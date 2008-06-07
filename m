Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYFGVX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYFGVX7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYFGVXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 17:23:49 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56537 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbYFGVXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 17:23:48 -0400
Message-ID: <484AFC5A.3070006@linux.vnet.ibm.com>
Date: Sun, 08 Jun 2008 02:53:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [mmotm]  __build_sched_domains panic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

I have an x86_64 system with 4 CPUs and 4GB memory and I see the following
panic, when I boot with fake NUMA nodes. I am still investigating the problem. I
was trying to use this setup to verify KAMEZAWA's fix for the memcgroup page
migration problem.


BUG: unable to handle kernel paging request at 0000007800000020
IP: [<ffffffff8029dd04>] ____cache_alloc_node+0x62/0x133
PGD 0
Oops: 0000 [1] SMP DEBUG_PAGEALLOC
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc5-mm1 #1
RIP: 0010:[<ffffffff8029dd04>]  [<ffffffff8029dd04>] ____cache_alloc_node+0x62/0x133
RSP: 0000:ffff8100bfdebd30  EFLAGS: 00010007
RAX: ffff81007fdea040 RBX: 0000007800000000 RCX: ffff81007fdea730
RDX: 0000000000000000 RSI: ffff81003fc5d858 RDI: ffff81007fdea040
RBP: ffff8100bfdebd60 R08: 0000000000000004 R09: ffff81003fc5d858
R10: ffff8100000be400 R11: ffff8100bfdeb8b0 R12: ffff81003fc5d800
R13: ffff81003fc40400 R14: 000000000000000b R15: ffff81003fc5d840
FS:  0000000000000000(0000) GS:ffffffff807d9a00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000007800000020 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8100bfdea000, task ffff81007fdea040)
Stack:  000000d00000003f ffff8100bfe19780 000000000000000b 0000000000000246
 ffff81003fc40400 00000000000000d0 ffff8100bfdebda0 ffffffff8029d813
 ffff810081c13ca0 ffff8100bfe19780 ffff8100bfdebdf8 0000000000000004
Call Trace:
 [<ffffffff8029d813>] kmem_cache_alloc_node+0xc6/0x10e
 [<ffffffff8022fbb4>] __build_sched_domains+0x51d/0x7bd
 [<ffffffff80254a6a>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff80230299>] arch_init_sched_domains+0x63/0x70
 [<ffffffff807fe908>] sched_init_smp+0x4c/0x107
 [<ffffffff807eb916>] kernel_init+0xf9/0x2be
 [<ffffffff80254a32>] ? trace_hardirqs_on_caller+0xf9/0x124
 [<ffffffff80254a6a>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff805a9ad7>] ? _spin_unlock_irq+0x2b/0x30
 [<ffffffff805a9305>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff80254a32>] ? trace_hardirqs_on_caller+0xf9/0x124
 [<ffffffff8020c158>] child_rip+0xa/0x12
 [<ffffffff8020b86f>] ? restore_args+0x0/0x30
 [<ffffffff807eb81d>] ? kernel_init+0x0/0x2be
 [<ffffffff8020c14e>] ? child_rip+0x0/0x12


Code: f4 b9 30 00 49 8b 1c 24 4c 39 e3 75 1e 48 8b 53 20 48 8d 43 20 c7 83 90 00
00 00 01 00 00 00 48 39 c2 0f 84 91 00 00 00 48 89 d3 <8b> 43 20 41 3b 85 18 01
00 00 75 04 0f 0b eb fe 44 89 f2 4c 89
RIP  [<ffffffff8029dd04>] ____cache_alloc_node+0x62/0x133
 RSP <ffff8100bfdebd30>
CR2: 0000007800000020



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
