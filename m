Return-Path: <linux-kernel-owner+w=401wt.eu-S1758523AbYJNJRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523AbYJNJRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 05:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbYJNJRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 05:17:37 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:19601 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbYJNJRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 05:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bm2G/N+ZH9WR2lJTyKcKlcLHpLXDK2nsQjBgFhJ9i6zmGL30t2BeGRIZHBmMxcs5qy
         UdjRfmnEPJrc3TQS/To3vpSSP61w7S7LVWAM1Ql5Dhoh3UIhW6fLklDL75G7h1nxiP/x
         a8KykqFwdjYh/zHtxC1C/YDFSJs///zxLKxM0=
Message-ID: <2891419e0810140217l70f233bbr3b08760188458c35@mail.gmail.com>
Date: Tue, 14 Oct 2008 18:17:30 +0900
From: "Dong-Jae Kang" <baramsori72@gmail.com>
To: "Andrea Righi" <righi.andrea@gmail.com>
Subject: Re: [PATCH -mm 0/6] cgroup: block device i/o controller (v11)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Paul Menage" <menage@google.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk,
       "Carl Henrik Lunde" <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       "Divyesh Shah" <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, "Hirokazu Takahashi" <taka@valinux.co.jp>,
       "Li Zefan" <lizf@cn.fujitsu.com>,
       "Marco Innocenti" <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       "Ryo Tsuruta" <ryov@valinux.co.jp>,
       "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1223373818-13687-1-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <> <1223373818-13687-1-git-send-email-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9E9Hvdq020122

Hi, Andrea
thank you for your contribution to communitythese days, I am testing several IO controllers in container ML,dm-ioband by Ryo tsuruta(v1.7.0), 2-Layer CFQ by Satoshi and yourio-throttle(v11)
I have several question about io-throttlebelow is my test reusult of io-throttle(v11) with xdd 6.5But, I think I have something wrong, as showed in resultIn direct IO mode, Only read operation was controlled by io-throttleCan you check my  test procedure and result and comments to me about that
additionally, your testing shell script(run_io_throttle_test.sh) forio-throttle was not updated for new io-throttleso, it could be operated after I fixed it
------------------------------------------------------------------------------------ Test System Information
Computer Name, localhost.localdomain, User Name, rootOS release and version, Linux 2.6.27-rc5-mm1 #1 SMP Thu Oct 9 18:27:09 KST 2008Machine hardware type, i686Number of processors on this system, 1Page size in bytes, 4096Number of physical pages, 515885Megabytes of physical memory, 2015Target[0] Q[0], /dev/sdbPer-pass time limit in seconds, 30Blocksize in bytes, 512Request size, 128, blocks, 65536, bytesNumber of Requests, 16384Number of MegaBytes, 512 or 1024Direct I/O, disabled or enableSeek pattern, sequentialQueue Depth, 1
- Test Procedure
ÔÅ¨	mkdir /dev/blockioctlÔÅ¨	mount -t cgroup -o blockio cgroup /dev/blockioctlÔÅ¨	mkdir /dev/blockioctl/cgroup-1ÔÅ¨	mkdir /dev/blockioctl/cgroup-2ÔÅ¨	mkdir /dev/blockioctl/cgroup-3ÔÅ¨	echo /dev/sdb:$((1024*1024)):0:0 >/dev/blockioctl/cgroup-1/blockio.bandwidth-maxÔÅ¨	echo /dev/sdb:$((2*1024*1024)):0:0 >/dev/blockioctl/cgroup-2/blockio.bandwidth-maxÔÅ¨	echo /dev/sdb:$((3*1024*1024)):0:0 >/dev/blockioctl/cgroup-3/blockio.bandwidth-maxÔÅ¨	in terminal 1, echo $$ > /dev/blockioctl/cgroup-1/tasksÔÅ¨	in terminal 2, echo $$ > /dev/blockioctl/cgroup-2/tasksÔÅ¨	in terminal 3, echo $$ > /dev/blockioctl/cgroup-3/tasksÔÅ¨	in each terminal, xdd.linux -op write( or read ) -targets 1 /dev/sdb-blocksize 512 -reqsize 128 -mbytes 1024( or 512 )  -timelimit 30-verbose ‚Äìdio(enable or disable)
- setting status information
[root@localhost blockioctl]# cat ./cgroup-1/blockio.bandwidth-max8 16 1048576 0 0 0 13016[root@localhost blockioctl]# cat ./cgroup-2/blockio.bandwidth-max8 16 2097152 0 0 0 11763[root@localhost blockioctl]# cat ./cgroup-3/blockio.bandwidth-max8 16 3145728 0 0 0 11133
- Test Resultxdd.linux -op read -targets 1 /dev/sdb -blocksize 512 -reqsize 128-mbytes 512 -timelimit 30 -dio -verbose
cgroup-1
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1      31522816      481    30.005     1.051      16.03    0.0624  0.00   read       655360  1      31522816      481    30.005     1.051      16.03    0.0624  0.00   read       655361  1      31522816      481    30.005     1.051      16.03    0.0624  0.00   read       65536
cgroup-2
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1      62980096      961    30.001     2.099      32.03    0.0312  0.00   read       655360  1      62980096      961    30.001     2.099      32.03    0.0312  0.00   read       655361  1      62980096      961    30.001     2.099      32.03    0.0312  0.00   read       65536
cgroup-3
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1      94437376     1441    30.003     3.148      48.03    0.0208  0.00   read       655360  1      94437376     1441    30.003     3.148      48.03    0.0208  0.00   read       655361  1      94437376     1441    30.003     3.148      48.03    0.0208  0.00   read       65536
xdd.linux -op write -targets 1 /dev/sdb -blocksize 512 -reqsize 128-mbytes 512 -timelimit 30 -dio ‚Äìverbose
cgroup-1
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1     640221184     9769    30.097    21.272     324.58    0.0031  0.00   write       655360  1     640221184     9769    30.097    21.272     324.58    0.0031  0.00   write       655361  1     640221184     9769    30.097    21.272     324.58    0.0031  0.00   write       65536
cgroup-2
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1     633798656     9671    30.001    21.126     322.36    0.0031  0.00   write       655360  1     633798656     9671    30.001    21.126     322.36    0.0031  0.00   write       655361  1     633798656     9671    30.001    21.126     322.36    0.0031  0.00   write       65536
cgroup-3
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1     630652928     9623    30.001    21.021     320.76    0.0031  0.00   write       655360  1     630652928     9623    30.001    21.021     320.76    0.0031  0.00   write       655361  1     630652928     9623    30.001    21.021     320.76    0.0031  0.00   write       65536
xdd.linux -op read -targets 1 /dev/sdb -blocksize 512 -reqsize 128-mbytes 1024  -timelimit 30  -verbose
cgroup-1
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1      70123520     1070    30.150     2.326      35.49    0.0282  0.00   read       655360  1      70123520     1070    30.150     2.326      35.49    0.0282  0.00   read       655361  1      70123520     1070    30.150     2.326      35.49    0.0282  0.00   read       65536
cgroup-2
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1      70844416     1081    30.063     2.357      35.96    0.0278  0.00   read       655360  1      70844416     1081    30.063     2.357      35.96    0.0278  0.00   read       655361  1      70844416     1081    30.063     2.357      35.96    0.0278  0.00   read       65536
cgroup-3
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1      72155136     1101    30.204     2.389      36.45    0.0274  0.00   read       655360  1      72155136     1101    30.204     2.389      36.45    0.0274  0.00   read       655361  1      72155136     1101    30.204     2.389      36.45    0.0274  0.00   read       65536
xdd.linux -op write -targets 1 /dev/sdb -blocksize 512 -reqsize 128-mbytes 1024  -timelimit 30  -verbose
cgroup-1
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1     818610176    12491    30.031    27.258     415.93    0.0024  0.00   write       655360  1     818610176    12491    30.031    27.258     415.93    0.0024  0.00   write       655361  1     818610176    12491    30.031    27.258     415.93    0.0024  0.00   write       65536
cgroup-2
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1     848494592    12947    30.066    28.221     430.62    0.0023  0.00   write       655360  1     848494592    12947    30.066    28.221     430.62    0.0023  0.00   write       655361  1     848494592    12947    30.066    28.221     430.62    0.0023  0.00   write       65536
cgroup-3
T  Q       Bytes      Ops    Time      Rate      IOPS   Latency%CPU  OP_Type    ReqSize0  1     786563072    12002    30.078    26.151     399.03    0.0025  0.00   write       655360  1     786563072    12002    30.078    26.151     399.03    0.0025  0.00   write       655361  1     786563072    12002    30.078    26.151     399.03    0.0025  0.00   write       65536
Best Regards,Dong-Jae Kang

2008/10/7 Andrea Righi <righi.andrea@gmail.com>:>> The objective of the i/o controller is to improve i/o performance> predictability of different cgroups sharing the same block devices.>> Respect to other priority/weight-based solutions the approach used by this> controller is to explicitly choke applications' requests that directly (or> indirectly) generate i/o activity in the system.>> The direct bandwidth and/or iops limiting method has the advantage of improving> the performance predictability at the cost of reducing, in general, the overall> performance of the system (in terms of throughput).>> Detailed informations about design, its goal and usage are described in the> documentation.>> Patchset against 2.6.27-rc5-mm1:>>  [PATCH 0/6] cgroup: block device i/o controller (v11)>  [PATCH 1/6] i/o controller documentation>  [PATCH 2/6] introduce ratelimiting attributes and functionality to res_counter>  [PATCH 3/6] i/o controller infrastructure>  [PATCH 4/6] memcg: interface to charge the right cgroup of asynchronous i/o activity>  [PATCH 5/6] i/o controller instrumentation: accounting and throttling>  [PATCH 6/6] export per-task i/o throttling statistics to userspace>> The all-in-one patch (and previous versions) can be found at:> http://download.systemimager.org/~arighi/linux/patches/io-throttle/>> There are no significant changes respect to v10, I've only implemented/fixed> some suggestions I received.>> Changelog: (v10 -> v11)>> * report per block device i/o statistics (total bytes read/written and iops)>  in blockio.stat for i/o limited cgroups> * distinct bandwidth and iops statistics: both in blockio.throttlecnt and>  /proc/PID/io-throttle-stat (suggested by David Radford)> * merge res_counter_ratelimit functionality into res_counter, to avoid code>  duplication (suggested by Paul Manage)> * use kernel-doc style for documenting struct res_counter attributes>  (suggested by Randy Dunalp)> * udpated documentation>> Thanks to all for the feedback!> -Andrea>ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
