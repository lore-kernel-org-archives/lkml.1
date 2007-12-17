Return-Path: <linux-kernel-owner+w=401wt.eu-S935900AbXLQLAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935900AbXLQLAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 06:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935830AbXLQLAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 06:00:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935738AbXLQLAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 06:00:13 -0500
Date: Mon, 17 Dec 2007 02:59:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org
Subject: Re: CMD646 & cdrom: drive appears confused & drive not ready for
 command
Message-Id: <20071217025952.ad1017fa.akpm@linux-foundation.org>
In-Reply-To: <20071217025903.cef552f1.akpm@linux-foundation.org>
References: <Pine.SOC.4.64.0712162015210.27847@math.ut.ee>
	<20071217025903.cef552f1.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 02:59:03 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> (added linux-ide)

(Ths time for real)

> On Sun, 16 Dec 2007 20:36:04 +0200 (EET) Meelis Roos <mroos@linux.ee> wrote:
> 
> > I just noticed that all my recent test kernels on Sun Ultra 5 spam dmesg 
> > with "hdc: drive not ready for command" messages.  Oldest logs that I 
> > have are from 2.6.24-rc4-g94545bad and they are already bad.
> 
> So when did thi start?  Is 2.6.23 OK?
> 
> > The 
> > spamming does not happen right away but some time later, and 
> > hald-addon-storage is the userspace daemon that polls the cdrom 
> > regularly. Full dmesg until the spamming begins - notice there are first 
> > some "drive appears confused" messages right before it happens.
> > 
> > Dec 15 14:11:00 mandariin kernel: PROMLIB: Sun IEEE Boot Prom 'OBP 3.31.0 2001/07/25 20:36'
> > Dec 15 14:11:00 mandariin kernel: PROMLIB: Root node compatible: 
> > Dec 15 14:11:00 mandariin kernel: Linux version 2.6.24-rc5-gda8cadb3 (mroos@mandariin) (gcc version 4.2.3 20071123 (prerelease) (Debian 4.2.2-4)) #38 Sat Dec 15 13:00:43 EET 2007
> > Dec 15 14:11:00 mandariin kernel: ARCH: SUN4U
> > Dec 15 14:11:00 mandariin kernel: Ethernet address: 08:00:20:f8:c7:72
> > Dec 15 14:11:00 mandariin kernel: [0000000200000000-fffff80000800000] page_structs=262144 node=0 entry=0/0
> > Dec 15 14:11:00 mandariin kernel: [0000000200000000-fffff80000c00000] page_structs=262144 node=0 entry=1/0
> > Dec 15 14:11:00 mandariin kernel: [0000000200000000-fffff80001000000] page_structs=262144 node=0 entry=2/0
> > Dec 15 14:11:00 mandariin kernel: [0000000200000000-fffff80001400000] page_structs=262144 node=0 entry=3/0
> > Dec 15 14:11:00 mandariin kernel: OF stdout device is: /pci@1f,0/pci@1,1/ebus@1/se@14,400000:a
> > Dec 15 14:11:00 mandariin kernel: PROM: Built device tree with 42042 bytes of memory.
> > Dec 15 14:11:00 mandariin kernel: On node 0 totalpages: 64952
> > Dec 15 14:11:00 mandariin kernel:   Normal zone: 447 pages used for memmap
> > Dec 15 14:11:00 mandariin kernel:   Normal zone: 0 pages reserved
> > Dec 15 14:11:00 mandariin kernel:   Normal zone: 64505 pages, LIFO batch:15
> > Dec 15 14:11:00 mandariin kernel:   Movable zone: 0 pages used for memmap
> > Dec 15 14:11:00 mandariin kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64505
> > Dec 15 14:11:00 mandariin kernel: Kernel command line: root=/dev/hda1 ro
> > Dec 15 14:11:00 mandariin kernel: PID hash table entries: 2048 (order: 11, 16384 bytes)
> > Dec 15 14:11:00 mandariin kernel: clocksource: mult[2c71c] shift[16]
> > Dec 15 14:11:00 mandariin kernel: clockevent: mult[5c28f5c2] shift[32]
> > Dec 15 14:11:00 mandariin kernel: Console: colour dummy device 80x25
> > Dec 15 14:11:00 mandariin kernel: console [tty0] enabled
> > Dec 15 14:11:00 mandariin kernel: Dentry cache hash table entries: 65536 (order: 6, 524288 bytes)
> > Dec 15 14:11:00 mandariin kernel: Inode-cache hash table entries: 32768 (order: 5, 262144 bytes)
> > Dec 15 14:11:00 mandariin kernel: Memory: 501368k available (2696k kernel code, 904k data, 128k init) [fffff80000000000,000000001ff42000]
> > Dec 15 14:11:00 mandariin kernel: SLUB: Genslabs=12, HWalign=32, Order=0-2, MinObjects=8, CPUs=1, Nodes=1
> > Dec 15 14:11:00 mandariin kernel: Calibrating delay using timer specific routine.. 721.25 BogoMIPS (lpj=3606278)
> > Dec 15 14:11:00 mandariin kernel: Mount-cache hash table entries: 512
> > Dec 15 14:11:00 mandariin kernel: Initializing cgroup subsys ns
> > Dec 15 14:11:00 mandariin kernel: net_namespace: 120 bytes
> > Dec 15 14:11:00 mandariin kernel: NET: Registered protocol family 16
> > Dec 15 14:11:00 mandariin kernel: PCI: Probing for controllers.
> > Dec 15 14:11:00 mandariin kernel: /pci@1f,0: SABRE PCI Bus Module
> > Dec 15 14:11:00 mandariin kernel: /pci@1f,0: PCI IO[1fe02000000] MEM[1ff00000000]
> > Dec 15 14:11:00 mandariin kernel: PCI: Scanning PBM /pci@1f,0
> > Dec 15 14:11:00 mandariin kernel: ebus0: [auxio] [power] [SUNW,pll] [se] [su] [su] [ecpp] [fdthree] [eeprom] [flashprom] [SUNW,CS4231]
> > Dec 15 14:11:00 mandariin kernel: power: Control reg at 1fff1724000
> > Dec 15 14:11:00 mandariin kernel: SCSI subsystem initialized
> > Dec 15 14:11:00 mandariin kernel: libata version 3.00 loaded.
> > Dec 15 14:11:00 mandariin kernel: AUXIO: Found device at /pci@1f,0/pci@1,1/ebus@1/auxio@14,726000
> > Dec 15 14:11:00 mandariin kernel: /pci@1f,0/pci@1,1/ebus@1/eeprom@14,0: Clock regs at 000001fff1000000
> > Dec 15 14:11:00 mandariin kernel: NET: Registered protocol family 2
> > Dec 15 14:11:00 mandariin kernel: Time: tick clocksource has been installed.
> > Dec 15 14:11:00 mandariin kernel: Switched to high resolution mode on CPU 0
> > Dec 15 14:11:00 mandariin kernel: IP route cache hash table entries: 4096 (order: 2, 32768 bytes)
> > Dec 15 14:11:00 mandariin kernel: TCP established hash table entries: 16384 (order: 5, 262144 bytes)
> > Dec 15 14:11:00 mandariin kernel: TCP bind hash table entries: 16384 (order: 4, 131072 bytes)
> > Dec 15 14:11:00 mandariin kernel: TCP: Hash tables configured (established 16384 bind 16384)
> > Dec 15 14:11:00 mandariin kernel: TCP reno registered
> > Dec 15 14:11:00 mandariin kernel: Mini RTC Driver
> > Dec 15 14:11:00 mandariin kernel: VFS: Disk quotas dquot_6.5.1
> > Dec 15 14:11:00 mandariin kernel: Dquot-cache hash table entries: 1024 (order 0, 8192 bytes)
> > Dec 15 14:11:00 mandariin kernel: io scheduler noop registered
> > Dec 15 14:11:00 mandariin kernel: io scheduler anticipatory registered
> > Dec 15 14:11:00 mandariin kernel: io scheduler deadline registered
> > Dec 15 14:11:00 mandariin kernel: io scheduler cfq registered (default)
> > Dec 15 14:11:00 mandariin kernel: PCI: Enabling device: (0000:01:02.0), cmd 82
> > Dec 15 14:11:00 mandariin kernel: atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
> > Dec 15 14:11:00 mandariin kernel: atyfb: 4M SGRAM (1:1), 14.31818 MHz XTAL, 230 MHz PLL, 100 Mhz MCLK, 100 MHz XCLK
> > Dec 15 14:11:00 mandariin kernel: Console: switching to colour frame buffer device 144x56
> > Dec 15 14:11:00 mandariin kernel: atyfb: fb0: ATY Mach64 frame buffer device on PCI
> > Dec 15 14:11:00 mandariin kernel: /pci@1f,0/pci@1,1/ebus@1/su@14,3083f8: Keyboard port at 1fff13083f8, irq 6
> > Dec 15 14:11:00 mandariin kernel: /pci@1f,0/pci@1,1/ebus@1/su@14,3062f8: Mouse port at 1fff13062f8, irq 7
> > Dec 15 14:11:00 mandariin kernel: f0061c64: ttyS0 at MMIO 0x1fff1400000 (irq = 5) is a SAB82532 V3.2
> > Dec 15 14:11:00 mandariin kernel: Console: ttyS0 (SAB82532)
> > Dec 15 14:11:00 mandariin kernel: console [ttyS0] enabled
> > Dec 15 14:11:00 mandariin kernel: f0061c64: ttyS1 at MMIO 0x1fff1400040 (irq = 5) is a SAB82532 V3.2
> > Dec 15 14:11:00 mandariin kernel: Floppy drive(s): fd0 is 1.44M
> > Dec 15 14:11:00 mandariin kernel: FDC 0 is a National Semiconductor PC87306
> > Dec 15 14:11:00 mandariin kernel: loop: module loaded
> > Dec 15 14:11:00 mandariin kernel: PCI: Enabling device: (0000:01:01.1), cmd 2
> > Dec 15 14:11:00 mandariin kernel: sunhme.c:v3.00 June 23, 2006 David S. Miller (davem@davemloft.net)
> > Dec 15 14:11:00 mandariin kernel: eth0: HAPPY MEAL (PCI/CheerIO) 10/100BaseT Ethernet 08:00:20:f8:c7:72
> > Dec 15 14:11:00 mandariin kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> > Dec 15 14:11:00 mandariin kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> > Dec 15 14:11:00 mandariin kernel: CMD646: IDE controller (0x1095:0x0646 rev 0x03) at  PCI slot 0000:01:03.0
> > Dec 15 14:11:00 mandariin kernel: CMD646: MultiWord DMA force limited
> > Dec 15 14:11:00 mandariin kernel: CMD646: 100% native mode on irq 14
> > Dec 15 14:11:00 mandariin kernel:     ide0: BM-DMA at 0x1fe02c00020-0x1fe02c00027, BIOS settings: hda:pio, hdb:pio
> > Dec 15 14:11:00 mandariin kernel:     ide1: BM-DMA at 0x1fe02c00028-0x1fe02c0002f, BIOS settings: hdc:pio, hdd:pio
> > Dec 15 14:11:00 mandariin kernel: Probing IDE interface ide0...
> > Dec 15 14:11:00 mandariin kernel: hda: WDC WD1200JB-75CRA0, ATA DISK drive
> > Dec 15 14:11:00 mandariin kernel: hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> > Dec 15 14:11:00 mandariin kernel: hda: MW DMA 2 mode selected
> > Dec 15 14:11:00 mandariin kernel: ide0 at 0x1fe02c00000-0x1fe02c00007,0x1fe02c0000a on irq 14
> > Dec 15 14:11:00 mandariin kernel: Probing IDE interface ide1...
> > Dec 15 14:11:00 mandariin kernel: hdc: CRD-8322B, ATAPI CD/DVD-ROM drive
> > Dec 15 14:11:00 mandariin kernel: hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> > Dec 15 14:11:00 mandariin kernel: hdc: MW DMA 2 mode selected
> > Dec 15 14:11:00 mandariin kernel: ide1 at 0x1fe02c00010-0x1fe02c00017,0x1fe02c0001a on irq 14
> > Dec 15 14:11:00 mandariin kernel: hda: max request size: 128KiB
> > Dec 15 14:11:00 mandariin kernel: hda: Host Protected Area detected.
> > Dec 15 14:11:00 mandariin kernel: ^Icurrent capacity is 234375000 sectors (120000 MB)
> > Dec 15 14:11:00 mandariin kernel: ^Inative  capacity is 234441648 sectors (120034 MB)
> > Dec 15 14:11:00 mandariin kernel: hda: Host Protected Area disabled.
> > Dec 15 14:11:00 mandariin kernel: hda: 234441648 sectors (120034 MB) w/8192KiB Cache, CHS=65535/16/63, (U)DMA
> > Dec 15 14:11:00 mandariin kernel: hda: cache flushes not supported
> > Dec 15 14:11:00 mandariin kernel:  hda: hda1 hda2 hda3
> > Dec 15 14:11:00 mandariin kernel: mice: PS/2 mouse device common for all mice
> > Dec 15 14:11:00 mandariin kernel: input: Sun Mouse as /devices/root/f005f9c0/f00601b4/f0061504/f0064df4/serio1/input/input0
> > Dec 15 14:11:00 mandariin kernel: TCP cubic registered
> > Dec 15 14:11:00 mandariin kernel: NET: Registered protocol family 1
> > Dec 15 14:11:00 mandariin kernel: NET: Registered protocol family 17
> > Dec 15 14:11:00 mandariin kernel: registered taskstats version 1
> > Dec 15 14:11:00 mandariin kernel: kjournald starting.  Commit interval 5 seconds
> > Dec 15 14:11:00 mandariin kernel: EXT3-fs: mounted filesystem with ordered data mode.
> > Dec 15 14:11:00 mandariin kernel: VFS: Mounted root (ext3 filesystem) readonly.
> > Dec 15 14:11:00 mandariin kernel: hdc: ATAPI 32X CD-ROM drive, 128kB Cache, DMA
> > Dec 15 14:11:00 mandariin kernel: Uniform CD-ROM driver Revision: 3.20
> > Dec 15 14:11:00 mandariin kernel: Adding 1843616k swap on /dev/hda2.  Priority:-1 extents:1 across:1843616k
> > Dec 15 14:11:00 mandariin kernel: EXT3 FS on hda1, internal journal
> > Dec 15 14:11:00 mandariin kernel: device-mapper: uevent: version 1.0.3
> > Dec 15 14:11:00 mandariin kernel: device-mapper: ioctl: 4.12.0-ioctl (2007-10-02) initialised: dm-devel@redhat.com
> > Dec 15 14:11:00 mandariin kernel: Ebtables v2.0 registered
> > Dec 15 14:11:00 mandariin kernel: Bridge firewalling registered
> > Dec 15 14:11:00 mandariin kernel: fuse init (API version 7.9)
> > Dec 15 14:11:00 mandariin kernel: NET: Registered protocol family 10
> > Dec 15 14:11:01 mandariin kernel: lo: Disabled Privacy Extensions
> > Dec 15 14:11:01 mandariin kernel: eth0: Link is up using internal transceiver at 100Mb/s, Full Duplex.
> > Dec 15 14:11:01 mandariin kernel: RPC: Registered udp transport module.
> > Dec 15 14:11:01 mandariin kernel: RPC: Registered tcp transport module.
> > Dec 15 14:11:02 mandariin kernel: parport0: PC-style at 0x1fff13043bc (0x1fff13047bc), irq 8, dma 0 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
> > Dec 15 14:11:02 mandariin kernel: lp0: using parport0 (interrupt-driven).
> > Dec 15 14:11:02 mandariin kernel: eth0: no IPv6 routers present
> > Dec 15 14:11:07 mandariin kernel: Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> > Dec 15 14:11:07 mandariin kernel: NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> > Dec 15 14:11:07 mandariin kernel: NFSD: starting 90-second grace period
> > Dec 15 14:11:20 mandariin kernel: end_request: I/O error, dev fd0, sector 0
> > Dec 16 06:26:10 mandariin kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01). Trying to recover by ending request.
> > Dec 16 06:53:04 mandariin kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01). Trying to recover by ending request.
> > Dec 16 06:55:49 mandariin kernel: hdc: cdrom_pc_intr: The drive appears confused (ireason = 0x01). Trying to recover by ending request.
> > Dec 16 06:56:01 mandariin last message repeated 3 times
> > Dec 16 06:56:01 mandariin kernel: hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > Dec 16 06:56:01 mandariin kernel: ide: failed opcode was: unknown
> > Dec 16 06:56:01 mandariin kernel: hdc: drive not ready for command
> > Dec 16 06:56:04 mandariin kernel: hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > 
> > And so on.
> > 
> > ps shows
> > hald-addon-storage: polling /dev/hdc (every 2 sec)
> > and killing this hald-addon-storage makes the messages go away (no more 
> > polling - but's already broken anyway).
> > 
> 
> Are there any other consequences apart from log spam?
> 
> 
