Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbYENLZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbYENLZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758392AbYENLZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:25:06 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:36894 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYENLZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:25:04 -0400
Message-ID: <482ACBFE.9010606@linux.vnet.ibm.com>
Date: Wed, 14 May 2008 16:54:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [BUG] 2.6.26-rc2-mm1 - kernel bug while bootup at __alloc_pages_internal
 () on x86_64
References: <20080514010129.4f672378.akpm@linux-foundation.org>
In-Reply-To: <20080514010129.4f672378.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The 2.6.26-rc2-mm1 kernel panic's while bootup on the x86_64 machine.


BUG: unable to handle kernel paging request at 0000000000001e08
IP: [<ffffffff8026ac60>] __alloc_pages_internal+0x80/0x470
PGD 0 
Oops: 0000 [1] SMP 
last sysfs file: 
CPU 31 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.26-rc2-mm1-autotest #1
RIP: 0010:[<ffffffff8026ac60>]  [<ffffffff8026ac60>] __alloc_pages_internal+0x80/0x470
RSP: 0018:ffff810bf9dbdbc0  EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff810bef4786c0 RCX: 0000000000000001
RDX: 0000000000001e00 RSI: 0000000000000001 RDI: 0000000000001020
RBP: ffff810bf9dbb6d0 R08: 0000000000001020 R09: 0000000000000000
R10: 0000000000000008 R11: ffffffff8046d130 R12: 0000000000001020
R13: 0000000000000001 R14: 0000000000001e00 R15: ffff810bf8d29878
FS:  0000000000000000(0000) GS:ffff810bf916dec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000001e08 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff810bf9dbc000, task ffff810bf9dbb6d0)
Stack:  0002102000000000 0000000000000002 0000000000000000 0000000200000000
 0000000000000000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 ffff810bef4786c0 0000000000001020 ffffffffffffffff
Call Trace:
 [<ffffffff802112e9>] dma_alloc_coherent+0xa9/0x280
 [<ffffffff804e8c9e>] tg3_init_one+0xa3e/0x15e0
 [<ffffffff8028d0e4>] alternate_node_alloc+0x84/0xd0
 [<ffffffff802286fc>] task_rq_lock+0x4c/0x90
 [<ffffffff8022de62>] set_cpus_allowed_ptr+0x72/0xf0
 [<ffffffff802e12fb>] sysfs_addrm_finish+0x1b/0x210
 [<ffffffff802e0f99>] sysfs_find_dirent+0x29/0x40
 [<ffffffff8036cc34>] pci_device_probe+0xe4/0x130
 [<ffffffff803bfc26>] driver_probe_device+0x96/0x1a0
 [<ffffffff803bfdb9>] __driver_attach+0x89/0x90
 [<ffffffff803bfd30>] __driver_attach+0x0/0x90
 [<ffffffff803bf29d>] bus_for_each_dev+0x4d/0x80
 [<ffffffff8028d676>] kmem_cache_alloc+0x116/0x130
 [<ffffffff803bf78e>] bus_add_driver+0xae/0x220
 [<ffffffff803c0046>] driver_register+0x56/0x130
 [<ffffffff8036cee8>] __pci_register_driver+0x68/0xb0
 [<ffffffff80708a29>] kernel_init+0x139/0x390
 [<ffffffff8020c358>] child_rip+0xa/0x12
 [<ffffffff807088f0>] kernel_init+0x0/0x390
 [<ffffffff8020c34e>] child_rip+0x0/0x12


Code: c9 00 00 02 00 25 00 08 00 00 89 4c 24 04 89 04 24 44 89 e9 b8 01 00 00 00 d3 e0 48 98 48 89 44 24 08 65 48 8b 2c 25 00 00 00 00 <49> 83 7e 08 00 0f 84 9a 03 00 00 44 8b 44 24 1c 48 8b 74 24 10 
RIP  [<ffffffff8026ac60>] __alloc_pages_internal+0x80/0x470
 RSP <ffff810bf9dbdbc0>
CR2: 0000000000001e08
---[ end trace 111493bba2b1f3db ]---

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
