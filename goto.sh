#!/bin/sh

####Global Var
LOG_ALIAS=""
LOG_IN_IP=""
LOG_IN_PWD=""
LOG_IN_USER=""

##### pwd:complete-name:ip:user
##### alias:ip
SERVERS="
my_svr 127.0.0.1
"

function echo_err()
{
	echo "[ERROR] $1"
}

function echo_info()
{
	echo "[_INFO] $1"
}


function do_login()
{
	#echo_info "${LOG_IN_USER} go server ${LOG_IN_IP}"
	echo_info "go server ${LOG_IN_IP}"
	if [ -z "${LOG_IN_IP}" ] ; then
		echo_err "No login ip"
		exit 1	
	fi	

    content="echo -ne '\033]0;${LOG_IN_IP}\007'"
    command="export PROMPT_COMMAND=\"${content}\""
	ssh -p 32200 ${LOG_IN_IP}
}

function find_server()
{
	complete_name=$1;
	echo_info "Find server for ${complete_name}."
	for server in ${SERVERS}; do
#		echo_info $server;
		cn=`echo "${server}" | awk -F":" '{print $1}'`;
#		echo_info $cn;
		if [ "$cn" == "${complete_name}" ]; then
			#LOG_ALIAS="$cn";
			LOG_IN_IP=`echo "${server}" | awk -F":" '{print $2}'`;
			#LOG_IN_PWD=`echo "${server}" | awk -F":" '{print $1}'`;
			#LOG_IN_USER=`echo "${server}" | awk -F":" '{print $4}'`;
			break;
		fi
	done		
}

function do_complete()
{
	cc=""
	for server in ${SERVERS}; do
		cn=`echo "${server}" | awk -F":" '{print $1}'`;
		cc="${cc} ${cn}"
	done
	echo_info "Do complete -W \"${cc}\" goplus"
	complete -W "${cc}" goplus
}

function go_foo()
{
	if [ -z "$1" ]; then
#		echo_info "Init for go."
		return 0
	elif [ "$1" == "-c" ]; then
		# do complete
		echo "do complete"
		do_complete
	else
		### find server from parameter
		find_server $*; 
		### do login
		do_login ;
	fi	
}

do_complete
go_foo $*


