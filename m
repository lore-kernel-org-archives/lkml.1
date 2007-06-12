Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXFLT5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXFLT5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 15:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbXFLT5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 15:57:46 -0400
Received: from host-66-43-248-10 ([67.55.143.10]:43510 "EHLO albrecht.rdi1.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752026AbXFLT5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 15:57:45 -0400
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
From: Paul Albrecht <albrecht@rdi1.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <d120d5000706121150p56a581d3je6d9a886529b591@mail.gmail.com>
References: <1181236651.15435.1.camel@albrecht.rdi1.com>
	 <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com>
	 <1181588095.2436.5.camel@albrecht.rdi1.com>
	 <200706120114.48645.dtor@insightbb.com>
	 <1181656946.3176.1.camel@albrecht.rdi1.com>
	 <d120d5000706121150p56a581d3je6d9a886529b591@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 12 Jun 2007 15:02:15 -0400
Message-Id: <1181674936.2533.1.camel@albrecht.rdi1.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-12 at 14:50 -0400, Dmitry Torokhov wrote: 
> On 6/12/07, Paul Albrecht <albrecht@rdi1.com> wrote:
> > On Tue, 2007-06-12 at 01:14 -0400, Dmitry Torokhov wrote:
> > > On Monday 11 June 2007 14:54, Paul Albrecht wrote:
> > > >
> > > > Is i8042.noaux a workaround or a fix?
> > > >
> > >
> > > Just a workaround. Do you have a PS/2 mouse you could test with? If so could
> > > you check if both keybioard and mouse work with mouse plugged in and without
> > > i8042.noaux.
> > >
> >
> > The system I'm using has only one ps/2 interface so I can't test with
> > them both plugged in at the same time.
> >
> > > Also cxould you please try the patch below (again with mouse if you have one
> > > and without).
> > >
> >
> > I tried applying your patch to 2.6.21.5 and it failed. Here's the
> > output:
> >
> > patch --dry-run -p1 < ../i8042.patch
> > patching file drivers/input/serio/i8042-x86ia64io.h
> > Hunk #1 FAILED at 356.
> > Hunk #2 FAILED at 404.
> > 2 out of 2 hunks FAILED -- saving rejects to file
> > drivers/input/serio/i8042-x86ia64io.h.rej
> >
> 
> Hmm, wierd:
> 
> [~] tar jxf downloads/linux-2.6.21.5.tar.bz2
> [~] cd linux-2.6.21.5/
> [~/linux-2.6.21.5] patch -p1 --dry-run < ../quilt/i8042-trust-pnp-more.patch
> patching file drivers/input/serio/i8042-x86ia64io.h
> Hunk #1 succeeded at 313 (offset -43 lines).
> Hunk #2 succeeded at 361 (offset -43 lines).
> [~/linux-2.6.21.5]
> 
> The patch must have gotten corrupted on the way to you. Let me try
> resending it, but this time as an attachment.
> 

There must be some difference between the sources we're using because
when I try to patch 2.6.21.5 I get this for output:

patch --dry-run -p1 < ../i8042-trust-pnp-more.patch
patching file drivers/input/serio/i8042-x86ia64io.h
Hunk #1 succeeded at 313 (offset -43 lines).

However, the patch succeeded so I retested without i8042.noaux and that
worked. Here's the dmesg output:



nux version 2.6.21.5 (root@albrecht.rdi1.com) (gcc version 3.3.3) #2 Tue
Jun 12 14:08:06 EDT 2007
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
ACPI: RSDP 000F7510, 0014 (r0 VIA605)
ACPI: RSDT 1F7F3040, 0028 (r1 VIA605 AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 1F7F30C0, 0074 (r1 VIA605 AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 1F7F3180, 2218 (r1 VIA605 AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 1F7F0000, 0040
Allocating PCI resources starting at 20000000 (gap: 1f800000:e07f0000)
Built 1 zonelists.  Total pages: 128001
Kernel command line: THINIXCONF=true root=/dev/hda1 vga=791
splash=silent ide=nodma quiet noinitrd i8042.debug log_buf_len=131072
ide_setup: ide=nodma : Prevented DMA
log_buf_len: 131072
No local APIC present or hardware disabled
mapped APIC to ffffd000 (01412000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 800.043 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 503572k/516032k available (4452k kernel code, 11872k reserved,
1952k data, 240k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb6000 - 0xfffff000   ( 292 kB)
    vmalloc : 0xe0000000 - 0xfffb4000   ( 511 MB)
    lowmem  : 0xc0000000 - 0xdf7f0000   ( 503 MB)
      .init : 0xc0744000 - 0xc0780000   ( 240 kB)
      .data : 0xc05592a0 - 0xc074140c   (1952 kB)
      .text : 0xc0100000 - 0xc05592a0   (4452 kB)
Checking if this processor honours the WP bit even in supervisor mode...
Ok.
Calibrating delay using timer specific routine.. 1601.89 BogoMIPS
(lpj=3203785)
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
ACPI: Core revision 20070126
ACPI: setting ELCR to 0080 (from 1c80)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb4d0, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
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
pnp: 00:00: iomem range 0xcc000-0xcffff could not be reserved
pnp: 00:00: iomem range 0xda800-0xdbfff has been reserved
pnp: 00:00: iomem range 0xf0000-0xfbfff could not be reserved
pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
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
Time: tsc clocksource has been installed.
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKA] -> GSI 10 (level,
low) -> IRQ 10
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs...it isn't (bad gzip magic numbers);
looks like an initrd
Freeing initrd memory: 22k freed
audit: initializing netlink socket (disabled)
audit(1181658118.292:1): initialized
squashfs: version 3.2-r2 (2007/01/15) Phillip Lougher
Coda Kernel/Venus communications, v6.0.0, coda@cs.cmu.edu
NTFS driver 2.1.28 [Flags: R/W].
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Disabling Via external APIC routing
vesafb: framebuffer at 0xe0000000, mapped to 0xe0080000, using 3072k,
total 7104k
vesafb: mode is 1024x768x16, linelength=2048, pages=3
vesafb: protected mode interface info at c000:79d0
vesafb: pmi: set display start = c00c7a5a, set palette = c00c7aa3
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
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
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected VIA ProSavage PM133/PL133/PN133 chipset
agpgart: AGP aperture is 64M @ 0xe8000000
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Time: pit clocksource has been installed.
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
via-rhine: Broken BIOS detected, avoid_D3 enabled.
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
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
boot with i8042.nopnp
drivers/input/serio/i8042.c: 20 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 67 <- i8042 (return) [0]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 76 -> i8042 (parameter) [0]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [0]
drivers/input/serio/i8042.c: 67 -> i8042 (parameter) [0]
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [0]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [1]
drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [2]
drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [2]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [2]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [3]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [3]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [4]
drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [4]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [5]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [5]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [6]
drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [6]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [7]
input: AT Translated Set 2 keyboard as /class/input/input3
input: PC Speaker as /class/input/input4
Linux telephony interface: v1.00
ixj driver initialized.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised:
dm-devel@redhat.com
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14
07:25:50 2007 UTC).
ACPI: PCI Interrupt 0000:00:07.5[C] -> Link [LNKC] -> GSI 11 (level,
low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:07.5 to 64
usbcore: registered new interface driver snd-usb-audio
usbcore: registered new interface driver snd-usb-usx2y
ALSA device list:
  #0: VIA 82C686A/B rev50 with VIA1612A at 0xc000, irq 11
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI Shortcut mode
ReiserFS: hda1: warning: read_super_block: found reiserfs format "3.6"
with non-standard journal
ReiserFS: hda1: using ordered data mode
ReiserFS: hda1: journal params: device hda1, size 512, journal first
block 18, max trans len 256, max batch 225, max commit age 30, max trans
age 30
ReiserFS: hda1: checking transaction log (hda1)
ReiserFS: hda1: replayed 9 transactions in 0 seconds
ReiserFS: hda1: Using r5 hash to sort names
VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 240k freed
ReiserFS: dm-0: warning: read_super_block: found reiserfs format "3.6"
with non-standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 2048, journal first
block 18, max trans len 1024, max batch 900, max commit age 30, max
trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: replayed 20 transactions in 5 seconds
ReiserFS: dm-0: Using r5 hash to sort names



Paul Albrecht

