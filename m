Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYKDS2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYKDS2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYKDS2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:28:23 -0500
Received: from mx71.mail.ru ([194.67.23.4]:64581 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbYKDS2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:28:20 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ide@vger.kernel.org
Subject: 2.6.28-rc3: WARN_ON(ap->nr_active_links) in ata_eh_finish() with pata_ali DMA CD-ROM
Date: Tue, 4 Nov 2008 21:28:05 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4545247.dXvYFO2xiD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811042128.10356.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4545247.dXvYFO2xiD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Every now and then I give pata_ali CD-ROM DMA a test. This time I got
someting new - not only usual timeouts but also WARN_ON. There was a
whole bunch of subsequent WARN_ON's, but they are likely to be just
followup errors.

Also, in the past ejecting media from drive would abort processing and
all commands waiting for completion would return to prompt. Now they
seem to hang forever.

Dmesg follows.

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc3-1avb (bor@cooker) (gcc version 4.3.=
2 (GCC) ) #10 Tue Nov 4 00:57:56 MSK 2008
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
[    0.000000] RAMDISK: 1ebd6000 - 1ef4f666
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
 4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
 4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
 100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: DMI detected: Toshiba
[    0.000000] 495MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1ef60000
[    0.000000]   low ram: 00000000 - 1ef60000
[    0.000000]   bootmap 00001000 - 00004dec
[    0.000000] (7 early reservations) =3D=3D> bootmem [0000000000 - 001ef60=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 0000943b74]    TEXT DATA BSS =3D=3D> [000=
0100000 - 0000943b74]
[    0.000000]   #2 [001ebd6000 - 001ef4f666]          RAMDISK =3D=3D> [001=
ebd6000 - 001ef4f666]
[    0.000000]   #3 [0000944000 - 0000948000]    INIT_PG_TABLE =3D=3D> [000=
0944000 - 0000948000]
[    0.000000]   #4 [000009fc00 - 0000100000]    BIOS reserved =3D=3D> [000=
009fc00 - 0000100000]
[    0.000000]   #5 [0000007000 - 0000009000]          PGTABLE =3D=3D> [000=
0007000 - 0000009000]
[    0.000000]   #6 [0000001000 - 0000005000]          BOOTMAP =3D=3D> [000=
0001000 - 0000005000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001ef60
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001ef60
[    0.000000] On node 0 totalpages: 126719
[    0.000000] free_area_init_node: node 0, pgdat c03dcd40, node_mem_map c1=
000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 959 pages used for memmap
[    0.000000]   Normal zone: 121761 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 00000000000=
ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 00000000000=
ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 00000000001=
00000
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000=
:dff80000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 125728
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.28-rc3-1avb root=3DLAB=
EL=3D/ resume=3DLABEL=3Dswap acpi_backlight=3Dvendor netconsole=3D@10.0.0.1=
/eth0,@10.0.0.2/00:17:42:21:27:e4 vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0427000 soft=3Dc0426000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 747.776 MHz processor.
[    0.003333] Console: colour dummy device 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:           4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2463 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333] ------------------------------------------------------------=
=2D---------------
[    0.003333]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.003333]   ----------------------------------------------------------=
=2D---------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.003333]   ----------------------------------------------------------=
=2D---------------
[    0.003333]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.003333]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.003333]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.003333]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.003333]   ----------------------------------------------------------=
=2D---------------
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
[    0.003333] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.003333] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.003333] Memory: 490176k/507264k available (2034k kernel code, 16452k=
 reserved, 937k data, 236k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xffffa000 - 0xfffff000   (  20 kB)
[    0.003333]     vmalloc : 0xdf760000 - 0xffff8000   ( 520 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[    0.003333]       .init : 0xc03e8000 - 0xc0423000   ( 236 kB)
[    0.003333]       .data : 0xc02fca92 - 0xc03e6edc   ( 937 kB)
[    0.003333]       .text : 0xc0100000 - 0xc02fca92   (2034 kB)
[    0.003333] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.003333] SLUB: Genslabs=3D12, HWalign=3D32, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.003415] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 1496.86 BogoMIPS (lpj=3D2492586)
[    0.003600] Mount-cache hash table entries: 512
[    0.006006] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.006045] CPU: L2 cache: 256K
[    0.006105] CPU: Intel Pentium III (Coppermine) stepping 0a
[    0.006155] Checking 'hlt' instruction... OK.
[    0.017717] Freeing SMP alternatives: 0k freed
[    0.017741] ACPI: Core revision 20080926
[    0.048698] ACPI: setting ELCR to 0200 (from 0a00)
[    0.052161] Testing tracer nop: PASSED
[    0.056223] net_namespace: 392 bytes
[    0.056393] Toshiba Portege 4000 series board detected. Selecting BIOS-m=
ethod for reboots.
[    0.057846] NET: Registered protocol family 16
[    0.061406] ACPI: bus type pci registered
[    0.063463] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[    0.063514] PCI: Using configuration type 1 for base access
[    0.084183] ACPI: EC: Look up EC in DSDT
[    0.113840] ACPI: Interpreter enabled
[    0.113900] ACPI: (supports S0 S3 S4 S5)
[    0.114326] ACPI: Using PIC for interrupt routing
[    0.172687] ACPI: ACPI Dock Station Driver: 2 docks/bays found
[    0.172856] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.174087] pci 0000:00:00.0: reg 10 32bit mmio: [0xf0000000-0xf3ffffff]
[    0.174453] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7eff000-0xf7efffff]
[    0.174583] pci 0000:00:02.0: PME# supported from D3hot D3cold
[    0.174626] pci 0000:00:02.0: PME# disabled
[    0.174813] pci 0000:00:04.0: reg 20 io port: [0xeff0-0xefff]
[    0.174994] pci 0000:00:06.0: reg 10 io port: [0xed00-0xedff]
[    0.175020] pci 0000:00:06.0: reg 14 32bit mmio: [0xf7efe000-0xf7efefff]
[    0.175131] pci 0000:00:06.0: supports D1 D2
[    0.175139] pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
[    0.175169] pci 0000:00:06.0: PME# disabled
[    0.175615] pci 0000:00:08.0: quirk: region ee00-ee3f claimed by ali7101=
 ACPI
[    0.175647] pci 0000:00:08.0: quirk: region ef00-ef1f claimed by ali7101=
 SMB
[    0.175773] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7efd000-0xf7efdfff]
[    0.175800] pci 0000:00:0a.0: reg 14 io port: [0xeb40-0xeb7f]
[    0.175825] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7d00000-0xf7dfffff]
[    0.175921] pci 0000:00:0a.0: supports D1 D2
[    0.175929] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.175960] pci 0000:00:0a.0: PME# disabled
[    0.176104] pci 0000:00:10.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.176139] pci 0000:00:10.0: supports D1 D2
[    0.176147] pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.176178] pci 0000:00:10.0: PME# disabled
[    0.176304] pci 0000:00:11.0: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.176449] pci 0000:00:11.1: reg 10 32bit mmio: [0x000000-0x000fff]
[    0.176613] pci 0000:00:12.0: reg 10 32bit mmio: [0xf7cffe00-0xf7cfffff]
[    0.176796] pci 0000:00:12.0: supports D1 D2
[    0.176805] pci 0000:00:12.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.176836] pci 0000:00:12.0: PME# disabled
[    0.177051] pci 0000:01:00.0: reg 10 32bit mmio: [0xfc000000-0xfdffffff]
[    0.177076] pci 0000:01:00.0: reg 14 32bit mmio: [0xfbc00000-0xfbffffff]
[    0.177100] pci 0000:01:00.0: reg 18 32bit mmio: [0xf8000000-0xf9ffffff]
[    0.177125] pci 0000:01:00.0: reg 1c 32bit mmio: [0xf7ff8000-0xf7ffffff]
[    0.177176] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.177214] pci 0000:01:00.0: supports D1 D2
[    0.177366] pci 0000:00:01.0: bridge 32bit mmio: [0xf7f00000-0xfdffffff]
[    0.177595] bus 00 -> node 0
[    0.177642] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.178357] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.214996] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[    0.215933] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[    0.216898] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[    0.217795] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[    0.218681] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[    0.219567] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[    0.221156] ACPI: Power Resource [PFAN] (off)
[    0.224040] PCI: Using ACPI for IRQ routing
[    0.225194] pnp: PnP ACPI init
[    0.226796] ACPI: bus type pnp registered
[    0.252170] pnp: PnP ACPI: found 12 devices
[    0.252228] ACPI: ACPI bus type pnp unregistered
[    0.252336] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.252366] system 00:00: iomem range 0xe0000-0xeffff could not be reser=
ved
[    0.252394] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[    0.252423] system 00:00: iomem range 0x100000-0x1ef5ffff could not be r=
eserved
[    0.252456] system 00:00: iomem range 0x1ef60000-0x1ef6ffff could not be=
 reserved
[    0.252486] system 00:00: iomem range 0x1f000000-0x1fffffff has been res=
erved
[    0.252514] system 00:00: iomem range 0x1ef70000-0x1effffff has been res=
erved
[    0.252546] system 00:00: iomem range 0xffe00000-0xffffffff could not be=
 reserved
[    0.252646] system 00:08: ioport range 0x370-0x371 has been reserved
[    0.252673] system 00:08: ioport range 0x40b-0x40b has been reserved
[    0.252700] system 00:08: ioport range 0x480-0x48f has been reserved
[    0.252727] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.252754] system 00:08: ioport range 0x4d6-0x4d6 has been reserved
[    0.252781] system 00:08: ioport range 0x6c0-0x6ff has been reserved
[    0.252808] system 00:08: ioport range 0xe000-0xe07f has been reserved
[    0.252836] system 00:08: ioport range 0xe080-0xe0ff has been reserved
[    0.252864] system 00:08: ioport range 0xe400-0xe47f has been reserved
[    0.252892] system 00:08: ioport range 0xe480-0xe4ff has been reserved
[    0.252920] system 00:08: ioport range 0xe800-0xe87f has been reserved
[    0.252949] system 00:08: ioport range 0xe880-0xe8ff has been reserved
[    0.252977] system 00:08: ioport range 0xec00-0xec7f has been reserved
[    0.253005] system 00:08: ioport range 0xec80-0xecff has been reserved
[    0.253035] system 00:08: ioport range 0xee00-0xee41 could not be reserv=
ed
[    0.253064] system 00:08: ioport range 0xee90-0xee9f has been reserved
[    0.253092] system 00:08: ioport range 0xeeac-0xeeac has been reserved
[    0.253122] system 00:08: ioport range 0xef00-0xef3f could not be reserv=
ed
[    0.253150] system 00:08: ioport range 0xef40-0xef5f has been reserved
[    0.293655] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.293709] pci 0000:00:01.0:   IO window: disabled
[    0.293743] pci 0000:00:01.0:   MEM window: 0xf7f00000-0xfdffffff
[    0.293775] pci 0000:00:01.0:   PREFETCH window: 0x00000048000000-0x0000=
00480fffff
[    0.293825] pci 0000:00:10.0: CardBus bridge, secondary bus 0000:02
[    0.293848] pci 0000:00:10.0:   IO window: 0x001000-0x0010ff
[    0.293878] pci 0000:00:10.0:   IO window: 0x001400-0x0014ff
[    0.293909] pci 0000:00:10.0:   PREFETCH window: 0x30000000-0x33ffffff
[    0.293941] pci 0000:00:10.0:   MEM window: 0x34000000-0x37ffffff
[    0.293973] pci 0000:00:11.0: CardBus bridge, secondary bus 0000:06
[    0.293995] pci 0000:00:11.0:   IO window: 0x001800-0x0018ff
[    0.294025] pci 0000:00:11.0:   IO window: 0x001c00-0x001cff
[    0.294056] pci 0000:00:11.0:   PREFETCH window: 0x38000000-0x3bffffff
[    0.294088] pci 0000:00:11.0:   MEM window: 0x3c000000-0x3fffffff
[    0.294120] pci 0000:00:11.1: CardBus bridge, secondary bus 0000:0a
[    0.294143] pci 0000:00:11.1:   IO window: 0x002000-0x0020ff
[    0.294172] pci 0000:00:11.1:   IO window: 0x002400-0x0024ff
[    0.294203] pci 0000:00:11.1:   PREFETCH window: 0x40000000-0x43ffffff
[    0.294235] pci 0000:00:11.1:   MEM window: 0x44000000-0x47ffffff
[    0.294305] pci 0000:00:01.0: setting latency timer to 64
[    0.294341] pci 0000:00:10.0: enabling device (0000 -> 0003)
[    0.296153] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.296185] PCI: setting IRQ 11 as level-triggered
[    0.296199] pci 0000:00:10.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, =
low) -> IRQ 11
[    0.296262] pci 0000:00:11.0: enabling device (0000 -> 0003)
[    0.297745] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.297775] pci 0000:00:11.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, =
low) -> IRQ 11
[    0.297838] pci 0000:00:11.1: enabling device (0000 -> 0003)
[    0.299253] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.299280] pci 0000:00:11.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, =
low) -> IRQ 11
[    0.299328] bus: 00 index 0 io port: [0x00-0xffff]
[    0.299347] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.299368] bus: 01 index 0 mmio: [0x0-0x0]
[    0.299386] bus: 01 index 1 mmio: [0xf7f00000-0xfdffffff]
[    0.299406] bus: 01 index 2 mmio: [0x48000000-0x480fffff]
[    0.299426] bus: 01 index 3 mmio: [0x0-0x0]
[    0.299444] bus: 02 index 0 io port: [0x1000-0x10ff]
[    0.299463] bus: 02 index 1 io port: [0x1400-0x14ff]
[    0.299483] bus: 02 index 2 mmio: [0x30000000-0x33ffffff]
[    0.299503] bus: 02 index 3 mmio: [0x34000000-0x37ffffff]
[    0.299524] bus: 06 index 0 io port: [0x1800-0x18ff]
[    0.299543] bus: 06 index 1 io port: [0x1c00-0x1cff]
[    0.299563] bus: 06 index 2 mmio: [0x38000000-0x3bffffff]
[    0.299583] bus: 06 index 3 mmio: [0x3c000000-0x3fffffff]
[    0.299604] bus: 0a index 0 io port: [0x2000-0x20ff]
[    0.299623] bus: 0a index 1 io port: [0x2400-0x24ff]
[    0.299643] bus: 0a index 2 mmio: [0x40000000-0x43ffffff]
[    0.299663] bus: 0a index 3 mmio: [0x44000000-0x47ffffff]
[    0.299748] NET: Registered protocol family 2
[    0.300797] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[    0.301906] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[    0.302646] TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
[    0.308698] TCP: Hash tables configured (established 16384 bind 16384)
[    0.308971] TCP reno registered
[    0.309649] NET: Registered protocol family 1
[    0.311199] checking if image is initramfs... it is
[    0.796783] Switched to high resolution mode on CPU 0
[    1.211492] Freeing initrd memory: 3557k freed
[    1.219632] Initializing RT-Tester: OK
[    1.221166] audit: initializing netlink socket (disabled)
[    1.221393] type=3D2000 audit(1225812603.220:1): initialized
[    1.236799] Kprobe smoke test started
[    1.241177] Kprobe smoke test passed successfully
[    1.241288] Testing tracer sched_switch: PASSED
[    1.375569] msgmni has been set to 964
[    1.377116] io scheduler noop registered
[    1.377155] io scheduler anticipatory registered
[    1.377176] io scheduler deadline registered
[    1.377298] io scheduler cfq registered (default)
[    1.377584] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    1.377740] pci 0000:01:00.0: Boot video device
[    1.380807] vesafb: framebuffer at 0xfc000000, mapped to 0xdf780000, usi=
ng 3072k, total 16384k
[    1.380864] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[    1.380887] vesafb: protected mode interface info at c000:775e
[    1.380910] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
 c00c77e2
[    1.380934] vesafb: scrolling: redraw
[    1.380955] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    1.448379] Console: switching to colour frame buffer device 128x48
[    1.514000] fb0: VESA VGA frame buffer device
[    1.912227] brd: module loaded
[    1.912679] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[    1.913692] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.916557] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    1.917389] e100 0000:00:0a.0: PCI INT A -> Link[LNKD] -> GSI 11 (level,=
 low) -> IRQ 11
[    1.945482] e100 0000:00:0a.0: PME# disabled
[    1.947292] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr 00=
:00:39:d7:14:a1
[    1.948711] netconsole: local port 6665
[    1.949197] netconsole: local IP 10.0.0.1
[    1.949695] netconsole: interface eth0
[    1.950412] netconsole: remote port 6666
[    1.950903] netconsole: remote IP 10.0.0.2
[    1.951415] netconsole: remote ethernet address 00:17:42:21:27:e4
[    1.952208] netconsole: device eth0 not up yet, forcing it
[    5.983394] netconsole: timeout waiting for carrier
[    5.985967] console [netcon0] enabled
[   11.578679] Clocksource tsc unstable (delta =3D 4686592561 ns)
[   11.603502] netconsole: network logging started
[   11.629119] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
 irq 1,12
[   11.659750] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.684594] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.712043] mice: PS/2 mouse device common for all mice
[   11.736749] cpuidle: using governor ladder
[   11.760478] cpuidle: using governor menu
[   11.783943] TCP cubic registered
[   11.807024] Using IPI Shortcut mode
[   11.834258] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[   11.863208] Freeing unused kernel memory: 236k freed
[   11.887906] Write protecting the kernel text: 2036k
[   11.911707] Write protecting the kernel read-only data: 768k
[   11.962217] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   12.579515] SCSI subsystem initialized
[   12.648863] Driver 'sd' needs updating - please use bus_type methods
[   12.776239] libata version 3.00 loaded.
[   12.817363] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[   12.841629] scsi0 : pata_ali
[   12.866022] scsi1 : pata_ali
[   12.893203] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq =
14
[   12.915890] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq =
15
[   13.097625] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[   13.119900] ata1.00: 39070080 sectors, multi 0: LBA=20
[   13.141835] ata1.00: limited to UDMA/33 due to 40-wire cable
[   13.177492] ata1.00: configured for UDMA/33
[   13.380585] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[   13.402117] ata2.00: WARNING: ATAPI DMA disabled for reliablity issues. =
 It can be enabled
[   13.424331] ata2.00: WARNING: via pata_ali.atapi_dma modparam or corresp=
onding sysfs node.
[   13.477230] ata2.00: configured for UDMA/33
[   13.502739] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA=
3O PQ: 0 ANSI: 5
[   13.529254] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0 =
GB/18.6 GiB)
[   13.553451] sd 0:0:0:0: [sda] Write Protect is off
[   13.577282] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.577508] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   13.604026] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0 =
GB/18.6 GiB)
[   13.628899] sd 0:0:0:0: [sda] Write Protect is off
[   13.653341] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   13.653565] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   13.678598]  sda: sda1 sda2
[   13.728834] sd 0:0:0:0: [sda] Attached SCSI disk
[   13.767541] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 13=
13 PQ: 0 ANSI: 5
[   14.037286] ReiserFS: sda2: found reiserfs format "3.6" with standard jo=
urnal
[   14.063447] ReiserFS: sda2: using ordered data mode
[   14.096155] ReiserFS: sda2: journal params: device sda2, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   14.159212] ReiserFS: sda2: checking transaction log (sda2)
[   14.237861] ReiserFS: sda2: Using r5 hash to sort names
[   17.256099] usbcore: registered new interface driver usbfs
[   17.282947] usbcore: registered new interface driver hub
[   17.309251] usbcore: registered new device driver usb
[   24.172445] Linux agpgart interface v0.103
[   24.190280] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   24.192361] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[   24.192381] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11 (le=
vel, low) -> IRQ 11
[   24.192550] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   24.195205] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 1
[   24.207494] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[   24.228810] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input1
[   24.238629] ACPI: Power Button (FF) [PWRF]
[   24.239400] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input2
[   24.239867] ACPI: Lid Switch [LID]
[   24.266104] usb usb1: configuration #1 chosen from 1 choice
[   24.267088] hub 1-0:1.0: USB hub found
[   24.267368] hub 1-0:1.0: 3 ports detected
[   24.307993] agpgart-ali 0000:00:00.0: ALi M1644 chipset
[   24.361192] agpgart-ali 0000:00:00.0: AGP aperture is 64M @ 0xf0000000
[   24.389055] ACPI: AC Adapter [ADP1] (on-line)
[   24.456954] ACPI Warning (nspredef-0858): \_SB_.BAT1._BIF: Return Packag=
e type mismatch at index 9 - found Buffer, expected String [20080926]
[   24.458919] ACPI: Battery Slot [BAT1] (battery present)
[   24.460108] ACPI: Battery Slot [BAT2] (battery absent)
[   24.536705] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   24.537971] processor ACPI0007:00: registered as cooling_device0
[   24.689101] thermal LNXTHERM:01: registered as thermal_zone0
[   24.691005] ACPI: Thermal Zone [THRM] (59 C)
[   24.965758] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.19
[   24.965774] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[   25.018286] ACPI: Transitioning device [FAN] to D3
[   25.018714] fan PNP0C0B:00: registered as cooling_device1
[   25.018748] ACPI: Fan [FAN] (off)
[   25.150339] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   25.151075] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   25.194570] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:0=
0/device:14/device:15/input/input3
[   25.205270] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[   25.399938] pci 0000:00:08.0: enabling device (0000 -> 0001)
[   25.401091] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[   26.050639] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   26.352838] Driver 'sr' needs updating - please use bus_type methods
[   26.374912] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[   26.374935] Uniform CD-ROM driver Revision: 3.20
[   26.376342] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   26.866628] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042=
/serio1/input/input5
[   27.341083] yenta_cardbus 0000:00:10.0: CardBus bridge found [12a3:ab01]
[   27.465931] yenta_cardbus 0000:00:10.0: ISA IRQ mask 0x0000, PCI irq 11
[   27.465949] yenta_cardbus 0000:00:10.0: Socket status: 30000059
[   27.473093] yenta_cardbus 0000:00:11.0: CardBus bridge found [1179:0001]
[   27.606152] yenta_cardbus 0000:00:11.0: ISA IRQ mask 0x04b8, PCI irq 11
[   27.606170] yenta_cardbus 0000:00:11.0: Socket status: 30000007
[   27.622420] yenta_cardbus 0000:00:11.1: CardBus bridge found [1179:0001]
[   27.749579] yenta_cardbus 0000:00:11.1: ISA IRQ mask 0x04b8, PCI irq 11
[   27.749597] yenta_cardbus 0000:00:11.1: Socket status: 30000007
[   28.221911] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted i=
nto slot 0
[   28.235619] rtc_cmos 00:07: RTC can wake from S4
[   28.237505] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[   28.237605] rtc0: alarms up to one year, 114 bytes nvram,  irqs
[   29.350230] NET: Registered protocol family 23
[   29.594101] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C IrDA chip, pre-configuring device.
[   29.594141] Activated ALi 1533 ISA bridge port 0x02e8.
[   29.594159] Activated ALi 1533 ISA bridge port 0x02f8.
[   29.594413] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
: LPC47N227
[   29.594429] smsc_superio_flat(): IrDA not enabled
[   29.594459] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
, mode: 0x02
[   29.594499] SMsC IrDA Controller found
[   29.594502]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[   29.594722] No transceiver found. Defaulting to Fast pin select
[   29.595955] IrDA: Registered device irda0
[   30.863656] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[   30.865348] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[   30.865366] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11 (le=
vel, low) -> IRQ 11
[   35.696170] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af:=
 excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   35.700165] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff:=
 clean.
[   35.701797] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff:=
 clean.
[   35.703236] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7:=
 clean.
[   35.716731] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x100-0x3af:=
 excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   35.720882] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x3e0-0x4ff:=
 clean.
[   35.722543] pcmcia_socket pcmcia_socket2: cs: IO port probe 0x820-0x8ff:=
 clean.
[   35.723969] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xc00-0xcf7:=
 clean.
[   35.726725] pcmcia_socket pcmcia_socket2: cs: IO port probe 0xa00-0xaff:=
 clean.
[   35.730217] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff:=
 clean.
[   35.988743] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0x=
a0ffffff: clean.
[   36.004723] pcmcia 0.0: pcmcia: registering new device pcmcia0.0
[   36.519337] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af:=
 excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
[   36.523417] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff:=
 clean.
[   36.524989] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff:=
 clean.
[   36.526531] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7:=
 clean.
[   36.529406] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff:=
 clean.
[   37.158626] Marking TSC unstable due to TSC halts in idle
[   37.446312] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[   37.487379] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>=
, Pavel Roskin <proski@gnu.org>, et al)
[   37.569741] eth1: Hardware identity 0005:0002:0001:0002
[   37.569860] eth1: Station identity  001f:0001:0006:000e
[   37.569871] eth1: Firmware determined as Lucent/Agere 6.14
[   37.569888] eth1: Attempting to download firmware agere_sta_fw.bin
[   37.569917] hermes_dld: AUX enable returned 0
[   37.570922] hermes_dld: AUX disable returned 0
[   37.570930] hermes_dld: Actual PDA length 998, Max allowed 1000
[   37.570937] eth1: Read PDA returned 0
[   37.570950] orinoco_cs 0.0: firmware: requesting agere_sta_fw.bin
[   37.761704] hermes_dld: AUX enable returned 0
[   37.761769] hermes_dld: Enabling volatile, EP 0x000f8000
[   37.762817] hermes_dld: PROGRAM_ENABLE returned 0
[   37.762825] eth1: Program init returned 0
[   37.762836] hermes_dld: Programming block of length 60416 to address 0x0=
01f0000
[   37.811002] hermes_dld: Programming block of length 4096 to address 0x00=
1ef000
[   37.814283] eth1: Program returned 0
[   37.814293] hermes_dld: Found record 0x0003 at ddf83c1c
[   37.814315] hermes_dld: Found record 0x0005 at ddf83ca8
[   37.814334] hermes_dld: Found record 0x0008 at ddf83cd2
[   37.814351] hermes_dld: Found record 0x0007 at ddf83cc4
[   37.814369] hermes_dld: Found record 0x0006 at ddf83cb6
[   37.814389] hermes_dld: Found record 0x0110 at ddf83d9a
[   37.814423] hermes_dld: Found record 0x0120 at ddf83dba
[   37.814456] hermes_dld: Found record 0x0130 at ddf83dda
[   37.814489] hermes_dld: Found record 0x0140 at ddf83dfa
[   37.814502] hermes_dld: Found record 0x0150 at ddf83e02
[   37.814515] hermes_dld: Using default record 0x0160 at dfb20b60
[   37.814549] hermes_dld: Found record 0x0101 at ddf83d46
[   37.814564] hermes_dld: Found record 0x0103 at ddf83d5c
[   37.814584] hermes_dld: Found record 0x0104 at ddf83d6c
[   37.814596] hermes_dld: Found record 0x0105 at ddf83d72
[   37.814609] hermes_dld: Found record 0x0105 at ddf83d72
[   37.814621] hermes_dld: Found record 0x0105 at ddf83d72
[   37.814633] hermes_dld: Found record 0x0107 at ddf83d7e
[   37.814645] hermes_dld: Found record 0x0109 at ddf83d8c
[   37.814664] hermes_dld: Using default record 0x0161 at dfb20b80
[   37.814880] eth1: Apply PDA returned 0
[   37.814945] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
, r2 0x0000
[   37.814973] hermes_dld: AUX disable returned 0
[   37.825617] eth1: Program end returned 0
[   37.825626] eth1: hermes_present returned 1
[   37.826434] eth1: Hardware identity 0005:0002:0001:0002
[   37.826561] eth1: Station identity  001f:0002:0009:0030
[   37.826572] eth1: Firmware determined as Lucent/Agere 9.48
[   37.826580] eth1: Ad-hoc demo mode supported
[   37.826587] eth1: IEEE standard IBSS ad-hoc mode supported
[   37.826594] eth1: WEP supported, 104-bit key
[   37.826603] eth1: WPA-PSK supported
[   38.612354] eth1: MAC address 00:02:2d:26:95:6c
[   38.612470] eth1: Station name "HERMES I"
[   38.613238] eth1: ready
[   38.614092] eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
[   38.930935] Toshiba System Management Mode driver v1.11 26/9/2001
[   39.009889] Non-volatile memory driver v1.2
[   39.649344] device-mapper: uevent: version 1.0.3
[   39.652035] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:=
 dm-devel@redhat.com
[   39.853323] device-mapper: multipath: version 1.0.5 loaded
[   40.424836] device-mapper: multipath round-robin: version 1.0.0 loaded
[   40.426212] device-mapper: table: 254:0: multipath: error getting device
[   40.426232] device-mapper: ioctl: error adding target to table
[   46.107065] loop: module loaded
[   49.559510] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1 acr=
oss:500432k
[   55.596986] Uniform Multi-Platform E-IDE driver
[   55.672149] ide_generic: please use "probe_mask=3D0x3f" module parameter=
 for probing all legacy ISA IDE ports
[   55.824795] ide-gd driver 1.18
[   58.735910] IrCOMM protocol (Dag Brattli)
[   60.714352] PPP generic driver version 2.4.2
[   69.905090] eth1: New link status: Connected (0001)
[   70.528852] NET: Registered protocol family 17
[   71.023262] eth1: Lucent/Agere firmware doesn't support manual roaming
[ 5386.583164] PM: Syncing filesystems ... done.
[ 5387.048017] Freezing user space processes ... (elapsed 0.11 seconds) don=
e.
[ 5387.160284] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 5387.161152] Suspending console(s) (use no_console_suspend to debug)
[ 5387.172810] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 5387.173558] sd 0:0:0:0: [sda] Stopping disk
[ 5387.850552] e100 0000:00:0a.0: PCI INT A disabled
[ 5387.905282] ALI 5451 0000:00:06.0: PCI INT A disabled
[ 5387.918470] ALI 5451 0000:00:06.0: power state changed by ACPI to D3
[ 5388.694410] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 5388.703223] ohci_hcd 0000:00:02.0: PCI INT A disabled
[ 5388.721551] ACPI: Preparing to enter system sleep state S3
[ 5388.721551] Back to C!
[ 5388.734575] ACPI: Waking up from system sleep state S3
[ 5388.755381] pci 0000:00:01.0: setting latency timer to 64
[ 5388.766363] ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNKG] -> GSI 11 (le=
vel, low) -> IRQ 11
[ 5388.766985] ohci_hcd 0000:00:02.0: restoring config space at offset 0xf =
(was 0x500001ff, writing 0x5000010b)
[ 5388.821597] usb usb1: root hub lost power or was reset
[ 5388.833803] pata_ali 0000:00:04.0: restoring config space at offset 0x1 =
(was 0x2900001, writing 0x2900005)
[ 5388.833860] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
[ 5388.842140] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 5388.842178] ALI 5451 0000:00:06.0: restoring config space at offset 0xf =
(was 0x180201ff, writing 0x1802010b)
[ 5388.842433] ALI 5451 0000:00:06.0: power state changed by ACPI to D0
[ 5388.842471] ALI 5451 0000:00:06.0: PCI INT A -> Link[LNKH] -> GSI 11 (le=
vel, low) -> IRQ 11
[ 5389.131451] ali1535_smbus 0000:00:08.0: enabling device (0000 -> 0001)
[ 5389.142935] e100 0000:00:0a.0: restoring config space at offset 0xf (was=
 0x380801ff, writing 0x3808010b)
[ 5389.143006] e100 0000:00:0a.0: restoring config space at offset 0x1 (was=
 0x2900003, writing 0x2900007)
[ 5389.169945] yenta_cardbus 0000:00:10.0: restoring config space at offset=
 0x6 (was 0x50200, writing 0xb0050200)
[ 5389.416915] ata2.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 5389.416925] ata2.00: ACPI cmd ef/03:42:00:00:00:00 filtered out
[ 5389.417750] ata2.00: configured for UDMA/33
[ 5390.152956] pci 0000:00:12.0: restoring config space at offset 0xf (was =
0x1ff, writing 0x10b)
[ 5390.153085] pci 0000:01:00.0: restoring config space at offset 0xf (was =
0x1ff, writing 0x10b)
[ 5390.158663] sd 0:0:0:0: [sda] Starting disk
[ 5391.155005] ata1.00: ACPI cmd ef/03:0c:00:00:00:00 filtered out
[ 5391.155015] ata1.00: ACPI cmd ef/03:44:00:00:00:00 filtered out
[ 5391.168661] ata1.00: configured for UDMA/33
[ 5391.184650] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors: (20.0 =
GB/18.6 GiB)
[ 5391.184840] sd 0:0:0:0: [sda] Write Protect is off
[ 5391.184848] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 5391.185055] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 5391.436831] eth1: Attempting to download firmware agere_sta_fw.bin
[ 5391.436866] hermes_dld: AUX enable returned 0
[ 5391.437941] hermes_dld: AUX disable returned 0
[ 5391.437948] hermes_dld: Actual PDA length 998, Max allowed 1000
[ 5391.437955] eth1: Read PDA returned 0
[ 5391.520119] hermes_dld: AUX enable returned 0
[ 5391.520126] hermes_dld: Enabling volatile, EP 0x000f8000
[ 5391.521237] hermes_dld: PROGRAM_ENABLE returned 0
[ 5391.521244] eth1: Program init returned 0
[ 5391.521252] hermes_dld: Programming block of length 60416 to address 0x0=
01f0000
[ 5391.569447] hermes_dld: Programming block of length 4096 to address 0x00=
1ef000
[ 5391.572731] eth1: Program returned 0
[ 5391.572740] hermes_dld: Found record 0x0003 at cad3cc1c
[ 5391.572759] hermes_dld: Found record 0x0005 at cad3cca8
[ 5391.572777] hermes_dld: Found record 0x0008 at cad3ccd2
[ 5391.572792] hermes_dld: Found record 0x0007 at cad3ccc4
[ 5391.572809] hermes_dld: Found record 0x0006 at cad3ccb6
[ 5391.572827] hermes_dld: Found record 0x0110 at cad3cd9a
[ 5391.572858] hermes_dld: Found record 0x0120 at cad3cdba
[ 5391.572890] hermes_dld: Found record 0x0130 at cad3cdda
[ 5391.572921] hermes_dld: Found record 0x0140 at cad3cdfa
[ 5391.572933] hermes_dld: Found record 0x0150 at cad3ce02
[ 5391.572945] hermes_dld: Using default record 0x0160 at dfb20b60
[ 5391.572976] hermes_dld: Found record 0x0101 at cad3cd46
[ 5391.572990] hermes_dld: Found record 0x0103 at cad3cd5c
[ 5391.573009] hermes_dld: Found record 0x0104 at cad3cd6c
[ 5391.573019] hermes_dld: Found record 0x0105 at cad3cd72
[ 5391.573031] hermes_dld: Found record 0x0105 at cad3cd72
[ 5391.573041] hermes_dld: Found record 0x0105 at cad3cd72
[ 5391.573052] hermes_dld: Found record 0x0107 at cad3cd7e
[ 5391.573063] hermes_dld: Found record 0x0109 at cad3cd8c
[ 5391.573081] hermes_dld: Using default record 0x0161 at dfb20b80
[ 5391.573295] eth1: Apply PDA returned 0
[ 5391.573358] hermes_dld: PROGRAM_DISABLE returned 0, r0 0x0000, r1 0x0000=
, r2 0x0000
[ 5391.573385] hermes_dld: AUX disable returned 0
[ 5391.584022] eth1: Program end returned 0
[ 5391.584029] eth1: hermes_present returned 1
[ 5391.597173] Restarting tasks ... done.
[ 5391.756604] eth1: New link status: Connected (0001)
[ 5605.688452] ISO 9660 Extensions: RRIP_1991A
[ 5687.038230] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 fr=
ozen
[ 5687.038304] ata2.00: cmd a0/01:00:00:00:08/00:00:00:00:00/a0 tag 0 dma 2=
048 in
[ 5687.038309]          cdb 28 00 00 00 00 1d 00 00  01 00 00 00 00 00 00 00
[ 5687.038314]          res 40/00:02:00:08:00/00:00:00:00:00/a0 Emask 0x4 (=
timeout)
[ 5687.038348] ata2.00: status: { DRDY }
[ 5687.038477] ata2: soft resetting link
[ 5687.198450] ata2.00: configured for UDMA/33
[ 5687.198783] ata2: EH complete
[ 5687.999978] ------------[ cut here ]------------
[ 5688.000033] WARNING: at /home/bor/src/linux-git/drivers/ata/libata-eh.c:=
3259 ata_eh_finish+0xc2/0xd0 [libata]()
[ 5688.000050] Modules linked in: isofs zlib_inflate autofs4 af_packet irne=
t ppp_generic slhc ircomm_tty ircomm ide_gd_mod ide_generic ide_core binfmt=
_misc loop dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath dm_m=
od nvram toshiba cryptomgr aead crypto_blkcipher michael_mic crypto_algapi =
orinoco_cs orinoco hermes_dld hermes pcmcia firmware_class snd_ali5451 snd_=
ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn=
d_seq_device snd_pcm_oss smsc_ircc2 snd_pcm irda snd_timer snd_mixer_oss rt=
c_cmos yenta_socket snd rsrc_nonstatic rtc_core pcmcia_core crc_ccitt i2c_a=
li1535 psmouse rtc_lib sr_mod pcspkr soundcore evdev i2c_core cdrom alim153=
5_wdt snd_page_alloc video sg fan output toshiba_acpi rfkill backlight ther=
mal input_polldev processor battery ac ali_agp button ohci_hcd agpgart usbc=
ore pata_ali libata sd_mod scsi_mod reiserfs
[ 5688.001092] Pid: 872, comm: scsi_eh_1 Not tainted 2.6.28-rc3-1avb #10
[ 5688.001300] Call Trace:
[ 5688.001335]  [<c02f54e8>] ? printk+0x18/0x20
[ 5688.001372]  [<c011da54>] warn_on_slowpath+0x54/0x80
[ 5688.001445]  [<dfb9005d>] ? __ata_port_next_link+0x5d/0x70 [libata]
[ 5688.001501]  [<dfba31d0>] ? ata_sff_softreset+0x0/0x150 [libata]
[ 5688.001549]  [<dfba3320>] ? ata_sff_prereset+0x0/0xc0 [libata]
[ 5688.001600]  [<c013fb5d>] ? trace_hardirqs_on_caller+0xfd/0x140
[ 5688.001618]  [<c013fbab>] ? trace_hardirqs_on+0xb/0x10
[ 5688.001639]  [<c012e1ca>] ? __cancel_work_timer+0x3a/0x160
[ 5688.001658]  [<c013db0b>] ? trace_hardirqs_off+0xb/0x10
[ 5688.001694]  [<c01074f7>] ? native_sched_clock+0x77/0xb0
[ 5688.001744]  [<dfb9f6d2>] ata_eh_finish+0xc2/0xd0 [libata]
[ 5688.001793]  [<dfba3320>] ? ata_sff_prereset+0x0/0xc0 [libata]
[ 5688.001844]  [<dfb9f763>] ata_do_eh+0x83/0x90 [libata]
[ 5688.001894]  [<dfba1310>] ? ata_sff_postreset+0x0/0x70 [libata]
[ 5688.001946]  [<dfba11f7>] ata_sff_error_handler+0xc7/0x1e0 [libata]
[ 5688.001997]  [<dfba1310>] ? ata_sff_postreset+0x0/0x70 [libata]
[ 5688.002047]  [<dfba31d0>] ? ata_sff_softreset+0x0/0x150 [libata]
[ 5688.002099]  [<dfb9ff7e>] ata_scsi_error+0x2be/0x610 [libata]
[ 5688.002118]  [<c02f58eb>] ? schedule+0x2db/0x4b0
[ 5688.002387]  [<dfb2fe7c>] scsi_error_handler+0xdc/0x550 [scsi_mod]
[ 5688.002409]  [<c0119e30>] ? finish_task_switch+0x0/0xc0
[ 5688.002428]  [<c02f58eb>] ? schedule+0x2db/0x4b0
[ 5688.002476]  [<dfb2fda0>] ? scsi_error_handler+0x0/0x550 [scsi_mod]
[ 5688.002506]  [<c013158a>] kthread+0x3a/0x70
[ 5688.002523]  [<c0131550>] ? kthread+0x0/0x70
[ 5688.002542]  [<c0104043>] kernel_thread_helper+0x7/0x14
[ 5688.002557] ---[ end trace 57d3c9e80c1b210a ]---
[ 5688.002893] VFS: busy inodes on changed media or resized disk sr0
[ 5688.003638] ------------[ cut here ]------------
[ 5688.003670] WARNING: at /home/bor/src/linux-git/drivers/ata/libata-core.=
c:4807 ata_qc_issue+0x3b/0x220 [libata]()
[ 5688.003686] Modules linked in: isofs zlib_inflate autofs4 af_packet irne=
t ppp_generic slhc ircomm_tty ircomm ide_gd_mod ide_generic ide_core binfmt=
_misc loop dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath dm_m=
od nvram toshiba cryptomgr aead crypto_blkcipher michael_mic crypto_algapi =
orinoco_cs orinoco hermes_dld hermes pcmcia firmware_class snd_ali5451 snd_=
ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn=
d_seq_device snd_pcm_oss smsc_ircc2 snd_pcm irda snd_timer snd_mixer_oss rt=
c_cmos yenta_socket snd rsrc_nonstatic rtc_core pcmcia_core crc_ccitt i2c_a=
li1535 psmouse rtc_lib sr_mod pcspkr soundcore evdev i2c_core cdrom alim153=
5_wdt snd_page_alloc video sg fan output toshiba_acpi rfkill backlight ther=
mal input_polldev processor battery ac ali_agp button ohci_hcd agpgart usbc=
ore pata_ali libata sd_mod scsi_mod reiserfs
[ 5688.004508] Pid: 3281, comm: hald-addon-stor Tainted: G        W  2.6.28=
=2Drc3-1avb #10
[ 5688.004523] Call Trace:
[ 5688.004543]  [<c02f54e8>] ? printk+0x18/0x20
[ 5688.004543]  [<c011da54>] warn_on_slowpath+0x54/0x80
[ 5688.004543]  [<c013db0b>] ? trace_hardirqs_off+0xb/0x10
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c018cdc9>] ? kmem_cache_alloc+0x59/0xd0
[ 5688.004543]  [<dfb2bf73>] ? scsi_pool_alloc_command+0x43/0x70 [scsi_mod]
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<dfb2c287>] ? scsi_get_command+0x67/0x90 [scsi_mod]
[ 5688.004543]  [<dfb9329b>] ata_qc_issue+0x3b/0x220 [libata]
[ 5688.004543]  [<dfb98fc7>] ata_scsi_translate+0xb7/0x180 [libata]
[ 5688.004543]  [<c02f8388>] ? _spin_lock+0x58/0x60
[ 5688.004543]  [<dfb2b750>] ? scsi_done+0x0/0x10 [scsi_mod]
[ 5688.004543]  [<dfb9b22a>] ata_scsi_queuecmd+0xba/0x220 [libata]
[ 5688.004543]  [<dfb99480>] ? atapi_xlat+0x0/0x190 [libata]
[ 5688.004543]  [<dfb2b750>] ? scsi_done+0x0/0x10 [scsi_mod]
[ 5688.004543]  [<dfb2b961>] scsi_dispatch_cmd+0xe1/0x250 [scsi_mod]
[ 5688.004543]  [<dfb315e3>] scsi_request_fn+0x3a3/0x510 [scsi_mod]
[ 5688.004543]  [<c02f81bf>] ? _spin_unlock_irqrestore+0x4f/0x60
[ 5688.004543]  [<c01eb963>] __generic_unplug_device+0x23/0x30
[ 5688.004543]  [<c01ee2fc>] blk_execute_rq_nowait+0x5c/0xa0
[ 5688.004543]  [<c01ee3ec>] blk_execute_rq+0xac/0xd0
[ 5688.004543]  [<c01ee270>] ? blk_end_sync_rq+0x0/0x30
[ 5688.004543]  [<c01f5acb>] ? cfq_set_request+0xcb/0x300
[ 5688.004543]  [<c01f5a00>] ? cfq_set_request+0x0/0x300
[ 5688.004543]  [<c01e89ff>] ? elv_set_request+0x1f/0x50
[ 5688.004543]  [<c01eb4d4>] ? get_request+0x264/0x290
[ 5688.004543]  [<dfb32c87>] scsi_execute+0xd7/0x120 [scsi_mod]
[ 5688.004543]  [<dfb32d3a>] scsi_execute_req+0x6a/0xd0 [scsi_mod]
[ 5688.004543]  [<e00b828a>] sr_test_unit_ready+0x5a/0xf0 [sr_mod]
[ 5688.004543]  [<e00b8595>] sr_media_change+0x55/0x260 [sr_mod]
[ 5688.004543]  [<c0179008>] ? handle_mm_fault+0x178/0x5e0
[ 5688.004543]  [<dff460aa>] media_changed+0x6a/0xb0 [cdrom]
[ 5688.004543]  [<dff46129>] cdrom_media_changed+0x39/0x50 [cdrom]
[ 5688.004543]  [<e00b8381>] sr_block_media_changed+0x11/0x20 [sr_mod]
[ 5688.004543]  [<c01b49d4>] check_disk_change+0x24/0x70
[ 5688.004543]  [<dff4a32a>] cdrom_open+0x16a/0xb20 [cdrom]
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5688.004543]  [<c02f67d1>] ? mutex_lock_nested+0x1e1/0x270
[ 5688.004543]  [<c013fbab>] ? trace_hardirqs_on+0xb/0x10
[ 5688.004543]  [<e00b84ed>] sr_block_open+0x5d/0xb0 [sr_mod]
[ 5688.004543]  [<c01b5331>] __blkdev_get+0x221/0x2c0
[ 5688.004543]  [<c01b53da>] blkdev_get+0xa/0x10
[ 5688.004543]  [<c01b5664>] blkdev_open+0x64/0xc0
[ 5688.004543]  [<c018e99c>] __dentry_open+0x9c/0x250
[ 5688.004543]  [<c018ec25>] nameidata_to_filp+0x45/0x60
[ 5688.004543]  [<c01b5600>] ? blkdev_open+0x0/0xc0
[ 5688.004543]  [<c019b579>] do_filp_open+0x1e9/0x810
[ 5688.004543]  [<c013fbab>] ? trace_hardirqs_on+0xb/0x10
[ 5688.004543]  [<c02f81ed>] ? _spin_unlock+0x1d/0x20
[ 5688.004543]  [<c01a44a8>] ? alloc_fd+0xe8/0x100
[ 5688.004543]  [<c018e7b9>] do_sys_open+0x59/0xf0
[ 5688.004543]  [<c018e8b9>] sys_open+0x29/0x40
[ 5688.004543]  [<c01033b9>] sysenter_do_call+0x12/0x31
[ 5688.004543] ---[ end trace 57d3c9e80c1b210a ]---
[ 5688.113038] VFS: busy inodes on changed media or resized disk sr0
[ 5696.001643] ------------[ cut here ]------------
[ 5696.001697] WARNING: at /home/bor/src/linux-git/drivers/ata/libata-eh.c:=
3259 ata_eh_finish+0xc2/0xd0 [libata]()
[ 5696.001713] Modules linked in: isofs zlib_inflate autofs4 af_packet irne=
t ppp_generic slhc ircomm_tty ircomm ide_gd_mod ide_generic ide_core binfmt=
_misc loop dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath dm_m=
od nvram toshiba cryptomgr aead crypto_blkcipher michael_mic crypto_algapi =
orinoco_cs orinoco hermes_dld hermes pcmcia firmware_class snd_ali5451 snd_=
ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn=
d_seq_device snd_pcm_oss smsc_ircc2 snd_pcm irda snd_timer snd_mixer_oss rt=
c_cmos yenta_socket snd rsrc_nonstatic rtc_core pcmcia_core crc_ccitt i2c_a=
li1535 psmouse rtc_lib sr_mod pcspkr soundcore evdev i2c_core cdrom alim153=
5_wdt snd_page_alloc video sg fan output toshiba_acpi rfkill backlight ther=
mal input_polldev processor battery ac ali_agp button ohci_hcd agpgart usbc=
ore pata_ali libata sd_mod scsi_mod reiserfs
[ 5696.002757] Pid: 872, comm: scsi_eh_1 Tainted: G        W  2.6.28-rc3-1a=
vb #10
[ 5696.002772] Call Trace:
[ 5696.002806]  [<c02f54e8>] ? printk+0x18/0x20
[ 5696.002841]  [<c011da54>] warn_on_slowpath+0x54/0x80
[ 5696.002907]  [<dfb9005d>] ? __ata_port_next_link+0x5d/0x70 [libata]
[ 5696.002961]  [<dfba31d0>] ? ata_sff_softreset+0x0/0x150 [libata]
[ 5696.003009]  [<dfba3320>] ? ata_sff_prereset+0x0/0xc0 [libata]
[ 5696.003087]  [<c013fbab>] ? trace_hardirqs_on+0xb/0x10
[ 5696.003108]  [<c012e23a>] ? __cancel_work_timer+0xaa/0x160
[ 5696.003126]  [<c012e1ca>] ? __cancel_work_timer+0x3a/0x160
[ 5696.003177]  [<dfb9f6d2>] ata_eh_finish+0xc2/0xd0 [libata]
[ 5696.003227]  [<dfba3320>] ? ata_sff_prereset+0x0/0xc0 [libata]
[ 5696.003277]  [<dfb9f763>] ata_do_eh+0x83/0x90 [libata]
[ 5696.003327]  [<dfba1310>] ? ata_sff_postreset+0x0/0x70 [libata]
[ 5696.003379]  [<dfba11f7>] ata_sff_error_handler+0xc7/0x1e0 [libata]
[ 5696.003429]  [<dfba1310>] ? ata_sff_postreset+0x0/0x70 [libata]
[ 5696.003480]  [<dfba31d0>] ? ata_sff_softreset+0x0/0x150 [libata]
[ 5696.003533]  [<dfb9ff7e>] ata_scsi_error+0x2be/0x610 [libata]
[ 5696.003554]  [<c02f58eb>] ? schedule+0x2db/0x4b0
[ 5696.003746]  [<dfb2fe7c>] scsi_error_handler+0xdc/0x550 [scsi_mod]
[ 5696.003834]  [<c0119e30>] ? finish_task_switch+0x0/0xc0
[ 5696.003853]  [<c02f58eb>] ? schedule+0x2db/0x4b0
[ 5696.003903]  [<dfb2fda0>] ? scsi_error_handler+0x0/0x550 [scsi_mod]
[ 5696.003934]  [<c013158a>] kthread+0x3a/0x70
[ 5696.003951]  [<c0131550>] ? kthread+0x0/0x70
[ 5696.003978]  [<c0104043>] kernel_thread_helper+0x7/0x14
[ 5696.003993] ---[ end trace 57d3c9e80c1b210a ]---
[ 5696.004673] ------------[ cut here ]------------
[ 5696.004706] WARNING: at /home/bor/src/linux-git/drivers/ata/libata-core.=
c:4807 ata_qc_issue+0x3b/0x220 [libata]()
[ 5696.004721] Modules linked in: isofs zlib_inflate autofs4 af_packet irne=
t ppp_generic slhc ircomm_tty ircomm ide_gd_mod ide_generic ide_core binfmt=
_misc loop dm_mirror dm_region_hash dm_log dm_round_robin dm_multipath dm_m=
od nvram toshiba cryptomgr aead crypto_blkcipher michael_mic crypto_algapi =
orinoco_cs orinoco hermes_dld hermes pcmcia firmware_class snd_ali5451 snd_=
ac97_codec ac97_bus snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq sn=
d_seq_device snd_pcm_oss smsc_ircc2 snd_pcm irda snd_timer snd_mixer_oss rt=
c_cmos yenta_socket snd rsrc_nonstatic rtc_core pcmcia_core crc_ccitt i2c_a=
li1535 psmouse rtc_lib sr_mod pcspkr soundcore evdev i2c_core cdrom alim153=
5_wdt snd_page_alloc video sg fan output toshiba_acpi rfkill backlight ther=
mal input_polldev processor battery ac ali_agp button ohci_hcd agpgart usbc=
ore pata_ali libata sd_mod scsi_mod reiserfs
[ 5696.005610] Pid: 3281, comm: hald-addon-stor Tainted: G        W  2.6.28=
=2Drc3-1avb #10
[ 5696.005626] Call Trace:
[ 5696.005652]  [<c02f54e8>] ? printk+0x18/0x20
[ 5696.005682]  [<c011da54>] warn_on_slowpath+0x54/0x80
[ 5696.005733]  [<c016b86e>] ? mempool_alloc_slab+0xe/0x10
[ 5696.005751]  [<c016bb00>] ? mempool_alloc+0x30/0xf0
[ 5696.005786]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.005903]  [<dfb2bf73>] ? scsi_pool_alloc_command+0x43/0x70 [scsi_mod]
[ 5696.005974]  [<dfb9a2bb>] ? atapi_drain_needed+0x2b/0x40 [libata]
[ 5696.005996]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.006018]  [<c018cdc9>] ? kmem_cache_alloc+0x59/0xd0
[ 5696.006063]  [<dfb2bf73>] ? scsi_pool_alloc_command+0x43/0x70 [scsi_mod]
[ 5696.006083]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.006131]  [<dfb2c287>] ? scsi_get_command+0x67/0x90 [scsi_mod]
[ 5696.006183]  [<dfb9329b>] ata_qc_issue+0x3b/0x220 [libata]
[ 5696.006233]  [<dfb98fc7>] ata_scsi_translate+0xb7/0x180 [libata]
[ 5696.006260]  [<c02f8388>] ? _spin_lock+0x58/0x60
[ 5696.006374]  [<dfb2b750>] ? scsi_done+0x0/0x10 [scsi_mod]
[ 5696.006427]  [<dfb9b22a>] ata_scsi_queuecmd+0xba/0x220 [libata]
[ 5696.006478]  [<dfb99480>] ? atapi_xlat+0x0/0x190 [libata]
[ 5696.006524]  [<dfb2b750>] ? scsi_done+0x0/0x10 [scsi_mod]
[ 5696.006570]  [<dfb2b961>] scsi_dispatch_cmd+0xe1/0x250 [scsi_mod]
[ 5696.006690]  [<dfb315e3>] scsi_request_fn+0x3a3/0x510 [scsi_mod]
[ 5696.006710]  [<c02f81bf>] ? _spin_unlock_irqrestore+0x4f/0x60
[ 5696.006754]  [<c01eb963>] __generic_unplug_device+0x23/0x30
[ 5696.006834]  [<c01ee2fc>] blk_execute_rq_nowait+0x5c/0xa0
[ 5696.006852]  [<c01ee3ec>] blk_execute_rq+0xac/0xd0
[ 5696.006981]  [<c01ee270>] ? blk_end_sync_rq+0x0/0x30
[ 5696.007131]  [<c01f5acb>] ? cfq_set_request+0xcb/0x300
[ 5696.007262]  [<c01f5a00>] ? cfq_set_request+0x0/0x300
[ 5696.007394]  [<c01e89ff>] ? elv_set_request+0x1f/0x50
[ 5696.007525]  [<c01eb4d4>] ? get_request+0x264/0x290
[ 5696.007690]  [<dfb32c87>] scsi_execute+0xd7/0x120 [scsi_mod]
[ 5696.007849]  [<dfb32d3a>] scsi_execute_req+0x6a/0xd0 [scsi_mod]
[ 5696.007855]  [<e00b828a>] sr_test_unit_ready+0x5a/0xf0 [sr_mod]
[ 5696.007855]  [<e00b8595>] sr_media_change+0x55/0x260 [sr_mod]
[ 5696.007855]  [<dff460aa>] media_changed+0x6a/0xb0 [cdrom]
[ 5696.007855]  [<dff46129>] cdrom_media_changed+0x39/0x50 [cdrom]
[ 5696.007855]  [<e00b8381>] sr_block_media_changed+0x11/0x20 [sr_mod]
[ 5696.007855]  [<c01b49d4>] check_disk_change+0x24/0x70
[ 5696.007855]  [<dff4a32a>] cdrom_open+0x16a/0xb20 [cdrom]
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<dff493e2>] ? cdrom_ioctl+0x32/0xe10 [cdrom]
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<c0141b7d>] ? print_lock_contention_bug+0x1d/0x110
[ 5696.007855]  [<c02f67d1>] ? mutex_lock_nested+0x1e1/0x270
[ 5696.007855]  [<c013fbab>] ? trace_hardirqs_on+0xb/0x10
[ 5696.007855]  [<e00b84ed>] sr_block_open+0x5d/0xb0 [sr_mod]
[ 5696.007855]  [<c01b5331>] __blkdev_get+0x221/0x2c0
[ 5696.007855]  [<c01b53da>] blkdev_get+0xa/0x10
[ 5696.007855]  [<c01b5664>] blkdev_open+0x64/0xc0
[ 5696.007855]  [<c018e99c>] __dentry_open+0x9c/0x250
[ 5696.007855]  [<c018ec25>] nameidata_to_filp+0x45/0x60
[ 5696.007855]  [<c01b5600>] ? blkdev_open+0x0/0xc0
[ 5696.007855]  [<c019b579>] do_filp_open+0x1e9/0x810
[ 5696.007855]  [<c02f81ed>] ? _spin_unlock+0x1d/0x20
[ 5696.007855]  [<c01a44a8>] ? alloc_fd+0xe8/0x100
[ 5696.007855]  [<c018e7b9>] do_sys_open+0x59/0xf0
[ 5696.007855]  [<c018e8b9>] sys_open+0x29/0x40
[ 5696.007855]  [<c01033b9>] sysenter_do_call+0x12/0x31
[ 5696.007855] ---[ end trace 57d3c9e80c1b210a ]---

--nextPart4545247.dXvYFO2xiD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkQlDYACgkQR6LMutpd94x5LgCggODl+qw75giy/5WOQvzTcd2D
Eg8AoKcmdvLWtR7kUZwUKC4eYSPciupP
=8qKp
-----END PGP SIGNATURE-----

--nextPart4545247.dXvYFO2xiD--
