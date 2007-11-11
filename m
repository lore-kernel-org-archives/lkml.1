Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbXKKKba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbXKKKba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 05:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbXKKKbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 05:31:18 -0500
Received: from mx27.mail.ru ([194.67.23.23]:7939 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753063AbXKKKbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 05:31:10 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Date: Sun, 11 Nov 2007 13:30:59 +0300
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200711052201.17150.arvidjaar@mail.ru>
In-Reply-To: <200711052201.17150.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1477510.IZ4lJEI4s0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711111331.00826.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1477510.IZ4lJEI4s0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 05 November 2007, Andrey Borzenkov wrote:
> Notice "hung" not "hangs". This happened so far only once - when low batt=
ery=20
> condition triggered suspend to disk. I was not able to reproduce it after=
=20
> this running on AC.
>=20
> Just in case it rings the bell for someone. This is not suspend regressio=
n=20
> reported earlier by Jens - I do not even have SATA nor is using libata=20
> drivers.
>=20

This happened second time, now with 2.6.24-rc2. I have kpowersave configured
to initiate suspend-to-disk on low battery. Suspend-to-disk is initiated,
but system stops after Suspending console line. Suspend image is not create=
d.

This did work before although I do not name exact version.

I am rather at loss how to proceed further ... any idea? dmesg and config
attached just in case. The problem is that hibernation works when I initiate
it manually ...

[    0.000000] Linux version 2.6.24-rc2-2avb (bor@cooker) (gcc version 4.2.=
2 20070909 (prerelease) (4.2.2-0.RC.1mdv2008.0)) #6 Wed Nov 7 08:20:45 MSK =
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
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.24-rc2-2avb root=3DLAB=
EL=3D/ resume=3DLABEL=3Dswap vga=3D791
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 747.687 MHz processor.
[   59.604186] Console: colour dummy device 80x25
[   59.604207] console [tty0] enabled
[   59.606364] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[   59.606389] ... MAX_LOCKDEP_SUBCLASSES:    8
[   59.606404] ... MAX_LOCK_DEPTH:          30
[   59.606419] ... MAX_LOCKDEP_KEYS:        2048
[   59.606434] ... CLASSHASH_SIZE:           1024
[   59.606449] ... MAX_LOCKDEP_ENTRIES:     8192
[   59.606464] ... MAX_LOCKDEP_CHAINS:      16384
[   59.606479] ... CHAINHASH_SIZE:          8192
[   59.606494]  memory used by lock dependency info: 1024 kB
[   59.606512]  per task-struct memory footprint: 1680 bytes
[   59.606529] ------------------------
[   59.606542] | Locking API testsuite:
[   59.606557] ------------------------------------------------------------=
=2D---------------
[   59.606583]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[   59.606609]   ----------------------------------------------------------=
=2D---------------
[   59.606655]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.609128]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.611333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.613579]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.615823]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.618130]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.620435]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.622754]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.624888]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.627009]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[   59.629198]   ----------------------------------------------------------=
=2D---------------
[   59.629226]               recursive read-lock:             |  ok  |     =
        |  ok  |
[   59.629956]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[   59.630686]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[   59.631422]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[   59.632157]   ----------------------------------------------------------=
=2D---------------
[   59.632184]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   59.633265]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[   59.634351]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   59.635428]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[   59.636505]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[   59.637585]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[   59.638663]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   59.639740]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[   59.640823]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   59.641900]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[   59.642982]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   59.644091]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[   59.645199]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   59.646305]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[   59.647409]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   59.648512]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[   59.649617]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   59.650716]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[   59.651820]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   59.652906]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[   59.653996]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   59.655095]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[   59.656198]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   59.657304]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[   59.658417]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   59.659521]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[   59.660633]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   59.661737]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[   59.662843]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   59.663943]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[   59.665048]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   59.666150]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[   59.667261]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   59.668361]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[   59.669467]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   59.670572]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[   59.671683]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   59.672786]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[   59.673897]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   59.675003]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[   59.676112]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   59.677218]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[   59.678325]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   59.679429]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[   59.680540]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   59.681644]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[   59.682752]       hard-irq read-recursion/123:  ok  |
[   59.683135]       soft-irq read-recursion/123:  ok  |
[   59.683519]       hard-irq read-recursion/132:  ok  |
[   59.683901]       soft-irq read-recursion/132:  ok  |
[   59.684281]       hard-irq read-recursion/213:  ok  |
[   59.684661]       soft-irq read-recursion/213:  ok  |
[   59.685044]       hard-irq read-recursion/231:  ok  |
[   59.685424]       soft-irq read-recursion/231:  ok  |
[   59.685805]       hard-irq read-recursion/312:  ok  |
[   59.686184]       soft-irq read-recursion/312:  ok  |
[   59.686566]       hard-irq read-recursion/321:  ok  |
[   59.686946]       soft-irq read-recursion/321:  ok  |
[   59.687329] -------------------------------------------------------
[   59.687350] Good, all 218 testcases passed! |
[   59.687366] ---------------------------------
[   59.688975] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[   59.691054] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[   59.775709] Memory: 495640k/507264k available (1874k kernel code, 11016k=
 reserved, 887k data, 188k init, 0k highmem)
[   59.775786] virtual kernel memory layout:
[   59.775790]     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
[   59.775794]     vmalloc : 0xdf800000 - 0xffff4000   ( 519 MB)
[   59.775798]     lowmem  : 0xc0000000 - 0xdef60000   ( 495 MB)
[   59.775802]       .init : 0xc03b6000 - 0xc03e5000   ( 188 kB)
[   59.775806]       .data : 0xc02d49c9 - 0xc03b2964   ( 887 kB)
[   59.775810]       .text : 0xc0100000 - 0xc02d49c9   (1874 kB)
[   59.775900] Checking if this processor honours the WP bit even in superv=
isor mode... Ok.
[   59.776150] SLUB: Genslabs=3D11, HWalign=3D32, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1, Nodes=3D1
[   59.859553] Calibrating delay using timer specific routine.. 1498.35 Bog=
oMIPS (lpj=3D2496563)
[   59.859753] Mount-cache hash table entries: 512
[   59.860734] CPU: After generic identify, caps: 0387f9ff 00000000 0000000=
0 00000000 00000000 00000000 00000000 00000000
[   59.860772] CPU: L1 I cache: 16K, L1 D cache: 16K
[   59.860801] CPU: L2 cache: 256K
[   59.860816] CPU serial number disabled.
[   59.860834] CPU: After all inits, caps: 0383f9ff 00000000 00000000 00000=
040 00000000 00000000 00000000 00000000
[   59.860871] Compat vDSO mapped to ffffe000.
[   59.860927] CPU: Intel Pentium III (Coppermine) stepping 0a
[   59.860959] Checking 'hlt' instruction... OK.
[   59.873632] Freeing SMP alternatives: 0k freed
[   59.874322] Early unpacking initramfs... done
[   59.973268] ACPI: Core revision 20070126
[   59.973957] ACPI: Looking for DSDT in initramfs... error, file /DSDT.aml=
 not found.
[   59.984047] Parsing all Control Methods:
[   59.984389] Table [DSDT](id 0001) - 683 Objects with 60 Devices 195 Meth=
ods 10 Regions
[   59.984431]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[   59.984470] ACPI: setting ELCR to 0200 (from 0a00)
[   59.985031] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[   59.987576] net_namespace: 80 bytes
[   59.990834] NET: Registered protocol family 16
[   59.992552] ACPI: bus type pci registered
[   59.994666] PCI: PCI BIOS revision 2.10 entry at 0xfe5ae, last bus=3D5
[   59.994712] PCI: Using configuration type 1
[   59.994728] Setting up standard PCI resources
[   60.007802] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 3F [_GP=
E] 8 regs on int 0x9
[   60.009977] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Ena=
bled 0 Runtime GPEs in this block
[   60.010028] ACPI: EC: Look up EC in DSDT
[   60.017890] Completing Region/Field/Buffer/Package initialization:......=
=2E..............................
[   60.020613] Initialized 5/10 Regions 0/0 Fields 16/16 Buffers 16/27 Pack=
ages (692 nodes)
[   60.020646] Initializing Device/Processor/Thermal objects by executing _=
INI methods:.
[   60.024161] Executed 1 _INI methods requiring 0 _STA executions (examine=
d 64 objects)
[   60.024251] ACPI: Interpreter enabled
[   60.024270] ACPI: (supports S0 S3 S4 S5)
[   60.024414] ACPI: Using PIC for interrupt routing
[   60.056779] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   60.058426] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
[   60.058461] PCI quirk: region ef00-ef1f claimed by ali7101 SMB
[   60.060816] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   60.061389] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[   60.088831] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
[   60.089678] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
[   60.090406] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
[   60.091126] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
[   60.091842] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
[   60.092560] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
[   60.094006] ACPI: Power Resource [PFAN] (off)
[   60.094402] Linux Plug and Play Support v0.97 (c) Adam Belay
[   60.094682] pnp: PnP ACPI init
[   60.094831] ACPI: bus type pnp registered
[   60.118694] pnp: PnP ACPI: found 12 devices
[   60.118750] ACPI: ACPI bus type pnp unregistered
[   60.119917] PCI: Using ACPI for IRQ routing
[   60.119958] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[   60.146097] Time: tsc clocksource has been installed.
[   60.153098] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[   60.153133] system 00:00: iomem range 0xe0000-0xeffff could not be reser=
ved
[   60.153160] system 00:00: iomem range 0xf0000-0xfffff could not be reser=
ved
[   60.153187] system 00:00: iomem range 0x100000-0x1ef5ffff could not be r=
eserved
[   60.186890] PCI: Bridge: 0000:00:01.0
[   60.186932]   IO window: disabled.
[   60.186959]   MEM window: f7f00000-fdffffff
[   60.186982]   PREFETCH window: disabled.
[   60.187010] PCI: Bus 2, cardbus bridge: 0000:00:10.0
[   60.187028]   IO window: 00001000-000010ff
[   60.187051]   IO window: 00001400-000014ff
[   60.187073]   PREFETCH window: 30000000-33ffffff
[   60.187097]   MEM window: 34000000-37ffffff
[   60.187119] PCI: Bus 6, cardbus bridge: 0000:00:11.0
[   60.187136]   IO window: 00001800-000018ff
[   60.187158]   IO window: 00001c00-00001cff
[   60.187181]   PREFETCH window: 38000000-3bffffff
[   60.187204]   MEM window: 3c000000-3fffffff
[   60.187228] PCI: Bus 10, cardbus bridge: 0000:00:11.1
[   60.187245]   IO window: 00002000-000020ff
[   60.187267]   IO window: 00002400-000024ff
[   60.187290]   PREFETCH window: 40000000-43ffffff
[   60.187313]   MEM window: 44000000-47ffffff
[   60.187364] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   60.187447] PCI: Enabling device 0000:00:10.0 (0000 -> 0003)
[   60.189068] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   60.189100] PCI: setting IRQ 11 as level-triggered
[   60.189110] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI 11=
 (level, low) -> IRQ 11
[   60.189191] PCI: Enabling device 0000:00:11.0 (0000 -> 0003)
[   60.190423] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[   60.190449] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[   60.190527] PCI: Enabling device 0000:00:11.1 (0000 -> 0003)
[   60.191707] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   60.191731] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11=
 (level, low) -> IRQ 11
[   60.191839] NET: Registered protocol family 2
[   60.223167] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[   60.224753] TCP established hash table entries: 16384 (order: 7, 589824 =
bytes)
[   60.231065] TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
[   60.237340] TCP: Hash tables configured (established 16384 bind 16384)
[   60.237557] TCP reno registered
[   60.247001] checking if image is initramfs... it is
[   60.436269] Freeing initrd memory: 1019k freed
[   60.440363] audit: initializing netlink socket (disabled)
[   60.440552] audit(1194776297.666:1): initialized
[   60.460963] io scheduler noop registered
[   60.461025] io scheduler anticipatory registered
[   60.461043] io scheduler deadline registered
[   60.461627] io scheduler cfq registered (default)
[   60.461744] Activating ISA DMA hang workarounds.
[   60.461778] PCI: Firmware left 0000:00:0a.0 e100 interrupts enabled, dis=
abling
[   60.461844] Boot video device is 0000:01:00.0
[   60.463251] vesafb: framebuffer at 0xfc000000, mapped to 0xdf880000, usi=
ng 3072k, total 16384k
[   60.463305] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D9
[   60.463326] vesafb: protected mode interface info at c000:775e
[   60.463346] vesafb: pmi: set display start =3D c00c777f, set palette =3D=
 c00c77e2
[   60.463368] vesafb: scrolling: redraw
[   60.463387] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[   60.533277] Console: switching to colour frame buffer device 128x48
[   60.596021] fb0: VESA VGA frame buffer device
[   60.689318] Switched to high resolution mode on CPU 0
[   60.833105] Real Time Clock Driver v1.12ac
[   60.839648] RAMDISK driver initialized: 16 RAM disks of 32000K size 1024=
 blocksize
[   60.841292] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   60.842106] e100: Copyright(c) 1999-2006 Intel Corporation
[   60.845271] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   60.846177] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11=
 (level, low) -> IRQ 11
[   60.876360] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr 00=
:00:39:d7:14:a1
[   60.877589] console [netcon0] enabled
[   65.595651] Clocksource tsc unstable (delta =3D 4686895377 ns)
[   65.623080] Time: acpi_pm clocksource has been installed.
[   65.650476] netconsole: network logging started
[   65.678699] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64=
 irq 1,12
[   65.711589] serio: i8042 KBD port at 0x60,0x64 irq 1
[   65.739068] serio: i8042 AUX port at 0x60,0x64 irq 12
[   65.767472] mice: PS/2 mouse device common for all mice
[   65.794852] cpuidle: using governor ladder
[   65.821205] cpuidle: using governor menu
[   65.847272] TCP cubic registered
[   65.873536] NET: Registered protocol family 1
[   65.898946] Using IPI Shortcut mode
[   65.924961] BIOS EDD facility v0.16 2004-Jun-25, 16 devices found
[   65.957280] Freeing unused kernel memory: 188k freed
[   65.982661] Write protecting the kernel read-only data: 719k
[   66.014031] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[   66.113581] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   66.140106] ide: Assuming 33MHz system bus speed for PIO modes; override=
 with idebus=3Dxx
[   66.199358] ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slo=
t 0000:00:04.0
[   66.227541] ACPI: Unable to derive IRQ for device 0000:00:04.0
[   66.255645] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
[   66.283968] ALI15X3: not 100% native mode: will probe irqs later
[   66.312607]     ide0: BM-DMA at 0xeff0-0xeff7, BIOS settings: hda:DMA, h=
db:pio
[   66.341480]     ide1: BM-DMA at 0xeff8-0xefff, BIOS settings: hdc:DMA, h=
dd:pio
[   66.369629] Probing IDE interface ide0...
[   67.284016] hda: IC25N020ATDA04-0, ATA DISK drive
[   67.311898] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   67.312138] hda: host side 80-wire cable detection failed, limiting max =
speed to UDMA33
[   67.340493] hda: UDMA 2 mode selected
[   67.341027] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   67.387166] Probing IDE interface ide1...
[   68.726935] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
[   68.755543] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   68.755963] hdc: UDMA 2 mode selected
[   68.756773] ide1 at 0x170-0x177,0x376 on irq 15
[   68.852771] hda: max request size: 128KiB
[   68.880966] hda: 39070080 sectors (20003 MB) w/1806KiB Cache, CHS=3D3876=
0/16/63, UDMA(33)
[   68.909323] hda: cache flushes not supported
[   68.937493]  hda: hda1 hda2
[   69.452756] swsusp: Marking nosave pages: 000000000009f000 - 00000000001=
00000
[   69.452784] swsusp: Basic memory bitmaps created
[   69.489501] swsusp: Basic memory bitmaps freed
[   69.649247] ReiserFS: hda2: found reiserfs format "3.6" with standard jo=
urnal
[   69.675083] ReiserFS: hda2: using ordered data mode
[   69.716775] ReiserFS: hda2: journal params: device hda2, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   69.776637] ReiserFS: hda2: checking transaction log (hda2)
[  125.120993] ReiserFS: hda2: replayed 665 transactions in 55 seconds
[  125.605649] ReiserFS: hda2: Using r5 hash to sort names
[  135.479478] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[  135.479917] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)
[  135.625095] hdc: ATAPI 24X DVD-ROM drive, 128kB Cache, UDMA(33)
[  135.625134] Uniform CD-ROM driver Revision: 3.20
[  135.952133] Linux agpgart interface v0.102
[  136.784300] Yenta: CardBus bridge found at 0000:00:10.0 [12a3:ab01]
[  136.784369] Yenta: Enabling burst memory read transactions
[  136.784384] Yenta: Using CSCINT to route CSC interrupts to PCI
[  136.784391] Yenta: Routing CardBus interrupts to PCI
[  136.784405] Yenta TI: socket 0000:00:10.0, mfunc 0x01000002, devctl 0x60
[  137.014787] Yenta: ISA IRQ mask 0x0000, PCI irq 11
[  137.014806] Socket status: 30000011
[  137.015881] Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
[  137.082662] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sha=
ring enabled
[  137.141427] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  137.141444] Socket status: 30000007
[  137.144946] Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
[  137.271481] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[  137.271498] Socket status: 30000007
[  137.276826] agpgart: Detected ALi M1644 chipset
[  137.290770] agpgart: AGP aperture is 64M @ 0xf0000000
[  137.349411] serial 00:09: activated
[  137.647284] pccard: PCMCIA card inserted into slot 0
[  137.899316] usbcore: registered new interface driver usbfs
[  137.899652] usbcore: registered new interface driver hub
[  137.903505] usbcore: registered new device driver usb
[  138.063885] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I) Driver
[  138.068150] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
[  138.068172] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11=
 (level, low) -> IRQ 11
[  138.068242] ohci_hcd 0000:00:02.0: OHCI Host Controller
[  138.070798] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus =
number 1
[  138.070887] ohci_hcd 0000:00:02.0: irq 11, io mem 0xf7eff000
[  138.127451] usb usb1: configuration #1 chosen from 1 choice
[  138.128300] hub 1-0:1.0: USB hub found
[  138.128446] hub 1-0:1.0: 3 ports detected
[  138.684252] NET: Registered protocol family 23
[  138.939362] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
[  138.939385] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11=
 (level, low) -> IRQ 11
[  138.964168] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C IrDA chip, pre-configuring device.
[  138.964208] Activated ALi 1533 ISA bridge port 0x02e8.
[  138.964223] Activated ALi 1533 ISA bridge port 0x02f8.
[  138.964431] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
: LPC47N227
[  138.964444] smsc_superio_flat(): IrDA not enabled
[  138.964471] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
, mode: 0x02
[  138.964510] SMsC IrDA Controller found
[  138.964513]  IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3D3, irq=
=3D7
[  138.964738] No transceiver found. Defaulting to Fast pin select
[  138.966650] IrDA: Registered device irda0
[  141.119155] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0=
x22f 0x330-0x337 0x388-0x38f
[  141.122507] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0=
x48f 0x4d0-0x4d7
[  141.124311] cs: IO port probe 0x820-0x8ff: clean.
[  141.125624] cs: IO port probe 0xc00-0xcf7: clean.
[  141.127975] cs: IO port probe 0xa00-0xaff: clean.
[  141.529162] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0=
x22f 0x330-0x337 0x388-0x38f
[  141.532501] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0=
x48f 0x4d0-0x4d7
[  141.534038] cs: IO port probe 0x820-0x8ff: clean.
[  141.535351] cs: IO port probe 0xc00-0xcf7: clean.
[  141.537777] cs: IO port probe 0xa00-0xaff: clean.
[  141.539544] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[  141.552093] pcmcia: registering new device pcmcia0.0
[  141.568299] cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0=
x22f 0x330-0x337 0x388-0x38f
[  141.571609] cs: IO port probe 0x3e0-0x4ff: excluding 0x408-0x40f 0x480-0=
x48f 0x4d0-0x4d7
[  141.573135] cs: IO port probe 0x820-0x8ff: clean.
[  141.574433] cs: IO port probe 0xc00-0xcf7: clean.
[  141.576812] cs: IO port probe 0xa00-0xaff: clean.
[  142.274634] wlags49_h1_cs v7.18 for PCMCIA, 03/31/2004 14:31:00 by Agere=
 Systems, http://www.agere.com
[  142.274654] *** Modified for kernel 2.6 by Andrey Borzenkov <arvidjaar@m=
ail.ru> $Revision: 39 $
[  142.274662] *** Station Mode (STA) Support: YES
[  142.274668] *** Access Point Mode (AP) Support: YES
[  143.293647] eth1: PRI 31 variant 2 version 9.48
[  143.293715] eth1: NIC 5 variant 2 version 1.02
[  143.317120] eth1: Wireless, io_addr 0x100, irq 11, mac_address 00:02:2D:=
26:95:6C
[  144.472665] Toshiba System Managment Mode driver v1.11 26/9/2001
[  144.589404] Non-volatile memory driver v1.2
[  144.753440] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042=
/serio1/input/input1
[  145.557659] ACPI: AC Adapter [ADP1] (on-line)
[  145.624438] ACPI: Battery Slot [BAT1] (battery present)
[  145.625080] ACPI: Battery Slot [BAT2] (battery absent)
[  145.686177] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input2
[  145.708670] ACPI: Power Button (FF) [PWRF]
[  145.709243] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input3
[  145.722283] ACPI: Lid Switch [LID]
[  145.759309] ACPI: Fan [FAN] (off)
[  145.981997] ACPI: CPU0 (power states: C1[C1] C2[C2])
[  146.103663] ACPI: Thermal Zone [THRM] (54 C)
[  146.254531] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
[  146.254550] toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
[  146.362058] input: Video Bus as /devices/virtual/input/input4
[  146.388316] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: n=
o)
[  146.771274] Marking TSC unstable due to: TSC halts in idle.
[  146.843352] device-mapper: uevent: version 1.0.3
[  146.843783] device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised:=
 dm-devel@redhat.com
[  147.211921] loop: module loaded
[  149.035580] ReiserFS: hda2: Removing [671391 1799323 0x0 SD]..done
[  149.036411] ReiserFS: hda2: Removing [671391 1799322 0x0 SD]..done
[  149.036674] ReiserFS: hda2: Removing [21277 1799317 0x0 SD]..done
[  149.036823] ReiserFS: hda2: Removing [671391 1799316 0x0 SD]..done
[  149.036955] ReiserFS: hda2: Removing [21277 1799301 0x0 SD]..done
[  149.037072] ReiserFS: hda2: Removing [21277 1799299 0x0 SD]..done
[  149.037198] ReiserFS: hda2: Removing [671391 1799283 0x0 SD]..done
[  149.038443] ReiserFS: hda2: Removing [671391 1799272 0x0 SD]..done
[  149.038576] ReiserFS: hda2: Removing [671391 1799271 0x0 SD]..done
[  149.038799] ReiserFS: hda2: Removing [21277 1799257 0x0 SD]..done
[  149.038917] ReiserFS: hda2: Removing [21277 1799239 0x0 SD]..done
[  149.039034] ReiserFS: hda2: Removing [21277 1799227 0x0 SD]..done
[  149.039149] ReiserFS: hda2: Removing [21277 1799216 0x0 SD]..done
[  149.039264] ReiserFS: hda2: Removing [21277 1799204 0x0 SD]..done
[  149.039387] ReiserFS: hda2: Removing [671391 1799202 0x0 SD]..done
[  149.039597] ReiserFS: hda2: Removing [671391 1799197 0x0 SD]..done
[  149.039721] ReiserFS: hda2: Removing [671391 1799187 0x0 SD]..done
[  149.039964] ReiserFS: hda2: Removing [671391 1799179 0x0 SD]..done
[  149.040203] ReiserFS: hda2: Removing [671391 1799169 0x0 SD]..done
[  149.040441] ReiserFS: hda2: Removing [671391 1799150 0x0 SD]..done
[  149.040674] ReiserFS: hda2: Removing [671391 1799149 0x0 SD]..done
[  149.040867] ReiserFS: hda2: Removing [671391 1799138 0x0 SD]..done
[  149.041041] ReiserFS: hda2: Removing [671391 1799131 0x0 SD]..done
[  149.041274] ReiserFS: hda2: Removing [671391 1799130 0x0 SD]..done
[  149.041494] ReiserFS: hda2: Removing [671391 1799104 0x0 SD]..done
[  149.041685] ReiserFS: hda2: Removing [671391 1799088 0x0 SD]..done
[  149.041909] ReiserFS: hda2: Removing [671391 1799081 0x0 SD]..done
[  149.042129] ReiserFS: hda2: Removing [671391 1799068 0x0 SD]..done
[  149.042284] ReiserFS: hda2: Removing [21277 1799051 0x0 SD]..done
[  149.042406] ReiserFS: hda2: Removing [671391 1799004 0x0 SD]..done
[  149.042602] ReiserFS: hda2: Removing [671391 1798888 0x0 SD]..done
[  149.042728] ReiserFS: hda2: Removing [21277 1798869 0x0 SD]..done
[  149.042841] ReiserFS: hda2: Removing [21277 1798867 0x0 SD]..done
[  149.042954] ReiserFS: hda2: Removing [21277 1798866 0x0 SD]..done
[  149.043066] ReiserFS: hda2: Removing [671391 1798865 0x0 SD]..done
[  149.043212] ReiserFS: hda2: Removing [21277 1798184 0x0 SD]..done
[  149.043325] ReiserFS: hda2: Removing [21277 1797848 0x0 SD]..done
[  149.043443] ReiserFS: hda2: Removing [671391 1793929 0x0 SD]..done
[  149.043618] ReiserFS: hda2: Removing [671391 1793905 0x0 SD]..done
[  149.043759] ReiserFS: hda2: Removing [671391 1793891 0x0 SD]..done
[  149.044078] ReiserFS: hda2: Removing [671391 1793846 0x0 SD]..done
[  149.044273] ReiserFS: hda2: Removing [671391 1793837 0x0 SD]..done
[  149.044522] ReiserFS: hda2: Removing [671391 1793730 0x0 SD]..done
[  149.044730] ReiserFS: hda2: Removing [671391 1773059 0x0 SD]..done
[  149.044894] ReiserFS: hda2: Removing [671391 1494144 0x0 SD]..done
[  149.045109] ReiserFS: hda2: Removing [671391 1494025 0x0 SD]..done
[  149.046495] ReiserFS: hda2: Removing [671391 1395299 0x0 SD]..done
[  149.047091] ReiserFS: hda2: Removing [671391 1389886 0x0 SD]..done
[  149.047356] ReiserFS: hda2: Removing [671391 1376501 0x0 SD]..done
[  149.047521] ReiserFS: hda2: Removing [671391 1376497 0x0 SD]..done
[  149.047720] ReiserFS: hda2: Removing [671391 1376496 0x0 SD]..done
[  149.047908] ReiserFS: hda2: Removing [671391 1376494 0x0 SD]..done
[  149.048120] ReiserFS: hda2: Removing [671391 1376491 0x0 SD]..done
[  149.048288] ReiserFS: hda2: Removing [671391 1376481 0x0 SD]..done
[  149.048453] ReiserFS: hda2: Removing [671391 1376430 0x0 SD]..done
[  149.048618] ReiserFS: hda2: Removing [671391 1376428 0x0 SD]..done
[  149.048813] ReiserFS: hda2: Removing [671391 1376425 0x0 SD]..done
[  149.049554] ReiserFS: hda2: Removing [671391 847727 0x0 SD]..done
[  149.049782] ReiserFS: hda2: Removing [671391 447114 0x0 SD]..done
[  149.050053] ReiserFS: hda2: Removing [160679 396515 0x0 SD]..done
[  149.050510] ReiserFS: hda2: There were 60 uncompleted unlinks/truncates.=
 Completed
[  149.673893] Adding 500432k swap on /dev/hda1.  Priority:-1 extents:1 acr=
oss:500432k
[  157.146275] IrCOMM protocol (Dag Brattli)
[  159.610081] PPP generic driver version 2.4.2
[  165.481163] Bluetooth: Core ver 2.11
[  165.481747] NET: Registered protocol family 31
[  165.481755] Bluetooth: HCI device and connection manager initialized
[  165.482140] Bluetooth: HCI socket layer initialized
[  165.786997] Bluetooth: L2CAP ver 2.9
[  165.787022] Bluetooth: L2CAP socket layer initialized
[  166.302068] Bluetooth: RFCOMM socket layer initialized
[  166.303217] Bluetooth: RFCOMM TTY layer initialized
[  166.303235] Bluetooth: RFCOMM ver 1.8
[  166.966600] NET: Registered protocol family 17
[  169.889228] eth1: PRI 31 variant 2 version 9.48
[  169.889321] eth1: NIC 5 variant 2 version 1.02
[  170.822534] eth1: PRI 31 variant 2 version 9.48
[  170.822615] eth1: NIC 5 variant 2 version 1.02
[  171.114717] eth1: PRI 31 variant 2 version 9.48
[  171.114804] eth1: NIC 5 variant 2 version 1.02


#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc2
# Wed Nov  7 07:11:36 2007
#
CONFIG_X86_32=3Dy
CONFIG_GENERIC_TIME=3Dy
CONFIG_GENERIC_CMOS_UPDATE=3Dy
CONFIG_CLOCKSOURCE_WATCHDOG=3Dy
CONFIG_GENERIC_CLOCKEVENTS=3Dy
CONFIG_LOCKDEP_SUPPORT=3Dy
CONFIG_STACKTRACE_SUPPORT=3Dy
CONFIG_SEMAPHORE_SLEEPERS=3Dy
CONFIG_X86=3Dy
CONFIG_MMU=3Dy
CONFIG_ZONE_DMA=3Dy
CONFIG_QUICKLIST=3Dy
CONFIG_GENERIC_ISA_DMA=3Dy
CONFIG_GENERIC_IOMAP=3Dy
CONFIG_GENERIC_BUG=3Dy
CONFIG_GENERIC_HWEIGHT=3Dy
CONFIG_ARCH_MAY_HAVE_PC_FDC=3Dy
CONFIG_DMI=3Dy
CONFIG_DEFCONFIG_LIST=3D"/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=3Dy
CONFIG_BROKEN_ON_SMP=3Dy
CONFIG_INIT_ENV_ARG_LIMIT=3D32
CONFIG_LOCALVERSION=3D""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=3Dy
CONFIG_SYSVIPC=3Dy
CONFIG_SYSVIPC_SYSCTL=3Dy
CONFIG_POSIX_MQUEUE=3Dy
CONFIG_BSD_PROCESS_ACCT=3Dy
CONFIG_BSD_PROCESS_ACCT_V3=3Dy
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
CONFIG_AUDIT=3Dy
CONFIG_AUDITSYSCALL=3Dy
CONFIG_AUDIT_TREE=3Dy
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=3D17
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=3Dy
CONFIG_FAIR_USER_SCHED=3Dy
# CONFIG_FAIR_CGROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=3Dy
CONFIG_BLK_DEV_INITRD=3Dy
CONFIG_INITRAMFS_SOURCE=3D""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=3Dy
CONFIG_EMBEDDED=3Dy
# CONFIG_UID16 is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=3Dy
CONFIG_KALLSYMS_ALL=3Dy
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=3Dy
CONFIG_PRINTK=3Dy
CONFIG_BUG=3Dy
CONFIG_ELF_CORE=3Dy
CONFIG_BASE_FULL=3Dy
CONFIG_FUTEX=3Dy
CONFIG_ANON_INODES=3Dy
CONFIG_EPOLL=3Dy
CONFIG_SIGNALFD=3Dy
CONFIG_EVENTFD=3Dy
CONFIG_SHMEM=3Dy
CONFIG_VM_EVENT_COUNTERS=3Dy
CONFIG_SLUB_DEBUG=3Dy
# CONFIG_SLAB is not set
CONFIG_SLUB=3Dy
# CONFIG_SLOB is not set
CONFIG_RT_MUTEXES=3Dy
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=3D0
CONFIG_MODULES=3Dy
CONFIG_MODULE_UNLOAD=3Dy
CONFIG_MODULE_FORCE_UNLOAD=3Dy
CONFIG_MODVERSIONS=3Dy
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=3Dy
CONFIG_BLOCK=3Dy
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=3Dy
CONFIG_IOSCHED_AS=3Dy
CONFIG_IOSCHED_DEADLINE=3Dy
CONFIG_IOSCHED_CFQ=3Dy
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=3Dy
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED=3D"cfq"

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=3Dy
CONFIG_NO_HZ=3Dy
CONFIG_HIGH_RES_TIMERS=3Dy
CONFIG_GENERIC_CLOCKEVENTS_BUILD=3Dy
# CONFIG_SMP is not set
CONFIG_X86_PC=3Dy
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=3Dy
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=3Dy
# CONFIG_MPENTIUMM is not set
# CONFIG_MCORE2 is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=3Dy
CONFIG_X86_L1_CACHE_SHIFT=3D5
CONFIG_X86_XADD=3Dy
CONFIG_RWSEM_XCHGADD_ALGORITHM=3Dy
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=3Dy
CONFIG_X86_WP_WORKS_OK=3Dy
CONFIG_X86_INVLPG=3Dy
CONFIG_X86_BSWAP=3Dy
CONFIG_X86_POPAD_OK=3Dy
CONFIG_X86_GOOD_APIC=3Dy
CONFIG_X86_INTEL_USERCOPY=3Dy
CONFIG_X86_USE_PPRO_CHECKSUM=3Dy
CONFIG_X86_TSC=3Dy
CONFIG_X86_CMOV=3Dy
CONFIG_X86_MINIMUM_CPU_FAMILY=3D4
CONFIG_HPET_TIMER=3Dy
CONFIG_HPET_EMULATE_RTC=3Dy
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=3Dy
# CONFIG_PREEMPT is not set
# CONFIG_X86_UP_APIC is not set
# CONFIG_X86_MCE is not set
CONFIG_VM86=3Dy
CONFIG_TOSHIBA=3Dm
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=3Dy
CONFIG_MICROCODE=3Dm
CONFIG_MICROCODE_OLD_INTERFACE=3Dy
CONFIG_X86_MSR=3Dm
CONFIG_X86_CPUID=3Dm

#
# Firmware Drivers
#
CONFIG_EDD=3Dy
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=3Dy
CONFIG_NOHIGHMEM=3Dy
# CONFIG_HIGHMEM4G is not set
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=3Dy
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=3D0xC0000000
# CONFIG_X86_PAE is not set
CONFIG_ARCH_FLATMEM_ENABLE=3Dy
CONFIG_ARCH_SPARSEMEM_ENABLE=3Dy
CONFIG_ARCH_SELECT_MEMORY_MODEL=3Dy
CONFIG_ARCH_POPULATES_NODE_MAP=3Dy
CONFIG_SELECT_MEMORY_MODEL=3Dy
CONFIG_FLATMEM_MANUAL=3Dy
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=3Dy
CONFIG_FLAT_NODE_MEM_MAP=3Dy
CONFIG_SPARSEMEM_STATIC=3Dy
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=3D4
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=3D1
CONFIG_BOUNCE=3Dy
CONFIG_NR_QUICK=3D1
CONFIG_VIRT_TO_BUS=3Dy
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=3Dy
# CONFIG_EFI is not set
CONFIG_SECCOMP=3Dy
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=3Dy
# CONFIG_HZ_1000 is not set
CONFIG_HZ=3D300
# CONFIG_KEXEC is not set
CONFIG_PHYSICAL_START=3D0x100000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=3D0x100000
# CONFIG_COMPAT_VDSO is not set

#
# Power management options (ACPI, APM)
#
CONFIG_PM=3Dy
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=3Dy
CONFIG_SUSPEND_UP_POSSIBLE=3Dy
CONFIG_SUSPEND=3Dy
CONFIG_HIBERNATION_UP_POSSIBLE=3Dy
CONFIG_HIBERNATION=3Dy
CONFIG_PM_STD_PARTITION=3D""
CONFIG_ACPI=3Dy
CONFIG_ACPI_SLEEP=3Dy
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_ACPI_AC=3Dm
CONFIG_ACPI_BATTERY=3Dm
CONFIG_ACPI_BUTTON=3Dm
CONFIG_ACPI_VIDEO=3Dm
CONFIG_ACPI_FAN=3Dm
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=3Dm
CONFIG_ACPI_THERMAL=3Dm
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=3Dm
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_CUSTOM_DSDT_INITRD=3Dy
CONFIG_ACPI_BLACKLIST_YEAR=3D0
CONFIG_ACPI_DEBUG=3Dy
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
CONFIG_ACPI_EC=3Dy
CONFIG_ACPI_POWER=3Dy
CONFIG_ACPI_SYSTEM=3Dy
CONFIG_X86_PM_TIMER=3Dy
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=3Dy
CONFIG_CPU_FREQ_TABLE=3Dy
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=3Dy
CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=3Dy
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dm
CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dm
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dm

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=3Dm
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
CONFIG_CPU_IDLE=3Dy
CONFIG_CPU_IDLE_GOV_LADDER=3Dy
CONFIG_CPU_IDLE_GOV_MENU=3Dy

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=3Dy
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=3Dy
CONFIG_PCI_BIOS=3Dy
CONFIG_PCI_DIRECT=3Dy
CONFIG_PCI_MMCONFIG=3Dy
CONFIG_PCI_DOMAINS=3Dy
# CONFIG_PCIEPORTBUS is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCI_LEGACY=3Dy
# CONFIG_PCI_DEBUG is not set
CONFIG_ISA_DMA_API=3Dy
CONFIG_ISA=3Dy
# CONFIG_EISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
CONFIG_PCCARD=3Dm
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=3Dm
CONFIG_PCMCIA_LOAD_CIS=3Dy
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=3Dy

#
# PC-card bridges
#
CONFIG_YENTA=3Dm
CONFIG_YENTA_O2=3Dy
CONFIG_YENTA_RICOH=3Dy
CONFIG_YENTA_TI=3Dy
CONFIG_YENTA_ENE_TUNE=3Dy
CONFIG_YENTA_TOSHIBA=3Dy
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
# CONFIG_I82365 is not set
# CONFIG_TCIC is not set
CONFIG_PCMCIA_PROBE=3Dy
CONFIG_PCCARD_NONSTATIC=3Dm
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=3Dy
CONFIG_BINFMT_AOUT=3Dm
CONFIG_BINFMT_MISC=3Dm

#
# Networking
#
CONFIG_NET=3Dy

#
# Networking options
#
CONFIG_PACKET=3Dm
CONFIG_PACKET_MMAP=3Dy
CONFIG_UNIX=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_USER=3Dm
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
CONFIG_NET_KEY=3Dm
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=3Dy
CONFIG_IP_MULTICAST=3Dy
CONFIG_IP_ADVANCED_ROUTER=3Dy
CONFIG_ASK_IP_FIB_HASH=3Dy
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=3Dy
CONFIG_IP_MULTIPLE_TABLES=3Dy
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
CONFIG_TCP_CONG_CUBIC=3Dy
CONFIG_DEFAULT_TCP_CONG=3D"cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
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

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
CONFIG_IRDA=3Dm

#
# IrDA protocols
#
CONFIG_IRLAN=3Dm
CONFIG_IRNET=3Dm
CONFIG_IRCOMM=3Dm
CONFIG_IRDA_ULTRA=3Dy

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
CONFIG_IRDA_FAST_RR=3Dy
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
# Old SIR device drivers
#
# CONFIG_IRPORT_SIR is not set

#
# Old Serial dongle support
#

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
CONFIG_SMC_IRCC_FIR=3Dm
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=3Dm
CONFIG_BT_L2CAP=3Dm
# CONFIG_BT_SCO is not set
CONFIG_BT_RFCOMM=3Dm
CONFIG_BT_RFCOMM_TTY=3Dy
CONFIG_BT_BNEP=3Dm
# CONFIG_BT_BNEP_MC_FILTER is not set
# CONFIG_BT_BNEP_PROTO_FILTER is not set
# CONFIG_BT_HIDP is not set

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=3Dm
# CONFIG_BT_HCIUSB_SCO is not set
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
CONFIG_FIB_RULES=3Dy

#
# Wireless
#
CONFIG_CFG80211=3Dm
CONFIG_NL80211=3Dy
CONFIG_WIRELESS_EXT=3Dy
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=3D"\"\""
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=3Dy
CONFIG_FW_LOADER=3Dm
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=3Dm
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=3Dy
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
# CONFIG_ISAPNP is not set
# CONFIG_PNPBIOS is not set
CONFIG_PNPACPI=3Dy
CONFIG_BLK_DEV=3Dy
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=3Dm
CONFIG_BLK_DEV_CRYPTOLOOP=3Dm
CONFIG_BLK_DEV_NBD=3Dm
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=3Dy
CONFIG_BLK_DEV_RAM_COUNT=3D16
CONFIG_BLK_DEV_RAM_SIZE=3D32000
CONFIG_BLK_DEV_RAM_BLOCKSIZE=3D1024
CONFIG_CDROM_PKTCDVD=3Dy
CONFIG_CDROM_PKTCDVD_BUFFERS=3D8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=3Dy
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
CONFIG_IDE=3Dm
CONFIG_IDE_MAX_HWIFS=3D4
CONFIG_BLK_DEV_IDE=3Dm

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=3Dm
# CONFIG_IDEDISK_MULTI_MODE is not set
# CONFIG_BLK_DEV_IDECS is not set
# CONFIG_BLK_DEV_DELKIN is not set
CONFIG_BLK_DEV_IDECD=3Dm
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=3Dy
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=3Dy

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=3Dm
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=3Dy
CONFIG_IDEPCI_SHARE_IRQ=3Dy
# CONFIG_IDEPCI_PCIBUS_ORDER is not set
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=3Dy
# CONFIG_BLK_DEV_AEC62XX is not set
CONFIG_BLK_DEV_ALI15X3=3Dm
# CONFIG_WDC_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
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
# CONFIG_IDE_ARM is not set

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
CONFIG_BLK_DEV_IDEDMA=3Dy
CONFIG_IDE_ARCH_OBSOLETE_INIT=3Dy
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=3Dm
CONFIG_SCSI_DMA=3Dy
CONFIG_SCSI_TGT=3Dm
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=3Dy

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=3Dm
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=3Dm
CONFIG_BLK_DEV_SR_VENDOR=3Dy
CONFIG_CHR_DEV_SG=3Dm
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=3Dy
CONFIG_SCSI_CONSTANTS=3Dy
CONFIG_SCSI_LOGGING=3Dy
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=3Dm

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=3Dm
# CONFIG_SCSI_FC_ATTRS is not set
CONFIG_SCSI_ISCSI_ATTRS=3Dm
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=3Dy
# CONFIG_ISCSI_TCP is not set
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
# CONFIG_SCSI_NCR53C406A is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_PAS16 is not set
# CONFIG_SCSI_PSI240I is not set
# CONFIG_SCSI_QLOGIC_FAS is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_SEAGATE is not set
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
CONFIG_ATA=3Dm
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=3Dy
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=3Dm
CONFIG_PATA_ALI=3Dm
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
CONFIG_MD=3Dy
CONFIG_BLK_DEV_MD=3Dm
CONFIG_MD_LINEAR=3Dm
CONFIG_MD_RAID0=3Dm
CONFIG_MD_RAID1=3Dm
CONFIG_MD_RAID10=3Dm
CONFIG_MD_RAID456=3Dm
CONFIG_MD_RAID5_RESHAPE=3Dy
CONFIG_MD_MULTIPATH=3Dm
CONFIG_MD_FAULTY=3Dm
CONFIG_BLK_DEV_DM=3Dm
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=3Dm
CONFIG_DM_SNAPSHOT=3Dm
CONFIG_DM_MIRROR=3Dm
CONFIG_DM_ZERO=3Dm
CONFIG_DM_MULTIPATH=3Dm
CONFIG_DM_MULTIPATH_EMC=3Dm
# CONFIG_DM_MULTIPATH_RDAC is not set
# CONFIG_DM_MULTIPATH_HP is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=3Dy
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=3Dy
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=3Dm
CONFIG_BONDING=3Dm
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=3Dm
CONFIG_VETH=3Dm
# CONFIG_NET_SB1000 is not set
# CONFIG_IP1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_PHYLIB is not set
CONFIG_NET_ETHERNET=3Dy
CONFIG_MII=3Dy
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
CONFIG_NET_PCI=3Dy
# CONFIG_PCNET32 is not set
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_AC3200 is not set
# CONFIG_APRICOT is not set
# CONFIG_B44 is not set
# CONFIG_FORCEDETH is not set
# CONFIG_CS89x0 is not set
# CONFIG_EEPRO100 is not set
CONFIG_E100=3Dy
# CONFIG_FEALNX is not set
# CONFIG_NATSEMI is not set
# CONFIG_NE2K_PCI is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
# CONFIG_SIS900 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
# CONFIG_VIA_RHINE is not set
# CONFIG_SC92031 is not set
# CONFIG_NETDEV_1000 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=3Dy
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=3Dm
CONFIG_PPP_MULTILINK=3Dy
CONFIG_PPP_FILTER=3Dy
CONFIG_PPP_ASYNC=3Dm
CONFIG_PPP_SYNC_TTY=3Dm
CONFIG_PPP_DEFLATE=3Dm
CONFIG_PPP_BSDCOMP=3Dm
CONFIG_PPP_MPPE=3Dm
CONFIG_PPPOE=3Dm
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=3Dm
# CONFIG_NET_FC is not set
CONFIG_SHAPER=3Dm
CONFIG_NETCONSOLE=3Dy
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=3Dy
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=3Dy
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=3Dy
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=3Dy
CONFIG_INPUT_MOUSEDEV_PSAUX=3Dy
CONFIG_INPUT_MOUSEDEV_SCREEN_X=3D1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=3D768
CONFIG_INPUT_JOYDEV=3Dm
CONFIG_INPUT_EVDEV=3Dm
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=3Dy
CONFIG_KEYBOARD_ATKBD=3Dy
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=3Dy
CONFIG_MOUSE_PS2=3Dm
# CONFIG_MOUSE_PS2_ALPS is not set
# CONFIG_MOUSE_PS2_LOGIPS2PP is not set
# CONFIG_MOUSE_PS2_SYNAPTICS is not set
# CONFIG_MOUSE_PS2_LIFEBOOK is not set
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_INPORT is not set
# CONFIG_MOUSE_LOGIBM is not set
# CONFIG_MOUSE_PC110PAD is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=3Dy
CONFIG_INPUT_PCSPKR=3Dm
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
CONFIG_INPUT_UINPUT=3Dm

#
# Hardware I/O ports
#
CONFIG_SERIO=3Dy
CONFIG_SERIO_I8042=3Dy
CONFIG_SERIO_SERPORT=3Dy
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=3Dy
CONFIG_SERIO_RAW=3Dm
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=3Dy
CONFIG_VT_CONSOLE=3Dy
CONFIG_HW_CONSOLE=3Dy
CONFIG_VT_HW_CONSOLE_BINDING=3Dy
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=3Dm
CONFIG_FIX_EARLYCON_MEM=3Dy
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_PNP=3Dm
CONFIG_SERIAL_8250_CS=3Dm
CONFIG_SERIAL_8250_NR_UARTS=3D4
CONFIG_SERIAL_8250_RUNTIME_UARTS=3D4
CONFIG_SERIAL_8250_EXTENDED=3Dy
# CONFIG_SERIAL_8250_MANY_PORTS is not set
CONFIG_SERIAL_8250_SHARE_IRQ=3Dy
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=3Dm
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=3Dy
CONFIG_LEGACY_PTYS=3Dy
CONFIG_LEGACY_PTY_COUNT=3D256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=3Dy
CONFIG_HW_RANDOM_INTEL=3Dm
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
CONFIG_NVRAM=3Dm
CONFIG_RTC=3Dy
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
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=3Dm
CONFIG_MAX_RAW_DEVS=3D256
CONFIG_HPET=3Dy
# CONFIG_HPET_RTC_IRQ is not set
CONFIG_HPET_MMAP=3Dy
CONFIG_HANGCHECK_TIMER=3Dm
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=3Dy
CONFIG_I2C=3Dm
CONFIG_I2C_BOARDINFO=3Dy
CONFIG_I2C_CHARDEV=3Dm

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=3Dm
CONFIG_I2C_ALGOPCF=3Dm
CONFIG_I2C_ALGOPCA=3Dm

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=3Dm
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_ELEKTOR is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_STUB=3Dm
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=3Dm
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=3Dm
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=3Dm
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
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
CONFIG_SENSORS_LM90=3Dm
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_WATCHDOG=3Dy
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=3Dm
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=3Dm
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_ITCO_WDT is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
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

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=3Dy
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=3Dm
CONFIG_AGP_ALI=3Dm
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
CONFIG_VIDEO_OUTPUT_CONTROL=3Dm
CONFIG_FB=3Dy
CONFIG_FIRMWARE_EDID=3Dy
# CONFIG_FB_DDC is not set
CONFIG_FB_CFB_FILLRECT=3Dy
CONFIG_FB_CFB_COPYAREA=3Dy
CONFIG_FB_CFB_IMAGEBLIT=3Dy
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=3Dy
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=3Dy
CONFIG_FB_TILEBLITTING=3Dy

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
CONFIG_FB_UVESA=3Dm
CONFIG_FB_VESA=3Dy
# CONFIG_FB_HECUBA is not set
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
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
CONFIG_LCD_CLASS_DEVICE=3Dm
CONFIG_BACKLIGHT_CLASS_DEVICE=3Dm
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=3Dy
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=3Dy
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE=3Dy
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=3Dy
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
CONFIG_FONTS=3Dy
CONFIG_FONT_8x8=3Dy
CONFIG_FONT_8x16=3Dy
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=3Dy
CONFIG_LOGO_LINUX_MONO=3Dy
CONFIG_LOGO_LINUX_VGA16=3Dy
CONFIG_LOGO_LINUX_CLUT224=3Dy

#
# Sound
#
CONFIG_SOUND=3Dm

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=3Dm
CONFIG_SND_TIMER=3Dm
CONFIG_SND_PCM=3Dm
CONFIG_SND_RAWMIDI=3Dm
CONFIG_SND_SEQUENCER=3Dm
CONFIG_SND_SEQ_DUMMY=3Dm
CONFIG_SND_OSSEMUL=3Dy
CONFIG_SND_MIXER_OSS=3Dm
CONFIG_SND_PCM_OSS=3Dm
CONFIG_SND_PCM_OSS_PLUGINS=3Dy
CONFIG_SND_SEQUENCER_OSS=3Dy
CONFIG_SND_RTCTIMER=3Dm
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=3Dy
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=3Dy
CONFIG_SND_VERBOSE_PROCFS=3Dy
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_MPU401_UART=3Dm
CONFIG_SND_AC97_CODEC=3Dm
CONFIG_SND_DUMMY=3Dm
CONFIG_SND_VIRMIDI=3Dm
CONFIG_SND_MTPAV=3Dm
CONFIG_SND_SERIAL_U16550=3Dm
CONFIG_SND_MPU401=3Dm

#
# ISA devices
#
# CONFIG_SND_ADLIB is not set
# CONFIG_SND_AD1816A is not set
# CONFIG_SND_AD1848 is not set
# CONFIG_SND_ALS100 is not set
# CONFIG_SND_AZT2320 is not set
# CONFIG_SND_CMI8330 is not set
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4232 is not set
# CONFIG_SND_CS4236 is not set
# CONFIG_SND_DT019X is not set
# CONFIG_SND_ES968 is not set
# CONFIG_SND_ES1688 is not set
# CONFIG_SND_ES18XX is not set
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
# CONFIG_SND_GUSEXTREME is not set
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_INTERWAVE is not set
# CONFIG_SND_INTERWAVE_STB is not set
# CONFIG_SND_OPL3SA2 is not set
# CONFIG_SND_OPTI92X_AD1848 is not set
# CONFIG_SND_OPTI92X_CS4231 is not set
# CONFIG_SND_OPTI93X is not set
# CONFIG_SND_MIRO is not set
# CONFIG_SND_SB8 is not set
# CONFIG_SND_SB16 is not set
# CONFIG_SND_SBAWE is not set
# CONFIG_SND_SGALAXY is not set
# CONFIG_SND_SSCAPE is not set
# CONFIG_SND_WAVEFRONT is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=3Dm
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
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
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_AC97_POWER_SAVE=3Dy
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=3D60

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=3Dm
CONFIG_HID_SUPPORT=3Dy
CONFIG_HID=3Dm
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=3Dm
# CONFIG_USB_HIDINPUT_POWERBOOK is not set
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=3Dm
CONFIG_USB_MOUSE=3Dm
CONFIG_USB_SUPPORT=3Dy
CONFIG_USB_ARCH_HAS_HCD=3Dy
CONFIG_USB_ARCH_HAS_OHCI=3Dy
CONFIG_USB_ARCH_HAS_EHCI=3Dy
CONFIG_USB=3Dm
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=3Dy
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=3Dy
CONFIG_USB_SUSPEND=3Dy
CONFIG_USB_PERSIST=3Dy
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_EHCI_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=3Dm
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=3Dy
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=3Dm
CONFIG_USB_PRINTER=3Dm

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=3Dm
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=3Dy
CONFIG_USB_STORAGE_FREECOM=3Dy
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=3Dy
CONFIG_USB_STORAGE_USBAT=3Dy
CONFIG_USB_STORAGE_SDDR09=3Dy
CONFIG_USB_STORAGE_SDDR55=3Dy
CONFIG_USB_STORAGE_JUMPSHOT=3Dy
CONFIG_USB_STORAGE_ALAUDA=3Dy
CONFIG_USB_STORAGE_KARMA=3Dy
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
CONFIG_USB_SERIAL=3Dm
CONFIG_USB_SERIAL_GENERIC=3Dy
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_AIRPRIME is not set
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
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=3Dm
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
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

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_VIRTUALIZATION is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# File systems
#
CONFIG_EXT2_FS=3Dm
CONFIG_EXT2_FS_XATTR=3Dy
CONFIG_EXT2_FS_POSIX_ACL=3Dy
CONFIG_EXT2_FS_SECURITY=3Dy
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=3Dm
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=3Dm
CONFIG_FS_MBCACHE=3Dm
CONFIG_REISERFS_FS=3Dm
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=3Dy
CONFIG_REISERFS_FS_XATTR=3Dy
CONFIG_REISERFS_FS_POSIX_ACL=3Dy
CONFIG_REISERFS_FS_SECURITY=3Dy
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=3Dy
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=3Dy
CONFIG_INOTIFY_USER=3Dy
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=3Dy
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=3Dm
CONFIG_FUSE_FS=3Dm
CONFIG_GENERIC_ACL=3Dy

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=3Dm
CONFIG_JOLIET=3Dy
CONFIG_ZISOFS=3Dy
CONFIG_UDF_FS=3Dm
CONFIG_UDF_NLS=3Dy

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=3Dm
CONFIG_MSDOS_FS=3Dm
CONFIG_VFAT_FS=3Dm
CONFIG_FAT_DEFAULT_CODEPAGE=3D866
CONFIG_FAT_DEFAULT_IOCHARSET=3D"iso8859-1"
CONFIG_NTFS_FS=3Dm
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=3Dy
CONFIG_PROC_KCORE=3Dy
CONFIG_PROC_SYSCTL=3Dy
CONFIG_SYSFS=3Dy
CONFIG_TMPFS=3Dy
CONFIG_TMPFS_POSIX_ACL=3Dy
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=3Dm

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
CONFIG_SQUASHFS=3Dm
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3D3
# CONFIG_SQUASHFS_VMALLOC is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=3Dy
CONFIG_NFS_FS=3Dm
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
CONFIG_NFS_V4=3Dy
CONFIG_NFS_DIRECTIO=3Dy
CONFIG_NFSD=3Dm
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
CONFIG_NFSD_V4=3Dy
CONFIG_NFSD_TCP=3Dy
CONFIG_LOCKD=3Dm
CONFIG_LOCKD_V4=3Dy
CONFIG_EXPORTFS=3Dm
CONFIG_NFS_ACL_SUPPORT=3Dm
CONFIG_NFS_COMMON=3Dy
CONFIG_SUNRPC=3Dm
CONFIG_SUNRPC_GSS=3Dm
# CONFIG_SUNRPC_BIND34 is not set
CONFIG_RPCSEC_GSS_KRB5=3Dm
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=3Dm
CONFIG_CIFS_STATS=3Dy
CONFIG_CIFS_STATS2=3Dy
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=3Dm
# CONFIG_CODA_FS_OLD_API is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=3Dy
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=3Dy
CONFIG_BSD_DISKLABEL=3Dy
# CONFIG_MINIX_SUBPARTITION is not set
CONFIG_SOLARIS_X86_PARTITION=3Dy
CONFIG_UNIXWARE_DISKLABEL=3Dy
CONFIG_LDM_PARTITION=3Dy
# CONFIG_LDM_DEBUG is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=3Dy
CONFIG_NLS_DEFAULT=3D"utf8"
CONFIG_NLS_CODEPAGE_437=3Dm
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=3Dm
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=3Dm
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=3Dm
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=3Dm
CONFIG_NLS_ASCII=3Dm
CONFIG_NLS_ISO8859_1=3Dm
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
CONFIG_NLS_ISO8859_5=3Dm
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=3Dm
CONFIG_NLS_KOI8_R=3Dm
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=3Dm
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=3Dy
CONFIG_PROFILING=3Dy
CONFIG_OPROFILE=3Dm
CONFIG_KPROBES=3Dy
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=3Dy
CONFIG_PRINTK_TIME=3Dy
CONFIG_ENABLE_WARN_DEPRECATED=3Dy
CONFIG_ENABLE_MUST_CHECK=3Dy
CONFIG_MAGIC_SYSRQ=3Dy
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=3Dy
CONFIG_DEBUG_SHIRQ=3Dy
CONFIG_DETECT_SOFTLOCKUP=3Dy
CONFIG_SCHED_DEBUG=3Dy
CONFIG_SCHEDSTATS=3Dy
CONFIG_TIMER_STATS=3Dy
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=3Dy
CONFIG_DEBUG_MUTEXES=3Dy
CONFIG_DEBUG_LOCK_ALLOC=3Dy
CONFIG_PROVE_LOCKING=3Dy
CONFIG_LOCKDEP=3Dy
CONFIG_LOCK_STAT=3Dy
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=3Dy
CONFIG_DEBUG_SPINLOCK_SLEEP=3Dy
CONFIG_DEBUG_LOCKING_API_SELFTESTS=3Dy
CONFIG_STACKTRACE=3Dy
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=3Dy
CONFIG_DEBUG_INFO=3Dy
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=3Dy
CONFIG_FORCED_INLINING=3Dy
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_SAMPLES is not set
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=3Dy
# CONFIG_DEBUG_STACK_USAGE is not set

#
# Page alloc debug is incompatible with Software Suspend on i386
#
CONFIG_DEBUG_RODATA=3Dy
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=3Dy

#
# Security options
#
CONFIG_KEYS=3Dy
CONFIG_KEYS_DEBUG_PROC_KEYS=3Dy
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_XOR_BLOCKS=3Dm
CONFIG_ASYNC_CORE=3Dm
CONFIG_ASYNC_MEMCPY=3Dm
CONFIG_ASYNC_XOR=3Dm
CONFIG_CRYPTO=3Dy
CONFIG_CRYPTO_ALGAPI=3Dm
CONFIG_CRYPTO_AEAD=3Dm
CONFIG_CRYPTO_BLKCIPHER=3Dm
CONFIG_CRYPTO_HASH=3Dm
CONFIG_CRYPTO_MANAGER=3Dm
CONFIG_CRYPTO_HMAC=3Dm
CONFIG_CRYPTO_XCBC=3Dm
CONFIG_CRYPTO_NULL=3Dm
CONFIG_CRYPTO_MD4=3Dm
CONFIG_CRYPTO_MD5=3Dm
CONFIG_CRYPTO_SHA1=3Dm
CONFIG_CRYPTO_SHA256=3Dm
CONFIG_CRYPTO_SHA512=3Dm
CONFIG_CRYPTO_WP512=3Dm
CONFIG_CRYPTO_TGR192=3Dm
CONFIG_CRYPTO_GF128MUL=3Dm
CONFIG_CRYPTO_ECB=3Dm
CONFIG_CRYPTO_CBC=3Dm
CONFIG_CRYPTO_PCBC=3Dm
CONFIG_CRYPTO_LRW=3Dm
CONFIG_CRYPTO_XTS=3Dm
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_DES=3Dm
CONFIG_CRYPTO_FCRYPT=3Dm
CONFIG_CRYPTO_BLOWFISH=3Dm
CONFIG_CRYPTO_TWOFISH=3Dm
CONFIG_CRYPTO_TWOFISH_COMMON=3Dm
CONFIG_CRYPTO_TWOFISH_586=3Dm
CONFIG_CRYPTO_SERPENT=3Dm
CONFIG_CRYPTO_AES=3Dm
CONFIG_CRYPTO_AES_586=3Dm
CONFIG_CRYPTO_CAST5=3Dm
CONFIG_CRYPTO_CAST6=3Dm
CONFIG_CRYPTO_TEA=3Dm
CONFIG_CRYPTO_ARC4=3Dm
CONFIG_CRYPTO_KHAZAD=3Dm
CONFIG_CRYPTO_ANUBIS=3Dm
CONFIG_CRYPTO_SEED=3Dm
CONFIG_CRYPTO_DEFLATE=3Dm
CONFIG_CRYPTO_MICHAEL_MIC=3Dm
CONFIG_CRYPTO_CRC32C=3Dm
CONFIG_CRYPTO_CAMELLIA=3Dm
CONFIG_CRYPTO_TEST=3Dm
CONFIG_CRYPTO_AUTHENC=3Dm
# CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=3Dy
CONFIG_CRC_CCITT=3Dm
CONFIG_CRC16=3Dm
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=3Dy
CONFIG_CRC7=3Dm
CONFIG_LIBCRC32C=3Dm
CONFIG_AUDIT_GENERIC=3Dy
CONFIG_ZLIB_INFLATE=3Dm
CONFIG_ZLIB_DEFLATE=3Dm
CONFIG_PLIST=3Dy
CONFIG_HAS_IOMEM=3Dy
CONFIG_HAS_IOPORT=3Dy
CONFIG_HAS_DMA=3Dy
CONFIG_GENERIC_HARDIRQS=3Dy
CONFIG_GENERIC_IRQ_PROBE=3Dy
CONFIG_X86_BIOS_REBOOT=3Dy
CONFIG_KTIME_SCALAR=3Dy

--nextPart1477510.IZ4lJEI4s0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHNtnkR6LMutpd94wRAmKvAJ0YVutrlLK2x7Nv+85Ygw1cCsEe9gCgjdPJ
fcE0YIVBR1ASzjboTdyLQu4=
=03Fg
-----END PGP SIGNATURE-----

--nextPart1477510.IZ4lJEI4s0--
