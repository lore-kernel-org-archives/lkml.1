Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYHTGps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYHTGps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYHTGpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:45:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52368 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbYHTGpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:45:23 -0400
Date: Wed, 20 Aug 2008 08:44:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dtor@mail.ru>
Cc: Paul Jackson <pj@sgi.com>, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Max Krasnyansky <maxk@qualcomm.com>
Subject: [input layer, lockdep warning] Re: [PATCH] cpuset: Rework sched
	domains and CPU hotplug handling (take 4)
Message-ID: <20080820064437.GA14208@elte.hu>
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com> <20080811183122.acd25489.pj@sgi.com> <20080814092424.GB18771@elte.hu> <20080814111633.GA2614@elte.hu> <48A477B8.9090704@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A477B8.9090704@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dmitry,

this lockdep warning triggered again in -tip testing:

> > [   59.750200] =======================================================
> > [   59.750200] [ INFO: possible circular locking dependency detected ]
> > [   59.750200] 2.6.27-rc3-tip-00076-g75f9a29-dirty #1
> > [   59.750200] -------------------------------------------------------
> > [   59.750200] Xorg/6623 is trying to acquire lock:
> > [   59.750200]  (cpu_add_remove_lock){--..}, at: [<c0147dae>] cpu_maps_update_begin+0x14/0x16
> > [   59.750200] 
> > [   59.750200] but task is already holding lock:
> > [   59.750200]  (polldev_mutex){--..}, at: [<c07eb66f>] input_close_polled_device+0x22/0x47
> > [   59.750200] 
> > [   59.750200] which lock already depends on the new lock.

See the bootlog below. Upstream base of the tree below is 
1fca254274823876. The first warnings came with b635acec48.

	Ingo

------------------>
Initializing cgroup subsys cpuset
Linux version 2.6.27-rc3-tip-00607-g3c311a4-dirty (mingo@europe) (gcc version 4.2.2) #1 SMP Mon Aug 18 21:31:41 CEST 2008
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
last_pfn = 0x7f6e0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 38000000 @ 7000-c000
DMI present.
ACPI: RSDP 000F68A0, 0024 (r2 LENOVO)
ACPI: XSDT 7F6E631F, 0074 (r1 LENOVO TP-79        1020  LTP        0)
ACPI: FACP 7F6E6400, 00F4 (r3 LENOVO TP-79        1020 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080609]
ACPI: DSDT 7F6E65E7, C765 (r1 LENOVO TP-79        1020 MSFT  100000E)
ACPI: FACS 7F6F4000, 0040
ACPI: SSDT 7F6E65B4, 0033 (r1 LENOVO TP-79        1020 MSFT  100000E)
ACPI: ECDT 7F6F2D4C, 0052 (r1 LENOVO TP-79        1020 LNVO        1)
ACPI: TCPA 7F6F2D9E, 0032 (r2 LENOVO TP-79        1020 LNVO        1)
ACPI: APIC 7F6F2DD0, 0068 (r1 LENOVO TP-79        1020 LNVO        1)
ACPI: MCFG 7F6F2E38, 003E (r1 LENOVO TP-79        1020 LNVO        1)
ACPI: HPET 7F6F2E76, 0038 (r1 LENOVO TP-79        1020 LNVO        1)
ACPI: BOOT 7F6F2FD8, 0028 (r1 LENOVO TP-79        1020  LTP        1)
ACPI: SSDT 7F6E58DA, 0507 (r1 LENOVO TP-79        1020 INTL 20050513)
ACPI: SSDT 7F6E5702, 01D8 (r1 LENOVO TP-79        1020 INTL 20050513)
1142MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(8 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0001590cdc]    TEXT DATA BSS ==> [0000100000 - 0001590cdc]
  #4 [0001591000 - 0001598000]    INIT_PG_TABLE ==> [0001591000 - 0001598000]
  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
found SMP MP-table at [c00f68e0] 000f68e0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0007f6e0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007f6e0
On node 0 totalpages: 521855
free_area_init_node: node 0, pgdat c0e50f00, node_mem_map c1598000
  DMA zone: 3943 pages, LIFO batch:0
  Normal zone: 222200 pages, LIFO batch:31
  HighMem zone: 288575 pages, LIFO batch:31
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
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
dyn_array irq_2_pin_head+0x0/0xc size:0xc nr:256 align:0x1000
dyn_array irq_cfgx+0x0/0x4 size:0x1c nr:32 align:0x1000
dyn_array irq_descX+0x0/0x4 size:0x80 nr:32 align:0x1000
dyn_array total_size: 0x3000
dyn_array irq_2_pin_head+0x0/0xc  ==> [0x3198000 - 0x3198c00]
dyn_array irq_cfgx+0x0/0x4  ==> [0x3199000 - 0x3199380]
dyn_array irq_descX+0x0/0x4  ==> [0x319a000 - 0x319b000]
kstat_irqs ==> [0x319b000 - 0x319b100]
PERCPU: Allocating 36864 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 514718
Kernel command line: 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
found new irq_desc for irq 0
found new irq_desc for irq 1
found new irq_desc for irq 2
found new irq_desc for irq 3
found new irq_desc for irq 4
found new irq_desc for irq 5
found new irq_desc for irq 6
found new irq_desc for irq 7
found new irq_desc for irq 8
found new irq_desc for irq 9
found new irq_desc for irq 10
found new irq_desc for irq 11
found new irq_desc for irq 12
found new irq_desc for irq 13
found new irq_desc for irq 14
found new irq_desc for irq 15
CPU 0 irqstacks, hard=c0fc6000 soft=c0fbe000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
TSC calibrated against PIT
Detected 1596.586 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 2335 kB
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
Memory: 2035704k/2087808k available (9635k kernel code, 50736k reserved, 4837k data, 568k init, 1170304k highmem)
virtual kernel memory layout:
    fixmap  : 0xffee0000 - 0xfffff000   (1148 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0f2d000 - 0xc0fbb000   ( 568 kB)
      .data : 0xc0a68c57 - 0xc0f22078   (4837 kB)
      .text : 0xc0100000 - 0xc0a68c57   (9635 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3193.17 BogoMIPS (lpj=6386344)
Security Framework initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
Parsing all Control Methods:
Table [DSDT](id 0001) - 1587 Objects with 76 Devices 433 Methods 26 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 1 Objects with 0 Devices 1 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0003) - 14 Objects with 0 Devices 5 Methods 0 Regions
Parsing all Control Methods:
Table [SSDT](id 0004) - 14 Objects with 1 Devices 2 Methods 0 Regions
 tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
 0 add_pin_to_irq: irq 0 --> apic 0 pin 2
 0 add_pin_to_irq: irq 3 --> apic 0 pin 3
 0 add_pin_to_irq: irq 4 --> apic 0 pin 4
 0 add_pin_to_irq: irq 5 --> apic 0 pin 5
 0 add_pin_to_irq: irq 6 --> apic 0 pin 6
 0 add_pin_to_irq: irq 7 --> apic 0 pin 7
 0 add_pin_to_irq: irq 8 --> apic 0 pin 8
 0 add_pin_to_irq: irq 9 --> apic 0 pin 9
 0 add_pin_to_irq: irq 10 --> apic 0 pin 10
 0 add_pin_to_irq: irq 11 --> apic 0 pin 11
 0 add_pin_to_irq: irq 12 --> apic 0 pin 12
 0 add_pin_to_irq: irq 13 --> apic 0 pin 13
 0 add_pin_to_irq: irq 14 --> apic 0 pin 14
 0 add_pin_to_irq: irq 15 --> apic 0 pin 15
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
lockdep: fixing up alternatives.
CPU 1 irqstacks, hard=c0fc7000 soft=c0fbf000
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.46 BogoMIPS (lpj=7314927)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 580096 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (6850.63 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
net_namespace: 568 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
ACPI: EC: EC description table is found, configuring boot EC
Completing Region/Field/Buffer/Package initialization:.........................................................................................................................................................................................................................................................................................
Initialized 26/26 Regions 142/142 Fields 64/64 Buffers 49/49 Packages (1625 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:...<6>ACPI: EC: non-query interrupt received, switching to interrupt mode
....
Executed 7 _INI methods requiring 2 _STA executions (examined 83 objects)
evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 2 Runtime GPEs in this block
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [8086/27a0] class 000600 header type 00
pci 0000:00:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:02.0: found [8086/27a2] class 000300 header type 00
pci 0000:00:02.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:02.1: found [8086/27a6] class 000380 header type 00
pci 0000:00:02.1: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1b.0: found [8086/27d8] class 000403 header type 00
pci 0000:00:1b.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: found [8086/27d0] class 000604 header type 01
pci 0000:00:1c.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: found [8086/27d2] class 000604 header type 01
pci 0000:00:1c.1: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: found [8086/27d4] class 000604 header type 01
pci 0000:00:1c.2: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: found [8086/27d6] class 000604 header type 01
pci 0000:00:1c.3: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: found [8086/27c8] class 000c03 header type 00
pci 0000:00:1d.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1d.1: found [8086/27c9] class 000c03 header type 00
pci 0000:00:1d.1: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1d.2: found [8086/27ca] class 000c03 header type 00
pci 0000:00:1d.2: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1d.3: found [8086/27cb] class 000c03 header type 00
pci 0000:00:1d.3: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1d.7: found [8086/27cc] class 000c03 header type 00
pci 0000:00:1d.7: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1e.0: found [8086/2448] class 000604 header type 01
pci 0000:00:1e.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1f.0: found [8086/27b9] class 000601 header type 00
pci 0000:00:1f.0: calling ich_force_enable_hpet+0x0/0x16b
pci 0000:00:1f.0: calling quirk_ich6_lpc_acpi+0x0/0x6a
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:00:1f.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1f.1: found [8086/27df] class 000101 header type 00
pci 0000:00:1f.1: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1f.2: found [8086/27c5] class 000106 header type 00
pci 0000:00:1f.2: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: found [8086/27da] class 000c05 header type 00
pci 0000:00:1f.3: calling pci_fixup_transparent_bridge+0x0/0x30
PCI: Fixups for bus 0000:00
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
pci 0000:02:00.0: found [8086/109a] class 000200 header type 00
pci 0000:02:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
PCI: Fixups for bus 0000:02
PCI: bridge 0000:00:1c.0 io port: [2fff00002000, f78aaae4f7982000]
PCI: bridge 0000:00:1c.0 32bit mmio: [ee0fffffee000000, f78aaae4f7982000]
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:1c.1: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
pci 0000:03:00.0: found [8086/4227] class 000280 header type 00
pci 0000:03:00.0: calling pci_fixup_transparent_bridge+0x0/0x30
pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
pci 0000:03:00.0: PME# disabled
PCI: Fixups for bus 0000:03
PCI: bridge 0000:00:1c.1 io port: [4fff00003000, f78ab2e4f7982400]
PCI: bridge 0000:00:1c.1 32bit mmio: [edffffffec000000, f78ab2e4f7982400]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [e40fffffe4000000, f78ab2e4f7982400]
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:1c.2: scanning behind bridge, config 0b0400, pass 0
PCI: Scanning bus 0000:04
PCI: Fixups for bus 0000:04
PCI: bridge 0000:00:1c.2 io port: [6fff00005000, f78abae4f7982800]
PCI: bridge 0000:00:1c.2 32bit mmio: [e9ffffffe8000000, f78abae4f7982800]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [e41fffffe4100000, f78abae4f7982800]
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:1c.3: scanning behind bridge, config 130c00, pass 0
PCI: Scanning bus 0000:0c
PCI: Fixups for bus 0000:0c
PCI: bridge 0000:00:1c.3 io port: [8fff00007000, f78ac2e4f7982c00]
PCI: bridge 0000:00:1c.3 32bit mmio: [ebffffffea000000, f78ac2e4f7982c00]
PCI: bridge 0000:00:1c.3 64bit mmio pref: [e42fffffe4200000, f78ac2e4f7982c00]
PCI: Bus scan for 0000:0c returning with max=0c
pci 0000:00:1e.0: scanning behind bridge, config 181500, pass 0
PCI: Scanning bus 0000:15
pci 0000:15:00.0: found [104c/ac56] class 000607 header type 02
pci 0000:15:00.0: supports D1
pci 0000:15:00.0: supports D2
pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:15:00.0: PME# disabled
PCI: Fixups for bus 0000:15
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [cfff00009000, f78af2e4f7983000]
PCI: bridge 0000:00:1e.0 32bit mmio: [e7ffffffe4300000, f78af2e4f7983000]
PCI: bridge 0000:00:1e.0 64bit mmio pref: [e3ffffffe0000000, f78af2e4f7983000]
pci 0000:15:00.0: scanning behind bridge, config 181615, pass 0
pci 0000:15:00.0: scanning behind bridge, config 181615, pass 1
PCI: Bus scan for 0000:15 returning with max=17
pci 0000:00:1c.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:1c.1: scanning behind bridge, config 030300, pass 1
pci 0000:00:1c.2: scanning behind bridge, config 0b0400, pass 1
pci 0000:00:1c.3: scanning behind bridge, config 130c00, pass 1
pci 0000:00:1e.0: scanning behind bridge, config 181500, pass 1
PCI: Bus scan for 0000:00 returning with max=18
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
ACPI: WMI: Mapper loaded
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: parse allocated resources
pnp 00:00:   add mem 0x0-0x9ffff flags 0x1
pnp 00:00:   add mem 0xc0000-0xc3fff flags 0x0
pnp 00:00:   add mem 0xc4000-0xc7fff flags 0x0
pnp 00:00:   add mem 0xc8000-0xcbfff flags 0x0
pnp 00:00:   add mem 0xcc000-0xcffff flags 0x0
pnp 00:00:   add mem 0xd0000-0xd3fff flags 0x0
pnp 00:00:   add mem 0xd4000-0xd3fff flags 0x10000000
pnp 00:00:   add mem 0xd8000-0xd7fff flags 0x10000000
pnp 00:00:   add mem 0xdc000-0xdffff flags 0x1
pnp 00:00:   add mem 0xe0000-0xe3fff flags 0x0
pnp 00:00:   add mem 0xe4000-0xe7fff flags 0x0
pnp 00:00:   add mem 0xe8000-0xebfff flags 0x0
pnp 00:00:   add mem 0xec000-0xeffff flags 0x0
pnp 00:00:   add mem 0xf0000-0xfffff flags 0x0
pnp 00:00:   add mem 0x100000-0x7fffffff flags 0x1
pnp 00:00:   add mem 0xfec00000-0xffffffff flags 0x0
pnp 00:00:   add mem 0xfed41000-0xfed40fff flags 0x10000000
pnp 00:00: PNP0c01: calling quirk_system_pci_resources+0x0/0x160
pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add io  0xcf8-0xcff flags 0x1
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add io  0x10-0x1f flags 0x1
pnp 00:02:   add io  0x90-0x9f flags 0x1
pnp 00:02:   add io  0x24-0x25 flags 0x1
pnp 00:02:   add io  0x28-0x29 flags 0x1
pnp 00:02:   add io  0x2c-0x2d flags 0x1
pnp 00:02:   add io  0x30-0x31 flags 0x1
pnp 00:02:   add io  0x34-0x35 flags 0x1
pnp 00:02:   add io  0x38-0x39 flags 0x1
pnp 00:02:   add io  0x3c-0x3d flags 0x1
pnp 00:02:   add io  0xa4-0xa5 flags 0x1
pnp 00:02:   add io  0xa8-0xa9 flags 0x1
pnp 00:02:   add io  0xac-0xad flags 0x1
pnp 00:02:   add io  0xb0-0xb5 flags 0x1
pnp 00:02:   add io  0xb8-0xb9 flags 0x1
pnp 00:02:   add io  0xbc-0xbd flags 0x1
pnp 00:02:   add io  0x50-0x53 flags 0x1
pnp 00:02:   add io  0x72-0x77 flags 0x1
pnp 00:02:   add io  0x164e-0x164f flags 0x1
pnp 00:02:   add io  0x2e-0x2f flags 0x1
pnp 00:02:   add io  0x1000-0x107f flags 0x1
pnp 00:02:   add io  0x1180-0x11bf flags 0x1
pnp 00:02:   add io  0x800-0x80f flags 0x1
pnp 00:02:   add io  0x15e0-0x15ef flags 0x1
pnp 00:02:   add io  0x1600-0x165f flags 0x1
pnp 00:02:   add mem 0xf0000000-0xf3ffffff flags 0x1
pnp 00:02:   add mem 0xfed1c000-0xfed1ffff flags 0x1
pnp 00:02:   add mem 0xfed14000-0xfed17fff flags 0x1
pnp 00:02:   add mem 0xfed18000-0xfed18fff flags 0x1
pnp 00:02:   add mem 0xfed19000-0xfed19fff flags 0x1
pnp 00:02: PNP0c02: calling quirk_system_pci_resources+0x0/0x160
pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add mem 0xfed00000-0xfed003ff flags 0x0
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add io  0x0-0xf flags 0x1
pnp 00:04:   add io  0x80-0x8f flags 0x1
pnp 00:04:   add io  0xc0-0xdf flags 0x1
pnp 00:04:   add dma 4 flags 0x5
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0x61-0x61 flags 0x1
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add io  0xf0-0xf0 flags 0x1
pnp 00:06:   add irq 13 flags 0x1
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add io  0x70-0x71 flags 0x1
pnp 00:07:   add irq 8 flags 0x1
pnp 00:07: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0x60-0x60 flags 0x1
pnp 00:08:   add io  0x64-0x64 flags 0x1
pnp 00:08:   add irq 1 flags 0x1
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add irq 12 flags 0x1
pnp 00:09: Plug and Play ACPI device, IDs IBM0057 PNP0f13 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add io  0x2f8-0x2ff flags 0x1
pnp 00:0a:   add irq 3 flags 0x1
pnp 00:0a:   add dma 3 flags 0x0
pnp 00:0a: parse resource options
pnp 00:0a:   dependent set 0 (preferred) io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 0 (preferred) irq 3 flags 0x1
pnp 00:0a:   dependent set 0 (preferred) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 1 (acceptable) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 1 (acceptable) irq 4 flags 0x1
pnp 00:0a:   dependent set 1 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 2 (acceptable) io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 2 (acceptable) irq 3 flags 0x1
pnp 00:0a:   dependent set 2 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 3 (acceptable) io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 3 (acceptable) irq 4 flags 0x1
pnp 00:0a:   dependent set 3 (acceptable) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 4 (functional) io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 4 (functional) irq 4 5 7 flags 0x1
pnp 00:0a:   dependent set 4 (functional) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 5 (functional) io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 5 (functional) irq 3 5 7 flags 0x1
pnp 00:0a:   dependent set 5 (functional) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 6 (functional) io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 6 (functional) irq 4 5 7 flags 0x1
pnp 00:0a:   dependent set 6 (functional) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a:   dependent set 7 (functional) io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
pnp 00:0a:   dependent set 7 (functional) irq 3 5 7 flags 0x1
pnp 00:0a:   dependent set 7 (functional) dma 0 1 3 (bitmask 0xb) flags 0x0
pnp 00:0a: Plug and Play ACPI device, IDs IBM0071 PNP0511 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c-core: driver [dummy] registered
PCI: Using ACPI for IRQ routing
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
irda_init()
NET: Registered protocol family 23
Bluetooth: Core ver 2.12
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
tracer: 211 pages allocated for 16384 entries of 52 bytes
   actual entries 16458
Switched to high resolution mode on CPU 0
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 1
pnp: the driver 'system' has been registered
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
system 00:00: driver attached
system 00:02: ioport range 0x164e-0x164f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x165f could not be reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:02: driver attached
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
pci 0000:15:00.0:   MEM window: 0x88000000-0x8bffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
pci 0000:00:1e.0:   IO window: 0x9000-0xcfff
pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e3ffffff
found new irq_cfg for irq 20
 0 add_pin_to_irq: irq 20 --> apic 0 pin 20
found new irq_desc for irq 20
pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.0: setting latency timer to 64
found new irq_cfg for irq 21
 0 add_pin_to_irq: irq 21 --> apic 0 pin 21
found new irq_desc for irq 21
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
found new irq_cfg for irq 22
 0 add_pin_to_irq: irq 22 --> apic 0 pin 22
found new irq_desc for irq 22
pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.2: setting latency timer to 64
found new irq_cfg for irq 23
 0 add_pin_to_irq: irq 23 --> apic 0 pin 23
found new irq_desc for irq 23
pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: enabling device (0005 -> 0007)
pci 0000:00:1e.0: setting latency timer to 64
vendor=8086 device=2448
found new irq_cfg for irq 16
 0 add_pin_to_irq: irq 16 --> apic 0 pin 16
found new irq_desc for irq 16
pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
bus: 00 index 0 io port: [ffff00000000, f7981c00]
bus: 00 index 1 mmio: [ffffffff00000000, f7981c00]
bus: 02 index 0 io port: [2fff00002000, f7981c14f78aa800]
bus: 02 index 1 mmio: [ee0fffffee000000, f7981c14f78aa800]
bus: 02 index 2 mmio: [0, f7981c14f78aa800]
bus: 02 index 3 mmio: [0, f7981c14f78aa800]
bus: 03 index 0 io port: [4fff00003000, f7981c14f78ab000]
bus: 03 index 1 mmio: [edffffffec000000, f7981c14f78ab000]
bus: 03 index 2 mmio: [e40fffffe4000000, f7981c14f78ab000]
bus: 03 index 3 mmio: [0, f7981c14f78ab000]
bus: 04 index 0 io port: [6fff00005000, f7981c14f78ab800]
bus: 04 index 1 mmio: [e9ffffffe8000000, f7981c14f78ab800]
bus: 04 index 2 mmio: [e41fffffe4100000, f7981c14f78ab800]
bus: 04 index 3 mmio: [0, f7981c14f78ab800]
bus: 0c index 0 io port: [8fff00007000, f7981c14f78ac000]
bus: 0c index 1 mmio: [ebffffffea000000, f7981c14f78ac000]
bus: 0c index 2 mmio: [e42fffffe4200000, f7981c14f78ac000]
bus: 0c index 3 mmio: [0, f7981c14f78ac000]
bus: 15 index 0 io port: [cfff00009000, f7981c14f78af000]
bus: 15 index 1 mmio: [e7ffffffe4300000, f7981c14f78af000]
bus: 15 index 2 mmio: [e3ffffffe0000000, f7981c14f78af000]
bus: 15 index 3 io port: [ffff00000000, f7981c14f78af000]
bus: 15 index 4 mmio: [ffffffff00000000, f7981c14f78af000]
bus: 16 index 0 io port: [90ff00009000, f7983014f798a800]
bus: 16 index 1 io port: [94ff00009400, f7983014f798a800]
bus: 16 index 2 mmio: [e3ffffffe0000000, f7983014f798a800]
bus: 16 index 3 mmio: [8bffffff88000000, f7983014f798a800]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
pci 0000:00:00.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:00.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:02.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:02.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:02.0: Boot video device
pci 0000:00:02.1: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:02.1: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1b.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1b.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1b.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1b.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1c.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1c.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1c.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1c.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1c.1: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1c.1: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1c.1: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1c.1: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1c.2: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1c.2: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1c.2: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1c.2: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1c.3: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1c.3: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1c.3: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1c.3: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1d.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1d.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1d.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1d.1: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1d.1: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1d.1: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.1: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1d.2: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1d.2: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1d.2: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.2: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1d.3: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1d.3: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1d.3: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:1d.3: Performing full reset
pci 0000:00:1d.3: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1d.7: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1d.7: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1d.7: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1d.7: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1e.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1e.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1e.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1e.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1f.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1f.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1f.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1f.0: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1f.1: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1f.1: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1f.1: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1f.1: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1f.2: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1f.2: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1f.2: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1f.2: calling pci_fixup_video+0x0/0x9a
pci 0000:00:1f.3: calling quirk_e100_interrupt+0x0/0x164
pci 0000:00:1f.3: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:00:1f.3: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:00:1f.3: calling pci_fixup_video+0x0/0x9a
pci 0000:02:00.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:02:00.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:02:00.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:02:00.0: calling pci_fixup_video+0x0/0x9a
pci 0000:03:00.0: calling quirk_e100_interrupt+0x0/0x164
pci 0000:03:00.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:03:00.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:03:00.0: calling pci_fixup_video+0x0/0x9a
pci 0000:15:00.0: calling quirk_cardbus_legacy+0x0/0x26
pci 0000:15:00.0: calling quirk_usb_early_handoff+0x0/0x3aa
pci 0000:15:00.0: calling pci_fixup_video+0x0/0x9a
Simple Boot Flag at 0x35 set to 0x1
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk> <peter.oruba@amd.com>
Initializing RT-Tester: OK
====[ backtrace testing ]===========
Testing a backtrace from process context.
The following trace is a kernel self test and not a bug!
Pid: 1, comm: swapper Not tainted 2.6.27-rc3-tip-00607-g3c311a4-dirty #1
 [<c016bf2e>] backtrace_regression_test+0x2f/0xd1
 [<c01a7c73>] ? __percpu_alloc_mask+0xac/0xbd
 [<c0f43182>] ? crash_save_vmcoreinfo_init+0x30a/0x316
 [<c010112a>] do_one_initcall+0x42/0x133
 [<c016beff>] ? backtrace_regression_test+0x0/0xd1
 [<c01600fb>] ? trace_hardirqs_on_caller+0xe8/0x11d
 [<c016013b>] ? trace_hardirqs_on+0xb/0xd
 [<c0151749>] ? __queue_work+0x2b/0x30
 [<c01517b1>] ? queue_work_on+0x3a/0x46
 [<c0f2d5cb>] kernel_init+0x16e/0x1d5
 [<c0f2d45d>] ? kernel_init+0x0/0x1d5
 [<c0117c03>] kernel_thread_helper+0x7/0x10
 =======================
Testing a backtrace from irq context.
The following trace is a kernel self test and not a bug!
Pid: 7, comm: ksoftirqd/1 Not tainted 2.6.27-rc3-tip-00607-g3c311a4-dirty #1
 [<c01600e5>] ? trace_hardirqs_on_caller+0xd2/0x11d
 [<c016bef3>] backtrace_test_irq_callback+0xd/0x19
 [<c0147e2f>] tasklet_action+0x78/0xe3
 [<c0147ab0>] __do_softirq+0x89/0x10c
 [<c0147a27>] ? __do_softirq+0x0/0x10c
 [<c0119989>] do_softirq+0x7e/0xdf
 [<c01478c6>] ksoftirqd+0x67/0xc8
 [<c014785f>] ? ksoftirqd+0x0/0xc8
 [<c0153e2a>] kthread+0x40/0x66
 [<c0153dea>] ? kthread+0x0/0x66
 [<c0117c03>] kernel_thread_helper+0x7/0x10
 =======================
Testing a saved backtrace.
The following trace is a kernel self test and not a bug!
 [<c012054d>] save_stack_trace+0x22/0x41
 [<c016bfb5>] backtrace_regression_test+0xb6/0xd1
 [<c010112a>] do_one_initcall+0x42/0x133
 [<c0f2d5cb>] kernel_init+0x16e/0x1d5
 [<c0117c03>] kernel_thread_helper+0x7/0x10
 [<ffffffff>] 0xffffffff
====[ end of backtrace testing ]====
audit: initializing netlink socket (disabled)
type=2000 audit(1219087960.500:1): initialized
rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1
Testing tracer sched_switch: <6>ACPI: Battery Slot [BAT0] (battery present)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input2
ACPI: Sleep Button (CM) [SLPB]
ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
found new irq_cfg for irq 19
 0 add_pin_to_irq: irq 19 --> apic 0 pin 19
found new irq_desc for irq 19
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
PASSED
Testing tracer ftrace: <7>ehci_hcd 0000:00:1d.7: GetStatus port 8 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 8: status 0501 change 0001
PASSED
Testing tracer wakeup: <7>hub 1-0:1.0: state 7 ports 8 chg 0100 evt 0000
hub 1-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-rc3-tip-00607-g3c311a4-dirty ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: port 8 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 8 not reset yet, waiting 50ms
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-rc3-tip-00607-g3c311a4-dirty uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
found new irq_cfg for irq 17
 0 add_pin_to_irq: irq 17 --> apic 0 pin 17
found new irq_desc for irq 17
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: GetStatus port 8 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0100
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0000
.. no entries found ..FAILED!
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
DLM (built Aug 18 2008 21:29:35) installed
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
QNX4 filesystem 0.2.3 registered.
fuse init (API version 7.9)
JFS: nTxBlock = 8192, nTxLock = 65536
SGI XFS with ACLs, security attributes, realtime, debug enabled
SGI XFS Quota Management subsystem
BeFS version: 0.9.3
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-rc3-tip-00607-g3c311a4-dirty uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
found new irq_cfg for irq 18
 0 add_pin_to_irq: irq 18 --> apic 0 pin 18
found new irq_desc for irq 18
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
Clocksource tsc unstable (delta = 73064959 ns)
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-rc3-tip-00607-g3c311a4-dirty uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.3: port 2 portsc 009b,00
hub 5-0:1.0: port 2: status 0101 change 0003
hub 5-0:1.0: state 7 ports 2 chg 0004 evt 0000
hub 5-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-rc3-tip-00607-g3c311a4-dirty uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
cpcihp_generic: not configured, disabling.
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
fakephp: Fake PCI Hot Plug Controller Driver
pci_create_slot: created pci_slot on 0000:00:00
pci_create_slot: created pci_slot on 0000:00:02
pci_create_slot: created pci_slot on 0000:00:1b
pci_create_slot: created pci_slot on 0000:00:1c
pci_create_slot: created pci_slot on 0000:00:1d
pci_create_slot: created pci_slot on 0000:00:1e
pci_create_slot: created pci_slot on 0000:00:1f
pci_create_slot: created pci_slot on 0000:02:00
pci_create_slot: created pci_slot on 0000:03:00
pci_create_slot: created pci_slot on 0000:15:00
INTEL CARILLO RANCH LPC not found.
Carillo Ranch Backlight Driver Initialized.
nvidiafb_setup START
vmlfb: initializing
Could not find Carillo Ranch MCH device.
input: Video Bus as /class/input/input3
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
input: Video Bus as /class/input/input4
ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
pci_create_slot: inc refcount to 2 on 0000:15:00
isapnp: Scanning for PnP cards...
usb 5-2: new full speed USB device using uhci_hcd and address 2
usb 5-2: ep0 maxpacket = 8
usb 5-2: default language 0x0409
usb 5-2: uevent
usb 5-2: usb_probe_device
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: adding 5-2:1.0 (config #1, interface 0)
usb 5-2:1.0: uevent
usb 5-2: New USB device found, idVendor=0483, idProduct=2016
usb 5-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 5-2: Product: Biometric Coprocessor
usb 5-2: Manufacturer: STMicroelectronics
isapnp: No Plug & Play device found
RocketPort device driver module, version 2.09, 12-June-2003
No rocketport ports found; unloading driver
Cyclades driver 2.5 (built Aug 18 2008 21:27:36)
Initializing Nozomi driver 2.1d (build date: Aug 18 2008 21:27:42)
MOXA Intellio family driver version 6.0k
SyncLink serial driver $Revision: 4.38 $
SyncLink serial driver $Revision: 4.38 $, tty major#250
SyncLink GT $Revision: 4.50 $
SyncLink GT $Revision: 4.50 $, tty major#249
SyncLink GT no devices found
HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
N_HDLC line discipline registered.
lp: driver loaded but no devices found
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
sonypi: Sony Programmable I/O Controller Driver v1.26.
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
toshiba: not a supported Toshiba laptop
ppdev: user-space parallel port driver
nsc_gpio initializing
telclk_interrup = 0xf non-mcpbl0010 hw.
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
SyncLink PC Card driver $Revision: 4.34 $
SyncLink PC Card driver $Revision: 4.34 $, tty major#248
cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte
OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte
ipmi message handler version 39.2
ipmi device interface
IPMI System Interface driver.
ipmi_si: Unable to find any System Interface(s)
Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[drm] Initialized drm 1.1.0 20060810
intelfb: intelfb_init
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets
intelfb: Version 0.9.5
intelfb: intelfb_setup
intelfb: no options
intelfb: intelfb_pci_register
intelfb 0000:00:02.0: power state changed by ACPI to D0
intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
intelfb: fb aperture: 0xd0000000/0x10000000, MMIO region: 0xee100000/0x80000
intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory 7932kB
intelfb: MTRR is disabled in the kernel
intelfb: fb: 0xd0000000(+ 0x0)/0x7bf000 (0xf8f00000)
intelfb: MMIO: 0xee100000/0x80000 (0xfc700000)
intelfb: ring buffer: 0xd3001000/0x10000 (0xfbf01000)
intelfb: HW cursor: 0x0/0x0 (0x00000000) (offset 0x0) (phys 0x0)
intelfb: options: vram = 4, accel = 1, hwcursor = 0, fixed = 0, noinit = 0
intelfb: options: mode = ""
intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
intelfb: Video mode must be programmed at boot time.
intelfb: cleanup
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
pnp: the driver 'serial' has been registered
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
usb usb2: suspend_rh
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
MM: desc_per_page = 128
usbcore: registered new interface driver ub
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
acer-wmi: Acer Laptop ACPI-WMI Extras
acer-wmi: No or unsupported WMI interface, unable to load
Phantom Linux Driver, version n0.9.8, init OK
thinkpad_acpi: ThinkPad ACPI Extras v0.21
thinkpad_acpi: http://ibm-acpi.sf.net/
thinkpad_acpi: ThinkPad BIOS 79ET56WW (1.02 ), EC 79HT42WW-1.01
thinkpad_acpi: Lenovo ThinkPad T60, model 1951A26
thinkpad_acpi: radio switch found; radios are disabled
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi:orange:batt
Registered led device: tpacpi:green:batt
Registered led device: tpacpi::dock_active
Registered led device: tpacpi::bay_active
Registered led device: tpacpi::dock_batt
Registered led device: tpacpi::unknown_led
Registered led device: tpacpi::standby
input: ThinkPad Extra Buttons as /class/input/input5
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:02:00.0: Disabling L1 ASPM
vendor=8086 device=27d0
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
0000:02:00.0: 0000:02:00.0: Warning: detected ASPM enabled in EEPROM
0000:02:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:41:17:49:d2
0000:02:00.0: eth0: Intel(R) PRO/1000 Network Connection
0000:02:00.0: eth0: MAC: 2, PHY: 2, PBA No: 005301-003
vcan: Virtual CAN interface driver
Ethernet Channel Bonding Driver: v3.3.0 (June 10, 2008)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
cs89x0:cs89x0_probe(0x0)
PP_addr at 300[a]: 0xffff
eth1: incorrect signature at 300[c]: 0xffff!=0x630E
PP_addr at 320[a]: 0xffff
eth1: incorrect signature at 320[c]: 0xffff!=0x630E
PP_addr at 340[a]: 0xffff
eth1: incorrect signature at 340[c]: 0xffff!=0x630E
PP_addr at 360[a]: 0xffff
eth1: incorrect signature at 360[c]: 0xffff!=0x630E
PP_addr at 200[a]: 0xffff
eth1: incorrect signature at 200[c]: 0xffff!=0x630E
PP_addr at 220[a]: 0xffff
eth1: incorrect signature at 220[c]: 0xffff!=0x630E
PP_addr at 240[a]: 0xffff
eth1: incorrect signature at 240[c]: 0xffff!=0x630E
PP_addr at 260[a]: 0xffff
eth1: incorrect signature at 260[c]: 0xffff!=0x630E
PP_addr at 280[a]: 0xffff
eth1: incorrect signature at 280[c]: 0xffff!=0x630E
PP_addr at 2a0[a]: 0xffff
eth1: incorrect signature at 2a0[c]: 0xffff!=0x630E
PP_addr at 2c0[a]: 0xffff
eth1: incorrect signature at 2c0[c]: 0xffff!=0x630E
PP_addr at 2e0[a]: 0xffff
eth1: incorrect signature at 2e0[c]: 0xffff!=0x630E
cs89x0: no cs8900 or cs8920 detected.  Be sure to disable PnP with SETUP
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
pnp: the driver '3c509' has been registered
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
proteon.c: 0 cards found.
proteon.c: No cards found.
skisa.c: 0 cards found.
skisa.c: No cards found.
HDLC support module revision 1.22
DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
SDLA driver v0.30, 12 Sep 1996, mike.mclagan@linux.org.
Cyclom 2X Support Module v0.6 (c) 1998-2003 Arnaldo Carvalho de Melo <acme@conectiva.com.br>
CYCLOM 2X(tm) Sync Card Driver v0.11 (c) 1998-2003 Arnaldo Carvalho de Melo <acme@conectiva.com.br>
arcnet loaded.
arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
arcnet: raw mode (`r') encapsulation support loaded.
arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
E-mail me if you actually test this driver, please!
 arc%d: No autoprobe for IO mapped cards; you must specify the base address!
arcnet: RIM I (entirely mem-mapped) support
E-mail me if you actually test the RIM I driver, please!
 arc%d: Given: node 00h, shmem 0h, irq 0
 arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
usbcore: registered new interface driver catc
catc: v2.8 CATC EL1210A NetMate USB Ethernet driver
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver dm9601
usbcore: registered new interface driver gl620a
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
STRIP: Version 1.3A-STUART.CHESHIRE (unlimited channels)
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
winbond-840.c:v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
  http://www.scyld.com/network/drivers.html
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
usbcore: registered new interface driver irda-usb
USB IrDA support registered
usbcore: registered new interface driver stir4200
pnp: the driver 'nsc-ircc' has been registered
nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; irq 3 ; dma 3.
nsc-ircc 00:0a: driver attached
nsc-ircc, chip->init
nsc-ircc, Found chip at base=0x164e
nsc-ircc, driver loaded (Dag Brattli)
nsc_ircc_open(), can't get iobase of 0x2f8
nsc-ircc, Found chip at base=0x164e
nsc-ircc, driver loaded (Dag Brattli)
nsc_ircc_open(), can't get iobase of 0x2f8
nsc-ircc 00:0a: disabled
pnp: the driver 'nsc-ircc' has been unregistered
w83977af_init()
w83977af_open()
w83977af_probe()
w83977af_probe(), Wrong chip version<7>w83977af_probe()
w83977af_probe(), Wrong chip version<6>usbcore: registered new interface driver mcs7780
usbcore: registered new interface driver kingsun-sir
usbcore: registered new interface driver ks959-sir
console [netcon0] enabled
netconsole: network logging started
input: Macintosh mouse button emulation as /class/input/input6
Loading iSCSI transport class v2.0-870.
rdac: device handler registered
hp_sw: device handler registered
iscsi: registered transport (tcp)
Adaptec aacraid driver 1.1-5[2456]-ms
scsi: <fdomain> Detection failed (no card)
sym53c416.c: Version 1.0.0-ac
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options<6>QLogic Fibre Channel HBA Driver: 8.02.01-k6
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
Emulex LightPulse Fibre Channel SCSI driver 8.2.7
Copyright(c) 2004-2008 Emulex.  All rights reserved.
Failed initialization of WD-7000 SCSI card!
DC390: clustering now enabled by default. If you get problems load
	with "disable_clustering=1" and report to maintainers
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
3ware Storage Controller device driver for Linux v1.26.02.002.
ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Driver 'ses' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
found new irq_cfg for irq 1024256
found new irq_desc for irq 1024256
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 1024256
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-7: HTS541080G9SA00, MB4IC60H, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48 
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
ata1.00: configured for UDMA/100
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata5.00: ATAPI: HL-DT-STCD-RW/DVD DRIVE GCC-4246N, 0X05, max UDMA/33
ata5.00: configured for UDMA/33
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            HL-DT-ST RW/DVD GCC-4246N 0X05 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
pnp: the driver 'pata_isapnp' has been registered
Intel ISA PCIC probe: not found.
aoe: AoE v47 initialised.
sl811: driver sl811-hcd, 19 May 2005
r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
usbcore: registered new interface driver microtekX6
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
usbserial: USB Serial support registered for ch341-uart
usbcore: registered new interface driver ch341
usbserial: USB Serial support registered for Reiner SCT Cyberjack USB card reader
usbcore: registered new interface driver cyberjack
cyberjack: v1.01 Matthias Bruestle
cyberjack: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver
usbserial: USB Serial support registered for Digi 2 port USB adapter
usbserial: USB Serial support registered for Digi 4 port USB adapter
usbcore: registered new interface driver digi_acceleport
digi_acceleport: v1.80.1.2:Digi AccelePort USB-2/USB-4 Serial Converter driver
usbserial: USB Serial support registered for Edgeport 2 port adapter
usbserial: USB Serial support registered for Edgeport 4 port adapter
usbserial: USB Serial support registered for Edgeport 8 port adapter
usbserial: USB Serial support registered for EPiC device
usbcore: registered new interface driver io_edgeport
io_edgeport: Edgeport USB Serial Driver v2.7
usbserial: USB Serial support registered for Edgeport TI 1 port adapter
usbserial: USB Serial support registered for Edgeport TI 2 port adapter
usbcore: registered new interface driver io_ti
io_ti: Edgeport USB Serial Driver v0.7mode043006
usbserial: USB Serial support registered for empeg
usbcore: registered new interface driver empeg
empeg: v1.2:USB Empeg Mark I/II Driver
usbserial: USB Serial support registered for FTDI USB Serial Device
usbcore: registered new interface driver ftdi_sio
ftdi_sio: v1.4.3:USB FTDI Serial Converters Driver
usbserial: USB Serial support registered for PocketPC PDA
ipaq: USB PocketPC PDA driver v0.5
usbcore: registered new interface driver ipaq
usbserial: USB Serial support registered for IR Dongle
usbcore: registered new interface driver ir-usb
ir_usb: USB IR Dongle driver v0.4
usbserial: USB Serial support registered for iuu_phoenix
usbcore: registered new interface driver iuu_phoenix
iuu_phoenix: Infinity USB Unlimited Phoenix driver v0.5
usbserial: USB Serial support registered for Keyspan - (without firmware)
usbserial: USB Serial support registered for Keyspan 1 port adapter
usbserial: USB Serial support registered for Keyspan 2 port adapter
usbserial: USB Serial support registered for Keyspan 4 port adapter
usbcore: registered new interface driver keyspan
keyspan: v1.1.5:Keyspan USB to Serial Converter Driver
usbserial: USB Serial support registered for Keyspan PDA
usbserial: USB Serial support registered for Keyspan PDA - (prerenumeration)
usbcore: registered new interface driver keyspan_pda
keyspan_pda: USB Keyspan PDA Converter driver v1.1
usbserial: USB Serial support registered for KL5KUSB105D / PalmConnect
usbcore: registered new interface driver kl5kusb105d
kl5kusb105: KLSI KL5KUSB105 chipset USB->Serial Converter driver v0.3a
usbserial: USB Serial support registered for MCT U232
usbcore: registered new interface driver mct_u232
mct_u232: Magic Control Technology USB-RS232 converter driver z2.1
usbserial: USB Serial support registered for Moschip 2 port adapter
mos7720: Moschip USB Serial Driver 1.0.0.4F
usbcore: registered new interface driver moschip7720
usbserial: USB Serial support registered for navman
usbcore: registered new interface driver navman
usbserial: USB Serial support registered for ZyXEL - omni.net lcd plus usb
usbcore: registered new interface driver omninet
omninet: v1.1:USB ZyXEL omni.net LCD PLUS Driver
usbserial: USB Serial support registered for oti6858
usbcore: registered new interface driver oti6858
usbserial: USB Serial support registered for pl2303
usbcore: registered new interface driver pl2303
pl2303: Prolific PL2303 USB to serial adaptor driver
safe_serial: v0.0b sl@lineo.com, tbr@lineo.com
safe_serial: USB Safe Encapsulated Serial
safe_serial: vendor: 0 product: 0 safe: 1 padded: 0

usbserial: USB Serial support registered for safe_serial
usbcore: registered new interface driver safe_serial
usbserial: USB Serial support registered for Sierra USB modem
usbcore: registered new interface driver sierra
sierra: USB Driver for Sierra Wireless USB modems: v.1.2.13a
usbserial: USB Serial support registered for Handspring Visor / Palm OS
usbserial: USB Serial support registered for Sony Clie 3.5
usbserial: USB Serial support registered for Sony Clie 5.0
usbcore: registered new interface driver visor
visor: USB HandSpring Visor / Palm OS driver
drivers/usb/misc/adutux.c :  adu_init : enter 
usbcore: registered new interface driver adutux
adutux: adutux adutux (see www.ontrak.net) v0.0.13
adutux: adutux is an experimental driver. Use at your own risk
drivers/usb/misc/adutux.c :  adu_init : leave, return value 0 
usbcore: registered new interface driver appledisplay
usbcore: registered new interface driver cypress_cy7c63
usbcore: registered new interface driver cytherm
cytherm: v1.0:Cypress USB Thermometer driver
usbcore: registered new interface driver emi26 - firmware loader
usbcore: registered new interface driver isight_firmware
usbcore: registered new interface driver usblcd
usbcore: registered new interface driver usbled
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
usbcore: registered new interface driver legousbtower
legousbtower: LEGO USB Tower Driver v0.96
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
usbcore: registered new interface driver phidgetkit
usbcore: registered new interface driver phidgetmotorcontrol
usbcore: registered new interface driver phidgetservo
usbcore: registered new interface driver uss720
uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
uss720: NOTE: this is a special purpose driver to allow nonstandard
uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
uss720: If you just want to connect to a printer, use usblp instead
usbcore: registered new interface driver sisusb
usbcore: registered new interface driver cxacru
[ueagle-atm] driver ueagle 1.4 loaded
usbcore: registered new interface driver ueagle-atm
drivers/usb/atm/usbatm.c: usbatm_usb_init: driver version 1.10
drivers/usb/atm/xusbatm.c: xusbatm_init
xusbatm: malformed module parameters
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:08: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:09: driver attached
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
parkbd: no such parport
pnp: the driver 'ns558' has been registered
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input7
usbcore: registered new interface driver appletouch
usbcore: registered new interface driver bcm5974
logibm.c: Didn't find Logitech busmouse at 0x23c
usbcore: registered new interface driver iforce
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007): Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
aiptek: Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006<6>usbcore: registered new interface driver kbtab
kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
input: PC Speaker as /class/input/input8
wistron_btns: System unknown
usbcore: registered new interface driver ati_remote
ati_remote: Registered USB driver ATI/X10 RF USB Remote Control v. 2.2.1
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.2
usbcore: registered new interface driver keyspan_remote
usbcore: registered new interface driver yealink
yealink: Yealink phone driver:yld-20051230
apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
I2O subsystem v1.325
i2o: max drivers = 8
I2O Configuration OSM v1.323
I2O Bus Adapter OSM v1.317
pnp: the driver 'rtc_cmos' has been registered
rtc_cmos: dev (254:0)
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
rtc_cmos 00:07: driver attached
i2c-core: driver [rtc-ds1374] registered
i2c-core: driver [ds1672] registered
i2c-core: driver [rtc-fm3130] registered
i2c-core: driver [rtc-isl1208] registered
i2c-core: driver [max6900] registered
i2c-core: driver [rtc-rs5c372] registered
i2c-core: driver [rtc-x1205] registered
i2c /dev entries driver
i2c-core: driver [dev_driver] registered
i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
i2c-adapter i2c-0: adapter [SMBus I801 adapter at 18e0] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
i801_smbus 0000:00:1f.3: No response
i2c-dev: adapter [SMBus I801 adapter at 18e0] registered as minor 0
i2c-parport-light: adapter type unspecified
usbcore: registered new interface driver i2c-tiny-usb
i2c-core: driver [ds1682] registered
i2c-core: driver [at24] registered
i2c-core: driver [eeprom] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x50
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x51
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x52
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x53
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x54
i2c-adapter i2c-0: Creating eeprom at 0x54
i2c 0-0054: uevent
eeprom 0-0054: probe
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0054
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x55
i2c-adapter i2c-0: Creating eeprom at 0x55
i2c 0-0055: uevent
eeprom 0-0055: probe
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0055
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x56
i2c-adapter i2c-0: Creating eeprom at 0x56
i2c 0-0056: uevent
eeprom 0-0056: probe
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0056
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x57
i2c-adapter i2c-0: Creating eeprom at 0x57
i2c 0-0057: uevent
eeprom 0-0057: probe
i2c-adapter i2c-0: client [eeprom] registered with bus id 0-0057
i2c-core: driver [pca9539] registered
i2c-core: driver [pcf8574] registered
i2c-core: driver [pcf8575] registered
i2c-core: driver [pcf8591] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4f
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [tsl2550] registered
Driver for 1-wire Dallas network protocol.
usbcore: registered new interface driver DS9490R
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
i2c-core: driver [asb100] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [w83781d] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [w83791d] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [ad7414] registered
i2c-core: driver [ad7418] registered
i2c-core: driver [adm1021] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [adm1025] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [adm1026] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [adm1029] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [adm1031] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [dme1737] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [ds1621] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4f
i801_smbus 0000:00:1f.3: No response
f71882fg: Not a Fintek device
f71882fg: Not a Fintek device
i2c-core: driver [fschmd] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [fscpos] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x73
i801_smbus 0000:00:1f.3: No response
hdaps: inverting axis readings.
hdaps: LENOVO ThinkPad T60 detected.
input: hdaps as /class/input/input9
hdaps: driver successfully loaded.
i2c-core: driver [lm75] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4f
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [lm77] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [lm80] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x28
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [lm83] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [lm85] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [lm87] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [lm92] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x49
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [max1619] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x18
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x19
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x29
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2a
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4c
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4d
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [max6650] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1b
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x1f
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x48
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x4b
i801_smbus 0000:00:1f.3: No response
pc87360: PC8736x not detected, module not inserted.
i2c-core: driver [w83l785ts] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-core: driver [w83l786ng] registered
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2e
i801_smbus 0000:00:1f.3: No response
i2c-adapter i2c-0: found normal entry for adapter 0, addr 0x2f
i801_smbus 0000:00:1f.3: No response
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Bluetooth: HCI USB driver ver 2.10
usbcore: registered new interface driver hci_usb
Bluetooth: Virtual HCI driver ver 1.2
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: Broadcom Blutonium firmware driver ver 1.2
usbcore: registered new interface driver bcm203x
Bluetooth: Digianswer Bluetooth USB driver ver 0.10
usbcore: registered new interface driver bpa10x
Bluetooth: BlueFRITZ! USB driver ver 1.2
usbcore: registered new interface driver bfusb
Bluetooth: Generic Bluetooth SDIO driver ver 0.1
ISDN subsystem Rev: 1.1.2.3/1.1.2.3/1.1.2.2/1.1.2.3/1.1.2.2/1.1.2.2
PPP BSD Compression module registered
CAPI Subsystem Rev 1.1.2.8
capidrv: Rev 1.1.2.2: loaded
b1isa: revision 1.1.2.3
b1: revision 1.1.2.2
b1pci: revision 1.1.2.2
b1dma: revision 1.1.2.3
b1pci: revision 1.1.2.2
t1isa: revision 1.1.2.3
t1pci: revision 1.1.2.2
c4: revision 1.1.2.2
dss1_divert module successfully installed
HiSax: Linux Driver for passive ISDN cards
HiSax: Version 3.5 (kernel)
HiSax: Layer1 Revision 2.46.2.5
HiSax: Layer2 Revision 2.30.2.4
HiSax: TeiMgr Revision 2.20.2.3
HiSax: Layer3 Revision 2.22.2.3
HiSax: LinkLayer Revision 2.59.2.4
HiSax: Total 1 card defined
HiSax: Card 1 Protocol EDSS1 Id=HiSax (0)
HiSax: Traverse Tech. NETspider-U driver Rev. 2.14.2.3
NETspider-U: No PCI card found
HiSax: Card NETspider-U not installed !
hisax_st5481: ST5481 USB ISDN driver $Revision: 2.4.2.3 $
usbcore: registered new interface driver st5481_usb
HFC-S USB: driver module revision 2.3.2.24 date 2007/10/14 loaded, (debug=0)
usbcore: registered new interface driver hfc_usb
HFC-4S/8S: Layer 1 driver module for HFC-4S/8S isdn chips, Revision: 1.10
HFC-4S/8S: (C) 2003 Cornelius Consult, www.cornelius-consult.de
HFC-4S/8S: found 0 cards
PCBIT-D device driver v 0.5-fjpc0 19991204 - Copyright (C) 1996 Universidade de Lisboa
Trying to detect board using default settings
PCBIT: memory region d0000-d1000 already in use
IBM Active 2000 ISDN driver
act2000: No cards defined yet
lguest: mapped switcher at ffc00000
cpuidle: using governor ladder
cpuidle: using governor menu
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
pnp: the driver 'wbsd' has been registered
i2c-core: driver [pca9532] registered
i2c-core: driver [leds-pca955x] registered
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
No iBFT detected.
pktgen v2.70: Packet Generator for packet performance testing.
NET: Registered protocol family 26
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP bic registered
TCP cubic registered
TCP westwood registered
TCP highspeed registered
TCP hybla registered
TCP htcp registered
TCP vegas registered
TCP veno registered
TCP yeah registered
TCP illinois registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
Mobile IPv6
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
ip6tnl0: Disabled Privacy Extensions
NET: Registered protocol family 17
NET: Registered protocol family 4
can: controller area network core (rev 20071116 abi 8)
NET: Registered protocol family 29
IrCOMM protocol (Dag Brattli)
Bluetooth: L2CAP ver 2.10
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: CMTP (CAPI Emulation) ver 1.0
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered rdma transport module.
NET: Registered protocol family 33
lec.c: Aug 18 2008 21:28:11 initialized
mpc.c: Aug 18 2008 21:27:59 initialized
NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
DECnet: Routing cache hash table of 1024 buckets, 32Kbytes
NET: Registered protocol family 12
CCID: Registered CCID 2 (TCP-like)
SCTP: Hash tables configured (established 65536 bind 65536)
sctp_init_sock(sk: f69b8000)
TIPC: Activated (version 1.6.4 compiled Aug 18 2008 21:29:30)
NET: Registered protocol family 30
TIPC: Started in single node mode
Installing 9P2000 support
Using IPI No-Shortcut mode
kAFS: Red Hat AFS client v0.1 registering.
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 568k freed
Write protecting the kernel text: 9636k
Write protecting the kernel read-only data: 3960k
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb 5-2: uevent
usb 5-2:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
found new irq_cfg for irq 2097408
found new irq_desc for irq 2097408
ADDRCONF(NETDEV_UP): eth0: link is not ready
0000:02:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
EXT3 FS on sda1, internal journal
Adding 4096564k swap on /dev/sda2.  Priority:-1 extents:1 across:4096564k
eth0: no IPv6 routers present
warning: `named' uses deprecated v2 capabilities in a way that may be insecure.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc3-tip-00607-g3c311a4-dirty #1
-------------------------------------------------------
Xorg/5359 is trying to acquire lock:
 (cpu_add_remove_lock){--..}, at: [<c0144598>] cpu_maps_update_begin+0x14/0x16

but task is already holding lock:
 (polldev_mutex){--..}, at: [<c078526b>] input_close_polled_device+0x22/0x47

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #5 (polldev_mutex){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
       [<c0785341>] input_open_polled_device+0x1c/0xa3
       [<c0782b6a>] input_open_device+0x5a/0x86
       [<c0788590>] evdev_open+0x103/0x14f
       [<c0783ea3>] input_open_file+0x44/0x60
       [<c01acc9f>] chrdev_open+0xf1/0x108
       [<c01a8f21>] __dentry_open+0x135/0x21f
       [<c01a902f>] nameidata_to_filp+0x24/0x38
       [<c01b3f6d>] do_filp_open+0x351/0x636
       [<c01a8d09>] do_sys_open+0x47/0xbc
       [<c01a8dca>] sys_open+0x23/0x2b
       [<c0116d13>] sysenter_do_call+0x12/0x3f
       [<ffffffff>] 0xffffffff

-> #4 (&dev->mutex){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
       [<c0782d02>] input_register_handle+0x26/0x7a
       [<c04a62c9>] kbd_connect+0x64/0x8d
       [<c0782842>] input_attach_handler+0x38/0x6b
       [<c0784216>] input_register_handler+0x74/0xc3
       [<c0f54e4b>] kbd_init+0x66/0x91
       [<c0f54f7b>] vty_init+0xce/0xd7
       [<c0f54952>] tty_init+0x193/0x197
       [<c010112a>] do_one_initcall+0x42/0x133
       [<c0f2d5cb>] kernel_init+0x16e/0x1d5
       [<c0117c03>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #3 (input_mutex){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
       [<c0783fbe>] input_register_device+0xff/0x17f
       [<c048a889>] acpi_button_add+0x31e/0x429
       [<c04889f4>] acpi_device_probe+0x43/0xde
       [<c052c67f>] driver_probe_device+0xa5/0x120
       [<c052c73c>] __driver_attach+0x42/0x64
       [<c052be91>] bus_for_each_dev+0x43/0x65
       [<c052c507>] driver_attach+0x19/0x1b
       [<c052c251>] bus_add_driver+0x9e/0x1a1
       [<c052c8de>] driver_register+0x76/0xd2
       [<c0488dc3>] acpi_bus_register_driver+0x3f/0x41
       [<c0f51bf2>] acpi_button_init+0x32/0x51
       [<c010112a>] do_one_initcall+0x42/0x133
       [<c0f2d201>] do_async_initcalls+0x1a/0x2a
       [<c0150eec>] run_workqueue+0xc3/0x193
       [<c015195d>] worker_thread+0xbb/0xc7
       [<c0153e2a>] kthread+0x40/0x66
       [<c0117c03>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #2 (async_work){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0150ee7>] run_workqueue+0xbe/0x193
       [<c015195d>] worker_thread+0xbb/0xc7
       [<c0153e2a>] kthread+0x40/0x66
       [<c0117c03>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #1 (kasyncinit){--..}:
       [<c0160f87>] validate_chain+0x831/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0151125>] cleanup_workqueue_thread+0x2b/0x5e
       [<c01511ba>] destroy_workqueue+0x50/0x78
       [<c0f2d5ef>] kernel_init+0x192/0x1d5
       [<c0117c03>] kernel_thread_helper+0x7/0x10
       [<ffffffff>] 0xffffffff

-> #0 (cpu_add_remove_lock){--..}:
       [<c0160d10>] validate_chain+0x5ba/0xaa2
       [<c0161872>] __lock_acquire+0x67a/0x6e0
       [<c0161933>] lock_acquire+0x5b/0x81
       [<c0a6650c>] mutex_lock_nested+0xdb/0x27d
       [<c0144598>] cpu_maps_update_begin+0x14/0x16
       [<c0151190>] destroy_workqueue+0x26/0x78
       [<c0785284>] input_close_polled_device+0x3b/0x47
       [<c0782c3c>] input_close_device+0x45/0x61
       [<c078784d>] evdev_release+0x7f/0x99
       [<c01ab40c>] __fput+0xb3/0x17c
       [<c01ab7cc>] fput+0x1c/0x1e
       [<c01a8cb8>] filp_close+0x55/0x5f
       [<c01a9e88>] sys_close+0x76/0xb2
       [<c0116d13>] sysenter_do_call+0x12/0x3f
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

3 locks held by Xorg/5359:
 #0:  (&evdev->mutex){--..}, at: [<c0787835>] evdev_release+0x67/0x99
 #1:  (&dev->mutex){--..}, at: [<c0782c16>] input_close_device+0x1f/0x61
 #2:  (polldev_mutex){--..}, at: [<c078526b>] input_close_polled_device+0x22/0x47

stack backtrace:
Pid: 5359, comm: Xorg Not tainted 2.6.27-rc3-tip-00607-g3c311a4-dirty #1
 [<c016074b>] print_circular_bug_tail+0x9b/0xa6
 [<c0160d10>] validate_chain+0x5ba/0xaa2
 [<c0161872>] __lock_acquire+0x67a/0x6e0
 [<c0161933>] lock_acquire+0x5b/0x81
 [<c0144598>] ? cpu_maps_update_begin+0x14/0x16
 [<c0a6650c>] mutex_lock_nested+0xdb/0x27d
 [<c0144598>] ? cpu_maps_update_begin+0x14/0x16
 [<c01600fb>] ? trace_hardirqs_on_caller+0xe8/0x11d
 [<c0144598>] ? cpu_maps_update_begin+0x14/0x16
 [<c0144598>] cpu_maps_update_begin+0x14/0x16
 [<c0151190>] destroy_workqueue+0x26/0x78
 [<c0785284>] input_close_polled_device+0x3b/0x47
 [<c0782c3c>] input_close_device+0x45/0x61
 [<c078784d>] evdev_release+0x7f/0x99
 [<c01ab40c>] __fput+0xb3/0x17c
 [<c01ab7cc>] fput+0x1c/0x1e
 [<c01a8cb8>] filp_close+0x55/0x5f
 [<c01a9e88>] sys_close+0x76/0xb2
 [<c0116d13>] sysenter_do_call+0x12/0x3f
 [<c0110000>] ? x86_emulate_insn+0x31fc/0x3a34
 =======================
