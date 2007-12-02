Return-Path: <linux-kernel-owner+w=401wt.eu-S1752687AbXLBPqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbXLBPqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755575AbXLBPpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:45:43 -0500
Received: from rtr.ca ([76.10.145.34]:2694 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755411AbXLBPph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:45:37 -0500
Message-ID: <4752D31C.8060202@rtr.ca>
Date: Sun, 02 Dec 2007 10:45:32 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, abelay@novell.com,
       lenb@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: 20000+ wake-ups/second in 2.6.24.   Bug?
References: <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com> <4750CC78.9070105@rtr.ca> <20071130190227.1976e682@laptopd505.fenrus.org> <4750D180.6080001@rtr.ca> <20071130191816.3e744205@laptopd505.fenrus.org> <4750D585.1030200@rtr.ca> <4750D899.4020905@rtr.ca> <4751F1AB.2060801@rtr.ca> <20071202144113.GJ15974@stusta.de> <4752C86D.8050909@rtr.ca> <20071202151231.GK15974@stusta.de>
In-Reply-To: <20071202151231.GK15974@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the info from 2.6.24:  dmesg + lsmod + lspci-v + PowerTop:

[    0.000000] Linux version 2.6.24-rc3-git5 (root@corey) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #3 SMP PREEMPT Fri Nov 30 22:35:04 EST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfed3400 (usable)
[    0.000000]  BIOS-e820: 00000000bfed3400 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4007000 (reserved)
[    0.000000]  BIOS-e820: 00000000f4008000 - 00000000f400c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 2174MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 786131) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   786131
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   786131
[    0.000000] On node 0 totalpages: 786131
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4349 pages used for memmap
[    0.000000]   HighMem zone: 552406 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FC1B0, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT BFED39CD, 0040 (r1 DELL    M07     27D7061B ASL        61)
[    0.000000] ACPI: FACP BFED4800, 0074 (r1 DELL    M07     27D7061B ASL        61)
[    0.000000] ACPI: DSDT BFED5400, 4841 (r1 INT430 SYSFexxx     1001 INTL 20050624)
[    0.000000] ACPI: FACS BFEE3C00, 0040
[    0.000000] ACPI: HPET BFED4F00, 0038 (r1 DELL    M07            1 ASL        61)
[    0.000000] ACPI: APIC BFED5000, 0068 (r1 DELL    M07     27D7061B ASL        47)
[    0.000000] ACPI: MCFG BFED4FC0, 003E (r16 DELL    M07     27D7061B ASL        61)
[    0.000000] ACPI: SLIC BFED509C, 0176 (r1 DELL    M07     27D7061B ASL        61)
[    0.000000] ACPI: BOOT BFED4BC0, 0028 (r1 DELL    M07     27D7061B ASL        61)
[    0.000000] ACPI: SSDT BFED3A0D, 04DC (r1  PmRef    CpuPm     3000 INTL 20050624)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:15 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:15 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
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
[    0.000000] Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
[    0.000000] swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
[    0.000000] swsusp: Registered nosave memory region: 00000000000a0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 779990
[    0.000000] Kernel command line: root=/dev/sda1 ro resume=/dev/sda3 vga=ext sysrq_always_enabled
[    0.000000] debug: sysrq always enabled.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c038a000 soft=c0388000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2161.420 MHz processor.
[    6.428240] Console: colour VGA+ 80x50
[    6.428243] console [tty0] enabled
[    6.434703] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    6.435082] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    6.571914] Memory: 3114916k/3144524k available (1666k kernel code, 28492k reserved, 708k data, 188k init, 2227020k highmem)
[    6.572067] virtual kernel memory layout:
[    6.572068]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    6.572069]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    6.572069]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    6.572070]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    6.572071]       .init : 0xc0356000 - 0xc0385000   ( 188 kB)
[    6.572072]       .data : 0xc02a0a76 - 0xc0351c00   ( 708 kB)
[    6.572073]       .text : 0xc0100000 - 0xc02a0a76   (1666 kB)
[    6.572993] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[    6.573258] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    6.573525] hpet clockevent registered
[    6.656724] Calibrating delay using timer specific routine.. 4327.37 BogoMIPS (lpj=7210194)
[    6.656979] Mount-cache hash table entries: 512
[    6.657216] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
[    6.657222] monitor/mwait feature present.
[    6.657336] using mwait in idle threads.
[    6.657452] CPU: L1 I cache: 32K, L1 D cache: 32K
[    6.657650] CPU: L2 cache: 4096K
[    6.657765] CPU: Physical Processor ID: 0
[    6.657879] CPU: Processor Core ID: 0
[    6.657993] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
[    6.658001] Compat vDSO mapped to ffffe000.
[    6.658125] Checking 'hlt' instruction... OK.
[    6.670306] SMP alternatives: switching to UP code
[    6.670903] ACPI: Core revision 20070126
[    6.673425] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    6.673723] SMP alternatives: switching to SMP code
[    6.674136] Booting processor 1/1 eip 3000
[    6.674249] CPU 1 irqstacks, hard=c038b000 soft=c0389000
[    8.564513] Initializing CPU#1
[    8.644461] Calibrating delay using timer specific routine.. 4324.62 BogoMIPS (lpj=7204193)
[    8.644467] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
[    8.644471] monitor/mwait feature present.
[    8.644473] CPU: L1 I cache: 32K, L1 D cache: 32K
[    8.644475] CPU: L2 cache: 4096K
[    8.644476] CPU: Physical Processor ID: 0
[    8.644477] CPU: Processor Core ID: 1
[    8.644478] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
[    6.767099] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    6.768198] Total of 2 processors activated (8652.99 BogoMIPS).
[    6.768508] ENABLING IO-APIC IRQs
[    6.768805] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    6.906377] checking TSC synchronization [CPU#0 -> CPU#1]:
[    6.926547] Measured 4065529416 cycles TSC warp between CPUs, turning off TSC clock.
[    6.926687] Marking TSC unstable due to: check_tsc_sync_source failed.
[    6.926809] Brought up 2 CPUs
[    6.927051] net_namespace: 64 bytes
[    6.927439] NET: Registered protocol family 16
[    6.927666] ACPI: bus type pci registered
[    6.927837] PCI: Using MMCONFIG
[    6.928704] Setting up standard PCI resources
[    6.933401] ACPI: EC: Look up EC in DSDT
[    6.936970] ACPI: Interpreter enabled
[    6.937081] ACPI: (supports S0 S3 S4 S5)
[    6.937538] ACPI: Using IOAPIC for interrupt routing
[    6.950219] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    6.950910] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    6.951026] PCI quirk: region 1080-10bf claimed by ICH6 GPIO
[    6.952318] PCI: Transparent bridge - 0000:00:1e.0
[    6.952491] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    6.952806] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    6.952879] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    6.952996] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    6.953084] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    6.953169] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    6.959511] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *4
[    6.960230] ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
[    6.960762] ACPI: PCI Interrupt Link [LNKC] (IRQs *9 10 11)
[    6.961377] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
[    6.962246] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    6.963557] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    6.964868] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    6.966181] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    6.967525] Linux Plug and Play Support v0.97 (c) Adam Belay
[    6.967656] pnp: PnP ACPI init
[    6.967772] ACPI: bus type pnp registered
[    6.981084] pnpacpi: exceeded the max number of mem resources: 12
[    6.981200] pnpacpi: exceeded the max number of mem resources: 12
[    6.981314] pnpacpi: exceeded the max number of mem resources: 12
[    6.981429] pnpacpi: exceeded the max number of mem resources: 12
[    6.981544] pnpacpi: exceeded the max number of mem resources: 12
[    6.981658] pnpacpi: exceeded the max number of mem resources: 12
[    6.991731] pnp: PnP ACPI: found 12 devices
[    6.991844] ACPI: ACPI bus type pnp unregistered
[    6.992080] SCSI subsystem initialized
[    6.992214] libata version 3.00 loaded.
[    6.992298] PCI: Using ACPI for IRQ routing
[    6.992411] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    7.002826] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    7.003277] hpet0: 3 64-bit timers, 14318180 Hz
[    7.004413] ACPI: RTC can wake from S4
[    7.006131] Time: hpet clocksource has been installed.
[    7.006253] Switched to high resolution mode on CPU 0
[    8.884597] Switched to high resolution mode on CPU 1
[    7.012838] system 00:00: iomem range 0x0-0x9fbff could not be reserved
[    7.012954] system 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[    7.013071] system 00:00: iomem range 0xc0000-0xcffff could not be reserved
[    7.013187] system 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    7.013303] system 00:00: iomem range 0x100000-0xbfed33ff could not be reserved
[    7.013444] system 00:00: iomem range 0xbfed3400-0xbfefffff could not be reserved
[    7.013585] system 00:00: iomem range 0xbff00000-0xbfffffff could not be reserved
[    7.013730] system 00:00: iomem range 0xffb00000-0xffffffff could not be reserved
[    7.013872] system 00:00: iomem range 0xfec00000-0xfec0ffff could not be reserved
[    7.014013] system 00:00: iomem range 0xfee00000-0xfee0ffff could not be reserved
[    7.014154] system 00:00: iomem range 0xfed20000-0xfed9ffff could not be reserved
[    7.014296] system 00:00: iomem range 0xffa80000-0xffa83fff could not be reserved
[    7.014440] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    7.014555] system 00:02: ioport range 0x1000-0x1005 has been reserved
[    7.014671] system 00:02: ioport range 0x1008-0x100f has been reserved
[    7.014789] system 00:03: ioport range 0xf400-0xf4fe has been reserved
[    7.014905] system 00:03: ioport range 0x1006-0x1007 has been reserved
[    7.015021] system 00:03: ioport range 0x100a-0x1059 could not be reserved
[    7.015136] system 00:03: ioport range 0x1060-0x107f has been reserved
[    7.015251] system 00:03: ioport range 0x1080-0x10bf has been reserved
[    7.015366] system 00:03: ioport range 0x10c0-0x10df has been reserved
[    7.015481] system 00:03: ioport range 0x1010-0x102f has been reserved
[    7.015596] system 00:03: ioport range 0x809-0x809 has been reserved
[    7.015715] system 00:08: ioport range 0xc80-0xcff could not be reserved
[    7.015830] system 00:08: ioport range 0x910-0x91f has been reserved
[    7.017073] system 00:08: ioport range 0x920-0x92f has been reserved
[    7.017188] system 00:08: ioport range 0xcb0-0xcbf has been reserved
[    7.017303] system 00:08: ioport range 0x930-0x97f has been reserved
[    7.017421] system 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
[    7.047781] PCI: Bridge: 0000:00:01.0
[    7.047894]   IO window: e000-efff
[    7.048006]   MEM window: efd00000-efefffff
[    7.048118]   PREFETCH window: d0000000-dfffffff
[    7.048232] PCI: Bridge: 0000:00:1c.0
[    7.048343]   IO window: disabled.
[    7.048457]   MEM window: disabled.
[    7.048570]   PREFETCH window: disabled.
[    7.048685] PCI: Bridge: 0000:00:1c.1
[    7.048796]   IO window: disabled.
[    7.048911]   MEM window: efc00000-efcfffff
[    7.049025]   PREFETCH window: disabled.
[    7.049139] PCI: Bridge: 0000:00:1c.3
[    7.049252]   IO window: d000-dfff
[    7.049367]   MEM window: efa00000-efbfffff
[    7.049486]   PREFETCH window: e0000000-e01fffff
[    7.049602] PCI: Bridge: 0000:00:1e.0
[    7.049714]   IO window: disabled.
[    7.049828]   MEM window: ef900000-ef9fffff
[    7.049942]   PREFETCH window: disabled.
[    7.050064] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    7.050293] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    7.050310] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    7.050536] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    7.050554] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    7.050780] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    7.050798] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
[    7.051024] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    7.051034] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    7.051041] NET: Registered protocol family 2
[    7.079403] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    7.079689] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    7.080215] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[    7.080623] TCP: Hash tables configured (established 131072 bind 65536)
[    7.080739] TCP reno registered
[    7.089515] Simple Boot Flag at 0x79 set to 0x1
[    8.968226] highmem bounce pool size: 64 pages
[    8.968445] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    8.968586] io scheduler noop registered
[    8.968698] io scheduler anticipatory registered
[    8.968810] io scheduler cfq registered (default)
[    8.969015] Boot video device is 0000:01:00.0
[    8.969096] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    8.969112] assign_interrupt_mode Found MSI capability
[    8.969226] Allocate Port Service[0000:00:01.0:pcie00]
[    8.969256] Allocate Port Service[0000:00:01.0:pcie03]
[    8.969306] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    8.969351] assign_interrupt_mode Found MSI capability
[    8.969465] Allocate Port Service[0000:00:1c.0:pcie00]
[    8.969492] Allocate Port Service[0000:00:1c.0:pcie02]
[    8.969521] Allocate Port Service[0000:00:1c.0:pcie03]
[    8.969601] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    8.969647] assign_interrupt_mode Found MSI capability
[    8.969760] Allocate Port Service[0000:00:1c.1:pcie00]
[    8.969788] Allocate Port Service[0000:00:1c.1:pcie02]
[    8.969815] Allocate Port Service[0000:00:1c.1:pcie03]
[    8.969895] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    8.969941] assign_interrupt_mode Found MSI capability
[    8.970054] Allocate Port Service[0000:00:1c.3:pcie00]
[    8.970087] Allocate Port Service[0000:00:1c.3:pcie02]
[    8.970115] Allocate Port Service[0000:00:1c.3:pcie03]
[    8.987532] hpet_resources: 0xfed00000 is busy
[    8.987577] Generic RTC Driver v1.07
[    8.987718] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[    8.988156] RAMDISK driver initialized: 4 RAM disks of 8192K size 1024 blocksize
[    8.988376] ata_piix 0000:00:1f.2: version 2.12
[    8.988382] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    8.988852] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
[    8.989103] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    8.989154] scsi0 : ata_piix
[    8.989315] scsi1 : ata_piix
[    8.989574] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
[    8.989690] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
[    7.269512] ata1.00: ATA-7: ST9160823AS, 3.AAB, max UDMA/133
[    7.269627] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    7.282831] ata1.00: configured for UDMA/133
[    7.595645] ata2.00: ATAPI: SONY DVD RW DW-Q58A, UYS2, max UDMA/33
[    7.761978] ata2.00: configured for UDMA/33
[    9.640101] scsi 0:0:0:0: Direct-Access     ATA      ST9160823AS      3.AA PQ: 0 ANSI: 5
[    9.640341] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    9.640464] sd 0:0:0:0: [sda] Write Protect is off
[    9.640577] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.640589] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.640764] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    9.640885] sd 0:0:0:0: [sda] Write Protect is off
[    9.640999] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.641010] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.641152]  sda: sda1 sda2 sda3
[    7.768479] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.769266] scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-Q58A   UYS2 PQ: 0 ANSI: 5
[    7.769578] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    7.772487] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.772603] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.772840] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    7.772992] rtc0: alarms up to one month, y3k
[    7.773129] cpuidle: using governor ladder
[    7.773243] cpuidle: using governor menu
[    7.773399] TCP cubic registered
[    7.773512] Using IPI No-Shortcut mode
[    7.775248] input: AT Translated Set 2 keyboard as /class/input/input0
[    7.800680] rtc_cmos 00:06: setting system clock to 2007-12-02 15:31:19 UTC (1196609479)
[    7.940157] EXT3-fs: mounted filesystem with ordered data mode.
[    7.940275] VFS: Mounted root (ext3 filesystem) readonly.
[    7.940484] Freeing unused kernel memory: 188k freed
[    7.940659] kjournald starting.  Commit interval 5 seconds
[    8.538899] NET: Registered protocol family 1
[   16.854771] ACPI: SSDT BFED4134, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[   16.855251] ACPI: SSDT BFED3EE9, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[   16.855962] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   16.856414] ACPI: Processor [CPU0] (supports 8 throttling states)
[   16.856868] ACPI: SSDT BFED4378, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[   16.857308] ACPI: SSDT BFED40AF, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[   16.858037] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   16.858493] ACPI: Processor [CPU1] (supports 8 throttling states)
[   16.896878] input: Lid Switch as /class/input/input1
[   16.927170] ACPI: Lid Switch [LID]
[   16.927329] input: Power Button (CM) as /class/input/input2
[   16.976666] ACPI: Power Button (CM) [PBTN]
[   16.976830] input: Sleep Button (CM) as /class/input/input3
[   17.023244] ACPI: Sleep Button (CM) [SBTN]
[   17.028529] ACPI: Thermal Zone [THM] (50 C)
[   17.067787] Linux agpgart interface v0.102
[   17.139916] ACPI: AC Adapter [AC] (on-line)
[   17.170598] usbcore: registered new interface driver usbfs
[   17.170739] usbcore: registered new interface driver hub
[   17.171013] usbcore: registered new device driver usb
[   17.224823] intel_rng: FWH not detected
[   17.250299] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   17.250438] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   17.284638] ricoh-mmc: Ricoh MMC Controller disabling driver
[   17.284761] ricoh-mmc: Copyright(c) Philip Langdale
[   17.284903] ricoh-mmc: Ricoh MMC controller found at 0000:03:01.2 [1180:0843] (rev 1)
[   17.285059] ricoh-mmc: Controller is now disabled.
[   17.349704] ACPI: Battery Slot [BAT0] (battery present)
[   19.227656] input: PC Speaker as /class/input/input4
[   17.395011] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   17.395130] Uniform CD-ROM driver Revision: 3.20
[   17.395270] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   17.406827] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   17.422358] USB Universal Host Controller Interface driver v3.0
[   17.422503] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
[   17.422735] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   17.422738] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   17.423086] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   17.423260] uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000bf80
[   17.423491] usb usb1: configuration #1 chosen from 1 choice
[   17.423637] hub 1-0:1.0: USB hub found
[   17.423754] hub 1-0:1.0: 2 ports detected
[   17.436471] sdhci: Secure Digital Host Controller Interface driver
[   17.436605] sdhci: Copyright(c) Pierre Ossman
[   17.456802] b44.c:v2.0
[   17.473656] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:18:8b:a7:bf:42
[   17.523397] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 20
[   17.523631] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   17.523635] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   17.523767] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   17.523933] uhci_hcd 0000:00:1d.1: irq 20, io base 0x0000bf60
[   17.524139] usb usb2: configuration #1 chosen from 1 choice
[   17.524275] hub 2-0:1.0: USB hub found
[   17.524390] hub 2-0:1.0: 2 ports detected
[   17.626557] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 21
[   17.626866] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   17.626870] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   17.627042] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   17.627215] uhci_hcd 0000:00:1d.2: irq 21, io base 0x0000bf40
[   17.627425] usb usb3: configuration #1 chosen from 1 choice
[   17.627560] hub 3-0:1.0: USB hub found
[   17.627675] hub 3-0:1.0: 2 ports detected
[   17.714196] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 22
[   17.714425] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   17.714428] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   17.714561] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   17.714760] uhci_hcd 0000:00:1d.3: irq 22, io base 0x0000bf20
[   17.714973] usb usb4: configuration #1 chosen from 1 choice
[   17.715107] hub 4-0:1.0: USB hub found
[   17.715237] hub 4-0:1.0: 2 ports detected
[   19.594226] usb 1-1: new full speed USB device using uhci_hcd and address 2
[   17.722985] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 20
[   17.723247] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   17.731372] usb 1-1: configuration #1 chosen from 1 choice
[   17.731695] hub 1-1:1.0: USB hub found
[   17.732375] hub 1-1:1.0: 4 ports detected
[   17.751024] Synaptics Touchpad, model: 1, fw: 6.2, id: 0xfa0b1, caps: 0xa04713/0x200000
[   17.757327] input: SynPS/2 Synaptics TouchPad as /class/input/input5
[   17.775633] mice: PS/2 mouse device common for all mice
[   19.670449] sdhci: SDHCI controller found at 0000:03:01.1 [1180:0822] (rev 19)
[   19.670612] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 23
[   19.670888] mmc0: SDHCI at 0xef9fd400 irq 23 DMA
[   17.793175] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 18
[   17.793443] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
[   17.793662] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   17.793665] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   17.793801] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   17.797847] ehci_hcd 0000:00:1d.7: debug port 1
[   17.797964] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   17.797968] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xffa80000
[   17.865404] usb 3-1: new full speed USB device using uhci_hcd and address 2
[   19.744154] firewire_ohci: Added fw-ohci device 0000:03:01.0, OHCI version 1.10
[   17.875381] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   17.875636] usb usb5: configuration #1 chosen from 1 choice
[   17.875771] hub 5-0:1.0: USB hub found
[   17.875887] hub 5-0:1.0: 8 ports detected
[   17.927015] hub 1-1:1.0: hub_port_status failed (err = -71)
[   17.928236] hub 1-1:1.0: hub_port_status failed (err = -71)
[   17.929010] hub 1-1:1.0: hub_port_status failed (err = -71)
[   17.930009] hub 1-1:1.0: hub_port_status failed (err = -71)
[   17.930143] usb 1-1: USB disconnect, address 2
[   18.094628] fuse init (API version 7.9)
[   18.126244] usb 5-1: new high speed USB device using ehci_hcd and address 2
[   18.127911] NET: Registered protocol family 17
[   18.141750] firewire_core: created new fw device fw0 (0 config rom retries, S400)
[   18.154281] usb 5-1: configuration #1 chosen from 1 choice
[   18.154569] hub 5-1:1.0: USB hub found
[   18.154799] hub 5-1:1.0: 4 ports detected
[   18.404165] usb 5-5: new high speed USB device using ehci_hcd and address 3
[   18.528823] usb 5-5: configuration #1 chosen from 1 choice
[   20.408571] hub 5-5:1.0: USB hub found
[   20.409039] hub 5-5:1.0: 4 ports detected
[   18.823757] usb 5-5.1: new low speed USB device using ehci_hcd and address 4
[   18.911379] usb 5-5.1: configuration #1 chosen from 1 choice
[   20.792148] usbcore: registered new interface driver usbserial
[   20.792278] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   20.792438] usbcore: registered new interface driver usbserial_generic
[   20.792553] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   20.802099] drivers/usb/serial/usb-serial.c: USB Serial support registered for Handspring Visor / Palm OS
[   20.802256] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 3.5
[   20.802414] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 5.0
[   20.802572] usbcore: registered new interface driver visor
[   20.802686] drivers/usb/serial/visor.c: USB HandSpring Visor / Palm OS driver
[   18.979647] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   18.984069] pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
[   18.984763] Load service driver hpdriver on pcie device 0000:00:1c.0:pcie02
[   18.984779] pciehp: HPC vendor_id 8086 device_id 27d2 ss_vid 0 ss_did 0
[   19.003648] usbcore: registered new interface driver hiddev
[   19.005605] input: Logitech Optical USB Mouse as /class/input/input6
[   19.023185] input,hidraw0: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-5.1
[   19.023671] usbcore: registered new interface driver usbhid
[   19.023785] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   19.984937] pciehp: Device 0000:0c:00.0 already exists at c:0, cannot hot-add
[   19.985057] pciehp: Cannot add device 0xc:0
[   19.985177] Load service driver hpdriver on pcie device 0000:00:1c.1:pcie02
[   19.985199] pciehp: HPC vendor_id 8086 device_id 27d6 ss_vid 0 ss_did 0
[   19.985350] Load service driver hpdriver on pcie device 0000:00:1c.3:pcie02
[   19.985356] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   21.880534] Adding 2064344k swap on /dev/sda3.  Priority:-1 extents:1 across:2064344k
[   20.110616] EXT3 FS on sda1, internal journal
[   20.272818] kjournald starting.  Commit interval 5 seconds
[   20.272974] EXT3 FS on sda2, internal journal
[   20.272978] EXT3-fs: mounted filesystem with ordered data mode.
[   22.176681] b44: eth0: Link is up at 100 Mbps, full duplex.
[   22.176683] b44: eth0: Flow control is off for TX and off for RX.
[   24.802846] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   27.078916] RPC: Registered udp transport module.
[   27.078922] RPC: Registered tcp transport module.
[   27.133817] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   27.233003] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   27.233578] NFSD: starting 90-second grace period
[   27.904761] Bluetooth: Core ver 2.11
[   27.904849] NET: Registered protocol family 31
[   27.904852] Bluetooth: HCI device and connection manager initialized
[   27.904858] Bluetooth: HCI socket layer initialized
[   27.948472] Bluetooth: L2CAP ver 2.9
[   27.948703] Bluetooth: L2CAP socket layer initialized
[   28.082302] Bluetooth: RFCOMM socket layer initialized
[   28.082317] Bluetooth: RFCOMM TTY layer initialized
[   28.082320] Bluetooth: RFCOMM ver 1.8
[   31.691604] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>

Module                  Size  Used by
microcode              10356  0 
binfmt_misc            11336  1 
rfcomm                 37136  5 
l2cap                  23168  5 rfcomm
bluetooth              53476  4 rfcomm,l2cap
nfs                   236684  0 
nfsd                  204848  19 
lockd                  60936  3 nfs,nfsd
nfs_acl                 3392  2 nfs,nfsd
auth_rpcgss            41120  1 nfsd
sunrpc                171996  17 nfs,nfsd,lockd,nfs_acl,auth_rpcgss
exportfs                4672  1 nfsd
acpi_cpufreq            8916  1 
cpufreq_stats           5776  0 
cpufreq_userspace       4012  0 
cpufreq_conservative     7496  0 
cpufreq_powersave       1728  0 
container               4736  0 
fan                     4484  0 
firmware_class          9472  1 microcode
usbhid                 28224  0 
pciehp                 34968  0 
pci_hotplug            13960  1 pciehp
hid                    33408  1 usbhid
visor                  16908  0 
af_packet              20932  2 
usbserial              32808  1 visor
fuse                   45204  1 
firewire_sbp2          14220  0 
mousedev               13128  1 
snd_hda_intel         275036  4 
snd_pcm_oss            36064  0 
snd_pcm                66116  3 snd_hda_intel,snd_pcm_oss
snd_mixer_oss          15296  1 snd_pcm_oss
snd_seq_dummy           3652  0 
snd_seq_oss            29504  0 
snd_seq_midi            8032  0 
snd_rawmidi            22496  1 snd_seq_midi
snd_seq_midi_event      6848  2 snd_seq_oss,snd_seq_midi
snd_seq                46800  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              21124  3 snd_pcm,snd_seq
snd_seq_device          7692  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
firewire_ohci          16576  0 
serio_raw               6532  0 
firewire_core          39168  2 firewire_sbp2,firewire_ohci
sdhci                  17028  0 
ehci_hcd               32908  0 
uhci_hcd               23116  0 
b44                    25168  0 
ssb                    26692  1 b44
sr_mod                 15588  0 
cdrom                  32416  1 sr_mod
snd                    48996  15 snd_hda_intel,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
psmouse                29640  0 
pcspkr                  2944  0 
battery                13316  0 
ricoh_mmc               3328  0 
crc_itu_t               2048  1 firewire_core
mmc_core               47044  1 sdhci
sg                     34128  0 
mii                     5184  1 b44
soundcore               7840  1 snd
snd_page_alloc          9928  2 snd_hda_intel,snd_pcm
usbcore               133740  6 usbhid,visor,usbserial,ehci_hcd,uhci_hcd
ac                      6020  0 
power_supply            8452  2 battery,ac
intel_agp              23252  0 
agpgart                31564  1 intel_agp
thermal                15900  0 
button                  8272  0 
processor              36032  4 acpi_cpufreq,thermal
unix                   26544  366 

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express PCI Express Root Port (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: efd00000-efefffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Capabilities: [88] Subsystem: Dell Unknown device 01cd
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [a0] Express Root Port (Slot+) IRQ 0
	Capabilities: [100] Virtual Channel
	Capabilities: [140] Unknown (5)

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, fast devsel, latency 0, IRQ 20
	Memory at efffc000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [70] Express Unknown type IRQ 0
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [90] Subsystem: Dell Unknown device 01cd
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
	Memory behind bridge: efc00000-efcfffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [90] Subsystem: Dell Unknown device 01cd
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 01) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0d, subordinate=0e, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: efa00000-efbfffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000e01fffff
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
	Capabilities: [90] Subsystem: Dell Unknown device 01cd
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at bf80 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at bf60 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at bf40 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 22
	I/O ports at bf20 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01) (prog-if 20 [EHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 19
	Memory at ffa80000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
	Memory behind bridge: ef900000-ef9fffff
	Capabilities: [50] Subsystem: Dell Unknown device 01cd

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller IDE (rev 01) (prog-if 80 [Master])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 17
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at bfa0 [size=16]
	Capabilities: [70] Power Management version 2

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
	Subsystem: Dell Unknown device 01cd
	Flags: medium devsel, IRQ 5
	I/O ports at 10c0 [size=32]

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility X1400 (prog-if 00 [VGA])
	Subsystem: Dell Unknown device 2002
	Flags: bus master, fast devsel, latency 0, IRQ 4
	Memory at d0000000 (32-bit, prefetchable) [size=256M]
	I/O ports at ee00 [size=256]
	Memory at efdf0000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at efe00000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Express Legacy Endpoint IRQ 0

03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev 02)
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, fast devsel, latency 64, IRQ 17
	Memory at ef9fe000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [40] Power Management version 2

03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (prog-if 10 [OHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 64, IRQ 18
	Memory at ef9fd800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2

03:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19) (prog-if 01)
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 64, IRQ 23
	Memory at ef9fd400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 0a)
	Subsystem: Dell Unknown device 01cd
	Flags: medium devsel, IRQ 9
	Memory at ef9fd500 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 05)
	Subsystem: Dell Unknown device 01cd
	Flags: medium devsel, IRQ 9
	Memory at ef9fd600 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff) (prog-if ff)
	!!! Unknown header type 7f

0c:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
	Subsystem: Intel Corporation Unknown device 1000
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at efcff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 2
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
	Capabilities: [e0] Express Legacy Endpoint IRQ 0
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 6f-5e-72-ff-ff-d2-19-00

PowerTop:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 1.9%)         2.17 Ghz     0.0%
C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
C2                0.1ms ( 0.0%)         1333 Mhz     0.0%
C3                6.9ms (98.0%)         1000 Mhz   100.0%


Wakeups-from-idle per second : 142.9    interval: 5.0s
no ACPI power usage estimate available

Top causes for wakeups:
  36.3% ( 47.0)       <interrupt> : uhci_hcd:usb2, HDA Intel
  10.2% ( 13.2)            kicker : schedule_timeout (process_timeout)
   8.8% ( 11.4)      <kernel IPI> : Rescheduling interrupts
   7.9% ( 10.2)              Xorg : do_setitimer (it_real_fn)
   7.7% ( 10.0)   <kernel module> : ehci_work (ehci_watchdog)
   7.3% (  9.4)       <interrupt> : extra timer interrupt
   6.8% (  8.8)             artsd : schedule_timeout (process_timeout)
   3.7% (  4.8)            dhcdbd : schedule_timeout (process_timeout)
   1.5% (  2.0)       <interrupt> : libata
   1.5% (  2.0)     passkey-agent : schedule_timeout (process_timeout)
   0.8% (  1.0)             artsd : do_setitimer (it_real_fn)
   0.8% (  1.0)           klipper : schedule_timeout (process_timeout)
   0.8% (  1.0)              ntpd : do_setitimer (it_real_fn)
   0.8% (  1.0)        atieventsd : schedule_timeout (process_timeout)
   0.8% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup)
   0.8% (  1.0)          ifconfig : b44_open (b44_timer)
   0.5% (  0.6)               gpm : do_nanosleep (hrtimer_wakeup)
   0.3% (  0.4)              Xorg : schedule_timeout (process_timeout)
   0.3% (  0.4)              kded : schedule_timeout (process_timeout)
   0.3% (  0.4)              kmix : schedule_timeout (process_timeout)
   0.2% (  0.2)       <interrupt> : PS/2 keyboard/mouse/touchpad
   0.2% (  0.2)           konsole : schedule_timeout (process_timeout)
   0.2% (  0.2)   guidance-power- : schedule_timeout (process_timeout)
   0.2% (  0.2)     <kernel core> : clocksource_register (clocksource_watchdog)
   0.2% (  0.2)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer)
   0.2% (  0.2)      kio_uiserver : schedule_timeout (process_timeout)
   0.2% (  0.2)   <kernel module> : nfsacl_decode (delayed_work_timer_fn)
   0.2% (  0.2)        rpc.idmapd : schedule_timeout (process_timeout)
   0.2% (  0.2)              kwin : schedule_timeout (process_timeout)
   0.2% (  0.2)     <kernel core> : ip_rt_init (delayed_work_timer_fn)
   0.2% (  0.2)          katapult : schedule_timeout (process_timeout)
   0.2% (  0.2)     <kernel core> : __netdev_watchdog_up (dev_watchdog)
   0.2% (  0.2)    adept_notifier : schedule_timeout (process_timeout)
   0.2% (  0.2)     <kernel core> : end_that_request_last (laptop_timer_fn)
