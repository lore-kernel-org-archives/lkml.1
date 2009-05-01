Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbZEACwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbZEACwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZEACvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:51:50 -0400
Received: from thunk.org ([69.25.196.29]:43360 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZEACvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:51:46 -0400
Date: Thu, 30 Apr 2009 22:51:32 -0400
From: Theodore Tso <tytso@mit.edu>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
	question)
Message-ID: <20090501025132.GA7275@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Robert Hancock <hancockrwd@gmail.com>,
	Alex Buell <alex.buell@munted.org.uk>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@linux.intel.com>,
	Linux IDE mailing list <linux-ide@vger.kernel.org>
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <20090430113445.GA4809@mit.edu> <20090430113814.GB4809@mit.edu> <49FA55A0.8080303@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <49FA55A0.8080303@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 30, 2009 at 07:51:28PM -0600, Robert Hancock wrote:
>> Thinking about this a bit more, I'll bet the problem is the BIOS
>> setting is only affecting the primary SATA ports (which are being
>> grabed by ahci) and not the SATA port in the Ultrabay slot (which is
>> being picked up by either the ata_piix or piix driver).  Sigh...
>
> dmesg and lspci -vv output might be useful..

Here you go...



--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.30-rc3-00369-ga774073 (root@closure) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #27 SMP Sun Apr 26 23:54:09 EDT 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
[    0.000000]  BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   1 base 13C000000 mask FFC000000 uncachable
[    0.000000]   2 base 000000000 mask F00000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0BF700000 mask FFFF00000 uncachable
[    0.000000]   5 base 0BF800000 mask FFF800000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bf700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] RAMDISK: 378b6000 - 37feff74
[    0.000000] Allocated new RAMDISK: 00db1000 - 014eaf74
[    0.000000] Move RAMDISK from 00000000378b6000 - 0000000037feff73 to 00db1000 - 014eaf73
[    0.000000] ACPI: RSDP 000f6950 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT bf6bd368 00094 (v01 LENOVO TP-7N    00002190  LTP 00000000)
[    0.000000] ACPI: FACP bf6bd500 000F4 (v03 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI Warning (tbfadt-0531): 32/64X length mismatch in Gpe1Block: 0/32 [20090320]
[    0.000000] ACPI Warning (tbfadt-0562): Optional field Gpe1Block has zero address or length: 000000000000102C/0 [20090320]
[    0.000000] ACPI: DSDT bf6bd8db 0E32A (v01 LENOVO TP-7N    00002190 MSFT 03000000)
[    0.000000] ACPI: FACS bf6e4000 00040
[    0.000000] ACPI: SSDT bf6bd6b4 00227 (v01 LENOVO TP-7N    00002190 MSFT 03000000)
[    0.000000] ACPI: ECDT bf6cbc05 00052 (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: TCPA bf6cbc57 00032 (v02 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: APIC bf6cbc89 00068 (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: MCFG bf6cbcf1 0003C (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: HPET bf6cbd2d 00038 (v01 LENOVO TP-7N    00002190 LNVO 00000001)
[    0.000000] ACPI: SLIC bf6cbdf0 00176 (v01 LENOVO TP-7N    00002190  LTP 00000000)
[    0.000000] ACPI: BOOT bf6cbf66 00028 (v01 LENOVO TP-7N    00002190  LTP 00000001)
[    0.000000] ACPI: ASF! bf6cbf8e 00072 (v16 LENOVO TP-7N    00002190 PTL  00000001)
[    0.000000] ACPI: SSDT bf6e2697 0025F (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT bf6e28f6 000A6 (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT bf6e299c 004F7 (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: SSDT bf6e2e93 001D8 (v01 LENOVO TP-7N    00002190 INTL 20050513)
[    0.000000] ACPI: DMI detected: Lenovo ThinkPad X61
[    0.000000] ACPI: Added _OSI(Linux)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 4166MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00009000 - 0000ff40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000da6dcc]    TEXT DATA BSS ==> [0000100000 - 0000da6dcc]
[    0.000000]   #4 [000009d800 - 0000100000]    BIOS reserved ==> [000009d800 - 0000100000]
[    0.000000]   #5 [0000da7000 - 0000db0138]              BRK ==> [0000da7000 - 0000db0138]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000db1000 - 00014eaf74]      NEW RAMDISK ==> [0000db1000 - 00014eaf74]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f6980] f6980
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009d
[    0.000000]     0: 0x00000100 -> 0x000bf6b0
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1029709
[    0.000000] free_area_init_node: node 0, pgdat c0713bc0, node_mem_map c14eb000
[    0.000000]   DMA zone: 60 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3937 pages, LIFO batch:0
[    0.000000]   Normal zone: 3278 pages used for memmap
[    0.000000]   Normal zone: 220464 pages, LIFO batch:31
[    0.000000]   HighMem zone: 15623 pages used for memmap
[    0.000000]   HighMem zone: 786347 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 334 pages at c5f33000, static data 1346460 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1010748
[    0.000000] Kernel command line: root=/dev/mapper/ssd-root rootfstype=ext4 ro thinkpad_acpi.brightness_enable=1 quiet splash 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] CPU 0 irqstacks, hard=c5f33000 soft=c5f34000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1595.841 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 3103 kB
[    0.003333]  per task-struct memory footprint: 1920 bytes
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Initializing HighMem for node 0 (000379fe:0013c000)
[    0.003333] Memory: 4018088k/5177344k available (4048k kernel code, 99964k reserved, 2251k data, 1660k init, 3207880k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
[    0.003333]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.003333]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.003333]       .init : 0xc072d000 - 0xc08cc000   (1660 kB)
[    0.003333]       .data : 0xc04f411d - 0xc0726ff0   (2251 kB)
[    0.003333]       .text : 0xc0100000 - 0xc04f411d   (4048 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.66 BogoMIPS (lpj=5319470)
[    0.003333] Security Framework initialized
[    0.003333] SELinux:  Disabled at boot.
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] Initializing cgroup subsys debug
[    0.003333] Initializing cgroup subsys ns
[    0.003333] Initializing cgroup subsys cpuacct
[    0.003333] Initializing cgroup subsys devices
[    0.003333] Initializing cgroup subsys freezer
[    0.003333] Initializing cgroup subsys net_cls
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 4096K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#0.
[    0.003333] using mwait in idle threads.
[    0.003333] Checking 'hlt' instruction... OK.
[    0.016543] ACPI: Core revision 20090320
[    0.086699] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.086714] ftrace: allocating 20570 entries in 41 pages
[    0.093788] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.126813] CPU0: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0b
[    0.129999] lockdep: fixing up alternatives.
[    0.129999] CPU 1 irqstacks, hard=c6081000 soft=c6082000
[    0.129999] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3193.95 BogoMIPS (lpj=5319934)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 4096K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.226619] CPU1: Intel(R) Core(TM)2 Duo CPU     L7500  @ 1.60GHz stepping 0b
[    0.226648] checking TSC synchronization [CPU#0 -> CPU#1]:
[    0.226666] Measured 882784 cycles TSC warp between CPUs, turning off TSC clock.
[    0.226666] Marking TSC unstable due to check_tsc_sync_source failed
[    0.226778] Brought up 2 CPUs
[    0.226786] Total of 2 processors activated (6386.62 BogoMIPS).
[    0.227002] CPU0 attaching sched-domain:
[    0.227010]  domain 0: span 0-1 level MC
[    0.227018]   groups: 0 1
[    0.227067] CPU1 attaching sched-domain:
[    0.227074]  domain 0: span 0-1 level MC
[    0.227081]   groups: 1 0
[    0.227498] khelper used greatest stack depth: 2804 bytes left
[    0.227626] net_namespace: 1264 bytes
[    0.230236] Booting paravirtualized kernel on bare hardware
[    0.230728] regulator: core version 0.5
[    0.230728] NET: Registered protocol family 16
[    0.233621] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.233668] ACPI: bus type pci registered
[    0.233724] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.233724] PCI: MCFG area at f0000000 reserved in E820
[    0.233724] PCI: Using MMCONFIG for extended config space
[    0.233724] PCI: Using configuration type 1 for base access
[    0.260318] bio: create slab <bio-0> at 0
[    0.280223] ACPI: EC: EC description table is found, configuring boot EC
[    0.320473] ACPI: BIOS _OSI(Linux) query honored via DMI
[    0.323421] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.353763] ACPI: Interpreter enabled
[    0.353775] ACPI: (supports S0 S3 S4 S5)
[    0.353936] ACPI: Using IOAPIC for interrupt routing
[    0.413636] ACPI: EC: GPE = 0x12, I/O: command/status = 0x66, data = 0x62
[    0.413644] ACPI: EC: driver started in interrupt mode
[    0.413795] ACPI: Power Resource [PUBS] (on)
[    0.426165] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.427619] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.427887] pci 0000:00:02.0: reg 10 64bit mmio: [0xf8000000-0xf80fffff]
[    0.427887] pci 0000:00:02.0: reg 18 64bit mmio: [0xe0000000-0xefffffff]
[    0.427887] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.427887] pci 0000:00:02.1: reg 10 64bit mmio: [0xf8100000-0xf81fffff]
[    0.428024] pci 0000:00:19.0: reg 10 32bit mmio: [0xf8200000-0xf821ffff]
[    0.428057] pci 0000:00:19.0: reg 14 32bit mmio: [0xf8225000-0xf8225fff]
[    0.428089] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.428307] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.428326] pci 0000:00:19.0: PME# disabled
[    0.428548] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.430189] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.430458] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf8426c00-0xf8426fff]
[    0.430701] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.430720] pci 0000:00:1a.7: PME# disabled
[    0.430934] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf8220000-0xf8223fff]
[    0.431195] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.431213] pci 0000:00:1b.0: PME# disabled
[    0.431571] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.431590] pci 0000:00:1c.0: PME# disabled
[    0.431959] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.431977] pci 0000:00:1c.1: PME# disabled
[    0.432271] pci 0000:00:1d.0: reg 20 io port: [0x18a0-0x18bf]
[    0.432547] pci 0000:00:1d.1: reg 20 io port: [0x18c0-0x18df]
[    0.432852] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf8427000-0xf84273ff]
[    0.433118] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.433137] pci 0000:00:1d.7: PME# disabled
[    0.433818] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.433835] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.433849] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
[    0.433863] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
[    0.433877] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
[    0.434079] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.434111] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.434142] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.434173] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.434205] pci 0000:00:1f.1: reg 20 io port: [0x18e0-0x18ef]
[    0.434514] pci 0000:00:1f.2: reg 10 io port: [0x1c30-0x1c37]
[    0.434546] pci 0000:00:1f.2: reg 14 io port: [0x1c24-0x1c27]
[    0.434578] pci 0000:00:1f.2: reg 18 io port: [0x1c28-0x1c2f]
[    0.434610] pci 0000:00:1f.2: reg 1c io port: [0x1c20-0x1c23]
[    0.434641] pci 0000:00:1f.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.434673] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf8426000-0xf84267ff]
[    0.434853] pci 0000:00:1f.2: PME# supported from D3hot
[    0.434871] pci 0000:00:1f.2: PME# disabled
[    0.435007] pci 0000:00:1f.3: reg 10 32bit mmio: [0xf8427400-0xf84274ff]
[    0.435112] pci 0000:00:1f.3: reg 20 io port: [0x1c40-0x1c5f]
[    0.435508] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.435528] pci 0000:00:1c.0: bridge 32bit mmio: [0xf4000000-0xf5ffffff]
[    0.435560] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8500000-0xf85fffff]
[    0.435961] pci 0000:03:00.0: reg 10 64bit mmio: [0xf7f00000-0xf7f01fff]
[    0.436453] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.436497] pci 0000:03:00.0: PME# disabled
[    0.436881] pci 0000:00:1c.1: bridge io port: [0x3000-0x3fff]
[    0.436900] pci 0000:00:1c.1: bridge 32bit mmio: [0xf6000000-0xf7ffffff]
[    0.436932] pci 0000:00:1c.1: bridge 64bit mmio pref: [0xf8600000-0xf86fffff]
[    0.437116] pci 0000:05:00.0: reg 10 32bit mmio: [0xd7eff000-0xd7efffff]
[    0.437218] pci 0000:05:00.0: supports D1 D2
[    0.437224] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.437244] pci 0000:05:00.0: PME# disabled
[    0.437422] pci 0000:05:00.1: reg 10 32bit mmio: [0xd7efe800-0xd7efefff]
[    0.437680] pci 0000:05:00.1: supports D1 D2
[    0.437686] pci 0000:05:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.437705] pci 0000:05:00.1: PME# disabled
[    0.437882] pci 0000:05:00.2: reg 10 32bit mmio: [0xd7efe400-0xd7efe4ff]
[    0.438139] pci 0000:05:00.2: supports D1 D2
[    0.438145] pci 0000:05:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.438165] pci 0000:05:00.2: PME# disabled
[    0.438472] pci 0000:00:1e.0: transparent bridge
[    0.438492] pci 0000:00:1e.0: bridge io port: [0x4000-0x7fff]
[    0.438511] pci 0000:00:1e.0: bridge 32bit mmio: [0xd4000000-0xd7efffff]
[    0.438543] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd8000000-0xdbffffff]
[    0.438718] pci_bus 0000:00: on NUMA node 0
[    0.438742] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.439500] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.439787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.440114] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.473923] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
[    0.474701] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.475472] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.476239] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.477055] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.477824] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.478637] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.479404] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.480353] SCSI subsystem initialized
[    0.480353] libata version 3.00 loaded.
[    0.480353] ACPI: WMI: Mapper loaded
[    0.480353] PCI: Using ACPI for IRQ routing
[    0.496845] NET: Registered protocol family 8
[    0.496853] NET: Registered protocol family 20
[    0.543541] cfg80211: Using static regulatory domain info
[    0.543541] cfg80211: Regulatory domain: US
[    0.543541] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.543541] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.543541] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.543541] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.543541] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.543541] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.543541] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.543817] cfg80211: Calling CRDA for country: US
[    0.544057] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.544073] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.553402] Switched to high resolution mode on CPU 0
[    0.553465] Switched to high resolution mode on CPU 1
[    0.570063] pnp: PnP ACPI init
[    0.570156] ACPI: bus type pnp registered
[    0.587454] pnp: PnP ACPI: found 11 devices
[    0.587463] ACPI: ACPI bus type pnp unregistered
[    0.587471] PnPBIOS: Disabled by ACPI PNP
[    0.587631] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.587644] system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
[    0.587655] system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
[    0.587665] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.587674] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.587685] system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
[    0.587696] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.587707] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.587718] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.587728] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.587739] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.587750] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.587762] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.587773] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.587815] system 00:02: ioport range 0x164e-0x164f has been reserved
[    0.587825] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.587835] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.587845] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.587855] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.587866] system 00:02: ioport range 0x1600-0x165f could not be reserved
[    0.587877] system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.587887] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.587898] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.587909] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.587920] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.587930] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.626003] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.626018] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.626044] pci 0000:00:1c.0:   MEM window: 0xf4000000-0xf5ffffff
[    0.626064] pci 0000:00:1c.0:   PREFETCH window: 0x000000f8500000-0x000000f85fffff
[    0.626096] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.626109] pci 0000:00:1c.1:   IO window: 0x3000-0x3fff
[    0.626134] pci 0000:00:1c.1:   MEM window: 0xf6000000-0xf7ffffff
[    0.626153] pci 0000:00:1c.1:   PREFETCH window: 0x000000f8600000-0x000000f86fffff
[    0.626201] pci 0000:05:00.0: CardBus bridge, secondary bus 0000:06
[    0.626207] pci 0000:05:00.0:   IO window: 0x004000-0x0040ff
[    0.626227] pci 0000:05:00.0:   IO window: 0x004400-0x0044ff
[    0.626247] pci 0000:05:00.0:   PREFETCH window: 0xd8000000-0xdbffffff
[    0.626266] pci 0000:05:00.0:   MEM window: 0xc4000000-0xc7ffffff
[    0.626286] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.626299] pci 0000:00:1e.0:   IO window: 0x4000-0x7fff
[    0.626324] pci 0000:00:1e.0:   MEM window: 0xd4000000-0xd7efffff
[    0.626343] pci 0000:00:1e.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
[    0.626424]   alloc irq_desc for 20 on cpu 0 node 0
[    0.626431]   alloc kstat_irqs on cpu 0 node 0
[    0.626449] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.626469] pci 0000:00:1c.0: setting latency timer to 64
[    0.626501]   alloc irq_desc for 21 on cpu 0 node 0
[    0.626507]   alloc kstat_irqs on cpu 0 node 0
[    0.626521] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.626540] pci 0000:00:1c.1: setting latency timer to 64
[    0.626563] pci 0000:00:1e.0: enabling device (0005 -> 0007)
[    0.626588] pci 0000:00:1e.0: setting latency timer to 64
[    0.626620]   alloc irq_desc for 16 on cpu 0 node 0
[    0.626626]   alloc kstat_irqs on cpu 0 node 0
[    0.626640] pci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.626663] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.626671] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.626679] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.626686] pci_bus 0000:02: resource 1 mem: [0xf4000000-0xf5ffffff]
[    0.626694] pci_bus 0000:02: resource 2 mem: [0xf8500000-0xf85fffff]
[    0.626701] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.626708] pci_bus 0000:03: resource 0 io:  [0x3000-0x3fff]
[    0.626715] pci_bus 0000:03: resource 1 mem: [0xf6000000-0xf7ffffff]
[    0.626722] pci_bus 0000:03: resource 2 mem: [0xf8600000-0xf86fffff]
[    0.626729] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.626736] pci_bus 0000:05: resource 0 io:  [0x4000-0x7fff]
[    0.626743] pci_bus 0000:05: resource 1 mem: [0xd4000000-0xd7efffff]
[    0.626750] pci_bus 0000:05: resource 2 mem: [0xd8000000-0xdbffffff]
[    0.626757] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.626764] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.626772] pci_bus 0000:06: resource 0 io:  [0x4000-0x40ff]
[    0.626778] pci_bus 0000:06: resource 1 io:  [0x4400-0x44ff]
[    0.626785] pci_bus 0000:06: resource 2 mem: [0xd8000000-0xdbffffff]
[    0.626792] pci_bus 0000:06: resource 3 mem: [0xc4000000-0xc7ffffff]
[    0.627007] NET: Registered protocol family 2
[    0.664749] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.667224] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.668577] TCP bind hash table entries: 65536 (order: 9, 2621440 bytes)
[    0.682796] TCP: Hash tables configured (established 131072 bind 65536)
[    0.682877] TCP reno registered
[    0.691312] NET: Registered protocol family 1
[    0.692110] checking if image is initramfs...
[    1.326442] rootfs image is initramfs; unpacking...
[    1.326933] Freeing initrd memory: 7399k freed
[    1.336034] Simple Boot Flag at 0x35 set to 0x1
[    1.344812] cpu0(2) debug files 133
[    1.350111] cpu1(2) debug files 133
[    1.353269] audit: initializing netlink socket (disabled)
[    1.353361] type=2000 audit(1241126574.350:1): initialized
[    1.377950] highmem bounce pool size: 64 pages
[    1.377971] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.395390] VFS: Disk quotas dquot_6.5.2
[    1.395999] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.402228] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.404511] fuse init (API version 7.11)
[    1.405466] msgmni has been set to 1598
[    1.407143] alg: No test for cipher_null (cipher_null-generic)
[    1.407279] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.407413] alg: No test for digest_null (digest_null-generic)
[    1.407563] alg: No test for compress_null (compress_null-generic)
[    1.407946] cryptomgr_test used greatest stack depth: 2252 bytes left
[    1.410677] alg: No test for stdrng (krng)
[    1.411325] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.411392] io scheduler noop registered
[    1.411454] io scheduler cfq registered (default)
[    1.411790] pci 0000:00:02.0: Boot video device
[    1.413290]   alloc irq_desc for 24 on cpu 0 node 0
[    1.413298]   alloc kstat_irqs on cpu 0 node 0
[    1.413344] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.413423] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    1.414718]   alloc irq_desc for 25 on cpu 0 node 0
[    1.414726]   alloc kstat_irqs on cpu 0 node 0
[    1.414766] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    1.414841] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    1.417963] power_supply AC: uevent
[    1.417969] power_supply AC: No power supply yet
[    1.418465] power_supply AC: power_supply_changed
[    1.418488] ACPI: AC Adapter [AC] (off-line)
[    1.418665] power_supply AC: power_supply_changed_work
[    1.418693] power_supply AC: power_supply_update_gen_leds 0
[    1.418760] power_supply AC: uevent
[    1.418766] power_supply AC: POWER_SUPPLY_NAME=AC
[    1.418778] power_supply AC: Static prop TYPE=Mains
[    1.418785] power_supply AC: 1 dynamic props
[    1.418793] power_supply AC: prop ONLINE=0
[    1.419864] input: Power Button as /class/input/input0
[    1.420001] ACPI: Power Button [PWRF]
[    1.420476] input: Lid Switch as /class/input/input1
[    1.421396] ACPI: Lid Switch [LID]
[    1.421837] input: Sleep Button as /class/input/input2
[    1.421858] ACPI: Sleep Button [SLPB]
[    1.425163] ACPI: SSDT bf6e1b32 00282 (v01  PmRef  Cpu0Ist 00000100 INTL 20050513)
[    1.430074] ACPI: SSDT bf6e1e39 0085E (v01  PmRef  Cpu0Cst 00000100 INTL 20050513)
[    1.445612] Monitor-Mwait will be used to enter C-1 state
[    1.445732] Monitor-Mwait will be used to enter C-2 state
[    1.445849] Monitor-Mwait will be used to enter C-3 state
[    1.446586] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.447192] processor ACPI_CPU:00: registered as cooling_device0
[    1.447215] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.448489] ACPI: SSDT bf6e1a6a 000C8 (v01  PmRef  Cpu1Ist 00000100 INTL 20050513)
[    1.453397] ACPI: SSDT bf6e1db4 00085 (v01  PmRef  Cpu1Cst 00000100 INTL 20050513)
[    1.462414] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.462674] processor ACPI_CPU:01: registered as cooling_device1
[    1.462695] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.483603] thermal LNXTHERM:01: registered as thermal_zone0
[    1.483661] ACPI: Thermal Zone [THM0] (37 C)
[    1.488706] thermal LNXTHERM:02: registered as thermal_zone1
[    1.488769] ACPI: Thermal Zone [THM1] (38 C)
[    1.489094] isapnp: Scanning for PnP cards...
[    1.648436] power_supply BAT0: uevent
[    1.648443] power_supply BAT0: No power supply yet
[    1.663634] power_supply BAT0: power_supply_changed
[    1.663873] power_supply BAT0: power_supply_changed_work
[    1.670468] ACPI: Battery Slot [BAT0] (battery present)
[    1.677096] power_supply BAT0: power_supply_update_bat_leds 2
[    1.677121] power_supply BAT0: uevent
[    1.677128] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    1.677140] power_supply BAT0: Static prop TYPE=Battery
[    1.677147] power_supply BAT0: 13 dynamic props
[    1.677155] power_supply BAT0: prop STATUS=Discharging
[    1.677164] power_supply BAT0: prop PRESENT=1
[    1.677173] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    1.677183] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=14400000
[    1.677192] power_supply BAT0: prop VOLTAGE_NOW=16507000
[    1.677201] power_supply BAT0: prop CURRENT_NOW=16820000
[    1.677210] power_supply BAT0: prop POWER_NOW=16820000
[    1.677219] power_supply BAT0: prop ENERGY_FULL_DESIGN=74880000
[    1.677229] power_supply BAT0: prop ENERGY_FULL=74880000
[    1.677238] power_supply BAT0: prop ENERGY_NOW=74810000
[    1.677247] power_supply BAT0: prop MODEL_NAME=93P5030
[    1.677256] power_supply BAT0: prop MANUFACTURER=SONY
[    1.677264] power_supply BAT0: prop SERIAL_NUMBER= 6895
[    1.852770] isapnp: No Plug & Play device found
[    2.011099] Non-volatile memory driver v1.3
[    2.011312] Linux agpgart interface v0.103
[    2.011549] [drm] Initialized drm 1.1.0 20060810
[    2.011557] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.025958] brd: module loaded
[    2.031102] loop: module loaded
[    2.031460] input: Macintosh mouse button emulation as /class/input/input3
[    2.031616] Uniform Multi-Platform E-IDE driver
[    2.032039] ide-gd driver 1.18
[    2.033140] Driver 'sd' needs updating - please use bus_type methods
[    2.033433] ahci 0000:00:1f.2: version 3.0
[    2.033476] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    2.033644]   alloc irq_desc for 26 on cpu 0 node 0
[    2.033651]   alloc kstat_irqs on cpu 0 node 0
[    2.033696] ahci 0000:00:1f.2: irq 26 for MSI/MSI-X
[    2.033901] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x5 impl SATA mode
[    2.033911] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
[    2.033932] ahci 0000:00:1f.2: setting latency timer to 64
[    2.034660] scsi0 : ahci
[    2.035662] scsi1 : ahci
[    2.036134] scsi2 : ahci
[    2.036740] ata1: SATA max UDMA/133 abar m2048@0xf8426000 port 0xf8426100 irq 26
[    2.036747] ata2: DUMMY
[    2.036757] ata3: SATA max UDMA/133 abar m2048@0xf8426000 port 0xf8426200 irq 26
[    2.037065] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[    2.037071] Copyright (c) 1999-2006 Intel Corporation.
[    2.037398] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    2.037404] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    2.037559] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.037585] e1000e 0000:00:19.0: setting latency timer to 64
[    2.037980]   alloc irq_desc for 27 on cpu 0 node 0
[    2.037987]   alloc kstat_irqs on cpu 0 node 0
[    2.038034] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    2.241383] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1d:72:86:9c:c6
[    2.241391] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.241445] 0000:00:19.0: eth0: MAC: 6, PHY: 6, PBA No: 1008ff-0ff
[    2.241774] Fusion MPT base driver 3.04.07
[    2.241779] Copyright (c) 1999-2008 LSI Corporation
[    2.241816] Fusion MPT SPI Host driver 3.04.07
[    2.242583] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.254066] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.254172] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.256597] mice: PS/2 mouse device common for all mice
[    2.261048] cpuidle: using governor ladder
[    2.264582] cpuidle: using governor menu
[    2.265962] input: AT Translated Set 2 keyboard as /class/input/input4
[    2.267372] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    2.267380] thinkpad_acpi: http://ibm-acpi.sf.net/
[    2.267385] thinkpad_acpi: ThinkPad BIOS 7NETB9WW (2.19 ), EC 7MHT25WW-1.03
[    2.267392] thinkpad_acpi: Lenovo ThinkPad X61s, model 76663EU
[    2.269206] thinkpad_acpi: radio switch found; radios are enabled
[    2.269695] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    2.269702] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    2.294270] Registered led device: tpacpi::thinklight
[    2.294908] thinkpad_acpi: acpi_bus_get_device(bay) failed: -19
[    2.295009] thinkpad_acpi: disabling subdriver bay
[    2.295422] Registered led device: tpacpi::power
[    2.295791] Registered led device: tpacpi::standby
[    2.301867] thinkpad_acpi: Backlight control force enabled, even if standard ACPI backlight interface is available
[    2.301884] thinkpad_acpi: detected a 16-level brightness capable ThinkPad
[    2.303912] input: ThinkPad Extra Buttons as /class/input/input5
[    2.305011] Advanced Linux Sound Architecture Driver Version 1.0.19.
[    2.318861] ALSA device list:
[    2.318867]   No soundcards found.
[    2.322404] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.338239] TCP cubic registered
[    2.340433] RPC: Registered udp transport module.
[    2.340441] RPC: Registered tcp transport module.
[    2.345586] Using IPI No-Shortcut mode
[    2.347755] PM: Resume from disk failed.
[    2.347832] registered taskstats version 1
[    2.353550] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.353611] ata3: SATA link down (SStatus 0 SControl 300)
[    2.354675] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    2.354686] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.354695] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.355096] ata1.00: ATA-7: INTEL SSDSA2MH080G1GC, 045C8820, max UDMA/133
[    2.355105] ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31)
[    2.356477] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    2.356487] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    2.356496] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    2.357033] ata1.00: configured for UDMA/133
[    2.371806] ata1.00: configured for UDMA/133
[    2.371820] ata1: EH complete
[    2.373030] scsi 0:0:0:0: Direct-Access     ATA      INTEL SSDSA2MH08 045C PQ: 0 ANSI: 5
[    2.376159] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    2.376260] sd 0:0:0:0: [sda] Write Protect is off
[    2.376269] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.376412] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.377373]  sda: sda1 sda2
[    2.380923] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.381142] Freeing unused kernel memory: 1660k freed
[    2.383383] Write protecting the kernel text: 4052k
[    2.384091] Write protecting the kernel read-only data: 1940k
[    2.651972] usplash[1299] general protection ip:b7f63d3b sp:bfee4e88 error:0 in libusplash.so.0[b7f50000+29000]
[    2.673160] device-mapper: uevent: version 1.0.3
[    2.673594] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.779159] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    2.790509] power_supply AC: uevent
[    2.790513] power_supply AC: POWER_SUPPLY_NAME=AC
[    2.790520] power_supply AC: Static prop TYPE=Mains
[    2.790524] power_supply AC: 1 dynamic props
[    2.790529] power_supply AC: prop ONLINE=0
[    2.790574] power_supply BAT0: uevent
[    2.790577] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    2.790582] power_supply BAT0: Static prop TYPE=Battery
[    2.790586] power_supply BAT0: 13 dynamic props
[    2.798123] input: TPPS/2 IBM TrackPoint as /class/input/input6
[    2.798578] power_supply BAT0: prop STATUS=Discharging
[    2.798585] power_supply BAT0: prop PRESENT=1
[    2.798590] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    2.798595] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=14400000
[    2.798600] power_supply BAT0: prop VOLTAGE_NOW=16507000
[    2.798604] power_supply BAT0: prop CURRENT_NOW=16820000
[    2.798609] power_supply BAT0: prop POWER_NOW=16820000
[    2.798613] power_supply BAT0: prop ENERGY_FULL_DESIGN=74880000
[    2.798618] power_supply BAT0: prop ENERGY_FULL=74880000
[    2.798623] power_supply BAT0: prop ENERGY_NOW=74810000
[    2.798627] power_supply BAT0: prop MODEL_NAME=93P5030
[    2.798632] power_supply BAT0: prop MANUFACTURER=SONY
[    2.798636] power_supply BAT0: prop SERIAL_NUMBER= 6895
[    2.827310] udevadm used greatest stack depth: 2172 bytes left
[    2.859474] scsi_id used greatest stack depth: 1888 bytes left
[    3.605170] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.785967] PM: Starting manual resume from disk
[    3.785997] PM: Resume from partition 8:2
[    3.786002] PM: Checking hibernation image.
[    3.786681] PM: Resume from disk failed.
[    3.799831] EXT4-fs: barriers enabled
[    3.800518] kjournald2 starting: pid 2375, dev dm-0:8, commit interval 5 seconds
[    3.800707] EXT4-fs: delayed allocation enabled
[    3.800714] EXT4-fs: file extents enabled
[    3.804557] EXT4-fs: mballoc enabled
[    3.804774] EXT4-fs: mounted filesystem dm-0 with ordered data mode
[    4.798246] readahead-list used greatest stack depth: 1736 bytes left
[    5.000919] Clocksource tsc unstable (delta = -100432316 ns)
[    5.103417] udev: starting version 141
[    5.103471] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[    5.227965] power_supply AC: uevent
[    5.227969] power_supply AC: POWER_SUPPLY_NAME=AC
[    5.227976] power_supply AC: Static prop TYPE=Mains
[    5.227980] power_supply AC: 1 dynamic props
[    5.227984] power_supply AC: prop ONLINE=0
[    5.228034] power_supply BAT0: uevent
[    5.228038] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.228044] power_supply BAT0: Static prop TYPE=Battery
[    5.228048] power_supply BAT0: 13 dynamic props
[    5.270580] power_supply BAT0: prop STATUS=Discharging
[    5.270587] power_supply BAT0: prop PRESENT=1
[    5.270593] power_supply BAT0: prop TECHNOLOGY=Li-ion
[    5.270598] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=14400000
[    5.270603] power_supply BAT0: prop VOLTAGE_NOW=16471000
[    5.270608] power_supply BAT0: prop CURRENT_NOW=16998000
[    5.270612] power_supply BAT0: prop POWER_NOW=16998000
[    5.270617] power_supply BAT0: prop ENERGY_FULL_DESIGN=74880000
[    5.270622] power_supply BAT0: prop ENERGY_FULL=74880000
[    5.270626] power_supply BAT0: prop ENERGY_NOW=74790000
[    5.270631] power_supply BAT0: prop MODEL_NAME=93P5030
[    5.270636] power_supply BAT0: prop MANUFACTURER=SONY
[    5.270640] power_supply BAT0: prop SERIAL_NUMBER= 6895
[    6.215565] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[    6.217612] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[    6.221034] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[    6.246233]   alloc irq_desc for 17 on cpu 0 node 0
[    6.246238]   alloc kstat_irqs on cpu 0 node 0
[    6.246249] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.246256] hda_intel: probe_mask set to 0x1 for device 17aa:20ac
[    6.246326] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    6.286013] input: PC Speaker as /class/input/input7
[    6.671367] input: HDA Digital PCBeep as /class/input/input8
[    6.678697] modprobe used greatest stack depth: 1536 bytes left
[    6.958358] ata_piix 0000:00:1f.1: version 2.12
[    6.958400] ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
[    6.958566] ata_piix 0000:00:1f.1: setting latency timer to 64
[    6.958879] scsi3 : ata_piix
[    6.960236] scsi4 : ata_piix
[    6.964812] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x18e0 irq 14
[    6.964821] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x18e8 irq 15
[    7.131740] ata5: port disabled. ignoring.
[    7.164426] lp: driver loaded but no devices found
[    7.577657] EXT4 FS on dm-0, internal journal on dm-0:8
[    8.014466] EXT4-fs: barriers enabled
[    8.015100] kjournald2 starting: pid 3879, dev sda1:8, commit interval 5 seconds
[    8.015478] EXT4 FS on sda1, internal journal on sda1:8
[    8.015484] EXT4-fs: delayed allocation enabled
[    8.015603] EXT4-fs: mballoc enabled
[    8.015682] EXT4-fs: mounted filesystem sda1 with ordered data mode
[   10.269335] tun: Universal TUN/TAP device driver, 1.6
[   10.269340] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   11.966942] power_supply AC: uevent
[   11.966946] power_supply AC: POWER_SUPPLY_NAME=AC
[   11.966952] power_supply AC: Static prop TYPE=Mains
[   11.966955] power_supply AC: 1 dynamic props
[   11.966959] power_supply AC: prop ONLINE=0
[   11.967055] power_supply BAT0: uevent
[   11.967058] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   11.967063] power_supply BAT0: Static prop TYPE=Battery
[   11.967066] power_supply BAT0: 13 dynamic props
[   11.973155] power_supply BAT0: prop STATUS=Discharging
[   11.973160] power_supply BAT0: prop PRESENT=1
[   11.973164] power_supply BAT0: prop TECHNOLOGY=Li-ion
[   11.973169] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=14400000
[   11.973173] power_supply BAT0: prop VOLTAGE_NOW=16442000
[   11.973177] power_supply BAT0: prop CURRENT_NOW=16754000
[   11.973181] power_supply BAT0: prop POWER_NOW=16754000
[   11.973185] power_supply BAT0: prop ENERGY_FULL_DESIGN=74880000
[   11.973189] power_supply BAT0: prop ENERGY_FULL=74880000
[   11.973194] power_supply BAT0: prop ENERGY_NOW=74760000
[   11.973198] power_supply BAT0: prop MODEL_NAME=93P5030
[   11.973201] power_supply BAT0: prop MANUFACTURER=SONY
[   11.973205] power_supply BAT0: prop SERIAL_NUMBER= 6895
[   13.088134] ppdev: user-space parallel port driver
[   14.150094] pci 0000:00:02.0: power state changed by ACPI to D0
[   14.150109] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   14.150117] pci 0000:00:02.0: setting latency timer to 64
[   14.152240] mtrr: type mismatch for e0000000,10000000 old: write-back new: write-combining
[   14.152246] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   14.152289]   alloc irq_desc for 28 on cpu 0 node 0
[   14.152293]   alloc kstat_irqs on cpu 0 node 0
[   14.152311] pci 0000:00:02.0: irq 28 for MSI/MSI-X
[   14.158652] acpi device:03: registered as cooling_device2
[   14.159293] input: Video Bus as /class/input/input9
[   14.159414] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   14.159572] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.140960] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[   17.197077] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
	Subsystem: Lenovo Device 20b3
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
	Subsystem: Lenovo Device 20b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=1M]
	Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at 1800 [size=8]
	Capabilities: <access denied>
	Kernel modules: intelfb

00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
	Subsystem: Lenovo Device 20b5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Region 0: Memory at f8100000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>

00:19.0 Ethernet controller: Intel Corporation 82566MM Gigabit Network Connection (rev 03)
	Subsystem: Lenovo Device 20de
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 27
	Region 0: Memory at f8200000 (32-bit, non-prefetchable) [size=128K]
	Region 1: Memory at f8225000 (32-bit, non-prefetchable) [size=4K]
	Region 2: I/O ports at 1840 [size=32]
	Capabilities: <access denied>
	Kernel driver in use: e1000e

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 03)
	Subsystem: Lenovo Device 20aa
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 20
	Region 4: I/O ports at 1860 [size=32]
	Kernel modules: uhci-hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
	Subsystem: Lenovo Device 20aa
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at 1880 [size=32]
	Kernel modules: uhci-hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20ab
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at f8426c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel modules: ehci-hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
	Subsystem: Lenovo Device 20ac
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at f8220000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f4000000-f5ffffff
	Prefetchable memory behind bridge: 00000000f8500000-00000000f85fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: f6000000-f7ffffff
	Prefetchable memory behind bridge: 00000000f8600000-00000000f86fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
	Subsystem: Lenovo Device 20aa
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 18a0 [size=32]
	Kernel modules: uhci-hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
	Subsystem: Lenovo Device 20aa
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at 18c0 [size=32]
	Kernel modules: uhci-hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20)
	Subsystem: Lenovo Device 20ab
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin D routed to IRQ 19
	Region 0: Memory at f8427000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel modules: ehci-hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3) (prog-if 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=08, sec-latency=32
	I/O behind bridge: 00004000-00007fff
	Memory behind bridge: d4000000-d7efffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000dbffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801HBM (ICH8M-E) LPC Interface Controller (rev 03)
	Subsystem: Lenovo Device 20b6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt

00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Lenovo Device 20a6
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx+
	Latency: 0
	Interrupt: pin C routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 18e0 [size=16]
	Kernel driver in use: ata_piix
	Kernel modules: ata_piix, piix

00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) (prog-if 01)
	Subsystem: Lenovo Device 20a7
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 26
	Region 0: I/O ports at 1c30 [size=8]
	Region 1: I/O ports at 1c24 [size=4]
	Region 2: I/O ports at 1c28 [size=8]
	Region 3: I/O ports at 1c20 [size=4]
	Region 4: I/O ports at 1c00 [size=32]
	Region 5: Memory at f8426000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
	Subsystem: Lenovo Device 20a9
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f8427400 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 1c40 [size=32]
	Kernel modules: i2c-i801

03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN [Kedron] Network Connection (rev 61)
	Subsystem: Intel Corporation Device 1010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at f7f00000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel modules: iwlagn

05:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
	Subsystem: Lenovo Device 20c6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d7eff000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=05, secondary=06, subordinate=07, sec-latency=176
	Memory window 0: d8000000-dbfff000 (prefetchable)
	Memory window 1: c4000000-c7fff000 (prefetchable)
	I/O window 0: 00004000-000040ff
	I/O window 1: 00004400-000044ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001
	Kernel modules: yenta_socket

05:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04) (prog-if 10)
	Subsystem: Lenovo Device 20c7
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max)
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at d7efe800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: <access denied>
	Kernel modules: ohci1394

05:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
	Subsystem: Lenovo Device 20c8
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 11
	Region 0: Memory at d7efe400 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>
	Kernel modules: sdhci-pci


--6c2NcOVqGQ03X4Wi--
