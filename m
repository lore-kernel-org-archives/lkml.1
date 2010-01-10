Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778Ab0AJDJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0AJDJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 22:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196Ab0AJDJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 22:09:03 -0500
Received: from pc-249.acfr.usyd.edu.au ([129.78.210.249]:33932 "EHLO
	rosaceae.acfr.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0AJDJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 22:09:00 -0500
From: Alex Brooks <a.brooks@marathon-robotics.com>
Organization: Marathon Robotics
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: BAR 0: can't allocate resource
Date: Sun, 10 Jan 2010 14:07:26 +1100
User-Agent: KMail/1.9.9
References: <201001061305.31635.a.brooks@marathon-robotics.com> <201001071209.01975.a.brooks@marathon-robotics.com> <1262843176.27608.2.camel@dc7800.home>
In-Reply-To: <1262843176.27608.2.camel@dc7800.home>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uRUSL9lOkYWZ3jS"
Message-Id: <201001101407.26930.a.brooks@marathon-robotics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uRUSL9lOkYWZ3jS
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> I was hoping for a kernel directly from Linus' git repo, e.g.,
> 2.6.33-rc3; I don't think the debug output I'm thinking about went in
> until after 2.6.32 was released.

I'm not sure how to modify the 2.6.33-rc3 kernel source exactly re MCFG -- the 
dmesg output for 2.6.33-rc3 is quite different (attached), including some new 
information about an address collision for the recalcitrant device:

pci 0000:01:04.0: address space collision: [mem 0x00800000-0x00800fff] already 
in use
pci 0000:01:04.0: can't reserve [mem 0x00800000-0x00800fff]

Does this shed any more light on things (or can you tell me what I could 
modify to get better debug info)?


Thanks,

Alex

--Boundary-00=_uRUSL9lOkYWZ3jS
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg_2.6.33-rc3.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_2.6.33-rc3.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.33-rc3 (root@waltz) (gcc version 4.3.4 (Debian 4.3.4-6) ) #4 SMP Sun Jan 10 13:34:48 EST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f7c0000 (usable)
[    0.000000]  BIOS-e820: 000000003f7c0000 - 000000003f7ce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f7ce000 - 000000003f800000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x3f7c0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 03F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 00800000
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-00000000373fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037000000 page 2M
[    0.000000]  0037000000 - 00373fe000 page 4k
[    0.000000] kernel direct mapping tables up to 373fe000 @ 15000-1b000
[    0.000000] RAMDISK: 2f270000 - 2fa0fb83
[    0.000000] ACPI: RSDP 000f8ed0 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 3f7c0000 0003C (v01 112007 RSDT1407 20071120 MSFT 00000097)
[    0.000000] ACPI: FACP 3f7c0200 00084 (v02 112007 FACP1407 20071120 MSFT 00000097)
[    0.000000] ACPI: DSDT 3f7c05b0 04FF8 (v01  DLAG_ DLAG_117 00000117 INTL 20051117)
[    0.000000] ACPI: FACS 3f7ce000 00040
[    0.000000] ACPI: APIC 3f7c0390 0005C (v01 112007 APIC1407 20071120 MSFT 00000097)
[    0.000000] ACPI: MCFG 3f7c03f0 0003C (v01 112007 OEMMCFG  20071120 MSFT 00000097)
[    0.000000] ACPI: SLIC 3f7c0430 00176 (v01 112007 SLIC1407 20071120 MSFT 00000097)
[    0.000000] ACPI: OEMB 3f7ce040 00071 (v01 112007 OEMB1407 20071120 MSFT 00000097)
[    0.000000] ACPI: ASF! 3f7c55b0 00075 (v32 LEGEND I865PASF 00000001 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 131MB HIGHMEM available.
[    0.000000] 883MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 373fe000
[    0.000000]   low ram: 0 - 373fe000
[    0.000000]   node 0 low ram: 00000000 - 373fe000
[    0.000000]   node 0 bootmap 00017000 - 0001de80
[    0.000000] (14 early reservations) ==> bootmem [0000000000 - 00373fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000001000]    EX TRAMPOLINE
[    0.000000]   #2 [0000100000 - 0000594208]    TEXT DATA BSS ==> [0000100000 - 0000594208]
[    0.000000]   #3 [002f270000 - 002fa0fb83]          RAMDISK ==> [002f270000 - 002fa0fb83]
[    0.000000]   #4 [0000595000 - 0000597127]              BRK ==> [0000595000 - 0000597127]
[    0.000000]   #5 [00000ff790 - 0000100000]    BIOS reserved ==> [00000ff790 - 0000100000]
[    0.000000]   #6 [00000ff780 - 00000ff790]     MP-table mpf ==> [00000ff780 - 00000ff790]
[    0.000000]   #7 [000009fc00 - 00000e5890]    BIOS reserved ==> [000009fc00 - 00000e5890]
[    0.000000]   #8 [00000e59b8 - 00000ff780]    BIOS reserved ==> [00000e59b8 - 00000ff780]
[    0.000000]   #9 [00000e5890 - 00000e59b8]     MP-table mpc ==> [00000e5890 - 00000e59b8]
[    0.000000]   #10 [0000010000 - 0000011000]       TRAMPOLINE ==> [0000010000 - 0000011000]
[    0.000000]   #11 [0000011000 - 0000015000]      ACPI WAKEUP ==> [0000011000 - 0000015000]
[    0.000000]   #12 [0000015000 - 0000017000]          PGTABLE ==> [0000015000 - 0000017000]
[    0.000000]   #13 [0000017000 - 000001e000]          BOOTMAP ==> [0000017000 - 000001e000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000373fe
[    0.000000]   HighMem  0x000373fe -> 0x0003f7c0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f7c0
[    0.000000] On node 0 totalpages: 259919
[    0.000000] free_area_init_node: node 0, pgdat c0481e40, node_mem_map c1001200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1736 pages used for memmap
[    0.000000]   Normal zone: 220470 pages, LIFO batch:31
[    0.000000]   HighMem zone: 264 pages used for memmap
[    0.000000]   HighMem zone: 33466 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 3f800000 (gap: 3f800000:bf600000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @c1800000 s32280 r0 d20968 u2097152
[    0.000000] pcpu-alloc: s32280 r0 d20968 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257887
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33-rc3 root=UUID=01963ea0-bf6e-4697-9eb4-53287b2c5e12 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000373fe:0003f7c0)
[    0.000000] Memory: 1017516k/1040128k available (2394k kernel code, 21592k reserved, 1236k data, 368k init, 134920k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd56000 - 0xfffff000   (2724 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0xf7bfe000 - 0xff3fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf73fe000   ( 883 MB)
[    0.000000]       .init : 0xc048c000 - 0xc04e8000   ( 368 kB)
[    0.000000]       .data : 0xc0356b0e - 0xc048bd84   (1236 kB)
[    0.000000]       .text : 0xc0100000 - 0xc0356b0e   (2394 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1666.693 MHz processor.
[    0.004005] Calibrating delay loop (skipped), value calculated using timer frequency.. 3333.38 BogoMIPS (lpj=6666772)
[    0.004048] Security Framework initialized
[    0.004055] SELinux:  Disabled at boot.
[    0.004072] Mount-cache hash table entries: 512
[    0.004207] Initializing cgroup subsys ns
[    0.004211] Initializing cgroup subsys cpuacct
[    0.004216] Initializing cgroup subsys devices
[    0.004219] Initializing cgroup subsys freezer
[    0.004221] Initializing cgroup subsys net_cls
[    0.004254] mce: CPU supports 6 MCE banks
[    0.004264] CPU0: Thermal monitoring enabled (TM2)
[    0.004268] using mwait in idle threads.
[    0.004276] Performance Events: no PMU driver, software events only.
[    0.004282] Checking 'hlt' instruction... OK.
[    0.020370] SMP alternatives: switching to UP code
[    0.024301] ACPI: Core revision 20091214
[    0.036415] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076697] CPU0: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz stepping 0c
[    0.080000] Brought up 1 CPUs
[    0.080000] Total of 1 processors activated (3333.38 BogoMIPS).
[    0.080000] regulator: core version 0.5
[    0.080000] NET: Registered protocol family 16
[    0.080000] ACPI: bus type pci registered
[    0.080000] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.080000] PCI: not using MMCONFIG
[    0.080000] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=1
[    0.080000] PCI: Using configuration type 1 for base access
[    0.080000] bio: create slab <bio-0> at 0
[    0.080050] ACPI: EC: Look up EC in DSDT
[    0.085189] ACPI: Executed 1 blocks of module-level executable AML code
[    0.091910] ACPI Warning: Incorrect checksum in table [OEMB] - 48, should be 41 (20091214/tbutils-314)
[    0.091933] ACPI: SSDT 3f7ce0c0 00688 (v01    AMI   CPU1PM 00000001 INTL 20051117)
[    0.092614] ACPI: Interpreter enabled
[    0.092625] ACPI: (supports S0 S1 S3 S4 S5)
[    0.092652] ACPI: Using IOAPIC for interrupt routing
[    0.092714] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.113778] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.113784] PCI: MMCONFIG for 0000 [bus00-3f] at [mem 0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.113787] PCI: Using MMCONFIG for extended config space
[    0.126055] ACPI: No dock devices found.
[    0.126239] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.126294] pci_root PNP0A08:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.126637] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.126641] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.126645] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.126648] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.126652] pci_root PNP0A08:00: host bridge window [mem 0x3f800000-0xdfffffff] (ignored)
[    0.126655] pci_root PNP0A08:00: host bridge window [mem 0xe4000000-0xfed8ffff] (ignored)
[    0.126723] pci 0000:00:02.0: reg 10: [mem 0xfea80000-0xfeafffff]
[    0.126729] pci 0000:00:02.0: reg 14: [io  0xdc80-0xdc87]
[    0.126734] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff pref]
[    0.126740] pci 0000:00:02.0: reg 1c: [mem 0xfea40000-0xfea7ffff]
[    0.126778] pci 0000:00:02.1: reg 10: [mem 0xfe980000-0xfe9fffff]
[    0.126871] pci 0000:00:1b.0: reg 10: [mem 0xfea38000-0xfea3bfff 64bit]
[    0.126925] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.126930] pci 0000:00:1b.0: PME# disabled
[    0.126984] pci 0000:00:1d.0: reg 20: [io  0xdc00-0xdc1f]
[    0.127043] pci 0000:00:1d.1: reg 20: [io  0xd880-0xd89f]
[    0.127102] pci 0000:00:1d.2: reg 20: [io  0xd800-0xd81f]
[    0.127161] pci 0000:00:1d.3: reg 20: [io  0xd480-0xd49f]
[    0.127219] pci 0000:00:1d.7: reg 10: [mem 0xfea37c00-0xfea37fff]
[    0.127281] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.127287] pci 0000:00:1d.7: PME# disabled
[    0.127430] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.127437] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.127442] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
[    0.127447] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0a00 (mask 000f)
[    0.127453] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0278 (mask 000f)
[    0.127458] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 03e8 (mask 000f)
[    0.127464] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 000f)
[    0.127510] pci 0000:00:1f.1: reg 10: [io  0x0000-0x0007]
[    0.127518] pci 0000:00:1f.1: reg 14: [io  0x0000-0x0003]
[    0.127527] pci 0000:00:1f.1: reg 18: [io  0x08f0-0x08f7]
[    0.127535] pci 0000:00:1f.1: reg 1c: [io  0x08f8-0x08fb]
[    0.127543] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.127590] pci 0000:00:1f.2: reg 10: [io  0xd400-0xd407]
[    0.127598] pci 0000:00:1f.2: reg 14: [io  0xd080-0xd083]
[    0.127605] pci 0000:00:1f.2: reg 18: [io  0xd000-0xd007]
[    0.127613] pci 0000:00:1f.2: reg 1c: [io  0xcc80-0xcc83]
[    0.127621] pci 0000:00:1f.2: reg 20: [io  0xcc00-0xcc0f]
[    0.127628] pci 0000:00:1f.2: reg 24: [mem 0xfea37800-0xfea37bff]
[    0.127655] pci 0000:00:1f.2: PME# supported from D3hot
[    0.127659] pci 0000:00:1f.2: PME# disabled
[    0.127711] pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
[    0.127771] pci 0000:01:04.0: reg 10: [mem 0x00800000-0x00800fff]
[    0.127858] pci 0000:01:08.0: reg 10: [mem 0xfebfe000-0xfebfefff]
[    0.127866] pci 0000:01:08.0: reg 14: [io  0xec80-0xecbf]
[    0.127917] pci 0000:01:08.0: supports D1 D2
[    0.127919] pci 0000:01:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.127925] pci 0000:01:08.0: PME# disabled
[    0.127968] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.127973] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.127979] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.127993] pci_bus 0000:00: on NUMA node 0
[    0.128029] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.128264] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.139416] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.139554] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.139689] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.139823] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.139959] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.140115] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.140252] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.140391] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
[    0.140589] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.140597] vgaarb: loaded
[    0.140771] PCI: Using ACPI for IRQ routing
[    0.140776] PCI: pci_cache_line_size set to 64 bytes
[    0.140836] pci 0000:01:04.0: address space collision: [mem 0x00800000-0x00800fff] already in use
[    0.140895] pci 0000:01:04.0: can't reserve [mem 0x00800000-0x00800fff]
[    0.141171] hpet clockevent registered
[    0.141176] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.141182] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.141188] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.144027] Switching to clocksource tsc
[    0.145530] pnp: PnP ACPI init
[    0.145540] ACPI: bus type pnp registered
[    0.152165] pnp: PnP ACPI: found 17 devices
[    0.152168] ACPI: ACPI bus type pnp unregistered
[    0.152172] PnPBIOS: Disabled by ACPI PNP
[    0.152183] system 00:01: [mem 0xfed13000-0xfed19fff] has been reserved
[    0.152192] system 00:09: [io  0x0a00-0x0a0f] has been reserved
[    0.152201] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.152205] system 00:0b: [io  0x0800-0x087f] has been reserved
[    0.152208] system 00:0b: [io  0x0480-0x04bf] has been reserved
[    0.152212] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.152216] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.152220] system 00:0b: [mem 0xfed40000-0xfed8ffff] has been reserved
[    0.152226] system 00:0d: [mem 0xffc00000-0xffefffff] has been reserved
[    0.152234] system 00:0e: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.152238] system 00:0e: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.152244] system 00:0f: [mem 0xe0000000-0xe3ffffff] has been reserved
[    0.152251] system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.152254] system 00:10: [mem 0x000c0000-0x000cffff] could not be reserved
[    0.152258] system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.152262] system 00:10: [mem 0x00100000-0x3f7fffff] could not be reserved
[    0.152266] system 00:10: [mem 0xfed90000-0xffffffff] could not be reserved
[    0.187242] pci 0000:01:04.0: BAR 0: assigned [mem 0xfeb00000-0xfeb00fff]
[    0.187250] pci 0000:01:04.0: BAR 0: error updating (0xfeb00002 != 0x000000)
[    0.187305] pci 0000:01:04.0: BAR 0: set to [mem 0xfeb00000-0xfeb00fff] (PCI address [0xfeb00000-0xfeb00fff]
[    0.187310] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    0.187314] pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
[    0.187321] pci 0000:00:1e.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.187326] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.187342] pci 0000:00:1e.0: setting latency timer to 64
[    0.187346] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.187349] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.187353] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.187356] pci_bus 0000:01: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.187359] pci_bus 0000:01: resource 3 [io  0x0000-0xffff]
[    0.187362] pci_bus 0000:01: resource 4 [mem 0x00000000-0xffffffff]
[    0.187399] NET: Registered protocol family 2
[    0.187473] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.187740] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.189151] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.189564] TCP: Hash tables configured (established 131072 bind 65536)
[    0.189568] TCP reno registered
[    0.189571] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.189587] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.189719] NET: Registered protocol family 1
[    0.189738] pci 0000:00:02.0: Boot video device
[    0.189860] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    0.189866] PCI: CLS 32 bytes, default 64
[    0.189926] Trying to unpack rootfs image as initramfs...
[    0.484255] Freeing initrd memory: 7806k freed
[    0.489793] audit: initializing netlink socket (disabled)
[    0.489813] type=2000 audit(1263092387.487:1): initialized
[    0.489962] highmem bounce pool size: 64 pages
[    0.489969] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.490059] VFS: Disk quotas dquot_6.5.2
[    0.490086] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.490151] msgmni has been set to 1740
[    0.490307] alg: No test for stdrng (krng)
[    0.490365] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.490369] io scheduler noop registered
[    0.490371] io scheduler deadline registered
[    0.490385] io scheduler cfq registered (default)
[    0.490794] isapnp: Scanning for PnP cards...
[    0.844847] isapnp: No Plug & Play device found
[    0.848354] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.848495] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.848629] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.849059] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.849252] 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    0.851365] brd: module loaded
[    0.851522] PNP: No PS/2 controller found. Probing ports directly.
[    0.853978] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.853984] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.854182] mice: PS/2 mouse device common for all mice
[    0.854232] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.854259] rtc_cmos 00:03: RTC can wake from S4
[    0.854333] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.854363] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.854402] cpuidle: using governor ladder
[    0.854404] cpuidle: using governor menu
[    0.854409] No iBFT detected.
[    0.854676] TCP cubic registered
[    0.854713] NET: Registered protocol family 10
[    0.855099] lo: Disabled Privacy Extensions
[    0.855330] Mobile IPv6
[    0.855332] NET: Registered protocol family 17
[    0.855347] Using IPI No-Shortcut mode
[    0.855489] registered taskstats version 1
[    0.855699] rtc_cmos 00:03: setting system clock to 2010-01-10 02:59:48 UTC (1263092388)
[    0.855744] Freeing unused kernel memory: 368k freed
[    0.855997] Write protecting the kernel text: 2396k
[    0.856030] Write protecting the kernel read-only data: 840k
[    1.067814] Linux agpgart interface v0.103
[    1.087406] Uniform Multi-Platform E-IDE driver
[    1.117079] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    1.117083] e100: Copyright(c) 1999-2006 Intel Corporation
[    1.117132] e100 0000:01:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.142316] e100 0000:01:08.0: PME# disabled
[    1.142833] e100: eth0: e100_probe: addr 0xfebfe000, irq 20, MAC addr 00:30:59:04:25:2e
[    1.146643] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.146650] ACPI: Power Button [PWRB]
[    1.146712] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.146717] ACPI: Power Button [PWRF]
[    1.196330] SCSI subsystem initialized
[    1.272678] agpgart-intel 0000:00:00.0: Intel 945GME Chipset
[    1.273122] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    1.275799] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    1.282114] piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
[    1.282132] PIIX_IDE 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.282145] piix 0000:00:1f.1: IDE port disabled
[    1.282155] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    1.282162]     ide0: BM-DMA at 0xffa0-0xffa7
[    1.282170] Probing IDE interface ide0...
[    1.291322] usbcore: registered new interface driver usbfs
[    1.291357] usbcore: registered new interface driver hub
[    1.291712] usbcore: registered new device driver usb
[    1.296614] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.323175] libata version 3.00 loaded.
[    1.532708] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input2
[    1.532717] ACPI: Video Device [IGD] (multi-head: yes  rom: no  post: no)
[    1.848010] hdb: CF Card, ATA DISK drive
[    1.848057] hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO2
[    1.848078] hdb: host side 80-wire cable detection failed, limiting max speed to UDMA33
[    1.848081] hdb: UDMA/33 mode selected
[    1.848159] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    1.857660] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.857681] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.857686] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.857712] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    1.857733] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    1.857746] ehci_hcd 0000:00:1d.7: debug port 1
[    1.861619] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.861638] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfea37c00
[    1.876010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.876051] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.876054] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.876057] usb usb1: Product: EHCI Host Controller
[    1.876060] usb usb1: Manufacturer: Linux 2.6.33-rc3 ehci_hcd
[    1.876063] usb usb1: SerialNumber: 0000:00:1d.7
[    1.876168] hub 1-0:1.0: USB hub found
[    1.876174] hub 1-0:1.0: 8 ports detected
[    1.876383] ata_piix 0000:00:1f.2: version 2.13
[    1.876401] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.876407] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.876448] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.876708] scsi0 : ata_piix
[    1.880373] uhci_hcd: USB Universal Host Controller Interface driver
[    1.880667] scsi1 : ata_piix
[    1.880717] ata1: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xcc00 irq 19
[    1.880721] ata2: SATA max UDMA/133 cmd 0xd000 ctl 0xcc80 bmdma 0xcc08 irq 19
[    1.882095] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    1.882105] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.882110] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.882122] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.882150] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000dc00
[    1.882192] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.882196] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.882199] usb usb2: Product: UHCI Host Controller
[    1.882201] usb usb2: Manufacturer: Linux 2.6.33-rc3 uhci_hcd
[    1.882204] usb usb2: SerialNumber: 0000:00:1d.0
[    1.882299] hub 2-0:1.0: USB hub found
[    1.882304] hub 2-0:1.0: 2 ports detected
[    1.882368] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.882375] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.882379] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.882386] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.882412] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d880
[    1.882446] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.882450] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.882453] usb usb3: Product: UHCI Host Controller
[    1.882455] usb usb3: Manufacturer: Linux 2.6.33-rc3 uhci_hcd
[    1.882458] usb usb3: SerialNumber: 0000:00:1d.1
[    1.882536] hub 3-0:1.0: USB hub found
[    1.882541] hub 3-0:1.0: 2 ports detected
[    1.882603] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.882610] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.882614] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.882621] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    1.882658] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d800
[    1.882695] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.882698] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.882701] usb usb4: Product: UHCI Host Controller
[    1.882704] usb usb4: Manufacturer: Linux 2.6.33-rc3 uhci_hcd
[    1.882706] usb usb4: SerialNumber: 0000:00:1d.2
[    1.882783] hub 4-0:1.0: USB hub found
[    1.882788] hub 4-0:1.0: 2 ports detected
[    1.882855] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    1.882862] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    1.882866] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.882873] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    1.882906] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d480
[    1.882940] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.882943] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.882946] usb usb5: Product: UHCI Host Controller
[    1.882949] usb usb5: Manufacturer: Linux 2.6.33-rc3 uhci_hcd
[    1.882951] usb usb5: SerialNumber: 0000:00:1d.3
[    1.883029] hub 5-0:1.0: USB hub found
[    1.883033] hub 5-0:1.0: 2 ports detected
[    2.065301] ide-gd driver 1.18
[    2.065341] hdb: max request size: 128KiB
[    2.065344] hdb: 7880544 sectors (4034 MB) w/1KiB Cache, CHS=7818/16/63
[    2.065393]  hdb: hdb1 hdb2 < hdb5 >
[    2.139023] PM: Starting manual resume from disk
[    2.161644] kjournald starting.  Commit interval 5 seconds
[    2.161653] EXT3-fs (hdb1): mounted filesystem with ordered data mode
[    2.372020] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    2.508256] udev: starting version 149
[    2.623167] usb 2-1: New USB device found, idVendor=1241, idProduct=1603
[    2.623171] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.623175] usb 2-1: Product: USB Keyboard
[    2.623178] usb 2-1: Manufacturer:  
[    2.715721] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    2.735990] intel_rng: FWH not detected
[    2.828830] Marking TSC unstable due to TSC halts in idle
[    2.833542] parport_pc 00:08: reported by Plug and Play ACPI
[    2.833593] parport0: PC-style at 0x378, irq 7 [PCSPP]
[    2.845066] Switching to clocksource hpet
[    2.947553] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.954328] usbcore: registered new interface driver hiddev
[    2.980206] Error: Driver 'pcspkr' is already registered, aborting...
[    2.988097] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.988152] HDA Intel 0000:00:1b.0: irq 24 for MSI/MSI-X
[    2.988186] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.998505] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input4
[    2.998578] generic-usb 0003:1241:1603.0001: input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1/input0
[    3.090965] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.1/input/input5
[    3.091039] generic-usb 0003:1241:1603.0002: input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on usb-0000:00:1d.0-1/input1
[    3.091071] usbcore: registered new interface driver usbhid
[    3.091073] usbhid: USB HID core driver
[    3.098999] hda_codec: ALC882: BIOS auto-probing.
[    3.100361] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[    3.305501] Adding 224868k swap on /dev/hdb5.  Priority:-1 extents:1 across:224868k 
[    3.356624] EXT3-fs (hdb1): using internal journal
[    3.384216] loop: module loaded
[    4.213175] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    4.216155] e100: eth0 NIC Link is Up 100 Mbps Full Duplex
[    4.216470] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.244016] eth0: no IPv6 routers present

--Boundary-00=_uRUSL9lOkYWZ3jS--
