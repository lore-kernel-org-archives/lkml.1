Return-Path: <linux-kernel-owner+w=401wt.eu-S1763799AbXJZRa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763799AbXJZRa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756392AbXJZRaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:30:12 -0400
Received: from mx40.mail.ru ([194.67.23.36]:53026 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbXJZRaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:30:08 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ide@vger.kernel.org
Subject: 2.6.24-rc1: pata_acpi fails to activate DMA for DVD-ROM on ALi M5229 secondary channel
Date: Fri, 26 Oct 2007 21:30:02 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4391925.fbdIblEMNr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710262130.03567.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4391925.fbdIblEMNr
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Running legacy IDE drivers apparently works in DMA mode for both:

[  977.965732] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  977.992455] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with
 idebus=3Dxx
[  978.051475] ALI15X3: IDE controller at PCI slot 0000:00:04.0
[  978.079054] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  978.106380] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[  978.133773] ALI15X3: chipset revision 195
[  978.160976] ALI15X3: not 100% native mode: will probe irqs later
[  978.188724]     ide0: BM-DMA at 0xeff0-0xeff7, BIOS settings: hda:DMA,=20
hdb:pio
[  978.217143]     ide1: BM-DMA at 0xeff8-0xefff, BIOS settings: hdc:DMA,=20
hdd:pio
[  978.245413] Probing IDE interface ide0...
[  978.520045] hda: IC25N020ATDA04-0, ATA DISK drive
[  979.186275] hda: host side 80-wire cable detection failed, limiting max=
=20
speed to UDMA33
[  979.214905] hda: selected mode 0x42
[  979.215421] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[  979.260674] Probing IDE interface ide1...
[  979.962872] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
[  980.629100] hdc: selected mode 0x42
[  980.668382] ide1 at 0x170-0x177,0x376 on irq 15
[  980.763889] hda: max request size: 128KiB
[  980.791954] hda: 39070080 sectors (20003 MB) w/1806KiB Cache,=20
CHS=3D38760/16/63, UDMA(33)
[  980.820383] hda: cache flushes not supported
[  980.848674]  hda: hda1 hda2

{pts/1}% sudo hdparm -I /dev/hdc

/dev/hdc:

ATAPI CD-ROM, with removable media
        Model Number:       TOSHIBA DVD-ROM SD-C2502
        Serial Number:      0100208938
        Firmware Revision:  1313
Standards:
        Used: ATAPI for CD-ROMs, SFF-8020i, r2.5
        Supported: CD-ROM ATAPI-2
Configuration:
        DRQ response: 50us.
        Packet size: 12 bytes
Capabilities:
        LBA, IORDY(can be disabled)
        Buffer size: 128.0kB
        DMA: sdma0 sdma1 sdma2 mdma0 mdma1 mdma2 udma0 udma1 *udma2
             Cycle time: min=3D120ns recommended=3D120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns

while pata_acpi says something about

[  524.200200] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[  524.224890] ata2.00: simplex DMA is claimed by other device, disabling D=
MA

full dmesg follows


[    0.000000] Linux version 2.6.24-rc1-2avb (bor@cooker) (gcc version 4.2.=
2=20
20070909 (prerelease) (4.2.2-0.RC.1mdv2008.0)) #2 Fri Oct 26 19:59:00 MSD=20
2007
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
[    0.000000] 495MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 126816) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   126816
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   126816
[    0.000000] On node 0 totalpages: 126816
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 958 pages used for memmap
[    0.000000]   Normal zone: 121762 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
[    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
=20
4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
=20
100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap:=20
20000000:dff80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 -=
=20
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 -=
=20
00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 -=
=20
00000000000ee000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ee000 -=
=20
00000000000ef000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ef000 -=
=20
0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l=20
pages: 125826
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.24-rc1-2avb root=3DLAB=
EL=3D/=20
resume=3DLABEL=3Dswap vga=3D791 1
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.678 MHz processor.
[  516.640927] Console: colour dummy device 80x25
[  516.640953] console [tty0] enabled
[  516.643123] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
=20
Ingo Molnar
[  516.643149] ... MAX_LOCKDEP_SUBCLASSES:    8
[  516.643164] ... MAX_LOCK_DEPTH:          30
[  516.643179] ... MAX_LOCKDEP_KEYS:        2048
[  516.643194] ... CLASSHASH_SIZE:           1024
[  516.643209] ... MAX_LOCKDEP_ENTRIES:     8192
[  516.643225] ... MAX_LOCKDEP_CHAINS:      16384
[  516.643240] ... CHAINHASH_SIZE:          8192
[  516.643255]  memory used by lock dependency info: 1024 kB
[  516.643273]  per task-struct memory footprint: 1680 bytes
[  516.643291] ------------------------
[  516.643304] | Locking API testsuite:
[ =20
516.643319] ---------------------------------------------------------------=
=2D------------
[  516.643345]                                  | spin |wlock |rlock |mutex=
 |=20
wsem | rsem |
[ =20
516.643372]   -------------------------------------------------------------=
=2D------------
[  516.643423]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.646320]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.648532]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.650789]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.653047]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.655371]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.657694]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.660028]                     double unlock:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.662162]                   initialize held:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[  516.664288]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 | =20
ok  |  ok  |
[ =20
516.666481]   -------------------------------------------------------------=
=2D------------
[  516.666508]               recursive read-lock:             | =20
ok  |             |  ok  |
[  516.667240]            recursive read-lock #2:             | =20
ok  |             |  ok  |
[  516.667974]             mixed read-write-lock:             | =20
ok  |             |  ok  |
[  516.668711]             mixed write-read-lock:             | =20
ok  |             |  ok  |
[ =20
516.669446]   -------------------------------------------------------------=
=2D------------
[  516.669473]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  516.670562]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[  516.671653]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  516.672731]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[  516.673810]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[  516.674892]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[  516.675971]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  516.677050]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[  516.678135]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  516.679214]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[  516.680296]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  516.681406]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[  516.682517]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  516.683626]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[  516.684733]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  516.685841]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[  516.686951]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  516.688055]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[  516.689162]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  516.690252]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[  516.691344]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  516.692446]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[  516.693549]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  516.694658]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[  516.695770]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  516.696875]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[  516.697986]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  516.699090]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[  516.700201]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  516.701305]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[  516.702412]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  516.703518]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[  516.704629]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  516.705732]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[  516.706841]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  516.707953]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[  516.709068]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  516.710173]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[  516.711287]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  516.712393]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[  516.713504]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  516.714608]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[  516.715720]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  516.716827]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[  516.717943]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  516.719049]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[  516.720161]       hard-irq read-recursion/123:  ok  |
[  516.720545]       soft-irq read-recursion/123:  ok  |
[  516.720928]       hard-irq read-recursion/132:  ok  |
[  516.721310]       soft-irq read-recursion/132:  ok  |
[  516.721692]       hard-irq read-recursion/213:  ok  |
[  516.722073]       soft-irq read-recursion/213:  ok  |
[  516.722455]       hard-irq read-recursion/231:  ok  |
[  516.722838]       soft-irq read-recursion/231:  ok  |
[  516.723221]       hard-irq read-recursion/312:  ok  |
[  516.723602]       soft-irq read-recursion/312:  ok  |
[  516.723985]       hard-irq read-recursion/321:  ok  |
[  516.724367]       soft-irq read-recursion/321:  ok  |
[  516.724751] -------------------------------------------------------
[  516.724773] Good, all 218 testcases passed! |
[  516.724788] ---------------------------------
[  516.726402] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[  516.729374] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[  516.834940] Memory: 496152k/507264k available (1876k kernel code, 10548k=
=20
reserved, 889k data, 188k init, 0k highmem)
[  516.835035] virtual kernel memory layout:
[  516.835039]     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
[  516.835043]     vmalloc : 0xdf800000 - 0xffff4000   ( 519 MB)
[  516.835047]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[  516.835051]       .init : 0xc03b6000 - 0xc03e5000   ( 188 kB)
[  516.835055]       .data : 0xc02d5179 - 0xc03b3964   ( 889 kB)
[  516.835059]       .text : 0xc0100000 - 0xc02d5179   (1876 kB)
[  516.835148] Checking if this processor honours the WP bit even in=20
supervisor mode... Ok.
[  516.835440] SLUB: Genslabs=3D11, HWalign=3D32, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1,=20
Nodes=3D1
[  516.918855] Calibrating delay using timer specific routine.. 1498.37=20
BogoMIPS (lpj=3D2496595)
[  516.919087] Mount-cache hash table entries: 512
[  516.920241] CPU: After generic identify, caps: 0383f9ff 00000000 0000000=
0=20
00000000 00000000 00000000 00000000 00000000
[  516.920283] CPU: L1 I cache: 16K, L1 D cache: 16K
[  516.920311] CPU: L2 cache: 256K
[  516.920332] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040=20
00000000 00000000 00000000 00000000
[  516.920373] Compat vDSO mapped to ffffe000.
[  516.920434] CPU: Intel Pentium III (Coppermine) stepping 0a
[  516.920471] Checking 'hlt' instruction... OK.
[  516.932976] Freeing SMP alternatives: 0k freed
[  516.933754] Early unpacking initramfs... done
[  517.012908] ACPI: Core revision 20070126
[  517.013740] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml=
=20
not found.
[  517.024152] Parsing all Control Methods:
[  517.024502] Table [DSDT](id 0001) - 683 Objects with 60 Devices 195 Meth=
ods=20
10 Regions
[  517.024543]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables=20
successfully acquired
[  517.024585] ACPI: setting ELCR to 0200 (from 0a00)
[  517.025174] evxfevnt-0091 [00] enable                : Transition to ACP=
I=20
mode successful
[  517.027659] net_namespace: 80 bytes
[  517.030954] NET: Registered protocol family 16
[  517.032772] ACPI: bus type pci registered
[  517.034808] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[  517.034861] PCI: Using configuration type 1
[  517.034876] Setting up standard PCI resources
[  517.048111] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 3F [_GP=
E]=20
8 regs on int 0x9
[  517.050326] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake,=20
Enabled 0 Runtime GPEs in this block
[  517.050382] ACPI: EC: Look up EC in DSDT
[  517.058452] Completing Region/Field/Buffer/Package=20
initialization:.....................................
[  517.061193] Initialized 5/10 Regions 0/0 Fields 16/16 Buffers 16/27=20
Packages (692 nodes)
[  517.061227] Initializing Device/Processor/Thermal objects by executing _=
INI=20
methods:.
[  517.064772] Executed 1 _INI methods requiring 0 _STA executions (examine=
d=20
64 objects)
[  517.064873] ACPI: Interpreter enabled
[  517.064893] ACPI: (supports S0 S3 S4 S5)
[  517.065049] ACPI: Using PIC for interrupt routing
[  517.097811] ACPI: PCI Root Bridge [PCI0] (0000:00)
[  517.099553] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[  517.099592] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[  517.101894] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[  517.102617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[  517.129978] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[  517.130749] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[  517.131462] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[  517.132240] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[  517.132970] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[  517.133683] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[  517.135016] ACPI: Power Resource [PFAN] (off)
[  517.135535] Linux Plug and Play Support v0.97 (c) Adam Belay
[  517.135827] pnp: PnP ACPI init
[  517.135970] ACPI: bus type pnp registered
[  517.160282] pnp: PnP ACPI: found 12 devices
[  517.160340] ACPI: ACPI bus type pnp unregistered
[  517.161428] PCI: Using ACPI for IRQ routing
[  517.161466] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[  517.185407] Time: tsc clocksource has been installed.
[  517.192414] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[  517.192448] system 00:00: iomem range 0xe0000-0xeffff could not be reser=
ved
[  517.192475] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[  517.192502] system 00:00: iomem range 0x100000-0x1ef5ffff could not be=20
reserved
[  517.226218] PCI: Bridge: 0000:00:01.0
[  517.226258]   IO window: disabled.
[  517.226286]   MEM window: f7f00000-fdffffff
[  517.226308]   PREFETCH window: disabled.
[  517.226336] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[  517.226354]   IO window: 00001000-000010ff
[  517.226377]   IO window: 00001400-000014ff
[  517.226400]   PREFETCH window: 30000000-33ffffff
[  517.226423]   MEM window: 34000000-37ffffff
[  517.226446] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[  517.226463]   IO window: 00001800-000018ff
[  517.226485]   IO window: 00001c00-00001cff
[  517.226508]   PREFETCH window: 38000000-3bffffff
[  517.226532]   MEM window: 3c000000-3fffffff
[  517.226555] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[  517.226573]   IO window: 00002000-000020ff
[  517.226595]   IO window: 00002400-000024ff
[  517.226618]   PREFETCH window: 40000000-43ffffff
[  517.226641]   MEM window: 44000000-47ffffff
[  517.226692] PCI: Setting latency timer of device 0000:00:01.0 to 64
[  517.226774] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[  517.228380] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[  517.228413] PCI: setting IRQ 11 as level-triggered
[  517.228423] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
=20
(level, low) -> IRQ 11
[  517.228506] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[  517.229749] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[  517.229778] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
=20
(level, low) -> IRQ 11
[  517.229857] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[  517.231032] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[  517.231057] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
=20
(level, low) -> IRQ 11
[  517.231163] NET: Registered protocol family 2
[  517.262473] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[  517.264032] TCP established hash table entries: 16384 (order: 7, 589824=
=20
bytes)
[  517.270191] TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
[  517.276306] TCP: Hash tables configured (established 16384 bind 16384)
[  517.276527] TCP reno registered
[  517.286304] checking if image is initramfs... it is
[  517.424414] Freeing initrd memory: 548k freed
[  517.428537] audit: initializing netlink socket (disabled)
[  517.428820] audit(1193416852.596:1): initialized
[  517.449879] io scheduler noop registered
[  517.449942] io scheduler anticipatory registered
[  517.449961] io scheduler deadline registered
[  517.450513] io scheduler cfq registered (default)
[  517.450624] Activating ISA DMA hang workarounds.
[  517.450696] Boot video device is 0000:01:00.0
[  517.451821] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng=20
3072k, total 16384k
[  517.451867] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[  517.451887] vesafb: protected mode interface info at c000:775e
[  517.451908] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
=20
c00c77e2
[  517.451930] vesafb: scrolling: redraw
[  517.451948] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[  517.521909] Console: switching to colour frame buffer device 128x48
[  517.584654] fb0: VESA VGA frame buffer device
[  517.728628] Switched to high resolution mode on CPU 0
[  517.822561] Real Time Clock Driver v1.12ac
[  517.829244] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
=20
blocksize
[  517.830938] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[  517.831755] e100: Copyright(c) 1999-2006 Intel Corporation
[  517.834906] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[  517.835821] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
=20
(level, low) -> IRQ 11
[  517.865901] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:d7:14:a1
[  517.867131] console [netcon0] enabled
[  522.592910] Clocksource tsc unstable (delta =3D 4686954543 ns)
[  522.620167] Time: acpi_pm clocksource has been installed.
[  522.647386] netconsole: network logging started
[  522.675431] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
=20
irq 1,12
[  522.708557] serio: i8042 KBD port at 0x60,0x64 irq 1
[  522.735837] serio: i8042 AUX port at 0x60,0x64 irq 12
[  522.764194] mice: PS/2 mouse device common for all mice
[  522.791405] cpuidle: using governor ladder
[  522.817591] cpuidle: using governor menu
[  522.843528] TCP cubic registered
[  522.869609] NET: Registered protocol family 1
[  522.894814] Using IPI Shortcut mode
[  522.920678] BIOS EDD facility v0.16 2004-Jun-25, 16 devices found
[  522.952935] Freeing unused kernel memory: 188k freed
[  522.978165] Write protecting the kernel read-only data: 716k
[  523.009845] input: AT Translated Set 2 keyboard=20
as /devices/platform/i8042/serio0/input/input0
[  523.121270] SCSI subsystem initialized
[  523.211882] libata version 3.00 loaded.
[  523.245470] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  523.271487] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[  523.297853] ata4294967295: failed to start port (errno=3D-19)
[  523.324223] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  523.421674] ACPI: Unable to derive IRQ for device 0000:00:04.0
[  523.447747] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[  523.474283] scsi0 : pata_ali
[  523.500521] scsi1 : pata_ali
[  523.527940] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq =
14
[  523.553554] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq =
15
[  523.737291] ata1.00: ATA-5: IC25N020ATDA04-0, DA3OA70A, max UDMA/100
[  523.762408] ata1.00: 39070080 sectors, multi 0: LBA=20
[  523.787397] ata1.00: limited to UDMA/33 due to 40-wire cable
[  523.823786] ata1.00: configured for UDMA/33
[  524.200200] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
[  524.224890] ata2.00: simplex DMA is claimed by other device, disabling D=
MA
[  524.433408] ata2.00: configured for PIO4
[  524.458673] scsi 0:0:0:0: Direct-Access     ATA      IC25N020ATDA04-0 DA=
3O=20
PQ: 0 ANSI: 5
[  524.484834] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 =
MB)
[  524.509540] sd 0:0:0:0: [sda] Write Protect is off
[  524.533781] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  524.533932] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[  524.559427] sd 0:0:0:0: [sda] 39070080 512-byte hardware sectors (20004 =
MB)
[  524.584354] sd 0:0:0:0: [sda] Write Protect is off
[  524.608652] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  524.608800] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[  524.633631]  sda: sda1 sda2
[  524.688530] sd 0:0:0:0: [sda] Attached SCSI disk
[  524.726881] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 13=
13=20
PQ: 0 ANSI: 5
[  525.164956] swsusp: Marking nosave pages: 000000000009f000 -=20
0000000000100000
[  525.164987] swsusp: Basic memory bitmaps created
[  525.200632] swsusp: Basic memory bitmaps freed
[  525.346708] ReiserFS: sda2: found reiserfs format "3.6" with standard=20
journal
[  525.370400] ReiserFS: sda2: using ordered data mode
[  525.412737] ReiserFS: sda2: journal params: device sda2, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[  525.471135] ReiserFS: sda2: checking transaction log (sda2)
[  525.542975] ReiserFS: sda2: Using r5 hash to sort names
[  534.637643] sd 0:0:0:0: Attached scsi generic sg0 type 0
[  534.637769] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[  535.371031] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
[  535.371057] Uniform CD-ROM driver Revision: 3.20
[  535.371459] sr 1:0:0:0: Attached scsi CD-ROM sr0
[  535.567610] Linux agpgart interface v0.102
[  536.088236] agpgart: Detected ALi M1644 chipset
[  536.101692] agpgart: AGP aperture is 64M @ 0xf0000000
[  536.144303] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[  536.144714] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[  537.066856] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  537.066923] Yenta: Using CSCINT to route CSC interrupts to PCI
[  537.066929] Yenta: Routing CardBus interrupts to PCI
[  537.066943] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  537.289979] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ=20
sharing enabled
[  537.296843] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  537.296862] Socket status: 30000059
[  537.416917] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  537.543575] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  537.543594] Socket status: 30000007
[  537.558090] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  537.574372] serial 00:09: activated
[  537.690918] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  537.690939] Socket status: 30000007
[  537.943137] usbcore: registered new interface driver usbfs
[  537.943489] usbcore: registered new interface driver hub
[  537.955061] usbcore: registered new device driver usb
[  538.052617] pccard: PCMCIA card inserted into slot 0
[  538.505432] NET: Registered protocol family 23
[  538.542005] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[  538.543997] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[  538.544017] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
=20
(level, low) -> IRQ 11
[  538.544086] ohci_hcd 0000:00:02.0: OHCI Host Controller
[  538.546851] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 1
[  538.546942] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[  538.603004] usb usb1: configuration #1 chosen from 1 choice
[  538.603380] hub 1-0:1.0: USB hub found
[  538.603526] hub 1-0:1.0: 3 ports detected
[  538.900212] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[  538.900252] Activated ALi 1533 ISA bridge port 0x02e8.
[  538.900267] Activated ALi 1533 ISA bridge port 0x02f8.
[  538.900478] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[  538.900513] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x0a
[  538.900554] SMsC IrDA Controller found
[  538.900557]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[  538.900769] No transceiver found. Defaulting to Fast pin select
[  538.902862] IrDA: Registered device irda0
[  539.211830] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[  539.211855] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
=20
(level, low) -> IRQ 11
[  542.315788] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x330-0x337 0x388-0x38f
[  542.318898] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x330-0x337 0x388-0x38f
[  542.322150] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  542.323644] cs: IO port probe 0x820-0x8ff: clean.
[  542.325041] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  542.326524] cs: IO port probe 0x820-0x8ff: clean.
[  542.327833] cs: IO port probe 0xc00-0xcf7: clean.
[  542.329327] cs: IO port probe 0xc00-0xcf7: clean.
[  542.331694] cs: IO port probe 0xa00-0xaff: clean.
[  542.335153] cs: IO port probe 0xa00-0xaff: clean.
[  542.378069] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[  542.409324] pcmcia: registering new device pcmcia0.0
[  542.920481] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207=20
0x220-0x22f 0x330-0x337 0x388-0x38f
[  542.923815] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f=20
0x480-0x48f 0x4d0-0x4d7
[  542.925383] cs: IO port probe 0x820-0x8ff: clean.
[  542.926870] cs: IO port probe 0xc00-0xcf7: clean.
[  542.934056] cs: IO port probe 0xa00-0xaff: clean.
[  543.418405] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
=20
Systems, http://www.agere.com
[  543.418434] *** Modified for kernel 2.6 by Andrey Borzenkov=20
<arvidjaar@mail.ru> $Revision: 39 $
[  543.418442] *** Station Mode (STA) Support: YES
[  543.418448] *** Access Point Mode (AP) Support: YES
[  544.395305] eth1: PRI 31 variant 2 version 9.48
[  544.395374] eth1: NIC 5 variant 2 version 1.02
[  544.479305] eth1: Wireless, io_addr 0x100, irq 11, mac_address=20
00:02:2D:26:95:6C
[  545.679081] Toshiba System Managment Mode driver v1.11 26/9/2001
[  545.757056] Non-volatile memory driver v1.2
[  545.969214] input: ImPS/2 Generic Wheel Mouse=20
as /devices/platform/i8042/serio1/input/input1
[  546.968302] ACPI: AC Adapter [ADP1] (on-line)
[  547.046401] ACPI: Battery Slot [BAT1] (battery present)
[  547.055529] ACPI: Battery Slot [BAT2] (battery absent)
[  547.103081] input: Power Button (FF) as /devices/virtual/input/input2
[  547.127036] ACPI: Power Button (FF) [PWRF]
[  547.127599] input: Lid Switch as /devices/virtual/input/input3
[  547.140237] ACPI: Lid Switch [LID]
[  547.187409] ACPI: Transitioning device [FAN] to D3
[  547.187428] ACPI: Transitioning device [FAN] to D3
[  547.193056] ACPI: Fan [FAN] (off)
[  547.364389] ACPI: CPU0 (power states: C1[C1] C2[C2])
[  547.464157] ACPI: Thermal Zone [THRM] (59 C)
[  547.612936] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[  547.612956] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[  547.712089] input: Video Bus as /devices/virtual/input/input4
[  547.740107] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[  548.179656] Marking TSC unstable due to: TSC halts in idle.
[  548.310870] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[  548.310908] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with idebus=3Dxx
[  548.500962] device-mapper: uevent: version 1.0.3
[  548.501532] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised:=
=20
dm-devel@redhat.com
[  548.855189] loop: module loaded
[  551.351386] Adding 500432k swap on /dev/sda1.  Priority:-1 extents:1=20
across:500432k

--nextPart4391925.fbdIblEMNr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIiQbR6LMutpd94wRAj+CAKC5ZEOpoNT6cO32OFzrZ99c624uwACeJlW9
SbZp56A50bN2qVZWnIAXfs8=
=pmCZ
-----END PGP SIGNATURE-----

--nextPart4391925.fbdIblEMNr--
