Return-Path: <linux-kernel-owner+w=401wt.eu-S1752225AbYLXGew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbYLXGew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 01:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYLXGeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 01:34:44 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50434 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYLXGen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 01:34:43 -0500
Message-Id: <200812240634.mBO6Y6ZY084756@www262.sakura.ne.jp>
Subject: [mmotm 2008-12-22-16-14] NULL pointer dereference in dma_alloc_from_coherent().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Dec 2008 15:34:06 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 23122008 #1347588, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm using Debian Sarge on VMware Workstation 6.5.1 .

Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.28-rc9-mm1

Regards.
----------
Linux version 2.6.28-rc9-mm1 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #2 SMP PREEMPT Wed Dec 24 15:00:36 JST 2008
(.....snipped.....)
initrd-tools: 0.1.81.1
mount: unknown filesystem type 'devfs'
NET: Registered protocol family 1
SCSI subsystem initialized
pci 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
scsi: ***** BusLogic SCSI Driver Version 2.1.16 of 18 July 2002 *****
scsi: Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
scsi0: Configuring BusLogic Model BT-958 PCI Wide Ultra SCSI Host Adapter
scsi0:   Firmware Version: 5.07B, I/O Address: 0x10C0, IRQ Channel: 17/Level
scsi0:   PCI Bus: 0, Device: 16, Address: 0xD8800000, Host Adapter SCSI ID: 7
scsi0:   Parity Checking: Enabled, Extended Translation: Enabled
scsi0:   Synchronous Negotiation: Ultra, Wide Negotiation: Enabled
scsi0:   Disconnect/Reconnect: Enabled, Tagged Queuing: Enabled
scsi0:   Scatter/Gather Limit: 128 of 8192 segments, Mailboxes: 211
scsi0:   Driver Queue Depth: 211, Host Adapter Queue Depth: 192
scsi0:   Tagged Queue Depth: Automatic, Untagged Queue Depth: 3
BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c0159475>] dma_alloc_from_coherent+0x35/0xa0
*pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file: 
Modules linked in: BusLogic(+) sg scsi_mod unix

Pid: 947, comm: modprobe Not tainted (2.6.28-rc9-mm1 #2) VMware Virtual Platform
EIP: 0060:[<c0159475>] EFLAGS: 00010247 CPU: 1
EIP is at dma_alloc_from_coherent+0x35/0xa0
EAX: f73b3c58 EBX: 00000000 ECX: 00000001 EDX: 00001e68
ESI: 00001e68 EDI: 00000020 EBP: 00000000 ESP: f6b0fcc0
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 947, ti=f6b0e000 task=f73ab850 task.ti=f6b0e000)
Stack:
 f6b0fce8 c0c00294 f73b3c58 00000020 c03be720 f80e604f f6b0fce4 00000c2c
 f80e7e8c c0c002ba c0c00294 f6b14000 c0c00350 c0c03344 00000c2c f80e8539
 f80dfeb0 00000000 00000000 f80e33e0 00000014 c0c00000 c0c00294 00000000
Call Trace:
 [<f80e604f>] BusLogic_CreateInitialCCBs+0x4f/0x120 [BusLogic]
 [<f80e7e8c>] BusLogic_AcquireResources+0x5c/0xf0 [BusLogic]
 [<f80e8539>] BusLogic_init+0x2d9/0x440 [BusLogic]
 [<c014ecb6>] each_symbol+0x46/0x1f0
 [<c014ee60>] find_symbol_in_section+0x0/0xf0
 [<c014ee60>] find_symbol_in_section+0x0/0xf0
 [<f80e8260>] BusLogic_init+0x0/0x440 [BusLogic]
 [<c0101115>] do_one_initcall+0x25/0x190
 [<c011f740>] update_curr+0x50/0xc0
 [<c0101fd3>] __switch_to+0x23/0x1c0
 [<c031121e>] _spin_unlock_irq+0xe/0x30
 [<c0124a16>] finish_task_switch+0x46/0xb0
 [<c030f6c6>] __sched_text_start+0x2a6/0x570
 [<c01202f3>] check_preempt_wakeup+0xd3/0x120
 [<c02081a3>] sub_alloc+0x73/0x150
 [<c02082fc>] idr_get_empty_slot+0x7c/0x140
 [<c0208aa6>] ida_get_new_above+0x96/0x180
 [<c01d5210>] sysfs_ilookup_test+0x0/0x10
 [<c01d5210>] sysfs_ilookup_test+0x0/0x10
 [<c01d55ba>] sysfs_find_dirent+0x1a/0x30
 [<c01d5328>] __sysfs_add_one+0x48/0x90
 [<c019cc76>] ilookup5+0x36/0x50
 [<c01d5382>] sysfs_add_one+0x12/0x50
 [<c01d551e>] sysfs_addrm_finish+0xe/0x90
 [<c01d4924>] sysfs_add_file_mode+0x54/0x80
 [<c01d69ab>] create_files+0xbb/0xe0
 [<c017e28e>] __vunmap+0x8e/0xc0
 [<c0150410>] mod_sysfs_setup+0x60/0xb0
 [<c0151841>] load_module+0x9f1/0xcc0
 [<c0151841>] load_module+0x9f1/0xcc0
 [<c0158dd1>] tracepoint_update_probe_range+0x21/0x60
 [<c0159277>] tracepoint_module_notify+0x27/0x30
 [<c01446ee>] notifier_call_chain+0x3e/0x60
 [<c014495d>] __blocking_notifier_call_chain+0x4d/0x70
 [<c0151c05>] sys_init_module+0xf5/0x1b0
 [<c010347a>] syscall_call+0x7/0xb
Code: 04 85 c0 89 0c 24 74 06 8b a8 98 00 00 00 8d 5e ff b9 ff ff ff ff c1 eb 0b 8d b6 00 00 00 00 8d bc 27 00 00 00 00 41 d1 eb 75 fb <8b> 55 08 31 c0 39 d6 7f 49 85 ed 74 3e 8b 45 10 e8 a6 7d 0b 00 
EIP: [<c0159475>] dma_alloc_from_coherent+0x35/0xa0 SS:ESP 0068:f6b0fcc0
---[ end trace d20c97140e4dab92 ]---
Segmentation fault
input: PC Speaker as /class/input/input1
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: I/O resource piix4_smbus [0x1040-0x1047] conflicts with ACPI region SMB_ [0x1040-0x104b]
ACPI: Device needs an ACPI driver
piix4_smbus: probe of 0000:00:07.3 failed with error -16
FATAL: Could not open '/lib/modules/2.6.28-rc9-mm1/kernel/drivers/net/pcnet32.ko': No such file or directory
Driver 'sd' needs updating - please use bus_type methods
umount: devfs: not mounted
mount: unknown filesystem type 'devfs'
umount: devfs: not mounted
pivot_root: No such file or directory
/sbin/init: 432: cannot open dev/console: No such file
Kernel panic - not syncing: Attempted to kill init!
