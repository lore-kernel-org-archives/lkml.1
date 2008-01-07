Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYAGMOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYAGMOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbYAGMN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:13:56 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:48736 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997AbYAGMNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:13:54 -0500
Message-ID: <47821774.8010701@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2008 17:43:40 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Linux 2.6.24-rc7  kernel BUG at kernel/sched.c:5156!
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When booting the 2.6.24-rc7 kernel on the powerpc, kernel bug at
kernel.sched.c is triggered

[    0.000000] Kernel command line: ro console=hvc0 rhgb quiet root=LABEL=/ 
[    0.149567] BUG: scheduling while atomic: kthreadd/2/0x0006f34c
[    0.149655] BUG: scheduling while atomic: kthreadd/3/0xbe0d8168
[    0.149714] ------------[ cut here ]------------
[    0.149722] kernel BUG at kernel/sched.c:5156!
cpu 0x0: Vector: 700 (Program Check) at [c0000001be0dbd70]
    pc: c00000000006c090: .migration_thread+0x64/0x31c
    lr: c00000000008e348: .kthread+0x78/0xc4
    sp: c0000001be0dbff0
   msr: 8000000000029032
  current = 0xc0000000ee11ccc0
  paca    = 0xc000000000532d00
    pid   = 3, comm = kthreadd
kernel BUG at kernel/sched.c:5156!
enter ? for help
[c0000001be0dc0b0] c00000000008e348 .kthread+0x78/0xc4
[c0000001be0dc140] c00000000002a550 .kernel_thread+0x4c/0x68

0:mon> t
[c0000001be0dc0b0] c00000000008e348 .kthread+0x78/0xc4
[c0000001be0dc140] c00000000002a550 .kernel_thread+0x4c/0x68
0:mon> r
R00 = 0000000000000001   R16 = 4000000001c00000
R01 = c0000001be0dbff0   R17 = c000000000403920
R02 = c0000000006072f8   R18 = 0000000000000000
R03 = 0000000000000000   R19 = 000000000019b000
R04 = c0000000ee11ccc0   R20 = c0000000004c9550
R05 = 0000000000000000   R21 = 00000000020c9550
R06 = c000000000532d00   R22 = 00000000020c97c0
R07 = c0000001be0d81b0   R23 = c0000000004c97c0
R08 = 0000000000000000   R24 = 00000000018bf8d0
R09 = c0000000ee11ccbf   R25 = 0000000000000000
R10 = fffffffffffffffc   R26 = c0000000006a4968
R11 = c000000000532d00   R27 = c0000000006a00b0
R12 = c00000000002a550   R28 = c0000000ee143c98
R13 = c000000000532d00   R29 = c000000000f35b80
R14 = 0000000000000000   R30 = c0000000005b4190
R15 = c0000000004050a0   R31 = c0000000005cf910
pc  = c00000000006c090 .migration_thread+0x64/0x31c
lr  = c00000000008e348 .kthread+0x78/0xc4
msr = 8000000000029032   cr  = 28000024
ctr = c00000000006c02c   xer = 0000000020000004   trap =  700

(gdb) p kthread
$1 = {int (void *)} 0xc00000000008e2d0 <kthread>
(gdb) p/x 0xc00000000008e2d0+0x78
$2 = 0xc00000000008e348
(gdb) l *0xc00000000008e348
0xc00000000008e348 is in kthread (kernel/kthread.c:78).
73              __set_current_state(TASK_UNINTERRUPTIBLE);
74              complete(&create->started);
75              schedule();
76
77              if (!kthread_should_stop())
78                      ret = threadfn(data);
79
80              /* It might have exited on its own, w/o kthread_stop.  Check. */
81              if (kthread_should_stop()) {
82                      kthread_stop_info.err = ret;


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
