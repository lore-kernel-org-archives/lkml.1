Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYEENpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYEENpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbYEENpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:45:15 -0400
Received: from bay0-omc3-s27.bay0.hotmail.com ([65.54.246.227]:39068 "EHLO
	bay0-omc3-s27.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929AbYEENpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:45:03 -0400
Message-ID: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl>
X-Originating-IP: [85.32.103.134]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020
Date: Mon, 5 May 2008 15:41:29 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 05 May 2008 13:45:02.0216 (UTC) FILETIME=[37B83880:01C8AEB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.
Just few minutes ago an xfs filesystem
was shutdown with these errors:

May  5 14:31:38 Pleiadi kernel: xfs_inotobp: xfs_imap()  returned an
error 22 on hda8.  Returning error.
May  5 14:31:38 Pleiadi kernel: xfs_iunlink_remove: xfs_inotobp()
returned an error 22 on hda8.  Returning error.
May  5 14:31:38 Pleiadi kernel: xfs_inactive:^Ixfs_ifree() returned an
error = 22 on hda8
May  5 14:31:38 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called from
line 1737 of file fs/xfs/xfs_vnodeops.c.  Return address = 0xc01e6fde
May  5 14:31:38 Pleiadi kernel: Filesystem "hda8": I/O Error Detected.
Shutting down filesystem: hda8
May  5 14:31:38 Pleiadi kernel: Please umount the filesystem, and
rectify the problem(s)
May  5 14:36:43 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called from
line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xc01eaf21

Here is the full dmesg (from boot to crash).
config is similar to this post:
http://www.ussg.iu.edu/hypermail/linux/kernel/0804.3/1763.html

Apr 24 15:32:27 Pleiadi kernel: Linux version 2.6.25 (root@Pleiadi) (gcc
version 3.4.6) #1 Thu Apr 24 14:43:02 CEST 2008
Apr 24 15:32:27 Pleiadi kernel: BIOS-provided physical RAM map:
Apr 24 15:32:27 Pleiadi kernel:  BIOS-e820: 0000000000000000 -
000000000009f800 (usable)
Apr 24 15:32:27 Pleiadi kernel:  BIOS-e820: 000000000009f800 -
00000000000a0000 (reserved)
Apr 24 15:32:27 Pleiadi kernel:  BIOS-e820: 00000000000f0000 -
0000000000100000 (reserved)
Apr 24 15:32:27 Pleiadi kernel:  BIOS-e820: 0000000000100000 -
000000000a000000 (usable)
Apr 24 15:32:27 Pleiadi kernel:  BIOS-e820: 00000000ffff0000 -
0000000100000000 (reserved)
Apr 24 15:32:27 Pleiadi kernel: 160MB LOWMEM available.
Apr 24 15:32:27 Pleiadi kernel: Scan SMP from c0000000 for 1024 bytes.
Apr 24 15:32:27 Pleiadi kernel: Scan SMP from c009fc00 for 1024 bytes.
Apr 24 15:32:27 Pleiadi kernel: Scan SMP from c00f0000 for 65536 bytes.
Apr 24 15:32:27 Pleiadi kernel: Scan SMP from c009f800 for 1024 bytes.
Apr 24 15:32:27 Pleiadi kernel: Entering add_active_range(0, 0, 40960) 0
entries of 256 used
Apr 24 15:32:27 Pleiadi kernel: Zone PFN ranges:
Apr 24 15:32:27 Pleiadi kernel:   DMA             0 ->     4096
Apr 24 15:32:27 Pleiadi kernel:   Normal       4096 ->    40960
Apr 24 15:32:27 Pleiadi kernel: Movable zone start PFN for each node
Apr 24 15:32:27 Pleiadi kernel: early_node_map[1] active PFN ranges
Apr 24 15:32:27 Pleiadi kernel:     0:        0 ->    40960
Apr 24 15:32:27 Pleiadi kernel: On node 0 totalpages: 40960
Apr 24 15:32:27 Pleiadi kernel:   DMA zone: 32 pages used for memmap
Apr 24 15:32:27 Pleiadi kernel:   DMA zone: 0 pages reserved
Apr 24 15:32:27 Pleiadi kernel:   DMA zone: 4064 pages, LIFO batch:0
Apr 24 15:32:27 Pleiadi kernel:   Normal zone: 288 pages used for memmap
Apr 24 15:32:27 Pleiadi kernel:   Normal zone: 36576 pages, LIFO batch:7
Apr 24 15:32:27 Pleiadi kernel:   Movable zone: 0 pages used for memmap
Apr 24 15:32:27 Pleiadi kernel: DMI 2.1 present.
Apr 24 15:32:27 Pleiadi kernel: ACPI Error (tbxfroot-0218): A valid RSDP
was not found [20070126]
Apr 24 15:32:27 Pleiadi kernel: ACPI: DMI detected: Hewlett-Packard
Apr 24 15:32:27 Pleiadi kernel: Allocating PCI resources starting at
10000000 (gap: 0a000000:f5ff0000)
Apr 24 15:32:27 Pleiadi kernel: Built 1 zonelists in Zone order,
mobility grouping on.  Total pages: 40640
Apr 24 15:32:27 Pleiadi kernel: Kernel command line: BOOT_IMAGE=Linux ro
root=301 console=ttyS0,9600 console=tty0
Apr 24 15:32:27 Pleiadi kernel: Local APIC disabled by BIOS -- you can
enable it with "lapic"
Apr 24 15:32:27 Pleiadi kernel: mapped APIC to ffffb000 (01141000)
Apr 24 15:32:27 Pleiadi kernel: Enabling fast FPU save and restore...
done.
Apr 24 15:32:27 Pleiadi kernel: Initializing CPU#0
Apr 24 15:32:27 Pleiadi kernel: PID hash table entries: 1024 (order: 10,
4096 bytes)
Apr 24 15:32:27 Pleiadi kernel: Detected 300.691 MHz processor.
Apr 24 15:32:27 Pleiadi kernel: Console: colour VGA+ 80x25
Apr 24 15:32:27 Pleiadi kernel: console [tty0] enabled
Apr 24 15:32:27 Pleiadi kernel: console [ttyS0] enabled
Apr 24 15:32:27 Pleiadi kernel: Dentry cache hash table entries: 32768
(order: 5, 131072 bytes)
Apr 24 15:32:27 Pleiadi kernel: Inode-cache hash table entries: 16384
(order: 4, 65536 bytes)
Apr 24 15:32:27 Pleiadi kernel: Memory: 158804k/163840k available (2097k
kernel code, 4600k reserved, 643k data, 184k init, 0k highmem)
Apr 24 15:32:27 Pleiadi kernel: virtual kernel memory layout:
Apr 24 15:32:27 Pleiadi kernel:     fixmap  : 0xfffb5000 - 0xfffff000
( 296 kB)
Apr 24 15:32:27 Pleiadi kernel:     vmalloc : 0xca800000 - 0xfffb3000
( 855 MB)
Apr 24 15:32:27 Pleiadi kernel:     lowmem  : 0xc0000000 - 0xca000000
( 160 MB)
Apr 24 15:32:27 Pleiadi kernel:       .init : 0xc03b0000 - 0xc03de000
( 184 kB)
Apr 24 15:32:27 Pleiadi kernel:       .data : 0xc030c46f - 0xc03ad3dc
( 643 kB)
Apr 24 15:32:27 Pleiadi kernel:       .text : 0xc0100000 - 0xc030c46f
(2097 kB)
Apr 24 15:32:27 Pleiadi kernel: Checking if this processor honours the
WP bit even in supervisor mode...Ok.
Apr 24 15:32:27 Pleiadi kernel: CPA: page pool initialized 1 of 1 pages
preallocated
Apr 24 15:32:27 Pleiadi kernel: SLUB: Genslabs=12, HWalign=32,
Order=0-1, MinObjects=4, CPUs=1, Nodes=1
Apr 24 15:32:27 Pleiadi kernel: Calibrating delay using timer specific
routine.. 602.15 BogoMIPS (lpj=1204300)
Apr 24 15:32:27 Pleiadi kernel: Mount-cache hash table entries: 512
Apr 24 15:32:27 Pleiadi kernel: CPU: L1 I cache: 16K, L1 D cache: 16K
Apr 24 15:32:27 Pleiadi kernel: CPU: L2 cache: 128K
Apr 24 15:32:27 Pleiadi kernel: Compat vDSO mapped to ffffe000.
Apr 24 15:32:27 Pleiadi kernel: CPU: Intel Celeron (Mendocino) stepping
00
Apr 24 15:32:27 Pleiadi kernel: Checking 'hlt' instruction... OK.
Apr 24 15:32:27 Pleiadi kernel: Freeing SMP alternatives: 0k freed
Apr 24 15:32:27 Pleiadi kernel: ACPI: Core revision 20070126
Apr 24 15:32:27 Pleiadi kernel: ACPI Exception (tbxface-0629):
AE_NO_ACPI_TABLES, While loading namespace from ACPI tables [20070126]
Apr 24 15:32:27 Pleiadi kernel: ACPI: Unable to load the System
Description Tables
Apr 24 15:32:27 Pleiadi kernel: net_namespace: 444 bytes
Apr 24 15:32:27 Pleiadi kernel: NET: Registered protocol family 16
Apr 24 15:32:27 Pleiadi kernel: PCI: PCI BIOS revision 2.10 entry at
0xfda61, last bus=1
Apr 24 15:32:27 Pleiadi kernel: PCI: Using configuration type 1
Apr 24 15:32:27 Pleiadi kernel: Setting up standard PCI resources
Apr 24 15:32:27 Pleiadi kernel: ACPI: Interpreter disabled.
Apr 24 15:32:27 Pleiadi kernel: Linux Plug and Play Support v0.97 (c)
Adam Belay
Apr 24 15:32:27 Pleiadi kernel: pnp: PnP ACPI: disabled
Apr 24 15:32:27 Pleiadi kernel: PCI: Probing PCI hardware
Apr 24 15:32:27 Pleiadi kernel: PCI: Probing PCI hardware (bus 00)
Apr 24 15:32:27 Pleiadi kernel: * Found PM-Timer Bug on the chipset. Due
to workarounds for a bug,
Apr 24 15:32:27 Pleiadi kernel: * this clock source is slow. Consider
trying other clock sources
Apr 24 15:32:27 Pleiadi kernel: pci 0000:00:07.3: quirk: region
6100-613f claimed by PIIX4 ACPI
Apr 24 15:32:27 Pleiadi kernel: pci 0000:00:07.3: quirk: region
5f00-5f0f claimed by PIIX4 SMB
Apr 24 15:32:27 Pleiadi kernel: PCI: Using IRQ router PIIX/ICH
[8086/7110] at 0000:00:07.0
Apr 24 15:32:27 Pleiadi kernel: PCI: setting IRQ 11 as level-triggered
Apr 24 15:32:27 Pleiadi kernel: PCI: Found IRQ 11 for device
0000:00:07.2
Apr 24 15:32:27 Pleiadi kernel: PCI: Sharing IRQ 11 with 0000:00:0b.0
Apr 24 15:32:27 Pleiadi kernel: PCI: Bridge: 0000:00:01.0
Apr 24 15:32:27 Pleiadi kernel:   IO window: b000-bfff
Apr 24 15:32:27 Pleiadi kernel:   MEM window: 0xefe00000-0xefefffff
Apr 24 15:32:27 Pleiadi kernel:   PREFETCH window:
0x00000000e5c00000-0x00000000e7cfffff
Apr 24 15:32:27 Pleiadi kernel: NET: Registered protocol family 2
Apr 24 15:32:27 Pleiadi kernel: IP route cache hash table entries: 2048
(order: 1, 8192 bytes)
Apr 24 15:32:27 Pleiadi kernel: TCP established hash table entries: 8192
(order: 4, 65536 bytes)
Apr 24 15:32:27 Pleiadi kernel: TCP bind hash table entries: 8192
(order: 3, 32768 bytes)
Apr 24 15:32:27 Pleiadi kernel: TCP: Hash tables configured (established
8192 bind 8192)
Apr 24 15:32:27 Pleiadi kernel: TCP reno registered
Apr 24 15:32:27 Pleiadi kernel: SGI XFS with no debug enabled
Apr 24 15:32:27 Pleiadi kernel: io scheduler noop registered (default)
Apr 24 15:32:27 Pleiadi kernel: pci 0000:00:00.0: Limiting direct
PCI/PCI transfers
Apr 24 15:32:27 Pleiadi kernel: pci 0000:01:00.0: Boot video device
Apr 24 15:32:27 Pleiadi kernel: Serial: 8250/16550 driver $Revision:
1.90 $ 4 ports, IRQ sharing disabled
Apr 24 15:32:27 Pleiadi kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4)
is a 16550A
Apr 24 15:32:27 Pleiadi kernel: serial8250: ttyS1 at I/O 0x2f8 (irq = 3)
is a 16550A
Apr 24 15:32:27 Pleiadi kernel: Uniform Multi-Platform E-IDE driver
Apr 24 15:32:27 Pleiadi kernel: ide: Assuming 33MHz system bus speed for
PIO modes; override with idebus=xx
Apr 24 15:32:27 Pleiadi kernel: PIIX4: IDE controller (0x8086:0x7111 rev
0x01) at  PCI slot 0000:00:07.1
Apr 24 15:32:27 Pleiadi kernel: PIIX4: not 100%% native mode: will probe
irqs later
Apr 24 15:32:27 Pleiadi kernel:     ide0: BM-DMA at 0xffa0-0xffa7, BIOS
settings: hda:DMA, hdb:PIO
Apr 24 15:32:27 Pleiadi kernel:     ide1: BM-DMA at 0xffa8-0xffaf, BIOS
settings: hdc:DMA, hdd:PIO
Apr 24 15:32:27 Pleiadi kernel: Probing IDE interface ide0...
Apr 24 15:32:27 Pleiadi kernel: hda: QUANTUM FIREBALL EX4.3A, ATA DISK
drive
Apr 24 15:32:27 Pleiadi kernel: hda: host max PIO4 wanted
PIO255(auto-tune) selected PIO4
Apr 24 15:32:27 Pleiadi kernel: hda: UDMA/33 mode selected
Apr 24 15:32:27 Pleiadi kernel: Probing IDE interface ide1...
Apr 24 15:32:27 Pleiadi kernel: hdc: MATSHITA CR-588, ATAPI CD/DVD-ROM
drive
Apr 24 15:32:27 Pleiadi kernel: hdc: host max PIO4 wanted
PIO255(auto-tune) selected PIO4
Apr 24 15:32:27 Pleiadi kernel: hdc: MWDMA2 mode selected
Apr 24 15:32:27 Pleiadi kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Apr 24 15:32:27 Pleiadi kernel: ide1 at 0x170-0x177,0x376 on irq 15
Apr 24 15:32:27 Pleiadi kernel: hda: max request size: 128KiB
Apr 24 15:32:27 Pleiadi kernel: hda: 8405775 sectors (4303 MB) w/418KiB
Cache, CHS=8895/15/63
Apr 24 15:32:27 Pleiadi kernel: hda: cache flushes not supported
Apr 24 15:32:27 Pleiadi kernel:  hda: hda1 hda2 < hda5 hda6 hda7 hda8
hda9 >
Apr 24 15:32:27 Pleiadi kernel: PNP: No PS/2 controller found. Probing
ports directly.
Apr 24 15:32:27 Pleiadi kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Apr 24 15:32:27 Pleiadi kernel: serio: i8042 AUX port at 0x60,0x64 irq
12
Apr 24 15:32:27 Pleiadi kernel: mice: PS/2 mouse device common for all
mice
Apr 24 15:32:27 Pleiadi kernel: nf_conntrack version 0.5.0 (3072
buckets, 12288 max)
Apr 24 15:32:27 Pleiadi kernel: ip_tables: (C) 2000-2006 Netfilter Core
Team
Apr 24 15:32:27 Pleiadi kernel: TCP cubic registered
Apr 24 15:32:27 Pleiadi kernel: Initializing XFRM netlink socket
Apr 24 15:32:27 Pleiadi kernel: NET: Registered protocol family 1
Apr 24 15:32:27 Pleiadi kernel: NET: Registered protocol family 17
Apr 24 15:32:27 Pleiadi kernel: Clocksource tsc unstable (delta =
623988441 ns)
Apr 24 15:32:27 Pleiadi kernel: NET: Registered protocol family 15
Apr 24 15:32:27 Pleiadi kernel: Using IPI Shortcut mode
Apr 24 15:32:27 Pleiadi kernel: input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input0
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda1": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: XFS mounting filesystem hda1
Apr 24 15:32:27 Pleiadi kernel: Ending clean XFS mount for filesystem:
hda1
Apr 24 15:32:27 Pleiadi kernel: VFS: Mounted root (xfs filesystem)
readonly.
Apr 24 15:32:27 Pleiadi kernel: Freeing unused kernel memory: 184k freed
Apr 24 15:32:27 Pleiadi kernel: Adding 151160k swap on /dev/hda9.
Priority:-1 extents:1 across:151160k
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda1": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda1": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: PCI: setting IRQ 9 as level-triggered
Apr 24 15:32:27 Pleiadi kernel: PCI: Found IRQ 9 for device 0000:00:09.0
Apr 24 15:32:27 Pleiadi kernel: 3c59x: Donald Becker and others.
Apr 24 15:32:27 Pleiadi kernel: 0000:00:09.0: 3Com PCI 3c905 Boomerang
100baseTx at 0001de00.
Apr 24 15:32:27 Pleiadi kernel: PCI: setting IRQ 10 as level-triggered
Apr 24 15:32:27 Pleiadi kernel: PCI: Found IRQ 10 for device
0000:00:0a.0
Apr 24 15:32:27 Pleiadi kernel: 0000:00:0a.0: 3Com PCI 3c905 Boomerang
100baseTx at 0001dc00.
Apr 24 15:32:27 Pleiadi kernel: PCI: Found IRQ 11 for device
0000:00:0b.0
Apr 24 15:32:27 Pleiadi kernel: PCI: Sharing IRQ 11 with 0000:00:07.2
Apr 24 15:32:27 Pleiadi kernel: 0000:00:0b.0: 3Com PCI 3c905 Boomerang
100baseTx at 0001da00.
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda5": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: XFS mounting filesystem hda5
Apr 24 15:32:27 Pleiadi kernel: Ending clean XFS mount for filesystem:
hda5
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda6": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: XFS mounting filesystem hda6
Apr 24 15:32:27 Pleiadi kernel: Ending clean XFS mount for filesystem:
hda6
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda7": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: XFS mounting filesystem hda7
Apr 24 15:32:27 Pleiadi kernel: Ending clean XFS mount for filesystem:
hda7
Apr 24 15:32:27 Pleiadi kernel: Filesystem "hda8": Disabling barriers,
not supported by the underlying device
Apr 24 15:32:27 Pleiadi kernel: XFS mounting filesystem hda8
Apr 24 15:32:27 Pleiadi kernel: Ending clean XFS mount for filesystem:
hda8
Apr 24 15:32:27 Pleiadi kernel: eth0:  setting half-duplex.
Apr 24 15:32:27 Pleiadi kernel: eth1:  setting half-duplex.
Apr 24 15:32:27 Pleiadi kernel: eth2:  setting half-duplex.
Apr 24 15:33:15 Pleiadi kernel: eth2:  setting full-duplex.
Apr 24 15:33:25 Pleiadi kernel: eth0:  setting full-duplex.
Apr 24 15:33:35 Pleiadi kernel: eth1:  setting full-duplex.
Apr 24 18:33:03 Pleiadi kernel: conntrack_ftp: partial 227  745997273+46
Apr 24 18:33:37 Pleiadi last message repeated 5 times
Apr 24 18:34:12 Pleiadi kernel: conntrack_ftp: partial 227  745997273+46
Apr 24 18:34:49 Pleiadi kernel: conntrack_ftp: partial 227  759970722+48
Apr 24 18:35:13 Pleiadi last message repeated 5 times
Apr 24 18:35:23 Pleiadi kernel: conntrack_ftp: partial 227  745997273+46
Apr 24 18:35:38 Pleiadi kernel: conntrack_ftp: partial 227  759970722+48
Apr 24 18:36:28 Pleiadi kernel: conntrack_ftp: partial 227  759970722+48
Apr 24 18:37:23 Pleiadi kernel: conntrack_ftp: partial 227  745997273+46
Apr 24 18:38:08 Pleiadi kernel: conntrack_ftp: partial 227  759970722+48
Apr 24 18:39:23 Pleiadi kernel: conntrack_ftp: partial 227  745997273+46
Apr 24 18:40:08 Pleiadi kernel: conntrack_ftp: partial 227  759970722+48
May  5 12:57:46 Pleiadi kernel: ller+0xee/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c02c85ef>] tcp_prune_queue+0x5f/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c7d76>] tcp_data_queue+0x466/0x790
May  5 12:57:46 Pleiadi kernel:  [<c02c8cfc>]
tcp_rcv_established+0x15c/0x670
May  5 12:57:46 Pleiadi kernel:  [<c02cfd33>] tcp_v4_do_rcv+0xe3/0xf0
May  5 12:57:46 Pleiadi kernel:  [<c02d022f>] tcp_v4_rcv+0x4ef/0x5f0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a77>]
ip_local_deliver_finish+0x67/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5c27>] ip_local_deliver+0xb7/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a10>]
ip_local_deliver_finish+0x0/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 12:57:46 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 12:57:46 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 12:57:46 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 12:57:46 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 12:57:46 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 12:57:46 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 12:57:46 Pleiadi kernel:  =======================
May  5 12:57:46 Pleiadi kernel: Mem-info:
May  5 12:57:46 Pleiadi kernel: DMA per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 12:57:46 Pleiadi kernel: Normal per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  32
May  5 12:57:46 Pleiadi kernel: Active:29114 inactive:2898 dirty:45
writeback:37 unstable:0
May  5 12:57:46 Pleiadi kernel:  free:4303 slab:2277 mapped:565
pagetables:306 bounce:0
May  5 12:57:46 Pleiadi kernel: DMA free:2304kB min:160kB low:200kB
high:240kB active:8744kB inactive:804kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 12:57:46 Pleiadi kernel: Normal free:14908kB min:1448kB
low:1808kB high:2172kB active:107712kB inactive:10788kB present:146304kB
pages_scanned:271 all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 12:57:46 Pleiadi kernel: DMA: 442*4kB 61*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2304kB
May  5 12:57:46 Pleiadi kernel: Normal: 2773*4kB 399*8kB 33*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14908kB
May  5 12:57:46 Pleiadi kernel: 4540 total pagecache pages
May  5 12:57:46 Pleiadi kernel: Swap cache: add 1450893, delete 1447455,
find 102344/314120
May  5 12:57:46 Pleiadi kernel: Free swap  = 74868kB
May  5 12:57:46 Pleiadi kernel: Total swap = 151160kB
May  5 12:57:46 Pleiadi kernel: Free swap:        74868kB
May  5 12:57:46 Pleiadi kernel: 40960 pages of RAM
May  5 12:57:46 Pleiadi kernel: 0 pages of HIGHMEM
May  5 12:57:46 Pleiadi kernel: 1202 reserved pages
May  5 12:57:46 Pleiadi kernel: 7058 pages shared
May  5 12:57:46 Pleiadi kernel: 3438 pages swap cached
May  5 12:57:46 Pleiadi kernel: 45 pages dirty
May  5 12:57:46 Pleiadi kernel: 37 pages writeback
May  5 12:57:46 Pleiadi kernel: 565 pages mapped
May  5 12:57:46 Pleiadi kernel: 2277 pages slab
May  5 12:57:46 Pleiadi kernel: 306 pages pagetables
May  5 12:57:46 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 12:57:46 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 12:57:46 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 12:57:46 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c02c85ef>] tcp_prune_queue+0x5f/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c7d76>] tcp_data_queue+0x466/0x790
May  5 12:57:46 Pleiadi kernel:  [<c02c8cfc>]
tcp_rcv_established+0x15c/0x670
May  5 12:57:46 Pleiadi kernel:  [<c02cfd33>] tcp_v4_do_rcv+0xe3/0xf0
May  5 12:57:46 Pleiadi kernel:  [<c02d022f>] tcp_v4_rcv+0x4ef/0x5f0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a77>]
ip_local_deliver_finish+0x67/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5c27>] ip_local_deliver+0xb7/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a10>]
ip_local_deliver_finish+0x0/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 12:57:46 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 12:57:46 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 12:57:46 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 12:57:46 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 12:57:46 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 12:57:46 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 12:57:46 Pleiadi kernel:  =======================
May  5 12:57:46 Pleiadi kernel: Mem-info:
May  5 12:57:46 Pleiadi kernel: DMA per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 12:57:46 Pleiadi kernel: Normal per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  31
May  5 12:57:46 Pleiadi kernel: Active:29114 inactive:2898 dirty:45
writeback:37 unstable:0
May  5 12:57:46 Pleiadi kernel:  free:4303 slab:2277 mapped:565
pagetables:306 bounce:0
May  5 12:57:46 Pleiadi kernel: DMA free:2304kB min:160kB low:200kB
high:240kB active:8744kB inactive:804kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 12:57:46 Pleiadi kernel: Normal free:14908kB min:1448kB
low:1808kB high:2172kB active:107712kB inactive:10788kB present:146304kB
pages_scanned:271 all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 12:57:46 Pleiadi kernel: DMA: 442*4kB 61*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2304kB
May  5 12:57:46 Pleiadi kernel: Normal: 2773*4kB 399*8kB 33*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14908kB
May  5 12:57:46 Pleiadi kernel: 4540 total pagecache pages
May  5 12:57:46 Pleiadi kernel: Swap cache: add 1450893, delete 1447455,
find 102344/314120
May  5 12:57:46 Pleiadi kernel: Free swap  = 74868kB
May  5 12:57:46 Pleiadi kernel: Total swap = 151160kB
May  5 12:57:46 Pleiadi kernel: Free swap:        74868kB
May  5 12:57:46 Pleiadi kernel: 40960 pages of RAM
May  5 12:57:46 Pleiadi kernel: 0 pages of HIGHMEM
May  5 12:57:46 Pleiadi kernel: 1202 reserved pages
May  5 12:57:46 Pleiadi kernel: 7058 pages shared
May  5 12:57:46 Pleiadi kernel: 3438 pages swap cached
May  5 12:57:46 Pleiadi kernel: 45 pages dirty
May  5 12:57:46 Pleiadi kernel: 37 pages writeback
May  5 12:57:46 Pleiadi kernel: 565 pages mapped
May  5 12:57:46 Pleiadi kernel: 2277 pages slab
May  5 12:57:46 Pleiadi kernel: 306 pages pagetables
May  5 12:57:46 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 12:57:46 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 12:57:46 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 12:57:46 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c02c85ef>] tcp_prune_queue+0x5f/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c7d76>] tcp_data_queue+0x466/0x790
May  5 12:57:46 Pleiadi kernel:  [<c02c8cfc>]
tcp_rcv_established+0x15c/0x670
May  5 12:57:46 Pleiadi kernel:  [<c02cfd33>] tcp_v4_do_rcv+0xe3/0xf0
May  5 12:57:46 Pleiadi kernel:  [<c02d022f>] tcp_v4_rcv+0x4ef/0x5f0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a77>]
ip_local_deliver_finish+0x67/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5c27>] ip_local_deliver+0xb7/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a10>]
ip_local_deliver_finish+0x0/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 12:57:46 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 12:57:46 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 12:57:46 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 12:57:46 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 12:57:46 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 12:57:46 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 12:57:46 Pleiadi kernel:  =======================
May  5 12:57:46 Pleiadi kernel: Mem-info:
May  5 12:57:46 Pleiadi kernel: DMA per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 12:57:46 Pleiadi kernel: Normal per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  30
May  5 12:57:46 Pleiadi kernel: Active:29114 inactive:2898 dirty:45
writeback:37 unstable:0
May  5 12:57:46 Pleiadi kernel:  free:4303 slab:2277 mapped:565
pagetables:306 bounce:0
May  5 12:57:46 Pleiadi kernel: DMA free:2304kB min:160kB low:200kB
high:240kB active:8744kB inactive:804kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 12:57:46 Pleiadi kernel: Normal free:14908kB min:1448kB
low:1808kB high:2172kB active:107712kB inactive:10788kB present:146304kB
pages_scanned:271 all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 12:57:46 Pleiadi kernel: DMA: 442*4kB 61*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2304kB
May  5 12:57:46 Pleiadi kernel: Normal: 2773*4kB 399*8kB 33*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14908kB
May  5 12:57:46 Pleiadi kernel: 4540 total pagecache pages
May  5 12:57:46 Pleiadi kernel: Swap cache: add 1450893, delete 1447455,
find 102344/314120
May  5 12:57:46 Pleiadi kernel: Free swap  = 74868kB
May  5 12:57:46 Pleiadi kernel: Total swap = 151160kB
May  5 12:57:46 Pleiadi kernel: Free swap:        74868kB
May  5 12:57:46 Pleiadi kernel: 40960 pages of RAM
May  5 12:57:46 Pleiadi kernel: 0 pages of HIGHMEM
May  5 12:57:46 Pleiadi kernel: 1202 reserved pages
May  5 12:57:46 Pleiadi kernel: 7058 pages shared
May  5 12:57:46 Pleiadi kernel: 3438 pages swap cached
May  5 12:57:46 Pleiadi kernel: 45 pages dirty
May  5 12:57:46 Pleiadi kernel: 37 pages writeback
May  5 12:57:46 Pleiadi kernel: 565 pages mapped
May  5 12:57:46 Pleiadi kernel: 2277 pages slab
May  5 12:57:46 Pleiadi kernel: 306 pages pagetables
May  5 12:57:46 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 12:57:46 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 12:57:46 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 12:57:46 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c02c85ef>] tcp_prune_queue+0x5f/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c7d76>] tcp_data_queue+0x466/0x790
May  5 12:57:46 Pleiadi kernel:  [<c02c8cfc>]
tcp_rcv_established+0x15c/0x670
May  5 12:57:46 Pleiadi kernel:  [<c02cfd33>] tcp_v4_do_rcv+0xe3/0xf0
May  5 12:57:46 Pleiadi kernel:  [<c02d022f>] tcp_v4_rcv+0x4ef/0x5f0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a77>]
ip_local_deliver_finish+0x67/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5c27>] ip_local_deliver+0xb7/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a10>]
ip_local_deliver_finish+0x0/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 12:57:46 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 12:57:46 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 12:57:46 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 12:57:46 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 12:57:46 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 12:57:46 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 12:57:46 Pleiadi kernel:  =======================
May  5 12:57:46 Pleiadi kernel: Mem-info:
May  5 12:57:46 Pleiadi kernel: DMA per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 12:57:46 Pleiadi kernel: Normal per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  29
May  5 12:57:46 Pleiadi kernel: Active:29114 inactive:2898 dirty:45
writeback:37 unstable:0
May  5 12:57:46 Pleiadi kernel:  free:4303 slab:2277 mapped:565
pagetables:306 bounce:0
May  5 12:57:46 Pleiadi kernel: DMA free:2304kB min:160kB low:200kB
high:240kB active:8744kB inactive:804kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 12:57:46 Pleiadi kernel: Normal free:14908kB min:1448kB
low:1808kB high:2172kB active:107712kB inactive:10788kB present:146304kB
pages_scanned:271 all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 12:57:46 Pleiadi kernel: DMA: 442*4kB 61*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2304kB
May  5 12:57:46 Pleiadi kernel: Normal: 2773*4kB 399*8kB 33*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14908kB
May  5 12:57:46 Pleiadi kernel: 4540 total pagecache pages
May  5 12:57:46 Pleiadi kernel: Swap cache: add 1450893, delete 1447455,
find 102344/314120
May  5 12:57:46 Pleiadi kernel: Free swap  = 74868kB
May  5 12:57:46 Pleiadi kernel: Total swap = 151160kB
May  5 12:57:46 Pleiadi kernel: Free swap:        74868kB
May  5 12:57:46 Pleiadi kernel: 40960 pages of RAM
May  5 12:57:46 Pleiadi kernel: 0 pages of HIGHMEM
May  5 12:57:46 Pleiadi kernel: 1202 reserved pages
May  5 12:57:46 Pleiadi kernel: 7058 pages shared
May  5 12:57:46 Pleiadi kernel: 3438 pages swap cached
May  5 12:57:46 Pleiadi kernel: 45 pages dirty
May  5 12:57:46 Pleiadi kernel: 37 pages writeback
May  5 12:57:46 Pleiadi kernel: 565 pages mapped
May  5 12:57:46 Pleiadi kernel: 2277 pages slab
May  5 12:57:46 Pleiadi kernel: 306 pages pagetables
May  5 12:57:46 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 12:57:46 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 12:57:46 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 12:57:46 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c02c85ef>] tcp_prune_queue+0x5f/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c7d76>] tcp_data_queue+0x466/0x790
May  5 12:57:46 Pleiadi kernel:  [<c02c8cfc>]
tcp_rcv_established+0x15c/0x670
May  5 12:57:46 Pleiadi kernel:  [<c02cfd33>] tcp_v4_do_rcv+0xe3/0xf0
May  5 12:57:46 Pleiadi kernel:  [<c02d022f>] tcp_v4_rcv+0x4ef/0x5f0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a77>]
ip_local_deliver_finish+0x67/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5c27>] ip_local_deliver+0xb7/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a10>]
ip_local_deliver_finish+0x0/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 12:57:46 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 12:57:46 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 12:57:46 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 12:57:46 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 12:57:46 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 12:57:46 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 12:57:46 Pleiadi kernel:  =======================
May  5 12:57:46 Pleiadi kernel: Mem-info:
May  5 12:57:46 Pleiadi kernel: DMA per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 12:57:46 Pleiadi kernel: Normal per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  28
May  5 12:57:46 Pleiadi kernel: Active:29114 inactive:2898 dirty:45
writeback:37 unstable:0
May  5 12:57:46 Pleiadi kernel:  free:4303 slab:2277 mapped:565
pagetables:306 bounce:0
May  5 12:57:46 Pleiadi kernel: DMA free:2304kB min:160kB low:200kB
high:240kB active:8744kB inactive:804kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 12:57:46 Pleiadi kernel: Normal free:14908kB min:1448kB
low:1808kB high:2172kB active:107712kB inactive:10788kB present:146304kB
pages_scanned:271 all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 12:57:46 Pleiadi kernel: DMA: 442*4kB 61*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2304kB
May  5 12:57:46 Pleiadi kernel: Normal: 2773*4kB 399*8kB 33*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14908kB
May  5 12:57:46 Pleiadi kernel: 4540 total pagecache pages
May  5 12:57:46 Pleiadi kernel: Swap cache: add 1450893, delete 1447455,
find 102344/314120
May  5 12:57:46 Pleiadi kernel: Free swap  = 74868kB
May  5 12:57:46 Pleiadi kernel: Total swap = 151160kB
May  5 12:57:46 Pleiadi kernel: Free swap:        74868kB
May  5 12:57:46 Pleiadi kernel: 40960 pages of RAM
May  5 12:57:46 Pleiadi kernel: 0 pages of HIGHMEM
May  5 12:57:46 Pleiadi kernel: 1202 reserved pages
May  5 12:57:46 Pleiadi kernel: 7058 pages shared
May  5 12:57:46 Pleiadi kernel: 3438 pages swap cached
May  5 12:57:46 Pleiadi kernel: 45 pages dirty
May  5 12:57:46 Pleiadi kernel: 37 pages writeback
May  5 12:57:46 Pleiadi kernel: 565 pages mapped
May  5 12:57:46 Pleiadi kernel: 2277 pages slab
May  5 12:57:46 Pleiadi kernel: 306 pages pagetables
May  5 12:57:46 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 12:57:46 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 12:57:46 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 12:57:46 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c820c>] tcp_collapse+0x16c/0x3a0
May  5 12:57:46 Pleiadi kernel:  [<c02c85ef>] tcp_prune_queue+0x5f/0x110
May  5 12:57:46 Pleiadi kernel:  [<c02c7d76>] tcp_data_queue+0x466/0x790
May  5 12:57:46 Pleiadi kernel:  [<c02c8cfc>]
tcp_rcv_established+0x15c/0x670
May  5 12:57:46 Pleiadi kernel:  [<c02cfd33>] tcp_v4_do_rcv+0xe3/0xf0
May  5 12:57:46 Pleiadi kernel:  [<c02d022f>] tcp_v4_rcv+0x4ef/0x5f0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a77>]
ip_local_deliver_finish+0x67/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5c27>] ip_local_deliver+0xb7/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c02b5a10>]
ip_local_deliver_finish+0x0/0x160
May  5 12:57:46 Pleiadi kernel:  [<c02b5cef>] ip_rcv_finish+0xbf/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 12:57:46 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 12:57:46 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 12:57:46 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 12:57:46 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 12:57:46 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 12:57:46 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 12:57:46 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 12:57:46 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 12:57:46 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 12:57:46 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 12:57:46 Pleiadi kernel:  =======================
May  5 12:57:46 Pleiadi kernel: Mem-info:
May  5 12:57:46 Pleiadi kernel: DMA per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 12:57:46 Pleiadi kernel: Normal per-cpu:
May  5 12:57:46 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  27
May  5 12:57:46 Pleiadi kernel: Active:29114 inactive:2898 dirty:45
writeback:37 unstable:0
May  5 12:57:46 Pleiadi kernel:  free:4303 slab:2277 mapped:565
pagetables:306 bounce:0
May  5 12:57:46 Pleiadi kernel: DMA free:2304kB min:160kB low:200kB
high:240kB active:8744kB inactive:804kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 12:57:46 Pleiadi kernel: Normal free:14908kB min:1448kB
low:1808kB high:2172kB active:107712kB inactive:10788kB present:146304kB
pages_scanned:271 all_unreclaimable? no
May  5 12:57:46 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 12:57:46 Pleiadi kernel: DMA: 442*4kB 61*8kB 1*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2304kB
May  5 12:57:46 Pleiadi kernel: Normal: 2773*4kB 399*8kB 33*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 14908kB
May  5 12:57:46 Pleiadi kernel: 4540 total pagecache pages
May  5 12:57:46 Pleiadi kernel: Swap cache: add 1450893, delete 1447455,
find 102344/314120
May  5 12:57:46 Pleiadi kernel: Free swap  = 74868kB
May  5 12:57:46 Pleiadi kernel: Total swap = 151160kB
May  5 12:57:46 Pleiadi kernel: Free swap:        74868kB
May  5 12:57:46 Pleiadi kernel: 40960 pages of RAM
May  5 12:57:46 Pleiadi kernel: 0 pages of HIGHMEM
May  5 12:57:46 Pleiadi kernel: 1202 reserved pages
May  5 12:57:46 Pleiadi kernel: 7058 pages shared
May  5 12:57:46 Pleiadi kernel: 3438 pages swap cached
May  5 12:57:46 Pleiadi kernel: 45 pages dirty
May  5 12:57:46 Pleiadi kernel: 37 pages writeback
May  5 12:57:46 Pleiadi kernel: 565 pages mapped
May  5 12:57:46 Pleiadi kernel: 2277 pages slab
May  5 12:57:46 Pleiadi kernel: 306 pages pagetables
May  5 13:03:41 Pleiadi kernel: o_IRQ+0x3c/0x70
May  5 13:03:41 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:41 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:41 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:41 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:41 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:41 Pleiadi kernel:  =======================
May  5 13:03:41 Pleiadi kernel: Mem-info:
May  5 13:03:41 Pleiadi kernel: DMA per-cpu:
May  5 13:03:41 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:41 Pleiadi kernel: Normal per-cpu:
May  5 13:03:41 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  38
May  5 13:03:41 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2644 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8504kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1630*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8504kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:03:43 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:03:43 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:03:43 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c01185ad>] profile_tick+0x4d/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:03:43 Pleiadi kernel:  [<c015709a>]
__kmalloc_track_caller+0x5a/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:43 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:43 Pleiadi kernel:  =======================
May  5 13:03:43 Pleiadi kernel: Mem-info:
May  5 13:03:43 Pleiadi kernel: DMA per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:43 Pleiadi kernel: Normal per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  37
May  5 13:03:43 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2644 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8504kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1630*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8504kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:03:43 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:03:43 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:03:43 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c01185ad>] profile_tick+0x4d/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:03:43 Pleiadi kernel:  [<c015709a>]
__kmalloc_track_caller+0x5a/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:43 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:43 Pleiadi kernel:  =======================
May  5 13:03:43 Pleiadi kernel: Mem-info:
May  5 13:03:43 Pleiadi kernel: DMA per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:43 Pleiadi kernel: Normal per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  36
May  5 13:03:43 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2644 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8504kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1630*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8504kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:03:43 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:03:43 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:03:43 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:03:43 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:43 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:43 Pleiadi kernel:  =======================
May  5 13:03:43 Pleiadi kernel: Mem-info:
May  5 13:03:43 Pleiadi kernel: DMA per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:43 Pleiadi kernel: Normal per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  35
May  5 13:03:43 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2644 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8504kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1630*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8504kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:03:43 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:03:43 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:03:43 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:03:43 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:43 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:43 Pleiadi kernel:  =======================
May  5 13:03:43 Pleiadi kernel: Mem-info:
May  5 13:03:43 Pleiadi kernel: DMA per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:43 Pleiadi kernel: Normal per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  34
May  5 13:03:43 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2644 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8504kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1630*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8504kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:03:43 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:03:43 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:03:43 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:03:43 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:43 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:43 Pleiadi kernel:  =======================
May  5 13:03:43 Pleiadi kernel: Mem-info:
May  5 13:03:43 Pleiadi kernel: DMA per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:43 Pleiadi kernel: Normal per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  33
May  5 13:03:43 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2644 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8504kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1630*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8504kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:03:43 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:03:43 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:03:43 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:03:43 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:03:43 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:03:43 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:03:43 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:03:43 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:03:43 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:03:43 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:03:43 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:03:43 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:03:43 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:03:43 Pleiadi kernel:  =======================
May  5 13:03:43 Pleiadi kernel: Mem-info:
May  5 13:03:43 Pleiadi kernel: DMA per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:03:43 Pleiadi kernel: Normal per-cpu:
May  5 13:03:43 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  39
May  5 13:03:43 Pleiadi kernel: Active:30111 inactive:3524 dirty:409
writeback:365 unstable:0
May  5 13:03:43 Pleiadi kernel:  free:2637 slab:2308 mapped:515
pagetables:306 bounce:0
May  5 13:03:43 Pleiadi kernel: DMA free:2072kB min:160kB low:200kB
high:240kB active:8868kB inactive:884kB present:16256kB
pages_scanned:177 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:03:43 Pleiadi kernel: Normal free:8476kB min:1448kB low:1808kB
high:2172kB active:111576kB inactive:13212kB present:146304kB
pages_scanned:0 all_unreclaimable? no
May  5 13:03:43 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:03:43 Pleiadi kernel: DMA: 358*4kB 72*8kB 2*16kB 1*32kB 0*64kB
0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
May  5 13:03:43 Pleiadi kernel: Normal: 1623*4kB 196*8kB 20*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8476kB
May  5 13:03:43 Pleiadi kernel: 6609 total pagecache pages
May  5 13:03:43 Pleiadi kernel: Swap cache: add 1466771, delete 1462564,
find 103318/317453
May  5 13:03:43 Pleiadi kernel: Free swap  = 72820kB
May  5 13:03:43 Pleiadi kernel: Total swap = 151160kB
May  5 13:03:43 Pleiadi kernel: Free swap:        72820kB
May  5 13:03:43 Pleiadi kernel: 40960 pages of RAM
May  5 13:03:43 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:03:43 Pleiadi kernel: 1202 reserved pages
May  5 13:03:43 Pleiadi kernel: 7601 pages shared
May  5 13:03:43 Pleiadi kernel: 4207 pages swap cached
May  5 13:03:43 Pleiadi kernel: 409 pages dirty
May  5 13:03:43 Pleiadi kernel: 365 pages writeback
May  5 13:03:43 Pleiadi kernel: 515 pages mapped
May  5 13:03:43 Pleiadi kernel: 2308 pages slab
May  5 13:03:43 Pleiadi kernel: 306 pages pagetables
May  5 13:04:12 Pleiadi kernel: printk: 807 messages suppressed.
May  5 13:04:12 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:04:12 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:04:12 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:04:12 Pleiadi kernel:  [<c0276fbf>] ide_build_sglist+0x6f/0xa0
May  5 13:04:12 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:12 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:04:12 Pleiadi kernel:  [<c02771b0>] dma_timer_expiry+0x0/0x80
May  5 13:04:12 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:04:12 Pleiadi kernel:  [<c0277471>] ide_dma_start+0x21/0x40
May  5 13:04:12 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:12 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:04:12 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:15 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:15 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:15 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:04:15 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:15 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:15 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:15 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:15 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:15 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:04:15 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:04:15 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:04:16 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:04:16 Pleiadi kernel:  =======================
May  5 13:04:16 Pleiadi kernel: Mem-info:
May  5 13:04:16 Pleiadi kernel: DMA per-cpu:
May  5 13:04:16 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:04:16 Pleiadi kernel: Normal per-cpu:
May  5 13:04:16 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  37
May  5 13:04:16 Pleiadi kernel: Active:28060 inactive:3389 dirty:106
writeback:595 unstable:0
May  5 13:04:16 Pleiadi kernel:  free:4718 slab:2424 mapped:495
pagetables:306 bounce:0
May  5 13:04:16 Pleiadi kernel: DMA free:3836kB min:160kB low:200kB
high:240kB active:6968kB inactive:664kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:04:16 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:04:16 Pleiadi kernel: Normal free:15036kB min:1448kB
low:1808kB high:2172kB active:105272kB inactive:12892kB present:146304kB
pages_scanned:159 all_unreclaimable? no
May  5 13:04:16 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:04:16 Pleiadi kernel: DMA: 573*4kB 155*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3836kB
May  5 13:04:16 Pleiadi kernel: Normal: 3123*4kB 246*8kB 30*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15036kB
May  5 13:04:17 Pleiadi kernel: 6318 total pagecache pages
May  5 13:04:17 Pleiadi kernel: Swap cache: add 1473369, delete 1468506,
find 103801/318581
May  5 13:04:17 Pleiadi kernel: Free swap  = 65016kB
May  5 13:04:17 Pleiadi kernel: Total swap = 151160kB
May  5 13:04:17 Pleiadi kernel: Free swap:        65016kB
May  5 13:04:17 Pleiadi kernel: 40960 pages of RAM
May  5 13:04:17 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:04:17 Pleiadi kernel: 1202 reserved pages
May  5 13:04:17 Pleiadi kernel: 5804 pages shared
May  5 13:04:17 Pleiadi kernel: 4863 pages swap cached
May  5 13:04:17 Pleiadi kernel: 106 pages dirty
May  5 13:04:17 Pleiadi kernel: 595 pages writeback
May  5 13:04:17 Pleiadi kernel: 495 pages mapped
May  5 13:04:17 Pleiadi kernel: 2424 pages slab
May  5 13:04:17 Pleiadi kernel: 306 pages pagetables
May  5 13:04:17 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:04:17 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:04:17 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:04:17 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:04:17 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:04:17 Pleiadi kernel:  =======================
May  5 13:04:17 Pleiadi kernel: Mem-info:
May  5 13:04:17 Pleiadi kernel: DMA per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:04:17 Pleiadi kernel: Normal per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  36
May  5 13:04:17 Pleiadi kernel: Active:28060 inactive:3389 dirty:106
writeback:595 unstable:0
May  5 13:04:17 Pleiadi kernel:  free:4718 slab:2424 mapped:495
pagetables:306 bounce:0
May  5 13:04:17 Pleiadi kernel: DMA free:3836kB min:160kB low:200kB
high:240kB active:6968kB inactive:664kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:04:17 Pleiadi kernel: Normal free:15036kB min:1448kB
low:1808kB high:2172kB active:105272kB inactive:12892kB present:146304kB
pages_scanned:159 all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:04:17 Pleiadi kernel: DMA: 573*4kB 155*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3836kB
May  5 13:04:17 Pleiadi kernel: Normal: 3123*4kB 246*8kB 30*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15036kB
May  5 13:04:17 Pleiadi kernel: 6318 total pagecache pages
May  5 13:04:17 Pleiadi kernel: Swap cache: add 1473369, delete 1468506,
find 103801/318581
May  5 13:04:17 Pleiadi kernel: Free swap  = 65016kB
May  5 13:04:17 Pleiadi kernel: Total swap = 151160kB
May  5 13:04:17 Pleiadi kernel: Free swap:        65016kB
May  5 13:04:17 Pleiadi kernel: 40960 pages of RAM
May  5 13:04:17 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:04:17 Pleiadi kernel: 1202 reserved pages
May  5 13:04:17 Pleiadi kernel: 5804 pages shared
May  5 13:04:17 Pleiadi kernel: 4863 pages swap cached
May  5 13:04:17 Pleiadi kernel: 106 pages dirty
May  5 13:04:17 Pleiadi kernel: 595 pages writeback
May  5 13:04:17 Pleiadi kernel: 495 pages mapped
May  5 13:04:17 Pleiadi kernel: 2424 pages slab
May  5 13:04:17 Pleiadi kernel: 306 pages pagetables
May  5 13:04:17 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:04:17 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:04:17 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:04:17 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:04:17 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:04:17 Pleiadi kernel:  =======================
May  5 13:04:17 Pleiadi kernel: Mem-info:
May  5 13:04:17 Pleiadi kernel: DMA per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:04:17 Pleiadi kernel: Normal per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  35
May  5 13:04:17 Pleiadi kernel: Active:28060 inactive:3389 dirty:106
writeback:595 unstable:0
May  5 13:04:17 Pleiadi kernel:  free:4718 slab:2424 mapped:495
pagetables:306 bounce:0
May  5 13:04:17 Pleiadi kernel: DMA free:3836kB min:160kB low:200kB
high:240kB active:6968kB inactive:664kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:04:17 Pleiadi kernel: Normal free:15036kB min:1448kB
low:1808kB high:2172kB active:105272kB inactive:12892kB present:146304kB
pages_scanned:159 all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:04:17 Pleiadi kernel: DMA: 573*4kB 155*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3836kB
May  5 13:04:17 Pleiadi kernel: Normal: 3123*4kB 246*8kB 30*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15036kB
May  5 13:04:17 Pleiadi kernel: 6318 total pagecache pages
May  5 13:04:17 Pleiadi kernel: Swap cache: add 1473369, delete 1468506,
find 103801/318581
May  5 13:04:17 Pleiadi kernel: Free swap  = 65016kB
May  5 13:04:17 Pleiadi kernel: Total swap = 151160kB
May  5 13:04:17 Pleiadi kernel: Free swap:        65016kB
May  5 13:04:17 Pleiadi kernel: 40960 pages of RAM
May  5 13:04:17 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:04:17 Pleiadi kernel: 1202 reserved pages
May  5 13:04:17 Pleiadi kernel: 5804 pages shared
May  5 13:04:17 Pleiadi kernel: 4863 pages swap cached
May  5 13:04:17 Pleiadi kernel: 106 pages dirty
May  5 13:04:17 Pleiadi kernel: 595 pages writeback
May  5 13:04:17 Pleiadi kernel: 495 pages mapped
May  5 13:04:17 Pleiadi kernel: 2424 pages slab
May  5 13:04:17 Pleiadi kernel: 306 pages pagetables
May  5 13:04:17 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:04:17 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:04:17 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:04:17 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 13:04:17 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:04:17 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:04:17 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:04:17 Pleiadi kernel:  =======================
May  5 13:04:17 Pleiadi kernel: Mem-info:
May  5 13:04:17 Pleiadi kernel: DMA per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:04:17 Pleiadi kernel: Normal per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  35
May  5 13:04:17 Pleiadi kernel: Active:28010 inactive:3372 dirty:106
writeback:521 unstable:0
May  5 13:04:17 Pleiadi kernel:  free:4781 slab:2427 mapped:495
pagetables:306 bounce:0
May  5 13:04:17 Pleiadi kernel: DMA free:3836kB min:160kB low:200kB
high:240kB active:6968kB inactive:664kB present:16256kB pages_scanned:38
all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:04:17 Pleiadi kernel: Normal free:15288kB min:1448kB
low:1808kB high:2172kB active:105072kB inactive:12824kB present:146304kB
pages_scanned:154 all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:04:17 Pleiadi kernel: DMA: 573*4kB 155*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3836kB
May  5 13:04:17 Pleiadi kernel: Normal: 3144*4kB 259*8kB 34*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15288kB
May  5 13:04:17 Pleiadi kernel: 6251 total pagecache pages
May  5 13:04:17 Pleiadi kernel: Swap cache: add 1473369, delete 1468572,
find 103801/318581
May  5 13:04:17 Pleiadi kernel: Free swap  = 65016kB
May  5 13:04:17 Pleiadi kernel: Total swap = 151160kB
May  5 13:04:17 Pleiadi kernel: Free swap:        65016kB
May  5 13:04:17 Pleiadi kernel: 40960 pages of RAM
May  5 13:04:17 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:04:17 Pleiadi kernel: 1202 reserved pages
May  5 13:04:17 Pleiadi kernel: 5804 pages shared
May  5 13:04:17 Pleiadi kernel: 4797 pages swap cached
May  5 13:04:17 Pleiadi kernel: 106 pages dirty
May  5 13:04:17 Pleiadi kernel: 521 pages writeback
May  5 13:04:17 Pleiadi kernel: 495 pages mapped
May  5 13:04:17 Pleiadi kernel: 2427 pages slab
May  5 13:04:17 Pleiadi kernel: 306 pages pagetables
May  5 13:04:17 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:04:17 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:04:17 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:04:17 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c015709a>]
__kmalloc_track_caller+0x5a/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 13:04:17 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:04:17 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:04:17 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:04:17 Pleiadi kernel:  =======================
May  5 13:04:17 Pleiadi kernel: Mem-info:
May  5 13:04:17 Pleiadi kernel: DMA per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:04:17 Pleiadi kernel: Normal per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  34
May  5 13:04:17 Pleiadi kernel: Active:28010 inactive:3372 dirty:106
writeback:489 unstable:0
May  5 13:04:17 Pleiadi kernel:  free:4781 slab:2427 mapped:495
pagetables:306 bounce:0
May  5 13:04:17 Pleiadi kernel: DMA free:3836kB min:160kB low:200kB
high:240kB active:6968kB inactive:664kB present:16256kB pages_scanned:38
all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:04:17 Pleiadi kernel: Normal free:15288kB min:1448kB
low:1808kB high:2172kB active:105072kB inactive:12824kB present:146304kB
pages_scanned:154 all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:04:17 Pleiadi kernel: DMA: 573*4kB 155*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3836kB
May  5 13:04:17 Pleiadi kernel: Normal: 3144*4kB 259*8kB 34*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15288kB
May  5 13:04:17 Pleiadi kernel: 6251 total pagecache pages
May  5 13:04:17 Pleiadi kernel: Swap cache: add 1473369, delete 1468572,
find 103801/318581
May  5 13:04:17 Pleiadi kernel: Free swap  = 65016kB
May  5 13:04:17 Pleiadi kernel: Total swap = 151160kB
May  5 13:04:17 Pleiadi kernel: Free swap:        65016kB
May  5 13:04:17 Pleiadi kernel: 40960 pages of RAM
May  5 13:04:17 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:04:17 Pleiadi kernel: 1202 reserved pages
May  5 13:04:17 Pleiadi kernel: 5804 pages shared
May  5 13:04:17 Pleiadi kernel: 4797 pages swap cached
May  5 13:04:17 Pleiadi kernel: 106 pages dirty
May  5 13:04:17 Pleiadi kernel: 489 pages writeback
May  5 13:04:17 Pleiadi kernel: 495 pages mapped
May  5 13:04:17 Pleiadi kernel: 2427 pages slab
May  5 13:04:17 Pleiadi kernel: 306 pages pagetables
May  5 13:04:17 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:04:17 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:04:17 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:04:17 Pleiadi kernel:  [<c027007b>]
try_to_flush_leftover_data+0x4b/0x90
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c015709a>]
__kmalloc_track_caller+0x5a/0x100
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:04:17 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c02b6092>] ip_rcv+0x182/0x260
May  5 13:04:17 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:04:17 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 13:04:17 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:04:17 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 13:04:17 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:04:17 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:04:17 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:04:17 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:04:17 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:04:17 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:04:17 Pleiadi kernel:  =======================
May  5 13:04:17 Pleiadi kernel: Mem-info:
May  5 13:04:17 Pleiadi kernel: DMA per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:04:17 Pleiadi kernel: Normal per-cpu:
May  5 13:04:17 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  33
May  5 13:04:17 Pleiadi kernel: Active:28010 inactive:3372 dirty:106
writeback:488 unstable:0
May  5 13:04:17 Pleiadi kernel:  free:4781 slab:2427 mapped:495
pagetables:306 bounce:0
May  5 13:04:17 Pleiadi kernel: DMA free:3836kB min:160kB low:200kB
high:240kB active:6968kB inactive:664kB present:16256kB pages_scanned:38
all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:04:17 Pleiadi kernel: Normal free:15288kB min:1448kB
low:1808kB high:2172kB active:105072kB inactive:12824kB present:146304kB
pages_scanned:154 all_unreclaimable? no
May  5 13:04:17 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:04:17 Pleiadi kernel: DMA: 573*4kB 155*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3836kB
May  5 13:04:17 Pleiadi kernel: Normal: 3144*4kB 259*8kB 34*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 15288kB
May  5 13:04:17 Pleiadi kernel: 6251 total pagecache pages
May  5 13:04:17 Pleiadi kernel: Swap cache: add 1473369, delete 1468572,
find 103801/318581
May  5 13:04:17 Pleiadi kernel: Free swap  = 65016kB
May  5 13:04:17 Pleiadi kernel: Total swap = 151160kB
May  5 13:04:17 Pleiadi kernel: Free swap:        65016kB
May  5 13:04:17 Pleiadi kernel: 40960 pages of RAM
May  5 13:04:17 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:04:17 Pleiadi kernel: 1202 reserved pages
May  5 13:04:17 Pleiadi kernel: 5804 pages shared
May  5 13:04:17 Pleiadi kernel: 4797 pages swap cached
May  5 13:04:17 Pleiadi kernel: 106 pages dirty
May  5 13:04:17 Pleiadi kernel: 488 pages writeback
May  5 13:04:17 Pleiadi kernel: 495 pages mapped
May  5 13:04:17 Pleiadi kernel: 2427 pages slab
May  5 13:04:17 Pleiadi kernel: 306 pages pagetables
May  5 13:05:25 Pleiadi kernel:
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:05:25 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:05:25 Pleiadi kernel:  =======================
May  5 13:05:25 Pleiadi kernel: Mem-info:
May  5 13:05:25 Pleiadi kernel: DMA per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:05:25 Pleiadi kernel: Normal per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  43
May  5 13:05:25 Pleiadi kernel: Active:26067 inactive:1579 dirty:0
writeback:1 unstable:0
May  5 13:05:25 Pleiadi kernel:  free:8464 slab:2471 mapped:484
pagetables:306 bounce:0
May  5 13:05:25 Pleiadi kernel: DMA free:4264kB min:160kB low:200kB
high:240kB active:6632kB inactive:396kB present:16256kB
pages_scanned:139 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:05:25 Pleiadi kernel: Normal free:29592kB min:1448kB
low:1808kB high:2172kB active:97636kB inactive:5920kB present:146304kB
pages_scanned:337 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:05:25 Pleiadi kernel: DMA: 612*4kB 169*8kB 27*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4264kB
May  5 13:05:25 Pleiadi kernel: Normal: 4946*4kB 1010*8kB 102*16kB
1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
29592kB
May  5 13:05:25 Pleiadi kernel: 2651 total pagecache pages
May  5 13:05:25 Pleiadi kernel: Swap cache: add 1483073, delete 1480994,
find 104928/321161
May  5 13:05:25 Pleiadi kernel: Free swap  = 64396kB
May  5 13:05:25 Pleiadi kernel: Total swap = 151160kB
May  5 13:05:25 Pleiadi kernel: Free swap:        64396kB
May  5 13:05:25 Pleiadi kernel: 40960 pages of RAM
May  5 13:05:25 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:05:25 Pleiadi kernel: 1202 reserved pages
May  5 13:05:25 Pleiadi kernel: 4945 pages shared
May  5 13:05:25 Pleiadi kernel: 2079 pages swap cached
May  5 13:05:25 Pleiadi kernel: 0 pages dirty
May  5 13:05:25 Pleiadi kernel: 1 pages writeback
May  5 13:05:25 Pleiadi kernel: 484 pages mapped
May  5 13:05:25 Pleiadi kernel: 2471 pages slab
May  5 13:05:25 Pleiadi kernel: 306 pages pagetables
May  5 13:05:25 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:05:25 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:05:25 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:05:25 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:05:25 Pleiadi kernel:  =======================
May  5 13:05:25 Pleiadi kernel: Mem-info:
May  5 13:05:25 Pleiadi kernel: DMA per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:05:25 Pleiadi kernel: Normal per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  42
May  5 13:05:25 Pleiadi kernel: Active:26067 inactive:1579 dirty:0
writeback:1 unstable:0
May  5 13:05:25 Pleiadi kernel:  free:8464 slab:2471 mapped:484
pagetables:306 bounce:0
May  5 13:05:25 Pleiadi kernel: DMA free:4264kB min:160kB low:200kB
high:240kB active:6632kB inactive:396kB present:16256kB
pages_scanned:139 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:05:25 Pleiadi kernel: Normal free:29592kB min:1448kB
low:1808kB high:2172kB active:97636kB inactive:5920kB present:146304kB
pages_scanned:337 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:05:25 Pleiadi kernel: DMA: 612*4kB 169*8kB 27*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4264kB
May  5 13:05:25 Pleiadi kernel: Normal: 4946*4kB 1010*8kB 102*16kB
1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
29592kB
May  5 13:05:25 Pleiadi kernel: 2651 total pagecache pages
May  5 13:05:25 Pleiadi kernel: Swap cache: add 1483073, delete 1480994,
find 104928/321161
May  5 13:05:25 Pleiadi kernel: Free swap  = 64396kB
May  5 13:05:25 Pleiadi kernel: Total swap = 151160kB
May  5 13:05:25 Pleiadi kernel: Free swap:        64396kB
May  5 13:05:25 Pleiadi kernel: 40960 pages of RAM
May  5 13:05:25 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:05:25 Pleiadi kernel: 1202 reserved pages
May  5 13:05:25 Pleiadi kernel: 4945 pages shared
May  5 13:05:25 Pleiadi kernel: 2079 pages swap cached
May  5 13:05:25 Pleiadi kernel: 0 pages dirty
May  5 13:05:25 Pleiadi kernel: 1 pages writeback
May  5 13:05:25 Pleiadi kernel: 484 pages mapped
May  5 13:05:25 Pleiadi kernel: 2471 pages slab
May  5 13:05:25 Pleiadi kernel: 306 pages pagetables
May  5 13:05:25 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:05:25 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:05:25 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:05:25 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:05:25 Pleiadi kernel:  =======================
May  5 13:05:25 Pleiadi kernel: Mem-info:
May  5 13:05:25 Pleiadi kernel: DMA per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:05:25 Pleiadi kernel: Normal per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  41
May  5 13:05:25 Pleiadi kernel: Active:26067 inactive:1579 dirty:0
writeback:0 unstable:0
May  5 13:05:25 Pleiadi kernel:  free:8464 slab:2471 mapped:484
pagetables:306 bounce:0
May  5 13:05:25 Pleiadi kernel: DMA free:4264kB min:160kB low:200kB
high:240kB active:6632kB inactive:396kB present:16256kB
pages_scanned:139 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:05:25 Pleiadi kernel: Normal free:29592kB min:1448kB
low:1808kB high:2172kB active:97636kB inactive:5920kB present:146304kB
pages_scanned:337 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:05:25 Pleiadi kernel: DMA: 612*4kB 169*8kB 27*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4264kB
May  5 13:05:25 Pleiadi kernel: Normal: 4946*4kB 1010*8kB 102*16kB
1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
29592kB
May  5 13:05:25 Pleiadi kernel: 2651 total pagecache pages
May  5 13:05:25 Pleiadi kernel: Swap cache: add 1483073, delete 1480994,
find 104928/321161
May  5 13:05:25 Pleiadi kernel: Free swap  = 64396kB
May  5 13:05:25 Pleiadi kernel: Total swap = 151160kB
May  5 13:05:25 Pleiadi kernel: Free swap:        64396kB
May  5 13:05:25 Pleiadi kernel: 40960 pages of RAM
May  5 13:05:25 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:05:25 Pleiadi kernel: 1202 reserved pages
May  5 13:05:25 Pleiadi kernel: 4945 pages shared
May  5 13:05:25 Pleiadi kernel: 2079 pages swap cached
May  5 13:05:25 Pleiadi kernel: 0 pages dirty
May  5 13:05:25 Pleiadi kernel: 0 pages writeback
May  5 13:05:25 Pleiadi kernel: 484 pages mapped
May  5 13:05:25 Pleiadi kernel: 2471 pages slab
May  5 13:05:25 Pleiadi kernel: 306 pages pagetables
May  5 13:05:25 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:05:25 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:05:25 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c01185ad>] profile_tick+0x4d/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c015709a>]
__kmalloc_track_caller+0x5a/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:05:25 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:05:25 Pleiadi kernel:  =======================
May  5 13:05:25 Pleiadi kernel: Mem-info:
May  5 13:05:25 Pleiadi kernel: DMA per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:05:25 Pleiadi kernel: Normal per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  40
May  5 13:05:25 Pleiadi kernel: Active:26067 inactive:1579 dirty:0
writeback:0 unstable:0
May  5 13:05:25 Pleiadi kernel:  free:8464 slab:2471 mapped:484
pagetables:306 bounce:0
May  5 13:05:25 Pleiadi kernel: DMA free:4264kB min:160kB low:200kB
high:240kB active:6632kB inactive:396kB present:16256kB
pages_scanned:139 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:05:25 Pleiadi kernel: Normal free:29592kB min:1448kB
low:1808kB high:2172kB active:97636kB inactive:5920kB present:146304kB
pages_scanned:337 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:05:25 Pleiadi kernel: DMA: 612*4kB 169*8kB 27*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4264kB
May  5 13:05:25 Pleiadi kernel: Normal: 4946*4kB 1010*8kB 102*16kB
1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
29592kB
May  5 13:05:25 Pleiadi kernel: 2651 total pagecache pages
May  5 13:05:25 Pleiadi kernel: Swap cache: add 1483073, delete 1480994,
find 104928/321161
May  5 13:05:25 Pleiadi kernel: Free swap  = 64396kB
May  5 13:05:25 Pleiadi kernel: Total swap = 151160kB
May  5 13:05:25 Pleiadi kernel: Free swap:        64396kB
May  5 13:05:25 Pleiadi kernel: 40960 pages of RAM
May  5 13:05:25 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:05:25 Pleiadi kernel: 1202 reserved pages
May  5 13:05:25 Pleiadi kernel: 4945 pages shared
May  5 13:05:25 Pleiadi kernel: 2079 pages swap cached
May  5 13:05:25 Pleiadi kernel: 0 pages dirty
May  5 13:05:25 Pleiadi kernel: 0 pages writeback
May  5 13:05:25 Pleiadi kernel: 484 pages mapped
May  5 13:05:25 Pleiadi kernel: 2471 pages slab
May  5 13:05:25 Pleiadi kernel: 306 pages pagetables
May  5 13:05:25 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:05:25 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:05:25 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c02b86f0>] ip_finish_output+0x0/0x270
May  5 13:05:25 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 13:05:25 Pleiadi kernel:  [<c02b87fc>]
ip_finish_output+0x10c/0x270
May  5 13:05:25 Pleiadi kernel:  [<c02b8dc7>] ip_output+0x97/0xa0
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c02b8495>] ip_local_out+0x15/0x20
May  5 13:05:25 Pleiadi kernel:  [<c02b90e9>] ip_queue_xmit+0x319/0x390
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c02f1e8c>]
__xfrm_policy_check+0x9c/0x5c0
May  5 13:05:25 Pleiadi kernel:  [<c02f0c90>]
xfrm_policy_lookup+0x0/0x50
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<ca8cd0b4>]
gre_keymap_lookup+0x64/0xc0 [nf_conntrack_proto_gre]
May  5 13:05:25 Pleiadi kernel:  [<ca8cd3a1>] gre_pkt_to_tuple+0xc1/0xf0
[nf_conntrack_proto_gre]
May  5 13:05:25 Pleiadi kernel:  [<c02aa021>] nf_ct_get_tuple+0x91/0xb0
May  5 13:05:25 Pleiadi kernel:  [<c02aac9f>] nf_conntrack_in+0xcf/0x2c0
May  5 13:05:25 Pleiadi kernel:  [<c02a909e>] nf_iterate+0x5e/0x90
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c02b60cd>] ip_rcv+0x1bd/0x260
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 13:05:25 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 13:05:25 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 13:05:25 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 13:05:25 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:05:25 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:05:25 Pleiadi kernel:  =======================
May  5 13:05:25 Pleiadi kernel: Mem-info:
May  5 13:05:25 Pleiadi kernel: DMA per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:05:25 Pleiadi kernel: Normal per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  46
May  5 13:05:25 Pleiadi kernel: Active:26067 inactive:1579 dirty:0
writeback:0 unstable:0
May  5 13:05:25 Pleiadi kernel:  free:8457 slab:2471 mapped:484
pagetables:306 bounce:0
May  5 13:05:25 Pleiadi kernel: DMA free:4264kB min:160kB low:200kB
high:240kB active:6632kB inactive:396kB present:16256kB
pages_scanned:139 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:05:25 Pleiadi kernel: Normal free:29564kB min:1448kB
low:1808kB high:2172kB active:97636kB inactive:5920kB present:146304kB
pages_scanned:337 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:05:25 Pleiadi kernel: DMA: 612*4kB 169*8kB 27*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4264kB
May  5 13:05:25 Pleiadi kernel: Normal: 4939*4kB 1010*8kB 102*16kB
1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
29564kB
May  5 13:05:25 Pleiadi kernel: 2651 total pagecache pages
May  5 13:05:25 Pleiadi kernel: Swap cache: add 1483073, delete 1480994,
find 104928/321161
May  5 13:05:25 Pleiadi kernel: Free swap  = 64396kB
May  5 13:05:25 Pleiadi kernel: Total swap = 151160kB
May  5 13:05:25 Pleiadi kernel: Free swap:        64396kB
May  5 13:05:25 Pleiadi kernel: 40960 pages of RAM
May  5 13:05:25 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:05:25 Pleiadi kernel: 1202 reserved pages
May  5 13:05:25 Pleiadi kernel: 4945 pages shared
May  5 13:05:25 Pleiadi kernel: 2079 pages swap cached
May  5 13:05:25 Pleiadi kernel: 0 pages dirty
May  5 13:05:25 Pleiadi kernel: 0 pages writeback
May  5 13:05:25 Pleiadi kernel: 484 pages mapped
May  5 13:05:25 Pleiadi kernel: 2471 pages slab
May  5 13:05:25 Pleiadi kernel: 306 pages pagetables
May  5 13:05:25 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:05:25 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:05:25 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:05:25 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c02b86f0>] ip_finish_output+0x0/0x270
May  5 13:05:25 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 13:05:25 Pleiadi kernel:  [<c02b87fc>]
ip_finish_output+0x10c/0x270
May  5 13:05:25 Pleiadi kernel:  [<c02b8dc7>] ip_output+0x97/0xa0
May  5 13:05:25 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:05:25 Pleiadi kernel:  [<c02b8495>] ip_local_out+0x15/0x20
May  5 13:05:25 Pleiadi kernel:  [<c02b90e9>] ip_queue_xmit+0x319/0x390
May  5 13:05:25 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:05:25 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:05:25 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:05:25 Pleiadi kernel:  [<c02f1e8c>]
__xfrm_policy_check+0x9c/0x5c0
May  5 13:05:25 Pleiadi kernel:  [<c02f0c90>]
xfrm_policy_lookup+0x0/0x50
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<ca8cd0b4>]
gre_keymap_lookup+0x64/0xc0 [nf_conntrack_proto_gre]
May  5 13:05:25 Pleiadi kernel:  [<ca8cd3a1>] gre_pkt_to_tuple+0xc1/0xf0
[nf_conntrack_proto_gre]
May  5 13:05:25 Pleiadi kernel:  [<c02aa021>] nf_ct_get_tuple+0x91/0xb0
May  5 13:05:25 Pleiadi kernel:  [<c02aac9f>] nf_conntrack_in+0xcf/0x2c0
May  5 13:05:25 Pleiadi kernel:  [<c02a909e>] nf_iterate+0x5e/0x90
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c02a9136>] nf_hook_slow+0x66/0x100
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c02b60cd>] ip_rcv+0x1bd/0x260
May  5 13:05:25 Pleiadi kernel:  [<c02b5c30>] ip_rcv_finish+0x0/0x2e0
May  5 13:05:25 Pleiadi kernel:  [<c0290f2c>]
netif_receive_skb+0x20c/0x290
May  5 13:05:25 Pleiadi kernel:  [<c0291017>] process_backlog+0x67/0xc0
May  5 13:05:25 Pleiadi kernel:  [<c0291103>] net_rx_action+0x63/0x130
May  5 13:05:25 Pleiadi kernel:  [<c011b8a0>] __do_softirq+0x40/0xa0
May  5 13:05:25 Pleiadi kernel:  [<c011b926>] do_softirq+0x26/0x30
May  5 13:05:25 Pleiadi kernel:  [<c01053e1>] do_IRQ+0x41/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:05:25 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:05:25 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:05:25 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:05:25 Pleiadi kernel:  =======================
May  5 13:05:25 Pleiadi kernel: Mem-info:
May  5 13:05:25 Pleiadi kernel: DMA per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:05:25 Pleiadi kernel: Normal per-cpu:
May  5 13:05:25 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  45
May  5 13:05:25 Pleiadi kernel: Active:26067 inactive:1579 dirty:0
writeback:0 unstable:0
May  5 13:05:25 Pleiadi kernel:  free:8457 slab:2471 mapped:484
pagetables:306 bounce:0
May  5 13:05:25 Pleiadi kernel: DMA free:4264kB min:160kB low:200kB
high:240kB active:6632kB inactive:396kB present:16256kB
pages_scanned:139 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:05:25 Pleiadi kernel: Normal free:29564kB min:1448kB
low:1808kB high:2172kB active:97636kB inactive:5920kB present:146304kB
pages_scanned:337 all_unreclaimable? no
May  5 13:05:25 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:05:25 Pleiadi kernel: DMA: 612*4kB 169*8kB 27*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 4264kB
May  5 13:05:25 Pleiadi kernel: Normal: 4939*4kB 1010*8kB 102*16kB
1*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =
29564kB
May  5 13:05:25 Pleiadi kernel: 2651 total pagecache pages
May  5 13:05:25 Pleiadi kernel: Swap cache: add 1483073, delete 1480994,
find 104928/321161
May  5 13:05:25 Pleiadi kernel: Free swap  = 64396kB
May  5 13:05:25 Pleiadi kernel: Total swap = 151160kB
May  5 13:05:25 Pleiadi kernel: Free swap:        64396kB
May  5 13:05:25 Pleiadi kernel: 40960 pages of RAM
May  5 13:05:25 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:05:25 Pleiadi kernel: 1202 reserved pages
May  5 13:05:25 Pleiadi kernel: 4945 pages shared
May  5 13:05:25 Pleiadi kernel: 2079 pages swap cached
May  5 13:05:25 Pleiadi kernel: 0 pages dirty
May  5 13:05:25 Pleiadi kernel: 0 pages writeback
May  5 13:05:25 Pleiadi kernel: 484 pages mapped
May  5 13:05:25 Pleiadi kernel: 2471 pages slab
May  5 13:05:25 Pleiadi kernel: 306 pages pagetables
May  5 13:08:52 Pleiadi kernel: > [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:52 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:52 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:52 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:52 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:52 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:52 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:52 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:52 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:52 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:52 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:52 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:52 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:55 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  38
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:08:56 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:08:56 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:08:56 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  37
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:08:56 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:08:56 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:08:56 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c01185ad>] profile_tick+0x4d/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c015709a>] __kmalloc_track_caller+0x5
a/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  36
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:08:56 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:08:56 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:08:56 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  35
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:08:56 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:08:56 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:08:56 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  34
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:08:56 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:08:56 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:08:56 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  33
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:08:56 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:08:56 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:08:56 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:08:56 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:08:56 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:08:56 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:08:56 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:08:56 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:08:56 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:08:56 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:08:56 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:08:56 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:08:56 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:08:56 Pleiadi kernel:  =======================
May  5 13:08:56 Pleiadi kernel: Mem-info:
May  5 13:08:56 Pleiadi kernel: DMA per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:08:56 Pleiadi kernel: Normal per-cpu:
May  5 13:08:56 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  32
May  5 13:08:56 Pleiadi kernel: Active:26401 inactive:1748 dirty:2
writeback:24 unstable:0
May  5 13:08:56 Pleiadi kernel:  free:8056 slab:2382 mapped:463
pagetables:306 bounce:0
May  5 13:08:56 Pleiadi kernel: DMA free:3788kB min:160kB low:200kB
high:240kB active:7312kB inactive:420kB present:16256kB
pages_scanned:128 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:08:56 Pleiadi kernel: Normal free:28436kB min:1448kB
low:1808kB high:2172kB active:98292kB inactive:6572kB present:146304kB
pages_scanned:356 all_unreclaimable? no
May  5 13:08:56 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:08:56 Pleiadi kernel: DMA: 553*4kB 141*8kB 26*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 3788kB
May  5 13:08:56 Pleiadi kernel: Normal: 5215*4kB 813*8kB 61*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 28436kB
May  5 13:08:56 Pleiadi kernel: 3058 total pagecache pages
May  5 13:08:56 Pleiadi kernel: Swap cache: add 1494842, delete 1492522,
find 106182/324488
May  5 13:08:56 Pleiadi kernel: Free swap  = 64700kB
May  5 13:08:56 Pleiadi kernel: Total swap = 151160kB
May  5 13:08:56 Pleiadi kernel: Free swap:        64700kB
May  5 13:08:56 Pleiadi kernel: 40960 pages of RAM
May  5 13:08:56 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:08:56 Pleiadi kernel: 1202 reserved pages
May  5 13:08:56 Pleiadi kernel: 4728 pages shared
May  5 13:08:56 Pleiadi kernel: 2320 pages swap cached
May  5 13:08:56 Pleiadi kernel: 2 pages dirty
May  5 13:08:56 Pleiadi kernel: 24 pages writeback
May  5 13:08:56 Pleiadi kernel: 463 pages mapped
May  5 13:08:56 Pleiadi kernel: 2382 pages slab
May  5 13:08:56 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: printk: 214 messages suppressed.
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c0276fbf>] ide_build_sglist+0x6f/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<c02771b0>] dma_timer_expiry+0x0/0x80
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<c0277471>] ide_dma_start+0x21/0x40
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0270a10>] start_request+0x140/0x1a0
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  40
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2486 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:30 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:30 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:30 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:30 Pleiadi kernel: 6334 total pagecache pages
May  5 13:10:30 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:30 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:30 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:30 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4871 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2486 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: :        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4872 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2485 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  37
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:30 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:30 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:30 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:30 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:30 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:30 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:30 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:30 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4872 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2485 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  36
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:30 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:30 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:30 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:30 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:30 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:30 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:30 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:30 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4872 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2485 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  35
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:30 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:30 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:30 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:30 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:30 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:30 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:30 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:30 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4872 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2485 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  34
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:30 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:30 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:30 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:30 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:30 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:30 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:30 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:30 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4872 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2485 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  33
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:30 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:30 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:30 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:30 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:30 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:30 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:30 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:30 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:30 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:30 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:30 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:30 Pleiadi kernel: 1202 reserved pages
May  5 13:10:30 Pleiadi kernel: 4872 pages shared
May  5 13:10:30 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:30 Pleiadi kernel: 41 pages dirty
May  5 13:10:30 Pleiadi kernel: 137 pages writeback
May  5 13:10:30 Pleiadi kernel: 435 pages mapped
May  5 13:10:30 Pleiadi kernel: 2485 pages slab
May  5 13:10:30 Pleiadi kernel: 306 pages pagetables
May  5 13:10:30 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:30 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:30 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:30 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:30 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:30 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:30 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:30 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:30 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:30 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:30 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:30 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:30 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:30 Pleiadi kernel:  =======================
May  5 13:10:30 Pleiadi kernel: Mem-info:
May  5 13:10:30 Pleiadi kernel: DMA per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:30 Pleiadi kernel: Normal per-cpu:
May  5 13:10:30 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  32
May  5 13:10:30 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:30 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:30 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:31 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:31 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:31 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:31 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:31 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:31 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:31 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:31 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:31 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:31 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:31 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:31 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:31 Pleiadi kernel: 1202 reserved pages
May  5 13:10:31 Pleiadi kernel: 4872 pages shared
May  5 13:10:31 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:31 Pleiadi kernel: 41 pages dirty
May  5 13:10:31 Pleiadi kernel: 137 pages writeback
May  5 13:10:31 Pleiadi kernel: 435 pages mapped
May  5 13:10:31 Pleiadi kernel: 2485 pages slab
May  5 13:10:31 Pleiadi kernel: 306 pages pagetables
May  5 13:10:31 Pleiadi kernel: swapper: page allocation failure.
order:3, mode:0x4020
May  5 13:10:31 Pleiadi kernel: Pid: 0, comm: swapper Not tainted 2.6.25
#1
May  5 13:10:31 Pleiadi kernel:  [<c013f6ee>] __alloc_pages+0x30e/0x360
May  5 13:10:31 Pleiadi kernel:  [<c01556c5>] allocate_slab+0x35/0x90
May  5 13:10:31 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:31 Pleiadi kernel:  [<c0155770>] new_slab+0x20/0x120
May  5 13:10:31 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:31 Pleiadi kernel:  [<c0155cfc>] __slab_alloc+0xac/0x160
May  5 13:10:31 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:31 Pleiadi kernel:  [<c015712e>]
__kmalloc_track_caller+0xee/0x100
May  5 13:10:31 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:31 Pleiadi kernel:  [<c0289e04>] __alloc_skb+0x54/0x110
May  5 13:10:31 Pleiadi kernel:  [<ca8728a0>] boomerang_rx+0x210/0x430
[3c59x]
May  5 13:10:31 Pleiadi kernel:  [<c0111de3>]
__update_rq_clock+0x23/0x120
May  5 13:10:31 Pleiadi kernel:  [<ca87208b>]
boomerang_interrupt+0x11b/0x3c0 [3c59x]
May  5 13:10:31 Pleiadi kernel:  [<c011f1d2>]
run_timer_softirq+0x12/0x150
May  5 13:10:31 Pleiadi kernel:  [<c0137f45>] handle_IRQ_event+0x25/0x60
May  5 13:10:31 Pleiadi kernel:  [<c0138e17>] handle_level_irq+0x47/0xa0
May  5 13:10:31 Pleiadi kernel:  [<c01053dc>] do_IRQ+0x3c/0x70
May  5 13:10:31 Pleiadi kernel:  [<c0103753>] common_interrupt+0x23/0x28
May  5 13:10:31 Pleiadi kernel:  [<c0120000>] signal_wake_up+0x10/0x20
May  5 13:10:31 Pleiadi kernel:  [<c01012c9>] default_idle+0x39/0x70
May  5 13:10:31 Pleiadi kernel:  [<c0101290>] default_idle+0x0/0x70
May  5 13:10:31 Pleiadi kernel:  [<c0101336>] cpu_idle+0x26/0x60
May  5 13:10:31 Pleiadi kernel:  =======================
May  5 13:10:31 Pleiadi kernel: Mem-info:
May  5 13:10:31 Pleiadi kernel: DMA per-cpu:
May  5 13:10:31 Pleiadi kernel: CPU    0: hi:    0, btch:   1 usd:   0
May  5 13:10:31 Pleiadi kernel: Normal per-cpu:
May  5 13:10:31 Pleiadi kernel: CPU    0: hi:   42, btch:   7 usd:  31
May  5 13:10:31 Pleiadi kernel: Active:29662 inactive:3159 dirty:41
writeback:137 unstable:0
May  5 13:10:31 Pleiadi kernel:  free:3262 slab:2485 mapped:435
pagetables:306 bounce:0
May  5 13:10:31 Pleiadi kernel: DMA free:2336kB min:160kB low:200kB
high:240kB active:7920kB inactive:1116kB present:16256kB pages_scanned:0
all_unreclaimable? no
May  5 13:10:31 Pleiadi kernel: lowmem_reserve[]: 0 142 142
May  5 13:10:31 Pleiadi kernel: Normal free:10712kB min:1448kB
low:1808kB high:2172kB active:110728kB inactive:11520kB present:146304kB
pages_scanned:284 all_unreclaimable? no
May  5 13:10:31 Pleiadi kernel: lowmem_reserve[]: 0 0 0
May  5 13:10:31 Pleiadi kernel: DMA: 332*4kB 88*8kB 17*16kB 1*32kB
0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2336kB
May  5 13:10:31 Pleiadi kernel: Normal: 2142*4kB 192*8kB 32*16kB 1*32kB
1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10712kB
May  5 13:10:31 Pleiadi kernel: 6335 total pagecache pages
May  5 13:10:31 Pleiadi kernel: Swap cache: add 1503534, delete 1499309,
find 107824/327901
May  5 13:10:31 Pleiadi kernel: Free swap  = 69736kB
May  5 13:10:31 Pleiadi kernel: Total swap = 151160kB
May  5 13:10:31 Pleiadi kernel: Free swap:        69736kB
May  5 13:10:31 Pleiadi kernel: 40960 pages of RAM
May  5 13:10:31 Pleiadi kernel: 0 pages of HIGHMEM
May  5 13:10:31 Pleiadi kernel: 1202 reserved pages
May  5 13:10:31 Pleiadi kernel: 4872 pages shared
May  5 13:10:31 Pleiadi kernel: 4225 pages swap cached
May  5 13:10:31 Pleiadi kernel: 41 pages dirty
May  5 13:10:31 Pleiadi kernel: 137 pages writeback
May  5 13:10:31 Pleiadi kernel: 435 pages mapped
May  5 13:10:31 Pleiadi kernel: 2485 pages slab
May  5 13:10:31 Pleiadi kernel: 306 pages pagetables
May  5 14:31:38 Pleiadi kernel: xfs_inotobp: xfs_imap()  returned an
error 22 on hda8.  Returning error.
May  5 14:31:38 Pleiadi kernel: xfs_iunlink_remove: xfs_inotobp()
returned an error 22 on hda8.  Returning error.
May  5 14:31:38 Pleiadi kernel: xfs_inactive:^Ixfs_ifree() returned an
error = 22 on hda8
May  5 14:31:38 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called from
line 1737 of file fs/xfs/xfs_vnodeops.c.  Return address = 0xc01e6fde
May  5 14:31:38 Pleiadi kernel: Filesystem "hda8": I/O Error Detected.
Shutting down filesystem: hda8
May  5 14:31:38 Pleiadi kernel: Please umount the filesystem, and
rectify the problem(s)
May  5 14:36:43 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called from
line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xc01eaf21
May  5 14:39:36 Pleiadi kernel: Filesystem "hda8": Disabling barriers,
not supported by the underlying device
May  5 14:39:36 Pleiadi kernel: XFS mounting filesystem hda8
May  5 14:39:37 Pleiadi kernel: Ending clean XFS mount for filesystem:
hda8


