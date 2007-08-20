Return-Path: <linux-kernel-owner+w=401wt.eu-S1762763AbXHTUsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762763AbXHTUsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXHTUse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:48:34 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:42373 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbXHTUsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:48:31 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: jgarzik@pobox.com
Subject: sata_via: write errors on PATA drive connected to VT6421
Date: Mon, 20 Aug 2007 22:42:06 +0200
User-Agent: KMail/1.9.7
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fyfyGKFD+nGaZP5"
Message-Id: <200708202242.07290.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fyfyGKFD+nGaZP5
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,
I've built a new machine with VT6421 add-on card that has two SATA and one 
PATA port:

sata_via 0000:00:0a.0: version 2.2
sata_via 0000:00:0a.0: routed to hard irq line 12
scsi0 : sata_via
scsi1 : sata_via
scsi2 : sata_via
ata1: SATA max UDMA/133 cmd 0x00016300 ctl 0x0001630a bmdma 0x00016700 irq 12
ata2: SATA max UDMA/133 cmd 0x00016400 ctl 0x0001640a bmdma 0x00016708 irq 12
ata3: PATA max UDMA/133 cmd 0x00016500 ctl 0x0001650a bmdma 0x00016710 irq 12


The SATA port works fine with Samsung 500GB HDD:

ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133

But there are write problems with the PATA port with Seagate 250GB HDD:

ata3.00: ATA-7: ST3250823A, 3.03, max UDMA/100
ata3.00: 488397168 sectors, multi 16: LBA48
ata3.00: configured for UDMA/100

Reading works but writing any longer data stream causes errors like this:

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:40:97:c6:87/00:01:16:00:00/e0 tag 0 cdb 0x0 data 163840 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:df:d1:87/00:04:16:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support 
DPO or FUA

The transfer mode decreases from UDMA/100 to UDMA/66 and then UDMA/33 but it 
doesn't help at all. The drive itself is fine, the problems also appear with 
4.3GB Seagate drive. But there are no problems with WD 700MB drive (PIO 
mode). I think that it's some kind of UDMA problem.

Kernel is 2.6.22.3, older 2.6.21.5 was also affected. Complete dmesg output is 
attached.

-- 
Ondrej Zary

--Boundary-00=_fyfyGKFD+nGaZP5
Content-Type: text/plain;
  charset="us-ascii";
  name="sata_via-error.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="sata_via-error.txt"

Linux version 2.6.22.3-router2 (rainbow@pentium) (gcc version 4.1.2) #3 Mon Aug 20 19:16:29 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000002000000 (usable)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
32MB LOWMEM available.
Entering add_active_range(0, 0, 8192) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->     8192
early_node_map[1] active PFN ranges
    0:        0 ->     8192
On node 0 totalpages: 8192
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 32 pages used for memmap
  Normal zone: 4064 pages, LIFO batch:0
DMI not present or invalid.
Allocating PCI resources starting at 10000000 (gap: 02000000:fdff0000)
Built 1 zonelists.  Total pages: 8128
Kernel command line: auto BOOT_IMAGE=Linux26223 ro root=821
Initializing CPU#0
PID hash table entries: 128 (order: 7, 512 bytes)
Detected 133.130 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 29668k/32768k available (1594k kernel code, 2716k reserved, 537k data, 132k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffffc000 - 0xfffff000   (  12 kB)
    vmalloc : 0xc2800000 - 0xffffa000   ( 983 MB)
    lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
      .init : 0xc0318000 - 0xc0339000   ( 132 kB)
      .data : 0xc028e8de - 0xc03150dc   ( 537 kB)
      .text : 0xc0100000 - 0xc028e8de   (1594 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 266.63 BogoMIPS (lpj=1333176)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 008001bf 00000000 00000000 00000000 00000000 00000000 00000000
Intel Pentium with F0 0F bug - workaround enabled.

CPU: After all inits, caps: 008001bf 00000000 00000000 00000000 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium MMX stepping 03
Checking 'hlt' instruction... OK.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfad90, last bus=0
PCI: Using configuration type 1
Setting up standard PCI resources
Linux Plug and Play Support v0.97 (c) Adam Belay
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fbaf0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbb18, dseg 0xf0000
PnPBIOS: 14 nodes reported by PnP BIOS; 14 recorded by driver
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
pnp: 00:07: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:07: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:07: iomem range 0xfffe0000-0xffffffff could not be reserved
pnp: 00:07: iomem range 0x100000-0x1ffffff could not be reserved
pnp: 00:09: ioport range 0x208-0x20f has been reserved
NET: Registered protocol family 2
Time: tsc clocksource has been installed.
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
Activating ISA DMA hang workarounds.
Boot video device is 0000:00:08.0
isapnp: Scanning for PnP cards...
isapnp: Card '3Com 3C509B EtherLink III'
isapnp: 1 Plug & Play card detected total
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
ppdev: user-space parallel port driver
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
parport_pc 00:0c: reported by Plug and Play BIOS
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
lp0: using parport0 (interrupt-driven).
loop: module loaded
3c59x: Donald Becker and others.
0000:00:09.0: 3Com PCI 3c905C Tornado at c2800000.
ne.c:v1.10 9/23/94 Donald Becker (becker@scyld.com)
Last modified Nov 1, 2000 by Paul Gortmaker
NE*000 ethercard probe at 0x300: 00 40 33 25 7b fa
eth1: NE2000 found at 0x300, using IRQ 3.
pnp: Device 01:01.00 activated.
eth2: 3c5x9 found at 0x220, BNC port, address  00 a0 24 be 47 3f, IRQ 5.
3c509.c:1.19b 08Nov2002 becker@scyld.com
sata_via 0000:00:0a.0: version 2.2
sata_via 0000:00:0a.0: routed to hard irq line 12
scsi0 : sata_via
scsi1 : sata_via
scsi2 : sata_via
ata1: SATA max UDMA/133 cmd 0x00016300 ctl 0x0001630a bmdma 0x00016700 irq 12
ata2: SATA max UDMA/133 cmd 0x00016400 ctl 0x0001640a bmdma 0x00016708 irq 12
ata3: PATA max UDMA/133 cmd 0x00016500 ctl 0x0001650a bmdma 0x00016710 irq 12
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 310)
ata3.00: ATA-7: ST3250823A, 3.03, max UDMA/100
ata3.00: 488397168 sectors, multi 16: LBA48 
ata3.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 2:0:0:0: Direct-Access     ATA      ST3250823A       3.03 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
pata_via 0000:00:07.1: version 0.3.1
scsi3 : pata_via
scsi4 : pata_via
ata4: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00016000 irq 14
ata5: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376 bmdma 0x00016008 irq 15
ata4.00: ATA-0: WDC AC21000H, 21.15T71, max MWDMA2
ata4.00: 2116800 sectors, multi 16: LBA 
ata4.00: configured for MWDMA2
scsi 3:0:0:0: Direct-Access     ATA      WDC AC21000H     21.1 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdc] 2116800 512-byte hardware sectors (1084 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 2116800 512-byte hardware sectors (1084 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
input: PC Speaker as /class/input/input0
md: raid1 personality registered for level 1
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (256 buckets, 2048 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input1
md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda2 ...
md: created md0
md: bind<sda2>
md: bind<sdb1>
md: running: <sdb1><sda2>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 132k freed
Adding 124984k swap on /dev/sdc2.  Priority:-1 extents:1 across:124984k
EXT3 FS on sdc1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on md0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth0: Setting Rx mode to 1 addresses.
PM: Writing back config space on device 0000:00:09.0 at offset 1 (was 82100007, writing 2100007)
eth1:  setting full-duplex.
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:40:97:c6:87/00:01:16:00:00/e0 tag 0 cdb 0x0 data 163840 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:df:d1:87/00:04:16:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:f0:6f:5a:88/00:03:16:00:00/e0 tag 0 cdb 0x0 data 516096 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/100
ata3: EH complete
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: limiting speed to UDMA/66:PIO4
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:c7:0e:89/00:04:16:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:07:14:89/00:04:16:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:1f:dd:89/00:04:16:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:07:e5:89/00:04:16:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:87:fb:a6/00:04:19:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd 35/00:00:e7:07:a7/00:04:19:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3: soft resetting port
ata3.00: configured for UDMA/66
ata3: EH complete
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--Boundary-00=_fyfyGKFD+nGaZP5--
