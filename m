Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbYBEISi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbYBEISi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYBEISb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:18:31 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:34510 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561AbYBEISa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:18:30 -0500
Message-ID: <47A81BC9.5060600@linux.vnet.ibm.com>
Date: Tue, 05 Feb 2008 13:48:17 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, tglx@linutronix.de,
       apw@shadowen.org, balbir@linux.vnet.ibm.com, randy.dunlap@oracle.com
Subject: [BUG] regression from 2.6.24-rc8-mm1 and 2.6.24-mm1 kernel panic
 while bootup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.24-mm1 kernel panics while bootup on the x86_64 (Dual Core AMD Opteron)
box. This was seen in 2.6.24-rc8-mm1 either (http://lkml.org/lkml/2008/1/17/129).

BUG: unable to handle kernel paging request at 0000000000004a78
IP: [<ffffffff8026c9e4>] __alloc_pages+0x47/0x337
PGD 0 
Oops: 0000 [1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-mm1-autotest #1
RIP: 0010:[<ffffffff8026c9e4>]  [<ffffffff8026c9e4>] __alloc_pages+0x47/0x337
RSP: 0000:ffff81003f9b9c20  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: 0000000000000010 RSI: 0000000000000605 RDI: ffffffff805bf425
RBP: ffff81003f9b9c80 R08: 00380800000000c0 R09: 000000000003db8d
R10: ffff81003f9b9d50 R11: 0000000000000001 R12: 00000000000000d0
R13: 0000000000004a70 R14: 0000000000000000 R15: 0000000000000286
FS:  0000000000000000(0000) GS:ffffffff8067f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000004a78 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff81003f9b8000, task ffff81003f9b6000)
Stack:  0000001000000002 ffff81000000fa78 ffff81003f9b6000 0000000000000000
 0000000000000303 ffffffff00000000 0000000400000000 0000000000000000
 0000000000000000 ffffffff80815c90 ffffffff80815c90 0000000000000286
Call Trace:
 [<ffffffff8028be79>] new_slab+0x117/0x26c
 [<ffffffff8028bfef>] get_new_slab+0x21/0xab
 [<ffffffff8028c194>] __slab_alloc+0x11b/0x175
 [<ffffffff805070b2>] process_zones+0x6c/0x152
 [<ffffffff8028c22c>] kmem_cache_alloc_node+0x3e/0x74
 [<ffffffff805070b2>] process_zones+0x6c/0x152
 [<ffffffff805071cc>] pageset_cpuup_callback+0x34/0x92
 [<ffffffff8050c520>] notifier_call_chain+0x33/0x65
 [<ffffffff80249fa5>] __raw_notifier_call_chain+0x9/0xb
 [<ffffffff80506cb4>] _cpu_up+0x6c/0x103
 [<ffffffff80506da2>] cpu_up+0x57/0x67
 [<ffffffff808be689>] kernel_init+0xc5/0x2fe
 [<ffffffff8020cd88>] child_rip+0xa/0x12
 [<ffffffff8036caa8>] acpi_ds_init_one_object+0x0/0x88
 [<ffffffff808be5c4>] kernel_init+0x0/0x2fe
 [<ffffffff8020cd7e>] child_rip+0x0/0x12


Code: 65 48 8b 04 25 00 00 00 00 83 e2 10 48 89 45 b0 89 55 a4 74 16 be 05 06 00 00 48 c7 c7 25 f4 5b 80 e8 1f e0 fb ff e8 e6 bd 29 00 <49> 83 7d 08 00 49 8d 45 08 48 89 45 b8 75 19 48 c7 45 a8 00 00 
RIP  [<ffffffff8026c9e4>] __alloc_pages+0x47/0x337
 RSP <ffff81003f9b9c20>
CR2: 0000000000004a78
---[ end trace 4eaa2a86a8e2da22 ]---
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
