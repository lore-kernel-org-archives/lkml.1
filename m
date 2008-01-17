Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbYAQNw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbYAQNw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYAQNwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:52:18 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:43913 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYAQNwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:52:16 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: bugreport kernel panic on early stage, with HIGHMEM4G:
Date: Thu, 17 Jan 2008 15:31:51 +0200
Message-Id: <20080117133029.M23459@visp.net.lb>
In-Reply-To: <20080115113947.GA14603@elte.hu>
References: <20080107053908.M5584@visp.net.lb> <20080115113947.GA14603@elte.hu>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fixes the problem.
Here is dmesg (i cut it, probably remaining part of it not required).
0]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT CFEFD038, 0050 (r1 INTEL  DG965SS       6B7       
1000013)
[    0.000000] ACPI: FACP CFEFC000, 0074 (r1 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: DSDT CFEF7000, 41AA (r1 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: FACS CFE9C000, 0040
[    0.000000] ACPI: APIC CFEF6000, 0078 (r1 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: WDDT CFEF5000, 0040 (r1 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: MCFG CFEF4000, 003C (r1 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: ASF! CFEF3000, 00A6 (r32 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: HPET CFEF2000, 0038 (r1 INTEL  DG965SS       6B7 MSFT  
1000013)
[    0.000000] ACPI: SSDT CFE9A000, 020C (r1 INTEL     CpuPm      6B7 MSFT  
1000013)
[    0.000000] ACPI: SSDT CFE99000, 0175 (r1 INTEL   Cpu0Ist      6B7 MSFT  
1000013)
[    0.000000] ACPI: SSDT CFE98000, 0175 (r1 INTEL   Cpu1Ist      6B7 MSFT  
1000013)
[    0.000000] ACPI: SSDT CFE97000, 0175 (r1 INTEL   Cpu2Ist      6B7 MSFT  
1000013)
[    0.000000] ACPI: SSDT CFE96000, 0175 (r1 INTEL   Cpu3Ist      6B7 MSFT  
1000013)
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d4000000 (gap: 
d0000000:2ff00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 1040384
[    0.000000] Kernel command line: root=/dev/sdb2
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2397.647 MHz processor.
[   23.770446] Console: colour VGA+ 80x25
[   23.770448] console [tty0] enabled
[   23.779138] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[   23.779395] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   23.788992] set_highmem_pages_init(bad_ppro:0)
[   23.789056] sizeof(struct page):        32
[   23.789118] sizeof(struct mem_section): 8
[   23.789180] PFN_SECTION_SHIFT:          14
[   23.789243] mem_map: 00000000
[   23.789304]   highstart_pfn:    229376 [page: c1700700]
[   23.789367]     highend_pfn:   1048576 [page: 02000000]
[   23.789431]   highend_pfn-1:   1048575 [page: 01ffffe0]
[   23.789494] NR_MEM_SECTIONS: 64
[   23.789555] pfn_to_section_nr(highstart_pfn):        14
[   23.789619] pfn_to_section_nr(highend_pfn):          64
[   23.789682] pfn_to_section_nr(highend_pfn-1):        63
[   23.789745] totalhigh_pages:         0
[   23.789807]  totalram_pages:    221519
[   23.924275] WARNING: at arch/x86/mm/init_32.c:353 set_highmem_pages_init()
[   23.924344] Pid: 0, comm: swapper Not tainted 2.6.24-rc8-git1 #1
[   23.924409]  [<c0104fac>] show_trace_log_lvl+0x1a/0x2f
[   23.924503]  [<c0105805>] show_trace+0x12/0x14
[   23.924591]  [<c0105bc1>] dump_stack+0x6c/0x72
[   23.924678]  [<c03ce93e>] mem_init+0x2a7/0x596
[   23.924768]  [<c03c38b6>] start_kernel+0x271/0x2fb
[   23.924858]  [<00000000>] _stext+0x3feff000/0x19
[   23.924945]  =======================
[   23.925007] bad pfn: 851968
[   23.925068] totalhigh_pages:    622129
[   23.925130]  totalram_pages:    221519
[   23.925194] Memory: 3373812k/4194304k available (1990k kernel code, 30976k 
reserved, 813k data, 208k init, 2488516k highmem)
[   23.925300] virtual kernel memory layout:
[   23.925301]     fixmap  : 0xffe15000 - 0xfffff000   (1960 kB)
[   23.925302]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   23.925302]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   23.925303]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   23.925304]       .init : 0xc03c3000 - 0xc03f7000   ( 208 kB)
[   23.925305]       .data : 0xc02f18c5 - 0xc03bcdec   ( 813 kB)
[   23.925305]       .text : 0xc0100000 - 0xc02f18c5   (1990 kB)
[   23.925805] Checking if this processor honours the WP bit even in 
supervisor mode... Ok.
[   23.926109] hpet clockevent registered
[   23.986100] Calibrating delay using timer specific routine.. 4797.85 
BogoMIPS (lpj=2398929)
[   23.986267] Mount-cache hash table entries: 512
[   23.986424] CPU: After generic identify, caps: bfebfbff 20100000 00000000 
00000000 0000e3bd 00000000 00000001 00000000
[   23.986429] monitor/mwait feature present.
[   23.987257] using mwait in idle threads.
[   23.987320] CPU: L1 I cache: 32K, L1 D cache: 32K
[   23.987408] CPU: L2 cache: 4096K
[   23.987470] CPU: Physical Processor ID: 0
[   23.987532] CPU: Processor Core ID: 0
[   23.987594] CPU: After all inits, caps: bfebfbff 20100000 00000000 
00003940 0000e3bd 00000000 00000001 00000000
[   23.987599] Intel machine check architecture supported.
[   23.987664] Intel machine check reporting enabled on CPU#0.
[   23.987729] Compat vDSO mapped to ffffe000.
[   23.987800] Checking 'hlt' instruction... OK.
[   23.991366] SMP alternatives: switching to UP code
[   23.991940] ACPI: Core revision 20070126
[   23.993505] Parsing all Control Methods:
[   23.993595] Table [DSDT](id 0001) - 610 Objects with 62 Devices 154 
Methods 38 Regions
[   23.993793] Parsing all Control Methods:
[   23.993879] Table [SSDT](id 0002) - 10 Objects with 0 Devices 4 Methods 0 
Regions
[   23.994055] Parsing all Control Methods:
[   23.994147] Table [SSDT](id 0003) - 5 Objects with 0 Devices 3 Methods 0 
Regions
[   23.994323] Parsing all Control Methods:
[   23.994408] Table [SSDT](id 0004) - 5 Objects with 0 Devices 3 Methods 0 
Regions
[   23.994584] Parsing all Control Methods:
[   23.994668] Table [SSDT](id 0005) - 5 Objects with 0 Devices 3 Methods 0 
Regions
[   23.994844] Parsing all Control Methods:
[   23.994930] Table [SSDT](id 0006) - 5 Objects with 0 Devices 3 Methods 0 
Regions
[   23.995088]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables 
successfully acquired
[   23.996207] evxfevnt-0091 [00] enable                : Transition to ACPI 
mode successful
[   23.996377] CPU0: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 
06
[   23.996500] SMP alternatives: switching to SMP code
[   23.996894] Booting processor 1/1 eip 3000
[   24.007645] Initializing CPU#1
[   24.067080] Calibrating delay using timer specific routine.. 4795.20 
BogoMIPS (lpj=2397601)
[   24.067085] CPU: After generic identify, caps: bfebfbff 20100000 00000000 
00000000 0000e3bd 00000000 00000001 00000000
[   24.067089] monitor/mwait feature present.
[   24.067091] CPU: L1 I cache: 32K, L1 D cache: 32K
[   24.067092] CPU: L2 cache: 4096K
[   24.067093] CPU: Physical Processor ID: 0
[   24.067094] CPU: Processor Core ID: 1
[   24.067096] CPU: After all inits, caps: bfebfbff 20100000 00000000 
00003940 0000e3bd 00000000 00000001 00000000
[   24.067100] Intel machine check architecture supported.
[   24.067102] Intel machine check reporting enabled on CPU#1.
[   24.067636] CPU1: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 
06
[   24.068359] Total of 2 processors activated (9593.06 BogoMIPS).
[   24.068559] ENABLING IO-APIC IRQs
[   24.068778] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   24.180160] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   24.200256] Brought up 2 CPUs
[   24.200332] CPU0 attaching sched-domain:
[   24.200334]  domain 0: span 00000003
[   24.200336]   groups: 00000001 00000002
[   24.200339] CPU1 attaching sched-domain:
[   24.200340]  domain 0: span 00000003
[   24.200341]   groups: 00000002 00000001
[   24.200493] net_namespace: 64 bytes
[   24.200849] NET: Registered protocol family 16
[   24.201014] ACPI: bus type pci registered
[   24.201138] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[   24.201203] PCI: Not using MMCONFIG.
[   24.202626] PCI: Using configuration type 1
[   24.202688] Setting up standard PCI resources
[   24.209439] evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 
4 regs on int 0x9
[   24.210162] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, 
Enabled 4 Runtime GPEs in this block
[   24.210318] ACPI: EC: Look up EC in DSDT
[   24.211574] Completing Region/Field/Buffer/Package 
initialization:........................................................................
[   24.213966] Initialized 32/38 Regions 0/0 Fields 25/25 Buffers 15/35 
Packages (649 nodes)
[   24.214124] Initializing Device/Processor/Thermal objects by executing 
_INI methods:.
[   24.214272] Executed 1 _INI methods requiring 0 _STA executions (examined 
68 objects)
[   24.214443] ACPI: Interpreter enabled
[   24.214506] ACPI: (supports S0 S3 S5)
[   24.214648] ACPI: Using IOAPIC for interrupt routing
[   24.218082] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   24.218839] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[   24.218906] PCI quirk: region 0500-053f claimed by ICH6 GPIO
[   24.219522] PCI: Transparent bridge - 0000:00:1e.0
[   24.219617] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   24.219888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[   24.220094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[   24.220180] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[   24.220267] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[   24.220353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[   24.220438] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[   24.224894] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[   24.225280] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[   24.225662] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[   24.226043] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[   24.226428] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[   24.226810] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[   24.227191] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[   24.227574] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[   24.227980] Linux Plug and Play Support v0.97 (c) Adam Belay
[   24.228065] pnp: PnP ACPI init
[   24.228131] ACPI: bus type pnp registered
[   24.230140] pnp: PnP ACPI: found 11 devices
[   24.230203] ACPI: ACPI bus type pnp unregistered
[   24.230403] SCSI subsystem initialized
[   24.230493] libata version 3.00 loaded.
[   24.230556] PCI: Using ACPI for IRQ routing
[   24.230619] PCI: If a device doesn't work, try "pci=routeirq".  If it 
helps, post a report
[   24.235340] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   24.235515] hpet0: 3 64-bit timers, 14318180 Hz
[   24.236603] ACPI: RTC can wake from S4
[   24.237154] Time: tsc clocksource has been installed.
[   24.239432] system 00:01: iomem range 0xf0000000-0xf7ffffff has been 
reserved
[   24.239510] system 00:01: iomem range 0xfed13000-0xfed13fff has been 
reserved
[   24.239576] system 00:01: iomem range 0xfed14000-0xfed17fff has been 
reserved
[   24.239642] system 00:01: iomem range 0xfed18000-0xfed18fff has been 
reserved
[   24.239708] system 00:01: iomem range 0xfed19000-0xfed19fff has been 
reserved
[   24.239773] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[   24.239839] system 00:01: iomem range 0xfed20000-0xfed3ffff has been 
reserved
[   24.239905] system 00:01: iomem range 0xfed45000-0xfed99fff has been 
reserved
[   24.239971] system 00:01: iomem range 0xc0000-0xdffff could not be reserved
[   24.240036] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[   24.240106] system 00:06: ioport range 0x500-0x53f has been reserved
[   24.240170] system 00:06: ioport range 0x400-0x47f has been reserved
[   24.240235] system 00:06: ioport range 0x680-0x6ff has been reserved
[   24.270635] PCI: Failed to allocate mem resource #6:20000@e0000000 for 
0000:01:00.0
[   24.270735] PCI: Bridge: 0000:00:01.0
[   24.270797]   IO window: 2000-2fff
[   24.270861]   MEM window: e0000000-e1ffffff
[   24.270924]   PREFETCH window: d0000000-dfffffff
[   24.270988] PCI: Bridge: 0000:00:1c.0
[   24.271050]   IO window: disabled.
[   24.271114]   MEM window: disabled.
[   24.271177]   PREFETCH window: disabled.
[   24.271242] PCI: Bridge: 0000:00:1c.1
[   24.271305]   IO window: 1000-1fff
[   24.271369]   MEM window: e2000000-e20fffff
[   24.271435]   PREFETCH window: disabled.
[   24.271499] PCI: Bridge: 0000:00:1c.2
[   24.271561]   IO window: disabled.
[   24.271624]   MEM window: disabled.
[   24.271688]   PREFETCH window: disabled.
[   24.271752] PCI: Bridge: 0000:00:1c.3
[   24.271814]   IO window: disabled.
[   24.271878]   MEM window: disabled.
[   24.271941]   PREFETCH window: disabled.
[   24.272005] PCI: Bridge: 0000:00:1c.4
[   24.272067]   IO window: disabled.
[   24.272130]   MEM window: disabled.
[   24.272193]   PREFETCH window: disabled.
[   24.272258] PCI: Bridge: 0000:00:1e.0
[   24.272319]   IO window: disabled.
[   24.272383]   MEM window: disabled.
[   24.272447]   PREFETCH window: disabled.
[   24.272520] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> 
IRQ 16
[   24.272646] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   24.272660] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> 
IRQ 17
[   24.272786] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   24.272800] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> 
IRQ 16
[   24.272925] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   24.272939] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> 
IRQ 18
[   24.273065] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   24.273079] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> 
IRQ 19
[   24.273204] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   24.273217] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> 
IRQ 17
[   24.273343] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   24.273351] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   24.273370] NET: Registered protocol family 2
[   24.283667] IP route cache hash table entries: 32768 (order: 5, 131072 
bytes)
[   24.283894] TCP established hash table entries: 131072 (order: 8, 1048576 
bytes)
[   24.284300] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[   24.284563] TCP: Hash tables configured (established 131072 bind 65536)
[   24.284634] TCP reno registered
[   24.288032] Machine check exception polling timer started.
[   24.288271] IA-32 Microcode Update Driver: v1.14a 
<tigran@aivazian.fsnet.co.uk>
[   24.288744] highmem bounce pool size: 64 pages
[   24.288809] Total HugeTLB memory allocated, 0
[   24.289015] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 254)
[   24.289115] io scheduler noop registered
[   24.289188] io scheduler cfq registered (default)
[   24.289542] Boot video device is 0000:01:00.0
[   24.289613] PCI: Setting latency timer of device 0000:00:01.0 to 64



On Tue, 15 Jan 2008 12:39:47 +0100, Ingo Molnar wrote
> * Denys Fedoryshchenko <denys@visp.net.lb> wrote:
> 
> > Hi
> > 
> > After physical memory upgrade from 3GB to 4GB (also it happens on 5GB) 
> > got kernel panic.
> > 
> > Because it is happening on early stage and my machine doesn't contain 
> > serial port, i had to take photo. Kernel boots fine with 64GB highmem, 
> > no highmem, or highmem4G with limited memory by mem=3G. All dmesg 
> > attached. Also i attach dmidecode and lspci -vvv output, probably it 
> > will be useful.
> 
> thanks for the detailed report, i think i know what's going on. 
> Could you try the patch below, does it fix your problem?
> 
> this seems to be a SPARSEMEM bug which is present in v2.6.23 as well 
> and has probably been present ever since SPARSEMEM was added to 32-
> bit x86.
> 
> There's a ~256MB hole in your e820 memory map (the pci aperture),
>  which causes the last 4 sparsemem sections (each covering 64MB of 
> RAM) to be not present - and they are thus missing from the 
> sparsemem mem_map[] too. The highmem init code on the other hand 
> assumes that all pages are in the mem_map[]:
> 
>  static void __init set_highmem_pages_init(int bad_ppro)
>  {
>         int pfn;
>         for (pfn = highstart_pfn; pfn < highend_pfn; pfn++)
>                 add_one_highpage_init(pfn_to_page(pfn), pfn, 
> bad_ppro);
> 
> the pfn_to_page() is unconditional and dereferences to a NULL-ish 
> pointer which crashes your box. highend_pfn is what got 
> miscalculated by 256 MB, so set_highmem_pages_init() tried to 
> reference a non-existing struct page - but it should still be robust 
> enough against non-existent pages.
> 
> The patch below fixes this bug. Please also send a dmesg if you 
> manage to boot the box up fine, i've added a few debug printouts to 
> confirm this theory. (i'll figure out whether we need to clip 
> highend_pfn as well - but this patch alone should be good enough to 
> fix the crash on your box.)
> 
> 	Ingo
> 
> ------------->
> Subject: x86: fix CONFIG_SPARSEMEM highmem init bug
> From: Ingo Molnar <mingo@elte.hu>
> 
> fix CONFIG_SPARSEMEM highmem init bug.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/init_32.c |   43 
> ++++++++++++++++++++++++++++++++++++++++--- mm/sparse.c           |  
>   8 +++++++- 2 files changed, 47 insertions(+), 4 deletions(-)
> 
> Index: linux/arch/x86/mm/init_32.c
> ===================================================================
> --- linux.orig/arch/x86/mm/init_32.c
> +++ linux/arch/x86/mm/init_32.c
> @@ -321,11 +321,48 @@ extern void set_highmem_pages_init(int);
>  static void __init set_highmem_pages_init(int bad_ppro)
>  {
>  	int pfn;
> -	for (pfn = highstart_pfn; pfn < highend_pfn; pfn++)
> -		add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro);
> +
> +	printk("set_highmem_pages_init(bad_ppro:%d)\n", bad_ppro);
> +	printk("sizeof(struct page):        %d\n", sizeof(struct page));
> +	printk("sizeof(struct mem_section): %d\n", sizeof(struct 
> mem_section)); +	printk("PFN_SECTION_SHIFT:          %d\n",
>  PFN_SECTION_SHIFT); + +	printk("mem_map: %p\n", mem_map); +	
> printk("  highstart_pfn: %9ld [page: %p]\n", +		
highstart_pfn, 
> pfn_to_page(highstart_pfn)); +	printk("    highend_pfn: %9ld [page: 
> %p]\n", +		highend_pfn, pfn_to_page(highend_pfn)); +	
printk("  
> highend_pfn-1: %9ld [page: %p]\n", +		highend_pfn-1, 
> pfn_to_page(highend_pfn-1)); + +	printk("NR_MEM_SECTIONS: %ld\n",
>  NR_MEM_SECTIONS); +	printk("pfn_to_section_nr(highstart_pfn): 
> %9ld\n", +		pfn_to_section_nr(highstart_pfn)); +	
> printk("pfn_to_section_nr(highend_pfn):   %9ld\n", +	
> 	pfn_to_section_nr(highend_pfn)); +	
> printk("pfn_to_section_nr(highend_pfn-1): %9ld\n", +	
> 	pfn_to_section_nr(highend_pfn-1)); + +	printk("totalhigh_pages: 
> %9ld\n", totalhigh_pages); +	printk(" totalram_pages: %9ld\n", 
> totalram_pages); + +	for (pfn = highstart_pfn; pfn < highend_pfn; 
> pfn++) { +		if (pfn_valid(pfn)) +		
> 	add_one_highpage_init(pfn_to_page(pfn), pfn, bad_ppro); +	
	else { +	
> 		if (WARN_ON_ONCE(1)) { +				
printk("bad pfn: %d\n", pfn); +				break;
> +			}
> +		}
> +	}
> +	printk("totalhigh_pages: %9ld\n", totalhigh_pages);
> +	printk(" totalram_pages: %9ld\n", totalram_pages);
> +
> +
>  	totalram_pages += totalhigh_pages;
>  }
> -#endif /* CONFIG_FLATMEM */
> +#endif /* CONFIG_NUMA */
> 
>  #else
>  #define kmap_init() do { } while (0)
> Index: linux/mm/sparse.c
> ===================================================================
> --- linux.orig/mm/sparse.c
> +++ linux/mm/sparse.c
> @@ -295,9 +295,13 @@ void __init sparse_init(void)
>  	struct page *map;
>  	unsigned long *usemap;
> 
> +	printk("sparse_init()\n");
>  	for (pnum = 0; pnum < NR_MEM_SECTIONS; pnum++) {
> -		if (!present_section_nr(pnum))
> +		printk("section %2ld: ", pnum);
> +		if (!present_section_nr(pnum)) {
> +			printk("!present\n");
>  			continue;
> +		}
> 
>  		map = sparse_early_mem_map_alloc(pnum);
>  		if (!map)
> @@ -309,6 +313,8 @@ void __init sparse_init(void)
> 
>  		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
>  								usemap);
> +		printk("map: %p, usemap: %p [content: %08lx]\n",
> +			map, usemap, __nr_to_section(pnum)->section_mem_map);
>  	}
>  }


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

