Return-Path: <linux-kernel-owner+w=401wt.eu-S1760927AbXE1KIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760927AbXE1KIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXE1KIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:08:48 -0400
Received: from 3404ds2-brh.0.fullrate.dk ([90.184.3.208]:11259 "EHLO
	mail.jaquet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXE1KIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:08:47 -0400
X-Greylist: delayed 649 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2007 06:08:46 EDT
Date: Mon, 28 May 2007 11:57:55 +0200
From: Rasmus Andersen <rasmus@jaquet.dk>
To: linux-kernel@vger.kernel.org
Subject: RAID1 questions and errors and questions about errors :)
Message-ID: <20070528095755.GU11507@jaquet.dk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I have for some time been facing some RAID1 issues which I finally have
been able to take the time to write about. I hope you can help me shed
some light on this.

My main problem is that a check/repair run of my RAID1 device reports
errors. Not always the same number of errors and not monotonously
increasing. It has not always been like this but I have not been able to
link this to any external event.

Secondary problems, probably linked to the main one, is that rtorrent
complains about checksum errors from time to time and that a loop of ten
sha1/md5 sums over a DVD image returns varying numbers, usually only a
single diffent one. The latter is more easily provoked if the system (my
home server) as such is busy (rdiff-backup, compiling, etc). (The
torrents and images reside on the RAID1 device.)

I have tried to run smart tests on the component drives and I have tried
memtest86+ for about 24 hours and doug ledfords memtest script[1] for
~12 hours, all without errors reported. The box is running gentoo so it
also sees a fair amount of gcc action, which also never have had a
SIGSEG or SIGBUS error pop up.

The system dmesg is attached, it a basic oldish athlon system with two
SATA drives on a SIL adapter with a PATA drive as well. The SATA drives
are the ones in the RAID1 setup. Running the md5sums on the PATA drive
has not resulted in any errors so far.

A tangential question to all of this is that if I use mdadm to create a
single-device raid1 setup consisting of my existing PATA partition, the
resulting device is smaller than the existing one, causing fsck to
complain bitterly about the FS being bigger than the device. Is that a
bug? The command I use to create the device is

   mdadm --create /dev/md1 -l 1 -n 2 /dev/hdb2 missing

(from memory but should capture the essence). I have wanted to create a
test RAID1 on the PATA drive to see if this caused errors to occur but
this prevents me from doing so, at least without some pain.


Lastly, I hope I made some sense :) I might well be that this is not
related to RAID1 at all but I have to start somewhere :)


[1] http://people.redhat.com/dledford/memtest.html

Thanks in advance,
  Rasmus

--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.21.1 (rasmus@firewall) (gcc version 3.4.6 (Gentoo 3.4.6-r1, ssp-3.4.5-1.0, pie-8.7.9)) #2 Mon May 14 20:25:51 CEST 2007
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
copy_e820_map() start: 00000000ffff0000 size: 0000000000010000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
 BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
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
ACPI: RSDP 000F7930, 0014 (r0 ASUS  )
ACPI: RSDT 1FFEC000, 002C (r1 ASUS   A7A266   42302E31 MSFT 31313031)
ACPI: FACP 1FFEC080, 0074 (r1 ASUS   A7A266   42302E31 MSFT 31313031)
ACPI: DSDT 1FFEC100, 291E (r1   ASUS A7A266       1000 MSFT  100000B)
ACPI: FACS 1FFFF000, 0040
ACPI: BOOT 1FFEC040, 0028 (r1 ASUS   A7A266   42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 30000000 (gap: 20000000:dfff0000)
Built 1 zonelists.  Total pages: 130029
Kernel command line: BOOT_IMAGE=2.6.21.1 ro root=902 root=/dev/ram0 lvm2root=/dev/data1/root elevator=cfq hda=none
ide_setup: hda=none
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffd000 (01402000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 1410.282 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 512888k/524208k available (2465k kernel code, 10788k reserved, 973k data, 200k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xe0800000 - 0xfffb5000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdffec000   ( 511 MB)
      .init : 0xc045e000 - 0xc0490000   ( 200 kB)
      .data : 0xc0368602 - 0xc045bc0c   ( 973 kB)
      .text : 0xc0100000 - 0xc0368602   (2465 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 2822.33 BogoMIPS (lpj=5644669)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0383f9ff c1cbf9ff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0383f9ff c1cbf9ff 00000000 00000420 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(TM) XP1600+ stepping 02
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 1e60)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf1170, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region e400-e43f claimed by ali7101 ACPI
PCI quirk: region e800-e81f claimed by ali7101 SMB
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKI] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x1fffffff could not be reserved
pnp: 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:02: ioport range 0xe400-0xe47f could not be reserved
pnp: 00:02: ioport range 0xe800-0xe81f has been reserved
pnp: 00:02: ioport range 0x40b-0x40b has been reserved
pnp: 00:02: ioport range 0x480-0x48f has been reserved
pnp: 00:02: ioport range 0x4d6-0x4d6 has been reserved
pnp: 00:03: iomem range 0xfffe0000-0xffffffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: e6000000-e7dfffff
  PREFETCH window: e7f00000-efffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
Freeing initrd memory: 2436k freed
Simple Boot Flag at 0x3a set to 0x1
Machine check exception polling timer started.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Limiting direct PCI/PCI transfers.
Activating ISA DMA hang workarounds.
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: Invalid PBLK length [5]
lp: driver loaded but no devices found
Linux agpgart interface v0.102 (c) Dave Jones
[drm] Initialized drm 1.1.0 20060810
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
floppy0: no floppy controllers found
RAMDISK driver initialized: 4 RAM disks of 8192K size 1024 blocksize
loop: loaded (max 8 devices)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 12 (level, low) -> IRQ 12
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0a.0: 3Com PCI 3c905C Tornado at e080c000.
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0b.0[A] -> Link [LNKB] -> GSI 10 (level, low) -> IRQ 10
0000:00:0b.0: 3Com PCI 3c905C Tornado at e080e000.
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hdb: WDC WD800BB-00CAA1, ATA DISK drive
Probing IDE interface ide1...
hdc: PLEXTOR DVDR PX-712A, ATAPI CD/DVD-ROM drive
Probing IDE interface ide2...
Probing IDE interface ide3...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hdb: max request size: 128KiB
hdb: 156301488 sectors (80026 MB) w/2048KiB Cache, CHS=65535/16/63
hdb: cache flushes not supported
 hdb: hdb1 hdb2
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache
Uniform CD-ROM driver Revision: 3.20
sata_sil 0000:00:09.0: version 2.1
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LNKD] -> GSI 5 (level, low) -> IRQ 5
ata1: SATA max UDMA/100 cmd 0xe0810080 ctl 0xe081008a bmdma 0xe0810000 irq 5
ata2: SATA max UDMA/100 cmd 0xe08100c0 ctl 0xe08100ca bmdma 0xe0810008 irq 5
scsi0 : sata_sil
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-7: Maxtor 6Y250M0, YAR51HW0, max UDMA/133
ata1.00: 490234752 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi1 : sata_sil
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: ATA-7: ST3320620AS, 3.AAJ, max UDMA/133
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y250M0   YAR5 PQ: 0 ANSI: 5
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
SCSI device sdb: 625142448 512-byte hdwr sectors (320073 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 625142448 512-byte hdwr sectors (320073 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 1:0:0:0: Attached scsi disk sdb
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugfs is not available
USB Universal Host Controller Interface driver v3.0
usbcore: registered new interface driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
md: linear personality registered for level -1
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Wed Mar 14 07:25:50 2007 UTC).
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:0c.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
ALSA device list:
  #0: Ensoniq AudioPCI ENS1371 at 0x9400, irq 11
oprofile: using timer interrupt.
nf_conntrack version 0.5.0 (4095 buckets, 32760 max)
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on hdb1
md: hdb1 has invalid sb, not importing!
md: invalid raid superblock magic on sdb1
md: sdb1 has invalid sb, not importing!
md: autorun ...
md: considering sdb2 ...
md:  adding sdb2 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb2>
md: running: <sdb2><sda1>
md: kicking non-fresh sda1 from array!
md: unbind<sda1>
md: export_rdev(sda1)
raid1: raid set md0 active with 1 out of 2 mirrors
md0: bitmap initialized from disk: read 12/12 pages, set 36371 bits, status: 0
created bitmap (190 pages) for device md0
md: ... autorun DONE.
RAMDISK: Compressed image found at block 0
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 200k freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
ali15x3_smbus 0000:00:11.0: ALI15X3_smb region uninitialized - upgrade BIOS or use force_addr=0xaddr
ali15x3_smbus 0000:00:11.0: ALI15X3 not detected, module not inserted.
EXT3 FS on dm-6, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
Adding 489972k swap on /dev/sda2.  Priority:1 extents:1 across:489972k

--QRj9sO5tAVLaXnSD--
