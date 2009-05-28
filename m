Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbZE1Wkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbZE1Wkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZE1WkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:40:24 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:47014 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZE1WkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:40:21 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [regression, bisected] adb trackpad disappears after suspend to ram
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	<87prdt3bgb.fsf@scholz.fias.uni-frankfurt.de>
	<200905281858.37729.rjw@sisk.pl> <1243549422.17903.10.camel@pasglop>
Date: Fri, 29 May 2009 00:39:22 +0200
In-Reply-To: <1243549422.17903.10.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Fri, 29 May 2009 08:23:42 +1000")
Message-ID: <87tz34n97p.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

>> We are too late in the cycle to revert this commit and it really is needed to
>> fix a more serious issue.  Nevertheless knowing that it caused the problem to
>> appear on your system is also important.
>> 
>> Ben, do you have an idea what may be going on here?  Does __disable_irq() mask
>> the interrupt on this platform?
>
> I suppose so :-) I'll have to check what's going on, it's not
> immediately clear to me.
>
> Cheers,
> Ben.
>
>> 
>> I'd like to see a boot log, preferably containing a suspend-resume in which
>> the problem was reproduced.

Here is a log from booting, through several suspend cycles, until the
trackpad disappeared. The first few suspends were done while X was
running but from the console. As you can tell from lines like
   May 28 23:51:26 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
the trackpad was still present. The last suspend was done from within X,
here the trackpad did not make it.
   May 28 23:58:09 [kernel] adb devices: [2]: 2 c4 [7]: 7 1f
However, there have been cases, although not in this log, were the
trackpad has been alive even when suspending from within X.

Here's the log:

May 28 23:51:25 [kernel] nvram: XP partition at 0x1020
May 28 23:51:26 [kernel] nvram: NR partition at 0x1120
May 28 23:51:26 [kernel] Top of RAM: 0x50000000, Total RAM: 0x50000000
May 28 23:51:26 [kernel] Memory hole size: 0MB
May 28 23:51:26 [kernel] Zone PFN ranges:
May 28 23:51:26 [kernel]   DMA      0x00000000 -> 0x00030000
May 28 23:51:26 [kernel]   Normal   0x00030000 -> 0x00030000
May 28 23:51:26 [kernel]   HighMem  0x00030000 -> 0x00050000
May 28 23:51:26 [kernel] Movable zone start PFN for each node
May 28 23:51:26 [kernel] early_node_map[1] active PFN ranges
May 28 23:51:26 [kernel]     0: 0x00000000 -> 0x00050000
May 28 23:51:26 [kernel] On node 0 totalpages: 327680
May 28 23:51:26 [kernel] free_area_init_node: node 0, pgdat c03eb2e8, node_mem_map c0425000
May 28 23:51:26 [kernel]   DMA zone: 1536 pages used for memmap
May 28 23:51:26 [kernel]   DMA zone: 0 pages reserved
May 28 23:51:26 [kernel]   DMA zone: 195072 pages, LIFO batch:31
May 28 23:51:26 [kernel]   HighMem zone: 1024 pages used for memmap
May 28 23:51:26 [kernel]   HighMem zone: 130048 pages, LIFO batch:31
May 28 23:51:26 [kernel] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 325120
May 28 23:51:26 [kernel] Kernel command line: root=/dev/hda7 ro idebus=66 
May 28 23:51:26 [kernel] mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
May 28 23:51:26 [kernel] mpic: ISU size: 64, shift: 6, mask: 3f
May 28 23:51:26 [kernel] mpic: Initializing for 64 sources
May 28 23:51:26 [kernel] PID hash table entries: 4096 (order: 12, 16384 bytes)
May 28 23:51:26 [kernel] GMT Delta read from XPRAM: 0 minutes, DST: off
May 28 23:51:26 [kernel] time_init: decrementer frequency = 18.432000 MHz
May 28 23:51:26 [kernel] time_init: processor frequency   = 1199.999997 MHz
May 28 23:51:26 [kernel] clocksource: timebase mult[d9038e4] shift[22] registered
May 28 23:51:26 [kernel] clockevent: decrementer mult[4b7] shift[16] cpu[0]
May 28 23:51:26 [kernel] Console: colour dummy device 80x25
May 28 23:51:26 [kernel] console handover: boot [udbg0] -> real [tty0]
May 28 23:51:26 [kernel] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
May 28 23:51:26 [kernel] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
May 28 23:51:26 [kernel] High memory: 524288k
May 28 23:51:26 [kernel] Memory: 1289860k/1310720k available (3860k kernel code, 19728k reserved, 160k data, 135k bss, 188k init)
May 28 23:51:26 [kernel] Calibrating delay loop... 36.32 BogoMIPS (lpj=61312)
May 28 23:51:26 [kernel] Mount-cache hash table entries: 512
May 28 23:51:26 [kernel] device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
May 28 23:51:26 [kernel] net_namespace: 936 bytes
May 28 23:51:26 [kernel] NET: Registered protocol family 16
May 28 23:51:26 [kernel] KeyWest i2c @0xf8001003 irq 42 /uni-n@f8000000/i2c@f8001000
May 28 23:51:26 [kernel]  channel 0 bus <multibus>
May 28 23:51:26 [kernel]  channel 1 bus <multibus>
May 28 23:51:26 [kernel] KeyWest i2c @0x80018000 irq 26 /pci@f2000000/mac-io@17/i2c@18000
May 28 23:51:26 [kernel]  channel 0 bus <multibus>
May 28 23:51:26 [kernel] PMU i2c /pci@f2000000/mac-io@17/via-pmu@16000/pmu-i2c
May 28 23:51:26 [kernel]  channel 1 bus <multibus>
May 28 23:51:26 [kernel]  channel 2 bus <multibus>
May 28 23:51:26 [kernel] PCI: Probing PCI hardware
May 28 23:51:26 [kernel] pci 0000:00:10.0: reg 10 32bit mmio: [0x98000000-0x9fffffff]
May 28 23:51:26 [kernel] pci 0000:00:10.0: reg 14 io port: [0x400-0x4ff]
May 28 23:51:26 [kernel] pci 0000:00:10.0: reg 18 32bit mmio: [0x90000000-0x9000ffff]
May 28 23:51:26 [kernel] pci 0000:00:10.0: reg 30 32bit mmio: [0x90020000-0x9003ffff]
May 28 23:51:26 [kernel] pci 0000:00:10.0: supports D1 D2
May 28 23:51:26 [kernel] pci 0001:10:12.0: reg 10 32bit mmio: [0x80084000-0x80085fff]
May 28 23:51:26 [kernel] pci 0001:10:12.0: supports D1 D2
May 28 23:51:26 [kernel] pci 0001:10:12.0: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:51:26 [kernel] pci 0001:10:12.0: PME# disabled
May 28 23:51:26 [kernel] pci 0001:10:17.0: reg 10 32bit mmio: [0x80000000-0x8007ffff]
May 28 23:51:26 [kernel] pci 0001:10:18.0: reg 10 32bit mmio: [0x000000-0x000fff]
May 28 23:51:26 [kernel] pci 0001:10:19.0: reg 10 32bit mmio: [0x000000-0x000fff]
May 28 23:51:26 [kernel] pci 0001:10:1a.0: reg 10 32bit mmio: [0x80083000-0x80083fff]
May 28 23:51:26 [kernel] pci 0001:10:1b.0: reg 10 32bit mmio: [0x80082000-0x80082fff]
May 28 23:51:26 [kernel] pci 0001:10:1b.0: supports D1 D2
May 28 23:51:26 [kernel] pci 0001:10:1b.0: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:51:26 [kernel] pci 0001:10:1b.0: PME# disabled
May 28 23:51:26 [kernel] pci 0001:10:1b.1: reg 10 32bit mmio: [0x80081000-0x80081fff]
May 28 23:51:26 [kernel] pci 0001:10:1b.1: supports D1 D2
May 28 23:51:26 [kernel] pci 0001:10:1b.1: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:51:26 [kernel] pci 0001:10:1b.1: PME# disabled
May 28 23:51:26 [kernel] pci 0001:10:1b.2: reg 10 32bit mmio: [0x80080000-0x800800ff]
May 28 23:51:26 [kernel] pci 0001:10:1b.2: supports D1 D2
May 28 23:51:26 [kernel] pci 0001:10:1b.2: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:51:26 [kernel] pci 0001:10:1b.2: PME# disabled
May 28 23:51:26 [kernel] pci 0002:20:0d.0: reg 10 32bit mmio: [0xf5004000-0xf5007fff]
May 28 23:51:26 [kernel] pci 0002:20:0e.0: reg 10 32bit mmio: [0xf5000000-0xf5000fff]
May 28 23:51:26 [kernel] pci 0002:20:0e.0: supports D1 D2
May 28 23:51:26 [kernel] pci 0002:20:0e.0: PME# supported from D0 D1 D2 D3hot
May 28 23:51:26 [kernel] pci 0002:20:0e.0: PME# disabled
May 28 23:51:26 [kernel] pci 0002:20:0f.0: reg 10 32bit mmio: [0xf5200000-0xf53fffff]
May 28 23:51:26 [kernel] pci 0002:20:0f.0: reg 30 32bit mmio: [0xf5100000-0xf51fffff]
May 28 23:51:26 [kernel] PCI 0000:00 Cannot reserve Legacy IO [0x802000-0x802fff]
May 28 23:51:26 [kernel] pci_bus 0001:10: resource 0 io:  [0x00-0x7fffff]
May 28 23:51:26 [kernel] pci_bus 0001:10: resource 1 mem: [0xf3000000-0xf3ffffff]
May 28 23:51:26 [kernel] pci_bus 0001:10: resource 2 mem: [0x80000000-0x8fffffff]
May 28 23:51:26 [kernel] pci_bus 0002:20: resource 0 io:  [0xff7fe000-0xffffdfff]
May 28 23:51:26 [kernel] pci_bus 0002:20: resource 1 mem: [0xf5000000-0xf5ffffff]
May 28 23:51:26 [kernel] bio: create slab <bio-0> at 0
May 28 23:51:26 [kernel] NET: Registered protocol family 2
May 28 23:51:26 [kernel] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
May 28 23:51:26 [kernel] Switched to NOHz mode on CPU #0
May 28 23:51:26 [kernel] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
May 28 23:51:26 [kernel] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
May 28 23:51:26 [kernel] TCP: Hash tables configured (established 131072 bind 65536)
May 28 23:51:26 [kernel] TCP reno registered
May 28 23:51:26 [kernel] NET: Registered protocol family 1
May 28 23:51:26 [kernel] Thermal assist unit not available
May 28 23:51:26 [kernel] setup_kcore: restrict size=3fffffff
May 28 23:51:26 [kernel] Registering PowerMac CPU frequency driver
May 28 23:51:26 [kernel] Low: 599 Mhz, High: 1199 Mhz, Boot: 599 Mhz
May 28 23:51:26 [kernel] highmem bounce pool size: 64 pages
May 28 23:51:26 [kernel] msgmni has been set to 1497
May 28 23:51:26 [kernel] alg: No test for stdrng (krng)
May 28 23:51:26 [kernel] io scheduler noop registered
May 28 23:51:26 [kernel] io scheduler anticipatory registered (default)
May 28 23:51:26 [kernel] io scheduler deadline registered
May 28 23:51:26 [kernel] io scheduler cfq registered
May 28 23:51:26 [kernel] radeonfb 0000:00:10.0: enabling device (0006 -> 0007)
May 28 23:51:26 [kernel] radeonfb 0000:00:10.0: Invalid ROM contents
May 28 23:51:26 [kernel] radeonfb (0000:00:10.0): Invalid ROM signature 0 should be 0xaa55
May 28 23:51:26 [kernel] radeonfb: Retrieved PLL infos from Open Firmware
May 28 23:51:26 [kernel] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=190.00 Mhz, System=183.00 MHz
May 28 23:51:26 [kernel] radeonfb: PLL min 12000 max 35000
May 28 23:51:26 [kernel] i2c-adapter i2c-2: unable to read EDID block.
                - Last output repeated 2 times -
May 28 23:51:26 [kernel] i2c-adapter i2c-3: unable to read EDID block.
                - Last output repeated 2 times -
May 28 23:51:26 [kernel] radeonfb: Monitor 1 type LCD found
May 28 23:51:26 [kernel] radeonfb: EDID probed
May 28 23:51:26 [kernel] radeonfb: Monitor 2 type no found
May 28 23:51:26 [kernel] radeonfb: Using Firmware dividers 0x000600ad from PPLL 0
May 28 23:51:26 [kernel] radeonfb: Dynamic Clock Power Management enabled
May 28 23:51:26 [kernel] Console: switching to colour frame buffer device 128x48
May 28 23:51:26 [kernel] radeonfb: Backlight initialized (radeonbl0)
May 28 23:51:26 [kernel] radeonfb (0000:00:10.0): ATI Radeon 5c63 "\c"
May 28 23:51:26 [kernel] Generic non-volatile memory driver v1.1
May 28 23:51:26 [kernel] Linux agpgart interface v0.103
May 28 23:51:26 [kernel] agpgart-uninorth 0000:00:0b.0: Apple UniNorth 2 chipset
May 28 23:51:26 [kernel] agpgart-uninorth 0000:00:0b.0: configuring for size idx: 8
May 28 23:51:26 [kernel] agpgart-uninorth 0000:00:0b.0: AGP aperture is 32M @ 0x0
May 28 23:51:26 [kernel] [drm] Initialized drm 1.1.0 20060810
May 28 23:51:26 [kernel] [drm] Initialized radeon 1.29.0 20080528 on minor 0
May 28 23:51:26 [kernel] loop: module loaded
May 28 23:51:26 [kernel] sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
May 28 23:51:26 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:51:26 [kernel] eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0d:93:4b:d6:8c
May 28 23:51:26 [kernel] eth0: Found BCM5221 PHY
May 28 23:51:26 [kernel] MacIO PCI driver attached to Intrepid chipset
May 28 23:51:26 [kernel] input: Macintosh mouse button emulation as /devices/virtual/input/input0
May 28 23:51:26 [kernel] Uniform Multi-Platform E-IDE driver
May 28 23:51:26 [kernel] adb: starting probe task...
May 28 23:51:26 [kernel] ide-pmac 0002:20:0d.0: enabling device (0000 -> 0002)
May 28 23:51:26 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
May 28 23:51:26 [kernel] ADB keyboard at 2, handler 1
May 28 23:51:26 [kernel] Detected ADB keyboard, type ISO, swapping keys.
May 28 23:51:26 [kernel] input: ADB keyboard as /devices/virtual/input/input1
May 28 23:51:26 [kernel] input: ADB Powerbook buttons as /devices/virtual/input/input2
May 28 23:51:26 [kernel] ADB mouse at 3, handler set to 4 (trackpad)
May 28 23:51:26 [kernel] input: ADB mouse as /devices/virtual/input/input3
May 28 23:51:26 [kernel] adb: finished probe task...
May 28 23:51:26 [kernel] ide-pmac: Found Apple UniNorth ATA-6 controller (PCI), bus ID 3, irq 39
May 28 23:51:26 [kernel] Probing IDE interface ide0...
May 28 23:51:26 [kernel] hda: FUJITSU MHT2030AT, ATA DISK drive
May 28 23:51:26 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:51:26 [kernel] hda: UDMA/100 mode selected
May 28 23:51:26 [kernel] ide0 at 0xf103a000-0xf103a070,0xf103a160 on irq 39
May 28 23:51:26 [kernel] ide-pmac: Found Apple KeyLargo ATA-3 controller (macio), bus ID 0, irq 24
May 28 23:51:26 [kernel] Probing IDE interface ide1...
May 28 23:51:26 [kernel] hdc: MATSHITACD-RW CW-8123, ATAPI CD/DVD-ROM drive
May 28 23:51:26 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:51:26 [kernel] hdc: MWDMA2 mode selected
May 28 23:51:26 [kernel] ide1 at 0xf101a000-0xf101a070,0xf101a160 on irq 24
May 28 23:51:26 [kernel] ide-gd driver 1.18
May 28 23:51:26 [kernel] hda: max request size: 512KiB
May 28 23:51:26 [kernel] hda: 58605120 sectors (30005 MB) w/2048KiB Cache, CHS=16383/255/63
May 28 23:51:26 [kernel] ide-cd driver 5.00
May 28 23:51:26 [kernel] ide-cd: hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
May 28 23:51:26 [kernel] Uniform CD-ROM driver Revision: 3.20
May 28 23:51:26 [kernel] mice: PS/2 mouse device common for all mice
May 28 23:51:26 [kernel] i2c /dev entries driver
May 28 23:51:26 [kernel] TCP cubic registered
May 28 23:51:26 [kernel] NET: Registered protocol family 17
May 28 23:51:26 [kernel] input: PMU as /devices/virtual/input/input4
May 28 23:51:26 [kernel] Registered led device: pmu-front-led
May 28 23:51:26 [kernel] ReiserFS: hda7: found reiserfs format "3.6" with standard journal
May 28 23:51:26 [kernel] ReiserFS: hda7: using ordered data mode
May 28 23:51:26 [kernel] ReiserFS: hda7: journal params: device hda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
May 28 23:51:26 [kernel] ReiserFS: hda7: checking transaction log (hda7)
May 28 23:51:26 [kernel] ReiserFS: hda7: Using r5 hash to sort names
May 28 23:51:26 [kernel] VFS: Mounted root (reiserfs filesystem) readonly on device 3:7.
May 28 23:51:26 [kernel] Freeing unused kernel memory: 188k init
May 28 23:51:26 [kernel] b43-pci-bridge 0001:10:12.0: enabling device (0004 -> 0006)
May 28 23:51:26 [kernel] ssb: Sonics Silicon Backplane found on PCI device 0001:10:12.0
May 28 23:51:26 [kernel] usbcore: registered new interface driver usbfs
May 28 23:51:26 [kernel] usbcore: registered new interface driver hub
May 28 23:51:26 [kernel] usbcore: registered new device driver usb
May 28 23:51:26 [kernel] PowerMac i2c bus pmu 2 registered
May 28 23:51:26 [kernel] PowerMac i2c bus pmu 1 registered
May 28 23:51:26 [kernel] PowerMac i2c bus mac-io 0 registered
May 28 23:51:26 [kernel] PowerMac i2c bus uni-n 1 registered
May 28 23:51:26 [kernel] PowerMac i2c bus uni-n 0 registered
May 28 23:51:26 [kernel] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
May 28 23:51:26 [kernel] Apple USB OHCI 0001:10:18.0 disabled by firmware
May 28 23:51:26 [kernel] Apple USB OHCI 0001:10:19.0 disabled by firmware
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1a.0: enabling device (0000 -> 0002)
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1a.0: OHCI Host Controller
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1a.0: new USB bus registered, assigned bus number 1
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1a.0: irq 29, io mem 0x80083000
May 28 23:51:26 [kernel] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
May 28 23:51:26 [kernel] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
May 28 23:51:26 [kernel] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
May 28 23:51:26 [kernel] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:51:26 [kernel] usb usb1: Product: OHCI Host Controller
May 28 23:51:26 [kernel] usb usb1: Manufacturer: Linux 2.6.29.4-00028-g6575141 ohci_hcd
May 28 23:51:26 [kernel] usb usb1: SerialNumber: 0001:10:1a.0
May 28 23:51:26 [kernel] usb usb1: configuration #1 chosen from 1 choice
May 28 23:51:26 [kernel] hub 1-0:1.0: USB hub found
May 28 23:51:26 [kernel] hub 1-0:1.0: 2 ports detected
May 28 23:51:26 [kernel] ehci_hcd 0001:10:1b.2: enabling device (0004 -> 0006)
May 28 23:51:26 [kernel] ehci_hcd 0001:10:1b.2: EHCI Host Controller
May 28 23:51:26 [kernel] ehci_hcd 0001:10:1b.2: new USB bus registered, assigned bus number 2
May 28 23:51:26 [kernel] ehci_hcd 0001:10:1b.2: irq 63, io mem 0x80080000
May 28 23:51:26 [kernel] ehci_hcd 0001:10:1b.2: USB 2.0 started, EHCI 1.00
May 28 23:51:26 [kernel] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
May 28 23:51:26 [kernel] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:51:26 [kernel] usb usb2: Product: EHCI Host Controller
May 28 23:51:26 [kernel] usb usb2: Manufacturer: Linux 2.6.29.4-00028-g6575141 ehci_hcd
May 28 23:51:26 [kernel] usb usb2: SerialNumber: 0001:10:1b.2
May 28 23:51:26 [kernel] usb usb2: configuration #1 chosen from 1 choice
May 28 23:51:26 [kernel] hub 2-0:1.0: USB hub found
May 28 23:51:26 [kernel] hub 2-0:1.0: 5 ports detected
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.0: enabling device (0000 -> 0002)
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.0: OHCI Host Controller
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.0: new USB bus registered, assigned bus number 3
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.0: irq 63, io mem 0x80082000
May 28 23:51:26 [kernel] ohci1394 0002:20:0e.0: enabling device (0000 -> 0002)
May 28 23:51:26 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:51:26 [kernel] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 28 23:51:26 [kernel] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:51:26 [kernel] usb usb3: Product: OHCI Host Controller
May 28 23:51:26 [kernel] usb usb3: Manufacturer: Linux 2.6.29.4-00028-g6575141 ohci_hcd
May 28 23:51:26 [kernel] usb usb3: SerialNumber: 0001:10:1b.0
May 28 23:51:26 [kernel] usb usb3: configuration #1 chosen from 1 choice
May 28 23:51:26 [kernel] hub 3-0:1.0: USB hub found
May 28 23:51:26 [kernel] hub 3-0:1.0: 3 ports detected
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.1: enabling device (0000 -> 0002)
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.1: OHCI Host Controller
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.1: new USB bus registered, assigned bus number 4
May 28 23:51:26 [kernel] ohci_hcd 0001:10:1b.1: irq 63, io mem 0x80081000
May 28 23:51:26 [kernel] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 28 23:51:26 [kernel] usb usb4: Product: OHCI Host Controller
May 28 23:51:26 [kernel] usb usb4: SerialNumber: 0001:10:1b.1
May 28 23:51:26 [kernel] usb usb4: configuration #1 chosen from 1 choice
May 28 23:51:26 [kernel] hub 4-0:1.0: USB hub found
May 28 23:51:26 [kernel] hub 4-0:1.0: 2 ports detected
May 28 23:51:26 [kernel] usb 1-1: new full speed USB device using ohci_hcd and address 2
May 28 23:51:26 [kernel] usb 1-1: New USB device found, idVendor=05ac, idProduct=1000
May 28 23:51:26 [kernel] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
May 28 23:51:26 [kernel] usb 1-1: configuration #1 chosen from 1 choice
May 28 23:51:26 [kernel] usb 2-2: new high speed USB device using ehci_hcd and address 2
May 28 23:51:26 [kernel] usb 2-2: New USB device found, idVendor=04b4, idProduct=6830
May 28 23:51:26 [kernel] usb 2-2: New USB device strings: Mfr=56, Product=58, SerialNumber=60
May 28 23:51:26 [kernel] usb 2-2: Product:  
May 28 23:51:26 [kernel] usb 2-2: Manufacturer:  
May 28 23:51:26 [kernel] usb 2-2: SerialNumber: D
May 28 23:51:26 [kernel] usb 2-2: configuration #1 chosen from 1 choice
May 28 23:51:26 [kernel] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000d93fffe4bd68c]
May 28 23:51:26 [kernel] cfg80211: Using static regulatory domain info
May 28 23:51:26 [kernel] cfg80211: Regulatory domain: US
May 28 23:51:26 [kernel] _(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 28 23:51:26 [kernel] _(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
May 28 23:51:26 [kernel] _(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:51:26 [kernel] _(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:51:26 [kernel] _(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:51:26 [kernel] _(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:51:26 [kernel] _(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
May 28 23:51:26 [kernel] cfg80211: Calling CRDA for country: US
May 28 23:51:26 [kernel] b43-phy0: Broadcom 4306 WLAN found
May 28 23:51:26 [kernel] wmaster0 (b43): not using net_device_ops yet
May 28 23:51:26 [kernel] phy0: Selected rate control algorithm 'minstrel'
May 28 23:51:26 [kernel] wlan0 (b43): not using net_device_ops yet
May 28 23:51:26 [kernel] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
May 28 23:51:26 [kernel] udev: renamed network interface wmaster0 to eth1
May 28 23:51:26 [kernel] input: HID 05ac:1000 as /devices/pci0001:10/0001:10:1a.0/usb1/1-1/1-1:1.0/input/input5
May 28 23:51:26 [kernel] generic-usb 0003:05AC:1000.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0001:10:1a.0-1/input0
May 28 23:51:26 [kernel] input: HID 05ac:1000 as /devices/pci0001:10/0001:10:1a.0/usb1/1-1/1-1:1.1/input/input6
May 28 23:51:26 [kernel] generic-usb 0003:05AC:1000.0002: input,hidraw1: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0001:10:1a.0-1/input1
May 28 23:51:26 [kernel] usbcore: registered new interface driver usbhid
May 28 23:51:26 [kernel] usbhid: v2.6:USB HID core driver
May 28 23:51:26 [kernel] SCSI subsystem initialized
May 28 23:51:26 [kernel] Initializing USB Mass Storage driver...
May 28 23:51:26 [kernel] scsi0 : SCSI emulation for USB Mass Storage devices
May 28 23:51:26 [kernel] usbcore: registered new interface driver usb-storage
May 28 23:51:26 [kernel] USB Mass Storage support registered.
May 28 23:51:26 [kernel] usb-storage: device found at 2
May 28 23:51:26 [kernel] usb-storage: waiting for device to settle before scanning
May 28 23:51:26 [kernel] adt746x: version 1 (supported)
May 28 23:51:26 [kernel] adt746x: Thermostat bus: 1, address: 0x2e, limit_adjust: 0, fan_speed: -1
May 28 23:51:26 [kernel] sensor 0: PWR/MEMORY BOTTOMSIDE
May 28 23:51:26 [kernel] sensor 1: CPU BOTTOMSIDE
May 28 23:51:26 [kernel] sensor 2: GPU BOTTOMSIDE
May 28 23:51:26 [kernel] adt746x: ADT7467 initializing
May 28 23:51:26 [kernel] adt746x: Lowering max temperatures from 69, 92, 101 to 70, 50, 70
May 28 23:51:26 [kernel] platform ppc-rtc.0: rtc core: registered ppc_md as rtc0
May 28 23:51:26 [kernel] input: PowerMac Beep as /devices/pci0001:10/0001:10:17.0/input/input7
May 28 23:51:26 [kernel] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
May 28 23:51:26 [kernel] scsi 0:0:0:0: Direct-Access     WDC WD16 00BEVE-11UYT0    0000 PQ: 0 ANSI: 0
May 28 23:51:26 [kernel] usb-storage: device scan complete
May 28 23:51:26 [kernel] Driver 'sd' needs updating - please use bus_type methods
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Write Protect is off
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Mode Sense: 27 00 00 00
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Assuming drive cache: write through
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Write Protect is off
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Mode Sense: 27 00 00 00
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Assuming drive cache: write through
May 28 23:51:26 [kernel]  sda: sda1
May 28 23:51:26 [kernel] sd 0:0:0:0: [sda] Attached SCSI disk
May 28 23:51:26 [kernel] sd 0:0:0:0: Attached scsi generic sg0 type 0
May 28 23:51:26 [kernel] Adding 1048568k swap on /dev/hda6.  Priority:-1 extents:1 across:1048568k 
May 28 23:51:29 [kernel] ip_tables: (C) 2000-2006 Netfilter Core Team
May 28 23:51:31 [kernel] NET: Registered protocol family 10
May 28 23:51:31 [kernel] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 28 23:51:31 [kernel] ip6_tables: (C) 2000-2006 Netfilter Core Team
May 28 23:51:33 [kernel] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
May 28 23:51:34 [kernel] Bluetooth: Core ver 2.14
May 28 23:51:34 [kernel] NET: Registered protocol family 31
May 28 23:51:34 [kernel] Bluetooth: HCI device and connection manager initialized
May 28 23:51:34 [kernel] Bluetooth: HCI socket layer initialized
May 28 23:51:35 [kernel] usb 1-1: USB disconnect, address 2
May 28 23:51:35 [kernel] usb 1-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -108
May 28 23:51:35 [kernel] usb 1-1: new full speed USB device using ohci_hcd and address 3
May 28 23:51:36 [kernel] usb 1-1: New USB device found, idVendor=05ac, idProduct=8203
May 28 23:51:36 [kernel] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
May 28 23:51:36 [kernel] usb 1-1: configuration #1 chosen from 1 choice
May 28 23:51:36 [kernel] Bluetooth: Generic Bluetooth USB driver ver 0.4
May 28 23:51:36 [kernel] usbcore: registered new interface driver btusb
May 28 23:51:37 [kernel] Bluetooth: L2CAP ver 2.11
May 28 23:51:37 [kernel] Bluetooth: L2CAP socket layer initialized
May 28 23:51:37 [kernel] Bluetooth: RFCOMM socket layer initialized
May 28 23:51:37 [kernel] Bluetooth: RFCOMM TTY layer initialized
May 28 23:51:37 [kernel] Bluetooth: RFCOMM ver 1.10
May 28 23:51:40 [kernel] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
May 28 23:51:40 [kernel] Bluetooth: BNEP filters: protocol multicast
May 28 23:51:58 [kernel] b43 ssb0:0: firmware: requesting b43/ucode5.fw
May 28 23:51:58 [kernel] b43 ssb0:0: firmware: requesting b43/pcm5.fw
May 28 23:51:59 [kernel] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
May 28 23:51:59 [kernel] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
May 28 23:51:59 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:51:59 [kernel] Registered led device: b43-phy0::tx
May 28 23:51:59 [kernel] Registered led device: b43-phy0::rx
May 28 23:51:59 [kernel] b43-phy0: Radio turned on by software
May 28 23:51:59 [kernel] ADDRCONF(NETDEV_UP): wlan0: link is not ready
May 28 23:52:11 [kernel] radeonfb 0000:00:10.0: Invalid ROM contents
                - Last output repeated twice -
May 28 23:52:11 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:52:11 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:52:12 [kernel] [drm] Setting GART location based on new memory map
May 28 23:52:12 [kernel] [drm] Loading R200 Microcode
May 28 23:52:12 [kernel] [drm] writeback test succeeded in 1 usecs
May 28 23:52:59 [kernel] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 28 23:54:47 [kernel] GMT Delta read from XPRAM: 0 minutes, DST: off
May 28 23:54:47 [kernel] time_init: decrementer frequency = 18.432000 MHz
May 28 23:54:47 [kernel] time_init: processor frequency   = 1199.999997 MHz
May 28 23:54:47 [kernel] clocksource: timebase mult[d9038e4] shift[22] registered
May 28 23:54:47 [kernel] clockevent: decrementer mult[4b7] shift[16] cpu[0]
May 28 23:54:47 [kernel] Console: colour dummy device 80x25
May 28 23:54:47 [kernel] console handover: boot [udbg0] -> real [tty0]
May 28 23:54:47 [kernel] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
May 28 23:54:47 [kernel] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
May 28 23:54:47 [kernel] High memory: 524288k
May 28 23:54:47 [kernel] Memory: 1289604k/1310720k available (4092k kernel code, 19972k reserved, 180k data, 130k bss, 176k init)
May 28 23:54:47 [kernel] Calibrating delay loop... 36.32 BogoMIPS (lpj=61312)
May 28 23:54:47 [kernel] Mount-cache hash table entries: 512
May 28 23:54:47 [kernel] device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
May 28 23:54:47 [kernel] net_namespace: 936 bytes
May 28 23:54:47 [kernel] NET: Registered protocol family 16
May 28 23:54:47 [kernel] irq: irq 42 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 42
May 28 23:54:47 [kernel] KeyWest i2c @0xf8001003 irq 42 /uni-n@f8000000/i2c@f8001000
May 28 23:54:47 [kernel]  channel 0 bus <multibus>
May 28 23:54:47 [kernel]  channel 1 bus <multibus>
May 28 23:54:47 [kernel] irq: irq 26 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 26
May 28 23:54:47 [kernel] KeyWest i2c @0x80018000 irq 26 /pci@f2000000/mac-io@17/i2c@18000
May 28 23:54:47 [kernel]  channel 0 bus <multibus>
May 28 23:54:47 [kernel] PMU i2c /pci@f2000000/mac-io@17/via-pmu@16000/pmu-i2c
May 28 23:54:47 [kernel]  channel 1 bus <multibus>
May 28 23:54:47 [kernel]  channel 2 bus <multibus>
May 28 23:54:47 [kernel] irq: irq 25 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 25
May 28 23:54:47 [kernel] irq: irq 47 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 47
May 28 23:54:47 [kernel] PCI: Probing PCI hardware
May 28 23:54:47 [kernel] pci 0000:00:10.0: reg 10 32bit mmio: [0x98000000-0x9fffffff]
May 28 23:54:47 [kernel] pci 0000:00:10.0: reg 14 io port: [0x400-0x4ff]
May 28 23:54:47 [kernel] pci 0000:00:10.0: reg 18 32bit mmio: [0x90000000-0x9000ffff]
May 28 23:54:47 [kernel] pci 0000:00:10.0: reg 30 32bit mmio: [0x90020000-0x9003ffff]
May 28 23:54:47 [kernel] pci 0000:00:10.0: supports D1 D2
May 28 23:54:47 [kernel] irq: irq 48 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 48
May 28 23:54:47 [kernel] pci 0001:10:12.0: reg 10 32bit mmio: [0x80084000-0x80085fff]
May 28 23:54:47 [kernel] pci 0001:10:12.0: supports D1 D2
May 28 23:54:47 [kernel] pci 0001:10:12.0: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:54:47 [kernel] pci 0001:10:12.0: PME# disabled
May 28 23:54:47 [kernel] pci 0001:10:17.0: reg 10 32bit mmio: [0x80000000-0x8007ffff]
May 28 23:54:47 [kernel] pci 0001:10:18.0: reg 10 32bit mmio: [0x000000-0x000fff]
May 28 23:54:47 [kernel] pci 0001:10:19.0: reg 10 32bit mmio: [0x000000-0x000fff]
May 28 23:54:47 [kernel] pci 0001:10:1a.0: reg 10 32bit mmio: [0x80083000-0x80083fff]
May 28 23:54:47 [kernel] pci 0001:10:1b.0: reg 10 32bit mmio: [0x80082000-0x80082fff]
May 28 23:54:47 [kernel] pci 0001:10:1b.0: supports D1 D2
May 28 23:54:47 [kernel] pci 0001:10:1b.0: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:54:47 [kernel] pci 0001:10:1b.0: PME# disabled
May 28 23:54:47 [kernel] pci 0001:10:1b.1: reg 10 32bit mmio: [0x80081000-0x80081fff]
May 28 23:54:47 [kernel] pci 0001:10:1b.1: supports D1 D2
May 28 23:54:47 [kernel] pci 0001:10:1b.1: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:54:47 [kernel] pci 0001:10:1b.1: PME# disabled
May 28 23:54:47 [kernel] pci 0001:10:1b.2: reg 10 32bit mmio: [0x80080000-0x800800ff]
May 28 23:54:47 [kernel] pci 0001:10:1b.2: supports D1 D2
May 28 23:54:47 [kernel] pci 0001:10:1b.2: PME# supported from D0 D1 D2 D3hot D3cold
May 28 23:54:47 [kernel] pci 0001:10:1b.2: PME# disabled
May 28 23:54:47 [kernel] irq: irq 52 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 52
May 28 23:54:47 [kernel] irq: irq 27 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 27
May 28 23:54:47 [kernel] irq: irq 28 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 28
May 28 23:54:47 [kernel] irq: irq 29 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 29
May 28 23:54:47 [kernel] irq: irq 63 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 63
May 28 23:54:47 [kernel] pci 0002:20:0d.0: reg 10 32bit mmio: [0xf5004000-0xf5007fff]
May 28 23:54:47 [kernel] pci 0002:20:0e.0: reg 10 32bit mmio: [0xf5000000-0xf5000fff]
May 28 23:54:47 [kernel] pci 0002:20:0e.0: supports D1 D2
May 28 23:54:47 [kernel] pci 0002:20:0e.0: PME# supported from D0 D1 D2 D3hot
May 28 23:54:47 [kernel] pci 0002:20:0e.0: PME# disabled
May 28 23:54:47 [kernel] pci 0002:20:0f.0: reg 10 32bit mmio: [0xf5200000-0xf53fffff]
May 28 23:54:47 [kernel] pci 0002:20:0f.0: reg 30 32bit mmio: [0xf5100000-0xf51fffff]
May 28 23:54:47 [kernel] irq: irq 39 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 39
May 28 23:54:47 [kernel] PCI 0000:00 Cannot reserve Legacy IO [0x802000-0x802fff]
May 28 23:54:47 [kernel] pci_bus 0000:00: resource 0 io:  [0x802000-0x1001fff]
May 28 23:54:47 [kernel] pci_bus 0000:00: resource 1 mem: [0xf1000000-0xf1ffffff]
May 28 23:54:47 [kernel] pci_bus 0000:00: resource 2 mem: [0x90000000-0x9fffffff]
May 28 23:54:47 [kernel] pci_bus 0001:10: resource 0 io:  [0x00-0x7fffff]
May 28 23:54:47 [kernel] pci_bus 0001:10: resource 1 mem: [0xf3000000-0xf3ffffff]
May 28 23:54:47 [kernel] pci_bus 0001:10: resource 2 mem: [0x80000000-0x8fffffff]
May 28 23:54:47 [kernel] pci_bus 0002:20: resource 0 io:  [0xff7fe000-0xffffdfff]
May 28 23:54:47 [kernel] pci_bus 0002:20: resource 1 mem: [0xf5000000-0xf5ffffff]
May 28 23:54:47 [kernel] bio: create slab <bio-0> at 0
May 28 23:54:47 [kernel] Switched to NOHz mode on CPU #0
May 28 23:54:47 [kernel] NET: Registered protocol family 2
May 28 23:54:47 [kernel] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
May 28 23:54:47 [kernel] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
May 28 23:54:47 [kernel] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
May 28 23:54:47 [kernel] TCP: Hash tables configured (established 131072 bind 65536)
May 28 23:54:47 [kernel] TCP reno registered
May 28 23:54:47 [kernel] NET: Registered protocol family 1
May 28 23:54:47 [kernel] Thermal assist unit not available
May 28 23:54:47 [kernel] setup_kcore: restrict size=3fffffff
May 28 23:54:47 [kernel] Registering PowerMac CPU frequency driver
May 28 23:54:47 [kernel] Low: 599 Mhz, High: 1199 Mhz, Boot: 599 Mhz
May 28 23:54:47 [kernel] highmem bounce pool size: 64 pages
May 28 23:54:47 [kernel] msgmni has been set to 1496
May 28 23:54:47 [kernel] alg: No test for stdrng (krng)
May 28 23:54:47 [kernel] io scheduler noop registered
May 28 23:54:47 [kernel] io scheduler anticipatory registered (default)
May 28 23:54:47 [kernel] io scheduler deadline registered
May 28 23:54:47 [kernel] io scheduler cfq registered
May 28 23:54:47 [kernel] radeonfb 0000:00:10.0: enabling device (0006 -> 0007)
May 28 23:54:47 [kernel] radeonfb 0000:00:10.0: Invalid ROM contents
May 28 23:54:47 [kernel] radeonfb (0000:00:10.0): Invalid ROM signature 0 should be 0xaa55
May 28 23:54:47 [kernel] radeonfb: Retrieved PLL infos from Open Firmware
May 28 23:54:47 [kernel] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=190.00 Mhz, System=183.00 MHz
May 28 23:54:47 [kernel] radeonfb: PLL min 12000 max 35000
May 28 23:54:47 [kernel] i2c-adapter i2c-2: unable to read EDID block.
                - Last output repeated 2 times -
May 28 23:54:47 [kernel] i2c-adapter i2c-3: unable to read EDID block.
                - Last output repeated 2 times -
May 28 23:54:48 [kernel] radeonfb: Monitor 1 type LCD found
May 28 23:54:48 [kernel] radeonfb: EDID probed
May 28 23:54:48 [kernel] radeonfb: Monitor 2 type no found
May 28 23:54:48 [kernel] radeonfb: Using Firmware dividers 0x000600ad from PPLL 0
May 28 23:54:48 [kernel] radeonfb: Dynamic Clock Power Management enabled
May 28 23:54:48 [kernel] Console: switching to colour frame buffer device 128x48
May 28 23:54:48 [kernel] radeonfb: Backlight initialized (radeonbl0)
May 28 23:54:48 [kernel] radeonfb (0000:00:10.0): ATI Radeon 5c63 "\c"
May 28 23:54:48 [kernel] Generic non-volatile memory driver v1.1
May 28 23:54:48 [kernel] Linux agpgart interface v0.103
May 28 23:54:48 [kernel] agpgart-uninorth 0000:00:0b.0: Apple UniNorth 2 chipset
May 28 23:54:48 [kernel] agpgart-uninorth 0000:00:0b.0: configuring for size idx: 8
May 28 23:54:48 [kernel] agpgart-uninorth 0000:00:0b.0: AGP aperture is 32M @ 0x0
May 28 23:54:48 [kernel] [drm] Initialized drm 1.1.0 20060810
May 28 23:54:48 [kernel] [drm] Initialized radeon 1.30.0 20080528 for 0000:00:10.0 on minor 0
May 28 23:54:48 [kernel] loop: module loaded
May 28 23:54:48 [kernel] MacIO PCI driver attached to Intrepid chipset
May 28 23:54:48 [kernel] irq: irq 32 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 32
May 28 23:54:48 [kernel] irq: irq 24 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 24
May 28 23:54:48 [kernel] irq: irq 12 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 16
May 28 23:54:48 [kernel] irq: irq 22 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 22
May 28 23:54:48 [kernel] irq: irq 5 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 17
May 28 23:54:48 [kernel] irq: irq 6 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 18
May 28 23:54:48 [kernel] irq: irq 23 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 23
May 28 23:54:48 [kernel] irq: irq 7 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 19
May 28 23:54:48 [kernel] irq: irq 8 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 20
May 28 23:54:48 [kernel] input: Macintosh mouse button emulation as /devices/virtual/input/input0
May 28 23:54:48 [kernel] Uniform Multi-Platform E-IDE driver
May 28 23:54:48 [kernel] adb: starting probe task...
May 28 23:54:48 [kernel] ide-pmac 0002:20:0d.0: enabling device (0000 -> 0002)
May 28 23:54:48 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
May 28 23:54:48 [kernel] ADB keyboard at 2, handler 1
May 28 23:54:48 [kernel] Detected ADB keyboard, type ISO, swapping keys.
May 28 23:54:48 [kernel] input: ADB Powerbook buttons as /devices/virtual/input/input2
May 28 23:54:48 [kernel] ADB mouse at 3, handler set to 4 (trackpad)
May 28 23:54:48 [kernel] input: ADB mouse as /devices/virtual/input/input3
May 28 23:54:48 [kernel] adb: finished probe task...
May 28 23:54:48 [kernel] ide-pmac: Found Apple UniNorth ATA-6 controller (PCI), bus ID 3, irq 39
May 28 23:54:48 [kernel] Probing IDE interface ide0...
May 28 23:54:48 [kernel] hda: FUJITSU MHT2030AT, ATA DISK drive
May 28 23:54:48 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:54:48 [kernel] hda: UDMA/100 mode selected
May 28 23:54:48 [kernel] ide0 at 0xf103a000-0xf103a070,0xf103a160 on irq 39
May 28 23:54:48 [kernel] ide-pmac: Found Apple KeyLargo ATA-3 controller (macio), bus ID 0, irq 24
May 28 23:54:48 [kernel] Probing IDE interface ide1...
May 28 23:54:48 [kernel] hdc: MATSHITACD-RW CW-8123, ATAPI CD/DVD-ROM drive
May 28 23:54:48 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:54:48 [kernel] hdc: MWDMA2 mode selected
May 28 23:54:48 [kernel] ide1 at 0xf101a000-0xf101a070,0xf101a160 on irq 24
May 28 23:54:48 [kernel] ide-gd driver 1.18
May 28 23:54:48 [kernel] hda: max request size: 512KiB
May 28 23:54:48 [kernel] hda: 58605120 sectors (30005 MB) w/2048KiB Cache, CHS=16383/255/63
May 28 23:54:48 [kernel] hda: cache flushes supported
May 28 23:54:48 [kernel]  hda: [mac] hda1 hda2 hda3 hda4 hda5 hda6 hda7 hda8 hda9
May 28 23:54:48 [kernel] ide-cd driver 5.00
May 28 23:54:48 [kernel] ide-cd: hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
May 28 23:54:48 [kernel] Uniform CD-ROM driver Revision: 3.20
May 28 23:54:48 [kernel] sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
May 28 23:54:48 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:54:48 [kernel] eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0d:93:4b:d6:8c
May 28 23:54:48 [kernel] eth0: Found BCM5221 PHY
May 28 23:54:48 [kernel] mice: PS/2 mouse device common for all mice
May 28 23:54:48 [kernel] i2c /dev entries driver
May 28 23:54:48 [kernel] TCP cubic registered
May 28 23:54:48 [kernel] NET: Registered protocol family 17
May 28 23:54:48 [kernel] input: PMU as /devices/virtual/input/input4
May 28 23:54:48 [kernel] Registered led device: pmu-front-led
May 28 23:54:48 [kernel] REISERFS (device hda7): found reiserfs format "3.6" with standard journal
May 28 23:54:48 [kernel] REISERFS (device hda7): using ordered data mode
May 28 23:54:48 [kernel] REISERFS (device hda7): journal params: device hda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
May 28 23:54:48 [kernel] REISERFS (device hda7): checking transaction log (hda7)
May 28 23:54:48 [kernel] REISERFS (device hda7): Using r5 hash to sort names
May 28 23:54:48 [kernel] VFS: Mounted root (reiserfs filesystem) readonly on device 3:7.
May 28 23:54:48 [kernel] Freeing unused kernel memory: 176k init
May 28 23:54:48 [kernel] b43-pci-bridge 0001:10:12.0: enabling device (0004 -> 0006)
May 28 23:54:48 [kernel] ssb: Sonics Silicon Backplane found on PCI device 0001:10:12.0
May 28 23:54:48 [kernel] rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
May 28 23:54:48 [kernel] usbcore: registered new interface driver usbfs
May 28 23:54:48 [kernel] usbcore: registered new interface driver hub
May 28 23:54:48 [kernel] usbcore: registered new device driver usb
May 28 23:54:48 [kernel] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
May 28 23:54:48 [kernel] Apple USB OHCI 0001:10:18.0 disabled by firmware
May 28 23:54:48 [kernel] Apple USB OHCI 0001:10:19.0 disabled by firmware
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1a.0: enabling device (0000 -> 0002)
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1a.0: OHCI Host Controller
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1a.0: new USB bus registered, assigned bus number 1
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1a.0: irq 29, io mem 0x80083000
May 28 23:54:48 [kernel] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
May 28 23:54:48 [kernel] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
May 28 23:54:48 [kernel] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
May 28 23:54:48 [kernel] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:54:48 [kernel] usb usb1: Product: OHCI Host Controller
May 28 23:54:48 [kernel] usb usb1: Manufacturer: Linux 2.6.30-rc7 ohci_hcd
May 28 23:54:48 [kernel] usb usb1: SerialNumber: 0001:10:1a.0
May 28 23:54:48 [kernel] usb usb1: configuration #1 chosen from 1 choice
May 28 23:54:48 [kernel] hub 1-0:1.0: USB hub found
May 28 23:54:48 [kernel] hub 1-0:1.0: 2 ports detected
May 28 23:54:48 [kernel] ehci_hcd 0001:10:1b.2: enabling device (0004 -> 0006)
May 28 23:54:48 [kernel] ehci_hcd 0001:10:1b.2: EHCI Host Controller
May 28 23:54:48 [kernel] ehci_hcd 0001:10:1b.2: new USB bus registered, assigned bus number 2
May 28 23:54:48 [kernel] ehci_hcd 0001:10:1b.2: irq 63, io mem 0x80080000
May 28 23:54:48 [kernel] ehci_hcd 0001:10:1b.2: USB 2.0 started, EHCI 1.00
May 28 23:54:48 [kernel] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
May 28 23:54:48 [kernel] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:54:48 [kernel] usb usb2: Product: EHCI Host Controller
May 28 23:54:48 [kernel] usb usb2: Manufacturer: Linux 2.6.30-rc7 ehci_hcd
May 28 23:54:48 [kernel] usb usb2: SerialNumber: 0001:10:1b.2
May 28 23:54:48 [kernel] usb usb2: configuration #1 chosen from 1 choice
May 28 23:54:48 [kernel] hub 2-0:1.0: USB hub found
May 28 23:54:48 [kernel] hub 2-0:1.0: 5 ports detected
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1b.0: OHCI Host Controller
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1b.0: irq 63, io mem 0x80082000
May 28 23:54:48 [kernel] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 28 23:54:48 [kernel] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:54:48 [kernel] usb usb3: Product: OHCI Host Controller
May 28 23:54:48 [kernel] usb usb3: Manufacturer: Linux 2.6.30-rc7 ohci_hcd
May 28 23:54:48 [kernel] usb usb3: SerialNumber: 0001:10:1b.0
May 28 23:54:48 [kernel] usb usb3: configuration #1 chosen from 1 choice
May 28 23:54:48 [kernel] hub 3-0:1.0: USB hub found
May 28 23:54:48 [kernel] hub 3-0:1.0: 3 ports detected
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1b.1: enabling device (0000 -> 0002)
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1b.1: OHCI Host Controller
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1b.1: new USB bus registered, assigned bus number 4
May 28 23:54:48 [kernel] ohci_hcd 0001:10:1b.1: irq 63, io mem 0x80081000
May 28 23:54:48 [kernel] PowerMac i2c bus pmu 2 registered
May 28 23:54:48 [kernel] PowerMac i2c bus pmu 1 registered
May 28 23:54:48 [kernel] PowerMac i2c bus mac-io 0 registered
May 28 23:54:48 [kernel] PowerMac i2c bus uni-n 1 registered
May 28 23:54:48 [kernel] PowerMac i2c bus uni-n 0 registered
May 28 23:54:48 [kernel] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 28 23:54:48 [kernel] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 28 23:54:48 [kernel] usb usb4: Product: OHCI Host Controller
May 28 23:54:48 [kernel] usb usb4: Manufacturer: Linux 2.6.30-rc7 ohci_hcd
May 28 23:54:48 [kernel] usb usb4: SerialNumber: 0001:10:1b.1
May 28 23:54:48 [kernel] usb usb4: configuration #1 chosen from 1 choice
May 28 23:54:48 [kernel] hub 4-0:1.0: USB hub found
May 28 23:54:48 [kernel] hub 4-0:1.0: 2 ports detected
May 28 23:54:48 [kernel] usb 1-1: new full speed USB device using ohci_hcd and address 2
May 28 23:54:48 [kernel] ohci1394 0002:20:0e.0: enabling device (0000 -> 0002)
May 28 23:54:48 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:54:48 [kernel] usb 1-1: New USB device found, idVendor=05ac, idProduct=1000
May 28 23:54:48 [kernel] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
May 28 23:54:48 [kernel] usb 1-1: configuration #1 chosen from 1 choice
May 28 23:54:48 [kernel] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000d93fffe4bd68c]
May 28 23:54:48 [kernel] cfg80211: Using static regulatory domain info
May 28 23:54:48 [kernel] cfg80211: Regulatory domain: US
May 28 23:54:48 [kernel] _(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
May 28 23:54:48 [kernel] _(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
May 28 23:54:48 [kernel] _(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:54:48 [kernel] _(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:54:48 [kernel] _(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:54:48 [kernel] _(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
May 28 23:54:48 [kernel] _(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
May 28 23:54:48 [kernel] cfg80211: Calling CRDA for country: US
May 28 23:54:48 [kernel] b43-phy0: Broadcom 4306 WLAN found (core revision 5)
May 28 23:54:48 [kernel] phy0: Selected rate control algorithm 'minstrel'
May 28 23:54:48 [kernel] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID: FW13 ]
May 28 23:54:48 [kernel] udev: renamed network interface wmaster0 to eth1
May 28 23:54:48 [kernel] input: HID 05ac:1000 as /devices/pci0001:10/0001:10:1a.0/usb1/1-1/1-1:1.0/input/input5
May 28 23:54:48 [kernel] generic-usb 0003:05AC:1000.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0001:10:1a.0-1/input0
May 28 23:54:48 [kernel] input: HID 05ac:1000 as /devices/pci0001:10/0001:10:1a.0/usb1/1-1/1-1:1.1/input/input6
May 28 23:54:48 [kernel] generic-usb 0003:05AC:1000.0002: input,hidraw1: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0001:10:1a.0-1/input1
May 28 23:54:48 [kernel] usbcore: registered new interface driver usbhid
May 28 23:54:48 [kernel] usbhid: v2.6:USB HID core driver
May 28 23:54:48 [kernel] adt746x: version 1 (supported)
May 28 23:54:48 [kernel] adt746x: Thermostat bus: 1, address: 0x2e, limit_adjust: 0, fan_speed: -1
May 28 23:54:48 [kernel] sensor 0: PWR/MEMORY BOTTOMSIDE
May 28 23:54:48 [kernel] sensor 1: CPU BOTTOMSIDE
May 28 23:54:48 [kernel] sensor 2: GPU BOTTOMSIDE
May 28 23:54:48 [kernel] adt746x: ADT7467 initializing
May 28 23:54:48 [kernel] adt746x: Lowering max temperatures from 69, 92, 101 to 70, 50, 70
May 28 23:54:48 [kernel] irq: irq 1 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 21
May 28 23:54:48 [kernel] irq: irq 2 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 30
May 28 23:54:48 [kernel] irq: irq 61 on host /pci@f2000000/mac-io@17/interrupt-controller@40000 mapped to virtual irq 61
May 28 23:54:48 [kernel] input: PowerMac Beep as /devices/pci0001:10/0001:10:17.0/input/input7
May 28 23:54:48 [kernel] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
May 28 23:54:48 [kernel] Adding 1048568k swap on /dev/hda6.  Priority:-1 extents:1 across:1048568k 
May 28 23:54:52 [kernel] NET: Registered protocol family 10
May 28 23:54:52 [kernel] ip_tables: (C) 2000-2006 Netfilter Core Team
May 28 23:54:52 [kernel] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 28 23:54:53 [kernel] ip6_tables: (C) 2000-2006 Netfilter Core Team
May 28 23:54:55 [kernel] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
May 28 23:54:56 [kernel] Bluetooth: Core ver 2.15
May 28 23:54:56 [kernel] NET: Registered protocol family 31
May 28 23:54:56 [kernel] Bluetooth: HCI device and connection manager initialized
May 28 23:54:56 [kernel] Bluetooth: HCI socket layer initialized
May 28 23:54:56 [kernel] usb 1-1: USB disconnect, address 2
May 28 23:54:56 [kernel] usb 1-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -108
May 28 23:54:57 [kernel] usb 1-1: new full speed USB device using ohci_hcd and address 3
May 28 23:54:57 [kernel] usb 1-1: New USB device found, idVendor=05ac, idProduct=8203
May 28 23:54:57 [kernel] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
May 28 23:54:57 [kernel] usb 1-1: configuration #1 chosen from 1 choice
May 28 23:54:57 [kernel] Bluetooth: Generic Bluetooth USB driver ver 0.5
May 28 23:54:57 [kernel] usbcore: registered new interface driver btusb
May 28 23:54:58 [kernel] Bluetooth: L2CAP ver 2.13
May 28 23:54:58 [kernel] Bluetooth: L2CAP socket layer initialized
May 28 23:54:59 [kernel] Bluetooth: RFCOMM socket layer initialized
May 28 23:54:59 [kernel] Bluetooth: RFCOMM TTY layer initialized
May 28 23:54:59 [kernel] Bluetooth: RFCOMM ver 1.11
May 28 23:55:01 [kernel] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
May 28 23:55:01 [kernel] Bluetooth: BNEP filters: protocol multicast
May 28 23:55:19 [kernel] b43 ssb0:0: firmware: requesting b43/ucode5.fw
May 28 23:55:19 [kernel] b43 ssb0:0: firmware: requesting b43/pcm5.fw
May 28 23:55:19 [kernel] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
May 28 23:55:20 [kernel] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
May 28 23:55:20 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:55:20 [kernel] Registered led device: b43-phy0::tx
May 28 23:55:20 [kernel] Registered led device: b43-phy0::rx
May 28 23:55:20 [kernel] b43-phy0: Radio turned on by software
May 28 23:55:20 [kernel] ADDRCONF(NETDEV_UP): wlan0: link is not ready
May 28 23:55:31 [kernel] radeonfb 0000:00:10.0: Invalid ROM contents
                - Last output repeated twice -
May 28 23:55:31 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:55:31 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:55:32 [kernel] [drm] Setting GART location based on new memory map
May 28 23:55:32 [kernel] [drm] Loading R200 Microcode
May 28 23:55:32 [kernel] [drm] writeback test succeeded in 1 usecs
May 28 23:56:30 [kernel] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 28 23:56:30 [kernel] Freezing remaining freezable tasks ... (elapsed 1.12 seconds) done.
May 28 23:56:30 [kernel] Suspending console(s) (use no_console_suspend to debug)
May 28 23:56:30 [kernel] btusb_bulk_complete: hci0 urb ef2d9560 failed to resubmit (1)
May 28 23:56:30 [kernel] btusb_bulk_complete: hci0 urb ef1ef4c0 failed to resubmit (1)
May 28 23:56:30 [kernel] btusb_intr_complete: hci0 urb ef1ef440 failed to resubmit (1)
May 28 23:56:30 [kernel] eth0: suspending, WakeOnLan disabled
May 28 23:56:30 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
May 28 23:56:30 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
May 28 23:56:30 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
May 28 23:56:30 [kernel] radeonfb (0000:00:10.0): suspending for event: 2...
May 28 23:56:30 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on device 0000:00:10.0
May 28 23:56:30 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on bridge
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0xc (was 0x0, writing 0x90020001)
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x6 (was 0x0, writing 0x90000000)
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x5 (was 0x1, writing 0x401)
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x4 (was 0x8, writing 0x98000008)
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x3 (was 0x0, writing 0xff08)
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00007)
May 28 23:56:30 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x4 (was 0x0, writing 0x80084000)
May 28 23:56:30 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x3 (was 0x0, writing 0x1000)
May 28 23:56:30 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
May 28 23:56:30 [kernel] ohci_hcd 0001:10:1b.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:56:30 [kernel] ohci_hcd 0001:10:1b.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:56:30 [kernel] ehci_hcd 0001:10:1b.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100012)
May 28 23:56:30 [kernel] radeonfb (0000:00:10.0): resuming from state: 2...
May 28 23:56:30 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:56:30 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:56:30 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
                - Last output repeated twice -
May 28 23:56:30 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
                - Last output repeated twice -
May 28 23:56:30 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
                - Last output repeated twice -
May 28 23:56:30 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:56:30 [kernel] eth0: resuming
May 28 23:56:30 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:56:30 [kernel] adb: starting probe task...
May 28 23:56:30 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:56:30 [kernel] hda: UDMA/100 mode selected
May 28 23:56:30 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:56:30 [kernel] hdc: MWDMA2 mode selected
May 28 23:56:30 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
May 28 23:56:30 [kernel] ADB keyboard at 2, handler 1
May 28 23:56:30 [kernel] ADB mouse at 3, handler set to 4 (trackpad)
May 28 23:56:30 [kernel] adb: finished probe task...
May 28 23:56:30 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:56:30 [kernel] Registered led device: b43-phy0::tx
May 28 23:56:30 [kernel] Registered led device: b43-phy0::rx
May 28 23:56:51 [kernel] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 28 23:56:51 [kernel] Freezing remaining freezable tasks ... (elapsed 0.25 seconds) done.
May 28 23:56:51 [kernel] Suspending console(s) (use no_console_suspend to debug)
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1a.0: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
May 28 23:56:51 [kernel] btusb_bulk_complete: hci0 urb ef875ae0 failed to resubmit (1)
May 28 23:56:51 [kernel] btusb_bulk_complete: hci0 urb ef875b60 failed to resubmit (1)
May 28 23:56:51 [kernel] btusb_intr_complete: hci0 urb ef875be0 failed to resubmit (1)
May 28 23:56:51 [kernel] eth0: suspending, WakeOnLan disabled
May 28 23:56:51 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
May 28 23:56:51 [kernel] radeonfb (0000:00:10.0): suspending for event: 2...
May 28 23:56:51 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on device 0000:00:10.0
May 28 23:56:51 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on bridge
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0xc (was 0x0, writing 0x90020001)
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x6 (was 0x0, writing 0x90000000)
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x5 (was 0x1, writing 0x401)
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x4 (was 0x8, writing 0x98000008)
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x3 (was 0x0, writing 0xff08)
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00007)
May 28 23:56:51 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x4 (was 0x0, writing 0x80084000)
May 28 23:56:51 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x3 (was 0x0, writing 0x1000)
May 28 23:56:51 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1b.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1b.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:56:51 [kernel] ehci_hcd 0001:10:1b.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100012)
May 28 23:56:51 [kernel] radeonfb (0000:00:10.0): resuming from state: 2...
May 28 23:56:51 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:56:51 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
                - Last output repeated twice -
May 28 23:56:51 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
                - Last output repeated twice -
May 28 23:56:51 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
                - Last output repeated twice -
May 28 23:56:51 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:56:51 [kernel] eth0: resuming
May 28 23:56:51 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:56:51 [kernel] adb: starting probe task...
May 28 23:56:51 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:56:51 [kernel] hda: UDMA/100 mode selected
May 28 23:56:51 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:56:51 [kernel] hdc: MWDMA2 mode selected
May 28 23:56:51 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
May 28 23:56:51 [kernel] ADB keyboard at 2, handler 1
May 28 23:56:51 [kernel] ADB mouse at 3, handler set to 4 (trackpad)
May 28 23:56:51 [kernel] adb: finished probe task...
May 28 23:56:51 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:56:51 [kernel] Registered led device: b43-phy0::tx
May 28 23:56:51 [kernel] Registered led device: b43-phy0::rx
May 28 23:57:10 [kernel] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 28 23:57:10 [kernel] Freezing remaining freezable tasks ... (elapsed 0.19 seconds) done.
May 28 23:57:10 [kernel] Suspending console(s) (use no_console_suspend to debug)
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1a.0: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
May 28 23:57:10 [kernel] btusb_bulk_complete: hci0 urb ef875860 failed to resubmit (1)
May 28 23:57:10 [kernel] btusb_bulk_complete: hci0 urb ef8758e0 failed to resubmit (1)
May 28 23:57:10 [kernel] btusb_intr_complete: hci0 urb ef875ee0 failed to resubmit (1)
May 28 23:57:10 [kernel] eth0: suspending, WakeOnLan disabled
May 28 23:57:10 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
May 28 23:57:10 [kernel] radeonfb (0000:00:10.0): suspending for event: 2...
May 28 23:57:10 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on device 0000:00:10.0
May 28 23:57:10 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on bridge
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0xc (was 0x0, writing 0x90020001)
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x6 (was 0x0, writing 0x90000000)
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x5 (was 0x1, writing 0x401)
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x4 (was 0x8, writing 0x98000008)
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x3 (was 0x0, writing 0xff08)
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00007)
May 28 23:57:10 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x4 (was 0x0, writing 0x80084000)
May 28 23:57:10 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x3 (was 0x0, writing 0x1000)
May 28 23:57:10 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1b.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1b.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:57:10 [kernel] ehci_hcd 0001:10:1b.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100012)
May 28 23:57:10 [kernel] radeonfb (0000:00:10.0): resuming from state: 2...
May 28 23:57:10 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:57:10 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
                - Last output repeated twice -
May 28 23:57:10 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
                - Last output repeated twice -
May 28 23:57:10 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
                - Last output repeated twice -
May 28 23:57:10 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:57:10 [kernel] eth0: resuming
May 28 23:57:10 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:57:10 [kernel] adb: starting probe task...
May 28 23:57:10 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:57:10 [kernel] hda: UDMA/100 mode selected
May 28 23:57:10 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:57:10 [kernel] hdc: MWDMA2 mode selected
May 28 23:57:10 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
May 28 23:57:10 [kernel] ADB keyboard at 2, handler 1
May 28 23:57:10 [kernel] ADB mouse at 3, handler set to 4 (trackpad)
May 28 23:57:10 [kernel] adb: finished probe task...
May 28 23:57:10 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:57:10 [kernel] Registered led device: b43-phy0::tx
May 28 23:57:10 [kernel] Registered led device: b43-phy0::rx
May 28 23:57:35 [kernel] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 28 23:57:35 [kernel] Freezing remaining freezable tasks ... (elapsed 1.82 seconds) done.
May 28 23:57:35 [kernel] Suspending console(s) (use no_console_suspend to debug)
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1a.0: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
May 28 23:57:35 [kernel] btusb_bulk_complete: hci0 urb ef875b60 failed to resubmit (1)
May 28 23:57:35 [kernel] btusb_bulk_complete: hci0 urb ef875be0 failed to resubmit (1)
May 28 23:57:35 [kernel] btusb_intr_complete: hci0 urb ef875c60 failed to resubmit (1)
May 28 23:57:35 [kernel] eth0: suspending, WakeOnLan disabled
May 28 23:57:35 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
May 28 23:57:35 [kernel] radeonfb (0000:00:10.0): suspending for event: 2...
May 28 23:57:35 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on device 0000:00:10.0
May 28 23:57:35 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on bridge
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0xc (was 0x0, writing 0x90020001)
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x6 (was 0x0, writing 0x90000000)
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x5 (was 0x1, writing 0x401)
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x4 (was 0x8, writing 0x98000008)
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x3 (was 0x0, writing 0xff08)
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00007)
May 28 23:57:35 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x4 (was 0x0, writing 0x80084000)
May 28 23:57:35 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x3 (was 0x0, writing 0x1000)
May 28 23:57:35 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1b.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1b.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:57:35 [kernel] ehci_hcd 0001:10:1b.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100012)
May 28 23:57:35 [kernel] radeonfb (0000:00:10.0): resuming from state: 2...
May 28 23:57:35 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:57:35 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
                - Last output repeated twice -
May 28 23:57:35 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
                - Last output repeated twice -
May 28 23:57:35 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
                - Last output repeated twice -
May 28 23:57:35 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:57:35 [kernel] eth0: resuming
May 28 23:57:35 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:57:35 [kernel] adb: starting probe task...
May 28 23:57:35 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:57:35 [kernel] hda: UDMA/100 mode selected
May 28 23:57:35 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:57:35 [kernel] hdc: MWDMA2 mode selected
May 28 23:57:35 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
May 28 23:57:35 [kernel] ADB keyboard at 2, handler 1
May 28 23:57:35 [kernel] ADB mouse at 3, handler set to 4 (trackpad)
May 28 23:57:35 [kernel] adb: finished probe task...
May 28 23:57:35 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:57:35 [kernel] Registered led device: b43-phy0::tx
May 28 23:57:35 [kernel] Registered led device: b43-phy0::rx
May 28 23:57:51 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:57:51 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:57:51 [kernel] [drm] Loading R200 Microcode
May 28 23:58:09 [kernel] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 28 23:58:09 [kernel] Freezing remaining freezable tasks ... (elapsed 1.84 seconds) done.
May 28 23:58:09 [kernel] Suspending console(s) (use no_console_suspend to debug)
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1a.0: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
May 28 23:58:09 [kernel] btusb_bulk_complete: hci0 urb ef8757e0 failed to resubmit (1)
May 28 23:58:09 [kernel] btusb_bulk_complete: hci0 urb ef875860 failed to resubmit (1)
May 28 23:58:09 [kernel] btusb_intr_complete: hci0 urb ef8758e0 failed to resubmit (1)
May 28 23:58:09 [kernel] eth0: suspending, WakeOnLan disabled
May 28 23:58:09 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
May 28 23:58:09 [kernel] radeonfb (0000:00:10.0): suspending for event: 2...
May 28 23:58:09 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on device 0000:00:10.0
May 28 23:58:09 [kernel] agpgart-uninorth 0000:00:0b.0: disabling AGP on bridge
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0xc (was 0x0, writing 0x90020001)
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x6 (was 0x0, writing 0x90000000)
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x5 (was 0x1, writing 0x401)
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x4 (was 0x8, writing 0x98000008)
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x3 (was 0x0, writing 0xff08)
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: restoring config space at offset 0x1 (was 0x2b00000, writing 0x2b00007)
May 28 23:58:09 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x4 (was 0x0, writing 0x80084000)
May 28 23:58:09 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x3 (was 0x0, writing 0x1000)
May 28 23:58:09 [kernel] b43-pci-bridge 0001:10:12.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1b.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1b.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100002)
May 28 23:58:09 [kernel] ehci_hcd 0001:10:1b.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100012)
May 28 23:58:09 [kernel] radeonfb (0000:00:10.0): resuming from state: 2...
May 28 23:58:09 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:58:09 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1b.0: PME# disabled
                - Last output repeated twice -
May 28 23:58:09 [kernel] ohci_hcd 0001:10:1b.1: PME# disabled
                - Last output repeated twice -
May 28 23:58:09 [kernel] ehci_hcd 0001:10:1b.2: PME# disabled
                - Last output repeated twice -
May 28 23:58:09 [kernel] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
May 28 23:58:09 [kernel] eth0: resuming
May 28 23:58:09 [kernel] PHY ID: 4061e4, addr: 0
May 28 23:58:09 [kernel] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:58:09 [kernel] adb: starting probe task...
May 28 23:58:09 [kernel] hda: UDMA/100 mode selected
May 28 23:58:09 [kernel] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
May 28 23:58:09 [kernel] hdc: MWDMA2 mode selected
May 28 23:58:09 [kernel] adb devices: [2]: 2 c4 [7]: 7 1f
May 28 23:58:09 [kernel] ADB keyboard at 2, handler 1
May 28 23:58:09 [kernel] adb: finished probe task...
May 28 23:58:09 [kernel] b43-phy0: Loading firmware version 410.2160 (2007-05-26 15:32:10)
May 28 23:58:09 [kernel] Registered led device: b43-phy0::tx
May 28 23:58:09 [kernel] Registered led device: b43-phy0::rx
May 28 23:58:10 [kernel] agpgart-uninorth 0000:00:0b.0: putting AGP V2 device into 4x mode
May 28 23:58:10 [kernel] radeonfb 0000:00:10.0: putting AGP V2 device into 4x mode
May 28 23:58:10 [kernel] [drm] Loading R200 Microcode
