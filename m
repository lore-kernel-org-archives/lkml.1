Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYGWXfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYGWXfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbYGWXfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:35:24 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:22529 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333AbYGWXfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:35:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAMhch0iWZWaT/2dsb2JhbACBWrE9RQ
X-IronPort-AV: E=Sophos;i="4.31,240,1215354600"; 
   d="scan'208";a="165495123"
Date: Thu, 24 Jul 2008 09:05:09 +0930
From: Kevin Shanahan <kmshanah@disenchant.net>
To: linux-kernel@vger.kernel.org
Subject: libata timeout, MCE and kernel panic
Message-ID: <20080723233509.GJ3930@cubit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I had a server reboot overnight (still need to find the cause of that,
nothing in the logs but I suspect OOM cause by our apache setup), but
encountered another problem when I tried to bring it back up this
morning.

The system has a RAID5 array with four 400GB SATA disks, which it
noticed was dirty so reconstruction began. This raid device is an lvm
pv, with several ext3 filesystems. When the init scripts went to mount
the largest filesystem (approx 650GB, about 85% full I think), journal
recovery was required. It seems the journal recovery combined with the
md device reconstruction was enough to cause an ata command
timeout. After that I saw several MCEs and the kernel paniced.

I don't have a serial console handy atm, so I just took a photo of the
console:
  http://disenchant.net/tmp/dsc00028.jpg

I've since got the server back up again by preventing that fs from
mounting at boot time. Is this a bug of some kind, or have just dumbly
misconfigured something? Full dmesg below.

TIA,
Kevin.
--

Linux version 2.6.25.10 (kmshanah@debian) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP PREEMPT Fri Jul 11 12:49:53 CST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dfcf0000 (usable)
 BIOS-e820: 00000000dfcf0000 - 00000000dfd96000 (ACPI NVS)
 BIOS-e820: 00000000dfd96000 - 00000000dfdfd000 (usable)
 BIOS-e820: 00000000dfdfd000 - 00000000dfe5f000 (reserved)
 BIOS-e820: 00000000dfe5f000 - 00000000dfe68000 (usable)
 BIOS-e820: 00000000dfe68000 - 00000000dfedf000 (ACPI NVS)
 BIOS-e820: 00000000dfedf000 - 00000000dfee5000 (usable)
 BIOS-e820: 00000000dfee5000 - 00000000dfeff000 (ACPI data)
 BIOS-e820: 00000000dfeff000 - 00000000dff00000 (usable)
 BIOS-e820: 00000000dff00000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fff80000 - 00000000fff8c000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
Warning only 4GB will be used.
Use a HIGHMEM64G enabled kernel.
3200MB HIGHMEM available.
896MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00fd270] 000fd270
Entering add_active_range(0, 0, 1048576) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->  1048576
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->  1048576
On node 0 totalpages: 1048576
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 6400 pages used for memmap
  HighMem zone: 812800 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI 2.5 present.
ACPI: RSDP 000F03C0, 0024 (r2 INTEL )
ACPI: XSDT DFEFE120, 00AC (r1 INTEL  S3200SHC        0 INTL  1000013)
ACPI: SLIC DFEFC000, 0176 (r1 INTEL  S3200SHC        2 INTL  1000013)
ACPI: FACP DFEFA000, 00F4 (r3 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: DSDT DFEF4000, 568D (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: FACS DFE68000, 0040
ACPI: APIC DFEF3000, 0084 (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: WDDT DFEF2000, 0040 (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: MCFG DFEF1000, 003C (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: HPET DFEF0000, 0038 (r1 INTEL  S3200SHC        1 MSFT  1000013)
ACPI: SPCR DFEEF000, 0050 (r1 INTEL  S3200SHC        0 MSFT  1000013)
ACPI: DMAR DFEEE000, 0110 (r1 INTEL  S3200SHC        1 MSFT  1000013)
ACPI: SSDT DFEED000, 0175 (r1 INTEL   Cpu0Ist       10 MSFT  1000013)
ACPI: SSDT DFEEC000, 0175 (r1 INTEL   Cpu1Ist       10 MSFT  1000013)
ACPI: SSDT DFEEB000, 0175 (r1 INTEL   Cpu2Ist       10 MSFT  1000013)
ACPI: SSDT DFEEA000, 0175 (r1 INTEL   Cpu3Ist       10 MSFT  1000013)
ACPI: SSDT DFEE9000, 01BC (r1 INTEL     CpuPm       10 MSFT  1000013)
ACPI: HEST DFEE8000, 00A8 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: BERT DFEE7000, 0030 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: ERST DFEE6000, 0230 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: EINJ DFEE5000, 0130 (r1 INTEL  S3200SHC        1 INTL        1)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
Processor #2 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Processor #3 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
ACPI: IOAPIC (id[0x05] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 5, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e1000000 (gap: e0000000:10000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1040384
Kernel command line: root=/dev/sda3 ro
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2394.075 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3627644k/4194304k available (2699k kernel code, 38600k reserved, 1527k data, 352k init, 2749852k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0528000 - 0xc0580000   ( 352 kB)
      .data : 0xc03a2eac - 0xc0520dbc   (1527 kB)
      .text : 0xc0100000 - 0xc03a2eac   (2699 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 4792.99 BogoMIPS (lpj=7983988)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 14k freed
ACPI: Core revision 20070126
CPU0: Intel(R) Xeon(R) CPU           X3220  @ 2.40GHz stepping 0b
Booting processor 1/1 ip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4789.21 BogoMIPS (lpj=7979550)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Xeon(R) CPU           X3220  @ 2.40GHz stepping 0b
Booting processor 2/2 ip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4789.24 BogoMIPS (lpj=7979589)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel(R) Xeon(R) CPU           X3220  @ 2.40GHz stepping 0b
Booting processor 3/3 ip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4789.24 BogoMIPS (lpj=7979592)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel(R) Xeon(R) CPU           X3220  @ 2.40GHz stepping 0b
Total of 4 processors activated (19161.69 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
net_namespace: 452 bytes
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  8846.400 MB/sec
xor: using function: pIII_sse (8846.400 MB/sec)
NET: Registered protocol family 16
No dock devices found.
EISA bus registered
ACPI: bus type pci registered
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
ACPI: RTC can wake from S4
system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
system 00:01: iomem range 0xc0000-0xdffff could not be reserved
system 00:01: iomem range 0xe0000-0xfffff could not be reserved
system 00:01: iomem range 0xffc00000-0xffffffff could not be reserved
system 00:06: ioport range 0x500-0x53f has been reserved
system 00:06: ioport range 0x400-0x47f has been reserved
system 00:06: ioport range 0xca0-0xcaf has been reserved
system 00:06: ioport range 0x680-0x6ff has been reserved
system 00:06: ioport range 0x800-0x87f has been reserved
system 00:06: ioport range 0x600-0x61f has been reserved
PCI: Bridge: 0000:01:00.0
  IO window: 2000-2fff
  MEM window: 0xe1a00000-0xe1afffff
  PREFETCH window: 0x00000000e1d00000-0x00000000e1dfffff
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: 0xe1a00000-0xe1bfffff
  PREFETCH window: 0x00000000e1d00000-0x00000000e1dfffff
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: 0xe1000000-0xe18fffff
  PREFETCH window: 0x00000000e0000000-0x00000000e0ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 1000-1fff
  MEM window: 0xe1900000-0xe19fffff
  PREFETCH window: 0x00000000e1e00000-0x00000000e1efffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:03:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: ACPI0007:03 is registered as cooling_device3
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
ppdev: user-space parallel port driver
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
FDC 0 is a National Semiconductor PC87306
brd: module loaded
loop: module loaded
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 18 (level, low) -> IRQ 18
e1000: 0000:04:02.0: e1000_probe: (PCI:33MHz:32-bit) 00:15:17:26:b1:c7
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
eth1: (PCI Express:2.5GB/s:Width x1) 00:15:17:26:b1:c9
eth1: Intel(R) PRO/1000 Network Connection
eth1: MAC: 5, PHY: 6, PBA No: 0070ff-0ff
sk98lin: driver has been replaced by the skge driver and is scheduled for removal
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Adaptec aacraid driver 1.1-5[2455]-ms
st: Version 20080221, fixed bufsize 32768, s/g segs 256
Driver 'st' needs updating - please use bus_type methods
Driver 'sd' needs updating - please use bus_type methods
SCSI Media Changer driver v0.25 
Driver 'ch' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 21 (level, low) -> IRQ 21
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x3430 irq 14
ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x3438 irq 15
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD3200AAKS-75VYA0, 12.01B02, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-7 12.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 21 (level, low) -> IRQ 21
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
PCI: Setting latency timer of device 0000:00:1f.5 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x3448 ctl 0x3464 bmdma 0x3410 irq 21
ata4: SATA max UDMA/133 cmd 0x3440 ctl 0x3460 bmdma 0x3418 irq 21
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
sata_promise 0000:04:01.0: version 2.12
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 17 (level, low) -> IRQ 17
scsi4 : sata_promise
scsi5 : sata_promise
scsi6 : sata_promise
scsi7 : sata_promise
ata5: SATA max UDMA/133 mmio m4096@0xe1960000 port 0xe1960200 irq 17
ata6: SATA max UDMA/133 mmio m4096@0xe1960000 port 0xe1960280 irq 17
ata7: SATA max UDMA/133 mmio m4096@0xe1960000 port 0xe1960300 irq 17
ata8: SATA max UDMA/133 mmio m4096@0xe1960000 port 0xe1960380 irq 17
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7: WDC WD4000YR-01PLB0, 01.06A01, max UDMA/133
ata5.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/133
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: ATA-7: WDC WD4000YR-01PLB0, 01.06A01, max UDMA/133
ata6.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/133
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata7.00: ATA-7: WDC WD4000YR-01PLB0, 01.06A01, max UDMA/133
ata7.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata7.00: configured for UDMA/133
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata8.00: ATA-7: WDC WD4000YR-01PLB0, 01.06A01, max UDMA/133
ata8.00: 781422768 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata8.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD4000YR-01P 01.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 4:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 5:0:0:0: Direct-Access     ATA      WDC WD4000YR-01P 01.0 PQ: 0 ANSI: 5
sd 5:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdc] 781422768 512-byte hardware sectors (400088 MB)
sd 5:0:0:0: [sdc] Write Protect is off
sd 5:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 5:0:0:0: [sdc] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg2 type 0
scsi 6:0:0:0: Direct-Access     ATA      WDC WD4000YR-01P 01.0 PQ: 0 ANSI: 5
sd 6:0:0:0: [sdd] 781422768 512-byte hardware sectors (400088 MB)
sd 6:0:0:0: [sdd] Write Protect is off
sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdd] 781422768 512-byte hardware sectors (400088 MB)
sd 6:0:0:0: [sdd] Write Protect is off
sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 6:0:0:0: [sdd] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg3 type 0
scsi 7:0:0:0: Direct-Access     ATA      WDC WD4000YR-01P 01.0 PQ: 0 ANSI: 5
sd 7:0:0:0: [sde] 781422768 512-byte hardware sectors (400088 MB)
sd 7:0:0:0: [sde] Write Protect is off
sd 7:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sde] 781422768 512-byte hardware sectors (400088 MB)
sd 7:0:0:0: [sde] Write Protect is off
sd 7:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 7:0:0:0: [sde] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg4 type 0
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
ACPI: PCI Interrupt 0000:02:08.0[A] -> GSI 16 (level, low) -> IRQ 16
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1020A A1: Capabilities={Initiator,Target}
scsi8 : ioc0: LSI53C1020A A1, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
scsi 8:0:0:0: Sequential-Access HP       Ultrium 3-SCSI   D22D PQ: 0 ANSI: 3
 target8:0:0: Beginning Domain Validation
 target8:0:0: Ending Domain Validation
 target8:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI PCOMP (6.25 ns, offset 64)
st 8:0:0:0: Attached scsi tape st0
st 8:0:0:0: st0: try direct i/o: yes (alignment 4 B)
st 8:0:0:0: Attached scsi generic sg5 type 1
Fusion MPT misc device (ioctl) driver 3.04.06
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 17, io mem 0xe1c21400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe1c21000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 18, io base 0x000030c0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030a0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 17, io base 0x00003080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003060
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003040
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003020
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input3
rtc_cmos: probe of 00:03 failed with error -16
input: ImExPS/2 Generic Explorer Mouse as /class/input/input4
md: raid1 personality registered for level 1
raid6: int32x1    825 MB/s
raid6: int32x2    765 MB/s
raid6: int32x4    656 MB/s
raid6: int32x8    571 MB/s
raid6: mmxx1     2593 MB/s
raid6: mmxx2     2721 MB/s
raid6: sse1x1    1743 MB/s
raid6: sse1x2    2129 MB/s
raid6: sse2x1    3223 MB/s
raid6: sse2x2    3510 MB/s
raid6: using algorithm sse2x2 (3510 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
EISA: Probing bus 0 at eisa.0
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
GACT probability on
Mirror/redirect action on
u32 classifier
    Actions configured 
IPv4 over IPv4 tunneling driver
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Bridge firewalling registered
Ebtables v2.0 registered
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Starting balanced_irq
Using IPI Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
md: Autodetecting RAID arrays.
md: Scanned 4 and added 4 devices.
md: autorun ...
md: considering sde1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md: created md5
md: bind<sdb1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: running: <sde1><sdd1><sdc1><sdb1>
md: md5: raid array is not clean -- starting background reconstruction
raid5: device sde1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: device sdb1 operational as raid disk 0
raid5: allocated 4204kB for md5
raid5: raid level 5 set md5 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdb1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdd1
 disk 3, o:1, dev:sde1
md: ... autorun DONE.
md: resync of RAID array md5
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
md: using 128k window, over a total of 390708736 blocks.
md: resuming resync of md5 from checkpoint.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 352k freed
Adding 1951888k swap on /dev/sda4.  Priority:-1 extents:1 across:1951888k
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
warning: `ntpd' uses 32-bit capabilities (legacy support in use)
