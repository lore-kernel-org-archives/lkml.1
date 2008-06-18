Return-Path: <linux-kernel-owner+w=401wt.eu-S1755137AbYFRT5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137AbYFRT5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYFRT51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:57:27 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:45488 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbYFRT5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:57:22 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Date: Wed, 18 Jun 2008 21:57:03 +0200
User-Agent: KMail/1.9.9
Cc: "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
References: <200806051100.12885.dex@dragonslave.de> <200806152114.33007.dex@dragonslave.de> <86802c440806151220l358ca541s9d87fe2acc360e8@mail.gmail.com>
In-Reply-To: <86802c440806151220l358ca541s9d87fe2acc360e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QiWWIoAB7KgDnKn"
Message-Id: <200806182157.04120.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1213819042;50259966;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QiWWIoAB7KgDnKn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Yinghai Lu wrote:
> On Sun, Jun 15, 2008 at 12:14 PM, Daniel Exner <dex@dragonslave.de> wrote:
> > Hi all,
> >
> > Yinghai Lu wrote:
> >> >> To clarify myself:
> >> >> 2.6.25.5:  --> relatively fast no IOAPIC Errors in dmesg
> >> >> 2.6.26-rc5:   --> relatively  no IOAPIC Errors in dmesg
> >> >> 2.6.26-rc5 + git-acpi Patch:   --> relatively  no IOAPIC Errors in
> >> >> dmesg 2.6.26-rc5 +  linux-next snapshot 20080604 --> even slower than
> >> >> before my ide Patch many "unable to locate IOAPIC" Errors
> >> >>
> >> >>
> >> >> So I think the problem lies not in the acpi tree but somewhre else.
> >> >>
> >> >> Is it possible to tell git to explicitly _exclude_ a specific tree
> >> >> while bisecting?
> >>
> >> can you check if the attached patch fix the problem?
> >> it will not check entries before MP_intsrc_info...
> >
> > This fixed it, thanks :)
> >
> > Also maschine feels not as fast as with 2.6.25.x but noticeable faster :)
> >
> > I guss you no longer need the complete dmesg output?
>
> still need that... wonder why your irq routing have same entris from
> your BIOS/ACPI?
Again, sorry for the delay. I raised the Kernel buffer and added an output, 
done using rc6.

No idea what you mean.. could you perhaps highlight the lines in my output?

--
Greetings
Daniel Exner

--Boundary-00=_QiWWIoAB7KgDnKn
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg.rc6"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.rc6"

Linux version 2.6.25-Laptop-fw6 (root@Joshua) (gcc version 4.3.1 (Frugalware Linux) ) #1 SMP PREEMPT Wed Jun 18 19:59:24 CEST 2008
PAT disabled. Not yet verified on this CPU type.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 00000000000eee00 (reserved)
 BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NVS)
 BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000eff0000 (usable)
 BIOS-e820: 000000000eff0000 - 000000000f000000 (ACPI data)
 BIOS-e820: 000000000f000000 - 0000000010000000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
239MB LOWMEM available.
Entering add_active_range(0, 0, 61424) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    61424
  HighMem     61424 ->    61424
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    61424
On node 0 totalpages: 61424
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 448 pages used for memmap
  Normal zone: 56880 pages, LIFO batch:15
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
ACPI: RSDT 0EFF0000, 002C (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: FACP 0EFF0054, 0084 (r2 TOSHIB 750        970814 TASM  4010000)
ACPI: DSDT 0EFF00D8, 41BA (r1 TOSHIB 1800     20010911 MSFT  1000007)
ACPI: FACS 000EEE00, 0040
ACPI: BOOT 0EFF002C, 0028 (r1 TOSHIB 750        970814 TASM  4010000)
ACPI: DMI detected: Toshiba
ACPI: PM-Timer IO Port: 0xee08
Allocating PCI resources starting at 20000000 (gap: 10000000:eff80000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 00000000000ee000
PM: Registered nosave memory: 00000000000ee000 - 00000000000ef000
PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
SMP: Allowing 0 CPUs, 0 hotplug CPUs
PERCPU: Allocating 37416 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 60944
Kernel command line: root=/dev/hda2 ro quiet vga=792 resume=/dev/hda1
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (011ed000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 1024 (order: 10, 4096 bytes)
Detected 1095.477 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 235496k/245696k available (3056k kernel code, 9572k reserved, 1165k data, 600k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xcf800000 - 0xff7fe000   ( 767 MB)
    lowmem  : 0xc0000000 - 0xceff0000   ( 239 MB)
      .init : 0xc0526000 - 0xc05bc000   ( 600 kB)
      .data : 0xc03fc272 - 0xc051f790   (1165 kB)
      .text : 0xc0100000 - 0xc03fc272   (3056 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 2192.75 BogoMIPS (lpj=1096379)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 13k freed
ACPI: Core revision 20080321
Parsing all Control Methods:
Table [DSDT](id 0001) - 574 Objects with 53 Devices 152 Methods 5 Regions
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
ACPI: setting ELCR to 0200 (from 0a00)
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
weird, boot CPU (#0) not listedby the BIOS.
SMP motherboard not detected.
Local APIC not detected. Using dummy APIC emulation.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (2192.75 BogoMIPS).
CPU0 attaching NULL sched-domain.
net_namespace: 652 bytes
NET: Registered protocol family 16
No dock devices found.
EISA bus registered
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfe34a, last bus=5
PCI: Using configuration type 1 for base access
Setting up standard PCI resources
evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 3F [_GPE] 8 regs on int 0x9
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:......................................
Initialized 2/5 Regions 0/0 Fields 16/16 Buffers 20/20 Packages (583 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 0 _STA executions (examined 57 objects)
evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 3 Wake, Enabled 0 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:08.0: quirk: region ee00-ee3f claimed by ali7101 ACPI
pci 0000:00:08.0: quirk: region ef00-ef1f claimed by ali7101 SMB
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 *11)
ACPI: Power Resource [PFAN] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI: RTC can wake from S4
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0xefeffff could not be reserved
system 00:00: iomem range 0xeff0000-0xeffffff could not be reserved
system 00:00: iomem range 0xf000000-0xfffffff could not be reserved
system 00:00: iomem range 0xffe00000-0xffffffff could not be reserved
system 00:08: ioport range 0x370-0x371 has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x480-0x48f has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0x6c0-0x6ff has been reserved
system 00:08: ioport range 0xe000-0xe07f has been reserved
system 00:08: ioport range 0xe080-0xe0ff has been reserved
system 00:08: ioport range 0xe400-0xe47f has been reserved
system 00:08: ioport range 0xe480-0xe4ff has been reserved
system 00:08: ioport range 0xe800-0xe87f has been reserved
system 00:08: ioport range 0xe880-0xe8ff has been reserved
system 00:08: ioport range 0xec00-0xec7f has been reserved
system 00:08: ioport range 0xec80-0xecff has been reserved
system 00:08: ioport range 0xee00-0xee41 could not be reserved
system 00:08: ioport range 0xee90-0xee9f has been reserved
system 00:08: ioport range 0xeeac-0xeeac has been reserved
system 00:08: ioport range 0xef00-0xef3f could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xf7f00000-0xfdffffff
  PREFETCH window: 0x0000000030000000-0x00000000300fffff
PCI: Bus 2, cardbus bridge: 0000:00:11.0
  IO window: 0x00001400-0x000014ff
  IO window: 0x00001800-0x000018ff
  PREFETCH window: 0x20000000-0x23ffffff
  MEM window: 0x24000000-0x27ffffff
PCI: Bus 6, cardbus bridge: 0000:00:11.1
  IO window: 0x00001c00-0x00001cff
  IO window: 0x00002000-0x000020ff
  PREFETCH window: 0x28000000-0x2bffffff
  MEM window: 0x2c000000-0x2fffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
pci 0000:00:11.0: enabling device (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:11.1: enabling device (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
Freeing initrd memory: 2000k freed
Simple Boot Flag at 0x7c set to 0x1
apm: BIOS version 1.2 Flags 0x02 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1213824587.296:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 464
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:07.0: Activating ISA DMA hang workarounds
pci 0000:00:0a.0: Firmware left e100 interrupts enabled; disabling
pci 0000:01:00.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0xfc000000, mapped to 0xcf880000, using 6144k, total 16384k
vesafb: mode is 1024x768x32, linelength=4096, pages=4
vesafb: protected mode interface info at c000:77f8
vesafb: pmi: set display start = c00c7819, set palette = c00c787c
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slot 0000:00:04.0
ACPI: Unable to derive IRQ for device 0000:00:04.0
ALI15X3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xeff0-0xeff7
    ide1: BM-DMA at 0xeff8-0xefff
Probing IDE interface ide0...
hda: HITACHI_DK23CA-20, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/66 mode selected
Probing IDE interface ide1...
hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 128KiB
hda: 39070080 sectors (20003 MB) w/2048KiB Cache, CHS=38760/16/63
hda: cache flushes not supported
 hda: hda1 hda2 hda3
hdc: ATAPI 24X DVD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
EISA: Probing bus 0 at eisa.0
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16.
ALSA device list:
  No soundcards found.
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
input: PS/2 Mouse as /class/input/input1
input: AlpsPS/2 ALPS GlidePoint as /class/input/input2
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
RAMDISK: ext2 filesystem found at block 0
RAMDISK: Loading 2000KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|done.
VFS: Mounted root (ext2 filesystem).
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Trying to move old root to /initrd ... /initrd does not exist. Ignored.
Unmounting old root
Trying to free ramdisk memory ... okay
Freeing unused kernel memory: 600k freed
EXT3 FS on hda2, internal journal
Linux agpgart interface v0.103
agpgart: Detected ALi M1644 chipset
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
agpgart: AGP aperture is 64M @ 0xf0000000
ohci_hcd 0000:00:02.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 11, io mem 0x30100000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
pci 0000:00:08.0: enabling device (0000 -> 0001)
ALi_M1535: initialized. timeout=60 sec (nowayout=0)
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: ACPI0007:00 is registered as cooling_device0
e100: eth0: e100_probe: addr 0xf7efe000, irq 11, MAC addr 00:00:39:32:e4:aa
ali15x3_smbus 0000:00:08.0: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
ali15x3_smbus 0000:00:08.0: ALI15X3 not detected, module not inserted.
Yenta: CardBus bridge found at 0000:00:11.0 [1179:0001]
ACPI: AC Adapter [ADP1] (on-line)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (58 C)
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000020
Yenta: CardBus bridge found at 0000:00:11.1 [1179:0001]
Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Socket status: 30000007
ALI 5451 0000:00:06.0: enabling device (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
eepro100.c:v1.09j-t 9/29/99 Donald Becker
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
pccard: CardBus card inserted into slot 0
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
input: Video Bus as /class/input/input5
ACPI: Video Device [VGA] (multi-head: yes  rom: yes  post: no)
ACPI: Transitioning device [FAN] to D3
ACPI: PNP0C0B:00 is registered as cooling_device1
ACPI: Fan [FAN] (off)
ACPI: Battery Slot [BAT1] (battery present)
toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
toshiba_acpi:     HCI method: \_SB_.VALD.GHCI
input: PC Speaker as /class/input/input6
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year
NET: Registered protocol family 23
Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip, pre-configuring device.
Activated ALi 1533 ISA bridge port 0x02e8.
Activated ALi 1533 ISA bridge port 0x02f8.
found SMC SuperIO Chip (devid=0x5a rev=00 base=0x002e): LPC47N227
smsc_superio_flat(): IrDA not enabled
smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7, mode: 0x02
SMsC IrDA Controller found
 IrCC version 2.0, firport 0x2f8, sirport 0x2e8 dma=3, irq=7
No transceiver found. Defaulting to Fast pin select
IrDA: Registered device irda0
parport_pc 00:0c: activated
parport_pc 00:0c: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
ath5k_pci 0000:02:00.0: enabling device (0000 -> 0002)
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ath5k_pci 0000:02:00.0: registered as 'phy0'
cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
cs: IO port probe 0x3e0-0x4ff: clean.
cs: IO port probe 0x100-0x3af: excluding 0x200-0x207 0x220-0x22f 0x330-0x337 0x388-0x38f
cs: IO port probe 0x3e0-0x4ff: clean.
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
ppdev: user-space parallel port driver
phy0: Selected rate control algorithm 'pid'
Marking TSC unstable due to: TSC halts in idle.
ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
udev: renamed network interface wlan0 to ath0
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
alim7101_wdt: Detected old alim7101 revision 'a1d'.  If this is a cobalt board, set the 'use_gpio' module parameter.
EXT3 FS on hda2, internal journal
lp0: using parport0 (interrupt-driven).
lp0: console ready
loop: module loaded
fuse init (API version 7.9)
Toshiba System Management Mode driver v1.11 26/9/2001
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 530104k swap on /dev/hda1.  Priority:-1 extents:1 across:530104k
phy0: HW CONFIG: freq=2412
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (4096 buckets, 16384 max)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ttyS0: LSR safety check engaged!
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)

--Boundary-00=_QiWWIoAB7KgDnKn--
