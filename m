Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYJaWmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYJaWmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYJaWmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:42:10 -0400
Received: from sec.bit-consulting.com.ar ([200.69.255.76]:56777 "EHLO
	sec.bit-consulting.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbYJaWmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:42:07 -0400
Message-ID: <59727.163.10.1.174.1225492920.squirrel@sec.bit-consulting.com.ar>
In-Reply-To: <86802c440810262217h13f78e57l1f234e8e86b72785@mail.gmail.com>
References: <200810262246.21807.dvadell@linuxclusters.com.ar>
    <86802c440810262217h13f78e57l1f234e8e86b72785@mail.gmail.com>
Date: Fri, 31 Oct 2008 19:42:00 -0300 (ART)
Subject: Re: PAT and MTRRs
From: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> can you try 2.6.28-rc2 ot tip/master and boot with mtrr_cleanup_debug ?
>
> YH

Hello,
  Thank you very much and sorry for the delay. This is a remote site and I
have to travel to get here.

  I upgradedt to 2.6.28-rc2 but the problem persists. Here is the
(hopefully) relevant part of dmesg:

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc2 (root@compute-0-5.local) (gcc version 3.4.6
20060404 (Red Hat 3.4.6-8))
#1 SMP Fri Oct 31 18:01:52 ART 2008
Command line: ro root=LABEL=/  mtrr_cleanup_debug
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cf561000 (usable)
 BIOS-e820: 00000000cf561000 - 00000000cf56e000 (reserved)
 BIOS-e820: 00000000cf56e000 - 00000000cf612000 (usable)
 BIOS-e820: 00000000cf612000 - 00000000cf6e9000 (ACPI NVS)
 BIOS-e820: 00000000cf6e9000 - 00000000cf6ed000 (usable)
 BIOS-e820: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
 BIOS-e820: 00000000cf6f2000 - 00000000cf6f3000 (usable)
 BIOS-e820: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
 BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
 BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 000000012c000000 (usable)
DMI 2.4 present.
last_pfn = 0x12c000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
After WB checking
MTRR MAP PFN: 0000000000000000 - 00000000000d0000
After UC checking
MTRR MAP PFN: 0000000000000000 - 00000000000cf700
After sorting
MTRR MAP PFN: 0000000000000000 - 00000000000cf700
WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 704MB of RAM.
------------[ cut here ]------------
WARNING: at arch/x86/kernel/cpu/mtrr/main.c:1662
mtrr_trim_uncached_memory+0x331/0x358()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.28-rc2 #1
Call Trace:
 [<ffffffff80232c63>] warn_on_slowpath+0x51/0x6d
 [<ffffffff80233b5f>] printk+0x8d/0x95
 [<ffffffff80306735>] generic_swap+0x0/0x19
 [<ffffffff8060a92e>] cmp_range+0x0/0x6
 [<ffffffff8060b4f0>] mtrr_trim_uncached_memory+0x331/0x358
 [<ffffffff803efcf7>] dmi_table+0x6f/0x96
 [<ffffffff80621aa3>] dmi_decode+0x0/0x4ab
 [<ffffffff806072a8>] setup_arch+0x3f9/0x63c
 [<ffffffff8060083c>] start_kernel+0x6a/0x307
 [<ffffffff806003a1>] x86_64_start_kernel+0xef/0xf3
---[ end trace 4eaa2a86a8e2da22 ]---
update e820 for mtrr
modified physical RAM map:
 modified: 0000000000000000 - 000000000008f000 (usable)
 modified: 000000000008f000 - 00000000000a0000 (reserved)
 modified: 00000000000e0000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 00000000cf561000 (usable)
 modified: 00000000cf561000 - 00000000cf56e000 (reserved)
 modified: 00000000cf56e000 - 00000000cf612000 (usable)
 modified: 00000000cf612000 - 00000000cf6e9000 (ACPI NVS)
 modified: 00000000cf6e9000 - 00000000cf6ed000 (usable)
 modified: 00000000cf6ed000 - 00000000cf6f2000 (ACPI data)
 modified: 00000000cf6f2000 - 00000000cf6f3000 (usable)
 modified: 00000000cf6f3000 - 00000000cf6ff000 (ACPI data)
 modified: 00000000cf6ff000 - 00000000cf700000 (usable)
 modified: 00000000cf700000 - 00000000d0000000 (reserved)
 modified: 00000000fff00000 - 000000012c000000 (reserved)
last_pfn = 0xcf700 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 00cf600000 page 2M
 00cf600000 - 00cf700000 page 4k
kernel direct mapping tables up to cf700000 @ 8000-e000
last_map_addr: cf700000 end: cf700000
RAMDISK: 37ef3000 - 37fef849
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT CF6FD038, 004C (r1 INTEL  DG965WH       697       1000013)
ACPI: FACP CF6FC000, 0074 (r1 INTEL  DG965WH       697 MSFT  1000013)
ACPI: DSDT CF6F7000, 40ED (r1 INTEL  DG965WH       697 MSFT  1000013)
ACPI: FACS CF6A0000, 0040
ACPI: APIC CF6F6000, 0078 (r1 INTEL  DG965WH       697 MSFT  1000013)
ACPI: WDDT CF6F5000, 0040 (r1 INTEL  DG965WH       697 MSFT  1000013)
ACPI: MCFG CF6F4000, 003C (r1 INTEL  DG965WH       697 MSFT  1000013)
ACPI: ASF! CF6F3000, 00A6 (r32 INTEL  DG965WH       697 MSFT  1000013)
ACPI: SSDT CF6F1000, 01BC (r1 INTEL     CpuPm      697 MSFT  1000013)
ACPI: SSDT CF6F0000, 0175 (r1 INTEL   Cpu0Ist      697 MSFT  1000013)
ACPI: SSDT CF6EF000, 0175 (r1 INTEL   Cpu1Ist      697 MSFT  1000013)
ACPI: SSDT CF6EE000, 0175 (r1 INTEL   Cpu2Ist      697 MSFT  1000013)
ACPI: SSDT CF6ED000, 0175 (r1 INTEL   Cpu3Ist      697 MSFT  1000013)
ACPI: Local APIC address 0xfee00000
(6 early reservations) ==> bootmem [0000000000 - 00cf700000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00006ddca8]    TEXT DATA BSS ==> [0000200000 - 00006ddca8]
  #3 [0037ef3000 - 0037fef849]          RAMDISK ==> [0037ef3000 - 0037fef849]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
found SMP MP-table at [ffff8800000fe200] 000fe200
 [ffffe20000000000-ffffe200033fffff] PMD ->
[ffff880001200000-ffff8800045fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[6] active PFN ranges
    0: 0x00000000 -> 0x0000008f
    0: 0x00000100 -> 0x000cf561
    0: 0x000cf56e -> 0x000cf612
    0: 0x000cf6e9 -> 0x000cf6ed
    0: 0x000cf6f2 -> 0x000cf6f3
    0: 0x000cf6ff -> 0x000cf700
On node 0 totalpages: 849306
  DMA zone: 64 pages used for memmap
  DMA zone: 1350 pages reserved
  DMA zone: 2569 pages, LIFO batch:0
  DMA32 zone: 13212 pages used for memmap
  DMA32 zone: 832111 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
Allocating PCI resources starting at d4000000 (gap: d0000000:2ff00000)
PERCPU: Allocating 49152 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 834680
Kernel command line: ro root=LABEL=/  mtrr_cleanup_debug
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2397.700 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
No AGP bridge found
Memory: 3330720k/3398656k available (2536k kernel code, 65836k reserved,
1406k data, 376k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency..
4795.40 BogoMIPS (lpj=9590800)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
Freeing SMP alternatives: 22k freed
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Booting processor 1 APIC 0x2 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4795.51 BogoMIPS
(lpj=9591031)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x1 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4795.50 BogoMIPS
(lpj=9591000)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4795.50 BogoMIPS
(lpj=9591018)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (19181.92 BogoMIPS).

I can send you the complete dmesg if you want.

Thanks again,
 -- Diego

