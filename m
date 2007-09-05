Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573AbXIENiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbXIENiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbXIENiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:38:13 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:41163 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755026AbXIENiM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:38:12 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [question] IPC queue filling-up problem?
Date: Wed, 5 Sep 2007 09:37:50 -0400
Message-ID: <F1D642E5A91BC94D9504EC83AE19E6B0128B86@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [question] IPC queue filling-up problem?
Thread-Index: AcfvwfQE0gZNHrFXTM6cN4FnxFkvRQ==
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Sep 2007 13:37:50.0917 (UTC) FILETIME=[F443F750:01C7EFC1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

We are testing new hardware and planning a switch from our old redhat
7.3 to a Debian Etch 4.0 for our radar forecast analysis systems.  We
found out that our main IPC dispatcher software module would use 100% of
a CPU all the time and that the IPC queues would fill up quickly on a
2.6 kernel.  We first tought that it would be a problem of compatibility
between a 2.4 vs 2.6 IPC calls vs our radar analysis software but after
a lot of work we have been able to test a 2.4 kernel on that same
hardware and got the exact same problem.

So curiously, on our actual systems (see SYSTEM 1 below) our IPC
dispatcher module works like a charm and queues gets near 0.  On our
test system which are way more powerfull systems (see SYSTEM 2) our IPC
dispatcher module queue fills up rapidly (depending of the msgmnb queue
size it will wimply take a bit longer to fill).

We have tested both our already compiled binaries from rh73 using gcc
2.9 and a recompiled version of the modules on a debian sarge system and
got the exact same problem on either a Debian Sarge 3.1 (running a 2.4
or 2.6 kernel) and on a Etch 64bit system (using 32bit compat layer)
with a 2.6 kernel.  In all cases the queues would simply fill-up.

After strac'ing the module I noticed that the time needed to handle the
signal & ipc calls are way lower on the new system hence I don't see why
the dispatcher queue does fill-up like that?!?!?!

Does anyone experienced something similar?  Could this be a kernel issue
vs material, kernel option?  Might this be related to libc?

Help / Clues very much appreciated.

Thnx

- vin


Debian Sarge 3.1 kernel 2.4.35 notes:
-------------------------------------
Pre-built 2.4.35.1 kernel + backported mpt fusion & megasas drivers for
Debian Sarge 3.1 available at:
http://linux-dev.qc.ec.gc.ca/kernel/debian/sarge/i386/2.4.35/
Megaraid SAS backport patch for a 2.4.35.1 kernel available at:
http://linux-dev.qc.ec.gc.ca/kernel/patches/megaraid_sas-linux_2.4.35.1-
v00.00.03.09.patch
2.4.35.1 config file:
http://linux-dev.qc.ec.gc.ca/kernel/debian/CONFIG-i686-2.4.35.1-008


RedHat 7.3 kernel 2.4.33 notes:
-------------------------------
Pre-built 2.4.33 kernel for RH73:
http://linux-dev.qc.ec.gc.ca/kernel/redhat/rh73/
2.4.33 config file:
http://linux-dev.qc.ec.gc.ca/kernel/redhat/rh73/config-2.4.33-01.rh73.en
vcanbigmem


SYSTEM INFORMATION:

SYSTEM 1:
---------
HPDL580 G2
Quad Intel Xeon 1.90GHz
4G ram
DRBD disks on dual-gigabit adapter
OS: RedHat 7.3 / kernel: 2.4.33 / libc: 2.2.5 / gcc 2.96

SYSTEM 2:
---------
Dell PE2950
Dual Intel Quad-Core 2.66GHz
16G ram
local 300G 15000 RPM SCSI.
OS1: Debian Etch 4.0 / kernels 2.6.18 -> 2.6.22 / libc 2.3.6 / gcc 4.1.2
OS2: Debian Sarge 3.1 / kernels 2.4.35, 2.6.18 -> 2.6.22 / libc 2.3.2 /
gcc 3.3.5



=============================
SYSTEM 1
=============================

top
---
 12:29pm  up 147 days, 15:47,  4 users,  load average: 3.00, 1.65, 1.56
229 processes: 227 sleeping, 2 running, 0 zombie, 0 stopped
CPU0 states: 48.0% user, 28.0% system,  0.0% nice, 23.0% idle
CPU1 states:  7.0% user,  3.0% system,  0.0% nice, 88.0% idle
CPU2 states: 71.0% user, 13.0% system,  0.0% nice, 15.0% idle
CPU3 states:  6.0% user,  7.0% system,  0.0% nice, 85.0% idle
CPU4 states: 35.0% user,  3.0% system,  0.0% nice, 60.0% idle
CPU5 states: 18.0% user,  3.0% system, 15.0% nice, 77.0% idle
CPU6 states: 11.0% user, 19.0% system,  0.0% nice, 68.0% idle
CPU7 states: 15.0% user,  9.0% system,  0.0% nice, 75.0% idle
Mem:  5952612K av, 5772232K used,  180380K free,       0K shrd,  145816K
buff
Swap: 2097112K av,    7560K used, 2089552K free                 4820588K
cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME COMMAND
29308 urp       14   5 10920  10M   496 S N  15.0  0.1   0:46
URPDispatcher


ipcs -q
-------
[root@localhost]$ ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages
0x41008050 1130594304 urp        660        0            0
0x370041d6 1132494849 urp        660        0            0
0x140041d8 1132396546 urp        660        0            0
0xfa0041d6 1133084675 urp        660        0            0
...


strace -ss -tt -T -v -e trace=ipc
---------------------------------
11:51:45.238031 msgsnd(1104543768, {1, ""...}, 91, IPC_NOWAIT) = 0
<0.000029>
11:51:45.260221 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 82
<0.000092>
11:51:45.280938 msgsnd(1103790090, {1, ""...}, 82, IPC_NOWAIT) = 0
<0.000034>
11:51:45.368730 msgsnd(1104543768, {1, ""...}, 82, IPC_NOWAIT) = 0
<0.023403>
11:51:45.414185 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 84
<0.000020>
11:51:45.483523 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 84
<0.000042>
11:51:45.543332 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 89
<0.000027>
11:51:45.578211 msgsnd(1104543768, {1, ""...}, 89, IPC_NOWAIT) = 0
<0.000057>
11:51:45.592104 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 91
<0.000032>
11:51:45.596233 msgsnd(1103790090, {1, ""...}, 91, IPC_NOWAIT) = 0
<0.000037>
11:51:45.660060 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 101
<0.000053>
11:51:45.717638 msgrcv(1100054529, {1, ""...}, 2565, 0, 0) = 89
<0.000045>


strace -ss -tt -T -v -e trace=signal
------------------------------------
07:11:27.150753 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000006>
07:11:27.434360 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000016>
07:11:27.717707 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000016>
07:11:28.001054 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000004>
07:11:28.286200 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000009>
07:11:28.569836 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000009>
07:11:28.853549 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000015>
07:11:29.143072 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000011>
07:11:29.436344 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000014>



=============================
SYSTEM 2
=============================

top
---

top - 07:26:58 up 18:18,  4 users,  load average: 7.06, 7.20, 7.48
Tasks: 134 total,   6 running, 128 sleeping,   0 stopped,   0 zombie
 Cpu0 :  16.6% user,   0.7% system,   0.0% nice,  82.7% idle
 Cpu1 : 100.0% user,   0.0% system,   0.0% nice,   0.0% idle
 Cpu2 : 100.0% user,   0.0% system,   0.0% nice,   0.0% idle
 Cpu3 :  61.8% user,   1.3% system,   0.0% nice,  36.9% idle
 Cpu4 : 100.0% user,   0.0% system,   0.0% nice,   0.0% idle
 Cpu5 :  54.8% user,   0.3% system,   0.0% nice,  44.9% idle
 Cpu6 :  13.3% user,   1.0% system,   0.0% nice,  85.7% idle
 Cpu7 : 100.0% user,   0.0% system,   0.0% nice,   0.0% idle
Mem:  16567608k total, 16530352k used,    37256k free,    35068k buffers
Swap:  2048276k total,        4k used,  2048272k free, 15368132k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 1963 urp       17   0 11308  11m  548 R 99.9  0.1  18:23.56
URPDispatcher


ipcs -q
-------
[root@localhost /root]# ipcs -q

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages
0x41018018 950272     urp        660        23732        276
0x41018024 983041     urp        660        0            0
0x4101800b 1015810    urp        660        0            0
0x41018011 1048579    urp        660        0            0
...


strace -ss -tt -T -v -e trace=ipc
---------------------------------
06:51:20.450471 msgsnd(557073, {1, ""...}, 78, IPC_NOWAIT) = 0
<0.000008>
06:51:20.538398 msgrcv(0, {1, ""...}, 2565, 0, 0) = 82 <0.000007>
06:51:20.569654 msgsnd(32769, {1, ""...}, 81, IPC_NOWAIT) = 0 <0.000007>
06:51:20.706519 msgsnd(360459, {1, ""...}, 81, IPC_NOWAIT) = 0
<0.000014>
06:51:20.832973 msgrcv(0, {1, ""...}, 2565, 0, 0) = 78 <0.000006>
06:51:21.032484 msgsnd(557073, {1, ""...}, 77, IPC_NOWAIT) = 0
<0.000009>
06:51:21.156817 msgrcv(0, {1, ""...}, 2565, 0, 0) = 79 <0.000007>
06:51:21.447914 msgrcv(0, {1, ""...}, 2565, 0, 0) = 78 <0.000009>
06:51:21.645212 msgsnd(557073, {1, ""...}, 77, IPC_NOWAIT) = 0
<0.000021>
06:51:21.730485 msgrcv(0, {1, ""...}, 2565, 0, 0) = 109 <0.000009>
06:51:22.028139 msgrcv(0, {1, ""...}, 2565, 0, 0) = 76 <0.000009>
06:51:22.229706 msgsnd(557073, {1, ""...}, 75, IPC_NOWAIT) = 0
<0.000013>
06:51:22.316948 msgrcv(0, {1, ""...}, 2565, 0, 0) = 79 <0.000012>
06:51:22.608471 msgrcv(0, {1, ""...}, 2565, 0, 0) = 79 <0.000009>


strace -ss -tt -T -v -e trace=signal
------------------------------------
06:59:01.979280 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.036669>
06:59:02.357971 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000012>
06:59:02.648930 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000009>
06:59:02.939051 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000011>
06:59:03.229976 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000009>
06:59:03.521447 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000012>
06:59:03.813863 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000014>
06:59:04.107771 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000010>
06:59:04.404351 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000005>
06:59:04.748842 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000014>
06:59:05.043842 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000006>
06:59:05.353598 rt_sigaction(SIGALRM, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, {0x804a888, [ALRM],
SA_RESTORER|SA_RESTART, 0x4006f678}, 8) = 0 <0.000013>

