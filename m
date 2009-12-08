Return-Path: <linux-kernel-owner+w=401wt.eu-S935720AbZLHAHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935720AbZLHAHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935337AbZLHAHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:07:48 -0500
Received: from twilight.fidra.de ([88.198.14.164]:47115 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935525AbZLHAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:07:46 -0500
From: Volker Lanz <vl@fidra.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Tue, 8 Dec 2009 01:07:48 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-tip-02731-gd17424f; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <200912072136.40202.vl@fidra.de> <4B1D7B47.4000306@kernel.org>
In-Reply-To: <4B1D7B47.4000306@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912080107.48201.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 December 2009 23:01:43 Yinghai Lu wrote:
> can you try to disable
> 
> CONFIG_X86_CHECK_BIOS_CORRUPTION
> and
> CONFIG_X86_RESERVE_LOW_64K

Still freezes and produces this log:

-----------------------------------------------------------------------------
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.32-tip-02731-gd17424f (vl@trevor) (gcc 
version 4.4.1 (Ubuntu 4.4.1-4ubuntu8) ) #24 SMP Tue Dec 8 00:51:32 CET 2009
[    0.000000] Command line: root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro 
nosplash debug
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 1C0000000 mask FC0000000 uncachable
[    0.000000]   5 base 1B0000000 mask FF0000000 uncachable
[    0.000000]   6 base 0CFF00000 mask FFFF00000 uncachable
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106
[    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-00000001b0000000
[    0.000000]  0100000000 - 01b0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1b0000000 @ c000-14000
[    0.000000] RAMDISK: 34054000 - 37fefd2f
[    0.000000] ACPI: RSDP 00000000000f7280 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfee2040 0004C (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: FACP 00000000cfee20c0 00074 (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000cfee2180 04CD9 (v01 GBT    GBTUACPI 00001000 
MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000cfee0000 00040
[    0.000000] ACPI: EUDS 00000000cfee7580 00500 (v01 GBT             00000000      
00000000)
[    0.000000] ACPI: HPET 00000000cfee74c0 00038 (v01 GBT    GBTUACPI 42302E31 
GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000cfee7540 0003C (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: APIC 00000000cfee6ec0 00084 (v01 GBT    GBTUACPI 42302E31 
GBTU 01010101)
[    0.000000] ACPI: SSDT 00000000cfee83b0 0018A (v01  PmRef  Cpu0Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee8540 0018A (v01  PmRef  Cpu1Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee86d0 0018A (v01  PmRef  Cpu2Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee8860 0018A (v01  PmRef  Cpu3Cst 00003001 
INTL 20040311)
[    0.000000] ACPI: SSDT 00000000cfee89f0 003AB (v01  PmRef    CpuPm 00003000 
INTL 20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] found SMP MP-table at [ffff8800000f5890] f5890
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001b0000000
[    0.000000] Bootmem setup node 0 0000000000000000-00000001b0000000
[    0.000000]   NODE_DATA [000000000000f000 - 0000000000013fff]
[    0.000000]   bootmap [0000000000014000 -  0000000000049fff] pages 36
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 01b0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0001000000 - 0001c89184]    TEXT DATA BSS ==> [0001000000 
- 0001c89184]
[    0.000000]   #3 [0034054000 - 0037fefd2f]          RAMDISK ==> [0034054000 
- 0037fefd2f]
[    0.000000]   #4 [0001c8a000 - 0001c8a0f6]              BRK ==> [0001c8a000 
- 0001c8a0f6]
[    0.000000]   #5 [0000001000 - 0000005000]      ACPI WAKEUP ==> [0000001000 
- 0000005000]
[    0.000000]   #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 
- 000000c000]
[    0.000000]   #7 [000000c000 - 000000f000]          PGTABLE ==> [000000c000 
- 000000f000]
[    0.000000]   #8 [00000f58a0 - 0000100000]    BIOS reserved ==> [00000f58a0 
- 0000100000]
[    0.000000]   #9 [00000f5890 - 00000f58a0]     MP-table mpf ==> [00000f5890 
- 00000f58a0]
[    0.000000]   #10 [000009f800 - 00000f0d00]    BIOS reserved ==> 
[000009f800 - 00000f0d00]
[    0.000000]   #11 [00000f0ebc - 00000f5890]    BIOS reserved ==> 
[00000f0ebc - 00000f5890]
[    0.000000]   #12 [00000f0d00 - 00000f0ebc]     MP-table mpc ==> 
[00000f0d00 - 00000f0ebc]
[    0.000000]  [ffffea0000000000-ffffea0005ffffff] PMD -> [ffff880028600000-
ffff88002dbfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001b0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfee0
[    0.000000]     0: 0x00100000 -> 0x001b0000
[    0.000000] On node 0 totalpages: 1572479
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 109 pages reserved
[    0.000000]   DMA zone: 3834 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 9856 pages used for memmap
[    0.000000]   Normal zone: 711040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfee0000 - 
00000000cfee2000
[    0.000000] PM: Registered nosave memory: 00000000cfee2000 - 
00000000cfef0000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 
00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at e4000000 (gap: 
e4000000:1ac00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880028200000 s91416 r8192 
d23272 u524288
[    0.000000] pcpu-alloc: s91416 r8192 d23272 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total 
pages: 1548178
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=160351ee-
c9b0-4a72-9fd5-9962c8137a7e ro nosplash debug
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 6057096k/7077888k available (5317k kernel code, 787972k 
absent, 232820k reserved, 5695k data, 652k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want 
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2832.939 MHz processor.
[    0.010005] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5665.87 BogoMIPS (lpj=28329390)
[    0.010102] Security Framework initialized
[    0.010145] SELinux:  Disabled at boot.
[    0.010695] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.015425] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.017744] Mount-cache hash table entries: 256
[    0.017910] Initializing cgroup subsys ns
[    0.017951] Initializing cgroup subsys cpuacct
[    0.017991] Initializing cgroup subsys memory
[    0.018619] Initializing cgroup subsys freezer
[    0.018657] Initializing cgroup subsys net_cls
[    0.018713] CPU 0/0x0 -> Node 0
[    0.018751] CPU: Physical Processor ID: 0
[    0.018788] CPU: Processor Core ID: 0
[    0.018827] mce: CPU supports 6 MCE banks
[    0.018870] CPU0: Thermal monitoring enabled (TM2)
[    0.018910] using mwait in idle threads.
[    0.018948] Performance Events: Core2 events, Intel PMU driver.
[    0.019043] ... version:                2
[    0.019081] ... bit width:              40
[    0.019118] ... generic registers:      2
[    0.019156] ... value mask:             000000ffffffffff
[    0.019195] ... max period:             000000007fffffff
[    0.019233] ... fixed-purpose events:   3
[    0.019271] ... event mask:             0000000700000003
[    0.020332] ACPI: Core revision 20090903
[    0.028442] Setting APIC routing to flat
[    0.028781] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.128834] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.130000] Booting processor 1 APIC 0x3 ip 0x6000
[    0.130000] Initializing CPU#1
[    0.130000] CPU 1/0x3 -> Node 0
[    0.130000] CPU: Physical Processor ID: 0
[    0.130000] CPU: Processor Core ID: 3
[    0.130000] CPU1: Thermal monitoring enabled (TM2)
[    0.280052] CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.290060] Booting processor 2 APIC 0x2 ip 0x6000
[    0.290051] Initializing CPU#2
[    0.290051] CPU 2/0x2 -> Node 0
[    0.290051] CPU: Physical Processor ID: 0
[    0.290051] CPU: Processor Core ID: 2
[    0.290051] CPU2: Thermal monitoring enabled (TM2)
[    0.450108] CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.460059] Booting processor 3 APIC 0x1 ip 0x6000
[    0.460050] Initializing CPU#3
[    0.460050] CPU 3/0x1 -> Node 0
[    0.460050] CPU: Physical Processor ID: 0
[    0.460050] CPU: Processor Core ID: 1
[    0.460050] CPU3: Thermal monitoring enabled (TM2)
[    0.620064] CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.630012] Brought up 4 CPUs
[    0.630052] Total of 4 processors activated (22663.99 BogoMIPS).
[    0.632708] regulator: core version 0.5
[    0.632766] Time:  0:58:25  Date: 12/08/09
[    0.632833] NET: Registered protocol family 16
[    0.632955] ACPI: bus type pci registered
[    0.633042] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.633083] PCI: MCFG area at e0000000 reserved in E820
[    0.634390] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.634429] PCI: Using configuration type 1 for base access
[    0.635096] bio: create slab <bio-0> at 0
[    0.635599] ACPI: EC: Look up EC in DSDT
[    0.640344] ACPI: Interpreter enabled
[    0.640387] ACPI: (supports S0 S3 S4 S5)
[    0.640545] ACPI: Using IOAPIC for interrupt routing
[    0.644159] ACPI: No dock devices found.
[    0.644271] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.644329] PCI: Scanning bus 0000:00
[    0.644372] pci 0000:00:00.0: found [8086:2e20] class 000600 header type 00
[    0.644430] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.644472] pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.644525] pci 0000:00:01.0: found [8086:2e21] class 000604 header type 01
[    0.644578] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x19f
[    0.644619] pci 0000:00:01.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.644668] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.644709] pci 0000:00:01.0: PME# disabled
[    0.644775] pci 0000:00:1a.0: found [8086:3a37] class 000c03 header type 00
[    0.644840] pci 0000:00:1a.0: reg 20 io port: [0xe100-0xe11f]
[    0.644889] pci 0000:00:1a.0: calling quirk_resource_alignment+0x0/0x19f
[    0.644930] pci 0000:00:1a.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.644990] pci 0000:00:1a.1: found [8086:3a38] class 000c03 header type 00
[    0.645055] pci 0000:00:1a.1: reg 20 io port: [0xe200-0xe21f]
[    0.645103] pci 0000:00:1a.1: calling quirk_resource_alignment+0x0/0x19f
[    0.645144] pci 0000:00:1a.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645204] pci 0000:00:1a.2: found [8086:3a39] class 000c03 header type 00
[    0.645269] pci 0000:00:1a.2: reg 20 io port: [0xe000-0xe01f]
[    0.645318] pci 0000:00:1a.2: calling quirk_resource_alignment+0x0/0x19f
[    0.645358] pci 0000:00:1a.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645425] pci 0000:00:1a.7: found [8086:3a3c] class 000c03 header type 00
[    0.645479] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe9305000-0xe93053ff]
[    0.645543] pci 0000:00:1a.7: calling quirk_resource_alignment+0x0/0x19f
[    0.645584] pci 0000:00:1a.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645649] pci 0000:00:1b.0: found [8086:3a3e] class 000403 header type 00
[    0.645703] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe9300000-0xe9303fff]
[    0.645760] pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x19f
[    0.645801] pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.645856] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.645897] pci 0000:00:1b.0: PME# disabled
[    0.645947] pci 0000:00:1c.0: found [8086:3a40] class 000604 header type 01
[    0.646005] pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x19f
[    0.646046] pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646103] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.646144] pci 0000:00:1c.0: PME# disabled
[    0.646197] pci 0000:00:1c.3: found [8086:3a46] class 000604 header type 01
[    0.646255] pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x19f
[    0.646296] pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646352] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.646393] pci 0000:00:1c.3: PME# disabled
[    0.646445] pci 0000:00:1c.4: found [8086:3a48] class 000604 header type 01
[    0.646502] pci 0000:00:1c.4: calling quirk_resource_alignment+0x0/0x19f
[    0.646543] pci 0000:00:1c.4: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646600] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.646641] pci 0000:00:1c.4: PME# disabled
[    0.646696] pci 0000:00:1d.0: found [8086:3a34] class 000c03 header type 00
[    0.646760] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.646809] pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x19f
[    0.646850] pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.646910] pci 0000:00:1d.1: found [8086:3a35] class 000c03 header type 00
[    0.646975] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.647023] pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x19f
[    0.647064] pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647124] pci 0000:00:1d.2: found [8086:3a36] class 000c03 header type 00
[    0.647189] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.647237] pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x19f
[    0.647278] pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647343] pci 0000:00:1d.7: found [8086:3a3a] class 000c03 header type 00
[    0.647396] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe9304000-0xe93043ff]
[    0.647461] pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x19f
[    0.647502] pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647563] pci 0000:00:1e.0: found [8086:244e] class 000604 header type 01
[    0.647622] pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x19f
[    0.647663] pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647724] pci 0000:00:1f.0: found [8086:3a18] class 000601 header type 00
[    0.647808] pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x19f
[    0.647849] pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.647915] pci 0000:00:1f.2: found [8086:3a20] class 000101 header type 00
[    0.647968] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.648010] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.648052] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.648094] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.648136] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.648178] pci 0000:00:1f.2: reg 24 io port: [0xf100-0xf10f]
[    0.648224] pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x19f
[    0.648265] pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.648325] pci 0000:00:1f.3: found [8086:3a30] class 000c05 header type 00
[    0.648374] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe9306000-0xe93060ff]
[    0.648423] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.648471] pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x19f
[    0.648512] pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.648564] pci 0000:00:1f.5: found [8086:3a26] class 000101 header type 00
[    0.648617] pci 0000:00:1f.5: reg 10 io port: [0xe700-0xe707]
[    0.648659] pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe803]
[    0.648701] pci 0000:00:1f.5: reg 18 io port: [0xe900-0xe907]
[    0.648744] pci 0000:00:1f.5: reg 1c io port: [0xea00-0xea03]
[    0.648786] pci 0000:00:1f.5: reg 20 io port: [0xeb00-0xeb0f]
[    0.648828] pci 0000:00:1f.5: reg 24 io port: [0xec00-0xec0f]
[    0.648873] pci 0000:00:1f.5: calling quirk_resource_alignment+0x0/0x19f
[    0.648914] pci 0000:00:1f.5: calling pci_fixup_transparent_bridge+0x0/0x2a
[    0.648972] PCI: Fixups for bus 0000:00
[    0.649010] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 0
[    0.649052] PCI: Scanning bus 0000:01
[    0.649098] pci 0000:01:00.0: found [10de:0402] class 000300 header type 00
[    0.649148] pci 0000:01:00.0: reg 10 32bit mmio: [0xe6000000-0xe6ffffff]
[    0.649194] pci 0000:01:00.0: reg 14 64bit mmio pref: 
[0xd0000000-0xdfffffff]
[    0.649240] pci 0000:01:00.0: reg 1c 64bit mmio: [0xe4000000-0xe5ffffff]
[    0.649283] pci 0000:01:00.0: reg 24 io port: [0xb000-0xb07f]
[    0.649325] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.649368] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.649450] PCI: Fixups for bus 0000:01
[    0.649488] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.649529] pci 0000:00:01.0: bridge 32bit mmio: [0xe4000000-0xe7ffffff]
[    0.649571] pci 0000:00:01.0: bridge 64bit mmio pref: 
[0xd0000000-0xdfffffff]
[    0.649611] PCI: Bus scan for 0000:01 returning with max=01
[    0.649652] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
[    0.650009] PCI: Scanning bus 0000:02
[    0.650070] PCI: Fixups for bus 0000:02
[    0.650114] PCI: Bus scan for 0000:02 returning with max=02
[    0.650164] pci 0000:00:1c.3: scanning behind bridge, config 030300, pass 0
[    0.650216] PCI: Scanning bus 0000:03
[    0.650269] pci 0000:03:00.0: found [197b:2363] class 000101 header type 00
[    0.650320] pci 0000:03:00.0: calling quirk_jmicron_ata+0x0/0x140
[    0.650408] pci 0000:03:00.0: reg 24 32bit mmio: [0xe9000000-0xe9001fff]
[    0.650458] pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.650522] pci 0000:03:00.0: PME# supported from D3hot
[    0.650564] pci 0000:03:00.0: PME# disabled
[    0.650626] pci 0000:03:00.1: found [197b:2363] class 000101 header type 00
[    0.650679] pci 0000:03:00.1: calling quirk_jmicron_ata+0x0/0x140
[    0.650728] pci 0000:03:00.1: reg 10 io port: [0xc000-0xc007]
[    0.650773] pci 0000:03:00.1: reg 14 io port: [0xc100-0xc103]
[    0.651417] pci 0000:03:00.1: reg 18 io port: [0xc200-0xc207]
[    0.651462] pci 0000:03:00.1: reg 1c io port: [0xc300-0xc303]
[    0.651508] pci 0000:03:00.1: reg 20 io port: [0xc400-0xc40f]
[    0.651565] pci 0000:03:00.1: calling quirk_resource_alignment+0x0/0x19f
[    0.651661] PCI: Fixups for bus 0000:03
[    0.651700] pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
[    0.651741] pci 0000:00:1c.3: bridge 32bit mmio: [0xe9000000-0xe90fffff]
[    0.651784] PCI: Bus scan for 0000:03 returning with max=03
[    0.651825] pci 0000:00:1c.4: scanning behind bridge, config 040400, pass 0
[    0.651868] PCI: Scanning bus 0000:04
[    0.651921] pci 0000:04:00.0: found [10ec:8168] class 000200 header type 00
[    0.651979] pci 0000:04:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.652034] pci 0000:04:00.0: reg 18 64bit mmio pref: 
[0xe9110000-0xe9110fff]
[    0.652085] pci 0000:04:00.0: reg 20 64bit mmio pref: 
[0xe9100000-0xe910ffff]
[    0.652131] pci 0000:04:00.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
[    0.652175] pci 0000:04:00.0: calling quirk_resource_alignment+0x0/0x19f
[    0.652244] pci 0000:04:00.0: supports D1 D2
[    0.652282] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.652325] pci 0000:04:00.0: PME# disabled
[    0.652403] PCI: Fixups for bus 0000:04
[    0.652442] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.652483] pci 0000:00:1c.4: bridge 32bit mmio: [0xe8000000-0xe8ffffff]
[    0.652526] pci 0000:00:1c.4: bridge 64bit mmio pref: 
[0xe9100000-0xe91fffff]
[    0.652567] PCI: Bus scan for 0000:04 returning with max=04
[    0.652608] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 0
[    0.652651] PCI: Scanning bus 0000:05
[    0.652706] pci 0000:05:07.0: found [104c:8024] class 000c00 header type 00
[    0.652761] pci 0000:05:07.0: reg 10 32bit mmio: [0xe9204000-0xe92047ff]
[    0.652805] pci 0000:05:07.0: reg 14 32bit mmio: [0xe9200000-0xe9203fff]
[    0.652868] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x19f
[    0.652921] pci 0000:05:07.0: supports D1 D2
[    0.652959] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.653000] pci 0000:05:07.0: PME# disabled
[    0.653068] PCI: Fixups for bus 0000:05
[    0.653105] pci 0000:00:1e.0: transparent bridge
[    0.653147] pci 0000:00:1e.0: bridge 32bit mmio: [0xe9200000-0xe92fffff]
[    0.653190] PCI: Bus scan for 0000:05 returning with max=05
[    0.653230] pci 0000:00:01.0: scanning behind bridge, config 010100, pass 1
[    0.653273] pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
[    0.653316] pci 0000:00:1c.3: scanning behind bridge, config 030300, pass 1
[    0.653359] pci 0000:00:1c.4: scanning behind bridge, config 040400, pass 1
[    0.653403] pci 0000:00:1e.0: scanning behind bridge, config 050500, pass 1
[    0.653445] PCI: Bus scan for 0000:00 returning with max=05
[    0.653486] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.653624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.653704] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.653788] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.653866] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.665892] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 
15)
[    0.666349] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.666859] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 
15)
[    0.667316] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 
15)
[    0.667772] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.668281] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 
15)
[    0.668737] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 
15)
[    0.669193] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 
15)
[    0.669651] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.669702] vgaarb: loaded
[    0.669812] SCSI subsystem initialized
[    0.669935] libata version 3.00 loaded.
[    0.670035] usbcore: registered new interface driver usbfs
[    0.670086] usbcore: registered new interface driver hub
[    0.670150] usbcore: registered new device driver usb
[    0.670277] ACPI: WMI: Mapper loaded
[    0.670315] PCI: Using ACPI for IRQ routing
[    0.670471] Bluetooth: Core ver 2.15
[    0.670526] NET: Registered protocol family 31
[    0.670564] Bluetooth: HCI device and connection manager initialized
[    0.670605] Bluetooth: HCI socket layer initialized
[    0.670644] NetLabel: Initializing
[    0.670681] NetLabel:  domain hash size = 128
[    0.670719] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.670765] NetLabel:  unlabeled traffic allowed by default
[    0.670819] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.670864] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.671036] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.680021] Switching to clocksource tsc
[    0.681262] pnp: PnP ACPI init
[    0.681305] ACPI: bus type pnp registered
[    0.682946] pnp: PnP ACPI: found 12 devices
[    0.682984] ACPI: ACPI bus type pnp unregistered
[    0.683028] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.683068] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.683109] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.683149] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.683190] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.683230] system 00:01: ioport range 0x4c0-0x4ff could not be reserved
[    0.683273] system 00:08: ioport range 0x400-0x4bf has been reserved
[    0.683316] system 00:09: iomem range 0xe0000000-0xe3ffffff has been 
reserved
[    0.683358] system 00:0a: iomem range 0xccc00-0xcffff has been reserved
[    0.683399] system 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
[    0.683440] system 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
[    0.683481] system 00:0a: iomem range 0xfc000-0xfffff could not be reserved
[    0.683522] system 00:0a: iomem range 0xcfee0000-0xcfefffff could not be 
reserved
[    0.683571] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.683612] system 00:0a: iomem range 0x100000-0xcfedffff could not be 
reserved
[    0.683660] system 00:0a: iomem range 0xfec00000-0xfec00fff could not be 
reserved
[    0.683709] system 00:0a: iomem range 0xfed10000-0xfed1dfff has been 
reserved
[    0.683750] system 00:0a: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.683791] system 00:0a: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.683832] system 00:0a: iomem range 0xffb00000-0xffb7ffff has been 
reserved
[    0.683873] system 00:0a: iomem range 0xfff00000-0xffffffff has been 
reserved
[    0.683915] system 00:0a: iomem range 0xe0000-0xeffff has been reserved
[    0.688589] pci 0000:01:00.0: BAR 6: got res [0xe7000000-0xe701ffff] bus 
[0xe7000000-0xe701ffff] flags 0x27200
[    0.688641] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.688681] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.688721] pci 0000:00:01.0:   MEM window: 0xe4000000-0xe7ffffff
[    0.688762] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.688811] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.688852] pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
[    0.688893] pci 0000:00:1c.0:   MEM window: 0xe9400000-0xe95fffff
[    0.688934] pci 0000:00:1c.0:   PREFETCH window: 
0x000000e9600000-0x000000e97fffff
[    0.688985] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.689026] pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
[    0.689067] pci 0000:00:1c.3:   MEM window: 0xe9000000-0xe90fffff
[    0.689108] pci 0000:00:1c.3:   PREFETCH window: 
0x000000e9800000-0x000000e99fffff
[    0.689160] pci 0000:04:00.0: BAR 6: got res [0xe9120000-0xe912ffff] bus 
[0xe9120000-0xe912ffff] flags 0x27200
[    0.689211] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.689251] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.689292] pci 0000:00:1c.4:   MEM window: 0xe8000000-0xe8ffffff
[    0.689333] pci 0000:00:1c.4:   PREFETCH window: 
0x000000e9100000-0x000000e91fffff
[    0.689384] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.689424] pci 0000:00:1e.0:   IO window: disabled
[    0.689464] pci 0000:00:1e.0:   MEM window: 0xe9200000-0xe92fffff
[    0.689521] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.689565]   alloc irq_desc for 16 on node -1
[    0.689609]   alloc kstat_irqs on node -1
[    0.689654] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.689705] pci 0000:00:01.0: setting latency timer to 64
[    0.689748] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.689790] pci 0000:00:1c.0: setting latency timer to 64
[    0.689833]   alloc irq_desc for 19 on node -1
[    0.689871]   alloc kstat_irqs on node -1
[    0.689910] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.689951] pci 0000:00:1c.3: setting latency timer to 64
[    0.689995] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.690036] pci 0000:00:1c.4: setting latency timer to 64
[    0.690078] pci 0000:00:1e.0: setting latency timer to 64
[    0.690119] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.690159] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.690199] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.690239] pci_bus 0000:01: resource 1 mem: [0xe4000000-0xe7ffffff]
[    0.690279] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.690319] pci_bus 0000:02: resource 0 io:  [0x1000-0x1fff]
[    0.690359] pci_bus 0000:02: resource 1 mem: [0xe9400000-0xe95fffff]
[    0.690399] pci_bus 0000:02: resource 2 pref mem [0xe9600000-0xe97fffff]
[    0.690440] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    0.690479] pci_bus 0000:03: resource 1 mem: [0xe9000000-0xe90fffff]
[    0.690519] pci_bus 0000:03: resource 2 pref mem [0xe9800000-0xe99fffff]
[    0.690560] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.690599] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe8ffffff]
[    0.690640] pci_bus 0000:04: resource 2 pref mem [0xe9100000-0xe91fffff]
[    0.690680] pci_bus 0000:05: resource 1 mem: [0xe9200000-0xe92fffff]
[    0.690720] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.690760] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.690819] NET: Registered protocol family 2
[    0.691025] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.691931] TCP established hash table entries: 524288 (order: 11, 8388608 
bytes)
[    0.695359] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.695967] TCP: Hash tables configured (established 524288 bind 65536)
[    0.696606] TCP reno registered
[    0.696740] NET: Registered protocol family 1
[    0.696799] pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x192
[    0.696841] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.696882] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.696924] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xbd
[    0.696965] pci 0000:00:01.0: calling quirk_e100_interrupt+0x0/0x192
[    0.697005] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.697046] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.697086] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xbd
[    0.697127] pci 0000:00:1a.0: calling quirk_e100_interrupt+0x0/0x192
[    0.697168] pci 0000:00:1a.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.697208] pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.697261] pci 0000:00:1a.0: calling pci_fixup_video+0x0/0xbd
[    0.697303] pci 0000:00:1a.1: calling quirk_e100_interrupt+0x0/0x192
[    0.697343] pci 0000:00:1a.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.697384] pci 0000:00:1a.1: calling quirk_usb_early_handoff+0x0/0x580
[    0.697435] pci 0000:00:1a.1: calling pci_fixup_video+0x0/0xbd
[    0.697476] pci 0000:00:1a.2: calling quirk_e100_interrupt+0x0/0x192
[    0.697516] pci 0000:00:1a.2: calling quirk_cardbus_legacy+0x0/0x30
[    0.697556] pci 0000:00:1a.2: calling quirk_usb_early_handoff+0x0/0x580
[    0.697608] pci 0000:00:1a.2: calling pci_fixup_video+0x0/0xbd
[    0.697649] pci 0000:00:1a.7: calling quirk_e100_interrupt+0x0/0x192
[    0.697690] pci 0000:00:1a.7: calling quirk_cardbus_legacy+0x0/0x30
[    0.697730] pci 0000:00:1a.7: calling quirk_usb_early_handoff+0x0/0x580
[    0.697790] pci 0000:00:1a.7: calling pci_fixup_video+0x0/0xbd
[    0.697831] pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x192
[    0.697871] pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.697912] pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.697952] pci 0000:00:1b.0: calling pci_fixup_video+0x0/0xbd
[    0.697993] pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x192
[    0.698034] pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.698074] pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.698115] pci 0000:00:1c.0: calling pci_fixup_video+0x0/0xbd
[    0.698156] pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x192
[    0.698197] pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x30
[    0.698237] pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x580
[    0.698278] pci 0000:00:1c.3: calling pci_fixup_video+0x0/0xbd
[    0.698319] pci 0000:00:1c.4: calling quirk_e100_interrupt+0x0/0x192
[    0.698359] pci 0000:00:1c.4: calling quirk_cardbus_legacy+0x0/0x30
[    0.698400] pci 0000:00:1c.4: calling quirk_usb_early_handoff+0x0/0x580
[    0.698440] pci 0000:00:1c.4: calling pci_fixup_video+0x0/0xbd
[    0.698481] pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x192
[    0.698522] pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.698562] pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.698614] pci 0000:00:1d.0: calling pci_fixup_video+0x0/0xbd
[    0.698655] pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x192
[    0.698695] pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.698736] pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x580
[    0.698787] pci 0000:00:1d.1: calling pci_fixup_video+0x0/0xbd
[    0.698828] pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x192
[    0.698868] pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x30
[    0.698909] pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x580
[    0.698960] pci 0000:00:1d.2: calling pci_fixup_video+0x0/0xbd
[    0.699001] pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x192
[    0.699042] pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x30
[    0.699082] pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x580
[    0.699148] pci 0000:00:1d.7: calling pci_fixup_video+0x0/0xbd
[    0.699189] pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x192
[    0.699230] pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.699270] pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.699311] pci 0000:00:1e.0: calling pci_fixup_video+0x0/0xbd
[    0.699352] pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x192
[    0.699392] pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.699432] pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.699473] pci 0000:00:1f.0: calling pci_fixup_video+0x0/0xbd
[    0.699546] pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x192
[    0.699586] pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x30
[    0.699636] pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x580
[    0.699687] pci 0000:00:1f.2: calling pci_fixup_video+0x0/0xbd
[    0.699728] pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x192
[    0.699769] pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x30
[    0.699809] pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x580
[    0.699850] pci 0000:00:1f.3: calling pci_fixup_video+0x0/0xbd
[    0.699891] pci 0000:00:1f.5: calling quirk_e100_interrupt+0x0/0x192
[    0.699931] pci 0000:00:1f.5: calling quirk_cardbus_legacy+0x0/0x30
[    0.699972] pci 0000:00:1f.5: calling quirk_usb_early_handoff+0x0/0x580
[    0.700012] pci 0000:00:1f.5: calling pci_fixup_video+0x0/0xbd
[    0.700053] pci 0000:01:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0xd
[    0.700100] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.700140] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.700181] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xbd
[    0.700222] pci 0000:01:00.0: Boot video device
[    0.700261] pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.700301] pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.700342] pci 0000:03:00.0: calling pci_fixup_video+0x0/0xbd
[    0.700383] pci 0000:03:00.1: calling quirk_cardbus_legacy+0x0/0x30
[    0.700423] pci 0000:03:00.1: calling quirk_usb_early_handoff+0x0/0x580
[    0.700464] pci 0000:03:00.1: calling pci_fixup_video+0x0/0xbd
[    0.700504] pci 0000:04:00.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.700545] pci 0000:04:00.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.700585] pci 0000:04:00.0: calling pci_fixup_video+0x0/0xbd
[    0.700626] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x30
[    0.700666] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x580
[    0.700707] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xbd
[    0.700787] Trying to unpack rootfs image as initramfs...
[    1.811056] Freeing initrd memory: 65135k freed
[    1.841393] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.841437] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    1.841486] software IO TLB at phys 0x20000000 - 0x24000000
[    1.841911] audit: initializing netlink socket (disabled)
[    1.841963] type=2000 audit(1260233905.830:1): initialized
[    1.852106] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.853125] VFS: Disk quotas dquot_6.5.2
[    1.853199] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.853621] fuse init (API version 7.13)
[    1.853712] msgmni has been set to 11957
[    1.853938] alg: No test for stdrng (krng)
[    1.853982] io scheduler noop registered
[    1.854020] io scheduler anticipatory registered
[    1.854058] io scheduler deadline registered
[    1.854120] io scheduler cfq registered (default)
[    1.854241]   alloc irq_desc for 24 on node -1
[    1.854280]   alloc kstat_irqs on node -1
[    1.854324] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.854366] pcieport 0000:00:01.0: setting latency timer to 64
[    1.854473]   alloc irq_desc for 25 on node -1
[    1.854511]   alloc kstat_irqs on node -1
[    1.854552] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.854596] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.854715]   alloc irq_desc for 26 on node -1
[    1.854753]   alloc kstat_irqs on node -1
[    1.854795] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    1.854838] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.854958]   alloc irq_desc for 27 on node -1
[    1.854997]   alloc kstat_irqs on node -1
[    1.855038] pcieport 0000:00:1c.4: irq 27 for MSI/MSI-X
[    1.855081] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.855181] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.855286] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.855435] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.855485] ACPI: Power Button [PWRB]
[    1.855563] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.855611] ACPI: Power Button [PWRF]
[    1.856023] ACPI: SSDT 00000000cfee7ad0 0022A (v01  PmRef  Cpu0Ist 00003000 
INTL 20040311)
[    1.856278] Marking TSC unstable due to TSC halts in idle
[    1.856344] processor LNXCPU:00: registered as cooling_device0
[    1.856560] ACPI: SSDT 00000000cfee7f90 00152 (v01  PmRef  Cpu1Ist 00003000 
INTL 20040311)
[    1.856881] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU1._PDC] (Node ffff8801a9048f40), AE_ALREADY_EXISTS
[    1.857016] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.857168] Switching to clocksource hpet
[    1.857355] processor LNXCPU:01: registered as cooling_device1
[    1.857596] ACPI: SSDT 00000000cfee80f0 00152 (v01  PmRef  Cpu2Ist 00003000 
INTL 20040311)
[    1.857918] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU2._PDC] (Node ffff8801a9048fc0), AE_ALREADY_EXISTS
[    1.858052] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.858267] processor LNXCPU:02: registered as cooling_device2
[    1.858474] ACPI: SSDT 00000000cfee8250 00152 (v01  PmRef  Cpu3Ist 00003000 
INTL 20040311)
[    1.858796] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU3._PDC] (Node ffff8801a904f040), AE_ALREADY_EXISTS
[    1.858930] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    1.859170] processor LNXCPU:03: registered as cooling_device3
[    1.861417] Linux agpgart interface v0.103
[    1.861461] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.862338] brd: module loaded
[    1.862696] loop: module loaded
[    1.862774] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    1.862880] ahci 0000:03:00.0: version 3.0
[    1.862930] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.883784] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 
impl SATA mode
[    1.883836] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum 
part 
[    1.883887] ahci 0000:03:00.0: setting latency timer to 64
[    1.884055] scsi0 : ahci
[    1.884139] scsi1 : ahci
[    1.884230] ata1: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000100 
irq 19
[    1.884280] ata2: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000180 
irq 19
[    2.230026] ata1: SATA link down (SStatus 0 SControl 300)
[    2.600025] ata2: SATA link down (SStatus 0 SControl 300)
[    2.620048] ata_piix 0000:00:1f.2: version 2.13
[    2.620095] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    2.620144] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.620341] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.620424] scsi2 : ata_piix
[    2.620497] scsi3 : ata_piix
[    2.621064] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    2.621107] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    3.480056] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.480113] ata3.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.546222] ata3.00: HPA detected: current 1953523055, native 1953525168
[    3.546268] ata3.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    3.546315] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.546491] ata3.01: ATA-7: ST3300831AS, 3.02, max UDMA/133
[    3.546532] ata3.01: 586072368 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.606227] ata3.00: configured for UDMA/133
[    3.620301] ata3.01: configured for UDMA/133
[    3.620431] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 
PQ: 0 ANSI: 5
[    3.620540] sd 2:0:0:0: [sda] 1953523055 512-byte logical blocks: (1.00 
TB/931 GiB)
[    3.620617] sd 2:0:0:0: [sda] Write Protect is off
[    3.620657] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.620710] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.620843]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
[    3.709071] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.709139] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.709218] scsi 2:0:1:0: Direct-Access     ATA      ST3300831AS      3.02 
PQ: 0 ANSI: 5
[    3.709318] sd 2:0:1:0: [sdb] 586072368 512-byte logical blocks: (300 
GB/279 GiB)
[    3.709394] sd 2:0:1:0: [sdb] Write Protect is off
[    3.709433] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.709486] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.709609]  sdb: sdb1
[    3.728148] sd 2:0:1:0: [sdb] Attached SCSI disk
[    3.728212] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    4.580055] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.580112] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.620286] ata4.00: HPA detected: current 976771055, native 976773168
[    4.620330] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    4.620372] ata4.00: 976771055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.620432] ata4.01: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
[    4.640301] ata4.00: configured for UDMA/133
[    4.680191] ata4.01: configured for UDMA/100
[    4.680567] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    4.680684] sd 3:0:0:0: [sdc] 976771055 512-byte logical blocks: (500 
GB/465 GiB)
[    4.680759] sd 3:0:0:0: [sdc] Write Protect is off
[    4.680798] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.680851] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.680969]  sdc: sdc2 < sdc5 sdc6 sdc7 > sdc3
[    4.741871] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.741934] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    4.743158] scsi 3:0:1:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 
PQ: 0 ANSI: 5
[    4.746828] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
cdda tray
[    4.746880] Uniform CD-ROM driver Revision: 3.20
[    4.746989] sr 3:0:1:0: Attached scsi CD-ROM sr0
[    4.747051] sr 3:0:1:0: Attached scsi generic sg3 type 5
[    4.747105] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    4.747147] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.747343] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.747409] scsi4 : ata_piix
[    4.747479] scsi5 : ata_piix
[    4.747880] ata5: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 
19
[    4.747922] ata6: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 
19
[    5.100654] ata5: SATA link down (SStatus 0 SControl 300)
[    5.460629] ata6: SATA link down (SStatus 0 SControl 300)
[    5.460890] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    5.460933] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> 
IRQ 16
[    5.460998] pata_jmicron 0000:03:00.1: enabling bus mastering
[    5.461040] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    5.461117] scsi6 : pata_jmicron
[    5.461188] scsi7 : pata_jmicron
[    5.461692] ata7: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 
16
[    5.461734] ata8: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 
16
[    5.791753] Fixed MDIO Bus: probed
[    5.791812] PPP generic driver version 2.4.2
[    5.791892] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.791943]   alloc irq_desc for 18 on node -1
[    5.791981]   alloc kstat_irqs on node -1
[    5.792021] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.792068] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.792109] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.792175] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    5.796118] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    5.796167] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe9305000
[    5.820012] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.820125] usb usb1: configuration #1 chosen from 1 choice
[    5.820187] hub 1-0:1.0: USB hub found
[    5.820228] hub 1-0:1.0: 6 ports detected
[    5.820307]   alloc irq_desc for 23 on node -1
[    5.820345]   alloc kstat_irqs on node -1
[    5.820385] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.820431] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.820471] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.820534] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    5.824470] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.824517] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe9304000
[    5.840012] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.840103] usb usb2: configuration #1 chosen from 1 choice
[    5.840173] hub 2-0:1.0: USB hub found
[    5.840214] hub 2-0:1.0: 6 ports detected
[    5.840291] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.840339] uhci_hcd: USB Universal Host Controller Interface driver
[    5.840410] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    5.840453] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.840494] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.840554] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    5.840621] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
[    5.840710] usb usb3: configuration #1 chosen from 1 choice
[    5.840766] hub 3-0:1.0: USB hub found
[    5.840807] hub 3-0:1.0: 2 ports detected
[    5.840873]   alloc irq_desc for 21 on node -1
[    5.840911]   alloc kstat_irqs on node -1
[    5.840950] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    5.840994] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.841034] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.841092] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    5.841162] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
[    5.841249] usb usb4: configuration #1 chosen from 1 choice
[    5.841305] hub 4-0:1.0: USB hub found
[    5.841345] hub 4-0:1.0: 2 ports detected
[    5.841411] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.841454] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.841494] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.841550] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    5.841615] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
[    5.841703] usb usb5: configuration #1 chosen from 1 choice
[    5.841757] hub 5-0:1.0: USB hub found
[    5.841798] hub 5-0:1.0: 2 ports detected
[    5.841866] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.841909] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.841950] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.842006] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    5.842071] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    5.842158] usb usb6: configuration #1 chosen from 1 choice
[    5.842212] hub 6-0:1.0: USB hub found
[    5.842254] hub 6-0:1.0: 2 ports detected
[    5.842322] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    5.842365] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.842405] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.842468] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    5.842534] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    5.842621] usb usb7: configuration #1 chosen from 1 choice
[    5.842675] hub 7-0:1.0: USB hub found
[    5.842717] hub 7-0:1.0: 2 ports detected
[    5.842784] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.842828] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.842868] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.842924] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    5.842989] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    5.843076] usb usb8: configuration #1 chosen from 1 choice
[    5.843131] hub 8-0:1.0: USB hub found
[    5.843171] hub 8-0:1.0: 2 ports detected
[    5.843270] PNP: No PS/2 controller found. Probing ports directly.
[    5.843646] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.843690] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.843811] mice: PS/2 mouse device common for all mice
[    5.843892] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    5.843956] rtc_cmos 00:04: RTC can wake from S4
[    5.844014] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    5.844670] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    5.844788] device-mapper: uevent: version 1.0.3
[    5.844876] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: 
dm-devel@redhat.com
[    5.845005] device-mapper: multipath: version 1.1.0 loaded
[    5.845045] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.845346] cpuidle: using governor ladder
[    5.845537] cpuidle: using governor menu
[    5.845818] TCP cubic registered
[    5.845953] NET: Registered protocol family 10
[    5.846293] lo: Disabled Privacy Extensions
[    5.846520] NET: Registered protocol family 17
[    5.846568] Bluetooth: L2CAP ver 2.14
[    5.846606] Bluetooth: L2CAP socket layer initialized
[    5.846645] Bluetooth: SCO (Voice Link) ver 0.6
[    5.846683] Bluetooth: SCO socket layer initialized
[    5.846736] Bluetooth: RFCOMM TTY layer initialized
[    5.846775] Bluetooth: RFCOMM socket layer initialized
[    5.846814] Bluetooth: RFCOMM ver 1.11
[    5.852150] PM: Resume from disk failed.
[    5.852199] registered taskstats version 1
[    5.852565]   Magic number: 5:77:961
[    5.852699] rtc_cmos 00:04: setting system clock to 2009-12-08 00:58:30 UTC 
(1260233910)
[    5.852757] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.852797] EDD information not available.
[    5.852875] Freeing unused kernel memory: 652k freed
[    5.853020] Write protecting the kernel read-only data: 10240k
[    5.853244] Freeing unused kernel memory: 808k freed
[    5.853549] Freeing unused kernel memory: 1768k freed
[    5.947623] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.947696] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.947744] r8169 0000:04:00.0: enabling Mem-Wr-Inval
[    5.947825] r8169 0000:04:00.0: setting latency timer to 64
[    5.947910]   alloc irq_desc for 28 on node -1
[    5.947953]   alloc kstat_irqs on node -1
[    5.948006] r8169 0000:04:00.0: irq 28 for MSI/MSI-X
[    5.948482] eth0: RTL8168c/8111c at 0xffffc90000c5c000, 00:1f:d0:9d:27:af, 
XID 1c4000c0 IRQ 28
[    5.951194] Floppy drive(s): fd0 is 1.44M
[    5.951296] DOR0=4
[    5.951337] floppy interrupt on bizarre fdc 1
[    5.951381] handler=(null)
[    5.974212] ohci1394 0000:05:07.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.983876] FDC 0 is a post-1991 82077
[    6.031318] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[e9204000-e92047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    6.424084] kjournald starting.  Commit interval 5 seconds
[    6.424094] EXT3-fs: mounted filesystem with writeback data mode.
[    6.780027] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    7.085817] usb 3-1: configuration #1 chosen from 1 choice
[    7.350429] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007c2d6400001fd0]
[    7.370045] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    7.543795] usb 5-1: configuration #1 chosen from 1 choice
[    7.820039] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    7.998774] usb 5-2: configuration #1 chosen from 1 choice
[    8.350029] usb 8-1: new full speed USB device using uhci_hcd and address 2
[    8.527169] usb 8-1: configuration #1 chosen from 1 choice
[    8.529095] hub 8-1:1.0: USB hub found
[    8.531074] hub 8-1:1.0: 4 ports detected
[    8.810034] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    9.048128] usb 8-2: configuration #1 chosen from 1 choice
[    9.131075] usb 8-1.4: new low speed USB device using uhci_hcd and address 
4
[    9.272139] usb 8-1.4: configuration #1 chosen from 1 choice
[   11.748097] udev: starting version 147
[   11.864974] usbcore: registered new interface driver hiddev
[   11.883321] input: Logitech USB RECEIVER as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
[   11.883418] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.2-2/input0
[   11.897294] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.0/input/input4
[   11.897346] generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 
Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input0
[   11.929345] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.1/input/input5
[   11.929397] generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 
Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input1
[   11.929423] usbcore: registered new interface driver usbhid
[   11.929425] usbhid: v2.6:USB HID core driver
[   12.518804] lp: driver loaded but no devices found
[   12.619174] nvidia: module license 'NVIDIA' taints kernel.
[   12.619177] Disabling lock debugging due to kernel taint
[   13.075529] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.075541] nvidia 0000:01:00.0: setting latency timer to 64
[   13.075683] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  185.18.36  Fri 
Aug 14 17:35:21 PDT 2009
[   13.303377] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.007467]   alloc irq_desc for 22 on node -1
[   14.007470]   alloc kstat_irqs on node -1
[   14.007475] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[   14.007626] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.147337] input: HDA Digital PCBeep as 
/devices/pci0000:00/0000:00:1b.0/input/input6
[   14.231107] usbcore: registered new interface driver snd-usb-audio
[   14.879252] Adding 6562544k swap on /dev/mapper/cryptoswap.  Priority:-1 
extents:1 across:6562544k 
[   15.279906] EXT3 FS on sda8, internal journal
[   15.447909] r8169: eth0: link up
[   15.447904] r8169: eth0: link up
[   15.883264] kjournald starting.  Commit interval 5 seconds
[   15.883278] EXT3-fs: mounted filesystem with writeback data mode.
[   15.922683] kjournald starting.  Commit interval 5 seconds
[   15.922913] EXT3 FS on sda6, internal journal
[   15.922915] EXT3-fs: mounted filesystem with writeback data mode.
[   16.086401] kjournald starting.  Commit interval 5 seconds
[   16.086407] EXT3-fs: mounted filesystem with writeback data mode.
[   16.092691] kjournald starting.  Commit interval 5 seconds
[   16.092937] EXT3 FS on sdc6, internal journal
[   16.092939] EXT3-fs: mounted filesystem with writeback data mode.
[   17.563582] ppdev: user-space parallel port driver
[   18.794389] RPC: Registered udp transport module.
[   18.794391] RPC: Registered tcp transport module.
[   18.794392] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   19.106071] svc: failed to register lockdv1 RPC service (errno 97).
[   24.999224] kjournald starting.  Commit interval 5 seconds
[   24.999231] EXT3-fs warning: maximal mount count reached, running e2fsck is 
recommended
[   25.011481] EXT3 FS on dm-1, internal journal
[   25.011485] EXT3-fs: mounted filesystem with writeback data mode.
[   26.303812] eth0: no IPv6 routers present
[   27.231500] CPUFREQ: Per core ondemand sysfs interface is deprecated - 
up_threshold
-----------------------------------------------------------------------------


Volker
