Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbYEPVAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbYEPVAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbYEPVAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:00:19 -0400
Received: from [158.64.110.160] ([158.64.110.160]:41100 "EHLO
	bonbons.gotdns.org" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756570AbYEPVAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:00:11 -0400
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: Input+S3: extra keycodes forgotten after suspend
Date: Fri, 16 May 2008 23:00:04 +0200
User-Agent: KMail/1.9.7
Cc: Linux Input <linux-input@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
References: <200805162225.44284.bonbons@linux-vserver.org> <20080516163318.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080516163318.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WXfLIz6Mh67oedx"
Message-Id: <200805162300.06027.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, untested
X-SpamProbe: GOOD 0.0000013 5d77c1910e13c42d2195bbdd9ab157a3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WXfLIz6Mh67oedx
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Dmitry,

On Friday 16 May 2008 22:38:07 Dmitry Torokhov wrote:
> Hi Bruno,
>
> On Fri, May 16, 2008 at 10:25:43PM +0200, Bruno Pr?mont wrote:
> > On my Acer TravelMate 660 I lose keycodes for the extra keys (dritek
> > extensions) after resume.
> >
> > The system runs setkeycodes during boot sequence to initialize key codes
> > for the extra keys as below:
> >
> > /usr/bin/setkeycodes KEYCODES="e025 138 e026 141 e027 171 e074 148 e073 149 e055 229 e056 230 e057 227 e058 228"
> > # Fn + F1   ~ e025  => 138 [KEY_HELP] (Help)
> > # Fn + F2   ~ e026  => 141 [KEY_SETUP] (Notebook Manager)
> > # Fn + F3   ~ e027  => 171 [KEY_CONFIG] (Power Options)
> > # Mail      ~ e06c  => 155 [KEY_MAIL] (EMail)
> > # WWW       ~ e032  => 150 [KEY_WWW] (Browser)
> > # P1        ~ e074  => 148 [KEY_PROG1] (P1)
> > # P2        ~ e073  => 149 [KEY_PROG2] (P2)
> > # Bluetooth ~ e058  => 228 [KEY_BLUETOOTH_DISABLE] (Disable Bluetooth)
> > # Bluetooth ~ e057  => 227 [KEY_BLUETOOTH_ENABLE] (Enable Bluetooth)
> > # Wireless  ~ e056  => 230 [KEY_WLAN_DISABLE] (Disable WLAN)
> > # Wireless  ~ e055  => 229 [KEY_WLAN_ENABLE] (Enable WLAN)
> > # Vol UP    ~ e030  => 115 [KEY_VOLUMEUP] (Increase Volume)
> > # Vol DOWN  ~ e02e  => 114 [KEY_VOLUMEDOWN] (Decrease Volume)
> > # Vol Mute  ~ e020  => 113 [KEY_MUTE] (Mute volume)
> >
> > After resume I end up with the following messages when pressing the keys:
> > [  779.695675] atkbd.c: Unknown key pressed (translated set 2, code 0xd6 on isa0060/serio0).
> > [  779.695675] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known. 
> > [  779.705218] atkbd.c: Unknown key released (translated set 2, code 0xd6 on isa0060/serio0).
> > [  779.705218] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known. 
> > [  781.603912] atkbd.c: Unknown key pressed (translated set 2, code 0xd5 on isa0060/serio0).
> > [  781.603912] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
> > [  781.613564] atkbd.c: Unknown key released (translated set 2, code 0xd5 on isa0060/serio0).
> > [  781.613564] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
> > [  782.772662] atkbd.c: Unknown key pressed (translated set 2, code 0xd7 on isa0060/serio0).
> > [  782.772662] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
> > [  782.782390] atkbd.c: Unknown key released (translated set 2, code 0xd7 on isa0060/serio0).
> > [  782.782390] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
> > [  783.461807] atkbd.c: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
> > [  783.461807] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
> > [  783.471544] atkbd.c: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
> > [  783.471544] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
> >
> >
> > Is this kind of issue known, what are the options to get kernel to
> > remember the keycode mappings after s2ram?
>
> Do you unload atkbd or perhaps i8042 for s2ram? Or do you see that
> keyboard is detected again (in dmesg) after resume?

I don't see anything in the logs that would allow to assume this.
Most is built right into the kernel.

Modules that were loaded for suspend/resume process (USB unloaded
before trying to suspend, alsa also stopped):
Module                  Size  Used by
pcspkr                  2176  0 
sunrpc                159996  17 nfs,lockd,nfs_acl
8021q                  17096  0 
xfs                   498804  4 
nsc_ircc               14480  0 
irda                  102584  1 nsc_ircc
crc_ccitt               1792  1 irda
b44                    22224  0 
ssb                    25796  1 b44
i2c_i801                8592  0 
evdev                   8448  1 
usbcore               123952  1 

Modules I loaded back later after resume:
nfs                   123180  4 
lockd                  59208  2 nfs
nfs_acl                 2688  1 nfs
squashfs               38408  1 
zlib_inflate           14720  1 squashfs
loop                   12932  8 
snd_pcm_oss            33888  0 
snd_mixer_oss          13376  1 snd_pcm_oss
snd_intel8x0           27932  3 
snd_ac97_codec         95268  1 snd_intel8x0
ac97_bus                1536  1 snd_ac97_codec
snd_pcm                56712  4 snd_pcm_oss,snd_intel8x0,snd_ac97_codec
snd_timer              18052  2 snd_pcm
snd                    42980  10 snd_pcm_oss,snd_mixer_oss,snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer
snd_page_alloc          7560  2 snd_intel8x0,snd_pcm


Note: the kernel is patched with the two patches I've just sent regarding
      dritek quirk (needed to get any response to they key presses)

Note: suspend/resume is not very stable on this laptop as visible in
      attached dmesg output)

Bruno

--Boundary-00=_WXfLIz6Mh67oedx
Content-Type: text/plain;
  charset="iso-8859-1";
  name="suspend.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="suspend.dmesg"

[    0.000000] Linux version 2.6.25.4 (bruno@neptune) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #8 Fri May 16 20:15:52 CEST 2008
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
[    0.000000] ACPI: RSDT 1DEE5A39, 0030 (r1 ACER   Wagtail  20020114  LTP        0)
[    0.000000] ACPI: FACP 1DEEBF2C, 0074 (r1 ACER   Wagtail  20020114 PTL        50)
[    0.000000] ACPI: DSDT 1DEE5A69, 64C3 (r1 ACER   Wagtail  20020114 MSFT  100000E)
[    0.000000] ACPI: FACS 1DEFCFC0, 0040
[    0.000000] ACPI: HPET 1DEEBFA0, 0038 (r1 ACER   Wagtail  20020114 PTL         0)
[    0.000000] ACPI: BOOT 1DEEBFD8, 0028 (r1 ACER   Wagtail  20020114  LTP        1)
[    0.000000] ACPI: DMI detected: Acer
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0x0 is invalid
[    0.000000] Allocating PCI resources starting at 30000000 (gap: 20000000:dec10000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 121635
[    0.000000] Kernel command line: BOOT_IMAGE=2.6.25.4 ro root=806 softlevel=default video=vesafb:1400x1050-32 lapic hpet=force
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Found and enabled local APIC!
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0463000 soft=c0462000
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Detected 1495.223 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.010000] Memory: 481692k/490368k available (2231k kernel code, 8176k reserved, 998k data, 216k init, 0k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
[    0.010000]     vmalloc : 0xde800000 - 0xfffb3000   ( 535 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xddee0000   ( 478 MB)
[    0.010000]       .init : 0xc0429000 - 0xc045f000   ( 216 kB)
[    0.010000]       .data : 0xc032dd2e - 0xc04277d8   ( 998 kB)
[    0.010000]       .text : 0xc0100000 - 0xc032dd2e   (2231 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=1, Nodes=1
[    0.160002] Calibrating delay using timer specific routine.. 2991.76 BogoMIPS (lpj=14958801)
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
[    0.200338] Freeing SMP alternatives: 0k freed
[    0.200345] ACPI: Core revision 20070126
[    0.212975] Parsing all Control Methods:
[    0.213111] Table [DSDT](id 0001) - 784 Objects with 54 Devices 203 Methods 19 Regions
[    0.213122]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
[    0.213136] ACPI: setting ELCR to 0200 (from 0c00)
[    0.220004] evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
[    0.230000] khelper used greatest stack depth: 3444 bytes left
[    0.230000] net_namespace: 540 bytes
[    0.230000] Time: 20:17:18  Date: 05/16/08
[    0.230000] NET: Registered protocol family 16
[    0.230000] No dock devices found.
[    0.230000] ACPI: bus type pci registered
[    0.230000] PCI: PCI BIOS revision 2.10 entry at 0xfd742, last bus=2
[    0.230000] PCI: Using configuration type 1
[    0.230000] Setting up standard PCI resources
[    0.239000] khelper used greatest stack depth: 3408 bytes left
[    0.239158] khelper used greatest stack depth: 3216 bytes left
[    0.240261] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
[    0.240562] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 5 Wake, Enabled 1 Runtime GPEs in this block
[    0.240578] ACPI: EC: Look up EC in DSDT
[    0.243694] Completing Region/Field/Buffer/Package initialization:.........................................................................
[    0.244936] Initialized 14/19 Regions 3/3 Fields 35/36 Buffers 21/28 Packages (793 nodes)
[    0.244947] Initializing Device/Processor/Thermal objects by executing _INI methods:..
[    0.245279] Executed 2 _INI methods requiring 1 _STA executions (examined 58 objects)
[    0.245297] ACPI: Interpreter enabled
[    0.245303] ACPI: (supports S0 S3 S5)
[    0.245318] ACPI: Using PIC for interrupt routing
[    0.253889] ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
[    0.253902] ACPI: EC: driver started in poll mode
[    0.253955] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.254408] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.254416] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[    0.254427] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
[    0.254812] PCI: Transparent bridge - 0000:00:1e.0
[    0.254859] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.255205] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.259220] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.259371] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.259512] ACPI: PCI Interrupt Link [LNKC] (IRQs *10)
[    0.259653] ACPI: PCI Interrupt Link [LNKD] (IRQs 10) *11
[    0.259796] ACPI: PCI Interrupt Link [LNKE] (IRQs 10) *11
[    0.259937] ACPI: PCI Interrupt Link [LNKF] (IRQs 10) *0, disabled.
[    0.260108] ACPI: PCI Interrupt Link [LNKG] (IRQs 11) *0, disabled.
[    0.260251] ACPI: PCI Interrupt Link [LNKH] (IRQs *10)
[    0.260416] ACPI: Power Resource [PFN0] (off)
[    0.260468] ACPI: Power Resource [PFN1] (off)
[    0.260604] ACPI: WMI: Mapper loaded
[    0.260611] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.260653] pnp: PnP ACPI init
[    0.260665] ACPI: bus type pnp registered
[    0.265782] pnp: PnP ACPI: found 9 devices
[    0.265791] ACPI: ACPI bus type pnp unregistered
[    0.265869] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.266365] SCSI subsystem initialized
[    0.266415] libata version 3.00 loaded.
[    0.266922] PCI: Using ACPI for IRQ routing
[    0.266932] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.272714] hpet clockevent registered
[    0.272719] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.272730] hpet0: 3 64-bit timers, 14318180 Hz
[    0.273784] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.273792] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.273800] system 00:04: ioport range 0x800-0x80f has been reserved
[    0.273808] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.273816] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.273823] system 00:04: ioport range 0x1c0-0x1cf has been reserved
[    0.273831] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.273839] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    0.273847] system 00:04: ioport range 0x610-0x61f has been reserved
[    0.273855] system 00:04: iomem range 0xfec10000-0xfec1ffff could not be reserved
[    0.273865] system 00:04: iomem range 0xff800000-0xffbfffff could not be reserved
[    0.273875] system 00:04: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.273884] system 00:04: iomem range 0x0-0x9ffff could not be reserved
[    0.273892] system 00:04: iomem range 0xe0000-0xfffff could not be reserved
[    0.273900] system 00:04: iomem range 0x0-0x0 could not be reserved
[    0.304386] PCI: Bus 3, cardbus bridge: 0000:02:06.0
[    0.304394]   IO window: 0x00003000-0x000030ff
[    0.304401]   IO window: 0x00003400-0x000034ff
[    0.304409]   PREFETCH window: 0x30000000-0x33ffffff
[    0.304417]   MEM window: 0x3c000000-0x3fffffff
[    0.304424] PCI: Bus 7, cardbus bridge: 0000:02:06.1
[    0.304430]   IO window: 0x00003800-0x000038ff
[    0.304438]   IO window: 0x00003c00-0x00003cff
[    0.304445]   PREFETCH window: 0x34000000-0x37ffffff
[    0.304453]   MEM window: 0x40000000-0x43ffffff
[    0.304461] PCI: Bridge: 0000:00:1e.0
[    0.304467]   IO window: 3000-3fff
[    0.304474]   MEM window: 0xe0200000-0xe07fffff
[    0.304482]   PREFETCH window: 0x0000000030000000-0x0000000037ffffff
[    0.304502] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.304777] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    0.304786] PCI: setting IRQ 10 as level-triggered
[    0.304789] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[    0.304812] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[    0.304835] NET: Registered protocol family 2
[    0.304937] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.305167] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.305315] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.305386] TCP: Hash tables configured (established 16384 bind 16384)
[    0.305394] TCP reno registered
[    0.305551] Simple Boot Flag at 0x37 set to 0x1
[    0.305612] Machine check exception polling timer started.
[    0.308089] khelper used greatest stack depth: 3208 bytes left
[    0.308599] io scheduler noop registered
[    0.308622] io scheduler cfq registered (default)
[    0.308640] pci 0000:00:02.0: Boot video device
[    0.308937] vesafb: framebuffer at 0xe8000000, mapped to 0xde880000, using 5120k, total 32576k
[    0.308949] vesafb: mode is 1280x1024x16, linelength=2560, pages=11
[    0.308956] vesafb: scrolling: redraw
[    0.308962] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.343452] Console: switching to colour frame buffer device 160x64
[    0.375419] fb0: VESA VGA frame buffer device
[    0.376260] ACPI: AC Adapter [ACAD] (on-line)
[    0.376916] ACPI: Battery Slot [BAT1] (battery absent)
[    0.378401] ACPI: Battery Slot [BAT2] (battery absent)
[    0.378723] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.379033] ACPI: Power Button (FF) [PWRF]
[    0.379272] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.379987] ACPI: Lid Switch [LID]
[    0.380000] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.380000] ACPI: Sleep Button (CM) [SLPB]
[    0.380165] ACPI: Transitioning device [FAN0] to D3
[    0.380404] ACPI: PNP0C0B:00 is registered as cooling_device0
[    0.380633] ACPI: Fan [FAN0] (off)
[    0.380903] ACPI: Transitioning device [FAN1] to D3
[    0.381133] ACPI: PNP0C0B:01 is registered as cooling_device1
[    0.381363] ACPI: Fan [FAN1] (off)
[    0.381868] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/input/input3
[    0.382217] ACPI: Video Device [AGP] (multi-head: yes  rom: yes  post: no)
[    0.382692] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.382984] ACPI: ACPI0007:00 is registered as cooling_device2
[    0.384046] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    0.384713] ACPI: Thermal Zone [THRM] (46 C)
[    0.384923] isapnp: Scanning for PnP cards...
[    0.695089] isapnp: No Plug & Play device found
[    0.698083] intel_rng: FWH not detected
[    0.698250] Linux agpgart interface v0.103
[    0.698430] agpgart: Detected an Intel 855GM Chipset.
[    0.699382] agpgart: Detected 32636K stolen memory.
[    0.706765] agpgart: AGP aperture is 128M @ 0xe8000000
[    0.707078] [drm] Initialized drm 1.1.0 20060810
[    0.707564] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.707794] PCI: setting IRQ 11 as level-triggered
[    0.707798] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[    0.708161] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.708249] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.708481] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    0.708558] [drm] Initialized i915 1.6.0 20060119 on minor 1
[    0.710054] acer-wmi: Acer Laptop ACPI-WMI Extras version 0.1
[    0.720023] acer-wmi: No or unsupported WMI interface, unable to load
[    0.730042] Driver 'sd' needs updating - please use bus_type methods
[    0.740045] ata_piix 0000:00:1f.1: version 2.12
[    0.740052] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[    0.750009] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[    0.760028] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.760114] scsi0 : ata_piix
[    0.770069] scsi1 : ata_piix
[    0.780008] Switched to high resolution mode on CPU 0
[    0.781434] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    0.790003] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    0.999944] ata1.00: ATA-6: FUJITSU MHT2060AH, 006C, max UDMA/100
[    0.999947] ata1.00: 117210240 sectors, multi 16: LBA 
[    1.058529] ata1.00: configured for UDMA/100
[    1.397743] ata2.01: NODEV after polling detection
[    1.587494] ata2.00: ATAPI: UJDA740 DVD/CDRW, 1.20, max UDMA/33
[    1.806367] ata2.00: configured for UDMA/33
[    1.806495] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2060A 006C PQ: 0 ANSI: 5
[    1.816491] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
[    1.826383] sd 0:0:0:0: [sda] Write Protect is off
[    1.836370] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.836392] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.846423] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
[    1.856379] sd 0:0:0:0: [sda] Write Protect is off
[    1.866369] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.866390] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.876369]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    2.046620] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.060728] scsi 1:0:0:0: CD-ROM            MATSHITA UJDA740 DVD/CDRW 1.20 PQ: 0 ANSI: 5
[    2.066380] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOU2] at 0x60,0x64 irq 1,12
[    2.077430] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.086159] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.096301] mice: PS/2 mouse device common for all mice
[    2.140488] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.147099] cpuidle: using governor ladder
[    2.150794] cpuidle: using governor menu
[    2.161072] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.170519] TCP cubic registered
[    2.180506] NET: Registered protocol family 1
[    2.190719] NET: Registered protocol family 10
[    2.201093] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.210507] NET: Registered protocol family 17
[    2.220662] Using IPI Shortcut mode
[    2.230808]   Magic number: 8:38:296
[    2.240516]   hash matches device tty29
[    2.254903] Marking TSC unstable due to: TSC halts in idle.
[    2.748051] Clocksource tsc unstable (delta = -484758642 ns)
[    2.815829] Synaptics Touchpad, model: 1, fw: 5.8, id: 0x9d48b1, caps: 0x904713/0x4006
[    2.847947] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input5
[    2.898306] ReiserFS: sda6: found reiserfs format "3.6" with standard journal
[    2.898318] ReiserFS: sda6: using ordered data mode
[    2.921624] ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    2.931672] ReiserFS: sda6: checking transaction log (sda6)
[    2.971821] ReiserFS: sda6: Using r5 hash to sort names
[    2.971903] VFS: Mounted root (reiserfs filesystem) readonly.
[    2.982096] Freeing unused kernel memory: 216k freed
[    3.011782] khelper used greatest stack depth: 2144 bytes left
[    3.796098] cat used greatest stack depth: 1772 bytes left
[    3.858799] init-early.sh used greatest stack depth: 1308 bytes left
[    5.115939] usbcore: registered new interface driver usbfs
[    5.115967] usbcore: registered new interface driver hub
[    5.116024] usbcore: registered new device driver usb
[    5.130508] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    5.130515] ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[    5.130534] PCI: Setting latency timer of device 0000:00:1f.6 to 64
[    5.137417] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.137440] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.149958] Driver 'sr' needs updating - please use bus_type methods
[    5.158439] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    5.158447] Uniform CD-ROM driver Revision: 3.20
[    5.158516] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.161763] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    5.191278] ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[    5.193366] USB Universal Host Controller Interface driver v3.0
[    5.193427] ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[    5.193439] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.193443] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.193712] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    5.193737] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001820
[    5.193898] usb usb1: configuration #1 chosen from 1 choice
[    5.193926] hub 1-0:1.0: USB hub found
[    5.193935] hub 1-0:1.0: 2 ports detected
[    5.291125] firewire_ohci: Added fw-ohci device 0000:02:07.0, OHCI version 1.10
[    5.301138] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.301143] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.301147] usb usb1: Product: UHCI Host Controller
[    5.301150] usb usb1: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    5.301152] usb usb1: SerialNumber: 0000:00:1d.0
[    5.301216] ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[    5.302000] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    5.302003] ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10 (level, low) -> IRQ 10
[    5.302021] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.302025] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.302062] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.305961] ehci_hcd 0000:00:1d.7: debug port 1
[    5.305967] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    5.305978] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xe0100000
[    5.321541] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.321700] usb usb2: configuration #1 chosen from 1 choice
[    5.321730] hub 2-0:1.0: USB hub found
[    5.321741] hub 2-0:1.0: 6 ports detected
[    5.431129] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.431135] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.431138] usb usb2: Product: EHCI Host Controller
[    5.431141] usb usb2: Manufacturer: Linux 2.6.25.4 ehci_hcd
[    5.431143] usb usb2: SerialNumber: 0000:00:1d.7
[    5.431513] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    5.431517] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
[    5.551089] ssb: Sonics Silicon Backplane found on PCI device 0000:02:02.0
[    5.551127] b44.c:v2.0
[    5.551229] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[    5.551263] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    5.590872] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:2d:03:9d
[    5.603660] udev: renamed network interface eth0 to lan
[    5.710253] hub 2-0:1.0: unable to enumerate USB device on port 6
[    5.790405] firewire_core: created device fw0: GUID 00c09f00000fc03c, S400
[    5.842673] NET: Registered protocol family 23
[    5.882685] nsc-ircc, chip->init
[    5.882700] nsc-ircc, Found chip at base=0x04e
[    5.882729] nsc-ircc, driver loaded (Dag Brattli)
[    5.884197] IrDA: Registered device irda0
[    5.884260] nsc-ircc, Found dongle: HP HSDL-1100/HSDL-2100
[    6.410122] intel8x0_measure_ac97_clock: measured 59417 usecs
[    6.410131] intel8x0: clocking to 48000
[    6.413032] ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
[    6.413056] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    6.413065] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.413136] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    6.413173] uhci_hcd 0000:00:1d.1: irq 10, io base 0x00001840
[    6.413468] usb usb3: configuration #1 chosen from 1 choice
[    6.413531] hub 3-0:1.0: USB hub found
[    6.413549] hub 3-0:1.0: 2 ports detected
[    6.519781] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.519790] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.519798] usb usb3: Product: UHCI Host Controller
[    6.519804] usb usb3: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    6.519809] usb usb3: SerialNumber: 0000:00:1d.1
[    6.520429] ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[    6.520449] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    6.520457] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.520519] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    6.520552] uhci_hcd 0000:00:1d.2: irq 10, io base 0x00001860
[    6.520822] usb usb4: configuration #1 chosen from 1 choice
[    6.520881] hub 4-0:1.0: USB hub found
[    6.520897] hub 4-0:1.0: 2 ports detected
[    6.629670] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.629681] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.629688] usb usb4: Product: UHCI Host Controller
[    6.629694] usb usb4: Manufacturer: Linux 2.6.25.4 uhci_hcd
[    6.629700] usb usb4: SerialNumber: 0000:00:1d.2
[    6.891996] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    7.060432] usb 4-2: configuration #1 chosen from 1 choice
[    7.072339] hub 4-2:1.0: USB hub found
[    7.074273] hub 4-2:1.0: 3 ports detected
[    7.179662] usb 4-2: New USB device found, idVendor=0451, idProduct=2036
[    7.179674] usb 4-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    7.179681] usb 4-2: Product: General Purpose USB Hub
[    7.412666] usb 4-2.3: new full speed USB device using uhci_hcd and address 3
[    7.573818] usb 4-2.3: configuration #1 chosen from 1 choice
[    7.576956] usb 4-2.3: New USB device found, idVendor=0483, idProduct=1307
[    7.576960] usb 4-2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    7.576963] usb 4-2.3: Product: USB Mass Storage Device
[    7.576965] usb 4-2.3: Manufacturer: Generic
[    7.576967] usb 4-2.3: SerialNumber: ABCDEF0123456789
[    7.606351] Initializing USB Mass Storage driver...
[    7.606610] scsi2 : SCSI emulation for USB Mass Storage devices
[    7.610814] usbcore: registered new interface driver usb-storage
[    7.610818] USB Mass Storage support registered.
[    7.611629] usb-storage: device found at 3
[    7.611632] usb-storage: waiting for device to settle before scanning
[   12.351821] usb-storage: device scan complete
[   12.354798] scsi 2:0:0:0: Direct-Access     Generic  Flash R/W        2002 PQ: 0 ANSI: 2
[   12.361902] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[   12.362000] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   16.179492] SGI XFS with ACLs, no debug enabled
[   16.183644] SGI XFS Quota Management subsystem
[   16.229617] XFS mounting filesystem sda9
[   16.346670] Ending clean XFS mount for filesystem: sda9
[   17.913493] dumpkeys used greatest stack depth: 1240 bytes left
[   18.600791] ADDRCONF(NETDEV_UP): lan: link is not ready
[   18.847386] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   18.847391] All bugs added by David S. Miller <davem@redhat.com>
[   18.905441] ADDRCONF(NETDEV_UP): lan.658: link is not ready
[   19.186626] Adding 1004020k swap on /dev/sda5.  Priority:-1 extents:1 across:1004020k
[   22.110026] b44: lan: Link is up at 100 Mbps, full duplex.
[   22.110038] b44: lan: Flow control is off for TX and off for RX.
[   22.110516] ADDRCONF(NETDEV_CHANGE): lan: link becomes ready
[   22.111542] ADDRCONF(NETDEV_CHANGE): lan.658: link becomes ready
[   28.212892] RPC: Registered udp transport module.
[   28.212904] RPC: Registered tcp transport module.
[   28.487085] mount.nfs used greatest stack depth: 908 bytes left
[   28.639715] loop: module loaded
[   28.679480] squashfs: version 3.3 (2007/10/31) Phillip Lougher
[   32.536948] lan.658: no IPv6 routers present
[   59.035774] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[   59.057345] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[  103.307142] usbcore: deregistering interface driver usb-storage
[  103.312303] uhci_hcd 0000:00:1d.2: remove, state 1
[  103.312328] usb usb4: USB disconnect, address 1
[  103.312334] usb 4-2: USB disconnect, address 2
[  103.312340] usb 4-2.3: USB disconnect, address 3
[  103.314470] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
[  103.314536] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  103.314554] uhci_hcd 0000:00:1d.1: remove, state 4
[  103.314567] usb usb3: USB disconnect, address 1
[  103.314822] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
[  103.314869] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  103.314886] uhci_hcd 0000:00:1d.0: remove, state 4
[  103.314898] usb usb1: USB disconnect, address 1
[  103.315151] uhci_hcd 0000:00:1d.0: USB bus 1 deregistered
[  103.315197] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[  103.315502] ehci_hcd 0000:00:1d.7: remove, state 4
[  103.315516] usb usb2: USB disconnect, address 1
[  103.319243] ehci_hcd 0000:00:1d.7: USB bus 2 deregistered
[  103.319421] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  103.468325] ACPI: PCI interrupt for device 0000:02:07.0 disabled
[  103.468338] firewire_ohci: Removed fw-ohci device.
[  103.490871] Uniform CD-ROM driver unloaded
[  103.517949] Driver 'sr' needs updating - please use bus_type methods
[  103.523871] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[  103.523884] Uniform CD-ROM driver Revision: 3.20
[  103.524025] sr 1:0:0:0: Attached scsi CD-ROM sr0
[  139.449500] Uniform CD-ROM driver unloaded
[  139.479537] Driver 'sr' needs updating - please use bus_type methods
[  139.485453] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[  139.485466] Uniform CD-ROM driver Revision: 3.20
[  139.485608] sr 1:0:0:0: Attached scsi CD-ROM sr0
[  177.662904] Uniform CD-ROM driver unloaded
[  177.760677] sr_mod: Unknown symbol register_cdrom
[  177.760677] sr_mod: Unknown symbol cdrom_ioctl
[  177.760677] sr_mod: Unknown symbol cdrom_media_changed
[  177.760677] sr_mod: Unknown symbol cdrom_get_media_event
[  177.760677] sr_mod: Unknown symbol cdrom_release
[  177.760677] sr_mod: Unknown symbol cdrom_open
[  177.760677] sr_mod: Unknown symbol unregister_cdrom
[  177.760677] sr_mod: Unknown symbol cdrom_number_of_slots
[  238.140902] PM: Syncing filesystems ... done.
[  238.145918] PM: Preparing system for mem sleep
[  238.189071] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  238.189726] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  238.189807] PM: Entering mem sleep
[  238.189812] Suspending console(s)
[  238.190003] b44: lan: powering down PHY
[  238.819251] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  238.819760] sd 0:0:0:0: [sda] Stopping disk
[  239.887361] drm_sysfs_suspend
[  239.907537] drm_sysfs_suspend
[  239.908355] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[  239.927989] nsc-ircc 00:08: disabled
[  239.928441] ACPI: PCI interrupt for device 0000:02:02.0 disabled
[  239.928593] ACPI: Cannot set device to a higher-powered state than parent
[  239.928647] ACPI: Cannot set device to a higher-powered state than parent
[  239.928700] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
[  239.937481] ACPI: Preparing to enter system sleep state S3
[  239.937626] ACPI: EC: missing write data confirmation, don't expect it any longer.
[  239.939035] cpufreq: suspend failed to assert current frequency is what timing core thinks it is.
[  239.939282]  hwsleep-0322 [00] enter_sleep_state     : Entering sleep state [S3]
[  239.939282] Intel machine check architecture supported.
[  239.939303] Intel machine check reporting enabled on CPU#0.
[  239.939403] Back to C!
[  239.939415] cpufreq: resume failed to assert current frequency is what timing core thinks it is.
[  239.939820] Force enabled HPET at resume
[  239.957481] PM: Writing back config space on device 0000:00:02.0 at offset f (was 100, writing 10b)
[  239.957481] PM: Writing back config space on device 0000:00:02.0 at offset 6 (was 1, writing 1801)
[  239.957481] PM: Writing back config space on device 0000:00:02.0 at offset 5 (was 0, writing e0000000)
[  239.957481] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 8, writing e8000008)
[  239.957481] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was 900000, writing 900003)
[  239.960697] PM: Writing back config space on device 0000:00:02.1 at offset 5 (was 0, writing e0080000)
[  239.960716] PM: Writing back config space on device 0000:00:02.1 at offset 4 (was 8, writing f0000008)
[  239.960729] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900003)
[  239.960934] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900002, writing 2900102)
[  239.960985] PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was fff0, writing 37f03000)
[  239.961000] PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 22803030, writing 2803030)
[  239.961025] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 80800105, writing 80800107)
[  239.961057] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[  239.961119] PM: Writing back config space on device 0000:00:1f.1 at offset f (was 100, writing 1ff)
[  239.961144] PM: Writing back config space on device 0000:00:1f.1 at offset 9 (was 0, writing 38000000)
[  239.961201] ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[  239.961217] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[  239.967481] ata2.01: _GTF evaluation failed (AE 0x1001)
[  239.967481] ata1.01: _GTF evaluation failed (AE 0x1001)
[  239.967481] PM: Writing back config space on device 0000:00:1f.5 at offset f (was 200, writing 20a)
[  239.967481] PM: Writing back config space on device 0000:00:1f.5 at offset 7 (was 0, writing e0100800)
[  239.967481] PM: Writing back config space on device 0000:00:1f.5 at offset 6 (was 0, writing e0100c00)
[  239.967481] PM: Writing back config space on device 0000:00:1f.5 at offset 5 (was 1301, writing 18c1)
[  239.967481] PM: Writing back config space on device 0000:00:1f.5 at offset 4 (was 1201, writing 1c01)
[  239.967481] PM: Writing back config space on device 0000:00:1f.5 at offset 1 (was 2900005, writing 2900003)
[  239.967481] PM: Writing back config space on device 0000:00:1f.6 at offset f (was 200, writing 20a)
[  239.967481] PM: Writing back config space on device 0000:00:1f.6 at offset 1 (was 2900005, writing 2900001)
[  240.506211] PCI: Enabling device 0000:02:02.0 (0000 -> 0002)
[  240.506211] ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10 (level, low) -> IRQ 10
[  240.506211] PM: Writing back config space on device 0000:02:02.0 at offset f (was 100, writing 10b)
[  240.506211] PM: Writing back config space on device 0000:02:02.0 at offset 4 (was 0, writing e0204000)
[  240.506211] PM: Writing back config space on device 0000:02:02.0 at offset 3 (was 0, writing 4000)
[  240.506211] PM: Writing back config space on device 0000:02:02.0 at offset 1 (was 100002, writing 100106)
[  240.506211] PM: Writing back config space on device 0000:02:04.0 at offset f (was 22020100, writing 2202010b)
[  240.506211] PM: Writing back config space on device 0000:02:04.0 at offset 4 (was 0, writing e0206000)
[  240.506211] PM: Writing back config space on device 0000:02:04.0 at offset 3 (was 0, writing 4008)
[  240.506211] PM: Writing back config space on device 0000:02:04.0 at offset 1 (was 2900000, writing 2900116)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset e (was 1, writing 34fd)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset d (was 1, writing 3401)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset c (was 1, writing 30fd)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset b (was 1, writing 3001)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset a (was 0, writing 3ffff000)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset 9 (was 0, writing 3c000000)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset 8 (was 0, writing 33fff000)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset 7 (was 0, writing 30000000)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset 6 (was 40000000, writing b0060302)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset 4 (was 0, writing e0207000)
[  240.506211] PM: Writing back config space on device 0000:02:06.0 at offset 1 (was 4100087, writing 4100187)
[  240.506211] ACPI: PCI Interrupt 0000:02:06.0[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset f (was 100, writing 18001ff)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset e (was 1, writing 3cfd)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset d (was 1, writing 3c01)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset c (was 1, writing 38fd)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset b (was 1, writing 3801)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset a (was 0, writing 43fff000)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 9 (was 0, writing 40000000)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 8 (was 0, writing 37fff000)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 7 (was 0, writing 34000000)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 6 (was 0, writing b00a0702)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 4 (was 0, writing e0208000)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 3 (was 820000, writing 824000)
[  240.506211] PM: Writing back config space on device 0000:02:06.1 at offset 1 (was 4100080, writing 4100107)
[  240.506211] ACPI: PCI Interrupt 0000:02:06.1[A] -> Link [LNKC] -> GSI 10 (level, low) -> IRQ 10
[  240.506211] PM: Writing back config space on device 0000:02:07.0 at offset f (was 4020100, writing 402010a)
[  240.506211] PM: Writing back config space on device 0000:02:07.0 at offset 5 (was 0, writing e0200000)
[  240.506211] PM: Writing back config space on device 0000:02:07.0 at offset 4 (was 0, writing e0209000)
[  240.506211] PM: Writing back config space on device 0000:02:07.0 at offset 3 (was 0, writing 4008)
[  240.506211] PM: Writing back config space on device 0000:02:07.0 at offset 1 (was 2100002, writing 2100112)
[  240.506457] nsc-ircc 00:08: activated
[  240.939967] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[  245.365628] sd 0:0:0:0: [sda] Starting disk
[  245.961449] ata2.01: NODEV after polling detection
[  245.964283] ata1.00: ACPI cmd 03/45:00:00:00:a0:ef rejected by device (Stat=0x51 Err=0x04)
[  245.970560] ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (Stat=0x51 Err=0x04)
[  248.314006] ata2.00: ACPI cmd 03/42:00:00:00:a0:ef rejected by device (Stat=0x51 Err=0x04)
[  248.314457] ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef rejected by device (Stat=0x51 Err=0x04)
[  248.314732] ata1.00: configured for UDMA/100
[  248.651143] sd 0:0:0:0: [sda] 117210240 512-byte hardware sectors (60012 MB)
[  248.651143] sd 0:0:0:0: [sda] Write Protect is off
[  248.651143] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  248.651143] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  249.049085] ata2.00: configured for UDMA/33
[  249.049109] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xb t4
[  249.049115] ata2: ACPI event
[  249.049191] ata2: soft resetting link
[  252.668456] ata2.01: NODEV after polling detection
[  252.668456] PM: Finishing wakeup.
[  252.668456] Restarting tasks ... done.
[  252.745418] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input7
[  255.289545] ata2.00: configured for UDMA/33
[  255.289545] ata2: EH complete
[  256.478123] b44: lan: Link is up at 100 Mbps, full duplex.
[  256.478134] b44: lan: Flow control is off for TX and off for RX.
[  779.695675] atkbd.c: Unknown key pressed (translated set 2, code 0xd6 on isa0060/serio0).
[  779.695675] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[  779.705218] atkbd.c: Unknown key released (translated set 2, code 0xd6 on isa0060/serio0).
[  779.705218] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[  781.603912] atkbd.c: Unknown key pressed (translated set 2, code 0xd5 on isa0060/serio0).
[  781.603912] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[  781.613564] atkbd.c: Unknown key released (translated set 2, code 0xd5 on isa0060/serio0).
[  781.613564] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[  782.772662] atkbd.c: Unknown key pressed (translated set 2, code 0xd7 on isa0060/serio0).
[  782.772662] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
[  782.782390] atkbd.c: Unknown key released (translated set 2, code 0xd7 on isa0060/serio0).
[  782.782390] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
[  783.461807] atkbd.c: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
[  783.461807] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
[  783.471544] atkbd.c: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
[  783.471544] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
[  801.414783] ieee80211_crypt: registered algorithm 'NULL'
[  801.421928] ieee80211: 802.11 data/management/control stack, git-1.1.13
[  801.421928] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[  801.438018] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[  801.438031] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[  801.439098] ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 10
[  801.439111] ACPI: PCI Interrupt 0000:02:04.0[A] -> Link [LNKE] -> GSI 10 (level, low) -> IRQ 10
[  801.439578] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
[  801.703725] udev: renamed network interface eth0 to wlan
[  812.523331] atkbd.c: Unknown key pressed (translated set 2, code 0xd6 on isa0060/serio0).
[  812.523331] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[  812.532913] atkbd.c: Unknown key released (translated set 2, code 0xd6 on isa0060/serio0).
[  812.532913] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[  814.294863] wlan: Radio is disabled by RF switch.
[  815.081274] atkbd.c: Unknown key pressed (translated set 2, code 0xd5 on isa0060/serio0).
[  815.081274] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[  815.090995] atkbd.c: Unknown key released (translated set 2, code 0xd5 on isa0060/serio0).
[  815.090995] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[ 1004.527895] ACPI: PCI interrupt for device 0000:02:04.0 disabled
[ 1027.037594] ieee80211_crypt: unregistered algorithm 'NULL'
[ 1050.556474] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
[ 1050.556685] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[ 1051.404652] intel8x0_measure_ac97_clock: measured 59326 usecs
[ 1051.404663] intel8x0: clocking to 48000
[ 1055.980654] loop: module loaded
[ 1056.010650] squashfs: version 3.3 (2007/10/31) Phillip Lougher
[ 1091.423390] input: PC Speaker as /devices/platform/pcspkr/input/input8

--Boundary-00=_WXfLIz6Mh67oedx--

