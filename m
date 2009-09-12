Return-Path: <linux-kernel-owner+w=401wt.eu-S1751620AbZILHhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbZILHhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZILHhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:37:46 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:60768 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751097AbZILHho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:37:44 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net E2E5728EFE4
Message-ID: <4AAB4FC9.4060402@arcor.de>
Date: Sat, 12 Sep 2009 10:37:45 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <200909112033.34445.volkerarmin@googlemail.com>
In-Reply-To: <200909112033.34445.volkerarmin@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Volker stripped all CCs from his posts; I restored them manually.)

On 09/11/2009 09:33 PM, Volker Armin Hemmann wrote:
> Hi,
>
> this is with 2.6.31+reiser4+fglrx
> Phenom II X4 955
>
> KDE 4.3.1, composite temporary disabled.
> tvtime running.
>
> load:
> fat emerge with make -j5 running in one konsole tab (xulrunner being
> compiled).
>
> without NO_NEW_FAIR_SLEEPERS:
>
> tvtime is smooth most of the time
>
> with NO_NEW_FAIR_SLEEPERS:
>
> tvtime is more jerky. Very visible in scenes with movement.

Is the make -j5 running niced 0?  If yes, that would be actually the 
correct behavior.  Unfortunately, I can't test tvtime specifically (I 
don't have a TV card), but other applications displaying video continue 
to work smooth on my dual core machine (Core 2 Duo E6600) even if I do 
"nice -n 19 make -j20".  If I don't nice it, the video is skippy here 
too though.

Question to Ingo:
Would posting perf results help in any way with finding differences 
between mainline NEW_FAIR_SLEEPERS/NO_NEW_FAIR_SLEEPERS and BFS?


> without background load:
>
> both settings act the same. tvtime is smooth, video is smooth, games are nice.
> No real difference.
>
> config is attached.
>
> Glück Auf,
> Volker
>
> dmesg:
>
> [    0.000000] Linux version 2.6.31r4 (root@energy) (gcc version 4.4.1 (Gentoo
> 4.4.1 p1.0) ) #1 SMP Thu Sep 10 10:48:07 CEST 2009
> [    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3
> nmi_watchdog=0 mtrr_spare_reg_nr=1
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)
> [    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
> [    0.000000] DMI present.
> [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
> [    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable)
> ==>  (reserved)
> [    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-EFFFF uncachable
> [    0.000000]   F0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> [    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back
> [    0.000000]   3 disabled
> [    0.000000]   4 disabled
> [    0.000000]   5 disabled
> [    0.000000]   6 disabled
> [    0.000000]   7 disabled
> [    0.000000] TOM2: 0000000238000000 aka 9088M
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> 0x7010600070106
> [    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable)
> ==>  (reserved)
> [    0.000000] last_pfn = 0xc7eb0 max_arch_pfn = 0x400000000
> [    0.000000] Scanning 0 areas for low memory corruption
> [    0.000000] modified physical RAM map:
> [    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
> [    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
> [    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)
> [    0.000000]  modified: 0000000000100000 - 00000000c7eb0000 (usable)
> [    0.000000]  modified: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)
> [    0.000000]  modified: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)
> [    0.000000]  modified: 00000000c7ef0000 - 00000000c7f00000 (reserved)
> [    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
> [    0.000000]  modified: 0000000100000000 - 0000000238000000 (usable)
> [    0.000000] initial memory mapped : 0 - 20000000
> [    0.000000] Using GB pages for direct mapping
> [    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000
> [    0.000000]  0000000000 - 00c0000000 page 1G
> [    0.000000]  00c0000000 - 00c7e00000 page 2M
> [    0.000000]  00c7e00000 - 00c7eb0000 page 4k
> [    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000
> [    0.000000] init_memory_mapping: 0000000100000000-0000000238000000
> [    0.000000]  0100000000 - 0200000000 page 1G
> [    0.000000]  0200000000 - 0238000000 page 2M
> [    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000
> [    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)
> [    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090506
> MSFT 00000097)
> [    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000601
> MSFT 00000097)
> [    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000121
> INTL 20051117)
> [    0.000000] ACPI: FACS 00000000c7ec0000 00040
> [    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090506
> MSFT 00000097)
> [    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090506
> MSFT 00000097)
> [    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090506
> MSFT 00000097)
> [    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090506
> MSFT 00000097)
> [    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090506
> MSFT 00000097)
> [    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000001
> AMD  00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] (7 early reservations) ==>  bootmem [0000000000 - 0238000000]
> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>  [0000000000
> - 0000001000]
> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>  [0000006000
> - 0000008000]
> [    0.000000]   #2 [0001000000 - 00015fb8c0]    TEXT DATA BSS ==>  [0001000000
> - 00015fb8c0]
> [    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==>  [000009fc00
> - 0000100000]
> [    0.000000]   #4 [00015fc000 - 00015fc133]              BRK ==>  [00015fc000
> - 00015fc133]
> [    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==>  [0000010000
> - 0000012000]
> [    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==>  [0000012000
> - 0000013000]
> [    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD ->  [ffff880028600000-
> ffff88002f7fffff] on node 0
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA      0x00000010 ->  0x00001000
> [    0.000000]   DMA32    0x00001000 ->  0x00100000
> [    0.000000]   Normal   0x00100000 ->  0x00238000
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0: 0x00000010 ->  0x0000009f
> [    0.000000]     0: 0x00000100 ->  0x000c7eb0
> [    0.000000]     0: 0x00100000 ->  0x00238000
> [    0.000000] On node 0 totalpages: 2096703
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 102 pages reserved
> [    0.000000]   DMA zone: 3825 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31
> [    0.000000]   Normal zone: 17472 pages used for memmap
> [    0.000000]   Normal zone: 1260480 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x808
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
> [    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 24
> [    0.000000] PM: Registered nosave memory: 000000000009f000 -
> 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 -
> 00000000000e6000
> [    0.000000] PM: Registered nosave memory: 00000000000e6000 -
> 0000000000100000
> [    0.000000] PM: Registered nosave memory: 00000000c7eb0000 -
> 00000000c7ec0000
> [    0.000000] PM: Registered nosave memory: 00000000c7ec0000 -
> 00000000c7ef0000
> [    0.000000] PM: Registered nosave memory: 00000000c7ef0000 -
> 00000000c7f00000
> [    0.000000] PM: Registered nosave memory: 00000000c7f00000 -
> 00000000fff00000
> [    0.000000] PM: Registered nosave memory: 00000000fff00000 -
> 0000000100000000
> [    0.000000] Allocating PCI resources starting at c7f00000 (gap:
> c7f00000:38000000)
> [    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 25 pages at ffff880028034000, static data 72160
> bytes
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total
> pages: 2064793
> [    0.000000] Kernel command line: root=/dev/md1
> md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1
> [    0.000000] md: Will configure md3 (super-block) from
> /dev/sda3,/dev/sdb3,/dev/sdc3, below.
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608
> bytes)
> [    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304
> bytes)
> [    0.000000] Initializing CPU#0
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Node 0: aperture @ 2a42000000 size 32 MB
> [    0.000000] Aperture beyond 4GB. Ignoring.
> [    0.000000] Your BIOS doesn't leave a aperture memory hole
> [    0.000000] Please enable the IOMMU option in the BIOS setup
> [    0.000000] This costs you 64 MB of RAM
> [    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 -
> 0000000024000000
> [    0.000000] Memory: 8184476k/9306112k available (3500k kernel code, 919300k
> absent, 201380k reserved, 1751k data, 376k init)
> [    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4,
> Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] NR_IRQS:4352 nr_irqs:440
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 3200.214 MHz processor.
> [    0.000609] Console: colour VGA+ 80x25
> [    0.000611] console [tty0] enabled
> [    0.003333] hpet clockevent registered
> [    0.003333]   alloc irq_desc for 24 on node 0
> [    0.003333]   alloc kstat_irqs on node 0
> [    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu
> timer
> [    0.003339] Calibrating delay loop (skipped), value calculated using timer
> frequency.. 6402.10 BogoMIPS (lpj=10667366)
> [    0.003421] Mount-cache hash table entries: 256
> [    0.003543] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
> bytes/line)
> [    0.003578] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.003613] tseg: 0000000000
> [    0.003618] CPU: Physical Processor ID: 0
> [    0.003652] CPU: Processor Core ID: 0
> [    0.003686] mce: CPU supports 6 MCE banks
> [    0.003725] using C1E aware idle routine
> [    0.003768] ACPI: Core revision 20090521
> [    0.016704] Setting APIC routing to flat
> [    0.017026] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.050860] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
> [    0.053333] Booting processor 1 APIC 0x1 ip 0x6000
> [    0.003333] Initializing CPU#1
> [    0.003333] Calibrating delay using timer specific routine.. 6402.85
> BogoMIPS (lpj=10666966)
> [    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
> bytes/line)
> [    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 1
> [    0.003333] mce: CPU supports 6 MCE banks
> [    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new
> 0x7010600070106
> [    0.144161] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
> [    0.144507] checking TSC synchronization [CPU#0 ->  CPU#1]: passed.
> [    0.146699] Booting processor 2 APIC 0x2 ip 0x6000
> [    0.003333] Initializing CPU#2
> [    0.003333] Calibrating delay using timer specific routine.. 6402.85
> BogoMIPS (lpj=10666970)
> [    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
> bytes/line)
> [    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 2
> [    0.003333] mce: CPU supports 6 MCE banks
> [    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new
> 0x7010600070106
> [    0.240822] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
> [    0.241168] checking TSC synchronization [CPU#0 ->  CPU#2]: passed.
> [    0.243373] Booting processor 3 APIC 0x3 ip 0x6000
> [    0.003333] Initializing CPU#3
> [    0.003333] Calibrating delay using timer specific routine.. 6402.85
> BogoMIPS (lpj=10666972)
> [    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
> bytes/line)
> [    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 3
> [    0.003333] mce: CPU supports 6 MCE banks
> [    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new
> 0x7010600070106
> [    0.337491] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
> [    0.337836] checking TSC synchronization [CPU#0 ->  CPU#3]: passed.
> [    0.340006] Brought up 4 CPUs
> [    0.340040] Total of 4 processors activated (25611.67 BogoMIPS).
> [    0.340109] CPU0 attaching sched-domain:
> [    0.340111]  domain 0: span 0-3 level MC
> [    0.340112]   groups: 0 1 2 3
> [    0.340116] CPU1 attaching sched-domain:
> [    0.340117]  domain 0: span 0-3 level MC
> [    0.340118]   groups: 1 2 3 0
> [    0.340120] CPU2 attaching sched-domain:
> [    0.340121]  domain 0: span 0-3 level MC
> [    0.340122]   groups: 2 3 0 1
> [    0.340125] CPU3 attaching sched-domain:
> [    0.340126]  domain 0: span 0-3 level MC
> [    0.340127]   groups: 3 0 1 2
> [    0.340162] xor: automatically using best checksumming function:
> generic_sse
> [    0.356667]    generic_sse: 12835.200 MB/sec
> [    0.356700] xor: using function: generic_sse (12835.200 MB/sec)
> [    0.356754] Time:  7:07:42  Date: 09/11/09
> [    0.356802] NET: Registered protocol family 16
> [    0.356851] node 0 link 0: io port [1000, ffffff]
> [    0.356851] TOM: 00000000c8000000 aka 3200M
> [    0.356851] Fam 10h mmconf [e0000000, efffffff]
> [    0.356851] node 0 link 0: mmio [e0000000, efffffff] ==>  none
> [    0.356851] node 0 link 0: mmio [f0000000, ffffffff]
> [    0.356851] node 0 link 0: mmio [a0000, bffff]
> [    0.356851] node 0 link 0: mmio [c8000000, dfffffff]
> [    0.356851] TOM2: 0000000238000000 aka 9088M
> [    0.356851] bus: [00,07] on node 0 link 0
> [    0.356851] bus: 00 index 0 io port: [0, ffff]
> [    0.356851] bus: 00 index 1 mmio: [f0000000, ffffffff]
> [    0.356851] bus: 00 index 2 mmio: [a0000, bffff]
> [    0.356851] bus: 00 index 3 mmio: [c8000000, dfffffff]
> [    0.356851] bus: 00 index 4 mmio: [238000000, fcffffffff]
> [    0.356851] ACPI: bus type pci registered
> [    0.356851] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.356851] PCI: Not using MMCONFIG.
> [    0.356851] PCI: Using configuration type 1 for base access
> [    0.356851] PCI: Using configuration type 1 for extended access
> [    0.356851] bio: create slab<bio-0>  at 0
> [    0.356978] ACPI: EC: Look up EC in DSDT
> [    0.367031] ACPI: Interpreter enabled
> [    0.367538] ACPI: (supports S0 S1 S3 S4 S5)
> [    0.367652] ACPI: Using IOAPIC for interrupt routing
> [    0.367725] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
> [    0.370531] PCI: MCFG area at e0000000 reserved in ACPI motherboard
> resources
> [    0.375947] PCI: Using MMCONFIG at e0000000 - efffffff
> [    0.380367] ACPI: No dock devices found.
> [    0.380451] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.380520] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
> [    0.380520] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
> [    0.380520] pci 0000:00:02.0: PME# disabled
> [    0.380520] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
> [    0.380520] pci 0000:00:09.0: PME# disabled
> [    0.380520] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
> [    0.380520] pci 0000:00:0a.0: PME# disabled
> [    0.380520] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]
> [    0.380520] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]
> [    0.380520] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]
> [    0.380520] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]
> [    0.380520] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]
> [    0.380520] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]
> [    0.380520] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]
> [    0.380520] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]
> [    0.380576] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]
> [    0.380625] pci 0000:00:12.2: supports D1 D2
> [    0.380626] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
> [    0.380663] pci 0000:00:12.2: PME# disabled
> [    0.380724] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]
> [    0.380775] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]
> [    0.380843] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]
> [    0.380893] pci 0000:00:13.2: supports D1 D2
> [    0.380894] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
> [    0.380930] pci 0000:00:13.2: PME# disabled
> [    0.381072] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
> [    0.381078] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
> [    0.381084] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
> [    0.381089] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
> [    0.381095] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
> [    0.381219] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]
> [    0.381353] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
> [    0.381360] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]
> [    0.381365] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]
> [    0.381372] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]
> [    0.381387] pci 0000:02:00.0: supports D1 D2
> [    0.381415] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]
> [    0.381445] pci 0000:02:00.1: supports D1 D2
> [    0.381495] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]
> [    0.381497] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
> [    0.381500] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
> [    0.381543] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]
> [    0.381545] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]
> [    0.381548] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]
> [    0.383347] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]
> [    0.383360] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]
> [    0.383370] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]
> [    0.383375] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]
> [    0.383402] pci 0000:01:00.0: supports D1 D2
> [    0.383403] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.383440] pci 0000:01:00.0: PME# disabled
> [    0.383525] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]
> [    0.383527] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
> [    0.383530] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]
> [    0.383565] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]
> [    0.383644] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]
> [    0.383701] pci 0000:05:08.0: supports D1 D2
> [    0.383743] pci 0000:00:14.4: transparent bridge
> [    0.383779] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
> [    0.383785] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]
> [    0.383797] pci_bus 0000:00: on NUMA node 0
> [    0.383800] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.383936] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
> [    0.383981] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
> [    0.384025] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
> [    0.384091] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]
> [    0.386726] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)
> [    0.386953] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)
> [    0.387183] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
> [    0.387408] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
> [    0.387643] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0,
> disabled.
> [    0.387914] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)
> [    0.388140] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)
> [    0.388352] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)
> [    0.388538] SCSI subsystem initialized
> [    0.388538] libata version 3.00 loaded.
> [    0.388538] usbcore: registered new interface driver usbfs
> [    0.388538] usbcore: registered new interface driver hub
> [    0.388538] usbcore: registered new device driver usb
> [    0.443347] raid6: int64x1   2755 MB/s
> [    0.500010] raid6: int64x2   3858 MB/s
> [    0.556669] raid6: int64x4   2850 MB/s
> [    0.613353] raid6: int64x8   2537 MB/s
> [    0.670007] raid6: sse2x1    3999 MB/s
> [    0.726666] raid6: sse2x2    7012 MB/s
> [    0.783343] raid6: sse2x4    7975 MB/s
> [    0.783377] raid6: using algorithm sse2x4 (7975 MB/s)
> [    0.783423] PCI: Using ACPI for IRQ routing
> [    0.783423] pci 0000:00:00.0: BAR 3: address space collision on of device
> [0xe0000000-0xffffffff]
> [    0.783425] pci 0000:00:00.0: BAR 3: can't allocate resource
> [    0.793433] PCI-DMA: Disabling AGP.
> [    0.793518] PCI-DMA: aperture base @ 20000000 size 65536 KB
> [    0.793518] PCI-DMA: using GART IOMMU.
> [    0.793518] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
> [    0.795205] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
> [    0.795312] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
> [    0.800030] hpet: hpet2 irq 24 for MSI
> [    0.810015] Switched to high resolution mode on CPU 0
> [    0.811193] Switched to high resolution mode on CPU 2
> [    0.811196] Switched to high resolution mode on CPU 1
> [    0.811200] Switched to high resolution mode on CPU 3
> [    0.820035] pnp: PnP ACPI init
> [    0.820085] ACPI: bus type pnp registered
> [    0.822351] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3
> (0x0-0x1fffffff), disabling
> [    0.822406] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0
> BAR 3 (0x0-0x1fffffff), disabling
> [    0.822461] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0
> BAR 3 (0x0-0x1fffffff), disabling
> [    0.822515] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps
> 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
> [    0.822837] pnp: PnP ACPI: found 12 devices
> [    0.822871] ACPI: ACPI bus type pnp unregistered
> [    0.822911] system 00:06: iomem range 0xfec00000-0xfec00fff could not be
> reserved
> [    0.822965] system 00:06: iomem range 0xfee00000-0xfee00fff has been
> reserved
> [    0.823002] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
> [    0.823037] system 00:07: ioport range 0x40b-0x40b has been reserved
> [    0.823072] system 00:07: ioport range 0x4d6-0x4d6 has been reserved
> [    0.823106] system 00:07: ioport range 0xc00-0xc01 has been reserved
> [    0.823141] system 00:07: ioport range 0xc14-0xc14 has been reserved
> [    0.823176] system 00:07: ioport range 0xc50-0xc51 has been reserved
> [    0.823211] system 00:07: ioport range 0xc52-0xc52 has been reserved
> [    0.823245] system 00:07: ioport range 0xc6c-0xc6c has been reserved
> [    0.823280] system 00:07: ioport range 0xc6f-0xc6f has been reserved
> [    0.823315] system 00:07: ioport range 0xcd0-0xcd1 has been reserved
> [    0.823359] system 00:07: ioport range 0xcd2-0xcd3 has been reserved
> [    0.823394] system 00:07: ioport range 0xcd4-0xcd5 has been reserved
> [    0.823429] system 00:07: ioport range 0xcd6-0xcd7 has been reserved
> [    0.823464] system 00:07: ioport range 0xcd8-0xcdf has been reserved
> [    0.823499] system 00:07: ioport range 0x800-0x89f has been reserved
> [    0.823533] system 00:07: ioport range 0xb00-0xb0f has been reserved
> [    0.823568] system 00:07: ioport range 0xb20-0xb3f has been reserved
> [    0.823603] system 00:07: ioport range 0x900-0x90f has been reserved
> [    0.823638] system 00:07: ioport range 0x910-0x91f has been reserved
> [    0.823673] system 00:07: ioport range 0xfe00-0xfefe has been reserved
> [    0.823708] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved
> [    0.823743] system 00:07: iomem range 0xfec10000-0xfec1001f has been
> reserved
> [    0.823780] system 00:09: ioport range 0x290-0x29f has been reserved
> [    0.823816] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
> [    0.823852] system 00:0b: iomem range 0xfec00000-0xffffffff could not be
> reserved
> [    0.828757] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
> [    0.828792] pci 0000:00:02.0:   IO window: 0xc000-0xcfff
> [    0.828828] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff
> [    0.828863] pci 0000:00:02.0:   PREFETCH window:
> 0x000000d0000000-0x000000dfffffff
> [    0.828918] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03
> [    0.828953] pci 0000:00:09.0:   IO window: 0xd000-0xdfff
> [    0.828988] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff
> [    0.829023] pci 0000:00:09.0:   PREFETCH window:
> 0x000000fa000000-0x000000fcefffff
> [    0.829078] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01
> [    0.829112] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff
> [    0.829148] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff
> [    0.829183] pci 0000:00:0a.0:   PREFETCH window:
> 0x000000cff00000-0x000000cfffffff
> [    0.829237] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
> [    0.829273] pci 0000:00:14.4:   IO window: 0xe000-0xefff
> [    0.829310] pci 0000:00:14.4:   MEM window: disabled
> [    0.829346] pci 0000:00:14.4:   PREFETCH window: 0xfcf00000-0xfcffffff
> [    0.829387]   alloc irq_desc for 18 on node -1
> [    0.829388]   alloc kstat_irqs on node -1
> [    0.829392] pci 0000:00:02.0: PCI INT A ->  GSI 18 (level, low) ->  IRQ 18
> [    0.829428] pci 0000:00:02.0: setting latency timer to 64
> [    0.829432]   alloc irq_desc for 17 on node -1
> [    0.829433]   alloc kstat_irqs on node -1
> [    0.829435] pci 0000:00:09.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
> [    0.829471] pci 0000:00:09.0: setting latency timer to 64
> [    0.829474] pci 0000:00:0a.0: PCI INT A ->  GSI 18 (level, low) ->  IRQ 18
> [    0.829509] pci 0000:00:0a.0: setting latency timer to 64
> [    0.829516] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> [    0.829517] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
> [    0.829519] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
> [    0.829521] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]
> [    0.829522] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]
> [    0.829523] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
> [    0.829525] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]
> [    0.829526] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]
> [    0.829527] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
> [    0.829529] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]
> [    0.829530] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]
> [    0.829531] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
> [    0.829533] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]
> [    0.829534] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
> [    0.829535] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
> [    0.829547] NET: Registered protocol family 2
> [    0.829602] IP route cache hash table entries: 262144 (order: 9, 2097152
> bytes)
> [    0.830084] TCP established hash table entries: 262144 (order: 10, 4194304
> bytes)
> [    0.831067] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> [    0.831468] TCP: Hash tables configured (established 262144 bind 65536)
> [    0.831504] TCP reno registered
> [    0.831582] NET: Registered protocol family 1
> [    0.832803] Scanning for low memory corruption every 60 seconds
> [    0.833572] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.833696] Loading Reiser4. See www.namesys.com for a description of
> Reiser4.
> [    0.833781] msgmni has been set to 15987
> [    0.834082] alg: No test for stdrng (krng)
> [    0.834123] async_tx: api initialized (sync-only)
> [    0.834227] Block layer SCSI generic (bsg) driver version 0.4 loaded (major
> 253)
> [    0.834280] io scheduler noop registered
> [    0.834315] io scheduler cfq registered (default)
> [    0.834448] pci 0000:02:00.0: Boot video device
> [    0.834538]   alloc irq_desc for 25 on node -1
> [    0.834540]   alloc kstat_irqs on node -1
> [    0.834545] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X
> [    0.834550] pcieport-driver 0000:00:02.0: setting latency timer to 64
> [    0.834642]   alloc irq_desc for 26 on node -1
> [    0.834643]   alloc kstat_irqs on node -1
> [    0.834646] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X
> [    0.834650] pcieport-driver 0000:00:09.0: setting latency timer to 64
> [    0.834741]   alloc irq_desc for 27 on node -1
> [    0.834742]   alloc kstat_irqs on node -1
> [    0.834744] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X
> [    0.834748] pcieport-driver 0000:00:0a.0: setting latency timer to 64
> [    0.834953] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [    0.835007] ACPI: Power Button [PWRF]
> [    0.835098] input: Power Button as
> /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
> [    0.835152] ACPI: Power Button [PWRB]
> [    0.835302] processor LNXCPU:00: registered as cooling_device0
> [    0.835337] ACPI: Processor [CPU0] (supports 8 throttling states)
> [    0.835434] processor LNXCPU:01: registered as cooling_device1
> [    0.835504] processor LNXCPU:02: registered as cooling_device2
> [    0.835577] processor LNXCPU:03: registered as cooling_device3
> [    0.839315] Linux agpgart interface v0.103
> [    0.839511] ahci 0000:00:11.0: version 3.0
> [    0.839521]   alloc irq_desc for 22 on node -1
> [    0.839522]   alloc kstat_irqs on node -1
> [    0.839525] ahci 0000:00:11.0: PCI INT A ->  GSI 22 (level, low) ->  IRQ 22
> [    0.839673] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f
> impl SATA mode
> [    0.839727] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio
> slum part
> [    0.840272] scsi0 : ahci
> [    0.840403] scsi1 : ahci
> [    0.840501] scsi2 : ahci
> [    0.840598] scsi3 : ahci
> [    0.840697] scsi4 : ahci
> [    0.840795] scsi5 : ahci
> [    0.840926] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed
> [    0.840962] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq
> 22
> [    0.841016] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq
> 22
> [    0.841070] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq
> 22
> [    0.841124] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq
> 22
> [    0.841178] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq
> 22
> [    0.841459] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [    0.841493] PNP: PS/2 appears to have AUX port disabled, if this is
> incorrect please boot with i8042.nopnp
> [    0.841943] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.842074] mice: PS/2 mouse device common for all mice
> [    0.842243] rtc_cmos 00:02: RTC can wake from S4
> [    0.842313] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> [    0.842369] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> [    0.842428] md: raid1 personality registered for level 1
> [    0.842462] md: raid6 personality registered for level 6
> [    0.842496] md: raid5 personality registered for level 5
> [    0.842530] md: raid4 personality registered for level 4
> [    0.843117] cpuidle: using governor ladder
> [    0.843151] cpuidle: using governor menu
> [    0.843689] usbcore: registered new interface driver hiddev
> [    0.843746] usbcore: registered new interface driver usbhid
> [    0.843780] usbhid: v2.6:USB HID core driver
> [    0.843843] Advanced Linux Sound Architecture Driver Version 1.0.20.
> [    0.843878] ALSA device list:
> [    0.843911]   No soundcards found.
> [    0.843979] TCP cubic registered
> [    0.844019] NET: Registered protocol family 10
> [    0.844148] IPv6 over IPv4 tunneling driver
> [    0.844265] NET: Registered protocol family 17
> [    0.844315] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor
> processors (4 cpu cores) (version 2.20.00)
> [    0.844391] powernow-k8:    0 : pstate 0 (3200 MHz)
> [    0.844425] powernow-k8:    1 : pstate 1 (2500 MHz)
> [    0.844459] powernow-k8:    2 : pstate 2 (2100 MHz)
> [    0.844492] powernow-k8:    3 : pstate 3 (800 MHz)
> [    0.844886] PM: Resume from disk failed.
> [    0.844966]   Magic number: 9:648:116
> [    0.866018] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input2
> [    1.160036] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.160097] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.160150] ata6: SATA link down (SStatus 0 SControl 300)
> [    1.160205] ata5: SATA link down (SStatus 0 SControl 300)
> [    1.160259] ata3: SATA link down (SStatus 0 SControl 300)
> [    1.166391] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7
> [    1.166432] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    1.166480] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7
> [    1.166514] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    1.172888] ata4.00: configured for UDMA/133
> [    1.172943] ata2.00: configured for UDMA/133
> [    1.560035] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    1.566394] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7
> [    1.566430] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> [    1.572855] ata1.00: configured for UDMA/133
> [    1.583424] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0
> PQ: 0 ANSI: 5
> [    1.583684] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500
> GB/465 GiB)
> [    1.583756] sd 0:0:0:0: [sda] Write Protect is off
> [    1.583791] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.583800] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.583911]  sda:
> [    1.583952] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.584094] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0
> PQ: 0 ANSI: 5
> [    1.584283] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500
> GB/465 GiB)
> [    1.584354] sd 1:0:0:0: [sdb] Write Protect is off
> [    1.584389] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    1.584398] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.584507]  sdb:
> [    1.584577] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    1.584709] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0
> PQ: 0 ANSI: 5
> [    1.584865] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750
> GB/698 GiB)
> [    1.584934] sd 3:0:0:0: [sdc] Write Protect is off
> [    1.584969] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [    1.584977] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.585071]  sdc:
> [    1.585123] sd 3:0:0:0: Attached scsi generic sg2 type 0
> [    1.588354]  sdc1 sdc2 sdc3 sdc4<  sdb1 sdb2 sdb3 sdb4<  sda1 sda2 sda3
> sda4<  sdb5 sdc5 sda5 sdc6 sdb6>
> [    1.606850] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.610449]  sda6>
> [    1.610814] sd 0:0:0:0: [sda] Attached SCSI disk
> [    1.617957]  sdc7>
> [    1.618341] sd 3:0:0:0: [sdc] Attached SCSI disk
> [    1.618382] md: Waiting for all devices to be available before autodetect
> [    1.618417] md: If you don't use raid, use raid=noautodetect
> [    1.618533] md: Autodetecting RAID arrays.
> [    1.724723] md: Scanned 12 and added 12 devices.
> [    1.724758] md: autorun ...
> [    1.724792] md: considering sdc6 ...
> [    1.724827] md:  adding sdc6 ...
> [    1.724862] md: sdc5 has different UUID to sdc6
> [    1.724897] md: sdc3 has different UUID to sdc6
> [    1.724931] md: sdc1 has different UUID to sdc6
> [    1.724967] md:  adding sda6 ...
> [    1.725001] md: sda5 has different UUID to sdc6
> [    1.725036] md: sda3 has different UUID to sdc6
> [    1.725070] md: sda1 has different UUID to sdc6
> [    1.725106] md:  adding sdb6 ...
> [    1.725140] md: sdb5 has different UUID to sdc6
> [    1.725175] md: sdb3 has different UUID to sdc6
> [    1.725209] md: sdb1 has different UUID to sdc6
> [    1.725349] md: created md3
> [    1.725382] md: bind<sdb6>
> [    1.725419] md: bind<sda6>
> [    1.725456] md: bind<sdc6>
> [    1.725492] md: running:<sdc6><sda6><sdb6>
> [    1.725626] raid5: device sdc6 operational as raid disk 2
> [    1.725661] raid5: device sda6 operational as raid disk 0
> [    1.725695] raid5: device sdb6 operational as raid disk 1
> [    1.725846] raid5: allocated 3220kB for md3
> [    1.725910] raid5: raid level 5 set md3 active with 3 out of 3 devices,
> algorithm 2
> [    1.725963] RAID5 conf printout:
> [    1.725996]  --- rd:3 wd:3
> [    1.726029]  disk 0, o:1, dev:sda6
> [    1.726062]  disk 1, o:1, dev:sdb6
> [    1.726095]  disk 2, o:1, dev:sdc6
> [    1.726142] md3: detected capacity change from 0 to 864065421312
> [    1.726213] md: considering sdc5 ...
> [    1.726249] md:  adding sdc5 ...
> [    1.726283] md: sdc3 has different UUID to sdc5
> [    1.726318] md: sdc1 has different UUID to sdc5
> [    1.726353] md:  adding sda5 ...
> [    1.726388] md: sda3 has different UUID to sdc5
> [    1.726422] md: sda1 has different UUID to sdc5
> [    1.726458] md:  adding sdb5 ...
> [    1.726492] md: sdb3 has different UUID to sdc5
> [    1.726526] md: sdb1 has different UUID to sdc5
> [    1.726630] md: created md2
> [    1.726663] md: bind<sdb5>
> [    1.726700] md: bind<sda5>
> [    1.726738] md: bind<sdc5>
> [    1.726774] md: running:<sdc5><sda5><sdb5>
> [    1.726901] raid5: device sdc5 operational as raid disk 2
> [    1.726935] raid5: device sda5 operational as raid disk 0
> [    1.726969] raid5: device sdb5 operational as raid disk 1
> [    1.727126] raid5: allocated 3220kB for md2
> [    1.727190] raid5: raid level 5 set md2 active with 3 out of 3 devices,
> algorithm 2
> [    1.727243] RAID5 conf printout:
> [    1.727276]  --- rd:3 wd:3
> [    1.727309]  disk 0, o:1, dev:sda5
> [    1.727342]  disk 1, o:1, dev:sdb5
> [    1.727376]  disk 2, o:1, dev:sdc5
> [    1.727420] md2: detected capacity change from 0 to 40007499776
> [    1.727490] md: considering sdc3 ...
> [    1.727526] md:  adding sdc3 ...
> [    1.727560] md: sdc1 has different UUID to sdc3
> [    1.727595] md:  adding sda3 ...
> [    1.727629] md: sda1 has different UUID to sdc3
> [    1.727664] md:  adding sdb3 ...
> [    1.727698] md: sdb1 has different UUID to sdc3
> [    1.727799] md: created md1
> [    1.727832] md: bind<sdb3>
> [    1.727869] md: bind<sda3>
> [    1.727905] md: bind<sdc3>
> [    1.727945] md: running:<sdc3><sda3><sdb3>
> [    1.728090] raid5: device sdc3 operational as raid disk 2
> [    1.728125] raid5: device sda3 operational as raid disk 0
> [    1.728159] raid5: device sdb3 operational as raid disk 1
> [    1.728320] raid5: allocated 3220kB for md1
> [    1.728370] raid5: raid level 5 set md1 active with 3 out of 3 devices,
> algorithm 2
> [    1.728423] RAID5 conf printout:
> [    1.728455]  --- rd:3 wd:3
> [    1.728488]  disk 0, o:1, dev:sda3
> [    1.728522]  disk 1, o:1, dev:sdb3
> [    1.728555]  disk 2, o:1, dev:sdc3
> [    1.728604] md1: detected capacity change from 0 to 79998877696
> [    1.728674] md: considering sdc1 ...
> [    1.728710] md:  adding sdc1 ...
> [    1.728745] md:  adding sda1 ...
> [    1.728779] md:  adding sdb1 ...
> [    1.728813] md: created md0
> [    1.728846] md: bind<sdb1>
> [    1.728882] md: bind<sda1>
> [    1.728919] md: bind<sdc1>
> [    1.728955] md: running:<sdc1><sda1><sdb1>
> [    1.729133] raid1: raid set md0 active with 3 out of 3 mirrors
> [    1.729176] md0: detected capacity change from 0 to 65667072
> [    1.729232] md: ... autorun DONE.
> [    1.729284] md: Loading md3: /dev/sda3
> [    1.729322]  md3: unknown partition table
> [    1.729481] md: couldn't update array info. -22
> [    1.729518] md: could not bd_claim sda3.
> [    1.729552] md: md_import_device returned -16
> [    1.729588] md: could not bd_claim sdb3.
> [    1.729621] md: md_import_device returned -16
> [    1.729657] md: could not bd_claim sdc3.
> [    1.729690] md: md_import_device returned -16
> [    1.729725] md: starting md3 failed
> [    1.729800]  md1: unknown partition table
> [    1.767199] reiser4: md1: found disk format 4.0.0.
> [    5.790318] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.
> [    5.790370] Freeing unused kernel memory: 376k freed
> [    9.037775] udev: starting version 145
> [    9.217043]  md2:
> [    9.217072]  md0: unknown partition table
> [    9.282015]  unknown partition table
> [   10.420576] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [   10.420591] r8169 0000:01:00.0: PCI INT A ->  GSI 18 (level, low) ->  IRQ 18
> [   10.420840] r8169 0000:01:00.0: setting latency timer to 64
> [   10.420871]   alloc irq_desc for 28 on node -1
> [   10.420872]   alloc kstat_irqs on node -1
> [   10.420882] r8169 0000:01:00.0: irq 28 for MSI/MSI-X
> [   10.420988] eth0: RTL8168c/8111c at 0xffffc90012f18000, 00:19:66:86:ce:12,
> XID 3c4000c0 IRQ 28
> [   10.440462] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   10.440465] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96
> [   10.440491] ehci_hcd 0000:00:12.2: PCI INT B ->  GSI 17 (level, low) ->  IRQ
> 17
> [   10.440518] ehci_hcd 0000:00:12.2: EHCI Host Controller
> [   10.440532] drivers/usb/core/inode.c: creating file 'devices'
> [   10.440534] drivers/usb/core/inode.c: creating file '001'
> [   10.440566] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus
> number 1
> [   10.440572] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2
> pcc=3 ordered !ppc ports=6
> [   10.440575] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes
> 256/512/1024
> [   10.440596] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze
> workaround
> [   10.440602] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8
> period=1024 Reset HALT
> [   10.440615] ehci_hcd 0000:00:12.2: debug port 1
> [   10.440619] ehci_hcd 0000:00:12.2: MWI active
> [   10.440620] ehci_hcd 0000:00:12.2: supports USB remote wakeup
> [   10.440633] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000
> [   10.440637] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8
> period=1024 Reset HALT
> [   10.440642] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1
> period=256 RUN
> [   10.447931] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
> [   10.447961] usb usb1: default language 0x0409
> [   10.447965] usb usb1: udev 1, busnum 1, minor = 0
> [   10.447967] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [   10.447968] usb usb1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [   10.447969] usb usb1: Product: EHCI Host Controller
> [   10.447970] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd
> [   10.447971] usb usb1: SerialNumber: 0000:00:12.2
> [   10.447998] usb usb1: uevent
> [   10.448007] usb usb1: usb_probe_device
> [   10.448009] usb usb1: configuration #1 chosen from 1 choice
> [   10.448014] usb usb1: adding 1-0:1.0 (config #1, interface 0)
> [   10.448021] usb 1-0:1.0: uevent
> [   10.448028] hub 1-0:1.0: usb_probe_interface
> [   10.448029] hub 1-0:1.0: usb_probe_interface - got id
> [   10.448031] hub 1-0:1.0: USB hub found
> [   10.448035] hub 1-0:1.0: 6 ports detected
> [   10.448036] hub 1-0:1.0: standalone hub
> [   10.448037] hub 1-0:1.0: no power switching (usb 1.0)
> [   10.448038] hub 1-0:1.0: individual port over-current protection
> [   10.448039] hub 1-0:1.0: power on to power good time: 20ms
> [   10.448042] hub 1-0:1.0: local power source is good
> [   10.448043] hub 1-0:1.0: trying to enable port power on non-switchable hub
> [   10.448067] drivers/usb/core/inode.c: creating file '001'
> [   10.448085]   alloc irq_desc for 19 on node -1
> [   10.448087]   alloc kstat_irqs on node -1
> [   10.448091] ehci_hcd 0000:00:13.2: PCI INT B ->  GSI 19 (level, low) ->  IRQ
> 19
> [   10.448101] ehci_hcd 0000:00:13.2: EHCI Host Controller
> [   10.448105] drivers/usb/core/inode.c: creating file '002'
> [   10.448122] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus
> number 2
> [   10.448127] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2
> pcc=3 ordered !ppc ports=6
> [   10.448130] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes
> 256/512/1024
> [   10.448143] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze
> workaround
> [   10.448148] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8
> period=1024 Reset HALT
> [   10.448161] ehci_hcd 0000:00:13.2: debug port 1
> [   10.448164] ehci_hcd 0000:00:13.2: MWI active
> [   10.448165] ehci_hcd 0000:00:13.2: supports USB remote wakeup
> [   10.448173] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800
> [   10.448176] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8
> period=1024 Reset HALT
> [   10.448181] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1
> period=256 RUN
> [   10.457930] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
> [   10.457945] usb usb2: default language 0x0409
> [   10.457949] usb usb2: udev 1, busnum 2, minor = 128
> [   10.457950] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [   10.457952] usb usb2: New USB device strings: Mfr=3, Product=2,
> SerialNumber=1
> [   10.457953] usb usb2: Product: EHCI Host Controller
> [   10.457954] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd
> [   10.457955] usb usb2: SerialNumber: 0000:00:13.2
> [   10.457977] usb usb2: uevent
> [   10.457984] usb usb2: usb_probe_device
> [   10.457986] usb usb2: configuration #1 chosen from 1 choice
> [   10.457989] usb usb2: adding 2-0:1.0 (config #1, interface 0)
> [   10.457997] usb 2-0:1.0: uevent
> [   10.458003] hub 2-0:1.0: usb_probe_interface
> [   10.458004] hub 2-0:1.0: usb_probe_interface - got id
> [   10.458005] hub 2-0:1.0: USB hub found
> [   10.458009] hub 2-0:1.0: 6 ports detected
> [   10.458010] hub 2-0:1.0: standalone hub
> [   10.458010] hub 2-0:1.0: no power switching (usb 1.0)
> [   10.458011] hub 2-0:1.0: individual port over-current protection
> [   10.458013] hub 2-0:1.0: power on to power good time: 20ms
> [   10.458015] hub 2-0:1.0: local power source is good
> [   10.458016] hub 2-0:1.0: trying to enable port power on non-switchable hub
> [   10.458038] drivers/usb/core/inode.c: creating file '001'
> [   10.474718] Linux video capture interface: v2.00
> [   10.489875] bttv: driver version 0.9.18 loaded
> [   10.489877] bttv: using 8 buffers with 2080k (520 pages) each for capture
> [   10.489914] bttv: Bt8xx card found (0).
> [   10.489923]   alloc irq_desc for 21 on node -1
> [   10.489924]   alloc kstat_irqs on node -1
> [   10.489928] bttv 0000:05:06.0: PCI INT A ->  GSI 21 (level, low) ->  IRQ 21
> [   10.489938] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128,
> mmio: 0xfcfff000
> [   10.489971] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra
> TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
> [   10.489974] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
> [   10.490007] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
> [   10.547936] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER
> sig=j CSC CONNECT
> [   10.547939] hub 1-0:1.0: port 2: status 0501 change 0001
> [   10.557954] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
> [   10.647931] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000
> [   10.647940] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
> [   10.700045] ehci_hcd 0000:00:12.2: port 2 high speed
> [   10.700049] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [   10.757104] usb 1-2: new high speed USB device using ehci_hcd and address 2
> [   10.810036] ehci_hcd 0000:00:12.2: port 2 high speed
> [   10.810039] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER
> sig=se0 PE CONNECT
> [   10.881474] usb 1-2: default language 0x0409
> [   10.881724] usb 1-2: udev 2, busnum 1, minor = 1
> [   10.881725] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608
> [   10.881726] usb 1-2: New USB device strings: Mfr=0, Product=1,
> SerialNumber=0
> [   10.881728] usb 1-2: Product: USB2.0 Hub
> [   10.881764] usb 1-2: uevent
> [   10.881773] usb 1-2: usb_probe_device
> [   10.881775] usb 1-2: configuration #1 chosen from 1 choice
> [   10.882188] usb 1-2: adding 1-2:1.0 (config #1, interface 0)
> [   10.882199] usb 1-2:1.0: uevent
> [   10.882206] hub 1-2:1.0: usb_probe_interface
> [   10.882207] hub 1-2:1.0: usb_probe_interface - got id
> [   10.882209] hub 1-2:1.0: USB hub found
> [   10.882473] hub 1-2:1.0: 4 ports detected
> [   10.882474] hub 1-2:1.0: standalone hub
> [   10.882476] hub 1-2:1.0: individual port power switching
> [   10.882477] hub 1-2:1.0: individual port over-current protection
> [   10.882478] hub 1-2:1.0: Single TT
> [   10.882479] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)
> [   10.882480] hub 1-2:1.0: Port indicators are supported
> [   10.882481] hub 1-2:1.0: power on to power good time: 100ms
> [   10.882848] hub 1-2:1.0: local power source is good
> [   10.882849] hub 1-2:1.0: enabling power on all ports
> [   10.883860] drivers/usb/core/inode.c: creating file '002'
> [   10.983961] hub 1-2:1.0: port 2: status 0301 change 0001
> [   11.083356] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]
> [   11.083364] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000
> [   11.083700] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s
> [   11.152198] usb 1-2.2: new low speed USB device using ehci_hcd and address
> 3
> [   11.241187] usb 1-2.2: skipped 1 descriptor after interface
> [   11.241189] usb 1-2.2: skipped 1 descriptor after interface
> [   11.241685] usb 1-2.2: default language 0x0409
> [   11.243941] usb 1-2.2: udev 3, busnum 1, minor = 2
> [   11.243943] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518
> [   11.243944] usb 1-2.2: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [   11.243945] usb 1-2.2: Product: USB Receiver
> [   11.243947] usb 1-2.2: Manufacturer: Logitech
> [   11.243972] usb 1-2.2: uevent
> [   11.243980] usb 1-2.2: usb_probe_device
> [   11.243981] usb 1-2.2: configuration #1 chosen from 1 choice
> [   11.251309] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)
> [   11.251324] usb 1-2.2:1.0: uevent
> [   11.251334] usbhid 1-2.2:1.0: usb_probe_interface
> [   11.251335] usbhid 1-2.2:1.0: usb_probe_interface - got id
> [   11.251796] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
> [   11.254692] input: Logitech USB Receiver as
> /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3
> [   11.254732] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11
> Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
> [   11.254740] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)
> [   11.254749] usb 1-2.2:1.1: uevent
> [   11.254755] usbhid 1-2.2:1.1: usb_probe_interface
> [   11.254757] usbhid 1-2.2:1.1: usb_probe_interface - got id
> [   11.255046] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42
> [   11.260359] input: Logitech USB Receiver as
> /devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4
> [   11.260368] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
> [   11.260384] drivers/usb/core/file.c: looking for a minor, starting at 96
> [   11.260414] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB
> HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
> [   11.260427] drivers/usb/core/inode.c: creating file '003'
> [   11.260438] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004
> [   11.280770] usb 1-2.2:1.0: uevent
> [   11.280827] usb 1-2.2: uevent
> [   11.280844] usb 1-2.2:1.0: uevent
> [   11.280903] usb 1-2.2: uevent
> [   11.281405] usb 1-2.2:1.1: uevent
> [   11.281467] usb 1-2.2: uevent
> [   11.281517] usb 1-2.2:1.0: uevent
> [   11.281529] usb 1-2.2:1.0: uevent
> [   11.282164] usb 1-2.2:1.1: uevent
> [   11.493831] bttv0: tea5757: read timeout
> [   11.493832] bttv0: tuner type=5
> [   11.505445] bttv0: audio absent, no audio device found!
> [   11.525030] TUNER: Unable to find symbol tea5767_autodetection()
> [   11.525033] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])
> [   11.527843] tuner-simple 0-0060: creating new instance
> [   11.527846] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and
> compatibles))
> [   11.528664] bttv0: registered device video0
> [   11.528695] bttv0: registered device vbi0
> [   11.814508] reiser4: md2: found disk format 4.0.0.
> [   13.337101] hub 2-0:1.0: hub_suspend
> [   13.337107] usb usb2: bus auto-suspend
> [   13.337109] ehci_hcd 0000:00:13.2: suspend root hub
> [   13.591267] reiser4: md3: found disk format 4.0.0.
> [   55.020583] reiser4: sdc7: found disk format 4.0.0.
> [   67.386552] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1
> across:7815612k
> [   67.408915] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1
> across:7815612k
> [   67.501498] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1
> across:7815612k
> [   68.205087] w83627ehf: Found W83627EHG chip at 0x290
> [   68.421646] r8169: eth0: link up
> [   68.421650] r8169: eth0: link up
> [   70.281241] usb usb1: uevent
> [   70.281269] usb 1-0:1.0: uevent
> [   70.281293] usb 1-2: uevent
> [   70.281320] usb 1-2.2: uevent
> [   70.281346] usb 1-2.2:1.0: uevent
> [   70.281533] usb 1-2.2:1.1: uevent
> [   70.281706] usb 1-2:1.0: uevent
> [   70.281804] usb usb2: uevent
> [   70.281830] usb 2-0:1.0: uevent
> [   71.272886]   alloc irq_desc for 23 on node -1
> [   71.272889]   alloc kstat_irqs on node -1
> [   71.272895] EMU10K1_Audigy 0000:05:08.0: PCI INT A ->  GSI 23 (level, low) -
>> IRQ 23
> [   71.278891] Audigy2 value: Special config.
> [   72.473408] fglrx: module license 'Proprietary. (C) 2002 - ATI
> Technologies, Starnberg, GERMANY' taints kernel.
> [   72.473417] Disabling lock debugging due to kernel taint
> [   72.490481] [fglrx] Maximum main memory to use for locked dma buffers: 7760
> MBytes.
> [   72.490559] [fglrx]   vendor: 1002 device: 9501 count: 1
> [   72.490739] [fglrx] ioport: bar 4, base 0xc000, size: 0x100
> [   72.490750] pci 0000:02:00.0: PCI INT A ->  GSI 18 (level, low) ->  IRQ 18
> [   72.490754] pci 0000:02:00.0: setting latency timer to 64
> [   72.490884] [fglrx] Kernel PAT support is enabled
> [   72.490901] [fglrx] module loaded - fglrx 8.66.2 [Sep  1 2009] with 1
> minors
> [   72.668413]   alloc irq_desc for 29 on node -1
> [   72.668416]   alloc kstat_irqs on node -1
> [   72.668424] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X
> [   72.668759] [fglrx] Firegl kernel thread PID: 3800
> [   74.787429] [fglrx] Gart USWC size:1279 M.
> [   74.787431] [fglrx] Gart cacheable size:508 M.
> [   74.787435] [fglrx] Reserved FB block: Shared offset:0, size:1000000
> [   74.787437] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000
> [   74.787438] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000
> [   75.947153] usb 1-2.2: link qh8-0601/ffff8800c78003c0 start 3 [1/2 us]
> [  616.849440] reiser4[ktxnmgrd:md1:ru(581)]: disable_write_barrier
> (fs/reiser4/wander.c:235)[zam-1055]:
> [  616.849445] NOTICE: md1 does not support write barriers, using synchronous
> write instead.
> [  671.813536] reiser4[ktxnmgrd:md2:ru(2774)]: disable_write_barrier
> (fs/reiser4/wander.c:235)[zam-1055]:
> [  671.813541] NOTICE: md2 does not support write barriers, using synchronous
> write instead.
> [  703.842289] reiser4[ktxnmgrd:md3:ru(2776)]: disable_write_barrier
> (fs/reiser4/wander.c:235)[zam-1055]:
> [  703.842293] NOTICE: md3 does not support write barriers, using synchronous
> write instead.
>
> ps. I have to disable c1e in bios, or video is very jerky - unless something
> cpu heavy runs on at least one core...
>
>
>

