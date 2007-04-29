Return-Path: <linux-kernel-owner+w=401wt.eu-S1030876AbXD2SWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876AbXD2SWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 14:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030951AbXD2SWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 14:22:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:45232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030876AbXD2SWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 14:22:11 -0400
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org, mkruky@linuxtv.org, linux-dvb@linuxtv.org
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 29 Apr 2007 20:22:09 +0200
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070429182209.267430@gmx.net>
MIME-Version: 1.0
Subject: Critical points about kernel 2.6.21 and pseudo-authorities
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18ozvNRJKcoIq8ulqbM97S63Y3HPS/rf3EEmPGgLr
 1DOSP35V6Pn9MJzIX40LKWrvJGVCZWVl3Z7w== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: P49WEjBIbXB+QWH8TTQ2G0QiLyUmZUhF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I swear I tested all seven release candidates of 2.6.21.
All were fine, and at least I haven't found any regressions.

But, what causes me some headache:

It seems to me that at every transition from the last release candidate
to the full kernel version stuff is being pushed in that should never be pushed in at all:

This happened with the final release of 2.6.20 (ide layer unusable),
and now it happens at some different place:

Symptoms:
for my AMD K7 machine, which is all but SiS chipset and configured as router,
the official 2.6.21 kernel is simply unusable, as it hangs up my machine
completely.

And now comes the critical point:
If I use kernel 2.6.21 in connection with git2 (NOT: git1) everything is fine so far.

BUT: This 2.6.21-git2 is unusable in so far as it contains regressive code
in the dvb-section, authored by Trent Piepho, acked by Michael Krufky, and signed-off-by Mauro Carvalho Chehab:

The regression is as follows:
If you run for instance a DVB card like the Pinnacle PCTV SAT (or CI) or the TwinHan DST (or CA) (which are two cards in a much bigger list of cards that, proven by facts, do not need any dvb-pll.c-module), you do not have any chance to deselect the compilation of the dvb-pll.c-module, as its deselection only works for VIDEO_V4L1_COMPAT, NOT for VIDEO_V4L1.
This part of the git2-code is a fallback to the development state of the year 2005.
All the almost excellent work that Michael Krufky has offered for that issue at the transition from 2.6.18 to 2.6.19 or 2.6.20 (do not remeber exactly) is being wiped out and rolled back with his acknowledgement! Incredible!

So if I, as everybody else would, expect a clean and working kernel as final release,
where is the way out of this dilemma?? No idea!
And what happens at the transition of the last release candidate to the official kernel version? It's just another sad miracle!

I will append one dmesg for my AMD K7 router, which needs git2 to function at all,
plus one dmesg of my Intel P4 workstation, for which the official 2.6.21 plus all
preceding release candidates are fine, but NOT git2 definitely:

1. the dmesg of the AMD K7 router machine
Linux version 2.6.21-git2 (root@jerry) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Sat Apr 28 15:23:35 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001def0000 end: 000000001dff0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001dff0000 size: 0000000000008000 end: 000000001dff8000 type: 3
copy_e820_map() start: 000000001dff8000 size: 0000000000008000 end: 000000001e000000 type: 4
copy_e820_map() start: 00000000ffee0000 size: 0000000000020000 end: 00000000fff00000 type: 2
copy_e820_map() start: 00000000fffc0000 size: 0000000000040000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001dff0000 (usable)
 BIOS-e820: 000000001dff0000 - 000000001dff8000 (ACPI data)
 BIOS-e820: 000000001dff8000 - 000000001e000000 (ACPI NVS)
 BIOS-e820: 00000000ffee0000 - 00000000fff00000 (reserved)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
479MB LOWMEM available.
Entering add_active_range(0, 0, 122864) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   122864
early_node_map[1] active PFN ranges
    0:        0 ->   122864
On node 0 totalpages: 122864
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 927 pages used for memmap
  Normal zone: 117841 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000FA320, 0014 (r0 AMI   )
ACPI: RSDT 1DFF0000, 0028 (r1 AMIINT SiS740XX     1000 MSFT  100000B)
ACPI: FACP 1DFF0030, 0081 (r2 AMIINT SiS740XX       11 MSFT  100000B)
ACPI: DSDT 1DFF00C0, 3297 (r1    SiS      740      100 MSFT  100000D)
ACPI: FACS 1DFF8000, 0040
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 20000000 (gap: 1e000000:e1ee0000)
Built 1 zonelists.  Total pages: 121905
Kernel command line: root=/dev/hda1 ro vga=791
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (013c2000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1526.880 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 484532k/491456k available (1349k kernel code, 6376k reserved, 477k data, 136k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb8000 - 0xfffff000   ( 284 kB)
    vmalloc : 0xde800000 - 0xfffb6000   ( 535 MB)
    lowmem  : 0xc0000000 - 0xddff0000   ( 479 MB)
      .init : 0xc02cc000 - 0xc02ee000   ( 136 kB)
      .data : 0xc0251682 - 0xc02c8cd0   ( 477 kB)
      .text : 0xc0100000 - 0xc0251682   (1349 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3054.53 BogoMIPS (lpj=1527269)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1c3f9ff 00000000 00000000 00000000 00000000 00000000
CPU: CLK_CTL MSR was 6003d22f. Reprogramming to 2003d22f
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f9ff c1c3f9ff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) XP 1800+ stepping 01
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0820)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfdb01, last bus=2
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Enabling SiS 96x SMBus.
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [URP2] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Time: tsc clocksource has been installed.
PCI: Ignore bogus resource 6 [0:0] of 0000:01:00.0
PCI: Bridge: 0000:00:01.0
  IO window: a000-afff
  MEM window: cfd00000-cfefffff
  PREFETCH window: bfa00000-cfbfffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
io scheduler noop registered (default)
vesafb: framebuffer at 0xc0000000, mapped to 0xde880000, using 3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=4
vesafb: protected mode interface info at cbd0:000c
vesafb: pmi: set display start = c00cbd46, set palette = c00cbd9c
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: IDE controller at PCI slot 0000:00:02.5
SIS5513: chipset revision 0
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
    ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xff08-0xff0f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: HDS728080PLAT20, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: TSSTcorpDVD-ROM SH-D162C, ATAPI CD/DVD-ROM drive
hdd: CD-540E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 160836480 sectors (82348 MB) w/1719KiB Cache, CHS=16383/255/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 hda8 >
TCP cubic registered
Using IPI Shortcut mode
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 136k freed
NET: Registered protocol family 1
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected SiS 740 chipset
agpgart: AGP aperture is 64M @ 0xd0000000
sis900.c: v1.08.10 Apr. 2 2006
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
0000:00:04.0: VIA 6103 PHY transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0xd000, IRQ 11, 00:0a:e6:67:a3:c1.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0b.0: 3Com PCI 3c905B Cyclone 100baseTx at de81cf80.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKE] -> GSI 5 (level, low) -> IRQ 5
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:03.0: irq 5, io mem 0xcfff7000
SCSI subsystem initialized
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
hdc: ATAPI 48X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X CD-ROM drive, 128kB Cache, UDMA(33)
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:03.1[B] -> Link [LNKF] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.1: irq 11, io mem 0xcfff8000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:03.2[C] -> Link [LNKG] -> GSI 11 (level, low) -> IRQ 11
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.2: irq 11, io mem 0xcfff9000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:03.3[D] -> Link [LNKH] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 4
PCI: cache line size of 64 is not supported by device 0000:00:03.3
ehci_hcd 0000:00:03.3: irq 11, io mem 0xcfffa000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0x0c00
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKB] -> GSI 5 (level, low) -> IRQ 5
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2940A Ultra SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

ACPI: PCI Interrupt 0000:00:02.7[C] -> Link [LNKC] -> GSI 11 (level, low) -> IRQ 11
intel8x0_measure_ac97_clock: measured 50839 usecs
intel8x0: clocking to 48000
Adding 1951856k swap on /dev/hda7.  Priority:-1 extents:1 across:1951856k
EXT3 FS on hda1, internal journal
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
NET: Registered protocol family 17
mice: PS/2 mouse device common for all mice
PNP: PS/2 Controller [PNP030b:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
loop: loaded (max 8 devices)
logips2pp: Detected unknown logitech mouse model 5
input: PS/2 Logitech Mouse as /class/input/input3
input: AT Translated Set 2 keyboard as /class/input/input4
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth1:  setting full-duplex.
eth1:  setting full-duplex.
eth0: Media Link On 100mbps full-duplex 
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
lp0: using parport0 (interrupt-driven).
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (3839 buckets, 30712 max)

2. The dmesg of the Intel P4 workstation, whose DVB card (Pinnacle PCTV SAT) is, in spite of all attempts of Mister Mauro Carvalho Chehab (chief maintainer of linuxtv.org) to ignore my contributions and fighting them down, WORKING EXCELLENTLY
without the modules dst, dst_ca AND, latest git2 regression caused by Chehab personally, WITHOUT module dvb-pll.c!
Linux version 2.6.21.1 (root@brian) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 PREEMPT Sun Apr 29 15:48:44 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000001feec000 end: 000000001ffec000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000001ffec000 size: 0000000000003000 end: 000000001ffef000 type: 3
copy_e820_map() start: 000000001ffef000 size: 0000000000010000 end: 000000001ffff000 type: 2
copy_e820_map() start: 000000001ffff000 size: 0000000000001000 end: 0000000020000000 type: 4
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end: 00000000fec01000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
 BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
511MB LOWMEM available.
Entering add_active_range(0, 0, 131052) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   131052
early_node_map[1] active PFN ranges
    0:        0 ->   131052
On node 0 totalpages: 131052
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 991 pages used for memmap
  Normal zone: 125965 pages, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F5360, 0014 (r0 ASUS  )
ACPI: RSDT 1FFEC000, 0030 (r1 ASUS   P4PE     42302E31 MSFT 31313031)
ACPI: FACP 1FFEC0C0, 0074 (r1 ASUS   P4PE     42302E31 MSFT 31313031)
ACPI: DSDT 1FFEC134, 2A43 (r1   ASUS P4PE         1000 MSFT  100000B)
ACPI: FACS 1FFFF000, 0040
ACPI: BOOT 1FFEC030, 0028 (r1 ASUS   P4PE     42302E31 MSFT 31313031)
ACPI: APIC 1FFEC058, 005A (r1 ASUS   P4PE     42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 22 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 30000000 (gap: 20000000:dec00000)
Built 1 zonelists.  Total pages: 130029
Kernel command line: root=/dev/hda1 ro vga=791
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1818.051 MHz processor.
Console: colour dummy device 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 517076k/524208k available (1309k kernel code, 6596k reserved, 485k data, 136k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb8000 - 0xfffff000   ( 284 kB)
    vmalloc : 0xe0800000 - 0xfffb6000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
      .init : 0xc02c4000 - 0xc02e6000   ( 136 kB)
      .data : 0xc02475aa - 0xc02c0b90   ( 485 kB)
      .text : 0xc0100000 - 0xc02475aa   (1309 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3637.56 BogoMIPS (lpj=1818780)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 3febfbff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: 3febfbff 00000000 00000000 00003080 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) 4 CPU 1.80GHz stepping 04
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1e60, last bus=2
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
* The chipset may have PM-Timer Bug. Due to workarounds for a bug,
* this clock source is slow. If you are sure your timer does not have
* this bug, please use "acpi_pm_good" to disable the workaround
PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
PCI: Enabled i801 SMBus device
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 17 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x1fffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:02: ioport range 0xe400-0xe47f has been reserved
pnp: 00:02: ioport range 0xe800-0xe81f has been reserved
pnp: 00:02: ioport range 0xec00-0xec3f has been reserved
pnp: 00:02: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
pnp: 00:02: iomem range 0xffb80000-0xffbfffff has been reserved
pnp: 00:10: ioport range 0x3f0-0x3f1 has been reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: d000-dfff
  MEM window: f2000000-f27fffff
  PREFETCH window: f3f00000-f7ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: f1000000-f17fffff
  PREFETCH window: f2800000-f3efffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
Simple Boot Flag at 0x3a set to 0x1
io scheduler noop registered (default)
vesafb: framebuffer at 0xf4000000, mapped to 0xe0880000, using 3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=20
vesafb: protected mode interface info at c000:441b
vesafb: pmi: set display start = c00c4489, set palette = c00c44c3
vesafb: pmi: ports = d810 d816 d854 d838 d83c d85c d800 d804 d8b0 d8b2 d8b4 
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH4: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 16
ICH4: chipset revision 2
ICH4: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IC35L080AVVA07-0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: HL-DT-STDVD-ROM GDR8163B, ATAPI CD/DVD-ROM drive
hdd: CD-W54E, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 160836480 sectors (82348 MB) w/1863KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 hda7 >
TCP cubic registered
Using IPI Shortcut mode
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 136k freed
NET: Registered protocol family 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 17, io base 0x0000b800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 18, io base 0x0000b400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 16, io base 0x0000b000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PCI: Enabling device 0000:00:1d.7 (0004 -> 0006)
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xf1800000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
hdc: ATAPI 52X DVD-ROM drive, 256kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Linux video capture interface: v2.00
b44.c:v1.01 (Jun 16, 2006)
PCI: Enabling device 0000:02:05.0 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:05.0[A] -> GSI 20 (level, low) -> IRQ 20
eth0: Broadcom 4400 10/100BaseT Ethernet 00:0c:6e:19:46:cf
hdd: ATAPI 32X CD-ROM CD-R/RW drive, 1280kB Cache, DMA
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
PCI: Enabling device 0000:00:1f.5 (0004 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1f.5 to 64
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
intel8x0_measure_ac97_clock: measured 50043 usecs
intel8x0: clocking to 48000
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 21
bttv: Bt8xx card found (0).
PCI: Enabling device 0000:02:0b.0 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:0b.0[A] -> GSI 23 (level, low) -> IRQ 19
bttv0: Bt878 (rev 17) at 0000:02:0b.0, irq: 19, latency: 32, mmio: 0xf3000000
bttv0: detected: Pinnacle PCTV Sat [card=94], PCI subsystem ID is 11bd:001c
bttv0: using: Pinnacle PCTV Sat [card=94,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00df00fc [init]
bttv0: using tuner=-1
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bttv0: add subdevice "dvb0"
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
PCI: Enabling device 0000:02:0b.1 (0004 -> 0006)
ACPI: PCI Interrupt 0000:02:0b.1[A] -> GSI 23 (level, low) -> IRQ 19
bt878_probe: card id=[0x1c11bd],[ Pinnacle PCTV Sat ] has DVB functions.
bt878(0): Bt878 (rev 17) at 02:0b.1, irq: 19, latency: 32, memory: 0xf2800000
Adding 1951856k swap on /dev/hda6.  Priority:-1 extents:1 across:1951856k
EXT3 FS on hda1, internal journal
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Invalid PBLK length [5]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
NET: Registered protocol family 17
mice: PS/2 mouse device common for all mice
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Translated Set 2 keyboard as /class/input/input2
DVB: registering new adapter (bttv0).
DVB: registering frontend 0 (Conexant CX24110 DVB-S)...
loop: loaded (max 8 devices)
logips2pp: Detected unknown logitech mouse model 11
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
input: PS/2 Logitech Mouse as /class/input/input3
b44: eth0: Link is up at 100 Mbps, full duplex.
b44: eth0: Flow control is off for TX and off for RX.

Hope there is a way out of the dilemma.
Why can't I even expect sober kernels that are being released as official final releases? I assume that this has got something to do with rather pseudo-authority hierarchies, at least in one proven and certified case @linuxtv.org!

Cheers
Uwe

-- 



"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: http://www.gmx.net/de/go/topmail
