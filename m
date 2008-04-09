Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYDIJpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYDIJpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYDIJpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:45:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37928 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYDIJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:44:59 -0400
Subject: Re: lockdep, false positive ?
From: Peter Zijlstra <peterz@infradead.org>
To: benh@kernel.crashing.org
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>
In-Reply-To: <1207714607.9079.22.camel@pasglop>
References: <1207714607.9079.22.camel@pasglop>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 11:44:41 +0200
Message-Id: <1207734281.4110.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 14:16 +1000, Benjamin Herrenschmidt wrote:
> Hi !
> 
> I adapted lockdep to ppc64 and see this on my G5:
> 
> Crash kernel location must be 0x2000000
> Reserving 0MB of memory at 32MB for crashkernel (System RAM: 3584MB)
> DART table allocated at: c00000007f000000
> Using PowerMac machine description
> Page orders: linear mapping = 24, virtual = 12, io = 12
> Found U3 memory controller & host bridge @ 0xf8000000 revision: 0x35
> Mapped at 0xd000080080000000
> Found a K2 mac-io controller, rev: 96, mapped at 0xd000080080041000
> PowerMac motherboard: PowerMac G5
> DART IOMMU initialized for U3 type chipset
> console [udbg0] enabled
> CPU maps initialized for 1 thread per core
>  (thread shift is 0)
> Starting Linux PPC64 #18 SMP Wed Apr 9 14:04:12 EST 2008
> -----------------------------------------------------
> ppc64_pft_size                = 0x0
> physicalMemorySize            = 0xe0000000
> htab_address                  = 0xc00000015c000000
> htab_hash_mask                = 0x7ffff
> -----------------------------------------------------
> Linux version 2.6.25-rc8 (benh@grosgo) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #18 SMP Wed Apr 9 14:04:12 EST 2008
> [boot]0012 Setup Arch
> Entering add_active_range(0, 0, 524288) 0 entries of 256 used
> Entering add_active_range(0, 1048576, 1441792) 1 entries of 256 used
> Found U3-AGP PCI host bridge.  Firmware bus number: 240->255
> PCI host bridge /pci@0,f0000000  ranges:
>  MEM 0x00000000f1000000..0x00000000f1ffffff -> 0x00000000f1000000 
>   IO 0x00000000f0000000..0x00000000f07fffff -> 0x0000000000000000
>  MEM 0x0000000090000000..0x00000000afffffff -> 0x0000000090000000 
> Can't get bus-range for /ht@0,f2000000, assume bus 0
> Found U3-HT PCI host bridge.  Firmware bus number: 0->239
> PCI host bridge /ht@0,f2000000 (primary) ranges:
> via-pmu: Server Mode is disabled
> PMU driver v2 initialized for Core99, firmware: 0c
> nvram: Checking bank 0...
> nvram: gen0=398, gen1=397
> nvram: Active bank is: 0
> nvram: OF partition at 0x410
> nvram: XP partition at 0x1020
> nvram: NR partition at 0x1120
> Top of RAM: 0x160000000, Total RAM: 0xe0000000
> Memory hole size: 2048MB
> Zone PFN ranges:
>   DMA             0 ->  1441792
>   Normal    1441792 ->  1441792
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0:        0 ->   524288
>     0:  1048576 ->  1441792
> On node 0 totalpages: 917504
>   DMA zone: 33792 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 883712 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
> [boot]0015 Setup Done
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 883712
> Kernel command line: 
> mpic: Setting up MPIC " MPIC 1   " version 1.2 at 80040000, max 4 CPUs
> mpic: ISU size: 120, shift: 7, mask: 7f
> mpic: Initializing for 120 sources
> mpic: Setting up MPIC " MPIC 2   " version 1.2 at f8040000, max 4 CPUs
> mpic: ISU size: 124, shift: 7, mask: 7f
> mpic: Initializing for 124 sources
> PID hash table entries: 4096 (order: 12, 32768 bytes)
> time_init: decrementer frequency = 33.333333 MHz
> time_init: processor frequency   = 2500.000000 MHz
> clocksource: timebase mult[7800001] shift[22] registered
> clockevent: decrementer mult[888] shift[16] cpu[0]
> Console: colour dummy device 80x25
> console handover: boot [udbg0] -> real [tty0]
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> .... MAX_LOCKDEP_SUBCLASSES:    8
> .... MAX_LOCK_DEPTH:          48
> .... MAX_LOCKDEP_KEYS:        2048
> .... CLASSHASH_SIZE:           1024
> .... MAX_LOCKDEP_ENTRIES:     8192
> .... MAX_LOCKDEP_CHAINS:      16384
> .... CHAINHASH_SIZE:          8192
>  memory used by lock dependency info: 1712 kB
>  per task-struct memory footprint: 3456 bytes
> ------------------------
> | Locking API testsuite:
> ----------------------------------------------------------------------------
>                                  | spin |wlock |rlock |mutex | wsem | rsem |
>   --------------------------------------------------------------------------
>                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
>   --------------------------------------------------------------------------
>               recursive read-lock:             |  ok  |             |  ok  |
>            recursive read-lock #2:             |  ok  |             |  ok  |
>             mixed read-write-lock:             |  ok  |             |  ok  |
>             mixed write-read-lock:             |  ok  |             |  ok  |
>   --------------------------------------------------------------------------
>      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
>        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
>          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
>       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
>       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
>       hard-irq read-recursion/123:  ok  |
>       soft-irq read-recursion/123:  ok  |
>       hard-irq read-recursion/132:  ok  |
>       soft-irq read-recursion/132:  ok  |
>       hard-irq read-recursion/213:  ok  |
>       soft-irq read-recursion/213:  ok  |
>       hard-irq read-recursion/231:  ok  |
>       soft-irq read-recursion/231:  ok  |
>       hard-irq read-recursion/312:  ok  |
>       soft-irq read-recursion/312:  ok  |
>       hard-irq read-recursion/321:  ok  |
>       soft-irq read-recursion/321:  ok  |
> -------------------------------------------------------
> Good, all 218 testcases passed! |
> ---------------------------------
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> Memory: 3431144k/3670016k available (7668k kernel code, 2335348k reserved, 1228k data, 4246k bss, 676k init)
> SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> Calibrating delay loop... 66.56 BogoMIPS (lpj=133120)
> Mount-cache hash table entries: 256
> PowerMac SMP probe found 2 cpus
> KeyWest i2c @0xf8001003 irq 16 /u3@0,f8000000/i2c@f8001000
>  channel 0 bus <multibus>
>  channel 1 bus <multibus>
> KeyWest i2c @0x80018000 irq 26 /ht@0,f2000000/pci@3/mac-io@7/i2c@18000
>  channel 0 bus <multibus>
> PMU i2c /ht@0,f2000000/pci@3/mac-io@7/via-pmu@16000/pmu-i2c
>  channel 1 bus <multibus>
>  channel 2 bus <multibus>
> Processor timebase sync using Pulsar i2c clock
> mpic: requesting IPIs ... 
> Processor 1 found.
> clockevent: decrementer mult[888] shift[16] cpu[1]
> Brought up 2 CPUs
> CPU0 attaching sched-domain:
>  domain 0: span 3
>   groups: 1 2
> CPU1 attaching sched-domain:
>  domain 0: span 3
>   groups: 2 1
> khelper used greatest stack depth: 10976 bytes left
> net_namespace: 1000 bytes
> NET: Registered protocol family 16
> PCI: Probing PCI hardware
> IOMMU table initialized, virtual merging enabled
> PCI: Closing bogus Apple Firmware region 2 on bus 0x01
> PCI: Closing bogus Apple Firmware region 2 on bus 0x02
> PCI: Closing bogus Apple Firmware region 2 on bus 0x03
> PCI: Closing bogus Apple Firmware region 2 on bus 0x04
> PCI: Closing bogus Apple Firmware region 2 on bus 0x05
> PCI: Bridge: 0001:00:01.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0001:00:02.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0001:00:03.0
>   IO window: disabled.
>   MEM window: 0x80000000-0x800fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0001:00:04.0
>   IO window: disabled.
>   MEM window: 0x80100000-0x801fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0001:00:05.0
>   IO window: disabled.
>   MEM window: 0x80200000-0x802fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0001:00:06.0
>   IO window: disabled.
>   MEM window: 0x80300000-0x805fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0001:00:07.0
>   IO window: disabled.
>   MEM window: 0x80600000-0x806fffff
>   PREFETCH window: disabled.
> PCI: Probing PCI hardware done
> Registering pmac pic with sysfs...
> SCSI subsystem initialized
> libata version 3.00 loaded.
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 1
> NET: Registered protocol family 2
> IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
> TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
> TCP: Hash tables configured (established 524288 bind 65536)
> TCP reno registered
> nvram_init: Could not find nvram partition for nvram buffered error logging.
> Registering G5 CPU frequency driver
> Frequency method: i2c/pfunc, Voltage method: i2c/pfunc
> Low: 2000 Mhz, High: 2500 Mhz, Cur: 2000 MHz
> Total HugeTLB memory allocated, 0
> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> pci 0001:00:01.0: MSI quirk detected; subordinate MSI disabled
> pci 0001:00:01.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
> pci 0001:00:02.0: MSI quirk detected; subordinate MSI disabled
> pci 0001:00:02.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
> PCI: Enabling device 0000:f0:10.0 (0006 -> 0007)
> radeonfb: Found Open Firmware ROM Image
> radeonfb: Retrieved PLL infos from Open Firmware
> radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=310.00 Mhz, System=400.00 MHz
> radeonfb: PLL min 12000 max 35000
> i2c-adapter i2c-2: unable to read EDID block.
> i2c-adapter i2c-2: unable to read EDID block.
> i2c-adapter i2c-2: unable to read EDID block.
> radeonfb: Monitor 1 type CRT found
> radeonfb: EDID probed
> radeonfb: Monitor 2 type no found
>       Display is GTF capable
> Attempt to iounmap early bolted mapping at 0xd0000800800c1000
> Console: switching to colour frame buffer device 160x64
> radeonfb (0000:f0:10.0): ATI Radeon AR 
> Generic RTC Driver v1.07
> Linux agpgart interface v0.103
> [drm] Initialized drm 1.1.0 20060810
> [drm] Initialized radeon 1.28.0 20060524 on minor 0
> pmac_zilog: 0.6 (Benjamin Herrenschmidt <benh@kernel.crashing.org>)
> ttyS0 at MMIO 0x80013020 (irq = 22) is a Z85c30 ESCC - Serial port
> ttyS1 at MMIO 0x80013000 (irq = 23) is a Z85c30 ESCC - Serial port
> brd: module loaded
> loop: module loaded
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
> Copyright (c) 1999-2006 Intel Corporation.
> sungem.c:v0.98 8/24/03 David S. Miller (davem@redhat.com)
> PHY ID: 2062e0, addr: 1
> eth0: Sun GEM (PCI) 10/100/1000BaseT Ethernet 00:0d:93:43:75:28
> eth0: Found BCM5421-K2 PHY
> MacIO PCI driver attached to K2 chipset
> input: Macintosh mouse button emulation as /class/input/input0
> PowerMac G5 Thermal control driver 1.3
> Detected fan controls:
>   0: PWM fan, id 1, location: BACKSIDE,SYS CTRLR FAN
>   1: RPM fan, id 2, location: DRIVE BAY
>   2: PWM fan, id 2, location: SLOT,PCI FAN
>   3: RPM fan, id 3, location: CPU A INTAKE
>   4: RPM fan, id 4, location: CPU A EXHAUST
>   5: RPM fan, id 5, location: CPU B INTAKE
>   6: RPM fan, id 6, location: CPU B EXHAUST
>   7: RPM fan, id 1, location: CPU A PUMP
>   8: RPM fan, id 0, location: CPU B PUMP
> Uniform Multi-Platform E-IDE driver
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> PCI: Enabling device 0001:03:0d.0 (0014 -> 0016)
> ide0: Found Apple K2 ATA-6 controller, bus ID 3, irq 39
> Probing IDE interface ide0...
> hda: HL-DT-ST DVD-RW GWA-4082B, ATAPI CD/DVD-ROM drive
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/66 mode selected
> ide0 at 0xd000080082352000-0xd000080082352007,0xd000080082352160 on irq 39
> hda: ATAPI 32X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20
> st: Version 20080221, fixed bufsize 32768, s/g segs 256
> Driver 'st' needs updating - please use bus_type methods
> Driver 'sd' needs updating - please use bus_type methods
> Driver 'sr' needs updating - please use bus_type methods
> sata_svw 0001:05:0c.0: version 2.3
> scsi0 : sata_svw
> scsi1 : sata_svw
> scsi2 : sata_svw
> scsi3 : sata_svw
> ata1: SATA max UDMA/133 mmio m8192@0x80600000 port 0x80600000 irq 17
> ata2: SATA max UDMA/133 mmio m8192@0x80600000 port 0x80600100 irq 17
> ata3: SATA max UDMA/133 mmio m8192@0x80600000 port 0x80600200 irq 17
> ata4: SATA max UDMA/133 mmio m8192@0x80600000 port 0x80600300 irq 17
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: ST3250410AS, 3.AAC, max UDMA/133
> ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/133
> eth0: Link is up at 100 Mbps, full-duplex.
> ata2: SATA link down (SStatus 4 SControl 300)
> ata3: SATA link down (SStatus 4 SControl 300)
> ata4: SATA link down (SStatus 4 SControl 300)
> scsi 0:0:0:0: Direct-Access     ATA      ST3250410AS      3.AA PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: [mac] sda1 sda2 sda3 sda4
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> PCI: Enabling device 0001:03:0e.0 (0000 -> 0002)
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[40]  MMIO=[80200000-802007ff]  Max Packet=[4096]  IR/IT contexts=[8/8]
> ieee1394: raw1394: /dev/raw1394 device initialized
> PCI: Enabling device 0001:02:0b.2 (0004 -> 0006)
> ehci_hcd 0001:02:0b.2: EHCI Host Controller
> ehci_hcd 0001:02:0b.2: new USB bus registered, assigned bus number 1
> ehci_hcd 0001:02:0b.2: irq 63, io mem 0x80100000
> ehci_hcd 0001:02:0b.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 5 ports detected
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
> PCI: Enabling device 0001:01:08.0 (0000 -> 0002)
> ohci_hcd 0001:01:08.0: OHCI Host Controller
> ohci_hcd 0001:01:08.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0001:01:08.0: irq 27, io mem 0x80081000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> PCI: Enabling device 0001:01:09.0 (0000 -> 0002)
> ohci_hcd 0001:01:09.0: OHCI Host Controller
> ohci_hcd 0001:01:09.0: new USB bus registered, assigned bus number 3
> ohci_hcd 0001:01:09.0: irq 28, io mem 0x80080000
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> PCI: Enabling device 0001:02:0b.0 (0000 -> 0002)
> ohci_hcd 0001:02:0b.0: OHCI Host Controller
> ohci_hcd 0001:02:0b.0: new USB bus registered, assigned bus number 4
> ohci_hcd 0001:02:0b.0: irq 63, io mem 0x80102000
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 3 ports detected
> PCI: Enabling device 0001:02:0b.1 (0000 -> 0002)
> ohci_hcd 0001:02:0b.1: OHCI Host Controller
> ohci_hcd 0001:02:0b.1: new USB bus registered, assigned bus number 5
> ohci_hcd 0001:02:0b.1: irq 63, io mem 0x80101000
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 2 ports detected
> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000d93fffe437528]
> usb 5-2: new full speed USB device using ohci_hcd and address 2
> usb 5-2: configuration #1 chosen from 1 choice
> hub 5-2:1.0: USB hub found
> hub 5-2:1.0: 3 ports detected
> usb 5-2.1: new low speed USB device using ohci_hcd and address 3
> usb 5-2.1: configuration #1 chosen from 1 choice
> usb 5-2.3: new full speed USB device using ohci_hcd and address 4
> usb 5-2.3: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver usblp
> Initializing USB Mass Storage driver...
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> mice: PS/2 mouse device common for all mice
> i2c /dev entries driver
> PowerMac i2c bus pmu 2 registered
> PowerMac i2c bus pmu 1 registered
> PowerMac i2c bus mac-io 0 registered
> PowerMac i2c bus u3 1 registered
> Liquid cooling pumps detected, using new algorithm !
> PowerMac i2c bus u3 0 registered
> md: linear personality registered for level -1
> FCU Initialized, RPM fan shift is 3
> md: raid0 personality registered for level 0
> md: raid1 personality registered for level 1
> device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> usbcore: registered new interface driver hiddev
> input: HID 04b3:3107 as /class/input/input1
> input: USB HID v1.00 Mouse [HID 04b3:3107] on usb-0001:02:0b.1-2.1
> input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input2
> input: USB HID v1.10 Keyboard [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:02:0b.1-2.3
> input: Mitsumi Electric Apple Extended USB Keyboard as /class/input/input3
> input: USB HID v1.10 Device [Mitsumi Electric Apple Extended USB Keyboard] on usb-0001:02:0b.1-2.3
> usbcore: registered new interface driver usbhid
> drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> oprofile: using ppc64/970 performance monitoring.
> IPv4 over IPv4 tunneling driver
> TCP cubic registered
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> input: PMU as /class/input/input4
> md: Autodetecting RAID arrays.
> md: Scanned 0 and added 0 devices.
> md: autorun ...
> md: ... autorun DONE.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> Freeing unused kernel memory: 676k freed
> khelper used greatest stack depth: 9072 bytes left
> runlevel used greatest stack depth: 8880 bytes left
> grep used greatest stack depth: 6864 bytes left
> Adding 9937800k swap on /dev/sda4.  Priority:-1 extents:1 across:9937800k
> EXT3 FS on sda3, internal journal
> ioctl32(pbbuttonsd:3234): Unknown cmd fd(9) cmd(40044201){t:'B';sz:4} arg(ff91c9dc) on /dev/pmu
> warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
> eth0: Link is up at 100 Mbps, full-duplex.
> eth0: Pause is enabled (rxfifo: 10240 off: 7168 on: 5632)
> hcid used greatest stack depth: 6560 bytes left
> ioctl32(gnome-terminal:4017): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(0fbfe7c4) on /dev/pts/0
> ioctl32(gnome-terminal:4017): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(0fbfe7cc) on /dev/pts/0
> ioctl32(gnome-terminal:4017): Unknown cmd fd(20) cmd(0000530b){t:'S';sz:0} arg(0fbfe7d4) on /dev/pts/0
> jockey-gtk used greatest stack depth: 6368 bytes left
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.25-rc8 #18
> ---------------------------------------------
> swapper/0 is trying to acquire lock:
>  (&dev->event_lock){++..}, at: [<c0000000003ef5f8>] .input_event+0x64/0xd0
> 
> but task is already holding lock:
>  (&dev->event_lock){++..}, at: [<c0000000003ef5f8>] .input_event+0x64/0xd0
> 
> other info that might help us debug this:
> 2 locks held by swapper/0:
>  #0:  (&dev->event_lock){++..}, at: [<c0000000003ef5f8>] .input_event+0x64/0xd0
>  #1:  (rcu_read_lock){..--}, at: [<c0000000003ed8d0>] .input_pass_event+0x0/0x160
> 
> stack backtrace:
> Call Trace:
> [c00000000fff2fa0] [c00000000000f58c] .show_stack+0x78/0x1c8 (unreliable)
> [c00000000fff3050] [c00000000000f6fc] .dump_stack+0x20/0x34
> [c00000000fff30d0] [c0000000000800c4] .__lock_acquire+0xac4/0xee0
> [c00000000fff31c0] [c0000000000805b8] .lock_acquire+0xd8/0x124
> [c00000000fff3280] [c0000000004ee1a0] ._spin_lock_irqsave+0x60/0xc8
> [c00000000fff3320] [c0000000003ef5f8] .input_event+0x64/0xd0
> [c00000000fff33d0] [c000000000338958] .mac_hid_mouse_emulate_buttons+0x94/0xf8
> [c00000000fff3450] [c0000000002b36bc] .kbd_event+0x1d0/0x82c
> [c00000000fff3540] [c0000000003ed9b0] .input_pass_event+0xe0/0x160
> [c00000000fff35f0] [c0000000003ee724] .input_handle_event+0x4fc/0x544
> [c00000000fff36b0] [c0000000003ef628] .input_event+0x94/0xd0
> [c00000000fff3760] [c0000000004229a4] .hidinput_hid_event+0x358/0x3bc
> [c00000000fff3810] [c00000000041d458] .hid_process_event+0x4c/0xc4
> [c00000000fff38c0] [c00000000041d874] .hid_input_field+0x3a4/0x3f0
> [c00000000fff39a0] [c00000000041d9d4] .hid_input_report+0x114/0x18c
> [c00000000fff3a50] [c0000000004263b4] .hid_irq_in+0xb0/0x1c8
> [c00000000fff3af0] [c0000000003bff50] .usb_hcd_giveback_urb+0xe8/0x15c
> [c00000000fff3b90] [c0000000003db9d8] .finish_urb+0xcc/0x15c
> [c00000000fff3c30] [c0000000003dbad4] .takeback_td+0x6c/0x19c
> [c00000000fff3cd0] [c0000000003df4cc] .ohci_irq+0x4d0/0x750
> [c00000000fff3db0] [c0000000003c0590] .usb_hcd_irq+0x58/0xc8
> [c00000000fff3e40] [c000000000091708] .handle_IRQ_event+0x60/0xe0
> [c00000000fff3ef0] [c000000000093950] .handle_fasteoi_irq+0x130/0x1d0
> [c00000000fff3f90] [c0000000000223b0] .call_handle_irq+0x1c/0x2c
> [c00000015a11fac0] [c00000000000c508] .do_IRQ+0x114/0x1d0
> [c00000015a11fb60] [c000000000004694] hardware_interrupt_entry+0x1c/0x20
> --- Exception: 501 at .cpu_idle+0xe8/0x150
>     LR = .cpu_idle+0xe8/0x150
> [c00000015a11fe50] [c000000000011da4] .cpu_idle+0xbc/0x150 (unreliable)
> [c00000015a11fef0] [c0000000004f10e4] .start_secondary+0x15c/0x188
> [c00000015a11ff90] [c0000000000073c0] .start_secondary_prolog+0xc/0x10
> 
> Now, I -think- that this is fine, that is, I believe the lock is first
> taken by the HID/kbd driver calling input_event, and then by mac-hid
> mouse emulation which has a separate input_dev and thus a separate
> instance of the lock.
> 
> (I may be wrong and we -might- have a real bug here, but I'll let
> others more familiar with the input layer have a look).
> 
> Is it a known issue that lockdep can issue false positives like that ?

Yes, if both locks are of the same class it will report this. Lockdep
does lock chain validation on classes, never on individual locks.

A class usually consists of all locks that share the lock init site; but
there are ways to explicity set another class.

In case of these recursions we have helpers like spin_lock_nested(&lock,
subclass) that allow you to annotate these. These sub-classes must then
always be taken in the same order; subclass < 8.

In this case its probably easier to explicity set a class, as the
nesting is not exposed to the input layer, so it doesn't know about it.

Something like this should do I guess.

---
Subject: mac_hid: lockdep annotate the emumousebtn input nesting

The mouse button emulation calls input device methods from an input
device. This causes funny lock nesting which is harmless as each device
has its own locks.

Give the nesting device its own lock classes so that lockdep will not
consider them the same.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/drivers/macintosh/mac_hid.c b/drivers/macintosh/mac_hid.c
index 8930230..f972ff3 100644
--- a/drivers/macintosh/mac_hid.c
+++ b/drivers/macintosh/mac_hid.c
@@ -103,6 +103,9 @@ int mac_hid_mouse_emulate_buttons(int caller, unsigned int keycode, int down)
 	return 0;
 }
 
+static struct lock_class_key emumousebtn_event_class;
+static struct lock_class_key emumousebtn_mutex_class;
+
 static int emumousebtn_input_register(void)
 {
 	int ret;
@@ -111,6 +114,9 @@ static int emumousebtn_input_register(void)
 	if (!emumousebtn)
 		return -ENOMEM;
 
+	lockdep_set_class(emumousebtn->event_lock, &emumousebtn_event_class);
+	lockdep_set_class(emumousebtn->mutex, &emumousebtn_mutex_class);
+
 	emumousebtn->name = "Macintosh mouse button emulation";
 	emumousebtn->id.bustype = BUS_ADB;
 	emumousebtn->id.vendor = 0x0001;


