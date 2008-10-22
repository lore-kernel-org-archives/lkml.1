Return-Path: <linux-kernel-owner+w=401wt.eu-S1756818AbYJVXnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818AbYJVXnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 19:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbYJVXnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 19:43:33 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:21731 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJVXnb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 19:43:31 -0400
X-IronPort-AV: E=Sophos;i="4.33,467,1220227200"; 
   d="scan'208";a="94842249"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de
Subject: Hang early in boot with 2.6.27-git
X-Message-Flag: Warning: May contain useful information
Date: Wed, 22 Oct 2008 16:43:29 -0700
Message-ID: <adaej28urfi.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 22 Oct 2008 23:43:30.0041 (UTC) FILETIME=[FCACFE90:01C9349F]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Latest git (head 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4) hangs early
in boot.  One clue is that if I let it sit there for ~30 minutes, I get
a message about the tsc being unstable... the last messages are:

[    2.255064] NET: Registered protocol family 2
[ 1528.453016] Clocksource tsc unstable (delta = 1499794012204 ns)

Any requests for debugging info or suggestions appreciated...

System is a dual-socket quad-core Xeon box.  Full boot log below:

[    0.000000] BIOS EBDA/lowmem at: 0009ec00/0009ec00
[    0.000000] Linux version 2.6.27-dbg (rdreier@roland-1950-2) (gcc version 4.3.2 (Debian 4.3.2-1)8
[    0.000000] Command line: root=/dev/sda1 ro console=ttyS0,115200n8
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)      ▮
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffa8000 (usable)────┘
[    0.000000]  BIOS-e820: 00000000cffa8000 - 00000000cffb7c00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffb7c00 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] DMI 2.4 present.m Corporation
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x3ffffffff804D B5C04F474331
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xcffa8 max_arch_pfn = 0x3ffffffff
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: cffa8000 end: cffa8000
[    0.000000] init_memory_mapping
[    0.000000] last_map_addr: 230000000 end: 230000000
[    0.000000] ACPI: RSDP 000F2900, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 000F2980, 004C (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: FACP 000F2A88, 00F4 (r3 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: DSDT CFFA8000, 2A90 (r1 DELL   PE_SC3          1 MSFT  100000E)
[    0.000000] ACPI: FACS CFFB7C00, 0040
[    0.000000] ACPI: APIC 000F2B7C, 00C8 (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: SPCR 000F2C5D, 0050 (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: HPET 000F2CAD, 0038 (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: MCFG 000F2CE5, 003C (r1 DELL   PE_SC3          1 DELL        1)
[    0.000000] ACPI: DMI detected: Dell PE 1950
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000230000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000230000000
[    0.000000]   NODE_DATA [0000000000001000 - 0000000000005fff]
[    0.000000]   bootmap [0000000000011000 -  0000000000056fff] pages 46
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 0230000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000d4d508]    TEXT DATA BSS ==> [0000200000 - 0000d4d508]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #4 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
[    0.000000]   #5 [000000c000 - 0000011000]          PGTABLE ==> [000000c000 - 0000011000]
[    0.000000] found SMP MP-table at [ffff8800000fe710] 000fe710
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000cffa8
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x09] address[0xfec81000] gsi_base[64])
[    0.000000] IOAPIC[1]: apic_id 9, version 0, address 0xfec81000, GSI 64-87
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] Allocating PCI resources starting at d1000000 (gap: d0000000:10000000)
[    0.000000] PERCPU: Allocating 45056 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2044684
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/sda1 ro console=ttyS0,115200n8
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2660.062 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [ttyS0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:           4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 3839 kB
[    0.004000]  per task-struct memory footprint: 1920 bytes
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 8127060k/9175040k available (2643k kernel code, 260812k reserved, 1686k data)
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004013] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.12 B)
[    0.013024] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.022443] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.026002] Mount-cache hash table entries: 256
[    0.028909] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.033656] CPU: L2 cache: 4096K
[    0.036005] CPU 0/0x0 -> Node 0
[    0.040004] CPU: Physical Processor ID: 0
[    0.044003] CPU: Processor Core ID: 0
[    0.047647] CPU0: Thermal monitoring enabled (TM1)
[    0.048004] using mwait in idle threads.
[    0.052012] Freeing SMP alternatives: 18k freed
[    0.056033] ACPI: Core revision 20080609
[    0.066776] Setting APIC routing to flat
[    0.068397] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.112782] CPU0: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.120001] lockdep: fixing up alternatives.
[    0.120080] Booting processor 1 APIC 0x4 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5320.01 BogoMIPS (lpj=10640028)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 1/0x4 -> Node 0
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.217398] CPU1: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.225239] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.228574] lockdep: fixing up alternatives.
[    0.232029] Booting processor 2 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5320.00 BogoMIPS (lpj=10640008)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 2/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU2: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.329382] CPU2: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.337239] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.340598] lockdep: fixing up alternatives.
[    0.344040] Booting processor 3 APIC 0x5 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5320.01 BogoMIPS (lpj=10640025)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 3/0x5 -> Node 0
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU3: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.441408] CPU3: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.449236] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.452537] lockdep: fixing up alternatives.
[    0.456029] Booting processor 4 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#4
[    0.004000] Calibrating delay using timer specific routine.. 5319.99 BogoMIPS (lpj=10639996)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 4/0x2 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] CPU4: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.553451] CPU4: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.561239] checking TSC synchronization [CPU#0 -> CPU#4]: passed.
[    0.564533] lockdep: fixing up alternatives.
[    0.568036] Booting processor 5 APIC 0x6 ip 0x6000
[    0.004000] Initializing CPU#5
[    0.004000] Calibrating delay using timer specific routine.. 5320.00 BogoMIPS (lpj=10640018)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 5/0x6 -> Node 0
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 2
[    0.004000] CPU5: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.665503] CPU5: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.673238] checking TSC synchronization [CPU#0 -> CPU#5]: passed.
[    0.676537] lockdep: fixing up alternatives.
[    0.680032] Booting processor 6 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#6
[    0.004000] Calibrating delay using timer specific routine.. 5319.98 BogoMIPS (lpj=10639975)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 6/0x3 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] CPU6: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.777455] CPU6: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.785239] checking TSC synchronization [CPU#0 -> CPU#6]: passed.
[    0.788551] lockdep: fixing up alternatives.
[    0.792029] Booting processor 7 APIC 0x7 ip 0x6000
[    0.004000] Initializing CPU#7
[    0.004000] Calibrating delay using timer specific routine.. 5320.01 BogoMIPS (lpj=10640024)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU 7/0x7 -> Node 0
[    0.004000] CPU: Physical Processor ID: 1
[    0.004000] CPU: Processor Core ID: 3
[    0.004000] CPU7: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.889418] CPU7: Intel(R) Xeon(R) CPU           X5355  @ 2.66GHz stepping 07
[    0.897239] checking TSC synchronization [CPU#0 -> CPU#7]: passed.
[    0.900016] Brought up 8 CPUs
[    0.902969] Total of 8 processors activated (42560.16 BogoMIPS).
[    0.904298] net_namespace: 1056 bytes
[    0.908506] NET: Registered protocol family 16
[    0.916301] No dock devices found.
[    0.920167] ACPI: bus type pci registered
[    0.924022] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.932005] PCI: MCFG area at e0000000 reserved in E820
[    0.952507] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.960005] PCI: Using configuration type 1 for base access
[    0.964005] PCI: Dell PowerEdge 1950 detected, enabling pci=bfsort.
[    0.984015] ACPI: Interpreter enabled
[    0.988013] ACPI: (supports S0 S5)
[    0.992559] ACPI: Using IOAPIC for interrupt routing
[    1.008401] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.016196] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.020028] pci 0000:00:00.0: PME# disabled
[    1.024058] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    1.032006] pci 0000:00:02.0: PME# disabled
[    1.036060] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.040006] pci 0000:00:03.0: PME# disabled
[    1.044056] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    1.052006] pci 0000:00:04.0: PME# disabled
[    1.056054] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.060006] pci 0000:00:05.0: PME# disabled
[    1.064059] pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
[    1.072006] pci 0000:00:06.0: PME# disabled
[    1.076055] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.084006] pci 0000:00:07.0: PME# disabled
[    1.088251] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.092007] pci 0000:00:1c.0: PME# disabled
[    1.096297] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.104008] pci 0000:00:1d.7: PME# disabled
[    1.109591] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.116052] pci 0000:05:00.0: PME# disabled
[    1.121746] pci 0000:05:00.3: PME# supported from D0 D3hot D3cold
[    1.128051] pci 0000:05:00.3: PME# disabled
[    1.132784] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pc'
[    1.145239] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.152052] pci 0000:06:00.0: PME# disabled
[    1.157651] pci 0000:06:01.0: PME# supported from D0 D3hot D3cold
[    1.164052] pci 0000:06:01.0: PME# disabled
[    1.171895] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    1.176052] pci 0000:07:00.0: PME# disabled
[    1.180510] pci 0000:07:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pc'
[    1.197559] pci 0000:08:00.0: PME# supported from D3hot D3cold
[    1.204052] pci 0000:08:00.0: PME# disabled
[    1.214936] pci 0000:01:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.220028] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.228007] pci 0000:01:00.0: PME# disabled
[    1.232028] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pc'
[    1.240519] pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pc'
[    1.253110] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    1.260008] pci 0000:03:00.0: PME# disabled
[    1.264024] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pc'
[    1.272177] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    1.280008] pci 0000:04:00.0: PME# disabled
[    1.284256] pci 0000:00:1e.0: transparent bridge
[    1.308326] ACPI: PCI Interrupt Link [LK00] (IRQs 3 4 5 *6 7 10 11 12)
[    1.317298] ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    1.324384] ACPI: PCI Interrupt Link [LK02] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    1.332386] ACPI: PCI Interrupt Link [LK03] (IRQs 3 4 *5 6 7 10 11 12)
[    1.340100] ACPI: PCI Interrupt Link [LK04] (IRQs 3 4 5 6 7 *10 11 12)
[    1.346308] ACPI: PCI Interrupt Link [LK05] (IRQs 3 4 5 6 7 10 *11 12)
[    1.353761] ACPI: PCI Interrupt Link [LK06] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    1.361727] ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 6 7 10 11 12) *0, disabled.
[    1.369655] SCSI subsystem initialized
[    1.376227] usbcore: registered new interface driver usbfs
[    1.380107] usbcore: registered new interface driver hub
[    1.388080] usbcore: registered new device driver usb
[    1.392145] PCI: Using ACPI for IRQ routing
[    1.408118] PCI-GART: No AMD northbridge found.
[    1.416052] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.420915] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.469330] pnp: PnP ACPI init
[    1.472391] ACPI: bus type pnp registered
[    1.486292] pnp: PnP ACPI: found 12 devices
[    1.490483] ACPI: ACPI bus type pnp unregistered
[    1.495125] system 00:08: ioport range 0x800-0x87f has been reserved
[    1.501472] system 00:08: ioport range 0x880-0x8bf has been reserved
[    1.507816] system 00:08: ioport range 0x8c0-0x8df has been reserved
[    1.514166] system 00:08: ioport range 0x8e0-0x8e3 has been reserved
[    1.520510] system 00:08: ioport range 0xc00-0xc7f has been reserved
[    1.526855] system 00:08: ioport range 0xca0-0xca7 has been reserved
[    1.533199] system 00:08: ioport range 0xca9-0xcab has been reserved
[    1.539541] system 00:08: ioport range 0xcad-0xcaf has been reserved
[    1.545894] system 00:09: ioport range 0xca8-0xca8 has been reserved
[    1.552237] system 00:09: ioport range 0xcac-0xcac has been reserved
[    1.558588] system 00:0a: iomem range 0xe0000000-0xefffffff could not be reserved
[    1.573263] pci 0000:07:00.0: PCI bridge, secondary bus 0000:08
[    1.579174] pci 0000:07:00.0:   IO window: disabled
[    1.584136] pci 0000:07:00.0:   MEM window: 0xf4000000-0xf7ffffff
[    1.590265] pci 0000:07:00.0:   PREFETCH window: disabled
[    1.595792] pci 0000:06:00.0: PCI bridge, secondary bus 0000:07
[    1.601702] pci 0000:06:00.0:   IO window: disabled
[    1.606663] pci 0000:06:00.0:   MEM window: 0xf4000000-0xf7ffffff
[    1.612804] pci 0000:06:00.0:   PREFETCH window: disabled
[    1.618332] pci 0000:06:01.0: PCI bridge, secondary bus 0000:09
[    1.624241] pci 0000:06:01.0:   IO window: disabled
[    1.629203] pci 0000:06:01.0:   MEM window: disabled
[    1.634206] pci 0000:06:01.0:   PREFETCH window: disabled
[    1.639734] pci 0000:05:00.0: PCI bridge, secondary bus 0000:06
[    1.645643] pci 0000:05:00.0:   IO window: disabled
[    1.650605] pci 0000:05:00.0:   MEM window: 0xf4000000-0xf7ffffff
[    1.656734] pci 0000:05:00.0:   PREFETCH window: disabled
[    1.662260] pci 0000:05:00.3: PCI bridge, secondary bus 0000:0a
[    1.668167] pci 0000:05:00.3:   IO window: disabled
[    1.673128] pci 0000:05:00.3:   MEM window: disabled
[    1.678132] pci 0000:05:00.3:   PREFETCH window: disabled
[    1.683658] pci 0000:00:02.0: PCI bridge, secondary bus 0000:05
[    1.689566] pci 0000:00:02.0:   IO window: disabled
[    1.694438] pci 0000:00:02.0:   MEM window: 0xf2000000-0xf7ffffff
[    1.700533] pci 0000:00:02.0:   PREFETCH window: disabled
[    1.707009] pci 0000:01:00.0: PCI bridge, secondary bus 0000:02
[    1.712921] pci 0000:01:00.0:   IO window: 0xe000-0xefff
[    1.718226] pci 0000:01:00.0:   MEM window: 0xfc900000-0xfcafffff
[    1.724309] pci 0000:01:00.0:   PREFETCH window: disabled
[    1.729701] pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
[    1.735612] pci 0000:00:03.0:   IO window: 0xe000-0xefff
[    1.740929] pci 0000:00:03.0:   MEM window: 0xfc800000-0xfcafffff
[    1.747012] pci 0000:00:03.0:   PREFETCH window: disabled
[    1.752403] pci 0000:00:04.0: PCI bridge, secondary bus 0000:0b
[    1.758311] pci 0000:00:04.0:   IO window: disabled
[    1.763181] pci 0000:00:04.0:   MEM window: 0xfc600000-0xfc7fffff
[    1.769266] pci 0000:00:04.0:   PREFETCH window: 0x000000d8800000-0x000000d8ffffff
[    1.776824] pci 0000:00:05.0: PCI bridge, secondary bus 0000:0c
[    1.782731] pci 0000:00:05.0:   IO window: disabled
[    1.787602] pci 0000:00:05.0:   MEM window: disabled
[    1.792559] pci 0000:00:05.0:   PREFETCH window: disabled
[    1.797952] pci 0000:00:06.0: PCI bridge, secondary bus 0000:0d
[    1.803862] pci 0000:00:06.0:   IO window: disabled
[    1.808733] pci 0000:00:06.0:   MEM window: 0xfc300000-0xfc5fffff
[    1.814818] pci 0000:00:06.0:   PREFETCH window: 0x000000d8000000-0x000000d87fffff
[    1.822377] pci 0000:00:07.0: PCI bridge, secondary bus 0000:0e
[    1.828284] pci 0000:00:07.0:   IO window: disabled
[    1.833156] pci 0000:00:07.0:   MEM window: disabled
[    1.838112] pci 0000:00:07.0:   PREFETCH window: disabled
[    1.843503] pci 0000:03:00.0: PCI bridge, secondary bus 0000:04
[    1.849411] pci 0000:03:00.0:   IO window: disabled
[    1.854285] pci 0000:03:00.0:   MEM window: 0xf8000000-0xfbffffff
[    1.860371] pci 0000:03:00.0:   PREFETCH window: disabled
[    1.865767] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
[    1.871675] pci 0000:00:1c.0:   IO window: disabled
[    1.876557] pci 0000:00:1c.0:   MEM window: 0xf8000000-0xfbffffff
[    1.882642] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.888037] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0f
[    1.893948] pci 0000:00:1e.0:   IO window: 0xd000-0xdfff
[    1.899252] pci 0000:00:1e.0:   MEM window: 0xfc100000-0xfc2fffff
[    1.905338] pci 0000:00:1e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    1.912909] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.919697] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.926618] pci 0000:06:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.933813] pci 0000:06:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.940876] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.947584] pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.954290] pci 0000:00:06.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.960997] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.967709] bus: 00 index 0 io port: [0x00-0xffff]
[    1.972491] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    1.978401] bus: 05 index 0 mmio: [0x0-0x0]
[    1.982576] bus: 05 index 1 mmio: [0xf2000000-0xf7ffffff]
[    1.987965] bus: 05 index 2 mmio: [0x0-0x0]
[    1.992139] bus: 05 index 3 mmio: [0x0-0x0]
[    1.996325] bus: 06 index 0 mmio: [0x0-0x0]
[    2.000500] bus: 06 index 1 mmio: [0xf4000000-0xf7ffffff]
[    2.005889] bus: 06 index 2 mmio: [0x0-0x0]
[    2.010064] bus: 06 index 3 mmio: [0x0-0x0]
[    2.014238] bus: 07 index 0 mmio: [0x0-0x0]
[    2.018413] bus: 07 index 1 mmio: [0xf4000000-0xf7ffffff]
[    2.023800] bus: 07 index 2 mmio: [0x0-0x0]
[    2.027976] bus: 07 index 3 mmio: [0x0-0x0]
[    2.032150] bus: 08 index 0 mmio: [0x0-0x0]
[    2.036324] bus: 08 index 1 mmio: [0xf4000000-0xf7ffffff]
[    2.041714] bus: 08 index 2 mmio: [0x0-0x0]
[    2.045889] bus: 08 index 3 mmio: [0x0-0x0]
[    2.050064] bus: 09 index 0 mmio: [0x0-0x0]
[    2.054239] bus: 09 index 1 mmio: [0x0-0x0]
[    2.058414] bus: 09 index 2 mmio: [0x0-0x0]
[    2.062588] bus: 09 index 3 mmio: [0x0-0x0]
[    2.066762] bus: 0a index 0 mmio: [0x0-0x0]
[    2.070939] bus: 0a index 1 mmio: [0x0-0x0]
[    2.075113] bus: 0a index 2 mmio: [0x0-0x0]
[    2.079288] bus: 0a index 3 mmio: [0x0-0x0]
[    2.083463] bus: 01 index 0 io port: [0xe000-0xefff]
[    2.088418] bus: 01 index 1 mmio: [0xfc800000-0xfcafffff]
[    2.093806] bus: 01 index 2 mmio: [0x0-0x0]
[    2.097980] bus: 01 index 3 mmio: [0x0-0x0]
[    2.102155] bus: 02 index 0 io port: [0xe000-0xefff]
[    2.107110] bus: 02 index 1 mmio: [0xfc900000-0xfcafffff]
[    2.112498] bus: 02 index 2 mmio: [0x0-0x0]
[    2.116672] bus: 02 index 3 mmio: [0x0-0x0]
[    2.120848] bus: 0b index 0 mmio: [0x0-0x0]
[    2.125032] bus: 0b index 1 mmio: [0xfc600000-0xfc7fffff]
[    2.130420] bus: 0b index 2 mmio: [0xd8800000-0xd8ffffff]
[    2.135808] bus: 0b index 3 mmio: [0x0-0x0]
[    2.139984] bus: 0c index 0 mmio: [0x0-0x0]
[    2.144158] bus: 0c index 1 mmio: [0x0-0x0]
[    2.148333] bus: 0c index 2 mmio: [0x0-0x0]
[    2.152509] bus: 0c index 3 mmio: [0x0-0x0]
[    2.156684] bus: 0d index 0 mmio: [0x0-0x0]
[    2.160858] bus: 0d index 1 mmio: [0xfc300000-0xfc5fffff]
[    2.166246] bus: 0d index 2 mmio: [0xd8000000-0xd87fffff]
[    2.171636] bus: 0d index 3 mmio: [0x0-0x0]
[    2.175812] bus: 0e index 0 mmio: [0x0-0x0]
[    2.179986] bus: 0e index 1 mmio: [0x0-0x0]
[    2.184162] bus: 0e index 2 mmio: [0x0-0x0]
[    2.188337] bus: 0e index 3 mmio: [0x0-0x0]
[    2.192513] bus: 03 index 0 mmio: [0x0-0x0]
[    2.196687] bus: 03 index 1 mmio: [0xf8000000-0xfbffffff]
[    2.202077] bus: 03 index 2 mmio: [0x0-0x0]
[    2.206253] bus: 03 index 3 mmio: [0x0-0x0]
[    2.210428] bus: 04 index 0 mmio: [0x0-0x0]
[    2.214604] bus: 04 index 1 mmio: [0xf8000000-0xfbffffff]
[    2.219992] bus: 04 index 2 mmio: [0x0-0x0]
[    2.224166] bus: 04 index 3 mmio: [0x0-0x0]
[    2.228343] bus: 0f index 0 io port: [0xd000-0xdfff]
[    2.233299] bus: 0f index 1 mmio: [0xfc100000-0xfc2fffff]
[    2.238687] bus: 0f index 2 mmio: [0xd0000000-0xd7ffffff]
[    2.244077] bus: 0f index 3 io port: [0x00-0xffff]
[    2.248859] bus: 0f index 4 mmio: [0x000000-0xffffffffffffffff]
[    2.255064] NET: Registered protocol family 2
[ 1528.453016] Clocksource tsc unstable (delta = 1499794012204 ns)
