Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbYGRNoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbYGRNoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbYGRNoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:44:30 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:46110 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbYGRNo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:44:27 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jul 2008 09:44:26 EDT
Message-ID: <48809C9C.2000807@ribosome.natur.cuni.cz>
Date: Fri, 18 Jul 2008 15:37:32 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080708 SeaMonkey/1.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.24.7: PCMCIA usb card failure causes panic at fs/buffer.c:1169
 mark_buffer_dirty()
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------090408030706000704050801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090408030706000704050801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
  I have Kouwell PCMCIA USB+FW card and via that attached external
drive. The laptop ASUS L3C/S has been now quite busy now with
downloading data via ssh and creating a DVD .iso imagine. Downloading
a tiny patch file through web browser caused an apparent lock
- the system did not reflect NumLock-key presses not Ctrl+Alt+F1.
The external drive (where the .iso has been created) got silent as
well as the internal HDD to which the data via ssh have been stored.
Luckily, I had removed the PCMCIA card before resetting. Here is
what I found in the logs:


Linux version 2.6.24.7 (root@vrapenec) (gcc version 4.3.1 (Gentoo 4.3.1-r1 p1.1) ) #3 Thu Jul 17 13:32:43 MEST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff9000 (usable)
 BIOS-e820: 000000007fff9000 - 000000007ffff000 (ACPI data)
 BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 524281) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524281
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   524281
On node 0 totalpages: 524281
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2303 pages used for memmap
  HighMem zone: 292602 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
ACPI: RSDP 000F6890, 0014 (r0 ASUS  )
ACPI: RSDT 7FFF9000, 002C (r1 ASUS   P4_L3CS  42302E31 MSFT 31313031)
ACPI: FACP 7FFF9080, 0074 (r1 ASUS   P4_L3CS  42302E31 MSFT 31313031)
ACPI: DSDT 7FFF9100, 52E9 (r1   ASUS P4_L3CS      1000 MSFT  100000D)
ACPI: FACS 7FFFF000, 0040
ACPI: BOOT 7FFF9040, 0028 (r1 ASUS   P4_L3CS  42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 88000000 (gap: 80000000:7fff0000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520186
Kernel command line: root=/dev/hda3 console=ttyS0,57600n8 console=tty0 vga=0x318 video=vesafb:mtrr:3,ywrap idebus=66 udev
ide_setup: idebus=66
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (02482000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1800.113 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2074204k/2097124k available (2625k kernel code, 21784k reserved, 1329k data, 196k init, 1179620k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc13e0000 - 0xc1411000   ( 196 kB)
      .data : 0xc1290441 - 0xc13dca84   (1329 kB)
      .text : 0xc1000000 - 0xc1290441   (2625 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3601.92 BogoMIPS (lpj=1800964)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebf9ff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: bfebf9ff 00000000 00000000 0000b080 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
Compat vDSO mapped to ffffe000.
CPU: Intel Mobile Intel(R) Pentium(R) 4 - M CPU 1.80GHz stepping 07
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0a28)
net_namespace: 64 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0e40, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Enabled i801 SMBus device
PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *5)
ACPI: PCI Interrupt Link [LNKB] (IRQs 7 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 11) *9
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Power Resource [PRCF] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
system 00:02: ioport range 0xe400-0xe47f has been reserved
system 00:02: ioport range 0xe800-0xe81f has been reserved
system 00:02: ioport range 0xec00-0xec3f has been reserved
system 00:02: ioport range 0x40b-0x40b has been reserved
system 00:02: ioport range 0x480-0x48f has been reserved
system 00:02: ioport range 0x4d6-0x4d6 has been reserved
system 00:03: iomem range 0xffa00000-0xffbfffff has been reserved
system 00:03: iomem range 0xffe00000-0xffffffff could not be reserved
system 00:04: ioport range 0x4d0-0x4d1 has been reserved
system 00:04: ioport range 0x77c-0x77f has been reserved
system 00:0e: ioport range 0x610-0x62f has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: d7000000-d7efffff
  PREFETCH window: d7f00000-dfffffff
PCI: Bus 3, cardbus bridge: 0000:02:07.0
  IO window: 0000a000-0000a0ff
  IO window: 0000a400-0000a4ff
  PREFETCH window: 88000000-8bffffff
  MEM window: 8c000000-8fffffff
PCI: Bus 7, cardbus bridge: 0000:02:07.1
  IO window: 0000ac00-0000acff
  IO window: 00001000-000010ff
  PREFETCH window: 90000000-93ffffff
  MEM window: 94000000-97ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: a000-afff
  MEM window: d6000000-d6ffffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
PCI: Enabling device 0000:02:07.1 (0000 -> 0003)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:02:07.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
DLM (built Jul 17 2008 13:21:02) installed
fuse init (API version 7.9)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=230.00 Mhz, System=183.00 MHz
radeonfb: PLL min 12000 max 35000
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
Non-DDC laptop panel detected
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
i2c-adapter i2c-3: unable to read EDID block.
radeonfb: Monitor 1 type LCD found
radeonfb: Monitor 2 type no found
radeonfb: panel ID string: Samsung LTN150P1-L02    
radeonfb: detected LVDS panel size from BIOS: 1400x1050
radeondb: BIOS provided dividers will be used
radeonfb: Dynamic Clock Power Management enabled
Console: switching to colour frame buffer device 175x65
radeonfb (0000:01:00.0): ATI Radeon LW 
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT0] (battery absent)
input: Power Button (FF) as /devices/virtual/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /devices/virtual/input/input1
ACPI: Sleep Button (CM) [SLPB]
input: Lid Switch as /devices/virtual/input/input2
ACPI: Lid Switch [LIDD]
ACPI: Transitioning device [CFAN] to D3
ACPI: Transitioning device [CFAN] to D3
ACPI: Fan [CFAN] (off)
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Thermal Zone [THRM] (55 C)
Asus Laptop ACPI Extras version 0.30
  L3C model detected, supported
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI interrupt for device 0000:00:1f.6 disabled
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
loop: module loaded
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 66MHz system bus speed for PIO modes
ICH3M: IDE controller (0x8086:0x248a rev 0x02) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:00:1f.1[A] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3
ICH3M: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x8400-0x8407, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x8408-0x840f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: ST9160821A, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: TOSHIBA DVD-ROM SD-R2212, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide2...
Probing IDE interface ide3...
Probing IDE interface ide4...
Probing IDE interface ide5...
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4
hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
input: PC Speaker as /devices/platform/pcspkr/input/input4
Synaptics Touchpad, model: 1, fw: 4.6, id: 0x925ea1, caps: 0x80471b/0x0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
i2c /dev entries driver
ACPI: PCI Interrupt 0000:00:1f.3[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
SCTP: Hash tables configured (established 65536 bind 65536)
Marking TSC unstable due to: TSC halts in idle.
Time: acpi_pm clocksource has been installed.
Using IPI Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 196k freed
Linux agpgart interface v0.102
agpgart: Detected an Intel 845G Chipset.
agpgart: AGP aperture is 256M @ 0xe0000000
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/LNXVIDEO:00/input/input6
ACPI: Video Device [VGAC] (multi-head: yes  rom: no  post: no)
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
ACPI: PCI Interrupt 0000:02:05.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
eth0: RealTek RTL8139 at 0xf884c000, 00:e0:18:b6:9d:31, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8100'
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 5, io base 0x0000b800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 11, io base 0x0000b400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
Yenta: CardBus bridge found at 0000:02:07.0 [1043:1624]
usb 1-2: new low speed USB device using uhci_hcd and address 2
Yenta: ISA IRQ mask 0x0090, PCI irq 5
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #02 to #06
pcmcia: parent PCI bridge I/O window: 0xa000 - 0xafff
cs: IO port probe 0xa000-0xafff: clean.
pcmcia: parent PCI bridge Memory window: 0xd6000000 - 0xd6ffffff
Yenta: CardBus bridge found at 0000:02:07.1 [1043:1624]
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
Yenta: ISA IRQ mask 0x0410, PCI irq 11
Socket status: 30000820
Yenta: Raising subordinate bus# of parent bus (#02) from #06 to #0a
pcmcia: parent PCI bridge I/O window: 0xa000 - 0xafff
cs: IO port probe 0xa000-0xafff: clean.
pcmcia: parent PCI bridge Memory window: 0xd6000000 - 0xd6ffffff
ACPI: PCI Interrupt 0000:02:07.2[C] -> Link [LNKC] -> GSI 3 (level, low) -> IRQ 3
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[3]  MMIO=[d6000000-d60007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
lp0: using parport0 (interrupt-driven).
usb 1-2: configuration #1 chosen from 1 choice
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input7
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-2
ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.5 to 64
pccard: CardBus card inserted into slot 1
PCI: Enabling device 0000:07:00.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:07:00.0: UHCI Host Controller
uhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:07:00.0: irq 11, io base 0x0000ac80
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PCI: Enabling device 0000:07:00.1 (0000 -> 0003)
ACPI: PCI Interrupt 0000:07:00.1[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:07:00.1: UHCI Host Controller
uhci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:07:00.1: irq 11, io base 0x0000aca0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PCI: Enabling device 0000:07:00.3 (0080 -> 0083)
ACPI: PCI Interrupt 0000:07:00.3[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:07:00.3 to 64
ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[94000000-940007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
intel8x0_measure_ac97_clock: measured 50566 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:1f.6[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1f.6 to 64
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00e018000305e5fc]
PCI: Enabling device 0000:07:00.2 (0000 -> 0002)
ACPI: PCI Interrupt 0000:07:00.2[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:07:00.2: EHCI Host Controller
ehci_hcd 0000:07:00.2: new USB bus registered, assigned bus number 5
ehci_hcd 0000:07:00.2: irq 11, io mem 0x94000a00
ehci_hcd 0000:07:00.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 4 ports detected
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: clean.
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: clean.
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
ieee1394: Host added: ID:BUS[1-00:1023]  GUID[00ff06ff00ff30ff]
EXT3 FS on hda3, internal journal
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Adding 1028152k swap on /dev/hda4.  Priority:-1 extents:1 across:1028152k
usb 5-1: new high speed USB device using ehci_hcd and address 2
usb 5-1: configuration #1 chosen from 1 choice
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi 0:0:0:0: Direct-Access     ST320082 6AS                   PQ: 0 ANSI: 2 CCS
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 38 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
usb-storage: device scan complete
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.28.0 20060524 on minor 0
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
[drm] Setting GART location based on new memory map
[drm] writeback test succeeded in 2 usecs
Clocksource tsc unstable (delta = -166560572 ns)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.


uhci_hcd 0000:07:00.0: host system error, PCI problems?
uhci_hcd 0000:07:00.0: host controller process error, something bad happened!
uhci_hcd 0000:07:00.1: host system error, PCI problems?
uhci_hcd 0000:07:00.1: host controller process error, something bad happened!
ehci_hcd 0000:07:00.2: HC died; cleaning up
uhci_hcd 0000:07:00.0: host system error, PCI problems?
uhci_hcd 0000:07:00.0: host controller process error, something bad happened!
uhci_hcd 0000:07:00.0: host controller halted, very bad!
uhci_hcd 0000:07:00.0: HCRESET not completed yet!
uhci_hcd 0000:07:00.0: HC died; cleaning up
uhci_hcd 0000:07:00.1: host system error, PCI problems?
uhci_hcd 0000:07:00.1: host controller process error, something bad happened!
uhci_hcd 0000:07:00.1: host controller halted, very bad!
uhci_hcd 0000:07:00.1: HCRESET not completed yet!
uhci_hcd 0000:07:00.1: HC died; cleaning up
usb 5-1: USB disconnect, address 2
pccard: card ejected from slot 1
sd 0:0:0:0: Device offlined - not ready after error recovery
sd 0:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sda, sector 156088471
sd 0:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
end_request: I/O error, dev sda, sector 156088503
Buffer I/O error on device sda1, logical block 6537
lost page write due to I/O error on sda1
Aborting journal on device sda1.
Buffer I/O error on device sda1, logical block 1545
lost page write due to I/O error on sda1
journal commit I/O error
Buffer I/O error on device sda1, logical block 19234818
lost page write due to I/O error on sda1
uhci_hcd 0000:07:00.0: remove, state 0
usb usb3: USB disconnect, address 1
uhci_hcd 0000:07:00.0: USB bus 3 deregistered
ACPI: PCI interrupt for device 0000:07:00.0 disabled
uhci_hcd 0000:07:00.1: remove, state 0
usb usb4: USB disconnect, address 1
uhci_hcd 0000:07:00.1: USB bus 4 deregistered
ACPI: PCI interrupt for device 0000:07:00.1 disabled
ehci_hcd 0000:07:00.2: remove, state 0
usb usb5: USB disconnect, address 1
ehci_hcd 0000:07:00.2: USB bus 5 deregistered
ACPI: PCI interrupt for device 0000:07:00.2 disabled
ieee1394: Node removed: ID:BUS[1-00:1023]  GUID[00ff06ff00ff30ff]
ohci1394: fw-host1: Set PHY Reg timeout [0xffffffff/0x00004000/100]
ohci1394: fw-host1: Set PHY Reg timeout [0xffffffff/0x00004000/100]
ext3_abort called.
EXT3-fs error (device sda1): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
pccard: CardBus card inserted into slot 1
PCI: Enabling device 0000:07:00.0 (0000 -> 0003)
ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:07:00.0: UHCI Host Controller
uhci_hcd 0000:07:00.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:07:00.0: irq 11, io base 0x0000ac80
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PCI: Enabling device 0000:07:00.1 (0000 -> 0003)
ACPI: PCI Interrupt 0000:07:00.1[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:07:00.1: UHCI Host Controller
uhci_hcd 0000:07:00.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:07:00.1: irq 11, io base 0x0000aca0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PCI: Enabling device 0000:07:00.2 (0000 -> 0002)
ACPI: PCI Interrupt 0000:07:00.2[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:07:00.2: EHCI Host Controller
ehci_hcd 0000:07:00.2: new USB bus registered, assigned bus number 5
ehci_hcd 0000:07:00.2: irq 11, io mem 0x94000a00
ehci_hcd 0000:07:00.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 4 ports detected
PCI: Enabling device 0000:07:00.3 (0080 -> 0083)
ACPI: PCI Interrupt 0000:07:00.3[A] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:07:00.3 to 64
ohci1394: fw-host1: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[94000000-940007ff]  Max Packet=[1024]  IR/IT contexts=[4/8]
usb 5-1: new high speed USB device using ehci_hcd and address 2
agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
usb 5-1: device descriptor read/64, error -110
usb 5-1: device descriptor read/64, error -110
usb 5-1: new high speed USB device using ehci_hcd and address 3
usb 5-1: device descriptor read/64, error -110
usb 5-1: device descriptor read/64, error -110
usb 5-1: new high speed USB device using ehci_hcd and address 4
usb 5-1: device not accepting address 4, error -110
usb 5-1: new high speed USB device using ehci_hcd and address 5
WARNING: at fs/buffer.c:1169 mark_buffer_dirty()
Pid: 3694, comm: umount Not tainted 2.6.24.7 #3
 [<c1005c69>] show_trace+0x1a/0x31
 [<c12904ab>] _etext+0x6a/0x70
 [<c107222e>] mark_buffer_dirty+0x41/0x84
 [<c10af0fa>] journal_update_superblock+0x4d/0x81
 [<c10af3af>] journal_destroy+0xfc/0x141
 [<c10a67a9>] ext3_put_super+0x24/0x174
 [<c1059b0b>] generic_shutdown_super+0x50/0xba
 [<c1059b84>] kill_block_super+0xf/0x20
 [<c1059c01>] deactivate_super+0x2f/0x41
 [<c10691dd>] mntput_no_expire+0x3a/0x4c
 [<c105da7d>] path_release_on_umount+0x15/0x18
 [<c1069999>] sys_umount+0x174/0x17e
 [<c1003ca6>] sysenter_past_esp+0x5f/0x85
 =======================
Buffer I/O error on device sda1, logical block 1545
lost page write due to I/O error on sda1
usb 5-1: device not accepting address 5, error -110



Any clues? I use only ext2 (boot) and ext3 (root, external) filesystems.
Please Cc: me in replies.
Martin

--------------090408030706000704050801
Content-Type: application/gzip;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
9xHP/x9Hnme+1rcAAA==
--------------090408030706000704050801--
