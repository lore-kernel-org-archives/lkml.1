Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbXDZLMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbXDZLMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 07:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXDZLMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 07:12:32 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:53935 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbXDZLMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 07:12:30 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: linux-kernel@vger.kernel.org
Subject: [REPORT] cfs-v6-rc2 vs sd-0.46 vs 2.6.21-rc7
Date: Thu, 26 Apr 2007 13:12:12 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1313845.DrJE8TzGy8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704261312.25571.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1177585949;2aec6f78;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1313845.DrJE8TzGy8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi list,

find below a test comparing
    2.6.21-rc7 (mainline)
    2.6.21-rc7-sd046
    2.6.21-rc7-cfs-v6-rc2(*) (X @ nice 0)
    2.6.21-rc7-cfs-v6-rc2(*) (X @ nice -10)
running on a dualcore x86_64.

(*) At the time I started the tests, 2.6.21-rc7-cfs-v6 was not yet
available. I don't know whether the changes from -v6-rc2 would
have had an impact on the results.


The 3 tasks perform extensive computations on some data that is
initially loaded from disk. Each completed run (1711 per task in
total) in saved in a PostgreSQL DB running on the same machine

I do provide actual start and end timestamp of each task.
Each task is run via 'time'; those figures are provided as well.
Last not least the timevalues given from "within" the perl script
are provided by calling the perl builtin function "times" which
(hopefully) gives user time (among other things).

Note that both mainline and cfs did finish the jobs in the order
LTMM, LTMB, LTBM while sd had them finished in the order LTMM,
LTBM, LTMB. Also sd had the shortest time to have all three
finished while cfs was the first to finish LTMM (the fastest of
the three jobs).

I don't really know the reason for these differences:
LTMM, LTMB and LTBM all do similar things though there are differences.
LTMM is indeed the job that involves the least computations but I have
not yet tried to find out in what order of magnitude. I could if that
would be of interest though it would involve extensive analysis and
partly depends on the data processed and I'm not keen to do that.

I have not extensively checked how stable these figures are w/r to
repeated reruns as a single run takes roughly 3h, but I have repeated
one run and that produced basically the same timing.

One remark regarding cfs with X niced to -10 and 0:
I have not really seen much difference in terms of usage experience
between the two. If at all I have the impression that at nice -10
under KDE some apps (namely kontact and the helper it is using) have
a higher probability to actually "take over" the desktop but so far
this is just a vague impression (read: have not been able to reproduce).
On the other hand I have not seen degradations with nice 0 either and
thus my gut feeling prefers cfs nice 0. Thanks to the bootparam
privileged_nice_level=3D0 this is easy to achieve.

When comparing cfs nice 0 and sd I have not been able to see any
real difference w/r to desktop responsiveness. But then I have not
tried to stresstest the desktop while running the above benchmarks
either.

Anyway, here are the numbers. Feel free to ask whenever something
is unclear. GC2 is the name of the dataset processed.


2.6.21-rc7-cfs-v6-rc2 (X @ nice -10)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
/proc/sys/kernel/sched_granularity_ns=3D6000000

Start of all 3 jobs: 10:03:01.933

Job LTMM End: 12:25:57.214
GC2 20070101 LTMM Thu Apr 26 12:25:20.844 2007: 142.42 Min.,  4.9942 sec/ru=
n (1711 runs)
Ranking-3.pl fertig nach 5484.580s(CPU) und 8574 Sek.
times:                   bewerteUmgeb #        1 Su    0.79 ~  0.7900
times:                      evalMarkt #     1711 Su 5469.91 ~  3.1969
times:                        writeDB #     1711 Su    0.26 ~  0.0002
real	142m56.806s
user	91m24.871s
sys	0m13.257s


Job LTMB End: 12:57:14.624
GC2 20070101 LTMB Thu Apr 26 12:56:52.295 2007: 173.90 Min.,  6.0982 sec/ru=
n (1711 runs)
Ranking-3.pl fertig nach 7544.170s(CPU) und 10449 Sek.
times:                   bewerteUmgeb #        1 Su    1.37 ~  1.3700
times:                      evalMarkt #     1711 Su 7529.12 ~  4.4004
times:                        writeDB #     1711 Su    0.27 ~  0.0002
real	174m10.404s
user	125m44.484s
sys	0m15.293s


Job LTBM End: 12:59:47.879
GC2 20070101 LTBM Thu Apr 26 12:59:30.257 2007: 176.55 Min.,  6.1911 sec/ru=
n (1711 runs)
Ranking-3.pl fertig nach 7584.040s(CPU) und 10607 Sek.
times:                   bewerteUmgeb #        1 Su    0.82 ~  0.8200
times:                      evalMarkt #     1711 Su 7569.56 ~  4.4241
times:                        writeDB #     1711 Su    0.25 ~  0.0001
real	176m50.446s
user	126m24.490s
sys	0m15.689s


=46rom fairly early during the job:
top - 10:07:02 up  1:07,  9 users,  load average: 3.18, 1.83, 0.84
Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.3%us,  0.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.2%hi,  0.3%si,  0.0=
%st
Mem:   3348632k total,  1377624k used,  1971008k free,    51748k buffers
Swap:  2097144k total,        0k used,  2097144k free,   674288k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
13938 mgd       20   0 92780  17m 3668 R  100  0.5   2:31.04 perl
13937 mgd       20   0 93884  18m 3672 R   50  0.6   2:51.31 perl
13940 mgd       20   0 93864  18m 3668 R   50  0.6   2:28.69 perl


procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
=2D-
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 3  0      0 1954320  52516 688484    0    0     0    71  430  927 100  0  =
0  0
 4  0      0 1954412  52532 688496    0    0     0    49  433  942 100  0  =
0  0
 3  0      0 1954012  52556 688492    0    0     0   159  452 1203 100  0  =
0  0
 3  0      0 1953924  52584 688476    0    0     0   141  444  961 100  0  =
0  0
 3  0      0 1953964  52584 688512    0    0     0     0  470 1170 100  0  =
0  0
 3  0      0 1953980  52600 688516    0    0     0    83  490 1144 100  0  =
0  0
 3  0      0 1953948  52600 688524    0    0     0     0  503 1303 100  0  =
0  0
 3  0      0 1953852  52624 688524    0    0     0    97  503 1394 100  0  =
0  0
 4  0      0 1953852  52640 688512    0    0     0    96  496 1474 100  0  =
0  0
 3  0      0 1953332  52656 688524    0    0     3    93  487 1556 100  0  =
0  0
 5  0      0 1953272  52672 688536    0    0     0    65  494 1483 100  0  =
0  0
 3  0      0 1953264  52684 688548    0    0     0    39  486 1452 100  0  =
0  0
 3  0      0 1953216  52692 688576    0    0     3    44  436  983 100  0  =
0  0
 5  0      0 1953264  52708 688564    0    0     0    61  437  911 100  0  =
0  0
 3  0      0 1953264  52708 688580    0    0     0     0  420  896 100  0  =
0  0
 3  0      0 1953172  52732 688584    0    0     0    67  437  913 100  0  =
0  0
 5  0      0 1952948  52740 688584    0    0     0    73  466 1720 99  1  0=
  0
 3  0      0 1952996  52772 688572    0    0     1   109  470 1173 99  0  1=
  0
 3  0      0 1952996  52788 688580    0    0     0    47  479 1491 89 10  1=
  0
 3  0      0 1952996  52796 688588    0    0     0    19  464 1101 95  5  0=
  0
 3  0      0 1952964  52836 688584    0    0     0   179  461 1072 100  0  =
0  0



2.6.21-rc7-cfs-v6-rc2 (X @ nice 0)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
/proc/sys/kernel/sched_granularity_ns=3D6000000

Start of all 3 jobs: 15:13:57.802

Job LTMM End: 17:19:53.494
GC2 20070101 LTMM Wed Apr 25 17:19:18.802 2007: 125.45 Min.,  4.3992 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 5472.800s(CPU) and 7555 Sec.
times:                   bewerteUmgeb #        1 Su    0.79 ~  0.7900
times:                      evalMarkt #     1711 Su 5458.31 ~  3.1901
times:                        writeDB #     1711 Su    0.25 ~  0.0001
real	125m58.235s
user	91m13.034s
sys	0m15.925s


Job LTMB End: 18:04:45.556
GC2 20070101 LTMB Wed Apr 25 18:04:22.411 2007: 170.47 Min.,  5.9778 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 7646.700s(CPU) and 10243 Sec.
times:                   bewerteUmgeb #        1 Su    0.98 ~  0.9800
times:                      evalMarkt #     1711 Su 7632.08 ~  4.4606
times:                        writeDB #     1711 Su    0.19 ~  0.0001
real	170m48.445s
user	127m26.950s
sys	0m13.705s


Job LTBM End: 18:13:45.927
GC2 20070101 LTBM Wed Apr 25 18:13:27.382 2007: 179.57 Min.,  6.2969 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 7623.300s(CPU) and 10789 Sec.
times:                   bewerteUmgeb #        1 Su    0.85 ~  0.8500
times:                      evalMarkt #     1711 Su 7607.95 ~  4.4465
times:                        writeDB #     1711 Su    0.26 ~  0.0002
real	179m51.230s
user	127m3.580s
sys	0m10.769s


=46rom fairly early during the job:
top - 15:17:43 up 21 min,  9 users,  load average: 3.35, 2.58, 2.10
Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.8%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.2%si,  0.0=
%st
Mem:   3348632k total,  1624044k used,  1724588k free,    64272k buffers
Swap:  2097144k total,        0k used,  2097144k free,   940176k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
30042 mgd       20   0 92752  17m 3668 R  100  0.5   2:51.25 perl
30038 mgd       20   0 93884  18m 3668 R   50  0.6   1:59.39 perl
30040 mgd       20   0 93624  18m 3668 R   50  0.6   2:32.13 perl


procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
=2D-
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 4  0      0 1720424  65132 940632    0    0     0     1  424  963 100  0  =
0  0
 6  0      0 1720448  65152 940612    0    0     0    79  441 1030 100  0  =
0  0
 7  0      0 1720448  65152 940636    0    0     0    45  442 1003 100  0  =
0  0
 3  0      0 1720424  65168 940620    0    0     0    76  451 1130 100  0  =
0  0
 5  0      0 1720384  65168 940640    0    0     0     0  431  913 100  0  =
0  0
 3  0      0 1720880  65200 940644    0    0     0   105  455 1080 100  0  =
0  0
 3  0      0 1719936  65208 940656    0    0     0    87  442 1302 100  0  =
0  0
 3  0      0 1720060  65216 940660    0    0     0    81  438  973 100  0  =
0  0
 3  0      0 1720560  65244 940644    0    0     0    88  437  998 100  0  =
0  0
 3  0      0 1720548  65252 940664    0    0     0    59  435  955 100  0  =
0  0
 3  0      0 1720548  65260 940664    0    0     0    39  429  918 100  0  =
0  0
 3  0      0 1720572  65268 940688    0    0     3    33  434  935 100  0  =
0  0
 3  0      0 1720572  65276 940696    0    0     0    31  433  969 100  0  =
0  0
 3  0      0 1719928  65296 940700    0    0     0   155  453 1362 99  1  0=
  0
 3  0      0 1719944  65316 940680    0    0     0    69  436 1025 100  0  =
0  0
 4  0      0 1719772  65372 940712    0    0     1   277  460 1207 100  0  =
0  0
 3  0      0 1719756  65380 940704    0    0     0    44  441 1142 100  0  =
0  0
 3  0      0 1719756  65388 940720    0    0     0    47  436 1094 100  0  =
0  0
 3  0      0 1719780  65396 940736    0    0     3    35  439 1043 100  0  =
0  0
 3  0      0 1719400  65412 940736    0    0     0    87  616 1306 100  1  =
0  0
 3  0      0 1719400  65420 940736    0    0     0    51  440 1033 100  0  =
0  0



2.6.21-rc7-sd046
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
/proc/sys/kernel/rr_interval=3D16

Start of all 3 jobs: 11:39:54.650

Job LTMM End: 14:00:07.868
GC2 20070101 LTMM Wed Apr 25 13:59:32.209 2007: 139.73 Min.,  4.9001 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 5448.340s(CPU) and 8413 Sec.
times:                   bewerteUmgeb #        1 Su    0.38 ~  0.3800
times:                      evalMarkt #     1711 Su 5434.63 ~  3.1763
times:                        writeDB #     1711 Su    0.21 ~  0.0001
real	140m16.127s
user	90m48.597s
sys	0m12.389s


Job LTBM End: 14:32:40.408
GC2 20070101 LTBM Wed Apr 25 14:32:19.259 2007: 172.48 Min.,  6.0485 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 7555.780s(CPU) and 10365 Sec.
times:                   bewerteUmgeb #        1 Su    0.39 ~  0.3900
times:                      evalMarkt #     1711 Su 7541.47 ~  4.4076
times:                        writeDB #     1711 Su    0.18 ~  0.0001
real	172m48.009s
user	125m56.188s
sys	0m16.689s


Job LTMB End: 14:35:07.261
GC2 20070101 LTMB Wed Apr 25 14:34:50.896 2007: 175.02 Min.,  6.1373 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 7612.750s(CPU) and 10514 Sec.
times:                   bewerteUmgeb #        1 Su    0.33 ~  0.3300
times:                      evalMarkt #     1711 Su 7599.43 ~  4.4415
times:                        writeDB #     1711 Su    0.29 ~  0.0002
real	175m17.481s
user	126m53.160s
sys	0m16.437s


=46rom fairly early during the job:
top - 11:43:24 up  1:43,  9 users,  load average: 3.86, 2.35, 1.21
Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.5%us,  0.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.3%si,  0.0=
%st
Mem:   3348628k total,  3212640k used,   135988k free,   435744k buffers
Swap:  2097144k total,        0k used,  2097144k free,  1089812k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
17563 mgd       11   0 92872  17m 3668 R  100  0.5   2:43.97 perl
17568 mgd       33   0 93932  18m 3668 R   50  0.6   1:48.49 perl
17570 mgd       31   0 93652  18m 3668 R   50  0.6   2:14.16 perl


procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
=2D-
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 4  0      0 125052 436832 1093420    0    0     0    87  932 1464 99  1  0=
  0
 7  0      0 125060 436832 1093428    0    0     0     0  933 1306 99  1  0=
  0
 3  0      0 125256 436852 1093408    0    0     0   120  831 1336 99  1  0=
  0
 3  0      0 124804 436864 1093440    0    0     0   165  443 1374 99  1  0=
  0
 3  0      0 124804 436864 1093440    0    0     0     0  421  955 100  0  =
0  0
 4  0      0 124812 436884 1093440    0    0     0   113  440  989 100  0  =
0  0
 4  0      0 124812 436884 1093440    0    0     0    63  436  936 100  0  =
0  0
 3  0      0 124804 436900 1093448    0    0     0    64  485 1142 100  0  =
0  0
 3  0      0 124804 436912 1093436    0    0     0    47  434  992 100  0  =
0  0
 3  0      0 124804 436920 1093448    0    0     0    24  448  978 100  0  =
0  0
 3  0      0 124656 436932 1093448    0    0     0   120  443 1850 99  1  0=
  0
 3  0      0 124648 436932 1093464    0    0     0     0  441 1081 99  1  0=
  0
 8  0      0 124688 436952 1093464    0    0     0   156  432  924 100  0  =
0  0
 4  0      0 124976 436960 1093472    0    0     0    43  439 1028 100  0  =
0  0
 3  0      0 125100 436968 1093472    0    0     0    27  426  961 100  0  =
0  0
10  0      0 125132 436976 1093480    0    0     0    43  427  876 100  0  =
0  0
 6  0      0 125132 436984 1093480    0    0     0    28  440 1087 100  0  =
0  0
 3  0      0 124868 437000 1093484    0    0     0   133  445 1629 100  0  =
0  0
 3  0      0 124392 437056 1093456    0    0     0   356  483 1072 99  1  0=
  0
 3  0      0 124400 437056 1093496    0    0     0     0  429 1069 100  0  =
0  0
 3  0      0 124400 437072 1093488    0    0     0    80  441 1000 100  0  =
0  0



2.6.21-rc7
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Start of all 3 jobs: 20:11:45.971

Job LTMM End: 22:25:33.108
GC2 20070101 LTMM Wed Apr 25 22:25:07.427 2007: 133.45 Min.,  4.6797 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 5462.240s(CPU) and 8026 Sek.
times:                   bewerteUmgeb #        1 Su    0.77 ~  0.7700
times:                      evalMarkt #     1711 Su 5447.89 ~  3.1840
times:                        writeDB #     1711 Su    0.29 ~  0.0002
real	133m50.274s
user	91m2.485s
sys	0m10.801s


Job LTMB End: 23:01:54.763
GC2 20070101 LTMB Wed Apr 25 23:01:35.274 2007: 169.88 Min.,  5.9573 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 7452.300s(CPU) and 10208 Sek.
times:                   bewerteUmgeb #        1 Su    0.76 ~  0.7600
times:                      evalMarkt #     1711 Su 7438.33 ~  4.3474
times:                        writeDB #     1711 Su    0.25 ~  0.0001
real	170m12.885s
user	124m12.562s
sys	0m14.705s


Job LTBM End: 23:09:16.506
GC2 20070101 LTBM Wed Apr 25 23:08:59.376 2007: 177.28 Min.,  6.2168 sec/ru=
n (1711 runs)
Ranking-3.pl finished after 7673.940s(CPU) and 10652 Sek.
times:                   bewerteUmgeb #        1 Su    0.78 ~  0.7800
times:                      evalMarkt #     1711 Su 7659.10 ~  4.4764
times:                        writeDB #     1711 Su    0.30 ~  0.0002
real	177m35.890s
user	127m54.376s
sys	0m9.873s


=46rom fairly early during the job:
top - 20:15:13 up 12 min,  9 users,  load average: 3.89, 2.61, 1.52
Tasks:   3 total,   3 running,   0 sleeping,   0 stopped,   0 zombie
Cpu(s): 99.8%us,  0.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.2%si,  0.0=
%st
Mem:   3348628k total,  1109020k used,  2239608k free,    28820k buffers
Swap:  2097144k total,        0k used,  2097144k free,   511352k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6389 mgd       25   0 92776  17m 3668 R  100  0.5   2:50.23 perl
 6390 mgd       25   0 93932  18m 3668 R   53  0.6   2:08.47 perl
 6393 mgd       25   0 93880  18m 3668 R   47  0.6   1:42.53 perl


procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu--=
=2D-
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id =
wa
 6  0      0 2211984  30780 525612    0    0     0     0  490 1318 100  0  =
0  0
 4  0      0 2211460  30872 525576    0    0     8   795  489 1052 100  0  =
0  0
 3  0      0 2211736  30896 525620    0    0     0   129  467 1003 99  1  0=
  0
 7  0      0 2211024  30896 525624    0    0     0    97  469 1234 100  0  =
0  0
 4  0      0 2211080  30924 525624    0    0     0   147  472 1117 100  0  =
0  0
 4  0      0 2211008  30936 525616    0    0     0    35  467 1086 100  0  =
0  0
 5  0      0 2210792  30976 525632    0    0     0   144  480 1120 100  0  =
0  0
 5  0      0 2210932  30992 525620    0    0     0    47  462 1099 99  1  0=
  0
 3  0      0 2210948  31000 525644    0    0     0    40  460 1087 100  0  =
0  0
 4  0      0 2210980  31016 525648    0    0     0    41  453  898 100  0  =
0  0
 4  0      0 2210716  31036 525648    0    0     1    99  471 1322 100  0  =
0  0
 4  0      0 2210748  31052 525648    0    0     0    60  454 1085 100  0  =
0  0
 5  0      0 2210764  31080 525652    0    0     0    68  463 1007 100  0  =
0  0
 5  0      0 2210796  31080 525656    0    0     0    68  462  962 100  0  =
0  0
 5  0      0 2210812  31104 525664    0    0     0    97  470 1193 100  0  =
0  0
 5  0      0 2210812  31104 525664    0    0     0     0  451  911 100  0  =
0  0
 4  0      0 2210812  31128 525672    0    0     0    69  465 1100 100  0  =
0  0
 3  0      0 2210300  31152 525660    0    0     0   143  466 1350 99  1  0=
  0
 4  0      0 2210292  31152 525676    0    0     3     9  513 2025 100  0  =
0  0
 6  0      0 2210624  31196 525700    0    0     3   133  492 1207 100  0  =
0  0
 4  0      0 2210460  31196 525720    0    0     0     0  458 1086 100  0  =
0  0

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1313845.DrJE8TzGy8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGMIkZUYYhyuxDQc4RAuDxAJ9qqTOsrK5ewLNr6gif/aHo3vSmvQCfbexG
jLSIYl3GO+/lGDQl1TDOxWE=
=ew88
-----END PGP SIGNATURE-----

--nextPart1313845.DrJE8TzGy8--
