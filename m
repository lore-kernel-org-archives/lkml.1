Return-Path: <linux-kernel-owner+w=401wt.eu-S1757563AbZAMMZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563AbZAMMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 07:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbZAMMZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 07:25:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:60040 "EHLO dhcp35"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975AbZAMMY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 07:24:58 -0500
Date: Tue, 13 Jan 2009 13:24:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Message-ID: <20090113122455.GA24824@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
I am not sure whether someone has already reported this, but 
I can see the following early boot WARNING with the 2.6.29-rc1 kernel in
the serial console output:

------------[ cut here ]------------
WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Hardware name: LIFEBOOK S7110
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #5
Call Trace:
 [<c0125735>] warn_slowpath+0x71/0xa8
 [<c013f0e1>] ? tick_check_oneshot_change+0x3c/0xf0
 [<c0137f96>] ? hrtimer_run_pending+0x33/0xac
 [<c03fde85>] ? _spin_unlock_irq+0x10/0x24
 [<c012d110>] ? run_timer_softirq+0x198/0x1a0
 [<c04001e0>] sub_preempt_count+0x81/0x95
 [<c0129fe6>] _local_bh_enable+0x6c/0x6e
 [<c012a0de>] __do_softirq+0xf6/0x100
 [<c0129fe8>] ? __do_softirq+0x0/0x100
 <IRQ>  [<c014f444>] ? handle_level_irq+0x0/0xc6
 [<c0129db7>] ? irq_exit+0x3a/0x77
 [<c01046ac>] ? do_IRQ+0xf1/0x107
 [<c0103527>] ? common_interrupt+0x27/0x2c
 [<c01400d8>] ? timer_stats_update_stats+0x1f6/0x1fe
 [<c03fdea0>] ? _spin_unlock_irqrestore+0x7/0x25
 [<c014eabf>] ? __setup_irq+0x17e/0x1cb
 [<c014ebe7>] ? setup_irq+0x19/0x1d
 [<c05d6786>] ? time_init_hook+0x2b/0x2d
 [<c05ca6f6>] ? hpet_time_init+0x16/0x18
 [<c05c575a>] ? start_kernel+0x224/0x292
 [<c05c5085>] ? __init_begin+0x85/0x8d
---[ end trace 4eaa2a86a8e2da22 ]---

Full boot log is attached as well as config.
Should I try to bisect down the cause? (Any hints which commits to try
before that?)

[I wasn't sure who should be in CC]

Thanks in advance
and
Best regards.
-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="boot.log"

Linux version 2.6.29-rc1 (root@dhcp35) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #5 SMP PREEMPT Mon Jan 12 10:42:45 CET 2009
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
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f6c0000 (usable)
 BIOS-e820: 000000003f6c0000 - 000000003f6d4000 (ACPI data)
 BIOS-e820: 000000003f6d4000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
DMI 2.4 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x3f6c0 max_arch_pfn = 0x100000
RAMDISK: 37be5000 - 37fef756
Allocated new RAMDISK: 00716000 - 00b20756
Move RAMDISK from 0000000037be5000 - 0000000037fef755 to 00716000 - 00b20755
ACPI: RSDP 000F5760, 0014 (r0 FUJ   )
ACPI: RSDT 3F6CBF73, 0048 (r1 FSC    PC        1330000 FUJ       100)
ACPI: FACP 3F6D3F8C, 0074 (r1 FSC    PC        1330000 FUJ       100)
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT 3F6CBFCB, 6D68 (r1 FUJ    FJNB1B5   1330000 MSFT  100000E)
ACPI: FACS 3F6D4FC0, 0040
ACPI: SSDT 3F6D2D33, 0265 (r1 FUJ    FJNB1B5   1330000 MSFT  100000E)
ACPI: MCFG 3F6D2F98, 003C (r1 FUJ    FJNB1B5   1330000 FUJ       100)
ACPI: SSDT 3F6D2FD4, 04DC (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: SSDT 3F6D3B84, 01CA (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: APIC 3F6D3D4E, 0068 (r1 FUJ    FJNB1B5   1330000  LTP        0)
ACPI: HPET 3F6D3DB6, 0038 (r1 FUJ    FJNB1B5   1330000 FUJ       100)
ACPI: BOOT 3F6D3DEE, 0028 (r1 FUJ    FJNB1B5   1330000 FUJ       100)
ACPI: SLIC 3F6D3E16, 0176 (r1 FSC    PC        1330000 FSC       100)
126MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00007127b4]    TEXT DATA BSS ==> [0000100000 - 00007127b4]
  #4 [0000713000 - 0000716000]    INIT_PG_TABLE ==> [0000713000 - 0000716000]
  #5 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [0000716000 - 0000b20756]      NEW RAMDISK ==> [0000716000 - 0000b20756]
  #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Reserving 64MB of memory at 16MB for crashkernel (System RAM: 1014MB)
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003f6c0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003f6c0
ACPI: PM-Timer IO Port: 0x1008
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:b8000000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Allocating 40960 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257633
Kernel command line: root=/dev/sda1 ro crashkernel=64M@16M resume=/dev/sda8 console=ttyS3,115200 console=tty no_console_suspend 
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1828.551 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS3] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 953220k/1039104k available (3080k kernel code, 85084k reserved, 1779k data, 304k init, 129800k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc05c5000 - 0xc0611000   ( 304 kB)
      .data : 0xc0402303 - 0xc05bf07c   (1779 kB)
      .text : 0xc0100000 - 0xc0402303   (3080 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
------------[ cut here ]------------
WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Hardware name: LIFEBOOK S7110
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.29-rc1 #5
Call Trace:
 [<c0125735>] warn_slowpath+0x71/0xa8
 [<c013f0e1>] ? tick_check_oneshot_change+0x3c/0xf0
 [<c0137f96>] ? hrtimer_run_pending+0x33/0xac
 [<c03fde85>] ? _spin_unlock_irq+0x10/0x24
 [<c012d110>] ? run_timer_softirq+0x198/0x1a0
 [<c04001e0>] sub_preempt_count+0x81/0x95
 [<c0129fe6>] _local_bh_enable+0x6c/0x6e
 [<c012a0de>] __do_softirq+0xf6/0x100
 [<c0129fe8>] ? __do_softirq+0x0/0x100
 <IRQ>  [<c014f444>] ? handle_level_irq+0x0/0xc6
 [<c0129db7>] ? irq_exit+0x3a/0x77
 [<c01046ac>] ? do_IRQ+0xf1/0x107
 [<c0103527>] ? common_interrupt+0x27/0x2c
 [<c01400d8>] ? timer_stats_update_stats+0x1f6/0x1fe
 [<c03fdea0>] ? _spin_unlock_irqrestore+0x7/0x25
 [<c014eabf>] ? __setup_irq+0x17e/0x1cb
 [<c014ebe7>] ? setup_irq+0x19/0x1d
 [<c05d6786>] ? time_init_hook+0x2b/0x2d
 [<c05ca6f6>] ? hpet_time_init+0x16/0x18
 [<c05c575a>] ? start_kernel+0x224/0x292
 [<c05c5085>] ? __init_begin+0x85/0x8d
---[ end trace 4eaa2a86a8e2da22 ]---
Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.10 BogoMIPS (lpj=7314204)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20081204
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 02
CPU 1 irqstacks, hard=c0635000 soft=c0615000
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.46 BogoMIPS (lpj=7314930)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         T5600  @ 1.83GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (7314.56 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
PM: Adding info for No Bus:platform
net_namespace: 1000 bytes
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
PM: Adding info for No Bus:default
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: SSDT 3F6D45C3, 0893 (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:LNXSYSTM:00
PM: Adding info for acpi:LNXPWRBN:00
PM: Adding info for acpi:ACPI_CPU:00
PM: Adding info for acpi:ACPI_CPU:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:PNP0C02:01
PM: Adding info for acpi:device:01
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:FUJ02B1:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:PNP0F13:00
PM: Adding info for acpi:PNP0103:00
PM: Adding info for acpi:PNP0501:00
PM: Adding info for acpi:SMCF010:00
PM: Adding info for acpi:PNP0400:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:device:1f
PM: Adding info for acpi:device:20
PM: Adding info for acpi:device:21
PM: Adding info for acpi:device:22
PM: Adding info for acpi:device:23
PM: Adding info for acpi:device:24
PM: Adding info for acpi:device:25
PM: Adding info for acpi:device:26
PM: Adding info for acpi:device:27
PM: Adding info for acpi:device:28
PM: Adding info for acpi:device:29
PM: Adding info for acpi:device:2a
PM: Adding info for acpi:device:2b
PM: Adding info for acpi:device:2c
PM: Adding info for acpi:device:2d
PM: Adding info for acpi:device:2e
PM: Adding info for acpi:device:2f
PM: Adding info for acpi:device:30
PM: Adding info for acpi:FUJ02E3:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0C:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:PNP0C0A:01
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:LNXTHERM:00
PM: Adding info for acpi:LNXTHERM:01
PM: Adding info for acpi:LNXTHERM:02
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
PM: Adding info for platform:dock.0
PM: Adding info for platform:dock.1
ACPI: ACPI Dock Station Driver: 2 docks/bays found
ACPI: PCI Root Bridge [PCI0] (0000:00)
PM: Adding info for No Bus:pci0000:00
PM: Adding info for No Bus:0000:00
pci 0000:00:02.0: reg 10 32bit mmio: [0xf0300000-0xf037ffff]
pci 0000:00:02.0: reg 14 io port: [0x1800-0x1807]
pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xf0400000-0xf043ffff]
pci 0000:00:02.1: reg 10 32bit mmio: [0xf0380000-0xf03fffff]
pci 0000:00:1b.0: reg 10 64bit mmio: [0xf0640000-0xf0643fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x1820-0x183f]
pci 0000:00:1d.1: reg 20 io port: [0x1840-0x185f]
pci 0000:00:1d.2: reg 20 io port: [0x1860-0x187f]
pci 0000:00:1d.3: reg 20 io port: [0x1880-0x189f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf0644000-0xf06443ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at fd00 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 06e8 (mask 0007)
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1810-0x181f]
pci 0000:00:1f.2: reg 10 io port: [0x18d0-0x18d7]
pci 0000:00:1f.2: reg 14 io port: [0x18c4-0x18c7]
pci 0000:00:1f.2: reg 18 io port: [0x18c8-0x18cf]
pci 0000:00:1f.2: reg 1c io port: [0x18c0-0x18c3]
pci 0000:00:1f.2: reg 20 io port: [0x18b0-0x18bf]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xf0644400-0xf06447ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x18e0-0x18ff]
pci 0000:02:00.0: reg 10 64bit mmio: [0xf0000000-0xf0003fff]
pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:1c.0: bridge 32bit mmio: [0xf0000000-0xf00fffff]
pci 0000:00:1c.1: bridge io port: [0x00-0xfff]
pci 0000:00:1c.1: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:00:1c.1: bridge 64bit mmio pref: [0x000000-0x0fffff]
pci 0000:05:00.0: reg 10 32bit mmio: [0xf0100000-0xf0100fff]
pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
pci 0000:05:00.0: PME# disabled
pci 0000:00:1c.2: bridge io port: [0x00-0xfff]
pci 0000:00:1c.2: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:00:1c.2: bridge 64bit mmio pref: [0x000000-0x0fffff]
pci 0000:08:03.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:08:03.0: supports D1 D2
pci 0000:08:03.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:08:03.0: PME# disabled
pci 0000:08:03.4: reg 10 32bit mmio: [0xf0200000-0xf0200fff]
pci 0000:08:03.4: reg 14 32bit mmio: [0xf0201000-0xf02017ff]
pci 0000:08:03.4: supports D1 D2
pci 0000:08:03.4: PME# supported from D0 D1 D2 D3hot
pci 0000:08:03.4: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xf0200000-0xf02fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.1
PM: Adding info for pci:0000:00:1c.2
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.3
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.1
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:02:00.0
PM: Adding info for No Bus:0000:02
PM: Adding info for No Bus:0000:03
PM: Adding info for pci:0000:05:00.0
PM: Adding info for No Bus:0000:05
PM: Adding info for pci:0000:08:03.0
PM: Adding info for pci:0000:08:03.4
PM: Adding info for No Bus:0000:09
PM: Adding info for No Bus:0000:08
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pci 0000:00:1c.1: BAR 7: can't allocate resource
pci 0000:00:1c.1: BAR 8: can't allocate resource
pci 0000:00:1c.1: BAR 9: can't allocate resource
pci 0000:00:1c.2: BAR 7: can't allocate resource
pci 0000:00:1c.2: BAR 8: can't allocate resource
pci 0000:00:1c.2: BAR 9: can't allocate resource
pci 0000:05:00.0: BAR 0: can't allocate resource
PM: Adding info for No Bus:lo
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
ACPI: bus type pnp registered
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
PM: Adding info for pnp:00:0b
PM: Adding info for pnp:00:0c
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x80f has been reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1080-0x10ff has been reserved
system 00:02: ioport range 0x1100-0x111f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0xf800-0xf87f has been reserved
system 00:02: ioport range 0xf880-0xf8ff has been reserved
system 00:02: ioport range 0xfc00-0xfc7f has been reserved
system 00:02: ioport range 0xfc80-0xfcff has been reserved
system 00:02: ioport range 0xfd0c-0xfd7f has been reserved
system 00:02: ioport range 0xfe00-0xfe01 has been reserved
system 00:02: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:02: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:02: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:02: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:02: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:02: iomem range 0xfef00000-0xfeffffff has been reserved
system 00:02: iomem range 0xcec00-0xcefff has been reserved
system 00:02: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:02: iomem range 0xfed40000-0xfed44fff has been reserved
system 00:09: iomem range 0xfed00000-0xfed003ff has been reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xf0000000-0xf00fffff
pci 0000:00:1c.0:   PREFETCH window: 0x00000054000000-0x000000540fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: disabled
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
pci 0000:00:1c.2:   IO window: disabled
pci 0000:00:1c.2:   MEM window: 0x54100000-0x541fffff
pci 0000:00:1c.2:   PREFETCH window: disabled
pci 0000:08:03.0: CardBus bridge, secondary bus 0000:09
pci 0000:08:03.0:   IO window: 0x003000-0x0030ff
pci 0000:08:03.0:   IO window: 0x003400-0x0034ff
pci 0000:08:03.0:   PREFETCH window: 0x50000000-0x53ffffff
pci 0000:08:03.0:   MEM window: 0x58000000-0x5bffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xf0200000-0xf02fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x00000053ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: enabling device (0000 -> 0002)
pci 0000:00:1c.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:08:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:02: resource 1 mem: [0xf0000000-0xf00fffff]
pci_bus 0000:02: resource 2 mem: [0x54000000-0x540fffff]
pci_bus 0000:02: resource 3 mem: [0x0-0x0]
pci_bus 0000:03: resource 0 mem: [0x0-0xfff]
pci_bus 0000:03: resource 1 mem: [0x0-0xfffff]
pci_bus 0000:03: resource 2 mem: [0x0-0xfffff]
pci_bus 0000:03: resource 3 mem: [0x0-0x0]
pci_bus 0000:05: resource 0 mem: [0x0-0xfff]
pci_bus 0000:05: resource 1 mem: [0x54100000-0x541fffff]
pci_bus 0000:05: resource 2 mem: [0x0-0xfffff]
pci_bus 0000:05: resource 3 mem: [0x0-0x0]
pci_bus 0000:08: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:08: resource 1 mem: [0xf0200000-0xf02fffff]
pci_bus 0000:08: resource 2 mem: [0x50000000-0x53ffffff]
pci_bus 0000:08: resource 3 io:  [0x00-0xffff]
pci_bus 0000:08: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:09: resource 0 io:  [0x3000-0x30ff]
pci_bus 0000:09: resource 1 io:  [0x3400-0x34ff]
pci_bus 0000:09: resource 2 mem: [0x50000000-0x53ffffff]
pci_bus 0000:09: resource 3 mem: [0x58000000-0x5bffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 4137k freed
Simple Boot Flag at 0x37 set to 0x1
Machine check exception polling timer started.
PM: Adding info for No Bus:msr0
PM: Adding info for No Bus:msr1
PM: Adding info for No Bus:cpu0
PM: Adding info for No Bus:cpu1
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:microcode
PM: Adding info for platform:microcode
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
PM: Adding info for No Bus:snapshot
highmem bounce pool size: 64 pages
msgmni has been set to 1617
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:02.0: Boot video device
PM: Adding info for No Bus:AC
ACPI: AC Adapter [AC] (on-line)
PM: Adding info for No Bus:CMB1
ACPI: Battery Slot [CMB1] (battery present)
ACPI: Battery Slot [CMB2] (battery absent)
PM: Adding info for No Bus:input0
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
PM: Adding info for No Bus:input1
input: Lid Switch as /class/input/input1
ACPI: Lid Switch [LID]
PM: Adding info for No Bus:input2
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
PM: Adding info for No Bus:input3
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT 3F6D34B0, 01A6 (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: SSDT 3F6D392F, 01D0 (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
PM: Adding info for No Bus:cooling_device0
processor ACPI_CPU:00: registered as cooling_device0
ACPI: SSDT 3F6D38A8, 0087 (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: SSDT 3F6D3AFF, 0085 (r1 FUJ    FJNB1B5   1330000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
PM: Adding info for No Bus:cooling_device1
processor ACPI_CPU:01: registered as cooling_device1
PM: Adding info for No Bus:thermal_zone0
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (27 C)
PM: Adding info for No Bus:thermal_zone1
thermal LNXTHERM:02: registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (27 C)
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:ptyp0
PM: Adding info for No Bus:ptyp1
PM: Adding info for No Bus:ptyp2
PM: Adding info for No Bus:ptyp3
PM: Adding info for No Bus:ptyp4
PM: Adding info for No Bus:ptyp5
PM: Adding info for No Bus:ptyp6
PM: Adding info for No Bus:ptyp7
PM: Adding info for No Bus:ptyp8
PM: Adding info for No Bus:ptyp9
PM: Adding info for No Bus:ptypa
PM: Adding info for No Bus:ptypb
PM: Adding info for No Bus:ptypc
PM: Adding info for No Bus:ptypd
PM: Adding info for No Bus:ptype
PM: Adding info for No Bus:ptypf
PM: Adding info for No Bus:ptyq0
PM: Adding info for No Bus:ptyq1
PM: Adding info for No Bus:ptyq2
PM: Adding info for No Bus:ptyq3
PM: Adding info for No Bus:ptyq4
PM: Adding info for No Bus:ptyq5
PM: Adding info for No Bus:ptyq6
PM: Adding info for No Bus:ptyq7
PM: Adding info for No Bus:ptyq8
PM: Adding info for No Bus:ptyq9
PM: Adding info for No Bus:ptyqa
PM: Adding info for No Bus:ptyqb
PM: Adding info for No Bus:ptyqc
PM: Adding info for No Bus:ptyqd
PM: Adding info for No Bus:ptyqe
PM: Adding info for No Bus:ptyqf
PM: Adding info for No Bus:ptyr0
PM: Adding info for No Bus:ptyr1
PM: Adding info for No Bus:ptyr2
PM: Adding info for No Bus:ptyr3
PM: Adding info for No Bus:ptyr4
PM: Adding info for No Bus:ptyr5
PM: Adding info for No Bus:ptyr6
PM: Adding info for No Bus:ptyr7
PM: Adding info for No Bus:ptyr8
PM: Adding info for No Bus:ptyr9
PM: Adding info for No Bus:ptyra
PM: Adding info for No Bus:ptyrb
PM: Adding info for No Bus:ptyrc
PM: Adding info for No Bus:ptyrd
PM: Adding info for No Bus:ptyre
PM: Adding info for No Bus:ptyrf
PM: Adding info for No Bus:ptys0
PM: Adding info for No Bus:ptys1
PM: Adding info for No Bus:ptys2
PM: Adding info for No Bus:ptys3
PM: Adding info for No Bus:ptys4
PM: Adding info for No Bus:ptys5
PM: Adding info for No Bus:ptys6
PM: Adding info for No Bus:ptys7
PM: Adding info for No Bus:ptys8
PM: Adding info for No Bus:ptys9
PM: Adding info for No Bus:ptysa
PM: Adding info for No Bus:ptysb
PM: Adding info for No Bus:ptysc
PM: Adding info for No Bus:ptysd
PM: Adding info for No Bus:ptyse
PM: Adding info for No Bus:ptysf
PM: Adding info for No Bus:ptyt0
PM: Adding info for No Bus:ptyt1
PM: Adding info for No Bus:ptyt2
PM: Adding info for No Bus:ptyt3
PM: Adding info for No Bus:ptyt4
PM: Adding info for No Bus:ptyt5
PM: Adding info for No Bus:ptyt6
PM: Adding info for No Bus:ptyt7
PM: Adding info for No Bus:ptyt8
PM: Adding info for No Bus:ptyt9
PM: Adding info for No Bus:ptyta
PM: Adding info for No Bus:ptytb
PM: Adding info for No Bus:ptytc
PM: Adding info for No Bus:ptytd
PM: Adding info for No Bus:ptyte
PM: Adding info for No Bus:ptytf
PM: Adding info for No Bus:ptyu0
PM: Adding info for No Bus:ptyu1
PM: Adding info for No Bus:ptyu2
PM: Adding info for No Bus:ptyu3
PM: Adding info for No Bus:ptyu4
PM: Adding info for No Bus:ptyu5
PM: Adding info for No Bus:ptyu6
PM: Adding info for No Bus:ptyu7
PM: Adding info for No Bus:ptyu8
PM: Adding info for No Bus:ptyu9
PM: Adding info for No Bus:ptyua
PM: Adding info for No Bus:ptyub
PM: Adding info for No Bus:ptyuc
PM: Adding info for No Bus:ptyud
PM: Adding info for No Bus:ptyue
PM: Adding info for No Bus:ptyuf
PM: Adding info for No Bus:ptyv0
PM: Adding info for No Bus:ptyv1
PM: Adding info for No Bus:ptyv2
PM: Adding info for No Bus:ptyv3
PM: Adding info for No Bus:ptyv4
PM: Adding info for No Bus:ptyv5
PM: Adding info for No Bus:ptyv6
PM: Adding info for No Bus:ptyv7
PM: Adding info for No Bus:ptyv8
PM: Adding info for No Bus:ptyv9
PM: Adding info for No Bus:ptyva
PM: Adding info for No Bus:ptyvb
PM: Adding info for No Bus:ptyvc
PM: Adding info for No Bus:ptyvd
PM: Adding info for No Bus:ptyve
PM: Adding info for No Bus:ptyvf
PM: Adding info for No Bus:ptyw0
PM: Adding info for No Bus:ptyw1
PM: Adding info for No Bus:ptyw2
PM: Adding info for No Bus:ptyw3
PM: Adding info for No Bus:ptyw4
PM: Adding info for No Bus:ptyw5
PM: Adding info for No Bus:ptyw6
PM: Adding info for No Bus:ptyw7
PM: Adding info for No Bus:ptyw8
PM: Adding info for No Bus:ptyw9
PM: Adding info for No Bus:ptywa
PM: Adding info for No Bus:ptywb
PM: Adding info for No Bus:ptywc
PM: Adding info for No Bus:ptywd
PM: Adding info for No Bus:ptywe
PM: Adding info for No Bus:ptywf
PM: Adding info for No Bus:ptyx0
PM: Adding info for No Bus:ptyx1
PM: Adding info for No Bus:ptyx2
PM: Adding info for No Bus:ptyx3
PM: Adding info for No Bus:ptyx4
PM: Adding info for No Bus:ptyx5
PM: Adding info for No Bus:ptyx6
PM: Adding info for No Bus:ptyx7
PM: Adding info for No Bus:ptyx8
PM: Adding info for No Bus:ptyx9
PM: Adding info for No Bus:ptyxa
PM: Adding info for No Bus:ptyxb
PM: Adding info for No Bus:ptyxc
PM: Adding info for No Bus:ptyxd
PM: Adding info for No Bus:ptyxe
PM: Adding info for No Bus:ptyxf
PM: Adding info for No Bus:ptyy0
PM: Adding info for No Bus:ptyy1
PM: Adding info for No Bus:ptyy2
PM: Adding info for No Bus:ptyy3
PM: Adding info for No Bus:ptyy4
PM: Adding info for No Bus:ptyy5
PM: Adding info for No Bus:ptyy6
PM: Adding info for No Bus:ptyy7
PM: Adding info for No Bus:ptyy8
PM: Adding info for No Bus:ptyy9
PM: Adding info for No Bus:ptyya
PM: Adding info for No Bus:ptyyb
PM: Adding info for No Bus:ptyyc
PM: Adding info for No Bus:ptyyd
PM: Adding info for No Bus:ptyye
PM: Adding info for No Bus:ptyyf
PM: Adding info for No Bus:ptyz0
PM: Adding info for No Bus:ptyz1
PM: Adding info for No Bus:ptyz2
PM: Adding info for No Bus:ptyz3
PM: Adding info for No Bus:ptyz4
PM: Adding info for No Bus:ptyz5
PM: Adding info for No Bus:ptyz6
PM: Adding info for No Bus:ptyz7
PM: Adding info for No Bus:ptyz8
PM: Adding info for No Bus:ptyz9
PM: Adding info for No Bus:ptyza
PM: Adding info for No Bus:ptyzb
PM: Adding info for No Bus:ptyzc
PM: Adding info for No Bus:ptyzd
PM: Adding info for No Bus:ptyze
PM: Adding info for No Bus:ptyzf
PM: Adding info for No Bus:ptya0
PM: Adding info for No Bus:ptya1
PM: Adding info for No Bus:ptya2
PM: Adding info for No Bus:ptya3
PM: Adding info for No Bus:ptya4
PM: Adding info for No Bus:ptya5
PM: Adding info for No Bus:ptya6
PM: Adding info for No Bus:ptya7
PM: Adding info for No Bus:ptya8
PM: Adding info for No Bus:ptya9
PM: Adding info for No Bus:ptyaa
PM: Adding info for No Bus:ptyab
PM: Adding info for No Bus:ptyac
PM: Adding info for No Bus:ptyad
PM: Adding info for No Bus:ptyae
PM: Adding info for No Bus:ptyaf
PM: Adding info for No Bus:ptyb0
PM: Adding info for No Bus:ptyb1
PM: Adding info for No Bus:ptyb2
PM: Adding info for No Bus:ptyb3
PM: Adding info for No Bus:ptyb4
PM: Adding info for No Bus:ptyb5
PM: Adding info for No Bus:ptyb6
PM: Adding info for No Bus:ptyb7
PM: Adding info for No Bus:ptyb8
PM: Adding info for No Bus:ptyb9
PM: Adding info for No Bus:ptyba
PM: Adding info for No Bus:ptybb
PM: Adding info for No Bus:ptybc
PM: Adding info for No Bus:ptybd
PM: Adding info for No Bus:ptybe
PM: Adding info for No Bus:ptybf
PM: Adding info for No Bus:ptyc0
PM: Adding info for No Bus:ptyc1
PM: Adding info for No Bus:ptyc2
PM: Adding info for No Bus:ptyc3
PM: Adding info for No Bus:ptyc4
PM: Adding info for No Bus:ptyc5
PM: Adding info for No Bus:ptyc6
PM: Adding info for No Bus:ptyc7
PM: Adding info for No Bus:ptyc8
PM: Adding info for No Bus:ptyc9
PM: Adding info for No Bus:ptyca
PM: Adding info for No Bus:ptycb
PM: Adding info for No Bus:ptycc
PM: Adding info for No Bus:ptycd
PM: Adding info for No Bus:ptyce
PM: Adding info for No Bus:ptycf
PM: Adding info for No Bus:ptyd0
PM: Adding info for No Bus:ptyd1
PM: Adding info for No Bus:ptyd2
PM: Adding info for No Bus:ptyd3
PM: Adding info for No Bus:ptyd4
PM: Adding info for No Bus:ptyd5
PM: Adding info for No Bus:ptyd6
PM: Adding info for No Bus:ptyd7
PM: Adding info for No Bus:ptyd8
PM: Adding info for No Bus:ptyd9
PM: Adding info for No Bus:ptyda
PM: Adding info for No Bus:ptydb
PM: Adding info for No Bus:ptydc
PM: Adding info for No Bus:ptydd
PM: Adding info for No Bus:ptyde
PM: Adding info for No Bus:ptydf
PM: Adding info for No Bus:ptye0
PM: Adding info for No Bus:ptye1
PM: Adding info for No Bus:ptye2
PM: Adding info for No Bus:ptye3
PM: Adding info for No Bus:ptye4
PM: Adding info for No Bus:ptye5
PM: Adding info for No Bus:ptye6
PM: Adding info for No Bus:ptye7
PM: Adding info for No Bus:ptye8
PM: Adding info for No Bus:ptye9
PM: Adding info for No Bus:ptyea
PM: Adding info for No Bus:ptyeb
PM: Adding info for No Bus:ptyec
PM: Adding info for No Bus:ptyed
PM: Adding info for No Bus:ptyee
PM: Adding info for No Bus:ptyef
PM: Adding info for No Bus:ttyp0
PM: Adding info for No Bus:ttyp1
PM: Adding info for No Bus:ttyp2
PM: Adding info for No Bus:ttyp3
PM: Adding info for No Bus:ttyp4
PM: Adding info for No Bus:ttyp5
PM: Adding info for No Bus:ttyp6
PM: Adding info for No Bus:ttyp7
PM: Adding info for No Bus:ttyp8
PM: Adding info for No Bus:ttyp9
PM: Adding info for No Bus:ttypa
PM: Adding info for No Bus:ttypb
PM: Adding info for No Bus:ttypc
PM: Adding info for No Bus:ttypd
PM: Adding info for No Bus:ttype
PM: Adding info for No Bus:ttypf
PM: Adding info for No Bus:ttyq0
PM: Adding info for No Bus:ttyq1
PM: Adding info for No Bus:ttyq2
PM: Adding info for No Bus:ttyq3
PM: Adding info for No Bus:ttyq4
PM: Adding info for No Bus:ttyq5
PM: Adding info for No Bus:ttyq6
PM: Adding info for No Bus:ttyq7
PM: Adding info for No Bus:ttyq8
PM: Adding info for No Bus:ttyq9
PM: Adding info for No Bus:ttyqa
PM: Adding info for No Bus:ttyqb
PM: Adding info for No Bus:ttyqc
PM: Adding info for No Bus:ttyqd
PM: Adding info for No Bus:ttyqe
PM: Adding info for No Bus:ttyqf
PM: Adding info for No Bus:ttyr0
PM: Adding info for No Bus:ttyr1
PM: Adding info for No Bus:ttyr2
PM: Adding info for No Bus:ttyr3
PM: Adding info for No Bus:ttyr4
PM: Adding info for No Bus:ttyr5
PM: Adding info for No Bus:ttyr6
PM: Adding info for No Bus:ttyr7
PM: Adding info for No Bus:ttyr8
PM: Adding info for No Bus:ttyr9
PM: Adding info for No Bus:ttyra
PM: Adding info for No Bus:ttyrb
PM: Adding info for No Bus:ttyrc
PM: Adding info for No Bus:ttyrd
PM: Adding info for No Bus:ttyre
PM: Adding info for No Bus:ttyrf
PM: Adding info for No Bus:ttys0
PM: Adding info for No Bus:ttys1
PM: Adding info for No Bus:ttys2
PM: Adding info for No Bus:ttys3
PM: Adding info for No Bus:ttys4
PM: Adding info for No Bus:ttys5
PM: Adding info for No Bus:ttys6
PM: Adding info for No Bus:ttys7
PM: Adding info for No Bus:ttys8
PM: Adding info for No Bus:ttys9
PM: Adding info for No Bus:ttysa
PM: Adding info for No Bus:ttysb
PM: Adding info for No Bus:ttysc
PM: Adding info for No Bus:ttysd
PM: Adding info for No Bus:ttyse
PM: Adding info for No Bus:ttysf
PM: Adding info for No Bus:ttyt0
PM: Adding info for No Bus:ttyt1
PM: Adding info for No Bus:ttyt2
PM: Adding info for No Bus:ttyt3
PM: Adding info for No Bus:ttyt4
PM: Adding info for No Bus:ttyt5
PM: Adding info for No Bus:ttyt6
PM: Adding info for No Bus:ttyt7
PM: Adding info for No Bus:ttyt8
PM: Adding info for No Bus:ttyt9
PM: Adding info for No Bus:ttyta
PM: Adding info for No Bus:ttytb
PM: Adding info for No Bus:ttytc
PM: Adding info for No Bus:ttytd
PM: Adding info for No Bus:ttyte
PM: Adding info for No Bus:ttytf
PM: Adding info for No Bus:ttyu0
PM: Adding info for No Bus:ttyu1
PM: Adding info for No Bus:ttyu2
PM: Adding info for No Bus:ttyu3
PM: Adding info for No Bus:ttyu4
PM: Adding info for No Bus:ttyu5
PM: Adding info for No Bus:ttyu6
PM: Adding info for No Bus:ttyu7
PM: Adding info for No Bus:ttyu8
PM: Adding info for No Bus:ttyu9
PM: Adding info for No Bus:ttyua
PM: Adding info for No Bus:ttyub
PM: Adding info for No Bus:ttyuc
PM: Adding info for No Bus:ttyud
PM: Adding info for No Bus:ttyue
PM: Adding info for No Bus:ttyuf
PM: Adding info for No Bus:ttyv0
PM: Adding info for No Bus:ttyv1
PM: Adding info for No Bus:ttyv2
PM: Adding info for No Bus:ttyv3
PM: Adding info for No Bus:ttyv4
PM: Adding info for No Bus:ttyv5
PM: Adding info for No Bus:ttyv6
PM: Adding info for No Bus:ttyv7
PM: Adding info for No Bus:ttyv8
PM: Adding info for No Bus:ttyv9
PM: Adding info for No Bus:ttyva
PM: Adding info for No Bus:ttyvb
PM: Adding info for No Bus:ttyvc
PM: Adding info for No Bus:ttyvd
PM: Adding info for No Bus:ttyve
PM: Adding info for No Bus:ttyvf
PM: Adding info for No Bus:ttyw0
PM: Adding info for No Bus:ttyw1
PM: Adding info for No Bus:ttyw2
PM: Adding info for No Bus:ttyw3
PM: Adding info for No Bus:ttyw4
PM: Adding info for No Bus:ttyw5
PM: Adding info for No Bus:ttyw6
PM: Adding info for No Bus:ttyw7
PM: Adding info for No Bus:ttyw8
PM: Adding info for No Bus:ttyw9
PM: Adding info for No Bus:ttywa
PM: Adding info for No Bus:ttywb
PM: Adding info for No Bus:ttywc
PM: Adding info for No Bus:ttywd
PM: Adding info for No Bus:ttywe
PM: Adding info for No Bus:ttywf
PM: Adding info for No Bus:ttyx0
PM: Adding info for No Bus:ttyx1
PM: Adding info for No Bus:ttyx2
PM: Adding info for No Bus:ttyx3
PM: Adding info for No Bus:ttyx4
PM: Adding info for No Bus:ttyx5
PM: Adding info for No Bus:ttyx6
PM: Adding info for No Bus:ttyx7
PM: Adding info for No Bus:ttyx8
PM: Adding info for No Bus:ttyx9
PM: Adding info for No Bus:ttyxa
PM: Adding info for No Bus:ttyxb
PM: Adding info for No Bus:ttyxc
PM: Adding info for No Bus:ttyxd
PM: Adding info for No Bus:ttyxe
PM: Adding info for No Bus:ttyxf
PM: Adding info for No Bus:ttyy0
PM: Adding info for No Bus:ttyy1
PM: Adding info for No Bus:ttyy2
PM: Adding info for No Bus:ttyy3
PM: Adding info for No Bus:ttyy4
PM: Adding info for No Bus:ttyy5
PM: Adding info for No Bus:ttyy6
PM: Adding info for No Bus:ttyy7
PM: Adding info for No Bus:ttyy8
PM: Adding info for No Bus:ttyy9
PM: Adding info for No Bus:ttyya
PM: Adding info for No Bus:ttyyb
PM: Adding info for No Bus:ttyyc
PM: Adding info for No Bus:ttyyd
PM: Adding info for No Bus:ttyye
PM: Adding info for No Bus:ttyyf
PM: Adding info for No Bus:ttyz0
PM: Adding info for No Bus:ttyz1
PM: Adding info for No Bus:ttyz2
PM: Adding info for No Bus:ttyz3
PM: Adding info for No Bus:ttyz4
PM: Adding info for No Bus:ttyz5
PM: Adding info for No Bus:ttyz6
PM: Adding info for No Bus:ttyz7
PM: Adding info for No Bus:ttyz8
PM: Adding info for No Bus:ttyz9
PM: Adding info for No Bus:ttyza
PM: Adding info for No Bus:ttyzb
PM: Adding info for No Bus:ttyzc
PM: Adding info for No Bus:ttyzd
PM: Adding info for No Bus:ttyze
PM: Adding info for No Bus:ttyzf
PM: Adding info for No Bus:ttya0
PM: Adding info for No Bus:ttya1
PM: Adding info for No Bus:ttya2
PM: Adding info for No Bus:ttya3
PM: Adding info for No Bus:ttya4
PM: Adding info for No Bus:ttya5
PM: Adding info for No Bus:ttya6
PM: Adding info for No Bus:ttya7
PM: Adding info for No Bus:ttya8
PM: Adding info for No Bus:ttya9
PM: Adding info for No Bus:ttyaa
PM: Adding info for No Bus:ttyab
PM: Adding info for No Bus:ttyac
PM: Adding info for No Bus:ttyad
PM: Adding info for No Bus:ttyae
PM: Adding info for No Bus:ttyaf
PM: Adding info for No Bus:ttyb0
PM: Adding info for No Bus:ttyb1
PM: Adding info for No Bus:ttyb2
PM: Adding info for No Bus:ttyb3
PM: Adding info for No Bus:ttyb4
PM: Adding info for No Bus:ttyb5
PM: Adding info for No Bus:ttyb6
PM: Adding info for No Bus:ttyb7
PM: Adding info for No Bus:ttyb8
PM: Adding info for No Bus:ttyb9
PM: Adding info for No Bus:ttyba
PM: Adding info for No Bus:ttybb
PM: Adding info for No Bus:ttybc
PM: Adding info for No Bus:ttybd
PM: Adding info for No Bus:ttybe
PM: Adding info for No Bus:ttybf
PM: Adding info for No Bus:ttyc0
PM: Adding info for No Bus:ttyc1
PM: Adding info for No Bus:ttyc2
PM: Adding info for No Bus:ttyc3
PM: Adding info for No Bus:ttyc4
PM: Adding info for No Bus:ttyc5
PM: Adding info for No Bus:ttyc6
PM: Adding info for No Bus:ttyc7
PM: Adding info for No Bus:ttyc8
PM: Adding info for No Bus:ttyc9
PM: Adding info for No Bus:ttyca
PM: Adding info for No Bus:ttycb
PM: Adding info for No Bus:ttycc
PM: Adding info for No Bus:ttycd
PM: Adding info for No Bus:ttyce
PM: Adding info for No Bus:ttycf
PM: Adding info for No Bus:ttyd0
PM: Adding info for No Bus:ttyd1
PM: Adding info for No Bus:ttyd2
PM: Adding info for No Bus:ttyd3
PM: Adding info for No Bus:ttyd4
PM: Adding info for No Bus:ttyd5
PM: Adding info for No Bus:ttyd6
PM: Adding info for No Bus:ttyd7
PM: Adding info for No Bus:ttyd8
PM: Adding info for No Bus:ttyd9
PM: Adding info for No Bus:ttyda
PM: Adding info for No Bus:ttydb
PM: Adding info for No Bus:ttydc
PM: Adding info for No Bus:ttydd
PM: Adding info for No Bus:ttyde
PM: Adding info for No Bus:ttydf
PM: Adding info for No Bus:ttye0
PM: Adding info for No Bus:ttye1
PM: Adding info for No Bus:ttye2
PM: Adding info for No Bus:ttye3
PM: Adding info for No Bus:ttye4
PM: Adding info for No Bus:ttye5
PM: Adding info for No Bus:ttye6
PM: Adding info for No Bus:ttye7
PM: Adding info for No Bus:ttye8
PM: Adding info for No Bus:ttye9
PM: Adding info for No Bus:ttyea
PM: Adding info for No Bus:ttyeb
PM: Adding info for No Bus:ttyec
PM: Adding info for No Bus:ttyed
PM: Adding info for No Bus:ttyee
PM: Adding info for No Bus:ttyef
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:rawctl
PM: Adding info for No Bus:hpet
intel_rng: FWH not detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
PM: Adding info for No Bus:agpgart
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
PM: Adding info for platform:serial8250
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
PM: Adding info for No Bus:ttyS3
PM: Removing info for No Bus:ttyS0
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
PM: Adding info for No Bus:ttyS0
floppy0: no floppy controllers found
PM: Adding info for No Bus:ram0
PM: Adding info for No Bus:1:0
PM: Adding info for No Bus:ram1
PM: Adding info for No Bus:1:1
PM: Adding info for No Bus:ram2
PM: Adding info for No Bus:1:2
PM: Adding info for No Bus:ram3
PM: Adding info for No Bus:1:3
PM: Adding info for No Bus:ram4
PM: Adding info for No Bus:1:4
PM: Adding info for No Bus:ram5
PM: Adding info for No Bus:1:5
PM: Adding info for No Bus:ram6
PM: Adding info for No Bus:1:6
PM: Adding info for No Bus:ram7
PM: Adding info for No Bus:1:7
PM: Adding info for No Bus:ram8
PM: Adding info for No Bus:1:8
PM: Adding info for No Bus:ram9
PM: Adding info for No Bus:1:9
PM: Adding info for No Bus:ram10
PM: Adding info for No Bus:1:10
PM: Adding info for No Bus:ram11
PM: Adding info for No Bus:1:11
PM: Adding info for No Bus:ram12
PM: Adding info for No Bus:1:12
PM: Adding info for No Bus:ram13
PM: Adding info for No Bus:1:13
PM: Adding info for No Bus:ram14
PM: Adding info for No Bus:1:14
PM: Adding info for No Bus:ram15
PM: Adding info for No Bus:1:15
brd: module loaded
PM: Adding info for No Bus:loop0
PM: Adding info for No Bus:7:0
PM: Adding info for No Bus:loop1
PM: Adding info for No Bus:7:1
PM: Adding info for No Bus:loop2
PM: Adding info for No Bus:7:2
PM: Adding info for No Bus:loop3
PM: Adding info for No Bus:7:3
PM: Adding info for No Bus:loop4
PM: Adding info for No Bus:7:4
PM: Adding info for No Bus:loop5
PM: Adding info for No Bus:7:5
PM: Adding info for No Bus:loop6
PM: Adding info for No Bus:7:6
PM: Adding info for No Bus:loop7
PM: Adding info for No Bus:7:7
loop: module loaded
console [netcon0] enabled
netconsole: network logging started
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
piix 0000:00:1f.1: IDE port disabled
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1810-0x1817
Probing IDE interface ide0...
hda: MATSHITADVD-RAM UJ-841S, ATAPI CD/DVD-ROM drive
PM: Adding info for No Bus:ide0
PM: Adding info for No Bus:ide0
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
PM: Adding info for ide:0.0
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
ide-cd driver 5.00
ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
PM: Adding info for No Bus:hda
PM: Adding info for No Bus:3:0
3ware Storage Controller device driver for Linux v1.26.02.002.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 24 for MSI/MSI-X
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x5 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
PM: Adding info for No Bus:host0
PM: Adding info for No Bus:host0
scsi1 : ahci
PM: Adding info for No Bus:host1
PM: Adding info for No Bus:host1
scsi2 : ahci
PM: Adding info for No Bus:host2
PM: Adding info for No Bus:host2
scsi3 : ahci
PM: Adding info for No Bus:host3
PM: Adding info for No Bus:host3
ata1: SATA max UDMA/133 abar m1024@0xf0644400 port 0xf0644500 irq 24
ata2: DUMMY
ata3: SATA max UDMA/133 abar m1024@0xf0644400 port 0xf0644600 irq 24
ata4: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ATA-7: ST9120822AS, 3.ALE, max UDMA/133
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
PM: Adding info for No Bus:target0:0:0
PM: Adding info for scsi:0:0:0:0
PM: Adding info for No Bus:0:0:0:0
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
PM: Adding info for No Bus:sda
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
PM: Adding info for No Bus:sda1
PM: Adding info for No Bus:sda2
PM: Adding info for No Bus:sda5
PM: Adding info for No Bus:sda6
PM: Adding info for No Bus:sda7
PM: Adding info for No Bus:sda8
PM: Adding info for No Bus:sda9
PM: Adding info for No Bus:8:0
sd 0:0:0:0: [sda] Attached SCSI disk
PM: Adding info for No Bus:0:0:0:0
PM: Adding info for No Bus:sg0
sd 0:0:0:0: Attached scsi generic sg0 type 0
ata3: SATA link down (SStatus 0 SControl 300)
ohci1394 0000:08:03.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PM: Adding info for ieee1394:fw-host0
PM: Adding info for No Bus:fw-host0
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[16]  MMIO=[f0200000-f02007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
PM: Adding info for No Bus:raw1394
ieee1394: raw1394: /dev/raw1394 device initialized
PM: Adding info for No Bus:usbmon0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
PM: Adding info for No Bus:usb_host1
PM: Adding info for No Bus:usbmon1
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf0644000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.29-rc1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
PM: Adding info for usb:usb1
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
PM: Adding info for No Bus:usbdev1.1_ep00
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
PM: Adding info for No Bus:usb_host2
PM: Adding info for No Bus:usbmon2
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001820
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.29-rc1 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
PM: Adding info for usb:usb2
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
PM: Adding info for No Bus:usbdev2.1_ep00
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
PM: Adding info for No Bus:usb_host3
PM: Adding info for No Bus:usbmon3
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 20, io base 0x00001840
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.29-rc1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
PM: Adding info for usb:usb3
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
PM: Adding info for No Bus:usbdev3.1_ep00
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
PM: Adding info for No Bus:usb_host4
PM: Adding info for No Bus:usbmon4
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.29-rc1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
PM: Adding info for usb:usb4
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for No Bus:usbdev4.1
PM: Adding info for No Bus:usbdev4.1_ep00
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
PM: Adding info for No Bus:usb_host5
PM: Adding info for No Bus:usbmon5
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001880
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.29-rc1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
PM: Adding info for usb:usb5
usb usb5: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev5.1_ep81
PM: Adding info for No Bus:usbdev5.1
PM: Adding info for No Bus:usbdev5.1_ep00
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
serio: i8042 AUX1 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio1
serio: i8042 AUX2 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio2
serio: i8042 AUX3 port at 0x60,0x64 irq 12
PM: Adding info for serio:serio3
PM: Adding info for No Bus:mice
PM: Adding info for serio:serio4
PM: Adding info for No Bus:psaux
mice: PS/2 mouse device common for all mice
PM: Adding info for No Bus:event0
PM: Adding info for No Bus:event1
PM: Adding info for No Bus:event2
PM: Adding info for No Bus:event3
PM: Adding info for No Bus:device-mapper
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to TSC halts in idle
usb 3-1: new low speed USB device using uhci_hcd and address 2
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
PM: Adding info for No Bus:input4
input: AT Translated Set 2 keyboard as /class/input/input4
oprofile: using NMI interrupt.
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
PM: Adding info for No Bus:sit0
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
PM: Adding info for No Bus:event4
Using IPI No-Shortcut mode
PM: Adding info for No Bus:cpu_dma_latency
PM: Adding info for No Bus:network_latency
PM: Adding info for No Bus:network_throughput
PM: Resume from partition /dev/sda8
PM: Checking hibernation image.
PM: Resume from disk failed.
registered taskstats version 1
Freeing unused kernel memory: 304k freed
Write protecting the kernel text: 3084k
Write protecting the kernel read-only data: 1336k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
usb 3-1: New USB device found, idVendor=046d, idProduct=c040
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: USB-PS/2 Optical Mouse
usb 3-1: Manufacturer: Logitech
PM: Adding info for usb:3-1
usb 3-1: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-1:1.0
PM: Adding info for hid:0003:046D:C040.0001
PM: Adding info for No Bus:input5
input: Logitech USB-PS/2 Optical Mouse as /class/input/input5
PM: Adding info for No Bus:mouse0
PM: Adding info for No Bus:event5
PM: Adding info for No Bus:hidraw0
generic-usb 0003:046D:C040.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.1-1/input0
PM: Adding info for No Bus:usbdev3.2_ep81
PM: Adding info for No Bus:usbdev3.2
PM: Adding info for No Bus:usbdev3.2_ep00
PM: Adding info for ieee1394:00000e1003d248c6
PM: Adding info for No Bus:00000e1003d248c6
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00000e1003d248c6]
sky2 driver version 1.22
sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
sky2 0000:02:00.0: setting latency timer to 64
sky2 0000:02:00.0: Yukon-2 EC Ultra chip revision 2
sky2 0000:02:00.0: Marvell Yukon 88E8055 Gigabit Ethernet Controller
 Part Number: Yukon 88E8055
 Engineering Level: Rev. 1.2
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x1a0b1, caps: 0xa04793/0x302000
 Manufacturer: Marvell
sky2 0000:02:00.0: irq 25 for MSI/MSI-X
serio: Synaptics pass-through port at isa0060/serio4/input0
PM: Adding info for No Bus:eth0
sky2 eth0: addr 00:17:42:71:25:91
udev: renamed network interface eth0 to lan0
PM: Adding info for No Bus:input6
input: SynPS/2 Synaptics TouchPad as /class/input/input6
PM: Adding info for No Bus:mouse1
PM: Adding info for No Bus:event6
PM: Adding info for serio:serio5
PM: Starting manual resume from disk
PM: Resume from partition 8:8
PM: Checking hibernation image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
udevd version 125 started
PM: Adding info for No Bus:input7
input: Fujitsu FUJ02B1 as /class/input/input7
PM: Adding info for No Bus:event7
ACPI: Fujitsu FUJ02B1 [FJEX] (on)
PM: Adding info for platform:fujitsu-laptop
PM: Adding info for No Bus:fujitsu-laptop
PM: Adding info for No Bus:input8
input: Fujitsu FUJ02E3 as /class/input/input8
PM: Adding info for No Bus:event8
ACPI: Fujitsu FUJ02E3 [FEXT] (on)
fujitsu-laptop: BTNI: [0xff0101]
fujitsu-laptop: driver 0.5.0 successfully loaded.
PM: Adding info for platform:regulatory.0
cfg80211: Calling CRDA to update world regulatory domain
rtc_cmos 00:04: RTC can wake from S4
PM: Adding info for No Bus:rtc0
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
PM: Adding info for No Bus:timer
PM: Adding info for No Bus:seq
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: setting latency timer to 64
PM: Adding info for No Bus:sequencer
PM: Adding info for No Bus:sequencer2
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945 0000:05:00.0: PCI INT A disabled
PM: Adding info for No Bus:phy0
wmaster0 (iwl3945): not using net_device_ops yet
PM: Adding info for No Bus:wmaster0
phy0: Selected rate control algorithm 'iwl-3945-rs'
wlan0 (iwl3945): not using net_device_ops yet
PM: Adding info for No Bus:wlan0
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: setting latency timer to 64
PM: Adding info for No Bus:pcmC0D1p
PM: Adding info for No Bus:adsp
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
PM: Adding info for No Bus:controlC0
PM: Adding info for No Bus:mixer
Clocksource tsc unstable (delta = -111077963 ns)
PM: Adding info for No Bus:input9
input: PS/2 Generic Mouse as /class/input/input9
PM: Adding info for No Bus:mouse2
PM: Adding info for No Bus:event9
Adding 979924k swap on /dev/sda8.  Priority:-1 extents:1 across:979924k 
EXT3 FS on sda1, internal journal
PM: Adding info for platform:coretemp.0
coretemp coretemp.0: Using relative temperature scale!
PM: Adding info for No Bus:hwmon0
PM: Adding info for platform:coretemp.1
coretemp coretemp.1: Using relative temperature scale!
PM: Adding info for No Bus:hwmon1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
PM: Adding info for No Bus:tun
fuse init (API version 7.11)
PM: Adding info for No Bus:fuse
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
iwl3945 0000:05:00.0: irq 26 for MSI/MSI-X
iwl3945 0000:05:00.0: firmware: requesting iwlwifi-3945-2.ucode
PM: Adding info for No Bus:0000:05:00.0
PM: Removing info for No Bus:0000:05:00.0
iwl3945: iwlwifi-3945-2.ucode firmware file req failed: Reason -2
iwl3945 0000:05:00.0: firmware: requesting iwlwifi-3945-1.ucode
PM: Adding info for No Bus:0000:05:00.0
PM: Removing info for No Bus:0000:05:00.0
iwl3945: Loaded firmware iwlwifi-3945-1.ucode, which is deprecated. Please use API v2 instead.
iwl3945: Firmware has old API version. Expected 2, got 1. New firmware can be obtained from http://www.intellinuxwireless.org.
iwl3945 loaded firmware version 15.28.1.6
iwl3945: Radio disabled by HW RF Kill switch
iwl3945 0000:05:00.0: PCI INT A disabled
sky2 lan0: enabling interface
ADDRCONF(NETDEV_UP): lan0: link is not ready
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
sky2 lan0: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): lan0: link becomes ready

--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-2.6.29-rc1"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc1
# Mon Jan 12 10:26:51 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
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
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=18
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set

#
# Control Group support
#
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_STRIP_GENERATED=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_COMPAT_BRK=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_SPARSE_IRQ is not set
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
# CONFIG_X86_RDC321X is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
CONFIG_MPENTIUMIII=y
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
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
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR_32=y
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
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
CONFIG_X86_MCE_P4THERMAL=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_UNEVICTABLE_LRU=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_VERBOSE=y
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_DEBUG_FUNC_TRACE is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NET_NS is not set
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
# CONFIG_INET6_XFRM_MODE_BEET is not set
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
# CONFIG_NF_CONNTRACK_AMANDA is not set
CONFIG_NF_CONNTRACK_FTP=m
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CONNTRACK_TFTP=m
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
# CONFIG_NETFILTER_XT_TARGET_NOTRACK is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
# CONFIG_NETFILTER_XT_TARGET_TRACE is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_CLS_ROUTE=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_PHONET is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_NL80211=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=m
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

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
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_C2PORT is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=y

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_IDE_GD=y
CONFIG_IDE_GD_ATA=y
# CONFIG_IDE_GD_ATAPI is not set
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_IDEPCI_PCIBUS_ORDER=y
# CONFIG_BLK_DEV_GENERIC is not set
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
CONFIG_BLK_DEV_AMD74XX=y
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT8172 is not set
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
# CONFIG_SCSI_AIC7XXX_OLD is not set
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=4000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_LIBFC is not set
# CONFIG_FCOE is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_DH is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=y
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
CONFIG_SATA_NV=y
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
CONFIG_SATA_SIL=y
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
CONFIG_IEEE1394_RAWIO=y
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLWIFI_RFKILL is not set
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLAGN is not set
CONFIG_IWL3945=m
# CONFIG_IWL3945_RFKILL is not set
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

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
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

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
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_AT24 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_HWMON=m
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_USB_VIDEO_CLASS is not set
CONFIG_USB_GSPCA=m
# CONFIG_USB_M5602 is not set
# CONFIG_USB_STV06XX is not set
# CONFIG_USB_GSPCA_CONEX is not set
# CONFIG_USB_GSPCA_ETOMS is not set
# CONFIG_USB_GSPCA_FINEPIX is not set
# CONFIG_USB_GSPCA_MARS is not set
# CONFIG_USB_GSPCA_OV519 is not set
# CONFIG_USB_GSPCA_OV534 is not set
# CONFIG_USB_GSPCA_PAC207 is not set
# CONFIG_USB_GSPCA_PAC7311 is not set
# CONFIG_USB_GSPCA_SONIXB is not set
# CONFIG_USB_GSPCA_SONIXJ is not set
# CONFIG_USB_GSPCA_SPCA500 is not set
# CONFIG_USB_GSPCA_SPCA501 is not set
# CONFIG_USB_GSPCA_SPCA505 is not set
# CONFIG_USB_GSPCA_SPCA506 is not set
# CONFIG_USB_GSPCA_SPCA508 is not set
# CONFIG_USB_GSPCA_SPCA561 is not set
# CONFIG_USB_GSPCA_STK014 is not set
# CONFIG_USB_GSPCA_SUNPLUS is not set
# CONFIG_USB_GSPCA_T613 is not set
# CONFIG_USB_GSPCA_TV8532 is not set
# CONFIG_USB_GSPCA_VC032X is not set
# CONFIG_USB_GSPCA_ZC3XX is not set
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_VICAM is not set
# CONFIG_USB_IBMCAM is not set
# CONFIG_USB_KONICAWC is not set
# CONFIG_USB_QUICKCAM_MESSENGER is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_VIDEO_OVCAMCHIP is not set
# CONFIG_USB_OV511 is not set
# CONFIG_USB_SE401 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_STV680 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_PWC is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_USB_S2255 is not set
CONFIG_RADIO_ADAPTERS=y
# CONFIG_RADIO_GEMTEK_PCI is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_MAESTRO is not set
# CONFIG_USB_DSBR is not set
# CONFIG_USB_SI470X is not set
# CONFIG_USB_MR800 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_DVB_DYNAMIC_MINORS is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
CONFIG_BACKLIGHT_GENERIC=m
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
CONFIG_DUMMY_CONSOLE=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
# CONFIG_SND_HDA_INPUT_BEEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
CONFIG_SND_HDA_CODEC_INTELHDMI=y
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=60
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_SOC is not set
CONFIG_SOUND_PRIME=y
# CONFIG_SOUND_OSS is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_COMPAT is not set
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_EZKEY=y
CONFIG_HID_GYRATION=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_TOPSEED=y
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_ZEROPLUS_FF is not set
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
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
#

#
# see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
CONFIG_MMC_TEST=m

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
# CONFIG_MMC_RICOH_MMC is not set
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_HP_DISK is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
# CONFIG_LEDS_TRIGGER_TIMER is not set
# CONFIG_LEDS_TRIGGER_IDE_DISK is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ASUS_LAPTOP is not set
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
# CONFIG_EXT3_FS_SECURITY is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

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
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
# CONFIG_ROOT_NFS is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
# CONFIG_SUNRPC_REGISTER_V4 is not set
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_RING_BUFFER=y
CONFIG_TRACING=y

#
# Tracers
#
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_BOOT_TRACER=y
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_BUILD_DOCSRC is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_586=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_586=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=m
# CONFIG_CRC16 is not set
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y

--gBBFr7Ir9EOA20Yy--
