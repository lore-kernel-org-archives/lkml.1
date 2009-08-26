Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZHZTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZHZTwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZHZTwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:52:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54401 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZHZTwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:52:24 -0400
Message-ID: <4A959276.3080000@us.ibm.com>
Date: Wed, 26 Aug 2009 12:52:22 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "lkml, " <linux-kernel@vger.kernel.org>
Subject: trace-cmd memory corruption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

 From latest trace-cmd git as of today.  prio-wake is from the LTP 
realtime testsuite testcases/realtime/func/prio-wake.

$ sudo ~/bin/trace-cmd record -p sched_switch -d ./prio-wake
   plugin sched_switch
*** glibc detected *** /home/dvhart/bin/trace-cmd: malloc(): memory 
corruption: 0x00000000006cc0c0 ***
======= Backtrace: =========
/lib64/libc.so.6[0x7f80d34a14ac]
/lib64/libc.so.6(__libc_malloc+0x7a)[0x7f80d34a302a]
/home/dvhart/bin/trace-cmd[0x401893]
/home/dvhart/bin/trace-cmd[0x401af1]
/home/dvhart/bin/trace-cmd[0x401f11]
/home/dvhart/bin/trace-cmd[0x403b24]
/lib64/libc.so.6(__libc_start_main+0xf4)[0x7f80d344c974]
/home/dvhart/bin/trace-cmd[0x4014b9]
======= Memory map: ========
00400000-0040f000 r-xp 00000000 08:03 538635 
  /home/dvhart/bin/trace-cmd
0060e000-0060f000 rw-p 0000e000 08:03 538635 
  /home/dvhart/bin/trace-cmd
006cb000-006ec000 rw-p 00000000 00:00 0 
  [heap]
7f80cc000000-7f80cc021000 rw-p 00000000 00:00 0
7f80cc021000-7f80d0000000 ---p 00000000 00:00 0
7f80d3221000-7f80d322e000 r-xp 00000000 08:03 114522 
  /lib64/libgcc_s-4.1.2-20080825.so.1
7f80d322e000-7f80d342e000 ---p 0000d000 08:03 114522 
  /lib64/libgcc_s-4.1.2-20080825.so.1
7f80d342e000-7f80d342f000 rw-p 0000d000 08:03 114522 
  /lib64/libgcc_s-4.1.2-20080825.so.1
7f80d342f000-7f80d357b000 r-xp 00000000 08:03 114301 
  /lib64/libc-2.5.so
7f80d357b000-7f80d377b000 ---p 0014c000 08:03 114301 
  /lib64/libc-2.5.so
7f80d377b000-7f80d377f000 r--p 0014c000 08:03 114301 
  /lib64/libc-2.5.so
7f80d377f000-7f80d3780000 rw-p 00150000 08:03 114301 
  /lib64/libc-2.5.so
7f80d3780000-7f80d3785000 rw-p 00000000 00:00 0
7f80d3785000-7f80d37a1000 r-xp 00000000 08:03 114508 
  /lib64/ld-2.5.so
7f80d3987000-7f80d3989000 rw-p 00000000 00:00 0
7f80d399e000-7f80d39a0000 rw-p 00000000 00:00 0
7f80d39a0000-7f80d39a1000 r--p 0001b000 08:03 114508 
  /lib64/ld-2.5.so
7f80d39a1000-7f80d39a2000 rw-p 0001c000 08:03 114508 
  /lib64/ld-2.5.so
7fffcba0c000-7fffcba21000 rw-p 00000000 00:00 0 
  [stack]
7fffcba3c000-7fffcba3d000 r-xp 00000000 00:00 0 
  [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0 
  [vsyscall]
Aborted


If it's relevant:
$ cat /debug/tracing/available_tracers
syscall blk power function_graph wakeup_rt wakeup function sysprof 
sched_switch nop


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
