if [ $# != 3 ]
then
    echo 'must specify client_thread, server thread num, pid'
    exit -1
fi

client_pthread_num=$1
server_pthread_num=$2
test_pid=$3

Flame_bin_path=${HOME}/FlameGraph
test_path=${HOME}/daos_flame
sub_path=${HOME}/daos_flame/${client_pthread_num}_${server_pthread_num}

if [ ! -d "${test_path}" ]
then
    mkdir "${test_path}"
elif [ ! -d "${sub_path}" ]
then
    mkdir ${sub_path}
else
    echo 'test and sub path exist'
fi

perf_file_path=${sub_path}/test.perf
folded_file_path=${sub_path}/test.folded
svg_file_path=${sub_path}/test.svg

sudo perf record -F 99 -g -p ${test_pid} -- sleep 40
sudo perf script > ${perf_file_path}
${Flame_bin_path}/stackcollapse-perf.pl ${perf_file_path} > ${folded_file_path}
${Flame_bin_path}/flamegraph.pl ${folded_file_path} > ${svg_file_path}

echo 'success'