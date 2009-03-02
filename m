Return-Path: <linux-kernel-owner+w=401wt.eu-S1758903AbZCBBqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758903AbZCBBqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbZCBBpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:45:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42795 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756505AbZCBBpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:45:52 -0500
Message-ID: <49AB3A3A.4090003@redhat.com>
Date: Sun, 01 Mar 2009 20:45:30 -0500
From: Brian Maly <bmaly@redhat.com>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix e820 end address with EFI
References: <49A965AD.10701@redhat.com>	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>	 <49AAEC79.3000808@redhat.com> <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
Content-Type: multipart/mixed;
 boundary="------------050104050605080304070508"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050104050605080304070508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

And for reference purposes here is dmesg from a 2.6.29-rc4 kernel when 
max_pfn = very end of e820 (all mapping types) and we dont call efi_ioremap.
Without setting max_pfn = end e820 (all mapping types) efi_ioremap is 
called, returning early with NULL.

I will try and gather a bit more from the working kernel, specifically 
what ranges efi_ioremap is being passed when things work properly.

Brian

--------------050104050605080304070508
Content-Type: text/plain;
 name="dmesg.mac-efi.fixed"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.mac-efi.fixed"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.29-rc4 (root@dhcp30.install.boston.redhat.com) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Sat Feb 28 04:11:18 EST 2009
Command line: ro root=/dev/VolGroup00/LogVol00
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
 BIOS-e820: 000000000008f000 - 0000000000090000 (ACPI NVS)
 BIOS-e820: 0000000000090000 - 00000000000a0000 (usable)
 BIOS-e820: 00000000000a0000 - 00000000000c0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007eef0000 (usable)
 BIOS-e820: 000000007eef0000 - 000000007f0f1000 (ACPI NVS)
 BIOS-e820: 000000007f0f1000 - 000000007fe53000 (usable)
 BIOS-e820: 000000007fe53000 - 000000007fe79000 (reserved)
 BIOS-e820: 000000007fe79000 - 000000007fe89000 (usable)
 BIOS-e820: 000000007fe89000 - 000000007feb3000 (reserved)
 BIOS-e820: 000000007feb3000 - 000000007feb9000 (usable)
 BIOS-e820: 000000007feb9000 - 000000007febf000 (reserved)
 BIOS-e820: 000000007febf000 - 000000007fed2000 (usable)
 BIOS-e820: 000000007fed2000 - 000000007fed4000 (ACPI NVS)
 BIOS-e820: 000000007fed4000 - 000000007fed7000 (ACPI data)
 BIOS-e820: 000000007fed7000 - 000000007feda000 (ACPI NVS)
 BIOS-e820: 000000007feda000 - 000000007fedb000 (ACPI data)
 BIOS-e820: 000000007fedb000 - 000000007feef000 (ACPI NVS)
 BIOS-e820: 000000007feef000 - 000000007feff000 (ACPI data)
 BIOS-e820: 000000007feff000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f00f8000 - 00000000f00f9000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fffa0000 - 00000000fffd0000 (reserved)
DMI not present or invalid.
EFI v1.10 by Apple 
 ACPI=0x7fefe000  ACPI 2.0=0x7fefe014  SMBIOS=0x7fed3000 
Kernel-defined memdesc doesn't match the one from EFI!
EFI: mem00: type=7, attr=0xf, range=[0x0000000000000000-0x000000000008c000) (0MB)
EFI: mem01: type=2, attr=0xf, range=[0x000000000008c000-0x000000000008e000) (0MB)
EFI: mem02: type=7, attr=0xf, range=[0x000000000008e000-0x000000000008f000) (0MB)
EFI: mem03: type=10, attr=0xf, range=[0x000000000008f000-0x0000000000090000) (0MB)
EFI: mem04: type=7, attr=0xf, range=[0x0000000000090000-0x00000000000a0000) (0MB)
EFI: mem05: type=7, attr=0xf, range=[0x0000000000100000-0x000000007b002000) (1967MB)
EFI: mem06: type=2, attr=0xf, range=[0x000000007b002000-0x000000007b003000) (0MB)
EFI: mem07: type=7, attr=0xf, range=[0x000000007b003000-0x000000007b005000) (0MB)
EFI: mem08: type=2, attr=0xf, range=[0x000000007b005000-0x000000007c714000) (23MB)
EFI: mem09: type=1, attr=0xf, range=[0x000000007c714000-0x000000007c74c000) (0MB)
EFI: mem10: type=2, attr=0xf, range=[0x000000007c74c000-0x000000007c7ea000) (0MB)
EFI: mem11: type=4, attr=0xf, range=[0x000000007c7ea000-0x000000007ca57000) (2MB)
EFI: mem12: type=2, attr=0xf, range=[0x000000007ca57000-0x000000007ca9a000) (0MB)
EFI: mem13: type=1, attr=0xf, range=[0x000000007ca9a000-0x000000007cab6000) (0MB)
EFI: mem14: type=7, attr=0xf, range=[0x000000007cab6000-0x000000007d396000) (8MB)
EFI: mem15: type=2, attr=0xf, range=[0x000000007d396000-0x000000007d70d000) (3MB)
EFI: mem16: type=4, attr=0xf, range=[0x000000007d70d000-0x000000007ea40000) (19MB)
EFI: mem17: type=7, attr=0xf, range=[0x000000007ea40000-0x000000007ea4f000) (0MB)
EFI: mem18: type=4, attr=0xf, range=[0x000000007ea4f000-0x000000007ea78000) (0MB)
EFI: mem19: type=7, attr=0xf, range=[0x000000007ea78000-0x000000007ea79000) (0MB)
EFI: mem20: type=4, attr=0xf, range=[0x000000007ea79000-0x000000007eb0d000) (0MB)
EFI: mem21: type=7, attr=0xf, range=[0x000000007eb0d000-0x000000007ebfa000) (0MB)
EFI: mem22: type=4, attr=0xf, range=[0x000000007ebfa000-0x000000007eef0000) (2MB)
EFI: mem23: type=10, attr=0xf, range=[0x000000007eef0000-0x000000007f0f1000) (2MB)
EFI: mem24: type=4, attr=0xf, range=[0x000000007f0f1000-0x000000007fc72000) (11MB)
EFI: mem25: type=7, attr=0xf, range=[0x000000007fc72000-0x000000007fcd0000) (0MB)
EFI: mem26: type=3, attr=0xf, range=[0x000000007fcd0000-0x000000007fe4a000) (1MB)
EFI: mem27: type=7, attr=0xf, range=[0x000000007fe4a000-0x000000007fe53000) (0MB)
EFI: mem28: type=5, attr=0x800000000000000f, range=[0x000000007fe53000-0x000000007fe79000) (0MB)
EFI: mem29: type=7, attr=0xf, range=[0x000000007fe79000-0x000000007fe89000) (0MB)
EFI: mem30: type=6, attr=0x800000000000000f, range=[0x000000007fe89000-0x000000007feb3000) (0MB)
EFI: mem31: type=7, attr=0xf, range=[0x000000007feb3000-0x000000007feb9000) (0MB)
EFI: mem32: type=0, attr=0xf, range=[0x000000007feb9000-0x000000007febf000) (0MB)
EFI: mem33: type=7, attr=0xf, range=[0x000000007febf000-0x000000007fed2000) (0MB)
EFI: mem34: type=10, attr=0xf, range=[0x000000007fed2000-0x000000007fed4000) (0MB)
EFI: mem35: type=9, attr=0xf, range=[0x000000007fed4000-0x000000007fed7000) (0MB)
EFI: mem36: type=10, attr=0xf, range=[0x000000007fed7000-0x000000007feda000) (0MB)
EFI: mem37: type=9, attr=0xf, range=[0x000000007feda000-0x000000007fedb000) (0MB)
EFI: mem38: type=10, attr=0xf, range=[0x000000007fedb000-0x000000007feef000) (0MB)
EFI: mem39: type=9, attr=0xf, range=[0x000000007feef000-0x000000007feff000) (0MB)
EFI: mem40: type=6, attr=0x800000000000000f, range=[0x000000007feff000-0x000000007ff00000) (0MB)
EFI: mem41: type=0, attr=0x8000000000000000, range=[0x00000000000a0000-0x00000000000c0000) (0MB)
EFI: mem42: type=0, attr=0x8000000000000000, range=[0x000000007ff00000-0x0000000080000000) (1MB)
EFI: mem43: type=11, attr=0x8000000000000000, range=[0x00000000f00f8000-0x00000000f00f9000) (0MB)
EFI: mem44: type=11, attr=0x8000000000000000, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
EFI: mem45: type=11, attr=0x8000000000000000, range=[0x00000000fffa0000-0x00000000fffd0000) (0MB)
last_pfn = 0xfffd0 max_arch_pfn = 0x100000000
init_memory_mapping: 0000000000000000-00000000fffd0000
 0000000000 - 00ffe00000 page 2M
 00ffe00000 - 00fffd0000 page 4k
kernel direct mapping tables up to fffd0000 @ 8000-e000
last_map_addr: fffd0000 end: fffd0000
RAMDISK: 7d396000 - 7d70caff
ACPI: RSDP 7FEFE014, 0024 (r2 APPLE )
ACPI: XSDT 7FEFE1C0, 007C (r1 APPLE   Apple00       70       1000013)
ACPI: FACP 7FEFC000, 00F4 (r3 APPLE   Apple00       70 Loki       5F)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 7FEF1000, 48A8 (r1 APPLE  MacBookP    30001 INTL 20061109)
ACPI: FACS 7FEDB000, 0040
ACPI: HPET 7FEFB000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: APIC 7FEFA000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: MCFG 7FEF9000, 003C (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ASF! 7FEF8000, 00A5 (r32 APPLE   Apple00        1 Loki       5F)
ACPI: SBST 7FEF7000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ECDT 7FEF6000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: SSDT 7FEDA000, 0137 (r1 APPLE  SataAhci     1000 INTL 20061109)
ACPI: SSDT 7FED6000, 04DC (r1  APPLE    CpuPm     3000 INTL 20061109)
ACPI: SSDT 7FED5000, 025F (r1  APPLE  Cpu0Tst     3000 INTL 20061109)
ACPI: SSDT 7FED4000, 00A6 (r1  APPLE  Cpu1Tst     3000 INTL 20061109)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-00000000fffd0000
Bootmem setup node 0 0000000000000000-00000000fffd0000
  NODE_DATA [0000000000001000 - 0000000000005fff]
  bootmap [000000000000b000 -  000000000002afff] pages 20
(7 early reservations) ==> bootmem [0000000000 - 00fffd0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000833610]    TEXT DATA BSS ==> [0000200000 - 0000833610]
  #3 [007d396000 - 007d70caff]          RAMDISK ==> [007d396000 - 007d70caff]
  #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #5 [007b002000 - 007b0028a0]       EFI memmap ==> [007b002000 - 007b0028a0]
  #6 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
 [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000008f
    0: 0x00000090 -> 0x000000a0
    0: 0x00000100 -> 0x0007eef0
    0: 0x0007f0f1 -> 0x0007fe53
    0: 0x0007fe79 -> 0x0007fe89
    0: 0x0007feb3 -> 0x0007feb9
    0: 0x0007febf -> 0x0007fed2
On node 0 totalpages: 523290
  DMA zone: 56 pages used for memmap
  DMA zone: 1690 pages reserved
  DMA zone: 2253 pages, LIFO batch:0
  DMA32 zone: 7108 pages used for memmap
  DMA32 zone: 512183 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000008f000 - 0000000000090000
PM: Registered nosave memory: 00000000000a0000 - 00000000000c0000
PM: Registered nosave memory: 00000000000c0000 - 0000000000100000
PM: Registered nosave memory: 000000007eef0000 - 000000007f0f1000
PM: Registered nosave memory: 000000007fe53000 - 000000007fe79000
PM: Registered nosave memory: 000000007fe89000 - 000000007feb3000
PM: Registered nosave memory: 000000007feb9000 - 000000007febf000
PM: Registered nosave memory: 000000007fed2000 - 000000007fed4000
PM: Registered nosave memory: 000000007fed4000 - 000000007fed7000
PM: Registered nosave memory: 000000007fed7000 - 000000007feda000
PM: Registered nosave memory: 000000007feda000 - 000000007fedb000
PM: Registered nosave memory: 000000007fedb000 - 000000007feef000
PM: Registered nosave memory: 000000007feef000 - 000000007feff000
PM: Registered nosave memory: 000000007feff000 - 0000000080000000
PM: Registered nosave memory: 0000000080000000 - 00000000f00f8000
PM: Registered nosave memory: 00000000f00f8000 - 00000000f00f9000
PM: Registered nosave memory: 00000000f00f9000 - 00000000fed1c000
PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
PM: Registered nosave memory: 00000000fed20000 - 00000000fffa0000
PM: Registered nosave memory: 00000000fffa0000 - 00000000fffd0000
Allocating PCI resources starting at 88000000 (gap: 80000000:700f8000)
NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 57344 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514436
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2194.684 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2054288k/4194112k available (2921k kernel code, 2100952k absent, 38872k reserved, 1803k data, 480k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 4389.36 BogoMIPS (lpj=2194684)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
ACPI: Core revision 20081204
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4388.77 BogoMIPS (lpj=2194388)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (8778.14 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 1856 bytes
Time:  0:35:20  Date: 03/01/09
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x60c0-0x60df]
pci 0000:00:1a.1: reg 20 io port: [0x60a0-0x60bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0x9b504c00-0x9b504fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0x9b500000-0x9b503fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x6080-0x609f]
pci 0000:00:1d.1: reg 20 io port: [0x6060-0x607f]
pci 0000:00:1d.2: reg 20 io port: [0x6040-0x605f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0x9b504800-0x9b504bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
pci 0000:00:1f.1: reg 10 io port: [0x6108-0x610f]
pci 0000:00:1f.1: reg 14 io port: [0x611c-0x611f]
pci 0000:00:1f.1: reg 18 io port: [0x6100-0x6107]
pci 0000:00:1f.1: reg 1c io port: [0x6118-0x611b]
pci 0000:00:1f.1: reg 20 io port: [0x60e0-0x60ef]
pci 0000:00:1f.2: reg 10 io port: [0x60f8-0x60ff]
pci 0000:00:1f.2: reg 14 io port: [0x6114-0x6117]
pci 0000:00:1f.2: reg 18 io port: [0x60f0-0x60f7]
pci 0000:00:1f.2: reg 1c io port: [0x6110-0x6113]
pci 0000:00:1f.2: reg 20 io port: [0x6020-0x603f]
pci 0000:00:1f.2: reg 24 32bit mmio: [0x9b504000-0x9b5047ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 10 32bit mmio: [0x9b505000-0x9b5050ff]
pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
pci 0000:01:00.0: reg 10 32bit mmio: [0x92000000-0x92ffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0x80000000-0x8fffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0x90000000-0x91ffffff]
pci 0000:01:00.0: reg 24 io port: [0x5000-0x507f]
pci 0000:01:00.0: reg 30 32bit mmio: [0x93000000-0x9301ffff]
pci 0000:00:01.0: bridge io port: [0x5000-0x5fff]
pci 0000:00:01.0: bridge 32bit mmio: [0x90000000-0x930fffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0x80000000-0x8fffffff]
pci 0000:00:1c.0: bridge 32bit mmio: [0x9b400000-0x9b4fffff]
pci 0000:00:1c.2: bridge io port: [0x4000-0x4fff]
pci 0000:00:1c.2: bridge 32bit mmio: [0x97400000-0x9b3fffff]
pci 0000:00:1c.2: bridge 64bit mmio pref: [0x93100000-0x970fffff]
pci 0000:0b:00.0: reg 10 64bit mmio: [0x97300000-0x9730ffff]
pci 0000:0b:00.0: supports D1
pci 0000:0b:00.0: PME# supported from D0 D1 D3hot
pci 0000:0b:00.0: PME# disabled
pci 0000:00:1c.4: bridge 32bit mmio: [0x97300000-0x973fffff]
pci 0000:0c:00.0: reg 10 64bit mmio: [0x97200000-0x97203fff]
pci 0000:0c:00.0: reg 18 io port: [0x3000-0x30ff]
pci 0000:0c:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
pci 0000:0c:00.0: supports D1 D2
pci 0000:0c:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0c:00.0: PME# disabled
pci 0000:00:1c.5: bridge io port: [0x3000-0x3fff]
pci 0000:00:1c.5: bridge 32bit mmio: [0x97200000-0x972fffff]
pci 0000:0d:03.0: reg 10 32bit mmio: [0x97104000-0x971047ff]
pci 0000:0d:03.0: reg 14 32bit mmio: [0x97100000-0x97103fff]
pci 0000:0d:03.0: supports D1 D2
pci 0000:0d:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:0d:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0x97100000-0x971fffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:07: ioport range 0x680-0x69f has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x810-0x817 has been reserved
system 00:07: ioport range 0x400-0x47f has been reserved
system 00:07: ioport range 0x500-0x53f has been reserved
system 00:07: ioport range 0x1640-0x164f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x5000-0x5fff
pci 0000:00:01.0:   MEM window: 0x90000000-0x930fffff
pci 0000:00:01.0:   PREFETCH window: 0x00000080000000-0x0000008fffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0x9b400000-0x9b4fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.2:   IO window: 0x4000-0x4fff
pci 0000:00:1c.2:   MEM window: 0x97400000-0x9b3fffff
pci 0000:00:1c.2:   PREFETCH window: 0x00000093100000-0x000000970fffff
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0b
pci 0000:00:1c.4:   IO window: disabled
pci 0000:00:1c.4:   MEM window: 0x97300000-0x973fffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:0c
pci 0000:00:1c.5:   IO window: 0x3000-0x3fff
pci 0000:00:1c.5:   MEM window: 0x97200000-0x972fffff
pci 0000:00:1c.5:   PREFETCH window: 0x0000009b600000-0x0000009b6fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0d
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0x97100000-0x971fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0000 -> 0002)
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.2: enabling device (0000 -> 0003)
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0x5000-0x5fff]
pci_bus 0000:01: resource 1 mem: [0x90000000-0x930fffff]
pci_bus 0000:01: resource 2 mem: [0x80000000-0x8fffffff]
pci_bus 0000:01: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 mem: [0x0-0x0]
pci_bus 0000:02: resource 1 mem: [0x9b400000-0x9b4fffff]
pci_bus 0000:02: resource 2 mem: [0x0-0x0]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:03: resource 1 mem: [0x97400000-0x9b3fffff]
pci_bus 0000:03: resource 2 mem: [0x93100000-0x970fffff]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:0b: resource 0 mem: [0x0-0x0]
pci_bus 0000:0b: resource 1 mem: [0x97300000-0x973fffff]
pci_bus 0000:0b: resource 2 mem: [0x0-0x0]
pci_bus 0000:0b: resource 3 mem: [0x0-0x0]
pci_bus 0000:0c: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:0c: resource 1 mem: [0x97200000-0x972fffff]
pci_bus 0000:0c: resource 2 mem: [0x9b600000-0x9b6fffff]
pci_bus 0000:0c: resource 3 mem: [0x0-0x0]
pci_bus 0000:0d: resource 0 mem: [0x0-0x0]
pci_bus 0000:0d: resource 1 mem: [0x97100000-0x971fffff]
pci_bus 0000:0d: resource 2 mem: [0x0-0x0]
pci_bus 0000:0d: resource 3 io:  [0x00-0xffff]
pci_bus 0000:0d: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3546k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1235867720.460:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 4019
SELinux:  Registering netfilter hooks
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1a.0: Performing full reset
pci 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1a.1: Performing full reset
pci 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0080
pci 0000:00:1d.2: Performing full reset
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: irq 27 for MSI/MSI-X
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: irq 28 for MSI/MSI-X
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: SSDT 7FED9A98, 02FE (r1  APPLE  Cpu0Ist     3000 INTL 20061109)
ACPI: SSDT 7FED7C18, 02A0 (r1  APPLE  Cpu0Cst     3001 INTL 20061109)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7FED8F18, 00C8 (r1  APPLE  Cpu1Ist     3000 INTL 20061109)
ACPI: SSDT 7FED7F18, 0085 (r1  APPLE  Cpu1Cst     3000 INTL 20061109)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input0
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: RTC can wake from S4
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
EFI Variables Facility v0.08 2004-May-17
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 1:81:556
pci_link PNP0C0F:07: hash matches
Freeing unused kernel memory: 480k freed
Write protecting the kernel read-only data: 4264k
Clocksource tsc unstable (delta = -110383661 ns)
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1a.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: supports USB remote wakeup
ehci_hcd 0000:00:1a.7: irq 21, io mem 0x9b504c00
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-rc4 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: enabling device (0000 -> 0002)
ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 20, io mem 0x9b504800
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: default language 0x0409
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-rc4 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.0: Performing full reset
uhci_hcd 0000:00:1a.0: supports USB remote wakeup
uhci_hcd 0000:00:1a.0: irq 20, io base 0x000060c0
usb usb3: default language 0x0409
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
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
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
uhci_hcd 0000:00:1a.1: supports USB remote wakeup
uhci_hcd 0000:00:1a.1: irq 16, io base 0x000060a0
usb usb4: default language 0x0409
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
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
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
usb usb5: default language 0x0409
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
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
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '006'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 18, io base 0x00006060
usb usb6: default language 0x0409
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
usb usb6: uevent
usb usb6: usb_probe_device
usb usb6: configuration #1 chosen from 1 choice
usb usb6: adding 6-0:1.0 (config #1, interface 0)
usb 6-0:1.0: uevent
hub 6-0:1.0: usb_probe_interface
hub 6-0:1.0: usb_probe_interface - got id
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
hub 6-0:1.0: standalone hub
hub 6-0:1.0: no power switching (usb 1.0)
hub 6-0:1.0: individual port over-current protection
hub 6-0:1.0: power on to power good time: 2ms
hub 6-0:1.0: local power source is good
hub 6-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '007'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 21, io base 0x00006040
usb usb7: default language 0x0409
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
usb usb7: uevent
usb usb7: usb_probe_device
usb usb7: configuration #1 chosen from 1 choice
usb usb7: adding 7-0:1.0 (config #1, interface 0)
usb 7-0:1.0: uevent
hub 7-0:1.0: usb_probe_interface
hub 7-0:1.0: usb_probe_interface - got id
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
hub 7-0:1.0: standalone hub
hub 7-0:1.0: no power switching (usb 1.0)
hub 7-0:1.0: individual port over-current protection
hub 7-0:1.0: power on to power good time: 2ms
hub 7-0:1.0: local power source is good
hub 7-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 18 (level, low) -> IRQ 18
ahci 0000:00:1f.2: irq 29 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0x9b504000 port 0x9b504100 irq 29
ata2: DUMMY
ata3: DUMMY
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 1: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001403 POWER sig=k CSC CONNECT
hub 2-0:1.0: port 1: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 4: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
hub 2-0:1.0: port 5: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 6: status 0501 change 0001
uhci_hcd 0000:00:1a.0: port 1 portsc 008a,00
uhci_hcd 0000:00:1d.0: port 1 portsc 008a,00
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
uhci_hcd 0000:00:1d.1: port 2 portsc 008a,00
uhci_hcd 0000:00:1d.2: port 1 portsc 008a,00
uhci_hcd 0000:00:1d.2: port 2 portsc 008a,00
hub 1-0:1.0: state 7 ports 4 chg 0002 evt 0000
hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1a.7: port 1 full speed --> companion
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 1 not reset yet, waiting 50ms
ehci_hcd 0000:00:1a.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 6 chg 0072 evt 0000
hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 1 low speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 1 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<7>ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
 sda1 sda2 sda3 sda4
sd 0:0:0:0: [sda] Attached SCSI disk
usb 2-4: new high speed USB device using ehci_hcd and address 3
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 2-4: skipped 1 descriptor after configuration
usb 2-4: skipped 5 descriptors after interface
usb 2-4: skipped 1 descriptor after endpoint
usb 2-4: skipped 22 descriptors after interface
usb 2-4: default language 0x0409
usb 2-4: New USB device found, idVendor=05ac, idProduct=8502
usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-4: Product: Built-in iSight
usb 2-4: Manufacturer: Apple Inc.
usb 2-4: SerialNumber: C07BA2BF3B1A93DB (03.00)
usb 2-4: uevent
usb 2-4: usb_probe_device
usb 2-4: configuration #1 chosen from 1 choice
usb 2-4: adding 2-4:1.0 (config #1, interface 0)
usb 2-4:1.0: uevent
usb 2-4: adding 2-4:1.1 (config #1, interface 1)
usb 2-4:1.1: uevent
usb 2-4: adding 2-4:1.2 (config #1, interface 2)
usb 2-4:1.2: uevent
drivers/usb/core/inode.c: creating file '003'
hub 2-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 5 low speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 5 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
hub 2-0:1.0: port 6 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1a.0: port 1 portsc 0093,00
hub 3-0:1.0: port 1, status 0101, change 0001, 12 Mb/s
hub 3-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x101
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb usb4: suspend_rh (auto-stop)
usb 3-1: skipped 1 descriptor after interface
usb 3-1: skipped 1 descriptor after interface
usb 3-1: New USB device found, idVendor=05ac, idProduct=1000
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 3-1: uevent
usb 3-1: usb_probe_device
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: adding 3-1:1.0 (config #1, interface 0)
usb 3-1:1.0: uevent
usbhid 3-1:1.0: usb_probe_interface
usbhid 3-1:1.0: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input1
uhci_hcd 0000:00:1a.0: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
generic-usb 0003:05AC:1000.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1a.0-1/input0
usb 3-1: adding 3-1:1.1 (config #1, interface 1)
usb 3-1:1.1: uevent
usbhid 3-1:1.1: usb_probe_interface
usbhid 3-1:1.1: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input2
generic-usb 0003:05AC:1000.0002: input,hidraw1: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1a.0-1/input1
drivers/usb/core/inode.c: creating file '002'
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
uhci_hcd 0000:00:1d.0: port 1 portsc 01a3,00
hub 5-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
usb usb6: suspend_rh (auto-stop)
hub 5-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 5-1: new low speed USB device using uhci_hcd and address 2
usb 5-1: skipped 1 descriptor after interface
usb 5-1: default language 0x0409
usb 5-1: New USB device found, idVendor=0458, idProduct=0036
usb 5-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
usb 5-1: Product: NetScroll + Mini Traveler
usb 5-1: Manufacturer: Genius
usb 5-1: uevent
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
usb 5-1:1.0: uevent
usbhid 5-1:1.0: usb_probe_interface
usbhid 5-1:1.0: usb_probe_interface - got id
input: Genius NetScroll + Mini Traveler as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1:1.0/input/input3
generic-usb 0003:0458:0036.0003: input,hidraw2: USB HID v1.10 Mouse [Genius NetScroll + Mini Traveler] on usb-0000:00:1d.0-1/input0
drivers/usb/core/inode.c: creating file '002'
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0006
uhci_hcd 0000:00:1d.2: port 1 portsc 01a3,00
hub 7-0:1.0: port 1, status 0301, change 0001, 1.5 Mb/s
hub 7-0:1.0: debounce: port 1: total 100ms stable 100ms status 0x301
usb 7-1: new low speed USB device using uhci_hcd and address 2
usb 7-1: skipped 1 descriptor after interface
usb 7-1: default language 0x0409
usb 7-1: New USB device found, idVendor=05ac, idProduct=8242
usb 7-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-1: Product: IR Receiver
usb 7-1: Manufacturer: Apple Computer, Inc.
usb 7-1: uevent
usb 7-1: usb_probe_device
usb 7-1: configuration #1 chosen from 1 choice
usb 7-1: adding 7-1:1.0 (config #1, interface 0)
usb 7-1:1.0: uevent
usbhid 7-1:1.0: usb_probe_interface
usbhid 7-1:1.0: usb_probe_interface - got id
drivers/usb/core/file.c: looking for a minor, starting at 96
apple 0003:05AC:8242.0004: hiddev96,hidraw3: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-1/input0
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.2: port 2 portsc 0093,00
hub 7-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
hub 7-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
usb 7-2: new full speed USB device using uhci_hcd and address 3
usb 7-2: ep0 maxpacket = 8
usb 7-2: USB quirks for this device: 2
usb 7-2: skipped 1 descriptor after interface
usb 7-2: skipped 1 descriptor after interface
usb 7-2: skipped 1 descriptor after interface
usb 7-2: default language 0x0409
usb 7-2: New USB device found, idVendor=05ac, idProduct=021a
usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-2: Product: Apple Internal Keyboard / Trackpad
usb 7-2: Manufacturer: Apple Computer
usb 7-2: uevent
usb 7-2: usb_probe_device
usb 7-2: configuration #1 chosen from 1 choice
usb 7-2: adding 7-2:1.0 (config #1, interface 0)
usb 7-2:1.0: uevent
usbhid 7-2:1.0: usb_probe_interface
usbhid 7-2:1.0: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.0/input/input4
uhci_hcd 0000:00:1d.2: reserve dev 3 ep83-INT, period 8, phase 4, 17 us
apple 0003:05AC:021A.0005: input,hidraw4: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2/input0
usb 7-2: adding 7-2:1.1 (config #1, interface 1)
usb 7-2:1.1: uevent
usbhid 7-2:1.1: usb_probe_interface
usbhid 7-2:1.1: usb_probe_interface - got id
usb 7-2: adding 7-2:1.2 (config #1, interface 2)
usb 7-2:1.2: uevent
usbhid 7-2:1.2: usb_probe_interface
usbhid 7-2:1.2: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.2/input/input5
uhci_hcd 0000:00:1d.2: reserve dev 3 ep84-INT, period 8, phase 4, 12 us
apple 0003:05AC:021A.0006: input,hidraw5: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.2-2/input2
drivers/usb/core/inode.c: creating file '003'
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0002
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0040
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: 8192 avtab hash slots, 171094 rules.
SELinux: 8192 avtab hash slots, 171094 rules.
SELinux:  5 users, 12 roles, 2293 types, 115 bools, 1 sens, 1024 cats
SELinux:  72 classes, 171094 rules
SELinux:  class kernel_service not defined in policy
SELinux:  permission open in class dir not defined in policy
SELinux:  permission open in class file not defined in policy
SELinux:  permission open in class chr_file not defined in policy
SELinux:  permission open in class blk_file not defined in policy
SELinux:  permission open in class fifo_file not defined in policy
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1235867724.821:2): policy loaded auid=4294967295 ses=4294967295
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1a.7: suspend root hub
usb usb3: uevent
usb 3-0:1.0: uevent
usb 3-1: uevent
usb 3-1:1.0: uevent
usb 3-1:1.1: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb 5-1: uevent
usb 5-1:1.0: uevent
usb usb6: uevent
usb 6-0:1.0: uevent
usb usb7: uevent
usb 7-0:1.0: uevent
usb 7-1: uevent
usb 7-1:1.0: uevent
usb 7-2: uevent
usb 7-2:1.0: uevent
usb 7-2:1.1: uevent
usb 7-2:1.2: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-4: uevent
usb 2-4:1.0: uevent
usb 2-4:1.1: uevent
usb 2-4:1.2: uevent
sky2 driver version 1.22
sky2 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:0c:00.0: setting latency timer to 64
sky2 0000:0c:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:0c:00.0: Marvell Yukon 88E8058 Gigabit Ethernet Controller
 Part Number: Yukon 88E8058
 Engineering Level: Rev. 1.3
 Manufacturer: Marvell
sky2 0000:0c:00.0: irq 30 for MSI/MSI-X
sky2 eth0: addr 00:1b:63:a0:59:d6
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input6
ACPI: Power Button (FF) [PWRF]
ACPI: Battery Slot [BAT0] (battery present)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input7
ACPI: Lid Switch [LID0]
ACPI: AC Adapter [ADP1] (on-line)
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input8
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input9
ACPI: Sleep Button (CM) [SLPB]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/device:03/input/input10
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
appletouch 7-2:1.1: usb_probe_interface
appletouch 7-2:1.1: usb_probe_interface - got id
appletouch: Geyser mode initialized.
input: appletouch as /devices/pci0000:00/0000:00:1d.2/usb7/7-2/7-2:1.1/input/input11
usbcore: registered new interface driver appletouch
sd 0:0:0:0: Attached scsi generic sg0 type 0
i801_smbus 0000:00:1f.3: enabling device (0000 -> 0003)
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 20 (level, low) -> IRQ 20
ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts with ACPI region SMBI [0xefa0-0xefaf]
ACPI: Device needs an ACPI driver
iTCO_vendor_support: vendor-support=0
pata_acpi 0000:00:1f.1: power state changed by ACPI to D0
pata_acpi 0000:00:1f.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
pata_acpi 0000:00:1f.1: setting latency timer to 64
pata_acpi 0000:00:1f.1: PCI INT A disabled
input: PC Speaker as /devices/platform/pcspkr/input/input12
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
iTCO_wdt: Found a ICH8M TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 21 (level, low) -> IRQ 21
ata_piix 0000:00:1f.1: setting latency timer to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x6108 ctl 0x611c bmdma 0x60e0 irq 21
ata5: PATA max UDMA/100 cmd 0x6100 ctl 0x6118 bmdma 0x60e8 irq 21
ata4.00: ATAPI: HL-DT-ST DVDRW  GSA-S10N, AP09, max UDMA/33
ata4.00: configured for UDMA/33
isa bounce pool size: 16 pages
scsi 3:0:0:0: CD-ROM            HL-DT-ST DVDRW  GSA-S10N  AP09 PQ: 0 ANSI: 5
scsi 3:0:0:0: Attached scsi generic sg1 type 5
nvidiafb 0000:01:00.0: enabling device (0002 -> 0003)
nvidiafb 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidiafb: Device ID: 10de0407 
nvidiafb: unknown NV_ARCH
firewire_ohci 0000:0d:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:0d:03.0, OHCI version 1.10
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda caddy
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
firewire_core: created device fw0: GUID 001cb3fffea2a2ae, S800
HDA Intel 0000:00:1b.0: enabling device (0000 -> 0002)
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
HDA Intel 0000:00:1b.0: setting latency timer to 64
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k 
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
type=1400 audit(1235885735.701:3): avc:  denied  { sys_resource } for  pid=1875 comm="dmesg" capability=24 scontext=system_u:system_r:dmesg_t:s0 tcontext=system_u:system_r:dmesg_t:s0 tclass=capability
platform microcode: firmware: requesting intel-ucode/06-0f-0a
platform microcode: firmware: requesting intel-ucode/06-0f-0a
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Microcode Update Driver: v2.00 removed.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
type=1400 audit(1235885738.730:4): avc:  denied  { sys_resource } for  pid=2061 comm="restorecond" capability=24 scontext=system_u:system_r:restorecond_t:s0 tcontext=system_u:system_r:restorecond_t:s0 tclass=capability
type=1400 audit(1235885738.961:5): avc:  denied  { read } for  pid=2068 comm="rsyslogd" name="System.map-2.6.29-rc4" dev=sda3 ino=19 scontext=system_u:system_r:syslogd_t:s0 tcontext=root:object_r:boot_t:s0 tclass=file
type=1400 audit(1235885738.961:6): avc:  denied  { getattr } for  pid=2068 comm="rsyslogd" path="/boot/System.map-2.6.29-rc4" dev=sda3 ino=19 scontext=system_u:system_r:syslogd_t:s0 tcontext=root:object_r:boot_t:s0 tclass=file
type=1400 audit(1235885739.052:7): avc:  denied  { read } for  pid=2068 comm="rsyslogd" name="System.map" dev=sda3 ino=17 scontext=system_u:system_r:syslogd_t:s0 tcontext=root:object_r:boot_t:s0 tclass=lnk_file
type=1400 audit(1235885739.173:8): avc:  denied  { sys_resource } for  pid=2079 comm="irqbalance" capability=24 scontext=system_u:system_r:irqbalance_t:s0 tcontext=system_u:system_r:irqbalance_t:s0 tclass=capability
type=1400 audit(1235885739.425:9): avc:  denied  { sys_resource } for  pid=2103 comm="rpc.statd" capability=24 scontext=system_u:system_r:rpcd_t:s0 tcontext=system_u:system_r:rpcd_t:s0 tclass=capability
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
type=1400 audit(1235885741.529:10): avc:  denied  { sys_resource } for  pid=2147 comm="dbus-daemon" capability=24 scontext=system_u:system_r:system_dbusd_t:s0-s0:c0.c1023 tcontext=system_u:system_r:system_dbusd_t:s0-s0:c0.c1023 tclass=capability
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
type=1400 audit(1235885741.882:11): avc:  denied  { sys_resource } for  pid=2179 comm="pcscd" capability=24 scontext=system_u:system_r:pcscd_t:s0 tcontext=system_u:system_r:pcscd_t:s0 tclass=capability
usb usb6: usb auto-resume
usb usb6: wakeup_rh
hub 6-0:1.0: hub_resume
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: usb auto-resume
usb usb4: wakeup_rh
hub 4-0:1.0: hub_resume
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb1: usb auto-resume
ehci_hcd 0000:00:1a.7: resume root hub
hub 1-0:1.0: hub_resume
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
Bluetooth: Core ver 2.14
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
usb usb6: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
type=1400 audit(1235885744.884:12): avc:  denied  { sys_resource } for  pid=2286 comm="newaliases" capability=24 scontext=system_u:system_r:sendmail_t:s0 tcontext=system_u:system_r:sendmail_t:s0 tclass=capability
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1a.7: suspend root hub
type=1400 audit(1235885745.279:13): avc:  denied  { sys_resource } for  pid=2308 comm="gpm" capability=24 scontext=system_u:system_r:gpm_t:s0 tcontext=system_u:system_r:gpm_t:s0 tclass=capability
uhci_hcd 0000:00:1a.0: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 8, phase 4, 93 us
uhci_hcd 0000:00:1d.2: reserve dev 3 ep81-INT, period 1, phase 0, 61 us
type=1400 audit(1235885746.668:14): avc:  denied  { sys_resource } for  pid=2342 comm="hald" capability=24 scontext=system_u:system_r:hald_t:s0 tcontext=system_u:system_r:hald_t:s0 tclass=capability
type=1400 audit(1235885746.770:15): avc:  denied  { sys_resource } for  pid=2345 comm="console-kit-dae" capability=24 scontext=system_u:system_r:consolekit_t:s0-s0:c0.c1023 tcontext=system_u:system_r:consolekit_t:s0-s0:c0.c1023 tclass=capability
uhci_hcd 0000:00:1d.2: reserve dev 2 ep82-INT, period 8, phase 4, 118 us
uhci_hcd 0000:00:1d.2: release dev 2 ep82-INT, period 8, phase 4, 118 us
type=1400 audit(1235885748.463:16): avc:  denied  { sys_resource } for  pid=2470 comm="NetworkManagerD" capability=24 scontext=system_u:system_r:NetworkManager_t:s0 tcontext=system_u:system_r:NetworkManager_t:s0 tclass=capability
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present

--------------050104050605080304070508--
