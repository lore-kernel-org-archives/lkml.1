Return-Path: <linux-kernel-owner+w=401wt.eu-S1030907AbXD1VkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907AbXD1VkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030912AbXD1VkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:40:24 -0400
Received: from [70.254.190.220] ([70.254.190.220]:41148 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030907AbXD1VkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:40:20 -0400
Date: Sat, 28 Apr 2007 21:40:19 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: PANIC: 2.6.21-rc7-mm2, Kernel access of bad area, sig: 11
Message-ID: <Pine.LNX.4.64.0704282135580.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This bug occurs in linux-2.6.21-rc7-mm2, and does not occur in 2.6.21-rc7
ARCH is powerpc

dmesg output, captured via netconsole:
[    0.000000] Using PowerMac machine description
[    0.000000] Total memory = 128MB; using 256kB for hash table (at c7fc0000)
[    0.000000] Linux version 2.6.21-rc7-mm2 (root@console) (gcc version 4.1.1 (Gentoo 4.1.1-r3)) #3 SMP PREEMPT Sat Apr 28 14:29:54 CDT 2007
[    0.000000] Found UniNorth memory controller & host bridge @ 0xf8000000 revision: 0xc0
[    0.000000] Mapped at 0xfdfc0000
[    0.000000] Found a Pangea mac-io controller, rev: 0, mapped at 0xfdf40000
[    0.000000] PowerMac motherboard: iMac "Flower Power"
[    0.000000] Found UniNorth PCI host bridge at 0x00000000f0000000. Firmware bus number: 0->0
[    0.000000] Found UniNorth PCI host bridge at 0x00000000f2000000. Firmware bus number: 0->0
[    0.000000] Found UniNorth PCI host bridge at 0x00000000f4000000. Firmware bus number: 0->0
[    0.000000] via-pmu: Server Mode is enabled
[    0.000000] PMU driver v2 initialized for Core99, firmware: 0c
[    0.000000] nvram: Checking bank 0...
[    0.000000] nvram: gen0=498, gen1=499
[    0.000000] nvram: Active bank is: 1
[    0.000000] nvram: OF partition at 0x210
[    0.000000] nvram: XP partition at 0xffffffff
[    0.000000] nvram: NR partition at 0xffffffff
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->    32768
[    0.000000]   Normal      32768 ->    32768
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->    32768
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 32512
[    0.000000] Kernel command line: root=/dev/hda4 ro real_root=/dev/hda4 netconsole=4444@192.168.0.3/eth0,6666@192.168.0.8/00:11:09:3C:07:C2 
[    0.000000] netconsole: local port 4444
[    0.000000] netconsole: local IP 192.168.0.3
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 6666
[    0.000000] netconsole: remote IP 192.168.0.8
[    0.000000] netconsole: remote ethernet address 00:11:09:3c:07:c2
[    0.000000] mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
[    0.000000] mpic: ISU size: 64, shift: 6, mask: 3f
[    0.000000] mpic: Initializing for 64 sources
[    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
[    0.000000] GMT Delta read from XPRAM: 0 minutes, DST: on
[   18.626246] Console: colour dummy device 80x25
[   18.626620] console handover: boot [udbg0] -> real [tty0]
[   18.627059] ------------------------
[   18.627073] | Locking API testsuite:
[   18.627083] ----------------------------------------------------------------------------
[   18.627098]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[   18.627113]   --------------------------------------------------------------------------
[   18.627140]                      A-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627204]                  A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627265]              A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627327]              A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627389]          A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627457]          A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627524]          A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
[   18.627592]                     double unlock:  ok  |  ok  |failed|  ok  |failed|failed|
[   18.627645]                   initialize held:failed|failed|failed|failed|failed|failed|
[   18.627703]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[   18.627763]   --------------------------------------------------------------------------
[   18.627785]               recursive read-lock:             |  ok  |             |failed|
[   18.627825]            recursive read-lock #2:             |  ok  |             |failed|
[   18.627865]             mixed read-write-lock:             |failed|             |failed|
[   18.627911]             mixed write-read-lock:             |failed|             |failed|
[   18.627951]   --------------------------------------------------------------------------
[   18.627974]      hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[   18.628011]      soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
[   18.628049]      hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[   18.628084]      soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
[   18.628120]        sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
[   18.628156]        sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
[   18.628192]          hard-safe-A + irqs-on/12:failed|failed|  ok  |
[   18.628229]          soft-safe-A + irqs-on/12:failed|failed|  ok  |
[   18.628266]          hard-safe-A + irqs-on/21:failed|failed|  ok  |
[   18.628302]          soft-safe-A + irqs-on/21:failed|failed|  ok  |
[   18.628338]     hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[   18.628376]     soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
[   18.628415]     hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[   18.628453]     soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
[   18.628491]     hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[   18.628530]     soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
[   18.628568]     hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[   18.628606]     soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
[   18.628644]     hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[   18.628682]     soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
[   18.628720]     hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[   18.628758]     soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
[   18.628800]     hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[   18.628841]     soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
[   18.628885]     hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[   18.628924]     soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
[   18.628963]     hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[   18.629001]     soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
[   18.629040]     hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[   18.629079]     soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
[   18.629117]     hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[   18.629155]     soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
[   18.629193]     hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[   18.629232]     soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
[   18.629270]       hard-irq lock-inversion/123:failed|failed|  ok  |
[   18.629310]       soft-irq lock-inversion/123:failed|failed|  ok  |
[   18.629349]       hard-irq lock-inversion/132:failed|failed|  ok  |
[   18.629388]       soft-irq lock-inversion/132:failed|failed|  ok  |
[   18.629426]       hard-irq lock-inversion/213:failed|failed|  ok  |
[   18.629465]       soft-irq lock-inversion/213:failed|failed|  ok  |
[   18.629504]       hard-irq lock-inversion/231:failed|failed|  ok  |
[   18.629542]       soft-irq lock-inversion/231:failed|failed|  ok  |
[   18.629580]       hard-irq lock-inversion/312:failed|failed|  ok  |
[   18.629619]       soft-irq lock-inversion/312:failed|failed|  ok  |
[   18.629657]       hard-irq lock-inversion/321:failed|failed|  ok  |
[   18.629696]       soft-irq lock-inversion/321:failed|failed|  ok  |
[   18.629734]       hard-irq read-recursion/123:  ok  |
[   18.629758]       soft-irq read-recursion/123:  ok  |
[   18.629782]       hard-irq read-recursion/132:  ok  |
[   18.629805]       soft-irq read-recursion/132:  ok  |
[   18.629829]       hard-irq read-recursion/213:  ok  |
[   18.629853]       soft-irq read-recursion/213:  ok  |
[   18.629881]       hard-irq read-recursion/231:  ok  |
[   18.629904]       soft-irq read-recursion/231:  ok  |
[   18.629928]       hard-irq read-recursion/312:  ok  |
[   18.629951]       soft-irq read-recursion/312:  ok  |
[   18.629975]       hard-irq read-recursion/321:  ok  |
[   18.629998]       soft-irq read-recursion/321:  ok  |
[   18.630023] --------------------------------------------------------
[   18.630041] 142 out of 218 testcases failed, as expected. |
[   18.630057] ----------------------------------------------------
[   18.630499] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[   18.630918] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[   18.655186] Memory: 121356k/131072k available (5428k kernel code, 9568k reserved, 212k data, 2207k bss, 248k init)
[   18.655433] SLUB: General Slabs=18, HW alignment=32, Processors=1, Nodes=1
[   18.673073] Mount-cache hash table entries: 512
[   18.673990] device-tree: Duplicate name in /cpus/PowerPC,750@0, renamed to "l2-cache#1"
[   18.677777] PowerMac SMP probe found 1 cpus
[   18.678182] Brought up 1 CPUs
[   18.679737] NET: Registered protocol family 16
[   18.681402] KeyWest i2c @0xf8001003 irq 42 /uni-n@f8000000/i2c@f8001000
[   18.681453]  channel 0 bus <multibus>
[   18.681468]  channel 1 bus <multibus>
[   18.681541] KeyWest i2c @0x80018000 irq 26 /pci@f2000000/mac-io@17/i2c@18000
[   18.681561]  channel 0 bus <multibus>
[   18.681598] PMU i2c /pci@f2000000/mac-io@17/via-pmu@16000
[   18.681616]  channel 1 bus <multibus>
[   18.681631]  channel 2 bus <multibus>
[   18.681793] PCI: Probing PCI hardware
[   18.699303] Linux Plug and Play Support v0.97 (c) Adam Belay
[   18.700522] SCSI subsystem initialized
[   18.701322] usbcore: registered new interface driver usbfs
[   18.701633] usbcore: registered new interface driver hub
[   18.701990] usbcore: registered new device driver usb
[   18.705546] NET: Registered protocol family 2
[   18.715032] IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
[   18.715338] TCP established hash table entries: 4096 (order: 4, 114688 bytes)
[   18.716163] TCP bind hash table entries: 4096 (order: 4, 98304 bytes)
[   18.716855] TCP: Hash tables configured (established 4096 bind 4096)
[   18.716893] TCP reno registered
[   18.720723] Thermal assist unit using timers, shrink_timer: 2000 jiffies
[   18.724650] Initializing RT-Tester: OK
[   18.724755] audit: initializing netlink socket (disabled)
[   18.724830] audit(2213944456.098:1): initialized
[   18.743947] io scheduler noop registered
[   18.744013] io scheduler anticipatory registered
[   18.744029] io scheduler deadline registered
[   18.744756] io scheduler cfq registered (default)
[   18.745925] PCI: Enabling device 0000:00:10.0 (0086 -> 0087)
[   18.746718] aty128fb: BIOS not located, guessing timings.
[   18.746747] aty128fb: Rage128 TR Ultra AGP [chip rev 0x4] 16M 128-bit SDR SGRAM (1:1)
[   18.765363] Console: switching to colour frame buffer device 128x48
[   18.780864] fb0: ATY Rage128 frame buffer device on Rage128 TR Ultra AGP
[   18.820931] Generic RTC Driver v1.07
[   18.821413] Macintosh non-volatile memory driver v1.1
[   18.821971] Linux agpgart interface v0.102 (c) Dave Jones
[   18.822302] [drm] Initialized drm 1.1.0 20060810
[   18.823105] [drm] Initialized r128 2.5.0 20030725 on minor 0
[   18.823693] ipmi message handler version 39.1
[   18.823960] ipmi device interface
[   18.824374] IPMI System Interface driver.
[   18.825585] ipmi_si: Unable to find any System Interface(s)
[   18.825827] IPMI Watchdog: driver initialized
[   18.826031] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[   18.831263] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   18.831914] loop: module loaded
[   18.832324] sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
[   18.895245] eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:30:65:cc:83:08 
[   18.895594] eth0: Found BCM5201 PHY
[   18.896712] netconsole: device eth0 not up yet, forcing it
[   21.294017] eth0: Link is up at 100 Mbps, full-duplex.
[   21.300376] eth0: Pause is disabled
[   22.195311] netconsole: network logging started
[   22.202234] MacIO PCI driver attached to Pangea chipset
[   22.214807] input: Macintosh mouse button emulation as /class/input/input0
[   22.222370] adb: starting probe task...
[   22.228980] adb: finished probe task...
[   22.235443] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   22.241934] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   23.261890] ide0: Found Apple KeyLargo ATA-4 controller, bus ID 2, irq 19
[   23.532202] hda: Maxtor 32049H2 B, ATA DISK drive
[   23.946194] hdb: MATSHITA CD-RW CW-7121, ATAPI CD/DVD-ROM drive
[   24.002898] hda: Enabling Ultra DMA 2
[   24.010334] hdb: Enabling MultiWord DMA 2
[   24.017814] ide0 at 0xc901e000-0xc901e007,0xc901e160 on irq 19
[   24.025417] hda: max request size: 128KiB
[   24.054738] hda: 40021632 sectors (20491 MB) w/2048KiB Cache, CHS=39704/16/63, UDMA(33)
[   24.061398] hda: cache flushes not supported
[   24.068183]  hda: [mac] hda1 hda2 hda3 hda4
[   24.087216] hdb: ATAPI 24X CD-ROM CD-R/RW drive, 2048kB Cache, DMA
[   24.094248] Uniform CD-ROM driver Revision: 3.20
[   24.104703] ide-floppy driver 0.99.newide
[   24.112454] mesh: configured for synchronous 5 MB/s
[   24.120569] 116x: driver isp116x-hcd, 03 Nov 2005
[   24.128122] PCI: Enabling device 0001:10:18.0 (0000 -> 0002)
[   24.134847] ohci_hcd 0001:10:18.0: OHCI Host Controller
[   24.141894] ohci_hcd 0001:10:18.0: new USB bus registered, assigned bus number 1
[   24.148709] ohci_hcd 0001:10:18.0: irq 27, io mem 0x80081000
[   24.225270] usb usb1: new device found, idVendor=0000, idProduct=0000
[   24.231860] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
[   24.238481] usb usb1: Product: OHCI Host Controller
[   24.245056] usb usb1: Manufacturer: Linux 2.6.21-rc7-mm2 ohci_hcd
[   24.251713] usb usb1: SerialNumber: 0001:10:18.0
[   24.259338] usb usb1: configuration #1 chosen from 1 choice
[   24.266527] hub 1-0:1.0: USB hub found
[   24.273315] hub 1-0:1.0: 2 ports detected
[   24.380519] PCI: Enabling device 0001:10:19.0 (0000 -> 0002)
[   24.387131] ohci_hcd 0001:10:19.0: OHCI Host Controller
[   24.394043] ohci_hcd 0001:10:19.0: new USB bus registered, assigned bus number 2
[   24.400705] ohci_hcd 0001:10:19.0: irq 28, io mem 0x80080000
[   24.477243] usb usb2: new device found, idVendor=0000, idProduct=0000
[   24.483659] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
[   24.490080] usb usb2: Product: OHCI Host Controller
[   24.496430] usb usb2: Manufacturer: Linux 2.6.21-rc7-mm2 ohci_hcd
[   24.502904] usb usb2: SerialNumber: 0001:10:19.0
[   24.510140] usb usb2: configuration #1 chosen from 1 choice
[   24.517080] hub 2-0:1.0: USB hub found
[   24.523498] hub 2-0:1.0: 2 ports detected
[   24.617893] usb 1-1: new full speed USB device using ohci_hcd and address 2
[   24.630546] USB Universal Host Controller Interface driver v3.0
[   24.637517] sl811: driver sl811-hcd, 19 May 2005
[   24.644158] Initializing USB Mass Storage driver...
[   24.763930] usb 1-1: new device found, idVendor=04fc, idProduct=0561
[   24.770256] usb 1-1: new device strings: Mfr=1, Product=2, SerialNumber=0
[   24.776497] usb 1-1: Product: Generic Digital camera
[   24.782724] usb 1-1: Manufacturer: Sunplus Technology Co., Ltd.
[   24.789899] usb 1-1: configuration #1 chosen from 1 choice
[   25.013887] usb 2-1: new full speed USB device using ohci_hcd and address 2
[   25.152937] usb 2-1: new device found, idVendor=0409, idProduct=0059
[   25.159269] usb 2-1: new device strings: Mfr=0, Product=0, SerialNumber=0
[   25.166371] usb 2-1: configuration #1 chosen from 1 choice
[   25.173335] hub 2-1:1.0: USB hub found
[   25.179956] hub 2-1:1.0: 4 ports detected
[   25.492921] usb 2-1.2: new full speed USB device using ohci_hcd and address 3
[   25.603922] usb 2-1.2: new device found, idVendor=1453, idProduct=4026
[   25.610183] usb 2-1.2: new device strings: Mfr=1, Product=2, SerialNumber=0
[   25.616426] usb 2-1.2: Product: USB-Serial Controller
[   25.622610] usb 2-1.2: Manufacturer: Prolific Technology Inc.
[   25.629617] usb 2-1.2: configuration #1 chosen from 1 choice
[   25.830923] usb 2-1.3: new low speed USB device using ohci_hcd and address 4
[   25.941936] usb 2-1.3: new device found, idVendor=1267, idProduct=0103
[   25.948156] usb 2-1.3: new device strings: Mfr=0, Product=0, SerialNumber=0
[   25.955181] usb 2-1.3: configuration #1 chosen from 1 choice
[   25.966129] usbcore: registered new interface driver usb-storage
[   25.972499] USB Mass Storage support registered.
[   25.979214] usbcore: registered new interface driver usbserial
[   25.985824] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   25.992806] usbcore: registered new interface driver usbserial_generic
[   25.999393] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   26.006211] drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
[   26.013127] pl2303 2-1.2:1.0: pl2303 converter detected
[   26.020502] usb 2-1.2: pl2303 converter now attached to ttyUSB0
[   26.027254] usbcore: registered new interface driver pl2303
[   26.033810] drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
[   26.041329] mice: PS/2 mouse device common for all mice
[   26.048657] I2O subsystem v1.325
[   26.055301] i2o: max drivers = 8
[   26.062547] I2O Configuration OSM v1.323
[   26.069712] I2O Bus Adapter OSM v1.317
[   26.076487] I2O Block Device OSM v1.325
[   26.083922] I2O SCSI Peripheral OSM v1.316
[   26.090680] I2O ProcFS OSM v1.316
[   26.098042] PowerMac i2c bus pmu 2 registered
[   26.104784] PowerMac i2c bus pmu 1 registered
[   26.111431] PowerMac i2c bus mac-io 0 registered
[   26.118007] PowerMac i2c bus uni-n 1 registered
[   26.124464] PowerMac i2c bus uni-n 0 registered
[   26.137840] input: HID 1267:0103 as /class/input/input1
[   26.144369] input: USB HID v1.10 Keyboard [HID 1267:0103] on usb-0001:10:19.0-1.3
[   26.159741] input: HID 1267:0103 as /class/input/input2
[   26.166357] input: USB HID v1.10 Device [HID 1267:0103] on usb-0001:10:19.0-1.3
[   26.172632] usbcore: registered new interface driver usbhid
[   26.178753] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   26.185056] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
[   26.962329] input: PowerMac Beep as /class/input/input3
[   26.970271] ALSA device list:
[   26.976661]   #0: PowerMac Screamer Rev 0
[   26.983305] TCP cubic registered
[   26.989512] Initializing XFRM netlink socket
[   26.995740] NET: Registered protocol family 1
[   27.002720] NET: Registered protocol family 10
[   27.009347] lo: Disabled Privacy Extensions
[   27.016020] NET: Registered protocol family 17
[   27.022182] NET: Registered protocol family 15
[   27.030444] input: PMU as /class/input/input4
[   27.052675] ReiserFS: hda4: found reiserfs format "3.6" with standard journal
[   27.058960] ReiserFS: hda4: using ordered data mode
[   27.078108] ReiserFS: hda4: journal params: device hda4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   27.099024] ReiserFS: hda4: checking transaction log (hda4)
[   27.195147] ReiserFS: hda4: Using r5 hash to sort names
[   27.201477] VFS: Mounted root (reiserfs filesystem) readonly.
[   27.207715] Freeing unused kernel memory: 248k init
[  156.166766] Oops: Kernel access of bad area, sig: 11 [#1]
[  156.167014] PREEMPT SMP NR_CPUS=2 DEBUG_PAGEALLOC PowerMac
[  156.167267] Modules linked in: nfsd exportfs pmac_zilog serial_core ohci1394 ieee1394 uninorth_agp
[  156.167711] NIP: c0068ce4 LR: c0068cdc CTR: 00000000
[  156.167892] REGS: c0583a40 TRAP: 0300   Not tainted  (2.6.21-rc7-mm2)
[  156.168118] MSR: 00001032 <ME,IR,DR>  CR: 42202022  XER: 00000000
[  156.168467] DAR: 00000000, DSISR: 42000000
[  156.168617] TASK = c0550260[0] 'swapper' THREAD: c0582000 CPU: 0
[  156.168840] GPR00: 00000000 c0583af0 c0550260 00000783 c059bc88 00000001 c0488ec0 c059bc80 
[  156.169272] GPR08: c0460713 c0488e77 00000000 c0488b70 00003da3 00000000 0023f96c c0590000 
[  156.169705] GPR16: c0590000 0023f964 c0590000 00000000 00001032 00000000 c0583eb0 c0590000 
[  156.170145] GPR24: c0583b18 00000000 00000000 00000000 c0583b28 c000a1e4 c0583b2c c059bc80 
[  156.170594] NIP [c0068ce4] kallsyms_lookup+0x64/0xa4
[  156.170806] LR [c0068cdc] kallsyms_lookup+0x5c/0xa4
[  156.170997] Call Trace:
[  156.171093] [c0583af0] [c0068cb4] kallsyms_lookup+0x34/0xa4 (unreliable)
[  156.171384] --- Exception: c0583bb0 at 0xc0583ba0
[  156.171578]     LR = draw_byte+0x34/0x1d0
[  156.171723] [c0583b10] [c002ebd0] xmon_show_stack+0x2b8/0x330 (unreliable)
[  156.172017] [c0583c10] [c003053c] cmds+0xa20/0x1600
[  156.172235] [c0583ca0] [c0031448] xmon_core+0x32c/0x734
[  156.172452] [c0583d60] [c00319fc] xmon+0x2c/0x68
[  156.172647] [c0583e20] [c0031b40] xmon_irq+0x50/0x6c
[  156.172856] [c0583e40] [c0073828] handle_IRQ_event+0x5c/0xb0
[  156.173090] [c0583e60] [c00755dc] handle_fasteoi_irq+0xac/0x174
[  156.173333] [c0583e80] [c0006be4] do_IRQ+0xec/0x130
[  156.179644] [c0583ea0] [c0014fe8] ret_from_except+0x0/0x14
[  156.185827] --- Exception: 501 at cpu_idle<hand copied begins here>+0xfc/0x1dc
                    LR = cpu_idle+0xfc/0x1dc
                [c0583f60] [c000a24c] cpu_idle+0x164/0x1dc (unreliable)
                [c0583f80] [c0003cc4] rest_init+0x74/0x88
                [c0583fa0] [c050fb68] start_kernel+0x310/0x394
                [c0583ff0] [000037b4] 0x37b4

This occurs after pressing the programmer switch to generate an NMI.

William Heimbigner
icxcnika@mar.tar.cc
