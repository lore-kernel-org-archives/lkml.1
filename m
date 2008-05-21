Return-Path: <linux-kernel-owner+w=401wt.eu-S936896AbYEUUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936896AbYEUUTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbYEUUTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:19:31 -0400
Received: from ppp-110-27.adsl.restena.lu ([158.64.110.27]:39234 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755832AbYEUUT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:19:26 -0400
X-Greylist: delayed 645 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 16:19:23 EDT
Date: Wed, 21 May 2008 22:08:33 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080521220833.2e4345cb@neptune.home>
In-Reply-To: <20080521135345.ZZRA012@mailhub.coreip.homeip.net>
References: <200805162225.44284.bonbons@linux-vserver.org>
	<20080516163318.ZZRA012@mailhub.coreip.homeip.net>
	<200805162300.06027.bonbons@linux-vserver.org>
	<20080519114827.ZZRA012@mailhub.coreip.homeip.net>
	<20080519184501.38647a94@neptune.home>
	<20080521135345.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/om726yAO=Un7T0R5.8N2uvH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/om726yAO=Un7T0R5.8N2uvH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Dmitry,

On Wed, 21 May 2008 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Bruno,
>=20
> On Mon, May 19, 2008 at 06:45:01PM +0200, Bruno Pr=C3=A9mont wrote:
> > Hi Dmitry,
> >=20
> > Please find attached dmesg output.
> >=20
> > The suspend process looked somewhat like the following:
> > - quick test of=20
> >     echo 1 > /sys/modules/i8042/parameters/debug
> >   and disabled it again
> >     echo 0 > /sys/modules/i8042/parameters/debug
> > - exit X and rmmod usb-storage and a few other modules
> >   (nfs, xfs and the like).
> > - checked the extra keys (showkey) and enabled debug again
> > - echo mem > /sys/power/state
> >=20
> > Wait half a minute with laptop in S3
> >=20
> > - hit enter to resume
> > - wait a bit, as it takes too long help out with short
> >   presses on power button (somehow it helps the HDD/CDROM
> >   to resume), also pressed caps-lock when graphics were
> >   resumed and cursor blinking (very slowly)
> > - once userspace was awake again check extra keys with
> >   showkeys
> > - disabled input debug
> >=20
> > I hope this is detailed enough.
> >=20
> > List of patches applied to linux-2.6.25.4:
> >   http://lkml.org/lkml/2008/5/16/430
> >   http://lkml.org/lkml/2008/5/16/429
> >   squashfs
> >=20
>=20
> Question - does the problem happen if you dont have dritek extension
> enabled (i.e. on unpatched kernel)?

When running 2.6.25.4 without the two dritek patches it does not
redetect the keyboard (but obviously the extra keys don't work at all)

Attached is the log for a suspend session without the dritek patches.

I hope you can find a useful difference between both cases with the
input debug messages so it's possible to get it working properly with
dritek extensions...
Seems to look like reset on suspend path does not reset everything...


Tomorrow I will also try with acerhk instead of the patches. That is:
- load acerhk which enables dritek (and also does some additional BIOS
  calls)
- suspend & resume
  -> check it keyboard got redetected

Redo the same but unloading acerhk before suspend

Bruno

--MP_/om726yAO=Un7T0R5.8N2uvH
Content-Type: text/plain; name=input-suspend-debug2.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=input-suspend-debug2.log

[    0.000000] Linux version 2.6.25.4-orig (bruno@neptune) (gcc version 4.1=
.2 (Gentoo 4.1.2 p1.0.2)) #1 Wed May 21 20:31:35 CEST 2008
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
[    0.000000] Detected 1495.202 MHz processor.
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
[    0.010000]       .data : 0xc032dd2e - 0xc04287d8   (1002 kB)
[    0.010000]       .text : 0xc0100000 - 0xc032dd2e   (2231 kB)
[    0.010000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1, Nodes=3D1
[    0.160002] Calibrating delay using timer specific routine.. 2991.75 Bog=
oMIPS (lpj=3D14958767)
[    0.160031] Security Framework initialized
[    0.160043] Capability LSM initialized
[    0.160053] Mount-cache hash table entries: 512
[    0.160212] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160220] CPU: L2 cache: 1024K
[    0.160226] Intel machine check architecture supported.
[    0.160235] Intel machine check reporting enabled on CPU#0.
[    0.160243] Compat vDSO mapped to ffffe000.
[    0.160251] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
[    0.160262] Checking 'hlt' instruction... OK.
[    0.200341] Freeing SMP alternatives: 0k freed
[    0.200348] ACPI: Core revision 20070126
[    0.212579] Parsing all Control Methods:
[    0.212715] Table [DSDT](id 0001) - 784 Objects with 54 Devices 203 Meth=
ods 19 Regions
[    0.212726]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[    0.212740] ACPI: setting ELCR to 0200 (from 0c00)
[    0.220004] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[    0.230000] khelper used greatest stack depth: 3444 bytes left
[    0.230000] net_namespace: 540 bytes
[    0.230000] Time: 21:02:16  Date: 05/21/08
[    0.230000] NET: Registered protocol family 16
[    0.230000] No dock devices found.
[    0.230000] ACPI: bus type pci registered
[    0.230000] PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=3D2
[    0.230000] PCI: Using configuration type 1
[    0.230000] Setting up standard PCI resources
[    0.238974] khelper used greatest stack depth: 3408 bytes left
[    0.239132] khelper used greatest stack depth: 3216 bytes left
[    0.240233] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GP=
E] 4 regs on int 0x9
[    0.240532] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 5 Wake, Ena=
bled 1 Runtime GPEs in this block
[    0.240548] ACPI: EC: Look up EC in DSDT
[    0.243658] Completing Region/Field/Buffer/Package initialization:......=
...................................................................
[    0.244888] Initialized 14/19 Regions 3/3 Fields 35/36 Buffers 21/28 Pac=
kages (793 nodes)
[    0.244900] Initializing Device/Processor/Thermal objects by executing _=
INI methods:..
[    0.245230] Executed 2 _INI methods requiring 1 _STA executions (examine=
d 58 objects)
[    0.245249] ACPI: Interpreter enabled
[    0.245255] ACPI: (supports S0 S3 S5)
[    0.245270] ACPI: Using PIC for interrupt routing
[    0.254225] ACPI: EC: GPE =3D 0x1d, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.254238] ACPI: EC: driver started in poll mode
[    0.254290] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.254742] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.254750] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 AC=
PI/GPIO/TCO
[    0.254762] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GP=
IO
[    0.255146] PCI: Transparent bridge - 0000:00:1e.0
[    0.255193] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.255537] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.259546] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.259695] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.259837] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[    0.259979] ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
[    0.260145] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
[    0.260288] ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
[    0.260430] ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
[    0.260573] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[    0.260741] ACPI: Power Resource [PFN0] (off)
[    0.260793] ACPI: Power Resource [PFN1] (off)
[    0.260928] ACPI: WMI: Mapper loaded
[    0.260935] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.260977] pnp: PnP ACPI init
[    0.260990] ACPI: bus type pnp registered
[    0.266095] pnp: PnP ACPI: found 9 devices
[    0.266105] ACPI: ACPI bus type pnp unregistered
[    0.266181] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.266675] SCSI subsystem initialized
[    0.266724] libata version 3.00 loaded.
[    0.267225] PCI: Using ACPI for IRQ routing
[    0.267236] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.273022] hpet clockevent registered
[    0.273028] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.273038] hpet0: 3 64-bit timers, 14318180 Hz
[    0.274093] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.274101] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.274109] system 00:04: ioport range 0x800-0x80f has been reserved
[    0.274117] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.274125] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.274133] system 00:04: ioport range 0x1c0-0x1cf has been reserved
[    0.274141] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.274149] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    0.274156] system 00:04: ioport range 0x610-0x61f has been reserved
[    0.274165] system 00:04: iomem range 0xfec10000-0xfec1ffff could not be=
 reserved
[    0.274175] system 00:04: iomem range 0xff800000-0xffbfffff could not be=
 reserved
[    0.274184] system 00:04: iomem range 0xfff00000-0xffffffff could not be=
 reserved
[    0.274194] system 00:04: iomem range 0x0-0x9ffff could not be reserved
[    0.274202] system 00:04: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.274210] system 00:04: iomem range 0x0-0x0 could not be reserved
[    0.304695] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.304703]   IO window: 0x00003000-0x000030ff
[    0.304711]   IO window: 0x00003400-0x000034ff
[    0.304719]   PREFETCH window: 0x30000000-0x33ffffff
[    0.304726]   MEM window: 0x3c000000-0x3fffffff
[    0.304734] PCI: Bus 7, cardbus bridge: 0000:02:06.1
[    0.304740]   IO window: 0x00003800-0x000038ff
[    0.304748]   IO window: 0x00003c00-0x00003cff
[    0.304755]   PREFETCH window: 0x34000000-0x37ffffff
[    0.304763]   MEM window: 0x40000000-0x43ffffff
[    0.304770] PCI: Bridge: 0000:00:1e.0
[    0.304776]   IO window: 3000-3fff
[    0.304784]   MEM window: 0xe0200000-0xe07fffff
[    0.304792]   PREFETCH window: 0x0000000030000000-0x0000000037ffffff
[    0.304811] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.305086] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.305095] PCI: setting IRQ 10 as level-triggered
[    0.305098] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.305121] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.305144] NET: Registered protocol family 2
[    0.305246] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[    0.305478] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[    0.305627] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.305698] TCP: Hash tables configured (established 16384 bind 16384)
[    0.305706] TCP reno registered
[    0.305860] Simple Boot Flag at 0x37 set to 0x1
[    0.305922] Machine check exception polling timer started.
[    0.308406] khelper used greatest stack depth: 3208 bytes left
[    0.308917] io scheduler noop registered
[    0.308940] io scheduler cfq registered (default)
[    0.308957] pci 0000:00:02.0: Boot video device
[    0.309254] vesafb: framebuffer at 0xe8000000, mapped to 0xde880000, usi=
ng 5120k, total 32576k
[    0.309265] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D11
[    0.309272] vesafb: scrolling: redraw
[    0.309279] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.343767] Console: switching to colour frame buffer device 160x64
[    0.375734] fb0: VESA VGA frame buffer device
[    0.376577] ACPI: AC Adapter [ACAD] (on-line)
[    0.377223] ACPI: Battery Slot [BAT1] (battery absent)
[    0.377834] ACPI: Battery Slot [BAT2] (battery absent)
[    0.378157] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    0.378468] ACPI: Power Button (FF) [PWRF]
[    0.378707] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[    0.379425] ACPI: Lid Switch [LID]
[    0.379632] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0E:00/input/input2
[    0.379972] ACPI: Sleep Button (CM) [SLPB]
[    0.380045] ACPI: Transitioning device [FAN0] to D3
[    0.380284] ACPI: PNP0C0B:00 is registered as cooling_device0
[    0.380513] ACPI: Fan [FAN0] (off)
[    0.380783] ACPI: Transitioning device [FAN1] to D3
[    0.381014] ACPI: PNP0C0B:01 is registered as cooling_device1
[    0.381243] ACPI: Fan [FAN1] (off)
[    0.381748] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:0=
0/device:02/input/input3
[    0.382097] ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: n=
o)
[    0.382572] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.382866] ACPI: ACPI0007:00 is registered as cooling_device2
[    0.384041] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.384709] ACPI: Thermal Zone [THRM] (47 C)
[    0.384917] isapnp: Scanning for PnP cards...
[    0.695140] isapnp: No Plug & Play device found
[    0.698138] intel_rng: FWH not detected
[    0.698303] Linux agpgart interface v0.103
[    0.698483] agpgart: Detected an Intel 855GM Chipset.
[    0.699444] agpgart: Detected 32636K stolen memory.
[    0.706827] agpgart: AGP aperture is 128M @ 0xe8000000
[    0.707140] [drm] Initialized drm 1.1.0 20060810
[    0.707626] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.707856] PCI: setting IRQ 11 as level-triggered
[    0.707860] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    0.708223] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.708311] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.708543] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    0.708619] [drm] Initialized i915 1.6.0 20060119 on minor 1
[    0.710054] acer-wmi: Acer Laptop ACPI-WMI Extras version 0.1
[    0.720023] acer-wmi: No or unsupported WMI interface, unable to load
[    0.730042] Driver 'sd' needs updating - please use bus_type methods
[    0.740044] ata_piix 0000:00:1f.1: version 2.12
[    0.740051] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[    0.750009] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.760028] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.760115] scsi0 : ata_piix
[    0.770070] scsi1 : ata_piix
[    0.780008] Switched to high resolution mode on CPU 0
[    0.781431] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    0.790003] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    0.999578] ata1.00: ATA-6: FUJITSU MHT2060AH, 006C, max UDMA/100
[    0.999580] ata1.00: 117210240 sectors, multi 16: LBA=20
[    1.058063] ata1.00: configured for UDMA/100
[    1.397243] ata2.01: NODEV after polling detection
[    1.586983] ata2.00: ATAPI: UJDA740 DVD/CDRW, 1.20, max UDMA/33
[    1.805869] ata2.00: configured for UDMA/33
[    1.805995] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 00=
6C PQ: 0 ANSI: 5
[    1.815992] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.825884] sd 0:0:0:0: [sda] Write Protect is off
[    1.835871] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.835894] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.845925] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.855880] sd 0:0:0:0: [sda] Write Protect is off
[    1.865871] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.865891] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.875870]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    2.043878] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.060485] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA740 DVD/CDRW 1.=
20 PQ: 0 ANSI: 5
[    2.073536] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64=
 irq 1,12
[    2.084678] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.093399] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.103549] mice: PS/2 mouse device common for all mice
[    2.147979] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input4
[    2.154544] cpuidle: using governor ladder
[    2.158284] cpuidle: using governor menu
[    2.168563] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.178010] TCP cubic registered
[    2.187998] NET: Registered protocol family 1
[    2.198209] NET: Registered protocol family 10
[    2.208584] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.217998] NET: Registered protocol family 17
[    2.228151] Using IPI Shortcut mode
[    2.238302]   Magic number: 8:760:45
[    2.252426] Marking TSC unstable due to: TSC halts in idle.
[    2.753436] Clocksource tsc unstable (delta =3D -492515889 ns)
[    2.810772] Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0=
x904713/0x4006
[    2.842888] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input5
[    2.891136] ReiserFS: sda6: found reiserfs format "3.6" with standard jo=
urnal
[    2.891148] ReiserFS: sda6: using ordered data mode
[    2.914398] ReiserFS: sda6: journal params: device sda6, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    2.915201] ReiserFS: sda6: checking transaction log (sda6)
[    2.954648] ReiserFS: sda6: Using r5 hash to sort names
[    2.954731] VFS: Mounted root (reiserfs filesystem) readonly.
[    2.964923] Freeing unused kernel memory: 216k freed
[    2.998725] khelper used greatest stack depth: 2144 bytes left
[    3.780575] cat used greatest stack depth: 1772 bytes left
[    3.846363] init-early.sh used greatest stack depth: 1308 bytes left
[    5.079641] Driver 'sr' needs updating - please use bus_type methods
[    5.081172] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    5.081177] Uniform CD-ROM driver Revision: 3.20
[    5.081248] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.136892] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.136918] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    5.186277] usbcore: registered new interface driver usbfs
[    5.186304] usbcore: registered new interface driver hub
[    5.188174] usbcore: registered new device driver usb
[    5.192517] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.227551] USB Universal Host Controller Interface driver v3.0
[    5.227633] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    5.227647] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.227652] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.227910] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 1
[    5.227936] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
[    5.228097] usb usb1: configuration #1 chosen from 1 choice
[    5.228126] hub 1-0:1.0: USB hub found
[    5.228134] hub 1-0:1.0: 2 ports detected
[    5.334910] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.334916] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.334919] usb usb1: Product: UHCI Host Controller
[    5.334922] usb usb1: Manufacturer: Linux 2.6.25.4-orig uhci_hcd
[    5.334924] usb usb1: SerialNumber: 0000:00:1d.0
[    5.335324] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.335328] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.335719] ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.336300] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.336303] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.336314] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    5.336318] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.336358] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 2
[    5.336386] uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
[    5.336516] usb usb2: configuration #1 chosen from 1 choice
[    5.336545] hub 2-0:1.0: USB hub found
[    5.336554] hub 2-0:1.0: 2 ports detected
[    5.434835] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI versi=
on 1.10
[    5.445030] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.445036] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.445040] usb usb2: Product: UHCI Host Controller
[    5.445042] usb usb2: Manufacturer: Linux 2.6.25.4-orig uhci_hcd
[    5.445045] usb usb2: SerialNumber: 0000:00:1d.1
[    5.445137] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.445249] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    5.445260] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    5.445264] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.445299] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 3
[    5.445325] uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
[    5.445463] usb usb3: configuration #1 chosen from 1 choice
[    5.445491] hub 3-0:1.0: USB hub found
[    5.445499] hub 3-0:1.0: 2 ports detected
[    5.554941] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.554946] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.554950] usb usb3: Product: UHCI Host Controller
[    5.554952] usb usb3: Manufacturer: Linux 2.6.25.4-orig uhci_hcd
[    5.554955] usb usb3: SerialNumber: 0000:00:1d.2
[    5.564900] ssb: Sonics Silicon Backplane found on PCI device 0000:02:02=
.0
[    5.564936] b44.c:v2.0
[    5.605442] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:2d:03=
:9d
[    5.626809] udev: renamed network interface eth0 to lan
[    5.799543] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    5.799554] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[    5.799580] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.799589] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.799665] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 4
[    5.803660] ehci_hcd 0000:00:1d.7: debug port 1
[    5.803670] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[    5.803689] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
[    5.830520] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 2
[    5.850116] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    5.850392] usb usb4: configuration #1 chosen from 1 choice
[    5.850455] hub 4-0:1.0: USB hub found
[    5.850472] hub 4-0:1.0: 6 ports detected
[    5.907537] hub 3-0:1.0: unable to enumerate USB device on port 2
[    5.927609] firewire_core: created device fw0: GUID 00c09f00000fc03c, S4=
00
[    5.955702] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.955713] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.955721] usb usb4: Product: EHCI Host Controller
[    5.955727] usb usb4: Manufacturer: Linux 2.6.25.4-orig ehci_hcd
[    5.955733] usb usb4: SerialNumber: 0000:00:1d.7
[    5.976680] NET: Registered protocol family 23
[    6.028994] nsc-ircc, chip->init
[    6.029010] nsc-ircc, Found chip at base=3D0x04e
[    6.029039] nsc-ircc, driver loaded (Dag Brattli)
[    6.030503] IrDA: Registered device irda0
[    6.030567] nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
[    6.137187] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    6.137230] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    6.245449] hub 4-0:1.0: unable to enumerate USB device on port 6
[    6.565427] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 3
[    6.738958] usb 3-2: configuration #1 chosen from 1 choice
[    6.744828] hub 3-2:1.0: USB hub found
[    6.745759] hub 3-2:1.0: 3 ports detected
[    6.857849] usb 3-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[    6.857859] usb 3-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    6.857867] usb 3-2: Product: General Purpose USB Hub
[    6.985386] intel8x0_measure_ac97_clock: measured 59427 usecs
[    6.985394] intel8x0: clocking to 48000
[    6.986425] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    6.986459] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[    7.084934] usb 3-2.3: new full speed USB device using uhci_hcd and addr=
ess 4
[    7.219225] usb 3-2.3: configuration #1 chosen from 1 choice
[    7.221775] usb 3-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[    7.221784] usb 3-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    7.221792] usb 3-2.3: Product: USB Mass Storage Device
[    7.221798] usb 3-2.3: Manufacturer: Generic
[    7.221803] usb 3-2.3: SerialNumber: ABCDEF0123456789
[    7.341201] Initializing USB Mass Storage driver...
[    7.341652] scsi2 : SCSI emulation for USB Mass Storage devices
[    7.342059] usbcore: registered new interface driver usb-storage
[    7.342069] USB Mass Storage support registered.
[    7.343658] usb-storage: device found at 4
[    7.343664] usb-storage: waiting for device to settle before scanning
[   12.104669] usb-storage: device scan complete
[   12.107580] scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[   12.120592] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   12.120682] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   16.616139] SGI XFS with ACLs, no debug enabled
[   16.619525] SGI XFS Quota Management subsystem
[   16.662296] XFS mounting filesystem sda9
[   16.779449] Ending clean XFS mount for filesystem: sda9
[   16.793502] ReiserFS: sda10: found reiserfs format "3.6" with standard j=
ournal
[   16.793530] ReiserFS: sda10: using ordered data mode
[   16.806481] ReiserFS: sda10: journal params: device sda10, size 8192, jo=
urnal first block 18, max trans len 1024, max batch 900, max commit age 30,=
 max trans age 30
[   16.806481] ReiserFS: sda10: checking transaction log (sda10)
[   16.849528] ReiserFS: sda10: Using r5 hash to sort names
[   16.878959] ReiserFS: sda7: found reiserfs format "3.6" with standard jo=
urnal
[   16.878959] ReiserFS: sda7: using ordered data mode
[   16.888288] ReiserFS: sda7: journal params: device sda7, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   16.888288] ReiserFS: sda7: checking transaction log (sda7)
[   16.943133] ReiserFS: sda7: Using r5 hash to sort names
[   16.980620] ReiserFS: sda8: found reiserfs format "3.6" with standard jo=
urnal
[   16.980620] ReiserFS: sda8: using ordered data mode
[   16.995620] ReiserFS: sda8: journal params: device sda8, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   16.995620] ReiserFS: sda8: checking transaction log (sda8)
[   17.038599] ReiserFS: sda8: Using r5 hash to sort names
[   19.046599] ADDRCONF(NETDEV_UP): lan: link is not ready
[   19.274763] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   19.274763] All bugs added by David S. Miller <davem@redhat.com>
[   19.322757] ADDRCONF(NETDEV_UP): lan.658: link is not ready
[   19.602662] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 ac=
ross:1004020k
[   22.051505] b44: lan: Link is up at 100 Mbps, full duplex.
[   22.051517] b44: lan: Flow control is off for TX and off for RX.
[   22.051991] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[   22.053017] ADDRCONF(NETDEV_CHANGE): lan.658: link becomes ready
[   31.661570] RPC: Registered udp transport module.
[   31.661582] RPC: Registered tcp transport module.
[   31.866028] mount.nfs used greatest stack depth: 908 bytes left
[   32.028822] loop: module loaded
[   32.206371] lan.658: no IPv6 routers present
[   33.097209] squashfs: version 3.3 (2007/10/31) Phillip Lougher
[  123.430614] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9c=
 <- i8042 (interrupt, 0, 1) [12285]
[  124.675179] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 12=
 <- i8042 (interrupt, 0, 1) [12409]
[  124.754811] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 92=
 <- i8042 (interrupt, 0, 1) [12417]
[  124.914572] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 2e=
 <- i8042 (interrupt, 0, 1) [12433]
[  124.979302] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ae=
 <- i8042 (interrupt, 0, 1) [12440]
[  125.019138] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 23=
 <- i8042 (interrupt, 0, 1) [12444]
[  125.048845] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 18=
 <- i8042 (interrupt, 0, 1) [12447]
[  125.098503] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: a3=
 <- i8042 (interrupt, 0, 1) [12452]
[  125.128355] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 98=
 <- i8042 (interrupt, 0, 1) [12455]
[  125.133498] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 39=
 <- i8042 (interrupt, 0, 1) [12455]
[  125.213102] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b9=
 <- i8042 (interrupt, 0, 1) [12463]
[  125.542776] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 27=
 <- i8042 (interrupt, 0, 1) [12496]
[  125.607222] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: a7=
 <- i8042 (interrupt, 0, 1) [12503]
[  125.637048] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 12=
 <- i8042 (interrupt, 0, 1) [12506]
[  125.706724] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 27=
 <- i8042 (interrupt, 0, 1) [12513]
[  125.716412] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 92=
 <- i8042 (interrupt, 0, 1) [12514]
[  125.781432] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: a7=
 <- i8042 (interrupt, 0, 1) [12520]
[  125.891234] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 39=
 <- i8042 (interrupt, 0, 1) [12531]
[  125.960874] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b9=
 <- i8042 (interrupt, 0, 1) [12538]
[  126.100666] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 36=
 <- i8042 (interrupt, 0, 1) [12552]
[  126.175279] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 56=
 <- i8042 (interrupt, 0, 1) [12560]
[  126.260252] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b6=
 <- i8042 (interrupt, 0, 1) [12569]
[  126.265242] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d6=
 <- i8042 (interrupt, 0, 1) [12570]
[  126.335051] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 39=
 <- i8042 (interrupt, 0, 1) [12577]
[  126.409792] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b9=
 <- i8042 (interrupt, 0, 1) [12584]
[  126.429636] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 36=
 <- i8042 (interrupt, 0, 1) [12586]
[  126.489479] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 34=
 <- i8042 (interrupt, 0, 1) [12592]
[  126.544306] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b6=
 <- i8042 (interrupt, 0, 1) [12598]
[  126.579049] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b4=
 <- i8042 (interrupt, 0, 1) [12601]
[  126.758832] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1f=
 <- i8042 (interrupt, 0, 1) [12619]
[  126.828460] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9f=
 <- i8042 (interrupt, 0, 1) [12626]
[  126.863462] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 15=
 <- i8042 (interrupt, 0, 1) [12630]
[  126.943093] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 95=
 <- i8042 (interrupt, 0, 1) [12638]
[  126.972922] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1f=
 <- i8042 (interrupt, 0, 1) [12641]
[  127.047346] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9f=
 <- i8042 (interrupt, 0, 1) [12648]
[  127.202515] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0f=
 <- i8042 (interrupt, 0, 1) [12664]
[  127.266707] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8f=
 <- i8042 (interrupt, 0, 1) [12670]
[  127.321981] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 19=
 <- i8042 (interrupt, 0, 1) [12676]
[  127.361582] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 18=
 <- i8042 (interrupt, 0, 1) [12680]
[  127.411196] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 99=
 <- i8042 (interrupt, 0, 1) [12685]
[  127.435983] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 98=
 <- i8042 (interrupt, 0, 1) [12687]
[  127.451026] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0f=
 <- i8042 (interrupt, 0, 1) [12689]
[  127.515209] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8f=
 <- i8042 (interrupt, 0, 1) [12695]
[  129.764029] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1f=
 <- i8042 (interrupt, 0, 1) [12920]
[  129.838856] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9f=
 <- i8042 (interrupt, 0, 1) [12928]
[  129.853454] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 <- i8042 (interrupt, 0, 1) [12929]
[  129.928614] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 94=
 <- i8042 (interrupt, 0, 1) [12937]
[  129.993230] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0f=
 <- i8042 (interrupt, 0, 1) [12943]
[  130.059637] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8f=
 <- i8042 (interrupt, 0, 1) [12950]
[  146.701192] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1c=
 <- i8042 (interrupt, 0, 1) [14617]
[  146.718247] PM: Syncing filesystems ... done.
[  146.722293] PM: Preparing system for mem sleep
[  146.756843] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9c=
 <- i8042 (interrupt, 0, 1) [14624]
[  146.758007] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[  146.758268] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[  146.758361] PM: Entering mem sleep
[  146.758366] Suspending console(s)
[  146.792488] b44: lan: powering down PHY
[  146.812357] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14630]
[  146.812419] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f5=
 -> i8042 (parameter) [14630]
[  146.814518] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14630]
[  146.814540] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14630]
[  146.814652] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [14630]
[  146.816946] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14630]
[  146.816963] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14630]
[  146.817025] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [14630]
[  146.819316] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14630]
[  146.819333] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14630]
[  146.819394] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [14630]
[  146.821683] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14630]
[  146.821700] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14630]
[  146.821762] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [14630]
[  146.824043] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14631]
[  146.824043] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14631]
[  146.824043] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [14631]
[  146.826306] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14631]
[  146.826306] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14631]
[  146.826306] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [14631]
[  146.828575] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14631]
[  146.828575] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14631]
[  146.828575] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [14631]
[  146.830837] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14631]
[  146.830837] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14631]
[  146.830837] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [14631]
[  146.833106] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14632]
[  146.833106] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14632]
[  146.833106] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [14632]
[  146.835371] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14632]
[  146.835371] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14632]
[  146.835371] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (parameter) [14632]
[  146.837644] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14632]
[  146.837644] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14632]
[  146.837644] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 -> i8042 (parameter) [14632]
[  146.839913] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14632]
[  146.839913] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14632]
[  146.839913] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ff=
 -> i8042 (parameter) [14632]
[  146.842185] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14633]
[  147.188275] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (interrupt, 1, 12) [14667]
[  147.189471] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [14667]
[  147.189471] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [14667]
[  147.189471] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f4=
 -> i8042 (parameter) [14667]
[  147.191742] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [14668]
[  147.191742] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ff=
 -> i8042 (kbd-data) [14668]
[  147.194623] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [14668]
[  147.303971] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (interrupt, 0, 1) [14679]
[  147.400428] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [14689]
[  147.400489] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 -> i8042 (parameter) [14689]
[  147.400507] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  147.400941] sd 0:0:0:0: [sda] Stopping disk
[  148.448030] drm_sysfs_suspend
[  148.468206] drm_sysfs_suspend
[  148.469024] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[  148.488671] nsc-ircc 00:08: disabled
[  148.508245] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[  148.508405] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[  148.528273] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[  148.528384] ACPI: Cannot set device to a higher-powered state than parent
[  148.528436] ACPI: Cannot set device to a higher-powered state than parent
[  148.528490] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[  148.528591] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  148.548077] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  148.548110] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  148.548144] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  148.556870] ACPI: Preparing to enter system sleep state S3
[  148.558171] ACPI: EC: missing write data confirmation, don't expect it a=
ny longer.
[  148.569426] cpufreq: suspend failed to assert current frequency is what =
timing core thinks it is.
[  148.569674]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[  148.569674] Intel machine check architecture supported.
[  148.569694] Intel machine check reporting enabled on CPU#0.
[  148.569795] Back to C!
[  148.569809] cpufreq: resume failed to assert current frequency is what t=
iming core thinks it is.
[  148.570210] Force enabled HPET at resume
[  148.584615] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 100, writing 10b)
[  148.584637] PM: Writing back config space on device 0000:00:02.0 at offs=
et 6 (was 1, writing 1801)
[  148.584647] PM: Writing back config space on device 0000:00:02.0 at offs=
et 5 (was 0, writing e0000000)
[  148.584658] PM: Writing back config space on device 0000:00:02.0 at offs=
et 4 (was 8, writing e8000008)
[  148.584671] PM: Writing back config space on device 0000:00:02.0 at offs=
et 1 (was 900000, writing 900003)
[  148.588018] PM: Writing back config space on device 0000:00:02.1 at offs=
et 5 (was 0, writing e0080000)
[  148.588018] PM: Writing back config space on device 0000:00:02.1 at offs=
et 4 (was 8, writing f0000008)
[  148.588018] PM: Writing back config space on device 0000:00:02.1 at offs=
et 1 (was 900000, writing 900003)
[  148.588018] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[  148.588018] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[  148.588018] usb usb1: root hub lost power or was reset
[  148.588018] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[  148.588018] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[  148.588018] usb usb2: root hub lost power or was reset
[  148.588018] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  148.588018] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[  148.588018] usb usb3: root hub lost power or was reset
[  149.137579] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[  149.137579] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[  149.137579] PM: Writing back config space on device 0000:00:1d.7 at offs=
et 1 (was 2900006, writing 2900106)
[  149.137579] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 9 (was fff0, writing 37f03000)
[  149.137579] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 7 (was 22803030, writing 2803030)
[  149.137579] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 1 (was 80800105, writing 80800107)
[  149.137579] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  149.137579] PM: Writing back config space on device 0000:00:1f.1 at offs=
et f (was 100, writing 1ff)
[  149.137579] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 9 (was 0, writing 38000000)
[  149.137579] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 1 (was 2800005, writing 2800007)
[  149.137579] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  149.137579] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[  149.137579] ata2.01: _GTF evaluation failed (AE 0x1001)
[  149.137579] ata1.01: _GTF evaluation failed (AE 0x1001)
[  149.137579] PM: Writing back config space on device 0000:00:1f.5 at offs=
et f (was 200, writing 20a)
[  149.137579] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 7 (was 0, writing e0100800)
[  149.137579] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 6 (was 0, writing e0100c00)
[  149.137579] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 5 (was 1301, writing 18c1)
[  149.137579] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 4 (was 1201, writing 1c01)
[  149.137579] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 1 (was 2900005, writing 2900003)
[  149.137579] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[  149.137579] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[  151.478160] ata2.01: NODEV after polling detection
[  152.212822] ata2.00: failed to IDENTIFY (I/O error, err_mask=3D0x40)
[  152.212822] ata2.00: revalidation failed (errno=3D-5)
[  152.212822] ata2: failed to recover some devices, retrying in 5 secs
[  152.212822] PM: Writing back config space on device 0000:00:1f.6 at offs=
et f (was 200, writing 20a)
[  152.212822] PM: Writing back config space on device 0000:00:1f.6 at offs=
et 1 (was 2900005, writing 2900001)
[  152.212822] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[  152.212822] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[  152.215553] ata1.00: ACPI cmd 03/45:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  152.218410] ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  156.361284] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[  156.361295] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[  156.361317] PM: Writing back config space on device 0000:02:02.0 at offs=
et f (was 100, writing 10b)
[  156.361350] PM: Writing back config space on device 0000:02:02.0 at offs=
et 4 (was 0, writing e0204000)
[  156.361362] PM: Writing back config space on device 0000:02:02.0 at offs=
et 3 (was 0, writing 4000)
[  156.361377] PM: Writing back config space on device 0000:02:02.0 at offs=
et 1 (was 100002, writing 100106)
[  156.361410] PM: Writing back config space on device 0000:02:04.0 at offs=
et f (was 22020100, writing 2202010b)
[  156.361446] PM: Writing back config space on device 0000:02:04.0 at offs=
et 4 (was 0, writing e0206000)
[  156.361459] PM: Writing back config space on device 0000:02:04.0 at offs=
et 3 (was 0, writing 4008)
[  156.361474] PM: Writing back config space on device 0000:02:04.0 at offs=
et 1 (was 2900000, writing 2900116)
[  156.361511] PM: Writing back config space on device 0000:02:06.0 at offs=
et e (was 1, writing 34fd)
[  156.361523] PM: Writing back config space on device 0000:02:06.0 at offs=
et d (was 1, writing 3401)
[  156.361536] PM: Writing back config space on device 0000:02:06.0 at offs=
et c (was 1, writing 30fd)
[  156.361548] PM: Writing back config space on device 0000:02:06.0 at offs=
et b (was 1, writing 3001)
[  156.361561] PM: Writing back config space on device 0000:02:06.0 at offs=
et a (was 0, writing 3ffff000)
[  156.361574] PM: Writing back config space on device 0000:02:06.0 at offs=
et 9 (was 0, writing 3c000000)
[  156.361586] PM: Writing back config space on device 0000:02:06.0 at offs=
et 8 (was 0, writing 33fff000)
[  156.361599] PM: Writing back config space on device 0000:02:06.0 at offs=
et 7 (was 0, writing 30000000)
[  156.361612] PM: Writing back config space on device 0000:02:06.0 at offs=
et 6 (was 40000000, writing b0060302)
[  156.361627] PM: Writing back config space on device 0000:02:06.0 at offs=
et 4 (was 0, writing e0207000)
[  156.361644] PM: Writing back config space on device 0000:02:06.0 at offs=
et 1 (was 4100087, writing 4100187)
[  156.361686] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  156.361714] PM: Writing back config space on device 0000:02:06.1 at offs=
et f (was 100, writing 18001ff)
[  156.361726] PM: Writing back config space on device 0000:02:06.1 at offs=
et e (was 1, writing 3cfd)
[  156.361739] PM: Writing back config space on device 0000:02:06.1 at offs=
et d (was 1, writing 3c01)
[  156.361751] PM: Writing back config space on device 0000:02:06.1 at offs=
et c (was 1, writing 38fd)
[  156.361764] PM: Writing back config space on device 0000:02:06.1 at offs=
et b (was 1, writing 3801)
[  156.361776] PM: Writing back config space on device 0000:02:06.1 at offs=
et a (was 0, writing 43fff000)
[  156.361789] PM: Writing back config space on device 0000:02:06.1 at offs=
et 9 (was 0, writing 40000000)
[  156.361801] PM: Writing back config space on device 0000:02:06.1 at offs=
et 8 (was 0, writing 37fff000)
[  156.361814] PM: Writing back config space on device 0000:02:06.1 at offs=
et 7 (was 0, writing 34000000)
[  156.361826] PM: Writing back config space on device 0000:02:06.1 at offs=
et 6 (was 0, writing b00a0702)
[  156.361841] PM: Writing back config space on device 0000:02:06.1 at offs=
et 4 (was 0, writing e0208000)
[  156.361854] PM: Writing back config space on device 0000:02:06.1 at offs=
et 3 (was 820000, writing 824000)
[  156.361869] PM: Writing back config space on device 0000:02:06.1 at offs=
et 1 (was 4100080, writing 4100107)
[  156.361909] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[  156.362447] ata1.00: configured for UDMA/100
[  156.362549] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[  156.362587] sd 0:0:0:0: [sda] Write Protect is off
[  156.362594] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  156.362647] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  156.749255] PM: Writing back config space on device 0000:02:07.0 at offs=
et f (was 4020100, writing 402010a)
[  156.749255] PM: Writing back config space on device 0000:02:07.0 at offs=
et 5 (was 0, writing e0200000)
[  156.749255] PM: Writing back config space on device 0000:02:07.0 at offs=
et 4 (was 0, writing e0209000)
[  156.749256] PM: Writing back config space on device 0000:02:07.0 at offs=
et 3 (was 0, writing 4008)
[  156.749256] PM: Writing back config space on device 0000:02:07.0 at offs=
et 1 (was 2100002, writing 2100116)
[  161.342777] ata2.01: NODEV after polling detection
[  162.711753] nsc-ircc 00:08: activated
[  163.667444] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[  163.669996] ata2.00: ACPI cmd 03/42:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  163.670488] ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[  167.832134] sd 0:0:0:0: [sda] Starting disk
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (flush, aux) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 74=
 -> i8042 (parameter) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 56=
 -> i8042 (parameter) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 60=
 -> i8042 (command) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 -> i8042 (parameter) [22916]
[  168.180388] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f2=
 -> i8042 (kbd-data) [22916]
[  168.200891] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22918]
[  168.200891] ata2.00: configured for UDMA/33
[  168.200891] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  168.200891] ata2: ACPI event
[  168.200891] ata2: soft resetting link
[  168.201387] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [22918]
[  168.205924] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ab=
 <- i8042 (interrupt, 0, 1) [22918]
[  168.210683] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 41=
 <- i8042 (interrupt, 0, 1) [22919]
[  168.210683] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ed=
 -> i8042 (kbd-data) [22919]
[  168.213392] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22919]
[  168.213392] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [22919]
[  168.216146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22919]
[  168.216146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (kbd-data) [22919]
[  168.216995] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 36=
 <- i8042 (interrupt, 0, 1) [22920]
[  168.219603] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22920]
[  168.219603] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [22920]
[  168.222318] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22920]
[  168.222318] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f4=
 -> i8042 (kbd-data) [22920]
[  168.222963] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b6=
 <- i8042 (interrupt, 0, 1) [22920]
[  168.225591] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22920]
[  168.225591] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (kbd-data) [22920]
[  168.228301] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22921]
[  168.228301] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [22921]
[  168.231432] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22921]
[  168.231432] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ed=
 -> i8042 (kbd-data) [22921]
[  168.234143] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22921]
[  168.234143] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (kbd-data) [22921]
[  168.237085] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 0, 1) [22922]
[  168.237085] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22922]
[  168.237085] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22922]
[  168.239263] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22922]
[  168.239263] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22922]
[  168.239263] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22922]
[  168.241459] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22924]
[  168.241482] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22924]
[  168.241601] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22924]
[  168.243811] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22924]
[  168.243833] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22924]
[  168.243899] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22924]
[  168.246104] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22924]
[  168.246126] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22924]
[  168.246245] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22924]
[  168.248458] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22925]
[  168.248480] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22925]
[  168.248599] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22925]
[  168.250781] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22925]
[  168.250781] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22925]
[  168.250781] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22925]
[  168.252953] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22925]
[  168.252953] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22925]
[  168.252953] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22925]
[  168.255120] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22925]
[  168.255120] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22925]
[  168.255120] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [22925]
[  168.257318] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22926]
[  168.258436] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 08=
 <- i8042 (interrupt, 1, 12) [22926]
[  168.259552] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 1, 12) [22926]
[  168.260670] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 15=
 <- i8042 (interrupt, 1, 12) [22926]
[  168.260670] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22926]
[  168.260670] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: ff=
 -> i8042 (parameter) [22926]
[  168.262845] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22926]
[  168.643312] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: aa=
 <- i8042 (interrupt, 1, 12) [22964]
[  168.644497] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [22964]
[  168.644497] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22964]
[  168.644497] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22964]
[  168.646670] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22965]
[  168.646670] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22965]
[  168.646670] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22965]
[  168.648845] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22965]
[  168.648845] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22965]
[  168.648845] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22965]
[  168.651013] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22965]
[  168.651013] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22965]
[  168.651013] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22965]
[  168.653185] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22965]
[  168.653185] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22965]
[  168.653185] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22965]
[  168.655352] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22966]
[  168.655352] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22966]
[  168.655352] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22966]
[  168.657524] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22966]
[  168.657524] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22966]
[  168.657524] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22966]
[  168.659691] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22966]
[  168.659691] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22966]
[  168.659691] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22966]
[  168.661862] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22966]
[  168.661862] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22966]
[  168.661862] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22966]
[  168.664031] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22966]
[  168.664031] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22966]
[  168.664031] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [22966]
[  168.666229] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22967]
[  168.667340] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 08=
 <- i8042 (interrupt, 1, 12) [22967]
[  168.668452] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 1, 12) [22967]
[  168.669570] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 15=
 <- i8042 (interrupt, 1, 12) [22967]
[  168.669570] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22967]
[  168.669570] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22967]
[  168.671741] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22967]
[  168.671741] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22967]
[  168.671741] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22967]
[  168.673914] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22967]
[  168.673914] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22967]
[  168.673914] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22967]
[  168.676081] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22968]
[  168.676081] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22968]
[  168.676081] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22968]
[  168.678253] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22968]
[  168.678253] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22968]
[  168.678253] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22968]
[  168.680420] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22968]
[  168.680420] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22968]
[  168.680420] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22968]
[  168.682594] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22968]
[  168.682594] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22968]
[  168.682594] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22968]
[  168.684761] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22969]
[  168.684761] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22969]
[  168.684761] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22969]
[  168.686933] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22969]
[  168.686933] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22969]
[  168.686933] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 03=
 -> i8042 (parameter) [22969]
[  168.689100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22969]
[  168.689100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22969]
[  168.689100] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [22969]
[  168.691294] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22969]
[  168.692418] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 9d=
 <- i8042 (interrupt, 1, 12) [22969]
[  168.693533] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 1, 12) [22969]
[  168.694652] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b1=
 <- i8042 (interrupt, 1, 12) [22970]
[  168.694652] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22970]
[  168.694652] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22970]
[  168.696826] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22970]
[  168.696826] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22970]
[  168.696826] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22970]
[  168.698996] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22970]
[  168.698996] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22970]
[  168.698996] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22970]
[  168.701161] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22970]
[  168.701161] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22970]
[  168.701161] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22970]
[  168.703336] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22970]
[  168.703336] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22970]
[  168.703336] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22970]
[  168.705504] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22971]
[  168.705504] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22971]
[  168.705504] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22971]
[  168.707677] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22971]
[  168.707677] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22971]
[  168.707677] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22971]
[  168.709846] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22971]
[  168.709846] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22971]
[  168.709846] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22971]
[  168.712021] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22971]
[  168.712021] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22971]
[  168.712021] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 02=
 -> i8042 (parameter) [22971]
[  168.714189] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22972]
[  168.714189] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22972]
[  168.714189] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [22972]
[  168.716386] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22972]
[  168.717494] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 90=
 <- i8042 (interrupt, 1, 12) [22972]
[  168.718610] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 1, 12) [22972]
[  168.719728] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 13=
 <- i8042 (interrupt, 1, 12) [22972]
[  168.719728] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22972]
[  168.719728] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22972]
[  168.721903] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22972]
[  168.721903] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22972]
[  168.721903] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22972]
[  168.724077] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22973]
[  168.724077] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22973]
[  168.724077] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22973]
[  168.726243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22973]
[  168.726243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22973]
[  168.726243] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22973]
[  168.728416] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22973]
[  168.728416] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22973]
[  168.728416] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22973]
[  168.730582] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22973]
[  168.730582] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22973]
[  168.730582] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22973]
[  168.732757] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22973]
[  168.732757] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22973]
[  168.732757] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 02=
 -> i8042 (parameter) [22973]
[  168.734954] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22974]
[  168.734977] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22974]
[  168.735043] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22974]
[  168.737251] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22974]
[  168.737273] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22974]
[  168.737392] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [22974]
[  168.739595] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22974]
[  168.739617] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22974]
[  168.739683] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e9=
 -> i8042 (parameter) [22974]
[  168.741915] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22974]
[  168.743055] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 <- i8042 (interrupt, 1, 12) [22975]
[  168.744170] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 40=
 <- i8042 (interrupt, 1, 12) [22975]
[  168.745289] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 06=
 <- i8042 (interrupt, 1, 12) [22975]
[  168.745289] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22975]
[  168.745289] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22975]
[  168.747464] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22975]
[  168.747464] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22975]
[  168.747464] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22975]
[  168.749638] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22975]
[  168.749638] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22975]
[  168.749638] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 02=
 -> i8042 (parameter) [22975]
[  168.751803] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22975]
[  168.751803] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22975]
[  168.751803] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22975]
[  168.753977] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22976]
[  168.753977] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22976]
[  168.753977] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22976]
[  168.756146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22976]
[  168.756146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22976]
[  168.756146] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22976]
[  168.758321] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22976]
[  168.758321] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22976]
[  168.758321] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [22976]
[  168.760487] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22976]
[  168.760487] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22976]
[  168.760487] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22976]
[  168.762662] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22977]
[  168.762662] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22977]
[  168.762662] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [22977]
[  168.764830] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22977]
[  168.764830] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22977]
[  168.764830] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (parameter) [22977]
[  168.767005] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22977]
[  168.767005] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22977]
[  168.767005] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 -> i8042 (parameter) [22977]
[  168.769174] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22977]
[  168.769174] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22977]
[  168.769174] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22977]
[  168.771348] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22977]
[  168.771348] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22977]
[  168.771348] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22977]
[  168.773521] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22978]
[  168.773521] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22978]
[  168.773521] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 03=
 -> i8042 (parameter) [22978]
[  168.775687] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22978]
[  168.775687] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22978]
[  168.775687] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22978]
[  168.777858] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22978]
[  168.777858] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22978]
[  168.777858] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 00=
 -> i8042 (parameter) [22978]
[  168.780023] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22978]
[  168.780023] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22978]
[  168.780023] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22978]
[  168.782198] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22979]
[  168.782198] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22979]
[  168.782198] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [22979]
[  168.784366] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22979]
[  168.784366] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22979]
[  168.784366] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22979]
[  168.786540] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22979]
[  168.786540] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22979]
[  168.786540] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 01=
 -> i8042 (parameter) [22979]
[  168.788707] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22979]
[  168.788707] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22979]
[  168.788707] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f3=
 -> i8042 (parameter) [22979]
[  168.790881] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22979]
[  168.790881] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22979]
[  168.790881] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 14=
 -> i8042 (parameter) [22979]
[  168.793053] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22979]
[  168.793053] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22979]
[  168.793053] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e8=
 -> i8042 (parameter) [22979]
[  168.793248] ata2.01: NODEV after polling detection
[  168.795396] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22980]
[  168.795415] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22980]
[  168.795481] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 03=
 -> i8042 (parameter) [22980]
[  168.797682] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22980]
[  168.797700] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22980]
[  168.797819] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e6=
 -> i8042 (parameter) [22980]
[  168.800025] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22980]
[  168.800044] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: d4=
 -> i8042 (command) [22980]
[  168.800163] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: f4=
 -> i8042 (parameter) [22980]
[  168.802370] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: fa=
 <- i8042 (interrupt, 1, 12) [22980]
[  181.183846] ata2.00: configured for UDMA/33
[  181.183868] ata2: EH complete
[  192.546039] PM: Finishing wakeup.
[  192.546039] Restarting tasks ... <6>usb 3-2: USB disconnect, address 3
[  192.546039] usb 3-2.3: USB disconnect, address 4
[  192.566039] done.
[  197.026705] b44: lan: Link is up at 100 Mbps, full duplex.
[  197.026720] b44: lan: Flow control is off for TX and off for RX.
[  201.093894] hub 4-0:1.0: unable to enumerate USB device on port 6
[  207.013651] usb 3-2: new full speed USB device using uhci_hcd and addres=
s 5
[  210.041716] usb 3-2: configuration #1 chosen from 1 choice
[  210.049923] hub 3-2:1.0: USB hub found
[  210.049923] hub 3-2:1.0: 3 ports detected
[  211.065777] usb 3-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[  211.065777] usb 3-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[  211.065777] usb 3-2: Product: General Purpose USB Hub
[  215.286611] usb 3-2.3: new full speed USB device using uhci_hcd and addr=
ess 6
[  216.137640] usb 3-2.3: configuration #1 chosen from 1 choice
[  216.145150] scsi3 : SCSI emulation for USB Mass Storage devices
[  216.147258] usb 3-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[  216.147271] usb 3-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[  216.147280] usb 3-2.3: Product: USB Mass Storage Device
[  216.147286] usb 3-2.3: Manufacturer: Generic
[  216.147291] usb 3-2.3: SerialNumber: ABCDEF0123456789
[  216.147840] usb-storage: device found at 6
[  216.147849] usb-storage: waiting for device to settle before scanning
[  222.009792] usb-storage: device scan complete
[  222.012471] scsi 3:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[  222.018190] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[  222.018657] sd 3:0:0:0: Attached scsi generic sg2 type 0
[  228.061982] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33133]
[  228.066996] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 0, 1) [33134]
[  228.166671] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33144]
[  228.171346] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c8=
 <- i8042 (interrupt, 0, 1) [33144]
[  228.436457] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33171]
[  228.441105] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 48=
 <- i8042 (interrupt, 0, 1) [33171]
[  228.509213] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33178]
[  228.513902] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c8=
 <- i8042 (interrupt, 0, 1) [33178]
[  228.908962] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33218]
[  228.913617] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 47=
 <- i8042 (interrupt, 0, 1) [33218]
[  228.988949] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33226]
[  228.993635] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: c7=
 <- i8042 (interrupt, 0, 1) [33227]
[  229.163527] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33244]
[  229.168589] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [33244]
[  229.248465] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33252]
[  229.253157] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [33253]
[  229.313108] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33259]
[  229.318235] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [33259]
[  229.388104] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33266]
[  229.392779] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [33267]
[  229.447946] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33272]
[  229.452624] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [33273]
[  229.517741] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33279]
[  229.522414] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [33280]
[  229.592360] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33287]
[  229.597531] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [33287]
[  229.632140] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33291]
[  229.637279] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [33291]
[  229.697299] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33297]
[  229.701776] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [33298]
[  229.761663] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33304]
[  229.766785] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [33304]
[  229.836745] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33311]
[  229.841405] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 4d=
 <- i8042 (interrupt, 0, 1) [33312]
[  229.881297] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: e0=
 <- i8042 (interrupt, 0, 1) [33316]
[  229.886417] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: cd=
 <- i8042 (interrupt, 0, 1) [33316]
[  230.596303] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0e=
 <- i8042 (interrupt, 0, 1) [33387]
[  230.658720] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8e=
 <- i8042 (interrupt, 0, 1) [33394]
[  230.998422] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 36=
 <- i8042 (interrupt, 0, 1) [33428]
[  231.113458] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 0b=
 <- i8042 (interrupt, 0, 1) [33439]
[  231.177011] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 8b=
 <- i8042 (interrupt, 0, 1) [33446]
[  231.212150] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: b6=
 <- i8042 (interrupt, 0, 1) [33449]
[  231.486750] /usr/src/linux-2.6.25.4-orig/drivers/input/serio/i8042.c: 1c=
 <- i8042 (interrupt, 0, 1) [33477]

--MP_/om726yAO=Un7T0R5.8N2uvH--
