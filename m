Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0CAEe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 23:34:58 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:58648 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0CAEe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 23:34:57 -0500
Message-ID: <4B8B43E9.1010506@in.ibm.com>
Date: Mon, 01 Mar 2010 10:04:49 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: 2.6.33-git6 boot failure[x86_64] (WARN: at arch/x86/mm/ioremap.c:111)
Content-Type: multipart/mixed;
 boundary="------------000609020605050902030508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000609020605050902030508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Latest 2.6.33 git(30ff056..) failed to boot on a x86_64 box
with errors during mptsas/mptbase initialization. I also
noticed a warning during ACPI initialization.

Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20091214
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x169/0x2f1()
Hardware name: BladeCenter LS21 -[79716AA]-
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.33-git6-autotest #1
Call Trace:
 [<ffffffff81047cff>] ? __ioremap_caller+0x169/0x2f1
 [<ffffffff81063b7d>] warn_slowpath_common+0x77/0xa4
 [<ffffffff81063bb9>] warn_slowpath_null+0xf/0x11
 [<ffffffff81047cff>] __ioremap_caller+0x169/0x2f1
 [<ffffffff813747a3>] ? acpi_os_map_memory+0x12/0x1b
 [<ffffffff81047f10>] ioremap_nocache+0x12/0x14
 [<ffffffff813747a3>] acpi_os_map_memory+0x12/0x1b
 [<ffffffff81282fa0>] acpi_tb_verify_table+0x29/0x5b
 [<ffffffff812827f0>] acpi_load_tables+0x39/0x15a
 [<ffffffff8191c8f8>] acpi_early_init+0x60/0xf5
 [<ffffffff818f2cad>] start_kernel+0x397/0x3a7
 [<ffffffff818f2295>] x86_64_start_reservations+0xa5/0xa9
 [<ffffffff818f237a>] x86_64_start_kernel+0xe1/0xe8
---[ end trace 4eaa2a86a8e2da22 ]---
ioremap reserve_memtype failed -22
ACPI Exception: AE_NO_ACPI_TABLES, While loading namespace from ACPI tables (20091214/tbxface-604)
ACPI: Unable to load the System Description Tables

I observed similar failure with x86_32 as well.

2.6.33-git5 (847f9c6...) worked fine.

Have attached dmesg log.

Thanks
-Sachin


-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------


--------------000609020605050902030508
Content-Type: text/plain;
 name="boot-log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot-log"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.33-git6-autotest (root@mls21b) (gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Mon Mar 1 07:39:00 IST 2010
Command line: root=/dev/disk/by-id/scsi-3500000e015c26a80-part1 console=tty0 console=ttyS1,19200 IDENT=1267410292
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
NX (Execute Disable) protection: active
DMI 2.4 present.
No AGP bridge found
last_pfn = 0x130000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xcffa3 max_arch_pfn = 0x400000000
found SMP MP-table at [ffff88000009c140] 9c140
init_memory_mapping: 0000000000000000-00000000cffa3000
init_memory_mapping: 0000000100000000-0000000130000000
RAMDISK: 375d9000 - 37fef1d6
ACPI: RSDP 00000000000fdfe0 00014 (v00 IBM   )
ACPI: RSDT 00000000cffa7380 00038 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: FACP 00000000cffa72c0 00084 (v02 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: DSDT 00000000cffa3900 036CE (v01 IBM    SERLEWIS 00001000 INTL 20060912)
ACPI: FACS 00000000cffa7040 00040
ACPI: APIC 00000000cffa7200 00090 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: SRAT 00000000cffa7100 000E8 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: HPET 00000000cffa70c0 00038 (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
ACPI: MCFG 00000000cffa7080 0003C (v01 IBM    SERLEWIS 00001000 IBM  45444F43)
SRAT: PXM 0 -> APIC 0x00 -> Node 0
SRAT: PXM 0 -> APIC 0x01 -> Node 0
SRAT: PXM 1 -> APIC 0x02 -> Node 1
SRAT: PXM 1 -> APIC 0x03 -> Node 1
SRAT: Node 0 PXM 0 0-a0000
SRAT: Node 0 PXM 0 100000-d0000000
SRAT: Node 0 PXM 0 100000000-130000000
Bootmem setup node 0 0000000000000000-0000000130000000
  NODE_DATA [000000000000f640 - 000000000004363f]
  bootmap [0000000000044000 -  0000000000069fff] pages 26
(14 early reservations) ==> bootmem [0000000000 - 0130000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0001000000 - 0005f608d4]    TEXT DATA BSS ==> [0001000000 - 0005f608d4]
  #2 [00375d9000 - 0037fef1d6]          RAMDISK ==> [00375d9000 - 0037fef1d6]
  #3 [0005f61000 - 0005f612d0]              BRK ==> [0005f61000 - 0005f612d0]
  #4 [000009c000 - 000009c140]    BIOS reserved ==> [000009c000 - 000009c140]
  #5 [000009c140 - 000009c150]     MP-table mpf ==> [000009c140 - 000009c150]
  #6 [000009c150 - 000009dce0]    BIOS reserved ==> [000009c150 - 000009dce0]
  #7 [000009de64 - 0000100000]    BIOS reserved ==> [000009de64 - 0000100000]
  #8 [000009dce0 - 000009de64]     MP-table mpc ==> [000009dce0 - 000009de64]
  #9 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 - 0000003000]
  #10 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 - 0000007000]
  #11 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
  #12 [000000c000 - 000000d000]          PGTABLE ==> [000000c000 - 000000d000]
  #13 [000000d000 - 000000f640]       MEMNODEMAP ==> [000000d000 - 000000f640]
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00130000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000001 -> 0x0000009c
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
setup_percpu: NR_CPUS:4096 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:2
PERCPU: Embedded 29 pages/cpu @ffff880009c00000 s89192 r8192 d21400 u524288
pcpu-alloc: s89192 r8192 d21400 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031245
Policy zone: Normal
Kernel command line: root=/dev/disk/by-id/scsi-3500000e015c26a80-part1 console=tty0 console=ttyS1,19200 IDENT=1267410292
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ f4000000 size 64 MB
Node 1: aperture @ f4000000 size 64 MB
Memory: 3975472k/4980736k available (3635k kernel code, 787208k absent, 218056k reserved, 5429k data, 800k init)
SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=2
Hierarchical RCU implementation.
RCU-based detection of stalled CPUs is enabled.
NR_IRQS:4352
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
allocated 41943040 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Fast TSC calibration using PIT
Detected 2200.201 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4400.40 BogoMIPS (lpj=8800804)
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
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
using C1E aware idle routine
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
ACPI: Core revision 20091214
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:111 __ioremap_caller+0x169/0x2f1()
Hardware name: BladeCenter LS21 -[79716AA]-
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.33-git6-autotest #1
Call Trace:
 [<ffffffff81047cff>] ? __ioremap_caller+0x169/0x2f1
 [<ffffffff81063b7d>] warn_slowpath_common+0x77/0xa4
 [<ffffffff81063bb9>] warn_slowpath_null+0xf/0x11
 [<ffffffff81047cff>] __ioremap_caller+0x169/0x2f1
 [<ffffffff813747a3>] ? acpi_os_map_memory+0x12/0x1b
 [<ffffffff81047f10>] ioremap_nocache+0x12/0x14
 [<ffffffff813747a3>] acpi_os_map_memory+0x12/0x1b
 [<ffffffff81282fa0>] acpi_tb_verify_table+0x29/0x5b
 [<ffffffff812827f0>] acpi_load_tables+0x39/0x15a
 [<ffffffff8191c8f8>] acpi_early_init+0x60/0xf5
 [<ffffffff818f2cad>] start_kernel+0x397/0x3a7
 [<ffffffff818f2295>] x86_64_start_reservations+0xa5/0xa9
 [<ffffffff818f237a>] x86_64_start_kernel+0xe1/0xe8
---[ end trace 4eaa2a86a8e2da22 ]---
ioremap reserve_memtype failed -22
ACPI Exception: AE_NO_ACPI_TABLES, While loading namespace from ACPI tables (20091214/tbxface-604)
ACPI: Unable to load the System Description Tables
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Dual-Core AMD Opteron(tm) Processor 2218 stepping 02
Booting Node   0, Processors  #1 #2 #3 Ok.
Brought up 4 CPUs
Total of 4 processors activated (17601.12 BogoMIPS).
NET: Registered protocol family 16
TOM: 00000000d0000000 aka 3328M
TOM2: 0000000130000000 aka 4864M
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Interpreter disabled.
vgaarb: loaded
PCI: Probing PCI hardware
pci 0000:00:01.0: Enabling HT MSI Mapping
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:01:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:06.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0: PCI bridge to [bus 04-04]
pci 0000:00:08.0: PCI bridge to [bus 05-05]
pci 0000:00:09.0: PCI bridge to [bus 06-06]
pci 0000:00:0a.0: PCI bridge to [bus 07-07]
pci 0000:00:0b.0: PCI bridge to [bus 08-08]
vgaarb: device added: PCI:0000:00:05.0,decodes=io+mem,owns=io+mem,locks=none
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
pnp: PnP ACPI: disabled
pci 0000:00:06.0: BAR 9: assigned [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:05.0: BAR 6: assigned [mem 0xd0100000-0xd011ffff pref]
pci 0000:01:0d.0: PCI bridge to [bus 02-02]
pci 0000:01:0d.0:   bridge window [io  disabled]
pci 0000:01:0d.0:   bridge window [mem 0xe2000000-0xe6ffffff]
pci 0000:01:0d.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: PCI bridge to [bus 01-02]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem 0xe2000000-0xe7ffffff]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:03:04.0: BAR 6: assigned [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:06.0: PCI bridge to [bus 03-03]
pci 0000:00:06.0:   bridge window [io  0x4000-0x4fff]
pci 0000:00:06.0:   bridge window [mem 0xdf000000-0xe00fffff]
pci 0000:00:06.0:   bridge window [mem 0xd0000000-0xd00fffff pref]
pci 0000:00:07.0: PCI bridge to [bus 04-04]
pci 0000:00:07.0:   bridge window [io  disabled]
pci 0000:00:07.0:   bridge window [mem 0xdd000000-0xddffffff]
pci 0000:00:07.0:   bridge window [mem pref disabled]
pci 0000:00:08.0: PCI bridge to [bus 05-05]
pci 0000:00:08.0:   bridge window [io  disabled]
pci 0000:00:08.0:   bridge window [mem 0xdc000000-0xdcffffff]
pci 0000:00:08.0:   bridge window [mem pref disabled]
pci 0000:00:09.0: PCI bridge to [bus 06-06]
pci 0000:00:09.0:   bridge window [io  disabled]
pci 0000:00:09.0:   bridge window [mem 0xdb000000-0xdbffffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0a.0: PCI bridge to [bus 07-07]
pci 0000:00:0a.0:   bridge window [io  disabled]
pci 0000:00:0a.0:   bridge window [mem 0xda000000-0xdaffffff]
pci 0000:00:0a.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 08-08]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem 0xd9000000-0xd9ffffff]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
UDP hash table entries: 2048 (order: 4, 65536 bytes)
UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: disabled boot interrupts on device [1166:0205]
pci 0000:00:08.0: Found enabled HT MSI Mapping
pci 0000:00:09.0: Found enabled HT MSI Mapping
pci 0000:00:0a.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
Unpacking initramfs...
Freeing initrd memory: 10328k freed
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ f4000000 size 65536 KB
init_memory_mapping: 00000000f4000000-00000000f8000000
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
platform rtc_cmos: registered platform RTC device (no PNP device found)
audit: initializing netlink socket (disabled)
type=2000 audit(1267410435.628:1): initialized
rcu-torture:--- Start of test: nreaders=8 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7913
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
No TPM chip found, activating TPM-bypass!
Freeing unused kernel memory: 800k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 440k freed
Freeing unused kernel memory: 180k freed
doing fast boot
SCSI subsystem initialized
Fusion MPT base driver 3.04.14
Copyright (c) 1999-2008 LSI Corporation
Fusion MPT SAS Host driver 3.04.14
mptsas 0000:03:04.0: can't find IRQ for PCI INT A; probably buggy MP table
mptbase: ioc0: Initiating bringup
ioc0: LSISAS1064 A3: Capabilities={Initiator}
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x1, page 0x1, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x0, page 0x2, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x9, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
scsi0 : ioc0: LSISAS1064 A3, FwRev=000a0f00h, Ports=1, MaxQ=511, IRQ=9
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x10, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x11, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x11, page 0x0, action 0
mptbase: ioc0: WARNING - Issuing Reset from mpt_config!!
mptbase: ioc0: Initiating recovery
mptbase: ioc0: Attempting Retry Config request type 0x12, page 0x0, action 0


--------------000609020605050902030508--
