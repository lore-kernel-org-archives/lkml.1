Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbXKXUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbXKXUhM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 15:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbXKXUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 15:36:56 -0500
Received: from mx27.mail.ru ([194.67.23.23]:3609 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXKXUgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 15:36:52 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-serial@vger.kernel.org
Subject: 2.6.24: Serial disabled in BIOS but serial modules still loaded (probably PnP related)
Date: Sat, 24 Nov 2007 23:36:37 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2470014.PoRkmeGDfM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711242336.43712.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2470014.PoRkmeGDfM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I have no COM port on notebook (without port replicator which I do not have)
so COM is disabled in BIOS. No ttyS* is detected during boot (and no device
created) but I just noticed that serial modules are still loaded. Well, this
partially defeats the purpose of disabling COM port - the intention was to
free resources by *not* loading unneeded modules ...

This may have something to do with (ACPI) PnP which apparently believes COM=
 is alive.
Notebook is Toshiba Portege 4000.

{pts/0}% lsmod | grep 82
8250_pnp                9792  0
8250                   24660  1 8250_pnp
serial_core            22872  1 8250

{pts/0}% lspnp -v
00:00 PNP0c01 System board
    state =3D active
        mem 0x0-0x9ffff
        mem 0xe0000-0xeffff
        mem 0xf0000-0xfffff
        mem 0x100000-0x1ef5ffff

00:01 PNP0a03 PCI bus
    state =3D active
        io 0xcf8-0xcff

00:02 PNP0200 AT DMA controller
    state =3D active
        io 0x0-0xf
        io 0x81-0x83
        io 0x87-0x87
        io 0x89-0x8b
        io 0x8f-0x8f
        io 0xc0-0xdf
        dma 4

00:03 PNP0800 AT speaker
    state =3D active
        io 0x61-0x61

00:04 PNP0c04 Math coprocessor
    state =3D active
        io 0xf0-0xff
        irq 13

00:05 PNP0303 IBM enhanced keyboard (101/102-key, PS/2 mouse support)
    state =3D active
        io 0x60-0x60
        io 0x64-0x64
        irq 1

00:06 PNP0f13 PS/2 port for PS/2-style mice
    state =3D active
        irq 12

00:07 PNP0b00 AT real-time clock
    state =3D active
        io 0x70-0x71
        irq 8

00:08 PNP0c02 Motherboard resources
    state =3D active
        io 0x2e-0x2f
        io 0x62-0x62
        io 0x66-0x66
        io 0x80-0x80
        io 0x84-0x86
        io 0x88-0x88
        io 0x8c-0x8e
        io 0x92-0x92

00:09 PNP0501 16550A-compatible serial port
    state =3D active
        io 0x3f8-0x3ff
        irq 5

00:0a SMCf010 SMC Fast Infrared Port
    state =3D disabled

00:0b PNP0401 ECP printer port
    state =3D disabled


[    0.000000] Linux version 2.6.24-rc3-1avb (bor@cooker) (gcc version 4.2.=
2 (4.2.2-1mdv2008.1)) #7 Sat Nov 17 12:09:07 MSK 2007
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
 4010000)
[    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814 TASM =
 4010000)
[    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417 MSFT =
 100000A)
[    0.000000] ACPI: FACS 000EEE00, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0xee08
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000=
:dff80000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - =
00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - =
00000000000e0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000e0000 - =
00000000000ee000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ee000 - =
00000000000ef000
[    0.000000] swsusp: Registered nosave memory region: 00000000000ef000 - =
0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 125826
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.24-rc3-1avb root=3DLAB=
EL=3D/ resume=3DLABEL=3Dswap vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.681 MHz processor.
[   64.681620] Console: colour dummy device 80x25
[   64.681647] console [tty0] enabled
[   64.683794] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[   64.683819] ... MAX_LOCKDEP_SUBCLASSES:    8
[   64.683834] ... MAX_LOCK_DEPTH:          30
[   64.683849] ... MAX_LOCKDEP_KEYS:        2048
[   64.683865] ... CLASSHASH_SIZE:           1024
[   64.683880] ... MAX_LOCKDEP_ENTRIES:     8192
[   64.683896] ... MAX_LOCKDEP_CHAINS:      16384
[   64.683911] ... CHAINHASH_SIZE:          8192
[   64.683926]  memory used by lock dependency info: 1024 kB
[   64.683944]  per task-struct memory footprint: 1680 bytes
[   64.683963] ------------------------
[   64.683976] | Locking API testsuite:
[   64.683991] ------------------------------------------------------------=
=2D---------------
[   64.684018]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[   64.684044]   ----------------------------------------------------------=
=2D---------------
[   64.684097]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.686992]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.689199]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.691459]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.693712]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.696038]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.698363]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.700697]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.702833]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.704958]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   64.707150]   ----------------------------------------------------------=
=2D---------------
[   64.707177]               recursive read-lock:             |  ok  |     =
        |  ok  |
[   64.707908]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[   64.708640]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[   64.709377]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[   64.710114]   ----------------------------------------------------------=
=2D---------------
[   64.710140]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   64.711228]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   64.712319]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   64.713397]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   64.714477]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[   64.715557]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[   64.716636]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   64.717716]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   64.718799]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   64.719878]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   64.720960]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   64.722073]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   64.723183]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   64.724292]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   64.725401]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   64.726507]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   64.727617]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   64.728724]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   64.729832]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   64.730922]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   64.732013]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   64.733119]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   64.734222]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   64.735329]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   64.736441]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   64.737549]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   64.738662]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   64.739769]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   64.740877]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   64.741983]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   64.743092]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   64.744195]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   64.745311]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   64.746414]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   64.747520]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   64.748628]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   64.749739]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   64.750843]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   64.751955]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   64.753061]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   64.754172]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   64.755276]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   64.756384]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   64.757492]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   64.758606]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   64.759711]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   64.760826]       hard-irq read-recursion/123:  ok  |
[   64.761208]       soft-irq read-recursion/123:  ok  |
[   64.761593]       hard-irq read-recursion/132:  ok  |
[   64.761974]       soft-irq read-recursion/132:  ok  |
[   64.762357]       hard-irq read-recursion/213:  ok  |
[   64.762736]       soft-irq read-recursion/213:  ok  |
[   64.763118]       hard-irq read-recursion/231:  ok  |
[   64.763499]       soft-irq read-recursion/231:  ok  |
[   64.763883]       hard-irq read-recursion/312:  ok  |
[   64.764263]       soft-irq read-recursion/312:  ok  |
[   64.764646]       hard-irq read-recursion/321:  ok  |
[   64.765026]       soft-irq read-recursion/321:  ok  |
[   64.765410] -------------------------------------------------------
[   64.765431] Good, all 218 testcases passed! |
[   64.765447] ---------------------------------
[   64.767112] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[   64.770080] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[   64.875556] Memory: 495640k/507264k available (1874k kernel code, 11016k=
 reserved, 888k data, 188k init, 0k highmem)
[   64.875648] virtual kernel memory layout:
[   64.875653]     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
[   64.875657]     vmalloc : 0xdf800000 - 0xffff4000   ( 519 MB)
[   64.875661]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[   64.875665]       .init : 0xc03b6000 - 0xc03e5000   ( 188 kB)
[   64.875669]       .data : 0xc02d48c9 - 0xc03b2944   ( 888 kB)
[   64.875673]       .text : 0xc0100000 - 0xc02d48c9   (1874 kB)
[   64.875768] Checking if this processor honours the WP bit even in superv=
isor mode... Ok.
[   64.875990] SLUB: Genslabs=3D11, HWalign=3D32, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1, Nodes=3D1
[   64.959400] Calibrating delay using timer specific routine.. 1498.34 Bog=
oMIPS (lpj=3D2496544)
[   64.959622] Mount-cache hash table entries: 512
[   64.960757] CPU: After generic identify, caps: 0387f9ff 00000000 0000000=
0 00000000 00000000 00000000 00000000 00000000
[   64.960796] CPU: L1 I cache: 16K, L1 D cache: 16K
[   64.960829] CPU: L2 cache: 256K
[   64.960845] CPU serial number disabled.
[   64.960862] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040 00000000 00000000 00000000 00000000
[   64.960904] Compat vDSO mapped to ffffe000.
[   64.960965] CPU: Intel Pentium III (Coppermine) stepping 0a
[   64.961002] Checking 'hlt' instruction... OK.
[   64.973498] Freeing SMP alternatives: 0k freed
[   64.974263] Early unpacking initramfs... done
[   65.078332] ACPI: Core revision 20070126
[   65.079222] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml=
 not found.
[   65.089742] Parsing all Control Methods:
[   65.090071] Table [DSDT](id 0001) - 683 Objects with 60 Devices 195 Meth=
ods 10 Regions
[   65.090110]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[   65.090150] ACPI: setting ELCR to 0200 (from 0a00)
[   65.090741] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[   65.093253] net_namespace: 80 bytes
[   65.096178] NET: Registered protocol family 16
[   65.098112] ACPI: bus type pci registered
[   65.100136] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[   65.100180] PCI: Using configuration type 1
[   65.100196] Setting up standard PCI resources
[   65.113276] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 3F [_GP=
E] 8 regs on int 0x9
[   65.115356] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Ena=
bled 0 Runtime GPEs in this block
[   65.115409] ACPI: EC: Look up EC in DSDT
[   65.123235] Completing Region/Field/Buffer/Package initialization:......=
=2E..............................
[   65.125898] Initialized 5/10 Regions 0/0 Fields 16/16 Buffers 16/27 Pack=
ages (692 nodes)
[   65.125930] Initializing Device/Processor/Thermal objects by executing _=
INI methods:.
[   65.129459] Executed 1 _INI methods requiring 0 _STA executions (examine=
d 64 objects)
[   65.129547] ACPI: Interpreter enabled
[   65.129566] ACPI: (supports S0 S3 S4 S5)
[   65.129715] ACPI: Using PIC for interrupt routing
[   65.161477] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   65.163189] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[   65.163229] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[   65.165447] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   65.166082] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[   65.192907] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[   65.193684] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[   65.194403] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[   65.195119] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[   65.195865] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[   65.196703] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[   65.198015] ACPI: Power Resource [PFAN] (off)
[   65.198385] Linux Plug and Play Support v0.97 (c) Adam Belay
[   65.198649] pnp: PnP ACPI init
[   65.198789] ACPI: bus type pnp registered
[   65.222567] pnp: PnP ACPI: found 12 devices
[   65.222688] ACPI: ACPI bus type pnp unregistered
[   65.223755] PCI: Using ACPI for IRQ routing
[   65.223792] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   65.249274] Time: tsc clocksource has been installed.
[   65.256263] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[   65.256296] system 00:00: iomem range 0xe0000-0xeffff could not be reser=
ved
[   65.256323] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[   65.256349] system 00:00: iomem range 0x100000-0x1ef5ffff could not be r=
eserved
[   65.289947] PCI: Bridge: 0000:00:01.0
[   65.289983]   IO window: disabled.
[   65.290010]   MEM window: f7f00000-fdffffff
[   65.290032]   PREFETCH window: disabled.
[   65.290060] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[   65.290078]   IO window: 00001000-000010ff
[   65.290100]   IO window: 00001400-000014ff
[   65.290122]   PREFETCH window: 30000000-33ffffff
[   65.290146]   MEM window: 34000000-37ffffff
[   65.290168] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[   65.290185]   IO window: 00001800-000018ff
[   65.290207]   IO window: 00001c00-00001cff
[   65.290229]   PREFETCH window: 38000000-3bffffff
[   65.290252]   MEM window: 3c000000-3fffffff
[   65.290275] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[   65.290292]   IO window: 00002000-000020ff
[   65.290314]   IO window: 00002400-000024ff
[   65.290336]   PREFETCH window: 40000000-43ffffff
[   65.290359]   MEM window: 44000000-47ffffff
[   65.290410] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   65.290488] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[   65.292096] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   65.292126] PCI: setting IRQ 11 as level-triggered
[   65.292135] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
 (level, low) -> IRQ 11
[   65.292215] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[   65.293449] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   65.293474] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[   65.293554] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[   65.294738] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   65.294763] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
 (level, low) -> IRQ 11
[   65.294869] NET: Registered protocol family 2
[   65.326333] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[   65.327804] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[   65.328490] TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
[   65.334646] TCP: Hash tables configured (established 16384 bind 16384)
[   65.334857] TCP reno registered
[   65.343464] checking if image is initramfs... it is
[   65.533312] Freeing initrd memory: 1019k freed
[   65.537373] audit: initializing netlink socket (disabled)
[   65.537557] audit(1195662260.663:1): initialized
[   65.558087] io scheduler noop registered
[   65.558145] io scheduler anticipatory registered
[   65.558164] io scheduler deadline registered
[   65.558735] io scheduler cfq registered (default)
[   65.558838] Activating ISA DMA hang workarounds.
[   65.558871] PCI: Firmware left 0000:00:0a.0 e100 interrupts enabled, dis=
abling
[   65.558935] Boot video device is 0000:01:00.0
[   65.560305] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng 3072k, total 16384k
[   65.560353] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[   65.560374] vesafb: protected mode interface info at c000:775e
[   65.560395] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
 c00c77e2
[   65.560416] vesafb: scrolling: redraw
[   65.560434] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[   65.630275] Console: switching to colour frame buffer device 128x48
[   65.693000] fb0: VESA VGA frame buffer device
[   65.792497] Switched to high resolution mode on CPU 0
[   65.936503] Real Time Clock Driver v1.12ac
[   65.942944] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
 blocksize
[   65.944618] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   65.945430] e100: Copyright(c) 1999-2006 Intel Corporation
[   65.948543] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   65.949446] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
 (level, low) -> IRQ 11
[   65.979507] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr 00=
:00:39:d7:14:a1
[   65.980727] console [netcon0] enabled
[   70.670663] Clocksource tsc unstable (delta =3D 4686935784 ns)
[   70.670751] Time: acpi_pm clocksource has been installed.
[   70.725424] netconsole: network logging started
[   70.753601] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
 irq 1,12
[   70.786689] serio: i8042 KBD port at 0x60,0x64 irq 1
[   70.814090] serio: i8042 AUX port at 0x60,0x64 irq 12
[   70.842317] mice: PS/2 mouse device common for all mice
[   70.869814] cpuidle: using governor ladder
[   70.896153] cpuidle: using governor menu
[   70.922193] TCP cubic registered
[   70.948433] NET: Registered protocol family 1
[   70.973813] Using IPI Shortcut mode
[   70.999664] BIOS EDD facility v0.16 2004-Jun-25, 16 devices found
[   71.029599] Freeing unused kernel memory: 188k freed
[   71.054972] Write protecting the kernel read-only data: 719k
[   71.110708] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   71.186617] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   71.213493] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   71.273244] ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slo=
t 0000:00:04.0
[   71.301801] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   71.330318] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[   71.359082] ALI15X3: not 100% native mode: will probe irqs later
[   71.388129]     ide0: BM-DMA at 0xeff0-0xeff7, BIOS settings: hda:DMA, h=
db:pio
[   71.417395]     ide1: BM-DMA at 0xeff8-0xefff, BIOS settings: hdc:DMA, h=
dd:pio
[   71.445933] Probing IDE interface ide0...
[   72.360494] hda: IC25N020ATDA04-0, ATA DISK drive
[   72.388702] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   72.388939] hda: host side 80-wire cable detection failed, limiting max =
speed to UDMA33
[   72.417680] hda: UDMA 2 mode selected
[   72.418207] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   72.465826] Probing IDE interface ide1...
[   73.806749] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
[   73.835722] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   73.836157] hdc: UDMA 2 mode selected
[   73.836918] ide1 at 0x170-0x177,0x376 on irq 15
[   73.934019] hda: max request size: 128KiB
[   73.962559] hda: 39070080 sectors (20003 MB) w/1806KiB Cache, CHS=3D3876=
0/16/63, UDMA(33)
[   73.991295] hda: cache flushes not supported
[   74.019839]  hda: hda1 hda2
[   74.524795] swsusp: Marking nosave pages: 000000000009f000 - 00000000001=
00000
[   74.524826] swsusp: Basic memory bitmaps created
[   74.561819] swsusp: Basic memory bitmaps freed
[   74.724058] ReiserFS: hda2: found reiserfs format "3.6" with standard jo=
urnal
[   74.750297] ReiserFS: hda2: using ordered data mode
[   74.791369] ReiserFS: hda2: journal params: device hda2, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   74.851103] ReiserFS: hda2: checking transaction log (hda2)
[  114.779022] ReiserFS: hda2: replayed 1435 transactions in 39 seconds
[  114.826881] ReiserFS: hda2: Using r5 hash to sort names
[  124.347318] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[  124.347742] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[  125.150126] Linux agpgart interface v0.102
[  125.781458] agpgart: Detected ALi M1644 chipset
[  125.812519] agpgart: AGP aperture is 64M @ 0xf0000000
[  125.814846] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  125.814914] Yenta: Using CSCINT to route CSC interrupts to PCI
[  125.814922] Yenta: Routing CardBus interrupts to PCI
[  125.814936] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  125.822820] usbcore: registered new interface driver usbfs
[  125.823149] usbcore: registered new interface driver hub
[  125.827226] hdc: ATAPI 24X DVD-ROM drive, 128kB Cache, UDMA(33)
[  125.827257] Uniform CD-ROM driver Revision: 3.20
[  125.850027] usbcore: registered new device driver usb
[  126.019758] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[  126.035809] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[  126.045775] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  126.045792] Socket status: 30000059
[  126.050930] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  126.107096] serial 00:09: activated
[  126.175701] Yenta: ISA IRQ mask 0x0498, PCI irq 11
[  126.175720] Socket status: 30000007
[  126.186038] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  126.312445] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  126.312463] Socket status: 30000087
[  126.327584] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[  126.327608] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[  126.327674] ohci_hcd 0000:00:02.0: OHCI Host Controller
[  126.338590] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 1
[  126.338701] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[  126.395443] usb usb1: configuration #1 chosen from 1 choice
[  126.395808] hub 1-0:1.0: USB hub found
[  126.395940] hub 1-0:1.0: 3 ports detected
[  126.681594] pccard: PCMCIA card inserted into slot 0
[  127.264692] NET: Registered protocol family 23
[  127.415335] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C IrDA chip, pre-configuring device.
[  127.415376] Activated ALi 1533 ISA bridge port 0x02e8.
[  127.415391] Activated ALi 1533 ISA bridge port 0x02f8.
[  127.415602] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
: LPC47N227
[  127.415616] smsc_superio_flat(): IrDA not enabled
[  127.415644] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
, mode: 0x02
[  127.415681] SMsC IrDA Controller found
[  127.415684]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[  127.415897] No transceiver found. Defaulting to Fast pin select
[  127.417800] IrDA: Registered device irda0
[  127.617781] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[  127.617804] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
 (level, low) -> IRQ 11
[  131.120690] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0=
x22f 0x330-0x337 0x388-0x38f
[  131.124686] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0=
x22f 0x330-0x337 0x388-0x38f
[  131.128564] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0=
x22f 0x330-0x337 0x388-0x38f
[  131.131947] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0=
x48f 0x4d0-0x4d7
[  131.133448] cs: IO port probe 0x820-0x8ff: clean.
[  131.134822] cs: IO port probe 0xc00-0xcf7: clean.
[  131.137233] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0=
x48f 0x4d0-0x4d7
[  131.138730] cs: IO port probe 0x820-0x8ff: clean.
[  131.140050] cs: IO port probe 0xc00-0xcf7: clean.
[  131.141613] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0=
x48f 0x4d0-0x4d7
[  131.143114] cs: IO port probe 0x820-0x8ff: clean.
[  131.144498] cs: IO port probe 0xc00-0xcf7: clean.
[  131.148145] cs: IO port probe 0xa00-0xaff: clean.
[  131.150663] cs: IO port probe 0xa00-0xaff: clean.
[  131.152294] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[  131.164365] cs: IO port probe 0xa00-0xaff: clean.
[  131.167010] pcmcia: registering new device pcmcia0.0
[  131.679901] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
 Systems, http://www.agere.com
[  131.679927] *** Modified for kernel 2.6 by Andrey Borzenkov <arvidjaar@m=
ail.ru> $Revision: 39 $
[  131.679936] *** Station Mode (STA) Support: YES
[  131.679941] *** Access Point Mode (AP) Support: YES
[  132.410786] eth1: PRI 31 variant 2 version 9.48
[  132.410855] eth1: NIC 5 variant 2 version 1.02
[  132.443109] eth1: Wireless, io_addr 0x100, irq 11, mac_address 00:02:2D:=
26:95:6C
[  133.470603] Toshiba System Managment Mode driver v1.11 26/9/2001
[  133.555684] Non-volatile memory driver v1.2
[  133.764780] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042=
/serio1/input/input1
[  134.563649] ACPI: AC Adapter [ADP1] (on-line)
[  134.605504] ACPI: Battery Slot [BAT1] (battery present)
[  134.606157] ACPI: Battery Slot [BAT2] (battery absent)
[  134.653633] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input2
[  134.682903] ACPI: Power Button (FF) [PWRF]
[  134.683438] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input3
[  134.696674] ACPI: Lid Switch [LID]
[  134.737572] ACPI: Fan [FAN] (off)
[  134.911281] ACPI: CPU0 (power states: C1[C1] C2[C2])
[  134.963997] ACPI: Thermal Zone [THRM] (44 C)
[  135.185527] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[  135.185546] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[  135.263702] input: Video Bus as /devices/virtual/input/input4
[  135.302665] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[  135.732723] Marking TSC unstable due to: TSC halts in idle.
[  135.791836] device-mapper: uevent: version 1.0.3
[  135.792271] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised:=
 dm-devel@redhat.com
[  136.160257] loop: module loaded
[  137.980925] ReiserFS: hda2: Removing [21277 1340280 0x0 SD]..done
[  137.981559] ReiserFS: hda2: Removing [671391 1340273 0x0 SD]..done
[  137.981983] ReiserFS: hda2: Removing [21277 1340264 0x0 SD]..done
[  137.982099] ReiserFS: hda2: Removing [671391 1340258 0x0 SD]..done
[  137.982289] ReiserFS: hda2: Removing [671391 1340227 0x0 SD]..done
[  137.982504] ReiserFS: hda2: Removing [671391 1340226 0x0 SD]..done
[  137.982674] ReiserFS: hda2: Removing [671391 1340224 0x0 SD]..done
[  137.982845] ReiserFS: hda2: Removing [671391 1340219 0x0 SD]..done
[  137.983015] ReiserFS: hda2: Removing [671391 1336209 0x0 SD]..done
[  137.983186] ReiserFS: hda2: Removing [19391 448635 0x0 SD]..done
[  137.983746] ReiserFS: hda2: There were 10 uncompleted unlinks/truncates.=
 Completed
[  138.596468] Adding 500432k swap on /dev/hda1.  Priority:-1 extents:1 acr=
oss:500432k
[  146.103336] IrCOMM protocol (Dag Brattli)
[  147.430553] PPP generic driver version 2.4.2
[  153.949864] Bluetooth: Core ver 2.11
[  153.950369] NET: Registered protocol family 31
[  153.950377] Bluetooth: HCI device and connection manager initialized
[  153.950747] Bluetooth: HCI socket layer initialized
[  154.597905] Bluetooth: L2CAP ver 2.9
[  154.597942] Bluetooth: L2CAP socket layer initialized
[  155.200108] Bluetooth: RFCOMM socket layer initialized
[  155.201359] Bluetooth: RFCOMM TTY layer initialized
[  155.201378] Bluetooth: RFCOMM ver 1.8
[  155.767149] NET: Registered protocol family 17
[  158.801282] eth1: PRI 31 variant 2 version 9.48
[  158.801374] eth1: NIC 5 variant 2 version 1.02
[  159.944985] eth1: PRI 31 variant 2 version 9.48
[  159.945063] eth1: NIC 5 variant 2 version 1.02
[  160.247216] eth1: PRI 31 variant 2 version 9.48
[  160.247302] eth1: NIC 5 variant 2 version 1.02
[ 1285.626257] swsusp: Marking nosave pages: 000000000009f000 - 00000000001=
00000
[ 1285.626532] swsusp: Basic memory bitmaps created
[ 1285.626661] Syncing filesystems ... done.
[ 1285.639248] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[ 1285.645720] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 1285.646465] Shrinking memory...  =08-=08\=08|=08/=08-=08\=08done (62312 =
pages freed)
[ 1286.879604] Freed 249248 kbytes in 2.18 seconds (114.33 MB/s)
[ 1286.879767] Suspending console(s)
[ 1287.672127] serial 00:09: disabled
[ 1287.675957] ACPI: PCI interrupt for device 0000:00:0a.0 disabled
[ 1287.675977] Trying to free already-free IRQ 11
[ 1287.678607] ACPI: PCI interrupt for device 0000:00:06.0 disabled
[ 1287.679443] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 1287.682301] swsusp: critical section:=20
[ 1287.749809] swsusp: Need to copy 55049 pages
[   74.074852] evxfevnt-0079 [00] enable                : System is already=
 in ACPI mode
[   74.082457] evxfevnt-0079 [00] enable                : System is already=
 in ACPI mode
[   74.090445] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   74.090737] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[   74.090967] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   74.090974] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[   74.091331] PM: Writing back config space on device 0000:00:06.0 at offs=
et 1 (was c2900007, writing c2900003)
[   74.091388] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
 (level, low) -> IRQ 11
[   74.098386] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[   74.098595] PM: Writing back config space on device 0000:00:0a.0 at offs=
et f (was 38080100, writing 3808010b)
[   74.098639] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 6 (was 0, writing f7d00000)
[   74.098655] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 5 (was 1, writing eb41)
[   74.098671] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 4 (was 0, writing f7efd000)
[   74.098686] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 3 (was 0, writing 4008)
[   74.098704] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 1 (was 2900000, writing 2900007)
[   74.098791] PM: Writing back config space on device 0000:00:10.0 at offs=
et f (was 34001ff, writing 5c001ff)
[   74.098842] PM: Writing back config space on device 0000:00:10.0 at offs=
et 4 (was 48101000, writing 48000000)
[   74.098858] PM: Writing back config space on device 0000:00:10.0 at offs=
et 3 (was 24008, writing 2a808)
[   74.107975] PM: Writing back config space on device 0000:00:11.0 at offs=
et f (was 10001ff, writing 58001ff)
[   74.108032] PM: Writing back config space on device 0000:00:11.0 at offs=
et 4 (was 48102000, writing 48001000)
[   74.108048] PM: Writing back config space on device 0000:00:11.0 at offs=
et 3 (was 824000, writing 82a800)
[   74.109100] PM: Writing back config space on device 0000:00:11.1 at offs=
et f (was 10002ff, writing 58002ff)
[   74.109153] PM: Writing back config space on device 0000:00:11.1 at offs=
et 4 (was 48103000, writing 48002000)
[   74.109170] PM: Writing back config space on device 0000:00:11.1 at offs=
et 3 (was 824000, writing 82a800)
[   74.110319] i8042 kbd 00:05: activation failed
[   74.110371] i8042 aux 00:06: activation failed
[   74.119889] serial 00:09: activated
[   74.165992] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   74.166428] hda: UDMA 2 mode selected
[   75.469631] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   75.469739] hdc: UDMA 2 mode selected
[   75.474415] usb usb1: root hub lost power or was reset
[   75.959723] eth1: PRI 31 variant 2 version 9.48
[   75.959784] eth1: NIC 5 variant 2 version 1.02
[   76.073373] Restarting tasks ... done.
[   76.117961] swsusp: Basic memory bitmaps freed
[   76.172914] toshiba_acpi: Re-enabled hotkeys
[   83.243145] eth1: PRI 31 variant 2 version 9.48
[   83.243236] eth1: NIC 5 variant 2 version 1.02
[   83.582774] eth1: PRI 31 variant 2 version 9.48
[   83.582862] eth1: NIC 5 variant 2 version 1.02
[   83.802370] eth1: PRI 31 variant 2 version 9.48
[   83.802457] eth1: NIC 5 variant 2 version 1.02
[  247.921616] swsusp: Marking nosave pages: 000000000009f000 - 00000000001=
00000
[  247.921896] swsusp: Basic memory bitmaps created
[  247.922025] Syncing filesystems ... done.
[  247.934077] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[  247.940444] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  247.941093] Shrinking memory...  =08-=08\=08|=08done (23819 pages freed)
[  248.694352] Freed 95276 kbytes in 1.61 seconds (59.17 MB/s)
[  248.694580] Suspending console(s)
[  249.466308] serial 00:09: disabled
[  249.469926] Trying to free already-free IRQ 11
[  249.471729] ACPI: PCI interrupt for device 0000:00:06.0 disabled
[  249.472450] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[  249.475238] swsusp: critical section:=20
[  249.542538] swsusp: Need to copy 52920 pages
[   73.199821] evxfevnt-0079 [00] enable                : System is already=
 in ACPI mode
[   73.207003] evxfevnt-0079 [00] enable                : System is already=
 in ACPI mode
[   73.216701] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   73.216993] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[   73.217225] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   73.217233] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[   73.217763] PM: Writing back config space on device 0000:00:06.0 at offs=
et 1 (was c2900007, writing c2900003)
[   73.217821] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
 (level, low) -> IRQ 11
[   73.230298] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[   73.230545] PM: Writing back config space on device 0000:00:0a.0 at offs=
et f (was 38080100, writing 3808010b)
[   73.230590] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 6 (was 0, writing f7d00000)
[   73.230605] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 5 (was 1, writing eb41)
[   73.230621] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 4 (was 0, writing f7efd000)
[   73.230636] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 3 (was 0, writing 4008)
[   73.230655] PM: Writing back config space on device 0000:00:0a.0 at offs=
et 1 (was 2900000, writing 2900007)
[   73.230742] PM: Writing back config space on device 0000:00:10.0 at offs=
et f (was 34001ff, writing 5c001ff)
[   73.230794] PM: Writing back config space on device 0000:00:10.0 at offs=
et 4 (was 48101000, writing 48000000)
[   73.230810] PM: Writing back config space on device 0000:00:10.0 at offs=
et 3 (was 24008, writing 2a808)
[   73.239902] PM: Writing back config space on device 0000:00:11.0 at offs=
et f (was 10001ff, writing 58001ff)
[   73.239959] PM: Writing back config space on device 0000:00:11.0 at offs=
et 4 (was 48102000, writing 48001000)
[   73.239976] PM: Writing back config space on device 0000:00:11.0 at offs=
et 3 (was 824000, writing 82a800)
[   73.240885] PM: Writing back config space on device 0000:00:11.1 at offs=
et f (was 10002ff, writing 58002ff)
[   73.240939] PM: Writing back config space on device 0000:00:11.1 at offs=
et 4 (was 48103000, writing 48002000)
[   73.240955] PM: Writing back config space on device 0000:00:11.1 at offs=
et 3 (was 824000, writing 82a800)
[   73.242132] i8042 kbd 00:05: activation failed
[   73.242183] i8042 aux 00:06: activation failed
[   73.251688] serial 00:09: activated
[   73.297820] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   73.298265] hda: UDMA 2 mode selected
[   74.601529] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   74.601643] hdc: UDMA 2 mode selected
[   74.606100] usb usb1: root hub lost power or was reset
[   75.091470] eth1: PRI 31 variant 2 version 9.48
[   75.091529] eth1: NIC 5 variant 2 version 1.02
[   75.200541] Restarting tasks ... done.
[   75.248705] swsusp: Basic memory bitmaps freed
[   75.305131] toshiba_acpi: Re-enabled hotkeys
[   81.841077] eth1: PRI 31 variant 2 version 9.48
[   81.841167] eth1: NIC 5 variant 2 version 1.02
[   82.190235] eth1: PRI 31 variant 2 version 9.48
[   82.190316] eth1: NIC 5 variant 2 version 1.02
[   82.425758] eth1: PRI 31 variant 2 version 9.48
[   82.425849] eth1: NIC 5 variant 2 version 1.02
[ 1153.719591] Syncing filesystems ... done.
[ 1153.744274] Freezing user space processes ... (elapsed 0.48 seconds) don=
e.
[ 1154.229700] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 1154.230394] Suspending console(s)
[ 1155.022732] serial 00:09: disabled
[ 1155.026329] Trying to free already-free IRQ 11
[ 1155.028108] ACPI: PCI interrupt for device 0000:00:06.0 disabled
[ 1155.028823] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 1155.031918]  hwsleep-0317 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[    1.036151] Back to C!
[    1.056122] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.056799] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[    1.056846] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 500001ff, writing 5000010b)
[    1.057047] ACPI: Unable to derive IRQ for device 0000:00:04.0
[    1.057054] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[    1.057519] PM: Writing back config space on device 0000:00:06.0 at offs=
et f (was 180201ff, writing 1802010b)
[    1.057580] PM: Writing back config space on device 0000:00:06.0 at offs=
et 1 (was 2900003, writing c2900003)
[    1.057634] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
 (level, low) -> IRQ 11
[    1.066826] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[    1.067196] PM: Writing back config space on device 0000:00:0a.0 at offs=
et f (was 380801ff, writing 3808010b)
[    1.067363] PM: Writing back config space on device 0000:00:10.0 at offs=
et 6 (was 50200, writing b0050200)
[    1.098450] PM: Writing back config space on device 0000:00:12.0 at offs=
et f (was 1ff, writing 10b)
[    1.098556] PM: Writing back config space on device 0000:01:00.0 at offs=
et f (was 1ff, writing 10b)
[    1.098734] i8042 kbd 00:05: activation failed
[    1.098784] i8042 aux 00:06: activation failed
[    1.108267] serial 00:09: activated
[    1.627444] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    1.636972] hda: UDMA 2 mode selected
[    1.646793] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    1.677965] hdc: UDMA 2 mode selected
[    1.680982] usb usb1: root hub lost power or was reset
[    2.166441] eth1: PRI 31 variant 2 version 9.48
[    2.166501] eth1: NIC 5 variant 2 version 1.02
[    2.171800] Restarting tasks ... done.
[    7.929022] eth1: PRI 31 variant 2 version 9.48
[    7.929114] eth1: NIC 5 variant 2 version 1.02
[    8.208428] eth1: PRI 31 variant 2 version 9.48
[    8.208516] eth1: NIC 5 variant 2 version 1.02
[    8.447269] eth1: PRI 31 variant 2 version 9.48
[    8.447360] eth1: NIC 5 variant 2 version 1.02
[ 2350.172266] Syncing filesystems ... done.
[ 2350.184788] Freezing user space processes ... (elapsed 0.10 seconds) don=
e.
[ 2350.291579] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[ 2350.292207] Suspending console(s)
[ 2351.089368] serial 00:09: disabled
[ 2351.092976] Trying to free already-free IRQ 11
[ 2351.094756] ACPI: PCI interrupt for device 0000:00:06.0 disabled
[ 2351.095476] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 2351.098537]  hwsleep-0317 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[    0.933942] Back to C!
[    0.951642] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.952117] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[    0.952164] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 500001ff, writing 5000010b)
[    0.952366] ACPI: Unable to derive IRQ for device 0000:00:04.0
[    0.952374] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[    0.953036] PM: Writing back config space on device 0000:00:06.0 at offs=
et f (was 180201ff, writing 1802010b)
[    0.953139] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
 (level, low) -> IRQ 11
[    0.962101] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[    0.962283] PM: Writing back config space on device 0000:00:0a.0 at offs=
et f (was 380801ff, writing 3808010b)
[    0.962450] PM: Writing back config space on device 0000:00:10.0 at offs=
et 6 (was 50200, writing b0050200)
[    1.059836] PM: Writing back config space on device 0000:00:12.0 at offs=
et f (was 1ff, writing 10b)
[    1.059942] PM: Writing back config space on device 0000:01:00.0 at offs=
et f (was 1ff, writing 10b)
[    1.060121] i8042 kbd 00:05: activation failed
[    1.060170] i8042 aux 00:06: activation failed
[    1.073993] serial 00:09: activated
[    1.346131] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    1.355276] hda: UDMA 2 mode selected
[    1.365868] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    1.406986] hdc: UDMA 2 mode selected
[    1.410005] usb usb1: root hub lost power or was reset
[    1.898840] eth1: PRI 31 variant 2 version 9.48
[    1.898901] eth1: NIC 5 variant 2 version 1.02
[    1.906448] Restarting tasks ... done.
[    6.768919] eth1: PRI 31 variant 2 version 9.48
[    6.769007] eth1: NIC 5 variant 2 version 1.02
[    7.191614] eth1: PRI 31 variant 2 version 9.48
[    7.191701] eth1: NIC 5 variant 2 version 1.02
[    7.441187] eth1: PRI 31 variant 2 version 9.48
[    7.441276] eth1: NIC 5 variant 2 version 1.02

--nextPart2470014.PoRkmeGDfM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHSItWR6LMutpd94wRAgaOAKCgWpR7r2WHJq9qu7LePe1XRiWP/wCggz1I
xGsUfttH4Mxcv+9dVkTvNqI=
=cMS+
-----END PGP SIGNATURE-----

--nextPart2470014.PoRkmeGDfM--
