Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYEWVER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYEWVER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYEWVD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:03:59 -0400
Received: from ppp-110-180.adsl.restena.lu ([158.64.110.180]:56350 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756277AbYEWVDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:03:52 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2008 17:03:50 EDT
Date: Fri, 23 May 2008 22:57:14 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080523225714.3f0953f3@neptune.home>
In-Reply-To: <20080523044430.GA9809@anvil.corenet.prv>
References: <200805162225.44284.bonbons@linux-vserver.org>
	<20080516163318.ZZRA012@mailhub.coreip.homeip.net>
	<200805162300.06027.bonbons@linux-vserver.org>
	<20080519114827.ZZRA012@mailhub.coreip.homeip.net>
	<20080519184501.38647a94@neptune.home>
	<20080521135345.ZZRA012@mailhub.coreip.homeip.net>
	<20080521220833.2e4345cb@neptune.home>
	<20080521163638.ZZRA012@mailhub.coreip.homeip.net>
	<20080523044430.GA9809@anvil.corenet.prv>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Ni_dBDXl96JRsToPB=22h5o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/Ni_dBDXl96JRsToPB=22h5o
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri, 23 May 2008 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > Ah, ok, great.. I think we simply need to move dritek out of the
> > place where you put it in so it does not interfere with our efforts
> > to resume keyboard and mouse ;) I will see what I can do there..
> > 
> 
> So what about the patch below? Does it work for you?
> 
> Thanks!

Hi Dmitry,

Yes, this patch works for me (in combination with
http://lkml.org/lkml/2008/5/16/430 ), see attached boot+suspend&resume
log.

You will eventually note the following lines during resume process:
...
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60 -> i8042 (command) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 0, 0) [15985]
[  150.588965] atkbd.c: Unknown key pressed (translated set 2, code 0x0 on isa0060/serio0).
[  150.588965] atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [15985]
[  150.609410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [15987]
...

This '00' interrupt for key code 0x0 also happens when loading acerhk
module (on freshly booted system).
There are no visible side-effects to it.

Bruno
--MP_/Ni_dBDXl96JRsToPB=22h5o
Content-Type: text/plain; name=input-suspend-debug11.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=input-suspend-debug11.log

[    0.000000] Linux version 2.6.25.4-orig (bruno@neptune) (gcc version 4.1=
.2 (Gentoo 4.1.2 p1.0.2)) #2 Fri May 23 22:05:50 CEST 2008
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
[    0.000000] Kernel command line: BOOT_IMAGE=3D2.6.25.4orig ro root=3D806=
 softlevel=3Ddefault video=3Dvesafb:1400x1050-32 lapic hpet=3Dforce
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=3Dc0464000 soft=3Dc0463000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1495.218 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.010000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.010000] Memory: 481688k/490368k available (2231k kernel code, 8180k =
reserved, 1002k data, 216k init, 0k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.010000]     vmalloc : 0xde800000 - 0xfffb3000   ( 535 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xddee0000   ( 478 MB)
[    0.010000]       .init : 0xc042a000 - 0xc0460000   ( 216 kB)
[    0.010000]       .data : 0xc032dd5e - 0xc04287d8   (1002 kB)
[    0.010000]       .text : 0xc0100000 - 0xc032dd5e   (2231 kB)
[    0.010000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1, Nodes=3D1
[    0.160002] Calibrating delay using timer specific routine.. 2991.74 Bog=
oMIPS (lpj=3D14958746)
[    0.160031] Security Framework initialized
[    0.160044] Capability LSM initialized
[    0.160054] Mount-cache hash table entries: 512
[    0.160212] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160220] CPU: L2 cache: 1024K
[    0.160226] Intel machine check architecture supported.
[    0.160234] Intel machine check reporting enabled on CPU#0.
[    0.160243] Compat vDSO mapped to ffffe000.
[    0.160251] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
[    0.160261] Checking 'hlt' instruction... OK.
[    0.200341] Freeing SMP alternatives: 0k freed
[    0.200347] ACPI: Core revision 20070126
[    0.212586] Parsing all Control Methods:
[    0.212722] Table [DSDT](id 0001) - 784 Objects with 54 Devices 203 Meth=
ods 19 Regions
[    0.212734]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[    0.212747] ACPI: setting ELCR to 0200 (from 0c00)
[    0.220004] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[    0.230000] khelper used greatest stack depth: 3444 bytes left
[    0.230000] net_namespace: 540 bytes
[    0.230000] Time: 22:09:20  Date: 05/23/08
[    0.230000] NET: Registered protocol family 16
[    0.230000] No dock devices found.
[    0.230000] ACPI: bus type pci registered
[    0.230000] PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=3D2
[    0.230000] PCI: Using configuration type 1
[    0.230000] Setting up standard PCI resources
[    0.238986] khelper used greatest stack depth: 3408 bytes left
[    0.239144] khelper used greatest stack depth: 3216 bytes left
[    0.240246] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GP=
E] 4 regs on int 0x9
[    0.240547] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 5 Wake, Ena=
bled 1 Runtime GPEs in this block
[    0.240563] ACPI: EC: Look up EC in DSDT
[    0.243676] Completing Region/Field/Buffer/Package initialization:......=
...................................................................
[    0.244906] Initialized 14/19 Regions 3/3 Fields 35/36 Buffers 21/28 Pac=
kages (793 nodes)
[    0.244918] Initializing Device/Processor/Thermal objects by executing _=
INI methods:..
[    0.245247] Executed 2 _INI methods requiring 1 _STA executions (examine=
d 58 objects)
[    0.245266] ACPI: Interpreter enabled
[    0.245272] ACPI: (supports S0 S3 S5)
[    0.245287] ACPI: Using PIC for interrupt routing
[    0.253752] ACPI: EC: GPE =3D 0x1d, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.253764] ACPI: EC: driver started in poll mode
[    0.253816] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.254268] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.254276] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 AC=
PI/GPIO/TCO
[    0.254287] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GP=
IO
[    0.254672] PCI: Transparent bridge - 0000:00:1e.0
[    0.254719] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.255064] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.259074] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.259224] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.259366] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[    0.259507] ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
[    0.259650] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
[    0.259791] ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
[    0.259934] ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
[    0.260103] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[    0.260269] ACPI: Power Resource [PFN0] (off)
[    0.260319] ACPI: Power Resource [PFN1] (off)
[    0.260454] ACPI: WMI: Mapper loaded
[    0.260461] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.260502] pnp: PnP ACPI init
[    0.260514] ACPI: bus type pnp registered
[    0.265629] pnp: PnP ACPI: found 9 devices
[    0.265638] ACPI: ACPI bus type pnp unregistered
[    0.265715] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.266210] SCSI subsystem initialized
[    0.266258] libata version 3.00 loaded.
[    0.266762] PCI: Using ACPI for IRQ routing
[    0.266772] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.272562] hpet clockevent registered
[    0.272569] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.272578] hpet0: 3 64-bit timers, 14318180 Hz
[    0.273632] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.273640] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.273648] system 00:04: ioport range 0x800-0x80f has been reserved
[    0.273656] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.273664] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.273671] system 00:04: ioport range 0x1c0-0x1cf has been reserved
[    0.273680] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.273687] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    0.273695] system 00:04: ioport range 0x610-0x61f has been reserved
[    0.273703] system 00:04: iomem range 0xfec10000-0xfec1ffff could not be=
 reserved
[    0.273713] system 00:04: iomem range 0xff800000-0xffbfffff could not be=
 reserved
[    0.273723] system 00:04: iomem range 0xfff00000-0xffffffff could not be=
 reserved
[    0.273732] system 00:04: iomem range 0x0-0x9ffff could not be reserved
[    0.273740] system 00:04: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.273748] system 00:04: iomem range 0x0-0x0 could not be reserved
[    0.304233] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.304241]   IO window: 0x00003000-0x000030ff
[    0.304248]   IO window: 0x00003400-0x000034ff
[    0.304256]   PREFETCH window: 0x30000000-0x33ffffff
[    0.304264]   MEM window: 0x3c000000-0x3fffffff
[    0.304271] PCI: Bus 7, cardbus bridge: 0000:02:06.1
[    0.304277]   IO window: 0x00003800-0x000038ff
[    0.304285]   IO window: 0x00003c00-0x00003cff
[    0.304292]   PREFETCH window: 0x34000000-0x37ffffff
[    0.304300]   MEM window: 0x40000000-0x43ffffff
[    0.304308] PCI: Bridge: 0000:00:1e.0
[    0.304314]   IO window: 3000-3fff
[    0.304321]   MEM window: 0xe0200000-0xe07fffff
[    0.304329]   PREFETCH window: 0x0000000030000000-0x0000000037ffffff
[    0.304348] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.304624] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.304632] PCI: setting IRQ 10 as level-triggered
[    0.304636] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.304659] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.304682] NET: Registered protocol family 2
[    0.304785] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[    0.305017] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[    0.305166] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.305237] TCP: Hash tables configured (established 16384 bind 16384)
[    0.305246] TCP reno registered
[    0.305398] Simple Boot Flag at 0x37 set to 0x1
[    0.305460] Machine check exception polling timer started.
[    0.307943] khelper used greatest stack depth: 3208 bytes left
[    0.308453] io scheduler noop registered
[    0.308476] io scheduler cfq registered (default)
[    0.308495] pci 0000:00:02.0: Boot video device
[    0.308795] vesafb: framebuffer at 0xe8000000, mapped to 0xde880000, usi=
ng 5120k, total 32576k
[    0.308807] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D11
[    0.308814] vesafb: scrolling: redraw
[    0.308820] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.343307] Console: switching to colour frame buffer device 160x64
[    0.375274] fb0: VESA VGA frame buffer device
[    0.376121] ACPI: AC Adapter [ACAD] (on-line)
[    0.376774] ACPI: Battery Slot [BAT1] (battery absent)
[    0.377385] ACPI: Battery Slot [BAT2] (battery absent)
[    0.377707] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    0.378018] ACPI: Power Button (FF) [PWRF]
[    0.378257] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[    0.378972] ACPI: Lid Switch [LID]
[    0.379179] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0E:00/input/input2
[    0.379519] ACPI: Sleep Button (CM) [SLPB]
[    0.379860] ACPI: Transitioning device [FAN0] to D3
[    0.380000] ACPI: PNP0C0B:00 is registered as cooling_device0
[    0.380004] ACPI: Fan [FAN0] (off)
[    0.380274] ACPI: Transitioning device [FAN1] to D3
[    0.380505] ACPI: PNP0C0B:01 is registered as cooling_device1
[    0.380734] ACPI: Fan [FAN1] (off)
[    0.381241] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:0=
0/device:02/input/input3
[    0.381590] ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: n=
o)
[    0.382067] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.382360] ACPI: ACPI0007:00 is registered as cooling_device2
[    0.383426] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.384092] ACPI: Thermal Zone [THRM] (43 C)
[    0.384300] isapnp: Scanning for PnP cards...
[    0.695096] isapnp: No Plug & Play device found
[    0.698083] intel_rng: FWH not detected
[    0.698249] Linux agpgart interface v0.103
[    0.698430] agpgart: Detected an Intel 855GM Chipset.
[    0.699381] agpgart: Detected 32636K stolen memory.
[    0.706765] agpgart: AGP aperture is 128M @ 0xe8000000
[    0.707077] [drm] Initialized drm 1.1.0 20060810
[    0.707558] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.707788] PCI: setting IRQ 11 as level-triggered
[    0.707792] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    0.708155] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.708244] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.708476] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    0.708552] [drm] Initialized i915 1.6.0 20060119 on minor 1
[    0.710054] acer-wmi: Acer Laptop ACPI-WMI Extras version 0.1
[    0.720024] acer-wmi: No or unsupported WMI interface, unable to load
[    0.730042] Driver 'sd' needs updating - please use bus_type methods
[    0.740044] ata_piix 0000:00:1f.1: version 2.12
[    0.740051] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[    0.750009] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.760028] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.760115] scsi0 : ata_piix
[    0.770070] scsi1 : ata_piix
[    0.780008] Switched to high resolution mode on CPU 0
[    0.781436] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    0.790003] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    0.980240] ata1.00: ATA-6: FUJITSU MHT2060AH, 006C, max UDMA/100
[    0.980243] ata1.00: 117210240 sectors, multi 16: LBA=20
[    1.038736] ata1.00: configured for UDMA/100
[    1.378002] ata2.01: NODEV after polling detection
[    1.567742] ata2.00: ATAPI: UJDA740 DVD/CDRW, 1.20, max UDMA/33
[    1.786453] ata2.00: configured for UDMA/33
[    1.786582] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 00=
6C PQ: 0 ANSI: 5
[    1.796577] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.806469] sd 0:0:0:0: [sda] Write Protect is off
[    1.816456] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.816478] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.826510] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.836465] sd 0:0:0:0: [sda] Write Protect is off
[    1.846455] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.846476] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.856455]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    2.028362] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.042465] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA740 DVD/CDRW 1.=
20 PQ: 0 ANSI: 5
[    2.048119] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64=
 irq 1,12
[    2.059283] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.067893] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.078041] mice: PS/2 mouse device common for all mice
[    2.131114] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input4
[    2.137696] cpuidle: using governor ladder
[    2.141428] cpuidle: using governor menu
[    2.151698] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.161145] TCP cubic registered
[    2.171132] NET: Registered protocol family 1
[    2.181344] NET: Registered protocol family 10
[    2.191718] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.201133] NET: Registered protocol family 17
[    2.211286] Using IPI Shortcut mode
[    2.221426]   Magic number: 8:672:199
[    2.235565] Marking TSC unstable due to: TSC halts in idle.
[    2.742249] Clocksource tsc unstable (delta =3D -492813475 ns)
[    2.795703] Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0=
x904713/0x4006
[    2.835494] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input5
[    2.884025] ReiserFS: sda6: found reiserfs format "3.6" with standard jo=
urnal
[    2.884037] ReiserFS: sda6: using ordered data mode
[    2.907252] ReiserFS: sda6: journal params: device sda6, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    2.908051] ReiserFS: sda6: checking transaction log (sda6)
[    2.947127] ReiserFS: sda6: Using r5 hash to sort names
[    2.947211] VFS: Mounted root (reiserfs filesystem) readonly.
[    2.957402] Freeing unused kernel memory: 216k freed
[    2.987185] khelper used greatest stack depth: 2144 bytes left
[    3.851941] cat used greatest stack depth: 1772 bytes left
[    3.943270] init-early.sh used greatest stack depth: 1136 bytes left
[    5.212639] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.212665] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.231804] usbcore: registered new interface driver usbfs
[    5.231834] usbcore: registered new interface driver hub
[    5.231884] usbcore: registered new device driver usb
[    5.263828] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.263835] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.266407] USB Universal Host Controller Interface driver v3.0
[    5.266467] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    5.266477] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.266481] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.266741] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 1
[    5.266767] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
[    5.266915] usb usb1: configuration #1 chosen from 1 choice
[    5.266942] hub 1-0:1.0: USB hub found
[    5.266949] hub 1-0:1.0: 2 ports detected
[    5.329874] Driver 'sr' needs updating - please use bus_type methods
[    5.337062] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    5.337070] Uniform CD-ROM driver Revision: 3.20
[    5.337147] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.373851] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.373856] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.373860] usb usb1: Product: UHCI Host Controller
[    5.373862] usb usb1: Manufacturer: Linux 2.6.25.4-orig uhci_hcd
[    5.373865] usb usb1: SerialNumber: 0000:00:1d.0
[    5.374244] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.374248] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.374499] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    5.374502] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[    5.374518] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.374522] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.374556] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    5.378469] ehci_hcd 0000:00:1d.7: debug port 1
[    5.378475] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[    5.378485] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
[    5.396860] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    5.397026] usb usb2: configuration #1 chosen from 1 choice
[    5.397056] hub 2-0:1.0: USB hub found
[    5.397067] hub 2-0:1.0: 6 ports detected
[    5.494017] ssb: Sonics Silicon Backplane found on PCI device 0000:02:02=
.0
[    5.494053] b44.c:v2.0
[    5.503926] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.503932] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.503936] usb usb2: Product: EHCI Host Controller
[    5.503939] usb usb2: Manufacturer: Linux 2.6.25.4-orig ehci_hcd
[    5.503941] usb usb2: SerialNumber: 0000:00:1d.7
[    5.503989] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.504003] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    5.504008] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.504036] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[    5.504062] uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
[    5.504198] usb usb3: configuration #1 chosen from 1 choice
[    5.504226] hub 3-0:1.0: USB hub found
[    5.504234] hub 3-0:1.0: 2 ports detected
[    5.534427] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:2d:03=
:9d
[    5.585007] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.613844] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.613850] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.613854] usb usb3: Product: UHCI Host Controller
[    5.613856] usb usb3: Manufacturer: Linux 2.6.25.4-orig uhci_hcd
[    5.613859] usb usb3: SerialNumber: 0000:00:1d.1
[    5.613922] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    5.613936] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    5.613941] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.613971] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[    5.613998] uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
[    5.614130] usb usb4: configuration #1 chosen from 1 choice
[    5.614158] hub 4-0:1.0: USB hub found
[    5.614166] hub 4-0:1.0: 2 ports detected
[    5.724196] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.724202] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.724205] usb usb4: Product: UHCI Host Controller
[    5.724208] usb usb4: Manufacturer: Linux 2.6.25.4-orig uhci_hcd
[    5.724210] usb usb4: SerialNumber: 0000:00:1d.2
[    5.724659] ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.758746] udev: renamed network interface eth0 to lan
[    5.783876] hub 2-0:1.0: unable to enumerate USB device on port 6
[    5.820954] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI versi=
on 1.10
[    5.821126] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.821146] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[    5.841723] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.841749] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    6.061077] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 2
[    6.082885] NET: Registered protocol family 23
[    6.135398] nsc-ircc, chip->init
[    6.135413] nsc-ircc, Found chip at base=3D0x04e
[    6.135442] nsc-ircc, driver loaded (Dag Brattli)
[    6.136900] IrDA: Registered device irda0
[    6.136963] nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
[    6.254365] usb 4-2: configuration #1 chosen from 1 choice
[    6.260197] hub 4-2:1.0: USB hub found
[    6.261192] hub 4-2:1.0: 3 ports detected
[    6.321072] firewire_core: created device fw0: GUID 00c09f00000fc03c, S4=
00
[    6.373235] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[    6.373244] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    6.373252] usb 4-2: Product: General Purpose USB Hub
[    6.612078] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 3
[    6.690866] intel8x0_measure_ac97_clock: measured 59411 usecs
[    6.690873] intel8x0: clocking to 48000
[    6.744978] usb 4-2.3: configuration #1 chosen from 1 choice
[    6.744978] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[    6.744978] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    6.744978] usb 4-2.3: Product: USB Mass Storage Device
[    6.744978] usb 4-2.3: Manufacturer: Generic
[    6.744978] usb 4-2.3: SerialNumber: ABCDEF0123456789
[    6.785653] Initializing USB Mass Storage driver...
[    6.786104] scsi2 : SCSI emulation for USB Mass Storage devices
[    6.790675] usbcore: registered new interface driver usb-storage
[    6.790684] USB Mass Storage support registered.
[    6.792294] usb-storage: device found at 3
[    6.792300] usb-storage: waiting for device to settle before scanning
[   11.575995] usb-storage: device scan complete
[   11.578906] scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[   11.590978] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   11.591073] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   16.223852] SGI XFS with ACLs, no debug enabled
[   16.227270] SGI XFS Quota Management subsystem
[   16.273272] XFS mounting filesystem sda9
[   16.384618] Ending clean XFS mount for filesystem: sda9
[   16.399497] ReiserFS: sda10: found reiserfs format "3.6" with standard j=
ournal
[   16.399524] ReiserFS: sda10: using ordered data mode
[   16.412242] ReiserFS: sda10: journal params: device sda10, size 8192, jo=
urnal first block 18, max trans len 1024, max batch 900, max commit age 30,=
 max trans age 30
[   16.412242] ReiserFS: sda10: checking transaction log (sda10)
[   16.455068] ReiserFS: sda10: Using r5 hash to sort names
[   16.484518] ReiserFS: sda7: found reiserfs format "3.6" with standard jo=
urnal
[   16.484518] ReiserFS: sda7: using ordered data mode
[   16.493845] ReiserFS: sda7: journal params: device sda7, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   16.493845] ReiserFS: sda7: checking transaction log (sda7)
[   16.548672] ReiserFS: sda7: Using r5 hash to sort names
[   16.586594] ReiserFS: sda8: found reiserfs format "3.6" with standard jo=
urnal
[   16.586618] ReiserFS: sda8: using ordered data mode
[   16.601857] ReiserFS: sda8: journal params: device sda8, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   16.601857] ReiserFS: sda8: checking transaction log (sda8)
[   16.644564] ReiserFS: sda8: Using r5 hash to sort names
[   18.557792] ADDRCONF(NETDEV_UP): lan: link is not ready
[   18.814347] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   18.814347] All bugs added by David S. Miller <davem@redhat.com>
[   18.862623] ADDRCONF(NETDEV_UP): lan.658: link is not ready
[   19.143404] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 ac=
ross:1004020k
[   22.080398] b44: lan: Link is up at 100 Mbps, full duplex.
[   22.080410] b44: lan: Flow control is off for TX and off for RX.
[   22.080887] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[   22.081909] ADDRCONF(NETDEV_CHANGE): lan.658: link becomes ready
[   30.942974] RPC: Registered udp transport module.
[   30.942987] RPC: Registered tcp transport module.
[   31.143389] mount.nfs used greatest stack depth: 908 bytes left
[   31.275022] loop: module loaded
[   31.326690] squashfs: version 3.3 (2007/10/31) Phillip Lougher
[   32.367131] lan.658: no IPv6 routers present
[  113.620185] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9c=
 <- i8042 (interrupt, 0, 1) [11291]
[  114.714204] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11400]
[  114.719224] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 0, 1) [11401]
[  114.783417] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11407]
[  114.788476] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c8=
 <- i8042 (interrupt, 0, 1) [11408]
[  115.128212] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11442]
[  115.132747] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 0, 1) [11442]
[  115.207731] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11450]
[  115.212261] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c7=
 <- i8042 (interrupt, 0, 1) [11450]
[  116.781406] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11607]
[  116.786458] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 0, 1) [11608]
[  116.863062] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11616]
[  116.867658] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c8=
 <- i8042 (interrupt, 0, 1) [11616]
[  117.157461] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11645]
[  117.162647] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 0, 1) [11646]
[  117.227150] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11652]
[  117.232187] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c7=
 <- i8042 (interrupt, 0, 1) [11653]
[  118.166411] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11746]
[  118.171451] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 53=
 <- i8042 (interrupt, 0, 1) [11747]
[  118.231835] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [11753]
[  118.236856] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d3=
 <- i8042 (interrupt, 0, 1) [11754]
[  125.737582] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1c=
 <- i8042 (interrupt, 0, 1) [12505]
[  125.751861] PM: Syncing filesystems ... done.
[  125.757749] PM: Preparing system for mem sleep
[  125.800907] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[  125.801189] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  125.801292] PM: Entering mem sleep
[  125.801297] Suspending console(s)
[  125.817690] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9c=
 <- i8042 (interrupt, 0, 1) [12513]
[  125.841109] b44: lan: powering down PHY
[  125.861102] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12518]
[  125.861164] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f5=
 -> i8042 (parameter) [12518]
[  125.863460] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12518]
[  125.863481] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12518]
[  125.863542] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [12518]
[  125.865837] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12518]
[  125.865855] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12518]
[  125.865916] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [12518]
[  125.868211] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12518]
[  125.868229] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12518]
[  125.868290] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [12518]
[  125.870578] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12518]
[  125.870596] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12518]
[  125.870657] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [12518]
[  125.872942] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12519]
[  125.872942] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12519]
[  125.872942] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [12519]
[  125.875206] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12519]
[  125.875206] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12519]
[  125.875206] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [12519]
[  125.877478] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12519]
[  125.877478] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12519]
[  125.877478] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [12519]
[  125.879744] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12519]
[  125.879744] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12519]
[  125.879744] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [12519]
[  125.882017] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12520]
[  125.882017] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12520]
[  125.882017] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [12520]
[  125.884281] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12520]
[  125.884281] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12520]
[  125.884281] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (parameter) [12520]
[  125.886554] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12520]
[  125.886554] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12520]
[  125.886554] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 -> i8042 (parameter) [12520]
[  125.888823] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12520]
[  125.888823] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12520]
[  125.888823] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ff=
 -> i8042 (parameter) [12520]
[  125.891096] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12521]
[  126.270859] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (interrupt, 1, 12) [12559]
[  126.272160] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [12559]
[  126.272160] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [12559]
[  126.272160] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f4=
 -> i8042 (parameter) [12559]
[  126.274427] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [12559]
[  126.274427] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ff=
 -> i8042 (kbd-data) [12559]
[  126.277309] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [12559]
[  126.386636] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (interrupt, 0, 1) [12570]
[  126.478996] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [12580]
[  126.479057] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 -> i8042 (parameter) [12580]
[  126.479074] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  126.479529] sd 0:0:0:0: [sda] Stopping disk
[  127.499318] drm_sysfs_suspend
[  127.516827] drm_sysfs_suspend
[  127.517645] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[  127.537264] nsc-ircc 00:08: disabled
[  127.556905] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[  127.557068] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[  127.576936] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[  127.577047] ACPI: Cannot set device to a higher-powered state than parent
[  127.577100] ACPI: Cannot set device to a higher-powered state than parent
[  127.577154] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[  127.577255] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  127.596737] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  127.596770] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  127.596804] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  127.605429] ACPI: Preparing to enter system sleep state S3
[  127.606836] ACPI: EC: missing OBF confirmation, don't expect it any long=
er.
[  127.618403] cpufreq: suspend failed to assert current frequency is what =
timing core thinks it is.
[  127.618652]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[  127.618652] Intel machine check architecture supported.
[  127.618673] Intel machine check reporting enabled on CPU#0.
[  127.618775] Back to C!
[  127.618789] cpufreq: resume failed to assert current frequency is what t=
iming core thinks it is.
[  127.619190] Force enabled HPET at resume
[  127.631781] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 100, writing 10b)
[  127.631803] PM: Writing back config space on device 0000:00:02.0 at offs=
et 6 (was 1, writing 1801)
[  127.631814] PM: Writing back config space on device 0000:00:02.0 at offs=
et 5 (was 0, writing e0000000)
[  127.631824] PM: Writing back config space on device 0000:00:02.0 at offs=
et 4 (was 8, writing e8000008)
[  127.631837] PM: Writing back config space on device 0000:00:02.0 at offs=
et 1 (was 900000, writing 900003)
[  127.638432] PM: Writing back config space on device 0000:00:02.1 at offs=
et 5 (was 0, writing e0080000)
[  127.638432] PM: Writing back config space on device 0000:00:02.1 at offs=
et 4 (was 8, writing f0000008)
[  127.638432] PM: Writing back config space on device 0000:00:02.1 at offs=
et 1 (was 900000, writing 900003)
[  127.638432] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[  127.638432] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  127.638432] usb usb1: root hub lost power or was reset
[  127.638432] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[  127.638432] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  127.638432] usb usb3: root hub lost power or was reset
[  127.638432] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  127.638432] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  127.638432] usb usb4: root hub lost power or was reset
[  128.189353] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[  128.189353] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  128.189353] PM: Writing back config space on device 0000:00:1d.7 at offs=
et 1 (was 2900006, writing 2900106)
[  128.189353] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 9 (was fff0, writing 37f03000)
[  128.189353] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 1 (was 80800105, writing 80800107)
[  128.189353] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  128.189353] PM: Writing back config space on device 0000:00:1f.1 at offs=
et f (was 100, writing 1ff)
[  128.189353] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 9 (was 0, writing 38000000)
[  128.189353] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 1 (was 2800005, writing 2800007)
[  128.189353] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  128.189353] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[  128.189353] ata2.01: _GTF evaluation failed (AE 0x1001)
[  128.189353] ata1.01: _GTF evaluation failed (AE 0x1001)
[  128.189353] PM: Writing back config space on device 0000:00:1f.5 at offs=
et f (was 200, writing 20a)
[  128.189353] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 7 (was 0, writing e0100800)
[  128.189353] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 6 (was 0, writing e0100c00)
[  128.189353] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 5 (was 1301, writing 18c1)
[  128.189353] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 4 (was 1201, writing 1c01)
[  128.189353] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 1 (was 2900005, writing 2900003)
[  128.189353] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[  128.189353] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[  137.443623] ata2.01: failed to IDENTIFY (I/O error, err_mask=3D0x40)
[  137.443631] ata2: failed to recover some devices, retrying in 5 secs
[  138.045454] PM: Writing back config space on device 0000:00:1f.6 at offs=
et f (was 200, writing 20a)
[  138.045454] PM: Writing back config space on device 0000:00:1f.6 at offs=
et 1 (was 2900005, writing 2900001)
[  138.045454] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[  138.045454] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[  138.047902] ata1.00: ACPI cmd 03/45:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  138.050394] ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  138.935326] ata1.00: configured for UDMA/100
[  138.935427] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[  138.935465] sd 0:0:0:0: [sda] Write Protect is off
[  138.935472] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  138.935525] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  140.135322] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[  140.135322] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[  140.135322] PM: Writing back config space on device 0000:02:02.0 at offs=
et f (was 100, writing 10b)
[  140.135322] PM: Writing back config space on device 0000:02:02.0 at offs=
et 4 (was 0, writing e0204000)
[  140.135322] PM: Writing back config space on device 0000:02:02.0 at offs=
et 3 (was 0, writing 4000)
[  140.135322] PM: Writing back config space on device 0000:02:02.0 at offs=
et 1 (was 100002, writing 100106)
[  140.135322] PM: Writing back config space on device 0000:02:04.0 at offs=
et f (was 22020100, writing 2202010b)
[  140.135322] PM: Writing back config space on device 0000:02:04.0 at offs=
et 4 (was 0, writing e0206000)
[  140.135322] PM: Writing back config space on device 0000:02:04.0 at offs=
et 3 (was 0, writing 4008)
[  140.135322] PM: Writing back config space on device 0000:02:04.0 at offs=
et 1 (was 2900000, writing 2900116)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et e (was 1, writing 34fd)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et d (was 1, writing 3401)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et c (was 1, writing 30fd)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et b (was 1, writing 3001)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et a (was 0, writing 3ffff000)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et 9 (was 0, writing 3c000000)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et 8 (was 0, writing 33fff000)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et 7 (was 0, writing 30000000)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et 6 (was 40000000, writing b0060302)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et 4 (was 0, writing e0207000)
[  140.135322] PM: Writing back config space on device 0000:02:06.0 at offs=
et 1 (was 4100087, writing 4100187)
[  140.135322] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et f (was 100, writing 18001ff)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et e (was 1, writing 3cfd)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et d (was 1, writing 3c01)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et c (was 1, writing 38fd)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et b (was 1, writing 3801)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et a (was 0, writing 43fff000)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 9 (was 0, writing 40000000)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 8 (was 0, writing 37fff000)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 7 (was 0, writing 34000000)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 6 (was 0, writing b00a0702)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 4 (was 0, writing e0208000)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 3 (was 820000, writing 824000)
[  140.135322] PM: Writing back config space on device 0000:02:06.1 at offs=
et 1 (was 4100080, writing 4100107)
[  140.135322] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  144.093467] PM: Writing back config space on device 0000:02:07.0 at offs=
et f (was 4020100, writing 402010a)
[  144.093467] PM: Writing back config space on device 0000:02:07.0 at offs=
et 5 (was 0, writing e0200000)
[  144.093467] PM: Writing back config space on device 0000:02:07.0 at offs=
et 4 (was 0, writing e0209000)
[  144.093467] PM: Writing back config space on device 0000:02:07.0 at offs=
et 3 (was 0, writing 4008)
[  144.093467] PM: Writing back config space on device 0000:02:07.0 at offs=
et 1 (was 2100002, writing 2100116)
[  145.050995] ata2.01: NODEV after polling detection
[  145.850701] nsc-ircc 00:08: activated
[  146.918246] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[  146.918246] ata2.00: ACPI cmd 03/42:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  146.918597] ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  150.254406] sd 0:0:0:0: [sda] Starting disk
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (flush, aux) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 74=
 -> i8042 (parameter) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 59=
 -> i8042 (command) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 90=
 -> i8042 (parameter) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 56=
 -> i8042 (parameter) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 -> i8042 (parameter) [15985]
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 0, 0) [15985]
[  150.588965] atkbd.c: Unknown key pressed (translated set 2, code 0x0 on =
isa0060/serio0).
[  150.588965] atkbd.c: Use 'setkeycodes 00 <keycode>' to make it known.
[  150.588965] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f2=
 -> i8042 (kbd-data) [15985]
[  150.609410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15987]
[  150.609410] ata2.00: configured for UDMA/33
[  150.609410] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  150.609410] ata2: ACPI event
[  150.609410] ata2: soft resetting link
[  150.609913] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [15987]
[  150.614239] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ab=
 <- i8042 (interrupt, 0, 1) [15987]
[  150.619513] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 41=
 <- i8042 (interrupt, 0, 1) [15988]
[  150.619513] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ed=
 -> i8042 (kbd-data) [15988]
[  150.622222] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15988]
[  150.622222] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [15988]
[  150.624976] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15988]
[  150.624976] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (kbd-data) [15988]
[  150.627887] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15989]
[  150.627887] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [15989]
[  150.630599] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15989]
[  150.630599] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f4=
 -> i8042 (kbd-data) [15989]
[  150.633722] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15989]
[  150.633722] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (kbd-data) [15989]
[  150.636432] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15990]
[  150.636432] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [15990]
[  150.639328] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15990]
[  150.639328] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ed=
 -> i8042 (kbd-data) [15990]
[  150.642038] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15990]
[  150.642038] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [15990]
[  150.645212] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [15991]
[  150.645212] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15991]
[  150.645212] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [15991]
[  150.647390] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15991]
[  150.647390] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15991]
[  150.647390] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [15991]
[  150.649588] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15993]
[  150.649611] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15993]
[  150.649730] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [15993]
[  150.651940] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15993]
[  150.651962] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15993]
[  150.652080] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [15993]
[  150.654284] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15993]
[  150.654306] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15993]
[  150.654372] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [15993]
[  150.656582] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15994]
[  150.656604] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15994]
[  150.656723] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [15994]
[  150.658906] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15994]
[  150.658906] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15994]
[  150.658906] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [15994]
[  150.661078] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15994]
[  150.661078] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15994]
[  150.661078] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [15994]
[  150.663246] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15994]
[  150.663246] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15994]
[  150.663246] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [15994]
[  150.665443] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15995]
[  150.666565] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 08=
 <- i8042 (interrupt, 1, 12) [15995]
[  150.667681] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 1, 12) [15995]
[  150.668800] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 15=
 <- i8042 (interrupt, 1, 12) [15995]
[  150.668800] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [15995]
[  150.668800] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ff=
 -> i8042 (parameter) [15995]
[  150.670978] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [15995]
[  151.051507] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (interrupt, 1, 12) [16033]
[  151.051507] ata2.01: NODEV after polling detection
[  151.052974] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [16033]
[  151.052974] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16033]
[  151.052974] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16033]
[  151.055147] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16034]
[  151.055147] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16034]
[  151.055147] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16034]
[  151.057319] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16034]
[  151.057319] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16034]
[  151.057319] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16034]
[  151.059486] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16034]
[  151.059486] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16034]
[  151.059486] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16034]
[  151.061661] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16034]
[  151.061661] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16034]
[  151.061661] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16034]
[  151.063828] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16035]
[  151.063828] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16035]
[  151.063828] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16035]
[  151.066004] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16035]
[  151.066004] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16035]
[  151.066004] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16035]
[  151.068171] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16035]
[  151.068171] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16035]
[  151.068171] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16035]
[  151.070344] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16035]
[  151.070344] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16035]
[  151.070344] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16035]
[  151.072510] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16035]
[  151.072510] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16035]
[  151.072510] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [16035]
[  151.074708] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16036]
[  151.075827] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 08=
 <- i8042 (interrupt, 1, 12) [16036]
[  151.076943] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 1, 12) [16036]
[  151.078061] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 15=
 <- i8042 (interrupt, 1, 12) [16036]
[  151.078061] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16036]
[  151.078061] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16036]
[  151.080236] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16036]
[  151.080236] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16036]
[  151.080236] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16036]
[  151.082410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16036]
[  151.082410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16036]
[  151.082410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16036]
[  151.084576] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16037]
[  151.084576] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16037]
[  151.084576] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16037]
[  151.086750] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16037]
[  151.086750] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16037]
[  151.086750] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16037]
[  151.088915] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16037]
[  151.088915] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16037]
[  151.088915] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16037]
[  151.091090] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16037]
[  151.091090] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16037]
[  151.091090] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16037]
[  151.093259] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16038]
[  151.093259] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16038]
[  151.093259] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16038]
[  151.095433] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16038]
[  151.095433] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16038]
[  151.095433] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 03=
 -> i8042 (parameter) [16038]
[  151.097600] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16038]
[  151.097600] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16038]
[  151.097600] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [16038]
[  151.099796] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16038]
[  151.100912] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9d=
 <- i8042 (interrupt, 1, 12) [16038]
[  151.102028] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 1, 12) [16038]
[  151.103146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b1=
 <- i8042 (interrupt, 1, 12) [16039]
[  151.103146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16039]
[  151.103146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16039]
[  151.105320] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16039]
[  151.105320] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16039]
[  151.105320] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16039]
[  151.107495] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16039]
[  151.107495] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16039]
[  151.107495] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16039]
[  151.109662] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16039]
[  151.109662] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16039]
[  151.109662] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16039]
[  151.111835] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16039]
[  151.111835] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16039]
[  151.111835] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16039]
[  151.114002] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16040]
[  151.114002] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16040]
[  151.114002] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16040]
[  151.116174] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16040]
[  151.116174] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16040]
[  151.116174] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16040]
[  151.118341] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16040]
[  151.118341] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16040]
[  151.118341] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16040]
[  151.120514] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16040]
[  151.120514] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16040]
[  151.120514] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 02=
 -> i8042 (parameter) [16040]
[  151.122680] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16041]
[  151.122680] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16041]
[  151.122680] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [16041]
[  151.124877] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16041]
[  151.126008] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 90=
 <- i8042 (interrupt, 1, 12) [16041]
[  151.127124] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 1, 12) [16041]
[  151.128243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 13=
 <- i8042 (interrupt, 1, 12) [16041]
[  151.128243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16041]
[  151.128243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16041]
[  151.130417] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16041]
[  151.130417] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16041]
[  151.130417] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16041]
[  151.132592] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16042]
[  151.132592] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16042]
[  151.132592] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16042]
[  151.134756] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16042]
[  151.134756] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16042]
[  151.134756] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16042]
[  151.136931] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16042]
[  151.136931] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16042]
[  151.136931] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16042]
[  151.139100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16042]
[  151.139100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16042]
[  151.139100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16042]
[  151.141274] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16043]
[  151.141274] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16043]
[  151.141274] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 02=
 -> i8042 (parameter) [16043]
[  151.143441] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16043]
[  151.143441] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16043]
[  151.143441] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16043]
[  151.145614] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16043]
[  151.145614] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16043]
[  151.145614] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [16043]
[  151.147782] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16043]
[  151.147782] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16043]
[  151.147782] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [16043]
[  151.149978] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16043]
[  151.151097] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [16043]
[  151.152243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 40=
 <- i8042 (interrupt, 1, 12) [16044]
[  151.153399] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 06=
 <- i8042 (interrupt, 1, 12) [16044]
[  151.153422] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16044]
[  151.153541] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16044]
[  151.155751] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16044]
[  151.155773] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16044]
[  151.155892] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16044]
[  151.158103] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16044]
[  151.158124] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16044]
[  151.158190] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 02=
 -> i8042 (parameter) [16044]
[  151.160396] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16044]
[  151.160418] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16044]
[  151.160537] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16044]
[  151.162727] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16045]
[  151.162727] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16045]
[  151.162727] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16045]
[  151.164896] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16045]
[  151.164896] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16045]
[  151.164896] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16045]
[  151.167070] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16045]
[  151.167070] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16045]
[  151.167070] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [16045]
[  151.169236] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16045]
[  151.169236] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16045]
[  151.169236] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16045]
[  151.171410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16046]
[  151.171410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16046]
[  151.171410] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [16046]
[  151.173577] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16046]
[  151.173577] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16046]
[  151.173577] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (parameter) [16046]
[  151.175753] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16046]
[  151.175753] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16046]
[  151.175753] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 -> i8042 (parameter) [16046]
[  151.177924] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16046]
[  151.177924] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16046]
[  151.177924] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16046]
[  151.180100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16046]
[  151.180100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16046]
[  151.180100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16046]
[  151.182274] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16047]
[  151.182274] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16047]
[  151.182274] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 03=
 -> i8042 (parameter) [16047]
[  151.184442] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16047]
[  151.184442] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16047]
[  151.184442] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16047]
[  151.186617] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16047]
[  151.186617] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16047]
[  151.186617] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [16047]
[  151.188786] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16047]
[  151.188786] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16047]
[  151.188786] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16047]
[  151.190957] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16048]
[  151.190957] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16048]
[  151.190957] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [16048]
[  151.193124] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16048]
[  151.193124] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16048]
[  151.193124] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16048]
[  151.195295] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16048]
[  151.195295] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16048]
[  151.195295] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [16048]
[  151.197465] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16048]
[  151.197465] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16048]
[  151.197465] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (parameter) [16048]
[  151.199640] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16048]
[  151.199640] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16048]
[  151.199640] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 -> i8042 (parameter) [16048]
[  151.201809] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16048]
[  151.201809] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16048]
[  151.201809] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [16048]
[  151.204125] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16049]
[  151.204147] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16049]
[  151.204213] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 03=
 -> i8042 (parameter) [16049]
[  151.206417] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16049]
[  151.206440] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16049]
[  151.206558] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [16049]
[  151.208769] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16049]
[  151.208791] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [16049]
[  151.208857] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f4=
 -> i8042 (parameter) [16049]
[  151.211068] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [16050]
[  158.314832] ata2.00: configured for UDMA/33
[  158.314832] ata2: EH complete
[  163.477493] b44: lan: Link is up at 100 Mbps, full duplex.
[  163.477499] b44: lan: Flow control is off for TX and off for RX.
[  164.506591] PM: Finishing wakeup.
[  164.506591] Restarting tasks ... <6>usb 4-2: USB disconnect, address 2
[  164.506591] usb 4-2.3: USB disconnect, address 3
[  164.526591] done.
[  173.571286] hub 2-0:1.0: unable to enumerate USB device on port 6
[  180.513125] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 4
[  181.479674] hub 4-0:1.0: unable to enumerate USB device on port 2
[  185.504770] hub 4-0:1.0: unable to enumerate USB device on port 2
[  192.454246] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 6
[  194.507400] usb 4-2: configuration #1 chosen from 1 choice
[  194.511837] hub 4-2:1.0: USB hub found
[  194.511837] hub 4-2:1.0: 3 ports detected
[  195.469774] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[  195.469788] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[  195.469796] usb 4-2: Product: General Purpose USB Hub
[  198.713643] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20785]
[  198.719384] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 0, 1) [20807]
[  198.804613] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20807]
[  198.810048] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c8=
 <- i8042 (interrupt, 0, 1) [20816]
[  198.950065] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20821]
[  198.952011] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 7
[  198.955088] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 0, 1) [20831]
[  199.032722] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20834]
[  199.037533] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c8=
 <- i8042 (interrupt, 0, 1) [20839]
[  199.367755] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20847]
[  199.373120] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 0, 1) [20872]
[  199.407565] usb 4-2.3: configuration #1 chosen from 1 choice
[  199.416375] scsi3 : SCSI emulation for USB Mass Storage devices
[  199.418508] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[  199.418522] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[  199.418532] usb 4-2.3: Product: USB Mass Storage Device
[  199.418538] usb 4-2.3: Manufacturer: Generic
[  199.418543] usb 4-2.3: SerialNumber: ABCDEF0123456789
[  199.418893] usb-storage: device found at 7
[  199.418893] usb-storage: waiting for device to settle before scanning
[  199.447544] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20877]
[  199.452880] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c7=
 <- i8042 (interrupt, 0, 1) [20880]
[  199.862792] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20921]
[  199.867337] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [20921]
[  199.962744] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20931]
[  199.967428] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [20932]
[  200.027375] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20938]
[  200.032506] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [20938]
[  200.107187] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20946]
[  200.112315] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [20946]
[  200.172348] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20953]
[  200.177007] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [20953]
[  200.246891] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20960]
[  200.252030] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [20961]
[  200.421927] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20978]
[  200.426587] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [20978]
[  200.496470] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20985]
[  200.501498] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [20986]
[  200.566201] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [20992]
[  200.571332] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [20993]
[  200.665973] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [21002]
[  200.670980] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [21003]
[  200.725699] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [21008]
[  200.730833] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [21009]
[  200.825477] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [21018]
[  200.830653] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [21019]
[  201.115247] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0e=
 <- i8042 (interrupt, 0, 1) [21047]
[  201.201767] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8e=
 <- i8042 (interrupt, 0, 1) [21056]
[  201.471673] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 36=
 <- i8042 (interrupt, 0, 1) [21083]
[  201.616688] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0b=
 <- i8042 (interrupt, 0, 1) [21098]
[  201.698005] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8b=
 <- i8042 (interrupt, 0, 1) [21098]
[  201.728233] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b6=
 <- i8042 (interrupt, 0, 1) [21109]
[  201.853341] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1c=
 <- i8042 (interrupt, 0, 1) [21122]
[  204.469573] usb-storage: device scan complete
[  204.472252] scsi 3:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[  204.481973] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[  204.482252] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  385.547380] psmouse.c: TouchPad at isa0060/serio1/input0 lost synchroniz=
ation, throwing 1 bytes away.

--MP_/Ni_dBDXl96JRsToPB=22h5o--
