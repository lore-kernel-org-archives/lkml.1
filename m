Return-Path: <linux-kernel-owner+w=401wt.eu-S1755561AbYHMNLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbYHMNLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 09:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYHMNLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 09:11:46 -0400
Received: from mail-ausfall.charite.de ([193.175.70.131]:38823 "EHLO
	mail-ausfall.charite.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYHMNLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 09:11:43 -0400
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2008 09:11:43 EDT
Date: Wed, 13 Aug 2008 15:00:59 +0200
From: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc3: ext4 mount problem (proc_dir_entry 'stats' already
	registered)
Message-ID: <20080813130059.GI28809@charite.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freshly created fs using:

mkfs -E test_fs -t ext3 /dev/cciss/c0d0p8
tune2fs -O extents -E test_fs /dev/cciss/c0d0p8

then mounted via:
mount /squid-cache0

from fstab:
# <file system> <mount point>   <type>  <options> <dump>  <pass>
/dev/cciss/c0d0p8       /squid-cache0   auto defaults,noatime,nodev,noexec,errors=panic      0  1

results in:
/dev/cciss/c0d0p8 on /squid-cache0 type ext4dev (rw,noexec,nodev,noatime,errors=panic)

in dmesg I get:

[    5.586583] proc_dir_entry 'stats' already registered

complete dmesg:

[    0.000000] Linux version 2.6.27-rc3 (root@proxy-cvk-1) (gcc version 4.2.4 (Debian 4.2.4-3)) #1 SMP Wed Aug 13 14:16:27 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff3000 (usable)
[    0.000000]  BIOS-e820: 000000007fff3000 - 000000007fffb000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007fffb000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000] last_pfn = 0x7fff3 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F4EE0, 0024 (r2 HP    )
[    0.000000] ACPI: XSDT 7FFF32C0, 004C (r1 HP     P54             2   “     162E)
[    0.000000] ACPI: FACP 7FFF3340, 00F4 (r3 HP     P54             2   “     162E)
[    0.000000] ACPI: DSDT 7FFF3440, 18CE (r1 HP         DSDT        1 INTL 20030228)
[    0.000000] ACPI: FACS 7FFF3100, 0040
[    0.000000] ACPI: SPCR 7FFF3140, 0050 (r1 HP     SPCRRBSU        1   “     162E)
[    0.000000] ACPI: MCFG 7FFF31C0, 003C (r1 HP     ProLiant        1             0)
[    0.000000] ACPI: APIC 7FFF3200, 00B6 (r1 HP     00000083        2             0)
[    0.000000] ACPI: SSDT 7FFF8000, 02CD (r1 HP        SSDTP        1 INTL 20030228)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00009000 - 00010000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0038000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 000040a910]    TEXT DATA BSS ==> [0000100000 - 000040a910]
[    0.000000]   #4 [000040b000 - 0000412000]    INIT_PG_TABLE ==> [000040b000 - 0000412000]
[    0.000000]   #5 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f4f60] 000f4f60
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x0007fff3
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007fff3
[    0.000000] On node 0 totalpages: 524177
[    0.000000] free_area_init_node: node 0, pgdat c0362380, node_mem_map c1000020
[    0.000000]   DMA zone: 3966 pages, LIFO batch:0
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 292595 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x908
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 9, version 32, address 0xfec10000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x0a] address[0xfec82000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 10, version 32, address 0xfec82000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x0b] address[0xfec82400] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 11, version 32, address 0xfec82400, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 4 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] mapped IOAPIC to ffff9000 (fec10000)
[    0.000000] mapped IOAPIC to ffff8000 (fec82000)
[    0.000000] mapped IOAPIC to ffff7000 (fec82400)
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
[    0.000000] PERCPU: Allocating 40352 bytes of per cpu data
[    0.000000] NR_CPUS: 4, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520081
[    0.000000] Kernel command line: BOOT_IMAGE=Linux ro root=6805 panic=10
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c03cd000 soft=c03c9000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 3400.066 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Memory: 2075280k/2097100k available (1827k kernel code, 20536k reserved, 737k data, 256k init, 1179596k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff85000 - 0xfffff000   ( 488 kB)
[    0.000999]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000999]     vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000999]       .init : 0xc0386000 - 0xc03c6000   ( 256 kB)
[    0.000999]       .data : 0xc02c8d4f - 0xc03813e8   ( 737 kB)
[    0.000999]       .text : 0xc0100000 - 0xc02c8d4f   (1827 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] Calibrating delay loop (skipped), value calculated using timer frequency.. 6800.13 BogoMIPS (lpj=3400066)
[    0.000999] Mount-cache hash table entries: 512
[    0.000999] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.000999] CPU: L2 cache: 2048K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] Intel machine check architecture supported.
[    0.000999] Intel machine check reporting enabled on CPU#0.
[    0.000999] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.000999] CPU0: Thermal monitoring enabled
[    0.000999] using mwait in idle threads.
[    0.000999] Checking 'hlt' instruction... OK.
[    0.005999] Freeing SMP alternatives: 9k freed
[    0.005999] ACPI: Core revision 20080609
[    0.009998] ENABLING IO-APIC IRQs
[    0.009998] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.020996] CPU0: Intel(R) Xeon(TM) CPU 3.40GHz stepping 03
[    0.020996] CPU 1 irqstacks, hard=c03ce000 soft=c03ca000
[    0.020996] Booting processor 1/6 ip 6000
[    0.030995] Initializing CPU#1
[    0.061990] Calibrating delay using timer specific routine.. 6799.07 BogoMIPS (lpj=3399539)
[    0.061990] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.061990] CPU: L2 cache: 2048K
[    0.061990] CPU: Physical Processor ID: 3
[    0.061990] Intel machine check architecture supported.
[    0.061990] Intel machine check reporting enabled on CPU#1.
[    0.061990] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.061990] CPU1: Thermal monitoring enabled
[    0.061990] x86 PAT enabled: cpu 1, old 0x7010600070106, new 0x7010600070106
[    0.091985] CPU1: Intel(R) Xeon(TM) CPU 3.40GHz stepping 03
[    0.092985] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.093985] CPU 2 irqstacks, hard=c03cf000 soft=c03cb000
[    0.093985] Booting processor 2/1 ip 6000
[    0.104984] Initializing CPU#2
[    0.104984] Calibrating delay using timer specific routine.. 6799.02 BogoMIPS (lpj=3399514)
[    0.104984] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.104984] CPU: L2 cache: 2048K
[    0.104984] CPU: Physical Processor ID: 0
[    0.104984] Intel machine check architecture supported.
[    0.104984] Intel machine check reporting enabled on CPU#2.
[    0.104984] CPU2: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.104984] CPU2: Thermal monitoring enabled
[    0.104984] x86 PAT enabled: cpu 2, old 0x7010600070106, new 0x7010600070106
[    0.165974] CPU2: Intel(R) Xeon(TM) CPU 3.40GHz stepping 03
[    0.166974] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.167974] CPU 3 irqstacks, hard=c03d0000 soft=c03cc000
[    0.167974] Booting processor 3/7 ip 6000
[    0.178972] Initializing CPU#3
[    0.178972] Calibrating delay using timer specific routine.. 6799.09 BogoMIPS (lpj=3399547)
[    0.178972] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.178972] CPU: L2 cache: 2048K
[    0.178972] CPU: Physical Processor ID: 3
[    0.178972] Intel machine check architecture supported.
[    0.178972] Intel machine check reporting enabled on CPU#3.
[    0.178972] CPU3: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.178972] CPU3: Thermal monitoring enabled
[    0.178972] x86 PAT enabled: cpu 3, old 0x7010600070106, new 0x7010600070106
[    0.239963] CPU3: Intel(R) Xeon(TM) CPU 3.40GHz stepping 03
[    0.240963] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.241962] Brought up 4 CPUs
[    0.241962] Total of 4 processors activated (27197.33 BogoMIPS).
[    0.242962] net_namespace: 596 bytes
[    0.242962] NET: Registered protocol family 16
[    0.242962] ACPI: bus type pci registered
[    0.243962] PCI: Found Intel Corporation E7520 Memory Controller Hub with MMCONFIG support.
[    0.243962] PCI: Using MMCONFIG for extended config space
[    0.243962] PCI: Using configuration type 1 for base access
[    0.243962] PCI: HP ProLiant DL360 detected, enabling pci=bfsort.
[    0.245962] ACPI: EC: Look up EC in DSDT
[    0.246962] ACPI: Interpreter enabled
[    0.246962] ACPI: (supports S0 S5)
[    0.247962] ACPI: Using IOAPIC for interrupt routing
[    0.250961] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.250961] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.250961] pci 0000:00:02.0: PME# disabled
[    0.250961] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.251961] pci 0000:00:04.0: PME# disabled
[    0.251961] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    0.251961] pci 0000:00:06.0: PME# disabled
[    0.251961] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.251961] pci 0000:00:1d.7: PME# disabled
[    0.251961] HPET not enabled in BIOS. You might try hpet=force boot option
[    0.251961] pci 0000:00:1f.0: quirk: region 0900-097f claimed by ICH4 ACPI/GPIO/TCO
[    0.251961] pci 0000:00:1f.0: quirk: region 0800-083f claimed by ICH4 GPIO
[    0.252961] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    0.252961] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    0.252961] pci 0000:06:00.0: PME# disabled
[    0.252961] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    0.253961] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    0.253961] pci 0000:06:00.2: PME# disabled
[    0.254379] pci 0000:02:01.0: supports D1
[    0.254499] pci 0000:02:02.0: PME# supported from D3hot D3cold
[    0.254675] pci 0000:02:02.0: PME# disabled
[    0.254960] pci 0000:02:02.1: PME# supported from D3hot D3cold
[    0.254960] pci 0000:02:02.1: PME# disabled
[    0.254960] pci 0000:01:03.0: supports D1
[    0.254960] pci 0000:01:03.0: supports D2
[    0.254960] pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
[    0.254960] pci 0000:01:04.2: PME# disabled
[    0.254960] pci 0000:00:1e.0: transparent bridge
[    0.254960] bus 00 -> node 0
[    0.254960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.ICHR._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTB0._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTB0.PCXA._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTB0.PCXB._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTA0._PRT]
[    0.255960] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PTC0._PRT]
[    0.258960] ACPI: PCI Interrupt Link [LNKA] (IRQs *5 7 10 11), disabled.
[    0.258960] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7 10 11) *0, disabled.
[    0.259960] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 *7 10 11), disabled.
[    0.259960] ACPI: PCI Interrupt Link [LNKD] (IRQs *5 7 10 11), disabled.
[    0.260960] ACPI: PCI Interrupt Link [LNKE] (IRQs 5 7 10 11) *0, disabled.
[    0.260960] ACPI: PCI Interrupt Link [LNKF] (IRQs *5 7 10 11), disabled.
[    0.260960] ACPI: PCI Interrupt Link [LNKG] (IRQs *5 7 10 11), disabled.
[    0.261959] ACPI: PCI Interrupt Link [LNKH] (IRQs *5 7 10 11), disabled.
[    0.261959] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.261959] pnp: PnP ACPI init
[    0.262959] ACPI: bus type pnp registered
[    0.263959] pnp: PnP ACPI: found 9 devices
[    0.263959] ACPI: ACPI bus type pnp unregistered
[    0.264959] SCSI subsystem initialized
[    0.264959] PCI: Using ACPI for IRQ routing
[    0.268960] system 00:01: ioport range 0x408-0x40f has been reserved
[    0.268960] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.268960] system 00:01: ioport range 0x700-0x71f has been reserved
[    0.268960] system 00:01: ioport range 0x800-0x83f has been reserved
[    0.268960] system 00:01: ioport range 0x900-0x97f has been reserved
[    0.268960] system 00:01: ioport range 0xc80-0xc83 has been reserved
[    0.268960] system 00:01: ioport range 0xcd4-0xcd7 has been reserved
[    0.268960] system 00:01: ioport range 0xf50-0xf58 has been reserved
[    0.268960] system 00:01: ioport range 0x2f8-0x2ff has been reserved
[    0.268960] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.299997] pci 0000:00:02.0: PCI bridge, secondary bus 0000:0d
[    0.299997] pci 0000:00:02.0:   IO window: disabled
[    0.299997] pci 0000:00:02.0:   MEM window: disabled
[    0.299997] pci 0000:00:02.0:   PREFETCH window: disabled
[    0.299997] pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
[    0.299997] pci 0000:06:00.0:   IO window: disabled
[    0.299997] pci 0000:06:00.0:   MEM window: disabled
[    0.299997] pci 0000:06:00.0:   PREFETCH window: disabled
[    0.299997] pci 0000:06:00.2: PCI bridge, secondary bus 0000:0a
[    0.299997] pci 0000:06:00.2:   IO window: disabled
[    0.299997] pci 0000:06:00.2:   MEM window: disabled
[    0.299997] pci 0000:06:00.2:   PREFETCH window: disabled
[    0.299997] pci 0000:00:04.0: PCI bridge, secondary bus 0000:06
[    0.299997] pci 0000:00:04.0:   IO window: disabled
[    0.299997] pci 0000:00:04.0:   MEM window: disabled
[    0.301001] pci 0000:00:04.0:   PREFETCH window: disabled
[    0.301037] pci 0000:00:06.0: PCI bridge, secondary bus 0000:03
[    0.301037] pci 0000:00:06.0:   IO window: disabled
[    0.301037] pci 0000:00:06.0:   MEM window: disabled
[    0.301037] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.301037] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.301037] pci 0000:00:1c.0:   IO window: 0x4000-0x4fff
[    0.301037] pci 0000:00:1c.0:   MEM window: 0xfdf00000-0xfdffffff
[    0.301037] pci 0000:00:1c.0:   PREFETCH window: 0x00000088000000-0x000000880fffff
[    0.301037] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:01
[    0.301037] pci 0000:00:1e.0:   IO window: 0x1000-0x3fff
[    0.301037] pci 0000:00:1e.0:   MEM window: 0xfbf00000-0xfcffffff
[    0.301037] pci 0000:00:1e.0:   PREFETCH window: 0x00000088100000-0x000000881fffff
[    0.301037] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.301037] pci 0000:00:02.0: setting latency timer to 64
[    0.301037] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.301037] pci 0000:00:04.0: setting latency timer to 64
[    0.301037] pci 0000:06:00.0: setting latency timer to 64
[    0.301037] pci 0000:06:00.2: setting latency timer to 64
[    0.301037] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.301037] pci 0000:00:06.0: setting latency timer to 64
[    0.301996] pci 0000:00:1e.0: setting latency timer to 64
[    0.301996] NET: Registered protocol family 2
[    0.305000] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.305000] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.305000] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.306008] TCP: Hash tables configured (established 131072 bind 65536)
[    0.306008] TCP reno registered
[    0.308008] NET: Registered protocol family 1
[    0.309936] highmem bounce pool size: 64 pages
[    0.313515] msgmni has been set to 1751
[    0.313684] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.314231] io scheduler noop registered
[    0.314293] io scheduler anticipatory registered
[    0.314324] io scheduler deadline registered
[    0.314324] io scheduler cfq registered (default)
[    0.314746] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.314746] pci_express 0000:00:02.0:pcie00: allocate port service
[    0.315206] pci_express 0000:00:02.0:pcie01: allocate port service
[    0.315206] pcieport-driver 0000:00:04.0: setting latency timer to 64
[    0.315206] pci_express 0000:00:04.0:pcie00: allocate port service
[    0.315206] pci_express 0000:00:04.0:pcie01: allocate port service
[    0.315206] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    0.315206] pci_express 0000:00:06.0:pcie00: allocate port service
[    0.315453] pci_express 0000:00:06.0:pcie01: allocate port service
[    0.315453] aer 0000:00:02.0:pcie01: AER service couldn't init device: no _OSC support
[    0.316161] aer 0000:00:04.0:pcie01: AER service couldn't init device: no _OSC support
[    0.316161] aer 0000:00:06.0:pcie01: AER service couldn't init device: no _OSC support
[    0.320453] Floppy drive(s): fd0 is 1.44M
[    0.332458] FDC 0 is a National Semiconductor PC87306
[    0.334321] Compaq SMART2 Driver (v 2.6.0)
[    0.334321] HP CISS Driver (v 3.6.20)
[    0.334321] cciss 0000:02:01.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[    0.413475] cciss0: <0x46> at PCI 0000:02:01.0 IRQ 24 using DAC
[    0.414206]       blocks= 142253280 block_size= 512
[    0.414274]       heads=255, sectors=32, cylinders=17433
[    0.414274] 
[    0.414483]       blocks= 142253280 block_size= 512
[    0.414714]       heads=255, sectors=32, cylinders=17433
[    0.414714] 
[    0.414714]  cciss/c0d0: p1 < p5 p6 p7 p8 p9 p10 >
[    0.456955] Uniform Multi-Platform E-IDE driver
[    0.457371] piix 0000:00:1f.1: IDE controller (0x8086:0x25a2 rev 0x02)
[    0.457493] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.457554] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    0.457554]     ide0: BM-DMA at 0x0500-0x0507
[    0.457554]     ide1: BM-DMA at 0x0508-0x050f
[    0.457554] Probing IDE interface ide0...
[    0.801212] Switched to high resolution mode on CPU 3
[    0.800307] Switched to high resolution mode on CPU 1
[    0.801325] Switched to high resolution mode on CPU 2
[    0.801469] Switched to high resolution mode on CPU 0
[    1.128002] hda: DV-28E-N, ATAPI CD/DVD-ROM drive
[    1.740311] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.740311] hda: UDMA/33 mode selected
[    1.741007] Probing IDE interface ide1...
[    2.260306] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.260306] ide1 at 0x170-0x177,0x376 on irq 15
[    2.260376] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    2.260376] ide_generic: I/O resource 0x1F0-0x1F7 not free.
[    2.260376] ide_generic: I/O resource 0x170-0x177 not free.
[    2.262974] hda: ATAPI 24X DVD-ROM drive, 256kB Cache
[    2.262974] Uniform CD-ROM driver Revision: 3.20
[    2.270001] Driver 'sd' needs updating - please use bus_type methods
[    2.270001] Driver 'sr' needs updating - please use bus_type methods
[    2.270002] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    2.272292] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.272292] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.273377] mice: PS/2 mouse device common for all mice
[    2.273377] cpuidle: using governor ladder
[    2.273377] cpuidle: using governor menu
[    2.273428] TCP cubic registered
[    2.273428] NET: Registered protocol family 17
[    2.273428] Starting balanced_irq
[    2.274006] Using IPI Shortcut mode
[    2.274238] registered taskstats version 1
[    2.325245] input: AT Translated Set 2 keyboard as /class/input/input0
[    2.388367] kjournald starting.  Commit interval 5 seconds
[    2.388367] EXT3-fs: mounted filesystem with ordered data mode.
[    2.388367] VFS: Mounted root (ext3 filesystem) readonly.
[    2.388367] Freeing unused kernel memory: 256k freed
[    2.388367] Write protecting the kernel text: 1828k
[    2.388367] Write protecting the kernel read-only data: 592k
[    3.427012] Real Time Clock Driver v1.12ac
[    3.429377] Generic RTC Driver v1.07
[    3.703006] Adding 1962456k swap on /dev/cciss/c0d0p6.  Priority:-1 extents:1 across:1962456k
[    3.723010] Adding 1962456k swap on /dev/cciss/c0d0p7.  Priority:-2 extents:1 across:1962456k
[    3.980356] EXT3 FS on cciss/c0d0p5, internal journal
[    4.779381] tg3.c:v3.93 (May 22, 2008)
[    4.779381] tg3 0000:02:02.0: PCI INT A -> GSI 25 (level, low) -> IRQ 25
[    4.810377] eth0: Tigon3 [partno(349321-001) rev 2100 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:16:35:3b:8f:8c
[    4.810377] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] WireSpeed[1] TSOcap[0]
[    4.810377] eth0: dma_rwctrl[769f0000] dma_mask[64-bit]
[    4.810377] tg3 0000:02:02.1: PCI INT B -> GSI 26 (level, low) -> IRQ 26
[    4.845131] eth1: Tigon3 [partno(349321-001) rev 2100 PHY(5704)] (PCIX:66MHz:64-bit) 10/100/1000Base-T Ethernet 00:16:35:3b:8f:8b
[    4.845131] eth1: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
[    4.845131] eth1: dma_rwctrl[769f0000] dma_mask[64-bit]
[    4.875345] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    5.559376] kjournald2 starting.  Commit interval 5 seconds
[    5.561423] EXT4 FS on cciss/c0d0p8, internal journal
[    5.561423] EXT4-fs: mounted filesystem with ordered data mode.
[    5.561423] EXT4-fs: delayed allocation enabled
[    5.561423] EXT4-fs: file extents enabled
[    5.561423] EXT4-fs: mballoc enabled
[    5.569001] kjournald2 starting.  Commit interval 5 seconds
[    5.586583] EXT4 FS on cciss/c0d0p9, internal journal
[    5.586583] EXT4-fs: mounted filesystem with ordered data mode.
[    5.586583] EXT4-fs: delayed allocation enabled
[    5.586583] EXT4-fs: file extents enabled
[    5.586583] proc_dir_entry 'stats' already registered
[    5.586583] Pid: 655, comm: mount Not tainted 2.6.27-rc3 #1
[    5.587013]  [<c019ea80>] proc_register+0xda/0x17d
[    5.587115]  [<c019eb85>] proc_create_data+0x62/0x9a
[    5.587307]  [<f8ad5a8f>] ext4_mb_init+0x47d/0x748 [ext4dev]
[    5.587601]  [<c0119f50>] __wake_up+0x32/0x42
[    5.587984]  [<c0123783>] printk+0x1b/0x1f
[    5.588006]  [<f8ac7d8a>] ext4_fill_super+0x1829/0x2043 [ext4dev]
[    5.588006]  [<c01de527>] snprintf+0x1f/0x23
[    5.588006]  [<c01a37bc>] disk_name+0x72/0xa6
[    5.588006]  [<c016e92f>] get_sb_bdev+0xea/0x10d
[    5.588006]  [<c0154d4c>] kstrdup+0x30/0x52
[    5.588006]  [<f8ac4690>] ext4_get_sb+0x20/0x25 [ext4dev]
[    5.589009]  [<f8ac6561>] ext4_fill_super+0x0/0x2043 [ext4dev]
[    5.589028]  [<c016e3d0>] vfs_kern_mount+0x37/0x88
[    5.589028]  [<c016e468>] do_kern_mount+0x31/0xbc
[    5.589028]  [<c0181aaa>] do_new_mount+0x69/0x8e
[    5.589028]  [<c0181c31>] do_mount+0x162/0x1aa
[    5.589028]  [<c017fb5e>] copy_mount_options+0x28/0x115
[    5.589028]  [<c01741f5>] getname+0x8c/0x9b
[    5.589028]  [<c0181cf0>] sys_mount+0x77/0xb7
[    5.589028]  [<c0103a02>] syscall_call+0x7/0xb
[    5.589028]  =======================
[    5.589028] proc_dir_entry 'max_to_scan' already registered
[    5.589028] Pid: 655, comm: mount Not tainted 2.6.27-rc3 #1
[    5.589028]  [<c019ea80>] proc_register+0xda/0x17d
[    5.590032]  [<c019eb85>] proc_create_data+0x62/0x9a
[    5.590032]  [<f8ad5ab7>] ext4_mb_init+0x4a5/0x748 [ext4dev]
[    5.590032]  [<c0119f50>] __wake_up+0x32/0x42
[    5.590032]  [<c0123783>] printk+0x1b/0x1f
[    5.590032]  [<f8ac7d8a>] ext4_fill_super+0x1829/0x2043 [ext4dev]
[    5.590032]  [<c01de527>] snprintf+0x1f/0x23
[    5.590032]  [<c01a37bc>] disk_name+0x72/0xa6
[    5.590032]  [<c016e92f>] get_sb_bdev+0xea/0x10d
[    5.590032]  [<c0154d4c>] kstrdup+0x30/0x52
[    5.590032]  [<f8ac4690>] ext4_get_sb+0x20/0x25 [ext4dev]
[    5.590032]  [<f8ac6561>] ext4_fill_super+0x0/0x2043 [ext4dev]
[    5.591032]  [<c016e3d0>] vfs_kern_mount+0x37/0x88
[    5.591032]  [<c016e468>] do_kern_mount+0x31/0xbc
[    5.591032]  [<c0181aaa>] do_new_mount+0x69/0x8e
[    5.591032]  [<c0181c31>] do_mount+0x162/0x1aa
[    5.591032]  [<c017fb5e>] copy_mount_options+0x28/0x115
[    5.591032]  [<c01741f5>] getname+0x8c/0x9b
[    5.591032]  [<c0181cf0>] sys_mount+0x77/0xb7
[    5.591032]  [<c0103a02>] syscall_call+0x7/0xb
[    5.591032]  =======================
[    5.591032] proc_dir_entry 'min_to_scan' already registered
[    5.591032] Pid: 655, comm: mount Not tainted 2.6.27-rc3 #1
[    5.591032]  [<c019ea80>] proc_register+0xda/0x17d
[    5.592035]  [<c019eb85>] proc_create_data+0x62/0x9a
[    5.592036]  [<f8ad5adf>] ext4_mb_init+0x4cd/0x748 [ext4dev]
[    5.592036]  [<c0119f50>] __wake_up+0x32/0x42
[    5.592036]  [<c0123783>] printk+0x1b/0x1f
[    5.592036]  [<f8ac7d8a>] ext4_fill_super+0x1829/0x2043 [ext4dev]
[    5.592036]  [<c01de527>] snprintf+0x1f/0x23
[    5.592036]  [<c01a37bc>] disk_name+0x72/0xa6
[    5.592036]  [<c016e92f>] get_sb_bdev+0xea/0x10d
[    5.592036]  [<c0154d4c>] kstrdup+0x30/0x52
[    5.592036]  [<f8ac4690>] ext4_get_sb+0x20/0x25 [ext4dev]
[    5.592036]  [<f8ac6561>] ext4_fill_super+0x0/0x2043 [ext4dev]
[    5.593024]  [<c016e3d0>] vfs_kern_mount+0x37/0x88
[    5.593024]  [<c016e468>] do_kern_mount+0x31/0xbc
[    5.593024]  [<c0181aaa>] do_new_mount+0x69/0x8e
[    5.593024]  [<c0181c31>] do_mount+0x162/0x1aa
[    5.593024]  [<c017fb5e>] copy_mount_options+0x28/0x115
[    5.593024]  [<c01741f5>] getname+0x8c/0x9b
[    5.593024]  [<c0181cf0>] sys_mount+0x77/0xb7
[    5.593024]  [<c0103a02>] syscall_call+0x7/0xb
[    5.593024]  =======================
[    5.593024] proc_dir_entry 'order2_req' already registered
[    5.593024] Pid: 655, comm: mount Not tainted 2.6.27-rc3 #1
[    5.593024]  [<c019ea80>] proc_register+0xda/0x17d
[    5.593024]  [<c019eb85>] proc_create_data+0x62/0x9a
[    5.594007]  [<f8ad5b07>] ext4_mb_init+0x4f5/0x748 [ext4dev]
[    5.594007]  [<c0119f50>] __wake_up+0x32/0x42
[    5.594007]  [<c0123783>] printk+0x1b/0x1f
[    5.594007]  [<f8ac7d8a>] ext4_fill_super+0x1829/0x2043 [ext4dev]
[    5.594007]  [<c01de527>] snprintf+0x1f/0x23
[    5.594007]  [<c01a37bc>] disk_name+0x72/0xa6
[    5.594007]  [<c016e92f>] get_sb_bdev+0xea/0x10d
[    5.594007]  [<c0154d4c>] kstrdup+0x30/0x52
[    5.594007]  [<f8ac4690>] ext4_get_sb+0x20/0x25 [ext4dev]
[    5.594007]  [<f8ac6561>] ext4_fill_super+0x0/0x2043 [ext4dev]
[    5.594007]  [<c016e3d0>] vfs_kern_mount+0x37/0x88
[    5.595017]  [<c016e468>] do_kern_mount+0x31/0xbc
[    5.595017]  [<c0181aaa>] do_new_mount+0x69/0x8e
[    5.595017]  [<c0181c31>] do_mount+0x162/0x1aa
[    5.595017]  [<c017fb5e>] copy_mount_options+0x28/0x115
[    5.595017]  [<c01741f5>] getname+0x8c/0x9b
[    5.595017]  [<c0181cf0>] sys_mount+0x77/0xb7
[    5.595017]  [<c0103a02>] syscall_call+0x7/0xb
[    5.595017]  =======================
[    5.595017] proc_dir_entry 'stream_req' already registered
[    5.595017] Pid: 655, comm: mount Not tainted 2.6.27-rc3 #1
[    5.595017]  [<c019ea80>] proc_register+0xda/0x17d
[    5.595017]  [<c019eb85>] proc_create_data+0x62/0x9a
[    5.596019]  [<f8ad5b2f>] ext4_mb_init+0x51d/0x748 [ext4dev]
[    5.596020]  [<c0119f50>] __wake_up+0x32/0x42
[    5.596020]  [<c0123783>] printk+0x1b/0x1f
[    5.596020]  [<f8ac7d8a>] ext4_fill_super+0x1829/0x2043 [ext4dev]
[    5.596020]  [<c01de527>] snprintf+0x1f/0x23
[    5.596020]  [<c01a37bc>] disk_name+0x72/0xa6
[    5.596020]  [<c016e92f>] get_sb_bdev+0xea/0x10d
[    5.596020]  [<c0154d4c>] kstrdup+0x30/0x52
[    5.596020]  [<f8ac4690>] ext4_get_sb+0x20/0x25 [ext4dev]
[    5.596020]  [<f8ac6561>] ext4_fill_super+0x0/0x2043 [ext4dev]
[    5.596020]  [<c016e3d0>] vfs_kern_mount+0x37/0x88
[    5.597022]  [<c016e468>] do_kern_mount+0x31/0xbc
[    5.597025]  [<c0181aaa>] do_new_mount+0x69/0x8e
[    5.597025]  [<c0181c31>] do_mount+0x162/0x1aa
[    5.597025]  [<c017fb5e>] copy_mount_options+0x28/0x115
[    5.597025]  [<c01741f5>] getname+0x8c/0x9b
[    5.597025]  [<c0181cf0>] sys_mount+0x77/0xb7
[    5.597025]  [<c0103a02>] syscall_call+0x7/0xb
[    5.597025]  =======================
[    5.597025] proc_dir_entry 'group_prealloc' already registered
[    5.597025] Pid: 655, comm: mount Not tainted 2.6.27-rc3 #1
[    5.597025]  [<c019ea80>] proc_register+0xda/0x17d
[    5.597025]  [<c019eb85>] proc_create_data+0x62/0x9a
[    5.597025]  [<f8ad5b57>] ext4_mb_init+0x545/0x748 [ext4dev]
[    5.598018]  [<c0119f50>] __wake_up+0x32/0x42
[    5.598018]  [<c0123783>] printk+0x1b/0x1f
[    5.598018]  [<f8ac7d8a>] ext4_fill_super+0x1829/0x2043 [ext4dev]
[    5.598018]  [<c01de527>] snprintf+0x1f/0x23
[    5.598018]  [<c01a37bc>] disk_name+0x72/0xa6
[    5.598018]  [<c016e92f>] get_sb_bdev+0xea/0x10d
[    5.598018]  [<c0154d4c>] kstrdup+0x30/0x52
[    5.598018]  [<f8ac4690>] ext4_get_sb+0x20/0x25 [ext4dev]
[    5.598018]  [<f8ac6561>] ext4_fill_super+0x0/0x2043 [ext4dev]
[    5.598018]  [<c016e3d0>] vfs_kern_mount+0x37/0x88
[    5.598018]  [<c016e468>] do_kern_mount+0x31/0xbc
[    5.599025]  [<c0181aaa>] do_new_mount+0x69/0x8e
[    5.599025]  [<c0181c31>] do_mount+0x162/0x1aa
[    5.599025]  [<c017fb5e>] copy_mount_options+0x28/0x115
[    5.599025]  [<c01741f5>] getname+0x8c/0x9b
[    5.599025]  [<c0181cf0>] sys_mount+0x77/0xb7
[    5.599025]  [<c0103a02>] syscall_call+0x7/0xb
[    5.599025]  =======================
[    5.599025] EXT4-fs: mballoc enabled
[    5.632375] kjournald starting.  Commit interval 5 seconds
[    5.635419] EXT3 FS on cciss/c0d0p10, internal journal
[    5.635419] EXT3-fs: mounted filesystem with ordered data mode.
[    8.991976] tg3: eth0: Link is up at 1000 Mbps, full duplex.
[    8.991976] tg3: eth0: Flow control is on for TX and on for RX.
[   10.141001] tg3: eth1: Link is up at 100 Mbps, full duplex.
[   10.141001] tg3: eth1: Flow control is on for TX and on for RX.
[   12.605123] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   12.605123] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
[   12.605123] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   12.605123] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   12.639002] ip_tables: (C) 2000-2006 Netfilter Core Team
[   35.228001] JBD: barrier-based sync failed on cciss/c0d0p8 - disabling barriers
[   35.641007] JBD: barrier-based sync failed on cciss/c0d0p9 - disabling barriers

-- 
Ralf Hildebrandt (i.A. des IT-Zentrums)         Ralf.Hildebrandt@charite.de
Charite - Universit√§tsmedizin Berlin            Tel.  +49 (0)30-450 570-155
Gemeinsame Einrichtung von FU- und HU-Berlin    Fax.  +49 (0)30-450 570-962
IT-Zentrum Standort CBF                 send no mail to snickebo@charite.de
