Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbYHLKMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbYHLKMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 06:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYHLKMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 06:12:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49753 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbYHLKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 06:12:05 -0400
Date: Tue, 12 Aug 2008 11:41:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Message-ID: <20080812094135.GA1565@elf.ucw.cz>
References: <20080806090246.GA1572@elf.ucw.cz> <87bq046cht.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bq046cht.fsf@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
> > Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
> > shutting down.
> > Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
> >
> > ...and machine went down at that point :-(.
> 
> I hope you can easily reproduce it?
> 
> So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please

Yes, I'm very sure. It makes machine basically unusable.

> double check that? Are there are new warnings in the boot logs
> from ACPI compared to .26?

Will take a look.... ... I don't see anything obvious, diff is below.

> I looked through the pile of patches that went in for ACPI and the 
> only candidate that might have imho caused this would be 
> ea51011a27db48ea0a80a5e20de3969b292d5d4d. Can you please 
> try reverting that. If that doesn't help a full bisect will be needed.

Not that one :-(. Thinkpad does not even have fan device: it is
controlled by hardware.
									Pavel

--- /tmp/dmesg.26	2008-08-12 11:38:44.000000000 +0200
+++ /tmp/dmesg.rc2	2008-08-12 11:15:44.000000000 +0200
@@ -1,4 +1,4 @@
-Linux version 2.6.26 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #313 SMP Mon Jul 14 08:33:14 CEST 2008
+Linux version 2.6.27-rc2 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #322 SMP Thu Aug 7 11:58:09 CEST 2008
 PAT disabled. Not yet verified on this CPU type.
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
@@ -16,31 +16,13 @@
  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
-1142MB HIGHMEM available.
-896MB LOWMEM available.
-found SMP MP-table at [c00f67f0] 000f67f0
-Entering add_active_range(0, 0, 521936) 0 entries of 256 used
-Zone PFN ranges:
-  DMA             0 ->     4096
-  Normal       4096 ->   229376
-  HighMem    229376 ->   521936
-Movable zone start PFN for each node
-early_node_map[1] active PFN ranges
-    0:        0 ->   521936
-On node 0 totalpages: 521936
-  DMA zone: 32 pages used for memmap
-  DMA zone: 0 pages reserved
-  DMA zone: 4064 pages, LIFO batch:0
-  Normal zone: 1760 pages used for memmap
-  Normal zone: 223520 pages, LIFO batch:31
-  HighMem zone: 2286 pages used for memmap
-  HighMem zone: 290274 pages, LIFO batch:31
-  Movable zone: 0 pages used for memmap
+last_pfn = 0x7f6d0 max_arch_pfn = 0x100000
+kernel direct mapping tables up to 38000000 @ 7000-c000
 DMI present.
 ACPI: RSDP 000F67C0, 0024 (r2 LENOVO)
 ACPI: XSDT 7F6D191C, 0084 (r1 LENOVO TP-7B        2140  LTP        0)
 ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2140 LNVO        1)
-ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080321]
+ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20080609]
 ACPI: DSDT 7F6D1D90, CFB9 (r1 LENOVO TP-7B        2140 MSFT  100000E)
 ACPI: FACS 7F6F4000, 0040
 ACPI: SSDT 7F6D1BB4, 01DC (r1 LENOVO TP-7B        2140 MSFT  100000E)
@@ -54,6 +36,37 @@
 ACPI: SSDT 7F6F28A4, 00A6 (r1 LENOVO TP-7B        2140 INTL 20050513)
 ACPI: SSDT 7F6F294A, 04F7 (r1 LENOVO TP-7B        2140 INTL 20050513)
 ACPI: SSDT 7F6F2E41, 01D8 (r1 LENOVO TP-7B        2140 INTL 20050513)
+1142MB HIGHMEM available.
+896MB LOWMEM available.
+  mapped low ram: 0 - 38000000
+  low ram: 00000000 - 38000000
+  bootmap 00008000 - 0000f000
+(8 early reservations) ==> bootmem [0000000000 - 0038000000]
+  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
+  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
+  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
+  #3 [0000200000 - 0000c07128]    TEXT DATA BSS ==> [0000200000 - 0000c07128]
+  #4 [0000c08000 - 0000c1d000]    INIT_PG_TABLE ==> [0000c08000 - 0000c1d000]
+  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
+  #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
+  #7 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
+Scan SMP from c0000000 for 1024 bytes.
+Scan SMP from c009fc00 for 1024 bytes.
+Scan SMP from c00f0000 for 65536 bytes.
+found SMP MP-table at [c00f67f0] 000f67f0
+Zone PFN ranges:
+  DMA      0x00000000 -> 0x00001000
+  Normal   0x00001000 -> 0x00038000
+  HighMem  0x00038000 -> 0x0007f6d0
+Movable zone start PFN for each node
+early_node_map[2] active PFN ranges
+    0: 0x00000000 -> 0x0000009f
+    0: 0x00000100 -> 0x0007f6d0
+On node 0 totalpages: 521839
+free_area_init_node: node 0, pgdat c0942e80, node_mem_map c1001000
+  DMA zone: 3967 pages, LIFO batch:0
+  Normal zone: 223520 pages, LIFO batch:31
+  HighMem zone: 290274 pages, LIFO batch:31
 ACPI: PM-Timer IO Port: 0x1008
 ACPI: Local APIC address 0xfee00000
 ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
@@ -70,26 +83,27 @@
 Enabling APIC mode:  Flat.  Using 1 I/O APICs
 ACPI: HPET id: 0x8086a201 base: 0xfed00000
 Using ACPI (MADT) for SMP configuration information
-Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
+SMP: Allowing 2 CPUs, 0 hotplug CPUs
+mapped APIC to ffffb000 (fee00000)
+mapped IOAPIC to ffffa000 (fec00000)
 PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
 PM: Registered nosave memory: 00000000000a0000 - 00000000000d2000
 PM: Registered nosave memory: 00000000000d2000 - 00000000000d4000
 PM: Registered nosave memory: 00000000000d4000 - 00000000000dc000
 PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
-SMP: Allowing 2 CPUs, 0 hotplug CPUs
-PERCPU: Allocating 37800 bytes of per cpu data
-NR_CPUS: 2, nr_cpu_ids: 2
-Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517858
+Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
+PERCPU: Allocating 37552 bytes of per cpu data
+NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
+Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517761
 Kernel command line: root=/dev/sda4 resume=/dev/sda1 psmouse.psmouse_proto=imps psmouse_proto=imps psmouse.proto=imps vga=791 init=/tmp/swsusp-init acpi_sleep=s3_bios,s3_mode no_console_suspend
 Unknown boot option `psmouse.psmouse_proto=imps': ignoring
-mapped APIC to ffffb000 (fee00000)
-mapped IOAPIC to ffffa000 (fec00000)
 Enabling fast FPU save and restore... done.
 Enabling unmasked SIMD FPU exception support... done.
 Initializing CPU#0
 PID hash table entries: 4096 (order: 12, 16384 bytes)
 Extended CMOS year: 2000
-Detected 1828.792 MHz processor.
+TSC calibrated against PM_TIMER
+Detected 1828.748 MHz processor.
 Console: colour dummy device 80x25
 console [tty0] enabled
 Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
@@ -100,23 +114,23 @@
 ... MAX_LOCKDEP_ENTRIES:     8192
 ... MAX_LOCKDEP_CHAINS:      16384
 ... CHAINHASH_SIZE:          8192
- memory used by lock dependency info: 992 kB
+ memory used by lock dependency info: 1056 kB
  per task-struct memory footprint: 1920 bytes
 Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
 Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
-Memory: 2059068k/2087744k available (5320k kernel code, 27516k reserved, 2458k data, 320k init, 1170240k highmem)
+Memory: 2058760k/2087744k available (5438k kernel code, 27692k reserved, 2511k data, 344k init, 1170240k highmem)
 virtual kernel memory layout:
-    fixmap  : 0xfff7f000 - 0xfffff000   ( 512 kB)
+    fixmap  : 0xfff83000 - 0xfffff000   ( 496 kB)
     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
-      .init : 0xc09a1000 - 0xc09f1000   ( 320 kB)
-      .data : 0xc0732166 - 0xc0998a08   (2458 kB)
-      .text : 0xc0200000 - 0xc0732166   (5320 kB)
+      .init : 0xc09cb000 - 0xc0a21000   ( 344 kB)
+      .data : 0xc074fbc6 - 0xc09c38f0   (2511 kB)
+      .text : 0xc0200000 - 0xc074fbc6   (5438 kB)
 Checking if this processor honours the WP bit even in supervisor mode...Ok.
 CPA: page pool initialized 32 of 32 pages preallocated
 hpet clockevent registered
-Calibrating delay using timer specific routine.. 3662.04 BogoMIPS (lpj=7324080)
+Calibrating delay loop (skipped), value calculated using timer frequency.. 3657.49 BogoMIPS (lpj=7314992)
 Mount-cache hash table entries: 512
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 2048K
@@ -124,7 +138,7 @@
 CPU: Processor Core ID: 0
 using mwait in idle threads.
 Checking 'hlt' instruction... OK.
-ACPI: Core revision 20080321
+ACPI: Core revision 20080609
 Parsing all Control Methods:
 Table [DSDT](id 0001) - 1592 Objects with 69 Devices 429 Methods 28 Regions
 Parsing all Control Methods:
@@ -137,7 +151,7 @@
 Table [SSDT](id 0005) - 14 Objects with 0 Devices 5 Methods 0 Regions
 Parsing all Control Methods:
 Table [SSDT](id 0006) - 14 Objects with 1 Devices 2 Methods 0 Regions
- tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
+ tbxface-0596 [00] tb_load_namespace     : ACPI Tables successfully acquired
 evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
 ENABLING IO-APIC IRQs
 ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
@@ -145,24 +159,24 @@
 lockdep: fixing up alternatives.
 Booting processor 1/1 ip 6000
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 3657.57 BogoMIPS (lpj=7315141)
+Calibrating delay using timer specific routine.. 3657.62 BogoMIPS (lpj=7315256)
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 2048K
 CPU: Physical Processor ID: 0
 CPU: Processor Core ID: 1
 CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
 checking TSC synchronization [CPU#0 -> CPU#1]:
-Measured 579986 cycles TSC warp between CPUs, turning off TSC clock.
-Marking TSC unstable due to: check_tsc_sync_source failed.
+Measured 579326 cycles TSC warp between CPUs, turning off TSC clock.
+Marking TSC unstable due to check_tsc_sync_source failed
 Brought up 2 CPUs
-Total of 2 processors activated (7319.61 BogoMIPS).
+Total of 2 processors activated (7315.12 BogoMIPS).
 CPU0 attaching sched-domain:
- domain 0: span 0-1
+ domain 0: span 0-1 level CPU
   groups: 0 1
 CPU1 attaching sched-domain:
- domain 0: span 0-1
+ domain 0: span 0-1 level CPU
   groups: 1 0
-net_namespace: 548 bytes
+net_namespace: 680 bytes
 NET: Registered protocol family 16
 ACPI: ACPI Dock Station Driver
 ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
@@ -170,29 +184,58 @@
 ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Is dependent on dock
 
 ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
+ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
 ACPI: bus type pci registered
 PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
 PCI: MCFG area at f0000000 reserved in E820
 PCI: Using MMCONFIG for extended config space
 PCI: Using configuration type 1 for base access
-Setting up standard PCI resources
-evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
+evgpeblk-0957 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
 ACPI: EC: EC description table is found, configuring boot EC
 Completing Region/Field/Buffer/Package initialization:........................................................................................................................................................................................................................................................................
 Initialized 28/28 Regions 126/126 Fields 54/54 Buffers 56/56 Packages (1651 nodes)
 Initializing Device/Processor/Thermal objects by executing _INI methods:...<6>ACPI: EC: non-query interrupt received, switching to interrupt mode
 ....
 Executed 7 _INI methods requiring 2 _STA executions (examined 76 objects)
-evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 2 Runtime GPEs in this block
+evgpeblk-1054 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 2 Runtime GPEs in this block
 ACPI: Interpreter enabled
 ACPI: (supports S0 S3 S4 S5)
 ACPI: Using IOAPIC for interrupt routing
 ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
 ACPI: EC: driver started in interrupt mode
 ACPI: PCI Root Bridge [PCI0] (0000:00)
+pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
+pci 0000:00:1b.0: PME# disabled
+pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
+pci 0000:00:1c.0: PME# disabled
+pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
+pci 0000:00:1c.1: PME# disabled
+pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
+pci 0000:00:1c.2: PME# disabled
+pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
+pci 0000:00:1c.3: PME# disabled
+pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
+pci 0000:00:1d.7: PME# disabled
 pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
 pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
-PCI: Transparent bridge - 0000:00:1e.0
+pci 0000:00:1f.2: PME# supported from D3hot
+pci 0000:00:1f.2: PME# disabled
+pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
+pci 0000:02:00.0: PME# disabled
+pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
+pci 0000:03:00.0: PME# disabled
+pci 0000:15:00.0: supports D1
+pci 0000:15:00.0: supports D2
+pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
+pci 0000:15:00.0: PME# disabled
+pci 0000:15:00.1: PME# supported from D0 D3hot D3cold
+pci 0000:15:00.1: PME# disabled
+pci 0000:15:00.2: supports D1
+pci 0000:15:00.2: supports D2
+pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
+pci 0000:15:00.2: PME# disabled
+pci 0000:00:1e.0: transparent bridge
+bus 00 -> node 0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
@@ -219,7 +262,7 @@
 usbcore: registered new interface driver hub
 usbcore: registered new device driver usb
 PCI: Using ACPI for IRQ routing
-Bluetooth: Core ver 2.11
+Bluetooth: Core ver 2.12
 NET: Registered protocol family 31
 Bluetooth: HCI device and connection manager initialized
 Bluetooth: HCI socket layer initialized
@@ -230,11 +273,11 @@
 system 00:00: iomem range 0xc8000-0xcbfff has been reserved
 system 00:00: iomem range 0xcc000-0xcffff could not be reserved
 system 00:00: iomem range 0xd0000-0xd3fff could not be reserved
-system 00:00: iomem range 0xdc000-0xdffff has been reserved
-system 00:00: iomem range 0xe0000-0xe3fff has been reserved
-system 00:00: iomem range 0xe4000-0xe7fff has been reserved
-system 00:00: iomem range 0xe8000-0xebfff has been reserved
-system 00:00: iomem range 0xec000-0xeffff has been reserved
+system 00:00: iomem range 0xdc000-0xdffff could not be reserved
+system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
+system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
+system 00:00: iomem range 0xe8000-0xebfff could not be reserved
+system 00:00: iomem range 0xec000-0xeffff could not be reserved
 system 00:00: iomem range 0xf0000-0xfffff could not be reserved
 system 00:00: iomem range 0x100000-0x7fffffff could not be reserved
 system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
@@ -250,38 +293,43 @@
 system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
 system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
 system 00:02: iomem range 0xfed19000-0xfed19fff could not be reserved
-PCI: Bridge: 0000:00:1c.0
-  IO window: 2000-2fff
-  MEM window: 0xee000000-0xee0fffff
-  PREFETCH window: disabled.
-PCI: Bridge: 0000:00:1c.1
-  IO window: 3000-4fff
-  MEM window: 0xec000000-0xedffffff
-  PREFETCH window: 0x00000000e4000000-0x00000000e40fffff
-PCI: Bridge: 0000:00:1c.2
-  IO window: 5000-6fff
-  MEM window: 0xe8000000-0xe9ffffff
-  PREFETCH window: 0x00000000e4100000-0x00000000e41fffff
-PCI: Bridge: 0000:00:1c.3
-  IO window: 7000-8fff
-  MEM window: 0xea000000-0xebffffff
-  PREFETCH window: 0x00000000e4200000-0x00000000e42fffff
-PCI: Bus 22, cardbus bridge: 0000:15:00.0
-  IO window: 0x00009000-0x000090ff
-  IO window: 0x00009400-0x000094ff
-  PREFETCH window: 0xe0000000-0xe3ffffff
-  MEM window: 0x88000000-0x8bffffff
-PCI: Bridge: 0000:00:1e.0
-  IO window: 9000-cfff
-  MEM window: 0xe4300000-0xe7ffffff
-  PREFETCH window: 0x00000000e0000000-0x00000000e3ffffff
-PCI: Setting latency timer of device 0000:00:1c.0 to 64
-PCI: Setting latency timer of device 0000:00:1c.1 to 64
-PCI: Setting latency timer of device 0000:00:1c.2 to 64
-PCI: Setting latency timer of device 0000:00:1c.3 to 64
+pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
+pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
+pci 0000:00:1c.0:   MEM window: 0xee000000-0xee0fffff
+pci 0000:00:1c.0:   PREFETCH window: disabled
+pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
+pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
+pci 0000:00:1c.1:   MEM window: 0xec000000-0xedffffff
+pci 0000:00:1c.1:   PREFETCH window: 0x000000e4000000-0x000000e40fffff
+pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
+pci 0000:00:1c.2:   IO window: 0x5000-0x6fff
+pci 0000:00:1c.2:   MEM window: 0xe8000000-0xe9ffffff
+pci 0000:00:1c.2:   PREFETCH window: 0x000000e4100000-0x000000e41fffff
+pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
+pci 0000:00:1c.3:   IO window: 0x7000-0x8fff
+pci 0000:00:1c.3:   MEM window: 0xea000000-0xebffffff
+pci 0000:00:1c.3:   PREFETCH window: 0x000000e4200000-0x000000e42fffff
+pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
+pci 0000:15:00.0:   IO window: 0x009000-0x0090ff
+pci 0000:15:00.0:   IO window: 0x009400-0x0094ff
+pci 0000:15:00.0:   PREFETCH window: 0xe0000000-0xe3ffffff
+pci 0000:15:00.0:   MEM window: 0x88000000-0x8bffffff
+pci 0000:00:1e.0: PCI bridge, secondary bus 0000:15
+pci 0000:00:1e.0:   IO window: 0x9000-0xcfff
+pci 0000:00:1e.0:   MEM window: 0xe4300000-0xe7ffffff
+pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e3ffffff
+pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
+pci 0000:00:1c.0: setting latency timer to 64
+pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
+pci 0000:00:1c.1: setting latency timer to 64
+pci 0000:00:1c.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
+pci 0000:00:1c.2: setting latency timer to 64
+pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
+pci 0000:00:1c.3: setting latency timer to 64
 pci 0000:00:1e.0: enabling device (0005 -> 0007)
-PCI: Setting latency timer of device 0000:00:1e.0 to 64
-PCI: Setting latency timer of device 0000:15:00.0 to 64
+pci 0000:00:1e.0: setting latency timer to 64
+pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+pci 0000:15:00.0: setting latency timer to 64
 NET: Registered protocol family 2
 IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
 TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
@@ -310,7 +358,7 @@
 vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
 Console: switching to colour frame buffer device 102x42
 fb0: VESA VGA frame buffer device
-ACPI: AC Adapter [AC] (on-line)
+ACPI: AC Adapter [AC] (off-line)
 ACPI: Battery Slot [BAT0] (battery present)
 input: Power Button (FF) as /class/input/input0
 ACPI: Power Button (FF) [PWRF]
@@ -325,21 +373,21 @@
 Parsing all Control Methods:
 Table [SSDT](id 0026) - 13 Objects with 0 Devices 1 Methods 0 Regions
 ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
-ACPI: ACPI0007:00 is registered as cooling_device0
+processor ACPI0007:00: registered as cooling_device0
 ACPI: Processor [CPU0] (supports 8 throttling states)
 ACPI: SSDT 7F6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
 Parsing all Control Methods:
-Table [SSDT](id 0030) - 4 Objects with 0 Devices 4 Methods 0 Regions
+Table [SSDT](id 002E) - 4 Objects with 0 Devices 4 Methods 0 Regions
 ACPI: SSDT 7F6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
 Parsing all Control Methods:
-Table [SSDT](id 0031) - 1 Objects with 0 Devices 1 Methods 0 Regions
+Table [SSDT](id 002F) - 1 Objects with 0 Devices 1 Methods 0 Regions
 ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
-ACPI: ACPI0007:01 is registered as cooling_device1
+processor ACPI0007:01: registered as cooling_device1
 ACPI: Processor [CPU1] (supports 8 throttling states)
-ACPI: LNXTHERM:01 is registered as thermal_zone0
-ACPI: Thermal Zone [THM0] (58 C)
-ACPI: LNXTHERM:02 is registered as thermal_zone1
-ACPI: Thermal Zone [THM1] (60 C)
+thermal LNXTHERM:01: registered as thermal_zone0
+ACPI: Thermal Zone [THM0] (50 C)
+thermal LNXTHERM:02: registered as thermal_zone1
+ACPI: Thermal Zone [THM1] (49 C)
 lp: driver loaded but no devices found
 Non-volatile memory driver v1.2
 intel_rng: FWH not detected
@@ -349,16 +397,18 @@
 agpgart: Detected 7932K stolen memory.
 agpgart: AGP aperture is 256M @ 0xd0000000
 [drm] Initialized drm 1.1.0 20060810
-PCI: Setting latency timer of device 0000:00:02.0 to 64
+pci 0000:00:02.0: power state changed by ACPI to D0
+pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+pci 0000:00:02.0: setting latency timer to 64
 [drm] Initialized i915 1.6.0 20060119 on minor 0
 intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets
 intelfb: Version 0.9.5
 intelfb: Cannot reserve FB region.
-Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
+Serial: 8250/16550 driver4 ports, IRQ sharing disabled
 serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
 floppy0: no floppy controllers found
 loop: module loaded
-thinkpad_acpi: ThinkPad ACPI Extras v0.20
+thinkpad_acpi: ThinkPad ACPI Extras v0.21
 thinkpad_acpi: http://ibm-acpi.sf.net/
 thinkpad_acpi: ThinkPad BIOS 7BETD3WW (2.14 ), EC 7BHT40WW-1.13
 thinkpad_acpi: Lenovo ThinkPad X60, model 17097HU
@@ -380,7 +430,8 @@
 e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
 e1000e: Copyright (c) 1999-2008 Intel Corporation.
 e1000e 0000:02:00.0: Disabling L1 ASPM
-PCI: Setting latency timer of device 0000:02:00.0 to 64
+e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+e1000e 0000:02:00.0: setting latency timer to 64
 eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:25:19:04
 eth0: Intel(R) PRO/1000 Network Connection
 eth0: MAC: 2, PHY: 2, PBA No: 005302-003
@@ -408,17 +459,18 @@
 usbcore: registered new interface driver w35und
 iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
 iwl3945: Copyright(c) 2003-2008 Intel Corporation
-PCI: Setting latency timer of device 0000:03:00.0 to 64
+iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
+iwl3945 0000:03:00.0: setting latency timer to 64
 iwl3945: Detected Intel Wireless WiFi Link 3945ABG
 iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
 phy0: Selected rate control algorithm 'iwl-3945-rs'
-ACPI: PCI interrupt for device 0000:03:00.0 disabled
+iwl3945 0000:03:00.0: PCI INT A disabled
 Linux video capture interface: v2.00
 Uniform Multi-Platform E-IDE driver
-ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
-ICH7: IDE controller (0x8086:0x27df rev 0x02) at  PCI slot 0000:00:1f.1
-ICH7: not 100% native mode: will probe irqs later
-ICH7: IDE port disabled
+piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
+pci 0000:00:1f.1: PCI INT C -> GSI 16 (level, low) -> IRQ 16
+piix 0000:00:1f.1: IDE port disabled
+piix 0000:00:1f.1: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0x1810-0x1817
 Probing IDE interface ide0...
 ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
@@ -426,9 +478,10 @@
 ide_generic: I/O resource 0x1F0-0x1F7 not free.
 ide_generic: I/O resource 0x170-0x177 not free.
 ahci 0000:00:1f.2: version 3.0
+ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
 ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
 ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
-PCI: Setting latency timer of device 0000:00:1f.2 to 64
+ahci 0000:00:1f.2: setting latency timer to 64
 scsi0 : ahci
 ahci: autosuspend disabled
 scsi1 : ahci
@@ -437,7 +490,7 @@
 ahci: autosuspend disabled
 scsi3 : ahci
 ahci: autosuspend disabled
-ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 16
+ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 16
 ata2: DUMMY
 ata3: DUMMY
 ata4: DUMMY
@@ -471,11 +524,13 @@
 pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
 pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
 pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
-PCI: Setting latency timer of device 0000:00:1d.7 to 64
+ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
+ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
+ehci_hcd 0000:00:1d.7: setting latency timer to 64
 ehci_hcd 0000:00:1d.7: EHCI Host Controller
 ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
 ehci_hcd 0000:00:1d.7: debug port 1
-PCI: cache line size of 32 is not supported by device 0000:00:1d.7
+ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
 ehci_hcd 0000:00:1d.7: irq 19, io mem 0xee444000
 ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
 usb usb1: configuration #1 chosen from 1 choice
@@ -484,11 +539,13 @@
 usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
 usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb1: Product: EHCI Host Controller
-usb usb1: Manufacturer: Linux 2.6.26 ehci_hcd
+usb usb1: Manufacturer: Linux 2.6.27-rc2 ehci_hcd
 usb usb1: SerialNumber: 0000:00:1d.7
 ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
 USB Universal Host Controller Interface driver v3.0
-PCI: Setting latency timer of device 0000:00:1d.0 to 64
+uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
+uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
+uhci_hcd 0000:00:1d.0: setting latency timer to 64
 uhci_hcd 0000:00:1d.0: UHCI Host Controller
 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
 uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
@@ -498,9 +555,10 @@
 usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb2: Product: UHCI Host Controller
-usb usb2: Manufacturer: Linux 2.6.26 uhci_hcd
+usb usb2: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
 usb usb2: SerialNumber: 0000:00:1d.0
-PCI: Setting latency timer of device 0000:00:1d.1 to 64
+uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
+uhci_hcd 0000:00:1d.1: setting latency timer to 64
 uhci_hcd 0000:00:1d.1: UHCI Host Controller
 uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
 uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
@@ -510,9 +568,11 @@
 usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb3: Product: UHCI Host Controller
-usb usb3: Manufacturer: Linux 2.6.26 uhci_hcd
+usb usb3: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
 usb usb3: SerialNumber: 0000:00:1d.1
-PCI: Setting latency timer of device 0000:00:1d.2 to 64
+uhci_hcd 0000:00:1d.2: power state changed by ACPI to D0
+uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
+uhci_hcd 0000:00:1d.2: setting latency timer to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
 uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
 uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
@@ -522,9 +582,10 @@
 usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb4: Product: UHCI Host Controller
-usb usb4: Manufacturer: Linux 2.6.26 uhci_hcd
+usb usb4: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
 usb usb4: SerialNumber: 0000:00:1d.2
-PCI: Setting latency timer of device 0000:00:1d.3 to 64
+uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
+uhci_hcd 0000:00:1d.3: setting latency timer to 64
 uhci_hcd 0000:00:1d.3: UHCI Host Controller
 uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
 uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
@@ -534,7 +595,7 @@
 usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
 usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
 usb usb5: Product: UHCI Host Controller
-usb usb5: Manufacturer: Linux 2.6.26 uhci_hcd
+usb usb5: Manufacturer: Linux 2.6.27-rc2 uhci_hcd
 usb usb5: SerialNumber: 0000:00:1d.3
 usb 5-1: new full speed USB device using uhci_hcd and address 2
 usb 5-1: configuration #1 chosen from 1 choice
@@ -562,31 +623,34 @@
 input: PC Speaker as /class/input/input5
 input: PS/2 Generic Mouse as /class/input/input6
 rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
-rtc0: alarms up to one month, y3k
+rtc0: alarms up to one month, y3k, hpet irqs
 md: raid0 personality registered for level 0
 md: raid1 personality registered for level 1
-device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
+device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
 Bluetooth: HCI UART driver ver 2.2
 Bluetooth: HCI H4 protocol initialized
 Bluetooth: HCI BCSP protocol initialized
 Bluetooth: Generic Bluetooth USB driver ver 0.1
 usbcore: registered new interface driver btusb
-EDAC MC: Ver: 2.1.0 Jul 14 2008
+EDAC MC: Ver: 2.1.0 Aug  6 2008
 cpuidle: using governor ladder
 sdhci: Secure Digital Host Controller Interface driver
 sdhci: Copyright(c) Pierre Ossman
-sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 18)
-mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
-PCI: Setting latency timer of device 0000:15:00.2 to 64
+sdhci-pci 0000:15:00.2: SDHCI controller found [1180:0822] (rev 18)
+sdhci-pci 0000:15:00.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
 Registered led device: mmc0
-mmc0: SDHCI at 0xe4301800 irq 18 DMA
+mmc0: SDHCI controller on PCI [0000:15:00.2] using PIO
 ricoh-mmc: Ricoh MMC Controller disabling driver
 ricoh-mmc: Copyright(c) Philip Langdale
 usbcore: registered new interface driver usbhid
 usbhid: v2.6:USB HID core driver
-Advanced Linux Sound Architecture Driver Version 1.0.16.
+Advanced Linux Sound Architecture Driver Version 1.0.17.
+HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 hda_intel: probe_mask set to 0x1 for device 17aa:2010
-PCI: Setting latency timer of device 0000:00:1b.0 to 64
+HDA Intel 0000:00:1b.0: setting latency timer to 64
+mmc0: new MMC card at address 0001
+mmcblk0: mmc0:0001 MMC    1019392KiB 
+ mmcblk0: p1
 usbcore: registered new interface driver snd-usb-audio
 ALSA device list:
   #0: HDA Intel at 0xee240000 irq 17
@@ -594,26 +658,23 @@
 ip_tables: (C) 2000-2006 Netfilter Core Team
 TCP cubic registered
 NET: Registered protocol family 17
-Bluetooth: L2CAP ver 2.9
+Bluetooth: L2CAP ver 2.10
 Bluetooth: L2CAP socket layer initialized
-Bluetooth: SCO (Voice Link) ver 0.5
+Bluetooth: SCO (Voice Link) ver 0.6
 Bluetooth: SCO socket layer initialized
 Bluetooth: RFCOMM socket layer initialized
 Bluetooth: RFCOMM TTY layer initialized
-Bluetooth: RFCOMM ver 1.8
+Bluetooth: RFCOMM ver 1.10
 Bluetooth: BNEP (Ethernet Emulation) ver 1.2
 Bluetooth: BNEP filters: protocol multicast
 Bluetooth: HIDP (Human Interface Emulation) ver 1.2
-mmc0: new MMC card at address 0001
 RPC: Registered udp transport module.
 RPC: Registered tcp transport module.
 ieee80211: 802.11 data/management/control stack, git-1.1.13
 ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
 ieee80211_crypt: registered algorithm 'NULL'
 ieee80211_crypt: registered algorithm 'WEP'
-mmcblk0: mmc0:0001 MMC    1019392KiB 
- mmcblk0:<6>Installing 9P2000 support
- p1
+Installing 9P2000 support
 Using IPI No-Shortcut mode
 PM: Resume from partition /dev/sda1
 PM: Checking hibernation image.
@@ -625,9 +686,9 @@
 kjournald starting.  Commit interval 5 seconds
 EXT3-fs: mounted filesystem with ordered data mode.
 VFS: Mounted root (ext3 filesystem) readonly.
-debug: unmapping init memory c09a1000..c09f1000
-Write protecting the kernel text: 5324k
-Write protecting the kernel read-only data: 1916k
+debug: unmapping init memory c09cb000..c0a21000
+Write protecting the kernel text: 5440k
+Write protecting the kernel read-only data: 1968k
 Failed to execute /tmp/swsusp-init.  Attempting defaults...
 EXT3 FS on sda4, internal journal
 Adding 987988k swap on /dev/sda1.  Priority:-1 extents:1 across:987988k
@@ -637,10 +698,259 @@
 pcmcia: Detected deprecated PCMCIA ioctl usage from process: hwclock.
 pcmcia: This interface will soon be removed from the kernel; please expect breakage unless you upgrade to new tools.
 pcmcia: see http://www.kernel.org/pub/linux/utils/kernel/pcmcia/pcmcia.html for details.
-Clocksource tsc unstable (delta = -82296647 ns)
-eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
 coda_read_super: Bad mount data
 coda_read_super: device index: 0
 coda_read_super: rootfid is (01234567.ffffffff.08051a38.00000000)
 coda: Unexpected interruption.
 Failure of coda_cnode_make for root: error -4

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
