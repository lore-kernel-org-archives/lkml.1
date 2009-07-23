Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZGWMvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZGWMvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 08:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZGWMvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 08:51:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:25100 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbZGWMvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 08:51:12 -0400
Subject: Re: Boot Hang - mmotm 090716 - serial 8250 irq flags support
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Vikram Pandita <vikram.pandita@ti.com>, Alan Cox <alan@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Eric Whitney <eric.whitney@hp.com>, Rich Freiss <richard.freiss@hp.com>
In-Reply-To: <20090723113353.7da8f6f9@lxorguk.ukuu.org.uk>
References: <1248291948.4490.67.camel@useless.americas.hpqcorp.net>
	 <20090723113353.7da8f6f9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: HP/LKTT
Date: Thu, 23 Jul 2009 08:51:02 -0400
Message-Id: <1248353462.5674.80.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 11:33 +0100, Alan Cox wrote:
> On Wed, 22 Jul 2009 15:45:48 -0400
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> 
> > The mmotm dated 17jul09 atop 2.6.31-rc3 hangs [or appears to--could have
> > just lost remote access via virtual serial port] during boot on HP
> > Proliant DL585 [and perhaps others].  Checking back, the last mmotm to
> > boot successfully on this platform was the 25jun09 snapshot.
> 
> Is your virtual serial port the console ? Also when you say "lost remote
> access", at what point do you lose remote access - what is the last thing
> printed to the console. What if anything is logged on the monitor if one
> is plugged in and does it boot fine with the patch but without console
> on the serial port ?

Alan:

Yes, the vsp is the console.  The test machine is in a lab 40 miles or
so away.  I access the "management processor" ["ilo" or "integrated
lights out" console in HP market-speak] via the net and then connect to
the virtual serial port from there.  Like a network terminal server.
This shows up as ttyS1 in Linux.

I plan on driving down to the site next week and plugging a terminal
into a serial port to test a "real serial port".  

I'll attach the console output--what I can capture of it--below.

[Ouch! I rebooted kernel with the 8250 patch to capture console log.
Altho' console hangs, looks like it still booted.  More below.]

> 
> Is the virtual serial port a standard PC serial port (or appearing as
> one) and using the standard drivers or is there anything else
> loaded/special modules in use for it ?

As far as I know, it LOOKS like a standard pc serial port.  I don't know
the actual hardware, altho' it seems to use the 8250 driver. Here's what
I see when I attach to the vsp from the ilo command line:

</system1>hpiLO-> Virtual Serial Port active: IO=0x02F8 INT=3

Perhaps Bjorn or Rich could comment on the hardware setup...

> 
> > The offending patch appears to be commit
> > 0b8d7a6fbba81ffd06de701fa6178916ee9732c3 - "serial-add-irqflags-support"
> > in the linux-next mega-patch.  Reverting the changes to the 8250 driver
> > allows the kernel to boot and operate normally.
> 
> Strange as it simply moves a few flags around. That ought to make it easy
> to figure however.

You'd think.  I'll gladly try any other patches or instrumentation to
help sort this out.  Altho' it is booting, I really would like to have
my console back.  Seems like the patch confuses the firmware managing
the other end of the vsp link.  Not hard to do, I imagine.

Console log [long]:

> 
Initializing cgroup subsys cpuset
Linux version 2.6.31-rc3-mmotm-090716-1432+8250-patch (lts@spoke.lnx.usa.hp.com) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-44)) #54 SMP Thu Jul 23 08:29:33 EDT 2009
Command line: ro root=LABEL=RHEL53 console=ttyS1,115200N8 debug meminit_loglevel=3
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fe4e000 (usable)
 BIOS-e820: 000000007fe4e000 - 000000007fe56000 (ACPI data)
 BIOS-e820: 000000007fe56000 - 000000007fe57000 (usable)
 BIOS-e820: 000000007fe57000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffc00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000087ffff000 (usable)
DMI 2.4 present.
last_pfn = 0x87ffff max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-back
MTRR variable ranges enabled:
  0 base 0000000000 mask FF80000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 0000000880000000 aka 34816M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 0000000080000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0x7fe57 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000007fe57000
 0000000000 - 007fe57000 page 4k
kernel direct mapping tables up to 7fe57000 @ 100000-503000
init_memory_mapping: 0000000100000000-000000087ffff000
 0100000000 - 087ffff000 page 4k
kernel direct mapping tables up to 87ffff000 @ 1646000-5a69000
RAMDISK: 37daa000 - 37fef1f3
ACPI: RSDP 00000000000f4f00 00024 (v02 HP    )
ACPI: XSDT 000000007fe4ed00 00074 (v01 HP     ProLiant 00000002   �? 0000162E)
ACPI: FACP 000000007fe4ed80 000F4 (v03 HP     A07      00000002   �? 0000162E)
ACPI: DSDT 000000007fe4ee80 04959 (v01 HP         DSDT 00000001 INTL 20030228)
ACPI: FACS 000000007fe4e100 00040
ACPI: SPCR 000000007fe4e140 00050 (v01 HP     SPCRRBSU 00000001   �? 0000162E)
ACPI: HPET 000000007fe4e1c0 00038 (v01 HP     ProLiant 00000002   �? 0000162E)
ACPI: SPMI 000000007fe4e200 00040 (v05 HP     ProLiant 00000001   �? 0000162E)
ACPI: ERST 000000007fe4e240 001D0 (v01 HP     ProLiant 00000001   �? 0000162E)
ACPI: APIC 000000007fe4e440 000C6 (v01 HP     ProLiant 00000002      00000000)
ACPI: SRAT 000000007fe4e580 001A0 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
ACPI: FFFF 000000007fe4e980 00176 (v01 HP     ProLiant 00000001   �? 0000162E)
ACPI: BERT 000000007fe4eb00 00030 (v01 HP     ProLiant 00000001   �? 0000162E)
ACPI: HEST 000000007fe4eb40 00170 (v01 HP     ProLiant 00000001   �? 0000162E)
ACPI: Local APIC address 0xfee00000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: PXM 2 -> APIC 4 -> Node 2
SRAT: PXM 2 -> APIC 5 -> Node 2
SRAT: PXM 3 -> APIC 6 -> Node 3
SRAT: PXM 3 -> APIC 7 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-80000000
SRAT: Node 0 PXM 0 100000000-280000000
SRAT: Node 1 PXM 1 280000000-480000000
SRAT: Node 2 PXM 2 480000000-680000000
SRAT: Node 3 PXM 3 680000000-880000000
NUMA: Allocated memnodemap from 8000 - 19040
NUMA: Using 20 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000280000000
  NODE_DATA [0000000000001000 - 0000000000004fff]
  bootmap [000000000001a000 -  0000000000069fff] pages 50
(9 early reservations) ==> bootmem [0000000000 - 0280000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0001644c10]    TEXT DATA BSS ==> [0001000000 - 0001644c10]
  #3 [0037daa000 - 0037fef1f3]          RAMDISK ==> [0037daa000 - 0037fef1f3]
  #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
  #5 [0001645000 - 0001645114]              BRK ==> [0001645000 - 0001645114]
  #6 [0000100000 - 0000501000]          PGTABLE ==> [0000100000 - 0000501000]
  #7 [0001646000 - 0005264000]          PGTABLE ==> [0001646000 - 0005264000]
  #8 [0000008000 - 0000019040]       MEMNODEMAP ==> [0000008000 - 0000019040]
Bootmem setup node 1 0000000280000000-0000000480000000
  NODE_DATA [0000000280000000 - 0000000280003fff]
  bootmap [0000000280004000 -  0000000280043fff] pages 40
(9 early reservations) ==> bootmem [0280000000 - 0480000000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0001000000 - 0001644c10]    TEXT DATA BSS
  #3 [0037daa000 - 0037fef1f3]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0001645000 - 0001645114]              BRK
  #6 [0000100000 - 0000501000]          PGTABLE
  #7 [0001646000 - 0005264000]          PGTABLE
  #8 [0000008000 - 0000019040]       MEMNODEMAP
Bootmem setup node 2 0000000480000000-0000000680000000
  NODE_DATA [0000000480000000 - 0000000480003fff]
  bootmap [0000000480004000 -  0000000480043fff] pages 40
(9 early reservations) ==> bootmem [0480000000 - 0680000000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0001000000 - 0001644c10]    TEXT DATA BSS
  #3 [0037daa000 - 0037fef1f3]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0001645000 - 0001645114]              BRK
  #6 [0000100000 - 0000501000]          PGTABLE
  #7 [0001646000 - 0005264000]          PGTABLE
  #8 [0000008000 - 0000019040]       MEMNODEMAP
Bootmem setup node 3 0000000680000000-000000087ffff000
  NODE_DATA [0000000680000000 - 0000000680003fff]
  bootmap [0000000680004000 -  0000000680043fff] pages 40
(9 early reservations) ==> bootmem [0680000000 - 087ffff000]
  #0 [0000000000 - 0000001000]   BIOS data page
  #1 [0000006000 - 0000008000]       TRAMPOLINE
  #2 [0001000000 - 0001644c10]    TEXT DATA BSS
  #3 [0037daa000 - 0037fef1f3]          RAMDISK
  #4 [000009f400 - 0000100000]    BIOS reserved
  #5 [0001645000 - 0001645114]              BRK
  #6 [0000100000 - 0000501000]          PGTABLE
  #7 [0001646000 - 0005264000]          PGTABLE
  #8 [0000008000 - 0000019040]       MEMNODEMAP
found SMP MP-table at [ffff8800000f4f80] f4f80
 [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff880028600000-ffff88002f5fffff] on node 0
 [ffffea0008c00000-ffffea000fbfffff] PMD -> [ffff880280200000-ffff8802871fffff] on node 1
 [ffffea000fc00000-ffffea0016bfffff] PMD -> [ffff880480200000-ffff8804871fffff] on node 2
 [ffffea0016c00000-ffffea001dbfffff] PMD -> [ffff880680200000-ffff8806871fffff] on node 3
sizeof(struct page) = 56
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x0087ffff
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007fe4e
    0: 0x0007fe56 -> 0x0007fe57
    0: 0x00100000 -> 0x00280000
    1: 0x00280000 -> 0x00480000
    2: 0x00480000 -> 0x00680000
    3: 0x00680000 -> 0x0087ffff
On node 0 totalpages: 2096622
  DMA zone: 56 pages used for memmap
  DMA zone: 1141 pages reserved
  DMA zone: 2802 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 505479 pages, LIFO batch:31
  Normal zone: 21504 pages used for memmap
  Normal zone: 1551360 pages, LIFO batch:31
On node 1 totalpages: 2097152
  Normal zone: 28672 pages used for memmap
  Normal zone: 2068480 pages, LIFO batch:31
On node 2 totalpages: 2097152
  Normal zone: 28672 pages used for memmap
  Normal zone: 2068480 pages, LIFO batch:31
On node 3 totalpages: 2097151
  Normal zone: 28672 pages used for memmap
  Normal zone: 2068479 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x908
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xd9af0000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 17, address 0xd9af0000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xd9fd0000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 17, address 0xd9fd0000, GSI 24-30
ACPI: IOAPIC (id[0x0a] address[0xd9fe0000] gsi_base[31])
IOAPIC[2]: apic_id 10, version 17, address 0xd9fe0000, GSI 31-37
ACPI: IOAPIC (id[0x0b] address[0xd9ff0000] gsi_base[38])
IOAPIC[3]: apic_id 11, version 17, address 0xd9ff0000, GSI 38-61
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: NMI_SRC (dfl dfl global_irq 28)
ACPI: NMI_SRC (dfl dfl global_irq 35)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x10228201 base: 0xfed00000
SMP: Allowing 8 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 62
Allocating PCI resources starting at 80000000 (gap: 80000000:60000000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:4
pcpu-lpage: sta/res/dyn=82656/8192/23840 unit=1048576 lpage=2097152
pcpu-lpage: 0 4 | 1 5 | 2 6 | 3 7 
PERCPU: Remapped at ffffc90000000000 with large pages, static data 82656 bytes
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 8265080
Policy zone: Normal
Kernel command line: ro root=LABEL=RHEL53 console=ttyS1,115200N8 debug meminit_loglevel=3
PID hash table entries: 4096 (order: 12, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Memory: 32951992k/35651580k available (3357k kernel code, 2099272k absent, 600316k reserved, 1831k data, 516k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=4
Hierarchical RCU implementation.
NR_IRQS:4352 nr_irqs:1118
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2813.300 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS1] enabled
allocated 335544320 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 5626.60 BogoMIPS (lpj=2813300)
Security Framework initialized
Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys memory
Initializing cgroup subsys devices
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Counters: AMD PMU driver.
... version:                 0
... bit width:               48
... generic counters:        4
... value mask:              0000ffffffffffff
... max period:              00007fffffffffff
... fixed-purpose counters:  0
... counter mask:            000000000000000f
ACPI: Core revision 20090625
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5625.65 BogoMIPS (lpj=2812825)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1/0x2 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 2 APIC 0x4 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5625.62 BogoMIPS (lpj=2812812)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2/0x4 -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 3 APIC 0x6 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5625.63 BogoMIPS (lpj=2812816)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3/0x6 -> Node 3
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 4 APIC 0x1 ip 0x6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 5625.68 BogoMIPS (lpj=2812841)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 4/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 5 APIC 0x3 ip 0x6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 5625.65 BogoMIPS (lpj=2812828)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 5/0x3 -> Node 1
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 6 APIC 0x5 ip 0x6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 5625.66 BogoMIPS (lpj=2812832)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 6/0x5 -> Node 2
CPU: Physical Processor ID: 2
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Booting processor 7 APIC 0x7 ip 0x6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 5625.71 BogoMIPS (lpj=2812855)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 7/0x7 -> Node 3
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 1
mce: CPU supports 5 MCE banks
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Dual-Core AMD Opteron(tm) Processor 8220 SE stepping 02
Brought up 8 CPUs
Total of 8 processors activated (45006.21 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0,4 level MC
  groups: 0 4
  domain 1: span 0-7 level NODE
   groups: 0,4 1,5 2,6 3,7
CPU1 attaching sched-domain:
 domain 0: span 1,5 level MC
  groups: 1 5
  domain 1: span 0-7 level NODE
   groups: 1,5 2,6 3,7 0,4
CPU2 attaching sched-domain:
 domain 0: span 2,6 level MC
  groups: 2 6
  domain 1: span 0-7 level NODE
   groups: 2,6 3,7 0,4 1,5
CPU3 attaching sched-domain:
 domain 0: span 3,7 level MC
  groups: 3 7
  domain 1: span 0-7 level NODE
   groups: 3,7 0,4 1,5 2,6
CPU4 attaching sched-domain:
 domain 0: span 0,4 level MC
  groups: 4 0
  domain 1: span 0-7 level NODE
   groups: 0,4 1,5 2,6 3,7
CPU5 attaching sched-domain:
 domain 0: span 1,5 level MC
  groups: 5 1
  domain 1: span 0-7 level NODE
   groups: 1,5 2,6 3,7 0,4
CPU6 attaching sched-domain:
 domain 0: span 2,6 level MC
  groups: 6 2
  domain 1: span 0-7 level NODE
   groups: 2,6 3,7 0,4 1,5
CPU7 attaching sched-domain:
 domain 0: span 3,7 level MC
  groups: 7 3
  domain 1: span 0-7 level NODE
   groups: 3,7 0,4 1,5 2,6
NET: Registered protocol family 16
node 0 link 1: io port [1000, 3fff]
node 1 link 2: io port [4000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 1: mmio [d0000000, d9efffff]
node 1 link 2: mmio [d9f00000, dfefffff]
node 0 link 1: mmio [e0000000, e3ffffff]
node 1 link 2: mmio [e4000000, e7ffffff]
node 0 link 1: mmio [a0000, bffff]
TOM2: 0000000880000000 aka 34816M
bus: [00,3f] on node 0 link 1
bus: 00 index 0 io port: [0, 3fff]
bus: 00 index 1 mmio: [80000000, d9efffff]
bus: 00 index 2 mmio: [dff00000, e3ffffff]
bus: 00 index 3 mmio: [a0000, bffff]
bus: 00 index 4 mmio: [e8000000, ffffffff]
bus: 00 index 5 mmio: [880000000, fcffffffff]
bus: [40,7f] on node 1 link 2
bus: 40 index 0 io port: [4000, ffff]
bus: 40 index 1 mmio: [d9f00000, dfefffff]
bus: 40 index 2 mmio: [e4000000, e7ffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: HP ProLiant DL585 G2 detected, enabling pci=bfsort.
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xd9ae0000-0xd9ae0fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10 32bit mmio: [0xd9ad0000-0xd9ad00ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:06.0: reg 20 io port: [0x500-0x50f]
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
PCI: peer root bus 00 res updated from pci conf
pci 0000:01:03.0: reg 10 32bit mmio: [0xd0000000-0xd7ffffff]
pci 0000:01:03.0: reg 14 io port: [0x1000-0x10ff]
pci 0000:01:03.0: reg 18 32bit mmio: [0xd9cf0000-0xd9cfffff]
pci 0000:01:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:03.0: supports D1 D2
pci 0000:01:04.0: reg 10 io port: [0x2800-0x28ff]
pci 0000:01:04.0: reg 14 32bit mmio: [0xd9ce0000-0xd9ce01ff]
pci 0000:01:04.0: PME# supported from D0 D3hot D3cold
pci 0000:01:04.0: PME# disabled
pci 0000:01:04.2: reg 10 io port: [0x1400-0x14ff]
pci 0000:01:04.2: reg 14 32bit mmio: [0xd9cd0000-0xd9cd07ff]
pci 0000:01:04.2: reg 18 32bit mmio: [0xd9cc0000-0xd9cc3fff]
pci 0000:01:04.2: reg 1c 32bit mmio: [0xd9c00000-0xd9c7ffff]
pci 0000:01:04.2: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:01:04.2: PME# supported from D0 D3hot D3cold
pci 0000:01:04.2: PME# disabled
pci 0000:01:04.4: reg 20 io port: [0x1800-0x181f]
pci 0000:01:04.4: PME# supported from D0 D3hot D3cold
pci 0000:01:04.4: PME# disabled
pci 0000:01:04.6: reg 10 32bit mmio: [0xd9bf0000-0xd9bf00ff]
pci 0000:01:04.6: PME# supported from D0 D3hot D3cold
pci 0000:01:04.6: PME# disabled
pci 0000:00:09.0: transparent bridge
pci 0000:00:09.0: bridge io port: [0x1000-0x2fff]
pci 0000:00:09.0: bridge 32bit mmio: [0xd9b00000-0xd9cfffff]
pci 0000:00:09.0: bridge 32bit mmio pref: [0xd0000000-0xd7ffffff]
pci 0000:08:00.0: reg 10 64bit mmio: [0xd9e00000-0xd9efffff]
pci 0000:08:00.0: reg 18 io port: [0x3000-0x30ff]
pci 0000:08:00.0: reg 1c 64bit mmio: [0xd9df0000-0xd9df0fff]
pci 0000:08:00.0: reg 30 32bit mmio: [0x000000-0x03ffff]
pci 0000:08:00.0: supports D1
pci 0000:00:0c.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:0c.0: bridge 32bit mmio: [0xd9d00000-0xd9efffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.IP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.CPE2._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:40)
pci 0000:40:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0b.0: PME# disabled
pci 0000:40:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0c.0: PME# disabled
pci 0000:40:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0d.0: PME# disabled
pci 0000:40:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:40:0e.0: PME# disabled
pci 0000:40:10.0: Enabling HT MSI Mapping
pci 0000:40:11.0: Enabling HT MSI Mapping
PCI: peer root bus 40 res updated from pci conf
pci 0000:41:01.0: reg 10 64bit mmio: [0xdc000000-0xddffffff]
pci 0000:41:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:41:01.0: PME# supported from D3hot D3cold
pci 0000:41:01.0: PME# disabled
pci 0000:41:02.0: reg 10 64bit mmio: [0xda000000-0xdbffffff]
pci 0000:41:02.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:41:02.0: PME# supported from D3hot D3cold
pci 0000:41:02.0: PME# disabled
pci 0000:40:10.0: bridge 32bit mmio: [0xda000000-0xddffffff]
pci 0000:42:01.0: reg 10 io port: [0x4000-0x40ff]
pci 0000:42:01.0: reg 14 64bit mmio: [0xdfee0000-0xdfefffff]
pci 0000:42:01.0: reg 1c 64bit mmio: [0xdfec0000-0xdfedffff]
pci 0000:42:01.0: reg 30 32bit mmio: [0x000000-0x0fffff]
pci 0000:42:01.0: supports D1 D2
pci 0000:42:01.1: reg 10 io port: [0x4400-0x44ff]
pci 0000:42:01.1: reg 14 64bit mmio: [0xdfea0000-0xdfebffff]
pci 0000:42:01.1: reg 1c 64bit mmio: [0xdfe80000-0xdfe9ffff]
pci 0000:42:01.1: reg 30 32bit mmio: [0x000000-0x0fffff]
pci 0000:42:01.1: supports D1 D2
pci 0000:40:11.0: bridge io port: [0x4000-0x4fff]
pci 0000:40:11.0: bridge 32bit mmio: [0xdfe00000-0xdfefffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.BRGB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.IPE3._PRT]
ACPI: PCI Interrupt Link [LNKW] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [LNKX] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [LNKY] (IRQs 18) *0, disabled.
ACPI: PCI Interrupt Link [LNKZ] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [LNU0] (IRQs 22) *5
ACPI: PCI Interrupt Link [LNU2] (IRQs 23) *10
ACPI: PCI Interrupt Link [LNKA] (IRQs 54) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 55) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 56) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 57) *0, disabled.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Expanded resource reserved due to conflict with PCI Bus #00
Expanded resource reserved due to conflict with PCI Bus #00
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 comparators, 32-bit 25.000000 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 4
Switched to high resolution mode on CPU 6
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 5
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 7
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x408-0x40f has been reserved
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x700-0x73f has been reserved
system 00:01: ioport range 0x800-0x8fe has been reserved
system 00:01: ioport range 0x900-0x9fe has been reserved
system 00:01: ioport range 0x9ff-0x9ff has been reserved
system 00:01: ioport range 0xa00-0xafe has been reserved
system 00:01: ioport range 0xaff-0xaff has been reserved
system 00:01: ioport range 0xb00-0xbfe has been reserved
system 00:01: ioport range 0xbff-0xbff has been reserved
system 00:01: ioport range 0xc80-0xc83 has been reserved
system 00:01: ioport range 0xcd4-0xcd7 has been reserved
system 00:01: ioport range 0xcf9-0xcf9 could not be reserved
system 00:01: ioport range 0xf50-0xf58 has been reserved
system 00:01: ioport range 0xca0-0xca1 has been reserved
system 00:01: ioport range 0xca4-0xca5 has been reserved
system 00:01: ioport range 0xc00-0xc03 has been reserved
system 00:01: ioport range 0x2f8-0x2ff has been reserved
pci 0000:00:09.0: PCI bridge, secondary bus 0000:01
pci 0000:00:09.0:   IO window: 0x1000-0x2fff
pci 0000:00:09.0:   MEM window: 0xd9b00000-0xd9cfffff
pci 0000:00:09.0:   PREFETCH window: 0xd0000000-0xd7ffffff
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:08
pci 0000:00:0c.0:   IO window: 0x3000-0x3fff
pci 0000:00:0c.0:   MEM window: 0xd9d00000-0xd9efffff
pci 0000:00:0c.0:   PREFETCH window: 0x80000000-0x800fffff
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:05
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: disabled
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0e.0:   IO window: disabled
pci 0000:00:0e.0:   MEM window: disabled
pci 0000:00:0e.0:   PREFETCH window: disabled
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:40:0b.0: PCI bridge, secondary bus 0000:4f
pci 0000:40:0b.0:   IO window: disabled
pci 0000:40:0b.0:   MEM window: disabled
pci 0000:40:0b.0:   PREFETCH window: disabled
pci 0000:40:0c.0: PCI bridge, secondary bus 0000:4c
pci 0000:40:0c.0:   IO window: disabled
pci 0000:40:0c.0:   MEM window: disabled
pci 0000:40:0c.0:   PREFETCH window: disabled
pci 0000:40:0d.0: PCI bridge, secondary bus 0000:49
pci 0000:40:0d.0:   IO window: disabled
pci 0000:40:0d.0:   MEM window: disabled
pci 0000:40:0d.0:   PREFETCH window: disabled
pci 0000:40:0e.0: PCI bridge, secondary bus 0000:46
pci 0000:40:0e.0:   IO window: disabled
pci 0000:40:0e.0:   MEM window: disabled
pci 0000:40:0e.0:   PREFETCH window: disabled
pci 0000:40:10.0: PCI bridge, secondary bus 0000:41
pci 0000:40:10.0:   IO window: disabled
pci 0000:40:10.0:   MEM window: 0xda000000-0xddffffff
pci 0000:40:10.0:   PREFETCH window: 0xde000000-0xde0fffff
pci 0000:40:11.0: PCI bridge, secondary bus 0000:42
pci 0000:40:11.0:   IO window: 0x4000-0x4fff
pci 0000:40:11.0:   MEM window: 0xdfe00000-0xdfefffff
pci 0000:40:11.0:   PREFETCH window: 0xde100000-0xde2fffff
pci 0000:40:0b.0: setting latency timer to 64
pci 0000:40:0c.0: setting latency timer to 64
pci 0000:40:0d.0: setting latency timer to 64
pci 0000:40:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0x3fff]
pci_bus 0000:00: resource 1 mem: [0x80000000-0xd9efffff]
pci_bus 0000:00: resource 2 mem: [0xdff00000-0xe3ffffff]
pci_bus 0000:00: resource 3 mem: [0x0a0000-0x0bffff]
pci_bus 0000:00: resource 4 mem: [0xe8000000-0xffffffff]
pci_bus 0000:00: resource 5 mem: [0x880000000-0xfcffffffff]
pci_bus 0000:01: resource 0 io:  [0x1000-0x2fff]
pci_bus 0000:01: resource 1 mem: [0xd9b00000-0xd9cfffff]
pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
pci_bus 0000:01: resource 3 io:  [0x00-0x3fff]
pci_bus 0000:01: resource 4 mem: [0x80000000-0xd9efffff]
pci_bus 0000:01: resource 5 mem: [0xdff00000-0xe3ffffff]
pci_bus 0000:01: resource 6 mem: [0x0a0000-0x0bffff]
pci_bus 0000:01: resource 7 mem: [0xe8000000-0xffffffff]
pci_bus 0000:01: resource 8 mem: [0x880000000-0xfcffffffff]
pci_bus 0000:08: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:08: resource 1 mem: [0xd9d00000-0xd9efffff]
pci_bus 0000:08: resource 2 pref mem [0x80000000-0x800fffff]
pci_bus 0000:40: resource 0 io:  [0x4000-0xffff]
pci_bus 0000:40: resource 1 mem: [0xd9f00000-0xdfefffff]
pci_bus 0000:40: resource 2 mem: [0xe4000000-0xe7ffffff]
pci_bus 0000:41: resource 1 mem: [0xda000000-0xddffffff]
pci_bus 0000:41: resource 2 pref mem [0xde000000-0xde0fffff]
pci_bus 0000:42: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:42: resource 1 mem: [0xdfe00000-0xdfefffff]
pci_bus 0000:42: resource 2 pref mem [0xde100000-0xde2fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
debug: unmapping init memory ffff880037daa000..ffff880037ff0000
platform rtc_cmos: registered platform RTC device (no PNP device found)
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 32768
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:01:03.0: Boot video device
pci 0000:01:04.4: HCRESET not completed yet!
pci 0000:40:0b.0: Found enabled HT MSI Mapping
pci 0000:40:0c.0: Found enabled HT MSI Mapping
pci 0000:40:0d.0: Found enabled HT MSI Mapping
pci 0000:40:0e.0: Found enabled HT MSI Mapping
  alloc irq_desc for 62 on node 0
  alloc kstat_irqs on node 0
pcieport-driver 0000:00:0c.0: irq 62 for MSI/MSI-X
pcieport-driver 0000:00:0c.0: setting latency timer to 64
  alloc irq_desc for 63 on node 0
  alloc kstat_irqs on node 0
pcieport-driver 0000:00:0d.0: irq 63 for MSI/MSI-X
pcieport-driver 0000:00:0d.0: setting latency timer to 64
  alloc irq_desc for 64 on node 0
  alloc kstat_irqs on node 0
pcieport-driver 0000:00:0e.0: irq 64 for MSI/MSI-X
pcieport-driver 0000:00:0e.0: setting latency timer to 64
  alloc irq_desc for 65 on node 1
  alloc kstat_irqs on node 1
pcieport-driver 0000:40:0b.0: irq 65 for MSI/MSI-X
pcieport-driver 0000:40:0b.0: setting latency timer to 64
  alloc irq_desc for 66 on node 1
  alloc kstat_irqs on node 1
pcieport-driver 0000:40:0c.0: irq 66 for MSI/MSI-X
pcieport-driver 0000:40:0c.0: setting latency timer to 64
  alloc irq_desc for 67 on node 1
  alloc kstat_irqs on node 1
pcieport-driver 0000:40:0d.0: irq 67 for MSI/MSI-X
pcieport-driver 0000:40:0d.0: setting latency timer to 64
  alloc irq_desc for 68 on node 1
  alloc kstat_irqs on node 1
pcieport-driver 0000:40:0e.0: irq 68 for MSI/MSI-X
pcieport-driver 0000:40:0e.0: setting latency timer to 64
processor LNXCPU:00: registered as cooling_device0
processor LNXCPU:01: registered as cooling_device1
processor LNXCPU:02: registered as cooling_device2
processor LNXCPU:03: registered as cooling_device3
processor LNXCPU:04: registered as cooling_device4
processor LNXCPU:05: registered as cooling_device5
processor LNXCPU:06: registered as cooling_device6
processor LNXCPU:07: registered as cooling_device7
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Platform driver 'serial8250' needs updating - please use dev_pm_ops
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.20)
ACPI: PCI Interrupt Link [LNKW] enabled at IRQ 16
  alloc irq_desc for 16 on node 0
  alloc kstat_irqs on node 0
cciss 0000:08:00.0: PCI INT A -> Link[LNKW] -> GSI 16 (level, high) -> IRQ 16
  alloc irq_desc for 69 on node 0
  alloc kstat_irqs on node 0
cciss 0000:08:00.0: irq 69 for MSI/MSI-X
  alloc irq_desc for 70 on node 0
  alloc kstat_irqs on node 0
cciss 0000:08:00.0: irq 70 for MSI/MSI-X
  alloc irq_desc for 71 on node 0
  alloc kstat_irqs on node 0
cciss 0000:08:00.0: irq 71 for MSI/MSI-X
  alloc irq_desc for 72 on node 0
  alloc kstat_irqs on node 0
cciss 0000:08:00.0: irq 72 for MSI/MSI-X
IRQ 71/cciss0: IRQF_DISABLED is not guaranteed on shared IRQs
cciss0: <0x3230> at PCI 0000:08:00.0 IRQ 71 using DAC
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d0: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d1: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d2: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d3: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d4: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d5: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d6: p1 p2 p3
      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

      blocks= 143305920 block_size= 512
      heads=255, sectors=32, cylinders=17562

 cciss/c0d7: p1 p2 p3
Uniform Multi-Platform E-IDE driver
amd74xx 0000:00:06.0: UDMA133 controller
amd74xx 0000:00:06.0: IDE controller (0x10de:0x0053 rev 0xa3)
amd74xx 0000:00:06.0: IDE port disabled
amd74xx 0000:00:06.0: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x0500-0x0507
Probing IDE interface ide0...
hda: DW-224E-R, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
usbcore: registered new interface driver rio500
rio500: v1.1:USB Rio 500 driver
PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
Platform driver 'i8042' needs updating - please use dev_pm_ops
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
debug: unmapping init memory ffffffff81524000..ffffffff815a5000
Write protecting the kernel read-only data: 4780k
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [LNU2] enabled at IRQ 23
  alloc irq_desc for 23 on node 0
  alloc kstat_irqs on node 0
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LNU2] -> GSI 23 (level, high) -> IRQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xd9ad0000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNU0] enabled at IRQ 22
  alloc irq_desc for 22 on node 0
  alloc kstat_irqs on node 0
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LNU0] -> GSI 22 (level, high) -> IRQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xd9ae0000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKX] enabled at IRQ 17
  alloc irq_desc for 17 on node 0
  alloc kstat_irqs on node 0
uhci_hcd 0000:01:04.4: PCI INT B -> Link[LNKX] -> GSI 17 (level, high) -> IRQ 17
uhci_hcd 0000:01:04.4: UHCI Host Controller
uhci_hcd 0000:01:04.4: new USB bus registered, assigned bus number 3
uhci_hcd 0000:01:04.4: port count misdetected? forcing to 2 ports
uhci_hcd 0000:01:04.4: HCRESET not completed yet!
usb 1-6: new high speed USB device using ehci_hcd and address 2
uhci_hcd 0000:01:04.4: irq 17, io base 0x00001800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-6: configuration #1 chosen from 1 choice
hub 1-6:1.0: USB hub found
hub 1-6:1.0: 4 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb 3-1: configuration #1 chosen from 1 choice
input: HP Virtual Keyboard as /class/input/input0
generic-usb 0003:03F0:1027.0001: input: USB HID v1.01 Keyboard [HP Virtual Keyboard] on usb-0000:01:04.4-1/input0
input: HP Virtual Keyboard as /class/input/input1
generic-usb 0003:03F0:1027.0002: input: USB HID v1.01 Mouse [HP Virtual Keyboard] on usb-0000:01:04.4-1/input1
usb 3-2: new full speed USB device using uhci_hcd and address 3
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
usb 3-2: configuration #1 chosen from 1 choice
hub 3-2:1.0: USB hub found
hub 3-2:1.0: 7 ports detected
<long pause here, then>
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
FS-Cache: Netfs 'nfs' registered for caching
svc: failed to register lockdv1 RPC service (errno 97).
<and nothing more...>

Those last messages would indicate that, altho' I've lost the console,
the init scripts have run.

At this point, the system doesn't respond to pings, so I didn't try
anything else.  Turns out, this is the result of my network setup from
home.  I can ssh into the system, so it did boot all the way. The
console is just dead.  I tried "echo foo >/dev/console", which works on
other Proliant DL* and see:

-bash: echo: write error: Input/output error

Lee

