Return-Path: <linux-kernel-owner+w=401wt.eu-S1757721AbYEMBwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbYEMBwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756702AbYEMBwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:52:11 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52575 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbYEMBwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:52:08 -0400
Subject: Oops on -rc2-git1, possibly md_raid1 or xfs related. (Was: Re:
	Linux 2.6.26-rc2)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 13 May 2008 03:49:18 +0200
Message-Id: <1210643358.1093.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just booted -rc2-git1, and got an oops(entier dmesg):
Linux version 2.6.26-rc2-git1 (root@quadstation) (gcc version 4.3.0
(Gentoo 4.3.0 p1.1) ) #1 SMP PREEMPT Tue May 13 03:32:40 CEST 2008
Command line: root=/dev/md1
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
 BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
 BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
 BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
max_pfn_mapped = 1245184
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI 2.4 present.
ACPI: RSDP 000F6EB0, 0014 (r0 GBT   )
ACPI: RSDT CFEE3040, 0034 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP CFEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT CFEE3180, 4C2E (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS CFEE0000, 0040
ACPI: HPET CFEE7F00, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG CFEE7F80, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC CFEE7E00, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
Entering add_active_range(0, 0, 158) 0 entries of 256 used
Entering add_active_range(0, 256, 851680) 1 entries of 256 used
Entering add_active_range(0, 1048576, 1245184) 2 entries of 256 used
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-64dfb3] TEXT DATA BSS
  early res: 3 [9e800-fffff] BIOS reserved
  early res: 4 [8000-dfff] PGTABLE
 [ffffe20000000000-ffffe200043fffff] PMD ->
[ffff81000c200000-ffff8100105fffff] on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1245184
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      158
    0:      256 ->   851680
    0:  1048576 ->  1245184
On node 0 totalpages: 1048190
  DMA zone: 56 pages used for memmap
  DMA zone: 1209 pages reserved
  DMA zone: 2733 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 833304 pages, LIFO batch:31
  Normal zone: 2688 pages used for memmap
  Normal zone: 193920 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at e6000000 (gap: e4000000:1ac00000)
PERCPU: Allocating 33988 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 4
Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
1029957
Kernel command line: root=/dev/md1
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 3200.110 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x163f000 - 0x563f000
Memory: 4045556k/4980736k available (2759k kernel code, 146580k
reserved, 976k data, 252k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 6403.45 BogoMIPS
(lpj=3201728)
Security Framework initialized
Capability LSM initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Freeing SMP alternatives: 19k freed
ACPI: Core revision 20080321
CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
Using local APIC timer interrupts.
APIC timer calibration result 25000857
Detected 25.000 MHz APIC timer.
Booting processor 1/3 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6400.07 BogoMIPS
(lpj=3200038)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6400.04 BogoMIPS
(lpj=3200022)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/2 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6400.04 BogoMIPS
(lpj=3200024)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 6144K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (25603.62 BogoMIPS).
net_namespace: 360 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e3ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0,
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 9 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x290-0x29f has been reserved
system 00:01: ioport range 0x800-0x87f has been reserved
system 00:01: ioport range 0x290-0x294 has been reserved
system 00:01: ioport range 0x880-0x88f has been reserved
system 00:09: ioport range 0x400-0x4bf could not be reserved
system 00:0a: iomem range 0xe0000000-0xe3ffffff could not be reserved
system 00:0b: iomem range 0xd1e00-0xd3fff has been reserved
system 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0b: iomem range 0xfc000-0xfffff could not be reserved
system 00:0b: iomem range 0xcfee0000-0xcfefffff could not be reserved
system 00:0b: iomem range 0x0-0x9ffff could not be reserved
system 00:0b: iomem range 0x100000-0xcfedffff could not be reserved
system 00:0b: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0b: iomem range 0xfed10000-0xfed1dfff could not be reserved
system 00:0b: iomem range 0xfed20000-0xfed8ffff could not be reserved
system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0b: iomem range 0xffb00000-0xffb7ffff could not be reserved
system 00:0b: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0b: iomem range 0xe0000-0xeffff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xe4000000-0xe6ffffff
  PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
PCI: Bridge: 0000:00:06.0
  IO window: a000-afff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: b000-bfff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: c000-cfff
  MEM window: 0xe7000000-0xe7ffffff
  PREFETCH window: 0x00000000e9000000-0x00000000e90fffff
PCI: Bridge: 0000:00:1c.5
  IO window: d000-dfff
  MEM window: 0xe8000000-0xe8ffffff
  PREFETCH window: 0x00000000e9100000-0x00000000e91fffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xe9200000-0xe92fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:06.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
SGI XFS with ACLs, security attributes, large block/inode numbers, no
debug enabled
msgmni has been set to 7902 for ipc namespace ffffffff8058c100
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie03]
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
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
Allocate Port Service[0000:00:1c.5:pcie03]
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 0
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA
mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum
part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306100 irq 378
ata2: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306180 irq 378
ata3: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306200 irq 378
ata4: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306280 irq 378
ata5: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306300 irq 378
ata6: SATA max UDMA/133 abar m2048@0xe9306000 port 0xe9306380 irq 378
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6: ST3500320NS, SN04, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0
ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST3500320NS      SN04 PQ: 0
ANSI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 1:0:0:0: [sdb] Attached SCSI disk
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
md: raid1 personality registered for level 1
cpuidle: using governor ladder
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
input: AT Translated Set 2 keyboard as /class/input/input0
md: Autodetecting RAID arrays.
md: Scanned 6 and added 6 devices.
md: autorun ...
md: considering sdb3 ...
md:  adding sdb3 ...
md: sdb2 has different UUID to sdb3
md: sdb1 has different UUID to sdb3
md:  adding sda3 ...
md: sda2 has different UUID to sdb3
md: sda1 has different UUID to sdb3
md: created md2
md: bind<sda3>
md: bind<sdb3>
md: running: <sdb3><sda3>
raid1: raid set md2 active with 2 out of 2 mirrors
md: considering sdb2 ...
md:  adding sdb2 ...
md: sdb1 has different UUID to sdb2
md:  adding sda2 ...
md: sda1 has different UUID to sdb2
md: created md1
md: bind<sda2>
md: bind<sdb2>
md: running: <sdb2><sda2>
raid1: raid set md1 active with 2 out of 2 mirrors
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: ... autorun DONE.
Filesystem "md1": Disabling barriers, not supported by the underlying
device
XFS mounting filesystem md1
------------[ cut here ]------------
WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x71/0xa0()
Modules linked in:
Pid: 460, comm: md1_raid1 Not tainted 2.6.26-rc2-git1 #1

Call Trace:
 [<ffffffff80232b04>] warn_on_slowpath+0x64/0xc0
 [<ffffffff803609a9>] __next_cpu+0x19/0x30
 [<ffffffff8022ac8c>] find_busiest_group+0x22c/0x8d0
 [<ffffffff803551a1>] blk_remove_plug+0x71/0xa0
 [<ffffffff804219fb>] flush_pending_writes+0x3b/0x90
 [<ffffffff80421b4c>] raid1d+0x4c/0xf60
 [<ffffffff8022f2fb>] hrtick_set+0x7b/0x160
 [<ffffffff804acb50>] thread_return+0x5e/0x57e
 [<ffffffff804ad32d>] schedule_timeout+0xad/0xf0
 [<ffffffff804299e7>] md_thread+0x47/0x120
 [<ffffffff80248df0>] autoremove_wake_function+0x0/0x30
 [<ffffffff804299a0>] md_thread+0x0/0x120
 [<ffffffff80248a47>] kthread+0x47/0x90
 [<ffffffff8022fe87>] schedule_tail+0x27/0x60
 [<ffffffff8020c598>] child_rip+0xa/0x12
 [<ffffffff80248a00>] kthread+0x0/0x90
 [<ffffffff8020c58e>] child_rip+0x0/0x12

---[ end trace a97097b29774f236 ]---
Ending clean XFS mount for filesystem: md1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 252k freed
Real Time Clock Driver v1.12ac
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe9305000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input2
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: ACPI0007:03 is registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI: Power Button (CM) [PWRB]
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe9304000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 6 ports detected
r8169 Gigabit Ethernet driver 2.2LK loaded
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
eth0: RTL8168c/8111c at 0xffffc20000078000, 00:1d:7d:06:7b:39, XID
3c2000c0 IRQ 377
r8169 Gigabit Ethernet driver 2.2LK loaded
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:05:00.0 to 64
eth1: RTL8168c/8111c at 0xffffc2000007a000, 00:1d:7d:06:75:d8, XID
3c2000c0 IRQ 376
ACPI: PCI Interrupt 0000:06:06.0[A] -> GSI 18 (level, low) -> IRQ 18
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]
MMIO=[e9204000-e92047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Filesystem "md1": Disabling barriers, not supported by the underlying
device
fuse init (API version 7.9)
input: ImPS/2 Logitech Wheel Mouse as /class/input/input3
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000ee74800001d7d]
r8169: eth0: link up
r8169: eth0: link up
it87: Found IT8718F chip at 0x290, revision 5
it87: in3 is VCC (+5V)
coretemp coretemp.0: Using relative temperature scale!
coretemp coretemp.1: Using relative temperature scale!
coretemp coretemp.2: Using relative temperature scale!
coretemp coretemp.3: Using relative temperature scale!

The system appeared to work, for the few minutes i had it running,
before i went back to .25.

On Mon, 2008-05-12 at 07:55 -0700, Linus Torvalds wrote:
<snip>

