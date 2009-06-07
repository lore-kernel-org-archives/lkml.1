Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZFGIXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZFGIXi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZFGIX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:23:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37022 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZFGIXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:23:17 -0400
Date: Sun, 7 Jun 2009 10:22:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/5] [GIP PULL] tracing/events/trace_stack: various
	fixes
Message-ID: <20090607082257.GA16761@elte.hu>
References: <20090603151724.144915858@goodmis.org> <20090605145219.GA14830@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605145219.GA14830@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, i've again triggered the ring-buffer test related lockdep 
failure i reported before:

Testing tracer sysprof: PASSED
Testing tracer function: PASSED
Testing tracer irqsoff: 
=============================================
PASSED
Testing tracer preemptoff: PASSED
Testing tracer preemptirqsoff: [ INFO: possible recursive locking detected ]
PASSED
Testing tracer branch: 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
---------------------------------------------
rb_consumer/431 is trying to acquire lock:
 (&cpu_buffer->reader_lock){......}, at: [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70

but task is already holding lock:
 (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0

Bootlog and config attached below.

	Ingo

Initializing cgroup subsys cpuset
Linux version 2.6.30-rc8-tip-01972-ge5b9078-dirty (mingo@europe) (gcc version 4.2.2) #5760 SMP PREEMPT Sun Jun 7 04:59:21 CEST 2009
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6e0000 (usable)
 BIOS-e820: 000000007f6e0000 - 000000007f6f3000 (ACPI data)
 BIOS-e820: 000000007f6f3000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x7f6e0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F700000 mask FFFF00000 uncachable
  2 base 07F800000 mask FFF800000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
Scanning 1 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000002000 (usable)
 modified: 0000000000002000 - 0000000000006000 (reserved)
 modified: 0000000000006000 - 000000000009f000 (usable)
 modified: 000000000009f000 - 00000000000a0000 (reserved)
 modified: 00000000000d2000 - 00000000000d4000 (reserved)
 modified: 00000000000dc000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000007f6e0000 (usable)
 modified: 000000007f6e0000 - 000000007f6f3000 (ACPI data)
 modified: 000000007f6f3000 - 000000007f700000 (ACPI NVS)
 modified: 000000007f700000 - 0000000080000000 (reserved)
 modified: 00000000f0000000 - 00000000f4000000 (reserved)
 modified: 00000000fec00000 - 00000000fec10000 (reserved)
 modified: 00000000fed00000 - 00000000fed00400 (reserved)
 modified: 00000000fed14000 - 00000000fed1a000 (reserved)
 modified: 00000000fed1c000 - 00000000fed90000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000ff800000 - 0000000100000000 (reserved)
initial memory mapped : 0 - 02800000
init_memory_mapping: 0000000000000000-00000000373fe000
 0000000000 - 00373fe000 page 4k
kernel direct mapping tables up to 373fe000 @ 100000-1e1000
ACPI: RSDP 000f68a0 00024 (v02 LENOVO)
ACPI: XSDT 7f6e631f 00074 (v01 LENOVO TP-79    00001020  LTP 00000000)
ACPI: FACP 7f6e6400 000F4 (v03 LENOVO TP-79    00001020 LNVO 00000001)
ACPI Warning (tbfadt-0531): 32/64X length mismatch in Gpe1Block: 0/32 [20090320]
ACPI Warning (tbfadt-0562): Optional field Gpe1Block has zero address or length: 000000000000102C/0 [20090320]
ACPI: DSDT 7f6e65e7 0C765 (v01 LENOVO TP-79    00001020 MSFT 0100000E)
ACPI: FACS 7f6f4000 00040
ACPI: SSDT 7f6e65b4 00033 (v01 LENOVO TP-79    00001020 MSFT 0100000E)
ACPI: ECDT 7f6f2d4c 00052 (v01 LENOVO TP-79    00001020 LNVO 00000001)
ACPI: TCPA 7f6f2d9e 00032 (v02 LENOVO TP-79    00001020 LNVO 00000001)
ACPI: APIC 7f6f2dd0 00068 (v01 LENOVO TP-79    00001020 LNVO 00000001)
ACPI: MCFG 7f6f2e38 0003E (v01 LENOVO TP-79    00001020 LNVO 00000001)
ACPI: HPET 7f6f2e76 00038 (v01 LENOVO TP-79    00001020 LNVO 00000001)
ACPI: BOOT 7f6f2fd8 00028 (v01 LENOVO TP-79    00001020  LTP 00000001)
ACPI: SSDT 7f6e58da 00507 (v01 LENOVO TP-79    00001020 INTL 20050513)
ACPI: SSDT 7f6e5702 001D8 (v01 LENOVO TP-79    00001020 INTL 20050513)
ACPI: Local APIC address 0xfee00000
1154MB HIGHMEM available.
883MB LOWMEM available.
  mapped low ram: 0 - 373fe000
  low ram: 0 - 373fe000
  node 0 low ram: 00000000 - 373fe000
  node 0 bootmap 00007000 - 0000de80
(8 early reservations) ==> bootmem [0000000000 - 00373fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0001000000 - 0002293358]    TEXT DATA BSS ==> [0001000000 - 0002293358]
  #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #5 [0002294000 - 000229e138]              BRK ==> [0002294000 - 000229e138]
  #6 [0000100000 - 00001d3000]          PGTABLE ==> [0000100000 - 00001d3000]
  #7 [0000007000 - 000000e000]          BOOTMAP ==> [0000007000 - 000000e000]
found SMP MP-table at [c00f68e0] f68e0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000373fe
  HighMem  0x000373fe -> 0x0007f6e0
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x00000002
    0: 0x00000006 -> 0x0000009f
    0: 0x00000100 -> 0x0007f6e0
On node 0 totalpages: 521851
  DMA zone: 52 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3943 pages, LIFO batch:0
  Normal zone: 2821 pages used for memmap
  Normal zone: 219385 pages, LIFO batch:31
  HighMem zone: 3754 pages used for memmap
  HighMem zone: 291896 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
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
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 0000000000002000 - 0000000000006000
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 16 pages at c3cbd000, static data 43836 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 515224
Kernel command line: 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:1280
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1828.800 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     16384
... MAX_LOCKDEP_CHAINS:      32768
... CHAINHASH_SIZE:          16384
 memory used by lock dependency info: 3487 kB
 per task-struct memory footprint: 1152 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing HighMem for node 0 (000373fe:0007f6e0)
Memory: 2038932k/2087808k available (7421k kernel code, 47664k reserved, 4312k data, 524k init, 1182600k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
      .init : 0xc1b7d000 - 0xc1c00000   ( 524 kB)
      .data : 0xc173f68e - 0xc1b757b8   (4312 kB)
      .text : 0xc1000000 - 0xc173f68e   (7421 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.60 BogoMIPS (lpj=1828800)
Security Framework initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090320
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Testing tracer nop: PASSED
lockdep: fixing up alternatives.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.36 BogoMIPS (lpj=1828680)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 579975 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (7314.96 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
device: 'platform': device_add
PM: Adding info for No Bus:platform
khelper used greatest stack depth: 6816 bytes left
bus: 'platform': registered
Registering sysdev class 'cpu'
khelper used greatest stack depth: 6668 bytes left
net_namespace: 968 bytes
Registering sysdev class 'lapic'
Registering sys device of class 'lapic'
Registering sys device 'lapic0'
Booting paravirtualized kernel on bare hardware
Time:  3:00:32  Date: 06/07/09
bus: 'virtio': registered
NET: Registered protocol family 16
device class 'bdi': registering
device class 'gpio': registering
device class 'pci_bus': registering
bus: 'pci': registered
device class 'backlight': registering
device class 'tty': registering
device class 'vtconsole': registering
device: 'vtcon0': device_add
PM: Adding info for No Bus:vtcon0
bus: 'i2c': registered
device class 'i2c-adapter': registering
bus: 'i2c': add driver dummy
i2c-core: driver [dummy] registered
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xfd84b, last bus=24
Registering sys device of class 'cpu'
Registering sys device 'cpu0'
Registering sys device of class 'cpu'
Registering sys device 'cpu1'
device: 'default': device_add
PM: Adding info for No Bus:default
bio: create slab <bio-0> at 0
device class 'block': registering
bus: 'i2c': add driver max732x
i2c-core: driver [max732x] registered
bus: 'i2c': add driver pca953x
i2c-core: driver [pca953x] registered
bus: 'platform': add driver twl4030_gpio
device class 'graphics': registering
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
bus: 'acpi': registered
device: 'LNXSYSTM:00': device_add
bus: 'acpi': add device LNXSYSTM:00
PM: Adding info for acpi:LNXSYSTM:00
device: 'LNXPWRBN:00': device_add
bus: 'acpi': add device LNXPWRBN:00
PM: Adding info for acpi:LNXPWRBN:00
device: 'ACPI_CPU:00': device_add
bus: 'acpi': add device ACPI_CPU:00
PM: Adding info for acpi:ACPI_CPU:00
device: 'ACPI_CPU:01': device_add
bus: 'acpi': add device ACPI_CPU:01
PM: Adding info for acpi:ACPI_CPU:01
device: 'device:00': device_add
bus: 'acpi': add device device:00
PM: Adding info for acpi:device:00
device: 'device:00': dev_uevent: bus uevent() returned -12
device: 'PNP0C0F:00': device_add
bus: 'acpi': add device PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:00
device: 'PNP0C0F:01': device_add
bus: 'acpi': add device PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:01
device: 'PNP0C0F:02': device_add
bus: 'acpi': add device PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:02
device: 'PNP0C0F:03': device_add
bus: 'acpi': add device PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:03
device: 'PNP0C0F:04': device_add
bus: 'acpi': add device PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:04
device: 'PNP0C0F:05': device_add
bus: 'acpi': add device PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:05
device: 'PNP0C0F:06': device_add
bus: 'acpi': add device PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:06
device: 'PNP0C0F:07': device_add
bus: 'acpi': add device PNP0C0F:07
PM: Adding info for acpi:PNP0C0F:07
device: 'PNP0C01:00': device_add
bus: 'acpi': add device PNP0C01:00
PM: Adding info for acpi:PNP0C01:00
device: 'PNP0C0D:00': device_add
bus: 'acpi': add device PNP0C0D:00
PM: Adding info for acpi:PNP0C0D:00
device: 'PNP0C0E:00': device_add
bus: 'acpi': add device PNP0C0E:00
PM: Adding info for acpi:PNP0C0E:00
device: 'PNP0A08:00': device_add
bus: 'acpi': add device PNP0A08:00
PM: Adding info for acpi:PNP0A08:00
device: 'device:01': device_add
bus: 'acpi': add device device:01
PM: Adding info for acpi:device:01
device: 'device:01': dev_uevent: bus uevent() returned -12
device: 'PNP0C02:00': device_add
bus: 'acpi': add device PNP0C02:00
PM: Adding info for acpi:PNP0C02:00
device: 'PNP0000:00': device_add
bus: 'acpi': add device PNP0000:00
PM: Adding info for acpi:PNP0000:00
device: 'PNP0100:00': device_add
bus: 'acpi': add device PNP0100:00
PM: Adding info for acpi:PNP0100:00
device: 'PNP0103:00': device_add
bus: 'acpi': add device PNP0103:00
PM: Adding info for acpi:PNP0103:00
device: 'PNP0200:00': device_add
bus: 'acpi': add device PNP0200:00
PM: Adding info for acpi:PNP0200:00
device: 'PNP0800:00': device_add
bus: 'acpi': add device PNP0800:00
PM: Adding info for acpi:PNP0800:00
device: 'PNP0C04:00': device_add
bus: 'acpi': add device PNP0C04:00
PM: Adding info for acpi:PNP0C04:00
device: 'PNP0B00:00': device_add
bus: 'acpi': add device PNP0B00:00
PM: Adding info for acpi:PNP0B00:00
device: 'PNP0303:00': device_add
bus: 'acpi': add device PNP0303:00
PM: Adding info for acpi:PNP0303:00
device: 'IBM0057:00': device_add
bus: 'acpi': add device IBM0057:00
PM: Adding info for acpi:IBM0057:00
device: 'IBM0071:00': device_add
bus: 'acpi': add device IBM0071:00
PM: Adding info for acpi:IBM0071:00
device: 'PNP0C09:00': device_add
bus: 'acpi': add device PNP0C09:00
PM: Adding info for acpi:PNP0C09:00
device: 'LNXPOWER:00': device_add
bus: 'acpi': add device LNXPOWER:00
PM: Adding info for acpi:LNXPOWER:00
device: 'PNP0C0A:00': device_add
bus: 'acpi': add device PNP0C0A:00
PM: Adding info for acpi:PNP0C0A:00
device: 'ACPI0003:00': device_add
bus: 'acpi': add device ACPI0003:00
PM: Adding info for acpi:ACPI0003:00
device: 'IBM0068:00': device_add
bus: 'acpi': add device IBM0068:00
PM: Adding info for acpi:IBM0068:00
device: 'device:02': device_add
bus: 'acpi': add device device:02
PM: Adding info for acpi:device:02
device: 'device:02': dev_uevent: bus uevent() returned -12
device: 'device:03': device_add
bus: 'acpi': add device device:03
PM: Adding info for acpi:device:03
device: 'device:03': dev_uevent: bus uevent() returned -12
device: 'device:04': device_add
bus: 'acpi': add device device:04
PM: Adding info for acpi:device:04
device: 'device:04': dev_uevent: bus uevent() returned -12
device: 'device:05': device_add
bus: 'acpi': add device device:05
PM: Adding info for acpi:device:05
device: 'device:05': dev_uevent: bus uevent() returned -12
device: 'device:06': device_add
bus: 'acpi': add device device:06
PM: Adding info for acpi:device:06
device: 'device:06': dev_uevent: bus uevent() returned -12
device: 'device:07': device_add
bus: 'acpi': add device device:07
PM: Adding info for acpi:device:07
device: 'device:07': dev_uevent: bus uevent() returned -12
device: 'device:08': device_add
bus: 'acpi': add device device:08
PM: Adding info for acpi:device:08
device: 'device:08': dev_uevent: bus uevent() returned -12
device: 'device:09': device_add
bus: 'acpi': add device device:09
PM: Adding info for acpi:device:09
device: 'device:09': dev_uevent: bus uevent() returned -12
device: 'device:0a': device_add
bus: 'acpi': add device device:0a
PM: Adding info for acpi:device:0a
device: 'device:0a': dev_uevent: bus uevent() returned -12
device: 'device:0b': device_add
bus: 'acpi': add device device:0b
PM: Adding info for acpi:device:0b
device: 'device:0b': dev_uevent: bus uevent() returned -12
device: 'device:0c': device_add
bus: 'acpi': add device device:0c
PM: Adding info for acpi:device:0c
device: 'device:0c': dev_uevent: bus uevent() returned -12
device: 'device:0d': device_add
bus: 'acpi': add device device:0d
PM: Adding info for acpi:device:0d
device: 'device:0d': dev_uevent: bus uevent() returned -12
device: 'device:0e': device_add
bus: 'acpi': add device device:0e
PM: Adding info for acpi:device:0e
device: 'device:0e': dev_uevent: bus uevent() returned -12
device: 'device:0f': device_add
bus: 'acpi': add device device:0f
PM: Adding info for acpi:device:0f
device: 'device:0f': dev_uevent: bus uevent() returned -12
device: 'device:10': device_add
bus: 'acpi': add device device:10
PM: Adding info for acpi:device:10
device: 'device:10': dev_uevent: bus uevent() returned -12
device: 'device:11': device_add
bus: 'acpi': add device device:11
PM: Adding info for acpi:device:11
device: 'device:11': dev_uevent: bus uevent() returned -12
device: 'device:12': device_add
bus: 'acpi': add device device:12
PM: Adding info for acpi:device:12
device: 'device:12': dev_uevent: bus uevent() returned -12
device: 'device:13': device_add
bus: 'acpi': add device device:13
PM: Adding info for acpi:device:13
device: 'device:13': dev_uevent: bus uevent() returned -12
device: 'device:14': device_add
bus: 'acpi': add device device:14
PM: Adding info for acpi:device:14
device: 'device:14': dev_uevent: bus uevent() returned -12
device: 'device:15': device_add
bus: 'acpi': add device device:15
PM: Adding info for acpi:device:15
device: 'device:16': device_add
bus: 'acpi': add device device:16
PM: Adding info for acpi:device:16
device: 'device:16': dev_uevent: bus uevent() returned -12
device: 'device:17': device_add
bus: 'acpi': add device device:17
PM: Adding info for acpi:device:17
device: 'device:17': dev_uevent: bus uevent() returned -12
device: 'device:18': device_add
bus: 'acpi': add device device:18
PM: Adding info for acpi:device:18
device: 'device:18': dev_uevent: bus uevent() returned -12
device: 'device:19': device_add
bus: 'acpi': add device device:19
PM: Adding info for acpi:device:19
device: 'device:19': dev_uevent: bus uevent() returned -12
device: 'device:1a': device_add
bus: 'acpi': add device device:1a
PM: Adding info for acpi:device:1a
device: 'device:1a': dev_uevent: bus uevent() returned -12
device: 'device:1b': device_add
bus: 'acpi': add device device:1b
PM: Adding info for acpi:device:1b
device: 'device:1b': dev_uevent: bus uevent() returned -12
device: 'device:1c': device_add
bus: 'acpi': add device device:1c
PM: Adding info for acpi:device:1c
device: 'device:1c': dev_uevent: bus uevent() returned -12
device: 'device:1d': device_add
bus: 'acpi': add device device:1d
PM: Adding info for acpi:device:1d
device: 'device:1d': dev_uevent: bus uevent() returned -12
device: 'device:1e': device_add
bus: 'acpi': add device device:1e
PM: Adding info for acpi:device:1e
device: 'device:1e': dev_uevent: bus uevent() returned -12
device: 'device:1f': device_add
bus: 'acpi': add device device:1f
PM: Adding info for acpi:device:1f
device: 'device:1f': dev_uevent: bus uevent() returned -12
device: 'device:20': device_add
bus: 'acpi': add device device:20
PM: Adding info for acpi:device:20
device: 'device:20': dev_uevent: bus uevent() returned -12
device: 'device:21': device_add
bus: 'acpi': add device device:21
PM: Adding info for acpi:device:21
device: 'device:21': dev_uevent: bus uevent() returned -12
device: 'device:22': device_add
bus: 'acpi': add device device:22
PM: Adding info for acpi:device:22
device: 'device:22': dev_uevent: bus uevent() returned -12
device: 'device:23': device_add
bus: 'acpi': add device device:23
PM: Adding info for acpi:device:23
device: 'device:23': dev_uevent: bus uevent() returned -12
device: 'device:24': device_add
bus: 'acpi': add device device:24
PM: Adding info for acpi:device:24
device: 'device:24': dev_uevent: bus uevent() returned -12
device: 'device:25': device_add
bus: 'acpi': add device device:25
PM: Adding info for acpi:device:25
device: 'device:25': dev_uevent: bus uevent() returned -12
device: 'LNXTHERM:00': device_add
bus: 'acpi': add device LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:00
device: 'LNXTHERM:01': device_add
bus: 'acpi': add device LNXTHERM:01
PM: Adding info for acpi:LNXTHERM:01
device: 'LNXTHERM:02': device_add
bus: 'acpi': add device LNXTHERM:02
PM: Adding info for acpi:LNXTHERM:02
bus: 'acpi': add driver ec
bus: 'acpi': driver_probe_device: matched device PNP0C09:00 with driver ec
bus: 'acpi': really_probe: probing driver ec with device PNP0C09:00
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
driver: 'PNP0C09:00': driver_bound: bound to device 'ec'
bus: 'acpi': really_probe: bound device PNP0C09:00 to driver ec
bus: 'acpi': add driver power
bus: 'acpi': driver_probe_device: matched device LNXPOWER:00 with driver power
bus: 'acpi': really_probe: probing driver power with device LNXPOWER:00
ACPI: Power Resource [PUBS] (on)
driver: 'LNXPOWER:00': driver_bound: bound to device 'power'
bus: 'acpi': really_probe: bound device LNXPOWER:00 to driver power
Registering platform device 'dock.0'. Parent at platform
device: 'dock.0': device_add
bus: 'platform': add device dock.0
PM: Adding info for platform:dock.0
Registering platform device 'dock.1'. Parent at platform
device: 'dock.1': device_add
bus: 'platform': add device dock.1
PM: Adding info for platform:dock.1
Registering platform device 'dock.2'. Parent at platform
device: 'dock.2': device_add
bus: 'platform': add device dock.2
PM: Adding info for platform:dock.2
ACPI: ACPI Dock Station Driver: 3 docks/bays found
bus: 'acpi': add driver pci_root
bus: 'acpi': driver_probe_device: matched device PNP0A08:00 with driver pci_root
bus: 'acpi': really_probe: probing driver pci_root with device PNP0A08:00
ACPI: PCI Root Bridge [PCI0] (0000:00)
device: 'pci0000:00': device_add
PM: Adding info for No Bus:pci0000:00
device: '0000:00': device_add
PM: Adding info for No Bus:0000:00
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [8086:27a0] class 000600 header type 00
pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:02.0: found [8086:27a2] class 000300 header type 00
pci 0000:00:02.0: reg 10 32bit mmio: [0xee100000-0xee17ffff]
pci 0000:00:02.0: reg 14 io port: [0x1800-0x1807]
pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xee200000-0xee23ffff]
pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:02.1: found [8086:27a6] class 000380 header type 00
pci 0000:00:02.1: reg 10 32bit mmio: [0xee180000-0xee1fffff]
pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:02.1: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1b.0: found [8086:27d8] class 000403 header type 00
pci 0000:00:1b.0: reg 10 64bit mmio: [0xee240000-0xee243fff]
pci 0000:00:1b.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: found [8086:27d0] class 000604 header type 01
pci 0000:00:1c.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: found [8086:27d2] class 000604 header type 01
pci 0000:00:1c.1: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1c.1: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: found [8086:27d4] class 000604 header type 01
pci 0000:00:1c.2: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1c.2: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: found [8086:27d6] class 000604 header type 01
pci 0000:00:1c.3: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: found [8086:27c8] class 000c03 header type 00
pci 0000:00:1d.0: reg 20 io port: [0x1820-0x183f]
pci 0000:00:1d.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.1: found [8086:27c9] class 000c03 header type 00
pci 0000:00:1d.1: reg 20 io port: [0x1840-0x185f]
pci 0000:00:1d.1: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.2: found [8086:27ca] class 000c03 header type 00
pci 0000:00:1d.2: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1d.2: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.3: found [8086:27cb] class 000c03 header type 00
pci 0000:00:1d.3: reg 20 io port: [0x1880-0x189f]
pci 0000:00:1d.3: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1d.3: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.7: found [8086:27cc] class 000c03 header type 00
pci 0000:00:1d.7: reg 10 32bit mmio: [0xee444000-0xee4443ff]
pci 0000:00:1d.7: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: found [8086:2448] class 000604 header type 01
pci 0000:00:1e.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.0: found [8086:27b9] class 000601 header type 00
pci 0000:00:1f.0: calling ich_force_enable_hpet+0x0/0x1b0
pci 0000:00:1f.0: calling quirk_ich7_lpc+0x0/0x60
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 1600 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 15e0 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 1680 (mask 001f)
pci 0000:00:1f.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.1: found [8086:27df] class 000101 header type 00
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
pci 0000:00:1f.1: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.2: found [8086:27c5] class 000106 header type 00
pci 0000:00:1f.2: reg 10 io port: [0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14 io port: [0x18c4-0x18c7]
pci 0000:00:1f.2: reg 18 io port: [0x18c8-0x18cf]
pci 0000:00:1f.2: reg 1c io port: [0x18c0-0x18c3]
pci 0000:00:1f.2: reg 20 io port: [0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xee444400-0xee4447ff]
pci 0000:00:1f.2: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: found [8086:27da] class 000c05 header type 00
pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
pci 0000:00:1f.3: calling quirk_resource_alignment+0x0/0x190
pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x40
PCI: Fixups for bus 0000:00
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
pci 0000:02:00.0: found [8086:109a] class 000200 header type 00
pci 0000:02:00.0: reg 10 32bit mmio: [0xee000000-0xee01ffff]
pci 0000:02:00.0: reg 18 io port: [0x2000-0x201f]
pci 0000:02:00.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:02:00.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
PCI: Fixups for bus 0000:02
pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xee000000-0xee0fffff]
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:1c.1: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
pci 0000:03:00.0: found [8086:4227] class 000280 header type 00
pci 0000:03:00.0: reg 10 32bit mmio: [0xedf00000-0xedf00fff]
pci 0000:03:00.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:03:00.0: calling pci_fixup_transparent_bridge+0x0/0x40
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
PCI: Fixups for bus 0000:03
pci 0000:00:1c.1: bridge io port: [0x3000-0x4fff]
pci 0000:00:1c.1: bridge 32bit mmio: [0xec000000-0xedffffff]
pci 0000:00:1c.1: bridge 64bit mmio pref: [0xe4000000-0xe40fffff]
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:1c.2: scanning behind bridge, config 0b0400, pass 0
PCI: Scanning bus 0000:04
PCI: Fixups for bus 0000:04
pci 0000:00:1c.2: bridge io port: [0x5000-0x6fff]
pci 0000:00:1c.2: bridge 32bit mmio: [0xe8000000-0xe9ffffff]
pci 0000:00:1c.2: bridge 64bit mmio pref: [0xe4100000-0xe41fffff]
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:1c.3: scanning behind bridge, config 130c00, pass 0
PCI: Scanning bus 0000:0c
PCI: Fixups for bus 0000:0c
pci 0000:00:1c.3: bridge io port: [0x7000-0x8fff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xea000000-0xebffffff]
pci 0000:00:1c.3: bridge 64bit mmio pref: [0xe4200000-0xe42fffff]
PCI: Bus scan for 0000:0c returning with max=0c
pci 0000:00:1e.0: scanning behind bridge, config 181500, pass 0
PCI: Scanning bus 0000:15
pci 0000:15:00.0: found [104c:ac56] class 000607 header type 02
pci 0000:15:00.0: reg 10 32bit mmio: [0xe4300000-0xe4300fff]
pci 0000:15:00.0: calling quirk_resource_alignment+0x0/0x190
pci 0000:15:00.0: supports D1 D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
PCI: Fixups for bus 0000:15
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x9000-0xcfff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xe4300000-0xe7ffffff]
pci 0000:00:1e.0: bridge 64bit mmio pref: [0xe0000000-0xe3ffffff]
pci 0000:15:00.0: scanning behind bridge, config 181615, pass 0
pci 0000:15:00.0: scanning behind bridge, config 181615, pass 1
PCI: Bus scan for 0000:15 returning with max=17
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:1c.1: scanning behind bridge, config 030300, pass 1
pci 0000:00:1c.2: scanning behind bridge, config 0b0400, pass 1
pci 0000:00:1c.3: scanning behind bridge, config 130c00, pass 1
pci 0000:00:1e.0: scanning behind bridge, config 181500, pass 1
PCI: Bus scan for 0000:00 returning with max=18
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
device: '0000:00:00.0': device_add
bus: 'pci': add device 0000:00:00.0
PM: Adding info for pci:0000:00:00.0
device: '0000:00:02.0': device_add
bus: 'pci': add device 0000:00:02.0
PM: Adding info for pci:0000:00:02.0
device: '0000:00:02.1': device_add
bus: 'pci': add device 0000:00:02.1
PM: Adding info for pci:0000:00:02.1
device: '0000:00:1b.0': device_add
bus: 'pci': add device 0000:00:1b.0
PM: Adding info for pci:0000:00:1b.0
device: '0000:00:1c.0': device_add
bus: 'pci': add device 0000:00:1c.0
PM: Adding info for pci:0000:00:1c.0
device: '0000:00:1c.1': device_add
bus: 'pci': add device 0000:00:1c.1
PM: Adding info for pci:0000:00:1c.1
device: '0000:00:1c.2': device_add
bus: 'pci': add device 0000:00:1c.2
PM: Adding info for pci:0000:00:1c.2
device: '0000:00:1c.3': device_add
bus: 'pci': add device 0000:00:1c.3
PM: Adding info for pci:0000:00:1c.3
device: '0000:00:1d.0': device_add
bus: 'pci': add device 0000:00:1d.0
PM: Adding info for pci:0000:00:1d.0
device: '0000:00:1d.1': device_add
bus: 'pci': add device 0000:00:1d.1
PM: Adding info for pci:0000:00:1d.1
device: '0000:00:1d.2': device_add
bus: 'pci': add device 0000:00:1d.2
PM: Adding info for pci:0000:00:1d.2
device: '0000:00:1d.3': device_add
bus: 'pci': add device 0000:00:1d.3
PM: Adding info for pci:0000:00:1d.3
device: '0000:00:1d.7': device_add
bus: 'pci': add device 0000:00:1d.7
PM: Adding info for pci:0000:00:1d.7
device: '0000:00:1e.0': device_add
bus: 'pci': add device 0000:00:1e.0
PM: Adding info for pci:0000:00:1e.0
device: '0000:00:1f.0': device_add
bus: 'pci': add device 0000:00:1f.0
PM: Adding info for pci:0000:00:1f.0
device: '0000:00:1f.1': device_add
bus: 'pci': add device 0000:00:1f.1
PM: Adding info for pci:0000:00:1f.1
device: '0000:00:1f.2': device_add
bus: 'pci': add device 0000:00:1f.2
PM: Adding info for pci:0000:00:1f.2
device: '0000:00:1f.3': device_add
bus: 'pci': add device 0000:00:1f.3
PM: Adding info for pci:0000:00:1f.3
device: '0000:02:00.0': device_add
bus: 'pci': add device 0000:02:00.0
PM: Adding info for pci:0000:02:00.0
device: '0000:02': device_add
PM: Adding info for No Bus:0000:02
device: '0000:03:00.0': device_add
bus: 'pci': add device 0000:03:00.0
PM: Adding info for pci:0000:03:00.0
device: '0000:03': device_add
PM: Adding info for No Bus:0000:03
device: '0000:04': device_add
PM: Adding info for No Bus:0000:04
device: '0000:0c': device_add
PM: Adding info for No Bus:0000:0c
device: '0000:15:00.0': device_add
bus: 'pci': add device 0000:15:00.0
PM: Adding info for pci:0000:15:00.0
device: '0000:16': device_add
PM: Adding info for No Bus:0000:16
device: '0000:15': device_add
PM: Adding info for No Bus:0000:15
driver: 'PNP0A08:00': driver_bound: bound to device 'pci_root'
bus: 'acpi': really_probe: bound device PNP0A08:00 to driver pci_root
bus: 'acpi': add driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:00
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:01
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:02
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:03
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:04
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:05 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:05
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:05': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:05 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:06 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:06
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:06': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:06 to driver pci_link
bus: 'acpi': driver_probe_device: matched device PNP0C0F:07 with driver pci_link
bus: 'acpi': really_probe: probing driver pci_link with device PNP0C0F:07
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
driver: 'PNP0C0F:07': driver_bound: bound to device 'pci_link'
bus: 'acpi': really_probe: bound device PNP0C0F:07 to driver pci_link
bus: 'pnp': registered
device class 'misc': registering
bus: 'i2c': add driver twl4030
i2c-core: driver [twl4030] registered
device class 'scsi_host': registering
bus: 'scsi': registered
device class 'scsi_device': registering
SCSI subsystem initialized
libata version 3.00 loaded.
device class 'mdio_bus': registering
bus: 'mdio_bus': registered
bus: 'mdio_bus': add driver Generic PHY
bus: 'usb': registered
device class 'usb_host': registering
bus: 'usb': add driver usbfs
usbcore: registered new interface driver usbfs
device class 'usb_device': registering
bus: 'usb': add driver hub
usbcore: registered new interface driver hub
bus: 'usb': add driver usb
usbcore: registered new device driver usb
bus: 'serio': registered
bus: 'gameport': registered
device class 'input': registering
device class 'hwmon': registering
device class 'leds': registering
PCI: Using ACPI for IRQ routing
device class 'net': registering
device: 'lo': device_add
PM: Adding info for No Bus:lo
NET: Registered protocol family 23
Bluetooth: Core ver 2.15
device class 'bluetooth': registering
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
NET: Registered protocol family 8
NET: Registered protocol family 20
device class 'atm': registering
device class 'ieee80211': registering
Registering platform device 'regulatory.0'. Parent at platform
device: 'regulatory.0': device_add
bus: 'platform': add device regulatory.0
PM: Adding info for platform:regulatory.0
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
device class 'rfkill': registering
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
Warning: could not register annotated branches stats
pnp: PnP ACPI init
device: 'pnp0': device_add
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
device: '00:00': device_add
bus: 'pnp': add device 00:00
PM: Adding info for pnp:00:00
device: '00:01': device_add
bus: 'pnp': add device 00:01
PM: Adding info for pnp:00:01
device: '00:02': device_add
bus: 'pnp': add device 00:02
PM: Adding info for pnp:00:02
device: '00:03': device_add
bus: 'pnp': add device 00:03
PM: Adding info for pnp:00:03
device: '00:04': device_add
bus: 'pnp': add device 00:04
PM: Adding info for pnp:00:04
device: '00:05': device_add
bus: 'pnp': add device 00:05
PM: Adding info for pnp:00:05
device: '00:06': device_add
bus: 'pnp': add device 00:06
PM: Adding info for pnp:00:06
device: '00:07': device_add
bus: 'pnp': add device 00:07
PM: Adding info for pnp:00:07
device: '00:08': device_add
bus: 'pnp': add device 00:08
PM: Adding info for pnp:00:08
device: '00:09': device_add
bus: 'pnp': add device 00:09
PM: Adding info for pnp:00:09
device: '00:0a': device_add
bus: 'pnp': add device 00:0a
PM: Adding info for pnp:00:0a
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
bus: 'pnp': add driver system
bus: 'pnp': driver_probe_device: matched device 00:00 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:00
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:00: iomem range 0xcc000-0xcffff could not be reserved
system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
system 00:00: iomem range 0xdc000-0xdffff could not be reserved
system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
system 00:00: iomem range 0xe8000-0xebfff could not be reserved
system 00:00: iomem range 0xec000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved
driver: '00:00': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:00 to driver system
bus: 'pnp': driver_probe_device: matched device 00:02 with driver system
bus: 'pnp': really_probe: probing driver system with device 00:02
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x165f could not be reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
driver: '00:02': driver_bound: bound to device 'system'
bus: 'pnp': really_probe: bound device 00:02 to driver system
device class 'mem': registering
device: 'mem': device_add
PM: Adding info for No Bus:mem
device: 'null': device_add
PM: Adding info for No Bus:null
device: 'port': device_add
PM: Adding info for No Bus:port
device: 'zero': device_add
PM: Adding info for No Bus:zero
device: 'full': device_add
PM: Adding info for No Bus:full
device: 'random': device_add
PM: Adding info for No Bus:random
device: 'urandom': device_add
PM: Adding info for No Bus:urandom
device: 'kmsg': device_add
PM: Adding info for No Bus:kmsg
device: 'oldmem': device_add
PM: Adding info for No Bus:oldmem
device class 'firmware': registering
bus: 'ieee1394': registered
device class 'ieee1394_host': registering
device class 'ieee1394_protocol': registering
device class 'ieee1394_node': registering
device class 'ieee1394': registering
bus: 'ieee1394': add driver nodemgr
bus: 'ssb': registered
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xee000000-0xee0fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
pci 0000:00:1c.1:   MEM window: 0xec000000-0xedffffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000e4000000-0x000000e40fffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.2:   IO window: 0x5000-0x6fff
pci 0000:00:1c.2:   MEM window: 0xe8000000-0xe9ffffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000e4100000-0x000000e41fffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
pci 0000:00:1c.3:   IO window: 0x7000-0x8fff
pci 0000:00:1c.3:   MEM window: 0xea000000-0xebffffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000e4200000-0x000000e42fffff
pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
pci 0000:15:00.0:   IO window: 0x009000-0x0090ff
pci 0000:15:00.0:   IO window: 0x009400-0x0094ff
pci 0000:15:00.0:   PREFETCH window: 0xe0000000-0xe3ffffff
pci 0000:15:00.0:   MEM window: 0x80000000-0x83ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
pci 0000:00:1e.0:   IO window: 0x9000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e3ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:02: resource 1 mem: [0xee000000-0xee0fffff]
pci_bus 0000:03: resource 0 io:  [0x3000-0x4fff]
pci_bus 0000:03: resource 1 mem: [0xec000000-0xedffffff]
pci_bus 0000:03: resource 2 pref mem [0xe4000000-0xe40fffff]
pci_bus 0000:04: resource 0 io:  [0x5000-0x6fff]
pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe9ffffff]
pci_bus 0000:04: resource 2 pref mem [0xe4100000-0xe41fffff]
pci_bus 0000:0c: resource 0 io:  [0x7000-0x8fff]
pci_bus 0000:0c: resource 1 mem: [0xea000000-0xebffffff]
pci_bus 0000:0c: resource 2 pref mem [0xe4200000-0xe42fffff]
pci_bus 0000:15: resource 0 io:  [0x9000-0xcfff]
pci_bus 0000:15: resource 1 mem: [0xe4300000-0xe7ffffff]
pci_bus 0000:15: resource 2 pref mem [0xe0000000-0xe3ffffff]
pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:16: resource 0 io:  [0x9000-0x90ff]
pci_bus 0000:16: resource 1 io:  [0x9400-0x94ff]
pci_bus 0000:16: resource 2 pref mem [0xe0000000-0xe3ffffff]
pci_bus 0000:16: resource 3 mem: [0x80000000-0x83ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Registering sysdev class 'i8259'
Registering sys device of class 'i8259'
Registering sys device 'i82590'
Simple Boot Flag at 0x35 set to 0x1
Registering sysdev class 'i8237'
Registering sys device of class 'i8237'
Registering sys device 'i82370'
cpu0(2) debug files 121
cpu1(2) debug files 121
Registering sysdev class 'machinecheck'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck0'
Registering sys device of class 'machinecheck'
Registering sys device 'machinecheck1'
device: 'mcelog': device_add
PM: Adding info for No Bus:mcelog
Machine check injector initialized
device class 'msr': registering
device: 'msr0': device_add
PM: Adding info for No Bus:msr0
device: 'msr1': device_add
PM: Adding info for No Bus:msr1
Registering sysdev class 'ioapic'
Registering sys device of class 'ioapic'
Registering sys device 'ioapic0'
Registering platform device 'pcspkr'. Parent at platform
device: 'pcspkr': device_add
bus: 'platform': add device pcspkr
PM: Adding info for platform:pcspkr
scx200: NatSemi SCx200 Driver
bus: 'pci': add driver scx200
Scanning for low memory corruption every 60 seconds
Registering sysdev class 'timekeeping'
Registering sys device of class 'timekeeping'
Registering sys device 'timekeeping0'
Registering sysdev class 'clocksource'
Registering sys device of class 'clocksource'
Registering sys device 'clocksource0'
Registering sysdev class 'rttest'
Registering sys device of class 'rttest'
Registering sys device 'rttest0'
Registering sys device of class 'rttest'
Registering sys device 'rttest1'
Registering sys device of class 'rttest'
Registering sys device 'rttest2'
Registering sys device of class 'rttest'
Registering sys device 'rttest3'
Registering sys device of class 'rttest'
Registering sys device 'rttest4'
Registering sys device of class 'rttest'
Registering sys device 'rttest5'
Registering sys device of class 'rttest'
Registering sys device 'rttest6'
Registering sys device of class 'rttest'
Registering sys device 'rttest7'
Initializing RT-Tester: OK
device: 'snapshot': device_add
PM: Adding info for No Bus:snapshot
audit: initializing netlink socket (disabled)
type=2000 audit(1244343631.524:1): initialized
Kprobe smoke test started
Kprobe smoke test passed successfully
Testing tracer sched_switch: <6>Starting ring buffer hammer
PASSED
Testing tracer sysprof: PASSED
Testing tracer function: PASSED
Testing tracer irqsoff: 
=============================================
PASSED
Testing tracer preemptoff: PASSED
Testing tracer preemptirqsoff: [ INFO: possible recursive locking detected ]
PASSED
Testing tracer branch: 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
---------------------------------------------
rb_consumer/431 is trying to acquire lock:
 (&cpu_buffer->reader_lock){......}, at: [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70

but task is already holding lock:
 (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0

other info that might help us debug this:
1 lock held by rb_consumer/431:
 #0:  (&cpu_buffer->reader_lock){......}, at: [<c10a019e>] ring_buffer_consume+0x7e/0xc0

stack backtrace:
Pid: 431, comm: rb_consumer Not tainted 2.6.30-rc8-tip-01972-ge5b9078-dirty #5760
Call Trace:
 [<c1070940>] validate_chain+0xa20/0x1000
 [<c1071240>] __lock_acquire+0x320/0x5f0
 [<c107159f>] lock_acquire+0x8f/0x120
 [<c109eef7>] ? ring_buffer_reset_cpu+0x37/0x70
 [<c1739c76>] _spin_lock_irqsave+0x56/0x70
 [<c109eef7>] ? ring_buffer_reset_cpu+0x37/0x70
 [<c109eef7>] ring_buffer_reset_cpu+0x37/0x70
 [<c10a596e>] tracing_reset+0x3e/0x80
 [<c109f4df>] ? rb_get_reader_page+0x11f/0x180
 [<c106c90b>] ? trace_hardirqs_off+0xb/0x10
 [<c10aa97f>] time_hardirqs_off+0xbf/0x110
 [<c109f4df>] ? rb_get_reader_page+0x11f/0x180
 [<c106c830>] trace_hardirqs_off_caller+0x20/0xf0
 [<c106c90b>] trace_hardirqs_off+0xb/0x10
 [<c109f4df>] rb_get_reader_page+0x11f/0x180
 [<c109f624>] rb_buffer_peek+0x24/0xe0
 [<c10a01ad>] ring_buffer_consume+0x8d/0xc0
 [<c10a1585>] ring_buffer_consumer_thread+0xa5/0x440
 [<c173a1c2>] ? _spin_unlock_irqrestore+0x62/0x80
 [<c10306be>] ? complete+0x4e/0x60
 [<c10a14e0>] ? ring_buffer_consumer_thread+0x0/0x440
 [<c105c1e2>] kthread+0x52/0x80
 [<c105c190>] ? kthread+0x0/0x80
 [<c10047cb>] kernel_thread_helper+0x7/0x10
PASSED
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
OCFS2 1.5.0
ocfs2: Registered cluster interface o2cb
OCFS2 Node Manager 1.5.0
OCFS2 DLM 1.5.0
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
msgmni has been set to 1674
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
cryptomgr_test used greatest stack depth: 6156 bytes left
alg: No test for stdrng (krng)
io scheduler noop registered (default)
io scheduler anticipatory registered
io scheduler deadline registered

# e5b90788
# head: e5b90788
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.30-rc8
# Sun Jun  7 04:53:50 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
# CONFIG_BOOTPARAM_SUPPORT is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
# CONFIG_BROKEN_BOOT_ALLOWED4 is not set
# CONFIG_BROKEN_BOOT_EUROPE is not set
# CONFIG_BROKEN_BOOT_TITAN is not set
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
# CONFIG_CGROUP_CPUACCT is not set
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_STRIP_ASM_SYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_IBS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_SLOW_WORK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP_SUPPORT=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_KVM_CLOCK=y
# CONFIG_KVM_GUEST is not set
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
CONFIG_MCRUSOE=y
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
# CONFIG_X86_PTRACE_BTS is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_OLD_MCE is not set
CONFIG_X86_NEW_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_VM86=y
CONFIG_TOSHIBA=y
CONFIG_I8K=m
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
CONFIG_X86_CPU_DEBUG=y
# CONFIG_UP_WANTED_1 is not set
CONFIG_SMP=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_CMDLINE_OVERRIDE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_SYSFS_POWER is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_DEBUG_FUNC_TRACE=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
CONFIG_ACPI_SBS=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=m
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
CONFIG_APM_CPU_IDLE=y
CONFIG_APM_DISPLAY_BLANK=y
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_POWERNOW_K6=m
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=m
CONFIG_X86_P4_CLOCKMOD=m
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
CONFIG_X86_LONGRUN=m
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_BIOS=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
CONFIG_PCI_LEGACY=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=m
CONFIG_OLPC=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
CONFIG_PCMCIA_DEBUG=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
# CONFIG_YENTA is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_COMPAQ=m
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
# CONFIG_HOTPLUG_PCI_CPCI_ZT5550 is not set
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
# CONFIG_INET_LRO is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
CONFIG_DEFAULT_RENO=y
CONFIG_DEFAULT_TCP_CONG="reno"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=m
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=m
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_HMAC_NONE=y
# CONFIG_SCTP_HMAC_SHA1 is not set
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_ECONET=y
# CONFIG_ECONET_AUNUDP is not set
# CONFIG_ECONET_NATIVE is not set
CONFIG_WAN_ROUTER=m
# CONFIG_PHONET is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=y
# CONFIG_NET_SCH_PRIO is not set
# CONFIG_NET_SCH_MULTIQ is not set
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=y
# CONFIG_NET_SCH_TBF is not set
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=m
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
# CONFIG_NET_ACT_GACT is not set
# CONFIG_NET_ACT_MIRRED is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_TCPPROBE=m
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
# CONFIG_NETROM is not set
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
# CONFIG_BAYCOM_EPP is not set
CONFIG_YAM=m
CONFIG_CAN=y
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=y

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=y
CONFIG_CAN_DEBUG_DEVICES=y
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=m
# CONFIG_IRCOMM is not set
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
# CONFIG_KINGSUN_DONGLE is not set
CONFIG_KSDAZZLE_DONGLE=y
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
CONFIG_SIGMATEL_FIR=y
CONFIG_NSC_FIR=y
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=y
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=y
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=y
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=m
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
# CONFIG_BT_CMTP is not set
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=y
CONFIG_BT_HCIBPA10X=y
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_AF_RXRPC=m
CONFIG_AF_RXRPC_DEBUG=y
# CONFIG_RXKAD is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
CONFIG_CFG80211_REG_DEBUG=y
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
# CONFIG_WIRELESS_EXT_SYSFS is not set
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
CONFIG_MAC80211_VERBOSE_MPL_DEBUG=y
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
# CONFIG_RFKILL_INPUT is not set
CONFIG_RFKILL_LEDS=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
CONFIG_PARPORT_PC_FIFO=y
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
CONFIG_ICS932S401=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_93CX6 is not set
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
# CONFIG_SCSI_ENCLOSURE is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=y
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
CONFIG_SCSI_IZIP_EPP16=y
CONFIG_SCSI_IZIP_SLOW_CTR=y
# CONFIG_SCSI_STEX is not set
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_LPFC_DEBUG_FS=y
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CS5535=m
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
CONFIG_PATA_EFAR=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
# CONFIG_PATA_HPT3X2N is not set
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_IT8213=y
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_NETCELL is not set
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87410 is not set
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=y
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
# CONFIG_PATA_RZ1000 is not set
CONFIG_PATA_SC1200=m
CONFIG_PATA_SERVERWORKS=m
# CONFIG_PATA_PDC2027X is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=m
# CONFIG_MD is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
# CONFIG_IEEE1394_OHCI1394 is not set
CONFIG_IEEE1394_PCILYNX=y
# CONFIG_IEEE1394_SBP2 is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
# CONFIG_I2O_BUS is not set
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_IFB=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=m
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=y
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
# CONFIG_ARCNET_CAP is not set
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
# CONFIG_ARCNET_COM20020_PCI is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
CONFIG_ETHOC=y
CONFIG_DNET=y
# CONFIG_NET_TULIP is not set
CONFIG_HP100=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
# CONFIG_AMD8111_ETH is not set
# CONFIG_ADAPTEC_STARFIRE is not set
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_E100=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
CONFIG_R6040=y
# CONFIG_SIS900 is not set
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
# CONFIG_SUNDANCE is not set
# CONFIG_TLAN is not set
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
# CONFIG_SC92031 is not set
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
# CONFIG_DE620 is not set
# CONFIG_ATL2 is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=y
CONFIG_E1000=m
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
CONFIG_IGB=m
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
CONFIG_YELLOWFIN=y
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=m
CONFIG_SKY2_DEBUG=y
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
CONFIG_JME=y
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
# CONFIG_WLAN_80211 is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable MMC support to see WiMAX SDIO drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=m
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SMSC95XX=m
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
# CONFIG_USB_NET_ZAURUS is not set
CONFIG_USB_HSO=m
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
# CONFIG_HDLC_RAW is not set
CONFIG_HDLC_RAW_ETH=y
CONFIG_HDLC_CISCO=y
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
CONFIG_PCI200SYN=m
# CONFIG_WANXL is not set
CONFIG_PC300TOO=y
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_WAN_ROUTER_DRIVERS is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=y
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
CONFIG_ATM_ENI_TUNE_BURST=y
# CONFIG_ATM_ENI_BURST_TX_16W is not set
CONFIG_ATM_ENI_BURST_TX_8W=y
CONFIG_ATM_ENI_BURST_TX_4W=y
CONFIG_ATM_ENI_BURST_TX_2W=y
CONFIG_ATM_ENI_BURST_RX_16W=y
# CONFIG_ATM_ENI_BURST_RX_8W is not set
CONFIG_ATM_ENI_BURST_RX_4W=y
CONFIG_ATM_ENI_BURST_RX_2W=y
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=y
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=m
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
CONFIG_ATM_IDT77252_DEBUG=y
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=y
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=y
CONFIG_ATM_IA_DEBUG=y
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
# CONFIG_PLIP is not set
# CONFIG_PPP is not set
CONFIG_SLIP=m
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=m
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=y
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
CONFIG_ISDN_PPP_BSDCOMP=m
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
# CONFIG_ISDN_DRV_HISAX is not set

#
# Active cards
#
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
# CONFIG_ISDN_DRV_GIGASET is not set
CONFIG_ISDN_CAPI=y
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
# CONFIG_CAPI_AVM is not set
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
CONFIG_PHONE=y

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_XTKBD=y
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_INPUT_MOUSE is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
CONFIG_JOYSTICK_GF2K=y
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=m
# CONFIG_JOYSTICK_INTERACT is not set
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=m
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=m
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=y
CONFIG_JOYSTICK_TWIDJOY=y
CONFIG_JOYSTICK_ZHENHUA=y
CONFIG_JOYSTICK_DB9=m
# CONFIG_JOYSTICK_GAMECON is not set
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=y
# CONFIG_JOYSTICK_XPAD_FF is not set
CONFIG_JOYSTICK_XPAD_LEDS=y
# CONFIG_JOYSTICK_WALKERA0701 is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=y
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=y
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
# CONFIG_INPUT_CM109 is not set
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
# CONFIG_SERIO_PARKBD is not set
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
# CONFIG_GAMEPORT_FM801 is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=y
CONFIG_CYZ_INTR=y
CONFIG_DIGIEPCA=y
# CONFIG_MOXA_INTELLIO is not set
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=y
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=y
# CONFIG_RISCOM8 is not set
CONFIG_SPECIALIX=y
# CONFIG_SX is not set
CONFIG_RIO=m
CONFIG_RIO_OLDPCI=y
CONFIG_STALDRV=y
CONFIG_STALLION=m
CONFIG_ISTALLION=m
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
# CONFIG_SERIAL_8250_RSA is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=m
# CONFIG_IPMI_WATCHDOG is not set
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_NVRAM is not set
CONFIG_RTC=m
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=m
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=m
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_SIMTEC=y

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m
CONFIG_SCx200_I2C=y
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
CONFIG_SENSORS_PCF8574=m
# CONFIG_PCF8575 is not set
CONFIG_SENSORS_MAX6875=m
# CONFIG_SENSORS_TSL2550 is not set
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_TWL4030=y

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m

#
# SPI GPIO expanders:
#
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_BQ27000=m
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=y
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7462=m
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_K8TEMP=y
# CONFIG_SENSORS_ASB100 is not set
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=y
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
# CONFIG_SENSORS_IBMPEX is not set
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=y
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=y
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=y
CONFIG_SENSORS_LM95241=m
# CONFIG_SENSORS_MAX1619 is not set
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_SHT15=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_VIA686A=y
CONFIG_SENSORS_VT1211=m
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=y
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=y
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
# CONFIG_THERMAL_HWMON is not set
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=y
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_SC1200_WDT=m
CONFIG_SCx200_WDT=y
CONFIG_PC87413_WDT=m
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
CONFIG_SBC7240_WDT=y
CONFIG_CPU5_WDT=y
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
# CONFIG_SSB_DRIVER_PCICORE is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TPS65010 is not set
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_MFD_WM8400=m
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_VIDEO_MEDIA is not set

#
# Multimedia drivers
#
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=m
CONFIG_AGP_AMD64=m
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
CONFIG_AGP_SWORKS=m
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=m
# CONFIG_DRM is not set
CONFIG_VGASTATE=y
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_ARC=y
CONFIG_FB_IMSTT=y
CONFIG_FB_UVESA=m
CONFIG_FB_EFI=y
CONFIG_FB_N411=m
CONFIG_FB_HGA=y
CONFIG_FB_HGA_ACCEL=y
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=m
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
# CONFIG_FB_ATY_GX is not set
CONFIG_FB_ATY_BACKLIGHT=y
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
CONFIG_FB_NEOMAGIC=m
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=m
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
CONFIG_BACKLIGHT_DA903X=m
CONFIG_BACKLIGHT_MBP_NVIDIA=y
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_HID=y
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=m
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HWA_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
# CONFIG_USB_STORAGE_SDDR09 is not set
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=y
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=y
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=y
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=y
CONFIG_USB_SERIAL_EMPEG=y
CONFIG_USB_SERIAL_FTDI_SIO=y
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=y
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
CONFIG_USB_SERIAL_KEYSPAN=y
# CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
CONFIG_USB_SERIAL_KEYSPAN_USA28XB=y
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QI is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
CONFIG_USB_SERIAL_KEYSPAN_USA49WLC=y
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=y
CONFIG_USB_SERIAL_MCT_U232=y
CONFIG_USB_SERIAL_MOS7720=y
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=y
CONFIG_USB_SERIAL_OTI6858=y
# CONFIG_USB_SERIAL_QUALCOMM is not set
CONFIG_USB_SERIAL_SPCP8X5=y
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=y
# CONFIG_USB_SERIAL_SYMBOL is not set
CONFIG_USB_SERIAL_TI=m
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=y
CONFIG_USB_SERIAL_OPTICON=m
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=y
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=y
CONFIG_USB_LCD=y
CONFIG_USB_BERRY_CHARGE=y
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=y
CONFIG_USB_IDMOUSE=m
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=y
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_VST is not set
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
# CONFIG_USB_XUSBATM is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=y
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=y
CONFIG_UWB_WLP=y
# CONFIG_UWB_I1480U is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_ALIX2=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_LP5521=y
CONFIG_LEDS_CLEVO_MAIL=y
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_GPIO is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_UIO is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
CONFIG_ASUS_LAPTOP=y
CONFIG_DELL_WMI=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_LAPTOP_DEBUG=y
# CONFIG_TC1100_WMI is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=m
# CONFIG_SONYPI_COMPAT is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
# CONFIG_DMIID is not set
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_CHECK=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_OCFS2_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
# CONFIG_QFMT_V2 is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_FSCACHE_DEBUG=y
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
# CONFIG_NTFS_RW is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_EXPORTFS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
# CONFIG_ACORN_PARTITION_RISCIX is not set
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=y
# CONFIG_NLS_CODEPAGE_863 is not set
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ALLOW_WARNINGS is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_SLUB_STATS=y
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_KPROBES_SANITY_TEST=y
CONFIG_BACKTRACE_SELF_TEST=m
CONFIG_LKDTM=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_FUNCTION_GRAPH_TRACER is not set
CONFIG_IRQSOFF_TRACER=y
CONFIG_PREEMPT_TRACER=y
CONFIG_SYSPROF_TRACER=y
# CONFIG_SCHED_TRACER is not set
CONFIG_FTRACE_SYSCALLS=y
# CONFIG_BOOT_TRACER is not set
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
CONFIG_PROFILE_ANNOTATED_BRANCHES=y
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_TRACING_BRANCHES=y
CONFIG_BRANCH_TRACER=y
CONFIG_POWER_TRACER=y
# CONFIG_KSYM_TRACER is not set
CONFIG_STACK_TRACER=y
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_DYNAMIC_FTRACE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
CONFIG_RING_BUFFER_BENCHMARK=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SAMPLES=y
CONFIG_SAMPLE_MARKERS=m
CONFIG_SAMPLE_TRACEPOINTS=m
CONFIG_SAMPLE_TRACE_EVENTS=m
# CONFIG_SAMPLE_KOBJECT is not set
CONFIG_SAMPLE_KPROBES=m
CONFIG_SAMPLE_KRETPROBES=m
CONFIG_SAMPLE_HW_BREAKPOINT=m
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_NX_TEST=m
# CONFIG_4KSTACKS is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
CONFIG_CRYPTO_RMD128=m
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_TGR192 is not set
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=y
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
# CONFIG_VIRTUALIZATION is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y
