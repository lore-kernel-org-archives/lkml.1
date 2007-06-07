Return-Path: <linux-kernel-owner+w=401wt.eu-S935566AbXFGTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935566AbXFGTNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762068AbXFGTM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:12:59 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:33452 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S935478AbXFGTM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:12:58 -0400
X-Greylist: delayed 3585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 15:12:57 EDT
Subject: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
From: Paul Albrecht <albrecht@rdi1.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Jun 2007 13:17:30 -0400
Message-Id: <1181236651.15435.1.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying use the 2.6.20 kernel and have run into a problem using the
ps/2 keyboard with console. When I type input in response to console
output the characters aren't echo'ed and the console program doesn't
receive the character input. It seems like the problem is specific to
the ps/2 interface because a usb keyboard works fine.

Here's dmesg output:



Linux version 2.6.20 (root@albrecht.rdi1.com) (gcc version 3.3.3) #3 Wed
Jun 6 09:58:30 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001f6f0000 end:
000000001f7f0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001f7f0000 size: 0000000000003000 end:
000000001f7f3000 type: 4
copy_e820_map() start: 000000001f7f3000 size: 000000000000d000 end:
000000001f800000 type: 3
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end:
0000000100000000 type: 2
BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000001f7f0000 (usable)
BIOS-e820: 000000001f7f0000 - 000000001f7f3000 (ACPI NVS)
BIOS-e820: 000000001f7f3000 - 000000001f800000 (ACPI data)
BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
503MB LOWMEM available.
Entering add_active_range(0, 0, 129008) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   129008
early_node_map[1] active PFN ranges
    0:        0 ->   129008
On node 0 totalpages: 129008
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 975 pages used for memmap
  Normal zone: 123937 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP (v000 VIA605                                ) @ 0x000f7510
ACPI: RSDT (v001 VIA605 AWRDACPI 0x42302e31 AWRD 0x00000000) @
0x1f7f3040
ACPI: FADT (v001 VIA605 AWRDACPI 0x42302e31 AWRD 0x00000000) @
0x1f7f30c0
ACPI: DSDT (v001 VIA605 AWRDACPI 0x00001000 MSFT 0x0100000e) @
0x00000000
Allocating PCI resources starting at 20000000 (gap: 1f800000:e07f0000)
Detected 800.024 MHz processor.
Built 1 zonelists.  Total pages: 128001
Kernel command line: root=/dev/hda1 vga=791 splash=noconsole ide=nodma
quiet noinitrd
bootsplash: no console.
ide_setup: ide=nodma : Prevented DMA
No local APIC present or hardware disabled
mapped APIC to ffffd000 (013f2000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 503740k/516032k available (4429k kernel code, 11704k reserved,
1931k data, 224k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb6000 - 0xfffff000   ( 292 kB)
    vmalloc : 0xe0000000 - 0xfffb4000   ( 511 MB)
    lowmem  : 0xc0000000 - 0xdf7f0000   ( 503 MB)
      .init : 0xc073a000 - 0xc0772000   ( 224 kB)
      .data : 0xc0553428 - 0xc073638c   (1931 kB)
      .text : 0xc0100000 - 0xc0553428   (4429 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 1601.79 BogoMIPS
(lpj=3203585)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0381b03f 00000000 00000000 00000000
00000000 00000000 00000000
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 64K (32 bytes/line)
CPU: After all inits, caps: 0381b13f 00000000 00000000 00000000 00000000
000000dd 00000000
Compat vDSO mapped to ffffe000.
CPU: Centaur VIA Nehemiah stepping 08
Checking 'hlt' instruction... OK.
ACPI: Core revision 20060707
ACPI: setting ELCR to 0080 (from 1c80)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb4d0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 10 11 *12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 11 devices
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
report
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: ec000000-ec0fffff
  PREFETCH window: e0000000-e7ffffff
PCI: Bus 2, cardbus bridge: 0000:00:0d.0
  IO window: 00001000-000010ff
  IO window: 00001400-000014ff
  PREFETCH window: 20000000-23ffffff
  MEM window: 24000000-27ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKA] -> GSI 10 (level,
low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 16384 bind 8192)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers);
looks like an initrd
Freeing initrd memory: 22k freed
audit: initializing netlink socket (disabled)
audit(1181215562.596:1): initialized
squashfs: version 3.2-r2 (2007/01/15) Phillip Lougher
Coda Kernel/Venus communications, v6.0.0, coda@cs.cmu.edu
NTFS driver 2.1.28 [Flags: R/W].
Supermount version 2.0.4 for kernel 2.6
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Disabling Via external APIC routing
vesafb: framebuffer at 0xe0000000, mapped to 0xe0080000, using 6144k,
total 7104k
vesafb: mode is 1024x768x16, linelength=2048, pages=3
vesafb: protected mode interface info at c000:79d0
vesafb: pmi: set display start = c00c7a5a, set palette = c00c7aa3
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
bootsplash 3.1.6-2004/03/31: looking for picture...<6> silentjpeg size
8984 bytes,<6>...found (1024x768, 14465 bytes, v3).
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 2 throttling states)
lp: driver loaded but no devices found
Generic RTC Driver v1.07
Non-volatile memory driver v1.2
VIA RNG detected
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected VIA ProSavage PM133/PL133/PN133 chipset
agpgart: AGP aperture is 64M @ 0xe8000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x0
parport_pc: VIA parallel port disabled in BIOS
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
NET: Registered protocol family 24
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKC] -> GSI 11 (level,
low) -> IRQ 11
eth0: RealTek RTL8139 at 0xc800, 00:e0:4c:69:2b:a5, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin
<proski@gnu.org>, et al)
orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel
Roskin <proski@gnu.org>, et al)
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with
idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xdd00-0xdd07, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xdd08-0xdd0f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
hda: SanDisk SDCFB-1024, CFA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
Probing IDE interface ide1...
Probing IDE interface ide2...
Probing IDE interface ide3...
hda: max request size: 128KiB
hda: 2001888 sectors (1024 MB) w/1KiB Cache, CHS=1986/16/63
hda: hda1 hda2
Yenta: CardBus bridge found at 0000:00:0d.0 [3412:7856]
Yenta: ISA IRQ mask 0x0000, PCI irq 10
Socket status: 30000006
usbmon: debugfs is not available
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
(PCI)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] -> GSI 12 (level,
low) -> IRQ 12
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 12, io base 0x0000e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:07.3[D] -> Link [LNKD] -> GSI 12 (level,
low) -> IRQ 12
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 12, io base 0x0000dc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver hiddev
input: Microsoft Basic Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Microsoft Basic Optical Mouse] on
usb-0000:00:07.3-1
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
usbcore: registered new interface driver usblcd
usbcore: registered new interface driver usbled
usbcore: registered new interface driver uss720
drivers/usb/misc/uss720.c: v0.6:USB Parport Cable driver for Cables
using the Lucent Technologies USS720 Chip
drivers/usb/misc/uss720.c: NOTE: this is a special purpose driver to
allow nonstandard
drivers/usb/misc/uss720.c: protocols (eg. bitbang) over USS720 usb to
parallel cables
drivers/usb/misc/uss720.c: If you just want to connect to a printer, use
usblp instead
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
input: PC Speaker as /class/input/input4
Linux telephony interface: v1.00
ixj driver initialized.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
Advanced Linux Sound Architecture Driver Version 1.0.14rc1 (Tue Jan 09
09:56:17 2007 UTC).
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 11 (level,
low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:07.5 to 64
usbcore: registered new interface driver snd-usb-audio
usbcore: registered new interface driver snd-usb-usx2y
ALSA device list:
  #0: VIA 82C686A/B rev50 with VIA1612A at 0xc000, irq 11
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
ACPI: (supports S0 S3 S4<6>Time: tsc clocksource has been installed.
S5)
ReiserFS: hda1: warning: read_super_block: found reiserfs format "3.6"
with non-standard journal
ReiserFS: hda1: using ordered data mode
ReiserFS: hda1: journal params: device hda1, size 512, journal first
block 18, max trans len 256, max batch 225, max commit age 30, max trans
age 30
ReiserFS: hda1: checking transaction log (hda1)
Time: pit clocksource has been installed.
ReiserFS: hda1: replayed 10 transactions in 1 seconds
ReiserFS: hda1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 224k freed
ReiserFS: dm-0: warning: read_super_block: found reiserfs format "3.6"
with non-standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 2048, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: replayed 20 transactions in 4 seconds
ReiserFS: dm-0: Using r5 hash to sort names
pcmcia: Detected deprecated PCMCIA ioctl usage from process: cardmgr.
pcmcia: This interface will soon be removed from the kernel; please
expect breakage unless you upgrade to new tools.
pcmcia: see
http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for
details.
eth0: link up, 10Mbps, half-duplex, lpa 0x0000



Any idea what the problem is or how to debug?

Paul Albrecht
