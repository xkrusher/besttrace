#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font="\033[32m" && Red_font="\033[31m" && Font_suffix="\033[0m"
Info="${Green_font}[Info]${Font_suffix}"
Error="${Red_font}[Error]${Font_suffix}"
echo -e "${Green_font}
#======================================
# Project: VPS回程路由测试
#======================================
${Font_suffix}"

check_system(){
	if   [[ ! -z "`cat /etc/issue | grep -iE "debian"`" ]]; then
		apt-get install traceroute unzip mtr -y
	elif [[ ! -z "`cat /etc/issue | grep -iE "ubuntu"`" ]]; then
		apt-get install traceroute unzip mtr -y
	elif [[ ! -z "`cat /etc/redhat-release | grep -iE "CentOS"`" ]]; then
		yum install traceroute unzip mtr -y
	else
		echo -e "${Error} system not support!" && exit 1
	fi
}
check_root(){
	[[ "`id -u`" != "0" ]] && echo -e "${Error} must be root user !" && exit 1
}
directory(){
	[[ ! -d /home/testrace ]] && mkdir -p /home/testrace
	cd /home/testrace
}
install(){
	[[ ! -d /home/testrace/besttrace ]] && wget https://github.com/xkrusher/besttrace/releases/download/latest/besttrace4linux.zip && unzip -qo *zip -d ./besttrace && rm *zip
	[[ ! -d /home/testrace/besttrace ]] && echo -e "${Error} download failed, please check!" && exit 1
	chmod -R +x /home/testrace
}

test_single(){
	echo -e "${Info} 请输入你要测试的目标 ip :"
	read -p "输入 ip 地址:" ip

	while [[ -z "${ip}" ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "输入 ip 地址:" ip
		done

	./besttrace -q 1 ${ip} | tee -a -i /home/testrace/testrace.log 2>/dev/null


	repeat_test_single
}
repeat_test_single(){
	echo -e "${Info} 是否继续测试其他目标 ip ?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_single
	while [[ ! "${whether_repeat_single}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_single
		done
	[[ "${whether_repeat_single}" == "1" ]] && test_single
	[[ "${whether_repeat_single}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}


test_alternative(){
	select_alternative
	set_alternative
	result_alternative
}
select_alternative(){
	echo -e "${Info} 选择需要测速的目标网络: \n1.中国电信\n2.中国联通\n3.中国移动\n4.教育网"
	read -p "输入数字以选择:" ISP

	while [[ ! "${ISP}" =~ ^[1-4]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" ISP
		done
}
set_alternative(){
	[[ "${ISP}" == "1" ]] && node_1
	[[ "${ISP}" == "2" ]] && node_2
	[[ "${ISP}" == "3" ]] && node_3
	[[ "${ISP}" == "4" ]] && node_4
}
node_1(){
	echo -e "\n1.北京电信\n2.上海电信\n3.广州电信\n4.成都电信\n5.贵阳电信\n6.昆明电信" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="北京电信" && ip=219.141.136.10
	[[ "${node}" == "2" ]] && ISP_name="上海电信" && ip=202.96.209.5
	[[ "${node}" == "3" ]] && ISP_name="广州电信" && ip=14.215.116.1
	[[ "${node}" == "4" ]] && ISP_name="成都电信" && ip=61.188.6.210
	[[ "${node}" == "5" ]] && ISP_name="贵阳电信" && ip=202.98.192.68
	[[ "${node}" == "6" ]] && ISP_name="昆明电信" && ip=222.221.4.148
}
node_2(){
	echo -e "\n1.北京联通\n2.上海联通\n3.广州联通\n4.成都联通\n5.贵阳联通\n6.昆明联通" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="北京联通" && ip=202.106.196.115
	[[ "${node}" == "2" ]] && ISP_name="上海联通" && ip=210.22.70.3
	[[ "${node}" == "3" ]] && ISP_name="广州联通" && ip=210.21.4.130
	[[ "${node}" == "4" ]] && ISP_name="成都联通" && ip=119.6.6.6
	[[ "${node}" == "5" ]] && ISP_name="贵阳联通" && ip=211.92.136.81
	[[ "${node}" == "6" ]] && ISP_name="昆明联通" && ip=221.3.136.39
}
node_3(){
	echo -e "\n1.北京移动\n2.上海移动\n3.广州移动\n4.成都移动\n5.贵州移动\n6.昆明移动" && read -p "输入数字以选择:" node

	while [[ ! "${node}" =~ ^[1-6]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" node
		done

	[[ "${node}" == "1" ]] && ISP_name="北京移动" && ip=211.136.28.228
	[[ "${node}" == "2" ]] && ISP_name="上海移动" && ip=221.130.188.251
	[[ "${node}" == "3" ]] && ISP_name="广州移动" && ip=211.136.192.6
	[[ "${node}" == "4" ]] && ISP_name="成都移动" && ip=183.221.253.66
	[[ "${node}" == "5" ]] && ISP_name="贵州移动" && ip=211.139.1.3
	[[ "${node}" == "6" ]] && ISP_name="昆明移动" && ip=183.224.24.241
}
node_4(){
	ISP_name="北京教育网" && ip=219.224.102.230
}
result_alternative(){
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./besttrace -q 1 ${ip} | tee -a -i /home/testrace/testrace.log 2>/dev/null
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"

	repeat_test_alternative
}
repeat_test_alternative(){
	echo -e "${Info} 是否继续测试其他节点?"
	echo -e "1.是\n2.否"
	read -p "请选择:" whether_repeat_alternative
	while [[ ! "${whether_repeat_alternative}" =~ ^[1-2]$ ]]
		do
			echo -e "${Error} 无效输入"
			echo -e "${Info} 请重新输入" && read -p "请选择:" whether_repeat_alternative
		done
	[[ "${whether_repeat_alternative}" == "1" ]] && test_alternative
	[[ "${whether_repeat_alternative}" == "2" ]] && echo -e "${Info} 退出脚本 ..." && exit 0
}

test_all(){
	result_all	'202.96.209.5'  	'上海电信'
	result_all	'61.188.6.210'		'成都电信'
	result_all	'202.106.196.115'	'北京联通'
	result_all	'119.6.6.6'		'成都联通'
	result_all	'211.136.192.6'		'广州移动'
	result_all	'183.221.253.66'	'成都移动'
	result_all	'219.224.102.230'	'北京教育网'
	echo -e "${Info} 四网路由快速测试 已完成 ！"
}
result_all(){
	ISP_name=$2
	echo -e "${Info} 测试路由 到 ${ISP_name} 中 ..."
	./besttrace -q 1 $1
	echo -e "${Info} 测试路由 到 ${ISP_name} 完成 ！"
}
test_all(){
	result_all	'202.96.209.5'  	'上海电信'
	result_all	'61.188.6.210'		'成都电信'
	result_all	'202.106.196.115'	'北京联通'	
	result_all	'119.6.6.6'		'成都联通'
	result_all	'211.136.192.6'		'广州移动'	
	result_all	'183.221.253.66'	'成都移动'
	result_all	'219.224.102.230'	'北京教育网'
	echo -e "${Info} 四网路由快速测试 已完成 ！"
}

check_system
check_root
directory
install
cd besttrace

echo -e "${Info} 选择你要使用的功能: "
echo -e "1.选择一个运营商进行测试\n2.四网路由快速测试\n3.手动输入ip进行测试"
read -p "输入数字以选择:" function

	while [[ ! "${function}" =~ ^[1-3]$ ]]
		do
			echo -e "${Error} 缺少或无效输入"
			echo -e "${Info} 请重新选择" && read -p "输入数字以选择:" function
		done

	if [[ "${function}" == "1" ]]; then
		test_alternative
	elif [[ "${function}" == "2" ]]; then
		test_all | tee -a -i /home/testrace/testrace.log 2>/dev/null
	else
		test_single
	fi
