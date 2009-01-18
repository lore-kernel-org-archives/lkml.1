Return-Path: <linux-kernel-owner+w=401wt.eu-S933260AbZARNmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260AbZARNmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 08:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbZARNmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 08:42:22 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:54956 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753990AbZARNmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 08:42:13 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: [2.6.29-rc2] Inconsistent lock state on resume in hres_timers_resume
Date: Sun, 18 Jan 2009 16:41:52 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1522549.CRbLR7Ohqc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901181642.00886.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1522549.CRbLR7Ohqc
Content-Type: multipart/mixed;
  boundary="Boundary-01=_iGzcJ/KkhG3dsAn"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_iGzcJ/KkhG3dsAn
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

at least, I think it is somewhere in hrt path. Previous resume resulted in=
=20
black screen with dead system, so warning seems real. Full dmesg follows; I=
=20
attach config as well.

[    0.000000] Linux version 2.6.29-rc2-1avb (bor@cooker) (gcc version 4.3.=
2=20
(GCC) ) #1 Sat Jan 17 17:39:44 MSK 2009
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
[    0.000000]   #1 [0000100000 - 0000973d98]    TEXT DATA BSS =3D=3D>=20
[0000100000 - 0000973d98]
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
[    0.000000] Detected 747.727 MHz processor.
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
[    0.003333] Memory: 489984k/507264k available (2103k kernel code, 16676k=
=20
reserved, 795k data, 232k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfffed000 - 0xfffff000   (  72 kB)
[    0.003333]     vmalloc : 0xdf760000 - 0xfffeb000   ( 520 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[    0.003333]       .init : 0xc03d6000 - 0xc0410000   ( 232 kB)
[    0.003333]       .data : 0xc030dee5 - 0xc03d4e00   ( 795 kB)
[    0.003333]       .text : 0xc0100000 - 0xc030dee5   (2103 kB)
[    0.003333] Checking if this processor honours the WP bit even in=20
supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0,=20
CPUs=3D1, Nodes=3D1
[    0.003387] Calibrating delay loop (skipped), value calculated using=20
timer frequency.. 1496.76 BogoMIPS (lpj=3D2492423)
[    0.003553] Mount-cache hash table entries: 512
[    0.005956] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.006005] CPU: L2 cache: 256K
[    0.006020] CPU serial number disabled.
[    0.006075] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.006121] Checking 'hlt' instruction... OK.
[    0.017692] Freeing SMP alternatives: 0k freed
[    0.017713] ACPI: Core revision 20081204
[    0.046419] ACPI: setting ELCR to 0200 (from 0a00)
[    0.049570] Testing tracer nop: PASSED
[    0.054406] net_namespace: 732 bytes
[    0.056106] NET: Registered protocol family 16
[    0.059516] ACPI: bus type pci registered
[    0.061561] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[    0.061612] PCI: Using configuration type 1 for base access
[    0.072890] bio: create slab <bio-0> at 0
[    0.083287] ACPI: EC: Look up EC in DSDT
[    0.111714] ACPI: Interpreter enabled
[    0.111779] ACPI: (supports S0 S3 S4 S5)
[    0.112204] ACPI: Using PIC for interrupt routing
[    0.171384] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.171559] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.172670] pci 0000:00:00.0: reg 10 32bit mmio: [0xf0000000-0xf3ffffff]
[    0.173068] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7eff000-0xf7efffff]
[    0.173210] pci 0000:00:02.0: PME# supported from D3hot D3cold
[    0.173246] pci 0000:00:02.0: PME# disabled
[    0.173469] pci 0000:00:04.0: reg 20 io port: [0xeff0-0xefff]
[    0.173653] pci 0000:00:06.0: reg 10 io port: [0xed00-0xedff]
[    0.173677] pci 0000:00:06.0: reg 14 32bit mmio: [0xf7efe000-0xf7efefff]
[    0.173803] pci 0000:00:06.0: supports D1 D2
[    0.173811] pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
[    0.173839] pci 0000:00:06.0: PME# disabled
[    0.174245] pci 0000:00:08.0: quirk: region ee00-ee3f claimed by ali7101=
=20
ACPI
[    0.174276] pci 0000:00:08.0: quirk: region ef00-ef1f claimed by ali7101=
=20
SMB
[    0.174396] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7efd000-0xf7efdfff]
[    0.174420] pci 0000:00:0a.0: reg 14 io port: [0xeb40-0xeb7f]
[    0.174444] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7d00000-0xf7dfffff]
[    0.174556] pci 0000:00:0a.0: supports D1 D2
[    0.174564] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.174592] pci 0000:00:0a.0: PME# disabled
[    0.174721] pci 0000:00:10.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.174781] pci 0000:00:10.0: supports D1 D2
[    0.174788] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.174817] pci 0000:00:10.0: PME# disabled
[    0.174930] pci 0000:00:11.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.175094] pci 0000:00:11.1: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.175269] pci 0000:00:12.0: reg 10 32bit mmio: [0xf7cffe00-0xf7cfffff]
[    0.175413] pci 0000:00:12.0: supports D1 D2
[    0.175421] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.175450] pci 0000:00:12.0: PME# disabled
[    0.175638] pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfdffffff]
[    0.175661] pci 0000:01:00.0: reg 14 32bit mmio: [0xfbc00000-0xfbffffff]
[    0.175684] pci 0000:01:00.0: reg 18 32bit mmio: [0xf8000000-0xf9ffffff]
[    0.175706] pci 0000:01:00.0: reg 1c 32bit mmio: [0xf7ff8000-0xf7ffffff]
[    0.175752] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.175822] pci 0000:01:00.0: supports D1 D2
[    0.175957] pci 0000:00:01.0: bridge 32bit mmio: [0xf7f00000-0xfdffffff]
[    0.176163] pci_bus 0000:00: on NUMA node 0
[    0.176209] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.176971] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.214343] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[    0.215308] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[    0.216209] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[    0.217245] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[    0.218156] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[    0.219058] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[    0.220675] ACPI: Power Resource [PFAN] (off)
[    0.223921] PCI: Using ACPI for IRQ routing
[    0.227832] pnp: PnP ACPI init
[    0.227832] ACPI: bus type pnp registered
[    0.254110] pnp: PnP ACPI: found 12 devices
[    0.254169] ACPI: ACPI bus type pnp unregistered
[    0.254282] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.254313] system 00:00: iomem range 0xe0000-0xeffff could not be=20
reserved
[    0.254342] system 00:00: iomem range 0xf0000-0xfffff could not be=20
reserved
[    0.254370] system 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[    0.254400] system 00:00: iomem range 0x1ef60000-0x1ef6ffff could not be=
=20
reserved
[    0.254431] system 00:00: iomem range 0x1f000000-0x1fffffff has been=20
reserved
[    0.254457] system 00:00: iomem range 0x1ef70000-0x1effffff has been=20
reserved
[    0.254488] system 00:00: iomem range 0xffe00000-0xffffffff could not be=
=20
reserved
[    0.254583] system 00:08: ioport range 0x370-0x371 has been reserved
[    0.254611] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.254637] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.254663] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.254689] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.254715] system 00:08: ioport range 0x6c0-0x6ff has been reserved
[    0.254742] system 00:08: ioport range 0xe000-0xe07f has been reserved
[    0.254769] system 00:08: ioport range 0xe080-0xe0ff has been reserved
[    0.254796] system 00:08: ioport range 0xe400-0xe47f has been reserved
[    0.254823] system 00:08: ioport range 0xe480-0xe4ff has been reserved
[    0.254850] system 00:08: ioport range 0xe800-0xe87f has been reserved
[    0.254877] system 00:08: ioport range 0xe880-0xe8ff has been reserved
[    0.254904] system 00:08: ioport range 0xec00-0xec7f has been reserved
[    0.254931] system 00:08: ioport range 0xec80-0xecff has been reserved
[    0.254960] system 00:08: ioport range 0xee00-0xee41 could not be=20
reserved
[    0.254987] system 00:08: ioport range 0xee90-0xee9f has been reserved
[    0.255014] system 00:08: ioport range 0xeeac-0xeeac has been reserved
[    0.255042] system 00:08: ioport range 0xef00-0xef3f could not be=20
reserved
[    0.255070] system 00:08: ioport range 0xef40-0xef5f has been reserved
[    0.294211] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.294268] pci 0000:00:01.0:   IO window: disabled
[    0.294300] pci 0000:00:01.0:   MEM window: 0xf7f00000-0xfdffffff
[    0.294331] pci 0000:00:01.0:   PREFETCH window:=20
0x00000048000000-0x000000480fffff
[    0.294377] pci 0000:00:10.0: CardBus bridge, secondary bus 0000:02
[    0.294399] pci 0000:00:10.0:   IO window: 0x001000-0x0010ff
[    0.294426] pci 0000:00:10.0:   IO window: 0x001400-0x0014ff
[    0.294454] pci 0000:00:10.0:   PREFETCH window: 0x30000000-0x33ffffff
[    0.294484] pci 0000:00:10.0:   MEM window: 0x34000000-0x37ffffff
[    0.294514] pci 0000:00:11.0: CardBus bridge, secondary bus 0000:06
[    0.294535] pci 0000:00:11.0:   IO window: 0x001800-0x0018ff
[    0.294562] pci 0000:00:11.0:   IO window: 0x001c00-0x001cff
[    0.294590] pci 0000:00:11.0:   PREFETCH window: 0x38000000-0x3bffffff
[    0.294620] pci 0000:00:11.0:   MEM window: 0x3c000000-0x3fffffff
[    0.294650] pci 0000:00:11.1: CardBus bridge, secondary bus 0000:0a
[    0.294671] pci 0000:00:11.1:   IO window: 0x002000-0x0020ff
[    0.294698] pci 0000:00:11.1:   IO window: 0x002400-0x0024ff
[    0.294726] pci 0000:00:11.1:   PREFETCH window: 0x40000000-0x43ffffff
[    0.294756] pci 0000:00:11.1:   MEM window: 0x44000000-0x47ffffff
[    0.294822] pci 0000:00:01.0: setting latency timer to 64
[    0.294855] pci 0000:00:10.0: enabling device (0000 -> 0003)
[    0.296744] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.296772] PCI: setting IRQ 11 as level-triggered
[    0.296785] pci 0000:00:10.0: PCI INT A -> Link[LNKC] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.296844] pci 0000:00:11.0: enabling device (0000 -> 0003)
[    0.298305] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.298331] pci 0000:00:11.0: PCI INT A -> Link[LNKA] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.298387] pci 0000:00:11.1: enabling device (0000 -> 0003)
[    0.299842] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.299868] pci 0000:00:11.1: PCI INT B -> Link[LNKB] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    0.299915] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.299925] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.299934] pci_bus 0000:01: resource 0 mem: [0x0-0x0]
[    0.299943] pci_bus 0000:01: resource 1 mem: [0xf7f00000-0xfdffffff]
[    0.299952] pci_bus 0000:01: resource 2 mem: [0x48000000-0x480fffff]
[    0.299961] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.300008] pci_bus 0000:02: resource 0 io:  [0x1000-0x10ff]
[    0.300018] pci_bus 0000:02: resource 1 io:  [0x1400-0x14ff]
[    0.300027] pci_bus 0000:02: resource 2 mem: [0x30000000-0x33ffffff]
[    0.300037] pci_bus 0000:02: resource 3 mem: [0x34000000-0x37ffffff]
[    0.300048] pci_bus 0000:06: resource 0 io:  [0x1800-0x18ff]
[    0.300056] pci_bus 0000:06: resource 1 io:  [0x1c00-0x1cff]
[    0.300065] pci_bus 0000:06: resource 2 mem: [0x38000000-0x3bffffff]
[    0.300075] pci_bus 0000:06: resource 3 mem: [0x3c000000-0x3fffffff]
[    0.300085] pci_bus 0000:0a: resource 0 io:  [0x2000-0x20ff]
[    0.300094] pci_bus 0000:0a: resource 1 io:  [0x2400-0x24ff]
[    0.300103] pci_bus 0000:0a: resource 2 mem: [0x40000000-0x43ffffff]
[    0.300113] pci_bus 0000:0a: resource 3 mem: [0x44000000-0x47ffffff]
[    0.300266] NET: Registered protocol family 2
[    0.301461] IP route cache hash table entries: 4096 (order: 2, 16384=20
bytes)
[    0.302506] TCP established hash table entries: 16384 (order: 5, 131072=
=20
bytes)
[    0.303245] TCP bind hash table entries: 16384 (order: 7, 655360 bytes)
[    0.309839] TCP: Hash tables configured (established 16384 bind 16384)
[    0.310256] TCP reno registered
[    0.311022] NET: Registered protocol family 1
[    0.312512] checking if image is initramfs... it is
[    0.796830] Switched to high resolution mode on CPU 0
[    1.224503] Freeing initrd memory: 3586k freed
[    1.233149] Initializing RT-Tester: OK
[    1.234626] audit: initializing netlink socket (disabled)
[    1.234880] type=3D2000 audit(1232262785.233:1): initialized
[    1.243686] Kprobe smoke test started
[    1.255271] Kprobe smoke test passed successfully
[    1.255381] Testing tracer sched_switch: PASSED
[    1.394233] msgmni has been set to 964
[    1.395797] io scheduler noop registered
[    1.395833] io scheduler anticipatory registered
[    1.395852] io scheduler deadline registered
[    1.395984] io scheduler cfq registered (default)
[    1.396252] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    1.396332] pci 0000:00:0a.0: Firmware left e100 interrupts enabled;=20
disabling
[    1.396431] pci 0000:01:00.0: Boot video device
[    1.399581] vesafb: framebuffer at 0xfc000000, mapped to 0xdf780000,=20
using 3072k, total 16384k
[    1.399633] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[    1.399655] vesafb: protected mode interface info at c000:775e
[    1.399676] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[    1.399698] vesafb: scrolling: redraw
[    1.399719] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.467320] Console: switching to colour frame buffer device 128x48
[    1.532839] fb0: VESA VGA frame buffer device
[    1.972178] brd: module loaded
[    1.972629] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
[    1.973730] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.976680] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.977583] e100 0000:00:0a.0: PCI INT A -> Link[LNKD] -> GSI 11 (level,=
=20
low) -> IRQ 11
[    2.005405] e100 0000:00:0a.0: PME# disabled
[    2.007306] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:d7:14:a1
[    2.008741] netconsole: local port 6665
[    2.009228] netconsole: local IP 10.0.0.1
[    2.009726] netconsole: interface eth0
[    2.010494] netconsole: remote port 6666
[    2.010985] netconsole: remote IP 10.0.0.2
[    2.011494] netconsole: remote ethernet address 00:17:42:21:27:e4
[    2.012283] netconsole: device eth0 not up yet, forcing it
[    2.028555] e100: eth0: e100_request_firmware: Failed to load firmware=20
"e100/d101m_ucode.bin": -22
[    2.030525] netconsole: failed to open eth0
[    2.031061] netconsole: cleaning up
[    2.032809] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[    2.039543] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.040340] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.044115] mice: PS/2 mouse device common for all mice
[    2.045538] cpuidle: using governor ladder
[    2.070283] cpuidle: using governor menu
[    2.094762] TCP cubic registered
[    2.118851] Using IPI Shortcut mode
[    2.146101] registered taskstats version 1
[    2.171088] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    2.200398] Freeing unused kernel memory: 232k freed
[    2.226493] Write protecting the kernel text: 2104k
[    2.251103] Write protecting the kernel read-only data: 624k
[    2.297370] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input0
[    2.934696] SCSI subsystem initialized
[    3.004777] Driver 'sd' needs updating - please use bus_type methods
[    3.135887] libata version 3.00 loaded.
[    3.177918] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[    3.202044] scsi0 : pata_ali
[    3.225987] scsi1 : pata_ali
[    3.252828] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq=
=20
14
[    3.275482] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq=
=20
15
[    3.457510] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[    3.479715] ata1.00: 39070080 sectors, multi 0: LBA=20
[    3.501535] ata1.00: limited to UDMA/33 due to 40-wire cable
[    3.537337] ata1.00: configured for UDMA/33
[    3.560742] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0=20
DA3O PQ: 0 ANSI: 5
[    3.584643] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[    3.607121] sd 0:0:0:0: [sda] Write Protect is off
[    3.629354] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.629534] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.654639] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[    3.678341] sd 0:0:0:0: [sda] Write Protect is off
[    3.701726] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.701905] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[    3.726082]  sda: sda1 sda2
[    3.778506] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.977214] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[    4.001118] ata2.00: WARNING: ATAPI DMA disabled for reliablity issues. =
=20
It can be enabled
[    4.025068] ata2.00: WARNING: via pata_ali.atapi_dma modparam or=20
corresponding sysfs node.
[    4.060470] ata2.00: configured for UDMA/33
[    4.089114] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502=20
1313 PQ: 0 ANSI: 5
[    4.371880] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[    4.398032] ReiserFS: sda2: using ordered data mode
[    4.440199] ReiserFS: sda2: journal params: device sda2, size 8192,=20
journal first block 18, max trans len 1024, max batch 900, max commit age=20
30, max trans age 30
[    4.502331] ReiserFS: sda2: checking transaction log (sda2)
[    4.581876] ReiserFS: sda2: Using r5 hash to sort names
[    7.386679] usbcore: registered new interface driver usbfs
[    7.413939] usbcore: registered new interface driver hub
[    7.440838] usbcore: registered new device driver usb
[   14.615288] Linux agpgart interface v0.103
[   14.666077] input: Power Button (FF) as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[   14.676898] ACPI: Power Button (FF) [PWRF]
[   14.677636] input: Lid Switch as=20
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[   14.678101] ACPI: Lid Switch [LID]
[   14.706387] ACPI: AC Adapter [ADP1] (on-line)
[   14.729305] ACPI Warning (nspredef-0940): \_SB_.BAT1._BIF: Return Packag=
e=20
type mismatch at index 12 - found Integer, expected String/Buffer [20081204]
[   14.735600] ACPI: Battery Slot [BAT1] (battery present)
[   14.735868] ACPI: Battery Slot [BAT2] (battery absent)
[   14.766266] agpgart-ali 0000:00:00.0: ALi M1644 chipset
[   14.902607] agpgart-ali 0000:00:00.0: AGP aperture is 64M @ 0xf0000000
[   14.975082] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   14.975935] processor ACPI_CPU:00: registered as cooling_device0
[   15.067646] thermal LNXTHERM:01: registered as thermal_zone0
[   15.069570] ACPI: Thermal Zone [THRM] (37 C)
[   15.144627] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   15.144645] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   15.307679] fan PNP0C0B:00: registered as cooling_device1
[   15.307721] ACPI: Fan [FAN] (off)
[   15.326246] input: Video Bus as=20
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14/device:15/input/input3
[   15.336949] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post:=20
no)
[   15.515906] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   15.518039] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   15.518058] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[   15.518232] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   15.525210] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[   15.525346] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   15.582241] usb usb1: configuration #1 chosen from 1 choice
[   15.583673] hub 1-0:1.0: USB hub found
[   15.584309] hub 1-0:1.0: 3 ports detected
[   15.899758] pci 0000:00:08.0: enabling device (0000 -> 0001)
[   15.901113] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[   16.102135] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   16.218009] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.218329] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   16.465587] Driver 'sr' needs updating - please use bus_type methods
[   16.514216] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   16.514242] Uniform CD-ROM driver Revision: 3.20
[   16.515596] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   16.652464] input: ImPS/2 Generic Wheel Mouse as=20
/devices/platform/i8042/serio1/input/input5
[   16.768730] yenta_cardbus 0000:00:10.0: CardBus bridge found [12a3:ab01]
[   16.894525] yenta_cardbus 0000:00:10.0: ISA IRQ mask 0x0000, PCI irq 11
[   16.894544] yenta_cardbus 0000:00:10.0: Socket status: 30000011
[   16.896654] yenta_cardbus 0000:00:11.0: CardBus bridge found [1179:0001]
[   17.024426] yenta_cardbus 0000:00:11.0: ISA IRQ mask 0x04b8, PCI irq 11
[   17.024444] yenta_cardbus 0000:00:11.0: Socket status: 30000007
[   17.034079] yenta_cardbus 0000:00:11.1: CardBus bridge found [1179:0001]
[   17.162499] yenta_cardbus 0000:00:11.1: ISA IRQ mask 0x04b8, PCI irq 11
[   17.162517] yenta_cardbus 0000:00:11.1: Socket status: 30000007
[   17.530657] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted=20
into slot 0
[   17.579714] rtc_cmos 00:07: RTC can wake from S4
[   17.581781] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   17.581879] rtc0: alarms up to one year, 114 bytes nvram
[   18.515117] NET: Registered protocol family 23
[   18.810200] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[   18.810242] Activated ALi 1533 ISA bridge port 0x02e8.
[   18.810258] Activated ALi 1533 ISA bridge port 0x02f8.
[   18.810514] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[   18.810530] smsc_superio_flat(): IrDA not enabled
[   18.810558] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x02
[   18.810599] SMsC IrDA Controller found
[   18.810602]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[   18.810822] No transceiver found. Defaulting to Fast pin select
[   18.810864] irda0 (): not using net_device_ops yet
[   18.811871] IrDA: Registered device irda0
[   20.638031] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[   20.639632] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   20.639651] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[   24.331300] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   24.337691] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   24.341062] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   24.344389] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   24.345792] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   24.348475] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   24.363177] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   24.364933] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   24.366325] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   24.385631] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   24.621530] Marking TSC unstable due to TSC halts in idle
[   24.793419] Clocksource tsc unstable (delta =3D -200528285 ns)
[   25.071083] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:=
=20
excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   25.074775] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:=
=20
clean.
[   25.076294] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:=
=20
clean.
[   25.077742] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:=
=20
clean.
[   25.080343] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:=
=20
clean.
[   25.082369] pcmcia_socket pcmcia_socket0: cs: memory probe=20
0xa0000000-0xa0ffffff: clean.
[   25.097658] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[   25.442349] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>,=20
Pavel Roskin <proski@gnu.org>, et al)
[   25.538930] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
,=20
Pavel Roskin <proski@gnu.org>, et al)
[   25.581666] eth1 (orinoco_cs): not using net_device_ops yet
[   25.621420] eth1: Hardware identity 0005:0002:0001:0002
[   25.621534] eth1: Station identity  001f:0001:0006:000e
[   25.621545] eth1: Firmware determined as Lucent/Agere 6.14
[   25.621994] eth1: Attempting to download firmware agere_sta_fw.bin
[   25.622026] hermes_dld: AUX enable returned 0
[   25.623030] hermes_dld: AUX disable returned 0
[   25.623038] hermes_dld: Actual PDA length 998, Max allowed 1000
[   25.623046] eth1: Read PDA returned 0
[   25.623058] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[   25.745384] hermes_dld: AUX enable returned 0
[   25.745401] hermes_dld: Enabling volatile, EP 0x000f8000
[   25.746492] hermes_dld: PROGRAM_ENABLE returned 0
[   25.746500] eth1: Program init returned 0
[   25.746509] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[   25.794601] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[   25.797876] eth1: Program returned 0
[   25.797888] hermes_dld: Found record 0x0003 at de66b41c
[   25.797909] hermes_dld: Found record 0x0005 at de66b4a8
[   25.797928] hermes_dld: Found record 0x0008 at de66b4d2
[   25.797944] hermes_dld: Found record 0x0007 at de66b4c4
[   25.797962] hermes_dld: Found record 0x0006 at de66b4b6
[   25.797982] hermes_dld: Found record 0x0110 at de66b59a
[   25.798016] hermes_dld: Found record 0x0120 at de66b5ba
[   25.798049] hermes_dld: Found record 0x0130 at de66b5da
[   25.798081] hermes_dld: Found record 0x0140 at de66b5fa
[   25.798095] hermes_dld: Found record 0x0150 at de66b602
[   25.798108] hermes_dld: Using default record 0x0160 at dfb0fb60
[   25.798141] hermes_dld: Found record 0x0101 at de66b546
[   25.798156] hermes_dld: Found record 0x0103 at de66b55c
[   25.798176] hermes_dld: Found record 0x0104 at de66b56c
[   25.798188] hermes_dld: Found record 0x0105 at de66b572
[   25.798200] hermes_dld: Found record 0x0105 at de66b572
[   25.798212] hermes_dld: Found record 0x0105 at de66b572
[   25.798224] hermes_dld: Found record 0x0107 at de66b57e
[   25.798236] hermes_dld: Found record 0x0109 at de66b58c
[   25.798255] hermes_dld: Using default record 0x0161 at dfb0fb80
[   25.798470] eth1: Apply PDA returned 0
[   25.798534] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[   25.798563] hermes_dld: AUX disable returned 0
[   25.809208] eth1: Program end returned 0
[   25.809217] eth1: hermes_present returned 1
[   25.810071] eth1: Hardware identity 0005:0002:0001:0002
[   25.810195] eth1: Station identity  001f:0002:0009:0030
[   25.810207] eth1: Firmware determined as Lucent/Agere 9.48
[   25.810216] eth1: Ad-hoc demo mode supported
[   25.810223] eth1: IEEE standard IBSS ad-hoc mode supported
[   25.810230] eth1: WEP supported, 104-bit key
[   25.810238] eth1: WPA-PSK supported
[   26.501955] eth1: MAC address 00:02:2d:26:95:6c
[   26.502071] eth1: Station name "HERMES I"
[   26.502794] eth1: ready
[   26.503770] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[   26.848486] Toshiba System Management Mode driver v1.11 26/9/2001
[   26.910498] Non-volatile memory driver v1.3
[   27.774924] device-mapper: uevent: version 1.0.3
[   27.777120] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
=20
dm-devel@redhat.com
[   28.005216] device-mapper: multipath: version 1.0.5 loaded
[   29.599977] device-mapper: multipath round-robin: version 1.0.0 loaded
[   29.601327] device-mapper: table: 254:0: multipath: error getting device
[   29.601345] device-mapper: ioctl: error adding target to table
[   37.512001] loop: module loaded
[   42.999188] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k=20
[   47.154644] IrCOMM protocol (Dag Brattli)
[   50.219051] PPP generic driver version 2.4.2
[   56.649125] NET: Registered protocol family 17
[   57.064141] eth1: Lucent/Agere firmware doesn't support manual roaming
[   57.230035] eth1: New link status: Connected (0001)
[ 1424.976778] usb 1-1: new full speed USB device using ohci_hcd and addres=
s=20
2
[ 1425.273541] usb 1-1: configuration #1 chosen from 1 choice
[ 1425.520764] Bluetooth: Core ver 2.14
[ 1425.522079] NET: Registered protocol family 31
[ 1425.522093] Bluetooth: HCI device and connection manager initialized
[ 1425.522975] Bluetooth: HCI socket layer initialized
[ 1471.803278] usb 1-1: USB disconnect, address 2
[ 1475.789984] usb 1-1: new full speed USB device using ohci_hcd and addres=
s=20
3
[ 1476.087287] usb 1-1: configuration #1 chosen from 1 choice
[ 2268.793247] usb 1-1: USB disconnect, address 3
[ 2641.646528] usb 1-1: new full speed USB device using ohci_hcd and addres=
s=20
4
[ 2641.936946] usb 1-1: configuration #1 chosen from 1 choice
[ 2643.417663] Bluetooth: Generic Bluetooth USB driver ver 0.4
[ 2643.422437] usbcore: registered new interface driver btusb
[ 2648.321798] Bluetooth: L2CAP ver 2.11
[ 2648.321823] Bluetooth: L2CAP socket layer initialized
[ 2648.941501] Bluetooth: RFCOMM socket layer initialized
[ 2648.941596] Bluetooth: RFCOMM TTY layer initialized
[ 2648.941605] Bluetooth: RFCOMM ver 1.10
[ 2649.198619] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[ 2649.760381] bluetoothd[14690]: segfault at 33462d3d ip 33462d3d sp=20
bfdc4f7c error 4 in input.so[b7ca4000+7000]
[ 3712.071493] usb 1-1: USB disconnect, address 4
[ 3712.072276] btusb_intr_complete: hci0 urb de7e8500 failed to resubmit=20
(19)
[ 3712.088751] btusb_send_frame: hci0 urb d770b980 submission failed
[ 3712.796728] hub 1-0:1.0: unable to enumerate USB device on port 1
[ 3742.666400] usb 1-2: new full speed USB device using ohci_hcd and addres=
s=20
6
[ 3742.869875] usb 1-2: configuration #1 chosen from 1 choice
[ 3743.369617] Initializing USB Mass Storage driver...
[ 3743.374535] scsi2 : SCSI emulation for USB Mass Storage devices
[ 3743.379271] usbcore: registered new interface driver usb-storage
[ 3743.379300] USB Mass Storage support registered.
[ 3743.401626] usb-storage: device found at 6
[ 3743.401645] usb-storage: waiting for device to settle before scanning
[ 3748.408952] scsi 2:0:0:0: Direct-Access     CBM      Flash Disk      =20
5.00 PQ: 0 ANSI: 2
[ 3748.434331] sd 2:0:0:0: [sdb] 257792 512-byte hardware sectors: (131=20
MB/125 MiB)
[ 3748.442873] sd 2:0:0:0: [sdb] Write Protect is off
[ 3748.442901] sd 2:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[ 3748.442911] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[ 3748.465826] sd 2:0:0:0: [sdb] 257792 512-byte hardware sectors: (131=20
MB/125 MiB)
[ 3748.472807] sd 2:0:0:0: [sdb] Write Protect is off
[ 3748.472832] sd 2:0:0:0: [sdb] Mode Sense: 0b 00 00 08
[ 3748.472841] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[ 3748.472862]  sdb: sdb1
[ 3748.492871] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[ 3748.507001] sd 2:0:0:0: Attached scsi generic sg2 type 0
[ 3748.514442] usb-storage: device scan complete
[ 7286.551236] usb 1-2: USB disconnect, address 6
[ 8835.243495] Bluetooth: RFCOMM socket layer initialized
[ 8835.243588] Bluetooth: RFCOMM TTY layer initialized
[ 8835.243596] Bluetooth: RFCOMM ver 1.10
[ 9003.362634] usb 1-1: new full speed USB device using ohci_hcd and addres=
s=20
7
[ 9003.656480] usb 1-1: configuration #1 chosen from 1 choice
[ 9014.227076] bluetoothd[16121]: segfault at 33462d3d ip 33462d3d sp=20
bfa1d12c error 4 in input.so[b7bff000+7000]
[ 9065.822051] usb 1-1: USB disconnect, address 7
[ 9065.822356] btusb_intr_complete: hci0 urb ddc22c80 failed to resubmit=20
(19)
[ 9065.840571] btusb_send_frame: hci0 urb ca0ba280 submission failed
[ 9100.247477] Bluetooth: RFCOMM socket layer initialized
[ 9100.247568] Bluetooth: RFCOMM TTY layer initialized
[ 9100.247576] Bluetooth: RFCOMM ver 1.10
[ 9121.819215] usb 1-1: new full speed USB device using ohci_hcd and addres=
s=20
8
[ 9122.112701] usb 1-1: configuration #1 chosen from 1 choice
[ 9276.730179] bluetoothd[16317]: segfault at 33462d3d ip 33462d3d sp=20
bfce904c error 4 in input.so[b7ccb000+7000]
[ 9281.491396] usb 1-1: USB disconnect, address 8
[ 9281.491722] btusb_intr_complete: hci0 urb ca3b2d00 failed to resubmit=20
(19)
[ 9281.504863] btusb_send_frame: hci0 urb d75ee880 submission failed
[ 9314.600710] Bluetooth: RFCOMM socket layer initialized
[ 9314.600806] Bluetooth: RFCOMM TTY layer initialized
[ 9314.600814] Bluetooth: RFCOMM ver 1.10
[ 9340.699254] usb 1-1: new full speed USB device using ohci_hcd and addres=
s=20
9
[ 9340.997198] usb 1-1: configuration #1 chosen from 1 choice
[ 9414.902858] bluetoothd[16480]: segfault at 33462d3d ip 33462d3d sp=20
bfa1256c error 4 in input.so[b7bf2000+7000]
[ 9425.547461] usb 1-1: USB disconnect, address 9
[ 9425.548299] btusb_intr_complete: hci0 urb ca3b2e00 failed to resubmit=20
(19)
[ 9425.561615] btusb_send_frame: hci0 urb ca1c6980 submission failed
[15009.983787] zsh[17158]: segfault at 3722d00 ip b7d604d2 sp bfd98280 erro=
r=20
4 in complist.so[b7d5b000+d000]
[15081.162637] zsh[17261]: segfault at 88 ip b7c144d8 sp bff4a430 error 4 i=
n=20
complist.so[b7c0f000+d000]
[15124.377990] zsh[17344]: segfault at 353348 ip b7d724d2 sp bfda7a90 error=
=20
4 in complist.so[b7d6d000+d000]
[15187.189266] zsh[17428]: segfault at 3f20139 ip b7da34d8 sp bfcd91c0 erro=
r=20
4 in complist.so[b7d9e000+d000]
[15275.419934] zsh[17594]: segfault at 322e476 ip b7d124d2 sp bff48430 erro=
r=20
4 in complist.so[b7d0d000+d000]
[15299.794884] zsh[17677]: segfault at 3000094 ip b7c1d4d2 sp bf852d30 erro=
r=20
4 in complist.so[b7c18000+d000]
[15368.921580] zsh[17762]: segfault at 76 ip b7d1d4d8 sp bff55430 error 4 i=
n=20
complist.so[b7d18000+d000]
[15808.127010] zsh[17880]: segfault at 3000102 ip b7c904d2 sp bfc6a940 erro=
r=20
4 in complist.so[b7c8b000+d000]
[15869.272461] zsh[17909]: segfault at 30001ca ip b7c7b4d2 sp bf955e20 erro=
r=20
4 in complist.so[b7c76000+d000]
[16254.069164] zsh[17965]: segfault at 300016e ip b7c4e4d2 sp bff293f0 erro=
r=20
4 in complist.so[b7c49000+d000]
[17852.071266] PM: Syncing filesystems ... done.
[17852.762783] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[17852.990465] Freezing user space processes ... (elapsed 0.07 seconds)=20
done.
[17853.060540] Freezing remaining freezable tasks ... (elapsed 0.02 seconds=
)=20
done.
[17853.081892] Suspending console(s) (use no_console_suspend to debug)
[17853.093406] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[17853.094422] sd 0:0:0:0: [sda] Stopping disk
[17853.787896] pci 0000:01:00.0: power state changed by ACPI to D3
[17853.799467] e100 0000:00:0a.0: PME# enabled
[17853.799709] e100 0000:00:0a.0: wake-up capability enabled by ACPI
[17853.799886] e100 0000:00:0a.0: PCI INT A disabled
[17853.858759] ALI 5451 0000:00:06.0: PCI INT A disabled
[17853.872025] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[17854.645211] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[17854.658525] ohci_hcd 0000:00:02.0: PME# enabled
[17854.658749] ohci_hcd 0000:00:02.0: wake-up capability enabled by ACPI
[17854.658780] ohci_hcd 0000:00:02.0: PCI INT A disabled
[17854.675256] ACPI: Preparing to enter system sleep state S3
[17854.688347] Back to C!
[17854.688347]=20
[17854.688347] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[17854.688347] [ INFO: inconsistent lock state ]
[17854.688347] 2.6.29-rc2-1avb #1
[17854.688347] ---------------------------------
[17854.688347] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
[17854.688347] pm-suspend/18240 [HC0[0]:SC0[0]:HE1:SE1] takes:
[17854.688347]  (&cpu_base->lock){++..}, at: [<c0136fcc>]=20
retrigger_next_event+0x5c/0xa0
[17854.688347] {in-hardirq-W} state was registered at:
[17854.688347]   [<c01443cd>] __lock_acquire+0x79d/0x1930
[17854.688347]   [<c01455bc>] lock_acquire+0x5c/0x80
[17854.688347]   [<c03092e5>] _spin_lock+0x35/0x70
[17854.688347]   [<c0136e61>] hrtimer_run_queues+0x31/0x140
[17854.688347]   [<c0128d98>] run_local_timers+0x8/0x20
[17854.688347]   [<c0128dd3>] update_process_times+0x23/0x60
[17854.688347]   [<c013e274>] tick_periodic+0x24/0x80
[17854.688347]   [<c013e2e2>] tick_handle_periodic+0x12/0x70
[17854.688347]   [<c0104e24>] timer_interrupt+0x14/0x20
[17854.688347]   [<c01607b9>] handle_IRQ_event+0x29/0x60
[17854.688347]   [<c0161c59>] handle_level_irq+0x69/0xe0
[17854.688347]   [<ffffffff>] 0xffffffff
[17854.688347] irq event stamp: 55771
[17854.688347] hardirqs last  enabled at (55771): [<c0309125>]=20
_spin_unlock_irqrestore+0x35/0x60
[17854.688347] hardirqs last disabled at (55770): [<c0309419>]=20
_spin_lock_irqsave+0x19/0x80
[17854.688347] softirqs last  enabled at (54836): [<c0124f54>]=20
__do_softirq+0xc4/0x110
[17854.688347] softirqs last disabled at (54831): [<c01049ae>]=20
do_softirq+0x8e/0xe0
[17854.688347]=20
[17854.688347] other info that might help us debug this:
[17854.688347] 3 locks held by pm-suspend/18240:
[17854.688347]  #0:  (&buffer->mutex){--..}, at: [<c01dd4c5>]=20
sysfs_write_file+0x25/0x100
[17854.688347]  #1:  (pm_mutex){--..}, at: [<c015056f>]=20
enter_state+0x4f/0x140
[17854.688347]  #2:  (dpm_list_mtx){--..}, at: [<c027880f>]=20
device_pm_lock+0xf/0x20
[17854.688347]=20
[17854.688347] stack backtrace:
[17854.688347] Pid: 18240, comm: pm-suspend Not tainted 2.6.29-rc2-1avb #1
[17854.688347] Call Trace:
[17854.688347]  [<c0306248>] ? printk+0x18/0x20
[17854.688347]  [<c0141fac>] print_usage_bug+0x16c/0x1d0
[17854.688347]  [<c0142bcf>] mark_lock+0x8bf/0xc90
[17854.688347]  [<c0106b8f>] ? pit_next_event+0x2f/0x40
[17854.688347]  [<c01441b0>] __lock_acquire+0x580/0x1930
[17854.688347]  [<c030916d>] ? _spin_unlock+0x1d/0x20
[17854.688347]  [<c0106b8f>] ? pit_next_event+0x2f/0x40
[17854.688347]  [<c013dd38>] ? clockevents_program_event+0x98/0x160
[17854.688347]  [<c0142fe8>] ? mark_held_locks+0x48/0x90
[17854.688347]  [<c0309125>] ? _spin_unlock_irqrestore+0x35/0x60
[17854.688347]  [<c0143229>] ? trace_hardirqs_on_caller+0x139/0x190
[17854.688347]  [<c014328b>] ? trace_hardirqs_on+0xb/0x10
[17854.688347]  [<c01455bc>] lock_acquire+0x5c/0x80
[17854.688347]  [<c0136fcc>] ? retrigger_next_event+0x5c/0xa0
[17854.688347]  [<c03092e5>] _spin_lock+0x35/0x70
[17854.688347]  [<c0136fcc>] ? retrigger_next_event+0x5c/0xa0
[17854.688347]  [<c0136fcc>] retrigger_next_event+0x5c/0xa0
[17854.688347]  [<c013711a>] hres_timers_resume+0xa/0x10
[17854.688347]  [<c013aa8e>] timekeeping_resume+0xee/0x150
[17854.688347]  [<c0273384>] __sysdev_resume+0x14/0x50
[17854.688347]  [<c0273407>] sysdev_resume+0x47/0x80
[17854.688347]  [<c02791ab>] device_power_up+0xb/0x20
[17854.688347]  [<c015043f>] suspend_devices_and_enter+0xcf/0x150
[17854.688347]  [<c0150c2f>] ? freeze_processes+0x3f/0x90
[17854.688347]  [<c0150614>] enter_state+0xf4/0x140
[17854.688347]  [<c01506dd>] state_store+0x7d/0xc0
[17854.688347]  [<c0150660>] ? state_store+0x0/0xc0
[17854.688347]  [<c0202da4>] kobj_attr_store+0x24/0x30
[17854.688347]  [<c01dd53c>] sysfs_write_file+0x9c/0x100
[17854.688347]  [<c019916c>] vfs_write+0x9c/0x160
[17854.688347]  [<c0103494>] ? restore_nocheck_notrace+0x0/0xe
[17854.688347]  [<c01dd4a0>] ? sysfs_write_file+0x0/0x100
[17854.688347]  [<c01992ed>] sys_write+0x3d/0x70
[17854.688347]  [<c0103371>] sysenter_do_call+0x12/0x31
[17854.711690] ohci_hcd 0000:00:02.0: restoring config space at offset 0xf=
=20
(was 0x500001ff, writing 0x5000010b)
[17854.711891] pci 0000:00:12.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[17854.711967] pci 0000:01:00.0: restoring config space at offset 0xf (was=
=20
0x1ff, writing 0x10b)
[17854.712326] ACPI: Waking up from system sleep state S3
[17854.727919] agpgart-ali 0000:00:00.0: PME# disabled
[17854.727961] pci 0000:00:01.0: setting latency timer to 64
[17854.728001] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11=20
(level, low) -> IRQ 11
[17854.728022] ohci_hcd 0000:00:02.0: wake-up capability disabled by ACPI
[17854.728034] ohci_hcd 0000:00:02.0: PME# disabled
[17854.780338] usb usb1: root hub lost power or was reset
[17854.791691] pata_ali 0000:00:04.0: restoring config space at offset 0x1=
=20
(was 0x2900001, writing 0x2900005)
[17854.791729] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[17854.797232] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[17854.797260] ALI 5451 0000:00:06.0: restoring config space at offset 0xf=
=20
(was 0x180201ff, writing 0x1802010b)
[17854.797446] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[17854.797472] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11=20
(level, low) -> IRQ 11
[17855.084965] pci 0000:00:07.0: PME# disabled
[17855.084986] ali1535_smbus 0000:00:08.0: enabling device (0000 -> 0001)
[17855.098326] e100 0000:00:0a.0: restoring config space at offset 0xf (was=
=20
0x380801ff, writing 0x3808010b)
[17855.098370] e100 0000:00:0a.0: restoring config space at offset 0x1 (was=
=20
0x2900003, writing 0x2900007)
[17855.098397] e100 0000:00:0a.0: wake-up capability disabled by ACPI
[17855.098408] e100 0000:00:0a.0: PME# disabled
[17855.098461] yenta_cardbus 0000:00:10.0: restoring config space at offset=
=20
0x6 (was 0x50200, writing 0xb0050200)
[17855.375541] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[17855.375551] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[17855.382106] ata2.00: configured for UDMA/33
[17856.081662] pci 0000:00:12.0: PME# disabled
[17856.081684] pci 0000:01:00.0: PME# disabled
[17856.085875] sd 0:0:0:0: [sda] Starting disk
[17857.051972] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[17857.051982] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[17857.065642] ata1.00: configured for UDMA/33
[17857.091721] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0=
=20
GB/18.6 GiB)
[17857.091813] sd 0:0:0:0: [sda] Write Protect is off
[17857.091822] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[17857.091951] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[17857.344981] eth1: Attempting to download firmware agere_sta_fw.bin
[17857.345012] hermes_dld: AUX enable returned 0
[17857.346042] hermes_dld: AUX disable returned 0
[17857.346048] hermes_dld: Actual PDA length 998, Max allowed 1000
[17857.346054] eth1: Read PDA returned 0
[17857.428222] hermes_dld: AUX enable returned 0
[17857.428266] hermes_dld: Enabling volatile, EP 0x000f8000
[17857.429332] hermes_dld: PROGRAM_ENABLE returned 0
[17857.429338] eth1: Program init returned 0
[17857.429346] hermes_dld: Programming block of length 60416 to address=20
0x001f0000
[17857.477388] hermes_dld: Programming block of length 4096 to address=20
0x001ef000
[17857.480655] eth1: Program returned 0
[17857.480663] hermes_dld: Found record 0x0003 at dc68b81c
[17857.480682] hermes_dld: Found record 0x0005 at dc68b8a8
[17857.480699] hermes_dld: Found record 0x0008 at dc68b8d2
[17857.480715] hermes_dld: Found record 0x0007 at dc68b8c4
[17857.480731] hermes_dld: Found record 0x0006 at dc68b8b6
[17857.480748] hermes_dld: Found record 0x0110 at dc68b99a
[17857.480780] hermes_dld: Found record 0x0120 at dc68b9ba
[17857.480811] hermes_dld: Found record 0x0130 at dc68b9da
[17857.480842] hermes_dld: Found record 0x0140 at dc68b9fa
[17857.480854] hermes_dld: Found record 0x0150 at dc68ba02
[17857.480866] hermes_dld: Using default record 0x0160 at dfb0fb60
[17857.480898] hermes_dld: Found record 0x0101 at dc68b946
[17857.480911] hermes_dld: Found record 0x0103 at dc68b95c
[17857.480930] hermes_dld: Found record 0x0104 at dc68b96c
[17857.480940] hermes_dld: Found record 0x0105 at dc68b972
[17857.480951] hermes_dld: Found record 0x0105 at dc68b972
[17857.480962] hermes_dld: Found record 0x0105 at dc68b972
[17857.480972] hermes_dld: Found record 0x0107 at dc68b97e
[17857.480983] hermes_dld: Found record 0x0109 at dc68b98c
[17857.481000] hermes_dld: Using default record 0x0161 at dfb0fb80
[17857.481215] eth1: Apply PDA returned 0
[17857.481277] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
,=20
r2 0x0000
[17857.481304] hermes_dld: AUX disable returned 0
[17857.491948] eth1: Program end returned 0
[17857.491955] eth1: hermes_present returned 1
[17857.504600] Restarting tasks ... <6>eth1: New link status: Connected=20
(0001)
[17857.610856] done.


--Boundary-01=_iGzcJ/KkhG3dsAn
Content-Type: text/plain;
  charset="us-ascii";
  name="config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc2
# Sat Jan 17 15:11:19 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
# CONFIG_CGROUPS is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
# CONFIG_NAMESPACES is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_STRIP_GENERATED=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
# CONFIG_CPU_SUP_CYRIX_32 is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR_32 is not set
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_TOSHIBA=m
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
CONFIG_NOHIGHMEM=y
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
# CONFIG_X86_PAE is not set
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=m
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
# CONFIG_YENTA_O2 is not set
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=m
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=m
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIBTUSB is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
# CONFIG_LIB80211 is not set
# CONFIG_MAC80211 is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="\"\""
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=32000
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=m
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=m
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set

#
# Other IDE chipsets support
#

#
# Note: most of these also require special kernel boot parameters
#
# CONFIG_BLK_DEV_4DRIVES is not set
# CONFIG_BLK_DEV_ALI14XX is not set
# CONFIG_BLK_DEV_DTC2278 is not set
# CONFIG_BLK_DEV_HT6560B is not set
# CONFIG_BLK_DEV_QD65XX is not set
# CONFIG_BLK_DEV_UMC8672 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=m
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_7000FASST is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AHA152X is not set
# CONFIG_SCSI_AHA1542 is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_IN2000 is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_FCOE is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_DTC3280 is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_GENERIC_NCR5380 is not set
# CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SYM53C416 is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_T128 is not set
# CONFIG_SCSI_U14_34F is not set
# CONFIG_SCSI_ULTRASTOR is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_QDI is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_WINBOND_VLB is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_LANCE is not set
# CONFIG_NET_VENDOR_SMC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_NET_TULIP is not set
# CONFIG_AT1700 is not set
# CONFIG_DEPCA is not set
# CONFIG_HP100 is not set
# CONFIG_NET_ISA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
CONFIG_E100=y
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_R6040 is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC9420 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_ATL2 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_HOSTAP is not set
CONFIG_HERMES=m
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
# CONFIG_PCI_HERMES is not set
CONFIG_PCMCIA_HERMES=m
# CONFIG_PCMCIA_SPECTRUM is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_HSO is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=m
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_PCA_ISA is not set
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_STUB=m
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# ISA-based Watchdog Cards
#
# CONFIG_PCWATCHDOG is not set
# CONFIG_MIXCOMWD is not set
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_ALI=m
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
# CONFIG_FB_DDC is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_CYBLA=m
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=60
# CONFIG_SND_ISA is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_GREENASIA_FF is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# Enable Host or Gadget support to see Inventra options
#

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP2101 is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=m
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=866
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=m
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_KPROBES_SANITY_TEST=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_HW_BRANCH_TRACER=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_HW_BRANCH_TRACER is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=m
CONFIG_CRYPTO_ALGAPI2=m
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=m
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_HASH2=m
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=m
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=m
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--Boundary-01=_iGzcJ/KkhG3dsAn--

--nextPart1522549.CRbLR7Ohqc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklzMaIACgkQR6LMutpd94wq0ACgyjDCpa4e3KEQhG+Qg1umC3sp
QsUAnibhuk3qdPdEP+5kav2OpCZW85nO
=6/5A
-----END PGP SIGNATURE-----

--nextPart1522549.CRbLR7Ohqc--
