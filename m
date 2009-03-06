Return-Path: <linux-kernel-owner+w=401wt.eu-S1754951AbZCFASK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbZCFASK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 19:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbZCFARz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 19:17:55 -0500
Received: from teri.daybyday.de ([85.183.245.173]:36933 "EHLO teri.daybyday.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbZCFARx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 19:17:53 -0500
From: Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Fri, 6 Mar 2009 01:17:39 +0100
User-Agent: KMail/1.9.7
References: <200903041828.49972.m.bueker@berlin.de> <20090304224310.GA29043@electric-eye.fr.zoreil.com>
In-Reply-To: <20090304224310.GA29043@electric-eye.fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kuGsJ38QCaGmoiO"
Message-Id: <200903060117.40069.m.bueker@berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_kuGsJ38QCaGmoiO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 04 March 2009, you wrote:
> The kernel displays a scary warning, I can guess that it is almost surely
> associated with some loss of network connectivity for a few seconds at the
> very least but it is a bit hard to figure the real scale of your problem.

I'll try to be more precise :)

I can readily reproduce the symptoms by initiating the scp transfer of a large 
file. The transfer will stall somewhere between ~2MB and ~50MB of data 
transferred. After that, the results differ for the two network cards:
With the r8169 card, the transfer never recovers, but after ~1min to ~2min, 
there is a "link up" message in dmesg and the network will be back up.
With the 8139too card, the stall will be no longer than ~30sec and the 
transfer will resume. There is also a "link up" message upon the network's 
resurrection.

I have been able to verify that this problem does _not_ occur when using the 
same network (and target server) through my wireless USB adapter. The average 
speed this way is lower, however - ~690kb/s as opposed to ~1.8MB/s over the 
wire (the reason this is so much lower than the physical limit for both types 
of connections probably lies in the fact that we're dealing with a pentium2 
that has to do ssl encryption on the fly).

The two dmesg files I have attached contain the log of the following actions:
1. Booting with the respective card inserted
2. Initializing the file transfer
3. Abort the transfer after it's been dead for ~10sec
4. Wait for the network to come back up

The two attached lspci outputs were recorded with the two cards inserted 
respectively.

> Can you identify a kernel which worked flawlessly ?

I'm quite sure I did not experience this problem with the last kernel I ran, 
which was 2.6.25.15.

Hope to help!
Michael

-- 
I came for the quality, but I stayed for the freedom.
- Sean Neakums

--Boundary-00=_kuGsJ38QCaGmoiO
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg_8139too"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_8139too"

Linux version 2.6.27.19-mb7 (root@phobos) (gcc version 4.2.4) #7 Tue Mar 3 00:26:37 CET 2009
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000011fd0000 (usable)
 BIOS-e820: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
 BIOS-e820: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
 BIOS-e820: 0000000011fe0000 - 0000000012000000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
DMI 2.2 present.
last_pfn = 0x11fd0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 11fd0000 @ 7000-d000
RAMDISK: 00dc0000 - 00eff50c
IBM Thinkpad 600 Series 2645 detected: force use of acpi=noirq
ACPI: RSDP 000FD6E0, 0014 (r0 IBM   )
ACPI: RSDT 11FD0000, 0028 (r1 IBM    TP600R          1             0)
ACPI: FACP 11FD0100, 0074 (r1 IBM    TP600R          1             0)
ACPI: DSDT 11FD0200, C439 (r1 IBM    TP600R        106 MSFT  100000C)
ACPI: FACS 11FDF000, 0040
287MB LOWMEM available.
  mapped low ram: 0 - 11fd0000
  low ram: 00000000 - 11fd0000
  bootmap 00001000 - 000033fc
(7 early reservations) ==> bootmem [0000000000 - 0011fd0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000058c054]    TEXT DATA BSS ==> [0000100000 - 000058c054]
  #2 [0000dc0000 - 0000eff50c]          RAMDISK ==> [0000dc0000 - 0000eff50c]
  #3 [000058d000 - 0000590000]    INIT_PG_TABLE ==> [000058d000 - 0000590000]
  #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #5 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #6 [0000001000 - 0000004000]          BOOTMAP ==> [0000001000 - 0000004000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00011fd0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00011fd0
On node 0 totalpages: 73583
free_area_init_node: node 0, pgdat c050a3a0, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 69040 pages, LIFO batch:15
ACPI: PM-Timer IO Port: 0xef08
Allocating PCI resources starting at 20000000 (gap: 12000000:edfe0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 73007
Kernel command line: auto BOOT_IMAGE=2.6.27.19-mb7 ro root=fe00 clocksource=tsc
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PMTIMER calibration value
Detected 363.959 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 285472k/294720k available (3078k kernel code, 8684k reserved, 1079k data, 276k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffffa000 - 0xfffff000   (  20 kB)
    vmalloc : 0xd2800000 - 0xffff8000   ( 727 MB)
    lowmem  : 0xc0000000 - 0xd1fd0000   ( 287 MB)
      .init : 0xc0512000 - 0xc0557000   ( 276 kB)
      .data : 0xc040189b - 0xc050f7d8   (1079 kB)
      .text : 0xc0100000 - 0xc040189b   (3078 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay loop (skipped), value calculated using timer frequency.. 727.91 BogoMIPS (lpj=363959)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Mobile Pentium II stepping 0a
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080609
ACPI: setting ELCR to 0a00 (from 0800)
net_namespace: 288 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd880, last bus=7
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:00.0 reg 10 32bit mmio: [40000000, 43ffffff]
PCI: 0000:00:02.0 reg 10 32bit mmio: [50102000, 50102fff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.0: PME# disabled
PCI: 0000:00:02.1 reg 10 32bit mmio: [50101000, 50101fff]
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.1: PME# disabled
PCI: 0000:00:06.0 reg 10 32bit mmio: [50100000, 50100fff]
PCI: 0000:00:06.0 reg 14 32bit mmio: [50000000, 500fffff]
PCI: 0000:00:07.1 reg 20 io port: [fcf0, fcff]
PCI: 0000:00:07.2 reg 20 io port: [8400, 841f]
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
pci 0000:00:07.3: quirk: region ef00-ef3f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region efa0-efaf claimed by PIIX4 SMB
pci 0000:00:07.3: PIIX4 devres C PIO at 15e8-15ef
pci 0000:00:07.3: PIIX4 devres E PIO at 0538-053f
pci 0000:00:07.3: PIIX4 devres G PIO at 0130-013f
pci 0000:00:07.3: PIIX4 devres I PIO at 002e-002f
PCI: 0000:01:00.0 reg 10 32bit mmio: [e0000000, e0ffffff]
PCI: 0000:01:00.0 reg 14 32bit mmio: [70000000, 703fffff]
PCI: 0000:01:00.0 reg 18 32bit mmio: [70400000, 704fffff]
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
PCI: bridge 0000:00:01.0 io port: [d000, dfff]
PCI: bridge 0000:00:01.0 32bit mmio: [70000000, dfffffff]
PCI: bridge 0000:00:01.0 32bit mmio pref: [e0000000, f7ffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP0._PRT]
ACPI: Power Resource [PSIO] (on)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PVID] (on)
ACPI: Power Resource [PRSD] (off)
ACPI: Power Resource [PDCK] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 18 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
pci 0000:00:07.0: PIIX/ICH IRQ router [8086/7110]
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xcbfff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x11ffffff could not be reserved
system 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
system 00:0d: ioport range 0x15e0-0x15ef has been reserved
system 00:0d: ioport range 0xef00-0xef3f has been reserved
system 00:0d: ioport range 0xefa0-0xefaf has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0x70000000-0xdfffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000f7ffffff
pci 0000:00:02.0: CardBus bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: 0x001000-0x0010ff
pci 0000:00:02.0:   IO window: 0x001400-0x0014ff
pci 0000:00:02.0:   PREFETCH window: 0x20000000-0x23ffffff
pci 0000:00:02.0:   MEM window: 0x24000000-0x27ffffff
pci 0000:00:02.1: CardBus bridge, secondary bus 0000:06
pci 0000:00:02.1:   IO window: 0x001800-0x0018ff
pci 0000:00:02.1:   IO window: 0x001c00-0x001cff
pci 0000:00:02.1:   PREFETCH window: 0x28000000-0x2bffffff
pci 0000:00:02.1:   MEM window: 0x2c000000-0x2fffffff
PCI: setting IRQ 11 as level-triggered
pci 0000:00:02.0: found PCI INT A -> IRQ 11
pci 0000:00:06.0: IRQ routing conflict: have IRQ 9, want IRQ 11
pci 0000:00:02.0: sharing IRQ 11 with 0000:01:00.0
pci 0000:00:02.1: found PCI INT B -> IRQ 11
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 io port: [d000, dfff]
bus: 01 index 1 mmio: [70000000, dfffffff]
bus: 01 index 2 mmio: [e0000000, f7ffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [1000, 10ff]
bus: 02 index 1 io port: [1400, 14ff]
bus: 02 index 2 mmio: [20000000, 23ffffff]
bus: 02 index 3 mmio: [24000000, 27ffffff]
bus: 06 index 0 io port: [1800, 18ff]
bus: 06 index 1 io port: [1c00, 1cff]
bus: 06 index 2 mmio: [28000000, 2bffffff]
bus: 06 index 3 mmio: [2c000000, 2fffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 1277k freed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 560
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:01:00.0: Boot video device
neofb 0000:01:00.0: power state changed by ACPI to D0
neofb 0000:01:00.0: found PCI INT A -> IRQ 11
neofb 0000:01:00.0: sharing IRQ 11 with 0000:00:02.0
pci 0000:00:06.0: IRQ routing conflict: have IRQ 9, want IRQ 11
neofb: mapped io at d2880000
Autodetected internal display
Panel is a 1024x768 color TFT display
neofb: mapped framebuffer at d2b00000
neofb v0.4.2: 2560kB VRAM, using 1024x768, 48.364kHz, 60Hz
Console: switching to colour frame buffer device 128x48
fb0: MagicGraph 256A frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0x40000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
[drm] Initialized drm 1.1.0 20060810
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
brd: module loaded
loop: module loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.21
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS INET36WW, EC unknown
thinkpad_acpi: acpi_bus_get_device(hotkey) failed: -19
thinkpad_acpi: disabling subdriver hotkey
thinkpad_acpi: acpi_bus_get_device(bay) failed: -19
thinkpad_acpi: disabling subdriver bay
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
thinkpad_acpi: CMOS NVRAM (4) and EC (0) do not agree on display brightness level
input: ThinkPad Extra Buttons as /class/input/input3
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
piix 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfcf0-0xfcf7
    ide1: BM-DMA at 0xfcf8-0xfcff
Probing IDE interface ide0...
hda: WDC WD800BEVE-00UYT0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2
Driver 'sd' needs updating - please use bus_type methods
Yenta: CardBus bridge found at 0000:00:02.0 [1014:00eb]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.0, mfunc 0xfba97543, devctl 0x62
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000020
Yenta: CardBus bridge found at 0000:00:02.1 [1014:00eb]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.1, mfunc 0xfba97543, devctl 0x62
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:07.2: found PCI INT D -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00008400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.19-mb7 uhci_hcd
usb usb1: SerialNumber: 0000:00:07.2
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:MOU0] at 0x60,0x64 irq 1,12
pccard: CardBus card inserted into slot 0
PCI: 0000:02:00.0 reg 10 io port: [0, ff]
PCI: 0000:02:00.0 reg 14 32bit mmio: [0, 1ff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D1 D2 D3hot
pci 0000:02:00.0: PME# disabled
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
8139too Fast Ethernet driver 0.9.28
8139too 0000:02:00.0: enabling device (0000 -> 0003)
8139too 0000:02:00.0: setting latency timer to 64
eth0: RealTek RTL8139 at 0xd283e000, 00:00:21:5c:0b:22, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8139C'
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Bluetooth: HCI USB driver ver 2.10
usbcore: registered new interface driver hci_usb
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.17.
input: AT Translated Set 2 keyboard as /class/input/input4
ALSA device list:
  #0: CS4236 at 0x530, irq 5, dma 1&0
TCP cubic registered
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
Freeing unused kernel memory: 276k freed
IBM TrackPoint firmware: 0x0b, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
EXT3 FS on dm-0, internal journal
Adding 1048568k swap on /swap.  Priority:-1 extents:265 across:1082580k
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:219 dev_watchdog+0x19f/0x1b0()
NETDEV WATCHDOG: eth0 (8139too): transmit timed out
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27.19-mb7 #7
 [<c0118226>] warn_slowpath+0x76/0x90
 [<c0393140>] tcp_v4_do_rcv+0xb0/0x1a0
 [<c0394b71>] tcp_v4_rcv+0x571/0x630
 [<c012dd06>] update_wall_time+0x256/0x750
 [<c0106de6>] read_tsc+0x6/0x30
 [<c0106de6>] read_tsc+0x6/0x30
 [<c021bf10>] strlcpy+0x20/0x60
 [<c0371ef0>] dev_watchdog+0x0/0x1b0
 [<c037208f>] dev_watchdog+0x19f/0x1b0
 [<c0130de2>] tick_dev_program_event+0x32/0xa0
 [<c01200ff>] run_timer_softirq+0x10f/0x160
 [<c011c602>] __do_softirq+0x42/0x90
 [<c011c677>] do_softirq+0x27/0x30
 [<c011c975>] irq_exit+0x45/0x70
 [<c0104eb7>] do_IRQ+0x47/0x80
 [<c010321f>] common_interrupt+0x23/0x28
 [<c01078d9>] default_idle+0x29/0x40
 [<c0101be5>] cpu_idle+0x35/0x70
 =======================
---[ end trace 572d14d46a4abb42 ]---
eth0: Transmit timeout, status 0d 0000 c07f media 00.
eth0: Tx queue start entry 1873  dirty entry 1869.
eth0:  Tx descriptor 0 is 000805ea.
eth0:  Tx descriptor 1 is 000805ea. (queue head)
eth0:  Tx descriptor 2 is 000805ea.
eth0:  Tx descriptor 3 is 000805ea.
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth0: Transmit timeout, status 0d 0000 c07f media 00.
eth0: Tx queue start entry 182  dirty entry 178.
eth0:  Tx descriptor 0 is 000805ea.
eth0:  Tx descriptor 1 is 000805ea.
eth0:  Tx descriptor 2 is 000805ea. (queue head)
eth0:  Tx descriptor 3 is 000805ea.
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth0: Transmit timeout, status 0d 0000 c07f media 00.
eth0: Tx queue start entry 2566  dirty entry 2562.
eth0:  Tx descriptor 0 is 000805ea.
eth0:  Tx descriptor 1 is 000805ea.
eth0:  Tx descriptor 2 is 000805ea. (queue head)
eth0:  Tx descriptor 3 is 000805ea.
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth0: Transmit timeout, status 0d 0000 c07f media 00.
eth0: Tx queue start entry 33  dirty entry 29.
eth0:  Tx descriptor 0 is 000805ea.
eth0:  Tx descriptor 1 is 000805ea. (queue head)
eth0:  Tx descriptor 2 is 000805ea.
eth0:  Tx descriptor 3 is 000805ea.
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1

--Boundary-00=_kuGsJ38QCaGmoiO
Content-Type: text/plain;
  charset="iso-8859-1";
  name="dmesg_r8169"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_r8169"

Linux version 2.6.27.19-mb7 (root@phobos) (gcc version 4.2.4) #7 Tue Mar 3 00:26:37 CET 2009
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000011fd0000 (usable)
 BIOS-e820: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
 BIOS-e820: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
 BIOS-e820: 0000000011fe0000 - 0000000012000000 (reserved)
 BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
DMI 2.2 present.
last_pfn = 0x11fd0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 11fd0000 @ 7000-d000
RAMDISK: 00dc0000 - 00eff50c
IBM Thinkpad 600 Series 2645 detected: force use of acpi=noirq
ACPI: RSDP 000FD6E0, 0014 (r0 IBM   )
ACPI: RSDT 11FD0000, 0028 (r1 IBM    TP600R          1             0)
ACPI: FACP 11FD0100, 0074 (r1 IBM    TP600R          1             0)
ACPI: DSDT 11FD0200, C439 (r1 IBM    TP600R        106 MSFT  100000C)
ACPI: FACS 11FDF000, 0040
287MB LOWMEM available.
  mapped low ram: 0 - 11fd0000
  low ram: 00000000 - 11fd0000
  bootmap 00001000 - 000033fc
(7 early reservations) ==> bootmem [0000000000 - 0011fd0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000058c054]    TEXT DATA BSS ==> [0000100000 - 000058c054]
  #2 [0000dc0000 - 0000eff50c]          RAMDISK ==> [0000dc0000 - 0000eff50c]
  #3 [000058d000 - 0000590000]    INIT_PG_TABLE ==> [000058d000 - 0000590000]
  #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #5 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #6 [0000001000 - 0000004000]          BOOTMAP ==> [0000001000 - 0000004000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00011fd0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00011fd0
On node 0 totalpages: 73583
free_area_init_node: node 0, pgdat c050a3a0, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 69040 pages, LIFO batch:15
ACPI: PM-Timer IO Port: 0xef08
Allocating PCI resources starting at 20000000 (gap: 12000000:edfe0000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 73007
Kernel command line: auto BOOT_IMAGE=2.6.27.19-mb7 ro root=fe00 clocksource=tsc
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PMTIMER calibration value
Detected 363.957 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 285472k/294720k available (3078k kernel code, 8684k reserved, 1079k data, 276k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffffa000 - 0xfffff000   (  20 kB)
    vmalloc : 0xd2800000 - 0xffff8000   ( 727 MB)
    lowmem  : 0xc0000000 - 0xd1fd0000   ( 287 MB)
      .init : 0xc0512000 - 0xc0557000   ( 276 kB)
      .data : 0xc040189b - 0xc050f7d8   (1079 kB)
      .text : 0xc0100000 - 0xc040189b   (3078 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay loop (skipped), value calculated using timer frequency.. 727.91 BogoMIPS (lpj=363957)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel Mobile Pentium II stepping 0a
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20080609
ACPI: setting ELCR to 0a00 (from 0800)
net_namespace: 288 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd880, last bus=7
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:00.0 reg 10 32bit mmio: [40000000, 43ffffff]
PCI: 0000:00:02.0 reg 10 32bit mmio: [50102000, 50102fff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.0: PME# disabled
PCI: 0000:00:02.1 reg 10 32bit mmio: [50101000, 50101fff]
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot
pci 0000:00:02.1: PME# disabled
PCI: 0000:00:06.0 reg 10 32bit mmio: [50100000, 50100fff]
PCI: 0000:00:06.0 reg 14 32bit mmio: [50000000, 500fffff]
PCI: 0000:00:07.1 reg 20 io port: [fcf0, fcff]
PCI: 0000:00:07.2 reg 20 io port: [8400, 841f]
* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources
pci 0000:00:07.3: quirk: region ef00-ef3f claimed by PIIX4 ACPI
pci 0000:00:07.3: quirk: region efa0-efaf claimed by PIIX4 SMB
pci 0000:00:07.3: PIIX4 devres C PIO at 15e8-15ef
pci 0000:00:07.3: PIIX4 devres E PIO at 0538-053f
pci 0000:00:07.3: PIIX4 devres G PIO at 0130-013f
pci 0000:00:07.3: PIIX4 devres I PIO at 002e-002f
PCI: 0000:01:00.0 reg 10 32bit mmio: [e0000000, e0ffffff]
PCI: 0000:01:00.0 reg 14 32bit mmio: [70000000, 703fffff]
PCI: 0000:01:00.0 reg 18 32bit mmio: [70400000, 704fffff]
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
PCI: bridge 0000:00:01.0 io port: [d000, dfff]
PCI: bridge 0000:00:01.0 32bit mmio: [70000000, dfffffff]
PCI: bridge 0000:00:01.0 32bit mmio pref: [e0000000, f7ffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP0._PRT]
ACPI: Power Resource [PSIO] (on)
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PVID] (on)
ACPI: Power Resource [PRSD] (off)
ACPI: Power Resource [PDCK] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 18 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
pci 0000:00:07.0: PIIX/ICH IRQ router [8086/7110]
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xcbfff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x11ffffff could not be reserved
system 00:00: iomem range 0xfffe0000-0xffffffff could not be reserved
system 00:0d: ioport range 0x15e0-0x15ef has been reserved
system 00:0d: ioport range 0xef00-0xef3f has been reserved
system 00:0d: ioport range 0xefa0-0xefaf has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0x70000000-0xdfffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000f7ffffff
pci 0000:00:02.0: CardBus bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: 0x001000-0x0010ff
pci 0000:00:02.0:   IO window: 0x001400-0x0014ff
pci 0000:00:02.0:   PREFETCH window: 0x20000000-0x23ffffff
pci 0000:00:02.0:   MEM window: 0x24000000-0x27ffffff
pci 0000:00:02.1: CardBus bridge, secondary bus 0000:06
pci 0000:00:02.1:   IO window: 0x001800-0x0018ff
pci 0000:00:02.1:   IO window: 0x001c00-0x001cff
pci 0000:00:02.1:   PREFETCH window: 0x28000000-0x2bffffff
pci 0000:00:02.1:   MEM window: 0x2c000000-0x2fffffff
PCI: setting IRQ 11 as level-triggered
pci 0000:00:02.0: found PCI INT A -> IRQ 11
pci 0000:00:06.0: IRQ routing conflict: have IRQ 9, want IRQ 11
pci 0000:00:02.0: sharing IRQ 11 with 0000:01:00.0
pci 0000:00:02.1: found PCI INT B -> IRQ 11
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 io port: [d000, dfff]
bus: 01 index 1 mmio: [70000000, dfffffff]
bus: 01 index 2 mmio: [e0000000, f7ffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [1000, 10ff]
bus: 02 index 1 io port: [1400, 14ff]
bus: 02 index 2 mmio: [20000000, 23ffffff]
bus: 02 index 3 mmio: [24000000, 27ffffff]
bus: 06 index 0 io port: [1800, 18ff]
bus: 06 index 1 io port: [1c00, 1cff]
bus: 06 index 2 mmio: [28000000, 2bffffff]
bus: 06 index 3 mmio: [2c000000, 2fffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Switched to high resolution mode on CPU 0
Freeing initrd memory: 1277k freed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 560
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:01:00.0: Boot video device
neofb 0000:01:00.0: power state changed by ACPI to D0
neofb 0000:01:00.0: found PCI INT A -> IRQ 11
neofb 0000:01:00.0: sharing IRQ 11 with 0000:00:02.0
pci 0000:00:06.0: IRQ routing conflict: have IRQ 9, want IRQ 11
neofb: mapped io at d2880000
Autodetected internal display
Panel is a 1024x768 color TFT display
neofb: mapped framebuffer at d2b00000
neofb v0.4.2: 2560kB VRAM, using 1024x768, 48.364kHz, 60Hz
Console: switching to colour frame buffer device 128x48
fb0: MagicGraph 256A frame buffer device
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 440BX Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0x40000000
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
[drm] Initialized drm 1.1.0 20060810
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
brd: module loaded
loop: module loaded
thinkpad_acpi: ThinkPad ACPI Extras v0.21
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS INET36WW, EC unknown
thinkpad_acpi: acpi_bus_get_device(hotkey) failed: -19
thinkpad_acpi: disabling subdriver hotkey
thinkpad_acpi: acpi_bus_get_device(bay) failed: -19
thinkpad_acpi: disabling subdriver bay
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
thinkpad_acpi: CMOS NVRAM (4) and EC (0) do not agree on display brightness level
input: ThinkPad Extra Buttons as /class/input/input3
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
piix 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xfcf0-0xfcf7
    ide1: BM-DMA at 0xfcf8-0xfcff
Probing IDE interface ide0...
hda: WDC WD800BEVE-00UYT0, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide_generic: I/O resource 0x1F0-0x1F7 not free.
ide_generic: I/O resource 0x170-0x177 not free.
hda: max request size: 512KiB
hda: 156301488 sectors (80026 MB) w/8192KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2
Driver 'sd' needs updating - please use bus_type methods
Yenta: CardBus bridge found at 0000:00:02.0 [1014:00eb]
Yenta: Enabling burst memory read transactions
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.0, mfunc 0xfba97543, devctl 0x62
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000020
Yenta: CardBus bridge found at 0000:00:02.1 [1014:00eb]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:02.1, mfunc 0xfba97543, devctl 0x62
Yenta: ISA IRQ mask 0x0498, PCI irq 11
Socket status: 30000006
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:07.2: found PCI INT D -> IRQ 11
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x00008400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.19-mb7 uhci_hcd
usb usb1: SerialNumber: 0000:00:07.2
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:MOU0] at 0x60,0x64 irq 1,12
pccard: CardBus card inserted into slot 0
PCI: 0000:02:00.0 reg 10 io port: [0, ff]
PCI: 0000:02:00.0 reg 14 32bit mmio: [0, 1ff]
PCI: 0000:02:00.0 reg 30 32bit mmio: [5ffc0000, 5ffdffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D1 D2 D3hot
pci 0000:02:00.0: PME# disabled
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: enabling device (0000 -> 0003)
r8169 0000:02:00.0: setting latency timer to 64
eth0: RTL8169sb/8110sb at 0xd283e000, 00:40:f4:f9:29:df, XID 10000000 IRQ 11
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Bluetooth: HCI USB driver ver 2.10
usbcore: registered new interface driver hci_usb
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.17.
input: AT Translated Set 2 keyboard as /class/input/input4
ALSA device list:
  #0: CS4236 at 0x530, irq 5, dma 1&0
TCP cubic registered
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
Freeing unused kernel memory: 276k freed
IBM TrackPoint firmware: 0x0b, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
udev: renamed network interface eth0 to eth1
EXT3 FS on dm-0, internal journal
Adding 1048568k swap on /swap.  Priority:-1 extents:265 across:1082580k
r8169: eth1: link up
spurious 8259A interrupt: IRQ7.
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:219 dev_watchdog+0x19f/0x1b0()
NETDEV WATCHDOG: eth1 (r8169): transmit timed out
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.27.19-mb7 #7
 [<c0118226>] warn_slowpath+0x76/0x90
 [<c0370030>] __flow_cache_shrink+0x10/0x90
 [<c01570d9>] kmem_cache_alloc+0x39/0xa0
 [<c035dbb5>] copy_skb_header+0x25/0x80
 [<c0393ab0>] tcp_v4_send_check+0x40/0xe0
 [<c012dd06>] update_wall_time+0x256/0x750
 [<c0106de6>] read_tsc+0x6/0x30
 [<c021bf10>] strlcpy+0x20/0x60
 [<c0371ef0>] dev_watchdog+0x0/0x1b0
 [<c037208f>] dev_watchdog+0x19f/0x1b0
 [<c0114d3f>] enqueue_task_fair+0xaf/0xd0
 [<c0113862>] enqueue_task+0x12/0x30
 [<c0113926>] activate_task+0x16/0x20
 [<c01200ff>] run_timer_softirq+0x10f/0x160
 [<c012e247>] getnstimeofday+0x47/0x110
 [<c011c602>] __do_softirq+0x42/0x90
 [<c011c677>] do_softirq+0x27/0x30
 [<c011c975>] irq_exit+0x45/0x70
 [<c0104eb7>] do_IRQ+0x47/0x80
 [<c010321f>] common_interrupt+0x23/0x28
 [<c01078d9>] default_idle+0x29/0x40
 [<c0101be5>] cpu_idle+0x35/0x70
 =======================
---[ end trace 00cf2b69d4cea8f9 ]---
r8169: eth1: link up
r8169: eth1: link up

--Boundary-00=_kuGsJ38QCaGmoiO
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci_8139too"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_8139too"

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
	Flags: bus master, medium devsel, latency 64
	Memory at 40000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 1.0
	Kernel driver in use: agpgart-intel
00: 86 80 90 71 06 00 10 22 03 00 00 06 00 40 00 00
10: 08 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 168
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=176
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: 70000000-dfffffff
	Prefetchable memory behind bridge: e0000000-f7ffffff
00: 86 80 91 71 07 00 20 02 03 00 04 06 00 a8 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 b0 d0 d0 a0 a2
20: 00 70 f0 df 00 e0 f0 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 00

00:02.0 CardBus bridge: Texas Instruments PCI1251A
	Subsystem: IBM Unknown device 00eb
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at 50102000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 20000000-23fff000 (prefetchable)
	Memory window 1: 24000000-27fff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
00: 4c 10 1d ac 07 00 10 02 00 00 07 06 08 a8 82 00
10: 00 20 10 50 a0 00 00 02 00 02 05 b0 00 00 00 20
20: 00 f0 ff 23 00 00 00 24 00 f0 ff 27 00 10 00 00
30: fc 10 00 00 00 14 00 00 fc 14 00 00 0b 01 00 05
40: 14 10 eb 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.1 CardBus bridge: Texas Instruments PCI1251A
	Subsystem: IBM Unknown device 00eb
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at 50101000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
	Memory window 0: 28000000-2bfff000 (prefetchable)
	Memory window 1: 2c000000-2ffff000
	I/O window 0: 00001800-000018ff
	I/O window 1: 00001c00-00001cff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
00: 4c 10 1d ac 07 00 10 02 00 00 07 06 08 a8 82 00
10: 00 10 10 50 a0 00 00 02 00 06 09 b0 00 00 00 28
20: 00 f0 ff 2b 00 00 00 2c 00 f0 ff 2f 00 18 00 00
30: fc 18 00 00 00 1c 00 00 fc 1c 00 00 0b 02 c0 05
40: 14 10 eb 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:06.0 Multimedia audio controller: Cirrus Logic CS 4610/11 [CrystalClear SoundFusion Audio Accelerator] (rev 01)
	Subsystem: IBM CS4610 SoundFusion Audio Accelerator
	Flags: bus master, medium devsel, latency 32, IRQ 9
	Memory at 50100000 (32-bit, non-prefetchable) [size=4K]
	Memory at 50000000 (32-bit, non-prefetchable) [size=1M]
00: 13 10 01 60 06 01 00 02 01 00 01 04 00 20 00 00
10: 00 00 10 50 00 00 00 50 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 10 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 01 04 18

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
	Flags: bus master, medium devsel, latency 0
00: 86 80 10 71 0f 00 80 02 02 00 80 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Flags: bus master, medium devsel, latency 48
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at fcf0 [size=16]
	Kernel driver in use: PIIX_IDE
00: 86 80 11 71 05 00 80 02 01 80 01 01 00 30 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: f1 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Flags: bus master, medium devsel, latency 48, IRQ 11
	I/O ports at 8400 [size=32]
	Kernel driver in use: uhci_hcd
00: 86 80 12 71 05 00 80 02 01 00 03 0c 00 30 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 04 00 00

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
	Flags: medium devsel, IRQ 9
00: 86 80 13 71 03 00 80 02 02 00 80 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:00.0 VGA compatible controller: Neomagic Corporation NM2200 [MagicGraph 256AV] (rev 12) (prog-if 00 [VGA controller])
	Subsystem: IBM ThinkPad 570
	Flags: bus master, medium devsel, latency 128, IRQ 11
	Memory at e0000000 (32-bit, prefetchable) [size=16M]
	Memory at 70000000 (32-bit, non-prefetchable) [size=4M]
	Memory at 70400000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [dc] Power Management version 1
	Kernel driver in use: neofb
00: c8 10 05 00 07 00 90 02 12 00 00 03 00 80 00 00
10: 08 00 00 e0 00 00 00 70 00 00 40 70 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 dd 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 10 ff

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Surecom Technology Unknown device 0428
	Flags: bus master, medium devsel, latency 64, IRQ 11
	I/O ports at 1000 [size=256]
	Memory at 24000000 (32-bit, non-prefetchable) [size=512]
	Capabilities: [50] Power Management version 2
	Kernel driver in use: 8139too
00: ec 10 39 81 07 00 90 02 10 00 00 02 00 40 00 00
10: 01 10 00 00 00 00 00 24 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 02 01 00 00 bd 10 28 04
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 20 40


--Boundary-00=_kuGsJ38QCaGmoiO
Content-Type: text/plain;
  charset="iso-8859-1";
  name="lspci_r8169"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_r8169"

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
	Flags: bus master, medium devsel, latency 64
	Memory at 40000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 1.0
	Kernel driver in use: agpgart-intel
00: 86 80 90 71 06 00 10 22 03 00 00 06 00 40 00 00
10: 08 00 00 40 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 168
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=176
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: 70000000-dfffffff
	Prefetchable memory behind bridge: e0000000-f7ffffff
00: 86 80 91 71 07 00 20 02 03 00 04 06 00 a8 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 b0 d0 d0 a0 a2
20: 00 70 f0 df 00 e0 f0 f7 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 88 00

00:02.0 CardBus bridge: Texas Instruments PCI1251A
	Subsystem: IBM Unknown device 00eb
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at 50102000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 20000000-23fff000 (prefetchable)
	Memory window 1: 24000000-27fff000
	I/O window 0: 00001000-000010ff
	I/O window 1: 00001400-000014ff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
00: 4c 10 1d ac 07 00 10 02 00 00 07 06 08 a8 82 00
10: 00 20 10 50 a0 00 00 02 00 02 05 b0 00 00 00 20
20: 00 f0 ff 23 00 00 00 24 00 f0 ff 27 00 10 00 00
30: fc 10 00 00 00 14 00 00 fc 14 00 00 0b 01 00 05
40: 14 10 eb 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:02.1 CardBus bridge: Texas Instruments PCI1251A
	Subsystem: IBM Unknown device 00eb
	Flags: bus master, medium devsel, latency 168, IRQ 11
	Memory at 50101000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
	Memory window 0: 28000000-2bfff000 (prefetchable)
	Memory window 1: 2c000000-2ffff000
	I/O window 0: 00001800-000018ff
	I/O window 1: 00001c00-00001cff
	16-bit legacy interface ports at 0001
	Kernel driver in use: yenta_cardbus
00: 4c 10 1d ac 07 00 10 02 00 00 07 06 08 a8 82 00
10: 00 10 10 50 a0 00 00 02 00 06 09 b0 00 00 00 28
20: 00 f0 ff 2b 00 00 00 2c 00 f0 ff 2f 00 18 00 00
30: fc 18 00 00 00 1c 00 00 fc 1c 00 00 0b 02 c0 05
40: 14 10 eb 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:06.0 Multimedia audio controller: Cirrus Logic CS 4610/11 [CrystalClear SoundFusion Audio Accelerator] (rev 01)
	Subsystem: IBM CS4610 SoundFusion Audio Accelerator
	Flags: bus master, medium devsel, latency 32, IRQ 9
	Memory at 50100000 (32-bit, non-prefetchable) [size=4K]
	Memory at 50000000 (32-bit, non-prefetchable) [size=1M]
00: 13 10 01 60 06 01 00 02 01 00 01 04 00 20 00 00
10: 00 00 10 50 00 00 00 50 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 10 10
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 01 04 18

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
	Flags: bus master, medium devsel, latency 0
00: 86 80 10 71 0f 00 80 02 02 00 80 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Flags: bus master, medium devsel, latency 48
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at fcf0 [size=16]
	Kernel driver in use: PIIX_IDE
00: 86 80 11 71 05 00 80 02 01 80 01 01 00 30 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: f1 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Flags: bus master, medium devsel, latency 48, IRQ 11
	I/O ports at 8400 [size=32]
	Kernel driver in use: uhci_hcd
00: 86 80 12 71 05 00 80 02 01 00 03 0c 00 30 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 84 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 04 00 00

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
	Flags: medium devsel, IRQ 9
00: 86 80 13 71 03 00 80 02 02 00 80 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

01:00.0 VGA compatible controller: Neomagic Corporation NM2200 [MagicGraph 256AV] (rev 12) (prog-if 00 [VGA controller])
	Subsystem: IBM ThinkPad 570
	Flags: bus master, medium devsel, latency 128, IRQ 11
	Memory at e0000000 (32-bit, prefetchable) [size=16M]
	Memory at 70000000 (32-bit, non-prefetchable) [size=4M]
	Memory at 70400000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [dc] Power Management version 1
	Kernel driver in use: neofb
00: c8 10 05 00 07 00 90 02 12 00 00 03 00 80 00 00
10: 08 00 00 e0 00 00 00 70 00 00 40 70 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 14 10 dd 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 10 ff

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet
	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
	I/O ports at 1000 [size=256]
	Memory at 24000000 (32-bit, non-prefetchable) [size=512]
	Expansion ROM at 20000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
	Kernel driver in use: r8169
00: ec 10 69 81 17 00 b0 02 10 00 00 02 08 40 00 00
10: 01 10 00 00 00 00 00 24 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 02 01 00 00 ec 10 69 81
30: 00 00 fc 5f dc 00 00 00 00 00 00 00 0b 01 20 40


--Boundary-00=_kuGsJ38QCaGmoiO--
