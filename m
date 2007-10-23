Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbXJWP4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbXJWP4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXJWP40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:56:26 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44663 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbXJWP4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:56:25 -0400
Message-ID: <471E110C.20404@linux.vnet.ibm.com>
Date: Tue, 23 Oct 2007 20:49:40 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] 2.6.23-git18 Kernel oops in sg helpers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kernel oops is triggered while running fsx-linux test, followed by cpu softlock
over the AMD box

Unable to handle kernel NULL pointer dereference at 0000000000000018 RIP: 
 [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
PGD 10185b067 PUD 10075b067 PMD 0 
Oops: 0002 [1] SMP 
CPU 3 
Modules linked in:
Pid: 18676, comm: fsx-linux Not tainted 2.6.23-git18-autokern1 #1
RIP: 0010:[<ffffffff8021f2f6>]  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
RSP: 0000:ffff810181edf948  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: 0000000000000002 RDI: ffffffff80573dac
RBP: ffff81018ca9a020 R08: 0000000000000004 R09: ffff810181edf8d4
R10: 00000000000000db R11: ffffffff8041926c R12: ffff81018ca9a040
R13: 0000000000000003 R14: 0000000000000001 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff81018071e380(0063) knlGS:00000000f7f9a900
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000000000018 CR3: 0000000101281000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fsx-linux (pid: 18676, threadinfo ffff810181ede000, task ffff810181fc0720)
Stack:  0000000300000001 ffff810100000000 ffff81018ca9a040 0000000000000001
 0000000200000002 ffff81018ca9a000 ffff81010079d870 ffff810002903c40
 ffff810082692000 ffff810180712bd0 ffff810002903c70 0000000002000000
Call Trace:
 [<ffffffff803ecb6b>] scsi_dma_map+0x3f/0x4e
 [<ffffffff803fd3fd>] mptscsih_qcmd+0x1bc/0x4af
 [<ffffffff803e6b41>] scsi_dispatch_cmd+0x1e7/0x277
 [<ffffffff803ec0b8>] scsi_request_fn+0x2df/0x369
 [<ffffffff80350e4c>] cfq_insert_request+0x2a6/0x2ae
 [<ffffffff80346b91>] elv_insert+0xcf/0x18a
 [<ffffffff8034a3d6>] __make_request+0x550/0x58b
 [<ffffffff8034a62e>] generic_make_request+0x1bb/0x1f0
 [<ffffffff8034a737>] submit_bio+0xd4/0xdf
 [<ffffffff802a13f7>] dio_bio_submit+0x52/0x66
 [<ffffffff802a2107>] __blockdev_direct_IO+0x813/0xa1c
 [<ffffffff80260f14>] pagevec_lookup_tag+0x1a/0x21
 [<ffffffff802df355>] ext3_direct_IO+0x107/0x19e
 [<ffffffff802dfd8c>] ext3_get_block+0x0/0xe2
 [<ffffffff8025a7b7>] generic_file_direct_IO+0xcb/0x111
 [<ffffffff8025aebb>] generic_file_aio_read+0x86/0x160
 [<ffffffff8027e7a6>] do_sync_read+0xc8/0x10b
 [<ffffffff80298141>] __mark_inode_dirty+0x29/0x17d
 [<ffffffff80245f75>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80290ce3>] notify_change+0x255/0x26a
 [<ffffffff802813dd>] vfs_getattr+0x2b/0x2f
 [<ffffffff802814c5>] vfs_fstat+0x33/0x3a
 [<ffffffff8027e894>] vfs_read+0xab/0x12e
 [<ffffffff8027eb98>] sys_read+0x45/0x6e
 [<ffffffff80222922>] ia32_sysret+0x0/0xa
Code: c7 41 18 00 00 00 00 8b 44 24 20 e9 7b 01 00 00 e8 27 f8 ff 
RIP  [<ffffffff8021f2f6>] gart_map_sg+0x26c/0x406
 RSP <ffff810181edf948>
CR2: 0000000000000018
BUG: soft lockup - CPU#3 stuck for 11s! [swapper:0]
CPU 3:
Modules linked in:
Pid: 0, comm: swapper Tainted: G      D 2.6.23-git18-autokern1 #1
RIP: 0010:[<ffffffff8048b971>]  [<ffffffff8048b971>] _spin_lock_irqsave+0x15/0x24
RSP: 0000:ffff81000177fe98  EFLAGS: 00000286
RAX: 0000000000000282 RBX: ffff81018f6f0000 RCX: ffff81018f6f0068
RDX: ffff810082692800 RSI: 0000000000000001 RDI: ffff810082692850
RBP: ffff81000177fe10 R08: 0000000000000028 R09: 0000000000000086
R10: 0000000000000001 R11: 0000000000000028 R12: ffffffff8020c256
R13: 0000000000000001 R14: ffff810082692800 R15: 0000000000000028
FS:  0000000000000000(0000) GS:ffff81018071e380(0000) knlGS:00000000f7caf080
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000000810e708 CR3: 000000018195f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

Call Trace:
 <IRQ>  [<ffffffff803e8c5d>] scsi_eh_scmd_add+0x2c/0x9c
 [<ffffffff803e8dab>] scsi_times_out+0x0/0x87
 [<ffffffff803e8e19>] scsi_times_out+0x6e/0x87
 [<ffffffff8023bc46>] run_timer_softirq+0x14f/0x1a0
 [<ffffffff8022d6cf>] scheduler_tick+0xff/0x10b
 [<ffffffff802384e1>] __do_softirq+0x50/0xbb
 [<ffffffff8020c7ac>] call_softirq+0x1c/0x28
 [<ffffffff8020e54f>] do_softirq+0x2e/0x97
 [<ffffffff8021c684>] smp_apic_timer_interrupt+0x3e/0x51
 [<ffffffff802099ee>] default_idle+0x0/0x3d
 [<ffffffff8020c256>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff80209a17>] default_idle+0x29/0x3d
 [<ffffffff80209bc4>] cpu_idle+0x8b/0xae



-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

