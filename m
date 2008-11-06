Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYKFKX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYKFKX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYKFKXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:23:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45132 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbYKFKXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:23:12 -0500
Date: Thu, 6 Nov 2008 11:23:09 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: 2.6.28-rc2-mm1: multiple BUG: scheduling while atomic: swapper, first in acpi_idle_enter_simple, then fbcon has problems
Message-ID: <20081106102309.GA334@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


...kernel contains experimental version of HP accelerometer driver and
new HP acclerometer LED, but hopefully they are not causing this?




BIOS EBDA/lowmem at: 0009fc00/0009fc00
Linux version 2.6.28-rc2-mm1 (pavel@amd) (gcc version 4.1.3 20080623 (prerelease) (Debian 4.1.2-23)) #1 SMP Thu Nov 6 10:28:45 CET 2008
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
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e3000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001beb0000 (usable)
 BIOS-e820: 000000001beb0000 - 000000001bebe000 (ACPI data)
 BIOS-e820: 000000001bebe000 - 000000001bef0000 (ACPI NVS)
 BIOS-e820: 000000001bef0000 - 000000001bf00000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x1beb0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 1beb0000 @ 7000-7b000
ACPI: RSDP 000F9EB0, 0024 (r2 HP    )
ACPI: XSDT 1BEB0100, 0064 (r1 HP     XSDT0956 20080402 MSFT       97)
ACPI: FACP 1BEB0290, 00F4 (r4 HP     FACP0956 20080402 MSFT       97)
ACPI: DSDT 1BEB0600, 906B (r2  68VGU 68VGUF02      F02 INTL 20061109)
ACPI: FACS 1BEBE000, 0040
ACPI: APIC 1BEB0390, 0060 (r2 HP     APIC0956 20080402 MSFT       97)
ACPI: MCFG 1BEB03F0, 003C (r1 HP     OEMMCFG  20080402 MSFT       97)
ACPI: SLIC 1BEB0430, 0176 (r1 HP     SLIC0956 20080402 MSFT       97)
ACPI: WDRT 1BEB05B0, 0047 (r1 HP     VT-8237S 20080402 MSFT       97)
ACPI: OEMB 1BEBE040, 00F0 (r1 HP     OEMB0956 20080402 MSFT       97)
ACPI: HPET 1BEB9670, 0038 (r1 HP     VT-8237S 20080402 MSFT       97)
ACPI: SSDT 1BEBE130, 03A0 (r1    HP    P001PM        1 INTL 20051117)
ACPI: DMI detected: Hewlett-Packard
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
446MB LOWMEM available.
  mapped low ram: 0 - 1beb0000
  low ram: 00000000 - 1beb0000
  bootmap 00002000 - 000057d8
(8 early reservations) ==> bootmem [0000000000 - 001beb0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000200000 - 0000eb4434]    TEXT DATA BSS ==> [0000200000 - 0000eb4434]
  #4 [0000eb5000 - 0000ecb000]    INIT_PG_TABLE ==> [0000eb5000 - 0000ecb000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000007000 - 0000062000]          PGTABLE ==> [0000007000 - 0000062000]
  #7 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
found SMP MP-table at [c00ff780] 000ff780
sizeof(struct page) = 32
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001beb0
  HighMem  0x0001beb0 -> 0x0001beb0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001beb0
On node 0 totalpages: 114255
Node 0 memmap at 0xc1001000 size 3670016 first pfn 0xc1001000
free_area_init_node: node 0, pgdat c0a09e00, node_mem_map c1001000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 862 pages used for memmap
  Normal zone: 109394 pages, LIFO batch:31
  HighMem zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x02] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 2, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
ACPI: HPET id: 0x11068201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 1 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e3000
PM: Registered nosave memory: 00000000000e3000 - 0000000000100000
Allocating PCI resources starting at 20000000 (gap: 1bf00000:e2d00000)
PERCPU: Allocating 32768 bytes of per cpu data
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:1 nr_node_ids:1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 113361
Kernel command line: root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps vga=791 init=/tmp/swsusp-init acpi_sleep=s3_bios,s3_mode no_console_suspend
Unknown boot option `psmouse.psmouse_proto=imps': ignoring
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Extended CMOS year: 2000
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 997.504 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 2335 kB
 per task-struct memory footprint: 1152 bytes
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 439364k/457408k available (5633k kernel code, 17536k reserved, 2710k data, 384k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdc6b0000 - 0xff7fe000   ( 561 MB)
    lowmem  : 0xc0000000 - 0xdbeb0000   ( 446 MB)
      .init : 0xc0a2f000 - 0xc0a8f000   ( 384 kB)
      .data : 0xc0780799 - 0xc0a260ac   (2710 kB)
      .text : 0xc0200000 - 0xc0780799   (5633 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 1995.00 BogoMIPS (lpj=3990016)
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
debug: unmapping init memory c0a2a000..c0a2f000
ACPI: Core revision 20080926
Parsing all Control Methods:
Table [DSDT](id 0001) - 1009 Objects with 79 Devices 249 Methods 32 Regions
Parsing all Control Methods:
Table [SSDT](id 0002) - 11 Objects with 0 Devices 5 Methods 0 Regions
 tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Centaur VIA C7-M Processor 1000MHz stepping 00
Brought up 1 CPUs
Total of 1 processors activated (1995.00 BogoMIPS).
CPU0 attaching NULL sched-domain.
net_namespace: 568 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
PCI: Using configuration type 1 for base access
evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int 0x9
evgpeblk-0957 [00] ev_create_gpe_block   : GPE 10 to 2F [_GPE] 4 regs on int 0x9
ACPI: EC: Look up EC in DSDT
Completing Region/Field/Buffer/Package initialization:.............................................................................................................................................................
Initialized 30/32 Regions 39/39 Fields 51/53 Buffers 37/38 Packages (1029 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:...
Executed 3 _INI methods requiring 1 _STA executions (examined 83 objects)
evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 2 Wake, Enabled 0 Runtime GPEs in this block
evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 1 Runtime GPEs in this block
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:0f.0: reg 10 io port: [0xcc00-0xcc07]
pci 0000:00:0f.0: reg 14 io port: [0xc880-0xc883]
pci 0000:00:0f.0: reg 18 io port: [0xc800-0xc807]
pci 0000:00:0f.0: reg 1c io port: [0xc480-0xc483]
pci 0000:00:0f.0: reg 20 io port: [0xc400-0xc40f]
pci 0000:00:0f.0: reg 24 io port: [0xc000-0xc0ff]
pci 0000:00:10.0: reg 20 io port: [0xb800-0xb81f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0xb880-0xb89f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.3: reg 20 io port: [0xbc00-0xbc1f]
pci 0000:00:10.3: supports D1 D2
pci 0000:00:10.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.3: PME# disabled
pci 0000:00:10.4: reg 10 32bit mmio: [0xfbeffc00-0xfbeffcff]
pci 0000:00:10.4: supports D1 D2
pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.4: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xdbffffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xfc000000-0xfcffffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0xfbff0000-0xfbffffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge 32bit mmio: [0xfbf00000-0xfcffffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xd8000000-0xdbffffff]
pci 0000:02:00.0: reg 10 64bit mmio: [0xfdffc000-0xfdffffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:02.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:02.0: bridge 32bit mmio: [0xfd000000-0xfdffffff]
pci 0000:00:02.0: bridge 64bit mmio pref: [0xde000000-0xdfffffff]
pci 0000:00:03.0: bridge io port: [0xe000-0xefff]
pci 0000:00:03.0: bridge 32bit mmio: [0xfe000000-0xfe9fffff]
pci 0000:00:03.0: bridge 64bit mmio pref: [0xf8000000-0xfaffffff]
pci 0000:07:03.0: reg 10 32bit mmio: [0xfeaf0000-0xfeafffff]
pci 0000:07:03.0: PME# supported from D3hot D3cold
pci 0000:07:03.0: PME# disabled
pci 0000:00:13.1: transparent bridge
pci 0000:00:13.1: bridge 32bit mmio: [0xfea00000-0xfeafffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBP0._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
pci 0000:80:01.0: reg 10 64bit mmio: [0xfebfc000-0xfebfffff]
pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
pci 0000:80:01.0: PME# disabled
bus 80 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: Power Resource [APMF] (off)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Bluetooth: Core ver 2.13
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Failed calling CRDA
cfg80211: calling CRDA failed - unable to update world regulatory domain, using static definition
Switched to NOHz mode on CPU #0
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:05: ioport range 0x3e0-0x3e7 has been reserved
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:05: ioport range 0x500-0x501 has been reserved
system 00:05: ioport range 0x800-0x87f has been reserved
system 00:05: ioport range 0x400-0x41f has been reserved
system 00:05: iomem range 0xfecc0000-0xfecc0fff could not be reserved
system 00:05: iomem range 0xfed02000-0xfed02fff has been reserved
system 00:08: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:08: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0x1befffff could not be reserved
system 00:0c: iomem range 0xfec00000-0xffffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfbf00000-0xfcffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dbffffff
pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: 0xd000-0xdfff
pci 0000:00:02.0:   MEM window: 0xfd000000-0xfdffffff
pci 0000:00:02.0:   PREFETCH window: 0x000000de000000-0x000000dfffffff
pci 0000:00:03.0: PCI bridge, secondary bus 0000:05
pci 0000:00:03.0:   IO window: 0xe000-0xefff
pci 0000:00:03.0:   MEM window: 0xfe000000-0xfe9fffff
pci 0000:00:03.0:   PREFETCH window: 0x000000f8000000-0x000000faffffff
pci 0000:00:13.1: PCI bridge, secondary bus 0000:07
pci 0000:00:13.1:   IO window: disabled
pci 0000:00:13.1:   MEM window: 0xfea00000-0xfeafffff
pci 0000:00:13.1:   PREFETCH window: disabled
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: PCI INT A -> GSI 27 (level, low) -> IRQ 27
pci 0000:00:02.0: setting latency timer to 64
pci 0000:00:03.0: PCI INT A -> GSI 31 (level, low) -> IRQ 31
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:13.1: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 mmio: [0x0-0x0]
bus: 01 index 1 mmio: [0xfbf00000-0xfcffffff]
bus: 01 index 2 mmio: [0xd8000000-0xdbffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xd000-0xdfff]
bus: 02 index 1 mmio: [0xfd000000-0xfdffffff]
bus: 02 index 2 mmio: [0xde000000-0xdfffffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0xe000-0xefff]
bus: 05 index 1 mmio: [0xfe000000-0xfe9fffff]
bus: 05 index 2 mmio: [0xf8000000-0xfaffffff]
bus: 05 index 3 mmio: [0x0-0x0]
bus: 07 index 0 mmio: [0x0-0x0]
bus: 07 index 1 mmio: [0xfea00000-0xfeafffff]
bus: 07 index 2 mmio: [0x0-0x0]
bus: 07 index 3 io port: [0x00-0xffff]
bus: 07 index 4 mmio: [0x000000-0xffffffff]
bus: 80 index 0 io port: [0x00-0xffff]
bus: 80 index 1 mmio: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
NTFS driver 2.1.29 [Flags: R/O DEBUG].
JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
fuse init (API version 7.10)
msgmni has been set to 858
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
PCI: VIA PCI bridge detected.Disabling DAC.
pci 0000:00:10.0: uhci_check_and_reset_hc: legsup = 0x8030
pci 0000:00:10.0: Performing full reset
pci 0000:00:10.2: uhci_check_and_reset_hc: legsup = 0x8030
pci 0000:00:10.2: Performing full reset
pci 0000:00:10.3: uhci_check_and_reset_hc: legsup = 0x8030
pci 0000:00:10.3: Performing full reset
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie01: allocate port service
pci_express 0000:00:02.0:pcie02: allocate port service
pci_express 0000:00:02.0:pcie03: allocate port service
pcieport-driver 0000:00:03.0: setting latency timer to 64
pcieport-driver 0000:00:03.0: found MSI capability
pci_express 0000:00:03.0:pcie00: allocate port service
pci_express 0000:00:03.0:pcie01: allocate port service
pci_express 0000:00:03.0:pcie02: allocate port service
pci_express 0000:00:03.0:pcie03: allocate port service
aer 0000:00:02.0:pcie01: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie01: AER service couldn't init device: no _OSC support
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
vesafb: framebuffer at 0xd8000000, mapped to 0xdc780000, using 3072k, total 32768k
vesafb: mode is 1024x768x16, linelength=2048, pages=20
vesafb: protected mode interface info at c000:819f
vesafb: pmi: set display start = c00c81ed, set palette = c00c8282
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 102x42
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [AC0] (on-line)
ACPI: Battery Slot [BAT1] (battery present)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
ACPI: Power Button (CM) [PWRB]
acpi device:0a: registered as cooling_device0
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:08/device:09/input/input4
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device1
ACPI: Processor [P001] (supports 16 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (56 C)
lp: driver loaded but no devices found
Non-volatile memory driver v1.2
VIA RNG detected
cs5535_gpio: DIVIL not found
Linux agpgart interface v0.103
agpgart: Detected VIA P4M900 chipset
agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xf0000000
[drm] Initialized drm 1.1.0 20060810
intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM chipsets
intelfb: Version 0.9.6
Serial: 8250/16550 driver4 ports, IRQ sharing disabled
floppy0: no floppy controllers found
loop: module loaded
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
tg3.c:v3.94 (August 14, 2008)
tg3 0000:07:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:07:03.0: firmware: using built-in firmware tigon/tg3_tso5.bin
eth0: Tigon3 [partno(BCM95788) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:1f:29:86:4c:5d
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
eth0: dma_rwctrl[763f0000] dma_mask[32-bit]
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
CSLIP: code copyright 1989 Regents of the University of California.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
usbcore: registered new interface driver asix
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
Broadcom 43xx driver loaded [ Features: PLR, Firmware-ID: FW13 ]
usbcore: registered new interface driver zd1211rw
usbcore: registered new interface driver zd1201
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2008 Intel Corporation
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
Probing IDE interface ide0...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide1 at 0x170-0x177,0x376 on irq 15
ide-gd driver 1.18
ide-cd driver 5.00
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
sata_via 0000:00:0f.0: version 2.3
sata_via 0000:00:0f.0: power state changed by ACPI to D0
sata_via 0000:00:0f.0: PCI INT B -> GSI 21 (level, low) -> IRQ 21
sata_via 0000:00:0f.0: routed to hard irq line 5
scsi0 : sata_via
scsi1 : sata_via
ata1: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 21
ata2: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-4: SMI MODEL, 20080308, max UDMA/66
ata1.00: 7831152 sectors, multi 0: LBA 
ata1.00: applying bridge limits
ata1.00: configured for UDMA/66
ata2: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      SMI MODEL        2008 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 7831152 512-byte hardware sectors: (4.00 GB/3.73 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 7831152 512-byte hardware sectors: (4.00 GB/3.73 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda4
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:10.4: PCI INT C -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:10.4: reset hcc_params 6872 thresh 7 uframes 256/512/1024
ehci_hcd 0000:00:10.4: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: MWI active
ehci_hcd 0000:00:10.4: supports USB remote wakeup
ehci_hcd 0000:00:10.4: irq 21, io mem 0xfbeffc00
ehci_hcd 0000:00:10.4: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:10.4: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28-rc2-mm1 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.0: UHCI Host Controller
ehci_hcd 0000:00:10.4: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2: status 0501 change 0001
ehci_hcd 0000:00:10.4: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 6: status 0501 change 0001
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: detected 2 ports
uhci_hcd 0000:00:10.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.0: Performing full reset
uhci_hcd 0000:00:10.0: supports USB remote wakeup
uhci_hcd 0000:00:10.0: irq 20, io base 0x0000b800
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28-rc2-mm1 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.0: port 1 portsc 008a,00
uhci_hcd 0000:00:10.0: port 2 portsc 009a,00
hub 1-0:1.0: state 7 ports 8 chg 0044 evt 0000
hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: detected 2 ports
uhci_hcd 0000:00:10.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.2: Performing full reset
uhci_hcd 0000:00:10.2: supports USB remote wakeup
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000b880
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
ehci_hcd 0000:00:10.4: port 2 full speed --> companion
ehci_hcd 0000:00:10.4: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
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
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28-rc2-mm1 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.2
uhci_hcd 0000:00:10.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:10.3: UHCI Host Controller
ehci_hcd 0000:00:10.4: GetStatus port 2 status 003802 POWER OWNER sig=j CSC
hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:10.2: port 1 portsc 008a,00
uhci_hcd 0000:00:10.2: port 2 portsc 008a,00
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: detected 2 ports
uhci_hcd 0000:00:10.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.3: Performing full reset
uhci_hcd 0000:00:10.3: supports USB remote wakeup
uhci_hcd 0000:00:10.3: irq 23, io base 0x0000bc00
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
ehci_hcd 0000:00:10.4: port 6 high speed
ehci_hcd 0000:00:10.4: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
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
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28-rc2-mm1 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.3
usb 1-6: new high speed USB device using ehci_hcd and address 3
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
uhci_hcd 0000:00:10.3: port 1 portsc 008a,00
uhci_hcd 0000:00:10.3: port 2 portsc 008a,00
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
ehci_hcd 0000:00:10.4: port 6 high speed
ehci_hcd 0000:00:10.4: GetStatus port 6 status 001005 POWER sig=se0 PE CONNECT
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usb 1-6: default language 0x0409
usb 1-6: uevent
usb 1-6: usb_probe_device
usb 1-6: configuration #1 chosen from 1 choice
usb 1-6: adding 1-6:1.0 (config #1, interface 0)
usb 1-6:1.0: uevent
usb-storage 1-6:1.0: usb_probe_interface
usb-storage 1-6:1.0: usb_probe_interface - got id
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
drivers/usb/core/inode.c: creating file '003'
usb 1-6: New USB device found, idVendor=058f, idProduct=6366
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6: Product: Mass Storage Device
usb 1-6: Manufacturer: Generic
usb 1-6: SerialNumber: 058F0O1111B1
hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0004
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
uhci_hcd 0000:00:10.0: port 2 portsc 0093,00
hub 2-0:1.0: port 2, status 0101, change 0001, 12 Mb/s
USB Serial support registered for GSM modem (1-port)
usbcore: registered new interface driver option
option: v0.7.2:USB Driver for GSM modems
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f12:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /devices/platform/pcspkr/input/input5
rtc_cmos 00:07: RTC can wake from S4
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 114 bytes nvram, , hpet irqs irqs
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x101
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Bluetooth: HCI UART driver ver 2.2
Bluetooth: HCI H4 protocol initialized
Bluetooth: HCI BCSP protocol initialized
Bluetooth: Generic Bluetooth USB driver ver 0.3
usbcore: registered new interface driver btusb
EDAC MC: Ver: 2.1.0 Nov  6 2008
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input6
usb 2-2: new full speed USB device using uhci_hcd and address 2
cpuidle: using governor ladder
cpuidle: using governor menu
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
Registered led device: hp:red:hddprotection
leds-hp-disk driver loaded.
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
Marking TSC unstable due to TSC halts in idle
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usbserial_generic 2-2:1.0: usb_probe_interface
usbserial_generic 2-2:1.0: usb_probe_interface - got id
btusb 2-2:1.0: usb_probe_interface
btusb 2-2:1.0: usb_probe_interface - got id
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
drivers/usb/core/inode.c: creating file '002'
usb 2-2: New USB device found, idVendor=0a12, idProduct=0001
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 2-0:1.0: state 7 ports 2 chg 0000 evt 0004
HDA Intel 0000:80:01.0: power state changed by ACPI to D0
HDA Intel 0000:80:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
usb usb3: suspend_rh (auto-stop)
HDA Intel 0000:80:01.0: setting latency timer to 64
HDA Intel 0000:80:01.0: PCI: Disallowing DAC for device
usb usb4: suspend_rh (auto-stop)
usbcore: registered new interface driver snd-usb-audio
Clocksource tsc unstable (delta = -348924508 ns)
ALSA device list:
  #0: HDA VIA VT82xx at 0xfebfc000 irq 17
nf_conntrack version 0.5.0 (7147 buckets, 28588 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
Bluetooth: L2CAP ver 2.11
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
Using IPI No-Shortcut mode
PM: Resume from partition /dev/sda1
PM: Checking hibernation image.
PM: Error -6 checking image file
PM: Resume from disk failed.
input: PS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input7
md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
scsi 2:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
sd 2:0:0:0: [sdb] 63700992 512-byte hardware sectors: (32.6 GB/30.3 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
sd 2:0:0:0: [sdb] 63700992 512-byte hardware sectors: (32.6 GB/30.3 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
sd 2:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 2:0:0:0: [sdb] Attached SCSI removable disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
usb-storage: device scan complete
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
debug: unmapping init memory c0a2f000..c0a8f000
Write protecting the kernel text: 5636k
Write protecting the kernel read-only data: 2096k
Failed to execute /tmp/swsusp-init.  Attempting defaults...
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f23d7>] EFLAGS: 00000292 CPU: 0
EIP is at acpi_idle_enter_simple+0x180/0x1ed
EAX: c0a29fb0 EBX: 00000267 ECX: 00000003 EDX: 008fe000
ESI: 00000000 EDI: 00624c8c EBP: 00624a25 ESP: c0a29fb0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f167b0 CR3: 1afd9000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0
EXT3 FS on sda4, internal journal
BUG: scheduling while atomic: sss/1538/0x10000100
1 lock held by sss/1538:
 #0:  (&tty->atomic_write_lock){....}, at: [<c0400fd9>] tty_write_lock+0x19/0x50
Modules linked in:

Pid: 1538, comm: sss Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03b8726>] EFLAGS: 00000246 CPU: 0
EIP is at fb_pad_unaligned_buffer+0xa6/0xf0
EAX: 00000000 EBX: 00000001 ECX: db166a3f EDX: 00000000
ESI: 00000001 EDI: c07a64c1 EBP: db166a3f ESP: da00bbe8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080fb408 CR3: 1affb000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c03c73c8>] ? bit_putcs+0x538/0x620
 [<c03c7c99>] ? soft_cursor+0x189/0x1f0
 [<c03c7c99>] ? soft_cursor+0x189/0x1f0
 [<c03c1bee>] ? fbcon_putcs+0x18e/0x2d0
 [<c03c6e90>] ? bit_putcs+0x0/0x620
 [<c03c3389>] ? fbcon_redraw+0x139/0x1a0
 [<c03c5390>] ? fbcon_scroll+0x1c0/0xe80
 [<c040e551>] ? scrup+0xe1/0xf0
 [<c040e5f7>] ? lf+0x47/0x50
 [<c0411007>] ? do_con_write+0x887/0x1a60
 [<c0240030>] ? bump_cpu_timer+0xf0/0x1e0
 [<c024c630>] ? __lock_acquire+0x230/0xa10
 [<c0412209>] ? con_put_char+0x29/0x40
 [<c03ff5f6>] ? tty_put_char+0x16/0x40
 [<c077f80a>] ? __reacquire_kernel_lock+0xa/0x30
 [<c0402b49>] ? opost+0xa9/0x210
 [<c0403531>] ? n_tty_write+0x111/0x340
 [<c0224a90>] ? default_wake_function+0x0/0x10
 [<c0401202>] ? tty_write+0x142/0x1f0
 [<c0403420>] ? n_tty_write+0x0/0x340
 [<c040132b>] ? redirected_tty_write+0x7b/0xa0
 [<c0287673>] ? vfs_write+0xa3/0x140
 [<c04012b0>] ? redirected_tty_write+0x0/0xa0
 [<c0287cb1>] ? sys_write+0x41/0x70
 [<c0203ca2>] ? syscall_call+0x7/0xb
BUG: scheduling while atomic: ifconfig/1613/0x10000101
1 lock held by ifconfig/1613:
 #0:  (rtnl_mutex){....}, at: [<c06dc1fa>] devinet_ioctl+0xfa/0x6b0
Modules linked in:
Pid: 1613, comm: ifconfig Not tainted 2.6.28-rc2-mm1 #1
Call Trace:
 [<c077d2da>] schedule+0x80a/0x900
 [<c0281926>] cache_free_debugcheck+0xe6/0x2e0
 [<c03e4e4f>] acpi_ut_update_ref_count+0x52/0x160
 [<c03e02c6>] acpi_ps_pop_scope+0x70/0x78
 [<c02287c6>] __cond_resched+0x16/0x40
 [<c077d4c8>] _cond_resched+0x28/0x30
 [<c03df8a2>] acpi_ps_complete_op+0x1c6/0x1cd
 [<c03dff1d>] acpi_ps_parse_loop+0x674/0x80b
 [<c03df24d>] acpi_ps_parse_aml+0xa7/0x314
 [<c03e0638>] acpi_ps_execute_method+0x12b/0x1f7
 [<c03dc728>] acpi_ns_evaluate+0x198/0x2bc
 [<c03dc19b>] acpi_evaluate_object+0x174/0x28d
 [<c0282d3a>] kmem_cache_alloc+0x9a/0xc0
 [<c03cb8a1>] acpi_evaluate_integer+0x7c/0x104
 [<c05e49ac>] hpled_set+0x4c/0x60
 [<c05e4ef6>] led_heartbeat_function+0x56/0xe0
 [<c0235496>] run_timer_softirq+0x156/0x1c0
 [<c05e4ea0>] led_heartbeat_function+0x0/0xe0
 [<c05e4ea0>] led_heartbeat_function+0x0/0xe0
 [<c0231267>] __do_softirq+0x87/0x150
 [<c0208350>] dma_generic_alloc_coherent+0x0/0xc0
 [<c0231367>] do_softirq+0x37/0x40
 [<c02313ed>] local_bh_enable_ip+0x7d/0x90
 [<c0482e42>] tg3_open+0x682/0x9b0
 [<c0685316>] dev_open+0x56/0xb0
 [<c077f1eb>] _spin_unlock_bh+0x1b/0x30
 [<c0683620>] dev_change_flags+0x80/0x190
 [<c06dc65f>] devinet_ioctl+0x55f/0x6b0
 [<c067816f>] sock_ioctl+0xcf/0x250
 [<c06780a0>] sock_ioctl+0x0/0x250
 [<c0292ecb>] vfs_ioctl+0x2b/0x90
 [<c029312b>] do_vfs_ioctl+0x1fb/0x580
 [<c0243436>] down_read_trylock+0x56/0x60
 [<c021aea8>] do_page_fault+0x358/0x690
 [<c02934ed>] sys_ioctl+0x3d/0x70
 [<c0203ca2>] syscall_call+0x7/0xb
BUG: scheduling while atomic: postconf/1680/0x10000102
1 lock held by postconf/1680:
 #0:  (&mm->mmap_sem){....}, at: [<c021abde>] do_page_fault+0x8e/0x690
Modules linked in:

Pid: 1680, comm: postconf Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c026f568>] EFLAGS: 00010286 CPU: 0
EIP is at __do_fault+0x258/0x3c0
EAX: d8d4a000 EBX: c131b940 ECX: 000000de EDX: 00000009
ESI: d8c73c88 EDI: d8d4ac88 EBP: da2b7b38 ESP: da2d5edc
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b7fc9140 CR3: 1a2e5000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c024c630>] ? __lock_acquire+0x230/0xa10
 [<c027098d>] ? handle_mm_fault+0xfd/0x5e0
 [<c0243436>] ? down_read_trylock+0x56/0x60
 [<c021aea8>] ? do_page_fault+0x358/0x690
 [<c0243454>] ? up_write+0x14/0x30
 [<c0275b70>] ? sys_mprotect+0x100/0x1c0
 [<c021ab50>] ? do_page_fault+0x0/0x690
 [<c077f912>] ? error_code+0x72/0x78
BUG: scheduling while atomic: sh/1663/0x10000100
no locks held by sh/1663.
Modules linked in:

Pid: 1663, comm: sh Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0073:[<b7df8dae>] EFLAGS: 00000246 CPU: 0
EIP is at 0xb7df8dae
EAX: 00000024 EBX: b7f15ff4 ECX: 0810380e EDX: 0810380e
ESI: 00000000 EDI: bf87e14c EBP: bf87e0ec ESP: bf87e090
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
CR0: 8005003b CR2: 08116108 CR3: 1a2c7000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
tg3: eth0: Link is up at 1000 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
coda_read_super: Bad mount data
coda_read_super: device index: 0
coda_read_super: No pseudo device
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f21ec>] EFLAGS: 00000292 CPU: 0
EIP is at acpi_idle_enter_bm+0x297/0x302
EAX: c0a29fac EBX: 0003eaf3 ECX: 00000006 EDX: 008fe000
ESI: 00000000 EDI: 00918b2e EBP: 008da03b ESP: c0a29fac
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 08055f74 CR3: 00a8f000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0
BUG: scheduling while atomic: mount/1738/0x10000100
2 locks held by mount/1738:
 #0:  (&type->s_umount_key#14){....}, at: [<c0288ad6>] sget+0x1e6/0x360
 #1:  (&inode->i_data.private_lock){....}, at: [<c02a457c>] __find_get_block_slow+0x5c/0x140
Modules linked in:

Pid: 1738, comm: mount Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c02a45c3>] EFLAGS: 00000202 CPU: 0
EIP is at __find_get_block_slow+0xa3/0x140
EAX: 000088b3 EBX: d93ae4f8 ECX: 00000001 EDX: 0000b501
ESI: 000088b3 EDI: 00000000 EBP: 00000001 ESP: da3f5c48
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b7e68600 CR3: 1a3f2000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c02a4a1d>] ? __find_get_block+0x9d/0x190
 [<c02a459a>] ? __find_get_block_slow+0x7a/0x140
 [<c02f5dd0>] ? ext3_bmap+0x0/0x90
 [<c02a4b33>] ? __getblk+0x23/0x2f0
 [<c029796e>] ? bmap+0x2e/0x40
 [<c024c630>] ? __lock_acquire+0x230/0xa10
 [<c030528f>] ? jread+0x8f/0x230
 [<c02a4f6d>] ? __set_page_dirty+0xcd/0x120
 [<c03056e8>] ? do_one_pass+0x2b8/0x440
 [<c077d779>] ? __wait_on_bit+0x59/0x70
 [<c0305982>] ? journal_recover+0xa2/0xe0
 [<c0307a08>] ? journal_load+0x38/0xa0
 [<c02fda6d>] ? ext3_fill_super+0xf8d/0x17f0
 [<c039c23f>] ? snprintf+0x1f/0x30
 [<c02c6d2a>] ? disk_name+0x8a/0xc0
 [<c028961c>] ? get_sb_bdev+0x12c/0x160
 [<c029be00>] ? alloc_vfsmnt+0x0/0xf0
 [<c026cb99>] ? kstrdup+0x39/0x70
 [<c02fb010>] ? ext3_get_sb+0x20/0x30
 [<c02fcae0>] ? ext3_fill_super+0x0/0x17f0
 [<c0289123>] ? vfs_kern_mount+0x43/0x90
 [<c02891cd>] ? do_kern_mount+0x3d/0xe0
 [<c029c85e>] ? do_mount+0x4be/0x6c0
 [<c029b050>] ? copy_mount_options+0x40/0x150
 [<c029cad7>] ? sys_mount+0x77/0xc0
 [<c0203ca2>] ? syscall_call+0x7/0xb
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f21ec>] EFLAGS: 00000292 CPU: 0
EIP is at acpi_idle_enter_bm+0x297/0x302
EAX: c0a29fac EBX: 00001f66 ECX: 00000008 EDX: 008fe000
ESI: 00000000 EDI: 00f98719 EBP: 00f967b3 ESP: c0a29fac
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7eef000 CR3: 00a8f000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f21ec>] EFLAGS: 00000292 CPU: 0
EIP is at acpi_idle_enter_bm+0x297/0x302
EAX: c0a29fac EBX: 00001f66 ECX: 00000008 EDX: 008fe000
ESI: 00000000 EDI: 00f98719 EBP: 00f967b3 ESP: c0a29fac
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7eef000 CR3: 00a8f000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f23d7>] EFLAGS: 00000296 CPU: 0
EIP is at acpi_idle_enter_simple+0x180/0x1ed
EAX: c0a29f90 EBX: 00027545 ECX: 00000009 EDX: 008fe000
ESI: 00000000 EDI: 00acfc38 EBP: 00aa86f3 ESP: c0a29f90
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7eef000 CR3: 00a8f000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c03f2022>] ? acpi_idle_enter_bm+0xcd/0x302
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f23d7>] EFLAGS: 00000296 CPU: 0
EIP is at acpi_idle_enter_simple+0x180/0x1ed
EAX: c0a29f90 EBX: 00027545 ECX: 00000009 EDX: 008fe000
ESI: 00000000 EDI: 00acfc38 EBP: 00aa86f3 ESP: c0a29f90
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7eef000 CR3: 00a8f000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c03f2022>] ? acpi_idle_enter_bm+0xcd/0x302
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0
BUG: scheduling while atomic: syslogd/1579/0x10000100
1 lock held by syslogd/1579:
 #0:  (&u->readlock){....}, at: [<c06fbdc8>] unix_dgram_recvmsg+0x68/0x250
Modules linked in:

Pid: 1579, comm: syslogd Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c077f79b>] EFLAGS: 00000286 CPU: 0
EIP is at _spin_unlock_irqrestore+0x2b/0x40
EAX: 00000000 EBX: da001f24 ECX: 00000001 EDX: 00007c7b
ESI: 00000286 EDI: da001f24 EBP: da006d08 ESP: da001d74
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b7eef000 CR3: 1b98d000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c06fbe00>] ? unix_dgram_recvmsg+0xa0/0x250
 [<c0676927>] ? sock_recvmsg+0xe7/0x120
 [<c023fa30>] ? autoremove_wake_function+0x0/0x50
 [<c0294d73>] ? core_sys_select+0x233/0x320
 [<c06761d2>] ? sockfd_lookup_light+0x32/0x60
 [<c0677930>] ? sys_recvfrom+0xd0/0x160
 [<c024c630>] ? __lock_acquire+0x230/0xa10
 [<c02874c2>] ? do_readv_writev+0x122/0x190
 [<c06779f7>] ? sys_recv+0x37/0x40
 [<c0677f4d>] ? sys_socketcall+0x16d/0x290
 [<c0294ff0>] ? sys_select+0x40/0xb0
 [<c0203cae>] ? syscall_exit+0x8/0x1a
 [<c0203ca2>] ? syscall_call+0x7/0xb
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on sdb1, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
BUG: scheduling while atomic: swapper/0/0x10000100
no locks held by swapper/0.
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.28-rc2-mm1 #1) HP 2133
EIP: 0060:[<c03f21ec>] EFLAGS: 00000292 CPU: 0
EIP is at acpi_idle_enter_bm+0x297/0x302
EAX: c0a29fac EBX: 000036cf ECX: 0000000b EDX: 008fe000
ESI: 00000000 EDI: 00687d3b EBP: 0068466c ESP: c0a29fac
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7ef3124 CR3: 00a8f000 CR4: 00000690
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Call Trace:
 [<c05d6076>] ? cpuidle_idle_call+0x66/0xc0
 [<c0202732>] ? cpu_idle+0x52/0xa0


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
