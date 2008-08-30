Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYH3FWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYH3FWg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 01:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbYH3FW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 01:22:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:53132 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbYH3FWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 01:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KeoIqUFOHzyzLG9aps9PhAmX3l/MbMO79muY4RwBPfNznfwiTn0EQSFYoVmwA/p2x2
         1jh2p4TnBWf7AWJYk03Lv6wPCAgxDOzfnBciErkbkXVelnq4UtibwBg04CgtyCW4AFyO
         MZdz6tlDbXSgVnUsaVATYTEz7w4QbJCSjEMYQ=
Message-ID: <86802c440808292222r21886f88n29804d14eabb4606@mail.gmail.com>
Date: Fri, 29 Aug 2008 22:22:20 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
	 <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
	 <alpine.LFD.1.10.0808291733260.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291751480.3300@nehalem.linux-foundation.org>
	 <86802c440808291830t4547140dx9b12353649edd975@mail.gmail.com>
	 <alpine.LFD.1.10.0808291919080.3300@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0808291954410.3300@nehalem.linux-foundation.org>
	 <86802c440808292007t3588edfnef95b723320ff023@mail.gmail.com>
	 <alpine.LFD.1.10.0808292017440.5010@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 8:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>>
>> we need to use insert_resource_split_to_fit instead...
>>
>> otherwise __request_region will not be happy.
>
> Are you really really sure?
>
> Try just removing the IORESOURCE_BUSY. As mentioned, if we expect the PCI
> BAR's to work with the e820 resources, then BUSY really is simply not
> right any more. Not that I think it should matter either..
>
> The ones that are added _early_ should be IORESOURCE_BUSY (ie the ones
> that cover RAM), but the others we now expect to nest with PCI BARs.


please check

  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(qla2xxx) [ddffc000, ddffffff]
busy flag
qla2xxx 0000:83:00.0: BAR 1: can't reserve mem region [0xddffc000-0xddffffff]

YH

...



Initializing cgroup subsys cpuset...............................................
Linux version 2.6.27-rc5-tip-00672-ge5c5407-dirty (yhlu@linux-zpir)
(gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision
135036] (SUSE Linux) ) #220 SMP Fri Aug 29 22:02:53 PDT 2008..
Command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/mydisk11_x86_64.gz rw root=/dev/ram0 debug
show_msr=1 i8042.noaux initcall_debug apic=verbose pci=routeirq
ip=dhcp load_ramdisk=1 ramdisk_size=131072
BOOT_IMAGE=kernel.org/bzImage_2.6.27_k8.1
                     done
KERNEL supported cpus:s
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls                                               done
BIOS-provided physical RAM map:                                      done
 BIOS-e820: 0000000000000000 - 0000000000097400 (usable)             done
 BIOS-e820: 0000000000097400 - 00000000000a0000 (reserved)           done
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)s.
 BIOS-e820: 0000000000100000 - 00000000d7fa0000 (usable)
 BIOS-e820: 00000000d7fae000 - 00000000d7fb0000 (usable)
 BIOS-e820: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
 BIOS-e820: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
 BIOS-e820: 00000000d7ff0000 - 00000000d8000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000002028000000 (usable)
Early serial console at I/O port 0x3f8 (options '115200n8')
console [uart0] enabled
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel
code) [200000, 970103]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (Kernel code) [200000, 970103]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel
data) [970104, ea9657]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (Kernel data) [970104, ea9657]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (Kernel
bss) [f8f000, 1147ee3]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (Kernel bss) [f8f000, 1147ee3]
last_pfn = 0x2028000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xd7fb0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
Using GB pages for direct mapping
 0000000000 - 00c0000000 page 1G
 00c0000000 - 00d7e00000 page 2M
 00d7e00000 - 00d7fb0000 page 4k
kernel direct mapping tables up to d7fb0000 @ 8000-b000
last_map_addr: d7fb0000 end: d7fb0000
init_memory_mapping
Using GB pages for direct mapping
 0100000000 - 2000000000 page 1G
 2000000000 - 2028000000 page 2M
kernel direct mapping tables up to 2028000000 @ a000-c000
last_map_addr: 2028000000 end: 2028000000
RAMDISK: 7e6d7000 - 7ffffe0b
DMI present.
..
SRAT: PXM 0 -> APIC 4 -> Node 0
SRAT: PXM 0 -> APIC 5 -> Node 0
SRAT: PXM 0 -> APIC 6 -> Node 0
SRAT: PXM 0 -> APIC 7 -> Node 0
SRAT: PXM 1 -> APIC 8 -> Node 1
SRAT: PXM 1 -> APIC 9 -> Node 1
SRAT: PXM 1 -> APIC 10 -> Node 1
SRAT: PXM 1 -> APIC 11 -> Node 1
SRAT: PXM 2 -> APIC 12 -> Node 2
SRAT: PXM 2 -> APIC 13 -> Node 2
SRAT: PXM 2 -> APIC 14 -> Node 2
SRAT: PXM 2 -> APIC 15 -> Node 2
SRAT: PXM 3 -> APIC 16 -> Node 3
SRAT: PXM 3 -> APIC 17 -> Node 3
SRAT: PXM 3 -> APIC 18 -> Node 3
SRAT: PXM 3 -> APIC 19 -> Node 3
SRAT: Node 0 PXM 0 0-a0000
Adding active range (0, 0x0, 0x97) 0 entries of 12800 used
SRAT: Node 0 PXM 0 100000-d8000000
Adding active range (0, 0x100, 0xd7fa0) 1 entries of 12800 used
Adding active range (0, 0xd7fae, 0xd7fb0) 2 entries of 12800 used
SRAT: Node 0 PXM 0 100000000-828000000
Adding active range (0, 0x100000, 0x828000) 3 entries of 12800 used
SRAT: Node 1 PXM 1 828000000-1028000000
Adding active range (1, 0x828000, 0x1028000) 4 entries of 12800 used
SRAT: Node 2 PXM 2 1028000000-1828000000
Adding active range (2, 0x1028000, 0x1828000) 5 entries of 12800 used
SRAT: Node 3 PXM 3 1828000000-2028000000
Adding active range (3, 0x1828000, 0x2028000) 6 entries of 12800 used
ACPI: SLIT: nodes = 4
 10 13 13 16
 13 10 16 13
 13 16 10 13
 16 13 13 10
NUMA: Allocated memnodemap from b000 - 4b580
NUMA: Using 20 for the hash shift.
..
ACPI: PM-Timer IO Port: 0xe008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x08] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x09] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x0a] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x0b] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x0c] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0d] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0e] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0f] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x13] enabled)
ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 0, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x01] address[0xddeff000] gsi_base[24])
IOAPIC[1]: apic_id 1, version 0, address 0xddeff000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 16 CPUs, 0 hotplug CPUs
init_cpu_to_node:
cpu 0 -> apicid 0x4 -> node 0
cpu 1 -> apicid 0x5 -> node 0
cpu 2 -> apicid 0x6 -> node 0
cpu 3 -> apicid 0x7 -> node 0
cpu 4 -> apicid 0x8 -> node 1
cpu 5 -> apicid 0x9 -> node 1
cpu 6 -> apicid 0xa -> node 1
cpu 7 -> apicid 0xb -> node 1
cpu 8 -> apicid 0xc -> node 2
cpu 9 -> apicid 0xd -> node 2
cpu 10 -> apicid 0xe -> node 2
cpu 11 -> apicid 0xf -> node 2
cpu 12 -> apicid 0x10 -> node 3
cpu 13 -> apicid 0x11 -> node 3
cpu 14 -> apicid 0x12 -> node 3
cpu 15 -> apicid 0x13 -> node 3
mapped APIC to ffffffffff5fc000 (        fee00000)
mapped IOAPIC to ffffffffff5fb000 (fec00000)
mapped IOAPIC to ffffffffff5fa000 (ddeff000)
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (System
RAM) [0, 973ff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (System RAM) [0, 973ff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [97400, 9ffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [97400, 9ffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [e0000, fffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [e0000, fffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (System
RAM) [100000, d7f9ffff]
  insert_resource: first: (Kernel code) [200000, 970103], new: (System
RAM) [100000, d7f9ffff]
  insert_resource: direct parent: (PCI mem) [0, ffffffffffffffff],
new: (System RAM) [100000, d7f9ffff]
    insert_resource: child: (Kernel code) [200000, 970103], new:
(System RAM) [100000, d7f9ffff]
    insert_resource: child: (Kernel data) [970104, ea9657], new:
(System RAM) [100000, d7f9ffff]
    insert_resource: child: (Kernel bss) [f8f000, 1147ee3], new:
(System RAM) [100000, d7f9ffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (System
RAM) [d7fae000, d7faffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (System RAM) [d7fae000, d7faffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (ACPI
Tables) [d7fb0000, d7fbdfff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (ACPI Tables) [d7fb0000, d7fbdfff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (ACPI
Non-volatile Storage) [d7fbe000, d7feffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (ACPI Non-volatile Storage) [d7fbe000,
d7feffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (System
RAM) [100000000, 2027ffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (System RAM) [100000000, 2027ffffff]
request_resource: root: (PCI IO) [0, ffff], new: (dma1) [0, 1f] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (pic1) [20, 21] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (timer0) [40, 43] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (timer1) [50, 53] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (keyboard) [60, 60] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (keyboard) [64, 64] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (dma page reg) [80,
8f] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (pic2) [a0, a1] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (dma2) [c0, df] conflict 0
request_resource: root: (PCI IO) [0, ffff], new: (fpu) [f0, ff] conflict 0
Allocating PCI resources starting at f1000000 (gap: f0000000:ec00000)
dyn_array irq_2_pin_head+0x0/0x8 size:0x10 nr:256 align:0x1000
dyn_array irq_cfgx+0x0/0x8 size:0xa0 nr:32 align:0x1000
dyn_array sparse_irqs+0x0/0x8 size:0x180 nr:32 align:0x1000
dyn_array irq_2_iommuX+0x0/0x8 size:0x10 nr:256 align:0x1000
dyn_array total_size: 0x7000
dyn_array irq_2_pin_head+0x0/0x8  ==> [0x5c000 - 0x5d000]
dyn_array irq_cfgx+0x0/0x8  ==> [0x5d000 - 0x5e400]
dyn_array sparse_irqs+0x0/0x8  ==> [0x5f000 - 0x62000]
kstat_irqs ==> [0x63000 - 0x63800]
dyn_array irq_2_iommuX+0x0/0x8  ==> [0x62000 - 0x63000]
PERCPU: Allocating 53248 bytes of per cpu data
per cpu data for cpu0 on node0 at 000000000124e000
per cpu data for cpu1 on node0 at 000000000125b000
per cpu data for cpu2 on node0 at 0000000001268000
per cpu data for cpu3 on node0 at 0000000001275000
per cpu data for cpu4 on node1 at 0000000844218000
per cpu data for cpu5 on node1 at 0000000844225000
per cpu data for cpu6 on node1 at 0000000844232000
per cpu data for cpu7 on node1 at 000000084423f000
per cpu data for cpu8 on node2 at 0000001044418000
per cpu data for cpu9 on node2 at 0000001044425000
per cpu data for cpu10 on node2 at 0000001044432000
per cpu data for cpu11 on node2 at 000000104443f000
per cpu data for cpu12 on node3 at 0000001844218000
per cpu data for cpu13 on node3 at 0000001844225000
per cpu data for cpu14 on node3 at 0000001844232000
per cpu data for cpu15 on node3 at 000000184423f000
NR_CPUS: 512, nr_cpu_ids: 16, nr_node_ids 4
Built 4 zonelists in Zone order, mobility grouping on.  Total pages: 33093064
Policy zone: Normal
Kernel command line: console=uart8250,io,0x3f8,115200n8
initrd=kernel.org/mydisk11_x86_64.gz rw root=/dev/ram0 debug
show_msr=1 i8042.noaux initcall_debug apic=verbose pci=routeirq
ip=dhcp load_ramdisk=1 ramdisk_size=131072
BOOT_IMAGE=kernel.org/bzImage_2.6.27_k8.1
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 2300.091 MHz processor.
spurious 8259A interrupt: IRQ7.
request_resource: root: (PCI IO) [0, ffff], new: (vga+) [3c0, 3df] conflict 0
Console: colour VGA+ 80x25
console handover: boot [uart0] -> real [ttyS0]
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (GART)
[20000000, 23ffffff]
  insert_resource: first: (System RAM) [100000, d7f9ffff], new: (GART)
[20000000, 23ffffff]
    insert_resource: good with request direct parent: (System RAM)
[100000, d7f9ffff], new: (GART) [20000000, 23ffffff]
numa_free_all_bootmem node 0 done
numa_free_all_bootmem node 1 done
numa_free_all_bootmem node 2 done
numa_free_all_bootmem node 3 done
Memory: 132270808k/134873088k available (7616k kernel code, 1946124k
reserved, 5349k data, 744k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=4
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4600.17 BogoMIPS (lpj=9200352)
Dentry cache hash table entries: 16777216 (order: 15, 134217728 bytes)
Inode-cache hash table entries: 8388608 (order: 14, 67108864 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/4 -> Node 0
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
ACPI: Core revision 20080609
Parsing all Control Methods:
Table [DSDT](id 0001) - 1291 Objects with 137 Devices 414 Methods 21 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 80 Objects with 0 Devices 0 Methods 0 Regions
 tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 29337 hash entries in 231 pages
Setting APIC routing to physical flat
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 IO-APIC (apicid-pin) 0-0 not connected.
 0 add_pin_to_irq: irq 1 --> apic 0 pin 1
IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
 0 add_pin_to_irq: irq 0 --> apic 0 pin 2
IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
 0 add_pin_to_irq: irq 3 --> apic 0 pin 3
IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
 0 add_pin_to_irq: irq 4 --> apic 0 pin 4
IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
 0 add_pin_to_irq: irq 5 --> apic 0 pin 5
IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
 0 add_pin_to_irq: irq 6 --> apic 0 pin 6
IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
 0 add_pin_to_irq: irq 7 --> apic 0 pin 7
IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
 0 add_pin_to_irq: irq 8 --> apic 0 pin 8
IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
 0 add_pin_to_irq: irq 9 --> apic 0 pin 9
IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
 0 add_pin_to_irq: irq 10 --> apic 0 pin 10
IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
 0 add_pin_to_irq: irq 11 --> apic 0 pin 11
IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
 0 add_pin_to_irq: irq 12 --> apic 0 pin 12
IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
 0 add_pin_to_irq: irq 13 --> apic 0 pin 13
IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
 0 add_pin_to_irq: irq 14 --> apic 0 pin 14
IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
 0 add_pin_to_irq: irq 15 --> apic 0 pin 15
IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 IO-APIC (apicid-pin) 0-16, 0-17, 0-18, 0-19, 0-20, 0-21, 0-22, 0-23,
1-0, 1-1, 1-2, 1-3, 1-4, 1-5, 1-6, 1-7, 1-8, 1-9, 1-10, 1-11, 1-12,
1-13, 1-14, 1-15, 1-16, 1-17, 1-18, 1-19, 1-20, 1-21, 1-22, 1-23 not
connected.
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: Quad-Core AMD Opteron(tm) Processor 8356 stepping 03
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1250039
... PM timer delta = 357952
... PM timer result ok
..... delta 1250039
..... mult: 53685410
..... calibration result: 800024
..... CPU clock speed is 2300.0282 MHz.
..... host bus clock speed is 200.0024 MHz.

calling  migration_init+0x0/0x5b
initcall migration_init+0x0/0x5b returned 1 after 0 msecs
initcall migration_init+0x0/0x5b returned with error code 1

calling  spawn_ksoftirqd+0x0/0x59
initcall spawn_ksoftirqd+0x0/0x59 returned 0 after 0 msecs

calling  init_call_single_data+0x0/0x5a
initcall init_call_single_data+0x0/0x5a returned 0 after 0 msecs

calling  spawn_softlockup_task+0x0/0x74
initcall spawn_softlockup_task+0x0/0x74 returned 0 after 0 msecs

calling  relay_init+0x0/0x14
initcall relay_init+0x0/0x14 returned 0 after 0 msecs
Booting processor 1/5 ip 6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4605.68 BogoMIPS (lpj=9211364)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/5 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Quad-Core AMD Opteron(tm) Processor 8356 stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/6 ip 6000
...
Brought up 16 CPUs
Total of 16 processors activated (73628.27 BogoMIPS).
..

calling  pci_arch_init+0x0/0x4e
    __request_region: good with request direct parent: (PCI IO) [0,
ffff], res: (PCI conf1) [cf8, cff]
PCI: Found AMD Family 10h NB with MMCONFIG support.
PCI: Using MMCONFIG at e0000000 - efffffff
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
MMCONFIG 0) [e0000000, efffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI MMCONFIG 0) [e0000000, efffffff]
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x4e returned 0 after 26 msecs

...

calling  acpi_pci_root_init+0x0/0x28
ACPI: PCI Root Bridge [PCI0] (0000:00)
insert_resource: parent: (PCI IO) [0, ffff], new: (PCI Bus #00) [8000, dfff]
    insert_resource: good with request direct parent: (PCI IO) [0,
ffff], new: (PCI Bus #00) [8000, dfff]
insert_resource: parent: (PCI IO) [0, ffff], new: (PCI Bus #00) [e000, efff]
    insert_resource: good with request direct parent: (PCI IO) [0,
ffff], new: (PCI Bus #00) [e000, efff]
insert_resource: parent: (PCI IO) [0, ffff], new: (PCI Bus #00) [0, 3fff]
  insert_resource: first: (dma1) [0, 1f], new: (PCI Bus #00) [0, 3fff]
  insert_resource: direct parent: (PCI IO) [0, ffff], new: (PCI Bus
#00) [0, 3fff]
    insert_resource: child: (dma1) [0, 1f], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (pic1) [20, 21], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (timer0) [40, 43], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (timer1) [50, 53], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (keyboard) [60, 60], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (keyboard) [64, 64], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (dma page reg) [80, 8f], new: (PCI Bus
#00) [0, 3fff]
    insert_resource: child: (pic2) [a0, a1], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (dma2) [c0, df], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (fpu) [f0, ff], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (vga+) [3c0, 3df], new: (PCI Bus #00) [0, 3fff]
    insert_resource: child: (PCI conf1) [cf8, cff], new: (PCI Bus #00) [0, 3fff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
Bus #00) [de000000, dfffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI Bus #00) [de000000, dfffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
Bus #00) [a0000, bffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI Bus #00) [a0000, bffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
Bus #00) [d8000000, dcffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI Bus #00) [d8000000, dcffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
Bus #00) [f0000000, ffffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI Bus #00) [f0000000, ffffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
Bus #00) [2028000000, fcffffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI Bus #00) [2028000000, fcffffffff]
PCI: Scanning bus 0000:00
pci 0000:00:00.0: found [10de/0369] class 000500 header type 00
pci 0000:00:01.0: found [10de/0364] class 000601 header type 00
PCI: 0000:00:01.0 reg 10 io port: [ef00, ef7f]
pci 0000:00:01.0: calling nvidia_force_enable_hpet+0x0/0xc4
pci 0000:00:01.1: found [10de/0368] class 000c05 header type 00
PCI: 0000:00:01.1 reg 10 io port: [ac00, ac3f]
PCI: 0000:00:01.1 reg 20 io port: [ed00, ed3f]
PCI: 0000:00:01.1 reg 24 io port: [ee00, ee3f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: found [10de/036c] class 000c03 header type 00
PCI: 0000:00:02.0 reg 10 32bit mmio: [defbf000, defbffff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: found [10de/036d] class 000c03 header type 00
PCI: 0000:00:02.1 reg 10 32bit mmio: [defbec00, defbecff]
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:05.0: found [10de/037f] class 000101 header type 00
PCI: 0000:00:05.0 reg 10 io port: [a480, a487]
PCI: 0000:00:05.0 reg 14 io port: [a400, a403]
PCI: 0000:00:05.0 reg 18 io port: [a080, a087]
PCI: 0000:00:05.0 reg 1c io port: [a000, a003]
PCI: 0000:00:05.0 reg 20 io port: [9c00, 9c0f]
PCI: 0000:00:05.0 reg 24 32bit mmio: [defbd000, defbdfff]
pci 0000:00:05.1: found [10de/037f] class 000101 header type 00
PCI: 0000:00:05.1 reg 10 io port: [9880, 9887]
PCI: 0000:00:05.1 reg 14 io port: [9800, 9803]
PCI: 0000:00:05.1 reg 18 io port: [9480, 9487]
PCI: 0000:00:05.1 reg 1c io port: [9400, 9403]
PCI: 0000:00:05.1 reg 20 io port: [9080, 908f]
PCI: 0000:00:05.1 reg 24 32bit mmio: [defbc000, defbcfff]
pci 0000:00:05.2: found [10de/037f] class 000101 header type 00
PCI: 0000:00:05.2 reg 10 io port: [9000, 9007]
PCI: 0000:00:05.2 reg 14 io port: [8c00, 8c03]
PCI: 0000:00:05.2 reg 18 io port: [8880, 8887]
PCI: 0000:00:05.2 reg 1c io port: [8800, 8803]
PCI: 0000:00:05.2 reg 20 io port: [8480, 848f]
PCI: 0000:00:05.2 reg 24 32bit mmio: [defbb000, defbbfff]
pci 0000:00:06.0: found [10de/0370] class 000604 header type 01
pci 0000:00:08.0: found [10de/0373] class 000680 header type 00
PCI: 0000:00:08.0 reg 10 32bit mmio: [defba000, defbafff]
PCI: 0000:00:08.0 reg 14 io port: [8400, 8407]
PCI: 0000:00:08.0 reg 18 32bit mmio: [defbe800, defbe8ff]
PCI: 0000:00:08.0 reg 1c 32bit mmio: [defbe400, defbe40f]
pci 0000:00:08.0: supports D1
pci 0000:00:08.0: supports D2
pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: found [10de/0373] class 000680 header type 00
PCI: 0000:00:09.0 reg 10 32bit mmio: [defb9000, defb9fff]
PCI: 0000:00:09.0 reg 14 io port: [8080, 8087]
PCI: 0000:00:09.0 reg 18 32bit mmio: [defbe000, defbe0ff]
PCI: 0000:00:09.0 reg 1c 32bit mmio: [defb8c00, defb8c0f]
pci 0000:00:09.0: supports D1
pci 0000:00:09.0: supports D2
pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: found [10de/0377] class 000604 header type 01
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0e.0: found [10de/0376] class 000604 header type 01
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:0f.0: found [10de/0375] class 000604 header type 01
pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0f.0: PME# disabled
pci 0000:00:18.0: found [1022/1200] class 000600 header type 00
pci 0000:00:18.0: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:18.1: found [1022/1201] class 000600 header type 00
pci 0000:00:18.1: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:18.2: found [1022/1202] class 000600 header type 00
pci 0000:00:18.2: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:18.3: found [1022/1203] class 000600 header type 00
pci 0000:00:18.3: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:18.4: found [1022/1204] class 000600 header type 00
pci 0000:00:18.4: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:19.0: found [1022/1200] class 000600 header type 00
pci 0000:00:19.0: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:19.1: found [1022/1201] class 000600 header type 00
pci 0000:00:19.1: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:19.2: found [1022/1202] class 000600 header type 00
pci 0000:00:19.2: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:19.3: found [1022/1203] class 000600 header type 00
pci 0000:00:19.3: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:19.4: found [1022/1204] class 000600 header type 00
pci 0000:00:19.4: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1a.0: found [1022/1200] class 000600 header type 00
pci 0000:00:1a.0: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1a.1: found [1022/1201] class 000600 header type 00
pci 0000:00:1a.1: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1a.2: found [1022/1202] class 000600 header type 00
pci 0000:00:1a.2: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1a.3: found [1022/1203] class 000600 header type 00
pci 0000:00:1a.3: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1a.4: found [1022/1204] class 000600 header type 00
pci 0000:00:1a.4: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1b.0: found [1022/1200] class 000600 header type 00
pci 0000:00:1b.0: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1b.1: found [1022/1201] class 000600 header type 00
pci 0000:00:1b.1: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1b.2: found [1022/1202] class 000600 header type 00
pci 0000:00:1b.2: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1b.3: found [1022/1203] class 000600 header type 00
pci 0000:00:1b.3: calling fam10h_pci_cfg_space_size+0x0/0x24
pci 0000:00:1b.4: found [1022/1204] class 000600 header type 00
pci 0000:00:1b.4: calling fam10h_pci_cfg_space_size+0x0/0x24
PCI: Fixups for bus 0000:00
pci 0000:00:06.0: scanning behind bridge, config 010100, pass 0
PCI: Scanning bus 0000:01
pci 0000:01:05.0: found [1a03/2000] class 000300 header type 00
PCI: 0000:01:05.0 reg 10 32bit mmio: [df000000, df7fffff]
PCI: 0000:01:05.0 reg 14 32bit mmio: [dfbe0000, dfbfffff]
PCI: 0000:01:05.0 reg 18 io port: [bc00, bc7f]
pci 0000:01:05.0: supports D1
pci 0000:01:05.0: supports D2
PCI: Fixups for bus 0000:01
pci 0000:00:06.0: transparent bridge
PCI: bridge 0000:00:06.0 io port: [b000, bfff]
PCI: bridge 0000:00:06.0 32bit mmio: [df000000, dfbfffff]
PCI: Bus scan for 0000:01 returning with max=01
pci 0000:00:0a.0: scanning behind bridge, config 020200, pass 0
PCI: Scanning bus 0000:02
PCI: Fixups for bus 0000:02
PCI: Bus scan for 0000:02 returning with max=02
pci 0000:00:0e.0: scanning behind bridge, config 030300, pass 0
PCI: Scanning bus 0000:03
pci 0000:03:00.0: found [10df/fc40] class 000c04 header type 00
PCI: 0000:03:00.0 reg 10 64bit mmio: [dfcff000, dfcfffff]
PCI: 0000:03:00.0 reg 18 64bit mmio: [dfcf8000, dfcfbfff]
PCI: 0000:03:00.0 reg 20 io port: [c800, c8ff]
PCI: 0000:03:00.0 reg 30 32bit mmio: [dfc80000, dfcbffff]
pci 0000:03:00.1: found [10df/fc40] class 000c04 header type 00
PCI: 0000:03:00.1 reg 10 64bit mmio: [dfcfe000, dfcfefff]
PCI: 0000:03:00.1 reg 18 64bit mmio: [dfcf4000, dfcf7fff]
PCI: 0000:03:00.1 reg 20 io port: [c400, c4ff]
PCI: 0000:03:00.1 reg 30 32bit mmio: [dfc40000, dfc7ffff]
PCI: Fixups for bus 0000:03
PCI: bridge 0000:00:0e.0 io port: [c000, cfff]
PCI: bridge 0000:00:0e.0 32bit mmio: [dfc00000, dfcfffff]
PCI: Bus scan for 0000:03 returning with max=03
pci 0000:00:0f.0: scanning behind bridge, config 040400, pass 0
PCI: Scanning bus 0000:04
pci 0000:04:00.0: found [9005/0285] class 000104 header type 00
PCI: 0000:04:00.0 reg 10 64bit mmio: [dfe00000, dfffffff]
PCI: 0000:04:00.0 reg 30 32bit mmio: [dfd80000, dfdfffff]
pci 0000:04:00.0: supports D1
PCI: Fixups for bus 0000:04
PCI: bridge 0000:00:0f.0 32bit mmio: [dfd00000, dfffffff]
PCI: Bus scan for 0000:04 returning with max=04
pci 0000:00:06.0: scanning behind bridge, config 010100, pass 1
pci 0000:00:0a.0: scanning behind bridge, config 020200, pass 1
pci 0000:00:0e.0: scanning behind bridge, config 030300, pass 1
pci 0000:00:0f.0: scanning behind bridge, config 040400, pass 1
PCI: Bus scan for 0000:00 returning with max=04
bus 00 -> pxm 0 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Root Bridge [PCIB] (0000:80)
insert_resource: parent: (PCI IO) [0, ffff], new: (PCI Bus #80) [4000, 7fff]
    insert_resource: good with request direct parent: (PCI IO) [0,
ffff], new: (PCI Bus #80) [4000, 7fff]
insert_resource: parent: (PCI IO) [0, ffff], new: (PCI Bus #80) [f000, ffff]
    insert_resource: good with request direct parent: (PCI IO) [0,
ffff], new: (PCI Bus #80) [f000, ffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new: (PCI
Bus #80) [dd000000, ddffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (PCI Bus #80) [dd000000, ddffffff]
PCI: Scanning bus 0000:80
pci 0000:80:00.0: found [10de/0369] class 000500 header type 00
pci 0000:80:01.0: found [10de/0361] class 000500 header type 00
PCI: 0000:80:01.0 reg 10 io port: [fc00, fc7f]
PCI: 0000:80:01.0 reg 14 32bit mmio: [ddeff000, ddefffff]
pci 0000:80:01.0: calling nvidia_force_enable_hpet+0x0/0xc4
pci 0000:80:01.1: found [10de/0368] class 000c05 header type 00
PCI: 0000:80:01.1 reg 10 io port: [6880, 68bf]
PCI: 0000:80:01.1 reg 20 io port: [6800, 683f]
PCI: 0000:80:01.1 reg 24 io port: [6480, 64bf]
pci 0000:80:01.1: PME# supported from D3hot D3cold
pci 0000:80:01.1: PME# disabled
pci 0000:80:05.0: found [10de/037f] class 000101 header type 00
PCI: 0000:80:05.0 reg 10 io port: [6400, 6407]
PCI: 0000:80:05.0 reg 14 io port: [6080, 6083]
PCI: 0000:80:05.0 reg 18 io port: [6000, 6007]
PCI: 0000:80:05.0 reg 1c io port: [5c00, 5c03]
PCI: 0000:80:05.0 reg 20 io port: [5880, 588f]
PCI: 0000:80:05.0 reg 24 32bit mmio: [ddefe000, ddefefff]
pci 0000:80:05.1: found [10de/037f] class 000101 header type 00
PCI: 0000:80:05.1 reg 10 io port: [5800, 5807]
PCI: 0000:80:05.1 reg 14 io port: [5480, 5483]
PCI: 0000:80:05.1 reg 18 io port: [5400, 5407]
PCI: 0000:80:05.1 reg 1c io port: [5080, 5083]
PCI: 0000:80:05.1 reg 20 io port: [5000, 500f]
PCI: 0000:80:05.1 reg 24 32bit mmio: [ddefd000, ddefdfff]
pci 0000:80:05.2: found [10de/037f] class 000101 header type 00
PCI: 0000:80:05.2 reg 10 io port: [4c00, 4c07]
PCI: 0000:80:05.2 reg 14 io port: [4880, 4883]
PCI: 0000:80:05.2 reg 18 io port: [4800, 4807]
PCI: 0000:80:05.2 reg 1c io port: [4480, 4483]
PCI: 0000:80:05.2 reg 20 io port: [4400, 440f]
PCI: 0000:80:05.2 reg 24 32bit mmio: [ddefc000, ddefcfff]
pci 0000:80:08.0: found [10de/0373] class 000680 header type 00
PCI: 0000:80:08.0 reg 10 32bit mmio: [ddefb000, ddefbfff]
PCI: 0000:80:08.0 reg 14 io port: [4080, 4087]
PCI: 0000:80:08.0 reg 18 32bit mmio: [ddefac00, ddefacff]
PCI: 0000:80:08.0 reg 1c 32bit mmio: [ddefa800, ddefa80f]
pci 0000:80:08.0: supports D1
pci 0000:80:08.0: supports D2
pci 0000:80:08.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:80:08.0: PME# disabled
pci 0000:80:09.0: found [10de/0373] class 000680 header type 00
PCI: 0000:80:09.0 reg 10 32bit mmio: [ddef9000, ddef9fff]
PCI: 0000:80:09.0 reg 14 io port: [4000, 4007]
PCI: 0000:80:09.0 reg 18 32bit mmio: [ddefa400, ddefa4ff]
PCI: 0000:80:09.0 reg 1c 32bit mmio: [ddefa000, ddefa00f]
pci 0000:80:09.0: supports D1
pci 0000:80:09.0: supports D2
pci 0000:80:09.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:80:09.0: PME# disabled
pci 0000:80:0b.0: found [10de/0378] class 000604 header type 01
pci 0000:80:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:80:0b.0: PME# disabled
pci 0000:80:0e.0: found [10de/0376] class 000604 header type 01
pci 0000:80:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:80:0e.0: PME# disabled
pci 0000:80:0f.0: found [10de/0377] class 000604 header type 01
pci 0000:80:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:80:0f.0: PME# disabled
PCI: Fixups for bus 0000:80
pci 0000:80:0b.0: scanning behind bridge, config 818180, pass 0
PCI: Scanning bus 0000:81
PCI: Fixups for bus 0000:81
PCI: Bus scan for 0000:81 returning with max=81
pci 0000:80:0e.0: scanning behind bridge, config 828280, pass 0
PCI: Scanning bus 0000:82
PCI: Fixups for bus 0000:82
PCI: Bus scan for 0000:82 returning with max=82
pci 0000:80:0f.0: scanning behind bridge, config 838380, pass 0
PCI: Scanning bus 0000:83
pci 0000:83:00.0: found [1077/2532] class 000c04 header type 00
PCI: 0000:83:00.0 reg 10 io port: [7800, 78ff]
PCI: 0000:83:00.0 reg 14 64bit mmio: [ddffc000, ddffffff]
PCI: 0000:83:00.0 reg 30 32bit mmio: [ddf80000, ddfbffff]
pci 0000:83:00.1: found [1077/2532] class 000c04 header type 00
PCI: 0000:83:00.1 reg 10 io port: [7400, 74ff]
PCI: 0000:83:00.1 reg 14 64bit mmio: [ddff8000, ddffbfff]
PCI: 0000:83:00.1 reg 30 32bit mmio: [ddf40000, ddf7ffff]
PCI: Fixups for bus 0000:83
PCI: bridge 0000:80:0f.0 io port: [7000, 7fff]
PCI: bridge 0000:80:0f.0 32bit mmio: [ddf00000, ddffffff]
PCI: Bus scan for 0000:83 returning with max=83
pci 0000:80:0b.0: scanning behind bridge, config 818180, pass 1
pci 0000:80:0e.0: scanning behind bridge, config 828280, pass 1
pci 0000:80:0f.0: scanning behind bridge, config 838380, pass 1
PCI: Bus scan for 0000:80 returning with max=83
bus 80 -> pxm 1 -> node 1
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.BR81._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.BR82._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCIB.BR83._PRT]
initcall acpi_pci_root_init+0x0/0x28 returned 0 after 1148 msecs


..

calling  pci_subsys_init+0x0/0x121
..
request_resource: root: (PCI Bus #00) [8000, dfff], new: (PCI Bus
0000:01) [b000, bfff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new: (PCI
Bus 0000:01) [df000000, dfbfffff] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new: (PCI Bus
0000:03) [c000, cfff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new: (PCI
Bus 0000:03) [dfc00000, dfcfffff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new: (PCI
Bus 0000:04) [dfd00000, dfffffff] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new: (PCI Bus
0000:83) [7000, 7fff] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new: (PCI
Bus 0000:83) [ddf00000, ddffffff] conflict 0
request_resource: root: (PCI Bus #00) [e000, efff], new:
(0000:00:01.0) [ef00, ef7f] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:01.1) [ac00, ac3f] conflict 0
request_resource: root: (PCI Bus #00) [e000, efff], new:
(0000:00:01.1) [ed00, ed3f] conflict 0
request_resource: root: (PCI Bus #00) [e000, efff], new:
(0000:00:01.1) [ee00, ee3f] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:02.0) [defbf000, defbffff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:02.1) [defbec00, defbecff] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.0) [a480, a487] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.0) [a400, a403] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.0) [a080, a087] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.0) [a000, a003] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.0) [9c00, 9c0f] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:05.0) [defbd000, defbdfff] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.1) [9880, 9887] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.1) [9800, 9803] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.1) [9480, 9487] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.1) [9400, 9403] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.1) [9080, 908f] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:05.1) [defbc000, defbcfff] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.2) [9000, 9007] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.2) [8c00, 8c03] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.2) [8880, 8887] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.2) [8800, 8803] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:05.2) [8480, 848f] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:05.2) [defbb000, defbbfff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:08.0) [defba000, defbafff] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:08.0) [8400, 8407] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:08.0) [defbe800, defbe8ff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:08.0) [defbe400, defbe40f] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:09.0) [defb9000, defb9fff] conflict 0
request_resource: root: (PCI Bus #00) [8000, dfff], new:
(0000:00:09.0) [8080, 8087] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:09.0) [defbe000, defbe0ff] conflict 0
request_resource: root: (PCI Bus #00) [de000000, dfffffff], new:
(0000:00:09.0) [defb8c00, defb8c0f] conflict 0
request_resource: root: (PCI Bus 0000:01) [df000000, dfbfffff], new:
(0000:01:05.0) [df000000, df7fffff] conflict 0
request_resource: root: (PCI Bus 0000:01) [df000000, dfbfffff], new:
(0000:01:05.0) [dfbe0000, dfbfffff] conflict 0
request_resource: root: (PCI Bus 0000:01) [b000, bfff], new:
(0000:01:05.0) [bc00, bc7f] conflict 0
request_resource: root: (PCI Bus 0000:03) [dfc00000, dfcfffff], new:
(0000:03:00.0) [dfcff000, dfcfffff] conflict 0
request_resource: root: (PCI Bus 0000:03) [dfc00000, dfcfffff], new:
(0000:03:00.0) [dfcf8000, dfcfbfff] conflict 0
request_resource: root: (PCI Bus 0000:03) [c000, cfff], new:
(0000:03:00.0) [c800, c8ff] conflict 0
request_resource: root: (PCI Bus 0000:03) [dfc00000, dfcfffff], new:
(0000:03:00.1) [dfcfe000, dfcfefff] conflict 0
request_resource: root: (PCI Bus 0000:03) [dfc00000, dfcfffff], new:
(0000:03:00.1) [dfcf4000, dfcf7fff] conflict 0
request_resource: root: (PCI Bus 0000:03) [c000, cfff], new:
(0000:03:00.1) [c400, c4ff] conflict 0
request_resource: root: (PCI Bus 0000:04) [dfd00000, dfffffff], new:
(0000:04:00.0) [dfe00000, dfffffff] conflict 0
request_resource: root: (PCI Bus #80) [f000, ffff], new:
(0000:80:01.0) [fc00, fc7f] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:01.0) [ddeff000, ddefffff] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:01.1) [6880, 68bf] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:01.1) [6800, 683f] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:01.1) [6480, 64bf] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.0) [6400, 6407] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.0) [6080, 6083] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.0) [6000, 6007] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.0) [5c00, 5c03] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.0) [5880, 588f] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:05.0) [ddefe000, ddefefff] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.1) [5800, 5807] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.1) [5480, 5483] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.1) [5400, 5407] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.1) [5080, 5083] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.1) [5000, 500f] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:05.1) [ddefd000, ddefdfff] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.2) [4c00, 4c07] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.2) [4880, 4883] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.2) [4800, 4807] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.2) [4480, 4483] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:05.2) [4400, 440f] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:05.2) [ddefc000, ddefcfff] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:08.0) [ddefb000, ddefbfff] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:08.0) [4080, 4087] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:08.0) [ddefac00, ddefacff] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:08.0) [ddefa800, ddefa80f] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:09.0) [ddef9000, ddef9fff] conflict 0
request_resource: root: (PCI Bus #80) [4000, 7fff], new:
(0000:80:09.0) [4000, 4007] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:09.0) [ddefa400, ddefa4ff] conflict 0
request_resource: root: (PCI Bus #80) [dd000000, ddffffff], new:
(0000:80:09.0) [ddefa000, ddefa00f] conflict 0
request_resource: root: (PCI Bus 0000:83) [7000, 7fff], new:
(0000:83:00.0) [7800, 78ff] conflict 0
request_resource: root: (PCI Bus 0000:83) [ddf00000, ddffffff], new:
(0000:83:00.0) [ddffc000, ddffffff] conflict 0
request_resource: root: (PCI Bus 0000:83) [7000, 7fff], new:
(0000:83:00.1) [7400, 74ff] conflict 0
request_resource: root: (PCI Bus 0000:83) [ddf00000, ddffffff], new:
(0000:83:00.1) [ddff8000, ddffbfff] conflict 0
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [d7ff0000, d7ffffff]
    insert_resource: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], new: (reserved) [d7ff0000, d7ffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [dd800000, efffffff]
  insert_resource: first: (PCI Bus #80) [dd000000, ddffffff], new:
(reserved) [dd800000, efffffff]
found conflict for reserved [dd800000, efffffff], try to insert with expand
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [dd800000, efffffff]
  insert_resource: first: (PCI Bus #80) [dd000000, ddffffff], new:
(reserved) [dd800000, efffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [dd000000, efffffff]
  insert_resource: first: (PCI Bus #80) [dd000000, ddffffff], new:
(reserved) [dd000000, efffffff]
  insert_resource: direct parent: (PCI mem) [0, ffffffffffffffff],
new: (reserved) [dd000000, efffffff]
    insert_resource: child: (PCI Bus #80) [dd000000, ddffffff], new:
(reserved) [dd000000, efffffff]
    insert_resource: child: (PCI Bus #00) [de000000, dfffffff], new:
(reserved) [dd000000, efffffff]
    insert_resource: child: (PCI MMCONFIG 0) [e0000000, efffffff],
new: (reserved) [dd000000, efffffff]
   expand to reserved [dd000000, efffffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [fec00000, fec00fff]
  insert_resource: first: (PCI Bus #00) [f0000000, ffffffff], new:
(reserved) [fec00000, fec00fff]
    insert_resource: good with request direct parent: (PCI Bus #00)
[f0000000, ffffffff], new: (reserved) [fec00000, fec00fff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [fee00000, feefffff]
  insert_resource: first: (PCI Bus #00) [f0000000, ffffffff], new:
(reserved) [fee00000, feefffff]
    insert_resource: good with request direct parent: (PCI Bus #00)
[f0000000, ffffffff], new: (reserved) [fee00000, feefffff]
insert_resource: parent: (PCI mem) [0, ffffffffffffffff], new:
(reserved) [ff700000, ffffffff]
  insert_resource: first: (PCI Bus #00) [f0000000, ffffffff], new:
(reserved) [ff700000, ffffffff]
    insert_resource: good with request direct parent: (PCI Bus #00)
[f0000000, ffffffff], new: (reserved) [ff700000, ffffffff]
initcall pci_subsys_init+0x0/0x121 returned 0 after 770 msecs

calling  proto_init+0x0/0x2e
initcall proto_init+0x0/0x2e returned 0 after 0 msecs

calling  net_dev_init+0x0/0x155
initcall net_dev_init+0x0/0x155 returned 0 after 0 msecs

calling  neigh_init+0x0/0x71
initcall neigh_init+0x0/0x71 returned 0 after 0 msecs

calling  genl_init+0x0/0xd9
initcall genl_init+0x0/0xd9 returned 0 after 15 msecs

calling  sysctl_init+0x0/0x49
initcall sysctl_init+0x0/0x49 returned 0 after 0 msecs

calling  pci_iommu_init+0x0/0x17
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
initcall pci_iommu_init+0x0/0x17 returned 0 after 22 msecs


calling  pnp_system_init+0x0/0x12
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (pnp
00:05) [4d0, 4d1]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (pnp 00:05) [4d0, 4d1]
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (pnp
00:05) [800, 80f]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (pnp 00:05) [800, 80f]
system 00:05: ioport range 0x800-0x80f has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [e000, e07f]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [e000, e07f]
system 00:05: ioport range 0xe000-0xe07f has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [e080, e0ff]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [e080, e0ff]
system 00:05: ioport range 0xe080-0xe0ff has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [e400, e47f]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [e400, e47f]
system 00:05: ioport range 0xe400-0xe47f has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [e480, e4ff]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [e480, e4ff]
system 00:05: ioport range 0xe480-0xe4ff has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [e800, e87f]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [e800, e87f]
system 00:05: ioport range 0xe800-0xe87f has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [e880, e8ff]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [e880, e8ff]
system 00:05: ioport range 0xe880-0xe8ff has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [ec00, ec7f]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [ec00, ec7f]
system 00:05: ioport range 0xec00-0xec7f has been reserved
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (pnp
00:05) [ec80, ecff]
    __request_region: good with request direct parent: (PCI Bus #00)
[e000, efff], res: (pnp 00:05) [ec80, ecff]
system 00:05: ioport range 0xec80-0xecff has been reserved
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(pnp 00:05) [defc0000, deffffff]
busy flag
system 00:05: iomem range 0xdefc0000-0xdeffffff could not be reserved
  __request_region: conflict: (PCI Bus #00) [f0000000, ffffffff], res:
(pnp 00:05) [fee01000, feefffff]
  __request_region: conflict: (reserved) [fee00000, feefffff], res:
(pnp 00:05) [fee01000, feefffff]
busy flag
system 00:05: iomem range 0xfee01000-0xfeefffff could not be reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:06) [f000, f07f]
    __request_region: good with request direct parent: (PCI Bus #80)
[f000, ffff], res: (pnp 00:06) [f000, f07f]
system 00:06: ioport range 0xf000-0xf07f has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:06) [f080, f0ff]
    __request_region: good with request direct parent: (PCI Bus #80)
[f000, ffff], res: (pnp 00:06) [f080, f0ff]
system 00:06: ioport range 0xf080-0xf0ff has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:06) [f400, f47f]
    __request_region: good with request direct parent: (PCI Bus #80)
[f000, ffff], res: (pnp 00:06) [f400, f47f]
system 00:06: ioport range 0xf400-0xf47f has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:06) [f480, f4ff]
    __request_region: good with request direct parent: (PCI Bus #80)
[f000, ffff], res: (pnp 00:06) [f480, f4ff]
system 00:06: ioport range 0xf480-0xf4ff has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:06) [f800, f87f]
    __request_region: good with request direct parent: (PCI Bus #80)
[f000, ffff], res: (pnp 00:06) [f800, f87f]
system 00:06: ioport range 0xf800-0xf87f has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:06) [f880, f8ff]
    __request_region: good with request direct parent: (PCI Bus #80)
[f000, ffff], res: (pnp 00:06) [f880, f8ff]
system 00:06: ioport range 0xf880-0xf8ff has been reserved
  __request_region: conflict: (PCI Bus #00) [f0000000, ffffffff], res:
(pnp 00:06) [fee01000, fef00fff]
  __request_region: conflict: (reserved) [fee00000, feefffff], res:
(pnp 00:06) [fee01000, fef00fff]
busy flag
system 00:06: iomem range 0xfee01000-0xfef00fff could not be reserved
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (pnp
00:0a) [ca0, ca1]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (pnp 00:0a) [ca0, ca1]
system 00:0a: ioport range 0xca0-0xca1 has been reserved
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (pnp
00:0a) [ca4, caf]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (pnp 00:0a) [ca4, caf]
system 00:0a: ioport range 0xca4-0xcaf has been reserved
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (pnp
00:0a) [cf9, cf9]
  __request_region: conflict: (PCI conf1) [cf8, cff], res: (pnp 00:0a)
[cf9, cf9]
busy flag
system 00:0a: ioport range 0xcf9-0xcf9 could not be reserved
  __request_region: conflict: (PCI Bus #00) [f0000000, ffffffff], res:
(pnp 00:0a) [fec00000, fec00fff]
  __request_region: conflict: (reserved) [fec00000, fec00fff], res:
(pnp 00:0a) [fec00000, fec00fff]
busy flag
system 00:0a: iomem range 0xfec00000-0xfec00fff could not be reserved
  __request_region: conflict: (PCI Bus #00) [f0000000, ffffffff], res:
(pnp 00:0a) [fee00000, fee00fff]
  __request_region: conflict: (reserved) [fee00000, feefffff], res:
(pnp 00:0a) [fee00000, fee00fff]
busy flag
system 00:0a: iomem range 0xfee00000-0xfee00fff could not be reserved
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(pnp 00:0b) [e0000000, efffffff]
busy flag
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
  __request_region: conflict: (System RAM) [0, 973ff], res: (pnp
00:0c) [0, 9ffff]
busy flag
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
    __request_region: good with request direct parent: (PCI mem) [0,
ffffffffffffffff], res: (pnp 00:0c) [c0000, cffff]
system 00:0c: iomem range 0xc0000-0xcffff has been reserved
  __request_region: conflict: (reserved) [e0000, fffff], res: (pnp
00:0c) [e0000, fffff]
busy flag
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
  __request_region: conflict: (System RAM) [100000, d7f9ffff], res:
(pnp 00:0c) [100000, ddffffff]
busy flag
system 00:0c: iomem range 0x100000-0xddffffff could not be reserved
  __request_region: conflict: (PCI Bus #00) [f0000000, ffffffff], res:
(pnp 00:0c) [fec00000, ffffffff]
  __request_region: conflict: (reserved) [fec00000, fec00fff], res:
(pnp 00:0c) [fec00000, ffffffff]
busy flag
system 00:0c: iomem range 0xfec00000-0xffffffff could not be reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:0e) [f000, f07f]
  __request_region: conflict: (pnp 00:06) [f000, f07f], res: (pnp
00:0e) [f000, f07f]
    __request_region: good with request direct parent: (pnp 00:06)
[f000, f07f], res: (pnp 00:0e) [f000, f07f]
system 00:0e: ioport range 0xf000-0xf07f has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:0e) [f080, f0ff]
  __request_region: conflict: (pnp 00:06) [f080, f0ff], res: (pnp
00:0e) [f080, f0ff]
    __request_region: good with request direct parent: (pnp 00:06)
[f080, f0ff], res: (pnp 00:0e) [f080, f0ff]
system 00:0e: ioport range 0xf080-0xf0ff has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:0e) [f400, f47f]
  __request_region: conflict: (pnp 00:06) [f400, f47f], res: (pnp
00:0e) [f400, f47f]
    __request_region: good with request direct parent: (pnp 00:06)
[f400, f47f], res: (pnp 00:0e) [f400, f47f]
system 00:0e: ioport range 0xf400-0xf47f has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:0e) [f480, f4ff]
  __request_region: conflict: (pnp 00:06) [f480, f4ff], res: (pnp
00:0e) [f480, f4ff]
    __request_region: good with request direct parent: (pnp 00:06)
[f480, f4ff], res: (pnp 00:0e) [f480, f4ff]
system 00:0e: ioport range 0xf480-0xf4ff has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:0e) [f800, f87f]
  __request_region: conflict: (pnp 00:06) [f800, f87f], res: (pnp
00:0e) [f800, f87f]
    __request_region: good with request direct parent: (pnp 00:06)
[f800, f87f], res: (pnp 00:0e) [f800, f87f]
system 00:0e: ioport range 0xf800-0xf87f has been reserved
  __request_region: conflict: (PCI Bus #80) [f000, ffff], res: (pnp
00:0e) [f880, f8ff]
  __request_region: conflict: (pnp 00:06) [f880, f8ff], res: (pnp
00:0e) [f880, f8ff]
    __request_region: good with request direct parent: (pnp 00:06)
[f880, f8ff], res: (pnp 00:0e) [f880, f8ff]
system 00:0e: ioport range 0xf880-0xf8ff has been reserved
  __request_region: conflict: (PCI Bus #00) [f0000000, ffffffff], res:
(pnp 00:0e) [fee01000, fef00fff]
  __request_region: conflict: (reserved) [fee00000, feefffff], res:
(pnp 00:0e) [fee01000, fef00fff]
busy flag
system 00:0e: iomem range 0xfee01000-0xfef00fff could not be reserved
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(pnp 00:0e) [dde80000, ddebffff]
busy flag
system 00:0e: iomem range 0xdde80000-0xddebffff could not be reserved
initcall pnp_system_init+0x0/0x12 returned 0 after 828 msecs

calling  chr_dev_init+0x0/0xa1
initcall chr_dev_init+0x0/0xa1 returned 0 after 0 msecs

calling  firmware_class_init+0x0/0x79
initcall firmware_class_init+0x0/0x79 returned 0 after 0 msecs

calling  loopback_init+0x0/0x12
initcall loopback_init+0x0/0x12 returned 0 after 0 msecs

calling  cpufreq_gov_performance_init+0x0/0x12
initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 msecs

calling  init_acpi_pm_clocksource+0x0/0xa9
initcall init_acpi_pm_clocksource+0x0/0xa9 returned 0 after 0 msecs

calling  pcibios_assign_resources+0x0/0x88
request_resource: root: (PCI Bus 0000:03) [dfc00000, dfcfffff], new:
(0000:03:00.0) [dfc80000, dfcbffff] conflict 0
request_resource: root: (PCI Bus 0000:03) [dfc00000, dfcfffff], new:
(0000:03:00.1) [dfc40000, dfc7ffff] conflict 0
request_resource: root: (PCI Bus 0000:04) [dfd00000, dfffffff], new:
(0000:04:00.0) [dfd80000, dfdfffff] conflict 0
request_resource: root: (PCI Bus 0000:83) [ddf00000, ddffffff], new:
(0000:83:00.0) [ddf80000, ddfbffff] conflict 0
request_resource: root: (PCI Bus 0000:83) [ddf00000, ddffffff], new:
(0000:83:00.1) [ddf40000, ddf7ffff] conflict 0
pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
pci 0000:00:06.0:   IO window: 0xb000-0xbfff
pci 0000:00:06.0:   MEM window: 0xdf000000-0xdfbfffff
pci 0000:00:06.0:   PREFETCH window: disabled
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: disabled
pci 0000:00:0a.0:   MEM window: disabled
pci 0000:00:0a.0:   PREFETCH window: disabled
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0e.0:   IO window: 0xc000-0xcfff
pci 0000:00:0e.0:   MEM window: 0xdfc00000-0xdfcfffff
pci 0000:00:0e.0:   PREFETCH window: disabled
pci 0000:00:0f.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0f.0:   IO window: disabled
pci 0000:00:0f.0:   MEM window: 0xdfd00000-0xdfffffff
pci 0000:00:0f.0:   PREFETCH window: disabled
pci 0000:00:06.0: setting latency timer to 64
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci 0000:00:0f.0: setting latency timer to 64
pci 0000:80:0b.0: PCI bridge, secondary bus 0000:81
pci 0000:80:0b.0:   IO window: disabled
pci 0000:80:0b.0:   MEM window: disabled
pci 0000:80:0b.0:   PREFETCH window: disabled
pci 0000:80:0e.0: PCI bridge, secondary bus 0000:82
pci 0000:80:0e.0:   IO window: disabled
pci 0000:80:0e.0:   MEM window: disabled
pci 0000:80:0e.0:   PREFETCH window: disabled
pci 0000:80:0f.0: PCI bridge, secondary bus 0000:83
pci 0000:80:0f.0:   IO window: 0x7000-0x7fff
pci 0000:80:0f.0:   MEM window: 0xddf00000-0xddffffff
pci 0000:80:0f.0:   PREFETCH window: disabled
pci 0000:80:0b.0: setting latency timer to 64
pci 0000:80:0e.0: setting latency timer to 64
pci 0000:80:0f.0: setting latency timer to 64
bus: 00 index 0 io port: [8000, dfff]
bus: 00 index 1 io port: [e000, efff]
bus: 00 index 2 io port: [0, 3fff]
bus: 00 index 3 mmio: [de000000, dfffffff]
bus: 00 index 4 mmio: [a0000, bffff]
bus: 00 index 5 mmio: [d8000000, dcffffff]
bus: 00 index 6 mmio: [f0000000, ffffffff]
bus: 00 index 7 mmio: [2028000000, fcffffffff]
bus: 01 index 0 io port: [b000, bfff]
bus: 01 index 1 mmio: [df000000, dfbfffff]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 io port: [8000, dfff]
bus: 01 index 4 io port: [e000, efff]
bus: 01 index 5 io port: [0, 3fff]
bus: 01 index 6 mmio: [de000000, dfffffff]
bus: 01 index 7 mmio: [a0000, bffff]
bus: 01 index 8 mmio: [d8000000, dcffffff]
bus: 01 index 9 mmio: [f0000000, ffffffff]
bus: 01 index a mmio: [2028000000, fcffffffff]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [c000, cfff]
bus: 03 index 1 mmio: [dfc00000, dfcfffff]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [dfd00000, dfffffff]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 80 index 0 io port: [4000, 7fff]
bus: 80 index 1 io port: [f000, ffff]
bus: 80 index 2 mmio: [dd000000, ddffffff]
bus: 81 index 0 mmio: [0, 0]
bus: 81 index 1 mmio: [0, 0]
bus: 81 index 2 mmio: [0, 0]
bus: 81 index 3 mmio: [0, 0]
bus: 82 index 0 mmio: [0, 0]
bus: 82 index 1 mmio: [0, 0]
bus: 82 index 2 mmio: [0, 0]
bus: 82 index 3 mmio: [0, 0]
bus: 83 index 0 io port: [7000, 7fff]
bus: 83 index 1 mmio: [ddf00000, ddffffff]
bus: 83 index 2 mmio: [0, 0]
bus: 83 index 3 mmio: [0, 0]
initcall pcibios_assign_resources+0x0/0x88 returned 0 after 327 msecs

calling  inet_init+0x0/0x1f2
NET: Registered protocol family 2
IP route cache hash table entries: 4194304 (order: 13, 33554432 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
initcall inet_init+0x0/0x1f2 returned 0 after 93 msecs

calling  af_unix_init+0x0/0x55
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x55 returned 0 after 2 msecs

calling  populate_rootfs+0x0/0x238
checking if image is initramfs...it isn't (no cpio magic); looks like an initrd
Freeing initrd memory: 25763k freed
initcall populate_rootfs+0x0/0x238 returned 0 after 1081 msecs

calling  pci_init+0x0/0x109
..

calling  ehci_hcd_init+0x0/0x1b
ehci_hcd 0000:00:02.1: PCI INT B -> Link[LUB2] -> GSI 21 (level, low) -> IRQ 21
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(ehci_hcd) [defbec00, defbecff]
busy flag
ehci_hcd 0000:00:02.1: PCI INT B disabled
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -16
ehci_hcd: probe of 0000:00:02.1 failed with error -16
initcall ehci_hcd_init+0x0/0x1b returned 0 after 28 msecs

calling  ohci_hcd_mod_init+0x0/0x42
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:02.0: PCI INT A -> Link[LUB0] -> GSI 22 (level, low) -> IRQ 22
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(ohci_hcd) [defbf000, defbffff]
busy flag
ohci_hcd 0000:00:02.0: PCI INT A disabled
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -16
ohci_hcd: probe of 0000:00:02.0 failed with error -16
initcall ohci_hcd_mod_init+0x0/0x42 returned 0 after 34 msecs



calling  acpi_reserve_resources+0x0/0xeb
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (ACPI
PM1a_EVT_BLK) [e000, e003]
  __request_region: conflict: (pnp 00:05) [e000, e07f], res: (ACPI
PM1a_EVT_BLK) [e000, e003]
    __request_region: good with request direct parent: (pnp 00:05)
[e000, e07f], res: (ACPI PM1a_EVT_BLK) [e000, e003]
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (ACPI
PM1a_CNT_BLK) [e004, e005]
  __request_region: conflict: (pnp 00:05) [e000, e07f], res: (ACPI
PM1a_CNT_BLK) [e004, e005]
    __request_region: good with request direct parent: (pnp 00:05)
[e000, e07f], res: (ACPI PM1a_CNT_BLK) [e004, e005]
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (ACPI
PM_TMR) [e008, e00b]
  __request_region: conflict: (pnp 00:05) [e000, e07f], res: (ACPI
PM_TMR) [e008, e00b]
    __request_region: good with request direct parent: (pnp 00:05)
[e000, e07f], res: (ACPI PM_TMR) [e008, e00b]
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (ACPI
GPE0_BLK) [e020, e027]
  __request_region: conflict: (pnp 00:05) [e000, e07f], res: (ACPI
GPE0_BLK) [e020, e027]
    __request_region: good with request direct parent: (pnp 00:05)
[e000, e07f], res: (ACPI GPE0_BLK) [e020, e027]
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (ACPI
GPE1_BLK) [e4a0, e4af]
  __request_region: conflict: (pnp 00:05) [e480, e4ff], res: (ACPI
GPE1_BLK) [e4a0, e4af]
    __request_region: good with request direct parent: (pnp 00:05)
[e480, e4ff], res: (ACPI GPE1_BLK) [e4a0, e4af]
initcall acpi_reserve_resources+0x0/0xeb returned 0 after 125 msecs

calling  acpi_ac_init+0x0/0x28
initcall acpi_ac_init+0x0/0x28 returned 0 after 0 msecs

calling  acpi_fan_init+0x0/0x32
initcall acpi_fan_init+0x0/0x32 returned 0 after 0 msecs

calling  irqrouter_init_sysfs+0x0/0x38
initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 0 msecs

calling  acpi_pci_slot_init+0x0/0x20
initcall acpi_pci_slot_init+0x0/0x20 returned 0 after 0 msecs

calling  acpi_processor_init+0x0/0x10a
  __request_region: conflict: (PCI Bus #00) [e000, efff], res: (ACPI
CPU throttle) [e010, e015]
  __request_region: conflict: (pnp 00:05) [e000, e07f], res: (ACPI CPU
throttle) [e010, e015]
    __request_region: good with request direct parent: (pnp 00:05)
[e000, e07f], res: (ACPI CPU throttle) [e010, e015]
processor ACPI0007:00: registered as cooling_device0
processor ACPI0007:01: registered as cooling_device1
processor ACPI0007:02: registered as cooling_device2
processor ACPI0007:03: registered as cooling_device3
processor ACPI0007:04: registered as cooling_device4
processor ACPI0007:05: registered as cooling_device5
processor ACPI0007:06: registered as cooling_device6
processor ACPI0007:07: registered as cooling_device7
processor ACPI0007:08: registered as cooling_device8
processor ACPI0007:09: registered as cooling_device9
processor ACPI0007:0a: registered as cooling_device10
processor ACPI0007:0b: registered as cooling_device11
processor ACPI0007:0c: registered as cooling_device12
processor ACPI0007:0d: registered as cooling_device13
processor ACPI0007:0e: registered as cooling_device14
processor ACPI0007:0f: registered as cooling_device15
initcall acpi_processor_init+0x0/0x10a returned 0 after 99 msecs

calling  hpet_init+0x0/0x6a
hpet_resources: 0xfed00000 is busy
initcall hpet_init+0x0/0x6a returned 0 after 3 msecs

calling  serial8250_init+0x0/0x116
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (serial) [3f8, 3ff]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial) [3f8, 3ff]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res:
(serial-rsa) [3f0, 3f7]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial-rsa) [3f0, 3f7]
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (serial) [2f8, 2ff]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial) [2f8, 2ff]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res:
(serial-rsa) [2f0, 2f7]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial-rsa) [2f0, 2f7]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (serial) [3e8, 3ef]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial) [3e8, 3ef]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res:
(serial-rsa) [3e0, 3e7]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial-rsa) [3e0, 3e7]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (serial) [2e8, 2ef]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial) [2e8, 2ef]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res:
(serial-rsa) [2e0, 2e7]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial-rsa) [2e0, 2e7]
initcall serial8250_init+0x0/0x116 returned 0 after 136 msecs

calling  serial8250_pnp_init+0x0/0x12
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res: (serial) [3f8, 3ff]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial) [3f8, 3ff]
  __request_region: conflict: (PCI Bus #00) [0, 3fff], res:
(serial-rsa) [3f0, 3f7]
    __request_region: good with request direct parent: (PCI Bus #00)
[0, 3fff], res: (serial-rsa) [3f0, 3f7]
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_pnp_init+0x0/0x12 returned 0 after 36 msecs


calling  init_nic+0x0/0x1b
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
forcedeth 0000:00:08.0: PCI INT A -> Link[LMAC] -> GSI 21 (level, low) -> IRQ 21
forcedeth 0000:00:08.0: setting latency timer to 64
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(forcedeth) [defba000, defbafff]
busy flag
forcedeth 0000:00:08.0: BAR 0: can't reserve mem region [0xdefba000-0xdefbafff]
forcedeth 0000:00:08.0: PCI INT A disabled
forcedeth: probe of 0000:00:08.0 failed with error -16
forcedeth 0000:00:09.0: PCI INT A -> Link[LMAD] -> GSI 20 (level, low) -> IRQ 20
forcedeth 0000:00:09.0: setting latency timer to 64
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(forcedeth) [defb9000, defb9fff]
busy flag
forcedeth 0000:00:09.0: BAR 0: can't reserve mem region [0xdefb9000-0xdefb9fff]
forcedeth 0000:00:09.0: PCI INT A disabled
forcedeth: probe of 0000:00:09.0 failed with error -16
forcedeth 0000:80:08.0: PCI INT A -> Link[IIM0] -> GSI 47 (level, low) -> IRQ 47
forcedeth 0000:80:08.0: setting latency timer to 64
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(forcedeth) [ddefb000, ddefbfff]
busy flag
forcedeth 0000:80:08.0: BAR 0: can't reserve mem region [0xddefb000-0xddefbfff]
forcedeth 0000:80:08.0: PCI INT A disabled
forcedeth: probe of 0000:80:08.0 failed with error -16
forcedeth 0000:80:09.0: PCI INT A -> Link[IIM1] -> GSI 46 (level, low) -> IRQ 46
forcedeth 0000:80:09.0: setting latency timer to 64
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(forcedeth) [ddef9000, ddef9fff]
busy flag
forcedeth 0000:80:09.0: BAR 0: can't reserve mem region [0xddef9000-0xddef9fff]
forcedeth 0000:80:09.0: PCI INT A disabled
forcedeth: probe of 0000:80:09.0 failed with error -16
initcall init_nic+0x0/0x1b returned 0 after 148 msecs
...

calling  qla2x00_module_init+0x0/0x12c
QLogic Fibre Channel HBA Driver: 8.02.01-k7
vendor=10de device=0377
qla2xxx 0000:83:00.0: PCI INT A -> Link[LE3B] -> GSI 43 (level, low) -> IRQ 43
  __request_region: conflict: (reserved) [dd000000, efffffff], res:
(qla2xxx) [ddffc000, ddffffff]
busy flag
qla2xxx 0000:83:00.0: BAR 1: can't reserve mem region [0xddffc000-0xddffffff]
qla2xxx 0000:83:00.0: Failed to reserve PIO/MMIO regions (0000:83:00.0)
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffff80672f9c>] qla2x00_free_device+0x571/0x618
PGD 0
Oops: 0000 [1] SMP
Dumping ftrace buffer:
   (ftrace buffer empty)
CPU 4
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.27-rc5-tip-00672-ge5c5407-dirty #220
RIP: 0010:[<ffffffff80672f9c>]  [<ffffffff80672f9c>]
qla2x00_free_device+0x571/0x618
RSP: 0018:ffff881824cafb10  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8810228ec630 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff881824cafb60 R08: ffff881824caf9c0 R09: 0000000000000000
R10: ffffffff8105b190 R11: 0000000000000010 R12: 00000000fffffff4
R13: ffff8810228ee790 R14: ffff882024acf890 R15: ffff8810228ec630
FS:  0000000000000000(0000) GS:ffff881024c78400(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff881824cae000, task ffff881024c90000)
Stack:  ffffffff80cd7a4b 0000000000000042 ffff882024acf800 ffff8810228ec630
 ffff881824cafb60 ffff882024acf9c0 00000000fffffff4 0000000000000042
 ffff882024acf890 ffff8810228ec630 ffff881824cafc70 ffffffff80948a81
Call Trace:
 [<ffffffff80948a81>] qla2x00_probe_one+0x112a/0x121a
 [<ffffffff8025393d>] ? default_wake_function+0x0/0xf
 [<ffffffff80966aa2>] ? wait_for_completion+0x18/0x1a
 [<ffffffff80257944>] ? set_cpus_allowed_ptr+0xfc/0x120
 [<ffffffff804cbf4a>] pci_device_probe+0xc8/0x11f
 [<ffffffff80544820>] driver_probe_device+0xc5/0x173
 [<ffffffff80544922>] __driver_attach+0x54/0x7e
 [<ffffffff805448ce>] ? __driver_attach+0x0/0x7e
 [<ffffffff80544076>] bus_for_each_dev+0x54/0x8e
 [<ffffffff804ba3c8>] ? kobject_get+0x1a/0x22
 [<ffffffff8054465c>] driver_attach+0x21/0x23
 [<ffffffff80543964>] bus_add_driver+0xbc/0x206
 [<ffffffff80544b34>] driver_register+0xad/0x12d
 [<ffffffff804cc213>] __pci_register_driver+0x6b/0xa4
 [<ffffffff80f00eb6>] ? qla2x00_module_init+0x0/0x12c
 [<ffffffff80f00fb2>] qla2x00_module_init+0xfc/0x12c
 [<ffffffff8020904c>] _stext+0x4c/0x144
 [<ffffffff8026aa63>] ? start_workqueue_thread+0x2b/0x2f
 [<ffffffff8026ae85>] ? __create_workqueue_key+0x112/0x22c
 [<ffffffff80ed578f>] kernel_init+0x228/0x29d
 [<ffffffff80227ff9>] child_rip+0xa/0x11
 [<ffffffff8023d489>] ? ftrace_test_p6nop+0x0/0xa
 [<ffffffff80ed5567>] ? kernel_init+0x0/0x29d
 [<ffffffff80227fef>] ? child_rip+0x0/0x11
Code: c7 83 c8 00 00 00 00 00 00 00 48 c7 83 c0 00 00 00 00 00 00 00
48 c7 83 a8 00 00 00 00 00 00 00 48 c7 83 a0 00 00 00 00 00 00 00 <4c>
8b 27 eb 21 48 8b 17 48 8b 47 08 48 89 42 08 48 89 10 48 89
RIP  [<ffffffff80672f9c>] qla2x00_free_device+0x571/0x618
 RSP <ffff881824cafb10>
CR2: 0000000000000000
---[ end trace 0e925ad07301302a ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D
2.6.27-rc5-tip-00672-ge5c5407-dirty #220
Call Trace:
 [<ffffffff80966666>] panic+0xa5/0x15c
 [<ffffffff80966789>] ? printk+0x6c/0x73
 [<ffffffff80517ce7>] ? account+0xe3/0xf2
 [<ffffffff80517e37>] ? extract_entropy+0x55/0x9c
 [<ffffffff8025dc5e>] do_exit+0x73/0x812
 [<ffffffff80517f72>] ? get_random_bytes+0x20/0x22
 [<ffffffff80969688>] oops_begin+0x0/0x9a
 [<ffffffff8096b679>] do_page_fault+0x7cb/0x8bf
 [<ffffffff8025ad99>] ? __call_console_drivers+0x6a/0x7b
 [<ffffffff8025b7da>] ? vprintk+0x2a0/0x2cc
 [<ffffffff80966789>] ? printk+0x6c/0x73
 [<ffffffff80969029>] error_exit+0x0/0x51
 [<ffffffff80672f9c>] ? qla2x00_free_device+0x571/0x618
 [<ffffffff80948a81>] qla2x00_probe_one+0x112a/0x121a
 [<ffffffff8025393d>] ? default_wake_function+0x0/0xf
 [<ffffffff80966aa2>] ? wait_for_completion+0x18/0x1a
 [<ffffffff80257944>] ? set_cpus_allowed_ptr+0xfc/0x120
 [<ffffffff804cbf4a>] pci_device_probe+0xc8/0x11f
 [<ffffffff80544820>] driver_probe_device+0xc5/0x173
 [<ffffffff80544922>] __driver_attach+0x54/0x7e
 [<ffffffff805448ce>] ? __driver_attach+0x0/0x7e
 [<ffffffff80544076>] bus_for_each_dev+0x54/0x8e
 [<ffffffff804ba3c8>] ? kobject_get+0x1a/0x22
 [<ffffffff8054465c>] driver_attach+0x21/0x23
 [<ffffffff80543964>] bus_add_driver+0xbc/0x206
 [<ffffffff80544b34>] driver_register+0xad/0x12d
 [<ffffffff804cc213>] __pci_register_driver+0x6b/0xa4
 [<ffffffff80f00eb6>] ? qla2x00_module_init+0x0/0x12c
 [<ffffffff80f00fb2>] qla2x00_module_init+0xfc/0x12c
 [<ffffffff8020904c>] _stext+0x4c/0x144
 [<ffffffff8026aa63>] ? start_workqueue_thread+0x2b/0x2f
 [<ffffffff8026ae85>] ? __create_workqueue_key+0x112/0x22c
 [<ffffffff80ed578f>] kernel_init+0x228/0x29d
 [<ffffffff80227ff9>] child_rip+0xa/0x11
 [<ffffffff8023d489>] ? ftrace_test_p6nop+0x0/0xa
 [<ffffffff80ed5567>] ? kernel_init+0x0/0x29d
 [<ffffffff80227fef>] ? child_rip+0x0/0x11
