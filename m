Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbXEJXsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbXEJXsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 19:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762731AbXEJXsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 19:48:37 -0400
Received: from app2.redhotpenguin.com ([64.151.90.21]:42322 "EHLO
	redhotpenguin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762671AbXEJXse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 19:48:34 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 19:48:34 EDT
X-Spam-Check-By: app2.redhotpenguin.com
Message-ID: <4643ADC5.4020409@redhotpenguin.com>
Date: Thu, 10 May 2007 16:41:57 -0700
From: Fred Moyer <fred@redhotpenguin.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re:  Re: [2.6.21.1] SATA freeze
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
 >Gerhard Mack wrote:
 >> On Wed, 9 May 2007, Jeff Garzik wrote:
 >>> Gerhard Mack wrote:
 >>>> May  9 14:51:35 mgerhard kernel: ata1.00: exception Emask 0x0 SAct 
0x0 SErr
 >>>> 0x1800000 action 0x2 frozen
 >>>> May  9 14:51:35 mgerhard kernel: ata1.00: cmd
 >>>> 35/00:00:80:6d:c8/00:04:09:00:00/e0 tag 0 cdb 0x0 data 524288 out
 >>>> May  9 14:51:35 mgerhard kernel:          res
 >>>> 40/00:c8:68:65:c8/84:00:09:00:00/e0 Emask 0x4 (timeout)
 >>>> May  9 14:51:42 mgerhard kernel: ata1: port is slow to respond, 
please be
 >>>> patient (Status 0xd0)
 >>>>
 >>>> Anything I can do to figgure out what's causing this?
 > You're showing various flags set in the SError register, which
 > suggests you're having SATA communication problems with the drive. A
 > bad SATA cable or power problems would be a strong possibility.

I just joined the list today so apologies if this email breaks any email 
client post threading.

I have been seeing similar errors on two different systems.  I applied 
Robert's sata_nv patch posted to the list on May 5th, and approved today 
by Jeff Garzik.  I've taken several steps to insure that this isn't a 
faulty cable or drive issue.  This is running on a hp dl145g2.  Here is 
my lspci, dmesg, and relevant kernel config sections:


Linux version 2.6.21-gentoo (root@app2.redhotpenguin.com) (gcc version 
4.1.1 (Gentoo 4.1.1)) #6 SMP Sun May 6 16:44:40 PDT 2007
Command line: root=/dev/sda2
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 0000000000098800 (usable)
  BIOS-e820: 0000000000098800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000c2000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000bff20000 (usable)
  BIOS-e820: 00000000bff20000 - 00000000bff29000 (ACPI data)
  BIOS-e820: 00000000bff29000 - 00000000bff80000 (ACPI NVS)
  BIOS-e820: 00000000bff80000 - 00000000c0000000 (reserved)
  BIOS-e820: 00000000d8000000 - 00000000d8000400 (reserved)
  BIOS-e820: 00000000d8001000 - 00000000d8001400 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
Entering add_active_range(0, 0, 152) 0 entries of 256 used
Entering add_active_range(0, 256, 786208) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 256 used
end_pfn_map = 1310720
DMI present.
Entering add_active_range(0, 0, 152) 0 entries of 256 used
Entering add_active_range(0, 256, 786208) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1310720) 2 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   DMA32        4096 ->  1048576
   Normal    1048576 ->  1310720
early_node_map[3] active PFN ranges
     0:        0 ->      152
     0:      256 ->   786208
     0:  1048576 ->  1310720
On node 0 totalpages: 1048248
   DMA zone: 56 pages used for memmap
   DMA zone: 1138 pages reserved
   DMA zone: 2798 pages, LIFO batch:0
   DMA32 zone: 14280 pages used for memmap
   DMA32 zone: 767832 pages, LIFO batch:31
   Normal zone: 3584 pages used for memmap
   Normal zone: 258560 pages, LIFO batch:31
Intel MultiProcessor Specification v1.4
MPTABLE: OEM ID: AMD      MPTABLE: Product ID: HAMMER       MPTABLE: 
APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
I/O APIC #2 at 0xFEC00000.
I/O APIC #3 at 0xD8000000.
I/O APIC #4 at 0xD8001000.
Setting APIC routing to flat
Processors: 2
Nosave address range: 0000000000098000 - 0000000000099000
Nosave address range: 0000000000099000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000c2000
Nosave address range: 00000000000c2000 - 0000000000100000
Nosave address range: 00000000bff20000 - 00000000bff29000
Nosave address range: 00000000bff29000 - 00000000bff80000
Nosave address range: 00000000bff80000 - 00000000c0000000
Nosave address range: 00000000c0000000 - 00000000d8000000
Nosave address range: 00000000d8000000 - 00000000d8001000
Nosave address range: 00000000d8001000 - 00000000e0000000
Nosave address range: 00000000e0000000 - 00000000f0000000
Nosave address range: 00000000f0000000 - 00000000fec00000
Nosave address range: 00000000fec00000 - 00000000fee00000
Nosave address range: 00000000fee00000 - 00000000fee01000
Nosave address range: 00000000fee01000 - 00000000fff80000
Nosave address range: 00000000fff80000 - 0000000100000000
Allocating PCI resources starting at c2000000 (gap: c0000000:18000000)
PERCPU: Allocating 36608 bytes of per cpu data
Built 1 zonelists.  Total pages: 1029190
Kernel command line: root=/dev/sda2
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2009.287 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
CPU 0: aperture @ 233e000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 8000000
Memory: 4044456k/5242880k available (2259k kernel code, 148400k 
reserved, 1224k data, 240k init)
Calibrating delay using timer specific routine.. 4021.00 BogoMIPS 
(lpj=8042012)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
Freeing SMP alternatives: 28k freed
ExtINT not setup in hardware but reported by MP table
Using local APIC timer interrupts.
result 12558039
Detected 12.558 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4018.82 BogoMIPS 
(lpj=8037658)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
AMD Opteron(tm) Processor 246 stepping 01
Brought up 2 CPUs
migration_cost=558
NET: Registered protocol family 16
PCI: Using configuration type 1
SCSI subsystem initialized
libata version 2.20 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:01:05.0
PCI: Transparent bridge - 0000:00:09.0
PCI: Discovered primary peer bus 80 [IRQ]
PCI: Using IRQ router default [10de/0051] at 0000:00:01.0
PCI->APIC IRQ transform: 0000:00:02.0[A] -> IRQ 10
PCI->APIC IRQ transform: 0000:00:02.1[B] -> IRQ 11
PCI->APIC IRQ transform: 0000:00:08.0[A] -> IRQ 10
PCI->APIC IRQ transform: 0000:01:05.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:02:00.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:03:00.0[A] -> IRQ 10
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 8000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
PCI: Bridge: 0000:00:09.0
   IO window: disabled.
   MEM window: c9000000-c9ffffff
   PREFETCH window: d0000000-d7ffffff
PCI: Bridge: 0000:00:0c.0
   IO window: disabled.
   MEM window: ca000000-ca0fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
   IO window: disabled.
   MEM window: ca100000-ca1fffff
   PREFETCH window: disabled.
PCI: Bridge: 0000:00:0e.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
PCI: Bridge: 0000:80:01.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
PCI: Bridge: 0000:80:02.0
   IO window: disabled.
   MEM window: disabled.
   PREFETCH window: disabled.
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
0000:00:02.1 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
PCI: Found disabled HT MSI Mapping on 0000:00:0c.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0d.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Found disabled HT MSI Mapping on 0000:00:0e.0
PCI: Found enabled HT MSI Mapping on 0000:00:00.0
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
floppy0: no floppy controllers found
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: loaded (max 8 devices)
tg3.c:v3.75 (March 23, 2007)
PCI: Setting latency timer of device 0000:02:00.0 to 64
eth0: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 
10/100/1000Base-T Ethernet 00:18:71:e3:74:a7
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
PCI: Setting latency timer of device 0000:03:00.0 to 64
eth1: Tigon3 [partno(BCM95721) rev 4101 PHY(5750)] (PCI Express) 
10/100/1000Base-T Ethernet 00:18:71:e3:74:a6
eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[1]
eth1: dma_rwctrl[76180000] dma_mask[64-bit]
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE-CK804: IDE controller at PCI slot 0000:00:06.0
NFORCE-CK804: chipset revision 162
NFORCE-CK804: not 100% native mode: will probe irqs later
NFORCE-CK804: 0000:00:06.0 (rev a2) UDMA133 controller
     ide0: BM-DMA at 0x1400-0x1407, BIOS settings: hda:pio, hdb:pio
     ide1: BM-DMA at 0x1408-0x140f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
Probing IDE interface ide0...
Probing IDE interface ide1...
sata_nv 0000:00:08.0: version 3.3
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata1: SATA max UDMA/133 cmd 0xffffc20000012480 ctl 0xffffc200000124a0 
bmdma 0x0000000000011410 irq 10
ata2: SATA max UDMA/133 cmd 0xffffc20000012580 ctl 0xffffc200000125a0 
bmdma 0x0000000000011418 irq 10
scsi0 : sata_nv
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: ST3808110AS,   3.AJJ, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48
ata1.00: configured for UDMA/100
scsi1 : sata_nv
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: ST3808110AS,   3.AJJ, max UDMA/100
ata2.00: 156301488 sectors, multi 16: LBA48
ata2.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      ST3808110AS      n/a  PQ: 0 ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      ST3808110AS      n/a  PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
segs 61
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
Fusion MPT base driver 3.04.04
Copyright (c) 1999-2007 LSI Logic Corporation
Fusion MPT SPI Host driver 3.04.04
Fusion MPT SAS Host driver 3.04.04
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: sda2: orphan cleanup on readonly fs
ext3_orphan_cleanup: deleting unreferenced inode 1824426
ext3_orphan_cleanup: deleting unreferenced inode 1824259
ext3_orphan_cleanup: deleting unreferenced inode 1824258
EXT3-fs: sda2: 3 orphan inodes deleted
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 240k freed
EXT3 FS on sda2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2096472k swap on /dev/sda3.  Priority:-1 extents:1 across:2096472k
PM: Writing back config space on device 0000:02:00.0 at offset c (was 
263c0000, writing 0)
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is off for TX and off for RX.
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
123392 in
          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata2.00: cmd b0/db:f8:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
126976 in
          res 50/00:f8:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
violation)
ata2: soft resetting port
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: configured for UDMA/100
ata2: EH complete
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA



app2 ~ # lspci -v
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller 
(rev a3)
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, fast devsel, latency 0
         Capabilities: [44] HyperTransport: Slave or Primary Interface
         Capabilities: [e0] HyperTransport: MSI Mapping

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, fast devsel, latency 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: 66MHz, fast devsel
         I/O ports at 1000 [size=32]
         I/O ports at 5000 [size=64]
         I/O ports at 5040 [size=64]
         Capabilities: [44] Power Management version 2

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) 
(prog-if 10 [OHCI])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
         Memory at c8000000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [44] Power Management version 2

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3) 
(prog-if 20 [EHCI])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 11
         Memory at c8001000 (32-bit, non-prefetchable) [size=256]
         Capabilities: [44] Debug port
         Capabilities: [80] Power Management version 2

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev a2) (prog-if 8a 
[Master SecP PriP])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, fast devsel, latency 0
         [virtual] Memory at 000001f0 (32-bit, non-prefetchable) 
[disabled] [size=8]
         [virtual] Memory at 000003f0 (type 3, non-prefetchable) 
[disabled] [size=1]
         [virtual] Memory at 00000170 (32-bit, non-prefetchable) 
[disabled] [size=8]
         [virtual] Memory at 00000370 (type 3, non-prefetchable) 
[disabled] [size=1]
         I/O ports at 1400 [size=16]
         Capabilities: [44] Power Management version 2

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev a3) (prog-if 85 [Master SecO PriO])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 10
         I/O ports at 1430 [size=8]
         I/O ports at 1424 [size=4]
         I/O ports at 1428 [size=8]
         I/O ports at 1420 [size=4]
         I/O ports at 1410 [size=16]
         Memory at c8002000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [44] Power Management version 2

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) 
(prog-if 01 [Subtractive decode])
         Flags: bus master, 66MHz, fast devsel, latency 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
         Memory behind bridge: c9000000-c9ffffff
         Prefetchable memory behind bridge: d0000000-d7ffffff

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) 
(prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
         Memory behind bridge: ca000000-ca0fffff
         Capabilities: [40] Power Management version 2
         Capabilities: [48] Message Signalled Interrupts: 64bit+ 
Queue=0/1 Enable+
         Capabilities: [58] HyperTransport: MSI Mapping
         Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) 
(prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
         Memory behind bridge: ca100000-ca1fffff
         Capabilities: [40] Power Management version 2
         Capabilities: [48] Message Signalled Interrupts: 64bit+ 
Queue=0/1 Enable+
         Capabilities: [58] HyperTransport: MSI Mapping
         Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) 
(prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
         Capabilities: [40] Power Management version 2
         Capabilities: [48] Message Signalled Interrupts: 64bit+ 
Queue=0/1 Enable+
         Capabilities: [58] HyperTransport: MSI Mapping
         Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
         Flags: fast devsel
         Capabilities: [80] HyperTransport: Host or Secondary Interface
         Capabilities: [a0] HyperTransport: Host or Secondary Interface
         Capabilities: [c0] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
         Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
         Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
         Flags: fast devsel

00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
         Flags: fast devsel
         Capabilities: [80] HyperTransport: Host or Secondary Interface
         Capabilities: [a0] HyperTransport: Host or Secondary Interface
         Capabilities: [c0] HyperTransport: Host or Secondary Interface

00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
         Flags: fast devsel

00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
         Flags: fast devsel

00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
         Flags: fast devsel

01:05.0 VGA compatible controller: nVidia Corporation NV11 [GeForce2 
MX/MX 400] (rev b2) (prog-if 00 [VGA])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 11
         Memory at c9000000 (32-bit, non-prefetchable) [size=16M]
         Memory at d0000000 (32-bit, prefetchable) [size=128M]
         [virtual] Expansion ROM at c2000000 [disabled] [size=64K]
         Capabilities: [60] Power Management version 2

02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721 
Gigabit Ethernet PCI Express (rev 11)
         Subsystem: Hewlett-Packard Company Unknown device 3209
         Flags: bus master, fast devsel, latency 0, IRQ 11
         Memory at ca000000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Vital Product Data
         Capabilities: [58] Message Signalled Interrupts: 64bit+ 
Queue=0/3 Enable-
         Capabilities: [d0] Express Endpoint IRQ 0

03:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721 
Gigabit Ethernet PCI Express (rev 11)
         Subsystem: Hewlett-Packard Company Unknown device 3209
         Flags: bus master, fast devsel, latency 0, IRQ 10
         Memory at ca100000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Vital Product Data
         Capabilities: [58] Message Signalled Interrupts: 64bit+ 
Queue=0/3 Enable-
         Capabilities: [d0] Express Endpoint IRQ 0

80:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge 
(rev 12) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 64
         Bus: primary=80, secondary=81, subordinate=85, sec-latency=64
         Capabilities: [60] PCI-X bridge device
         Capabilities: [b8] HyperTransport: Interrupt Discovery and 
Configuration
         Capabilities: [c0] HyperTransport: Slave or Primary Interface
         Capabilities: [f4] HyperTransport: MSI Mapping

80:01.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 12) 
(prog-if 10 [IO-APIC])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, medium devsel, latency 0

80:02.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8132 PCI-X Bridge 
(rev 12) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 64
         Bus: primary=80, secondary=86, subordinate=8a, sec-latency=64
         Capabilities: [60] PCI-X bridge device
         Capabilities: [b8] HyperTransport: Interrupt Discovery and 
Configuration
         Capabilities: [c0] HyperTransport: Revision ID: 2.00
         Capabilities: [f4] HyperTransport: MSI Mapping

80:02.1 PIC: Advanced Micro Devices [AMD] AMD-8132 PCI-X IOAPIC (rev 12) 
(prog-if 10 [IO-APIC])
         Subsystem: Hewlett-Packard Company Unknown device 3207
         Flags: bus master, medium devsel, latency 0


app2 linux-2.6.21-gentoo # egrep -i '(sata|scsi)' .config
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# SCSI device support
CONFIG_SCSI=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set
# SCSI support type (disk, tape, CD-ROM)
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
# SCSI Transports
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
# CONFIG_SCSI_SAS_LIBSAS is not set
# SCSI low-level drivers
# CONFIG_ISCSI_TCP is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_SATA_NV=y
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INTEL_COMBINED=y
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
