Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbYAaEoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbYAaEoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 23:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYAaEop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 23:44:45 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53272 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbYAaEoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 23:44:44 -0500
Date: Wed, 30 Jan 2008 21:02:09 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: system without RAM on node0 boot fail
In-reply-to: <200801302026.27130.yinghai.lu@sun.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Message-id: <200801302102.09510.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801302026.27130.yinghai.lu@sun.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

current x86.git
Command line: apic=debug acpi.debug_level=0x0000000F debug initcall_debug pci=routeirq ramdisk_size=131072 root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200n8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dcff0000 (usable)
 BIOS-e820: 00000000dcff0000 - 00000000dcffe000 (ACPI data)
 BIOS-e820: 00000000dcffe000 - 00000000dd000000 (ACPI NVS)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000123000000 (usable)
Early serial console at I/O port 0x3f8 (options '115200n8')
console [uart0] enabled
end_pfn_map = 1191936
DMI present.
...
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 1 PXM 1 0-a0000
SRAT: Node 1 PXM 1 0-dd000000
SRAT: Node 1 PXM 1 0-123000000
ACPI: SLIT: nodes = 2
 10 13
 13 10
mapped APIC to ffffffffff5fb000 (        fee00000)
Bootmem setup node 1 0000000000000000-0000000123000000
  NODE_DATA [000000000000e000 - 0000000000014fff]
  bootmap [0000000000015000 -  00000000000395ff] pages 25
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-d9c273] TEXT DATA BSS
early res: 3 [7e6f4000-7fff3a25] RAMDISK
early res: 4 [9bc00-9dbff] EBDA
early res: 5 [8000-dfff] PGTABLE
Could not find start_pfn for node 0
Pid: 0, comm: swapper Not tainted 2.6.24-smp-04921-gbce08dc-dirty #43

Call Trace:
 [<ffffffff80c200d6>] free_area_init_node+0x22/0x381
 [<ffffffff804539e5>] generic_swap+0x0/0x17
 [<ffffffff80c06a1b>] find_zone_movable_pfns_for_nodes+0x54/0x271
 [<ffffffff80c06f4a>] free_area_init_nodes+0x239/0x287
 [<ffffffff80c0203a>] paging_init+0x46/0x4c
 [<ffffffff80bf9dba>] setup_arch+0x3c3/0x44e
 [<ffffffff80bf38d3>] start_kernel+0x6f/0x2c7
 [<ffffffff80bf31e1>] _sinittext+0x1e1/0x1e8

RIP 0x10


2.6.24 
discontinuous and slab works well

2.6.24
sparse and slub will get oops
ehci_hcd 0000:00:02.1: EHCI Host Controller
Unable to handle kernel paging request at 0000000000003078 RIP:
 [<ffffffff8026585f>] __alloc_pages+0x7d/0x33a
PGD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-smp #1
RIP: 0010:[<ffffffff8026585f>]  [<ffffffff8026585f>] __alloc_pages+0x7d/0x33a
RSP: 0018:ffff810122a55bc0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: 0000000000003070 RSI: 0000000000000000 RDI: 00000000000000d0
RBP: 00000000000000d0 R08: ffff810001025be0 R09: ffff810122a55b00
R10: ffffffff8085e2a0 R11: 00000000000000a0 R12: 0000000000003070
R13: 0000000000000000 R14: 00000000000000d0 R15: ffff810122a52000
FS:  0000000000000000(0000) GS:ffff810122c02f00(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000003078 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff810122a54000, task ffff810122a52000)
Stack:  ffff810122a55d20 0000000080455b55 0000000000000000 0000000000000080
 0000000000003078 0000000022a55d10 00000010000200d0 ffff81011f5ea000
 0000000000000020 0000000000000000 00000000fffffff2 0000000000000000
Call Trace:
 [<ffffffff80282ea1>] new_slab+0xdd/0x236
 [<ffffffff802831a1>] __slab_alloc+0x1a7/0x397
 [<ffffffff804cea6f>] dma_pool_create+0x86/0x147
 [<ffffffff80283697>] kmem_cache_alloc_node+0x3e/0x6d
 [<ffffffff804cea6f>] dma_pool_create+0x86/0x147
 [<ffffffff80667e52>] hcd_buffer_create+0x57/0x89
 [<ffffffff80450032>] compat_blkdev_ioctl+0xd72/0x11f4
 [<ffffffff80662da4>] usb_add_hcd+0x72/0x59f
 [<ffffffff8066c541>] usb_hcd_pci_probe+0x1e4/0x28b
 [<ffffffff80461de6>] pci_device_probe+0xd1/0x136
 [<ffffffff804caf0f>] driver_probe_device+0xd3/0x150
 [<ffffffff804cb02e>] __driver_attach+0x0/0x93
 [<ffffffff804cb088>] __driver_attach+0x5a/0x93
 [<ffffffff804ca36d>] bus_for_each_dev+0x43/0x6e
 [<ffffffff804ca69d>] bus_add_driver+0x79/0x1bd
 [<ffffffff80461fbe>] __pci_register_driver+0x5b/0x8d
 [<ffffffff80bbf63a>] kernel_init+0x175/0x2e1
 [<ffffffff8020cd28>] child_rip+0xa/0x12
 [<ffffffff80bbf4c5>] kernel_init+0x0/0x2e1
 [<ffffffff8020cd1e>] child_rip+0x0/0x12


Code: 49 83 7c 24 08 00 75 0e 48 c7 44 24 38 00 00 00 00 e9 93 02
RIP  [<ffffffff8026585f>] __alloc_pages+0x7d/0x33a
 RSP <ffff810122a55bc0>
CR2: 0000000000003078
---[ end trace c08baa60a7f2ad32 ]---
Kernel panic - not syncing: Attempted to kill init!

