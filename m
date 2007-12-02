Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbXLBPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbXLBPpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXLBPpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:45:23 -0500
Received: from rtr.ca ([76.10.145.34]:2687 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXLBPpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:45:15 -0500
Message-ID: <4752D306.30506@rtr.ca>
Date: Sun, 02 Dec 2007 10:45:10 -0500
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

Here's the info from 2.6.23:  dmesg + lsmod + lspci-v + PowerTop:

[    0.000000] Linux version 2.6.23.8 (root@corey) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #10 SMP PREEMPT Sun Dec 2 10:24:11 EST 2007
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
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 779990
[    0.000000] Kernel command line: root=/dev/sda1 ro resume=/dev/sda3 vga=ext sysrq_always_enabled
[    0.000000] debug: sysrq always enabled.
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0374000 soft=c0372000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2161.325 MHz processor.
[    5.995348] Console: colour VGA+ 80x50
[    5.995351] console [tty0] enabled
[    6.001688] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    6.002066] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    6.113010] Memory: 3115000k/3144524k available (1626k kernel code, 28400k reserved, 675k data, 172k init, 2227020k highmem)
[    6.113162] virtual kernel memory layout:
[    6.113162]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    6.113163]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    6.113164]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    6.113165]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    6.113165]       .init : 0xc0344000 - 0xc036f000   ( 172 kB)
[    6.113166]       .data : 0xc0296a66 - 0xc033f9e0   ( 675 kB)
[    6.113167]       .text : 0xc0100000 - 0xc0296a66   (1626 kB)
[    6.114079] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[    6.114520] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    6.114974] hpet0: 3 64-bit timers, 14318180 Hz
[    6.199296] Calibrating delay using timer specific routine.. 4327.44 BogoMIPS (lpj=7210311)
[    6.199563] Mount-cache hash table entries: 512
[    6.199784] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
[    6.199789] monitor/mwait feature present.
[    6.199903] using mwait in idle threads.
[    6.200019] CPU: L1 I cache: 32K, L1 D cache: 32K
[    6.200217] CPU: L2 cache: 4096K
[    6.200331] CPU: Physical Processor ID: 0
[    6.200445] CPU: Processor Core ID: 0
[    6.200558] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
[    6.200563] Intel machine check architecture supported.
[    6.200679] Intel machine check reporting enabled on CPU#0.
[    6.200797] Compat vDSO mapped to ffffe000.
[    6.200922] Checking 'hlt' instruction... OK.
[    6.212908] SMP alternatives: switching to UP code
[    6.213510] ACPI: Core revision 20070126
[    6.216032] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    6.216329] SMP alternatives: switching to SMP code
[    6.216743] Booting processor 1/1 eip 3000
[    6.216855] CPU 1 irqstacks, hard=c0375000 soft=c0373000
[    8.103293] Initializing CPU#1
[    8.185199] Calibrating delay using timer specific routine.. 4324.63 BogoMIPS (lpj=7204220)
[    8.185205] CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001 00000000
[    8.185209] monitor/mwait feature present.
[    8.185211] CPU: L1 I cache: 32K, L1 D cache: 32K
[    8.185213] CPU: L2 cache: 4096K
[    8.185214] CPU: Physical Processor ID: 0
[    8.185215] CPU: Processor Core ID: 1
[    8.185216] CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001 00000000
[    8.185220] Intel machine check architecture supported.
[    8.185223] Intel machine check reporting enabled on CPU#1.
[    6.313015] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    6.314330] Total of 2 processors activated (8652.08 BogoMIPS).
[    6.314635] ENABLING IO-APIC IRQs
[    6.314933] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    6.452320] checking TSC synchronization [CPU#0 -> CPU#1]:
[    6.472490] Measured 4054353953 cycles TSC warp between CPUs, turning off TSC clock.
[    6.472629] Marking TSC unstable due to: check_tsc_sync_source failed.
[    6.472752] Brought up 2 CPUs
[    6.473050] NET: Registered protocol family 16
[    6.473286] ACPI: bus type pci registered
[    6.473458] PCI: Using MMCONFIG
[    6.474324] Setting up standard PCI resources
[    6.479860] ACPI: EC: Look up EC in DSDT
[    6.483426] ACPI: Interpreter enabled
[    6.483539] ACPI: (supports S0 S3 S4 S5)
[    6.483993] ACPI: Using IOAPIC for interrupt routing
[    6.497081] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    6.497724] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    6.497840] PCI quirk: region 1080-10bf claimed by ICH6 GPIO
[    6.499051] PCI: Transparent bridge - 0000:00:1e.0
[    6.499225] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    6.499534] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    6.499606] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    6.499701] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    6.499788] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    6.499873] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    6.506240] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 11) *4
[    6.506938] ACPI: PCI Interrupt Link [LNKB] (IRQs *5 7)
[    6.507464] ACPI: PCI Interrupt Link [LNKC] (IRQs *9 10 11)
[    6.508078] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
[    6.508966] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    6.510274] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
[    6.511588] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    6.512905] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
[    6.514248] Linux Plug and Play Support v0.97 (c) Adam Belay
[    6.514381] pnp: PnP ACPI init
[    6.514496] ACPI: bus type pnp registered
[    6.537611] pnp: PnP ACPI: found 12 devices
[    6.537724] ACPI: ACPI bus type pnp unregistered
[    6.537975] SCSI subsystem initialized
[    8.410882] libata version 2.21 loaded.
[    8.410978] PCI: Using ACPI for IRQ routing
[    8.411090] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    8.418750] ACPI: RTC can wake from S4
[    6.548707] Time: hpet clocksource has been installed.
[    6.548833] Switched to high resolution mode on CPU 0
[    8.422048] Switched to high resolution mode on CPU 1
[    8.432341] pnp: 00:00: iomem range 0x0-0x9fbff could not be reserved
[    8.432455] pnp: 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[    8.432569] pnp: 00:00: iomem range 0xc0000-0xcffff could not be reserved
[    8.432683] pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
[    8.432802] pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    8.432915] pnp: 00:02: ioport range 0x1000-0x1005 has been reserved
[    8.433029] pnp: 00:02: ioport range 0x1008-0x100f has been reserved
[    8.433145] pnp: 00:03: ioport range 0xf400-0xf4fe has been reserved
[    8.433259] pnp: 00:03: ioport range 0x1006-0x1007 has been reserved
[    8.433373] pnp: 00:03: ioport range 0x100a-0x1059 could not be reserved
[    8.433486] pnp: 00:03: ioport range 0x1060-0x107f has been reserved
[    8.433600] pnp: 00:03: ioport range 0x1080-0x10bf has been reserved
[    8.433714] pnp: 00:03: ioport range 0x10c0-0x10df has been reserved
[    8.433831] pnp: 00:08: ioport range 0xc80-0xcff could not be reserved
[    8.433945] pnp: 00:08: ioport range 0x910-0x91f has been reserved
[    8.434059] pnp: 00:08: ioport range 0x920-0x92f has been reserved
[    8.434172] pnp: 00:08: ioport range 0xcb0-0xcbf has been reserved
[    8.434286] pnp: 00:08: ioport range 0x930-0x97f has been reserved
[    8.434403] pnp: 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
[    8.464742] PCI: Bridge: 0000:00:01.0
[    8.464857]   IO window: e000-efff
[    8.464966]   MEM window: efd00000-efefffff
[    8.465078]   PREFETCH window: d0000000-dfffffff
[    8.465191] PCI: Bridge: 0000:00:1c.0
[    8.465302]   IO window: disabled.
[    8.465416]   MEM window: disabled.
[    8.465530]   PREFETCH window: disabled.
[    8.465650] PCI: Bridge: 0000:00:1c.1
[    8.465761]   IO window: disabled.
[    8.465875]   MEM window: efc00000-efcfffff
[    8.465985]   PREFETCH window: disabled.
[    8.466100] PCI: Bridge: 0000:00:1c.3
[    8.466213]   IO window: d000-dfff
[    8.466327]   MEM window: efa00000-efbfffff
[    8.466441]   PREFETCH window: e0000000-e01fffff
[    8.466557] PCI: Bridge: 0000:00:1e.0
[    8.466668]   IO window: disabled.
[    8.467899]   MEM window: ef900000-ef9fffff
[    8.468013]   PREFETCH window: disabled.
[    8.468140] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    8.468365] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    8.468383] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    8.468608] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    8.468628] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
[    8.468854] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    8.468873] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 18
[    8.469105] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    8.469116] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    8.469148] NET: Registered protocol family 2
[    8.502220] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    8.502413] TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
[    8.503312] TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
[    8.503777] TCP: Hash tables configured (established 131072 bind 65536)
[    8.503891] TCP reno registered
[    8.512288] Simple Boot Flag at 0x79 set to 0x1
[    8.512960] highmem bounce pool size: 64 pages
[    8.513245] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    8.513381] io scheduler noop registered
[    8.513492] io scheduler anticipatory registered
[    8.513615] io scheduler cfq registered (default)
[    8.513822] Boot video device is 0000:01:00.0
[    8.513906] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    8.513922] assign_interrupt_mode Found MSI capability
[    8.514035] Allocate Port Service[0000:00:01.0:pcie00]
[    8.514066] Allocate Port Service[0000:00:01.0:pcie03]
[    8.514119] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    8.514165] assign_interrupt_mode Found MSI capability
[    8.514278] Allocate Port Service[0000:00:1c.0:pcie00]
[    8.514307] Allocate Port Service[0000:00:1c.0:pcie02]
[    8.514335] Allocate Port Service[0000:00:1c.0:pcie03]
[    8.514415] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    8.514461] assign_interrupt_mode Found MSI capability
[    8.514574] Allocate Port Service[0000:00:1c.1:pcie00]
[    8.514602] Allocate Port Service[0000:00:1c.1:pcie02]
[    8.514630] Allocate Port Service[0000:00:1c.1:pcie03]
[    8.514716] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    8.514763] assign_interrupt_mode Found MSI capability
[    8.514872] Allocate Port Service[0000:00:1c.3:pcie00]
[    8.514898] Allocate Port Service[0000:00:1c.3:pcie02]
[    8.514924] Allocate Port Service[0000:00:1c.3:pcie03]
[    8.530609] hpet_resources: 0xfed00000 is busy
[    8.530655] Generic RTC Driver v1.07
[    8.530796] Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
[    8.531197] RAMDISK driver initialized: 4 RAM disks of 8192K size 1024 blocksize
[    8.531504] ata_piix 0000:00:1f.2: version 2.12
[    8.531509] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    8.531978] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 17 (level, low) -> IRQ 17
[    8.532237] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    8.532303] scsi0 : ata_piix
[    8.532465] scsi1 : ata_piix
[    8.532615] ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001bfa0 irq 14
[    8.532755] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001bfa8 irq 15
[    6.818767] ata1.00: ATA-7: ST9160823AS, 3.AAB, max UDMA/133
[    6.818881] ata1.00: 312581808 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    6.832077] ata1.00: configured for UDMA/133
[    7.144872] ata2.00: ATAPI: SONY DVD RW DW-Q58A, UYS2, max UDMA/33
[    7.311187] ata2.00: configured for UDMA/33
[    9.184147] scsi 0:0:0:0: Direct-Access     ATA      ST9160823AS      3.AA PQ: 0 ANSI: 5
[    9.184358] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    9.184489] sd 0:0:0:0: [sda] Write Protect is off
[    9.184601] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.184614] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.184788] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    9.184908] sd 0:0:0:0: [sda] Write Protect is off
[    9.185020] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    9.185033] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.185172]  sda: sda1 sda2 sda3
[    9.187971] sd 0:0:0:0: [sda] Attached SCSI disk
[    9.188784] scsi 1:0:0:0: CD-ROM            SONY     DVD RW DW-Q58A   UYS2 PQ: 0 ANSI: 5
[    9.189090] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    9.192124] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.192239] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.319695] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    7.319851] rtc0: alarms up to one month, y3k
[    7.320010] TCP cubic registered
[    7.320125] Starting balanced_irq
[    7.320265] Using IPI No-Shortcut mode
[    7.326131] input: AT Translated Set 2 keyboard as /class/input/input0
[    7.347435] rtc_cmos 00:06: setting the system clock to 2007-12-02 15:29:04 (1196609344)
[    7.387122] kjournald starting.  Commit interval 5 seconds
[    7.387240] EXT3-fs: mounted filesystem with ordered data mode.
[    7.387368] VFS: Mounted root (ext3 filesystem) readonly.
[    7.387570] Freeing unused kernel memory: 172k freed
[    9.834090] NET: Registered protocol family 1
[   16.192600] ACPI: SSDT BFED4134, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
[   16.193094] ACPI: SSDT BFED3EE9, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
[   16.193578] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   16.194031] ACPI: Processor [CPU0] (supports 8 throttling states)
[   16.194473] ACPI: SSDT BFED4378, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
[   16.194907] ACPI: SSDT BFED40AF, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
[   16.195411] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   16.195862] ACPI: Processor [CPU1] (supports 8 throttling states)
[   16.213685] input: Lid Switch as /class/input/input1
[   16.213824] ACPI: Lid Switch [LID]
[   16.213977] input: Power Button (CM) as /class/input/input2
[   16.214110] ACPI: Power Button (CM) [PBTN]
[   16.214261] input: Sleep Button (CM) as /class/input/input3
[   16.214389] ACPI: Sleep Button (CM) [SBTN]
[   16.236937] ACPI: Thermal Zone [THM] (53 C)
[   18.240321] ACPI: Battery Slot [BAT0] (battery present)
[   18.252298] Linux agpgart interface v0.102
[   16.388095] usbcore: registered new interface driver usbfs
[   16.388234] usbcore: registered new interface driver hub
[   16.388368] usbcore: registered new device driver usb
[   18.278949] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.279093] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[   18.282079] ACPI: AC Adapter [AC] (on-line)
[   18.286860] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 19
[   18.287090] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   18.287093] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   18.287510] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   18.287682] ehci_hcd 0000:00:1d.7: debug port 1
[   18.287798] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   18.287806] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xffa80000
[   18.291801] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   18.292067] usb usb1: configuration #1 chosen from 1 choice
[   18.292216] hub 1-0:1.0: USB hub found
[   18.292338] hub 1-0:1.0: 8 ports detected
[   16.422010] USB Universal Host Controller Interface driver v3.0
[   18.297635] intel_rng: FWH not detected
[   16.444131] input: PC Speaker as /class/input/input4
[   16.447586] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[   16.447702] Uniform CD-ROM driver Revision: 3.20
[   16.447863] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   18.337541] sdhci: Secure Digital Host Controller Interface driver
[   18.337659] sdhci: Copyright(c) Pierre Ossman
[   18.387455] b44.c:v1.01 (Jun 16, 2006)
[   18.387590] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   18.391338] eth0: Broadcom 4400 10/100BaseT Ethernet 00:18:8b:a7:bf:42
[   16.519229] ACPI: PCI Interrupt 0000:03:01.0[A] -> GSI 19 (level, low) -> IRQ 18
[   18.463138] firewire_ohci: Added fw-ohci device 0000:03:01.0, OHCI version 1.10
[   18.463341] sdhci: SDHCI controller found at 0000:03:01.1 [1180:0822] (rev 19)
[   18.463494] ACPI: PCI Interrupt 0000:03:01.1[B] -> GSI 18 (level, low) -> IRQ 20
[   18.463780] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 19
[   18.464013] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   18.464016] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   18.464169] mmc0: SDHCI at 0xef9fd400 irq 20 DMA
[   18.464304] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   18.464475] uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000bf80
[   18.464711] usb usb2: configuration #1 chosen from 1 choice
[   18.464861] hub 2-0:1.0: USB hub found
[   18.464978] hub 2-0:1.0: 2 ports detected
[   16.672810] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
[   16.673047] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   16.673050] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   16.673185] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   16.674529] uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000bf60
[   16.674741] usb usb3: configuration #1 chosen from 1 choice
[   16.674879] hub 3-0:1.0: USB hub found
[   16.674995] hub 3-0:1.0: 2 ports detected
[   16.681775] usb 1-1: new high speed USB device using ehci_hcd and address 2
[   16.718290] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 22 (level, low) -> IRQ 22
[   16.718549] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   16.718551] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   16.718694] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   16.718869] uhci_hcd 0000:00:1d.2: irq 22, io base 0x0000bf40
[   16.719095] usb usb4: configuration #1 chosen from 1 choice
[   16.719256] hub 4-0:1.0: USB hub found
[   16.719394] hub 4-0:1.0: 2 ports detected
[   16.756300] usb 1-1: configuration #1 chosen from 1 choice
[   16.756567] hub 1-1:1.0: USB hub found
[   16.756749] hub 1-1:1.0: 4 ports detected
[   16.776034] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
[   16.776279] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   16.776282] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   16.776419] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   16.776595] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000bf20
[   16.776833] usb usb5: configuration #1 chosen from 1 choice
[   16.776990] hub 5-0:1.0: USB hub found
[   16.777119] hub 5-0:1.0: 2 ports detected
[   16.791088] Synaptics Touchpad, model: 1, fw: 6.2, id: 0xfa0b1, caps: 0xa04713/0x200000
[   16.815906] input: SynPS/2 Synaptics TouchPad as /class/input/input5
[   16.836733] mice: PS/2 mouse device common for all mice
[   18.717449] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 21 (level, low) -> IRQ 21
[   18.717694] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   16.927718] firewire_core: created new fw device fw0 (0 config rom retries, S400)
[   17.030934] usb 1-5: new high speed USB device using ehci_hcd and address 3
[   17.101823] fuse init (API version 7.8)
[   17.155328] usb 1-5: configuration #1 chosen from 1 choice
[   17.155755] hub 1-5:1.0: USB hub found
[   17.156119] hub 1-5:1.0: 4 ports detected
[   17.502517] NET: Registered protocol family 17
[   17.686610] usb 1-5.1: new low speed USB device using ehci_hcd and address 4
[   17.774233] usb 1-5.1: configuration #1 chosen from 1 choice
[   19.649731] usbcore: registered new interface driver usbserial
[   19.650358] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   19.650984] usbcore: registered new interface driver usbserial_generic
[   19.651101] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   17.780071] drivers/usb/serial/usb-serial.c: USB Serial support registered for Handspring Visor / Palm OS
[   17.780225] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 3.5
[   17.780384] drivers/usb/serial/usb-serial.c: USB Serial support registered for Sony Clie 5.0
[   17.780540] usbcore: registered new interface driver visor
[   17.780658] drivers/usb/serial/visor.c: USB HandSpring Visor / Palm OS driver
[   17.791685] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   17.793687] pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
[   17.793852] pciehp: pciehp_enable_slot: no adapter on slot(0011_0002)
[   17.793971] Load service driver hpdriver on pcie device 0000:00:1c.0:pcie02
[   17.793986] pciehp: HPC vendor_id 8086 device_id 27d2 ss_vid 0 ss_did 0
[   19.671719] usbcore: registered new interface driver hiddev
[   17.801165] input: Logitech Optical USB Mouse as /class/input/input6
[   17.801407] input: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.7-5.1
[   17.801722] usbcore: registered new interface driver usbhid
[   17.801835] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   18.794488] pciehp: Device 0000:0c:00.0 already exists at c:0, cannot hot-add
[   18.794607] pciehp: Cannot add device 0xc:0
[   18.794739] Load service driver hpdriver on pcie device 0000:00:1c.1:pcie02
[   18.794759] pciehp: HPC vendor_id 8086 device_id 27d6 ss_vid 0 ss_did 0
[   18.795492] pciehp: pciehp_enable_slot: no adapter on slot(0013_0005)
[   18.795603] Load service driver hpdriver on pcie device 0000:00:1c.3:pcie02
[   18.795609] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[   18.812749] Adding 2064344k swap on /dev/sda3.  Priority:-1 extents:1 across:2064344k
[   18.921802] EXT3 FS on sda1, internal journal
[   19.100555] kjournald starting.  Commit interval 5 seconds
[   19.100683] EXT3 FS on sda2, internal journal
[   19.100686] EXT3-fs: mounted filesystem with ordered data mode.
[   21.259819] b44: eth0: Link is up at 100 Mbps, full duplex.
[   21.259821] b44: eth0: Flow control is off for TX and off for RX.
[   23.723141] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   26.877950] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   25.061099] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   26.934033] NFSD: starting 90-second grace period
[   27.848839] Bluetooth: Core ver 2.11
[   27.848920] NET: Registered protocol family 31
[   27.848923] Bluetooth: HCI device and connection manager initialized
[   27.848927] Bluetooth: HCI socket layer initialized
[   27.896212] Bluetooth: L2CAP ver 2.8
[   27.896219] Bluetooth: L2CAP socket layer initialized
[   26.149743] Bluetooth: RFCOMM socket layer initialized
[   26.149762] Bluetooth: RFCOMM TTY layer initialized
[   26.149765] Bluetooth: RFCOMM ver 1.8
[   29.826083] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>

Module                  Size  Used by
microcode              10292  0 
binfmt_misc            11400  1 
rfcomm                 36632  5 
l2cap                  22528  5 rfcomm
bluetooth              50916  4 rfcomm,l2cap
nfs                   235596  0 
nfsd                  206768  17 
exportfs                5184  1 nfsd
lockd                  61000  3 nfs,nfsd
nfs_acl                 3456  2 nfs,nfsd
auth_rpcgss            39648  1 nfsd
sunrpc                160924  9 nfs,nfsd,lockd,nfs_acl,auth_rpcgss
acpi_cpufreq            8980  1 
cpufreq_stats           5840  0 
cpufreq_userspace       4076  0 
cpufreq_ondemand        8268  1 
freq_table              4424  3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand
cpufreq_powersave       1728  0 
container               4864  0 
fan                     4996  0 
firmware_class          9600  1 microcode
usbhid                 27200  0 
hid                    25984  1 usbhid
pciehp                 34968  0 
pci_hotplug            14408  1 pciehp
visor                  18508  0 
af_packet              21128  2 
usbserial              32616  1 visor
fuse                   42196  1 
firewire_sbp2          12804  0 
mousedev               11848  1 
snd_hda_intel         258844  4 
snd_pcm_oss            36960  0 
snd_pcm                66500  3 snd_hda_intel,snd_pcm_oss
snd_mixer_oss          15296  1 snd_pcm_oss
snd_seq_dummy           3716  0 
snd_seq_oss            29568  0 
snd_seq_midi            8032  0 
snd_rawmidi            22560  1 snd_seq_midi
snd_seq_midi_event      6848  2 snd_seq_oss,snd_seq_midi
sdhci                  16908  0 
snd_seq                46800  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
mmc_core               27652  1 sdhci
pcspkr                  3008  0 
sr_mod                 15268  0 
cdrom                  32480  1 sr_mod
firewire_ohci          16448  0 
firewire_core          39040  2 firewire_sbp2,firewire_ohci
b44                    24972  0 
mii                     5248  1 b44
uhci_hcd               22732  0 
ehci_hcd               32268  0 
ac                      5572  0 
sg                     32412  0 
crc_itu_t               2112  1 firewire_core
usbcore               131016  6 usbhid,visor,usbserial,uhci_hcd,ehci_hcd
intel_agp              23316  0 
agpgart                31564  1 intel_agp
serio_raw               6660  0 
psmouse                29640  0 
battery                12168  0 
snd_timer              21188  3 snd_pcm,snd_seq
snd_seq_device          7756  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    48804  15 snd_hda_intel,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore               7904  1 snd
snd_page_alloc          9992  2 snd_hda_intel,snd_pcm
button                  8208  0 
thermal                15516  0 
processor              34304  2 acpi_cpufreq,thermal
unix                   26480  368 

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
	Flags: bus master, fast devsel, latency 0, IRQ 21
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
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at bf60 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 22
	I/O ports at bf40 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01) (prog-if 00 [UHCI])
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 23
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
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at ef9fd400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

03:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
	Subsystem: Dell Unknown device 01cd
	Flags: bus master, medium devsel, latency 0, IRQ 9
	Memory at ef9fd500 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 0a)
	Subsystem: Dell Unknown device 01cd
	Flags: medium devsel, IRQ 9
	Memory at ef9fd600 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
	Subsystem: Dell Unknown device 01cd
	Flags: medium devsel, IRQ 9
	Memory at ef9fd700 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

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
C0 (cpu running)        ( 2.9%)         2.17 Ghz     0.0%
C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
C2                3.8ms ( 9.5%)         1333 Mhz     0.0%
C3                5.2ms (87.6%)         1000 Mhz   100.0%


Wakeups-from-idle per second : 194.5    interval: 5.0s
no ACPI power usage estimate available

Top causes for wakeups:
  31.4% ( 47.0)       <interrupt> : uhci_hcd:usb3, HDA Intel
  25.9% ( 38.8)       <interrupt> : extra timer interrupt
   8.3% ( 12.4)            kicker : schedule_timeout (process_timeout)
   7.5% ( 11.2)              Xorg : do_setitimer (it_real_fn)
   6.7% ( 10.0)     <kernel core> : ehci_work (ehci_watchdog)
   6.4% (  9.6)             artsd : schedule_timeout (process_timeout)
   3.3% (  5.0)            dhcdbd : schedule_timeout (process_timeout)
   1.3% (  2.0)     passkey-agent : schedule_timeout (process_timeout)
   1.3% (  2.0)           klipper : schedule_timeout (process_timeout)
   0.9% (  1.4)       <interrupt> : libata
   0.7% (  1.0)        atieventsd : schedule_timeout (process_timeout)
   0.7% (  1.0)          ifconfig : b44_open (b44_timer)
   0.7% (  1.0)          kwrapper : do_nanosleep (hrtimer_wakeup)
   0.7% (  1.0)             artsd : do_setitimer (it_real_fn)
   0.7% (  1.0)              ntpd : do_setitimer (it_real_fn)
   0.4% (  0.6)              kded : schedule_timeout (process_timeout)
   0.4% (  0.6)          kdesktop : schedule_timeout (process_timeout)
   0.3% (  0.4)           konsole : schedule_timeout (process_timeout)
   0.3% (  0.4)             kirqd : schedule_timeout (process_timeout)
   0.3% (  0.4)     <kernel core> : queue_delayed_work_on (delayed_work_timer_fn)
   0.3% (  0.4)               gpm : do_nanosleep (hrtimer_wakeup)
   0.3% (  0.4)              kwin : schedule_timeout (process_timeout)
   0.1% (  0.2)       <interrupt> : PS/2 keyboard/mouse/touchpad
   0.1% (  0.2)    adept_notifier : schedule_timeout (process_timeout)
   0.1% (  0.2)              Xorg : schedule_timeout (process_timeout)
   0.1% (  0.2)           syslogd : do_setitimer (it_real_fn)
   0.1% (  0.2)              hald : schedule_timeout (process_timeout)
   0.1% (  0.2)     <kernel core> : __netdev_watchdog_up (dev_watchdog)
   0.1% (  0.2)   <kernel module> : nfsacl_decode (delayed_work_timer_fn)
   0.1% (  0.2)         ssh-agent : do_setitimer (it_real_fn)
   0.1% (  0.2)        rpc.idmapd : schedule_timeout (process_timeout)
   0.1% (  0.2)   guidance-power- : schedule_timeout (process_timeout)
   0.1% (  0.2)           konsole : end_that_request_last (laptop_timer_fn)


