Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbYE0VAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbYE0VAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 17:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbYE0VAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 17:00:25 -0400
Received: from ppp-110-19.adsl.restena.lu ([158.64.110.19]:46627 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755845AbYE0VAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 17:00:15 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 May 2008 17:00:12 EDT
Date: Tue, 27 May 2008 22:52:55 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080527225255.78640658@neptune.home>
In-Reply-To: <200805270152.25744.dtor@insightbb.com>
References: <200805162225.44284.bonbons@linux-vserver.org>
	<20080523044430.GA9809@anvil.corenet.prv>
	<20080523225714.3f0953f3@neptune.home>
	<200805270152.25744.dtor@insightbb.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/jp6pj87ZmRXdLM6bFI=p=D8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/jp6pj87ZmRXdLM6bFI=p=D8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tue, 27 May 2008 Dmitry Torokhov <dtor@insightbb.com> wrote:
> On Friday 23 May 2008 16:57, Bruno Pr=C3=A9mont wrote:
> > On Fri, 23 May 2008 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > Ah, ok, great.. I think we simply need to move dritek out of the
> > > > place where you put it in so it does not interfere with our
> > > > efforts to resume keyboard and mouse ;) I will see what I can
> > > > do there..
> > > >=20
> > >=20
> > > So what about the patch below? Does it work for you?
> > >=20
> > > Thanks!
> >=20
> > Hi Dmitry,
> >=20
> > Yes, this patch works for me (in combination with
> > http://lkml.org/lkml/2008/5/16/430 ), see attached
> > boot+suspend&resume log.
> >=20
> > You will eventually note the following lines during resume process:
> > ...
> > [ =C2=A0150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8=
042.c: 60 -> i8042 (command) [15985]
> > [ =C2=A0150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8=
042.c: 47 -> i8042 (parameter) [15985]
> > [ =C2=A0150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8=
042.c: 00 <- i8042 (interrupt, 0, 0) [15985]
> > [ =C2=A0150.588965] atkbd.c: Unknown key pressed (translated set 2, cod=
e 0x0 on isa0060/serio0).
> > [ =C2=A0150.588965] atkbd.c: Use 'setkeycodes 00 <keycode>' to make it =
known.
> > [ =C2=A0150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8=
042.c: f2 -> i8042 (kbd-data) [15985]
> > [ =C2=A0150.609410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8=
042.c: fa <- i8042 (interrupt, 0, 1) [15987]
> > ...
> >=20
>=20
> I see. Could you please try the patch below (in addition to the other
> 2 you have) and see if that 00 keycode is still reported?
>=20
> Thanks!=20
>=20
Yes, the 00 keycode is gone with this patch on top of the two I have,
the dritek keys still works as expected after resume.
Attached is the dmesg output (two suspends, only second one with i8042
debug output enabled)

Thanks for the patches,
Bruno

--MP_/jp6pj87ZmRXdLM6bFI=p=D8
Content-Type: text/plain; name=input-suspend-debug12.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=input-suspend-debug12.log

[    0.000000] Linux version 2.6.25.4 (bruno@neptune) (gcc version 4.1.2 (G=
entoo 4.1.2 p1.0.2)) #3 Tue May 27 22:04:25 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001dee0000 (usable)
[    0.000000]  BIOS-e820: 000000001dee0000 - 000000001deec000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001deec000 - 000000001df00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001df00000 - 0000000020000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
[    0.000000] 478MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009f800 for 1024 bytes.
[    0.000000] Entering add_active_range(0, 0, 122592) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   122592
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   122592
[    0.000000] On node 0 totalpages: 122592
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 925 pages used for memmap
[    0.000000]   Normal zone: 117571 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F6050, 0014 (r0 ACER  )
[    0.000000] ACPI: RSDT 1DEE5A39, 0030 (r1 ACER   Wagtail  20020114  LTP =
       0)
[    0.000000] ACPI: FACP 1DEEBF2C, 0074 (r1 ACER   Wagtail  20020114 PTL  =
      50)
[    0.000000] ACPI: DSDT 1DEE5A69, 64C3 (r1 ACER   Wagtail  20020114 MSFT =
 100000E)
[    0.000000] ACPI: FACS 1DEFCFC0, 0040
[    0.000000] ACPI: HPET 1DEEBFA0, 0038 (r1 ACER   Wagtail  20020114 PTL  =
       0)
[    0.000000] ACPI: BOOT 1DEEBFD8, 0028 (r1 ACER   Wagtail  20020114  LTP =
       1)
[    0.000000] ACPI: DMI detected: Acer
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0x0 is invalid
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000=
:dec10000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 121635
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.25.4 ro root=3D806 sof=
tlevel=3Ddefault video=3Dvesafb:1400x1050-32 hpet=3Dforce
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] mapped APIC to ffffb000 (013c2000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0463000 soft=3Dc0462000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1495.199 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.010000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.010000] Memory: 481692k/490368k available (2231k kernel code, 8184k =
reserved, 998k data, 216k init, 0k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.010000]     vmalloc : 0xde800000 - 0xfffb3000   ( 535 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xddee0000   ( 478 MB)
[    0.010000]       .init : 0xc0429000 - 0xc045f000   ( 216 kB)
[    0.010000]       .data : 0xc032dd5e - 0xc04277d8   ( 998 kB)
[    0.010000]       .text : 0xc0100000 - 0xc032dd5e   (2231 kB)
[    0.010000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1, Nodes=3D1
[    0.160002] Calibrating delay using timer specific routine.. 2991.75 Bog=
oMIPS (lpj=3D14958798)
[    0.160028] Security Framework initialized
[    0.160041] Capability LSM initialized
[    0.160051] Mount-cache hash table entries: 512
[    0.160210] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160219] CPU: L2 cache: 1024K
[    0.160225] Intel machine check architecture supported.
[    0.160234] Intel machine check reporting enabled on CPU#0.
[    0.160242] Compat vDSO mapped to ffffe000.
[    0.160250] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
[    0.160260] Checking 'hlt' instruction... OK.
[    0.200341] Freeing SMP alternatives: 0k freed
[    0.200348] ACPI: Core revision 20070126
[    0.212576] Parsing all Control Methods:
[    0.212712] Table [DSDT](id 0001) - 784 Objects with 54 Devices 203 Meth=
ods 19 Regions
[    0.212724]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[    0.212737] ACPI: setting ELCR to 0200 (from 0c00)
[    0.220004] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[    0.220151] khelper used greatest stack depth: 3444 bytes left
[    0.220236] net_namespace: 540 bytes
[    0.220477] Time: 22:15:29  Date: 05/27/08
[    0.220506] NET: Registered protocol family 16
[    0.220736] No dock devices found.
[    0.220839] ACPI: bus type pci registered
[    0.222157] PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=3D2
[    0.222165] PCI: Using configuration type 1
[    0.222176] Setting up standard PCI resources
[    0.245003] khelper used greatest stack depth: 3408 bytes left
[    0.245161] khelper used greatest stack depth: 3216 bytes left
[    0.246243] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GP=
E] 4 regs on int 0x9
[    0.246543] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 5 Wake, Ena=
bled 1 Runtime GPEs in this block
[    0.246559] ACPI: EC: Look up EC in DSDT
[    0.249671] Completing Region/Field/Buffer/Package initialization:......=
...................................................................
[    0.250924] Initialized 14/19 Regions 3/3 Fields 35/36 Buffers 21/28 Pac=
kages (793 nodes)
[    0.250936] Initializing Device/Processor/Thermal objects by executing _=
INI methods:..
[    0.251266] Executed 2 _INI methods requiring 1 _STA executions (examine=
d 58 objects)
[    0.251284] ACPI: Interpreter enabled
[    0.251290] ACPI: (supports S0 S3 S5)
[    0.251305] ACPI: Using PIC for interrupt routing
[    0.259756] ACPI: EC: GPE =3D 0x1d, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.259769] ACPI: EC: driver started in poll mode
[    0.259823] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.260325] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.260332] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 AC=
PI/GPIO/TCO
[    0.260343] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GP=
IO
[    0.260726] PCI: Transparent bridge - 0000:00:1e.0
[    0.260775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.261123] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.265098] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.265248] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.265389] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[    0.265531] ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
[    0.265672] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
[    0.265815] ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
[    0.265957] ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
[    0.266100] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[    0.266266] ACPI: Power Resource [PFN0] (off)
[    0.266317] ACPI: Power Resource [PFN1] (off)
[    0.266451] ACPI: WMI: Mapper loaded
[    0.266457] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.266499] pnp: PnP ACPI init
[    0.266511] ACPI: bus type pnp registered
[    0.271847] pnp: PnP ACPI: found 9 devices
[    0.271857] ACPI: ACPI bus type pnp unregistered
[    0.271934] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.272430] SCSI subsystem initialized
[    0.272478] libata version 3.00 loaded.
[    0.272985] PCI: Using ACPI for IRQ routing
[    0.272995] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.278770] hpet clockevent registered
[    0.278776] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.278786] hpet0: 3 64-bit timers, 14318180 Hz
[    0.279845] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.279853] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.279861] system 00:04: ioport range 0x800-0x80f has been reserved
[    0.279869] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.279877] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.279884] system 00:04: ioport range 0x1c0-0x1cf has been reserved
[    0.279893] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.279900] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    0.279908] system 00:04: ioport range 0x610-0x61f has been reserved
[    0.279917] system 00:04: iomem range 0xfec10000-0xfec1ffff could not be=
 reserved
[    0.279926] system 00:04: iomem range 0xff800000-0xffbfffff could not be=
 reserved
[    0.279936] system 00:04: iomem range 0xfff00000-0xffffffff could not be=
 reserved
[    0.279945] system 00:04: iomem range 0x0-0x9ffff could not be reserved
[    0.279953] system 00:04: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.279962] system 00:04: iomem range 0x0-0x0 could not be reserved
[    0.301675] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.301683]   IO window: 0x00003000-0x000030ff
[    0.301691]   IO window: 0x00003400-0x000034ff
[    0.301698]   PREFETCH window: 0x30000000-0x33ffffff
[    0.301706]   MEM window: 0x3c000000-0x3fffffff
[    0.301714] PCI: Bus 7, cardbus bridge: 0000:02:06.1
[    0.301720]   IO window: 0x00003800-0x000038ff
[    0.301727]   IO window: 0x00003c00-0x00003cff
[    0.301735]   PREFETCH window: 0x34000000-0x37ffffff
[    0.301743]   MEM window: 0x40000000-0x43ffffff
[    0.301750] PCI: Bridge: 0000:00:1e.0
[    0.301756]   IO window: 3000-3fff
[    0.301764]   MEM window: 0xe0200000-0xe07fffff
[    0.301771]   PREFETCH window: 0x0000000030000000-0x0000000037ffffff
[    0.301792] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.302064] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.302072] PCI: setting IRQ 10 as level-triggered
[    0.302076] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.302099] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.302122] NET: Registered protocol family 2
[    0.302224] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[    0.302455] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[    0.302602] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.302674] TCP: Hash tables configured (established 16384 bind 16384)
[    0.302682] TCP reno registered
[    0.302837] Simple Boot Flag at 0x37 set to 0x1
[    0.302900] Machine check exception polling timer started.
[    0.305824] io scheduler noop registered
[    0.305851] io scheduler cfq registered (default)
[    0.305870] pci 0000:00:02.0: Boot video device
[    0.306171] vesafb: framebuffer at 0xe8000000, mapped to 0xde880000, usi=
ng 5120k, total 32576k
[    0.306183] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D11
[    0.306189] vesafb: scrolling: redraw
[    0.306196] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.340693] Console: switching to colour frame buffer device 160x64
[    0.372671] fb0: VESA VGA frame buffer device
[    0.373527] ACPI: AC Adapter [ACAD] (on-line)
[    0.374185] ACPI: Battery Slot [BAT1] (battery absent)
[    0.374797] ACPI: Battery Slot [BAT2] (battery absent)
[    0.375120] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    0.375430] ACPI: Power Button (FF) [PWRF]
[    0.375670] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[    0.376383] ACPI: Lid Switch [LID]
[    0.376590] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0E:00/input/input2
[    0.376930] ACPI: Sleep Button (CM) [SLPB]
[    0.377272] ACPI: Transitioning device [FAN0] to D3
[    0.377510] ACPI: PNP0C0B:00 is registered as cooling_device0
[    0.377739] ACPI: Fan [FAN0] (off)
[    0.378008] ACPI: Transitioning device [FAN1] to D3
[    0.378239] ACPI: PNP0C0B:01 is registered as cooling_device1
[    0.378468] ACPI: Fan [FAN1] (off)
[    0.378973] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:0=
0/device:02/input/input3
[    0.379321] ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: n=
o)
[    0.379789] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.380000] ACPI: ACPI0007:00 is registered as cooling_device2
[    0.380826] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.381494] ACPI: Thermal Zone [THRM] (50 C)
[    0.381703] isapnp: Scanning for PnP cards...
[    0.694574] isapnp: No Plug & Play device found
[    0.697553] intel_rng: FWH not detected
[    0.697720] Linux agpgart interface v0.103
[    0.697901] agpgart: Detected an Intel 855GM Chipset.
[    0.698863] agpgart: Detected 32636K stolen memory.
[    0.706243] agpgart: AGP aperture is 128M @ 0xe8000000
[    0.706558] [drm] Initialized drm 1.1.0 20060810
[    0.707044] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.707274] PCI: setting IRQ 11 as level-triggered
[    0.707278] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    0.707641] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.707729] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.707961] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    0.708037] [drm] Initialized i915 1.6.0 20060119 on minor 1
[    0.710053] acer-wmi: Acer Laptop ACPI-WMI Extras version 0.1
[    0.720024] acer-wmi: No or unsupported WMI interface, unable to load
[    0.730042] Driver 'sd' needs updating - please use bus_type methods
[    0.740045] ata_piix 0000:00:1f.1: version 2.12
[    0.740052] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[    0.750010] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.760028] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.760115] scsi0 : ata_piix
[    0.770070] scsi1 : ata_piix
[    0.780012] Switched to high resolution mode on CPU 0
[    0.781440] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    0.790005] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    0.982518] ata1.00: ATA-6: FUJITSU MHT2060AH, 006C, max UDMA/100
[    0.982522] ata1.00: 117210240 sectors, multi 16: LBA=20
[    1.040941] ata1.00: configured for UDMA/100
[    1.369996] ata2.01: NODEV after polling detection
[    1.549713] ata2.00: ATAPI: UJDA740 DVD/CDRW, 1.20, max UDMA/33
[    1.758412] ata2.00: configured for UDMA/33
[    1.758545] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 00=
6C PQ: 0 ANSI: 5
[    1.768550] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.778431] sd 0:0:0:0: [sda] Write Protect is off
[    1.788417] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.788442] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.798474] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.808427] sd 0:0:0:0: [sda] Write Protect is off
[    1.818416] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.818439] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.828416]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    1.999039] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.013142] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA740 DVD/CDRW 1.=
20 PQ: 0 ANSI: 5
[    2.018815] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64=
 irq 1,12
[    2.030530] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.038571] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.048716] mice: PS/2 mouse device common for all mice
[    2.098449] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input4
[    2.105062] cpuidle: using governor ladder
[    2.108796] cpuidle: using governor menu
[    2.119038] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.128482] TCP cubic registered
[    2.138471] NET: Registered protocol family 1
[    2.148687] NET: Registered protocol family 10
[    2.159056] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.168470] NET: Registered protocol family 17
[    2.178626] Using IPI Shortcut mode
[    2.188764]   Magic number: 8:78:301
[    2.198481]   hash matches device tty30
[    2.212878] Marking TSC unstable due to: TSC halts in idle.
[    2.714308] Clocksource tsc unstable (delta =3D -493020848 ns)
[    2.806256] Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0=
x904713/0x4006
[    2.838984] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input5
[    2.972964] ReiserFS: sda6: found reiserfs format "3.6" with standard jo=
urnal
[    2.972982] ReiserFS: sda6: using ordered data mode
[    2.996258] ReiserFS: sda6: journal params: device sda6, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    2.997067] ReiserFS: sda6: checking transaction log (sda6)
[    3.036553] ReiserFS: sda6: Using r5 hash to sort names
[    3.036632] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.046830] Freeing unused kernel memory: 216k freed
[    3.076516] khelper used greatest stack depth: 2144 bytes left
[    3.928655] cat used greatest stack depth: 1772 bytes left
[    4.024443] init-early.sh used greatest stack depth: 1580 bytes left
[    4.367866] fstabinfo used greatest stack depth: 1564 bytes left
[    5.296610] Driver 'sr' needs updating - please use bus_type methods
[    5.303474] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    5.303481] Uniform CD-ROM driver Revision: 3.20
[    5.303562] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.341785] usbcore: registered new interface driver usbfs
[    5.341814] usbcore: registered new interface driver hub
[    5.341879] usbcore: registered new device driver usb
[    5.360266] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.360292] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.376147] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.397784] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.397790] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.417010] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.417017] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.418784] USB Universal Host Controller Interface driver v3.0
[    5.418840] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    5.418850] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.418854] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.419117] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 1
[    5.419143] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
[    5.419297] usb usb1: configuration #1 chosen from 1 choice
[    5.419326] hub 1-0:1.0: USB hub found
[    5.419333] hub 1-0:1.0: 2 ports detected
[    5.526191] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.526197] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.526200] usb usb1: Product: UHCI Host Controller
[    5.526203] usb usb1: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    5.526205] usb usb1: SerialNumber: 0000:00:1d.0
[    5.536115] ssb: Sonics Silicon Backplane found on PCI device 0000:02:02=
.0
[    5.536152] b44.c:v2.0
[    5.536630] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    5.536634] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[    5.536659] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.536663] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.536702] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    5.540597] ehci_hcd 0000:00:1d.7: debug port 1
[    5.540603] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[    5.540613] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
[    5.556054] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    5.556244] usb usb2: configuration #1 chosen from 1 choice
[    5.556274] hub 2-0:1.0: USB hub found
[    5.556286] hub 2-0:1.0: 6 ports detected
[    5.575641] NET: Registered protocol family 23
[    5.578342] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:2d:03=
:9d
[    5.578413] ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.608744] nsc-ircc, chip->init
[    5.608755] nsc-ircc, Found chip at base=3D0x04e
[    5.608780] nsc-ircc, driver loaded (Dag Brattli)
[    5.609418] IrDA: Registered device irda0
[    5.609477] nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
[    5.666132] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.666138] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.666141] usb usb2: Product: EHCI Host Controller
[    5.666144] usb usb2: Manufacturer: Linux 2.6.25.4 ehci_hcd
[    5.666146] usb usb2: SerialNumber: 0000:00:1d.7
[    5.676227] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI versi=
on 1.10
[    5.676416] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.676449] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    5.769679] udev: renamed network interface eth0 to lan
[    5.946052] hub 2-0:1.0: unable to enumerate USB device on port 6
[    6.176159] firewire_core: created device fw0: GUID 00c09f00000fc03c, S4=
00
[    6.525960] intel8x0_measure_ac97_clock: measured 59405 usecs
[    6.525968] intel8x0: clocking to 48000
[    6.527076] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    6.527111] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[    6.536570] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    6.536594] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    6.536603] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.536668] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[    6.536703] uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
[    6.537001] usb usb3: configuration #1 chosen from 1 choice
[    6.537064] hub 3-0:1.0: USB hub found
[    6.537085] hub 3-0:1.0: 2 ports detected
[    6.645967] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    6.645978] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.645986] usb usb3: Product: UHCI Host Controller
[    6.645992] usb usb3: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    6.645998] usb usb3: SerialNumber: 0000:00:1d.1
[    6.646604] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    6.646628] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    6.646636] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.646702] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[    6.646740] uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
[    6.647023] usb usb4: configuration #1 chosen from 1 choice
[    6.647085] hub 4-0:1.0: USB hub found
[    6.647101] hub 4-0:1.0: 2 ports detected
[    6.755801] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    6.755812] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.755820] usb usb4: Product: UHCI Host Controller
[    6.755826] usb usb4: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    6.755832] usb usb4: SerialNumber: 0000:00:1d.2
[    7.020555] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 2
[    7.198288] usb 4-2: configuration #1 chosen from 1 choice
[    7.203851] hub 4-2:1.0: USB hub found
[    7.204763] hub 4-2:1.0: 3 ports detected
[    7.305520] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[    7.305531] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    7.305539] usb 4-2: Product: General Purpose USB Hub
[    7.543245] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 3
[    7.681473] usb 4-2.3: configuration #1 chosen from 1 choice
[    7.684457] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[    7.684466] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    7.684474] usb 4-2.3: Product: USB Mass Storage Device
[    7.684480] usb 4-2.3: Manufacturer: Generic
[    7.684485] usb 4-2.3: SerialNumber: ABCDEF0123456789
[    7.743769] Initializing USB Mass Storage driver...
[    7.744675] scsi2 : SCSI emulation for USB Mass Storage devices
[    7.749827] usbcore: registered new interface driver usb-storage
[    7.749831] USB Mass Storage support registered.
[    7.750604] usb-storage: device found at 3
[    7.750607] usb-storage: waiting for device to settle before scanning
[   12.596702] usb-storage: device scan complete
[   12.599508] scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[   12.618604] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   12.618698] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   17.373079] SGI XFS with ACLs, no debug enabled
[   17.376487] SGI XFS Quota Management subsystem
[   17.424885] XFS mounting filesystem sda9
[   17.544738] Ending clean XFS mount for filesystem: sda9
[   17.563138] ReiserFS: sda10: found reiserfs format "3.6" with standard j=
ournal
[   17.563166] ReiserFS: sda10: using ordered data mode
[   17.575945] ReiserFS: sda10: journal params: device sda10, size 8192, jo=
urnal first block 18, max trans len 1024, max batch 900, max commit age 30,=
 max trans age 30
[   17.575945] ReiserFS: sda10: checking transaction log (sda10)
[   17.607797] ReiserFS: sda10: Using r5 hash to sort names
[   17.637725] ReiserFS: sda7: found reiserfs format "3.6" with standard jo=
urnal
[   17.637748] ReiserFS: sda7: using ordered data mode
[   17.647296] ReiserFS: sda7: journal params: device sda7, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   17.647296] ReiserFS: sda7: checking transaction log (sda7)
[   17.713251] ReiserFS: sda7: Using r5 hash to sort names
[   17.750617] ReiserFS: sda8: found reiserfs format "3.6" with standard jo=
urnal
[   17.750617] ReiserFS: sda8: using ordered data mode
[   17.765612] ReiserFS: sda8: journal params: device sda8, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   17.765612] ReiserFS: sda8: checking transaction log (sda8)
[   17.822231] ReiserFS: sda8: Using r5 hash to sort names
[   17.858405] mount used greatest stack depth: 1548 bytes left
[   18.764392] cp used greatest stack depth: 1504 bytes left
[   19.660661] ADDRCONF(NETDEV_UP): lan: link is not ready
[   19.887656] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   19.887656] All bugs added by David S. Miller <davem@redhat.com>
[   19.938861] ADDRCONF(NETDEV_UP): lan.658: link is not ready
[   20.213052] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 ac=
ross:1004020k
[   23.104790] b44: lan: Link is up at 100 Mbps, full duplex.
[   23.104803] b44: lan: Flow control is off for TX and off for RX.
[   23.105286] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[   23.106310] ADDRCONF(NETDEV_CHANGE): lan.658: link becomes ready
[   31.969130] RPC: Registered udp transport module.
[   31.969142] RPC: Registered tcp transport module.
[   32.214772] mount.nfs used greatest stack depth: 908 bytes left
[   32.364512] loop: module loaded
[   32.413745] squashfs: version 3.3 (2007/10/31) Phillip Lougher
[   33.857889] lan.658: no IPv6 routers present
[   59.534170] PM: Syncing filesystems ... done.
[   59.542327] PM: Preparing system for mem sleep
[   59.585497] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[   59.585775] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[   59.585875] PM: Entering mem sleep
[   59.585880] Suspending console(s)
[   59.618599] b44: lan: powering down PHY
[   60.256743] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   60.257179] sd 0:0:0:0: [sda] Stopping disk
[   61.290480] drm_sysfs_suspend
[   61.304232] drm_sysfs_suspend
[   61.305050] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[   61.324725] nsc-ircc 00:08: disabled
[   61.344309] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[   61.344476] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[   61.364347] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[   61.364459] ACPI: Cannot set device to a higher-powered state than parent
[   61.364514] ACPI: Cannot set device to a higher-powered state than parent
[   61.364569] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[   61.364670] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[   61.384147] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[   61.384181] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[   61.384214] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[   61.392361] ACPI: Preparing to enter system sleep state S3
[   61.394244] ACPI: EC: missing OBF confirmation, don't expect it any long=
er.
[   61.405278] cpufreq: suspend failed to assert current frequency is what =
timing core thinks it is.
[   61.405527]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[   61.405527] Intel machine check architecture supported.
[   61.405548] Intel machine check reporting enabled on CPU#0.
[   61.405647] Back to C!
[   61.405660] cpufreq: resume failed to assert current frequency is what t=
iming core thinks it is.
[   61.406060] Force enabled HPET at resume
[   61.417382] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 100, writing 10b)
[   61.417404] PM: Writing back config space on device 0000:00:02.0 at offs=
et 6 (was 1, writing 1801)
[   61.417414] PM: Writing back config space on device 0000:00:02.0 at offs=
et 5 (was 0, writing e0000000)
[   61.417425] PM: Writing back config space on device 0000:00:02.0 at offs=
et 4 (was 8, writing e8000008)
[   61.417438] PM: Writing back config space on device 0000:00:02.0 at offs=
et 1 (was 900000, writing 900003)
[   61.426120] PM: Writing back config space on device 0000:00:02.1 at offs=
et 5 (was 0, writing e0080000)
[   61.426120] PM: Writing back config space on device 0000:00:02.1 at offs=
et 4 (was 8, writing f0000008)
[   61.426120] PM: Writing back config space on device 0000:00:02.1 at offs=
et 1 (was 900000, writing 900003)
[   61.426120] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[   61.426120] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   61.426120] usb usb1: root hub lost power or was reset
[   61.426120] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[   61.426120] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   61.426120] usb usb3: root hub lost power or was reset
[   61.426120] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[   61.426120] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   61.426120] usb usb4: root hub lost power or was reset
[   61.438310] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[   61.438326] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   61.438393] PM: Writing back config space on device 0000:00:1d.7 at offs=
et 1 (was 2900006, writing 2900106)
[   61.438487] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 9 (was fff0, writing 37f03000)
[   61.438516] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 1 (was 80800105, writing 80800107)
[   61.438542] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   61.438603] PM: Writing back config space on device 0000:00:1f.1 at offs=
et f (was 100, writing 1ff)
[   61.438628] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 9 (was 0, writing 38000000)
[   61.438658] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 1 (was 2800005, writing 2800007)
[   61.438682] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[   61.438696] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   61.445173] ata2.01: _GTF evaluation failed (AE 0x1001)
[   61.448273] ata1.01: _GTF evaluation failed (AE 0x1001)
[   61.448273] PM: Writing back config space on device 0000:00:1f.5 at offs=
et f (was 200, writing 20a)
[   61.448273] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 7 (was 0, writing e0100800)
[   61.448273] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 6 (was 0, writing e0100c00)
[   61.448273] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 5 (was 1301, writing 18c1)
[   61.448273] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 4 (was 1201, writing 1c01)
[   61.448273] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 1 (was 2900005, writing 2900003)
[   61.448273] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[   61.448273] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   61.943323] ata2.01: NODEV after polling detection
[   62.488208] PM: Writing back config space on device 0000:00:1f.6 at offs=
et f (was 200, writing 20a)
[   62.488249] PM: Writing back config space on device 0000:00:1f.6 at offs=
et 1 (was 2900005, writing 2900001)
[   62.488281] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[   62.488297] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[   62.558500] ata2.00: NODEV after polling detection
[   62.558507] ata2.00: revalidation failed (errno=3D-2)
[   62.558514] ata2: failed to recover some devices, retrying in 5 secs
[   63.383225] ata1.00: ACPI cmd 03/45:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[   63.387067] ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[   63.420629] ata1.00: configured for UDMA/100
[   63.420733] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[   63.420771] sd 0:0:0:0: [sda] Write Protect is off
[   63.420778] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   63.420831] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[   63.520971] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[   63.520982] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[   63.521004] PM: Writing back config space on device 0000:02:02.0 at offs=
et f (was 100, writing 10b)
[   63.521037] PM: Writing back config space on device 0000:02:02.0 at offs=
et 4 (was 0, writing e0204000)
[   63.521049] PM: Writing back config space on device 0000:02:02.0 at offs=
et 3 (was 0, writing 4000)
[   63.521063] PM: Writing back config space on device 0000:02:02.0 at offs=
et 1 (was 100002, writing 100106)
[   63.521097] PM: Writing back config space on device 0000:02:04.0 at offs=
et f (was 22020100, writing 2202010b)
[   63.521133] PM: Writing back config space on device 0000:02:04.0 at offs=
et 4 (was 0, writing e0206000)
[   63.521145] PM: Writing back config space on device 0000:02:04.0 at offs=
et 3 (was 0, writing 4008)
[   63.521160] PM: Writing back config space on device 0000:02:04.0 at offs=
et 1 (was 2900000, writing 2900116)
[   63.521197] PM: Writing back config space on device 0000:02:06.0 at offs=
et e (was 1, writing 34fd)
[   63.521209] PM: Writing back config space on device 0000:02:06.0 at offs=
et d (was 1, writing 3401)
[   63.521222] PM: Writing back config space on device 0000:02:06.0 at offs=
et c (was 1, writing 30fd)
[   63.521234] PM: Writing back config space on device 0000:02:06.0 at offs=
et b (was 1, writing 3001)
[   63.521247] PM: Writing back config space on device 0000:02:06.0 at offs=
et a (was 0, writing 3ffff000)
[   63.521259] PM: Writing back config space on device 0000:02:06.0 at offs=
et 9 (was 0, writing 3c000000)
[   63.521272] PM: Writing back config space on device 0000:02:06.0 at offs=
et 8 (was 0, writing 33fff000)
[   63.521285] PM: Writing back config space on device 0000:02:06.0 at offs=
et 7 (was 0, writing 30000000)
[   63.521298] PM: Writing back config space on device 0000:02:06.0 at offs=
et 6 (was 40000000, writing b0060302)
[   63.521313] PM: Writing back config space on device 0000:02:06.0 at offs=
et 4 (was 0, writing e0207000)
[   63.521330] PM: Writing back config space on device 0000:02:06.0 at offs=
et 1 (was 4100087, writing 4100187)
[   63.521371] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[   63.521399] PM: Writing back config space on device 0000:02:06.1 at offs=
et f (was 100, writing 18001ff)
[   63.521412] PM: Writing back config space on device 0000:02:06.1 at offs=
et e (was 1, writing 3cfd)
[   63.521424] PM: Writing back config space on device 0000:02:06.1 at offs=
et d (was 1, writing 3c01)
[   63.521437] PM: Writing back config space on device 0000:02:06.1 at offs=
et c (was 1, writing 38fd)
[   63.521449] PM: Writing back config space on device 0000:02:06.1 at offs=
et b (was 1, writing 3801)
[   63.521461] PM: Writing back config space on device 0000:02:06.1 at offs=
et a (was 0, writing 43fff000)
[   63.521474] PM: Writing back config space on device 0000:02:06.1 at offs=
et 9 (was 0, writing 40000000)
[   63.521487] PM: Writing back config space on device 0000:02:06.1 at offs=
et 8 (was 0, writing 37fff000)
[   63.521499] PM: Writing back config space on device 0000:02:06.1 at offs=
et 7 (was 0, writing 34000000)
[   63.521512] PM: Writing back config space on device 0000:02:06.1 at offs=
et 6 (was 0, writing b00a0702)
[   63.521527] PM: Writing back config space on device 0000:02:06.1 at offs=
et 4 (was 0, writing e0208000)
[   63.521539] PM: Writing back config space on device 0000:02:06.1 at offs=
et 3 (was 820000, writing 824000)
[   63.521555] PM: Writing back config space on device 0000:02:06.1 at offs=
et 1 (was 4100080, writing 4100107)
[   63.521595] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[   63.541353] PM: Writing back config space on device 0000:02:07.0 at offs=
et f (was 4020100, writing 402010a)
[   63.541387] PM: Writing back config space on device 0000:02:07.0 at offs=
et 5 (was 0, writing e0200000)
[   63.541400] PM: Writing back config space on device 0000:02:07.0 at offs=
et 4 (was 0, writing e0209000)
[   63.541413] PM: Writing back config space on device 0000:02:07.0 at offs=
et 3 (was 0, writing 4008)
[   63.541428] PM: Writing back config space on device 0000:02:07.0 at offs=
et 1 (was 2100002, writing 2100116)
[   63.645927] nsc-ircc 00:08: activated
[   63.664169] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[   63.688195] sd 0:0:0:0: [sda] Starting disk
[   64.836075] PM: Finishing wakeup.
[   64.836081] Restarting tasks ... <6>usb 4-2: USB disconnect, address 2
[   64.845927] usb 4-2.3: USB disconnect, address 3
[   64.852819] done.
[   65.309204] hub 2-0:1.0: unable to enumerate USB device on port 6
[   65.589266] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 4
[   65.763415] usb 4-2: configuration #1 chosen from 1 choice
[   65.767827] hub 4-2:1.0: USB hub found
[   65.770017] hub 4-2:1.0: 3 ports detected
[   65.883972] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[   65.883987] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[   65.883996] usb 4-2: Product: General Purpose USB Hub
[   66.125178] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 5
[   66.263445] usb 4-2.3: configuration #1 chosen from 1 choice
[   66.273445] scsi3 : SCSI emulation for USB Mass Storage devices
[   66.273445] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[   66.273445] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[   66.273445] usb 4-2.3: Product: USB Mass Storage Device
[   66.273445] usb 4-2.3: Manufacturer: Generic
[   66.273445] usb 4-2.3: SerialNumber: ABCDEF0123456789
[   66.273822] usb-storage: device found at 5
[   66.273831] usb-storage: waiting for device to settle before scanning
[   67.287760] b44: lan: Link is up at 100 Mbps, full duplex.
[   67.287775] b44: lan: Flow control is off for TX and off for RX.
[   67.877805] ata2.01: NODEV after polling detection
[   68.058450] ata2.00: ACPI cmd 03/42:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[   68.058801] ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[   68.258189] ata2.00: configured for UDMA/33
[   68.258204] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[   68.258206] ata2: ACPI event
[   68.258238] ata2: soft resetting link
[   68.572891] ata2.01: NODEV after polling detection
[   68.953326] ata2.00: configured for UDMA/33
[   68.953336] ata2: EH complete
[   71.258856] usb-storage: device scan complete
[   71.261853] scsi 3:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[   71.280947] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[   71.281047] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  134.328252] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [13420]
[  134.712503] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13459]
[  134.717478] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [13459]
[  134.806943] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13468]
[  134.811623] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [13469]
[  135.006867] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13488]
[  135.011393] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [13489]
[  135.091378] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13497]
[  135.096424] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [13497]
[  135.516071] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13539]
[  135.520677] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [13540]
[  135.609720] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13549]
[  135.614906] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [13549]
[  135.919603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13580]
[  135.924654] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [13581]
[  136.018506] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [13590]
[  136.023499] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [13591]
[  137.727321] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [13761]
[  137.736494] PM: Syncing filesystems ... done.
[  137.744348] PM: Preparing system for mem sleep
[  137.787433] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[  137.787752] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  137.787873] PM: Entering mem sleep
[  137.787877] Suspending console(s)
[  137.794140] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [13768]
[  137.827558] b44: lan: powering down PHY
[  137.847435] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13774]
[  137.847496] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f5 -> i=
8042 (parameter) [13774]
[  137.849693] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13774]
[  137.849713] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13774]
[  137.849774] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [13774]
[  137.851967] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13774]
[  137.851984] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13774]
[  137.852045] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [13774]
[  137.854238] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13774]
[  137.854254] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13774]
[  137.854315] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [13774]
[  137.856505] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13774]
[  137.856522] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13774]
[  137.856583] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [13774]
[  137.858768] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13775]
[  137.858768] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13775]
[  137.858768] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [13775]
[  137.860932] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13775]
[  137.860932] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13775]
[  137.860932] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [13775]
[  137.863101] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13775]
[  137.863101] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13775]
[  137.863101] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [13775]
[  137.865266] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13775]
[  137.865266] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13775]
[  137.865266] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [13775]
[  137.867435] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13776]
[  137.867435] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13776]
[  137.867435] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [13776]
[  137.869599] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13776]
[  137.869599] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13776]
[  137.869599] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (parameter) [13776]
[  137.871768] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13776]
[  137.871768] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13776]
[  137.871768] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 -> i=
8042 (parameter) [13776]
[  137.873933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13776]
[  137.873933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13776]
[  137.873933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ff -> i=
8042 (parameter) [13776]
[  137.876105] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13776]
[  138.257155] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (interrupt, 1, 12) [13815]
[  138.258255] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [13815]
[  138.258255] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [13815]
[  138.258255] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 -> i=
8042 (parameter) [13815]
[  138.260422] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [13815]
[  138.260422] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ff -> i=
8042 (kbd-data) [13815]
[  138.263203] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [13815]
[  138.413148] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (interrupt, 0, 1) [13830]
[  138.505273] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [13840]
[  138.505334] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 -> i=
8042 (parameter) [13840]
[  138.505351] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  138.505704] sd 0:0:0:0: [sda] Stopping disk
[  139.525977] drm_sysfs_suspend
[  139.542912] drm_sysfs_suspend
[  139.543729] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[  139.563370] nsc-ircc 00:08: disabled
[  139.582950] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[  139.583114] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[  139.603006] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[  139.603120] ACPI: Cannot set device to a higher-powered state than parent
[  139.603176] ACPI: Cannot set device to a higher-powered state than parent
[  139.603231] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[  139.603332] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  139.622829] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  139.622863] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  139.622897] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  139.623640] ACPI: Preparing to enter system sleep state S3
[  139.634221] cpufreq: suspend failed to assert current frequency is what =
timing core thinks it is.
[  139.634470]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[  139.634470] Intel machine check architecture supported.
[  139.634490] Intel machine check reporting enabled on CPU#0.
[  139.634591] Back to C!
[  139.634605] cpufreq: resume failed to assert current frequency is what t=
iming core thinks it is.
[  139.635001] Force enabled HPET at resume
[  139.652906] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 100, writing 10b)
[  139.652927] PM: Writing back config space on device 0000:00:02.0 at offs=
et 6 (was 1, writing 1801)
[  139.652938] PM: Writing back config space on device 0000:00:02.0 at offs=
et 5 (was 0, writing e0000000)
[  139.652949] PM: Writing back config space on device 0000:00:02.0 at offs=
et 4 (was 8, writing e8000008)
[  139.652962] PM: Writing back config space on device 0000:00:02.0 at offs=
et 1 (was 900000, writing 900003)
[  139.658770] PM: Writing back config space on device 0000:00:02.1 at offs=
et 5 (was 0, writing e0080000)
[  139.658770] PM: Writing back config space on device 0000:00:02.1 at offs=
et 4 (was 8, writing f0000008)
[  139.658770] PM: Writing back config space on device 0000:00:02.1 at offs=
et 1 (was 900000, writing 900003)
[  139.658770] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[  139.658770] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  139.658770] usb usb1: root hub lost power or was reset
[  139.658770] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[  139.658770] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  139.658770] usb usb3: root hub lost power or was reset
[  139.658770] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  139.658770] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  139.658770] usb usb4: root hub lost power or was reset
[  139.669312] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[  139.669328] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  139.669395] PM: Writing back config space on device 0000:00:1d.7 at offs=
et 1 (was 2900006, writing 2900106)
[  139.669489] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 9 (was fff0, writing 37f03000)
[  139.669518] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 1 (was 80800105, writing 80800107)
[  139.669544] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  139.669606] PM: Writing back config space on device 0000:00:1f.1 at offs=
et f (was 100, writing 1ff)
[  139.669631] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 9 (was 0, writing 38000000)
[  139.669661] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 1 (was 2800005, writing 2800007)
[  139.669685] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  139.669699] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[  139.676100] ata2.01: _GTF evaluation failed (AE 0x1001)
[  139.679275] ata1.01: _GTF evaluation failed (AE 0x1001)
[  139.679275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et f (was 200, writing 20a)
[  139.679275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 7 (was 0, writing e0100800)
[  139.679275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 6 (was 0, writing e0100c00)
[  139.679275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 5 (was 1301, writing 18c1)
[  139.679275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 4 (was 1201, writing 1c01)
[  139.679275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 1 (was 2900005, writing 2900003)
[  139.679275] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[  139.679275] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[  140.174370] ata2.01: NODEV after polling detection
[  140.719219] PM: Writing back config space on device 0000:00:1f.6 at offs=
et f (was 200, writing 20a)
[  140.719260] PM: Writing back config space on device 0000:00:1f.6 at offs=
et 1 (was 2900005, writing 2900001)
[  140.719292] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[  140.719308] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[  140.789516] ata2.00: NODEV after polling detection
[  140.789523] ata2.00: revalidation failed (errno=3D-2)
[  140.789530] ata2: failed to recover some devices, retrying in 5 secs
[  141.614235] ata1.00: ACPI cmd 03/45:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  141.618074] ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  141.651642] ata1.00: configured for UDMA/100
[  141.651747] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[  141.651786] sd 0:0:0:0: [sda] Write Protect is off
[  141.651793] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  141.651846] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  141.752015] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[  141.752026] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[  141.752048] PM: Writing back config space on device 0000:02:02.0 at offs=
et f (was 100, writing 10b)
[  141.752081] PM: Writing back config space on device 0000:02:02.0 at offs=
et 4 (was 0, writing e0204000)
[  141.752093] PM: Writing back config space on device 0000:02:02.0 at offs=
et 3 (was 0, writing 4000)
[  141.752107] PM: Writing back config space on device 0000:02:02.0 at offs=
et 1 (was 100002, writing 100106)
[  141.752141] PM: Writing back config space on device 0000:02:04.0 at offs=
et f (was 22020100, writing 2202010b)
[  141.752177] PM: Writing back config space on device 0000:02:04.0 at offs=
et 4 (was 0, writing e0206000)
[  141.752189] PM: Writing back config space on device 0000:02:04.0 at offs=
et 3 (was 0, writing 4008)
[  141.752204] PM: Writing back config space on device 0000:02:04.0 at offs=
et 1 (was 2900000, writing 2900116)
[  141.752242] PM: Writing back config space on device 0000:02:06.0 at offs=
et e (was 1, writing 34fd)
[  141.752254] PM: Writing back config space on device 0000:02:06.0 at offs=
et d (was 1, writing 3401)
[  141.752267] PM: Writing back config space on device 0000:02:06.0 at offs=
et c (was 1, writing 30fd)
[  141.752279] PM: Writing back config space on device 0000:02:06.0 at offs=
et b (was 1, writing 3001)
[  141.752292] PM: Writing back config space on device 0000:02:06.0 at offs=
et a (was 0, writing 3ffff000)
[  141.752304] PM: Writing back config space on device 0000:02:06.0 at offs=
et 9 (was 0, writing 3c000000)
[  141.752317] PM: Writing back config space on device 0000:02:06.0 at offs=
et 8 (was 0, writing 33fff000)
[  141.752329] PM: Writing back config space on device 0000:02:06.0 at offs=
et 7 (was 0, writing 30000000)
[  141.752342] PM: Writing back config space on device 0000:02:06.0 at offs=
et 6 (was 40000000, writing b0060302)
[  141.752358] PM: Writing back config space on device 0000:02:06.0 at offs=
et 4 (was 0, writing e0207000)
[  141.752375] PM: Writing back config space on device 0000:02:06.0 at offs=
et 1 (was 4100087, writing 4100187)
[  141.752416] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  141.752444] PM: Writing back config space on device 0000:02:06.1 at offs=
et f (was 100, writing 18001ff)
[  141.752457] PM: Writing back config space on device 0000:02:06.1 at offs=
et e (was 1, writing 3cfd)
[  141.752469] PM: Writing back config space on device 0000:02:06.1 at offs=
et d (was 1, writing 3c01)
[  141.752482] PM: Writing back config space on device 0000:02:06.1 at offs=
et c (was 1, writing 38fd)
[  141.752494] PM: Writing back config space on device 0000:02:06.1 at offs=
et b (was 1, writing 3801)
[  141.752507] PM: Writing back config space on device 0000:02:06.1 at offs=
et a (was 0, writing 43fff000)
[  141.752520] PM: Writing back config space on device 0000:02:06.1 at offs=
et 9 (was 0, writing 40000000)
[  141.752532] PM: Writing back config space on device 0000:02:06.1 at offs=
et 8 (was 0, writing 37fff000)
[  141.752545] PM: Writing back config space on device 0000:02:06.1 at offs=
et 7 (was 0, writing 34000000)
[  141.752558] PM: Writing back config space on device 0000:02:06.1 at offs=
et 6 (was 0, writing b00a0702)
[  141.752572] PM: Writing back config space on device 0000:02:06.1 at offs=
et 4 (was 0, writing e0208000)
[  141.752585] PM: Writing back config space on device 0000:02:06.1 at offs=
et 3 (was 820000, writing 824000)
[  141.752601] PM: Writing back config space on device 0000:02:06.1 at offs=
et 1 (was 4100080, writing 4100107)
[  141.752640] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  141.772395] PM: Writing back config space on device 0000:02:07.0 at offs=
et f (was 4020100, writing 402010a)
[  141.772429] PM: Writing back config space on device 0000:02:07.0 at offs=
et 5 (was 0, writing e0200000)
[  141.772442] PM: Writing back config space on device 0000:02:07.0 at offs=
et 4 (was 0, writing e0209000)
[  141.772454] PM: Writing back config space on device 0000:02:07.0 at offs=
et 3 (was 0, writing 4008)
[  141.772470] PM: Writing back config space on device 0000:02:07.0 at offs=
et 1 (was 2100002, writing 2100116)
[  141.876960] nsc-ircc 00:08: activated
[  141.895205] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[  141.919233] sd 0:0:0:0: [sda] Starting disk
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (flush, aux) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 74 -> i=
8042 (parameter) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 59 -> i=
8042 (command) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 90 -> i=
8042 (parameter) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 56 -> i=
8042 (parameter) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 -> i=
8042 (parameter) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 0, 0) [14235]
[  141.927244] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f2 -> i=
8042 (kbd-data) [14235]
[  141.947780] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14237]
[  141.948883] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [14238]
[  141.953423] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ab <- i=
8042 (interrupt, 0, 1) [14238]
[  141.958185] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 41 <- i=
8042 (interrupt, 0, 1) [14239]
[  141.958185] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ed -> i=
8042 (kbd-data) [14239]
[  141.960893] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14239]
[  141.960894] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (kbd-data) [14239]
[  141.963646] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14239]
[  141.963646] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (kbd-data) [14239]
[  141.966849] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14239]
[  141.966849] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (kbd-data) [14239]
[  141.969563] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14240]
[  141.969563] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 -> i=
8042 (kbd-data) [14240]
[  141.972469] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14240]
[  141.972469] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (kbd-data) [14240]
[  141.975175] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14240]
[  141.975175] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (kbd-data) [14240]
[  141.978294] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14241]
[  141.978294] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ed -> i=
8042 (kbd-data) [14241]
[  141.981003] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14241]
[  141.981003] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (kbd-data) [14241]
[  141.983941] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [14241]
[  141.983941] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14241]
[  141.983941] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14241]
[  141.986119] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14241]
[  141.986119] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14241]
[  141.986119] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14241]
[  141.988326] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14244]
[  141.988350] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14244]
[  141.988469] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14244]
[  141.990680] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14244]
[  141.990703] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14244]
[  141.990821] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14244]
[  141.993025] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14244]
[  141.993048] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14244]
[  141.993166] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14244]
[  141.995375] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14244]
[  141.995397] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14244]
[  141.995463] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14244]
[  141.997645] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14245]
[  141.997645] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14245]
[  141.997645] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14245]
[  141.999818] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14245]
[  141.999818] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14245]
[  141.999818] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14245]
[  142.001984] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14245]
[  142.001984] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14245]
[  142.001984] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [14245]
[  142.004180] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14245]
[  142.005310] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 08 <- i=
8042 (interrupt, 1, 12) [14245]
[  142.006421] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 1, 12) [14245]
[  142.007540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 15 <- i=
8042 (interrupt, 1, 12) [14246]
[  142.007540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14246]
[  142.007540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ff -> i=
8042 (parameter) [14246]
[  142.009714] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14246]
[  142.389540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (interrupt, 1, 12) [14284]
[  142.390848] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [14284]
[  142.390848] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14284]
[  142.390848] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14284]
[  142.393021] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14284]
[  142.393021] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14284]
[  142.393021] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14284]
[  142.395193] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14284]
[  142.395193] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14284]
[  142.395193] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14284]
[  142.397358] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14285]
[  142.397358] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14285]
[  142.397358] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14285]
[  142.399531] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14285]
[  142.399531] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14285]
[  142.399531] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14285]
[  142.401695] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14285]
[  142.401695] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14285]
[  142.401695] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14285]
[  142.403865] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14285]
[  142.403865] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14285]
[  142.403865] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14285]
[  142.406029] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14286]
[  142.406029] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14286]
[  142.406029] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14286]
[  142.408203] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14286]
[  142.408203] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14286]
[  142.408203] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14286]
[  142.410368] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14286]
[  142.410368] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14286]
[  142.410368] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [14286]
[  142.412565] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14286]
[  142.413696] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 08 <- i=
8042 (interrupt, 1, 12) [14286]
[  142.414815] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 1, 12) [14286]
[  142.415966] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 15 <- i=
8042 (interrupt, 1, 12) [14287]
[  142.415989] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14287]
[  142.416108] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14287]
[  142.418320] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14287]
[  142.418343] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14287]
[  142.418462] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14287]
[  142.420670] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14287]
[  142.420692] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14287]
[  142.420758] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14287]
[  142.422961] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14287]
[  142.422983] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14287]
[  142.423102] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14287]
[  142.425314] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14287]
[  142.425336] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14287]
[  142.425454] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14287]
[  142.427639] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14288]
[  142.427639] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14288]
[  142.427639] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14288]
[  142.429812] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14288]
[  142.429812] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14288]
[  142.429812] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14288]
[  142.431976] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14288]
[  142.431976] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14288]
[  142.431976] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14288]
[  142.434150] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14288]
[  142.434150] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14288]
[  142.434150] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 03 -> i=
8042 (parameter) [14288]
[  142.436315] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14289]
[  142.436315] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14289]
[  142.436315] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [14289]
[  142.438511] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14289]
[  142.439637] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9d <- i=
8042 (interrupt, 1, 12) [14289]
[  142.440751] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 1, 12) [14289]
[  142.441866] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b1 <- i=
8042 (interrupt, 1, 12) [14289]
[  142.441866] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14289]
[  142.441866] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14289]
[  142.444040] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14289]
[  142.444040] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14289]
[  142.444040] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14289]
[  142.446211] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14290]
[  142.446211] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14290]
[  142.446211] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14290]
[  142.448376] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14290]
[  142.448376] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14290]
[  142.448376] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14290]
[  142.450548] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14290]
[  142.450548] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14290]
[  142.450548] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14290]
[  142.452714] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14290]
[  142.452714] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14290]
[  142.452714] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14290]
[  142.454886] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14290]
[  142.454886] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14290]
[  142.454886] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14290]
[  142.457052] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14291]
[  142.457052] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14291]
[  142.457052] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14291]
[  142.459221] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14291]
[  142.459221] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14291]
[  142.459221] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 -> i=
8042 (parameter) [14291]
[  142.461385] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14291]
[  142.461385] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14291]
[  142.461385] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [14291]
[  142.463582] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14291]
[  142.464697] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 90 <- i=
8042 (interrupt, 1, 12) [14291]
[  142.465807] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 1, 12) [14292]
[  142.466921] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 13 <- i=
8042 (interrupt, 1, 12) [14292]
[  142.466921] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14292]
[  142.466921] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14292]
[  142.469093] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14292]
[  142.469093] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14292]
[  142.469093] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14292]
[  142.471265] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14292]
[  142.471265] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14292]
[  142.471265] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14292]
[  142.473432] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14292]
[  142.473432] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14292]
[  142.473432] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14292]
[  142.475622] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14293]
[  142.475645] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14293]
[  142.475711] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14293]
[  142.477913] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14293]
[  142.477936] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14293]
[  142.478055] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14293]
[  142.480263] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14293]
[  142.480286] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14293]
[  142.480404] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 -> i=
8042 (parameter) [14293]
[  142.482609] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14293]
[  142.482632] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14293]
[  142.482697] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14293]
[  142.484888] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14293]
[  142.484888] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14293]
[  142.484888] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [14293]
[  142.487084] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14294]
[  142.487107] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14294]
[  142.487173] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [14294]
[  142.489406] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14294]
[  142.490565] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [14294]
[  142.491727] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 40 <- i=
8042 (interrupt, 1, 12) [14294]
[  142.492879] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 06 <- i=
8042 (interrupt, 1, 12) [14294]
[  142.492902] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14294]
[  142.493021] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14294]
[  142.495209] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14295]
[  142.495209] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14295]
[  142.495209] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14295]
[  142.497382] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14295]
[  142.497382] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14295]
[  142.497382] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 -> i=
8042 (parameter) [14295]
[  142.499546] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14295]
[  142.499546] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14295]
[  142.499546] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14295]
[  142.501715] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14295]
[  142.501715] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14295]
[  142.501715] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14295]
[  142.503879] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14295]
[  142.503879] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14295]
[  142.503879] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14295]
[  142.506049] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14296]
[  142.506049] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14296]
[  142.506049] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [14296]
[  142.508214] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14296]
[  142.508214] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14296]
[  142.508214] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14296]
[  142.510386] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14296]
[  142.510386] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14296]
[  142.510386] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [14296]
[  142.512548] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14296]
[  142.512548] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14296]
[  142.512548] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (parameter) [14296]
[  142.514718] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14297]
[  142.514718] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14297]
[  142.514718] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 -> i=
8042 (parameter) [14297]
[  142.516885] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14297]
[  142.516885] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14297]
[  142.516885] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14297]
[  142.519058] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14297]
[  142.519058] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14297]
[  142.519058] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14297]
[  142.521229] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14297]
[  142.521229] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14297]
[  142.521229] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 03 -> i=
8042 (parameter) [14297]
[  142.523395] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14297]
[  142.523395] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14297]
[  142.523395] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14297]
[  142.525565] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14298]
[  142.525565] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14298]
[  142.525565] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [14298]
[  142.527730] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14298]
[  142.527730] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14298]
[  142.527730] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14298]
[  142.529901] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14298]
[  142.529901] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14298]
[  142.529901] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [14298]
[  142.532068] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14298]
[  142.532068] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14298]
[  142.532068] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14298]
[  142.534237] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14299]
[  142.534237] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14299]
[  142.534237] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [14299]
[  142.536402] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14299]
[  142.536402] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14299]
[  142.536402] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (parameter) [14299]
[  142.538574] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14299]
[  142.538574] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14299]
[  142.538574] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 -> i=
8042 (parameter) [14299]
[  142.540740] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14299]
[  142.540740] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14299]
[  142.540740] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [14299]
[  142.542909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14299]
[  142.542909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14299]
[  142.542909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 03 -> i=
8042 (parameter) [14299]
[  142.545075] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14300]
[  142.545075] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14300]
[  142.545075] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [14300]
[  142.547246] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14300]
[  142.547246] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [14300]
[  142.547246] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 -> i=
8042 (parameter) [14300]
[  142.549419] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [14300]
[  143.065658] PM: Finishing wakeup.
[  143.065664] Restarting tasks ... <6>usb 4-2: USB disconnect, address 4
[  143.066120] usb 4-2.3: USB disconnect, address 5
[  143.085259] done.
[  143.547515] hub 2-0:1.0: unable to enumerate USB device on port 6
[  143.767620] hub 4-0:1.0: unable to enumerate USB device on port 2
[  144.067562] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 7
[  144.237671] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14469]
[  144.237801] usb 4-2: configuration #1 chosen from 1 choice
[  144.240530] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [14469]
[  144.241639] hub 4-2:1.0: USB hub found
[  144.243721] hub 4-2:1.0: 3 ports detected
[  144.308248] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14476]
[  144.312891] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [14476]
[  144.357564] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[  144.357577] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[  144.357585] usb 4-2: Product: General Purpose USB Hub
[  144.369922] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14482]
[  144.374817] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [14482]
[  144.456459] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14490]
[  144.461806] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [14491]
[  144.600280] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 8
[  144.738502] usb 4-2.3: configuration #1 chosen from 1 choice
[  144.748502] scsi4 : SCSI emulation for USB Mass Storage devices
[  144.748502] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[  144.748502] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[  144.748502] usb 4-2.3: Product: USB Mass Storage Device
[  144.748502] usb 4-2.3: Manufacturer: Generic
[  144.748502] usb 4-2.3: SerialNumber: ABCDEF0123456789
[  144.748761] usb-storage: device found at 8
[  144.748771] usb-storage: waiting for device to settle before scanning
[  144.829531] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14527]
[  144.834847] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 0, 1) [14528]
[  144.914617] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14536]
[  144.919302] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c7 <- i=
8042 (interrupt, 0, 1) [14536]
[  145.054479] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14550]
[  145.059163] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14550]
[  145.299049] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14574]
[  145.304321] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14575]
[  145.334205] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14578]
[  145.338886] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14578]
[  145.368789] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14581]
[  145.373906] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14582]
[  145.403821] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14585]
[  145.408490] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14585]
[  145.438424] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14588]
[  145.443555] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14589]
[  145.473438] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14592]
[  145.478126] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14592]
[  145.508026] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14595]
[  145.513143] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [14596]
[  145.538661] b44: lan: Link is up at 100 Mbps, full duplex.
[  145.538671] b44: lan: Flow control is off for TX and off for RX.
[  145.568522] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14601]
[  145.573639] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cd <- i=
8042 (interrupt, 0, 1) [14602]
[  145.791901] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14624]
[  145.796786] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [14625]
[  145.876648] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14633]
[  145.881781] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cb <- i=
8042 (interrupt, 0, 1) [14633]
[  145.951852] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14640]
[  145.956674] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [14641]
[  146.041839] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [14649]
[  146.046652] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cb <- i=
8042 (interrupt, 0, 1) [14650]
[  146.106499] ata2.01: NODEV after polling detection
[  146.288499] ata2.00: ACPI cmd 03/42:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  146.289054] ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  146.293802] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0e <- i=
8042 (interrupt, 0, 1) [14674]
[  146.367940] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8e <- i=
8042 (interrupt, 0, 1) [14682]
[  146.488701] ata2.00: configured for UDMA/33
[  146.488739] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  146.488747] ata2: ACPI event
[  146.488824] ata2: soft resetting link
[  146.704691] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14715]
[  146.808547] ata2.01: NODEV after polling detection
[  146.949549] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14740]
[  146.984835] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14743]
[  147.020716] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14747]
[  147.056018] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14750]
[  147.090763] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14754]
[  147.125926] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [14757]
[  147.130694] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0b <- i=
8042 (interrupt, 0, 1) [14758]
[  147.195935] ata2.00: configured for UDMA/33
[  147.195962] ata2: EH complete
[  147.226909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8b <- i=
8042 (interrupt, 0, 1) [14767]
[  147.242250] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b6 <- i=
8042 (interrupt, 0, 1) [14768]
[  147.372238] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [14781]
[  149.752374] usb-storage: device scan complete
[  149.755816] scsi 4:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[  149.760360] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[  149.760831] sd 4:0:0:0: Attached scsi generic sg2 type 0

--MP_/jp6pj87ZmRXdLM6bFI=p=D8--
