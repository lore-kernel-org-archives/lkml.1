Return-Path: <linux-kernel-owner+w=401wt.eu-S965829AbXFGA1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbXFGA1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXFGA1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:27:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50130 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821AbXFGA1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:27:35 -0400
Subject: [BUG] sysrq-m oops
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Sripathi Kodi <sripathik@in.ibm.com>, Bernhard Walle <bwalle@suse.de>,
       "Eric W. Biederman <ebiederm"@xmission.com
Content-Type: text/plain
Date: Wed, 06 Jun 2007 17:27:15 -0700
Message-Id: <1181176035.6275.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey All,
	With 2.6.21 and the current -git, we're seeing the following oops when
we try sysrq-m:

...
Node 1 Normal: 85*4kB 34*8kB 20*16kB 4*32kB 3*64kB 0*128kB 1*256kB
0*512kB 1*1024kB 0*2048kB 953*4096kB =
3906020kB                                             
Swap cache: add 0, delete 0, find 0/0, race 0+0
Free swap  = 2040212kB
Total swap = 2040212kB
Unable to handle kernel paging request at 0000000003480000 RIP: 
 [<ffffffff8102a16d>] show_mem+0xdd/0x1e0
PGD 2052e9067 PUD 2052ea067 PMD 0 
Oops: 0000 [1] PREEMPT SMP 
CPU 3 
Pid: 0, comm: swapper Not tainted 2.6.22-rc3-git7john #6
RIP: 0010:[<ffffffff8102a16d>]  [<ffffffff8102a16d>] show_mem+0xdd/0x1e0
RSP: 0018:ffff810211f8bdf8  EFLAGS: 00010006
RAX: 0000000000780000 RBX: 00000000000f0000 RCX: 0000000003480000
RDX: 0000000003480000 RSI: ffff81000210a0f0 RDI: 0000000000112000
RBP: 00000000000f0000 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff810000012189
R13: 0000000000007179 R14: 0000000000000000 R15: 0000000000000000
FS:  00002ba3b8bdbf40(0000) GS:ffff810211f629c0(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000003480000 CR3: 00000002052e8000 CR4: 00000000000006e0
Process swapper (pid: 0, threadinfo ffff8101118be000, task
ffff810211f70080)
Stack:  0000000000000000 ffffffff81a90460 0000000000000001
000000000000006d
 ffff810110bf6000 0000000000000006 0000000000000002 ffffffff812e0046
 ffff81011584fbc0 ffffffff820cc590 0000000000000061 000000000000006d
Call Trace:
 <IRQ>  [<ffffffff812e0046>] __handle_sysrq+0x86/0x140
 [<ffffffff8134309c>] receive_chars+0x27c/0x300
 [<ffffffff8105a600>] hrtimer_wakeup+0x0/0x30
 [<ffffffff8105c857>] clocksource_get_next+0x47/0x60
 [<ffffffff813444d2>] serial8250_interrupt+0x142/0x160
 [<ffffffff81076c94>] handle_IRQ_event+0x34/0x70
 [<ffffffff8107838a>] handle_edge_irq+0xca/0x150
 [<ffffffff8100d6cd>] do_IRQ+0xbd/0x1b0
 [<ffffffff81008ef0>] default_idle+0x0/0x40
 [<ffffffff8100a971>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff816ab340>] unix_poll+0x0/0xb0
 [<ffffffff81008f19>] default_idle+0x29/0x40
 [<ffffffff81008f9f>] cpu_idle+0x6f/0xe0


Code: 8b 02 f6 c4 04 75 92 8b 02 66 85 c0 79 7a 48 83 c5 01 49 83 
RIP  [<ffffffff8102a16d>] show_mem+0xdd/0x1e0
 RSP <ffff810211f8bdf8>
CR2: 0000000003480000
Kernel panic - not syncing: Aiee, killing interrupt handler!



I'll keep digging but I wanted to see if anyone had any quick thoughts
or suggestions.

thanks
-john


