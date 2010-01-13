Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428Ab0AMSEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0AMSEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 13:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917Ab0AMSEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 13:04:46 -0500
Received: from twilight.fidra.de ([88.198.14.164]:38541 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0AMSEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 13:04:44 -0500
From: Volker Lanz <vl@fidra.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Wed, 13 Jan 2010 19:04:39 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31-17-generic; KDE/4.3.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
References: <200912071856.48125.vl@fidra.de> <200912210955.00086.vl@fidra.de> <86802c441001122335gda44dd2v93c613609dac7584@mail.gmail.com>
In-Reply-To: <86802c441001122335gda44dd2v93c613609dac7584@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001131904.39254.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 January 2010 08:35:39 Yinghai Lu wrote:
> On Mon, Dec 21, 2009 at 12:54 AM, Volker Lanz <vl@fidra.de> wrote:
> > Any news on this problem? Anything else I can do to help debug the
> > situation? The prospect of being confined to distros with kernels <
> > 2.6.29 for the next couple of years on this machine worries me,
> > obviously.
> 
> as 6d794 said that is used fix exposed bug.

I beg your pardon?

> please checkout out
> 
> c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481
> 
> and boot with debug.

This is the boot log:

-----------------------------------------------------------------------------

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc7 (vl@trevor) (gcc version 4.4.1 (Ubuntu 
4.4.1-4ubuntu8) ) #2 SMP Wed Jan 13 18:04:42 CET 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.29-rc7 
root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro debug nosplash
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x1b0000 max_arch_pfn = 0x100000000
[    0.000000] e820 update range: 00000000cff00000 - 0000000100000000 (usable) 
==> (reserved)
[    0.000000] last_pfn = 0xcfee0 max_arch_pfn = 0x100000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usable) 
==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  modified: 00000000cfee0000 - 00000000cfee2000 (ACPI NVS)
[    0.000000]  modified: 00000000cfee2000 - 00000000cfef0000 (ACPI data)
[    0.000000]  modified: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 00000001b0000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000cfee0000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cfee0000 page 4k
[    0.000000] kernel direct mapping tables up to cfee0000 @ 8000-e000
[    0.000000] init_memory_mapping: 0000000100000000-00000001b0000000
[    0.000000]  0100000000 - 01b0000000 page 2M
[    0.000000] kernel direct mapping tables up to 1b0000000 @ c000-14000
[    0.000000] RAMDISK: 34bb5000 - 37fefa73
[    0.000000] ACPI: RSDP 000F7280, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT CFEE2040, 004C (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] ACPI: FACP CFEE20C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN 
(4)
[    0.000000] ACPI: DSDT CFEE2180, 4CD9 (r1 GBT    GBTUACPI     1000 MSFT  
100000C)
[    0.000000] ACPI: FACS CFEE0000, 0040
[    0.000000] ACPI: EUDS CFEE7580, 0500 (r1 GBT                    0             
0)
[    0.000000] ACPI: HPET CFEE74C0, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       
98)
[    0.000000] ACPI: MCFG CFEE7540, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] ACPI: APIC CFEE6EC0, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  
1010101)
[    0.000000] ACPI: SSDT CFEE83B0, 018A (r1  PmRef  Cpu0Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE8540, 018A (r1  PmRef  Cpu1Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE86D0, 018A (r1  PmRef  Cpu2Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE8860, 018A (r1  PmRef  Cpu3Cst     3001 INTL 
20040311)
[    0.000000] ACPI: SSDT CFEE89F0, 03AB (r1  PmRef    CpuPm     3000 INTL 
20040311)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 01b0000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0000200000 - 0000adaff8]    TEXT DATA BSS ==> [0000200000 
- 0000adaff8]
[    0.000000]   #3 [0034bb5000 - 0037fefa73]          RAMDISK ==> [0034bb5000 
- 0037fefa73]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 
- 0000100000]
[    0.000000]   #5 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 
- 000000c000]
[    0.000000]   #6 [000000c000 - 000000f000]          PGTABLE ==> [000000c000 
- 000000f000]
[    0.000000] found SMP MP-table at [ffff8800000f5890] f5890
[    0.000000]  [ffffe20000000000-ffffe20005ffffff] PMD -> [ffff880028200000-
ffff88002e1fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001b0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cfee0
[    0.000000]     0: 0x00100000 -> 0x001b0000
[    0.000000] On node 0 totalpages: 1572474
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2372 pages reserved
[    0.000000]   DMA zone: 1566 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 9856 pages used for memmap
[    0.000000]   Normal zone: 711040 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfee0000 - 
00000000cfee2000
[    0.000000] PM: Registered nosave memory: 00000000cfee2000 - 
00000000cfef0000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 
00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at e6000000 (gap: 
e4000000:1ac00000)
[    0.000000] NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages at ffff880028034000, static data 88992 
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1545910
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.29-rc7 
root=UUID=160351ee-c9b0-4a72-9fd5-9962c8137a7e ro debug nosplash
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] NR_IRQS:2304
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2832.938 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)
[    0.004000] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)
[    0.004000] allocated 70778880 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing 64MB software IO TLB between ffff880020000000 - 
ffff880024000000
[    0.004000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.004000] Memory: 5979968k/7077888k available (4647k kernel code, 787992k 
absent, 308996k reserved, 2463k data, 528k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5665.87 BogoMIPS (lpj=11331752)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20081204
[    0.010847] Setting APIC routing to flat
[    0.011237] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.050963] CPU0: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.052001] Booting processor 1 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5665.98 
BogoMIPS (lpj=11331961)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.136751] CPU1: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.137725] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.140120] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 5665.98 
BogoMIPS (lpj=11331978)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.232761] CPU2: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.233137] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.236111] Booting processor 3 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 5665.95 
BogoMIPS (lpj=11331915)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.328759] CPU3: Intel(R) Core(TM)2 Quad CPU    Q9550  @ 2.83GHz stepping 
0a
[    0.329145] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.332071] Brought up 4 CPUs
[    0.332110] Total of 4 processors activated (22663.80 BogoMIPS).
[    0.332190] CPU0 attaching sched-domain:
[    0.332229]  domain 0: span 0,3 level MC
[    0.332294]   groups: 0 3
[    0.332411]   domain 1: span 0-3 level CPU
[    0.332486]    groups: 0,3 1-2
[    0.332604] CPU1 attaching sched-domain:
[    0.332642]  domain 0: span 1-2 level MC
[    0.332707]   groups: 1 2
[    0.332823]   domain 1: span 0-3 level CPU
[    0.332888]    groups: 1-2 0,3
[    0.333006] CPU2 attaching sched-domain:
[    0.333044]  domain 0: span 1-2 level MC
[    0.333108]   groups: 2 1
[    0.333225]   domain 1: span 0-3 level CPU
[    0.333290]    groups: 1-2 0,3
[    0.333408] CPU3 attaching sched-domain:
[    0.333446]  domain 0: span 0,3 level MC
[    0.333510]   groups: 3 0
[    0.333627]   domain 1: span 0-3 level CPU
[    0.333691]    groups: 0,3 1-2
[    0.333904] net_namespace: 1840 bytes
[    0.333904] Booting paravirtualized kernel on bare hardware
[    0.333904] regulator: core version 0.5
[    0.333904] Time: 18:45:28  Date: 01/13/10
[    0.333904] NET: Registered protocol family 16
[    0.336014] ACPI: bus type pci registered
[    0.336100] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.336141] PCI: MCFG area at e0000000 reserved in E820
[    0.337508] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.337547] PCI: Using configuration type 1 for base access
[    0.338043] bio: create slab <bio-0> at 0
[    0.338093] ACPI: EC: Look up EC in DSDT
[    0.343850] ACPI: Interpreter enabled
[    0.343892] ACPI: (supports S0 S3 S4 S5)
[    0.344039] ACPI: Using IOAPIC for interrupt routing
[    0.347473] ACPI: No dock devices found.
[    0.347520] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.347625] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.347666] pci 0000:00:01.0: PME# disabled
[    0.347755] pci 0000:00:1a.0: reg 20 io port: [0xe100-0xe11f]
[    0.347847] pci 0000:00:1a.1: reg 20 io port: [0xe200-0xe21f]
[    0.347939] pci 0000:00:1a.2: reg 20 io port: [0xe000-0xe01f]
[    0.348048] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe9305000-0xe93053ff]
[    0.348150] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe9300000-0xe9303fff]
[    0.348221] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.348262] pci 0000:00:1b.0: PME# disabled
[    0.348342] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.348383] pci 0000:00:1c.0: PME# disabled
[    0.348464] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.348505] pci 0000:00:1c.3: PME# disabled
[    0.348586] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.348627] pci 0000:00:1c.4: PME# disabled
[    0.348705] pci 0000:00:1d.0: reg 20 io port: [0xe300-0xe31f]
[    0.348797] pci 0000:00:1d.1: reg 20 io port: [0xe400-0xe41f]
[    0.348888] pci 0000:00:1d.2: reg 20 io port: [0xe500-0xe51f]
[    0.348982] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe9304000-0xe93043ff]
[    0.349183] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.349225] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.349266] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.349308] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.349350] pci 0000:00:1f.2: reg 20 io port: [0xf000-0xf00f]
[    0.349392] pci 0000:00:1f.2: reg 24 io port: [0xf100-0xf10f]
[    0.349465] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe9306000-0xe93060ff]
[    0.349514] pci 0000:00:1f.3: reg 20 io port: [0x500-0x51f]
[    0.349594] pci 0000:00:1f.5: reg 10 io port: [0xe700-0xe707]
[    0.349637] pci 0000:00:1f.5: reg 14 io port: [0xe800-0xe803]
[    0.349679] pci 0000:00:1f.5: reg 18 io port: [0xe900-0xe907]
[    0.349721] pci 0000:00:1f.5: reg 1c io port: [0xea00-0xea03]
[    0.349763] pci 0000:00:1f.5: reg 20 io port: [0xeb00-0xeb0f]
[    0.349805] pci 0000:00:1f.5: reg 24 io port: [0xec00-0xec0f]
[    0.349886] pci 0000:01:00.0: reg 10 32bit mmio: [0xe6000000-0xe6ffffff]
[    0.349932] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.349977] pci 0000:01:00.0: reg 1c 64bit mmio: [0xe4000000-0xe5ffffff]
[    0.350020] pci 0000:01:00.0: reg 24 io port: [0xb000-0xb07f]
[    0.350063] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.350146] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.350186] pci 0000:00:01.0: bridge 32bit mmio: [0xe4000000-0xe7ffffff]
[    0.350228] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.350375] pci 0000:03:00.0: reg 24 32bit mmio: [0xe9000000-0xe9001fff]
[    0.350448] pci 0000:03:00.0: PME# supported from D3hot
[    0.350490] pci 0000:03:00.0: PME# disabled
[    0.350572] pci 0000:03:00.1: reg 10 io port: [0xc000-0xc007]
[    0.350617] pci 0000:03:00.1: reg 14 io port: [0xc100-0xc103]
[    0.350663] pci 0000:03:00.1: reg 18 io port: [0xc200-0xc207]
[    0.350708] pci 0000:03:00.1: reg 1c io port: [0xc300-0xc303]
[    0.350754] pci 0000:03:00.1: reg 20 io port: [0xc400-0xc40f]
[    0.350866] pci 0000:00:1c.3: bridge io port: [0xc000-0xcfff]
[    0.350907] pci 0000:00:1c.3: bridge 32bit mmio: [0xe9000000-0xe90fffff]
[    0.350986] pci 0000:04:00.0: reg 10 io port: [0xd000-0xd0ff]
[    0.351041] pci 0000:04:00.0: reg 18 64bit mmio: [0xe9110000-0xe9110fff]
[    0.351092] pci 0000:04:00.0: reg 20 64bit mmio: [0xe9100000-0xe910ffff]
[    0.351137] pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
[    0.351209] pci 0000:04:00.0: supports D1 D2
[    0.351248] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.351290] pci 0000:04:00.0: PME# disabled
[    0.351368] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.351409] pci 0000:00:1c.4: bridge 32bit mmio: [0xe8000000-0xe8ffffff]
[    0.351452] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xe9100000-0xe91fffff]
[    0.351526] pci 0000:05:07.0: reg 10 32bit mmio: [0xe9204000-0xe92047ff]
[    0.351570] pci 0000:05:07.0: reg 14 32bit mmio: [0xe9200000-0xe9203fff]
[    0.351645] pci 0000:05:07.0: supports D1 D2
[    0.351683] pci 0000:05:07.0: PME# supported from D0 D1 D2 D3hot
[    0.351725] pci 0000:05:07.0: PME# disabled
[    0.351790] pci 0000:00:1e.0: transparent bridge
[    0.351832] pci 0000:00:1e.0: bridge 32bit mmio: [0xe9200000-0xe92fffff]
[    0.351889] pci_bus 0000:00: on NUMA node 0
[    0.351930] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.352084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.352164] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.352245] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.352322] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.365232] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 
15)
[    0.365714] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.366240] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 14 
15)
[    0.366712] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 
15)
[    0.367182] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 
15) *0, disabled.
[    0.367708] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 *4 5 6 7 9 10 11 12 14 
15)
[    0.368174] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 
15)
[    0.368644] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 12 14 
15)
[    0.369307] SCSI subsystem initialized
[    0.369307] libata version 3.00 loaded.
[    0.369307] usbcore: registered new interface driver usbfs
[    0.369307] usbcore: registered new interface driver hub
[    0.369307] usbcore: registered new device driver usb
[    0.369307] ACPI: WMI: Mapper loaded
[    0.369307] PCI: Using ACPI for IRQ routing
[    0.384007] Bluetooth: Core ver 2.14
[    0.384059] NET: Registered protocol family 31
[    0.384066] Bluetooth: HCI device and connection manager initialized
[    0.384106] Bluetooth: HCI socket layer initialized
[    0.384145] NET: Registered protocol family 8
[    0.384183] NET: Registered protocol family 20
[    0.384228] NetLabel: Initializing
[    0.384266] NetLabel:  domain hash size = 128
[    0.384304] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.384350] NetLabel:  unlabeled traffic allowed by default
[    0.384421] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.384594] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.403989] pnp: PnP ACPI init
[    0.404636] ACPI: bus type pnp registered
[    0.406417] pnp: PnP ACPI: found 12 devices
[    0.406456] ACPI: ACPI bus type pnp unregistered
[    0.406499] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.406539] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.406580] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.406620] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.406660] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.406700] system 00:01: ioport range 0x4c0-0x4ff could not be reserved
[    0.406744] system 00:08: ioport range 0x400-0x4bf has been reserved
[    0.406788] system 00:09: iomem range 0xe0000000-0xe3ffffff has been reserved
[    0.406831] system 00:0a: iomem range 0xccc00-0xcffff has been reserved
[    0.406871] system 00:0a: iomem range 0xf0000-0xf7fff could not be reserved
[    0.406912] system 00:0a: iomem range 0xf8000-0xfbfff could not be reserved
[    0.406953] system 00:0a: iomem range 0xfc000-0xfffff could not be reserved
[    0.406994] system 00:0a: iomem range 0xcfee0000-0xcfefffff could not be 
reserved
[    0.407042] system 00:0a: iomem range 0x0-0x9ffff could not be reserved
[    0.407083] system 00:0a: iomem range 0x100000-0xcfedffff could not be 
reserved
[    0.407131] system 00:0a: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.407172] system 00:0a: iomem range 0xfed10000-0xfed1dfff has been 
reserved
[    0.407213] system 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.407254] system 00:0a: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.407295] system 00:0a: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.407336] system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
[    0.407377] system 00:0a: iomem range 0xe0000-0xeffff has been reserved
[    0.412003] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.412043] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.412084] pci 0000:00:01.0:   MEM window: 0xe4000000-0xe7ffffff
[    0.412125] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.412174] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.412214] pci 0000:00:1c.0:   IO window: disabled
[    0.412254] pci 0000:00:1c.0:   MEM window: disabled
[    0.412294] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.412337] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:03
[    0.412377] pci 0000:00:1c.3:   IO window: 0xc000-0xcfff
[    0.412418] pci 0000:00:1c.3:   MEM window: 0xe9000000-0xe90fffff
[    0.412459] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.412501] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.412541] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.412583] pci 0000:00:1c.4:   MEM window: 0xe8000000-0xe8ffffff
[    0.412624] pci 0000:00:1c.4:   PREFETCH window: 
0x000000e9100000-0x000000e91fffff
[    0.412675] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.412714] pci 0000:00:1e.0:   IO window: disabled
[    0.412755] pci 0000:00:1e.0:   MEM window: 0xe9200000-0xe92fffff
[    0.412796] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.412848] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.412894] pci 0000:00:01.0: setting latency timer to 64
[    0.412937] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.412978] pci 0000:00:1c.0: setting latency timer to 64
[    0.413022] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.413063] pci 0000:00:1c.3: setting latency timer to 64
[    0.413106] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.413147] pci 0000:00:1c.4: setting latency timer to 64
[    0.413190] pci 0000:00:1e.0: setting latency timer to 64
[    0.413230] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.413269] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.413310] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.413349] pci_bus 0000:01: resource 1 mem: [0xe4000000-0xe7ffffff]
[    0.413389] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
[    0.413429] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.413478] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.413517] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.413556] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.413595] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.413634] pci_bus 0000:03: resource 0 io:  [0xc000-0xcfff]
[    0.413673] pci_bus 0000:03: resource 1 mem: [0xe9000000-0xe90fffff]
[    0.413713] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.413752] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.413791] pci_bus 0000:04: resource 0 io:  [0xd000-0xdfff]
[    0.413830] pci_bus 0000:04: resource 1 mem: [0xe8000000-0xe8ffffff]
[    0.413870] pci_bus 0000:04: resource 2 mem: [0xe9100000-0xe91fffff]
[    0.413910] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.413949] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
[    0.413988] pci_bus 0000:05: resource 1 mem: [0xe9200000-0xe92fffff]
[    0.414028] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    0.414067] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.414106] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.414163] NET: Registered protocol family 2
[    0.447952] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.448363] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[    0.449442] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.449914] TCP: Hash tables configured (established 262144 bind 65536)
[    0.449955] TCP reno registered
[    0.459959] NET: Registered protocol family 1
[    0.460064] checking if image is initramfs...<7>Switched to high resolution 
mode on CPU 2
[    0.501151] Switched to high resolution mode on CPU 3
[    0.501236] Switched to high resolution mode on CPU 1
[    0.503873] Switched to high resolution mode on CPU 0
[    1.254494]  it is
[    2.152422] Freeing initrd memory: 53482k freed
[    2.177807] Scanning for low memory corruption every 60 seconds
[    2.177954] audit: initializing netlink socket (disabled)
[    2.178006] type=2000 audit(1263408330.176:1): initialized
[    2.184415] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.185395] VFS: Disk quotas dquot_6.5.2
[    2.185470] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.185895] fuse init (API version 7.11)
[    2.185981] msgmni has been set to 11785
[    2.186190] alg: No test for stdrng (krng)
[    2.186234] io scheduler noop registered
[    2.186274] io scheduler anticipatory registered
[    2.186312] io scheduler deadline registered
[    2.186372] io scheduler cfq registered (default)
[    2.186541] pci 0000:01:00.0: Boot video device
[    2.186639] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    2.186712] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    2.186791] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.186870] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    2.186965] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    2.187042] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    2.187140] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    2.187218] pcieport-driver 0000:00:1c.4: irq 27 for MSI/MSI-X
[    2.187319] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.187833] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.187975] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.188034] ACPI: Power Button (FF) [PWRF]
[    2.188099] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.188149] ACPI: Power Button (CM) [PWRB]
[    2.188552] ACPI: SSDT CFEE7AD0, 022A (r1  PmRef  Cpu0Ist     3000 INTL 
20040311)
[    2.188834] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    2.189006] processor ACPI_CPU:00: registered as cooling_device0
[    2.189052] ACPI: Processor [CPU0] (supports 8 throttling states)
[    2.189310] ACPI: SSDT CFEE7F90, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 
20040311)
[    2.189658] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU1._PDC] (Node ffff8801af815ec0), AE_ALREADY_EXISTS
[    2.189793] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    2.190045] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    2.190211] processor ACPI_CPU:01: registered as cooling_device1
[    2.190253] ACPI: Processor [CPU1] (supports 8 throttling states)
[    2.190535] ACPI: SSDT CFEE80F0, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 
20040311)
[    2.190869] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU2._PDC] (Node ffff8801af815f40), AE_ALREADY_EXISTS
[    2.191004] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    2.191211] ACPI: CPU2 (power states: C1[C1] C2[C2] C3[C3])
[    2.191369] processor ACPI_CPU:02: registered as cooling_device2
[    2.191409] ACPI: Processor [CPU2] (supports 8 throttling states)
[    2.191657] ACPI: SSDT CFEE8250, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 
20040311)
[    2.192010] ACPI Error (psparse-0537): Method parse/execution failed 
[\_PR_.CPU3._PDC] (Node ffff8801af815fc0), AE_ALREADY_EXISTS
[    2.192149] ACPI: Marking method _PDC as Serialized because of 
AE_ALREADY_EXISTS error
[    2.192377] ACPI: CPU3 (power states: C1[C1] C2[C2] C3[C3])
[    2.192545] processor ACPI_CPU:03: registered as cooling_device3
[    2.192587] ACPI: Processor [CPU3] (supports 8 throttling states)
[    2.194202] XENFS: not registering filesystem on non-xen platform
[    2.221656] Linux agpgart interface v0.103
[    2.221699] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.222377] brd: module loaded
[    2.222617] loop: module loaded
[    2.222696] Fixed MDIO Bus: probed
[    2.222736] PPP generic driver version 2.4.2
[    2.222806] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    2.222870] Driver 'sd' needs updating - please use bus_type methods
[    2.222915] Driver 'sr' needs updating - please use bus_type methods
[    2.222982] ahci 0000:03:00.0: version 3.0
[    2.223031] ahci 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.237531] ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 
impl SATA mode
[    2.237583] ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.237628] ahci 0000:03:00.0: setting latency timer to 64
[    2.237827] scsi0 : ahci
[    2.237945] scsi1 : ahci
[    2.238040] ata1: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000100 
irq 19
[    2.238689] ata2: SATA max UDMA/133 abar m8192@0xe9000000 port 0xe9000180 
irq 19
[    2.556022] ata1: SATA link down (SStatus 0 SControl 300)
[    2.892021] ata2: SATA link down (SStatus 0 SControl 300)
[    2.908044] ata_piix 0000:00:1f.2: version 2.12
[    2.908090] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    2.908149] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    2.908349] ata_piix 0000:00:1f.2: setting latency timer to 64
[    2.908457] scsi2 : ata_piix
[    2.908565] scsi3 : ata_piix
[    2.909155] ata3: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    2.909198] ata4: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    3.704052] ata3.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.704108] ata3.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.746202] ata3.00: HPA detected: current 1953523055, native 1953525168
[    3.746246] ata3.00: ATA-8: ST31000528AS, CC34, max UDMA/133
[    3.746287] ata3.00: 1953523055 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.746496] ata3.01: ATA-7: ST3300831AS, 3.02, max UDMA/133
[    3.746537] ata3.01: 586072368 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.802227] ata3.00: configured for UDMA/133
[    3.808305] ata3.01: configured for UDMA/133
[    3.808433] scsi 2:0:0:0: Direct-Access     ATA      ST31000528AS     CC34 
PQ: 0 ANSI: 5
[    3.808539] sd 2:0:0:0: [sda] 1953523055 512-byte hardware sectors: (1.00 
TB/931 GiB)
[    3.808597] sd 2:0:0:0: [sda] Write Protect is off
[    3.808636] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.808690] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.808777] sd 2:0:0:0: [sda] 1953523055 512-byte hardware sectors: (1.00 
TB/931 GiB)
[    3.808834] sd 2:0:0:0: [sda] Write Protect is off
[    3.808873] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.808927] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.808978]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
[    3.889484] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.889550] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    3.889630] scsi 2:0:1:0: Direct-Access     ATA      ST3300831AS      3.02 
PQ: 0 ANSI: 5
[    3.889727] sd 2:0:1:0: [sdb] 586072368 512-byte hardware sectors: (300 
GB/279 GiB)
[    3.889784] sd 2:0:1:0: [sdb] Write Protect is off
[    3.889823] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.889876] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.889956] sd 2:0:1:0: [sdb] 586072368 512-byte hardware sectors: (300 
GB/279 GiB)
[    3.890013] sd 2:0:1:0: [sdb] Write Protect is off
[    3.890052] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.890105] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.890156]  sdb: sdb1
[    3.907773] sd 2:0:1:0: [sdb] Attached SCSI disk
[    3.907838] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    4.700051] ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.700108] ata4.01: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    4.716278] ata4.00: ATA-8: SAMSUNG HD501LJ, CR100-11, max UDMA7
[    4.716320] ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    4.716382] ata4.01: ATAPI: HL-DT-STDVD-RAM GH22NS30, 1.01, max UDMA/100
[    4.724295] ata4.00: configured for UDMA/133
[    4.740187] ata4.01: configured for UDMA/100
[    4.740562] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 
PQ: 0 ANSI: 5
[    4.740669] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 
GB/465 GiB)
[    4.740725] sd 3:0:0:0: [sdc] Write Protect is off
[    4.740764] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.740817] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.740896] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 
GB/465 GiB)
[    4.740952] sd 3:0:0:0: [sdc] Write Protect is off
[    4.740991] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.741044] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    4.741096]  sdc: sdc2 < sdc5 sdc6 sdc7 > sdc3
[    4.808997] sd 3:0:0:0: [sdc] Attached SCSI disk
[    4.809058] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    4.810235] scsi 3:0:1:0: CD-ROM            HL-DT-ST DVD-RAM GH22NS30 1.01 
PQ: 0 ANSI: 5
[    4.813825] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 
cdda tray
[    4.813877] Uniform CD-ROM driver Revision: 3.20
[    4.814008] sr 3:0:1:0: Attached scsi CD-ROM sr0
[    4.814079] sr 3:0:1:0: Attached scsi generic sg3 type 5
[    4.814139] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    4.814182] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    4.814379] ata_piix 0000:00:1f.5: setting latency timer to 64
[    4.814503] scsi4 : ata_piix
[    4.814626] scsi5 : ata_piix
[    4.815041] ata5: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 
19
[    4.815083] ata6: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 
19
[    5.142563] ata5: SATA link down (SStatus 0 SControl 300)
[    5.470557] ata6: SATA link down (SStatus 0 SControl 300)
[    5.470817] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    5.470860] pata_jmicron 0000:03:00.1: PCI INT B -> GSI 16 (level, low) -> 
IRQ 16
[    5.470925] pata_jmicron 0000:03:00.1: setting latency timer to 64
[    5.471033] scsi6 : pata_jmicron
[    5.471142] scsi7 : pata_jmicron
[    5.471639] ata7: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 
16
[    5.471681] ata8: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 
16
[    5.791532] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.791584] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.791631] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.791672] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.791745] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 1
[    5.795697] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    5.795745] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe9305000
[    5.808007] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.808100] usb usb1: configuration #1 chosen from 1 choice
[    5.808163] hub 1-0:1.0: USB hub found
[    5.808204] hub 1-0:1.0: 6 ports detected
[    5.808303] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.808348] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.808389] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.808451] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 2
[    5.812391] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.812438] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe9304000
[    5.824007] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.824095] usb usb2: configuration #1 chosen from 1 choice
[    5.824154] hub 2-0:1.0: USB hub found
[    5.824194] hub 2-0:1.0: 6 ports detected
[    5.824285] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.824333] uhci_hcd: USB Universal Host Controller Interface driver
[    5.824413] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    5.824457] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.824497] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.824562] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 3
[    5.824627] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
[    5.824714] usb usb3: configuration #1 chosen from 1 choice
[    5.824767] hub 3-0:1.0: USB hub found
[    5.824807] hub 3-0:1.0: 2 ports detected
[    5.824892] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    5.824935] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.824975] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.825050] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 4
[    5.825121] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
[    5.825205] usb usb4: configuration #1 chosen from 1 choice
[    5.825258] hub 4-0:1.0: USB hub found
[    5.825298] hub 4-0:1.0: 2 ports detected
[    5.825382] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.825425] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.825466] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.825533] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 5
[    5.825598] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
[    5.825681] usb usb5: configuration #1 chosen from 1 choice
[    5.825735] hub 5-0:1.0: USB hub found
[    5.825775] hub 5-0:1.0: 2 ports detected
[    5.825858] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    5.825902] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.825942] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.826008] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 6
[    5.826073] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    5.826157] usb usb6: configuration #1 chosen from 1 choice
[    5.826211] hub 6-0:1.0: USB hub found
[    5.826251] hub 6-0:1.0: 2 ports detected
[    5.826335] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    5.826379] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.826419] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.826481] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 7
[    5.826545] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    5.826629] usb usb7: configuration #1 chosen from 1 choice
[    5.826682] hub 7-0:1.0: USB hub found
[    5.826724] hub 7-0:1.0: 2 ports detected
[    5.826811] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    5.826855] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.826895] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.826959] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 8
[    5.827024] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    5.827107] usb usb8: configuration #1 chosen from 1 choice
[    5.827759] hub 8-0:1.0: USB hub found
[    5.827799] hub 8-0:1.0: 2 ports detected
[    5.827909] usbcore: registered new interface driver libusual
[    5.827980] PNP: No PS/2 controller found. Probing ports directly.
[    5.828313] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.828356] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.837033] mice: PS/2 mouse device common for all mice
[    5.873054] rtc_cmos 00:04: RTC can wake from S4
[    5.873122] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    5.873180] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    5.873276] device-mapper: uevent: version 1.0.3
[    5.873415] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
[    5.873775] device-mapper: multipath: version 1.0.5 loaded
[    5.873815] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.874269] cpuidle: using governor ladder
[    5.874450] cpuidle: using governor menu
[    5.874555] Marking TSC unstable due to TSC halts in idle
[    5.874829] TCP cubic registered
[    5.874942] NET: Registered protocol family 10
[    5.875250] lo: Disabled Privacy Extensions
[    5.875472] NET: Registered protocol family 17
[    5.875519] Bluetooth: L2CAP ver 2.11
[    5.875557] Bluetooth: L2CAP socket layer initialized
[    5.875596] Bluetooth: SCO (Voice Link) ver 0.6
[    5.875634] Bluetooth: SCO socket layer initialized
[    5.875713] Bluetooth: RFCOMM socket layer initialized
[    5.875770] Bluetooth: RFCOMM TTY layer initialized
[    5.875810] Bluetooth: RFCOMM ver 1.10
[    5.881239] registered taskstats version 1
[    5.881384]   Magic number: 10:91:797
[    5.881496] rtc_cmos 00:04: setting system clock to 2010-01-13 18:45:34 UTC 
(1263408334)
[    5.881565] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    5.881605] EDD information not available.
[    5.881679] Freeing unused kernel memory: 528k freed
[    5.881810] Write protecting the kernel read-only data: 6548k
[    5.971463] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.971521] r8169 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.971575] r8169 0000:04:00.0: setting latency timer to 64
[    5.971683] r8169 0000:04:00.0: irq 28 for MSI/MSI-X
[    5.971816] r8169 0000:04:00.0: Missing EEPROM signature: 0000
[    5.972314] eth0: RTL8168c/8111c at 0xffffc20000058000, 00:1f:d0:9d:27:af, 
XID 3c4000c0 IRQ 28
[    5.987335] ohci1394 0000:05:07.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    6.041039] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[e9204000-e92047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    6.401059] usb 2-2: new high speed USB device using ehci_hcd and address 2
[    6.536196] usb 2-2: configuration #1 chosen from 1 choice
[    6.540763] Initializing USB Mass Storage driver...
[    6.540894] scsi8 : SCSI emulation for USB Mass Storage devices
[    6.541065] usb-storage: device found at 2
[    6.541070] usbcore: registered new interface driver usb-storage
[    6.541071] USB Mass Storage support registered.
[    6.541185] usb-storage: waiting for device to settle before scanning
[    6.862708] kjournald starting.  Commit interval 5 seconds
[    6.862778] EXT3-fs: mounted filesystem with ordered data mode.
[    6.941554] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    7.220815] usb 3-1: configuration #1 chosen from 1 choice
[    7.316771] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[007c2d6400001fd0]
[    7.461540] usb 5-1: new low speed USB device using uhci_hcd and address 2
[    7.629738] usb 5-1: configuration #1 chosen from 1 choice
[    7.872061] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    8.041760] usb 5-2: configuration #1 chosen from 1 choice
[    8.281066] usb 8-1: new full speed USB device using uhci_hcd and address 2
[    8.449185] usb 8-1: configuration #1 chosen from 1 choice
[    8.451164] hub 8-1:1.0: USB hub found
[    8.453104] hub 8-1:1.0: 4 ports detected
[    8.696049] usb 8-2: new low speed USB device using uhci_hcd and address 3
[    8.871164] usb 8-2: configuration #1 chosen from 1 choice
[    8.950118] usb 8-1.4: new low speed USB device using uhci_hcd and address 
4
[    9.090161] usb 8-1.4: configuration #1 chosen from 1 choice
[   11.540264] usb-storage: device scan complete
[   11.542811] scsi 8:0:0:0: Direct-Access     HTS72606 0M9AT00          0000 
PQ: 0 ANSI: 0
[   11.544034] sd 8:0:0:0: [sdd] 117210240 512-byte hardware sectors: (60.0 
GB/55.8 GiB)
[   11.544920] sd 8:0:0:0: [sdd] Write Protect is off
[   11.544960] sd 8:0:0:0: [sdd] Mode Sense: 27 00 00 00
[   11.544999] sd 8:0:0:0: [sdd] Assuming drive cache: write through
[   11.545674] sd 8:0:0:0: [sdd] 117210240 512-byte hardware sectors: (60.0 
GB/55.8 GiB)
[   11.546672] sd 8:0:0:0: [sdd] Write Protect is off
[   11.546713] sd 8:0:0:0: [sdd] Mode Sense: 27 00 00 00
[   11.546754] sd 8:0:0:0: [sdd] Assuming drive cache: write through
[   11.546796]  sdd: sdd1 < sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 sdd11 > sdd2 sdd3
[   12.055696] sd 8:0:0:0: [sdd] Attached SCSI disk
[   12.055781] sd 8:0:0:0: Attached scsi generic sg4 type 0
[   13.826655] udev: starting version 147
[   14.364913] ip_tables: (C) 2000-2006 Netfilter Core Team
[   14.748074] usbcore: registered new interface driver hiddev
[   14.766406] input: Logitech USB RECEIVER as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
[   14.797633] generic-usb 0003:046D:C50E.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB RECEIVER] on usb-0000:00:1d.2-2/input0
[   14.811361] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.0/input/input4
[   14.834373] Linux video capture interface: v2.00
[   14.837086] generic-usb 0003:0A81:0205.0002: input,hidraw1: USB HID v1.10 
Keyboard [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input0
[   14.862305] lp: driver loaded but no devices found
[   14.886301] pwc: Philips webcam module version 10.0.13 loaded.
[   14.886303] pwc: Supports Philips PCA645/646, PCVC675/680/690, 
PCVC720[40]/730/740/750 & PCVC830/840.
[   14.886304] pwc: Also supports the Askey VC010, various Logitech Quickcams, 
Samsung MPC-C10 and MPC-C30,
[   14.886305] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and 
Visionite VCS-UC300 and VCS-UM100.
[   14.886328] pwc: Logitech QuickCam 4000 Pro USB webcam detected.
[   14.886376] pwc: Registered as /dev/video0.
[   14.893763] usbcore: registered new interface driver Philips webcam
[   14.969460] input: CHESEN PS2 to USB Converter as 
/devices/pci0000:00/0000:00:1d.2/usb8/8-1/8-1.4/8-1.4:1.1/input/input5
[   15.012124] generic-usb 0003:0A81:0205.0003: input,hidraw2: USB HID v1.10 
Mouse [CHESEN PS2 to USB Converter] on usb-0000:00:1d.2-1.4/input1
[   15.012157] usbcore: registered new interface driver usbhid
[   15.012159] usbhid: v2.6:USB HID core driver
[   15.070864] coretemp coretemp.0: Using relative temperature scale!
[   15.070900] coretemp coretemp.1: Using relative temperature scale!
[   15.070935] coretemp coretemp.2: Using relative temperature scale!
[   15.070965] coretemp coretemp.3: Using relative temperature scale!
[   15.110474] it87: Found IT8718F chip at 0x290, revision 5
[   15.110481] it87: in3 is VCC (+5V)
[   15.477911] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[   15.478042] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.631984] usbcore: registered new interface driver snd-usb-audio
[   15.961530] Adding 6562544k swap on /dev/mapper/cryptoswap.  Priority:-1 
extents:1 across:6562544k 
[   16.959186] EXT3 FS on sda8, internal journal
[   17.129400] kjournald starting.  Commit interval 5 seconds
[   17.129406] EXT3-fs: mounted filesystem with ordered data mode.
[   17.154176] kjournald starting.  Commit interval 5 seconds
[   17.157745] EXT3 FS on sda6, internal journal
[   17.157749] EXT3-fs: mounted filesystem with ordered data mode.
[   17.323107] kjournald starting.  Commit interval 5 seconds
[   17.323402] EXT3 FS on sdc5, internal journal
[   17.323406] EXT3-fs: mounted filesystem with ordered data mode.
[   17.351397] kjournald starting.  Commit interval 5 seconds
[   17.351714] EXT3 FS on sdc6, internal journal
[   17.351718] EXT3-fs: mounted filesystem with ordered data mode.
[   17.407807] r8169: eth0: link up
[   17.407812] r8169: eth0: link up
[   18.284149] mtrr: base(0xe5000000) is not aligned on a size(0xe00000) 
boundary
[   22.680532] RPC: Registered udp transport module.
[   22.680535] RPC: Registered tcp transport module.
[   27.557009] eth0: no IPv6 routers present
[   33.661083] mtrr: base(0xe5000000) is not aligned on a size(0xe00000) 
boundary


-----------------------------------------------------------------------------

I did not try to suspend/resume with this kernel as I suppose this is only 
about some printed out debug information in the boot log, right?


Volker

PS. I am no longer subscribed to LKML, please CC.


-- 
Volker Lanz
http://www.volker-lanz.de
