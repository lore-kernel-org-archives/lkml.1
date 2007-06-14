Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXFNIZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXFNIZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXFNIZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:25:34 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:39672 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXFNIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:25:31 -0400
Date: Thu, 14 Jun 2007 10:25:28 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@linux-foundation.org>, Ville Syrjala <syrjala@sci.fi>,
       Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: mach64 breakage in 2.6.22 
Message-ID: <20070614082528.GA10284@aepfle.de>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, Andrew Morton wrote:

> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/

> +atyfb-reorganize-clock-init.patch

This change breaks the display on an ibook1 with 800x600 lcd.
It is commit b4e124c138558a0cff51398ddff9a8e44ed0b529 in 2.6.22-rc4.
The used config is arch/powerpc/configs/pmac32_defconfig

It seems that the recognized display width is only 640, the remain space
up to 800 is repeated with the content from colum 0. The chars around
colum 640 are mostly garbage.

.....
atyfb: using auxiliary register aperture
atyfb: 3D RAGE Mobility L (Mach64 LN, AGP 2x) [0x4c4e rev 0x64]
atyfb: 4M SDRAM (2:1) (32-bit), 14.31818 MHz XTAL, 230 MHz PLL, 70 Mhz MCLK, 27 MHz XCLK
aty: Backlight initialized (atybl0)
atyfb: monitor sense=0, mode 20
Console: switching to colour frame buffer device 100x37
atyfb: fb0: ATY Mach64 frame buffer device on PCI
.....



Using PowerMac machine description
Total memory = 160MB; using 512kB for hash table (at c9f80000)
Linux version 2.6.22-rc4-git5 (olaf@pomegranate) (gcc version 4.1.2 20070115 (prerelease) (SUSE Linux)) #10 Thu Jun 14 09:40:21 CEST 2007
Found initrd at 0xc4100000:0xc435e000
Found UniNorth memory controller & host bridge @ 0xf8000000 revision: 0x03
Mapped at 0xfdfc0000
Found a Keylargo mac-io controller, rev: 2, mapped at 0xfdf40000
PowerMac motherboard: iBook (first generation)
via-pmu: Server Mode is disabled
PMU driver v2 initialized for Core99, firmware: 0c
Entering add_active_range(0, 0, 40960) 0 entries of 256 used
Found UniNorth PCI host bridge at 0x00000000f0000000. Firmware bus number: 0->0
Found UniNorth PCI host bridge at 0x00000000f2000000. Firmware bus number: 0->0
Found UniNorth PCI host bridge at 0x00000000f4000000. Firmware bus number: 0->0
nvram: Checking bank 0...
nvram: gen0=549, gen1=548
nvram: Active bank is: 0
nvram: OF partition at 0x210
nvram: XP partition at 0xffffffff
nvram: NR partition at 0xffffffff
Top of RAM: 0xa000000, Total RAM: 0xa000000
Memory hole size: 0MB
Zone PFN ranges:
  DMA             0 ->    40960
  Normal      40960 ->    40960
early_node_map[1] active PFN ranges
    0:        0 ->    40960
On node 0 totalpages: 40960
  DMA zone: 320 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 40640 pages, LIFO batch:7
  Normal zone: 0 pages used for memmap
Built 1 zonelists.  Total pages: 40640
Kernel command line: root=/dev/disk/by-label/mango_root  quiet sysrq=1 panic=42  
mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
mpic: ISU size: 64, shift: 6, mask: 3f
mpic: Initializing for 64 sources
PID hash table entries: 1024 (order: 10, 4096 bytes)
GMT Delta read from XPRAM: 0 minutes, DST: on
time_init: decrementer frequency = 16.644884 MHz
time_init: processor frequency   = 299.999997 MHz
Console: colour dummy device 80x25
console handover: boot [udbg0] -> real [tty0]
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 154564k/163840k available (4168k kernel code, 9120k reserved, 168k data, 150k bss, 204k init)
Calibrating delay loop... 33.15 BogoMIPS (lpj=66304)
Mount-cache hash table entries: 512
device-tree: Duplicate name in /cpus/PowerPC,750@0, renamed to "l2-cache#1"
NET: Registered protocol family 16
KeyWest i2c @0xf8001003 irq 42 /uni-n@f8000000/i2c@f8001000
 channel 0 bus <multibus>
 channel 1 bus <multibus>
KeyWest i2c @0x80018000 irq 26 /pci@f2000000/mac-io@17/i2c@18000
 channel 0 bus <multibus>
PMU i2c /pci@f2000000/mac-io@17/via-pmu@16000
 channel 1 bus <multibus>
 channel 2 bus <multibus>
PCI: Probing PCI hardware
PCI: Cannot allocate resource region 0 of device 0001:10:19.0
Apple USB OHCI 0001:10:19.0 disabled by firmware
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
NET: Registered protocol family 2
IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2424k freed
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: Enabling device 0000:00:10.0 (0086 -> 0087)
atyfb: using auxiliary register aperture
atyfb: 3D RAGE Mobility L (Mach64 LN, AGP 2x) [0x4c4e rev 0x64]
atyfb: 4M SDRAM (2:1) (32-bit), 14.31818 MHz XTAL, 230 MHz PLL, 70 Mhz MCLK, 27 MHz XCLK
aty: Backlight initialized (atybl0)
atyfb: monitor sense=0, mode 20
Console: switching to colour frame buffer device 100x37
atyfb: fb0: ATY Mach64 frame buffer device on PCI
Generic RTC Driver v1.07
Macintosh non-volatile memory driver v1.1
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
PHY ID: 406212, addr: 0
eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0a:27:aa:0f:20 
eth0: Found BCM5201 PHY
pcnet32.c:v1.33 27.Jun.2006 tsbogend@alpha.franken.de
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
MacIO PCI driver attached to Keylargo chipset
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
adb: starting probe task...
adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
ADB keyboard at 2, handler 1
Detected ADB keyboard, type ISO, swapping keys.
input: ADB keyboard as /class/input/input1
input: ADB Powerbook buttons as /class/input/input2
ADB mouse at 3, handler set to 4 (trackpad)
input: ADB mouse as /class/input/input3
adb: finished probe task...
ide0: Found Apple KeyLargo ATA-4 controller, bus ID 2, irq 19
Probing IDE interface ide0...
hda: FUJITSU MHH2032AT, ATA DISK drive
hda: Enabling Ultra DMA 2
ide0 at 0xcb016000-0xcb016007,0xcb016160 on irq 19
eth0: Link is up at 100 Mbps, full-duplex.
ide1: Found Apple KeyLargo ATA-3 controller, bus ID 0, irq 20
Probing IDE interface ide1...
hdc: MATSHITA CR-175, ATAPI CD/DVD-ROM drive
hdc: Enabling MultiWord DMA 2
ide1 at 0xcb01c000-0xcb01c007,0xcb01c160 on irq 20
ide2: Found Apple KeyLargo ATA-3 controller, bus ID 1, irq 21
Probing IDE interface ide2...
hda: max request size: 128KiB
hda: 6357456 sectors (3255 MB) w/512KiB Cache, CHS=6307/16/63, UDMA(33)
hda: cache flushes not supported
 hda: [mac] hda1 hda2 hda3 hda4 hda5 hda6 hda7 hda8 hda9 hda10 hda11
hdc: ATAPI 24X CD-ROM drive, 128kB Cache, DMA
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
mesh: configured for synchronous 5 MB/s
st: Version 20070203, fixed bufsize 32768, s/g segs 256
usbmon: debugfs is not available
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device 0001:10:18.0 (0000 -> 0002)
ohci_hcd 0001:10:18.0: OHCI Host Controller
ohci_hcd 0001:10:18.0: new USB bus registered, assigned bus number 1
ohci_hcd 0001:10:18.0: irq 27, io mem 0x80080000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Apple USB OHCI 0001:10:19.0 disabled by firmware
mice: PS/2 mouse device common for all mice
PowerMac i2c bus pmu 2 registered
PowerMac i2c bus pmu 1 registered
PowerMac i2c bus mac-io 0 registered
PowerMac i2c bus uni-n 1 registered
PowerMac i2c bus uni-n 0 registered
usbcore: registered new interface driver usbhid
/home/olaf/kernel/olh/mach64/linux-2.6.22-rc4/drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
oprofile: using timer interrupt.
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
input: PMU as /class/input/input4
Registered led device: pmu-front-led
Freeing unused kernel memory: 204k init
EXT2 (no)acl options not supported
EXT2 (no)user_xattr options not supported
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected Apple UniNorth chipset
agpgart: configuring for size idx: 8
agpgart: AGP aperture is 32M @ 0x0
pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
pmac_zilog: i2c-modem detected, id: 1
ttyS0 at MMIO 0x80013020 (irq = 22) is a Z85c30 ESCC - Internal modem
ttyS1 at MMIO 0x80013000 (irq = 50) is a Z85c30 ESCC - Serial port
Adding 136544k swap on /dev/hda10.  Priority:-1 extents:1 across:136544k
EXT2 (no)acl options not supported
EXT2 (no)user_xattr options not supported
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
eth0: Link is up at 100 Mbps, full-duplex.
eth0: Pause is disabled
