Return-Path: <linux-kernel-owner+w=401wt.eu-S1750883AbZDNEBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750883AbZDNEBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbZDNEAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:00:54 -0400
Received: from mail001.aei.ca ([206.123.6.130]:33045 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZDNEAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:00:52 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: 2.6.30-rc1 - nmi_watchdog broken?
Date: Tue, 14 Apr 2009 00:00:29 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-crc; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904140000.30155.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been having fun finding bugs in 30-rc1.  One of them is a hard freeze.  I've not seen this type
of problem on this hardware before 30-rc1 - so I doubt if its hardware.  The best way I know to
debug a hard hang is with the nmi_watchdog.  I just cannot get it to work.

The system is a 3 core amd cpu on a 790gx chipset.

If I boot the nmi_watchdog=1 it complains that lapci is not available and the boot stops.  Same problem
if I change the clocksource to tsc,   If I disable highres timers it panics.  If I use nmi_watchdog=2 it panics.
Am I doing something wrong or have I hit a bug?

Logs of boots with and without highres timers inlined below.

Kernel is 30-rc1 with latency, ext3 latency, ext4 fixes for rc1, and an apci fix applied

TIA
Ed Tomlinson   

[    0.000000] Command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=uart8250,
io,0xe800,115200n8 movablecore=3G nmi_watchdog=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffbe000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] Early serial console at I/O port 0xe800 (options '115200n8')
[    0.000000] console [uart0] enabled
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xcffb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cffb0000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000100000000-0000000220000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] ACPI: RSDP 00000000000fa000 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cffb0100 00054 (v01 010809 OEMXSDT  20090108 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0290 000F4 (v03 010809 OEMFACP  20090108 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cffb0440 0B167 (v01  P0021 P0021000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0006C (v01 010809 OEMAPIC  20090108 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0400 0003C (v01 010809 OEMMCFG  20090108 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00071 (v01 010809 AMI_OEM  20090108 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffbb5b0 00038 (v01 010809 OEMHPET  20090108 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000cffbb5f0 00110 (v01 010809 OEMOSFR  20090108 MSFT 00000097)
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0220000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000096e8dc]    TEXT DATA BSS ==> [0000200000 - 000096e8dc]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [000096f000 - 000096f294]              BRK ==> [000096f000 - 000096f294]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00220000
[    0.000000] Movable zone start PFN for each node
[    0.000000]   Node 0: 1441792
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cffb0
[    0.000000]     0: 0x00100000 -> 0x00220000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ff00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028040000, static data 71520 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1998954
[    0.000000] Kernel command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=ua
rt8250,io,0xe800,115200n8 movablecore=3G nmi_watchdog=1
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2105.446 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS1] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ 20000000 size 32 MB
[    0.000999] Aperture pointing to e820 RAM. Ignoring.
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000999] Memory: 7915888k/8912896k available (4212k kernel code, 787204k absent, 209044k reserved, 2391k data, 444k init)
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.001011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4210.88 BogoMIPS (lpj=2105444)
[    0.003020] Security Framework initialized
[    0.004015] Mount-cache hash table entries: 256
[    0.005150] Initializing cgroup subsys cpuacct
[    0.006019] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.007003] CPU: L2 Cache: 512K (64 bytes/line)
[    0.008012] CPU: Physical Processor ID: 0
[    0.009002] CPU: Processor Core ID: 0
[    0.010009] using C1E aware idle routine
[    0.011014] Freeing SMP alternatives: 22k freed
[    0.012013] ACPI: Core revision 20090320
[    0.028030] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.029007] ftrace: allocating 13146 entries in 52 pages
[    0.031062] Setting APIC routing to flat
[    0.032338] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043167] CPU0: AMD Phenom(tm) 8450 Triple-Core Processor stepping 03
[    0.046999] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.047223] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4211.09 BogoMIPS (lpj=2105546)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.119727] CPU1: AMD Phenom(tm) 8450 Triple-Core Processor stepping 03
[    0.122004] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.124083] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4210.65 BogoMIPS (lpj=2105328)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.196708] CPU2: AMD Phenom(tm) 8450 Triple-Core Processor stepping 03
[    0.199005] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.201015] Brought up 3 CPUs
[    0.202004] Total of 3 processors activated (12632.63 BogoMIPS).
[    0.203034] Testing NMI watchdog ... OK.
[    0.225448] net_namespace: 1736 bytes
[    0.226267] NET: Registered protocol family 16
[    0.227116] TOM: 00000000d0000000 aka 3328M
[    0.228022] TOM2: 0000000230000000 aka 8960M
[    0.229026] ACPI: bus type pci registered
[    0.230078] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.231003] PCI: Not using MMCONFIG.
[    0.232003] PCI: Using configuration type 1 for base access
[    0.233001] PCI: Using configuration type 1 for extended access
[    0.234032] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.235002] mtrr: probably your BIOS does not setup all CPUs.
[    0.236002] mtrr: corrected configuration.
[    0.237721] bio: create slab <bio-0> at 0
[    0.255693] ACPI: Interpreter enabled
[    0.256002] ACPI: (supports S0 S5)
[    0.258299] ACPI: Using IOAPIC for interrupt routing
[    0.260036] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.269175] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.282474] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.294340] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - E8, should be DF [20090320]
[    0.298055] ACPI: No dock devices found.
[    0.299335] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.301088] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.302004] pci 0000:00:0a.0: PME# disabled
[    0.303340] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.304005] pci 0000:00:12.2: PME# disabled
[    0.306025] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.307005] pci 0000:00:13.2: PME# disabled
[    0.308266] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.309004] pci 0000:00:14.2: PME# disabled
[    0.311184] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.312004] pci 0000:02:00.0: PME# disabled
[    0.314259] pci 0000:03:08.0: PME# supported from D0 D1 D2 D3hot
[    0.315006] pci 0000:03:08.0: PME# disabled
[    0.316049] pci 0000:00:14.4: transparent bridge
[    0.324331] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.329041] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.334371] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.339365] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.344134] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.348368] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.353371] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 15) *0, disabled.
[    0.358015] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.363424] SCSI subsystem initialized
[    0.365139] usbcore: registered new interface driver usbfs
[    0.366046] usbcore: registered new interface driver hub
[    0.368050] usbcore: registered new device driver usb
[    0.369101] PCI: Using ACPI for IRQ routing
[    0.373198] PCI-DMA: Disabling AGP.
[    0.374096] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.375002] PCI-DMA: using GART IOMMU.
[    0.376004] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.379125] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.381898] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.116118] Warning: could not register annotated branches stats
[    1.117020] Clockevents: could not switch to one-shot mode:<6>Clockevents: could not switch to one-shot mode:<7>Switched to high r
esolution mode on CPU 0
[    1.117029]  lapic is not functional.
[    1.117033] Could not switch to high resolution mode on CPU 1
[    1.118016]  lapic is not functional.
[    1.118016] Could not switch to high resolution mode on CPU 2
[   11.119002] INFO: RCU detected CPU stalls: 1 2 (detected by 0, t=10002 jiffies)
[   41.121001] INFO: RCU detected CPU stalls: 1 2 (detected by 0, t=40004 jiffies)

(boot stalls here)

----------------------------

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc1-crc (root@grover) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5) ) #5 SMP PREEMPT Mon
Apr 13 08:02:50 EDT 2009
[    0.000000] Command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=uart8250,
io,0xe800,115200n8 movablecore=3G nmi_watchdog=1 highres=off
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffbe000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] Early serial console at I/O port 0xe800 (options '115200n8')
[    0.000000] console [uart0] enabled
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xcffb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cffb0000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000100000000-0000000220000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] ACPI: RSDP 00000000000fa000 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cffb0100 00054 (v01 010809 OEMXSDT  20090108 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0290 000F4 (v03 010809 OEMFACP  20090108 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cffb0440 0B167 (v01  P0021 P0021000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0006C (v01 010809 OEMAPIC  20090108 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0400 0003C (v01 010809 OEMMCFG  20090108 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00071 (v01 010809 AMI_OEM  20090108 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffbb5b0 00038 (v01 010809 OEMHPET  20090108 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000cffbb5f0 00110 (v01 010809 OEMOSFR  20090108 MSFT 00000097)
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0220000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000096e8dc]    TEXT DATA BSS ==> [0000200000 - 000096e8dc]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [000096f000 - 000096f294]              BRK ==> [000096f000 - 000096f294]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00220000
[    0.000000] Movable zone start PFN for each node
[    0.000000]   Node 0: 1441792
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cffb0
[    0.000000]     0: 0x00100000 -> 0x00220000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ff00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028040000, static data 71520 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1998954
[    0.000000] Kernel command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=ua
rt8250,io,0xe800,115200n8 movablecore=3G nmi_watchdog=1 highres=off
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2105.458 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc1-crc (root@grover) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5) ) #5 SMP PREEMPT Mon
Apr 13 08:02:50 EDT 2009
[    0.000000] Command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=uart8250,
io,0xe800,115200n8 movablecore=3G nmi_watchdog=1 highres=off
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffbe000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] Early serial console at I/O port 0xe800 (options '115200n8')
[    0.000000] console [uart0] enabled
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xcffb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cffb0000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000100000000-0000000220000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] ACPI: RSDP 00000000000fa000 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cffb0100 00054 (v01 010809 OEMXSDT  20090108 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0290 000F4 (v03 010809 OEMFACP  20090108 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cffb0440 0B167 (v01  P0021 P0021000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0006C (v01 010809 OEMAPIC  20090108 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0400 0003C (v01 010809 OEMMCFG  20090108 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00071 (v01 010809 AMI_OEM  20090108 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffbb5b0 00038 (v01 010809 OEMHPET  20090108 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000cffbb5f0 00110 (v01 010809 OEMOSFR  20090108 MSFT 00000097)
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0220000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000096e8dc]    TEXT DATA BSS ==> [0000200000 - 000096e8dc]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [000096f000 - 000096f294]              BRK ==> [000096f000 - 000096f294]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00220000
[    0.000000] Movable zone start PFN for each node
[    0.000000]   Node 0: 1441792
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cffb0
[    0.000000]     0: 0x00100000 -> 0x00220000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ff00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028040000, static data 71520 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1998954
[    0.000000] Kernel command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=ua
rt8250,io,0xe800,115200n8 movablecore=3G nmi_watchdog=1 highres=off
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2105.458 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS1] enabled
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-rc1-crc (root@grover) (gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5) ) #5 SMP PREEMPT Mon
Apr 13 08:02:50 EDT 2009
[    0.000000] Command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=uart8250,
io,0xe800,115200n8 movablecore=3G nmi_watchdog=1 highres=off
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cffb0000 (usable)
[    0.000000]  BIOS-e820: 00000000cffb0000 - 00000000cffbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cffbe000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
[    0.000000] Early serial console at I/O port 0xe800 (options '115200n8')
[    0.000000] console [uart0] enabled
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x220000 max_arch_pfn = 0x100000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] last_pfn = 0xcffb0 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cffb0000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000100000000-0000000220000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] ACPI: RSDP 00000000000fa000 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000cffb0100 00054 (v01 010809 OEMXSDT  20090108 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cffb0290 000F4 (v03 010809 OEMFACP  20090108 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cffb0440 0B167 (v01  P0021 P0021000 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cffbe000 00040
[    0.000000] ACPI: APIC 00000000cffb0390 0006C (v01 010809 OEMAPIC  20090108 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cffb0400 0003C (v01 010809 OEMMCFG  20090108 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cffbe040 00071 (v01 010809 AMI_OEM  20090108 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cffbb5b0 00038 (v01 010809 OEMHPET  20090108 MSFT 00000097)
[    0.000000] ACPI: OSFR 00000000cffbb5f0 00110 (v01 010809 OEMOSFR  20090108 MSFT 00000097)
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0220000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 000096e8dc]    TEXT DATA BSS ==> [0000200000 - 000096e8dc]
[    0.000000]   #3 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #4 [000096f000 - 000096f294]              BRK ==> [000096f000 - 000096f294]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00220000
[    0.000000] Movable zone start PFN for each node
[    0.000000]   Node 0: 1441792
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000cffb0
[    0.000000]     0: 0x00100000 -> 0x00220000
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 3, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 1 hotplug CPUs
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ff00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028040000, static data 71520 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1998954
[    0.000000] Kernel command line: root=/dev/sdb3 vga=0x376 video=vesafb:ywrap,mtrr:3 console=tty0 console=ttyS1,115200n8 console=ua
rt8250,io,0xe800,115200n8 movablecore=3G nmi_watchdog=1 highres=off
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2105.458 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] console [ttyS1] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Node 0: aperture @ 20000000 size 32 MB
[    0.000999] Aperture pointing to e820 RAM. Ignoring.
[    0.000999] Your BIOS doesn't leave a aperture memory hole
[    0.000999] Please enable the IOMMU option in the BIOS setup
[    0.000999] This costs you 64 MB of RAM
[    0.000999] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000999] Memory: 7915888k/8912896k available (4212k kernel code, 787204k absent, 209044k reserved, 2391k data, 444k init)
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000999] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.001011] Calibrating delay loop (skipped), value calculated using timer frequency.. 4210.91 BogoMIPS (lpj=2105456)
[    0.003020] Security Framework initialized
[    0.004016] Mount-cache hash table entries: 256
[    0.005149] Initializing cgroup subsys cpuacct
[    0.006019] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.007003] CPU: L2 Cache: 512K (64 bytes/line)
[    0.008012] CPU: Physical Processor ID: 0
[    0.009002] CPU: Processor Core ID: 0
[    0.010009] using C1E aware idle routine
[    0.011014] Freeing SMP alternatives: 22k freed
[    0.012013] ACPI: Core revision 20090320
[    0.028030] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.029007] ftrace: allocating 13146 entries in 52 pages
[    0.031063] Setting APIC routing to flat
[    0.032334] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.043175] CPU0: AMD Phenom(tm) 8450 Triple-Core Processor stepping 03
[    0.046999] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.047221] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4210.99 BogoMIPS (lpj=2105495)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.119679] CPU1: AMD Phenom(tm) 8450 Triple-Core Processor stepping 03
[    0.122005] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.124064] Booting processor 2 APIC 0x2 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4210.94 BogoMIPS (lpj=2105473)
[    0.000999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.000999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.196680] CPU2: AMD Phenom(tm) 8450 Triple-Core Processor stepping 03
[    0.199005] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.200046] Brought up 3 CPUs
[    0.201004] Total of 3 processors activated (12632.84 BogoMIPS).
[    0.202034] Testing NMI watchdog ... OK.
[    0.224445] net_namespace: 1736 bytes
[    0.225263] NET: Registered protocol family 16
[    0.226115] TOM: 00000000d0000000 aka 3328M
[    0.227022] TOM2: 0000000230000000 aka 8960M
[    0.228026] ACPI: bus type pci registered
[    0.229078] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.230003] PCI: Not using MMCONFIG.
[    0.231003] PCI: Using configuration type 1 for base access
[    0.232002] PCI: Using configuration type 1 for extended access
[    0.233032] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.234002] mtrr: probably your BIOS does not setup all CPUs.
[    0.235002] mtrr: corrected configuration.
[    0.236721] bio: create slab <bio-0> at 0
[    0.255575] ACPI: Interpreter enabled
[    0.259002] ACPI: (supports S0 S5)
[    0.263300] ACPI: Using IOAPIC for interrupt routing
[    0.268172] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.284067] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.303216] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.320007] ACPI Warning (tbutils-0246): Incorrect checksum in table [OEMB] - E8, should be DF [20090320]
[    0.330203] ACPI: No dock devices found.
[    0.335327] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.340170] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.347004] pci 0000:00:0a.0: PME# disabled
[    0.351309] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.358005] pci 0000:00:12.2: PME# disabled
[    0.363224] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.370005] pci 0000:00:13.2: PME# disabled
[    0.375073] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.381004] pci 0000:00:14.2: PME# disabled
[    0.386522] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.394005] pci 0000:02:00.0: PME# disabled
[    0.398270] pci 0000:03:08.0: PME# supported from D0 D1 D2 D3hot
[    0.405005] pci 0000:03:08.0: PME# disabled
[    0.410049] pci 0000:00:14.4: transparent bridge
[    0.422065] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.430372] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.439370] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.448167] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.456367] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.465371] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.474173] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 10 11 12 14 15) *0, disabled.
[    0.482371] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.491437] SCSI subsystem initialized
[    0.495668] usbcore: registered new interface driver usbfs
[    0.501108] usbcore: registered new interface driver hub
[    0.507175] usbcore: registered new device driver usb
[    0.513512] PCI: Using ACPI for IRQ routing
[    0.521213] PCI-DMA: Disabling AGP.
[    0.525093] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.531002] PCI-DMA: using GART IOMMU.
[    0.535004] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.544120] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.549896] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    1.290016] Clocksource tsc unstable (delta = 730005241 ns)
[    1.297127] Warning: could not register annotated branches stats
[    1.306013] pnp: PnP ACPI init
[    1.309366] ACPI: bus type pnp registered
[    1.320647] pnp: PnP ACPI: found 15 devices
[    1.325226] ACPI: ACPI bus type pnp unregistered
[    1.330285] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    1.338087] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    1.345892] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    1.352842] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    1.359781] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    1.366723] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    1.373668] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    1.380606] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    1.387545] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    1.394486] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    1.401420] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    1.408353] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    1.415303] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    1.422243] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    1.429196] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    1.436134] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    1.443074] system 00:0a: ioport range 0x800-0x89f has been reserved
[    1.450036] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    1.456974] system 00:0a: ioport range 0x900-0x90f has been reserved
[    1.463912] system 00:0a: ioport range 0x910-0x91f has been reserved
[    1.470853] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    1.477989] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    1.485790] system 00:0a: iomem range 0xfec10000-0xfec1001f has been reserved
[    1.493583] system 00:0c: ioport range 0xe00-0xe0f has been reserved
[    1.500520] system 00:0c: ioport range 0xe80-0xe8f has been reserved
[    1.507462] system 00:0c: ioport range 0xf40-0xf4f has been reserved
[    1.514413] system 00:0c: ioport range 0xa30-0xa3f has been reserved
[    1.521351] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    1.529167] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    1.536401] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    1.543619] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    1.551225] system 00:0e: iomem range 0x100000-0xcfffffff could not be reserved
[    1.559218] system 00:0e: iomem range 0xfec00000-0xffffffff could not be reserved
[    1.572173] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.578644] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    1.584451] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe9fffff
[    1.591114] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    1.599382] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
[    1.605851] pci 0000:00:0a.0:   IO window: 0xc000-0xcfff
[    1.611650] pci 0000:00:0a.0:   MEM window: 0xfea00000-0xfeafffff
[    1.618301] pci 0000:00:0a.0:   PREFETCH window: disabled
[    1.624203] pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
[    1.630673] pci 0000:00:14.4:   IO window: 0xd000-0xefff
[    1.636475] pci 0000:00:14.4:   MEM window: 0xfeb00000-0xfebfffff
[    1.643138] pci 0000:00:14.4:   PREFETCH window: disabled
[    1.649050] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.656453] NET: Registered protocol family 2
[    1.672075] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.680824] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    1.690330] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.697969] TCP: Hash tables configured (established 262144 bind 65536)
[    1.705205] TCP reno registered
[    1.714440] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.723693] msgmni has been set to 15462
[    1.728365] alg: No test for stdrng (krng)
[    1.733071] io scheduler noop registered
[    1.737372] io scheduler anticipatory registered
[    1.742405] io scheduler deadline registered
[    1.747121] io scheduler cfq registered (default)
[    1.916029] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20010100000, using 15000k, total 16384k
[    1.926287] vesafb: mode is 1600x1200x32, linelength=6400, pages=1
[    1.933037] vesafb: scrolling: redraw
[    1.937042] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    1.962036] Console: switching to colour frame buffer device 200x75
[    1.986716] fb0: VESA VGA frame buffer device
[    2.007235] Linux agpgart interface v0.103
[    2.011808] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.018966] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.026218] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.032566] serial 0000:03:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.040483] 0000:03:05.0: ttyS1 at I/O 0xe800 (irq = 20) is a 16550A
[    2.040483] 0000:03:05.0: ttyS1 at I/O 0xe800 (irq = 20) is a 16550A
[    2.053858] Driver 'sd' needs updating - please use bus_type methods
[    2.053858] Driver 'sd' needs updating - please use bus_type methods
[    2.067218] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.067218] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.081542] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.081542] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.098643] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
[    2.098643] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part
[    2.115848] scsi0 : ahci
[    2.115848] scsi0 : ahci
[    2.121274] scsi1 : ahci
[    2.121274] scsi1 : ahci
[    2.126661] scsi2 : ahci
[    2.126661] scsi2 : ahci
[    2.132041] scsi3 : ahci
[    2.132041] scsi3 : ahci
[    2.137429] scsi4 : ahci
[    2.137429] scsi4 : ahci
[    2.142817] scsi5 : ahci
[    2.142817] scsi5 : ahci
[    2.148178] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
[    2.148178] ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 22
[    2.165277] ata2: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ff980 irq 22
[    2.165277] ata2: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ff980 irq 22
[    2.180734] ata3: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffa00 irq 22
[    2.180734] ata3: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffa00 irq 22
[    2.196201] ata4: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffa80 irq 22
[    2.196201] ata4: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffa80 irq 22
[    2.211658] ata5: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffb00 irq 22
[    2.211658] ata5: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffb00 irq 22
[    2.227120] ata6: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffb80 irq 22
[    2.227120] ata6: SATA max UDMA/133 abar m1024@0xfe7ff800 port 0xfe7ffb80 irq 22
[    2.242716] usbcore: registered new interface driver libusual
[    2.242716] usbcore: registered new interface driver libusual
[    2.254801] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.254801] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    2.267729] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.267729] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.288017] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.288017] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.298528] mice: PS/2 mouse device common for all mice
[    2.298528] mice: PS/2 mouse device common for all mice
[    2.309488] cpuidle: using governor ladder
[    2.309488] cpuidle: using governor ladder
[    2.318106] Netfilter messages via NETLINK v0.30.
[    2.318106] Netfilter messages via NETLINK v0.30.
[    2.328245] TCP cubic registered
[    2.328245] TCP cubic registered
[    2.335025] turn off boot console uart0
[    2.335025] turn off boot console uart0
[    2.339109] input: AT Translated Set 2 keyboard as /class/input/input0
[    2.339109] input: AT Translated Set 2 keyboard as /class/input/input0
[    2.356782] registered taskstats version 1
[    2.547034] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.553529] ata5: SATA link down (SStatus 0 SControl 300)
[    2.556040] ata6: SATA link down (SStatus 0 SControl 300)
[    2.560043] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.560054] ata3.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
[    2.560054] ata3.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    2.561038] ata4: SATA link down (SStatus 0 SControl 300)
[    2.560054] ata3.00: configured for UDMA/133
[    2.560054] ata2.00: ATA-7: WDC WD3200KS-00PFB0, 21.00M21, max UDMA/133
[    2.560054] ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 1)
[    2.560054] ata2.00: configured for UDMA/133
[    2.965031] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.973579] ata1.00: ATA-7: Maxtor 6L250S0, BACE1G10, max UDMA/133
[    2.980036] ata1.00: 490234752 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.990036] ata1.00: configured for UDMA/133
[    3.016129] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BACE PQ: 0 ANSI: 5
[    3.028180] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.028286] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors: (251 GB/233 GiB)
[    3.028307] sd 0:0:0:0: [sda] Write Protect is off
[    3.028338] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.028453]  sda: sda1 sda2 sda4
[    3.077475] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.077481] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3200KS-00P 21.0 PQ: 0 ANSI: 5
[    3.077612] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    3.077700] sd 1:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
[    3.077733] sd 1:0:0:0: [sdb] Write Protect is off
[    3.077773] scsi 2:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
[    3.077784] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.077938]  sdb:<5>sd 2:0:0:0: Attached scsi generic sg2 type 0
[    3.078039] sd 2:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
[    3.078060] sd 2:0:0:0: [sdc] Write Protect is off
[    3.078093] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.078202]  sdc: sdb1 sdb2 sdb3 sdb4
[    3.211795]  sdc1<5>sd 1:0:0:0: [sdb] Attached SCSI disk
[    3.222234]  sdc2 sdc3 sdc4
[    3.241430] sd 2:0:0:0: [sdc] Attached SCSI disk
[    3.257267] EXT3-fs: sdb3: couldn't mount because of unsupported optional features (240).
[    3.283043] EXT4-fs: barriers enabled
[    3.297949] kjournald2 starting: pid 1990, dev sdb3:8, commit interval 5 seconds
[    3.297958] EXT4-fs: delayed allocation enabled
[    3.297960] EXT4-fs: file extents enabled
[    3.298127] EXT4-fs: mballoc enabled
[    3.298139] EXT4-fs: mounted filesystem sdb3 with ordered data mode
[    3.298154] VFS: Mounted root (ext4 filesystem) readonly on device 8:19.
[    3.298178] Freeing unused kernel memory: 444k freed
[    3.298341] Write protecting the kernel read-only data: 6020k
INIT: version 2.86 booting
[    4.190041] NET: Registered protocol family 1

Gentoo Linux; http://www.gentoo.org/
 Copyright 1999-2007 Gentoo Foundation; Distributed under the GPLv2

Press I to enter interactive boot mode

 * Mounting proc at /proc ...                                             [ ok ]
 * Mounting sysfs at /sys ...                                             [ ok ]
 * Mounting /dev ...                                                      [ ok ]
 * Starting udevd ...                                                     [ ok ]
 * Populating /dev with existing devices through uevents ...              [ ok ]
 * Waiting for uevents to be processed ...[    9.190003] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff8020c5b8, registers:
[    9.190003] CPU 0
[    9.190003] Modules linked in: tuner_xc2028 tuner tvp5150 em28xx(+) ir_common v4l2_common videodev v4l2_compat_ioctl32 videobuf_vm
alloc videobuf_core tveeprom i2c_core pl2303 usbserial usbhid snd_hda_codec_atihdmi snd_hda_codec_realtek usb_storage snd_hda_intel s
r_mod snd_hda_codec rtc_cmos ohci1394 cdrom ieee1394 rtc_core snd_pcm sky2 asus_atk0110 rtc_lib snd_timer wmi snd button thermal proc
essor soundcore snd_page_alloc evdev floppy ata_generic ehci_hcd pata_atiixp pcspkr ohci_hcd unix
[    9.190003] Pid: 0, comm: swapper Not tainted 2.6.30-rc1-crc #5 System Product Name
[    9.190003] RIP: 0010:[<ffffffff8020c5b8>]  [<ffffffff8020c5b8>] irq_entries_start+0xb8/0x400
[    9.190003] RSP: 0018:ffffffff80893e58  EFLAGS: 00000046
[    9.190003] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000c0010055
[    9.190003] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff80832d40
[    9.190003] RBP: ffffffff80893eb8 R08: 0000000000000000 R09: ffff88015e085ea8
[    9.190003] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8088d848
[    9.190003] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[    9.190003] FS:  00007f3d21e366f0(0000) GS:ffff880028040000(0000) knlGS:0000000000000000
[    9.190003] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    9.190003] CR2: 00007f8bb630f000 CR3: 000000015e088000 CR4: 00000000000006e0
[    9.190003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    9.190003] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    9.190003] Process swapper (pid: 0, threadinfo ffffffff80892000, task ffffffff807ea360)
[    9.190003] Stack:
[    9.190003]  ffffffff802156e7 0000000000000010 0000000000000246 ffffffff80893e88
[    9.190003]  0000000000000018 ffffffff802156e5 ffffffff8088d848 0000000000000000
[    9.190003]  0000000000000000 bc031f7ae140644c 0000000000000000 ffffffff8088d848
[    9.190003] Call Trace:
[    9.190003]  [<ffffffff802156e7>] ? default_idle+0x1d7/0x1f0
[    9.190003]  [<ffffffff802156e5>] ? default_idle+0x1d5/0x1f0
[    9.190003]  [<ffffffff80215765>] c1e_idle+0x65/0x160
[    9.190003]  [<ffffffff8020a5c6>] cpu_idle+0x116/0x150
[    9.190003]  [<ffffffff806055cd>] rest_init+0x8d/0xb0
[    9.190003]  [<ffffffff8089af6d>] start_kernel+0x3bd/0x41a
[    9.190003]  [<ffffffff8089a281>] x86_64_start_reservations+0x91/0xb5
[    9.190003]  [<ffffffff8089a379>] x86_64_start_kernel+0xd4/0x10b
[    9.190003] Code: 40 eb 0a 6a 3f eb 06 6a 3e eb 02 6a 3d e9 61 03 00 00 90 6a 3c eb 16 6a 3b eb 12 6a 3a eb 0e 6a 39 eb 0a 6a 38 e
b 06 6a 37 eb 02 <6a> 36 e9 41 03 00 00 90 6a 35 eb 16 6a 34 eb 12 6a 33 eb 0e 6a
[    9.190003] ---[ end trace 46b8f41409604645 ]---
[    9.191003] Kernel panic - not syncing: Attempted to kill the idle task!
[    9.191003] Pid: 0, comm: swapper Tainted: G      D    2.6.30-rc1-crc #5
[    9.191003] Call Trace:
[    9.191003]  <NMI>  [<ffffffff8060f681>] panic+0xc1/0x190
[    9.191003]  [<ffffffff80278e59>] ? blocking_notifier_call_chain+0x29/0x50
[    9.191003]  [<ffffffff8027c38d>] ? profile_task_exit+0x2d/0x50
[    9.191003]  [<ffffffff80257c20>] do_exit+0x720/0x9c0
[    9.191003]  [<ffffffff80253ead>] ? console_unblank+0x8d/0xd0
[    9.191003]  [<ffffffff804c3ff3>] ? unblank_screen+0x23/0x40
[    9.191003]  [<ffffffff80252fcb>] ? oops_exit+0x3b/0x60
[    9.191003]  [<ffffffff80616345>] die_nmi+0x145/0x150
[    9.191003]  [<ffffffff806169a2>] nmi_watchdog_tick+0x1b2/0x220
[    9.191003]  [<ffffffff8027922d>] ? notify_die+0x3d/0x60
[    9.191003]  [<ffffffff806159b9>] do_nmi+0x149/0x2f0
[    9.191003]  [<ffffffff8061553a>] nmi+0x1a/0x2c
[    9.191003]  [<ffffffff8020c5b8>] ? irq_entries_start+0xb8/0x400
[    9.191003]  <<EOE>>  [<ffffffff802156e7>] ? default_idle+0x1d7/0x1f0
[    9.191003]  [<ffffffff802156e5>] ? default_idle+0x1d5/0x1f0
[    9.191003]  [<ffffffff80215765>] c1e_idle+0x65/0x160
[    9.191003]  [<ffffffff8020a5c6>] cpu_idle+0x116/0x150
[    9.191003]  [<ffffffff806055cd>] rest_init+0x8d/0xb0
[    9.191003]  [<ffffffff8089af6d>] start_kernel+0x3bd/0x41a
[    9.191003]  [<ffffffff8089a281>] x86_64_start_reservations+0x91/0xb5
[    9.191003]  [<ffffffff8089a379>] x86_64_start_kernel+0xd4/0x10b                                                                  
