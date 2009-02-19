Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZBSSp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZBSSp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZBSSpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:45:17 -0500
Received: from www17.your-server.de ([213.133.104.17]:43354 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZBSSpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:45:07 -0500
Subject: Re: [Announce] 2.6.29-rc4-rt2
From: Thomas Meyer <thomas@m3y3r.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 19:44:03 +0100
Message-Id: <1235069043.3841.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 12.02.2009, 23:56 +0100 schrieb Thomas Gleixner:
> We are pleased to announce the first update to our new preempt-rt
> series. It fixes the reported bugs and some more.
> 
> Download locations:
> 
>    http://rt.et.redhat.com/download/
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
>  
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29-rc4-rt2 tree, the following patches should be
> applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc4.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc4-rt2.bz2
> 
> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>       Thomas, Ingo

Hi,

Setting CONFIG_PERF_COUNTERS make my build, hang really early. Likely
before ohci1394_dma=early stuff, because firescope doesn't seem to work.

With attached config the system boots up to the point
after /etc/rc.sysinit (this is a fedora 10 system) activates the swap.
Then all I see from upstart/init is "Message from illegal source". And
the system seems to stop the boot process. Strange, isn't it?
 
So this is what I could capture with attached config, by inserting
"/bin/bash" into /etc/rc.sysinit after swap activation:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.29-rc4-rt2-tip (thomas@localhost.localdomain) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #54 SMP PREEMPT RT Thu Feb 19 16:29:15 CET 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f0c8000 (usable)
[    0.000000]  BIOS-e820: 000000007f0c8000 - 000000007f2c9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f2c9000 - 000000007feb9000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feb9000 - 000000007feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007feef000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7f0c8 max_arch_pfn = 0x100000
[    0.000000] PAT not supported by CPU.
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] init_ohci1394_dma: initializing OHCI-1394 at 0c:03.0
[    0.000000] init_ohci1394_dma: finished initializing OHCI DMA
[    0.000000] RAMDISK: 7ed76000 - 7f0c775d
[    0.000000] Allocated new RAMDISK: 00dd0000 - 0112175d
[    0.000000] Move RAMDISK from 000000007ed76000 - 000000007f0c775c to 00dd0000 - 0112175c
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 7FEFD120, 0074 (r1 APPLE   Apple00       55       1000013)
[    0.000000] ACPI: FACP 7FEFB000, 00F4 (r3 APPLE   Apple00       55 Loki       5F)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 7FEF0000, 48C0 (r1 APPLE  MacBookP    10001 INTL 20050309)
[    0.000000] ACPI: FACS 7FEBB000, 0040
[    0.000000] ACPI: HPET 7FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC 7FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG 7FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! 7FEF7000, 009C (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST 7FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT 7FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT 7FEB6000, 064F (r1 APPLE   SataPri     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 7FEB5000, 069C (r1 APPLE   SataSec     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 7FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 1144MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000400000 - 0000dca8a0]    TEXT DATA BSS ==> [0000400000 - 0000dca8a0]
[    0.000000]   #4 [0000dcb000 - 0000dd0000]    INIT_PG_TABLE ==> [0000dcb000 - 0000dd0000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #7 [0000dd0000 - 000112175d]      NEW RAMDISK ==> [0000dd0000 - 000112175d]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0007f0c8
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0007f0c8
[    0.000000] On node 0 totalpages: 520295
[    0.000000] free_area_init_node: node 0, pgdat c0c8fb40, node_mem_map c1122000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2834 pages used for memmap
[    0.000000]   Normal zone: 220396 pages, LIFO batch:31
[    0.000000]   HighMem zone: 3721 pages used for memmap
[    0.000000]   HighMem zone: 289345 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 32768 bytes of per cpu data
[    0.000000] Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 513688
[    0.000000] Kernel command line: ro root=/dev/mapper/luks-sda4 panic=45 nomodeset ohci1394_dma=early vga=0x0f07 initrd=initrd-2.6.29-rc4-rt2-tip.img BOOT_IMAGE=vmlinuz-2.6.29-rc4-rt2-tip 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] CPU 0 irqstacks, hard=c0d2d000 soft=c0d29000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: PIT calibration matches PMTIMER. 1 loops
[    0.000000] Detected 1830.867 MHz processor.
[    0.003333] Console: colour VGA+ 80x60
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 2039352k/2081568k available (5824k kernel code, 40984k reserved, 3094k data, 420k init, 1172264k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.003333]       .init : 0xc0cbd000 - 0xc0d26000   ( 420 kB)
[    0.003333]       .data : 0xc09b03b2 - 0xc0cb5bc4   (3094 kB)
[    0.003333]       .text : 0xc0400000 - 0xc09b03b2   (5824 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] ------------[ cut here ]------------
[    0.003333] WARNING: at mm/highmem.c:225 kmap_flush_unused+0x2b/0x4b()
[    0.003333] Hardware name: MacBookPro1,1
[    0.003333] Modules linked in:
[    0.003333] Pid: 0, comm: swapper Not tainted 2.6.29-rc4-rt2-tip #54
[    0.003333] Call Trace:
[    0.003333]  [<c0451e70>] warn_slowpath+0x8a/0xd3
[    0.003333]  [<c043ee71>] ? kmap+0x6c/0x77
[    0.003333]  [<c04ad7f5>] ? get_page_from_freelist+0x389/0x42b
[    0.003333]  [<c04adb8f>] ? __alloc_pages_internal+0xbf/0x3a6
[    0.003333]  [<c04b9b92>] kmap_flush_unused+0x2b/0x4b
[    0.003333]  [<c043b877>] change_page_attr_set_clr+0xe8/0x2ca
[    0.003333]  [<c09aabd9>] ? rt_spin_lock+0x32/0x79
[    0.003333]  [<c04bbeb3>] ? __pte_alloc_kernel+0x50/0x83
[    0.003333]  [<c043bd16>] _set_memory_uc+0x27/0x3a
[    0.003333]  [<c043ac3d>] ioremap_change_attr+0x24/0x47
[    0.003333]  [<c043ae62>] __ioremap_caller+0x202/0x256
[    0.003333]  [<c0cd0b79>] ? hpet_enable+0x2d/0x26c
[    0.003333]  [<c043afe0>] ioremap_nocache+0x1c/0x2f
[    0.003333]  [<c0cd0b79>] ? hpet_enable+0x2d/0x26c
[    0.003333]  [<c0cd0b79>] hpet_enable+0x2d/0x26c
[    0.003333]  [<c0cc34fb>] hpet_time_init+0x16/0x37
[    0.003333]  [<c0cbd997>] start_kernel+0x289/0x345
[    0.003333]  [<c0cbd093>] __init_begin+0x93/0xac
[    0.003333] ---[ end trace a7919e7f17c0a725 ]---
[    0.003333] hpet clockevent registered
[    0.003333] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 3663.30 BogoMIPS (lpj=6102890)
[    0.003756] Security Framework initialized
[    0.003926] SELinux:  Initializing.
[    0.004114] SELinux:  Starting in permissive mode
[    0.004144] Mount-cache hash table entries: 512
[    0.006815] Initializing cgroup subsys ns
[    0.006985] Initializing cgroup subsys cpuacct
[    0.007155] Initializing cgroup subsys net_cls
[    0.007345] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.007614] CPU: L2 cache: 2048K
[    0.007780] CPU: Physical Processor ID: 0
[    0.007946] CPU: Processor Core ID: 0
[    0.008112] CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
[    0.008287] Intel machine check architecture supported.
[    0.008458] Intel machine check reporting enabled on CPU#0.
[    0.008638] Checking 'hlt' instruction... OK.
[    0.023772] ACPI: Core revision 20081204
[    0.037149] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072745] CPU0: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.073332] CPU 1 irqstacks, hard=c0d2e000 soft=c0d2a000
[    0.073332] Booting processor 1 APIC 0x1 ip 0x6000
[    0.073332] Initializing CPU#1
[    0.073332] Calibrating delay using timer specific routine.. 3663.33 BogoMIPS (lpj=6102937)
[    0.073332] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.073332] CPU: L2 cache: 2048K
[    0.073332] CPU: Physical Processor ID: 0
[    0.073332] CPU: Processor Core ID: 1
[    0.073332] CPU: CPU feature monitor disabled due to lack of CPUID level 0x5
[    0.073332] Intel machine check architecture supported.
[    0.073332] Intel machine check reporting enabled on CPU#1.
[    0.163791] CPU1: Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.165743] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.166729] Brought up 2 CPUs
[    0.166894] Total of 2 processors activated (7326.64 BogoMIPS).
[    0.167117] CPU0 attaching sched-domain:
[    0.167120]  domain 0: span 0-1 level MC
[    0.167123]   groups: 0 1
[    0.167129] CPU1 attaching sched-domain:
[    0.167131]  domain 0: span 0-1 level MC
[    0.167134]   groups: 1 0
[    0.176788] net_namespace: 1108 bytes
[    0.177292] NET: Registered protocol family 16
[    0.177292] ACPI: bus type pci registered
[    0.177292] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.177292] PCI: MCFG area at e0000000 reserved in E820
[    0.177292] PCI: Using MMCONFIG for extended config space
[    0.177292] PCI: Using configuration type 1 for base access
[    0.190078] bio: create slab <bio-0> at 0
[    0.190879] ACPI: EC: EC description table is found, configuring boot EC
[    0.193395] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.196875] ACPI: BIOS _OSI(Linux) query ignored
[    0.200196] ACPI: Interpreter enabled
[    0.200366] ACPI: (supports S0 S3 S4 S5)
[    0.200963] ACPI: Using IOAPIC for interrupt routing
[    0.220171] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.220333] ACPI: EC: driver started in interrupt mode
[    0.220531] ACPI: No dock devices found.
[    0.220625] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.220843] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.220843] pci 0000:00:01.0: PME# disabled
[    0.220843] pci 0000:00:07.0: reg 10 32bit mmio: [0x90404000-0x90404fff]
[    0.220843] pci 0000:00:1b.0: reg 10 64bit mmio: [0x90400000-0x90403fff]
[    0.220843] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.220843] pci 0000:00:1b.0: PME# disabled
[    0.221091] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.221264] pci 0000:00:1c.0: PME# disabled
[    0.221519] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.221694] pci 0000:00:1c.1: PME# disabled
[    0.221948] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.222122] pci 0000:00:1c.2: PME# disabled
[    0.222354] pci 0000:00:1d.0: reg 20 io port: [0x40a0-0x40bf]
[    0.222420] pci 0000:00:1d.1: reg 20 io port: [0x4080-0x409f]
[    0.222486] pci 0000:00:1d.2: reg 20 io port: [0x4060-0x407f]
[    0.222552] pci 0000:00:1d.3: reg 20 io port: [0x4040-0x405f]
[    0.222621] pci 0000:00:1d.7: reg 10 32bit mmio: [0x90405400-0x904057ff]
[    0.222688] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.222863] pci 0000:00:1d.7: PME# disabled
[    0.223206] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.223524] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.223700] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.223934] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
[    0.224167] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 (mask 0003)
[    0.224402] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
[    0.224688] pci 0000:00:1f.1: reg 10 io port: [0x40e8-0x40ef]
[    0.224697] pci 0000:00:1f.1: reg 14 io port: [0x40fc-0x40ff]
[    0.224705] pci 0000:00:1f.1: reg 18 io port: [0x40e0-0x40e7]
[    0.224714] pci 0000:00:1f.1: reg 1c io port: [0x40f8-0x40fb]
[    0.224723] pci 0000:00:1f.1: reg 20 io port: [0x40c0-0x40cf]
[    0.224780] pci 0000:00:1f.2: reg 10 io port: [0x40d8-0x40df]
[    0.224789] pci 0000:00:1f.2: reg 14 io port: [0x40f4-0x40f7]
[    0.224797] pci 0000:00:1f.2: reg 18 io port: [0x40d0-0x40d7]
[    0.224806] pci 0000:00:1f.2: reg 1c io port: [0x40f0-0x40f3]
[    0.224815] pci 0000:00:1f.2: reg 20 io port: [0x4020-0x402f]
[    0.224823] pci 0000:00:1f.2: reg 24 32bit mmio: [0x90405000-0x904053ff]
[    0.224855] pci 0000:00:1f.2: PME# supported from D3hot
[    0.225028] pci 0000:00:1f.2: PME# disabled
[    0.225256] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.225345] pci 0000:01:00.0: reg 10 32bit mmio: [0x80000000-0x87ffffff]
[    0.225357] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.225368] pci 0000:01:00.0: reg 18 32bit mmio: [0x90300000-0x9030ffff]
[    0.225399] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.225442] pci 0000:01:00.0: supports D1 D2
[    0.225475] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.225799] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.225803] pci 0000:00:01.0: bridge 32bit mmio: [0x90300000-0x903fffff]
[    0.225809] pci 0000:00:01.0: bridge 64bit mmio pref: [0x80000000-0x87ffffff]
[    0.225891] pci 0000:02:00.0: reg 10 64bit mmio: [0x90200000-0x90203fff]
[    0.225903] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.225939] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.225996] pci 0000:02:00.0: supports D1 D2
[    0.225998] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.226094] pci 0000:02:00.0: PME# disabled
[    0.226213] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.226464] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.226470] pci 0000:00:1c.0: bridge 32bit mmio: [0x90200000-0x902fffff]
[    0.226557] pci 0000:03:00.0: reg 10 64bit mmio: [0x90100000-0x9010ffff]
[    0.226753] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.226999] pci 0000:00:1c.1: bridge 32bit mmio: [0x90100000-0x901fffff]
[    0.227066] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.227072] pci 0000:00:1c.2: bridge 32bit mmio: [0x8c100000-0x900fffff]
[    0.227081] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x88000000-0x8bffffff]
[    0.227133] pci 0000:0c:03.0: reg 10 32bit mmio: [0x8c000000-0x8c000fff]
[    0.227197] pci 0000:0c:03.0: supports D1 D2
[    0.227200] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.227292] pci 0000:0c:03.0: PME# disabled
[    0.227436] pci 0000:00:1e.0: transparent bridge
[    0.227529] pci 0000:00:1e.0: bridge 32bit mmio: [0x8c000000-0x8c0fffff]
[    0.227566] pci_bus 0000:00: on NUMA node 0
[    0.227575] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.227879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.227996] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.228111] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.228223] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.228349] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.240585] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.240870] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.241678] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.242559] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.243400] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.244331] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.245260] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.246137] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.250158] SCSI subsystem initialized
[    0.250158] libata version 3.00 loaded.
[    0.250158] usbcore: registered new interface driver usbfs
[    0.250158] usbcore: registered new interface driver hub
[    0.250158] usbcore: registered new device driver usb
[    0.250158] ACPI: WMI: Mapper loaded
[    0.250158] PCI: Using ACPI for IRQ routing
[    0.260027] NET: Registered protocol family 23
[    0.260149] Bluetooth: Core ver 2.14
[    0.260252] NET: Registered protocol family 31
[    0.260252] Bluetooth: HCI device and connection manager initialized
[    0.260252] Bluetooth: HCI socket layer initialized
[    0.260272] NetLabel: Initializing
[    0.260355] NetLabel:  domain hash size = 128
[    0.260440] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.260544] NetLabel:  unlabeled traffic allowed by default
[    0.263356] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.263629] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.282737] pnp: PnP ACPI init
[    0.282832] ACPI: bus type pnp registered
[    0.285482] pnp 00:08: io resource (0x1640-0x164f) overlaps 0000:00:1c.2 BAR 7 (0x1000-0x1fff), disabling
[    0.293917] pnp: PnP ACPI: found 10 devices
[    0.294004] ACPI: ACPI bus type pnp unregistered
[    0.294102] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.294195] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.294289] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.294382] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.294476] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.294569] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.294669] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.294767] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.294860] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.294952] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.295044] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.295137] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.330478] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.330569] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.330659] pci 0000:00:01.0:   MEM window: 0x90300000-0x903fffff
[    0.330751] pci 0000:00:01.0:   PREFETCH window: 0x00000080000000-0x00000087ffffff
[    0.330874] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.330965] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.331057] pci 0000:00:1c.0:   MEM window: 0x90200000-0x902fffff
[    0.331150] pci 0000:00:1c.0:   PREFETCH window: 0x00000090500000-0x000000905fffff
[    0.333170] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.333259] pci 0000:00:1c.1:   IO window: disabled
[    0.333383] pci 0000:00:1c.1:   MEM window: 0x90100000-0x901fffff
[    0.333477] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.333570] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.333662] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.333755] pci 0000:00:1c.2:   MEM window: 0x8c100000-0x900fffff
[    0.333848] pci 0000:00:1c.2:   PREFETCH window: 0x00000088000000-0x0000008bffffff
[    0.333975] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.334066] pci 0000:00:1e.0:   IO window: disabled
[    0.334158] pci 0000:00:1e.0:   MEM window: 0x8c000000-0x8c0fffff
[    0.334251] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.334355] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.334449] pci 0000:00:01.0: setting latency timer to 64
[    0.334460] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.334555] pci 0000:00:1c.0: setting latency timer to 64
[    0.334565] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.334660] pci 0000:00:1c.1: setting latency timer to 64
[    0.334671] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.334765] pci 0000:00:1c.2: setting latency timer to 64
[    0.334861] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.334955] pci 0000:00:1e.0: setting latency timer to 64
[    0.334961] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.334964] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.334967] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    0.334970] pci_bus 0000:01: resource 1 mem: [0x90300000-0x903fffff]
[    0.334973] pci_bus 0000:01: resource 2 mem: [0x80000000-0x87ffffff]
[    0.334976] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.334979] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.334982] pci_bus 0000:02: resource 1 mem: [0x90200000-0x902fffff]
[    0.334985] pci_bus 0000:02: resource 2 mem: [0x90500000-0x905fffff]
[    0.334988] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.334991] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.334993] pci_bus 0000:03: resource 1 mem: [0x90100000-0x901fffff]
[    0.334996] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.334999] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.335002] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
[    0.335005] pci_bus 0000:04: resource 1 mem: [0x8c100000-0x900fffff]
[    0.335008] pci_bus 0000:04: resource 2 mem: [0x88000000-0x8bffffff]
[    0.335011] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.335013] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.335016] pci_bus 0000:0c: resource 1 mem: [0x8c000000-0x8c0fffff]
[    0.335019] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.335022] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.335025] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffff]
[    0.335086] NET: Registered protocol family 2
[    0.393427] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.393929] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.394739] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.396029] TCP: Hash tables configured (established 131072 bind 65536)
[    0.396125] TCP reno registered
[    0.413478] NET: Registered protocol family 1
[    0.413752] checking if image is initramfs... it is
[    0.690538] Freeing initrd memory: 3397k freed
[    0.692982] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.693700] audit: initializing netlink socket (disabled)
[    0.693806] type=2000 audit(1235070753.690:1): initialized
[    0.698609] highmem bounce pool size: 64 pages
[    0.698699] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.703396] VFS: Disk quotas dquot_6.5.2
[    0.703527] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.704047] NTFS driver 2.1.29 [Flags: R/O].
[    0.704175] fuse init (API version 7.11)
[    0.704404] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.708367] msgmni has been set to 1701
[    0.708594] SELinux:  Registering netfilter hooks
[    0.708782] alg: No test for cipher_null (cipher_null-generic)
[    0.708971] alg: No test for digest_null (digest_null-generic)
[    0.709103] alg: No test for compress_null (compress_null-generic)
[    0.710693] alg: No test for fcrypt (fcrypt-generic)
[    0.713278] alg: No test for stdrng (krng)
[    0.713528] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.713650] io scheduler noop registered
[    0.713735] io scheduler anticipatory registered
[    0.713821] io scheduler deadline registered
[    0.713928] io scheduler cfq registered (default)
[    0.714254] pci 0000:01:00.0: Boot video device
[    0.714420] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.714479] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.714666] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.714748] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.715023] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.715104] pcieport-driver 0000:00:1c.1: irq 26 for MSI/MSI-X
[    0.715375] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.715456] pcieport-driver 0000:00:1c.2: irq 27 for MSI/MSI-X
[    0.715843] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.716868] pciehp 0000:00:1c.0:pcie02: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
[    0.717121] pciehp 0000:00:1c.0:pcie02: service driver pciehp loaded
[    0.717147] pciehp 0000:00:1c.1:pcie02: HPC vendor_id 8086 device_id 27d2 ss_vid 0 ss_did 0
[    0.717389] pciehp 0000:00:1c.1:pcie02: service driver pciehp loaded
[    0.717416] pciehp 0000:00:1c.2:pcie02: HPC vendor_id 8086 device_id 27d4 ss_vid 0 ss_did 0
[    0.717687] pciehp 0000:00:1c.2:pcie02: service driver pciehp loaded
[    0.717746] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.717838] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.725297] decode_hpp: Could not get hotplug parameters. Use defaults
[    0.725442] acpiphp_glue: Slot 3 already registered by another hotplug driver
[    0.733389] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    0.733480] fakephp: Fake PCI Hot Plug Controller Driver
[    0.734135] fakephp: pci_hp_register failed with error -16
[    0.734227] fakephp: pci_hp_register failed with error -16
[    0.734764] ACPI: AC Adapter [ADP1] (on-line)
[    0.930439] ACPI: Battery Slot [BAT0] (battery present)
[    0.930739] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.930861] ACPI: Power Button (FF) [PWRF]
[    0.931071] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.931250] ACPI: Lid Switch [LID0]
[    0.931453] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    0.931576] ACPI: Power Button (CM) [PWRB]
[    0.931780] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    0.931903] ACPI: Sleep Button (CM) [SLPB]
[    0.933001] ACPI: SSDT 7FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[    0.933630] ACPI: SSDT 7FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[    0.934333] Monitor-Mwait will be used to enter C-1 state
[    0.934349] Monitor-Mwait will be used to enter C-2 state
[    0.934363] Monitor-Mwait will be used to enter C-3 state
[    0.934449] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.934819] processor ACPI_CPU:00: registered as cooling_device0
[    0.934913] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.935571] ACPI: SSDT 7FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[    0.936172] ACPI: SSDT 7FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[    0.937013] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    0.937373] processor ACPI_CPU:01: registered as cooling_device1
[    0.937466] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.994749] Non-volatile memory driver v1.3
[    0.995018] intel_rng: FWH not detected
[    0.995140] Linux agpgart interface v0.103
[    0.995389] ipmi message handler version 39.2
[    0.995480] ipmi device interface
[    0.995685] IPMI System Interface driver.
[    1.114316] ipmi_si: Unable to find any System Interface(s)
[    1.114408] IPMI Watchdog: driver initialized
[    1.114493] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    1.114625] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    1.114748] Hangcheck: Using get_cycles().
[    1.114846] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
[    1.114984] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    1.115397] [drm] Initialized drm 1.1.0 20060810
[    1.116200] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.116294] pci 0000:01:00.0: setting latency timer to 64
[    1.116452] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[    1.119306] brd: module loaded
[    1.120676] loop: module loaded
[    1.120922] sky2 driver version 1.22
[    1.121037] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.121136] sky2 0000:02:00.0: setting latency timer to 64
[    1.121162] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    1.153463] sky2 0000:02:00.0: Marvell Yukon 88E8053 Gigabit Ethernet Controller
[    1.153583]  Part Number: Yukon 88E8053
[    1.153585]  Engineering Level: Rev. 2.2
[    1.153587]  Manufacturer: Marvell
[    1.153661] sky2 0000:02:00.0: irq 28 for MSI/MSI-X
[    1.154147] sky2 eth0: addr 00:16:cb:8c:b2:65
[    1.154332] PPP generic driver version 2.4.2
[    1.154575] PPP Deflate Compression module registered
[    1.155851] PPP MPPE Compression module registered
[    1.155940] NET: Registered protocol family 24
[    1.156037] PPPoL2TP kernel driver, V1.0
[    1.157239] tun: Universal TUN/TAP device driver, 1.6
[    1.157327] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.157561] usbcore: registered new interface driver cdc_ether
[    1.157714] usbcore: registered new interface driver rndis_host
[    1.157872] usbcore: registered new interface driver rndis_wlan
[    1.157987] console [netcon0] enabled
[    1.158071] netconsole: network logging started
[    1.158157] Linux video capture interface: v2.00
[    1.158403] input: Macintosh mouse button emulation as /devices/virtual/input/input4
[    1.158825] Driver 'sd' needs updating - please use bus_type methods
[    1.158973] Driver 'sr' needs updating - please use bus_type methods
[    1.159175] SCSI Media Changer driver v0.25 
[    1.159317] Driver 'ch' needs updating - please use bus_type methods
[    1.159564] ata_piix 0000:00:1f.1: version 2.12
[    1.159651] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    1.159748] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.159884] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.160061] scsi0 : ata_piix
[    1.162244] scsi1 : ata_piix
[    1.163163] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40c0 irq 14
[    1.163257] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40c8 irq 15
[    1.323941] ata1.00: ATAPI: MATSHITADVD-R   UJ-857, HAEA, max UDMA/66
[    1.337231] ata1.00: configured for UDMA/66
[    1.339235] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   HAEA PQ: 0 ANSI: 5
[    1.341093] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.341186] Uniform CD-ROM driver Revision: 3.20
[    1.341532] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.341701] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.504627] ata_piix 0000:00:1f.2: enabling device (0005 -> 0007)
[    1.504725] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.504821] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.656694] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.656805] scsi2 : ata_piix
[    1.657075] scsi3 : ata_piix
[    1.658636] ata3: SATA max UDMA/133 cmd 0x40d8 ctl 0x40f4 bmdma 0x4020 irq 19
[    1.658731] ata4: SATA max UDMA/133 cmd 0x40d0 ctl 0x40f0 bmdma 0x4028 irq 19
[    2.157997] ata3.01: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
[    2.158091] ata3.01: 312581808 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    2.210562] ata3.01: configured for UDMA/133
[    2.223429] scsi 2:0:1:0: Direct-Access     ATA      WDC WD1600BEVS-0 04.0 PQ: 0 ANSI: 5
[    2.223834] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.223975] sd 2:0:1:0: [sda] Write Protect is off
[    2.224063] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.224102] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.224303] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    2.224443] sd 2:0:1:0: [sda] Write Protect is off
[    2.224531] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.224569] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.224694]  sda: sda1 sda2 sda3 sda4 sda5
[    2.272393] sd 2:0:1:0: [sda] Attached SCSI disk
[    2.272641] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    2.434835] firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.500019] firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI version 1.0
[    2.500420] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.500533] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.500637] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.500642] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.500923] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.504950] ehci_hcd 0000:00:1d.7: debug port 1
[    2.505042] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.505101] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x90405400
[    2.516683] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.516805] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.516898] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.517017] usb usb1: Product: EHCI Host Controller
[    2.517104] usb usb1: Manufacturer: Linux 2.6.29-rc4-rt2-tip ehci_hcd
[    2.517195] usb usb1: SerialNumber: 0000:00:1d.7
[    2.517413] usb usb1: configuration #1 chosen from 1 choice
[    2.517600] hub 1-0:1.0: USB hub found
[    2.517693] hub 1-0:1.0: 8 ports detected
[    2.518169] uhci_hcd: USB Universal Host Controller Interface driver
[    2.518293] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.518391] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.518396] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.518668] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.518818] uhci_hcd 0000:00:1d.0: irq 23, io base 0x000040a0
[    2.518949] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.519042] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.519161] usb usb2: Product: UHCI Host Controller
[    2.519249] usb usb2: Manufacturer: Linux 2.6.29-rc4-rt2-tip uhci_hcd
[    2.519341] usb usb2: SerialNumber: 0000:00:1d.0
[    2.519550] usb usb2: configuration #1 chosen from 1 choice
[    2.519743] hub 2-0:1.0: USB hub found
[    2.519834] hub 2-0:1.0: 2 ports detected
[    2.520153] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.520252] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.520256] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.520528] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.520680] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004080
[    2.520816] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    2.520909] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.521030] usb usb3: Product: UHCI Host Controller
[    2.521117] usb usb3: Manufacturer: Linux 2.6.29-rc4-rt2-tip uhci_hcd
[    2.521208] usb usb3: SerialNumber: 0000:00:1d.1
[    2.521413] usb usb3: configuration #1 chosen from 1 choice
[    2.521600] hub 3-0:1.0: USB hub found
[    2.521694] hub 3-0:1.0: 2 ports detected
[    2.522005] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.522104] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.522108] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.522384] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.522578] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004060
[    2.522708] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.522800] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.522920] usb usb4: Product: UHCI Host Controller
[    2.523006] usb usb4: Manufacturer: Linux 2.6.29-rc4-rt2-tip uhci_hcd
[    2.523097] usb usb4: SerialNumber: 0000:00:1d.2
[    2.523296] usb usb4: configuration #1 chosen from 1 choice
[    2.523486] hub 4-0:1.0: USB hub found
[    2.523578] hub 4-0:1.0: 2 ports detected
[    2.523859] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    2.523956] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.523960] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.524212] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.524406] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004040
[    2.524543] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.524635] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.524754] usb usb5: Product: UHCI Host Controller
[    2.524841] usb usb5: Manufacturer: Linux 2.6.29-rc4-rt2-tip uhci_hcd
[    2.524932] usb usb5: SerialNumber: 0000:00:1d.3
[    2.525126] usb usb5: configuration #1 chosen from 1 choice
[    2.525293] hub 5-0:1.0: USB hub found
[    2.525384] hub 5-0:1.0: 2 ports detected
[    2.525796] usbcore: registered new interface driver cdc_acm
[    2.525888] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    2.526075] usbcore: registered new interface driver usblp
[    2.526165] Initializing USB Mass Storage driver...
[    2.526344] usbcore: registered new interface driver usb-storage
[    2.526435] USB Mass Storage support registered.
[    2.526621] usbcore: registered new interface driver appledisplay
[    2.526994] PNP: No PS/2 controller found. Probing ports directly.
[    2.527968] i8042.c: No controller found.
[    2.540928] mice: PS/2 mouse device common for all mice
[    2.616918] usbcore: registered new interface driver appletouch
[    2.617086] usbcore: registered new interface driver bcm5974
[    2.617294] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    2.644324] I2O subsystem v1.325
[    2.644408] i2o: max drivers = 8
[    2.650182] I2O Configuration OSM v1.323
[    2.650406] I2O Bus Adapter OSM v1.317
[    2.650562] I2O Block Device OSM v1.325
[    2.653445] I2O SCSI Peripheral OSM v1.316
[    2.653594] I2O ProcFS OSM v1.316
[    2.653780] rtc_cmos 00:09: RTC can wake from S4
[    2.653960] rtc_cmos 00:09: rtc core: registered rtc_cmos as rtc0
[    2.654116] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    2.654271] i2c /dev entries driver
[    2.654504] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    2.654626] ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts with ACPI region SMBI [0xefa0-0xefaf]
[    2.654751] ACPI: Device needs an ACPI driver
[    2.655221] applesmc: Apple MacBook Pro detected:
[    2.655308] applesmc:  - Model with accelerometer
[    2.657299] applesmc:  - Model with light sensors and backlight
[    2.657389] applesmc:  - Model with 12 temperature sensors
[    2.658238] applesmc: device has already been initialized (0xe0, 0x00).
[    2.658241] applesmc: device successfully initialized.
[    2.659135] applesmc: 2 fans found.
[    2.660831] input: applesmc as /devices/platform/applesmc.768/input/input6
[    2.690200] Registered led device: smc::kbd_backlight
[    2.690363] applesmc: driver successfully loaded.
[    2.690829] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.04
[    2.691094] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Version=2, TCOBASE=0x0460)
[    2.691310] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.691449] device-mapper: uevent: version 1.0.3
[    2.691657] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.700091] device-mapper: multipath: version 1.0.5 loaded
[    2.700181] device-mapper: multipath round-robin: version 1.0.0 loaded
[    2.700346] Bluetooth: Generic Bluetooth USB driver ver 0.4
[    2.700511] usbcore: registered new interface driver btusb
[    2.703900] cpuidle: using governor ladder
[    2.704992] cpuidle: using governor menu
[    2.705263] Marking TSC unstable due to TSC halts in idle
[    2.706596] usbcore: registered new interface driver usbhid
[    2.706710] usbhid: v2.6:USB HID core driver
[    2.707034] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    2.708678] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.708884] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    2.738942] hda_codec: STAC922x, Apple subsys_id=106b0200
[    2.774442] input: HDA Intel at 0x90400000 irq 22 Line In at Ext Rear Jack as /devices/pci0000:00/0000:00:1b.0/input/input7
[    2.793824] input: HDA Intel at 0x90400000 irq 22 HP Out at Ext Rear Jack as /devices/pci0000:00/0000:00:1b.0/input/input8
[    2.801749] ALSA device list:
[    2.801834]   #0: Dummy 1
[    2.801914]   #1: Virtual MIDI Card 1
[    2.801999]   #2: HDA Intel at 0x90400000 irq 22
[    2.802226] oprofile: using NMI interrupt.
[    2.802350] GACT probability on
[    2.802434] Mirror/redirect action on
[    2.802518] Simple TC action Loaded
[    2.803038] netem: version 1.2
[    2.803122] u32 classifier
[    2.803203]     Performance counters on
[    2.803286]     input device check on 
[    2.803392]     Actions configured 
[    2.804015] IPv4 over IPv4 tunneling driver
[    2.804578] GRE over IPv4 tunneling driver
[    2.805188] TCP cubic registered
[    2.805272] Initializing XFRM netlink socket
[    2.805428] NET: Registered protocol family 10
[    2.806279] lo: Disabled Privacy Extensions
[    2.809108] tunl0: Disabled Privacy Extensions
[    2.810486] NET: Registered protocol family 17
[    2.810579] NET: Registered protocol family 15
[    2.810747] Bridge firewalling registered
[    2.810863] irlan0 (): not using net_device_ops yet
[    2.812234] IrCOMM protocol (Dag Brattli)
[    2.814862] Bluetooth: L2CAP ver 2.11
[    2.814947] Bluetooth: L2CAP socket layer initialized
[    2.815036] Bluetooth: SCO (Voice Link) ver 0.6
[    2.815122] Bluetooth: SCO socket layer initialized
[    2.815268] Bluetooth: RFCOMM socket layer initialized
[    2.815362] Bluetooth: RFCOMM TTY layer initialized
[    2.815450] Bluetooth: RFCOMM ver 1.10
[    2.815534] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    2.815623] Bluetooth: BNEP filters: protocol multicast
[    2.815712] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    2.815883] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.815976] All bugs added by David S. Miller <davem@redhat.com>
[    2.820471] CCID: Activated CCID 2 (TCP-like)
[    2.820588] CCID: Activated CCID 3 (TCP-Friendly Rate Control)
[    2.830366] SCTP: Hash tables configured (established 52428 bind 65536)
[    2.847663] lib80211: common routines for IEEE802.11 drivers
[    2.847773] lib80211_crypt: registered algorithm 'NULL'
[    2.847779] TIPC: Activated (version 1.6.4 compiled Feb 19 2009 16:57:08)
[    2.848303] NET: Registered protocol family 30
[    2.848392] TIPC: Started in single node mode
[    2.848479] Using IPI No-Shortcut mode
[    2.852277] registered taskstats version 1
[    2.852575] rtc_cmos 00:09: setting system clock to 2009-02-19 19:12:36 UTC (1235070756)
[    2.852698] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    2.853227] Freeing unused kernel memory: 420k freed
[    2.853406] Write protecting the kernel text: 5828k
[    2.853607] Write protecting the kernel read-only data: 2500k
[    2.930078] usb 1-3: new high speed USB device using ehci_hcd and address 3
[    3.000385] firewire_core: created device fw0: GUID 0016cbfffe4c8a54, S400
[    3.056174] usb 1-3: New USB device found, idVendor=090c, idProduct=1000
[    3.056288] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.056402] usb 1-3: Product: Flash Voyager
[    3.056503] usb 1-3: Manufacturer: Corsair
[    3.056602] usb 1-3: SerialNumber: A400000000028713
[    3.056880] usb 1-3: configuration #1 chosen from 1 choice
[    3.057694] scsi4 : SCSI emulation for USB Mass Storage devices
[    3.058040] usb-storage: device found at 3
[    3.058043] usb-storage: waiting for device to settle before scanning
[    3.163409] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    3.287174] usb 1-4: New USB device found, idVendor=05ac, idProduct=8300
[    3.287289] usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.287643] usb 1-4: configuration #1 chosen from 1 choice
[    3.726729] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    3.905036] usb 2-2: New USB device found, idVendor=05ac, idProduct=0218
[    3.905180] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.905293] usb 2-2: Product: Apple Internal Keyboard / Trackpad
[    3.905410] usb 2-2: Manufacturer: Apple Computer
[    3.905599] usb 2-2: configuration #1 chosen from 1 choice
[    3.913573] input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input9
[    3.934384] apple 0003:05AC:0218.0001: input,hidraw0: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
[    3.939034] appletouch: Geyser mode initialized.
[    3.939256] input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input10
[    3.970172] input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input11
[    3.991080] apple 0003:05AC:0218.0002: input,hidraw1: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
[    4.000097] Clocksource tsc unstable (delta = -277709176 ns)
[    4.216788] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    4.388806] usb 4-2: New USB device found, idVendor=05ac, idProduct=8240
[    4.388920] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.389033] usb 4-2: Product: IR Receiver
[    4.389132] usb 4-2: Manufacturer: Apple Computer, Inc.
[    4.389304] usb 4-2: configuration #1 chosen from 1 choice
[    4.396877] generic-usb 0003:05AC:8240.0003: hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    4.623456] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    4.793665] usb 5-1: New USB device found, idVendor=05ac, idProduct=1000
[    4.793778] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.793950] usb 5-1: configuration #1 chosen from 1 choice
[    4.814124] input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input12
[    4.834332] generic-usb 0003:05AC:1000.0004: input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[    4.850127] input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input13
[    4.871070] generic-usb 0003:05AC:1000.0005: input,hidraw4: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[    8.057172] usb-storage: device scan complete
[    8.058235] scsi 4:0:0:0: Direct-Access     Corsair  Flash Voyager    1100 PQ: 0 ANSI: 0 CCS
[    8.059814] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors: (4.06 GB/3.78 GiB)
[    8.060721] sd 4:0:0:0: [sdb] Write Protect is off
[    8.060833] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    8.060836] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    8.063853] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors: (4.06 GB/3.78 GiB)
[    8.064826] sd 4:0:0:0: [sdb] Write Protect is off
[    8.064932] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    8.064937] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    8.065050]  sdb: sdb1
[    8.066233] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    8.066398] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   13.169831] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
[   13.169957] in_atomic(): 0, irqs_disabled(): 1, pid: 1030, name: cryptsetup
[   13.170075] Pid: 1030, comm: cryptsetup Tainted: G        W  2.6.29-rc4-rt2-tip #54
[   13.170196] Call Trace:
[   13.170284]  [<c0444cdd>] __might_sleep+0xda/0xf0
[   13.170374]  [<c043ee55>] kmap+0x50/0x77
[   13.170460]  [<c043db3b>] gup_pte_range+0x4b/0xe9
[   13.170548]  [<c043dcb7>] get_user_pages_fast+0xde/0x17f
[   13.170639]  [<c04f75f1>] dio_get_page+0x59/0x124
[   13.170729]  [<c04f8258>] __blockdev_direct_IO+0x4ad/0xabe
[   13.170819]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
[   13.170837]  [<c04f730a>] blkdev_direct_IO+0x3f/0x55
[   13.170837]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
[   13.170837]  [<c04a977a>] generic_file_aio_read+0xfd/0x587
[   13.170837]  [<c05ff445>] ? avc_has_perm+0x56/0x71
[   13.170837]  [<c04d0fcf>] do_sync_read+0xc6/0x118
[   13.170837]  [<c0467414>] ? autoremove_wake_function+0x0/0x54
[   13.170837]  [<c06046d6>] ? selinux_file_permission+0x119/0x132
[   13.170837]  [<c05fa4dc>] ? security_file_permission+0x1e/0x31
[   13.170837]  [<c04d0f09>] ? do_sync_read+0x0/0x118
[   13.170837]  [<c04d1b61>] vfs_read+0x99/0x14e
[   13.170837]  [<c04d1cf7>] sys_read+0x50/0x87
[   13.170837]  [<c0420086>] sysenter_do_call+0x12/0x21
[   14.796047] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
[   14.796177] in_atomic(): 0, irqs_disabled(): 1, pid: 1045, name: cryptsetup
[   14.796273] Pid: 1045, comm: cryptsetup Tainted: G        W  2.6.29-rc4-rt2-tip #54
[   14.796394] Call Trace:
[   14.796485]  [<c0444cdd>] __might_sleep+0xda/0xf0
[   14.796573]  [<c043ee55>] kmap+0x50/0x77
[   14.796660]  [<c043db3b>] gup_pte_range+0x4b/0xe9
[   14.796671]  [<c043dcb7>] get_user_pages_fast+0xde/0x17f
[   14.796671]  [<c04f75f1>] dio_get_page+0x59/0x124
[   14.796671]  [<c04f8258>] __blockdev_direct_IO+0x4ad/0xabe
[   14.796671]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
[   14.796671]  [<c04f730a>] blkdev_direct_IO+0x3f/0x55
[   14.796671]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
[   14.796671]  [<c04a977a>] generic_file_aio_read+0xfd/0x587
[   14.796671]  [<c05ff445>] ? avc_has_perm+0x56/0x71
[   14.796671]  [<c04d0fcf>] do_sync_read+0xc6/0x118
[   14.796671]  [<c0467414>] ? autoremove_wake_function+0x0/0x54
[   14.796671]  [<c06046d6>] ? selinux_file_permission+0x119/0x132
[   14.796671]  [<c05fa4dc>] ? security_file_permission+0x1e/0x31
[   14.796671]  [<c04d0f09>] ? do_sync_read+0x0/0x118
[   14.796671]  [<c04d1b61>] vfs_read+0x99/0x14e
[   14.796671]  [<c04d1cf7>] sys_read+0x50/0x87
[   14.796671]  [<c0420086>] sysenter_do_call+0x12/0x21
[   17.837434] EXT3-fs: mounted filesystem with ordered data mode.
[   17.837844] kjournald starting.  Commit interval 5 seconds
[   17.966524] SELinux:  Disabled at runtime.
[   17.966629] SELinux:  Unregistering netfilter hooks
[   18.056792] type=1404 audit(1235070771.704:2): selinux=0 auid=4294967295 ses=4294967295
[   21.276574] udevd version 127 started
[   21.795981] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
[   21.795986] in_atomic(): 0, irqs_disabled(): 1, pid: 1374, name: cdrom_id
[   21.795990] Pid: 1374, comm: cdrom_id Tainted: G        W  2.6.29-rc4-rt2-tip #54
[   21.795993] Call Trace:
[   21.796003]  [<c0444cdd>] __might_sleep+0xda/0xf0
[   21.796007]  [<c043ee55>] kmap+0x50/0x77
[   21.796011]  [<c043db3b>] gup_pte_range+0x4b/0xe9
[   21.796015]  [<c043dcb7>] get_user_pages_fast+0xde/0x17f
[   21.796020]  [<c04f5505>] bio_map_user_iov+0x120/0x220
[   21.796024]  [<c04f5631>] bio_map_user+0x2c/0x42
[   21.796029]  [<c064fe04>] blk_rq_map_user+0xe2/0x1f2
[   21.796034]  [<c045a6ad>] ? capable+0x2d/0x5a
[   21.796039]  [<c065344a>] sg_io+0x1d5/0x32d
[   21.796045]  [<c04cd348>] ? kfree+0x84/0x9a
[   21.796049]  [<c0653adb>] scsi_cmd_ioctl+0x24f/0x4a4
[   21.796054]  [<c078f6ed>] ? cdrom_open+0x84b/0x8c3
[   21.796058]  [<c04f52a1>] ? bio_add_page+0x38/0x50
[   21.796062]  [<c078e185>] cdrom_ioctl+0x3e/0xd5b
[   21.796066]  [<c0444e4e>] ? update_curr+0x9c/0x1b7
[   21.796072]  [<c09aabd9>] ? rt_spin_lock+0x32/0x79
[   21.796077]  [<c04b94fe>] ? page_address+0x95/0xcb
[   21.796082]  [<c0765f9e>] sr_block_ioctl+0x4f/0x94
[   21.796086]  [<c065107d>] __blkdev_driver_ioctl+0x65/0x88
[   21.796090]  [<c0651b12>] blkdev_ioctl+0xa2b/0xa65
[   21.796095]  [<c065bafc>] ? kobject_get+0x20/0x37
[   21.796099]  [<c0652230>] ? get_disk+0x7e/0xa8
[   21.796103]  [<c09aabd9>] ? rt_spin_lock+0x32/0x79
[   21.796107]  [<c04b94fe>] ? page_address+0x95/0xcb
[   21.796111]  [<c04b9b51>] ? kmap_high+0x3f9/0x40f
[   21.796115]  [<c0478126>] ? rt_up+0x3a/0x61
[   21.796119]  [<c09ab92d>] ? unlock_kernel+0x34/0x47
[   21.796123]  [<c04a7eb7>] ? find_get_page+0x84/0xab
[   21.796127]  [<c044aad5>] ? __wake_up+0x3b/0x56
[   21.796131]  [<c04b95db>] ? kunmap_high+0xa7/0xbb
[   21.796135]  [<c04f6137>] block_ioctl+0x3f/0x58
[   21.796139]  [<c04f60f8>] ? block_ioctl+0x0/0x58
[   21.796143]  [<c04dde0c>] vfs_ioctl+0x2d/0x85
[   21.796146]  [<c04de412>] do_vfs_ioctl+0x4b5/0x501
[   21.796151]  [<c04bc25a>] ? handle_mm_fault+0x2d3/0x699
[   21.796155]  [<c04de4b5>] sys_ioctl+0x57/0x82
[   21.796159]  [<c0420086>] sysenter_do_call+0x12/0x21
[   23.427669] cfg80211: Calling CRDA to update world regulatory domain
[   24.409852] cfg80211: World regulatory domain updated:
[   24.409857] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   24.409861] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   24.741209] ath5k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   24.741226] ath5k 0000:03:00.0: setting latency timer to 64
[   24.741352] ath5k 0000:03:00.0: registered as 'phy0'
[   24.895180] wmaster0 (ath5k): not using net_device_ops yet
[   24.896728] phy0: Selected rate control algorithm 'minstrel'
[   24.896795] wlan0 (ath5k): not using net_device_ops yet
[   24.898345] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa3, PHY: 0x61)
[   25.937648] BUG: sleeping function called from invalid context at arch/x86/mm/highmem_32.c:8
[   25.937657] in_atomic(): 0, irqs_disabled(): 1, pid: 2075, name: lvm
[   25.937664] Pid: 2075, comm: lvm Tainted: G        W  2.6.29-rc4-rt2-tip #54
[   25.937670] Call Trace:
[   25.937683]  [<c0444cdd>] __might_sleep+0xda/0xf0
[   25.937691]  [<c043ee55>] kmap+0x50/0x77
[   25.937697]  [<c043db3b>] gup_pte_range+0x4b/0xe9
[   25.937705]  [<c043dcb7>] get_user_pages_fast+0xde/0x17f
[   25.937713]  [<c04f75f1>] dio_get_page+0x59/0x124
[   25.937721]  [<c04f8258>] __blockdev_direct_IO+0x4ad/0xabe
[   25.937728]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
[   25.937738]  [<c065bafc>] ? kobject_get+0x20/0x37
[   25.937746]  [<c0652230>] ? get_disk+0x7e/0xa8
[   25.937753]  [<c04f730a>] blkdev_direct_IO+0x3f/0x55
[   25.937760]  [<c04f5cdb>] ? blkdev_get_blocks+0x0/0x11c
[   25.937768]  [<c04a977a>] generic_file_aio_read+0xfd/0x587
[   25.937775]  [<c04f712c>] ? blkdev_open+0x71/0xaf
[   25.937785]  [<c04cf51f>] ? __dentry_open+0x193/0x276
[   25.937792]  [<c04d0fcf>] do_sync_read+0xc6/0x118
[   25.937801]  [<c0467414>] ? autoremove_wake_function+0x0/0x54
[   25.937811]  [<c09aa5cb>] ? rt_mutex_lock+0x23/0x5c
[   25.937819]  [<c09aacf2>] ? _mutex_unlock+0x17/0x2a
[   25.937828]  [<c05fa4dc>] ? security_file_permission+0x1e/0x31
[   25.937835]  [<c04d0f09>] ? do_sync_read+0x0/0x118
[   25.937841]  [<c04d1b61>] vfs_read+0x99/0x14e
[   25.937848]  [<c04d1cf7>] sys_read+0x50/0x87
[   25.937855]  [<c0420086>] sysenter_do_call+0x12/0x21
[   26.904618] EXT3 FS on dm-0, internal journal
[   27.017853] kjournald starting.  Commit interval 5 seconds
[   27.018257] EXT3 FS on sda3, internal journal
[   27.018268] EXT3-fs: mounted filesystem with ordered data mode.
[   46.073402] usb 2-1: new low speed USB device using uhci_hcd and address 3
[   46.245423] usb 2-1: New USB device found, idVendor=413c, idProduct=2003
[   46.245431] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   46.245437] usb 2-1: Product: DELL USB Keyboard
[   46.245441] usb 2-1: Manufacturer: DELL
[   46.245633] usb 2-1: configuration #1 chosen from 1 choice
[   46.263774] input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input14
[   46.281111] generic-usb 0003:413C:2003.0006: input,hidraw5: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:1d.0-1/input0
[   46.309496] input: DELL DELL USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.1/input/input15
[   46.331110] generic-usb 0003:413C:2003.0007: input,hidraw6: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:1d.0-1/input1


Belonging config is:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.29-rc4-rt2
# Thu Feb 19 16:26:17 2009
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
CONFIG_RWSEM_GENERIC_SPINLOCK=y
CONFIG_ASM_SEMAPHORES=y
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
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
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
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
# CONFIG_CLASSIC_RCU is not set
# CONFIG_TREE_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
# CONFIG_NET_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=y
# CONFIG_OPROFILE_IBS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_PROFILE_NMI=y
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
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
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
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_32_NON_STANDARD is not set
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
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
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
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
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
CONFIG_X86_DS=y
CONFIG_X86_PTRACE_BTS=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT_DESKTOP is not set
CONFIG_PREEMPT_RT=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_NONFATAL is not set
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
CONFIG_ILLEGAL_POINTER_VALUE=0
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
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW_64K=y
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
# CONFIG_KEXEC_JUMP is not set
CONFIG_PHYSICAL_START=0x400000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x400000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HARDIRQS_SW_RESEND=y

#
# Power management and ACPI options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_PM_TEST_SUSPEND=y
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
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=1999
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
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
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
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
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
# CONFIG_HOTPLUG_PCI_IBM is not set
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_COMPAT_NET_DEV_OPS=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
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
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
# CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT is not set
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
# CONFIG_IP_VS_IPV6 is not set
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
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
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
# CONFIG_BRIDGE_EBT_NFLOG is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=y
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=y
CONFIG_NET_EMATCH_NBYTE=y
CONFIG_NET_EMATCH_U32=y
CONFIG_NET_EMATCH_META=y
CONFIG_NET_EMATCH_TEXT=y
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=y
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRNET is not set
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
# CONFIG_MCS_FIR is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=y
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIVHCI is not set
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
CONFIG_LIB80211=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y

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
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
CONFIG_MTD_PARTITIONS=y
# CONFIG_MTD_TESTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_AR7_PARTS is not set

#
# User Modules And Translation Layers
#
# CONFIG_MTD_CHAR is not set
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_CAFE=m
CONFIG_MTD_NAND_CS553X=m
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=m
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
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
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
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
CONFIG_ATA_GENERIC=y
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
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
CONFIG_DM_DELAY=y
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
# CONFIG_FIREWIRE_SBP2 is not set
# CONFIG_IEEE1394 is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=y
CONFIG_DUMMY=y
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=y
CONFIG_VETH=m
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
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
CONFIG_SKY2=y
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
CONFIG_USB_NET_RNDIS_WLAN=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_P54_COMMON is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH9K is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLCORE is not set
# CONFIG_IWLWIFI_LEDS is not set
# CONFIG_IWLAGN is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set

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
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_HSO is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOL2TP=y
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
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
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_ZHENHUA is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set

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
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_WATCHDOG=y
CONFIG_IPMI_POWEROFF=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
# CONFIG_TCG_TIS is not set
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
CONFIG_TCG_INFINEON=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

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
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
CONFIG_I2C_PIIX4=y
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
CONFIG_HWMON=y
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
# CONFIG_SENSORS_ADT7475 is not set
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
CONFIG_SENSORS_CORETEMP=y
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
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
CONFIG_SENSORS_APPLESMC=y
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=y
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
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
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_REGULATOR is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
# CONFIG_VIDEO_ALLOW_V4L1 is not set
CONFIG_VIDEO_V4L1_COMPAT=y
# CONFIG_DVB_CORE is not set
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_VIDEO_V4L2=y
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
# CONFIG_FB_CFB_FILLRECT is not set
# CONFIG_FB_CFB_COPYAREA is not set
# CONFIG_FB_CFB_IMAGEBLIT is not set
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
CONFIG_SND_DUMMY=y
CONFIG_SND_VIRMIDI=y
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
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
# CONFIG_SND_HDA_RECONFIG is not set
CONFIG_SND_HDA_INPUT_BEEP=y
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
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
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
# CONFIG_SND_USB is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_COMPAT=y
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
# CONFIG_USB_DEVICE_CLASS is not set
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
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
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
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_LIBUSUAL is not set

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
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
# CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

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
CONFIG_RTC_DRV_CMOS=y
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
# CONFIG_DMADEVICES is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_HP_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
CONFIG_ACPI_WMI=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
# CONFIG_EXT4DEV_COMPAT is not set
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
# CONFIG_NTFS_RW is not set

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
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
CONFIG_HFSPLUS_FS=y
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_UBIFS_FS is not set
# CONFIG_CRAMFS is not set
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
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
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
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ALLOW_WARNINGS=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
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
CONFIG_HAVE_HW_BRANCH_TRACER=y
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
# CONFIG_CONTEXT_SWITCH_TRACER is not set
# CONFIG_BOOT_TRACER is not set
# CONFIG_TRACE_BRANCH_PROFILING is not set
# CONFIG_POWER_TRACER is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_HW_BRANCH_TRACER is not set
# CONFIG_KMEMTRACE is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
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
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_TRACE is not set
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y


