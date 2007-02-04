Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbXBDDAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbXBDDAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 22:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXBDDAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 22:00:39 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:54794 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbXBDDAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 22:00:37 -0500
Subject: bug at startup after freeze
From: Lionel Landwerlin <landwer@free.fr>
Reply-To: landwer@free.fr
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sun, 04 Feb 2007 04:00:34 +0100
Message-Id: <1170558034.5423.23.camel@cocoduo>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm giving the whole log, bug trace is at the end. I had got this after
a box freeze. The bug appears when the kernel is mounting the root
partition. I'm using ext3 for my root partition and as I did not see any
fix for ext3/vfs about that problem, I'm reporting it here.
The box is a macbook 2GHz x86.

Inspecting /boot/System.map-2.6.19.2-mactel
Loaded 24013 symbols from /boot/System.map-2.6.19.2-mactel.
Symbols match kernel version 2.6.19.
No module symbols loaded - kernel modules not enabled. 
Linux version 2.6.19.2-mactel (root@cocoduo) (gcc version 4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)) #2 SMP Mon Jan 22 11:08:41 CET 2007
BIOS-provided physical RAM map:
BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
BIOS-e820: 0000000000100000 - 000000007dfdc000 (usable)
BIOS-e820: 000000007dfdc000 - 000000007e1dd000 (ACPI NVS)
BIOS-e820: 000000007e1dd000 - 000000007eebf000 (ACPI data)
BIOS-e820: 000000007eebf000 - 000000007eeef000 (ACPI NVS)
BIOS-e820: 000000007eeef000 - 000000007ef00000 (ACPI data)
BIOS-e820: 000000007ef00000 - 0000000080000000 (reserved)
BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
1119MB HIGHMEM available.
896MB LOWMEM available.
Entering add_active_range(0, 0, 516060) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   516060
early_node_map[1] active PFN ranges
    0:        0 ->   516060
On node 0 totalpages: 516060
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2239 pages used for memmap
  HighMem zone: 284445 pages, LIFO batch:31
DMI 2.4 present.
ACPI: RSDP (v002 APPLE                                 ) @ 0x000fe020
ACPI: XSDT (v001 APPLE   Apple00 0x00000061      0x01000013) @ 0x7eefd120
ACPI: FADT (v003 APPLE   Apple00 0x00000061 Loki 0x0000005f) @ 0x7eefb000
ACPI: HPET (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eefa000
ACPI: MADT (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef9000
ACPI: MCFG (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef8000
ACPI: ASF! (v032 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef7000
ACPI: SBST (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef6000
ACPI: ECDT (v001 APPLE   Apple00 0x00000001 Loki 0x0000005f) @ 0x7eef5000
ACPI: SSDT (v001 APPLE   SataPri 0x00001000 INTL 0x20050309) @ 0x7eebc000
ACPI: SSDT (v001 APPLE   SataSec 0x00001000 INTL 0x20050309) @ 0x7eebb000
ACPI: SSDT (v001 APPLE     CpuPm 0x00003000 INTL 0x20050309) @ 0x7eeef000
ACPI: DSDT (v001 APPLE   MacBook 0x00010001 INTL 0x20050309) @ 0x00000000
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
Detected 2129.472 MHz processor.
Built 1 zonelists.  Total pages: 512029
Kernel command line: root=/dev/sda1 ro lpj=8000000 quiet splash
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2036768k/2064240k available (1956k kernel code, 26144k reserved, 1125k data, 312k init, 1146736k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0409000 - 0xc0457000   ( 312 kB)
      .data : 0xc02e93e1 - 0xc0402b74   (1125 kB)
      .text : 0xc0100000 - 0xc02e93e1   (1956 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Using HPET for base-timer
Calibrating delay loop (skipped)... 4000.00 BogoMIPS preset
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00000140 0000c1a9 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
CPU0: Intel Genuine Intel(R) CPU            1500  @ 2.00GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay loop (skipped)... 4000.00 BogoMIPS preset
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00000140 0000c1a9 00000000 00000000
CPU1: Intel Genuine Intel(R) CPU            1500  @ 2.00GHz stepping 08
Total of 2 processors activated (8000.00 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization across 2 CPUs: passed.
Brought up 2 CPUs
migration_cost=60
checking if image is initramfs... it is
Freeing initrd memory: 5285k freed
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 10 devices
PnPBIOS: Disabled by ACPI PNP
intel_rng: FWH not detected
PCI: Using ACPI for IRQ routing
Feb  4 03:28:46 cocoduo kernel: [    0.690909] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
Feb  4 03:28:46 cocoduo kernel: [    0.691667] PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
Feb  4 03:28:46 cocoduo kernel: [    0.691674] PCI: Bridge: 0000:00:1c.0
Feb  4 03:28:46 cocoduo kernel: [    0.691676]   IO window: 1000-1fff
Feb  4 03:28:46 cocoduo kernel: [    0.691682]   MEM window: 90200000-902fffff
Feb  4 03:28:46 cocoduo kernel: [    0.691686]   PREFETCH window: 90500000-905fffff
Feb  4 03:28:46 cocoduo kernel: [    0.691690] PCI: Bridge: 0000:00:1c.1
Feb  4 03:28:46 cocoduo kernel: [    0.691692]   IO window: disabled.
Feb  4 03:28:46 cocoduo kernel: [    0.691697]   MEM window: 90100000-901fffff
Feb  4 03:28:46 cocoduo kernel: [    0.691700]   PREFETCH window: disabled.
Feb  4 03:28:46 cocoduo kernel: [    0.691704] PCI: Bridge: 0000:00:1e.0
Feb  4 03:28:46 cocoduo kernel: [    0.691706]   IO window: disabled.
Feb  4 03:28:46 cocoduo kernel: [    0.691711]   MEM window: 90000000-900fffff
Feb  4 03:28:46 cocoduo kernel: [    0.691714]   PREFETCH window: disabled.
Feb  4 03:28:46 cocoduo kernel: [    0.691737] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
Feb  4 03:28:46 cocoduo kernel: [    0.691743] PCI: Setting latency timer of device 0000:00:1c.0 to 64
Feb  4 03:28:46 cocoduo kernel: [    0.691761] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 17
Feb  4 03:28:46 cocoduo kernel: [    0.691766] PCI: Setting latency timer of device 0000:00:1c.1 to 64
Feb  4 03:28:46 cocoduo kernel: [    0.691777] PCI: Setting latency timer of device 0000:00:1e.0 to 64
Feb  4 03:28:46 cocoduo kernel: [    0.691800] NET: Registered protocol family 2
Feb  4 03:28:46 cocoduo kernel: [    0.741550] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb  4 03:28:46 cocoduo kernel: [    0.741642] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Feb  4 03:28:46 cocoduo kernel: [    0.742850] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Feb  4 03:28:46 cocoduo kernel: [    0.743543] TCP: Hash tables configured (established 131072 bind 65536)
Feb  4 03:28:46 cocoduo kernel: [    0.743546] TCP reno registered
Feb  4 03:28:46 cocoduo kernel: [    0.744078] audit: initializing netlink socket (disabled)
Feb  4 03:28:46 cocoduo kernel: [    0.744093] audit(1170556096.060:1): initialized
Feb  4 03:28:46 cocoduo kernel: [    0.744171] highmem bounce pool size: 64 pages
Feb  4 03:28:46 cocoduo kernel: [    0.744250] VFS: Disk quotas dquot_6.5.1
Feb  4 03:28:46 cocoduo kernel: [    0.744274] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Feb  4 03:28:46 cocoduo kernel: [    0.744318] io scheduler noop registered
Feb  4 03:28:46 cocoduo kernel: [    0.744321] io scheduler anticipatory registered
Feb  4 03:28:46 cocoduo kernel: [    0.744323] io scheduler deadline registered
Feb  4 03:28:46 cocoduo kernel: [    0.744333] io scheduler cfq registered (default)
Feb  4 03:28:46 cocoduo kernel: [    0.744630] PCI: Setting latency timer of device 0000:00:1c.0 to 64
Feb  4 03:28:46 cocoduo kernel: [    0.744674] assign_interrupt_mode Found MSI capability
Feb  4 03:28:46 cocoduo kernel: [    0.744718] Allocate Port Service[0000:00:1c.0:pcie00]
Feb  4 03:28:46 cocoduo kernel: [    0.744756] Allocate Port Service[0000:00:1c.0:pcie02]
Feb  4 03:28:46 cocoduo kernel: [    0.744785] Allocate Port Service[0000:00:1c.0:pcie03]
Feb  4 03:28:46 cocoduo kernel: [    0.744876] PCI: Setting latency timer of device 0000:00:1c.1 to 64
Feb  4 03:28:46 cocoduo kernel: [    0.744920] assign_interrupt_mode Found MSI capability
Feb  4 03:28:46 cocoduo kernel: [    0.744954] Allocate Port Service[0000:00:1c.1:pcie00]
Feb  4 03:28:46 cocoduo kernel: [    0.744986] Allocate Port Service[0000:00:1c.1:pcie02]
Feb  4 03:28:46 cocoduo kernel: [    0.745015] Allocate Port Service[0000:00:1c.1:pcie03]
Feb  4 03:28:46 cocoduo kernel: [    0.745161] isapnp: Scanning for PnP cards...
Feb  4 03:28:46 cocoduo kernel: [    1.076930] isapnp: No Plug & Play device found
Feb  4 03:28:46 cocoduo kernel: [    1.097099] Real Time Clock Driver v1.12ac
Feb  4 03:28:46 cocoduo kernel: [    1.097149] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
Feb  4 03:28:46 cocoduo kernel: [    1.098176] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
Feb  4 03:28:46 cocoduo kernel: [    1.098264] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Feb  4 03:28:46 cocoduo kernel: [    1.098268] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb  4 03:28:46 cocoduo kernel: [    1.098570] PNP: No PS/2 controller found. Probing ports directly.
Feb  4 03:28:46 cocoduo kernel: [    1.099376] i8042.c: No controller found.
Feb  4 03:28:46 cocoduo kernel: [    1.099475] mice: PS/2 mouse device common for all mice
Feb  4 03:28:46 cocoduo kernel: [    1.099559] EISA: Probing bus 0 at eisa.0
Feb  4 03:28:46 cocoduo kernel: [    1.099565] Cannot allocate resource for EISA slot 1
Feb  4 03:28:46 cocoduo kernel: [    1.099568] Cannot allocate resource for EISA slot 2
Feb  4 03:28:46 cocoduo kernel: [    1.099594] EISA: Detected 0 cards.
Feb  4 03:28:46 cocoduo kernel: [    1.099678] TCP cubic registered
Feb  4 03:28:46 cocoduo kernel: [    1.099686] NET: Registered protocol family 1
Feb  4 03:28:46 cocoduo kernel: [    1.099691] NET: Registered protocol family 8
Feb  4 03:28:46 cocoduo kernel: [    1.099693] NET: Registered protocol family 20
Feb  4 03:28:46 cocoduo kernel: [    1.099751] Starting balanced_irq
Feb  4 03:28:46 cocoduo kernel: [    1.099763] Using IPI No-Shortcut mode
Feb  4 03:28:46 cocoduo kernel: [    1.099843] Apple MacBook detected (ICH7 SCI_EN quirk enabled)
Feb  4 03:28:46 cocoduo kernel: [    1.099845] ACPI: (supports S0 S3 S4 S5)
Feb  4 03:28:46 cocoduo kernel: [    1.100030] Freeing unused kernel memory: 312k freed
Feb  4 03:28:46 cocoduo kernel: [    1.101028] Time: tsc clocksource has been installed.
Feb  4 03:28:46 cocoduo kernel: [    2.184721] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu0Ist] [20060707]
Feb  4 03:28:46 cocoduo kernel: [    2.184920] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu0Cst] [20060707]
Feb  4 03:28:46 cocoduo kernel: [    2.185210] Monitor-Mwait will be used to enter C-1 state
Feb  4 03:28:46 cocoduo kernel: [    2.185213] Monitor-Mwait will be used to enter C-2 state
Feb  4 03:28:46 cocoduo kernel: [    2.185216] Monitor-Mwait will be used to enter C-3 state
Feb  4 03:28:46 cocoduo kernel: [    2.185222] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Feb  4 03:28:46 cocoduo kernel: [    2.185226] ACPI: Processor [CPU0] (supports 8 throttling states)
Feb  4 03:28:46 cocoduo kernel: [    2.185691] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu1Ist] [20060707]
Feb  4 03:28:46 cocoduo kernel: [    2.185864] ACPI (exconfig-0455): Dynamic SSDT Load - OemId [APPLE ] OemTableId [ Cpu1Cst] [20060707]
Feb  4 03:28:46 cocoduo kernel: [    2.186199] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
Feb  4 03:28:46 cocoduo kernel: [    2.186204] ACPI: Processor [CPU1] (supports 8 throttling states)
Feb  4 03:28:46 cocoduo kernel: [    2.496000] Time: hpet clocksource has been installed.
Feb  4 03:28:46 cocoduo kernel: [    2.692000] ICH7: IDE controller at PCI slot 0000:00:1f.1
Feb  4 03:28:46 cocoduo kernel: [    2.692000] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
Feb  4 03:28:46 cocoduo kernel: [    2.692000] ICH7: chipset revision 2
Feb  4 03:28:46 cocoduo kernel: [    2.692000] ICH7: not 100%% native mode: will probe irqs later
Feb  4 03:28:46 cocoduo kernel: [    2.692000]     ide0: BM-DMA at 0x20c0-0x20c7, BIOS settings: hda:DMA, hdb:pio
Feb  4 03:28:46 cocoduo kernel: [    2.692000]     ide1: BM-DMA at 0x20c8-0x20cf, BIOS settings: hdc:pio, hdd:pio
Feb  4 03:28:46 cocoduo kernel: [    2.692000] Probing IDE interface ide0...
Feb  4 03:28:46 cocoduo kernel: [    3.432000] hda: MATSHITADVD-R UJ-857, ATAPI CD/DVD-ROM drive
Feb  4 03:28:46 cocoduo kernel: [    3.768000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb  4 03:28:46 cocoduo kernel: [    3.768000] Probing IDE interface ide1...
Feb  4 03:28:46 cocoduo kernel: [    4.340000] SCSI subsystem initialized
Feb  4 03:28:46 cocoduo kernel: [    4.344000] libata version 2.00 loaded.
Feb  4 03:28:46 cocoduo kernel: [    4.344000] ata_piix 0000:00:1f.2: version 2.00ac6
Feb  4 03:28:46 cocoduo kernel: [    4.344000] ata_piix 0000:00:1f.2: MAP [ P0 P2 XX XX ]
Feb  4 03:28:46 cocoduo kernel: [    4.344000] ata_piix 0000:00:1f.2: invalid MAP value 0
Feb  4 03:28:46 cocoduo kernel: [    4.500000] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
Feb  4 03:28:46 cocoduo kernel: [    4.500000] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
Feb  4 03:28:46 cocoduo kernel: [    4.500000] PCI: Setting latency timer of device 0000:00:1f.2 to 64
Feb  4 03:28:46 cocoduo kernel: [    4.500000] ata1: SATA max UDMA/133 cmd 0x20D8 ctl 0x20FE bmdma 0x2020 irq 19
Feb  4 03:28:46 cocoduo kernel: [    4.500000] ata2: SATA max UDMA/133 cmd 0x20D0 ctl 0x20FA bmdma 0x2028 irq 19
Feb  4 03:28:46 cocoduo kernel: [    4.500000] scsi0 : ata_piix
Feb  4 03:28:46 cocoduo kernel: [    4.656000] ATA: abnormal status 0x7F on port 0x20DF
Feb  4 03:28:46 cocoduo kernel: [    4.672000] ATA: abnormal status 0x7F on port 0x20DF
Feb  4 03:28:46 cocoduo kernel: [    4.672000] ata1.01: ATA-7, max UDMA/133, 156301488 sectors: LBA48 NCQ (depth 0/32)
Feb  4 03:28:46 cocoduo kernel: [    4.672000] ata1.01: ata1: dev 1 multi count 16
Feb  4 03:28:46 cocoduo kernel: [    4.676000] ata1.01: configured for UDMA/133
Feb  4 03:28:46 cocoduo kernel: [    4.676000] scsi1 : ata_piix
Feb  4 03:28:46 cocoduo kernel: [    4.832000] ATA: abnormal status 0x7F on port 0x20D7
Feb  4 03:28:46 cocoduo kernel: [    4.836000] scsi 0:0:1:0: Direct-Access     ATA      ST98823AS        7.01 PQ: 0 ANSI: 5
Feb  4 03:28:46 cocoduo kernel: [    4.844000] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Feb  4 03:28:46 cocoduo kernel: [    4.844000] sda: Write Protect is off
Feb  4 03:28:46 cocoduo kernel: [    4.844000] sda: Mode Sense: 00 3a 00 00
Feb  4 03:28:46 cocoduo kernel: [    4.844000] SCSI device sda: drive cache: write back
Feb  4 03:28:46 cocoduo kernel: [    4.844000] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
Feb  4 03:28:46 cocoduo kernel: [    4.844000] sda: Write Protect is off
Feb  4 03:28:46 cocoduo kernel: [    4.844000] sda: Mode Sense: 00 3a 00 00
Feb  4 03:28:46 cocoduo kernel: [    4.844000] SCSI device sda: drive cache: write back
Feb  4 03:28:46 cocoduo kernel: [    4.844000]  sda:<6>hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)
Feb  4 03:28:46 cocoduo kernel: [    4.844000] Uniform CD-ROM driver Revision: 3.20
Feb  4 03:28:46 cocoduo kernel: [    4.856000]  sda1 sda2
Feb  4 03:28:46 cocoduo kernel: [    4.880000] sd 0:0:1:0: Attached scsi disk sda
Feb  4 03:28:46 cocoduo kernel: [    5.124000] Probing IDE interface ide1...
Feb  4 03:28:46 cocoduo kernel: [    5.152000] usbcore: registered new interface driver usbfs
Feb  4 03:28:46 cocoduo kernel: [    5.152000] usbcore: registered new interface driver hub
Feb  4 03:28:46 cocoduo kernel: [    5.152000] usbcore: registered new device driver usb
Feb  4 03:28:46 cocoduo kernel: [    5.152000] USB Universal Host Controller Interface driver v3.0
Feb  4 03:28:46 cocoduo kernel: [    5.152000] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 20
Feb  4 03:28:46 cocoduo kernel: [    5.152000] PCI: Setting latency timer of device 0000:00:1d.0 to 64
Feb  4 03:28:46 cocoduo kernel: [    5.152000] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Feb  4 03:28:46 cocoduo kernel: [    5.152000] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Feb  4 03:28:46 cocoduo kernel: [    5.152000] uhci_hcd 0000:00:1d.0: irq 20, io base 0x000020a0
Feb  4 03:28:46 cocoduo kernel: [    5.152000] usb usb1: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    5.152000] hub 1-0:1.0: USB hub found
Feb  4 03:28:46 cocoduo kernel: [    5.152000] hub 1-0:1.0: 2 ports detected
Feb  4 03:28:46 cocoduo kernel: [    5.172000] ieee1394: Initialized config rom entry `ip1394'
Feb  4 03:28:46 cocoduo kernel: [    5.256000] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
Feb  4 03:28:46 cocoduo kernel: [    5.256000] PCI: Setting latency timer of device 0000:00:1d.1 to 64
Feb  4 03:28:46 cocoduo kernel: [    5.256000] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Feb  4 03:28:46 cocoduo kernel: [    5.256000] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
Feb  4 03:28:46 cocoduo kernel: [    5.256000] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002080
Feb  4 03:28:46 cocoduo kernel: [    5.256000] usb usb2: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    5.256000] hub 2-0:1.0: USB hub found
Feb  4 03:28:46 cocoduo kernel: [    5.256000] hub 2-0:1.0: 2 ports detected
Feb  4 03:28:46 cocoduo kernel: [    5.360000] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
Feb  4 03:28:46 cocoduo kernel: [    5.360000] PCI: Setting latency timer of device 0000:00:1d.2 to 64
Feb  4 03:28:46 cocoduo kernel: [    5.360000] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Feb  4 03:28:46 cocoduo kernel: [    5.360000] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
Feb  4 03:28:46 cocoduo kernel: [    5.360000] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002060
Feb  4 03:28:46 cocoduo kernel: [    5.360000] usb usb3: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    5.360000] hub 3-0:1.0: USB hub found
Feb  4 03:28:46 cocoduo kernel: [    5.360000] hub 3-0:1.0: 2 ports detected
Feb  4 03:28:46 cocoduo kernel: [    5.464000] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 17
Feb  4 03:28:46 cocoduo kernel: [    5.464000] PCI: Setting latency timer of device 0000:00:1d.3 to 64
Feb  4 03:28:46 cocoduo kernel: [    5.464000] uhci_hcd 0000:00:1d.3: UHCI Host Controller
Feb  4 03:28:46 cocoduo kernel: [    5.464000] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
Feb  4 03:28:46 cocoduo kernel: [    5.464000] uhci_hcd 0000:00:1d.3: irq 17, io base 0x00002040
Feb  4 03:28:46 cocoduo kernel: [    5.464000] usb usb4: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    5.464000] hub 4-0:1.0: USB hub found
Feb  4 03:28:46 cocoduo kernel: [    5.464000] hub 4-0:1.0: 2 ports detected
Feb  4 03:28:46 cocoduo kernel: [    5.496000] usb 1-2: new full speed USB device using uhci_hcd and address 2
Feb  4 03:28:46 cocoduo kernel: [    5.568000] ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 19 (level, low) -> IRQ 19
Feb  4 03:28:46 cocoduo kernel: [    5.572000] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 20
Feb  4 03:28:46 cocoduo kernel: [    5.572000] PCI: Setting latency timer of device 0000:00:1d.7 to 64
Feb  4 03:28:46 cocoduo kernel: [    5.572000] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Feb  4 03:28:46 cocoduo kernel: [    5.572000] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
Feb  4 03:28:46 cocoduo kernel: [    5.572000] ehci_hcd 0000:00:1d.7: debug port 1
Feb  4 03:28:46 cocoduo kernel: [    5.572000] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
Feb  4 03:28:46 cocoduo kernel: [    5.572000] ehci_hcd 0000:00:1d.7: irq 20, io mem 0x90445400
Feb  4 03:28:46 cocoduo kernel: [    5.576000] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Feb  4 03:28:46 cocoduo kernel: [    5.576000] usb usb5: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    5.576000] hub 5-0:1.0: USB hub found
Feb  4 03:28:46 cocoduo kernel: [    5.576000] hub 5-0:1.0: 8 ports detected
Feb  4 03:28:46 cocoduo kernel: [    5.620000] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
Feb  4 03:28:46 cocoduo kernel: [    5.720000] Attempting manual resume
Feb  4 03:28:46 cocoduo kernel: [    5.728000] EXT3-fs: INFO: recovery required on readonly filesystem.
Feb  4 03:28:46 cocoduo kernel: [    5.728000] EXT3-fs: write access will be enabled during recovery.
Feb  4 03:28:46 cocoduo kernel: [    6.020000] usb 1-2: device not accepting address 2, error -71
Feb  4 03:28:46 cocoduo kernel: [    6.884000] usb 5-4: new high speed USB device using ehci_hcd and address 3
Feb  4 03:28:46 cocoduo kernel: [    6.900000] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0017f2fffe6a9282]
Feb  4 03:28:46 cocoduo kernel: [    7.016000] usb 5-4: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    7.624000] usb 1-2: new full speed USB device using uhci_hcd and address 4
Feb  4 03:28:46 cocoduo kernel: [    7.816000] usb 1-2: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    8.068000] usb 3-2: new full speed USB device using uhci_hcd and address 2
Feb  4 03:28:46 cocoduo kernel: [    8.252000] usb 3-2: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    8.492000] usb 4-1: new full speed USB device using uhci_hcd and address 2
Feb  4 03:28:46 cocoduo kernel: [    8.668000] usb 4-1: configuration #1 chosen from 1 choice
Feb  4 03:28:46 cocoduo kernel: [    8.672000] usbcore: registered new interface driver hiddev
Feb  4 03:28:46 cocoduo kernel: [    8.680000] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input0
Feb  4 03:28:46 cocoduo kernel: [    8.680000] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
Feb  4 03:28:46 cocoduo kernel: [    8.680000] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input1
Feb  4 03:28:46 cocoduo kernel: [    8.680000] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
Feb  4 03:28:46 cocoduo kernel: [    8.700000] input: HID 05ac:1000 as /class/input/input2
Feb  4 03:28:46 cocoduo kernel: [    8.700000] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
Feb  4 03:28:46 cocoduo kernel: [    8.716000] input: HID 05ac:1000 as /class/input/input3
Feb  4 03:28:46 cocoduo kernel: [    8.716000] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
Feb  4 03:28:46 cocoduo kernel: [    8.716000] usbcore: registered new interface driver usbhid
Feb  4 03:28:46 cocoduo kernel: [    8.716000] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
Feb  4 03:28:46 cocoduo kernel: [   14.084000] kjournald starting.  Commit interval 5 seconds
Feb  4 03:28:46 cocoduo kernel: [   14.084000] EXT3-fs: sda1: orphan cleanup on readonly fs
Feb  4 03:28:46 cocoduo kernel: [   14.084000] ext3_orphan_cleanup: deleting unreferenced inode 7408264
Feb  4 03:28:46 cocoduo kernel: [   14.084000] EXT3-fs: sda1: 1 orphan inode deleted
Feb  4 03:28:46 cocoduo kernel: [   14.088000] EXT3-fs: recovery complete.
Feb  4 03:28:46 cocoduo kernel: [   14.132000] EXT3-fs: mounted filesystem with ordered data mode.
Feb  4 03:28:46 cocoduo kernel: [   22.420000] BUG: unable to handle kernel paging request at virtual address fffb9014
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  printing eip:
Feb  4 03:28:46 cocoduo kernel: [   22.420000] c0157e3f
Feb  4 03:28:46 cocoduo kernel: [   22.420000] *pde = 00004067
Feb  4 03:28:46 cocoduo kernel: [   22.420000] Oops: 0002 [#1]
Feb  4 03:28:46 cocoduo kernel: [   22.420000] SMP 
Feb  4 03:28:46 cocoduo kernel: [   22.420000] Modules linked in: usbhid ext3 jbd mbcache ehci_hcd ohci1394 ieee1394 uhci_hcd usbcore ide_generic ide_cd cdrom sd_mod ata_piix libata scsi_mod piix generic thermal processor fan
Feb  4 03:28:46 cocoduo kernel: [   22.420000] CPU:    0
Feb  4 03:28:46 cocoduo kernel: [   22.420000] EIP:    0060:[get_page_from_freelist+623/832]    Not tainted VLI
Feb  4 03:28:46 cocoduo kernel: [   22.420000] EFLAGS: 00010286   (2.6.19.2-mactel #2)
Feb  4 03:28:46 cocoduo kernel: [   22.420000] EIP is at get_page_from_freelist+0x26f/0x340
Feb  4 03:28:46 cocoduo kernel: [   22.420000] eax: 00000000   ebx: c1f33140   ecx: 000003fb   edx: 00046000
Feb  4 03:28:46 cocoduo kernel: [   22.420000] esi: c1f33140   edi: fffb9014   ebp: 00000000   esp: f2f35c90
Feb  4 03:28:46 cocoduo kernel: [   22.420000] ds: 007b   es: 007b   ss: 0068
Feb  4 03:28:46 cocoduo kernel: [   22.420000] Process modprobe (pid: 2858, ti=f2f34000 task=f2f15a90 task.ti=f2f34000)
Feb  4 03:28:46 cocoduo kernel: [   22.420000] Stack: 00000002 00000044 fffb9000 00000001 00000001 00000000 00000002 00000000 
Feb  4 03:28:46 cocoduo kernel: [   22.420000]        000280d2 c0384220 00000246 000200d2 00000000 00000040 00000001 c0384220 
Feb  4 03:28:46 cocoduo kernel: [   22.420000]        000280d2 f2f15a90 00000000 c0157f67 00000044 00000010 00000013 c20a760a 
Feb  4 03:28:46 cocoduo kernel: [   22.420000] Call Trace:
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [__alloc_pages+87/768] __alloc_pages+0x57/0x300
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [anon_vma_prepare+29/224] anon_vma_prepare+0x1d/0xe0
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [__handle_mm_fault+2102/2464] __handle_mm_fault+0x836/0x9a0
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [__link_path_walk+2514/3760] __link_path_walk+0x9d2/0xeb0
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [__do_page_cache_readahead+121/608] __do_page_cache_readahead+0x79/0x260
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [__do_page_cache_readahead+216/608] __do_page_cache_readahead+0xd8/0x260
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [do_page_fault+1068/1504] do_page_fault+0x42c/0x5e0
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [do_page_fault+0/1504] do_page_fault+0x0/0x5e0
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [error_code+57/64] error_code+0x39/0x40
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [file_read_actor+55/256] file_read_actor+0x37/0x100
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [do_generic_mapping_read+727/1408] do_generic_mapping_read+0x2d7/0x580
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [generic_file_aio_read+257/624] generic_file_aio_read+0x101/0x270
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [file_read_actor+0/256] file_read_actor+0x0/0x100
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [do_sync_read+213/288] do_sync_read+0xd5/0x120
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [do_mmap_pgoff+1339/1952] do_mmap_pgoff+0x53b/0x7a0
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [vfs_read+188/400] vfs_read+0xbc/0x190
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [do_sync_read+0/288] do_sync_read+0x0/0x120
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [sys_read+65/112] sys_read+0x41/0x70
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  [sysenter_past_esp+86/121] sysenter_past_esp+0x56/0x79
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  =======================
Feb  4 03:28:46 cocoduo kernel: [   22.420000] Code: 24 10 85 db 7e 47 89 f3 31 ed c7 44 24 30 00 00 00 00 ba 03 00 00 00 89 d8 e8 0e 30 fc ff b9 00 04 00 00 89 44 24 08 89 c7 89 e8 <f3> ab 8b 44 24 08 ba 03 00 00 00 83 c3 20 e8 7e 30 fc ff 83 44 
Feb  4 03:28:46 cocoduo kernel: [   22.420000] EIP: [get_page_from_freelist+623/832] get_page_from_freelist+0x26f/0x340 SS:ESP 0068:f2f35c90
Feb  4 03:28:46 cocoduo kernel: [   22.420000]  <6>note: modprobe[2858] exited with preempt_count 1
Feb  4 03:28:46 cocoduo kernel: [   23.000000] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
Feb  4 03:28:46 cocoduo kernel: [   23.000000] tpm_inf_pnp 00:03: TPM found: config base 0x4e, io base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
Feb  4 03:28:46 cocoduo kernel: [   23.040000] Linux agpgart interface v0.101 (c) Dave Jones
Feb  4 03:28:46 cocoduo kernel: [   23.044000] agpgart: Detected an Intel 945GM Chipset.
Feb  4 03:28:46 cocoduo kernel: [   23.044000] agpgart: Detected 16124K stolen memory.
Feb  4 03:28:46 cocoduo kernel: [   23.060000] agpgart: AGP aperture is 256M @ 0x80000000
-- 
Lionel Landwerlin <landwer@free.fr>

