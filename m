Return-Path: <linux-kernel-owner+w=401wt.eu-S1753209AbZG3LZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbZG3LZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 07:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZG3LZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 07:25:51 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:50430 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZG3LZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 07:25:50 -0400
Message-ID: <4A718338.6050907@in.ibm.com>
Date: Thu, 30 Jul 2009 16:55:44 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
In-Reply-To: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------050907000001080904000205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050907000001080904000205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Today's Next failed to boot on a x86_64 box with following traces

ACPI: Core revision 20090625
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
PGD 0
Oops: 0002 [#1] SMP
last sysfs file:
CPU 0
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.31-rc4-autotest-next-20090730-5-default #1 BladeCenter LS21 -[79716AA]-
RIP: 0010:[<ffffffff81328c7b>]  [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
RSP: 0018:ffff88012b319e20  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000cbdc
RDX: 000000000000cbf0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88012b319e80 R08: 0000000000000004 R09: ffff880028092bc0
R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
R13: ffff8800280362c0 R14: ffff8800280362c0 R15: 00000000000142c0
FS:  0000000000000000(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88012b318000, task ffff88012b316000)
Stack:
 0000000000000003 000000000000cbe8 000000000000cbf8 000000000000cbf0
<0> 000000000000cbdc 00000000000142c0 0000000000000000 0000000000000003
<0> 0000000000000004 000000000000cbf8 000000000000cbe8 00000000000142c0
Call Trace:
 [<ffffffff81664c96>] native_smp_prepare_cpus+0x146/0x3b6
 [<ffffffff8165b594>] kernel_init+0x84/0x1db
 [<ffffffff8100ca1a>] child_rip+0xa/0x20
 [<ffffffff8165b510>] ? kernel_init+0x0/0x1db
 [<ffffffff8100ca10>] ? child_rip+0x0/0x20
Code: 00 00 48 89 c2 49 23 85 b0 00 00 00 49 23 96 b0 00 00 00 48 39 c2 75 2b 49 63 c4 48 8b 55 b8 48 8b 04 c5 90 fe 63 81 48 8b 04 02 <f0> 0f ab 18 48 63 c3 48 8b 04 c5 90 fe 63 81 48 8b 04 02 f0 44
RIP  [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
 RSP <ffff88012b319e20>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.31-rc4-autotest-next-20090730-5-default #1
Call Trace:
 [<ffffffff8132bc59>] panic+0x75/0x120
 [<ffffffff8104f41a>] ? exit_ptrace+0x33/0x12b
 [<ffffffff810493c0>] do_exit+0x79/0x6c8
 [<ffffffff8132f329>] oops_end+0xb3/0xbb
 [<ffffffff8102934f>] no_context+0x1ed/0x1fc
 [<ffffffff810294f0>] __bad_area_nosemaphore+0x192/0x1b8
 [<ffffffff810ac967>] ? __alloc_pages_nodemask+0x118/0x57d
 [<ffffffff81029524>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8133077f>] do_page_fault+0x187/0x2c6
 [<ffffffff8132e86f>] page_fault+0x1f/0x30
 [<ffffffff81328c7b>] ? set_cpu_sibling_map+0x24f/0x353
 [<ffffffff81664c96>] native_smp_prepare_cpus+0x146/0x3b6
 [<ffffffff8165b594>] kernel_init+0x84/0x1db
 [<ffffffff8100ca1a>] child_rip+0xa/0x20
 [<ffffffff8165b510>] ? kernel_init+0x0/0x1db
 [<ffffffff8100ca10>] ? child_rip+0x0/0x20

The failure points to the following piece of code :

if ((c->phys_proc_id == o->phys_proc_id) &&
    (c->cpu_node_id == o->cpu_node_id)) {
         cpumask_set_cpu(i, cpu_node_mask(cpu)); << ==
         cpumask_set_cpu(cpu, cpu_node_mask(i)); << ==
}


Yesterday's Next tree worked fine. Have attached the boot log.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------050907000001080904000205
Content-Type: text/plain;
 name="boot-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot-log"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.31-rc4-autotest-next-20090730-5-default (root@mls21b) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Thu Jul 30 14:47:18 IST 2009
Command line: root=/dev/sda1 console=tty0 console=ttyS1,19200 resume=/dev/disk/by-id/scsi-3500000e015c26a80-part2 splash=silent crashkernel=256M-:128M@16M IDENT=1248946314
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c000 (usable)
 BIOS-e820: 000000000009c000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cffa3900 (usable)
 BIOS-e820: 00000000cffa3900 - 00000000cffa7400 (ACPI data)
 BIOS-e820: 00000000cffa7400 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000f4000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
DMI 2.4 present.
last_pfn = 0x130000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcffa3 max_arch_pfn = 0x400000000
init_memory_mapping: 0000000000000000-00000000cffa3000
init_memory_mapping: 0000000100000000-0000000130000000
RAMDISK: 3771f000 - 37fef6c7
ACPI: RSDP 00000000000fdfe0 00014 (v00 IBM   )
ACPI: RSDT 00000000cffa7380 00038 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: FACP 00000000cffa72c0 00084 (v02 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: DSDT 00000000cffa3900 036CE (v01 IBM    SERLEWIS 00001000 INTL 20060912)
ACPI: FACS 00000000cffa7040 00040
ACPI: APIC 00000000cffa7200 00090 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: SRAT 00000000cffa7100 000E8 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: HPET 00000000cffa70c0 00038 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: MCFG 00000000cffa7080 0003C (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 1 -> APIC 2 -> Node 1
SRAT: PXM 1 -> APIC 3 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-d0000000
SRAT: Node 0 PXM 0 100000000-130000000
Bootmem setup node 0 0000000000000000-0000000130000000
  NODE_DATA [000000000000f640 - 000000000004363f]
  bootmap [0000000000044000 -  0000000000069fff] pages 26
(9 early reservations) ==> bootmem [0000000000 - 0130000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 0005d186b4]    TEXT DATA BSS ==> [0001000000 - 0005d186b4]
  #3 [003771f000 - 0037fef6c7]          RAMDISK ==> [003771f000 - 0037fef6c7]
  #4 [000009c000 - 0000100000]    BIOS reserved ==> [000009c000 - 0000100000]
  #5 [0005d19000 - 0005d192d0]              BRK ==> [0005d19000 - 0005d192d0]
  #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #7 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
  #8 [000000d000 - 000000f640]       MEMNODEMAP ==> [000000d000 - 000000f640]
found SMP MP-table at [ffff88000009c140] 9c140
crashkernel reservation failed - memory is in use
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00130000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009c
    0: 0x00000100 -> 0x000cffa3
    0: 0x00100000 -> 0x00130000
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x488
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[16])
IOAPIC[1]: apic_id 13, version 17, address 0xfec02000, GSI 16-31
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x1166a201 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009c000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000cffa3000 - 00000000cffa4000
PM: Registered nosave memory: 00000000cffa4000 - 00000000cffa7000
PM: Registered nosave memory: 00000000cffa7000 - 00000000cffa8000
PM: Registered nosave memory: 00000000cffa8000 - 00000000d0000000
PM: Registered nosave memory: 00000000d0000000 - 00000000f4000000
PM: Registered nosave memory: 00000000f4000000 - 00000000fc000000
PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at d0000000 (gap: d0000000:24000000)
NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 28 pages at ffff880028022000, static data 85408 bytes
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031249
Policy zone: Normal
Kernel command line: root=/dev/sda1 console=tty0 console=ttyS1,19200 resume=/dev/disk/by-id/scsi-3500000e015c26a80-part2 splash=silent crashkernel=256M-:128M@16M IDENT=1248946314
PID hash table entries: 4096 (order: 12, 32768 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ f4000000 size 64 MB
Node 1: aperture @ f4000000 size 64 MB
Memory: 4045260k/4980736k available (3281k kernel code, 787204k absent, 148272k reserved, 3170k data, 1360k init)
start_kernel(): bug: interrupts were enabled *very* early, fixing it
Hierarchical RCU implementation.
NR_IRQS:4352
Fast TSC calibration using PIT
Detected 2199.723 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 4399.44 BogoMIPS (lpj=8798892)
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Node ID: 0
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
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
PGD 0 
Oops: 0002 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.31-rc4-autotest-next-20090730-5-default #1 BladeCenter LS21 -[79716AA]-
RIP: 0010:[<ffffffff81328c7b>]  [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
RSP: 0018:ffff88012b319e20  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000000000000cbdc
RDX: 000000000000cbf0 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff88012b319e80 R08: 0000000000000004 R09: ffff880028092bc0
R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
R13: ffff8800280362c0 R14: ffff8800280362c0 R15: 00000000000142c0
FS:  0000000000000000(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88012b318000, task ffff88012b316000)
Stack:
 0000000000000003 000000000000cbe8 000000000000cbf8 000000000000cbf0
<0> 000000000000cbdc 00000000000142c0 0000000000000000 0000000000000003
<0> 0000000000000004 000000000000cbf8 000000000000cbe8 00000000000142c0
Call Trace:
 [<ffffffff81664c96>] native_smp_prepare_cpus+0x146/0x3b6
 [<ffffffff8165b594>] kernel_init+0x84/0x1db
 [<ffffffff8100ca1a>] child_rip+0xa/0x20
 [<ffffffff8165b510>] ? kernel_init+0x0/0x1db
 [<ffffffff8100ca10>] ? child_rip+0x0/0x20
Code: 00 00 48 89 c2 49 23 85 b0 00 00 00 49 23 96 b0 00 00 00 48 39 c2 75 2b 49 63 c4 48 8b 55 b8 48 8b 04 c5 90 fe 63 81 48 8b 04 02 <f0> 0f ab 18 48 63 c3 48 8b 04 c5 90 fe 63 81 48 8b 04 02 f0 44 
RIP  [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
 RSP <ffff88012b319e20>
CR2: 0000000000000000
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D    2.6.31-rc4-autotest-next-20090730-5-default #1
Call Trace:
 [<ffffffff8132bc59>] panic+0x75/0x120
 [<ffffffff8104f41a>] ? exit_ptrace+0x33/0x12b
 [<ffffffff810493c0>] do_exit+0x79/0x6c8
 [<ffffffff8132f329>] oops_end+0xb3/0xbb
 [<ffffffff8102934f>] no_context+0x1ed/0x1fc
 [<ffffffff810294f0>] __bad_area_nosemaphore+0x192/0x1b8
 [<ffffffff810ac967>] ? __alloc_pages_nodemask+0x118/0x57d
 [<ffffffff81029524>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8133077f>] do_page_fault+0x187/0x2c6
 [<ffffffff8132e86f>] page_fault+0x1f/0x30
 [<ffffffff81328c7b>] ? set_cpu_sibling_map+0x24f/0x353
 [<ffffffff81664c96>] native_smp_prepare_cpus+0x146/0x3b6
 [<ffffffff8165b594>] kernel_init+0x84/0x1db
 [<ffffffff8100ca1a>] child_rip+0xa/0x20
 [<ffffffff8165b510>] ? kernel_init+0x0/0x1db
 [<ffffffff8100ca10>] ? child_rip+0x0/0x20


--------------050907000001080904000205--
