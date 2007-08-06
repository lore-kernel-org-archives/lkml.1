Return-Path: <linux-kernel-owner+w=401wt.eu-S933481AbXHFNaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbXHFNaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932760AbXHFNUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:20:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:35353 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932755AbXHFNUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:20:33 -0400
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX183oc9ryqE3Uex297XaNEoq/Ctrh2IzSwjfg2gQjA
	Ue98jUQ3MtB5MN
Message-ID: <46B72E2E.5040906@gmx.net>
Date: Mon, 06 Aug 2007 16:20:30 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: high system cpu load during intense disk i/o
References: <200708031903.10063.jimis@gmx.net>	<200708051903.12414.jimis@gmx.net> <20070805182811.a8992126.akpm@linux-foundation.org>
In-Reply-To: <20070805182811.a8992126.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060004080700010708090404"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060004080700010708090404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Andrew, thanks for your reply!


Andrew Morton wrote:
> On Sun, 5 Aug 2007 19:03:12 +0300 Dimitrios Apostolou <jimis@gmx.net> wrote:
> 
>> was my report so complicated?
> 
> We're bad.
> 
> Seems that your context switch rate when running two instances of
> badblocks against two different disks went batshit insane.  It doesn't
> happen here.
> 
> Please capture the `vmstat 1' output while running the problematic
> workload.
> 
> The oom-killing could have been unrelated to the CPU load problem.  iirc
> badblocks uses a lot of memory, so it might have been genuine.  Keep an eye
> on the /proc/meminfo output and send the kernel dmesg output from the
> oom-killing event.

Please see the attached files. Unfortunately I don't see any useful info 
in them:
	*_before: before running any badblocks process
	*_while: while running badblocks process, but without any cron job 
having kicked in
	*_bad: 5 minutes later that some cron jobs kicked in

About the OOM killer, indeed I believe that it is unrelated. It started 
killing after about 2 days, that hundreds of processes were stuck as 
running and taking up memory, so I suppose the 256 MB RAM were truly 
filled. I just mentioned it because its behaviour is completely 
non-helpful. It doesn't touch the badblocks process, it rarely touches 
the stuck as running cron jobs, but it kills other irrelevant processes. 
If you still want the killing logs, tell me and I'll search for them.


Thanks,
Dimitris

--------------060004080700010708090404
Content-Type: text/plain;
 name="meminfo_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="meminfo_bad.txt"

MemTotal:       255912 kB
MemFree:         22928 kB
Buffers:        123420 kB
Cached:          69168 kB
SwapCached:          0 kB
Active:         118440 kB
Inactive:        86228 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       255912 kB
LowFree:         22928 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              76 kB
Writeback:           0 kB
AnonPages:       12088 kB
Mapped:           7608 kB
Slab:            23792 kB
SReclaimable:    18832 kB
SUnreclaim:       4960 kB
PageTables:        508 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    127956 kB
Committed_AS:    24928 kB
VmallocTotal:   770040 kB
VmallocUsed:      2852 kB
VmallocChunk:   766864 kB

--------------060004080700010708090404
Content-Type: text/plain;
 name="meminfo_before.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="meminfo_before.txt"

MemTotal:       255912 kB
MemFree:         26348 kB
Buffers:        123156 kB
Cached:          68412 kB
SwapCached:          0 kB
Active:         115788 kB
Inactive:        85484 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       255912 kB
LowFree:         26348 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:             436 kB
Writeback:           0 kB
AnonPages:        9704 kB
Mapped:           5748 kB
Slab:            23680 kB
SReclaimable:    18712 kB
SUnreclaim:       4968 kB
PageTables:        468 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    127956 kB
Committed_AS:    21260 kB
VmallocTotal:   770040 kB
VmallocUsed:      2852 kB
VmallocChunk:   766864 kB

--------------060004080700010708090404
Content-Type: text/plain;
 name="meminfo_while.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="meminfo_while.txt"

MemTotal:       255912 kB
MemFree:         25428 kB
Buffers:        123280 kB
Cached:          69088 kB
SwapCached:          0 kB
Active:         116216 kB
Inactive:        86068 kB
HighTotal:           0 kB
HighFree:            0 kB
LowTotal:       255912 kB
LowFree:         25428 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:              40 kB
Writeback:           0 kB
AnonPages:        9952 kB
Mapped:           5796 kB
Slab:            23708 kB
SReclaimable:    18764 kB
SUnreclaim:       4944 kB
PageTables:        480 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:    127956 kB
Committed_AS:    22060 kB
VmallocTotal:   770040 kB
VmallocUsed:      2852 kB
VmallocChunk:   766864 kB

--------------060004080700010708090404
Content-Type: text/plain;
 name="vmstat_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_bad.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 4  1      0  22688 123432  69172    0    0     7    78   45   21  3  0 96  1
 4  2      0  22680 123432  69180    0    0     0 15872  249  461 34 66  0  0
 4  2      0  22680 123432  69180    0    0     0 15872  247  468 37 63  0  0
 4  2      0  22680 123432  69180    0    0     0 15872  251  472 38 62  0  0
 4  2      0  22680 123432  69180    0    0     0 16000  252  495 43 57  0  0
 4  2      0  22680 123432  69180    0    0     0 15872  252  471 32 68  0  0
 3  2      0  22680 123440  69180    0    0     0 15984  251  516 73 27  0  0
 3  1      0  22680 123440  69180    0    0     0 15872  250  482 33 67  0  0
 4  2      0  22620 123440  69180    0    0     0 15872  251  467 30 70  0  0
 4  2      0  22620 123440  69180    0    0     0 15872  250  460 45 55  0  0

--------------060004080700010708090404
Content-Type: text/plain;
 name="vmstat_before.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_before.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0  26332 123196  68480    0    0     7    17   44   19  3  0 96  0
 0  0      0  26324 123196  68484    0    0     0     0   45   16  0  0 100  0
 0  0      0  26324 123196  68484    0    0     0     0   32   17  0  0 100  0
 0  0      0  26324 123196  68484    0    0     0     0   13   14  0  0 100  0
 0  0      0  26324 123196  68484    0    0     0     0   29   13  0  1 99  0
 0  0      0  26324 123196  68484    0    0     0     0   25   16  0  0 100  0
 0  0      0  26324 123204  68484    0    0     0    56   42   26  0  0 100  0
 0  0      0  26324 123204  68484    0    0     0     0   29   16  0  0 100  0
 0  0      0  26324 123204  68484    0    0     0     0   27   13  0  0 100  0
 0  0      0  26324 123204  68484    0    0     0     0   13   14  0  0 100  0

--------------060004080700010708090404
Content-Type: text/plain;
 name="vmstat_while.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmstat_while.txt"

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  2      0  25428 123288  69092    0    0     7    27   44   19  3  0 96  0
 2  2      0  25420 123288  69096    0    0     0 15744  273  421  0  7  0 93
 2  2      0  25420 123288  69096    0    0     0 15872  276  429  0  4  0 96
 2  2      0  25420 123288  69096    0    0     0 15872  273  394  0  2  0 98
 2  2      0  25420 123288  69096    0    0     0 15872  277  430  0  2  0 98
 1  2      0  25420 123288  69096    0    0     0 16000  273  496  2 10  0 88
 2  2      0  25360 123292  69096    0    0     0 15996  288  508  0  4  0 96
 2  2      0  25360 123292  69096    0    0     0 16000  283  487  0  3  0 97
 2  2      0  25360 123292  69096    0    0     0 15872  279  452  0  2  0 98
 2  2      0  25360 123292  69096    0    0     0 15872  283  442  0  2  0 98

--------------060004080700010708090404--
