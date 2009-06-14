Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbZFNNd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbZFNNd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 09:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbZFNNds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 09:33:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:51216 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754078AbZFNNdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 09:33:44 -0400
X-Authenticated: #3576790
X-Provags-ID: V01U2FsdGVkX1+NeiBvwt6Nrir5O+Xzh1j1XKElb98foqW19Z3g+2
	4/MSsgEGGmsur9
Date: Sun, 14 Jun 2009 15:35:53 +0200
From: "Benjamin S." <sbenni@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, js@sig21.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.30 enabling cpu1 on resume fails after suspend to memory
Message-ID: <20090614153553.5c188506@pluto-lenny.milky.way>
In-Reply-To: <alpine.LFD.2.00.0906141503160.2800@localhost.localdomain>
References: <20090614120950.116536fa@pluto-lenny.milky.way>
	<200906141400.27331.rjw@sisk.pl>
	<alpine.LFD.2.00.0906141405450.2800@localhost.localdomain>
	<200906141415.16949.rjw@sisk.pl>
	<20090614143708.32ec250c@pluto-lenny.milky.way>
	<alpine.LFD.2.00.0906141440440.2800@localhost.localdomain>
	<20090614145910.71c5cd5d@pluto-lenny.milky.way>
	<alpine.LFD.2.00.0906141503160.2800@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 15:05:41 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Sun, 14 Jun 2009, Benjamin S. wrote:
> > On Sun, 14 Jun 2009 14:43:11 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> > 
> > > On Sun, 14 Jun 2009, Benjamin S. wrote:
> > > >  19:          0         17   IO-APIC-fasteoi   ehci_hcd:usb4, HDA Intel
> > > >  24:       4830          0  HPET_MSI-edge      hpet2
> > > 
> > > This is probably the culprit. Try booting with hpet=disble and check
> > > whether your resume works.
> > 
> > With this option set resume works.
> 
> That's what I expected.
> 
> Can you boot w/o that option again and provide the full boot log of
> the machine ? 

Output of dmesg -s 10000000 | grep -v "PM: Adding info":

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30 (root@censored) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #5 SMP Sun Jun 14 14:41:36 CEST 2009
[    0.000000] Command line: root=/dev/mapper/linux-amd64root resume=/dev/sda1 selinux=0 acpi_sleep=s3_bios no_console_suspend
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000bfee0000 - 00000000bfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfef0000 - 00000000bff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FF80000000 write-back
[    0.000000]   1 base 0080000000 mask FFC0000000 write-back
[    0.000000]   2 base 00BFF00000 mask FFFFF00000 uncachable
[    0.000000]   3 base 0100000000 mask FFE0000000 write-back
[    0.000000]   4 base 0120000000 mask FFF0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000130000000 aka 4864M
[    0.000000] e820 update range: 00000000bff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfee0 max_arch_pfn = 0x100000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bfee0000 (usable)
[    0.000000]  modified: 00000000bfee0000 - 00000000bfee3000 (ACPI NVS)
[    0.000000]  modified: 00000000bfee3000 - 00000000bfef0000 (ACPI data)
[    0.000000]  modified: 00000000bfef0000 - 00000000bff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfee0000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfee0000 page 4k
[    0.000000] kernel direct mapping tables up to bfee0000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ b000-11000
[    0.000000] RAMDISK: 37b55000 - 37fef553
[    0.000000] ACPI: RSDP 00000000000f71c0 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000bfee3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 00000000bfee3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 00000000bfee30c0 06550 (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bfee0000 00040
[    0.000000] ACPI: SSDT 00000000bfee9700 0028A (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000bfee99c0 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 00000000bfee9a00 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 00000000bfee9640 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000000000c000 - 000000000003ffff]
[    0.000000]   bootmap [0000000000040000 -  0000000000065fff] pages 26
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0004df42cc]    TEXT DATA BSS ==> [0000200000 - 0004df42cc]
[    0.000000]   #3 [0037b55000 - 0037fef553]          RAMDISK ==> [0037b55000 - 0037fef553]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
[    0.000000]   #5 [0004df5000 - 0004df50fe]              BRK ==> [0004df5000 - 0004df50fe]
[    0.000000]   #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #7 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
[    0.000000] found SMP MP-table at [ffff8800000f5840] f5840
[    0.000000]  [ffffe20000000000-ffffe200043fffff] PMD -> [ffff880028200000-ffff88002b7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfee0
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 982650
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3835 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767768 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfee0000 - 00000000bfee3000
[    0.000000] PM: Registered nosave memory: 00000000bfee3000 - 00000000bfef0000
[    0.000000] PM: Registered nosave memory: 00000000bfef0000 - 00000000bff00000
[    0.000000] PM: Registered nosave memory: 00000000bff00000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: bff00000:20100000)
[    0.000000] NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028022000, static data 73632 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 965523
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/mapper/linux-amd64root resume=/dev/sda1 selinux=0 acpi_sleep=s3_bios no_console_suspend
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:4352
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2504.956 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Node 0: aperture @ 20000000 size 32 MB
[    0.004000] Aperture pointing to e820 RAM. Ignoring.
[    0.004000] Your BIOS doesn't leave a aperture memory hole
[    0.004000] Please enable the IOMMU option in the BIOS setup
[    0.004000] This costs you 64 MB of RAM
[    0.004000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.004000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.004000] Memory: 3717652k/4980736k available (3101k kernel code, 1050136k absent, 212948k reserved, 1442k data, 1428k init)
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.004009] Calibrating delay loop (skipped), value calculated using timer frequency.. 5009.91 BogoMIPS (lpj=10019824)
[    0.004766] Security Framework initialized
[    0.004808] SELinux:  Disabled at boot.
[    0.005307] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.008020] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.009286] Mount-cache hash table entries: 256
[    0.009700] Initializing cgroup subsys ns
[    0.009737] Initializing cgroup subsys cpuacct
[    0.009775] Initializing cgroup subsys devices
[    0.009922] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.009960] CPU: L2 Cache: 512K (64 bytes/line)
[    0.009996] CPU 0/0x0 -> Node 0
[    0.010031] tseg: 00bff00000
[    0.010033] CPU: Physical Processor ID: 0
[    0.010069] CPU: Processor Core ID: 0
[    0.010112] using C1E aware idle routine
[    0.010715] ACPI: Core revision 20090320
[    0.020084] Setting APIC routing to flat
[    0.020942] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061987] CPU0: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5010.68 BogoMIPS (lpj=10021374)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.148196] CPU1: AMD Athlon(tm) Dual Core Processor 4850e stepping 02
[    0.148542] Brought up 2 CPUs
[    0.148579] Total of 2 processors activated (10020.59 BogoMIPS).
[    0.148819] CPU0 attaching sched-domain:
[    0.148822]  domain 0: span 0-1 level CPU
[    0.148825]   groups: 0 1
[    0.148830] CPU1 attaching sched-domain:
[    0.148832]  domain 0: span 0-1 level CPU
[    0.148834]   groups: 1 0
[    0.148902] net_namespace: 1920 bytes
[    0.148902] Booting paravirtualized kernel on bare hardware
[    0.148902] Time: 13:13:35  Date: 06/14/09
[    0.148902] NET: Registered protocol family 16
[    0.148902] node 0 link 0: io port [c000, ffff]
[    0.148902] TOM: 00000000d0000000 aka 3328M
[    0.148902] node 0 link 0: mmio [a0000, bffff]
[    0.148902] node 0 link 0: mmio [d0000000, fe02ffff]
[    0.148902] node 0 link 0: mmio [e0000000, efffffff]
[    0.148902] TOM2: 0000000130000000 aka 4864M
[    0.148902] bus: [00,03] on node 0 link 0
[    0.148902] bus: 00 index 0 io port: [0, ffff]
[    0.148902] bus: 00 index 1 mmio: [a0000, bffff]
[    0.148902] bus: 00 index 2 mmio: [d0000000, ffffffff]
[    0.148902] bus: 00 index 3 mmio: [130000000, fcffffffff]
[    0.148902] ACPI: bus type pci registered
[    0.148902] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.148902] PCI: MCFG area at e0000000 reserved in E820
[    0.155476] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.155517] PCI: Using configuration type 1 for base access
[    0.156314] bio: create slab <bio-0> at 0
[    0.156611] ACPI: EC: Look up EC in DSDT
[    0.167821] ACPI: Interpreter enabled
[    0.167864] ACPI: (supports S0 S3 S4 S5)
[    0.168044] ACPI: Using IOAPIC for interrupt routing
[    0.173623] ACPI: No dock devices found.
[    0.173623] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.173623] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
[    0.173623] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.173623] pci 0000:00:0a.0: PME# disabled
[    0.176061] pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
[    0.176069] pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
[    0.176076] pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
[    0.176083] pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
[    0.176091] pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
[    0.176098] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
[    0.176117] pci 0000:00:11.0: set SATA to AHCI mode
[    0.176207] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
[    0.176265] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.176340] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
[    0.176394] pci 0000:00:12.2: supports D1 D2
[    0.176396] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.176435] pci 0000:00:12.2: PME# disabled
[    0.176505] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.176563] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.176639] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.176693] pci 0000:00:13.2: supports D1 D2
[    0.176695] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.176734] pci 0000:00:13.2: PME# disabled
[    0.176892] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.176899] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.176906] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.176913] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.176920] pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
[    0.176990] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
[    0.177034] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.177073] pci 0000:00:14.2: PME# disabled
[    0.177218] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
[    0.177352] pci 0000:01:05.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
[    0.177357] pci 0000:01:05.0: reg 14 io port: [0xee00-0xeeff]
[    0.177361] pci 0000:01:05.0: reg 18 32bit mmio: [0xfdfe0000-0xfdfeffff]
[    0.177369] pci 0000:01:05.0: reg 24 32bit mmio: [0xfde00000-0xfdefffff]
[    0.177382] pci 0000:01:05.0: supports D1 D2
[    0.177403] pci 0000:01:05.1: reg 10 32bit mmio: [0xfdffc000-0xfdffffff]
[    0.177424] pci 0000:01:05.1: supports D1 D2
[    0.177467] pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
[    0.177471] pci 0000:00:01.0: bridge 32bit mmio: [0xfde00000-0xfdffffff]
[    0.177475] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.177512] pci 0000:02:00.0: reg 10 io port: [0xde00-0xdeff]
[    0.177528] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdaff000-0xfdafffff]
[    0.177539] pci 0000:02:00.0: reg 20 64bit mmio: [0xfdae0000-0xfdaeffff]
[    0.177547] pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.177577] pci 0000:02:00.0: supports D1 D2
[    0.177579] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.177618] pci 0000:02:00.0: PME# disabled
[    0.177712] pci 0000:00:0a.0: bridge io port: [0xd000-0xdfff]
[    0.177715] pci 0000:00:0a.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.177720] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfda00000-0xfdafffff]
[    0.177780] pci 0000:00:14.4: transparent bridge
[    0.177819] pci 0000:00:14.4: bridge io port: [0xc000-0xcfff]
[    0.177824] pci 0000:00:14.4: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
[    0.177829] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfdb00000-0xfdbfffff]
[    0.177847] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.178189] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.178315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.178391] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.209535] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.209535] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.209535] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.209689] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.212221] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.212741] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.213261] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.213782] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.214214] usbcore: registered new interface driver usbfs
[    0.214214] usbcore: registered new interface driver hub
[    0.214214] usbcore: registered new device driver usb
[    0.214214] PCI: Using ACPI for IRQ routing
[    0.214214] pci 0000:00:00.0: BAR 3: can't allocate resource
[    0.228140] PCI-DMA: Disabling AGP.
[    0.228250] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.228250] PCI-DMA: using GART IOMMU.
[    0.228250] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.228625] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.228818] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.232043] hpet: hpet2 irq 24 for MSI
[    0.236025] Switched to high resolution mode on CPU 0
[    0.236433] Switched to high resolution mode on CPU 1
[    0.252021] pnp: PnP ACPI init
[    0.252075] ACPI: bus type pnp registered
[    0.255668] pnp 00:0b: mem resource (0xd1000-0xd3fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.255713] pnp 00:0b: mem resource (0xf0000-0xf7fff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.255757] pnp 00:0b: mem resource (0xf8000-0xfbfff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.255801] pnp 00:0b: mem resource (0xfc000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.255844] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.255887] pnp 00:0b: mem resource (0x100000-0xbfedffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
[    0.256099] pnp: PnP ACPI: found 12 devices
[    0.256137] ACPI: ACPI bus type pnp unregistered
[    0.256186] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.256226] system 00:01: ioport range 0x220-0x225 has been reserved
[    0.256265] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.256308] system 00:02: ioport range 0x4100-0x411f has been reserved
[    0.256347] system 00:02: ioport range 0x228-0x22f has been reserved
[    0.256387] system 00:02: ioport range 0x238-0x23f has been reserved
[    0.256427] system 00:02: ioport range 0x40b-0x40b has been reserved
[    0.256466] system 00:02: ioport range 0x4d6-0x4d6 has been reserved
[    0.256509] system 00:02: ioport range 0xc00-0xc01 has been reserved
[    0.256550] system 00:02: ioport range 0xc14-0xc14 has been reserved
[    0.256589] system 00:02: ioport range 0xc50-0xc52 has been reserved
[    0.256628] system 00:02: ioport range 0xc6c-0xc6d has been reserved
[    0.256666] system 00:02: ioport range 0xc6f-0xc6f has been reserved
[    0.256706] system 00:02: ioport range 0xcd0-0xcd1 has been reserved
[    0.256745] system 00:02: ioport range 0xcd2-0xcd3 has been reserved
[    0.256785] system 00:02: ioport range 0xcd4-0xcdf has been reserved
[    0.256825] system 00:02: ioport range 0x4000-0x40fe has been reserved
[    0.256865] system 00:02: ioport range 0x4210-0x4217 has been reserved
[    0.256904] system 00:02: ioport range 0xb00-0xb0f has been reserved
[    0.256943] system 00:02: ioport range 0xb10-0xb1f has been reserved
[    0.256983] system 00:02: ioport range 0xb20-0xb3f has been reserved
[    0.257028] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.257070] system 00:0b: iomem range 0xbfee0000-0xbfefffff could not be reserved
[    0.257115] system 00:0b: iomem range 0xffff0000-0xffffffff has been reserved
[    0.257154] system 00:0b: iomem range 0xbfff0000-0xcffeffff has been reserved
[    0.257194] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.257233] system 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.257273] system 00:0b: iomem range 0xfff80000-0xfffeffff has been reserved
[    0.262366] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.262404] pci 0000:00:01.0:   IO window: 0xe000-0xefff
[    0.262443] pci 0000:00:01.0:   MEM window: 0xfde00000-0xfdffffff
[    0.262480] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.262524] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    0.262561] pci 0000:00:0a.0:   IO window: 0xd000-0xdfff
[    0.262599] pci 0000:00:0a.0:   MEM window: 0xfdd00000-0xfddfffff
[    0.262638] pci 0000:00:0a.0:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
[    0.262679] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
[    0.262717] pci 0000:00:14.4:   IO window: 0xc000-0xcfff
[    0.262757] pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
[    0.262797] pci 0000:00:14.4:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
[    0.262859] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.262896] pci 0000:00:0a.0: setting latency timer to 64
[    0.262905] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.262907] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.262910] pci_bus 0000:01: resource 0 io:  [0xe000-0xefff]
[    0.262913] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdffffff]
[    0.262916] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.262918] pci_bus 0000:02: resource 0 io:  [0xd000-0xdfff]
[    0.262921] pci_bus 0000:02: resource 1 mem: [0xfdd00000-0xfddfffff]
[    0.262924] pci_bus 0000:02: resource 2 pref mem [0xfda00000-0xfdafffff]
[    0.262926] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    0.262929] pci_bus 0000:03: resource 1 mem: [0xfdc00000-0xfdcfffff]
[    0.262931] pci_bus 0000:03: resource 2 pref mem [0xfdb00000-0xfdbfffff]
[    0.262934] pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
[    0.262937] pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.263243] NET: Registered protocol family 2
[    0.308277] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.310182] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.314115] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.314654] TCP: Hash tables configured (established 524288 bind 65536)
[    0.314692] TCP reno registered
[    0.324252] NET: Registered protocol family 1
[    0.324359] Trying to unpack rootfs image as initramfs...
[    0.465416] Freeing initrd memory: 4713k freed
[    0.468985] Scanning for low memory corruption every 60 seconds
[    0.469586] audit: initializing netlink socket (disabled)
[    0.469639] type=2000 audit(1244985215.468:1): initialized
[    0.470087] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.470553] VFS: Disk quotas dquot_6.5.2
[    0.470673] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.470826] msgmni has been set to 7270
[    0.471129] alg: No test for stdrng (krng)
[    0.471315] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.471356] io scheduler noop registered
[    0.471392] io scheduler anticipatory registered
[    0.471427] io scheduler deadline registered
[    0.471579] io scheduler cfq registered (default)
[    1.300028] pci 0000:00:12.1: OHCI: BIOS handoff failed (BIOS bug?) 00000184
[    1.384050] pci 0000:01:05.0: Boot video device
[    1.384359] pcieport-driver 0000:00:0a.0: irq 25 for MSI/MSI-X
[    1.384369] pcieport-driver 0000:00:0a.0: setting latency timer to 64
[    1.388929] Linux agpgart interface v0.103
[    1.388968] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.391489] brd: module loaded
[    1.391731] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.391768] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.391962] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.392136] mice: PS/2 mouse device common for all mice
[    1.392246] rtc_cmos 00:05: RTC can wake from S4
[    1.392359] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.392432] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.392528] cpuidle: using governor ladder
[    1.392564] cpuidle: using governor menu
[    1.392602] No iBFT detected.
[    1.393015] TCP cubic registered
[    1.393051] NET: Registered protocol family 17
[    1.393260] PM: Checking image partition /dev/sda1
[    1.409175] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.409230] PM: Resume from disk failed.
[    1.409238] registered taskstats version 1
[    1.409428]   Magic number: 13:596:230
[    1.409552] rtc_cmos 00:05: setting system clock to 2009-06-14 13:13:37 UTC (1244985217)
[    1.409665] Freeing unused kernel memory: 1428k freed
[    2.875517] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    2.875577] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.875630] r8169 0000:02:00.0: setting latency timer to 64
[    2.875699] r8169 0000:02:00.0: irq 26 for MSI/MSI-X
[    2.875989] eth0: RTL8168c/8111c at 0xffffc20000668000, 00:1f:d0:53:f6:89, XID 3c4000c0 IRQ 26
[    2.895443] SCSI subsystem initialized
[    2.911513] libata version 3.00 loaded.
[    2.912355] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.918585] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.918626] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    2.918713] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.918766] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.918900] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 1
[    2.918990] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    2.965192] Uniform Multi-Platform E-IDE driver
[    2.982212] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.982254] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.982294] usb usb1: Product: OHCI Host Controller
[    2.982331] usb usb1: Manufacturer: Linux 2.6.30 ohci_hcd
[    2.982367] usb usb1: SerialNumber: 0000:00:12.0
[    2.984136] usb usb1: configuration #1 chosen from 1 choice
[    2.984210] hub 1-0:1.0: USB hub found
[    2.984256] hub 1-0:1.0: 3 ports detected
[    2.984527] ahci 0000:00:11.0: version 3.0
[    2.984554] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.984651] ahci 0000:00:11.0: irq 27 for MSI/MSI-X
[    2.984757] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.984799] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    2.985233] scsi0 : ahci
[    2.985502] scsi1 : ahci
[    2.985601] scsi2 : ahci
[    2.985696] scsi3 : ahci
[    2.985855] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 27
[    2.985897] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 27
[    2.985938] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 27
[    2.985979] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 27
[    2.986155] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.986217] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.986348] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 2
[    2.986418] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    2.986475] ehci_hcd 0000:00:12.2: debug port 1
[    2.986539] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    2.997028] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.997095] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.997133] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.997173] usb usb2: Product: EHCI Host Controller
[    2.997209] usb usb2: Manufacturer: Linux 2.6.30 ehci_hcd
[    2.997245] usb usb2: SerialNumber: 0000:00:12.2
[    2.997357] usb usb2: configuration #1 chosen from 1 choice
[    2.997429] hub 2-0:1.0: USB hub found
[    2.997473] hub 2-0:1.0: 6 ports detected
[    2.997685] atiixp 0000:00:14.1: IDE controller (0x1002:0x439c rev 0x00)
[    2.997733] ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.997792] atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
[    2.997833]     ide0: BM-DMA at 0xfa00-0xfa07
[    2.997876]     ide1: BM-DMA at 0xfa08-0xfa0f
[    2.997916] Probing IDE interface ide0...
[    3.304533] ata2: SATA link down (SStatus 0 SControl 300)
[    3.304600] ata1: SATA link down (SStatus 0 SControl 300)
[    3.304659] ata4: SATA link down (SStatus 0 SControl 300)
[    3.304721] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.305522] ata3.00: HPA detected: current 1250261615, native 1250263728
[    3.305562] ata3.00: ATA-8: WDC WD6400AAKS-00A7B0, 01.03B01, max UDMA/133
[    3.305599] ata3.00: 1250261615 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    3.306504] ata3.00: configured for UDMA/133
[    3.320656] scsi 2:0:0:0: Direct-Access     ATA      WDC WD6400AAKS-0 01.0 PQ: 0 ANSI: 5
[    3.384785] Driver 'sd' needs updating - please use bus_type methods
[    3.384969] sd 2:0:0:0: [sda] 1250261615 512-byte hardware sectors: (640 GB/596 GiB)
[    3.385023] sd 2:0:0:0: [sda] Write Protect is off
[    3.385060] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.385082] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.385217]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[    3.455515] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.684523] usb 1-3: new full speed USB device using ohci_hcd and address 2
[    3.851268] usb 1-3: New USB device found, idVendor=04a9, idProduct=220e
[    3.851309] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.851347] usb 1-3: Product: CanoScan
[    3.851383] usb 1-3: Manufacturer: Canon
[    3.851505] usb 1-3: configuration #1 chosen from 1 choice
[    4.084035] hdb: HL-DT-ST DVDRAM GSA-4163B, ATAPI CD/DVD-ROM drive
[    4.084188] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.084989] hdb: UDMA/33 mode selected
[    4.085470] Probing IDE interface ide1...
[    4.652085] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.655846] ide1 at 0x170-0x177,0x376 on irq 15
[    4.658608] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.658667] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    4.658779] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 3
[    4.658837] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    4.681949] ide-cd driver 5.00
[    4.684497] ide-cd: hdb: ATAPI 40X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
[    4.684725] Uniform CD-ROM driver Revision: 3.20
[    4.720035] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    4.720076] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.720116] usb usb3: Product: OHCI Host Controller
[    4.720152] usb usb3: Manufacturer: Linux 2.6.30 ohci_hcd
[    4.720188] usb usb3: SerialNumber: 0000:00:12.1
[    4.720293] usb usb3: configuration #1 chosen from 1 choice
[    4.720366] hub 3-0:1.0: USB hub found
[    4.720412] hub 3-0:1.0: 3 ports detected
[    4.748062] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.748123] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    4.748252] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    4.748322] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    4.748379] ehci_hcd 0000:00:13.2: debug port 1
[    4.748446] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    4.760749] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    4.760816] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    4.760854] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.760893] usb usb4: Product: EHCI Host Controller
[    4.760931] usb usb4: Manufacturer: Linux 2.6.30 ehci_hcd
[    4.760967] usb usb4: SerialNumber: 0000:00:13.2
[    4.761086] usb usb4: configuration #1 chosen from 1 choice
[    4.761158] hub 4-0:1.0: USB hub found
[    4.761202] hub 4-0:1.0: 6 ports detected
[    4.761837] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.761899] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    4.762025] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    4.762108] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    4.824057] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    4.824099] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.824140] usb usb5: Product: OHCI Host Controller
[    4.824176] usb usb5: Manufacturer: Linux 2.6.30 ohci_hcd
[    4.824212] usb usb5: SerialNumber: 0000:00:13.0
[    4.824337] usb usb5: configuration #1 chosen from 1 choice
[    4.824416] hub 5-0:1.0: USB hub found
[    4.824462] hub 5-0:1.0: 3 ports detected
[    4.824718] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.824779] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    4.824880] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    4.824943] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    4.888033] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    4.888076] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.888119] usb usb6: Product: OHCI Host Controller
[    4.888156] usb usb6: Manufacturer: Linux 2.6.30 ohci_hcd
[    4.888195] usb usb6: SerialNumber: 0000:00:13.1
[    4.888329] usb usb6: configuration #1 chosen from 1 choice
[    4.888409] hub 6-0:1.0: USB hub found
[    4.888457] hub 6-0:1.0: 3 ports detected
[    4.919593] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    4.919651] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    4.919764] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    4.919825] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    4.976030] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.976067] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.976107] usb usb7: Product: OHCI Host Controller
[    4.976143] usb usb7: Manufacturer: Linux 2.6.30 ohci_hcd
[    4.976179] usb usb7: SerialNumber: 0000:00:14.5
[    4.976264] usb usb7: configuration #1 chosen from 1 choice
[    4.976333] hub 7-0:1.0: USB hub found
[    4.976376] hub 7-0:1.0: 2 ports detected
[    5.162632] device-mapper: uevent: version 1.0.3
[    5.169353] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    5.224550] usb 3-1: new full speed USB device using ohci_hcd and address 2
[    5.340715] PM: Starting manual resume from disk
[    5.340753] PM: Resume from partition 8:1
[    5.340754] PM: Checking hibernation image.
[    5.340927] PM: Resume from disk failed.
[    5.356901] REISERFS (device dm-0): found reiserfs format "3.6" with standard journal
[    5.356961] REISERFS (device dm-0): using ordered data mode
[    5.366455] REISERFS (device dm-0): journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[    5.367642] REISERFS (device dm-0): checking transaction log (dm-0)
[    5.391074] usb 3-1: New USB device found, idVendor=1532, idProduct=00fb
[    5.391112] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.391150] usb 3-1: Product: Habu Mouse
[    5.391185] usb 3-1: Manufacturer: Tempest
[    5.391319] usb 3-1: configuration #1 chosen from 1 choice
[    5.408920] REISERFS (device dm-0): Using r5 hash to sort names
[    5.439672] usbcore: registered new interface driver hiddev
[    5.447170] input: Tempest Habu Mouse as /class/input/input1
[    5.447279] generic-usb 0003:1532:00FB.0001: input,hidraw0: USB HID v1.00 Mouse [Tempest Habu Mouse] on usb-0000:00:12.1-1/input0
[    5.447341] usbcore: registered new interface driver usbhid
[    5.447378] usbhid: v2.6:USB HID core driver
[    6.219883] udevd version 125 started
[    8.259023] processor ACPI_CPU:00: registered as cooling_device0
[    8.259121] processor ACPI_CPU:01: registered as cooling_device1
[    8.268635] input: Power Button as /class/input/input2
[    8.268723] ACPI: Power Button [PWRF]
[    8.268850] input: Power Button as /class/input/input3
[    8.268916] ACPI: Power Button [PWRB]
[    8.815058] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    8.872793] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.876416] input: PC Speaker as /class/input/input4
[    9.115622] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    9.115690] HDA Intel 0000:01:05.1: setting latency timer to 64
[   10.374608] Adding 7823612k swap on /dev/sda1.  Priority:-1 extents:1 across:7823612k 
[   16.399467] it87: Found IT8718F chip at 0x228, revision 5
[   16.399517] it87: in3 is VCC (+5V)
[   16.422739] loop: module loaded
[   17.114830] fuse init (API version 7.11)
[   17.146400] REISERFS (device sda7): found reiserfs format "3.6" with standard journal
[   17.146474] REISERFS (device sda7): using ordered data mode
[   17.157346] REISERFS (device sda7): journal params: device sda7, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   17.158522] REISERFS (device sda7): checking transaction log (sda7)
[   17.179225] REISERFS (device sda7): Using r5 hash to sort names
[   17.267465] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   17.268296] REISERFS (device dm-1): found reiserfs format "3.6" with standard journal
[   17.268371] REISERFS (device dm-1): using ordered data mode
[   17.279246] REISERFS (device dm-1): journal params: device dm-1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   17.280577] REISERFS (device dm-1): checking transaction log (dm-1)
[   17.313046] REISERFS (device dm-1): Using r5 hash to sort names
[   17.381308] REISERFS (device sda11): found reiserfs format "3.6" with standard journal
[   17.381395] REISERFS (device sda11): using ordered data mode
[   17.385810] REISERFS (device sda11): journal params: device sda11, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   17.386998] REISERFS (device sda11): checking transaction log (sda11)
[   17.448491] REISERFS (device sda11): Using r5 hash to sort names
[   18.711574] r8169: eth0: link up
[   18.711623] r8169: eth0: link up
[   19.441585] powernow-k8: Found 1 AMD Athlon(tm) Dual Core Processor 4850e processors (2 cpu cores) (version 2.20.00)
[   19.441675] powernow-k8:    0 : fid 0x11 (2500 MHz), vid 0xc
[   19.441678] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xd
[   19.441681] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xf
[   19.441683] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0x11
[   19.441686] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x13
[   19.441688] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x16
[   20.026538] NET: Registered protocol family 10
[   20.027427] lo: Disabled Privacy Extensions
[   21.000524] Clocksource tsc unstable (delta = -271091052 ns)
[   42.672021] eth0: no IPv6 routers present



> 
> Can you please provide the output of /proc/timer_list as well ?

Timer List Version: v0.4
HRTIMER_MAX_CLOCK_BASES: 2
now at 736274227327 nsecs

cpu: 0
 clock 0:
  .base:       ffff8800280300d8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1244985215741876327 nsecs
active timers:
 clock 1:
  .base:       ffff880028030118
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff8800280301a0>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 736276000000-736276000000 nsecs [in 1772673 to 1772673 nsecs]
 #1: <ffff88012a449908>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, atieventsd/2460
 # expires at 736624758887-736625758882 nsecs [in 350531560 to 351531555 nsecs]
 #2: <ffff88012352fa68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gnome-panel/3397
 # expires at 736895465468-736899463465 nsecs [in 621238141 to 625236138 nsecs]
 #3: <ffffffff808fcb78>, sched_rt_period_timer, S:01, enqueue_task_rt, swapper/1
 # expires at 737000000000-737000000000 nsecs [in 725772673 to 725772673 nsecs]
 #4: <ffff88012a727928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, dhcdbd/2839
 # expires at 737072827575-737073827573 nsecs [in 798600248 to 799600246 nsecs]
 #5: <ffff880125179a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, nautilus/3396
 # expires at 739759355396-739763355394 nsecs [in 3485128069 to 3489128067 nsecs]
 #6: <ffff88012f705928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, init/1
 # expires at 740806378202-740811378200 nsecs [in 4532150875 to 4537150873 nsecs]
 #7: <ffff88011740fd68>, hrtimer_wakeup, S:01, futex_wait, rsyslogd/6739
 # expires at 745503371822-745503421822 nsecs [in 9229144495 to 9229194495 nsecs]
 #8: <ffff880127d09e98>, hrtimer_wakeup, S:01, do_nanosleep, cron/3010
 # expires at 745503896888-745503946888 nsecs [in 9229669561 to 9229719561 nsecs]
 #9: <ffff88012f77ac28>, it_real_fn, S:01, do_setitimer, exim4/2737
 # expires at 1821936700883-1821936700883 nsecs [in 1085662473556 to 1085662473556 nsecs]
 #10: <ffff880127c85e98>, hrtimer_wakeup, S:01, do_nanosleep, atd/2990
 # expires at 3625291670995-3625291720995 nsecs [in 2889017443668 to 2889017493668 nsecs]
  .expires_next   : 736276000000 nsecs
  .hres_active    : 1
  .nr_events      : 29719
  .nohz_mode      : 2
  .idle_tick      : 736100000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4295076320
  .idle_calls     : 31862
  .idle_sleeps    : 4970
  .idle_entrytime : 736272074260 nsecs
  .idle_waketime  : 736072744463 nsecs
  .idle_exittime  : 736269252881 nsecs
  .idle_sleeptime : 710305309436 nsecs
  .last_jiffies   : 4295076364
  .next_jiffies   : 4295076750
  .idle_expires   : 737816000000 nsecs
jiffies: 4295076364

cpu: 1
 clock 0:
  .base:       ffff8800280490d8
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1244985215741876327 nsecs
active timers:
 clock 1:
  .base:       ffff880028049118
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <ffff8800280491a0>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 736276500000-736276500000 nsecs [in 2272673 to 2272673 nsecs]
 #1: <ffff88012246fa68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gnome-terminal/3409
 # expires at 736279195459-736279245459 nsecs [in 4968132 to 5018132 nsecs]
 #2: <ffff880127cc7928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, Xorg/3148
 # expires at 736282598303-736282648303 nsecs [in 8370976 to 8420976 nsecs]
 #3: <ffff88011745bd68>, hrtimer_wakeup, S:01, futex_wait, firefox-bin/6790
 # expires at 736476683651-736476733651 nsecs [in 202456324 to 202506324 nsecs]
 #4: <ffff880121523a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gnome-volume-ma/3436
 # expires at 736646362697-736661359695 nsecs [in 372135370 to 387132368 nsecs]
 #5: <ffff8801226ffa68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, nm-applet/3430
 # expires at 737064276905-737065276903 nsecs [in 790049578 to 791049576 nsecs]
 #6: <ffff88012a46f928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gpm/2748
 # expires at 737424727522-737426727520 nsecs [in 1150500195 to 1152500193 nsecs]
 #7: <ffff88012168da68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, mapping-daemon/3482
 # expires at 738874811188-738879811186 nsecs [in 2600583861 to 2605583859 nsecs]
 #8: <ffff8801235afa68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, update-notifier/3402
 # expires at 739039659163-739044659161 nsecs [in 2765431836 to 2770431834 nsecs]
 #9: <ffff88012a8ab928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, rsyslogd/2386
 # expires at 740230548716-740260548714 nsecs [in 3956321389 to 3986321387 nsecs]
 #10: <ffff880121481a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gnome-power-man/3433
 # expires at 742225613735-742235613733 nsecs [in 5951386408 to 5961386406 nsecs]
 #11: <ffff88012a44fa68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, kerneloops/2757
 # expires at 744258639187-744268636185 nsecs [in 7984411860 to 7994408858 nsecs]
 #12: <ffff88012a7efa68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, hald/2856
 # expires at 744258820519-744281430517 nsecs [in 7984593192 to 8007203190 nsecs]
 #13: <ffff88011c83bd68>, hrtimer_wakeup, S:01, futex_wait, firefox-bin/6887
 # expires at 744400637095-744400687095 nsecs [in 8126409768 to 8126459768 nsecs]
 #14: <ffff880117465d68>, hrtimer_wakeup, S:01, futex_wait, firefox-bin/6904
 # expires at 744634742628-744634792628 nsecs [in 8360515301 to 8360565301 nsecs]
 #15: <ffff880125001a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gconfd-2/3246
 # expires at 745747229463-745777179460 nsecs [in 9473002136 to 9502952133 nsecs]
 #16: <ffff8801236b9a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, claws-mail/3401
 # expires at 755725526116-755781188114 nsecs [in 19451298789 to 19506960787 nsecs]
 #17: <ffff880123413a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gnome-screensav/3394
 # expires at 796270864748-796330864746 nsecs [in 59996637421 to 60056637419 nsecs]
 #18: <ffff88012a9dda68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, avahi-daemon/2420
 # expires at 900278097575-900378097575 nsecs [in 164003870248 to 164103870248 nsecs]
 #19: <ffff88012a9b7a68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, dbus-daemon/2408
 # expires at 1006629948119-1006729948119 nsecs [in 270355720792 to 270455720792 nsecs]
 #20: <ffff88012a5cfe98>, hrtimer_wakeup, S:01, do_nanosleep, smartd/2806
 # expires at 1823199913166-1823199963166 nsecs [in 1086925685839 to 1086925735839 nsecs]
 #21: <ffff88012a5fd928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, dhclient/3065
 # expires at 3213258126398-3213358126398 nsecs [in 2476983899071 to 2477083899071 nsecs]
 #22: <ffff880127d1d928>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, gdm/3146
 # expires at 43587292842784-43587392842784 nsecs [in 42851018615457 to 42851118615457 nsecs]
 #23: <ffff88011750da68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, firefox-bin/6776
 # expires at 4295688772253740-4295688872253740 nsecs [in 4294952498026413 to 4294952598026413 nsecs]
 #24: <ffff88011750ba68>, hrtimer_wakeup, S:01, schedule_hrtimeout_range, firefox-bin/6749
 # expires at 4295703194321870-4295703294321870 nsecs [in 4294966920094543 to 4294967020094543 nsecs]
  .expires_next   : 736276500000 nsecs
  .hres_active    : 1
  .nr_events      : 35402
  .nohz_mode      : 2
  .idle_tick      : 736272500000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4295076363
  .idle_calls     : 49048
  .idle_sleeps    : 19565
  .idle_entrytime : 736271009948 nsecs
  .idle_waketime  : 736269230392 nsecs
  .idle_exittime  : 736271238748 nsecs
  .idle_sleeptime : 693822304487 nsecs
  .last_jiffies   : 4295076363
  .next_jiffies   : 4295076435
  .idle_expires   : 736556000000 nsecs
jiffies: 4295076364


Tick Device: mode:     1
Broadcast device
Clock Event Device: hpet
 max_delta_ns:   149983003520
 min_delta_ns:   5000
 mult:           61496115
 shift:          32
 mode:           3
 next_event:     9223372036854775807 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: hpet2
 max_delta_ns:   149983005959
 min_delta_ns:   5000
 mult:           61496114
 shift:          32
 mode:           3
 next_event:     736276000000 nsecs
 set_next_event: hpet_msi_next_event
 set_mode:       hpet_msi_set_mode
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: lapic
 max_delta_ns:   669709116
 min_delta_ns:   1197
 mult:           53797674
 shift:          32
 mode:           3
 next_event:     736276500000 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt




Benjamin
