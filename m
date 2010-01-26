Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709Ab0AZIsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0AZIsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 03:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323Ab0AZIsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 03:48:32 -0500
Received: from jgarrett.org ([64.5.53.252]:38242 "EHLO jgarrett.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0AZIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 03:48:30 -0500
Date: Tue, 26 Jan 2010 02:47:40 -0600
To: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Subject: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100126084740.GA5265@jgarrett.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
From: jeff@jgarrett.org (Jeff Garrett)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I was trying to chase down a theory that my desktop machine (a core i7)
is running warm (the fan sounds like it's at full speed all the time,
and I think it's not always acted this way -- hence the theory).

powertop is never showing it spending any time in C3...

I compiled a kernel without USB/sound/radeon, and ran without X.  I was
able to get the wakeups/sec down below 20, but no time is spent in C3.

sysfs looks to agree with powertop here (time = 0 on C3):
/sys/devices/system/cpu/cpu0/cpuidle/state0/desc: CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency: 0
/sys/devices/system/cpu/cpu0/cpuidle/state0/name: C0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power: 4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/time: 457
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage: 59
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc: ACPI FFH INTEL MWAIT 0x0
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency: 1
/sys/devices/system/cpu/cpu0/cpuidle/state1/name: C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/power: 1000
/sys/devices/system/cpu/cpu0/cpuidle/state1/time: 308177
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage: 3975
/sys/devices/system/cpu/cpu0/cpuidle/state2/desc: ACPI FFH INTEL MWAIT 0x10
/sys/devices/system/cpu/cpu0/cpuidle/state2/latency: 17
/sys/devices/system/cpu/cpu0/cpuidle/state2/name: C2
/sys/devices/system/cpu/cpu0/cpuidle/state2/power: 500
/sys/devices/system/cpu/cpu0/cpuidle/state2/time: 873440787
/sys/devices/system/cpu/cpu0/cpuidle/state2/usage: 239038
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc: ACPI FFH INTEL MWAIT 0x20
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency: 17
/sys/devices/system/cpu/cpu0/cpuidle/state3/name: C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/power: 350
/sys/devices/system/cpu/cpu0/cpuidle/state3/time: 0
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage: 0

This may be a complete red herring, but I added some printk logic to
acpi_idle_bm_check(), and it is getting called often, but bm_status is
always 1.  [I infer from this that the idle logic is trying to go into
C3, but this check is stopping it...  Unless I misread something.]

Is this expected behavior or is this a legitimate problem?

How might I investigate this further?

Attaching dmesg, /proc/cpuinfo, powertop -d output.

Thanks,
Jeff Garrett

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Linux version 2.6.33-rc5 (root@korrek) (gcc version 4.4.3 (Ubuntu 4.4.3-1ubuntu1) ) #14 SMP Mon Jan 25 22:25:02 CST 2010
[    0.000000] Command line: root=UUID=0671ec67-a417-4716-b4c8-90ef225e524d ro quiet splash usbcore.autosuspend=1 pci=use_crs 
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x340000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-E7FFF write-through
[    0.000000]   E8000-EBFFF write-protect
[    0.000000]   EC000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask F00000000 write-back
[    0.000000]   2 base 300000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   4 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf790 max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf790000 (usable)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000340000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf790000
[    0.000000]  0000000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf790000 page 4k
[    0.000000] kernel direct mapping tables up to bf790000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-0000000340000000
[    0.000000]  0100000000 - 0340000000 page 2M
[    0.000000] kernel direct mapping tables up to 340000000 @ 19000-27000
[    0.000000] RAMDISK: 34b37000 - 37fefc3d
[    0.000000] ACPI: RSDP 00000000000f9ce0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000bf790000 00044 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790200 00084 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf790660 056A7 (v01  1AAAA 1AAAA000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0008C (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf790420 0003C (v01 DELL   OEMMCFG  20090415 MSFT 00000097)
[    0.000000] ACPI: SLIC 00000000bf790460 00176 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000bf7905e0 00080 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 00072 (v01 DELL    FX09    20090415 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf798660 00038 (v01 DELL   OEMHPET  20090415 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf79f670 01298 (v01 DpgPmm    CpuPm 00000012 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000340000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000340000000
[    0.000000]   NODE_DATA [0000000000022000 - 0000000000026fff]
[    0.000000]   bootmap [0000000000027000 -  000000000008efff] pages 68
[    0.000000] (13 early reservations) ==> bootmem [0000000000 - 0340000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00019eba18]    TEXT DATA BSS ==> [0001000000 - 00019eba18]
[    0.000000]   #2 [0034b37000 - 0037fefc3d]          RAMDISK ==> [0034b37000 - 0037fefc3d]
[    0.000000]   #3 [00019ec000 - 00019ec0fc]              BRK ==> [00019ec000 - 00019ec0fc]
[    0.000000]   #4 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #5 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #6 [000009fc00 - 00000fcee0]    BIOS reserved ==> [000009fc00 - 00000fcee0]
[    0.000000]   #7 [00000fd074 - 00000ff780]    BIOS reserved ==> [00000fd074 - 00000ff780]
[    0.000000]   #8 [00000fcee0 - 00000fd074]     MP-table mpc ==> [00000fcee0 - 00000fd074]
[    0.000000]   #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #10 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #11 [0000016000 - 0000019000]          PGTABLE ==> [0000016000 - 0000019000]
[    0.000000]   #12 [0000019000 - 0000022000]          PGTABLE ==> [0000019000 - 0000022000]
[    0.000000]  [ffffea0000000000-ffffea000b5fffff] PMD -> [ffff880028600000-ffff880032dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00340000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bf790
[    0.000000]     0: 0x00100000 -> 0x00340000
[    0.000000] On node 0 totalpages: 3143456
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 114 pages reserved
[    0.000000]   DMA zone: 3814 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765896 pages, LIFO batch:31
[    0.000000]   Normal zone: 32256 pages used for memmap
[    0.000000]   Normal zone: 2327040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 7, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf790000 - 00000000bf79e000
[    0.000000] PM: Registered nosave memory: 00000000bf79e000 - 00000000bf7d0000
[    0.000000] PM: Registered nosave memory: 00000000bf7d0000 - 00000000bf7e0000
[    0.000000] PM: Registered nosave memory: 00000000bf7e0000 - 00000000bf7ec000
[    0.000000] PM: Registered nosave memory: 00000000bf7ec000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880028200000 s83608 r8192 d22888 u262144
[    0.000000] pcpu-alloc: s83608 r8192 d22888 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096750
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=UUID=0671ec67-a417-4716-b4c8-90ef225e524d ro quiet splash usbcore.autosuspend=1 pci=use_crs 
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 12270428k/13631488k available (3924k kernel code, 1057664k absent, 303396k reserved, 4815k data, 564k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:472
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 2660.467 MHz processor.
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.93 BogoMIPS (lpj=26604670)
[    0.000019] Security Framework initialized
[    0.000022] Smack:  Initializing.
[    0.000877] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.003760] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.004996] Mount-cache hash table entries: 256
[    0.005097] CPU: Physical Processor ID: 0
[    0.005098] CPU: Processor Core ID: 0
[    0.005103] mce: CPU supports 9 MCE banks
[    0.005112] CPU0: Thermal monitoring enabled (TM1)
[    0.005115] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.005121] using mwait in idle threads.
[    0.005122] Performance Events: Nehalem/Corei7 events, Intel PMU driver.
[    0.005126] ... version:                3
[    0.005127] ... bit width:              48
[    0.005128] ... generic registers:      4
[    0.005129] ... value mask:             0000ffffffffffff
[    0.005130] ... max period:             000000007fffffff
[    0.005131] ... fixed-purpose events:   3
[    0.005132] ... event mask:             000000070000000f
[    0.005146] ACPI: Core revision 20091214
[    0.035121] Setting APIC routing to flat
[    0.035439] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.173879] CPU0: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz stepping 04
[    0.288392] Booting Node   0, Processors  #1
[    0.447920] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.467991]  #2
[    0.627465] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.647507]  #3
[    0.807011] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.827079] Brought up 4 CPUs
[    0.827081] Total of 4 processors activated (21280.65 BogoMIPS).
[    0.828400] regulator: core version 0.5
[    0.828423] Time:  4:28:29  Date: 01/26/10
[    0.828451] NET: Registered protocol family 16
[    0.828530] ACPI: bus type pci registered
[    0.828582] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.828584] PCI: not using MMCONFIG
[    0.828585] PCI: Using configuration type 1 for base access
[    0.829154] bio: create slab <bio-0> at 0
[    0.830321] ACPI: EC: Look up EC in DSDT
[    0.832803] ACPI: Executed 1 blocks of module-level executable AML code
[    0.840148] ACPI: Interpreter enabled
[    0.840151] ACPI: (supports S0 S3 S4 S5)
[    0.840168] ACPI: Using IOAPIC for interrupt routing
[    0.840214] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.842058] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.855463] ACPI: No dock devices found.
[    0.855610] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.855895] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.855898] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.855899] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.855901] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.855903] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.855905] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
[    0.855954] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    0.855957] pci 0000:00:00.0: PME# disabled
[    0.856011] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.856013] pci 0000:00:01.0: PME# disabled
[    0.856065] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.856068] pci 0000:00:03.0: PME# disabled
[    0.856121] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.856124] pci 0000:00:07.0: PME# disabled
[    0.856225] IOH bus: [00, fb]
[    0.856227] IOH bus: 00 index 0 io port: [0, ffff]
[    0.856229] IOH bus: 00 index 1 mmio: [e0000000, fdffffff]
[    0.856398] pci 0000:00:19.0: reg 10: [mem 0xfbcc0000-0xfbcdffff]
[    0.856404] pci 0000:00:19.0: reg 14: [mem 0xfbcf4000-0xfbcf4fff]
[    0.856409] pci 0000:00:19.0: reg 18: [io  0xa080-0xa09f]
[    0.856443] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.856446] pci 0000:00:19.0: PME# disabled
[    0.856486] pci 0000:00:1a.0: reg 20: [io  0xa400-0xa41f]
[    0.856543] pci 0000:00:1a.1: reg 20: [io  0xa480-0xa49f]
[    0.856600] pci 0000:00:1a.2: reg 20: [io  0xa800-0xa81f]
[    0.856657] pci 0000:00:1a.7: reg 10: [mem 0xfbcf6000-0xfbcf63ff]
[    0.856705] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.856709] pci 0000:00:1a.7: PME# disabled
[    0.856739] pci 0000:00:1b.0: reg 10: [mem 0xfbcf8000-0xfbcfbfff 64bit]
[    0.856775] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.856778] pci 0000:00:1b.0: PME# disabled
[    0.856835] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.856838] pci 0000:00:1c.0: PME# disabled
[    0.856901] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.856904] pci 0000:00:1c.1: PME# disabled
[    0.856952] pci 0000:00:1d.0: reg 20: [io  0xa880-0xa89f]
[    0.857010] pci 0000:00:1d.1: reg 20: [io  0xac00-0xac1f]
[    0.857068] pci 0000:00:1d.2: reg 20: [io  0xb000-0xb01f]
[    0.857125] pci 0000:00:1d.7: reg 10: [mem 0xfbcfc000-0xfbcfc3ff]
[    0.857174] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.857177] pci 0000:00:1d.7: PME# disabled
[    0.857280] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.857283] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.857286] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 00ff)
[    0.857332] pci 0000:00:1f.2: reg 10: [io  0xbc00-0xbc07]
[    0.857337] pci 0000:00:1f.2: reg 14: [io  0xb880-0xb883]
[    0.857341] pci 0000:00:1f.2: reg 18: [io  0xb800-0xb807]
[    0.857346] pci 0000:00:1f.2: reg 1c: [io  0xb480-0xb483]
[    0.857351] pci 0000:00:1f.2: reg 20: [io  0xb400-0xb40f]
[    0.857355] pci 0000:00:1f.2: reg 24: [io  0xb080-0xb08f]
[    0.857395] pci 0000:00:1f.3: reg 10: [mem 0xfbcffc00-0xfbcffcff 64bit]
[    0.857407] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.857440] pci 0000:00:1f.5: reg 10: [io  0xcc00-0xcc07]
[    0.857445] pci 0000:00:1f.5: reg 14: [io  0xc880-0xc883]
[    0.857449] pci 0000:00:1f.5: reg 18: [io  0xc800-0xc807]
[    0.857454] pci 0000:00:1f.5: reg 1c: [io  0xc480-0xc483]
[    0.857458] pci 0000:00:1f.5: reg 20: [io  0xc400-0xc40f]
[    0.857463] pci 0000:00:1f.5: reg 24: [io  0xc080-0xc08f]
[    0.857509] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    0.857534] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    0.857561] pci 0000:04:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.857569] pci 0000:04:00.0: reg 18: [mem 0xfbee0000-0xfbeeffff 64bit]
[    0.857574] pci 0000:04:00.0: reg 20: [io  0xe000-0xe0ff]
[    0.857581] pci 0000:04:00.0: reg 30: [mem 0xfbec0000-0xfbedffff pref]
[    0.857597] pci 0000:04:00.0: supports D1 D2
[    0.857623] pci 0000:04:00.1: reg 10: [mem 0xfbefc000-0xfbefffff 64bit]
[    0.857653] pci 0000:04:00.1: supports D1 D2
[    0.857680] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.857683] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.857686] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.857690] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.857723] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.857776] pci 0000:02:00.0: reg 10: [mem 0xfbdff800-0xfbdfffff 64bit]
[    0.857785] pci 0000:02:00.0: reg 18: [io  0xd800-0xd8ff]
[    0.857851] pci 0000:02:00.0: supports D2
[    0.857853] pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
[    0.857858] pci 0000:02:00.0: PME# disabled
[    0.857906] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.857910] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.857913] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.857959] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.857988] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.858306] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.858359] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.858422] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
[    0.858474] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
[    0.858533] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
[    0.884188] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
[    0.884289] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[    0.884386] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
[    0.884484] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
[    0.884583] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 *4 6 7 10 11 12 14 15)
[    0.884681] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 *7 10 11 12 14 15)
[    0.884780] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
[    0.884878] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 *14 15)
[    0.884960] vgaarb: device added: PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.884963] vgaarb: loaded
[    0.885031] SCSI subsystem initialized
[    0.885082] libata version 3.00 loaded.
[    0.885175] ACPI: WMI: Mapper loaded
[    0.885177] PCI: Using ACPI for IRQ routing
[    0.885178] PCI: pci_cache_line_size set to 64 bytes
[    0.885312] Bluetooth: Core ver 2.15
[    0.885331] NET: Registered protocol family 31
[    0.885332] Bluetooth: HCI device and connection manager initialized
[    0.885333] Bluetooth: HCI socket layer initialized
[    0.885335] NetLabel: Initializing
[    0.885336] NetLabel:  domain hash size = 128
[    0.885337] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.885346] NetLabel:  unlabeled traffic allowed by default
[    0.885350] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.885354] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.885357] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.906879] Switching to clocksource tsc
[    0.908147] pnp: PnP ACPI init
[    0.908154] ACPI: bus type pnp registered
[    0.910306] pnp: PnP ACPI: found 14 devices
[    0.910308] ACPI: ACPI bus type pnp unregistered
[    0.910315] system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
[    0.910317] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    0.910319] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    0.910321] system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
[    0.910324] system 00:01: [mem 0xfec8a000-0xfec8afff] has been reserved
[    0.910326] system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
[    0.910330] system 00:06: [io  0x0a00-0x0a0f] has been reserved
[    0.910332] system 00:06: [io  0x0a10-0x0a1f] has been reserved
[    0.910334] system 00:06: [io  0x0a20-0x0a2f] has been reserved
[    0.910336] system 00:06: [io  0x0a30-0x0a3f] has been reserved
[    0.910340] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.910342] system 00:07: [io  0x0800-0x087f] has been reserved
[    0.910344] system 00:07: [io  0x0500-0x057f] could not be reserved
[    0.910346] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.910348] system 00:07: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.910350] system 00:07: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.910354] system 00:0a: [mem 0xffc00000-0xffefffff] has been reserved
[    0.910358] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.910360] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.910364] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.910367] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.910369] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.910371] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.910374] system 00:0d: [mem 0x00100000-0xbfffffff] could not be reserved
[    0.910376] system 00:0d: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.915061] pci 0000:00:1c.0: BAR 14: assigned [mem 0xc0000000-0xc01fffff]
[    0.915064] pci 0000:00:1c.0: BAR 15: assigned [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.915066] pci 0000:00:1c.1: BAR 15: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.915068] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.915070] pci 0000:00:01.0: PCI bridge to [bus 06-06]
[    0.915071] pci 0000:00:01.0:   bridge window [io  disabled]
[    0.915074] pci 0000:00:01.0:   bridge window [mem disabled]
[    0.915077] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    0.915081] pci 0000:00:03.0: PCI bridge to [bus 05-05]
[    0.915082] pci 0000:00:03.0:   bridge window [io  disabled]
[    0.915085] pci 0000:00:03.0:   bridge window [mem disabled]
[    0.915088] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    0.915092] pci 0000:00:07.0: PCI bridge to [bus 04-04]
[    0.915095] pci 0000:00:07.0:   bridge window [io  0xe000-0xefff]
[    0.915098] pci 0000:00:07.0:   bridge window [mem 0xfbe00000-0xfbefffff]
[    0.915101] pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.915106] pci 0000:00:1c.0: PCI bridge to [bus 03-03]
[    0.915108] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    0.915112] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.915115] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.915120] pci 0000:00:1c.1: PCI bridge to [bus 02-02]
[    0.915122] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.915126] pci 0000:00:1c.1:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    0.915129] pci 0000:00:1c.1:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.915134] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.915135] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.915139] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.915142] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.915152] pci 0000:00:01.0: setting latency timer to 64
[    0.915159] pci 0000:00:03.0: setting latency timer to 64
[    0.915165] pci 0000:00:07.0: setting latency timer to 64
[    0.915171] pci 0000:00:1c.0: enabling device (0104 -> 0107)
[    0.915174]   alloc irq_desc for 17 on node -1
[    0.915175]   alloc kstat_irqs on node -1
[    0.915180] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.915183] pci 0000:00:1c.0: setting latency timer to 64
[    0.915189]   alloc irq_desc for 16 on node -1
[    0.915190]   alloc kstat_irqs on node -1
[    0.915193] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.915196] pci 0000:00:1c.1: setting latency timer to 64
[    0.915201] pci 0000:00:1e.0: setting latency timer to 64
[    0.915203] pci_bus 0000:00: resource 0 [io  0x0000-0x0cf7]
[    0.915205] pci_bus 0000:00: resource 1 [io  0x0d00-0xffff]
[    0.915207] pci_bus 0000:00: resource 2 [mem 0x000a0000-0x000bffff]
[    0.915208] pci_bus 0000:00: resource 3 [mem 0x000d0000-0x000dffff]
[    0.915210] pci_bus 0000:00: resource 4 [mem 0xc0000000-0xdfffffff]
[    0.915211] pci_bus 0000:00: resource 5 [mem 0xf0000000-0xfed8ffff]
[    0.915213] pci_bus 0000:04: resource 0 [io  0xe000-0xefff]
[    0.915215] pci_bus 0000:04: resource 1 [mem 0xfbe00000-0xfbefffff]
[    0.915216] pci_bus 0000:04: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.915218] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.915220] pci_bus 0000:03: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.915222] pci_bus 0000:03: resource 2 [mem 0xc0200000-0xc03fffff 64bit pref]
[    0.915223] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.915225] pci_bus 0000:02: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.915226] pci_bus 0000:02: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
[    0.915228] pci_bus 0000:01: resource 3 [io  0x0000-0x0cf7]
[    0.915230] pci_bus 0000:01: resource 4 [io  0x0d00-0xffff]
[    0.915231] pci_bus 0000:01: resource 5 [mem 0x000a0000-0x000bffff]
[    0.915233] pci_bus 0000:01: resource 6 [mem 0x000d0000-0x000dffff]
[    0.915234] pci_bus 0000:01: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.915236] pci_bus 0000:01: resource 8 [mem 0xf0000000-0xfed8ffff]
[    0.915250] NET: Registered protocol family 2
[    0.915506] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.916412] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.917656] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.917793] TCP: Hash tables configured (established 524288 bind 65536)
[    0.917794] TCP reno registered
[    0.917812] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.917873] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.917994] NET: Registered protocol family 1
[    0.918151] pci 0000:04:00.0: Boot video device
[    0.918159] PCI: CLS 64 bytes, default 64
[    0.918194] Trying to unpack rootfs image as initramfs...
[    1.929433] Freeing initrd memory: 53987k freed
[    1.936850] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.936854] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    1.936856] software IO TLB at phys 0x20000000 - 0x24000000
[    1.937101] Scanning for low memory corruption every 60 seconds
[    1.937724] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.938693] VFS: Disk quotas dquot_6.5.2
[    1.938725] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.939121] fuse init (API version 7.13)
[    1.939178] msgmni has been set to 24071
[    1.939333] alg: No test for stdrng (krng)
[    1.939370] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.939372] io scheduler noop registered
[    1.939374] io scheduler deadline registered
[    1.939416] io scheduler cfq registered (default)
[    1.939490] pcieport 0000:00:01.0: setting latency timer to 64
[    1.939515]   alloc irq_desc for 24 on node -1
[    1.939516]   alloc kstat_irqs on node -1
[    1.939523] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.939571] pcieport 0000:00:03.0: setting latency timer to 64
[    1.939594]   alloc irq_desc for 25 on node -1
[    1.939596]   alloc kstat_irqs on node -1
[    1.939600] pcieport 0000:00:03.0: irq 25 for MSI/MSI-X
[    1.939647] pcieport 0000:00:07.0: setting latency timer to 64
[    1.939670]   alloc irq_desc for 26 on node -1
[    1.939672]   alloc kstat_irqs on node -1
[    1.939676] pcieport 0000:00:07.0: irq 26 for MSI/MSI-X
[    1.939725] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.939751]   alloc irq_desc for 27 on node -1
[    1.939752]   alloc kstat_irqs on node -1
[    1.939757] pcieport 0000:00:1c.0: irq 27 for MSI/MSI-X
[    1.939815] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.939841]   alloc irq_desc for 28 on node -1
[    1.939843]   alloc kstat_irqs on node -1
[    1.939848] pcieport 0000:00:1c.1: irq 28 for MSI/MSI-X
[    1.939911] aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
[    1.939916] aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
[    1.939920] aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
[    1.939932] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.939988] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.940053] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.940055] ACPI: Power Button [PWRB]
[    1.940087] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.940089] ACPI: Power Button [PWRF]
[    1.940865] ACPI: SSDT 00000000bf79e0c0 00403 (v01 DpgPmm  P001Ist 00000011 INTL 20051117)
[    1.941358] ACPI: SSDT 00000000bf79f100 003B2 (v01  PmRef  P001Cst 00003001 INTL 20051117)
[    1.941769] Monitor-Mwait will be used to enter C-1 state
[    1.941784] Monitor-Mwait will be used to enter C-2 state
[    1.941796] Monitor-Mwait will be used to enter C-3 state
[    1.942248] ACPI: SSDT 00000000bf79e4d0 00403 (v01 DpgPmm  P002Ist 00000012 INTL 20051117)
[    1.942663] ACPI: SSDT 00000000bf79f4c0 00085 (v01  PmRef  P002Cst 00003000 INTL 20051117)
[    1.943561] ACPI: SSDT 00000000bf79e8e0 00403 (v01 DpgPmm  P003Ist 00000012 INTL 20051117)
[    1.943983] ACPI: SSDT 00000000bf79f550 00085 (v01  PmRef  P003Cst 00003000 INTL 20051117)
[    1.944923] ACPI: SSDT 00000000bf79ecf0 00403 (v01 DpgPmm  P004Ist 00000012 INTL 20051117)
[    1.945348] ACPI: SSDT 00000000bf79f5e0 00085 (v01  PmRef  P004Cst 00003000 INTL 20051117)
[    1.948530] Linux agpgart interface v0.103
[    1.948546] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.949391] brd: module loaded
[    1.949700] loop: module loaded
[    1.949746] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    1.949818] ata_piix 0000:00:1f.2: version 2.13
[    1.949827]   alloc irq_desc for 19 on node -1
[    1.949828]   alloc kstat_irqs on node -1
[    1.949832] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.949836] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    1.949862] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.949900] scsi0 : ata_piix
[    1.949944] scsi1 : ata_piix
[    1.951501] ata1: SATA max UDMA/133 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 19
[    1.951506] ata2: SATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 19
[    1.951521] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.951524] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    1.951548] ata_piix 0000:00:1f.5: setting latency timer to 64
[    1.951570] scsi2 : ata_piix
[    1.951603] scsi3 : ata_piix
[    1.952780] ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 19
[    1.952783] ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 19
[    1.953307] Fixed MDIO Bus: probed
[    1.953330] PPP generic driver version 2.4.2
[    1.953384] PNP: No PS/2 controller found. Probing ports directly.
[    1.953720] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.953726] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.953763] mice: PS/2 mouse device common for all mice
[    1.953818] rtc_cmos 00:03: RTC can wake from S4
[    1.953837] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.953860] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.953938] device-mapper: uevent: version 1.0.3
[    1.953990] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    1.954043] device-mapper: multipath: version 1.1.1 loaded
[    1.954045] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.954219] cpuidle: using governor ladder
[    1.954348] cpuidle: using governor menu
[    1.954370] oprofile: using NMI interrupt.
[    1.954555] TCP cubic registered
[    1.954653] NET: Registered protocol family 10
[    1.954927] lo: Disabled Privacy Extensions
[    1.955073] NET: Registered protocol family 17
[    1.955083] Bluetooth: L2CAP ver 2.14
[    1.955084] Bluetooth: L2CAP socket layer initialized
[    1.955086] Bluetooth: SCO (Voice Link) ver 0.6
[    1.955087] Bluetooth: SCO socket layer initialized
[    1.955107] Bluetooth: RFCOMM TTY layer initialized
[    1.955109] Bluetooth: RFCOMM socket layer initialized
[    1.955110] Bluetooth: RFCOMM ver 1.11
[    1.956577] PM: Resume from disk failed.
[    1.956847]   Magic number: 10:270:465
[    1.956932] rtc_cmos 00:03: setting system clock to 2010-01-26 04:28:30 UTC (1264480110)
[    1.956935] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.956936] EDD information not available.
[    2.294611] ata3: SATA link down (SStatus 0 SControl 300)
[    2.305384] ata4: SATA link down (SStatus 0 SControl 300)
[    2.802603] ata1.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.802617] ata1.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.802795] ata2.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.802809] ata2.01: SATA link down (SStatus 0 SControl 300)
[    2.802820] ata2.01: link offline, clearing class 3 to NONE
[    2.822789] ata2.00: ATAPI: TSSTcorpDVD-ROM TS-H353B, D700, max UDMA/33
[    2.842863] ata1.00: ATA-7: Hitachi HUA721010KLA330, GKAOA9RA, max UDMA/133
[    2.842867] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.842908] ata1.01: ATAPI: HL-DT-ST DVD+/-RW GH30N, A102, max UDMA/100
[    2.862625] ata2.00: configured for UDMA/33
[    2.882783] ata1.00: configured for UDMA/133
[    2.922455] ata1.01: configured for UDMA/100
[    2.922917] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HUA72101 GKAO PQ: 0 ANSI: 5
[    2.923057] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.923179] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.924398] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVD+-RW GH30N    A102 PQ: 0 ANSI: 5
[    2.924466] sd 0:0:0:0: [sda] Write Protect is off
[    2.924469] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.925367] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.928400] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.928403] Uniform CD-ROM driver Revision: 3.20
[    2.928451]  sda:
[    2.928491] sr 0:0:1:0: Attached scsi CD-ROM sr0
[    2.928537] sr 0:0:1:0: Attached scsi generic sg1 type 5
[    2.929829] scsi 1:0:0:0: CD-ROM            TSSTcorp DVD-ROM TS-H353B D700 PQ: 0 ANSI: 5
[    2.935782] sr1: scsi3-mmc drive: 4x/48x cd/rw xa/form2 cdda tray
[    2.935871] sr 1:0:0:0: Attached scsi CD-ROM sr1
[    2.935914] sr 1:0:0:0: Attached scsi generic sg2 type 5
[    2.941613]  sda1 sda2 < sda5 >
[    2.961235] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.961308] Freeing unused kernel memory: 564k freed
[    2.961406] Write protecting the kernel read-only data: 8192k
[    2.961669] Freeing unused kernel memory: 152k freed
[    2.961943] Freeing unused kernel memory: 2016k freed
[    3.005798] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    3.005800] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    3.005835]   alloc irq_desc for 20 on node -1
[    3.005836]   alloc kstat_irqs on node -1
[    3.005842] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    3.005849] e1000e 0000:00:19.0: setting latency timer to 64
[    3.005917]   alloc irq_desc for 29 on node -1
[    3.005918]   alloc kstat_irqs on node -1
[    3.005925] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    3.018823] ohci1394 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.018830] ohci1394 0000:02:00.0: setting latency timer to 64
[    3.074194] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fbdff800-fbdfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    3.533416] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:e8:08:87:ea
[    3.533420] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    3.533441] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: ffffff-0ff
[    3.728120] kjournald starting.  Commit interval 5 seconds
[    3.728129] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    4.400386] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0024e880000887ea]
[    6.497804] Adding 36041788k swap on /dev/sda5.  Priority:-1 extents:1 across:36041788k 
[    7.068086] EXT3-fs (sda1): using internal journal
[    7.111992] udev: starting version 149
[    8.865194] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    9.177999] lp: driver loaded but no devices found
[   11.720904] mv[3135]: segfault at 7ffe93aa8dd8 ip 00007fc0c7ec2305 sp 00007ffe93aa8de0 error 6 in libattr.so.1.1.0[7fc0c7ec0000+4000]
[   12.061347] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   12.120923] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[   12.122729] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   15.434647] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   15.436410] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   22.683358] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   26.358101] eth0: no IPv6 routers present
[   28.977712] CPUFREQ: Per core ondemand sysfs interface is deprecated - ignore_nice_load
[   32.148921] ppdev: user-space parallel port driver
[  534.926499] coretemp coretemp.0: Unable to access MSR 0xEE, for Tjmax, left at default
[  534.926542] coretemp coretemp.1: Unable to access MSR 0xEE, for Tjmax, left at default
[  534.926582] coretemp coretemp.2: Unable to access MSR 0xEE, for Tjmax, left at default
[  534.926621] coretemp coretemp.3: Unable to access MSR 0xEE, for Tjmax, left at default

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=powertop

PowerTOP 1.12   (C) 2007, 2008 Intel Corporation 

Collecting data for 15 seconds 


Cn	          Avg residency
C0 (cpu running)        ( 1.0%)
polling		  0.0ms ( 0.0%)
C1 mwait	  0.0ms ( 0.0%)
C2 mwait	 63.7ms (99.0%)
C3 mwait	  0.0ms ( 0.0%)
P-states (frequencies)
Turbo Mode     0.0%
  2.67 Ghz     0.0%
  2.54 Ghz     0.0%
  2.40 Ghz     0.0%
  1.60 Ghz   100.0%
Wakeups-from-idle per second : 15.5	interval: 15.0s
no ACPI power usage estimate available
Top causes for wakeups:
  26.2% ( 16.6)   [kernel scheduler] Load balancing tick
  18.1% ( 11.5)   [extra timer interrupt]
  16.4% ( 10.4)   [ata_piix, ata_piix] <interrupt>
  15.5% (  9.8)   [Rescheduling interrupts] <kernel IPI>
   7.9% (  5.0)   offlineimap
   4.5% (  2.9)   [kernel core] hrtimer_start (tick_sched_timer)
   3.2% (  2.0)   [kernel core] add_timer_on (clocksource_watchdog)
   1.7% (  1.1)   hald-addon-stor
   1.6% (  1.0)   ntpd
   1.1% (  0.7)   [eth0] <interrupt>
   1.1% (  0.7)   devkit-disks-da
   0.8% (  0.5)   events/1
   0.4% (  0.3)   [kernel core] enqueue_task_rt (sched_rt_period_timer)
   0.3% (  0.2)   [kernel core] __mod_timer (dev_watchdog)
   0.3% (  0.2)   rtkit-daemon
   0.1% (  0.1)   events/2
   0.1% (  0.1)   [kernel core] __mod_timer (tcp_delack_timer)
   0.1% (  0.1)   sshd
   0.1% (  0.1)   [kernel core] __mod_timer (neigh_timer_handler)
   0.1% (  0.1)   ssh-agent
   0.1% (  0.1)   [kernel core] __mod_timer (cfq_idle_slice_timer)
   0.1% (  0.1)   mythbackend
   0.1% (  0.1)   NetworkManager
   0.1% (  0.1)   rsyslogd
   0.1% (  0.1)   [kernel core] __mod_timer (sync_supers_timer_fn)

Suggestion: Enable the CONFIG_USB_SUSPEND kernel configuration option.
This option will automatically disable UHCI USB when not in use, and may
save approximately 1 Watt of power.

Recent USB suspend statistics
Active  Device name

Recent audio activity statistics
Active  Device name

Recent SATA AHCI link activity statistics
Active	Partial	Slumber	Device name

--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=cpuinfo

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping	: 4
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5320.93
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping	: 4
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.90
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping	: 4
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         920  @ 2.67GHz
stepping	: 4
cpu MHz		: 1600.000
cache size	: 8192 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm ida tpr_shadow vnmi flexpriority ept vpid
bogomips	: 5319.90
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:


--Nq2Wo0NMKNjxTN9z--
