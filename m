Return-Path: <linux-kernel-owner+w=401wt.eu-S1161175AbXCNLew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbXCNLew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 07:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161171AbXCNLev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 07:34:51 -0400
Received: from bay0-omc2-s14.bay0.hotmail.com ([65.54.246.150]:37617 "EHLO
	bay0-omc2-s14.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161152AbXCNLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 07:34:49 -0400
Message-ID: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl>
X-Originating-IP: [85.36.106.198]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Wed, 14 Mar 2007 12:34:29 +0100
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 14 Mar 2007 11:34:48.0961 (UTC) FILETIME=[C5FC9F10:01C7662C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody.
Since 2.6.19.2 + commit 7fbbb01dca7704d52ace6f45a805c98a5b0362f9
I'm experimenting these errors.
2.6.19.1 has been worked good for more
than 30 days.
I have reverted back to 2.6.19.1 to see if
this problem happens again.
sda8 is a 280GB xfs filesystem which hosts
the squid file cache. I don't know if this
bug may be related to the used% size on
this file system.
May anoybody point me the step to try to
spot this bug?
TIA

Here is dmesg:

Mar  2 16:31:15 Pleiadi kernel: BUG: unable to handle kernel paging
request at virtual address a0814e49
Mar  2 16:31:15 Pleiadi kernel:  printing eip:
Mar  2 16:31:15 Pleiadi kernel: c013c22d
Mar  2 16:31:15 Pleiadi kernel: *pde = 00000000
Mar  2 16:31:15 Pleiadi kernel: Oops: 0000 [#1]
Mar  2 16:31:15 Pleiadi kernel: SMP
Mar  2 16:31:15 Pleiadi kernel: Modules linked in: nf_nat_pptp
nf_nat_proto_gre nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_ftp
nf_conntrack_ftp e1000 tg3
Mar  2 16:31:15 Pleiadi kernel: CPU:    0
Mar  2 16:31:15 Pleiadi kernel: EIP:    0060:[<c013c22d>]    Not tainted
VLI
Mar  2 16:31:15 Pleiadi kernel: EFLAGS: 00010082   (2.6.20 #1)
Mar  2 16:31:15 Pleiadi kernel: EIP is at find_lock_page+0x39/0x9c
Mar  2 16:31:15 Pleiadi kernel: eax: a0814e49   ebx: a0814e49   ecx:
fffffffa   edx: a0814e49
Mar  2 16:31:15 Pleiadi kernel: esi: f7e28694   edi: f7e286a4   ebp:
01e452a8   esp: eb585b38
Mar  2 16:31:15 Pleiadi kernel: ds: 007b   es: 007b   ss: 0068
Mar  2 16:31:15 Pleiadi kernel: Process squid (pid: 29819, ti=eb584000
task=c1969550 task.ti=eb584000)
Mar  2 16:31:15 Pleiadi kernel: Stack: f7e28698 00000000 f4f96380
00000250 01e452a8 c013c2c7 00000250 f7e28694
Mar  2 16:31:15 Pleiadi kernel:        c1330ce0 f4f96380 00001000
00000000 c01e8caf c01e8a0a f4f96380 f7ed37f4
Mar  2 16:31:15 Pleiadi kernel:        00000001 c03bee20 c03bee20
00000000 01e452a7 00010001 00000250 00001000
Mar  2 16:31:15 Pleiadi kernel: Call Trace:
Mar  2 16:31:15 Pleiadi kernel:  [<c013c2c7>]
find_or_create_page+0x37/0x8e
Mar  2 16:31:15 Pleiadi kernel:  [<c01e8caf>]
_xfs_buf_lookup_pages+0x132/0x2ea
Mar  2 16:31:15 Pleiadi kernel:  [<c01e8a0a>]
_xfs_buf_initialize+0xc8/0xf6
Mar  2 16:31:15 Pleiadi kernel:  [<c01e91a0>]
xfs_buf_get_flags+0xf8/0x11d
Mar  2 16:31:15 Pleiadi kernel:  [<c01e91e1>]
xfs_buf_read_flags+0x1c/0x7f
Mar  2 16:31:15 Pleiadi kernel:  [<c01db071>]
xfs_trans_read_buf+0x16a/0x34f
Mar  2 16:31:15 Pleiadi kernel:  [<c01c1a3f>] xfs_itobp+0x7c/0x242
Mar  2 16:31:15 Pleiadi kernel:  [<c01c2e8b>] xfs_iread+0x68/0x1d3
Mar  2 16:31:15 Pleiadi kernel:  [<c01b5835>]
xfs_dir2_leaf_lookup+0xd8/0xe2
Mar  2 16:31:15 Pleiadi kernel:  [<c01c0a4a>] xfs_iget_core+0xe7/0x687
Mar  2 16:31:15 Pleiadi kernel:  [<c01c10c2>] xfs_iget+0xd8/0x150
Mar  2 16:31:15 Pleiadi kernel:  [<c01dc156>]
xfs_dir_lookup_int+0x98/0x10e
Mar  2 16:31:15 Pleiadi kernel:  [<c01e1ad8>] xfs_lookup+0x5a/0x90
Mar  2 16:31:15 Pleiadi kernel:  [<c01ed58f>] xfs_vn_lookup+0x52/0x93
Mar  2 16:31:15 Pleiadi kernel:  [<c015e88c>] real_lookup+0xbb/0x116
Mar  2 16:31:15 Pleiadi kernel:  [<c015eb02>] do_lookup+0x90/0xc2
Mar  2 16:31:15 Pleiadi kernel:  [<c01ed53d>] xfs_vn_lookup+0x0/0x93
Mar  2 16:31:15 Pleiadi kernel:  [<c015f25b>]
__link_path_walk+0x727/0xcf1
Mar  2 16:31:15 Pleiadi kernel:  [<c015f863>] link_path_walk+0x3e/0xac
Mar  2 16:31:15 Pleiadi kernel:  [<c0157457>] get_unused_fd+0x2e/0xb6
Mar  2 16:31:15 Pleiadi kernel:  [<c015fb9f>] do_path_lookup+0x11a/0x1ba
Mar  2 16:31:15 Pleiadi kernel:  [<c015fca7>]
__path_lookup_intent_open+0x50/0x90
Mar  2 16:31:15 Pleiadi kernel:  [<c015fd07>] path_lookup_open+0x20/0x25
Mar  2 16:31:15 Pleiadi kernel:  [<c01604e3>] open_namei+0x7a/0x550
Mar  2 16:31:15 Pleiadi kernel:  [<c01489ec>] do_wp_page+0x20e/0x3e8
Mar  2 16:31:15 Pleiadi kernel:  [<c01572d2>] do_filp_open+0x2e/0x5b
Mar  2 16:31:15 Pleiadi kernel:  [<c0157457>] get_unused_fd+0x2e/0xb6
Mar  2 16:31:15 Pleiadi kernel:  [<c01575c5>] do_sys_open+0x4e/0xdb
Mar  2 16:31:15 Pleiadi kernel:  [<c015766e>] sys_open+0x1c/0x20
Mar  2 16:31:15 Pleiadi kernel:  [<c0102c24>] syscall_call+0x7/0xb
Mar  2 16:31:15 Pleiadi kernel:  =======================
Mar  2 16:31:15 Pleiadi kernel: Code: 89 c6 89 f8 89 6c 24 10 89 5c 24
04 89 d5 e8 85 80 1b 00 8d 46 04 89 04 24 89 ea 8b 04 24 e8 6d ea 0c 00
85 c0 89 c3 74 35 89 c2 <8b> 00 f6 c4 40 75 57 f0 ff 42 04 f0 0f ba 2b
00 19 c0 85 c0 74
Mar  2 16:31:15 Pleiadi kernel: EIP: [<c013c22d>]
find_lock_page+0x39/0x9c SS:ESP 0068:eb585b38
Mar 12 13:03:37 Pleiadi kernel: sanitize start
Mar 12 13:03:37 Pleiadi kernel: sanitize end
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 0000000000000000
size: 000000000009ac00 end: 000000000009ac00 type: 1
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() type is E820_RAM
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 000000000009ac00
size: 0000000000005400 end: 00000000000a0000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000000ce000
size: 0000000000002000 end: 00000000000d0000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000000e0000
size: 0000000000020000 end: 0000000000100000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 0000000000100000
size: 000000003fdf0000 end: 000000003fef0000 type: 1
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() type is E820_RAM
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 000000003fef0000
size: 000000000000b000 end: 000000003fefb000 type: 3
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 000000003fefb000
size: 0000000000005000 end: 000000003ff00000 type: 4
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 000000003ff00000
size: 0000000000080000 end: 000000003ff80000 type: 1
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() type is E820_RAM
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 000000003ff80000
size: 0000000000080000 end: 0000000040000000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000e0000000
size: 0000000010000000 end: 00000000f0000000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000fec00000
size: 0000000000100400 end: 00000000fed00400 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000fee00000
size: 0000000000100000 end: 00000000fef00000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000ffb00000
size: 0000000000100000 end: 00000000ffc00000 type: 2
Mar 12 13:03:37 Pleiadi kernel: copy_e820_map() start: 00000000fff00000
size: 0000000000100000 end: 0000000100000000 type: 2
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 0000000000000000 -
000000000009ac00 (usable)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 000000000009ac00 -
00000000000a0000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000000ce000 -
00000000000d0000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000000e0000 -
0000000000100000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 0000000000100000 -
000000003fef0000 (usable)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 000000003fef0000 -
000000003fefb000 (ACPI data)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 000000003fefb000 -
000000003ff00000 (ACPI NVS)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 000000003ff00000 -
000000003ff80000 (usable)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 000000003ff80000 -
0000000040000000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000e0000000 -
00000000f0000000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000fec00000 -
00000000fed00400 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000fee00000 -
00000000fef00000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000ffb00000 -
00000000ffc00000 (reserved)
Mar 12 13:03:37 Pleiadi kernel:  BIOS-e820: 00000000fff00000 -
0000000100000000 (reserved)
Mar 12 13:03:37 Pleiadi kernel: Zone PFN ranges:
Mar 12 13:03:37 Pleiadi kernel:   DMA             0 ->     4096
Mar 12 13:03:37 Pleiadi kernel:   Normal       4096 ->   229376
Mar 12 13:03:37 Pleiadi kernel:   HighMem    229376 ->   262016
Mar 12 13:03:37 Pleiadi kernel: early_node_map[1] active PFN ranges
Mar 12 13:03:37 Pleiadi kernel:     0:        0 ->   262016
Mar 12 13:03:37 Pleiadi kernel: Processor #0 15:4 APIC version 20
Mar 12 13:03:37 Pleiadi kernel: Processor #1 15:4 APIC version 20
Mar 12 13:03:37 Pleiadi kernel: IOAPIC[0]: apic_id 2, version 32,
address 0xfec00000, GSI 0-23
Mar 12 13:03:37 Pleiadi kernel: IOAPIC[1]: apic_id 3, version 32,
address 0xfec80000, GSI 24-47
Mar 12 13:03:37 Pleiadi kernel: IOAPIC[2]: apic_id 4, version 32,
address 0xfec80800, GSI 48-71
Mar 12 13:03:37 Pleiadi kernel: IOAPIC[3]: apic_id 5, version 32,
address 0xfec84000, GSI 72-95
Mar 12 13:03:37 Pleiadi kernel: IOAPIC[4]: apic_id 6, version 32,
address 0xfec84800, GSI 96-119
Mar 12 13:03:37 Pleiadi kernel: Enabling APIC mode:  Flat.  Using 5 I/O
APICs
Mar 12 13:03:37 Pleiadi kernel: Allocating PCI resources starting at
50000000 (gap: 40000000:a0000000)
Mar 12 13:03:37 Pleiadi kernel: Detected 3200.431 MHz processor.
Mar 12 13:03:37 Pleiadi kernel: Built 1 zonelists.  Total pages: 259969
Mar 12 13:03:37 Pleiadi kernel: PID hash table entries: 4096 (order: 12,
16384 bytes)
Mar 12 13:03:37 Pleiadi kernel: Console: colour VGA+ 80x25
Mar 12 13:03:37 Pleiadi kernel: Dentry cache hash table entries: 131072
(order: 7, 524288 bytes)
Mar 12 13:03:37 Pleiadi kernel: Inode-cache hash table entries: 65536
(order: 6, 262144 bytes)
Mar 12 13:03:37 Pleiadi kernel: virtual kernel memory layout:
Mar 12 13:03:37 Pleiadi kernel:     fixmap  : 0xfff9d000 - 0xfffff000
( 392 kB)
Mar 12 13:03:37 Pleiadi kernel:     pkmap   : 0xff800000 - 0xffc00000
(4096 kB)
Mar 12 13:03:37 Pleiadi kernel:     vmalloc : 0xf8800000 - 0xff7fe000
( 111 MB)
Mar 12 13:03:37 Pleiadi kernel:     lowmem  : 0xc0000000 - 0xf8000000
( 896 MB)
Mar 12 13:03:37 Pleiadi kernel:       .init : 0xc0391000 - 0xc03c0000
( 188 kB)
Mar 12 13:03:37 Pleiadi kernel:       .data : 0xc02f51a8 - 0xc038b074
( 599 kB)
Mar 12 13:03:37 Pleiadi kernel:       .text : 0xc0100000 - 0xc02f51a8
(2004 kB)
Mar 12 13:03:37 Pleiadi kernel: Checking if this processor honours the
WP bit even in supervisor mode... Ok.
Mar 12 13:03:37 Pleiadi kernel: Calibrating delay using timer specific
routine.. 6403.77 BogoMIPS (lpj=32018891)
Mar 12 13:03:37 Pleiadi kernel: Mount-cache hash table entries: 512
Mar 12 13:03:37 Pleiadi kernel: monitor/mwait feature present.
Mar 12 13:03:37 Pleiadi kernel: using mwait in idle threads.
Mar 12 13:03:37 Pleiadi kernel: CPU0: Intel(R) Xeon(TM) CPU 3.20GHz
stepping 0a
Mar 12 13:03:37 Pleiadi kernel: Booting processor 1/1 eip 2000
Mar 12 13:03:37 Pleiadi kernel: Calibrating delay using timer specific
routine.. 6400.43 BogoMIPS (lpj=32002195)
Mar 12 13:03:37 Pleiadi kernel: monitor/mwait feature present.
Mar 12 13:03:37 Pleiadi kernel: CPU1: Intel(R) Xeon(TM) CPU 3.20GHz
stepping 0a
Mar 12 13:03:37 Pleiadi kernel: ENABLING IO-APIC IRQs
Mar 12 13:03:37 Pleiadi kernel: migration_cost=42
Mar 12 13:03:37 Pleiadi kernel: Setting up standard PCI resources
Mar 12 13:03:37 Pleiadi kernel: PCI quirk: region f000-f07f claimed by
ICH4 ACPI/GPIO/TCO
Mar 12 13:03:37 Pleiadi kernel: PCI quirk: region f180-f1bf claimed by
ICH4 GPIO
Mar 12 13:03:37 Pleiadi kernel: PCI: PXH quirk detected, disabling MSI
for SHPC device
Mar 12 13:03:37 Pleiadi kernel: PCI: PXH quirk detected, disabling MSI
for SHPC device
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3
4 5 6 7 9 10 *11 12 14 15)
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3
4 5 6 7 *9 10 11 12 14 15)
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3
4 *5 6 7 9 10 11 12 14 15)
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3
4 5 6 7 9 *10 11 12 14 15)
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Mar 12 13:03:37 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3
*4 5 6 7 9 10 11 12 14 15)
Mar 12 13:03:37 Pleiadi kernel: ACPI: Device [PS2M] status [00000008]:
functional but not present; setting present
Mar 12 13:03:37 Pleiadi kernel: ACPI: Device [ECP] status [00000008]:
functional but not present; setting present
Mar 12 13:03:37 Pleiadi kernel: ACPI: Device [COM1] status [00000008]:
functional but not present; setting present
Mar 12 13:03:37 Pleiadi kernel: IP route cache hash table entries: 32768
(order: 5, 131072 bytes)
Mar 12 13:03:37 Pleiadi kernel: TCP established hash table entries:
131072 (order: 8, 1048576 bytes)
Mar 12 13:03:37 Pleiadi kernel: TCP bind hash table entries: 65536
(order: 7, 524288 bytes)
Mar 12 13:03:37 Pleiadi kernel: highmem bounce pool size: 64 pages
Mar 12 13:03:37 Pleiadi kernel: nf_conntrack version 0.5.0 (8188
buckets, 65504 max)
Mar 12 13:03:37 Pleiadi kernel: ip_tables: (C) 2000-2006 Netfilter Core
Team
Mar 12 13:03:37 Pleiadi kernel: Using IPI Shortcut mode
Mar 12 13:03:37 Pleiadi kernel: VFS: Mounted root (xfs filesystem)
readonly.
Mar 12 14:35:21 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:21 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:21 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:21 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:21 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:21 Pleiadi kernel:  [<c01405a3>] __alloc_pages+0x54/0x2d4
Mar 12 14:35:21 Pleiadi kernel:  [<f893a14d>]
e1000_xmit_frame+0x241/0x3fd [e1000]
Mar 12 14:35:21 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:21 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:21 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:21 Pleiadi kernel:  [<c02a8ee8>] ip_finish_output+0x0/0x1e3
Mar 12 14:35:21 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:21 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:21 Pleiadi kernel:  [<c011353a>] __activate_task+0x21/0x3b
Mar 12 14:35:21 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:21 Pleiadi kernel:  [<c012d568>]
autoremove_wake_function+0x1b/0x43
Mar 12 14:35:21 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:21 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:21 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 12 14:35:21 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 12 14:35:21 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 12 14:35:21 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 12 14:35:21 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 12 14:35:21 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:21 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 12 14:35:21 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 12 14:35:21 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 12 14:35:21 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 12 14:35:21 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 12 14:35:21 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:21 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 12 14:35:21 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 12 14:35:21 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:21 Pleiadi kernel:  =======================
Mar 12 14:35:22 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:22 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:22 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:22 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:22 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:22 Pleiadi kernel:  [<c02f2d78>]
__sched_text_start+0x360/0x77b
Mar 12 14:35:22 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:22 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:22 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:22 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:22 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:22 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 14:35:22 Pleiadi kernel:  [<c015d614>] pipe_read+0x23b/0x2bf
Mar 12 14:35:22 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:22 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 14:35:22 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:22 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:22 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 14:35:22 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 14:35:22 Pleiadi kernel:  [<c0157f84>] vfs_read+0xf2/0x16f
Mar 12 14:35:22 Pleiadi kernel:  [<c01582ca>] sys_read+0x41/0x6a
Mar 12 14:35:22 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:22 Pleiadi kernel:  =======================
Mar 12 14:35:24 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:24 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:24 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:24 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:24 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:24 Pleiadi kernel:  [<f893a14d>]
e1000_xmit_frame+0x241/0x3fd [e1000]
Mar 12 14:35:24 Pleiadi kernel:  [<c028fab3>] __qdisc_run+0x132/0x1ac
Mar 12 14:35:24 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:24 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:24 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:24 Pleiadi kernel:  [<c02a8ee8>] ip_finish_output+0x0/0x1e3
Mar 12 14:35:24 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:24 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:24 Pleiadi kernel:  [<c01773da>]
__block_commit_write+0x7d/0xb0
Mar 12 14:35:24 Pleiadi kernel:  [<c0142f42>]
__pagevec_lru_add+0x8f/0x9a
Mar 12 14:35:24 Pleiadi kernel:  [<c013e026>]
generic_file_buffered_write+0x39b/0x63d
Mar 12 14:35:24 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:24 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:24 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:24 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 12 14:35:24 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 12 14:35:24 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 12 14:35:24 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 12 14:35:24 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 12 14:35:24 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:24 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 12 14:35:24 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 12 14:35:24 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 12 14:35:24 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 12 14:35:24 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 12 14:35:24 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:24 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 12 14:35:24 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 12 14:35:24 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:24 Pleiadi kernel:  =======================
Mar 12 14:35:25 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:25 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:25 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c027dcdc>] __alloc_skb+0x56/0x108
Mar 12 14:35:25 Pleiadi kernel:  [<c02bcf3f>] tcp_send_ack+0xb9/0x105
Mar 12 14:35:25 Pleiadi kernel:  [<c02c0ab6>] tcp_v4_rcv+0x77b/0x803
Mar 12 14:35:25 Pleiadi kernel:  [<c0298fe1>] nf_hook_slow+0x5d/0xe9
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:25 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:25 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:25 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:25 Pleiadi kernel:  [<f88db69a>] tg3_restart_ints+0x11/0x65
[tg3]
Mar 12 14:35:25 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:25 Pleiadi kernel:  [<c028432a>] net_rx_action+0x6c/0xf0
Mar 12 14:35:25 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:25 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:25 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 12 14:35:25 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 12 14:35:25 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 12 14:35:25 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 12 14:35:25 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 12 14:35:25 Pleiadi kernel:  [<c0284238>] process_backlog+0x82/0x108
Mar 12 14:35:25 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:25 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 12 14:35:25 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 12 14:35:25 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 12 14:35:25 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 12 14:35:25 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 12 14:35:25 Pleiadi kernel:  [<c0284238>] process_backlog+0x82/0x108
Mar 12 14:35:25 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:25 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 12 14:35:25 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 12 14:35:25 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:25 Pleiadi kernel:  =======================
Mar 12 14:35:25 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:25 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:25 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c02f2d78>]
__sched_text_start+0x360/0x77b
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:25 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:25 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:25 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:25 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 14:35:25 Pleiadi kernel:  [<c01405a3>] __alloc_pages+0x54/0x2d4
Mar 12 14:35:25 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:25 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 14:35:25 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:25 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:25 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 14:35:25 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 14:35:25 Pleiadi kernel:  [<c0157f84>] vfs_read+0xf2/0x16f
Mar 12 14:35:25 Pleiadi kernel:  [<c01582ca>] sys_read+0x41/0x6a
Mar 12 14:35:25 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:25 Pleiadi kernel:  =======================
Mar 12 14:35:25 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:25 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:25 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c02f2d78>]
__sched_text_start+0x360/0x77b
Mar 12 14:35:25 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:25 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:25 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:25 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:25 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:25 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 14:35:25 Pleiadi kernel:  [<c015d614>] pipe_read+0x23b/0x2bf
Mar 12 14:35:25 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:25 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 14:35:25 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:25 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:25 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 14:35:25 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 14:35:25 Pleiadi kernel:  [<c0157f84>] vfs_read+0xf2/0x16f
Mar 12 14:35:25 Pleiadi kernel:  [<c01582ca>] sys_read+0x41/0x6a
Mar 12 14:35:25 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:25 Pleiadi kernel:  =======================
Mar 12 14:35:26 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:26 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:26 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:26 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:26 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:26 Pleiadi kernel:  [<f88e0464>]
tg3_start_xmit_dma_bug+0x26b/0x528 [tg3]
Mar 12 14:35:26 Pleiadi kernel:  [<c028fab3>] __qdisc_run+0x132/0x1ac
Mar 12 14:35:26 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:26 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:26 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:26 Pleiadi kernel:  [<c02a8ee8>] ip_finish_output+0x0/0x1e3
Mar 12 14:35:26 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:26 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:26 Pleiadi kernel:  [<c020dea6>] copy_to_user+0x2b/0x37
Mar 12 14:35:26 Pleiadi kernel:  [<c02806e2>] memcpy_toiovec+0x27/0x4c
Mar 12 14:35:26 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:26 Pleiadi kernel:  [<c027f95e>] skb_dequeue+0x45/0x56
Mar 12 14:35:26 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:26 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:26 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 12 14:35:26 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 12 14:35:26 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 12 14:35:26 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 12 14:35:26 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 12 14:35:26 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:26 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 12 14:35:26 Pleiadi kernel:  [<c015fcdb>] __path_lookup_intent_open+
0x50/0x90
Mar 12 14:35:26 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 12 14:35:26 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 12 14:35:26 Pleiadi kernel:  [<c014951c>]
do_anonymous_page+0xe4/0x18c
Mar 12 14:35:26 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 12 14:35:26 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:26 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 12 14:35:26 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 12 14:35:26 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:26 Pleiadi kernel:  =======================
Mar 12 14:35:27 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:27 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:27 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:27 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:27 Pleiadi last message repeated 2 times
Mar 12 14:35:27 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:27 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:27 Pleiadi kernel:  [<c0283967>]
dev_hard_start_xmit+0x57/0xd4
Mar 12 14:35:27 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:27 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:27 Pleiadi kernel:  [<c01773da>]
__block_commit_write+0x7d/0xb0
Mar 12 14:35:27 Pleiadi kernel:  [<c013df3d>]
generic_file_buffered_write+0x2b2/0x63d
Mar 12 14:35:27 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:27 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:27 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:27 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 12 14:35:27 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 12 14:35:27 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 12 14:35:27 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 12 14:35:27 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 12 14:35:27 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:27 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 12 14:35:27 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 12 14:35:27 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 12 14:35:27 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 12 14:35:27 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 12 14:35:27 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 14:35:27 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 12 14:35:27 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 12 14:35:27 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:27 Pleiadi kernel:  =======================
Mar 12 14:35:27 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 14:35:27 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 14:35:27 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 14:35:27 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:27 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:27 Pleiadi kernel:  [<c02f2d78>]
__sched_text_start+0x360/0x77b
Mar 12 14:35:27 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 14:35:27 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:27 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 14:35:27 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 14:35:27 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 14:35:27 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 14:35:27 Pleiadi kernel:  [<c015d614>] pipe_read+0x23b/0x2bf
Mar 12 14:35:27 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 14:35:27 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 14:35:27 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 14:35:27 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 14:35:27 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 14:35:27 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 14:35:27 Pleiadi kernel:  [<c0157f84>] vfs_read+0xf2/0x16f
Mar 12 14:35:27 Pleiadi kernel:  [<c01582ca>] sys_read+0x41/0x6a
Mar 12 14:35:27 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 14:35:27 Pleiadi kernel:  =======================
Mar 12 15:48:53 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 15:48:53 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 15:48:53 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 15:48:53 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 15:48:53 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 15:48:53 Pleiadi kernel:  [<c0283cb1>] dev_queue_xmit+0x2cd/0x2db
Mar 12 15:48:53 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 15:48:53 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 15:48:53 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 15:48:53 Pleiadi kernel:  [<c02a8ee8>] ip_finish_output+0x0/0x1e3
Mar 12 15:48:53 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 15:48:53 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 15:48:53 Pleiadi kernel:  [<c01773da>]
__block_commit_write+0x7d/0xb0
Mar 12 15:48:53 Pleiadi kernel:  [<c013df3d>]
generic_file_buffered_write+0x2b2/0x63d
Mar 12 15:48:53 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 15:48:53 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 15:48:53 Pleiadi kernel:  [<c028ddbd>]
flow_cache_lookup+0x1de/0x1e2
Mar 12 15:48:53 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 15:48:53 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 12 15:48:53 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 12 15:48:53 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 12 15:48:53 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 12 15:48:53 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 12 15:48:53 Pleiadi kernel:  [<f893af0a>] e1000_clean+0xc1/0x101
[e1000]
Mar 12 15:48:53 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 15:48:53 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 12 15:48:53 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 12 15:48:53 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 12 15:48:53 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 12 15:48:53 Pleiadi kernel:  [<f88df579>] tg3_rx+0x370/0x3c3 [tg3]
Mar 12 15:48:53 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 12 15:48:53 Pleiadi kernel:  [<f893af0a>] e1000_clean+0xc1/0x101
[e1000]
Mar 12 15:48:53 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 12 15:48:53 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 12 15:48:53 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 12 15:48:53 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 15:48:53 Pleiadi kernel:  =======================
Mar 12 17:56:59 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 17:56:59 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 17:56:59 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01405a3>] __alloc_pages+0x54/0x2d4
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 17:56:59 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 17:56:59 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 17:56:59 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 17:56:59 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 17:56:59 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 17:56:59 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 17:56:59 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 17:56:59 Pleiadi kernel:  =======================
Mar 12 17:56:59 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 17:56:59 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 17:56:59 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01405a3>] __alloc_pages+0x54/0x2d4
Mar 12 17:56:59 Pleiadi kernel:  [<c0168963>] __d_lookup+0x95/0xfa
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c0167a02>] dput+0x8a/0x12c
Mar 12 17:56:59 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 17:56:59 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 17:56:59 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 17:56:59 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 17:56:59 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 17:56:59 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 17:56:59 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 17:56:59 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 17:56:59 Pleiadi kernel:  =======================
Mar 12 17:56:59 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 17:56:59 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 17:56:59 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01405a3>] __alloc_pages+0x54/0x2d4
Mar 12 17:56:59 Pleiadi kernel:  [<c0168963>] __d_lookup+0x95/0xfa
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c0167a02>] dput+0x8a/0x12c
Mar 12 17:56:59 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 17:56:59 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 17:56:59 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 17:56:59 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 17:56:59 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 17:56:59 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 17:56:59 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 17:56:59 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 17:56:59 Pleiadi kernel:  =======================
Mar 12 17:56:59 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 12 17:56:59 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 12 17:56:59 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01405a3>] __alloc_pages+0x54/0x2d4
Mar 12 17:56:59 Pleiadi kernel:  [<c0168963>] __d_lookup+0x95/0xfa
Mar 12 17:56:59 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 12 17:56:59 Pleiadi kernel:  [<c0167a02>] dput+0x8a/0x12c
Mar 12 17:56:59 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 12 17:56:59 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 12 17:56:59 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 12 17:56:59 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 12 17:56:59 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 12 17:56:59 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 12 17:56:59 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 12 17:56:59 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 12 17:56:59 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 12 17:56:59 Pleiadi kernel:  =======================
Mar 13 09:29:07 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 13 09:29:07 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 13 09:29:07 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi kernel:  [<f88e0464>]
tg3_start_xmit_dma_bug+0x26b/0x528 [tg3]
Mar 13 09:29:07 Pleiadi kernel:  [<c028fab3>] __qdisc_run+0x132/0x1ac
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 13 09:29:07 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 13 09:29:07 Pleiadi kernel:  [<c02a8ee8>] ip_finish_output+0x0/0x1e3
Mar 13 09:29:07 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 13 09:29:07 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 13 09:29:07 Pleiadi kernel:  [<c01773da>]
__block_commit_write+0x7d/0xb0
Mar 13 09:29:07 Pleiadi kernel:  [<c028ddbd>]
flow_cache_lookup+0x1de/0x1e2
Mar 13 09:29:07 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 13 09:29:07 Pleiadi kernel:  [<c02e0c38>]
__xfrm_policy_check+0x8c/0x5e6
Mar 13 09:29:07 Pleiadi kernel:  [<c02dfe57>]
xfrm_policy_lookup+0x0/0x43
Mar 13 09:29:07 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 13 09:29:07 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 13 09:29:07 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 13 09:29:07 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 13 09:29:07 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 13 09:29:07 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 13 09:29:07 Pleiadi kernel:  [<c02b86be>]
tcp_rcv_established+0x3e3/0x6ad
Mar 13 09:29:07 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 13 09:29:07 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 13 09:29:07 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 13 09:29:07 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 13 09:29:07 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 13 09:29:07 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 13 09:29:07 Pleiadi kernel:  [<c0148a20>] do_wp_page+0x20e/0x3e8
Mar 13 09:29:07 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 13 09:29:07 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 13 09:29:07 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 13 09:29:07 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 13 09:29:07 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 13 09:29:07 Pleiadi kernel:  =======================
Mar 13 09:29:07 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 13 09:29:07 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 13 09:29:07 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi kernel:  [<f893a14d>]
e1000_xmit_frame+0x241/0x3fd [e1000]
Mar 13 09:29:07 Pleiadi kernel:  [<c028fab3>] __qdisc_run+0x132/0x1ac
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 13 09:29:07 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 13 09:29:07 Pleiadi kernel:  [<c02a8ee8>] ip_finish_output+0x0/0x1e3
Mar 13 09:29:07 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 13 09:29:07 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 13 09:29:07 Pleiadi kernel:  [<c01773da>]
__block_commit_write+0x7d/0xb0
Mar 13 09:29:07 Pleiadi kernel:  [<c013df3d>]
generic_file_buffered_write+0x2b2/0x63d
Mar 13 09:29:07 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 13 09:29:07 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 13 09:29:07 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 13 09:29:07 Pleiadi kernel:  [<c015e8c0>] real_lookup+0xbb/0x116
Mar 13 09:29:07 Pleiadi kernel:  [<c015eb36>] do_lookup+0x90/0xc2
Mar 13 09:29:07 Pleiadi kernel:  [<c01ed571>] xfs_vn_lookup+0x0/0x93
Mar 13 09:29:07 Pleiadi kernel:  [<c015f28f>]
__link_path_walk+0x727/0xcf1
Mar 13 09:29:07 Pleiadi kernel:  [<c015f897>] link_path_walk+0x3e/0xac
Mar 13 09:29:07 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 13 09:29:07 Pleiadi kernel:  [<c015fbd3>] do_path_lookup+0x11a/0x1ba
Mar 13 09:29:07 Pleiadi kernel:  [<c015fcdb>]
__path_lookup_intent_open+0x50/0x90
Mar 13 09:29:07 Pleiadi kernel:  [<c015fd3b>] path_lookup_open+0x20/0x25
Mar 13 09:29:07 Pleiadi kernel:  [<c0160517>] open_namei+0x7a/0x550
Mar 13 09:29:07 Pleiadi kernel:  [<c0148a20>] do_wp_page+0x20e/0x3e8
Mar 13 09:29:07 Pleiadi kernel:  [<c0157306>] do_filp_open+0x2e/0x5b
Mar 13 09:29:07 Pleiadi kernel:  [<c015748b>] get_unused_fd+0x2e/0xb6
Mar 13 09:29:07 Pleiadi kernel:  [<c01575f9>] do_sys_open+0x4e/0xdb
Mar 13 09:29:07 Pleiadi kernel:  [<c01576a2>] sys_open+0x1c/0x20
Mar 13 09:29:07 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 13 09:29:07 Pleiadi kernel:  =======================
Mar 13 09:29:07 Pleiadi kernel: 0x0: e0 61 ed 62 b6 ff f3 a4 7b d6 0c 75
ba 4e 8b cd
Mar 13 09:29:07 Pleiadi kernel: Filesystem "sda8": XFS internal error
xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller
0xc01b00bd
Mar 13 09:29:07 Pleiadi kernel:  [<c01affb3>] xfs_da_do_buf+0x70c/0x7b1
Mar 13 09:29:07 Pleiadi kernel:  [<c01b00bd>] xfs_da_read_buf+0x30/0x35
Mar 13 09:29:07 Pleiadi last message repeated 2 times
Mar 13 09:29:07 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 13 09:29:07 Pleiadi kernel:  [<c01ae571>]
xfs_da_node_lookup_int+0x9e/0x2b2
Mar 13 09:29:07 Pleiadi kernel:  [<c01b87f1>]
xfs_dir2_node_lookup+0x40/0xc9
Mar 13 09:29:07 Pleiadi kernel:  [<c01b0bf2>] xfs_dir_lookup+0x11b/0x11d
Mar 13 09:29:07 Pleiadi kernel:  [<c015eaea>] do_lookup+0x44/0xc2
Mar 13 09:29:07 Pleiadi kernel:  [<c015d614>] pipe_read+0x23b/0x2bf
Mar 13 09:29:07 Pleiadi kernel:  [<c01dc126>]
xfs_dir_lookup_int+0x34/0x10e
Mar 13 09:29:07 Pleiadi kernel:  [<c015f8ba>] link_path_walk+0x61/0xac
Mar 13 09:29:07 Pleiadi kernel:  [<c01e1b0c>] xfs_lookup+0x5a/0x90
Mar 13 09:29:07 Pleiadi kernel:  [<c01ed5c3>] xfs_vn_lookup+0x52/0x93
Mar 13 09:29:07 Pleiadi kernel:  [<c015fe40>] __lookup_hash+0x8a/0xac
Mar 13 09:29:07 Pleiadi kernel:  [<c01611f9>] do_unlinkat+0x6e/0x114
Mar 13 09:29:07 Pleiadi kernel:  [<c0157f84>] vfs_read+0xf2/0x16f
Mar 13 09:29:07 Pleiadi kernel:  [<c01582ca>] sys_read+0x41/0x6a
Mar 13 09:29:07 Pleiadi kernel:  [<c0102c38>] syscall_call+0x7/0xb
Mar 13 09:29:07 Pleiadi kernel:  =======================


