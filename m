Return-Path: <linux-kernel-owner+w=401wt.eu-S1758321AbZASUjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321AbZASUjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZASUjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:39:20 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:39918 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752416AbZASUjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:39:15 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-usb@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       linux-acpi@vger.kernel.org
Subject: [2.6.29-rc2] First suspend after reboot resumes immediately.
Date: Mon, 19 Jan 2009 23:39:01 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10629971.1Q56XLfsat";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901192339.03967.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10629971.1Q56XLfsat
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subsequent suspends seem fine. I suspect it is related to USB controller;=20
but because I see ACPI related message this is sent to linux-acpi as well.

Specifically, I am suspicious of this:

[  132.763954] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI  =
=20

The controller immediately resumes after any attempt to suspend it, so any=
=20
autosuspend functionality is currently disabled. But it /looks/ like ACPI=20
somehow tries to do it anyway.

I can also reproduce it by unloading and reloading USB drivers which=20
supports USB guess.

dmesg follows.

[    0.000000] Linux version 2.6.29-rc2-1avb (bor@cooker) (gcc version 4.3.=
2=20
(GCC) ) #10 Mon Jan 19 21:04:50 MSK 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] PAT WC disabled due to known CPU erratum.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
[    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001ef60000 (usable)
[    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001ef70000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] last_pfn =3D 0x1ef60 max_arch_pfn =3D 0x100000
[    0.000000] kernel direct mapping tables up to 1ef60000 @ 7000-d000
[    0.000000] RAMDISK: 1ebcf000 - 1ef4f86c
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match=20
PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] 495MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ef60000
[    0.000000]   low ram: 00000000 - 1ef60000
[    0.000000]   bootmap 00001000 - 00004dec
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 001ef60=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D>=20
[0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000973dd8]    TEXT DATA BSS =3D=3D>=20
[0000100000 - 0000973dd8]
[    0.000000]   #2 [001ebcf000 - 001ef4f86c]          RAMDISK =3D=3D>=20
[001ebcf000 - 001ef4f86c]
[    0.000000]   #3 [0000974000 - 0000978000]    INIT_PG_TABLE =3D=3D>=20
[0000974000 - 0000978000]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved =3D=3D>=20
[000009fc00 - 0000100000]
[    0.000000]   #5 [0000007000 - 0000009000]          PGTABLE =3D=3D>=20
[0000007000 - 0000009000]
[    0.000000]   #6 [0000001000 - 0000005000]          BOOTMAP =3D=3D>=20
[0000001000 - 0000005000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001ef60
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001ef60
[    0.000000] On node 0 totalpages: 126719
[    0.000000] free_area_init_node: node 0, pgdat c03caa00, node_mem_map=20
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 959 pages used for memmap
[    0.000000]   Normal zone: 121761 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] PM: Registered nosave memory: 000000000009f000 -=20
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -=20
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -=20
00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 -=20
00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 -=20
0000000000100000
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l=20
pages: 125728
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.29-rc2-1avb root=3DLAB=
EL=3D/=20
resume=3DLABEL=3Dswap acpi_backlight=3Dvendor=20
netconsole=3D@10.0.0.1/eth0,@10.0.0.2/00:17:42:21:27:e4 vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0414000 soft=3Dc0413000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 747.745 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2591 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333]=20
=2D------------------------------------------------------------------------=
=2D--
[    0.003333]                                  | spin |wlock |rlock |mutex=
=20
| wsem | rsem |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
=20
|  ok  |  ok  |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]               recursive read-lock:             |  ok  |     =
       =20
|  ok  |
[    0.003333]            recursive read-lock #2:             |  ok  |     =
       =20
|  ok  |
[    0.003333]             mixed read-write-lock:             |  ok  |     =
       =20
|  ok  |
[    0.003333]             mixed write-read-lock:             |  ok  |     =
       =20
|  ok  |
[    0.003333]  =20
=2D-------------------------------------------------------------------------
[    0.003333]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq read-recursion/123:  ok  |
[    0.003333]       soft-irq read-recursion/123:  ok  |
[    0.003333]       hard-irq read-recursion/132:  ok  |
[    0.003333]       soft-irq read-recursion/132:  ok  |
[    0.003333]       hard-irq read-recursion/213:  ok  |
[    0.003333]       soft-irq read-recursion/213:  ok  |
[    0.003333]       hard-irq read-recursion/231:  ok  |
[    0.003333]       soft-irq read-recursion/231:  ok  |
[    0.003333]       hard-irq read-recursion/312:  ok  |
[    0.003333]       soft-irq read-recursion/312:  ok  |
[    0.003333]       hard-irq read-recursion/321:  ok  |
[    0.003333]       soft-irq read-recursion/321:  ok  |
[    0.003333] -------------------------------------------------------
[    0.003333] Good, all 218 testcases passed! |
[    0.003333] ---------------------------------
[    0.003333] Dentry cache hash table entries: 65536 (order: 6, 262144=20
bytes)
[    0.003333] Inode-cache hash table entries: 32768 (order: 5, 131072=20
bytes)
[    0.003333] Memory: 489984k/507264k available (2104k kernel code, 16676k=
=20
reserved, 794k data, 232k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
[    0.003333]     vmalloc : 0xdf760000 - 0xfffeb000   ( 520 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[    0.003333]       .init : 0xc03d6000 - 0xc0410000   ( 232 kB)
[    0.003333]       .data : 0xc030e245 - 0xc03d4e00   ( 794 kB)
[    0.003333]       .text : 0xc0100000 - 0xc030e245   (2104 kB)
[    0.003333] Checking if this processor honours the WP bit even in=20
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0,=20
CPUs=3D1, Nodes=3D1
[    0.003398] Calibrating delay loop (skipped), value calculated using=20
timer frequency.. 1496.80 BogoMIPS (lpj=3D2492483)
[    0.003584] Mount-cache hash table entries: 512
[    0.006247] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.006312] CPU: L2 cache: 256K
[    0.006330] CPU serial number disabled.
[    0.006399] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.006452] Checking 'hlt' instruction... OK.
[    0.017719] Freeing SMP alternatives: 0k freed
[    0.017742] ACPI: Core revision 20081204
[    0.048821] ACPI: setting ELCR to 0200 (from 0a00)
[    0.052315] Testing tracer nop: PASSED
[    0.056794] net_namespace: 732 bytes
[    0.058508] NET: Registered protocol family 16
[    0.061942] ACPI: bus type pci registered
[    0.063976] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[    0.064028] PCI: Using configuration type 1 for base access
[    0.075451] bio: create slab <bio-0> at 0
[    0.086397] ACPI: EC: Look up EC in DSDT
[    0.115449] ACPI: Interpreter enabled
[    0.115514] ACPI: (supports S0 S3 S4 S5)
[    0.115939] ACPI: Using PIC for interrupt routing
[    0.176069] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.176236] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.177546] pci 0000:00:00.0: reg 10 32bit mmio: [0xf0000000-0xf3ffffff]
[    0.177947] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7eff000-0xf7efffff]
[    0.178091] pci 0000:00:02.0: PME# supported from D3hot D3cold
[    0.178135] pci 0000:00:02.0: PME# disabled
[    0.178303] pci 0000:00:04.0: reg 20 io port: [0xeff0-0xefff]
[    0.178489] pci 0000:00:06.0: reg 10 io port: [0xed00-0xedff]
[    0.178513] pci 0000:00:06.0: reg 14 32bit mmio: [0xf7efe000-0xf7efefff]
[    0.178641] pci 0000:00:06.0: supports D1 D2
[    0.178649] pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
[    0.178676] pci 0000:00:06.0: PME# disabled
[    0.179089] pci 0000:00:08.0: quirk: region ee00-ee3f claimed by ali7101=
=20
ACPI
[    0.179120] pci 0000:00:08.0: quirk: region ef00-ef1f claimed by ali7101=
=20
SMB
[    0.179241] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7efd000-0xf7efdfff]
[    0.179265] pci 0000:00:0a.0: reg 14 io port: [0xeb40-0xeb7f]
[    0.179289] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7d00000-0xf7dfffff]
[    0.179403] pci 0000:00:0a.0: supports D1 D2
[    0.179410] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.179439] pci 0000:00:0a.0: PME# disabled
[    0.179568] pci 0000:00:10.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.179628] pci 0000:00:10.0: supports D1 D2
[    0.179636] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.179665] pci 0000:00:10.0: PME# disabled
[    0.179779] pci 0000:00:11.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.179944] pci 0000:00:11.1: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.180169] pci 0000:00:12.0: reg 10 32bit mmio: [0xf7cffe00-0xf7cfffff]
[    0.180316] pci 0000:00:12.0: supports D1 D2
[    0.180324] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.180354] pci 0000:00:12.0: PME# disabled
[    0.180546] pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfdffffff]
[    0.180570] pci 0000:01:00.0: reg 14 32bit mmio: [0xfbc00000-0xfbffffff]
[    0.180593] pci 0000:01:00.0: reg 18 32bit mmio: [0xf8000000-0xf9ffffff]
[    0.180615] pci 0000:01:00.0: reg 1c 32bit mmio: [0xf7ff8000-0xf7ffffff]
[    0.180661] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.180732] pci 0000:01:00.0: supports D1 D2
[    0.180869] pci 0000:00:01.0: bridge 32bit mmio: [0xf7f00000-0xfdffffff]
[    0.181073] pci_bus 0000:00: on NUMA node 0
[    0.181124] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.181745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.220197] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[    0.221156] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[    0.222058] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[    0.222961] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[    0.224024] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[    0.224938] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[    0.226456] ACPI: Power Resource [PFAN] (off)
[    0.229542] PCI: Using ACPI for IRQ routing
[    0.233783] pnp: PnP ACPI init
[    0.233980] ACPI: bus type pnp registered
[    0.260086] pnp: PnP ACPI: found 12 devices
[    0.260145] ACPI: ACPI bus type pnp unregistered
[    0.260260] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.260290] system 00:00: iomem range 0xe0000-0xeffff could not be=20
reserved
[    0.260318] system 00:00: iomem range 0xf0000-0xfffff could not be=20
reserved
[    0.260346] system 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[    0.260376] system 00:00: iomem range 0x1ef60000-0x1ef6ffff could not be=
=20
reserved
[    0.260405] system 00:00: iomem range 0x1f000000-0x1fffffff has been=20
reserved
[    0.260432] system 00:00: iomem range 0x1ef70000-0x1effffff has been=20
reserved
[    0.260462] system 00:00: iomem range 0xffe00000-0xffffffff could not be=
=20
reserved
[    0.260555] system 00:08: ioport range 0x370-0x371 has been reserved
[    0.260583] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.260609] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.260634] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.260661] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.260686] system 00:08: ioport range 0x6c0-0x6ff has been reserved
[    0.260713] system 00:08: ioport range 0xe000-0xe07f has been reserved
[    0.260740] system 00:08: ioport range 0xe080-0xe0ff has been reserved
[    0.260767] system 00:08: ioport range 0xe400-0xe47f has been reserved
[    0.260794] system 00:08: ioport range 0xe480-0xe4ff has been reserved
[    0.260821] system 00:08: ioport range 0xe800-0xe87f has been reserved
[    0.260847] system 00:08: ioport range 0xe880-0xe8ff has been reserved
[    0.260875] system 00:08: ioport range 0xec00-0xec7f has been reserved
[    0.260902] system 00:08: ioport range 0xec80-0xecff has been reserved
[    0.260931] system 00:08: ioport range 0xee00-0xee41 could not be=20
reserved
[    0.260959] system 00:08: ioport range 0xee90-0xee9f has been reserved
[    0.260987] system 00:08: ioport range 0xeeac-0xeeac has been reserved
[    0.261015] system 00:08: ioport range 0xef00-0xef3f could not be=20
reserved
[    0.261044] system 00:08: ioport range 0xef40-0xef5f has been reserved
[    0.300287] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.300342] pci 0000:00:01.0:   IO window: disabled
[    0.300375] pci 0000:00:01.0:   MEM window: 0xf7f00000-0xfdffffff
[    0.300405] pci 0000:00:01.0:   PREFETCH window:=20
0x00000048000000-0x000000480fffff
[    0.300451] pci 0000:00:10.0: CardBus bridge, secondary bus 0000:02
[    0.300472] pci 0000:00:10.0:   IO window: 0x001000-0x0010ff
[    0.300499] pci 0000:00:10.0:   IO window: 0x001400-0x0014ff
[    0.300528] pci 0000:00:10.0:   PREFETCH window: 0x30000000-0x33ffffff
[    0.300557] pci 0000:00:10.0:   MEM window: 0x34000000-0x37ffffff
[    0.300586] pci 0000:00:11.0: CardBus bridge, secondary bus 0000:06
[    0.300607] pci 0000:00:11.0:   IO window: 0x001800-0x0018ff
[    0.300634] pci 0000:00:11.0:   IO window: 0x001c00-0x001cff
[    0.300662] pci 0000:00:11.0:   PREFETCH window: 0x38000000-0x3bffffff
[    0.300691] pci 0000:00:11.0:   MEM window: 0x3c000000-0x3fffffff
[    0.300721] pci 0000:00:11.1: CardBus bridge, secondary bus 0000:0a
[    0.300741] pci 0000:00:11.1:   IO window: 0x002000-0x0020ff
[    0.300768] pci 0000:00:11.1:   IO window: 0x002400-0x0024ff
[    0.300796] pci 0000:00:11.1:   PREFETCH window: 0x40000000-0x43ffffff
[    0.300825] pci 0000:00:11.1:   MEM window: 0x44000000-0x47ffffff
[    0.300892] pci 0000:00:01.0: setting latency timer to 64
[    0.300925] pci 0000:00:10.0: enabling device (0000 -> 0003)
[    0.302764] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.302793] PCI: setting IRQ 11 as level-triggered
[    0.302807] pci 0000:00:10.0: PCI INT A -> Link[LNKC] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.302865] pci 0000:00:11.0: enabling device (0000 -> 0003)
[    0.304375] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.304403] pci 0000:00:11.0: PCI INT A -> Link[LNKA] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.304461] pci 0000:00:11.1: enabling device (0000 -> 0003)
[    0.305920] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.305946] pci 0000:00:11.1: PCI INT B -> Link[LNKB] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.305994] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.306003] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.306012] pci_bus 0000:01: resource 0 mem: [0x0-0x0]
[    0.306021] pci_bus 0000:01: resource 1 mem: [0xf7f00000-0xfdffffff]
[    0.306030] pci_bus 0000:01: resource 2 mem: [0x48000000-0x480fffff]
[    0.306039] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.306049] pci_bus 0000:02: resource 0 io:  [0x1000-0x10ff]
[    0.306057] pci_bus 0000:02: resource 1 io:  [0x1400-0x14ff]
[    0.306066] pci_bus 0000:02: resource 2 mem: [0x30000000-0x33ffffff]
[    0.306075] pci_bus 0000:02: resource 3 mem: [0x34000000-0x37ffffff]
[    0.306085] pci_bus 0000:06: resource 0 io:  [0x1800-0x18ff]
[    0.306094] pci_bus 0000:06: resource 1 io:  [0x1c00-0x1cff]
[    0.306103] pci_bus 0000:06: resource 2 mem: [0x38000000-0x3bffffff]
[    0.306112] pci_bus 0000:06: resource 3 mem: [0x3c000000-0x3fffffff]
[    0.306122] pci_bus 0000:0a: resource 0 io:  [0x2000-0x20ff]
[    0.306130] pci_bus 0000:0a: resource 1 io:  [0x2400-0x24ff]
[    0.306139] pci_bus 0000:0a: resource 2 mem: [0x40000000-0x43ffffff]
[    0.306148] pci_bus 0000:0a: resource 3 mem: [0x44000000-0x47ffffff]
[    0.306301] NET: Registered protocol family 2
[    0.307574] IP route cache hash table entries: 4096 (order: 2, 16384=20
bytes)
[    0.308643] TCP established hash table entries: 16384 (order: 5, 131072=
=20
bytes)
[    0.309380] TCP bind hash table entries: 16384 (order: 7, 655360 bytes)
[    0.315949] TCP: Hash tables configured (established 16384 bind 16384)
[    0.316246] TCP reno registered
[    0.317112] NET: Registered protocol family 1
[    0.318626] checking if image is initramfs... it is
[    0.800127] Switched to high resolution mode on CPU 0
[    1.231151] Freeing initrd memory: 3586k freed
[    1.239869] Initializing RT-Tester: OK
[    1.241388] audit: initializing netlink socket (disabled)
[    1.241644] type=3D2000 audit(1232396742.240:1): initialized
[    1.250467] Kprobe smoke test started
[    1.262102] Kprobe smoke test passed successfully
[    1.262221] Testing tracer sched_switch: PASSED
[    1.400842] msgmni has been set to 964
[    1.402425] io scheduler noop registered
[    1.402460] io scheduler anticipatory registered
[    1.402480] io scheduler deadline registered
[    1.402611] io scheduler cfq registered (default)
[    1.402900] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    1.402980] pci 0000:00:0a.0: Firmware left e100 interrupts enabled;=20
disabling
[    1.403082] pci 0000:01:00.0: Boot video device
[    1.406178] vesafb: framebuffer at 0xfc000000, mapped to 0xdf780000,=20
using 3072k, total 16384k
[    1.406232] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[    1.406253] vesafb: protected mode interface info at c000:775e
[    1.406274] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[    1.406296] vesafb: scrolling: redraw
[    1.406317] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.473929] Console: switching to colour frame buffer device 128x48
[    1.539446] fb0: VESA VGA frame buffer device
[    1.984738] brd: module loaded
[    1.985188] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    1.985945] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.989208] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.989956] e100 0000:00:0a.0: PCI INT A -> Link[LNKD] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    2.018108] e100 0000:00:0a.0: PME# disabled
[    2.019933] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:d7:14:a1
[    2.021455] netconsole: local port 6665
[    2.021945] netconsole: local IP 10.0.0.1
[    2.022442] netconsole: interface eth0
[    2.022907] netconsole: remote port 6666
[    2.023688] netconsole: remote IP 10.0.0.2
[    2.024200] netconsole: remote ethernet address 00:17:42:21:27:e4
[    2.024994] netconsole: device eth0 not up yet, forcing it
[    2.041876] e100: eth0: e100_request_firmware: Failed to load firmware=20
"e100/d101m_ucode.bin": -22
[    2.043848] netconsole: failed to open eth0
[    2.044380] netconsole: cleaning up
[    2.046108] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[    2.052660] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.053449] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.057241] mice: PS/2 mouse device common for all mice
[    2.058698] cpuidle: using governor ladder
[    2.083433] cpuidle: using governor menu
[    2.107883] TCP cubic registered
[    2.131937] Using IPI Shortcut mode
[    2.159264] registered taskstats version 1
[    2.184377] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.210742] Freeing unused kernel memory: 232k freed
[    2.235995] Write protecting the kernel text: 2108k
[    2.260576] Write protecting the kernel read-only data: 620k
[    2.317122] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input0
[    2.944824] SCSI subsystem initialized
[    3.016067] Driver 'sd' needs updating - please use bus_type methods
[    3.148439] libata version 3.00 loaded.
[    3.191171] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[    3.215842] scsi0 : pata_ali
[    3.240392] scsi1 : pata_ali
[    3.267837] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq=
=20
14
[    3.290960] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq=
=20
15
[    3.474168] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[    3.496878] ata1.00: 39070080 sectors, multi 0: LBA=20
[    3.519208] ata1.00: limited to UDMA/33 due to 40-wire cable
[    3.554005] ata1.00: configured for UDMA/33
[    3.577983] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0=20
DA3O PQ: 0 ANSI: 5
[    3.602313] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[    3.625303] sd 0:0:0:0: [sda] Write Protect is off
[    3.648022] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.648205] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.673804] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[    3.697993] sd 0:0:0:0: [sda] Write Protect is off
[    3.721864] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.722047] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.746725]  sda: sda1 sda2
[    3.800099] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.023930] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[    4.048353] ata2.00: WARNING: ATAPI DMA disabled for reliablity issues. =
=20
It can be enabled
[    4.072801] ata2.00: WARNING: via pata_ali.atapi_dma modparam or=20
corresponding sysfs node.
[    4.110470] ata2.00: configured for UDMA/33
[    4.137806] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502=20
1313 PQ: 0 ANSI: 5
[    4.429121] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[    4.455829] ReiserFS: sda2: using ordered data mode
[    4.496181] ReiserFS: sda2: journal params: device sda2, size 8192,=20
journal first block 18, max trans len 1024, max batch 900, max commit age=20
30, max trans age 30
[    4.559357] ReiserFS: sda2: checking transaction log (sda2)
[    4.637914] ReiserFS: sda2: Using r5 hash to sort names
[    7.413076] usbcore: registered new interface driver usbfs
[    7.440426] usbcore: registered new interface driver hub
[    7.467200] usbcore: registered new device driver usb
[   14.521396] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   14.523608] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   14.523628] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[   14.523810] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   14.526264] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[   14.526396] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   14.526472] Linux agpgart interface v0.103
[   14.567350] input: Power Button (FF) as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   14.578051] ACPI: Power Button (FF) [PWRF]
[   14.578847] input: Lid Switch as=20
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[   14.594398] ACPI: Lid Switch [LID]
[   14.609290] usb usb1: configuration #1 chosen from 1 choice
[   14.640544] hub 1-0:1.0: USB hub found
[   14.640845] hub 1-0:1.0: 3 ports detected
[   14.783190] ACPI: AC Adapter [ADP1] (on-line)
[   14.801030] ACPI Warning (nspredef-0940): \_SB_.BAT1._BIF: Return Packag=
e=20
type mismatch at index 12 - found Integer, expected String/Buffer [20081204]
[   14.802548] ACPI: Battery Slot [BAT1] (battery present)
[   14.802770] ACPI: Battery Slot [BAT2] (battery absent)
[   14.819560] agpgart-ali 0000:00:00.0: ALi M1644 chipset
[   14.833061] agpgart-ali 0000:00:00.0: AGP aperture is 64M @ 0xf0000000
[   14.844907] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   14.845769] processor ACPI_CPU:00: registered as cooling_device0
[   14.965927] thermal LNXTHERM:01: registered as thermal_zone0
[   14.967981] ACPI: Thermal Zone [THRM] (58 C)
[   15.244811] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   15.244828] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   15.303315] input: Video Bus as=20
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14/device:15/input/input3
[   15.316961] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post:=20
no)
[   15.416846] fan PNP0C0B:00: registered as cooling_device1
[   15.416886] ACPI: Fan [FAN] (off)
[   15.507446] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   15.507825] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   15.559118] pci 0000:00:08.0: enabling device (0000 -> 0001)
[   15.560404] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[   15.846986] Driver 'sr' needs updating - please use bus_type methods
[   15.902466] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   15.902493] Uniform CD-ROM driver Revision: 3.20
[   15.903945] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   16.099411] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   16.816515] input: ImPS/2 Generic Wheel Mouse as=20
/devices/platform/i8042/serio1/input/input5
[   16.983084] rtc_cmos 00:07: RTC can wake from S4
[   16.984900] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   16.984998] rtc0: alarms up to one year, 114 bytes nvram
[   17.178421] yenta_cardbus 0000:00:10.0: CardBus bridge found [12a3:ab01]
[   17.304537] yenta_cardbus 0000:00:10.0: ISA IRQ mask 0x0000, PCI irq 11
[   17.304556] yenta_cardbus 0000:00:10.0: Socket status: 30000059
[   17.313791] yenta_cardbus 0000:00:11.0: CardBus bridge found [1179:0001]
[   17.441061] yenta_cardbus 0000:00:11.0: ISA IRQ mask 0x04b8, PCI irq 11
[   17.441076] yenta_cardbus 0000:00:11.0: Socket status: 30000007
[   17.444395] yenta_cardbus 0000:00:11.1: CardBus bridge found [1179:0001]
[   17.571331] yenta_cardbus 0000:00:11.1: ISA IRQ mask 0x04b8, PCI irq 11
[   17.571349] yenta_cardbus 0000:00:11.1: Socket status: 30000007
[   17.947089] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[   18.681446] NET: Registered protocol family 23
[   18.925773] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[   18.925814] Activated ALi 1533 ISA bridge port 0x02e8.
[   18.925831] Activated ALi 1533 ISA bridge port 0x02f8.
[   18.926087] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[   18.926103] smsc_superio_flat(): IrDA not enabled
[   18.926132] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x02
[   18.926172] SMsC IrDA Controller found
[   18.926176]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[   18.926395] No transceiver found. Defaulting to Fast pin select
[   18.926439] irda0 (): not using net_device_ops yet
[   18.927576] IrDA: Registered device irda0
[   20.317350] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[   20.319352] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   20.319373] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[   24.530878] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   24.534346] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   24.535874] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   24.557357] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   24.560824] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   24.562351] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   24.563868] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   24.566429] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   24.571005] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   24.578360] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   24.737568] Marking TSC unstable due to TSC halts in idle
[   24.796747] Clocksource tsc unstable (delta =3D -84974128 ns)
[   25.303851] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   25.307301] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   25.308829] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   25.310398] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   25.312952] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   25.315702] pcmcia_socket pcmcia_socket0: cs: memory probe=20
0xa0000000-0xa0ffffff: clean.
[   25.330642] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[   25.584442] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[   25.679610] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[   25.722367] eth1 (orinoco_cs): not using net_device_ops yet
[   25.762124] eth1: Hardware identity 0005:0002:0001:0002
[   25.762237] eth1: Station identity  001f:0001:0006:000e
[   25.762248] eth1: Firmware determined as Lucent/Agere 6.14
[   25.762472] eth1: Attempting to download firmware agere_sta_fw.bin
[   25.762503] hermes_dld: AUX enable returned 0
[   25.763559] hermes_dld: AUX disable returned 0
[   25.763567] hermes_dld: Actual PDA length 998, Max allowed 1000
[   25.763575] eth1: Read PDA returned 0
[   25.763588] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[   25.886677] hermes_dld: AUX enable returned 0
[   25.886742] hermes_dld: Enabling volatile, EP 0x000f8000
[   25.887788] hermes_dld: PROGRAM_ENABLE returned 0
[   25.887796] eth1: Program init returned 0
[   25.887806] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[   25.935898] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[   25.939178] eth1: Program returned 0
[   25.939187] hermes_dld: Found record 0x0003 at ddaddc1c
[   25.939209] hermes_dld: Found record 0x0005 at ddaddca8
[   25.939228] hermes_dld: Found record 0x0008 at ddaddcd2
[   25.939244] hermes_dld: Found record 0x0007 at ddaddcc4
[   25.939262] hermes_dld: Found record 0x0006 at ddaddcb6
[   25.939282] hermes_dld: Found record 0x0110 at ddaddd9a
[   25.939315] hermes_dld: Found record 0x0120 at ddadddba
[   25.939348] hermes_dld: Found record 0x0130 at ddadddda
[   25.939380] hermes_dld: Found record 0x0140 at ddadddfa
[   25.939393] hermes_dld: Found record 0x0150 at ddadde02
[   25.939406] hermes_dld: Using default record 0x0160 at dfabfb60
[   25.939438] hermes_dld: Found record 0x0101 at ddaddd46
[   25.939453] hermes_dld: Found record 0x0103 at ddaddd5c
[   25.939473] hermes_dld: Found record 0x0104 at ddaddd6c
[   25.939485] hermes_dld: Found record 0x0105 at ddaddd72
[   25.939497] hermes_dld: Found record 0x0105 at ddaddd72
[   25.939508] hermes_dld: Found record 0x0105 at ddaddd72
[   25.939520] hermes_dld: Found record 0x0107 at ddaddd7e
[   25.939532] hermes_dld: Found record 0x0109 at ddaddd8c
[   25.939550] hermes_dld: Using default record 0x0161 at dfabfb80
[   25.939765] eth1: Apply PDA returned 0
[   25.939829] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[   25.939858] hermes_dld: AUX disable returned 0
[   25.950498] eth1: Program end returned 0
[   25.950507] eth1: hermes_present returned 1
[   25.951323] eth1: Hardware identity 0005:0002:0001:0002
[   25.951451] eth1: Station identity  001f:0002:0009:0030
[   25.951461] eth1: Firmware determined as Lucent/Agere 9.48
[   25.951469] eth1: Ad-hoc demo mode supported
[   25.951477] eth1: IEEE standard IBSS ad-hoc mode supported
[   25.951484] eth1: WEP supported, 104-bit key
[   25.951492] eth1: WPA-PSK supported
[   26.702954] eth1: MAC address 00:02:2d:26:95:6c
[   26.703070] eth1: Station name "HERMES I"
[   26.703921] eth1: ready
[   26.704770] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[   27.032767] Toshiba System Management Mode driver v1.11 26/9/2001
[   27.124714] Non-volatile memory driver v1.3
[   27.889696] device-mapper: uevent: version 1.0.3
[   27.891810] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
=20
dm-devel@redhat.com
[   29.699045] device-mapper: multipath: version 1.0.5 loaded
[   30.923734] device-mapper: multipath round-robin: version 1.0.0 loaded
[   30.924984] device-mapper: table: 254:0: multipath: error getting device
[   30.925003] device-mapper: ioctl: error adding target to table
[   39.237654] loop: module loaded
[   43.771506] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k=20
[   47.789134] IrCOMM protocol (Dag Brattli)
[   50.716012] PPP generic driver version 2.4.2
[   57.581564] NET: Registered protocol family 17
[   57.970436] eth1: Lucent/Agere firmware doesn't support manual roaming
[   58.123407] eth1: New link status: Connected (0001)
[  130.624810] PM: Syncing filesystems ... done.
[  130.688894] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[  130.731416] Freezing user space processes ... (elapsed 0.01 seconds)=20
done.
[  130.748981] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
)=20
done.
[  130.749673] Suspending console(s) (use no_console_suspend to debug)
[  130.761183] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  131.218872] sd 0:0:0:0: [sda] Stopping disk
[  131.899832] pci 0000:01:00.0: power state changed by ACPI to D3
[  131.914446] e100 0000:00:0a.0: PME# enabled
[  131.914687] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[  131.914858] e100 0000:00:0a.0: PCI INT A disabled
[  131.984160] ALI 5451 0000:00:06.0: PCI INT A disabled
[  131.997154] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[  132.750111] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[  132.763635] ohci_hcd 0000:00:02.0: PCI INT A disabled
[  132.763740] ohci_hcd 0000:00:02.0: PME# enabled
[  132.763954] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI
[  132.793541] ACPI: Preparing to enter system sleep state S3
[  132.793541] Back to C!
[  132.793541] ohci_hcd 0000:00:02.0: restoring config space at offset 0xf=
=20
(was 0x500001ff, writing 0x5000010b)
[  132.793541] pci 0000:00:12.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[  132.793541] pci 0000:01:00.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[  132.807630] ACPI: Waking up from system sleep state S3
[  132.827467] agpgart-ali 0000:00:00.0: PME# disabled
[  132.827519] pci 0000:00:01.0: setting latency timer to 64
[  132.827550] ohci_hcd 0000:00:02.0: wake-up capability disabled by ACPI
[  132.827565] ohci_hcd 0000:00:02.0: PME# disabled
[  132.840174] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[  132.840202] ohci_hcd 0000:00:02.0: wake-up capability disabled by ACPI
[  132.840217] ohci_hcd 0000:00:02.0: PME# disabled
[  132.895449] usb usb1: root hub lost power or was reset
[  132.907049] pata_ali 0000:00:04.0: restoring config space at offset 0x1=
=20
(was 0x2900001, writing 0x2900005)
[  132.907105] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[  132.915553] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[  132.915592] ALI 5451 0000:00:06.0: restoring config space at offset 0xf=
=20
(was 0x180201ff, writing 0x1802010b)
[  132.915657] ALI 5451 0000:00:06.0: restoring config space at offset 0x1=
=20
(was 0x2900003, writing 0xc2900003)
[  132.916112] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[  132.916148] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[  133.210096] pci 0000:00:07.0: PME# disabled
[  133.210123] ali1535_smbus 0000:00:08.0: enabling device (0000 -> 0001)
[  133.223453] e100 0000:00:0a.0: restoring config space at offset 0xf (was=
=20
0x380801ff, writing 0x3808010b)
[  133.223518] e100 0000:00:0a.0: restoring config space at offset 0x1 (was=
=20
0x2900003, writing 0x2900007)
[  133.223557] e100 0000:00:0a.0: wake-up capability disabled by ACPI
[  133.223571] e100 0000:00:0a.0: PME# disabled
[  133.223650] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x6 (was 0x50200, writing 0xb0050200)
[  133.287090] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[  133.287100] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[  133.300679] ata1.00: configured for UDMA/33
[  133.301152] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[  133.301277] sd 0:0:0:0: [sda] Write Protect is off
[  133.301287] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  133.301481] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[  133.543981] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[  133.543991] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[  133.550553] ata2.00: configured for UDMA/33
[  134.206816] pci 0000:00:12.0: PME# disabled
[  134.206847] pci 0000:01:00.0: PME# disabled
[  134.212275] sd 0:0:0:0: [sda] Starting disk
[  135.540727] eth1: Attempting to download firmware agere_sta_fw.bin
[  135.540762] hermes_dld: AUX enable returned 0
[  135.541780] hermes_dld: AUX disable returned 0
[  135.541786] hermes_dld: Actual PDA length 998, Max allowed 1000
[  135.541793] eth1: Read PDA returned 0
[  135.623956] hermes_dld: AUX enable returned 0
[  135.623963] hermes_dld: Enabling volatile, EP 0x000f8000
[  135.625086] hermes_dld: PROGRAM_ENABLE returned 0
[  135.625092] eth1: Program init returned 0
[  135.625100] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[  135.673296] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[  135.676579] eth1: Program returned 0
[  135.676587] hermes_dld: Found record 0x0003 at debe8c1c
[  135.676607] hermes_dld: Found record 0x0005 at debe8ca8
[  135.676624] hermes_dld: Found record 0x0008 at debe8cd2
[  135.676639] hermes_dld: Found record 0x0007 at debe8cc4
[  135.676656] hermes_dld: Found record 0x0006 at debe8cb6
[  135.676721] hermes_dld: Found record 0x0110 at debe8d9a
[  135.676753] hermes_dld: Found record 0x0120 at debe8dba
[  135.676784] hermes_dld: Found record 0x0130 at debe8dda
[  135.676815] hermes_dld: Found record 0x0140 at debe8dfa
[  135.676827] hermes_dld: Found record 0x0150 at debe8e02
[  135.676838] hermes_dld: Using default record 0x0160 at dfabfb60
[  135.676869] hermes_dld: Found record 0x0101 at debe8d46
[  135.676883] hermes_dld: Found record 0x0103 at debe8d5c
[  135.676901] hermes_dld: Found record 0x0104 at debe8d6c
[  135.676911] hermes_dld: Found record 0x0105 at debe8d72
[  135.676922] hermes_dld: Found record 0x0105 at debe8d72
[  135.676933] hermes_dld: Found record 0x0105 at debe8d72
[  135.676943] hermes_dld: Found record 0x0107 at debe8d7e
[  135.676954] hermes_dld: Found record 0x0109 at debe8d8c
[  135.676970] hermes_dld: Using default record 0x0161 at dfabfb80
[  135.677184] eth1: Apply PDA returned 0
[  135.677247] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[  135.677274] hermes_dld: AUX disable returned 0
[  135.687916] eth1: Program end returned 0
[  135.687923] eth1: hermes_present returned 1
[  135.699834] Restarting tasks ... done.
[  136.042850] eth1: New link status: Connected (0001)


--nextPart10629971.1Q56XLfsat
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl05OcACgkQR6LMutpd94xLFwCgsssxaiv2PXDoQ9+tgvbvbt+A
MNsAoNOsUm4TREJy9qWcZJOQxYYwYlqL
=jkx1
-----END PGP SIGNATURE-----

--nextPart10629971.1Q56XLfsat--
