Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbYESQxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbYESQxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYESQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:53:10 -0400
Received: from ppp-111-55.adsl.restena.lu ([158.64.111.55]:37718 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751787AbYESQxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:53:02 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2008 12:53:00 EDT
Date: Mon, 19 May 2008 18:45:01 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Message-ID: <20080519184501.38647a94@neptune.home>
In-Reply-To: <20080519114827.ZZRA012@mailhub.coreip.homeip.net>
References: <200805162225.44284.bonbons@linux-vserver.org>
	<20080516163318.ZZRA012@mailhub.coreip.homeip.net>
	<200805162300.06027.bonbons@linux-vserver.org>
	<20080519114827.ZZRA012@mailhub.coreip.homeip.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/pslP0bYrxjhF2E.g9h_dXvH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/pslP0bYrxjhF2E.g9h_dXvH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Dmitry,

Please find attached dmesg output.

The suspend process looked somewhat like the following:
- quick test of 
    echo 1 > /sys/modules/i8042/parameters/debug
  and disabled it again
    echo 0 > /sys/modules/i8042/parameters/debug
- exit X and rmmod usb-storage and a few other modules
  (nfs, xfs and the like).
- checked the extra keys (showkey) and enabled debug again
- echo mem > /sys/power/state

Wait half a minute with laptop in S3

- hit enter to resume
- wait a bit, as it takes too long help out with short
  presses on power button (somehow it helps the HDD/CDROM
  to resume), also pressed caps-lock when graphics were
  resumed and cursor blinking (very slowly)
- once userspace was awake again check extra keys with
  showkeys
- disabled input debug

I hope this is detailed enough.

List of patches applied to linux-2.6.25.4:
  http://lkml.org/lkml/2008/5/16/430
  http://lkml.org/lkml/2008/5/16/429
  squashfs


Bruno

On Mon, 19 May 2008 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi Bruno,
> 
> On Fri, May 16, 2008 at 11:00:04PM +0200, Bruno Pr?mont wrote:
> > [  252.668456] PM: Finishing wakeup.
> > [  252.668456] Restarting tasks ... done.
> > [  252.745418] input: AT Translated Set 2 keyboard
> > as /devices/platform/i8042/serio0/input/input7
> 
> Ok, so for some reason it could not resume and here it re-detected the
> keyboard creating the new input device thus resetting the keymap. The
> question is why it had to re-detect. Could you please do
> 
> 	echo 1 > /sys/modules/i8042/parameters/debug
> 
> before suspending and send me full dmesg please?
> 
--MP_/pslP0bYrxjhF2E.g9h_dXvH
Content-Type: text/plain; name=input-suspend-debug.log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=input-suspend-debug.log

[    0.000000] Linux version 2.6.25.4 (bruno@neptune) (gcc version 4.1.2 (G=
entoo 4.1.2 p1.0.2)) #8 Fri May 16 20:15:52 CEST 2008
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
tlevel=3Ddefault video=3Dvesafb:1400x1050-32 lapic hpet=3Dforce
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffb000 (fee00000)
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
[    0.010000] Memory: 481692k/490368k available (2231k kernel code, 8176k =
reserved, 998k data, 216k init, 0k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.010000]     vmalloc : 0xde800000 - 0xfffb3000   ( 535 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xddee0000   ( 478 MB)
[    0.010000]       .init : 0xc0429000 - 0xc045f000   ( 216 kB)
[    0.010000]       .data : 0xc032dd2e - 0xc04277d8   ( 998 kB)
[    0.010000]       .text : 0xc0100000 - 0xc032dd2e   (2231 kB)
[    0.010000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=3D12, HWalign=3D64, Order=3D0-1, MinObjects=
=3D4, CPUs=3D1, Nodes=3D1
[    0.160002] Calibrating delay using timer specific routine.. 2991.75 Bog=
oMIPS (lpj=3D14958769)
[    0.160028] Security Framework initialized
[    0.160041] Capability LSM initialized
[    0.160051] Mount-cache hash table entries: 512
[    0.160210] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.160220] CPU: L2 cache: 1024K
[    0.160226] Intel machine check architecture supported.
[    0.160234] Intel machine check reporting enabled on CPU#0.
[    0.160242] Compat vDSO mapped to ffffe000.
[    0.160250] CPU: Intel(R) Pentium(R) M processor 1500MHz stepping 05
[    0.160261] Checking 'hlt' instruction... OK.
[    0.200340] Freeing SMP alternatives: 0k freed
[    0.200347] ACPI: Core revision 20070126
[    0.212575] Parsing all Control Methods:
[    0.212711] Table [DSDT](id 0001) - 784 Objects with 54 Devices 203 Meth=
ods 19 Regions
[    0.212723]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables succe=
ssfully acquired
[    0.212737] ACPI: setting ELCR to 0200 (from 0c00)
[    0.220004] evxfevnt-0091 [00] enable                : Transition to ACP=
I mode successful
[    0.230000] khelper used greatest stack depth: 3444 bytes left
[    0.230000] net_namespace: 540 bytes
[    0.230000] Time:  9:34:40  Date: 05/19/08
[    0.230000] NET: Registered protocol family 16
[    0.230000] No dock devices found.
[    0.230000] ACPI: bus type pci registered
[    0.230000] PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=3D2
[    0.230000] PCI: Using configuration type 1
[    0.230000] Setting up standard PCI resources
[    0.238982] khelper used greatest stack depth: 3408 bytes left
[    0.239139] khelper used greatest stack depth: 3216 bytes left
[    0.240242] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GP=
E] 4 regs on int 0x9
[    0.240543] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 5 Wake, Ena=
bled 1 Runtime GPEs in this block
[    0.240559] ACPI: EC: Look up EC in DSDT
[    0.243673] Completing Region/Field/Buffer/Package initialization:......=
...................................................................
[    0.244914] Initialized 14/19 Regions 3/3 Fields 35/36 Buffers 21/28 Pac=
kages (793 nodes)
[    0.244926] Initializing Device/Processor/Thermal objects by executing _=
INI methods:..
[    0.245256] Executed 2 _INI methods requiring 1 _STA executions (examine=
d 58 objects)
[    0.245274] ACPI: Interpreter enabled
[    0.245280] ACPI: (supports S0 S3 S5)
[    0.245295] ACPI: Using PIC for interrupt routing
[    0.253753] ACPI: EC: GPE =3D 0x1d, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.253766] ACPI: EC: driver started in poll mode
[    0.253818] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.254272] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.254280] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 AC=
PI/GPIO/TCO
[    0.254291] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GP=
IO
[    0.254675] PCI: Transparent bridge - 0000:00:1e.0
[    0.254722] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.255069] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.259081] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.259230] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.259373] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[    0.259513] ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
[    0.259656] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
[    0.259797] ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
[    0.259941] ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
[    0.260110] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[    0.260277] ACPI: Power Resource [PFN0] (off)
[    0.260328] ACPI: Power Resource [PFN1] (off)
[    0.260463] ACPI: WMI: Mapper loaded
[    0.260470] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.260512] pnp: PnP ACPI init
[    0.260524] ACPI: bus type pnp registered
[    0.265641] pnp: PnP ACPI: found 9 devices
[    0.265650] ACPI: ACPI bus type pnp unregistered
[    0.265726] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.266222] SCSI subsystem initialized
[    0.266271] libata version 3.00 loaded.
[    0.266778] PCI: Using ACPI for IRQ routing
[    0.266788] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it =
helps, post a report
[    0.272575] hpet clockevent registered
[    0.272581] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.272591] hpet0: 3 64-bit timers, 14318180 Hz
[    0.273646] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.273654] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.273661] system 00:04: ioport range 0x800-0x80f has been reserved
[    0.273669] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.273677] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.273685] system 00:04: ioport range 0x1c0-0x1cf has been reserved
[    0.273693] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.273701] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    0.273708] system 00:04: ioport range 0x610-0x61f has been reserved
[    0.273717] system 00:04: iomem range 0xfec10000-0xfec1ffff could not be=
 reserved
[    0.273726] system 00:04: iomem range 0xff800000-0xffbfffff could not be=
 reserved
[    0.273736] system 00:04: iomem range 0xfff00000-0xffffffff could not be=
 reserved
[    0.273745] system 00:04: iomem range 0x0-0x9ffff could not be reserved
[    0.273754] system 00:04: iomem range 0xe0000-0xfffff could not be reser=
ved
[    0.273762] system 00:04: iomem range 0x0-0x0 could not be reserved
[    0.304248] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.304256]   IO window: 0x00003000-0x000030ff
[    0.304264]   IO window: 0x00003400-0x000034ff
[    0.304271]   PREFETCH window: 0x30000000-0x33ffffff
[    0.304279]   MEM window: 0x3c000000-0x3fffffff
[    0.304287] PCI: Bus 7, cardbus bridge: 0000:02:06.1
[    0.304293]   IO window: 0x00003800-0x000038ff
[    0.304300]   IO window: 0x00003c00-0x00003cff
[    0.304308]   PREFETCH window: 0x34000000-0x37ffffff
[    0.304316]   MEM window: 0x40000000-0x43ffffff
[    0.304323] PCI: Bridge: 0000:00:1e.0
[    0.304329]   IO window: 3000-3fff
[    0.304337]   MEM window: 0xe0200000-0xe07fffff
[    0.304345]   PREFETCH window: 0x0000000030000000-0x0000000037ffffff
[    0.304364] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.304638] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.304646] PCI: setting IRQ 10 as level-triggered
[    0.304650] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.304673] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.304695] NET: Registered protocol family 2
[    0.304797] IP route cache hash table entries: 4096 (order: 2, 16384 byt=
es)
[    0.305028] TCP established hash table entries: 16384 (order: 5, 131072 =
bytes)
[    0.305177] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.305247] TCP: Hash tables configured (established 16384 bind 16384)
[    0.305255] TCP reno registered
[    0.305413] Simple Boot Flag at 0x37 set to 0x1
[    0.305474] Machine check exception polling timer started.
[    0.307951] khelper used greatest stack depth: 3208 bytes left
[    0.308460] io scheduler noop registered
[    0.308482] io scheduler cfq registered (default)
[    0.308500] pci 0000:00:02.0: Boot video device
[    0.308799] vesafb: framebuffer at 0xe8000000, mapped to 0xde880000, usi=
ng 5120k, total 32576k
[    0.308810] vesafb: mode is 1280x1024x16, linelength=3D2560, pages=3D11
[    0.308817] vesafb: scrolling: redraw
[    0.308824] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.343315] Console: switching to colour frame buffer device 160x64
[    0.375282] fb0: VESA VGA frame buffer device
[    0.376127] ACPI: AC Adapter [ACAD] (on-line)
[    0.376771] ACPI: Battery Slot [BAT1] (battery absent)
[    0.378070] ACPI: Battery Slot [BAT2] (battery absent)
[    0.378394] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00=
/input/input0
[    0.378704] ACPI: Power Button (FF) [PWRF]
[    0.378944] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input1
[    0.379659] ACPI: Lid Switch [LID]
[    0.379866] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/P=
NP0C0E:00/input/input2
[    0.380000] ACPI: Sleep Button (CM) [SLPB]
[    0.380000] ACPI: Transitioning device [FAN0] to D3
[    0.380046] ACPI: PNP0C0B:00 is registered as cooling_device0
[    0.380276] ACPI: Fan [FAN0] (off)
[    0.380546] ACPI: Transitioning device [FAN1] to D3
[    0.380777] ACPI: PNP0C0B:01 is registered as cooling_device1
[    0.381006] ACPI: Fan [FAN1] (off)
[    0.381512] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:0=
0/device:02/input/input3
[    0.381861] ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: n=
o)
[    0.382336] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.382629] ACPI: ACPI0007:00 is registered as cooling_device2
[    0.383692] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.384358] ACPI: Thermal Zone [THRM] (30 C)
[    0.384566] isapnp: Scanning for PnP cards...
[    0.695096] isapnp: No Plug & Play device found
[    0.698096] intel_rng: FWH not detected
[    0.698262] Linux agpgart interface v0.103
[    0.698443] agpgart: Detected an Intel 855GM Chipset.
[    0.699397] agpgart: Detected 32636K stolen memory.
[    0.706779] agpgart: AGP aperture is 128M @ 0xe8000000
[    0.707092] [drm] Initialized drm 1.1.0 20060810
[    0.707579] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.707809] PCI: setting IRQ 11 as level-triggered
[    0.707812] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    0.708176] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.708263] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.708496] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    0.708572] [drm] Initialized i915 1.6.0 20060119 on minor 1
[    0.710054] acer-wmi: Acer Laptop ACPI-WMI Extras version 0.1
[    0.720023] acer-wmi: No or unsupported WMI interface, unable to load
[    0.730042] Driver 'sd' needs updating - please use bus_type methods
[    0.740045] ata_piix 0000:00:1f.1: version 2.12
[    0.740052] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[    0.750009] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    0.760028] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.760115] scsi0 : ata_piix
[    0.770069] scsi1 : ata_piix
[    0.780008] Switched to high resolution mode on CPU 0
[    0.781434] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq=
 14
[    0.790003] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq=
 15
[    0.980001] ata1.00: ATA-6: FUJITSU MHT2060AH, 006C, max UDMA/100
[    0.980004] ata1.00: 117210240 sectors, multi 16: LBA=20
[    1.038566] ata1.00: configured for UDMA/100
[    1.377676] ata2.01: NODEV after polling detection
[    1.567387] ata2.00: ATAPI: UJDA740 DVD/CDRW, 1.20, max UDMA/33
[    1.786128] ata2.00: configured for UDMA/33
[    1.786256] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 00=
6C PQ: 0 ANSI: 5
[    1.796253] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.806144] sd 0:0:0:0: [sda] Write Protect is off
[    1.816131] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.816154] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.826185] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[    1.836140] sd 0:0:0:0: [sda] Write Protect is off
[    1.846131] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.846151] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.856130]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    2.026162] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.040266] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA740 DVD/CDRW 1.=
20 PQ: 0 ANSI: 5
[    2.045922] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64=
 irq 1,12
[    2.057024] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.065702] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.075844] mice: PS/2 mouse device common for all mice
[    2.124349] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input4
[    2.130927] cpuidle: using governor ladder
[    2.134655] cpuidle: using governor menu
[    2.144932] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.154380] TCP cubic registered
[    2.164368] NET: Registered protocol family 1
[    2.174580] NET: Registered protocol family 10
[    2.184955] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.194369] NET: Registered protocol family 17
[    2.204524] Using IPI Shortcut mode
[    2.214664]   Magic number: 8:403:576
[    2.228812] Marking TSC unstable due to: TSC halts in idle.
[    2.739105] Clocksource tsc unstable (delta =3D -493964952 ns)
[    2.823618] Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0=
x904713/0x4006
[    2.855941] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio1/input/input5
[    2.988962] ReiserFS: sda6: found reiserfs format "3.6" with standard jo=
urnal
[    2.988977] ReiserFS: sda6: using ordered data mode
[    3.012264] ReiserFS: sda6: journal params: device sda6, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[    3.013079] ReiserFS: sda6: checking transaction log (sda6)
[    3.052542] ReiserFS: sda6: Using r5 hash to sort names
[    3.052618] VFS: Mounted root (reiserfs filesystem) readonly.
[    3.062817] Freeing unused kernel memory: 216k freed
[    3.092502] khelper used greatest stack depth: 2144 bytes left
[    3.879399] cat used greatest stack depth: 1772 bytes left
[    3.942165] init-early.sh used greatest stack depth: 1308 bytes left
[    5.184096] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.184249] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.234961] NET: Registered protocol family 23
[    5.280985] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.280992] ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.303707] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.326025] usbcore: registered new interface driver usbfs
[    5.326054] usbcore: registered new interface driver hub
[    5.326109] usbcore: registered new device driver usb
[    5.372985] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI versi=
on 1.10
[    5.390629] USB Universal Host Controller Interface driver v3.0
[    5.390705] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[    5.390718] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.390723] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.391011] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 1
[    5.391037] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
[    5.391202] usb usb1: configuration #1 chosen from 1 choice
[    5.391232] hub 1-0:1.0: USB hub found
[    5.391241] hub 1-0:1.0: 2 ports detected
[    5.447137] Driver 'sr' needs updating - please use bus_type methods
[    5.453608] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    5.453615] Uniform CD-ROM driver Revision: 3.20
[    5.453704] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.492939] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.492944] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.492948] usb usb1: Product: UHCI Host Controller
[    5.492950] usb usb1: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    5.492953] usb usb1: SerialNumber: 0000:00:1d.0
[    5.493322] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    5.493326] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[    5.493348] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.493352] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.493382] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    5.497277] ehci_hcd 0000:00:1d.7: debug port 1
[    5.497283] PCI: cache line size of 32 is not supported by device 0000:0=
0:1d.7
[    5.497292] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
[    5.512852] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10=
 Dec 2004
[    5.513026] usb usb2: configuration #1 chosen from 1 choice
[    5.513055] hub 2-0:1.0: USB hub found
[    5.513066] hub 2-0:1.0: 6 ports detected
[    5.621806] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    5.621812] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.621815] usb usb2: Product: EHCI Host Controller
[    5.621818] usb usb2: Manufacturer: Linux 2.6.25.4 ehci_hcd
[    5.621820] usb usb2: SerialNumber: 0000:00:1d.7
[    5.622184] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.622187] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.737169] ssb: Sonics Silicon Backplane found on PCI device 0000:02:02=
.0
[    5.737205] b44.c:v2.0
[    5.737254] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    5.775984] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:2d:03=
:9d
[    5.776799] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[    5.776814] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    5.776818] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.776856] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 3
[    5.776882] uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
[    5.777026] usb usb3: configuration #1 chosen from 1 choice
[    5.777055] hub 3-0:1.0: USB hub found
[    5.777064] hub 3-0:1.0: 2 ports detected
[    5.822974] udev: renamed network interface eth0 to lan
[    5.865169] firewire_core: created device fw0: GUID 00c09f00000fc03c, S4=
00
[    5.884270] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.884278] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.884284] usb usb3: Product: UHCI Host Controller
[    5.884321] usb usb3: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    5.884325] usb usb3: SerialNumber: 0000:00:1d.1
[    5.884501] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[    5.884519] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    5.884526] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.884584] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 4
[    5.884615] uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
[    5.884828] usb usb4: configuration #1 chosen from 1 choice
[    5.884875] hub 4-0:1.0: USB hub found
[    5.884889] hub 4-0:1.0: 2 ports detected
[    5.894122] hub 2-0:1.0: unable to enumerate USB device on port 6
[    5.979607] nsc-ircc, chip->init
[    5.979623] nsc-ircc, Found chip at base=3D0x04e
[    5.979652] nsc-ircc, driver loaded (Dag Brattli)
[    5.981115] IrDA: Registered device irda0
[    5.981178] nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
[    5.986991] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    5.987001] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    5.987009] usb usb4: Product: UHCI Host Controller
[    5.987015] usb usb4: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    5.987021] usb usb4: SerialNumber: 0000:00:1d.2
[    6.095010] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    6.095055] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    6.259280] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 2
[    6.432963] usb 4-2: configuration #1 chosen from 1 choice
[    6.438814] hub 4-2:1.0: USB hub found
[    6.439769] hub 4-2:1.0: 3 ports detected
[    6.551852] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[    6.551862] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    6.551870] usb 4-2: Product: General Purpose USB Hub
[    6.790693] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 3
[    6.928087] usb 4-2.3: configuration #1 chosen from 1 choice
[    6.930754] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[    6.930764] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    6.930772] usb 4-2.3: Product: USB Mass Storage Device
[    6.930777] usb 4-2.3: Manufacturer: Generic
[    6.930783] usb 4-2.3: SerialNumber: ABCDEF0123456789
[    6.938126] intel8x0_measure_ac97_clock: measured 59437 usecs
[    6.938142] intel8x0: clocking to 48000
[    6.939211] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[    6.939245] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[    6.980743] Initializing USB Mass Storage driver...
[    6.982197] scsi2 : SCSI emulation for USB Mass Storage devices
[    6.982600] usbcore: registered new interface driver usb-storage
[    6.982609] USB Mass Storage support registered.
[    6.984212] usb-storage: device found at 3
[    6.984219] usb-storage: waiting for device to settle before scanning
[   11.724394] usb-storage: device scan complete
[   11.727203] scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[   11.739270] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   11.739361] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   16.206206] SGI XFS with ACLs, no debug enabled
[   16.208759] SGI XFS Quota Management subsystem
[   16.251760] XFS mounting filesystem sda9
[   16.363225] Ending clean XFS mount for filesystem: sda9
[   16.377088] ReiserFS: sda10: found reiserfs format "3.6" with standard j=
ournal
[   16.377114] ReiserFS: sda10: using ordered data mode
[   16.390117] ReiserFS: sda10: journal params: device sda10, size 8192, jo=
urnal first block 18, max trans len 1024, max batch 900, max commit age 30,=
 max trans age 30
[   16.390117] ReiserFS: sda10: checking transaction log (sda10)
[   16.433044] ReiserFS: sda10: Using r5 hash to sort names
[   16.462501] ReiserFS: sda7: found reiserfs format "3.6" with standard jo=
urnal
[   16.462501] ReiserFS: sda7: using ordered data mode
[   16.471828] ReiserFS: sda7: journal params: device sda7, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   16.471828] ReiserFS: sda7: checking transaction log (sda7)
[   16.537758] ReiserFS: sda7: Using r5 hash to sort names
[   16.576589] ReiserFS: sda8: found reiserfs format "3.6" with standard jo=
urnal
[   16.576615] ReiserFS: sda8: using ordered data mode
[   16.591835] ReiserFS: sda8: journal params: device sda8, size 8192, jour=
nal first block 18, max trans len 1024, max batch 900, max commit age 30, m=
ax trans age 30
[   16.591835] ReiserFS: sda8: checking transaction log (sda8)
[   16.634661] ReiserFS: sda8: Using r5 hash to sort names
[   18.566807] ADDRCONF(NETDEV_UP): lan: link is not ready
[   18.823665] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   18.823671] All bugs added by David S. Miller <davem@redhat.com>
[   18.883435] ADDRCONF(NETDEV_UP): lan.658: link is not ready
[   19.154514] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 ac=
ross:1004020k
[   22.091129] b44: lan: Link is up at 100 Mbps, full duplex.
[   22.091142] b44: lan: Flow control is off for TX and off for RX.
[   22.091621] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[   22.092650] ADDRCONF(NETDEV_CHANGE): lan.658: link becomes ready
[   28.157368] RPC: Registered udp transport module.
[   28.157380] RPC: Registered tcp transport module.
[   28.560683] mount.nfs used greatest stack depth: 908 bytes left
[   28.755612] loop: module loaded
[   29.816005] squashfs: version 3.3 (2007/10/31) Phillip Lougher
[   32.734479] lan.658: no IPv6 routers present
[   73.124915] Filesystem "loop1": Disabling barriers, not supported by the=
 underlying device
[   73.358541] XFS mounting filesystem loop1
[   73.706839] Ending clean XFS mount for filesystem: loop1
[   74.054730] Filesystem "loop2": Disabling barriers, not supported by the=
 underlying device
[   74.058948] XFS mounting filesystem loop2
[   74.202083] Ending clean XFS mount for filesystem: loop2
[   74.532394] Filesystem "loop3": Disabling barriers, not supported by the=
 underlying device
[   74.592881] XFS mounting filesystem loop3
[   74.719528] Ending clean XFS mount for filesystem: loop3
[30433.435809] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3062355]
[30434.998376] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 20 <- i=
8042 (interrupt, 0, 1) [3062511]
[30435.076881] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a0 <- i=
8042 (interrupt, 0, 1) [3062519]
[30435.221516] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 27 <- i=
8042 (interrupt, 0, 1) [3062534]
[30435.261947] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 12 <- i=
8042 (interrupt, 0, 1) [3062538]
[30435.286755] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a7 <- i=
8042 (interrupt, 0, 1) [3062541]
[30435.336784] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 92 <- i=
8042 (interrupt, 0, 1) [3062546]
[30435.431869] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1f <- i=
8042 (interrupt, 0, 1) [3062555]
[30435.491848] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9f <- i=
8042 (interrupt, 0, 1) [3062561]
[30435.641073] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0f <- i=
8042 (interrupt, 0, 1) [3062576]
[30435.694840] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8f <- i=
8042 (interrupt, 0, 1) [3062582]
[30436.195487] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3062633]
[30436.200643] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 38 <- i=
8042 (interrupt, 0, 1) [3062634]
[30436.318839] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 <- i=
8042 (interrupt, 0, 1) [3062646]
[30436.400698] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 82 <- i=
8042 (interrupt, 0, 1) [3062654]
[30436.445177] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3062659]
[30436.449666] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b8 <- i=
8042 (interrupt, 0, 1) [3062659]
[30436.569138] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 39 <- i=
8042 (interrupt, 0, 1) [3062671]
[30436.646470] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b9 <- i=
8042 (interrupt, 0, 1) [3062679]
[30436.770847] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 <- i=
8042 (interrupt, 0, 1) [3062692]
[30436.840892] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 94 <- i=
8042 (interrupt, 0, 1) [3062699]
[30437.005310] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 10 <- i=
8042 (interrupt, 0, 1) [3062715]
[30437.062817] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 17 <- i=
8042 (interrupt, 0, 1) [3062721]
[30437.070258] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 90 <- i=
8042 (interrupt, 0, 1) [3062722]
[30437.105501] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 26 <- i=
8042 (interrupt, 0, 1) [3062726]
[30437.145491] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 97 <- i=
8042 (interrupt, 0, 1) [3062730]
[30437.190246] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a6 <- i=
8042 (interrupt, 0, 1) [3062734]
[30437.355380] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3062751]
[30437.425421] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3062758]
[30440.893938] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063105]
[30440.899130] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3063106]
[30440.979116] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063114]
[30440.983605] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3063114]
[30441.173188] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063134]
[30441.178088] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3063134]
[30441.274864] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063144]
[30441.279395] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3063145]
[30441.694166] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063186]
[30441.698922] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063187]
[30442.188473] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063236]
[30442.193651] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063236]
[30442.223743] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063239]
[30442.228455] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063240]
[30442.258276] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063243]
[30442.263479] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063243]
[30442.293513] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063246]
[30442.298274] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063247]
[30442.328343] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063250]
[30442.333512] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063250]
[30442.363608] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063253]
[30442.368341] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063254]
[30442.398408] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063257]
[30442.403599] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063257]
[30442.433621] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063260]
[30442.438373] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063261]
[30442.468439] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063264]
[30442.473612] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3063264]
[30442.508466] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063268]
[30442.513643] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cb <- i=
8042 (interrupt, 0, 1) [3063268]
[30442.828092] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063300]
[30442.833007] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [3063300]
[30442.930580] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3063310]
[30442.935073] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cd <- i=
8042 (interrupt, 0, 1) [3063311]
[30443.190045] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0e <- i=
8042 (interrupt, 0, 1) [3063336]
[30443.257128] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8e <- i=
8042 (interrupt, 0, 1) [3063343]
[30443.516830] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [3063369]
[30443.649997] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0b <- i=
8042 (interrupt, 0, 1) [3063383]
[30443.730008] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8b <- i=
8042 (interrupt, 0, 1) [3063391]
[30443.744588] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b6 <- i=
8042 (interrupt, 0, 1) [3063392]
[30443.834174] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3063401]
[31048.837034] usbcore: deregistering interface driver usb-storage
[31120.099239] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[31214.145448] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3140840]
[31217.456364] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 12 <- i=
8042 (interrupt, 0, 1) [3141172]
[31217.531115] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 92 <- i=
8042 (interrupt, 0, 1) [3141180]
[31217.675648] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 2e <- i=
8042 (interrupt, 0, 1) [3141194]
[31217.750528] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ae <- i=
8042 (interrupt, 0, 1) [3141202]
[31217.810505] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 23 <- i=
8042 (interrupt, 0, 1) [3141208]
[31217.850188] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 18 <- i=
8042 (interrupt, 0, 1) [3141212]
[31217.899776] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a3 <- i=
8042 (interrupt, 0, 1) [3141217]
[31217.929627] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 98 <- i=
8042 (interrupt, 0, 1) [3141220]
[31218.024350] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 39 <- i=
8042 (interrupt, 0, 1) [3141229]
[31218.099215] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b9 <- i=
8042 (interrupt, 0, 1) [3141237]
[31218.438910] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 27 <- i=
8042 (interrupt, 0, 1) [3141271]
[31218.513356] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a7 <- i=
8042 (interrupt, 0, 1) [3141278]
[31218.518410] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 12 <- i=
8042 (interrupt, 0, 1) [3141279]
[31218.598035] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 92 <- i=
8042 (interrupt, 0, 1) [3141287]
[31218.622665] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 27 <- i=
8042 (interrupt, 0, 1) [3141289]
[31218.702327] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 12 <- i=
8042 (interrupt, 0, 1) [3141297]
[31218.707211] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a7 <- i=
8042 (interrupt, 0, 1) [3141298]
[31218.771789] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 92 <- i=
8042 (interrupt, 0, 1) [3141304]
[31219.051496] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 39 <- i=
8042 (interrupt, 0, 1) [3141332]
[31219.116354] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b9 <- i=
8042 (interrupt, 0, 1) [3141339]
[31219.890642] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0e <- i=
8042 (interrupt, 0, 1) [3141416]
[31219.959776] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8e <- i=
8042 (interrupt, 0, 1) [3141423]
[31220.029604] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0e <- i=
8042 (interrupt, 0, 1) [3141430]
[31220.098802] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8e <- i=
8042 (interrupt, 0, 1) [3141437]
[31220.283801] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 39 <- i=
8042 (interrupt, 0, 1) [3141456]
[31220.373411] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b9 <- i=
8042 (interrupt, 0, 1) [3141465]
[31220.527981] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [3141480]
[31220.603003] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 56 <- i=
8042 (interrupt, 0, 1) [3141488]
[31220.687374] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b6 <- i=
8042 (interrupt, 0, 1) [3141496]
[31220.702445] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d6 <- i=
8042 (interrupt, 0, 1) [3141498]
[31220.787022] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 39 <- i=
8042 (interrupt, 0, 1) [3141506]
[31220.866663] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b9 <- i=
8042 (interrupt, 0, 1) [3141514]
[31220.886555] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [3141516]
[31220.946316] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 34 <- i=
8042 (interrupt, 0, 1) [3141522]
[31221.001497] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b6 <- i=
8042 (interrupt, 0, 1) [3141528]
[31221.036083] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b4 <- i=
8042 (interrupt, 0, 1) [3141531]
[31221.241078] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1f <- i=
8042 (interrupt, 0, 1) [3141552]
[31221.310693] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9f <- i=
8042 (interrupt, 0, 1) [3141559]
[31221.330542] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 15 <- i=
8042 (interrupt, 0, 1) [3141561]
[31221.400211] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1f <- i=
8042 (interrupt, 0, 1) [3141568]
[31221.404622] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 95 <- i=
8042 (interrupt, 0, 1) [3141568]
[31221.474438] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9f <- i=
8042 (interrupt, 0, 1) [3141575]
[31221.649472] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0f <- i=
8042 (interrupt, 0, 1) [3141593]
[31221.708898] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8f <- i=
8042 (interrupt, 0, 1) [3141599]
[31222.128532] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 19 <- i=
8042 (interrupt, 0, 1) [3141641]
[31222.152964] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 18 <- i=
8042 (interrupt, 0, 1) [3141644]
[31222.197813] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 99 <- i=
8042 (interrupt, 0, 1) [3141648]
[31222.202418] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0f <- i=
8042 (interrupt, 0, 1) [3141649]
[31222.217077] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 98 <- i=
8042 (interrupt, 0, 1) [3141650]
[31222.271652] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8f <- i=
8042 (interrupt, 0, 1) [3141656]
[31223.186451] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1f <- i=
8042 (interrupt, 0, 1) [3141747]
[31223.256139] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9f <- i=
8042 (interrupt, 0, 1) [3141754]
[31223.265894] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 <- i=
8042 (interrupt, 0, 1) [3141755]
[31223.320292] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 94 <- i=
8042 (interrupt, 0, 1) [3141761]
[31223.420091] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0f <- i=
8042 (interrupt, 0, 1) [3141771]
[31223.474628] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8f <- i=
8042 (interrupt, 0, 1) [3141776]
[31231.255623] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3142556]
[31231.260722] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 0, 1) [3142557]
[31231.325473] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3142563]
[31231.330619] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c7 <- i=
8042 (interrupt, 0, 1) [3142564]
[31232.270188] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3142658]
[31232.274792] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 38 <- i=
8042 (interrupt, 0, 1) [3142659]
[31232.419850] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 04 <- i=
8042 (interrupt, 0, 1) [3142673]
[31232.510803] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 84 <- i=
8042 (interrupt, 0, 1) [3142683]
[31232.595830] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3142691]
[31232.600374] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b8 <- i=
8042 (interrupt, 0, 1) [3142692]
[31233.065242] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3142738]
[31233.143915] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3142746]
[31233.883402] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1f <- i=
8042 (interrupt, 0, 1) [3142820]
[31233.948145] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9f <- i=
8042 (interrupt, 0, 1) [3142827]
[31233.957975] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 23 <- i=
8042 (interrupt, 0, 1) [3142828]
[31234.042848] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a3 <- i=
8042 (interrupt, 0, 1) [3142836]
[31234.127455] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 18 <- i=
8042 (interrupt, 0, 1) [3142845]
[31234.202627] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 98 <- i=
8042 (interrupt, 0, 1) [3142852]
[31234.252478] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 2c <- i=
8042 (interrupt, 0, 1) [3142857]
[31234.322110] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ac <- i=
8042 (interrupt, 0, 1) [3142864]
[31234.511894] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 25 <- i=
8042 (interrupt, 0, 1) [3142883]
[31234.576324] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: a5 <- i=
8042 (interrupt, 0, 1) [3142890]
[31234.611397] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0f <- i=
8042 (interrupt, 0, 1) [3142893]
[31234.670266] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8f <- i=
8042 (interrupt, 0, 1) [3142899]
[31235.166294] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3142950]
[31235.231555] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3142957]
[31238.315162] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143266]
[31238.319665] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 6c <- i=
8042 (interrupt, 0, 1) [3143266]
[31238.324717] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143267]
[31238.329374] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ec <- i=
8042 (interrupt, 0, 1) [3143267]
[31241.133217] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143548]
[31241.137797] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 32 <- i=
8042 (interrupt, 0, 1) [3143548]
[31241.142853] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143549]
[31241.147505] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b2 <- i=
8042 (interrupt, 0, 1) [3143549]
[31244.291105] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143864]
[31244.295690] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 74 <- i=
8042 (interrupt, 0, 1) [3143865]
[31244.300743] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143865]
[31244.305399] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 <- i=
8042 (interrupt, 0, 1) [3143866]
[31245.282540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143964]
[31245.287072] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 73 <- i=
8042 (interrupt, 0, 1) [3143965]
[31245.292043] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3143965]
[31245.296702] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 <- i=
8042 (interrupt, 0, 1) [3143966]
[31247.021010] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3144139]
[31247.025580] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 57 <- i=
8042 (interrupt, 0, 1) [3144139]
[31247.030625] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3144140]
[31247.035285] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d7 <- i=
8042 (interrupt, 0, 1) [3144140]
[31247.869926] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3144224]
[31247.874536] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 55 <- i=
8042 (interrupt, 0, 1) [3144224]
[31247.879606] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3144225]
[31247.884249] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d5 <- i=
8042 (interrupt, 0, 1) [3144225]
[31260.599603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145499]
[31260.604571] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3145500]
[31260.668950] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145506]
[31260.673995] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3145507]
[31260.928522] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145532]
[31260.933558] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3145533]
[31261.010204] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145541]
[31261.014822] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3145541]
[31261.614467] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145601]
[31261.619531] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 0, 1) [3145602]
[31261.699516] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145610]
[31261.704117] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c7 <- i=
8042 (interrupt, 0, 1) [3145610]
[31262.338908] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145674]
[31262.343503] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 53 <- i=
8042 (interrupt, 0, 1) [3145674]
[31262.433130] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3145683]
[31262.438189] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d3 <- i=
8042 (interrupt, 0, 1) [3145684]
[31265.024508] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3145944]
[31265.024508] PM: Syncing filesystems ... done.
[31265.026074] PM: Preparing system for mem sleep
[31265.065665] Freezing user space processes ... (elapsed 0.00 seconds) don=
e.
[31265.065908] Freezing remaining freezable tasks ... (elapsed 0.00 seconds=
) done.
[31265.065973] PM: Entering mem sleep
[31265.065978] Suspending console(s)
[31265.093470] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3145951]
[31265.106152] b44: lan: powering down PHY
[31265.126157] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145955]
[31265.126219] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f5 -> i=
8042 (parameter) [3145955]
[31265.128511] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145955]
[31265.128532] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145955]
[31265.128594] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3145955]
[31265.130885] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145955]
[31265.130903] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145955]
[31265.130964] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3145955]
[31265.133255] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145955]
[31265.133272] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145955]
[31265.133334] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3145955]
[31265.135619] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145955]
[31265.135636] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145955]
[31265.135697] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3145955]
[31265.137978] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145956]
[31265.137978] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145956]
[31265.137978] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3145956]
[31265.140241] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145956]
[31265.140241] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145956]
[31265.140241] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3145956]
[31265.142510] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145956]
[31265.142510] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145956]
[31265.142510] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3145956]
[31265.144771] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145956]
[31265.144771] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145956]
[31265.144771] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3145956]
[31265.147043] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145957]
[31265.147043] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145957]
[31265.147043] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3145957]
[31265.149308] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145957]
[31265.149308] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145957]
[31265.149308] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (parameter) [3145957]
[31265.151579] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145957]
[31265.151579] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145957]
[31265.151579] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 -> i=
8042 (parameter) [3145957]
[31265.153844] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145957]
[31265.153844] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145957]
[31265.153844] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ff -> i=
8042 (parameter) [3145957]
[31265.156113] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145958]
[31265.535592] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (interrupt, 1, 12) [3145996]
[31265.537301] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [3145996]
[31265.537301] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3145996]
[31265.537301] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 -> i=
8042 (parameter) [3145996]
[31265.539573] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3145996]
[31265.539573] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ff -> i=
8042 (kbd-data) [3145996]
[31265.542454] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3145996]
[31265.651574] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (interrupt, 0, 1) [3146007]
[31265.743955] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [3146017]
[31265.744016] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 -> i=
8042 (parameter) [3146017]
[31265.744036] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[31265.744487] sd 0:0:0:0: [sda] Stopping disk
[31266.805893] drm_sysfs_suspend
[31266.821478] drm_sysfs_suspend
[31266.822296] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[31266.841930] nsc-ircc 00:08: disabled
[31266.861517] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[31266.861750] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[31266.861860] ACPI: Cannot set device to a higher-powered state than parent
[31266.861913] ACPI: Cannot set device to a higher-powered state than parent
[31266.861967] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[31266.862068] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[31266.881392] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[31266.881426] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[31266.881459] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[31266.890035] ACPI: Preparing to enter system sleep state S3
[31266.891500] ACPI: EC: missing OBF confirmation, don't expect it any long=
er.
[31266.902990] cpufreq: suspend failed to assert current frequency is what =
timing core thinks it is.
[31266.903238]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep st=
ate [S3]
[31266.903238] Intel machine check architecture supported.
[31266.903259] Intel machine check reporting enabled on CPU#0.
[31266.903360] Back to C!
[31266.903374] cpufreq: resume failed to assert current frequency is what t=
iming core thinks it is.
[31266.903777] Force enabled HPET at resume
[31266.915651] PM: Writing back config space on device 0000:00:02.0 at offs=
et f (was 100, writing 10b)
[31266.915673] PM: Writing back config space on device 0000:00:02.0 at offs=
et 6 (was 1, writing 1801)
[31266.915683] PM: Writing back config space on device 0000:00:02.0 at offs=
et 5 (was 0, writing e0000000)
[31266.915694] PM: Writing back config space on device 0000:00:02.0 at offs=
et 4 (was 8, writing e8000008)
[31266.915707] PM: Writing back config space on device 0000:00:02.0 at offs=
et 1 (was 900000, writing 900003)
[31266.922980] PM: Writing back config space on device 0000:00:02.1 at offs=
et 5 (was 0, writing e0080000)
[31266.922980] PM: Writing back config space on device 0000:00:02.1 at offs=
et 4 (was 8, writing f0000008)
[31266.922980] PM: Writing back config space on device 0000:00:02.1 at offs=
et 1 (was 900000, writing 900003)
[31266.922980] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[31266.922980] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[31266.922980] usb usb1: root hub lost power or was reset
[31266.922980] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[31266.922980] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[31266.922980] usb usb3: root hub lost power or was reset
[31266.922980] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[31266.922980] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[31266.922980] usb usb4: root hub lost power or was reset
[31267.472275] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10=
 (level, low) -> IRQ 10
[31267.472275] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[31267.472275] PM: Writing back config space on device 0000:00:1d.7 at offs=
et 1 (was 2900006, writing 2900106)
[31267.472275] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 9 (was fff0, writing 37f03000)
[31267.472275] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 7 (was 22803030, writing 2803030)
[31267.472275] PM: Writing back config space on device 0000:00:1e.0 at offs=
et 1 (was 80800105, writing 80800107)
[31267.472275] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[31267.472275] PM: Writing back config space on device 0000:00:1f.1 at offs=
et f (was 100, writing 1ff)
[31267.472275] PM: Writing back config space on device 0000:00:1f.1 at offs=
et 9 (was 0, writing 38000000)
[31267.472275] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[31267.472275] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[31267.478264] ata2.01: _GTF evaluation failed (AE 0x1001)
[31267.482275] ata1.01: _GTF evaluation failed (AE 0x1001)
[31267.482275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et f (was 200, writing 20a)
[31267.482275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 7 (was 0, writing e0100800)
[31267.482275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 6 (was 0, writing e0100c00)
[31267.482275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 5 (was 1301, writing 18c1)
[31267.482275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 4 (was 1201, writing 1c01)
[31267.482275] PM: Writing back config space on device 0000:00:1f.5 at offs=
et 1 (was 2900005, writing 2900003)
[31267.482275] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10=
 (level, low) -> IRQ 10
[31267.482275] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[31272.138637] ata2.01: failed to IDENTIFY (I/O error, err_mask=3D0x100)
[31272.138645] ata2: failed to recover some devices, retrying in 5 secs
[31272.143222] PM: Writing back config space on device 0000:00:1f.6 at offs=
et f (was 200, writing 20a)
[31272.143364] PM: Writing back config space on device 0000:00:1f.6 at offs=
et 1 (was 2900005, writing 2900001)
[31273.241797] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[31273.241809] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10=
 (level, low) -> IRQ 10
[31273.241831] PM: Writing back config space on device 0000:02:02.0 at offs=
et f (was 100, writing 10b)
[31273.241864] PM: Writing back config space on device 0000:02:02.0 at offs=
et 4 (was 0, writing e0204000)
[31273.241877] PM: Writing back config space on device 0000:02:02.0 at offs=
et 3 (was 0, writing 4000)
[31273.241891] PM: Writing back config space on device 0000:02:02.0 at offs=
et 1 (was 100002, writing 100106)
[31273.241925] PM: Writing back config space on device 0000:02:04.0 at offs=
et f (was 22020100, writing 2202010b)
[31273.241961] PM: Writing back config space on device 0000:02:04.0 at offs=
et 4 (was 0, writing e0206000)
[31273.241974] PM: Writing back config space on device 0000:02:04.0 at offs=
et 3 (was 0, writing 4008)
[31273.241989] PM: Writing back config space on device 0000:02:04.0 at offs=
et 1 (was 2900000, writing 2900116)
[31273.242026] PM: Writing back config space on device 0000:02:06.0 at offs=
et e (was 1, writing 34fd)
[31273.242039] PM: Writing back config space on device 0000:02:06.0 at offs=
et d (was 1, writing 3401)
[31273.242051] PM: Writing back config space on device 0000:02:06.0 at offs=
et c (was 1, writing 30fd)
[31273.242064] PM: Writing back config space on device 0000:02:06.0 at offs=
et b (was 1, writing 3001)
[31273.242077] PM: Writing back config space on device 0000:02:06.0 at offs=
et a (was 0, writing 3ffff000)
[31273.242089] PM: Writing back config space on device 0000:02:06.0 at offs=
et 9 (was 0, writing 3c000000)
[31273.242102] PM: Writing back config space on device 0000:02:06.0 at offs=
et 8 (was 0, writing 33fff000)
[31273.242115] PM: Writing back config space on device 0000:02:06.0 at offs=
et 7 (was 0, writing 30000000)
[31273.242128] PM: Writing back config space on device 0000:02:06.0 at offs=
et 6 (was 40000000, writing b0060302)
[31273.242143] PM: Writing back config space on device 0000:02:06.0 at offs=
et 4 (was 0, writing e0207000)
[31273.242161] PM: Writing back config space on device 0000:02:06.0 at offs=
et 1 (was 4100087, writing 4100187)
[31273.242202] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[31273.242230] PM: Writing back config space on device 0000:02:06.1 at offs=
et f (was 100, writing 18001ff)
[31273.242243] PM: Writing back config space on device 0000:02:06.1 at offs=
et e (was 1, writing 3cfd)
[31273.242256] PM: Writing back config space on device 0000:02:06.1 at offs=
et d (was 1, writing 3c01)
[31273.242269] PM: Writing back config space on device 0000:02:06.1 at offs=
et c (was 1, writing 38fd)
[31273.242281] PM: Writing back config space on device 0000:02:06.1 at offs=
et b (was 1, writing 3801)
[31273.242294] PM: Writing back config space on device 0000:02:06.1 at offs=
et a (was 0, writing 43fff000)
[31273.242307] PM: Writing back config space on device 0000:02:06.1 at offs=
et 9 (was 0, writing 40000000)
[31273.242319] PM: Writing back config space on device 0000:02:06.1 at offs=
et 8 (was 0, writing 37fff000)
[31273.242332] PM: Writing back config space on device 0000:02:06.1 at offs=
et 7 (was 0, writing 34000000)
[31273.242345] PM: Writing back config space on device 0000:02:06.1 at offs=
et 6 (was 0, writing b00a0702)
[31273.242360] PM: Writing back config space on device 0000:02:06.1 at offs=
et 4 (was 0, writing e0208000)
[31273.242372] PM: Writing back config space on device 0000:02:06.1 at offs=
et 3 (was 820000, writing 824000)
[31273.242388] PM: Writing back config space on device 0000:02:06.1 at offs=
et 1 (was 4100080, writing 4100107)
[31273.242428] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10=
 (level, low) -> IRQ 10
[31273.328752] ata1.00: ACPI cmd 03/45:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[31273.328752] PM: Writing back config space on device 0000:02:07.0 at offs=
et f (was 4020100, writing 402010a)
[31273.328752] PM: Writing back config space on device 0000:02:07.0 at offs=
et 5 (was 0, writing e0200000)
[31273.328752] PM: Writing back config space on device 0000:02:07.0 at offs=
et 4 (was 0, writing e0209000)
[31273.328752] PM: Writing back config space on device 0000:02:07.0 at offs=
et 3 (was 0, writing 4008)
[31273.328752] PM: Writing back config space on device 0000:02:07.0 at offs=
et 1 (was 2100002, writing 2100116)
[31273.331069] ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[31275.811248] ata1.00: configured for UDMA/100
[31275.811350] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012=
 MB)
[31275.811388] sd 0:0:0:0: [sda] Write Protect is off
[31275.811395] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[31275.811449] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[31277.864984] nsc-ircc 00:08: activated
[31278.911941] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11=
 (level, low) -> IRQ 11
[31282.454576] ata2.01: NODEV after polling detection
[31282.454576] sd 0:0:0:0: [sda] Starting disk
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (flush, aux) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 74 -> i=
8042 (parameter) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 56 -> i=
8042 (parameter) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 60 -> i=
8042 (command) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 -> i=
8042 (parameter) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 59 -> i=
8042 (command) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 90 -> i=
8042 (parameter) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f2 -> i=
8042 (kbd-data) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 0, 1) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152931]
[31282.774909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152931]
[31282.774929] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3152933]
[31282.776854] ata2.00: ACPI cmd 03/42:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[31282.777359] ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (S=
tat=3D0x51 Err=3D0x04)
[31282.778278] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152933]
[31282.778302] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152933]
[31282.784909] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152933]
[31282.787162] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152935]
[31282.787187] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152935]
[31282.787306] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152935]
[31282.789512] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152935]
[31282.789534] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152935]
[31282.789600] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152935]
[31282.791808] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152936]
[31282.791831] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152936]
[31282.791950] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152936]
[31282.794159] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152936]
[31282.794181] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152936]
[31282.794247] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152936]
[31282.796429] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152936]
[31282.796429] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152936]
[31282.796429] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152936]
[31282.798603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152936]
[31282.798603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152936]
[31282.798603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152936]
[31282.800770] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152936]
[31282.800770] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152936]
[31282.800770] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [3152936]
[31282.802965] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152937]
[31282.804076] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 08 <- i=
8042 (interrupt, 1, 12) [3152937]
[31282.805187] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 1, 12) [3152937]
[31282.806302] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 15 <- i=
8042 (interrupt, 1, 12) [3152937]
[31282.806302] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152937]
[31282.806302] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ff -> i=
8042 (parameter) [3152937]
[31282.808476] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152937]
[31282.814246] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ab <- i=
8042 (interrupt, 0, 1) [3152938]
[31282.818970] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 41 <- i=
8042 (interrupt, 0, 1) [3152938]
[31283.188199] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: aa <- i=
8042 (interrupt, 1, 12) [3152975]
[31283.189431] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [3152975]
[31283.189431] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152975]
[31283.189431] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152975]
[31283.191605] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152976]
[31283.191605] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152976]
[31283.191605] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152976]
[31283.193777] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152976]
[31283.193777] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152976]
[31283.193777] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152976]
[31283.195946] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152976]
[31283.195946] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152976]
[31283.195946] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152976]
[31283.198119] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152976]
[31283.198119] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152976]
[31283.198119] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152976]
[31283.200285] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152976]
[31283.200285] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152976]
[31283.200285] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152976]
[31283.201573] ata2.00: configured for UDMA/33
[31283.201597] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[31283.201603] ata2: ACPI event
[31283.201679] ata2: soft resetting link
[31283.203394] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152977]
[31283.203417] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152977]
[31283.203537] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152977]
[31283.205740] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152977]
[31283.205762] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152977]
[31283.205881] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152977]
[31283.208088] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152977]
[31283.208110] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152977]
[31283.208229] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152977]
[31283.210412] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152977]
[31283.210412] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152977]
[31283.210412] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [3152977]
[31283.212608] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152978]
[31283.213718] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 08 <- i=
8042 (interrupt, 1, 12) [3152978]
[31283.214834] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 1, 12) [3152978]
[31283.215952] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 15 <- i=
8042 (interrupt, 1, 12) [3152978]
[31283.215952] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152978]
[31283.215952] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152978]
[31283.218123] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152978]
[31283.218123] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152978]
[31283.218123] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152978]
[31283.220293] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152978]
[31283.220293] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152978]
[31283.220293] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152978]
[31283.222460] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152979]
[31283.222460] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152979]
[31283.222460] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152979]
[31283.224632] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152979]
[31283.224632] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152979]
[31283.224632] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152979]
[31283.226798] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152979]
[31283.226798] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152979]
[31283.226798] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152979]
[31283.228969] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152979]
[31283.228969] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152979]
[31283.228969] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152979]
[31283.231134] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152980]
[31283.231134] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152980]
[31283.231134] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152980]
[31283.233308] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152980]
[31283.233308] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152980]
[31283.233308] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 03 -> i=
8042 (parameter) [3152980]
[31283.235472] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152980]
[31283.235472] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152980]
[31283.235472] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [3152980]
[31283.237666] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152980]
[31283.238785] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9d <- i=
8042 (interrupt, 1, 12) [3152980]
[31283.239897] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 1, 12) [3152980]
[31283.241015] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b1 <- i=
8042 (interrupt, 1, 12) [3152981]
[31283.241015] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152981]
[31283.241015] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152981]
[31283.243189] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152981]
[31283.243189] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152981]
[31283.243189] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152981]
[31283.245361] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152981]
[31283.245361] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152981]
[31283.245361] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152981]
[31283.247528] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152981]
[31283.247528] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152981]
[31283.247528] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152981]
[31283.249700] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152981]
[31283.249700] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152981]
[31283.249700] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152981]
[31283.251868] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152982]
[31283.251868] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152982]
[31283.251868] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152982]
[31283.254041] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152982]
[31283.254041] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152982]
[31283.254041] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152982]
[31283.256204] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152982]
[31283.256204] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152982]
[31283.256204] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152982]
[31283.258372] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152982]
[31283.258372] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152982]
[31283.258372] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 -> i=
8042 (parameter) [3152982]
[31283.260540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152983]
[31283.260540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152983]
[31283.260540] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [3152983]
[31283.262736] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152983]
[31283.263859] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 90 <- i=
8042 (interrupt, 1, 12) [3152983]
[31283.264971] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 47 <- i=
8042 (interrupt, 1, 12) [3152983]
[31283.266086] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 13 <- i=
8042 (interrupt, 1, 12) [3152983]
[31283.266086] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152983]
[31283.266086] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152983]
[31283.268257] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152983]
[31283.268257] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152983]
[31283.268257] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152983]
[31283.270429] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152984]
[31283.270429] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152984]
[31283.270429] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152984]
[31283.272595] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152984]
[31283.272595] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152984]
[31283.272595] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152984]
[31283.274765] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152984]
[31283.274765] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152984]
[31283.274765] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152984]
[31283.276933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152984]
[31283.276933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152984]
[31283.276933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152984]
[31283.279105] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152984]
[31283.279105] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152984]
[31283.279105] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 -> i=
8042 (parameter) [3152984]
[31283.281268] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152985]
[31283.281268] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152985]
[31283.281268] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152985]
[31283.283438] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152985]
[31283.283438] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152985]
[31283.283438] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [3152985]
[31283.285603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152985]
[31283.285603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152985]
[31283.285603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e9 -> i=
8042 (parameter) [3152985]
[31283.287796] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152985]
[31283.288908] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 <- i=
8042 (interrupt, 1, 12) [3152985]
[31283.290020] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 40 <- i=
8042 (interrupt, 1, 12) [3152986]
[31283.291137] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 06 <- i=
8042 (interrupt, 1, 12) [3152986]
[31283.291137] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152986]
[31283.291137] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152986]
[31283.293312] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152986]
[31283.293312] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152986]
[31283.293312] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152986]
[31283.295484] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152986]
[31283.295484] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152986]
[31283.295484] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 02 -> i=
8042 (parameter) [3152986]
[31283.297647] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152986]
[31283.297647] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152986]
[31283.297647] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152986]
[31283.299819] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152987]
[31283.299819] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152987]
[31283.299819] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152987]
[31283.301986] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152987]
[31283.301986] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152987]
[31283.301986] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152987]
[31283.304156] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152987]
[31283.304156] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152987]
[31283.304156] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [3152987]
[31283.306321] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152987]
[31283.306321] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152987]
[31283.306321] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152987]
[31283.308492] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152988]
[31283.308492] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152988]
[31283.308492] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [3152988]
[31283.310656] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152988]
[31283.310656] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152988]
[31283.310656] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (parameter) [3152988]
[31283.312826] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152988]
[31283.312826] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152988]
[31283.312826] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 -> i=
8042 (parameter) [3152988]
[31283.314993] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152988]
[31283.314993] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152988]
[31283.314993] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152988]
[31283.317165] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152988]
[31283.317165] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152988]
[31283.317165] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152988]
[31283.319336] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152989]
[31283.319336] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152989]
[31283.319336] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 03 -> i=
8042 (parameter) [3152989]
[31283.321500] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152989]
[31283.321500] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152989]
[31283.321500] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152989]
[31283.323671] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152989]
[31283.323671] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152989]
[31283.323671] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (parameter) [3152989]
[31283.325837] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152989]
[31283.325837] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152989]
[31283.325837] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152989]
[31283.328010] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152990]
[31283.328010] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152990]
[31283.328010] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [3152990]
[31283.330177] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152990]
[31283.330177] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152990]
[31283.330177] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152990]
[31283.332348] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152990]
[31283.332348] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152990]
[31283.332348] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 01 -> i=
8042 (parameter) [3152990]
[31283.334513] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152990]
[31283.334513] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152990]
[31283.334513] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (parameter) [3152990]
[31283.336685] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152990]
[31283.336685] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152990]
[31283.336685] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 14 -> i=
8042 (parameter) [3152990]
[31283.338854] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152990]
[31283.338854] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152990]
[31283.338854] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e8 -> i=
8042 (parameter) [3152990]
[31283.341055] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152991]
[31283.341077] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152991]
[31283.341196] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 03 -> i=
8042 (parameter) [3152991]
[31283.343400] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152991]
[31283.343422] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152991]
[31283.343488] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e6 -> i=
8042 (parameter) [3152991]
[31283.345697] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152991]
[31283.345719] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d4 -> i=
8042 (command) [3152991]
[31283.345838] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 -> i=
8042 (parameter) [3152991]
[31283.348050] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 1, 12) [3152992]
[31287.581873] ata2.01: NODEV after polling detection
[31289.314558] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 3a <- i=
8042 (interrupt, 0, 1) [3154057]
[31289.434470] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ba <- i=
8042 (interrupt, 0, 1) [3154069]
[31291.093202] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 3a <- i=
8042 (interrupt, 0, 1) [3154235]
[31291.222031] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ba <- i=
8042 (interrupt, 0, 1) [3154235]
[31294.257468] ata2.00: configured for UDMA/33
[31294.257490] ata2: EH complete
[31295.254209] b44: lan: Link is up at 100 Mbps, full duplex.
[31295.254209] b44: lan: Flow control is off for TX and off for RX.
[31299.159934] PM: Finishing wakeup.
[31299.159940] Restarting tasks ... <6>usb 4-2: USB disconnect, address 2
[31299.160297] usb 4-2.3: USB disconnect, address 3
[31299.189114] done.
[31299.229114] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f2 -> i=
8042 (kbd-data) [3155049]
[31299.231528] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3155050]
[31299.236934] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ab <- i=
8042 (interrupt, 0, 1) [3155050]
[31299.242082] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 41 <- i=
8042 (interrupt, 0, 1) [3155051]
[31299.242082] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ed -> i=
8042 (kbd-data) [3155051]
[31299.244582] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3155051]
[31299.244582] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (kbd-data) [3155051]
[31299.247171] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3155051]
[31299.247171] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f3 -> i=
8042 (kbd-data) [3155051]
[31299.249994] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3155052]
[31299.249994] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 00 -> i=
8042 (kbd-data) [3155052]
[31299.252297] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3155052]
[31299.252297] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: f4 -> i=
8042 (kbd-data) [3155052]
[31299.255366] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: fa <- i=
8042 (interrupt, 0, 1) [3155052]
[31299.255366] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input7
[31304.018196] hub 2-0:1.0: unable to enumerate USB device on port 6
[31309.283870] usb 4-2: new full speed USB device using uhci_hcd and addres=
s 4
[31314.175520] usb 4-2: configuration #1 chosen from 1 choice
[31314.179679] hub 4-2:1.0: USB hub found
[31314.179679] hub 4-2:1.0: 3 ports detected
[31315.143923] usb 4-2: New USB device found, idVendor=3D0451, idProduct=3D=
2036
[31315.143923] usb 4-2: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[31315.143923] usb 4-2: Product: General Purpose USB Hub
[31319.409546] usb 4-2.3: new full speed USB device using uhci_hcd and addr=
ess 5
[31320.243601] usb 4-2.3: configuration #1 chosen from 1 choice
[31320.244925] usb 4-2.3: New USB device found, idVendor=3D0483, idProduct=
=3D1307
[31320.244925] usb 4-2.3: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[31320.244925] usb 4-2.3: Product: USB Mass Storage Device
[31320.244925] usb 4-2.3: Manufacturer: Generic
[31320.244925] usb 4-2.3: SerialNumber: ABCDEF0123456789
[31320.331745] Initializing USB Mass Storage driver...
[31320.331745] scsi3 : SCSI emulation for USB Mass Storage devices
[31320.331745] usbcore: registered new interface driver usb-storage
[31320.331745] USB Mass Storage support registered.
[31320.331745] usb-storage: device found at 5
[31320.331745] usb-storage: waiting for device to settle before scanning
[31322.655697] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157393]
[31322.660282] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3157394]
[31322.745256] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157394]
[31322.750173] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3157403]
[31323.430001] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157471]
[31323.435093] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3157471]
[31323.518904] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157480]
[31323.524077] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3157480]
[31325.253145] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3157653]
[31325.327915] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 9c <- i=
8042 (interrupt, 0, 1) [3157661]
[31325.329689] usb-storage: device scan complete
[31325.332383] scsi 3:0:0:0: Direct-Access     Generic  Flash R/W        20=
02 PQ: 0 ANSI: 2
[31325.340943] sd 3:0:0:0: [sdb] Attached SCSI removable disk
[31325.341438] sd 3:0:0:0: Attached scsi generic sg2 type 0
[31326.575813] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157784]
[31326.581223] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 6c <- i=
8042 (interrupt, 0, 1) [3157785]
[31326.586572] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157785]
[31326.591303] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: ec <- i=
8042 (interrupt, 0, 1) [3157786]
[31328.575338] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157985]
[31328.579989] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 32 <- i=
8042 (interrupt, 0, 1) [3157985]
[31328.585128] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3157986]
[31328.589860] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b2 <- i=
8042 (interrupt, 0, 1) [3157986]
[31330.340327] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158162]
[31330.344953] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 58 <- i=
8042 (interrupt, 0, 1) [3158162]
[31330.344953] atkbd.c: Unknown key pressed (translated set 2, code 0xd8 on=
 isa0060/serio0).
[31330.344953] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
[31330.350094] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158163]
[31330.354744] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d8 <- i=
8042 (interrupt, 0, 1) [3158163]
[31330.354744] atkbd.c: Unknown key released (translated set 2, code 0xd8 o=
n isa0060/serio0).
[31330.354744] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
[31332.487978] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158377]
[31332.492603] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 57 <- i=
8042 (interrupt, 0, 1) [3158378]
[31332.492603] atkbd.c: Unknown key pressed (translated set 2, code 0xd7 on=
 isa0060/serio0).
[31332.492604] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
[31332.497676] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158378]
[31332.502409] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d7 <- i=
8042 (interrupt, 0, 1) [3158379]
[31332.502409] atkbd.c: Unknown key released (translated set 2, code 0xd7 o=
n isa0060/serio0).
[31332.502409] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
[31334.316669] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158560]
[31334.321351] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 56 <- i=
8042 (interrupt, 0, 1) [3158561]
[31334.321351] atkbd.c: Unknown key pressed (translated set 2, code 0xd6 on=
 isa0060/serio0).
[31334.321351] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[31334.326398] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158561]
[31334.331116] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d6 <- i=
8042 (interrupt, 0, 1) [3158562]
[31334.331116] atkbd.c: Unknown key released (translated set 2, code 0xd6 o=
n isa0060/serio0).
[31334.331116] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[31335.655610] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158694]
[31335.660273] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 55 <- i=
8042 (interrupt, 0, 1) [3158694]
[31335.660273] atkbd.c: Unknown key pressed (translated set 2, code 0xd5 on=
 isa0060/serio0).
[31335.660273] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[31335.665668] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3158695]
[31335.670476] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: d5 <- i=
8042 (interrupt, 0, 1) [3158696]
[31335.670476] atkbd.c: Unknown key released (translated set 2, code 0xd5 o=
n isa0060/serio0).
[31335.670476] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[31345.230723] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159655]
[31345.235505] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3159655]
[31345.319859] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159664]
[31345.324964] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3159664]
[31345.599466] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159692]
[31345.604488] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3159692]
[31345.677316] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159700]
[31345.682355] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3159700]
[31346.341933] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159766]
[31346.346490] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3159767]
[31346.440127] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159776]
[31346.444709] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3159777]
[31346.699744] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159802]
[31346.704186] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3159803]
[31346.796082] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159812]
[31346.800685] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3159813]
[31347.225564] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159855]
[31347.230173] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 48 <- i=
8042 (interrupt, 0, 1) [3159856]
[31347.321947] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159865]
[31347.326531] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: c8 <- i=
8042 (interrupt, 0, 1) [3159866]
[31347.771498] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159911]
[31347.775182] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159911]
[31348.014848] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159935]
[31348.019837] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159936]
[31348.049622] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159939]
[31348.054208] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159939]
[31348.083988] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159942]
[31348.089049] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159943]
[31348.118753] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159946]
[31348.123366] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159946]
[31348.153145] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159949]
[31348.158229] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159950]
[31348.187991] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159953]
[31348.192593] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159953]
[31348.222378] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159956]
[31348.227410] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159957]
[31348.257171] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159960]
[31348.261790] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159960]
[31348.291573] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159963]
[31348.296619] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4b <- i=
8042 (interrupt, 0, 1) [3159964]
[31348.346409] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159969]
[31348.351016] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cb <- i=
8042 (interrupt, 0, 1) [3159969]
[31348.660842] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3159969]
[31348.665982] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 4d <- i=
8042 (interrupt, 0, 1) [3160001]
[31348.755949] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: e0 <- i=
8042 (interrupt, 0, 1) [3160010]
[31348.760570] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: cd <- i=
8042 (interrupt, 0, 1) [3160010]
[31349.130252] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0e <- i=
8042 (interrupt, 0, 1) [3160044]
[31349.221681] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8e <- i=
8042 (interrupt, 0, 1) [3160056]
[31349.566212] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 36 <- i=
8042 (interrupt, 0, 1) [3160090]
[31349.661169] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 0b <- i=
8042 (interrupt, 0, 1) [3160100]
[31349.746998] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 8b <- i=
8042 (interrupt, 0, 1) [3160109]
[31349.751619] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: b6 <- i=
8042 (interrupt, 0, 1) [3160109]
[31350.076589] /usr/src/linux-2.6.25.4/drivers/input/serio/i8042.c: 1c <- i=
8042 (interrupt, 0, 1) [3160109]

--MP_/pslP0bYrxjhF2E.g9h_dXvH--
