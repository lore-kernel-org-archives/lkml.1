Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbXLTU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbXLTU6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbXLTU5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:57:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbXLTU5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:57:51 -0500
Date: Thu, 20 Dec 2007 15:57:45 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc5-mm1 - SCSI/blkdev probing hang
Message-ID: <20071220155745.1f079a3b@bree.surriel.com>
In-Reply-To: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 02:40:50 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 

2.6.24-rc5-mm1 seems to have a hang related to the SCSI or block
device probing code.

This is on a dual quad-core x86-64 system with megaraid_sas controller.

scsi 0:2:0:0: Direct-Access     DELL     PERC 5/i         1.03 PQ: 0 ANSI: 5
general protection fault: 0000 [1] SMP 
last sysfs file: /sys/class/firmware/timeout
CPU 7 
Modules linked in: ata_piix libata dm_snapshot dm_zero dm_mirror dm_mod shpchp megaraid_sas sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 678, comm: scsi_scan_0 Not tainted 2.6.24-rc5-mm1 #1
RIP: 0010:[<ffffffff81058183>]  [<ffffffff81058183>] mark_lock+0x1b/0x472
RSP: 0018:ffff81043ba29c20  EFLAGS: 00010002
RAX: 0000000000000010 RBX: ffff81043b9ee8f0 RCX: ffff81043b9ee804
RDX: 6b6b6b6b6b6b6b6b RSI: ffff81043b9ee8f0 RDI: ffff81043b9ee000
RBP: ffff81043b9ee000 R08: 0000000000000002 R09: 0000000000000000
R10: ffffffff81129055 R11: 0000000281128c8d R12: 0000000000000004
R13: 0000000000000001 R14: 0000000000000002 R15: ffff81043e508028
FS:  0000000000000000(0000) GS:ffff81043e4e6a28(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 000000361969afa0 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scsi_scan_0 (pid: 678, threadinfo ffff81043ba28000, task ffff81043b9ee000)
Stack:  ffff81043b9ee8f0 6b6b6b6b6b6b6b6b ffff81043b9ee000<6>ata1.00: ATAPI: HL-DT-STCD-RW/DVD-ROM GCC-T10N, A102, max UDMA/33
 ffffffff81059139
 000000003ba29c50 0000000000000002 0000000000000000 ffffffff81058623
 ffff81043b504660 0000000000000246 ffff81043e508028 ffff81043b504660
Call Trace:
 [<ffffffff81059139>] __lock_acquire+0x4d7/0xc8e
 [<ffffffff81058623>] mark_held_locks+0x49/0x67
 [<ffffffff81059ce2>] lock_acquire+0x5a/0x73
 [<ffffffff81129055>] kobject_add+0xca/0x194
 [<ffffffff8126d56c>] mutex_lock_nested+0x2a1/0x2b0
 [<ffffffff8126e997>] _spin_lock+0x26/0x52
 [<ffffffff81129055>] kobject_add+0xca/0x194
 [<ffffffff811a318c>] device_add+0x9a/0x56e
 [<ffffffff8805c327>] :scsi_mod:scsi_alloc_target+0x2cd/0x343
 [<ffffffff8805c492>] :scsi_mod:__scsi_scan_target+0x66/0x5c6
 [<ffffffff810587f0>] trace_hardirqs_on+0x115/0x138
 [<ffffffff8805ca37>] :scsi_mod:scsi_scan_channel+0x45/0x70
 [<ffffffff8805cb37>] :scsi_mod:scsi_scan_host_selected+0xd5/0x110
ata1.00: configured for UDMA/33
ata2: port disabled. ignoring.
 [<ffffffff8805cbe5>] :scsi_mod:do_scan_async+0x0/0x152
 [<ffffffff8805cbf9>] :scsi_mod:do_scan_async+0x14/0x152
 [<ffffffff8805cbe5>] :scsi_mod:do_scan_async+0x0/0x152
 [<ffffffff8104d4e8>] kthread+0x47/0x73
 [<ffffffff8126e418>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8100cee8>] child_rip+0xa/0x12
 [<ffffffff8100c5ff>] restore_args+0x0/0x30
 [<ffffffff811e0908>] menu_reflect+0x0/0x75
 [<ffffffff8104d371>] kthreadd+0x115/0x13a
 [<ffffffff8104d4a1>] kthread+0x0/0x73
 [<ffffffff8100cede>] child_rip+0x0/0x12


Code: 48 85 42 30 0f 85 2e 04 00 00 f0 ff 0d 2c ce 34 00 79 0d f3 
RIP  [<ffffffff81058183>] mark_lock+0x1b/0x472
 RSP <ffff81043ba29c20>
general protection fault: 0000 [2] SMP 
last sysfs file: /sys/class/firmware/timeout
CPU 3 
Modules linked in: ata_piix libata dm_snapshot dm_zero dm_mirror dm_mod shpchp megaraid_sas sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 743, comm: insmod Tainted: G      D 2.6.24-rc5-mm1 #1
RIP: 0010:[<ffffffff81130cca>]  [<ffffffff81130cca>] __list_add+0x2b/0x5b
RSP: 0000:ffff81043b4319c8  EFLAGS: 00010246
RAX: 6b6b6b6b6b6b6b6b RBX: ffff81043bec4a68 RCX: 0000000000000000
RDX: 6b6b6b6b6b6b6b6b RSI: ffff81043e508000 RDI: ffff81043bec4a78
RBP: ffff81043ba794b0 R08: 0000000000000002 R09: 0000000000000000
R10: ffffffff81129055 R11: ffffffff8102093a R12: ffff81043bec4aa8
R13: 00000000fffffffe R14: 0000000000000000 R15: ffff81043ba79090
FS:  00007fc3239ae6f0(0000) GS:ffff81043fc01d48(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000036196d5140 CR3: 000000043bb4c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process insmod (pid: 743, threadinfo ffff81043b430000, task ffff81043b42e000)
Stack:  ffff81043ba79090 ffffffff81129066 ffff81043ba79098 ffff81043bec48b8
 ffff81043bec4aa8 ffff81043bec48b8 0000000000000000 ffffffff811a318c
 ffff81043ba79098 ffff81043ba79300 ffff81043bec4a68 ffff81043ba79098
Call Trace:
 [<ffffffff81129066>] kobject_add+0xdb/0x194
 [<ffffffff811a318c>] device_add+0x9a/0x56e
 [<ffffffff8805c327>] :scsi_mod:scsi_alloc_target+0x2cd/0x343
 [<ffffffff8805cd92>] :scsi_mod:__scsi_add_device+0x5b/0xd9
 [<ffffffff880c78d4>] :libata:ata_scsi_scan_host+0xa8/0x28b
 [<ffffffff880c4698>] :libata:ata_host_register+0x256/0x280
 [<ffffffff880c9bfd>] :libata:ata_pci_init_one+0x231/0x285
 [<ffffffff880e38cc>] :ata_piix:piix_init_one+0x512/0x53d
 [<ffffffff81012f31>] native_sched_clock+0x47/0x70
 [<ffffffff8126e8ae>] _spin_unlock+0x17/0x20
 [<ffffffff8113a0f7>] pci_device_probe+0xb3/0xfd
 [<ffffffff811a5412>] driver_probe_device+0xee/0x16b
 [<ffffffff811a55d7>] __driver_attach+0x90/0xcc
 [<ffffffff811a5547>] __driver_attach+0x0/0xcc
 [<ffffffff811a5547>] __driver_attach+0x0/0xcc
 [<ffffffff811a4733>] bus_for_each_dev+0x47/0x72
 [<ffffffff811a4ff9>] bus_add_driver+0xc4/0x20b
 [<ffffffff811a5845>] driver_register+0x59/0xcd
 [<ffffffff8113a36c>] __pci_register_driver+0x57/0x8b
 [<ffffffff880eb01e>] :ata_piix:piix_init+0x1e/0x32
 [<ffffffff81061b2a>] sys_init_module+0x15e5/0x173b
 [<ffffffff8100bfae>] system_call+0x7e/0x83
