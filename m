Return-Path: <linux-kernel-owner+w=401wt.eu-S1753908Ab0AHRPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0AHRPV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792Ab0AHRPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:15:19 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:19441 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0AHRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:15:15 -0500
Date: Fri, 8 Jan 2010 10:15:13 -0700
From: Alex Chiang <achiang@hp.com>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: High cpu temperature with 2.6.32, bisection shows commit
	69d258 (fwd)
Message-ID: <20100108171513.GB22713@ldl.fc.hp.com>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since you bisected this down to a commit from Arjan, it might
help to cc him.

Adding him and lkml.

* Dimitrios Apostolou <jimis@gmx.net>:
> Hello and sorry if I bother. I sent this email to lkml 2 days ago but got 
> no answer. Supposing it was lost somewhere I send it personally to you  
> that are listed as the maintainers of the "processor" module. If I should 
> reformulate the email and send it to lkml, please tell me what I should  
> add and I'll resend it.
>
> Please CC replies to me.
>
> Thanks in advance,
> Dimitris
>
>
> ---------- Forwarded message ----------
> Date: Wed, 6 Jan 2010 19:39:48 +0200 (EET)
> From: Dimitrios Apostolou <jimis@gmx.net>
> To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: High cpu temperature with 2.6.32, bisection shows commit 69d258
>
> Hello list,
>
> after upgrading to 2.6.32 kernel, I noticed my P3 500MHz laptop's fan was 
> working non-stop. Powertop showed more than 100K wakeups/s even though 
> cpu was idling almost 100% (no user nor system cpu usage). Further 
> investigation showed that this happened as soon as the "processor" module 
> was inserted, whence I also got a message like the following:
>
> tsc unstable due to halts in idle
> switching clocksource to acpi_pm
>
> A workaround that currently works for me is to boot with 
> "clocksource=pit" parameter. FYI in 2.6.31 logs I had the same message 
> about tsc instability, and the final clocksource was acpi_pm too. 
> Nevertheless wakeups/s were much less and temperature was low.
>
> I performed a bisection to find which commit to blame. Please look into  
> attached files which include dmesg output from good and bad case, and 
> bisection output.
>
>
> What do you think?
>
> Dimitris

> Linux version 2.6.31-07222-g45d80ee (jimis@mango) (gcc version 4.4.2 20091208 (prerelease) (GCC) ) #18 SMP PREEMPT Wed Jan 6 19:01:27 EET 2010
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e9800 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
>  BIOS-e820: 0000000007ff0000 - 0000000007fffc00 (ACPI data)
>  BIOS-e820: 0000000007fffc00 - 0000000008000000 (ACPI NVS)
>  BIOS-e820: 00000000fffe9800 - 0000000100000000 (reserved)
> DMI 2.1 present.
> Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> last_pfn = 0x7ff0 max_arch_pfn = 0x100000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-C7FFF write-protect
>   C8000-DFFFF uncachable
>   E0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 000000000 mask FF8000000 write-back
>   1 disabled
>   2 disabled
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> PAT not supported by CPU.
> Scanning 0 areas for low memory corruption
> modified physical RAM map:
>  modified: 0000000000000000 - 0000000000010000 (reserved)
>  modified: 0000000000010000 - 000000000009f400 (usable)
>  modified: 000000000009f400 - 00000000000a0000 (reserved)
>  modified: 00000000000e9800 - 0000000000100000 (reserved)
>  modified: 0000000000100000 - 0000000007ff0000 (usable)
>  modified: 0000000007ff0000 - 0000000007fffc00 (ACPI data)
>  modified: 0000000007fffc00 - 0000000008000000 (ACPI NVS)
>  modified: 00000000fffe9800 - 0000000100000000 (reserved)
> initial memory mapped : 0 - 01800000
> init_memory_mapping: 0000000000000000-0000000007ff0000
>  0000000000 - 0000400000 page 4k
>  0000400000 - 0007c00000 page 2M
>  0007c00000 - 0007ff0000 page 4k
> kernel direct mapping tables up to 7ff0000 @ 10000-15000
> ACPI: RSDP 000f6d80 00014 (v00 PTLTD )
> ACPI: RSDT 07ffd008 0002C (v01 PTLTD    RSDT   00000000  LTP 00000000)
> ACPI: FACP 07fffb65 00074 (v01 ASUS   L8400B   00000000 PTL  000F4240)
> ACPI: DSDT 07ffd034 02B31 (v01  Intel   Trajan 00000000 MSFT 01000004)
> ACPI: FACS 07ffffc0 00040
> ACPI: BOOT 07fffbd9 00027 (v01 PTLTD  $SBFTBL$ 00000000  LTP 00000001)
> 0MB HIGHMEM available.
> 127MB LOWMEM available.
>   mapped low ram: 0 - 07ff0000
>   low ram: 0 - 07ff0000
>   node 0 low ram: 00000000 - 07ff0000
>   node 0 bootmap 00011000 - 00012000
> (8 early reservations) ==> bootmem [0000000000 - 0007ff0000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0001000000 - 00014d8b14]    TEXT DATA BSS ==> [0001000000 - 00014d8b14]
>   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
>   #5 [00014d9000 - 00014df130]              BRK ==> [00014d9000 - 00014df130]
>   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
>   #7 [0000011000 - 0000012000]          BOOTMAP ==> [0000011000 - 0000012000]
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x00007ff0
>   HighMem  0x00007ff0 -> 0x00007ff0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x00007ff0
> On node 0 totalpages: 32639
> free_area_init_node: node 0, pgdat c13c13e0, node_mem_map c14e1200
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3951 pages, LIFO batch:0
>   Normal zone: 224 pages used for memmap
>   Normal zone: 28432 pages, LIFO batch:7
> Using APIC driver default
> ACPI: PM-Timer IO Port: 0x8008
> SMP: Allowing 1 CPUs, 0 hotplug CPUs
> Local APIC disabled by BIOS -- you can enable it with "lapic"
> APIC: disable apic facility
> nr_irqs_gsi: 16
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000ea000
> PM: Registered nosave memory: 00000000000ea000 - 0000000000100000
> Allocating PCI resources starting at 8000000 (gap: 8000000:f7fe9800)
> Booting paravirtualized kernel on bare hardware
> NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
> PERCPU: Embedded 13 pages/cpu @c1800000 s29528 r0 d23720 u4194304
> pcpu-alloc: s29528 r0 d23720 u4194304 alloc=1*4194304
> pcpu-alloc: [0] 0 
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32383
> Kernel command line: root=/dev/hda2 ro init=/bin/sh
> PID hash table entries: 512 (order: -1, 2048 bytes)
> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Initializing HighMem for node 0 (00000000:00000000)
> Memory: 124200k/131008k available (2870k kernel code, 6208k reserved, 993k data, 340k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xc87f0000 - 0xff7fe000   ( 880 MB)
>     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
>       .init : 0xc13c7000 - 0xc141c000   ( 340 kB)
>       .data : 0xc12cdb74 - 0xc13c6038   ( 993 kB)
>       .text : 0xc1000000 - 0xc12cdb74   (2870 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Hierarchical RCU implementation.
> NR_IRQS:512
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Fast TSC calibration using PIT
> Detected 501.039 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 1002.83 BogoMIPS (lpj=1670130)
> Mount-cache hash table entries: 512
> CPU: L1 I cache: 16K, L1 D cache: 16K
> CPU: L2 cache: 256K
> mce: CPU supports 5 MCE banks
> Performance Events: 
> no APIC, boot with the "lapic" boot parameter to force-enable it.
> no hardware sampling interrupt available.
> p6 PMU driver.
> ... version:                0
> ... bit width:              32
> ... generic registers:      2
> ... value mask:             00000000ffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   0
> ... event mask:             0000000000000003
> Checking 'hlt' instruction... OK.
> SMP alternatives: switching to UP code
> Freeing SMP alternatives: 11k freed
> ACPI: Core revision 20090521
> ACPI: setting ELCR to 0200 (from 0820)
> weird, boot CPU (#0) not listed by the BIOS.
> SMP motherboard not detected.
> Local APIC not detected. Using dummy APIC emulation.
> SMP disabled
> Brought up 1 CPUs
> Total of 1 processors activated (1002.83 BogoMIPS).
> CPU0 attaching NULL sched-domain.
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfd9a6, last bus=1
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Enabling special treatment for EC from MSI.
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using PIC for interrupt routing
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in interrupt mode
> ACPI: Power Resource [PFAN] (off)
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:00.0: reg 10 32bit mmio pref: [0xf8000000-0xfbffffff]
> pci 0000:00:06.0: reg 10 32bit mmio: [0xfedc0000-0xfedfffff]
> pci 0000:00:06.0: reg 14 io port: [0xfcc0-0xfcc7]
> pci 0000:00:06.0: reg 18 io port: [0xfcc8-0xfccf]
> pci 0000:00:06.0: supports D2
> pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
> pci 0000:00:06.0: PME# disabled
> pci 0000:00:07.1: reg 20 io port: [0xfcd0-0xfcdf]
> pci 0000:00:07.2: reg 20 io port: [0xfce0-0xfcff]
> pci 0000:00:07.3: quirk: region 8000-803f claimed by PIIX4 ACPI
> pci 0000:00:07.3: quirk: region 2180-218f claimed by PIIX4 SMB
> pci 0000:00:0a.0: reg 10 32bit mmio: [0x000000-0x000fff]
> pci 0000:00:0a.0: supports D1 D2
> pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.0: PME# disabled
> pci 0000:00:0a.1: reg 10 32bit mmio: [0x000000-0x000fff]
> pci 0000:00:0a.1: supports D1 D2
> pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.1: PME# disabled
> pci 0000:01:00.0: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
> pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:00:01.0: bridge 32bit mmio: [0xf0000000-0xf7ffffff]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs *5 6 7 10)
> ACPI: PCI Interrupt Link [LNKD] (IRQs *11)
> vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> PCI: Using ACPI for IRQ routing
> Switching to clocksource tsc
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:00: iomem range 0x0-0x9ffff could not be reserved
> system 00:00: iomem range 0xe0000-0xfffff could not be reserved
> system 00:00: iomem range 0x100000-0x7ffffff could not be reserved
> system 00:02: ioport range 0x4d0-0x4d1 has been reserved
> system 00:02: ioport range 0x398-0x399 has been reserved
> system 00:02: ioport range 0x2180-0x218f has been reserved
> system 00:02: ioport range 0x8000-0x803f has been reserved
> system 00:02: ioport range 0x3800-0x383f has been reserved
> system 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
> pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:01.0:   IO window: disabled
> pci 0000:00:01.0:   MEM window: 0xf0000000-0xf7ffffff
> pci 0000:00:01.0:   PREFETCH window: 0x18000000-0x180fffff
> pci 0000:00:0a.0: CardBus bridge, secondary bus 0000:02
> pci 0000:00:0a.0:   IO window: 0x001000-0x0010ff
> pci 0000:00:0a.0:   IO window: 0x001400-0x0014ff
> pci 0000:00:0a.0:   PREFETCH window: 0x8000000-0xbffffff
> pci 0000:00:0a.0:   MEM window: 0xc000000-0xfffffff
> pci 0000:00:0a.1: CardBus bridge, secondary bus 0000:06
> pci 0000:00:0a.1:   IO window: 0x001800-0x0018ff
> pci 0000:00:0a.1:   IO window: 0x001c00-0x001cff
> pci 0000:00:0a.1:   PREFETCH window: 0x10000000-0x13ffffff
> pci 0000:00:0a.1:   MEM window: 0x14000000-0x17ffffff
> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> pci 0000:00:0a.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> pci 0000:00:0a.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> pci_bus 0000:01: resource 1 mem: [0xf0000000-0xf7ffffff]
> pci_bus 0000:01: resource 2 pref mem [0x18000000-0x180fffff]
> pci_bus 0000:02: resource 0 io:  [0x1000-0x10ff]
> pci_bus 0000:02: resource 1 io:  [0x1400-0x14ff]
> pci_bus 0000:02: resource 2 pref mem [0x8000000-0xbffffff]
> pci_bus 0000:02: resource 3 mem: [0xc000000-0xfffffff]
> pci_bus 0000:06: resource 0 io:  [0x1800-0x18ff]
> pci_bus 0000:06: resource 1 io:  [0x1c00-0x1cff]
> pci_bus 0000:06: resource 2 pref mem [0x10000000-0x13ffffff]
> pci_bus 0000:06: resource 3 mem: [0x14000000-0x17ffffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
> TCP: Hash tables configured (established 4096 bind 4096)
> TCP reno registered
> NET: Registered protocol family 1
> Simple Boot Flag at 0x37 set to 0x1
> Scanning for low memory corruption every 60 seconds
> msgmni has been set to 242
> alg: No test for stdrng (krng)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered (default)
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> pci 0000:01:00.0: Boot video device
> ACPI: AC Adapter [AC] (on-line)
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> ACPI: Lid Switch [LID]
> fan PNP0C0B:00: registered as cooling_device0
> ACPI: Fan [FAN] (off)
> Marking TSC unstable due to TSC halts in idle
> ACPI: CPU0 (power states: C1[C1] C2[C2])
> processor LNXCPU:00: registered as cooling_device1
> ACPI: Processor [CPU0] (supports 4 throttling states)
> Switching to clocksource acpi_pm
> Switched to high resolution mode on CPU 0
> thermal LNXTHERM:01: registered as thermal_zone0
> ACPI: Thermal Zone [THRM] (64 C)
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 440BX Chipset
> agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
> Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> Hangcheck: Using get_cycles().
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
> 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> loop: module loaded
> Uniform Multi-Platform E-IDE driver
> piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
> piix 0000:00:07.1: IDE port disabled
> piix 0000:00:07.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xfcd0-0xfcd7
> Probing IDE interface ide0...
> ACPI: Battery Slot [BAT0] (battery absent)
> hda: IBM-DARA-212000, ATA DISK drive
> hdb: TOSHIBA DVD-ROM SD-C2302, ATAPI CD/DVD-ROM drive
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/33 mode selected
> hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdb: UDMA/33 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide-gd driver 1.18
> hda: max request size: 128KiB
> hda: 23579136 sectors (12072 MB) w/418KiB Cache, CHS=23392/16/63
> hda: cache flushes not supported
>  hda: hda1 hda2
> ide-cd driver 5.00
> ide-cd: hdb: ATAPI 24X DVD-ROM drive, 128kB Cache
> Uniform CD-ROM driver Revision: 3.20
> PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> cpuidle: using governor ladder
> cpuidle: using governor menu
> TCP cubic registered
> NET: Registered protocol family 17
> Using IPI No-Shortcut mode
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> Synaptics Touchpad, model: 1, fw: 4.6, id: 0x135ea1, caps: 0x804713/0x0
> input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input3
> EXT3-fs: hda2: couldn't mount because of unsupported optional features (240).
> EXT2-fs: hda2: couldn't mount because of unsupported optional features (240).
> EXT4-fs (hda2): barriers enabled
> EXT4-fs (hda2): delayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs (hda2): mounted filesystem with ordered data mode
> VFS: Mounted root (ext4 filesystem) readonly on device 3:2.
> Freeing unused kernel memory: 340k freed
> kjournald2 starting: pid 26, dev hda2:8, commit interval 5 seconds
> Write protecting the kernel text: 2872k
> Write protecting the kernel read-only data: 740k
> EXT4-fs (hda2): internal journal on hda2:8
> JBD: barrier-based sync failed on hda2:8 - disabling barriers

> Linux version 2.6.31-07223-g69d2587 (jimis@mango) (gcc version 4.4.2 20091208 (prerelease) (GCC) ) #17 SMP PREEMPT Wed Jan 6 18:39:29 EET 2010
> KERNEL supported cpus:
>   Intel GenuineIntel
>   AMD AuthenticAMD
>   NSC Geode by NSC
>   Cyrix CyrixInstead
>   Centaur CentaurHauls
>   Transmeta GenuineTMx86
>   Transmeta TransmetaCPU
>   UMC UMC UMC UMC
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
>  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000e9800 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
>  BIOS-e820: 0000000007ff0000 - 0000000007fffc00 (ACPI data)
>  BIOS-e820: 0000000007fffc00 - 0000000008000000 (ACPI NVS)
>  BIOS-e820: 00000000fffe9800 - 0000000100000000 (reserved)
> DMI 2.1 present.
> Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
> e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
> last_pfn = 0x7ff0 max_arch_pfn = 0x100000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-C7FFF write-protect
>   C8000-DFFFF uncachable
>   E0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 000000000 mask FF8000000 write-back
>   1 disabled
>   2 disabled
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> PAT not supported by CPU.
> Scanning 0 areas for low memory corruption
> modified physical RAM map:
>  modified: 0000000000000000 - 0000000000010000 (reserved)
>  modified: 0000000000010000 - 000000000009f400 (usable)
>  modified: 000000000009f400 - 00000000000a0000 (reserved)
>  modified: 00000000000e9800 - 0000000000100000 (reserved)
>  modified: 0000000000100000 - 0000000007ff0000 (usable)
>  modified: 0000000007ff0000 - 0000000007fffc00 (ACPI data)
>  modified: 0000000007fffc00 - 0000000008000000 (ACPI NVS)
>  modified: 00000000fffe9800 - 0000000100000000 (reserved)
> initial memory mapped : 0 - 01800000
> init_memory_mapping: 0000000000000000-0000000007ff0000
>  0000000000 - 0000400000 page 4k
>  0000400000 - 0007c00000 page 2M
>  0007c00000 - 0007ff0000 page 4k
> kernel direct mapping tables up to 7ff0000 @ 10000-15000
> ACPI: RSDP 000f6d80 00014 (v00 PTLTD )
> ACPI: RSDT 07ffd008 0002C (v01 PTLTD    RSDT   00000000  LTP 00000000)
> ACPI: FACP 07fffb65 00074 (v01 ASUS   L8400B   00000000 PTL  000F4240)
> ACPI: DSDT 07ffd034 02B31 (v01  Intel   Trajan 00000000 MSFT 01000004)
> ACPI: FACS 07ffffc0 00040
> ACPI: BOOT 07fffbd9 00027 (v01 PTLTD  $SBFTBL$ 00000000  LTP 00000001)
> 0MB HIGHMEM available.
> 127MB LOWMEM available.
>   mapped low ram: 0 - 07ff0000
>   low ram: 0 - 07ff0000
>   node 0 low ram: 00000000 - 07ff0000
>   node 0 bootmap 00011000 - 00012000
> (8 early reservations) ==> bootmem [0000000000 - 0007ff0000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
>   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
>   #3 [0001000000 - 00014d8b14]    TEXT DATA BSS ==> [0001000000 - 00014d8b14]
>   #4 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
>   #5 [00014d9000 - 00014df130]              BRK ==> [00014d9000 - 00014df130]
>   #6 [0000010000 - 0000011000]          PGTABLE ==> [0000010000 - 0000011000]
>   #7 [0000011000 - 0000012000]          BOOTMAP ==> [0000011000 - 0000012000]
> Zone PFN ranges:
>   DMA      0x00000010 -> 0x00001000
>   Normal   0x00001000 -> 0x00007ff0
>   HighMem  0x00007ff0 -> 0x00007ff0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000010 -> 0x0000009f
>     0: 0x00000100 -> 0x00007ff0
> On node 0 totalpages: 32639
> free_area_init_node: node 0, pgdat c13c13e0, node_mem_map c14e1200
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3951 pages, LIFO batch:0
>   Normal zone: 224 pages used for memmap
>   Normal zone: 28432 pages, LIFO batch:7
> Using APIC driver default
> ACPI: PM-Timer IO Port: 0x8008
> SMP: Allowing 1 CPUs, 0 hotplug CPUs
> Local APIC disabled by BIOS -- you can enable it with "lapic"
> APIC: disable apic facility
> nr_irqs_gsi: 16
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000ea000
> PM: Registered nosave memory: 00000000000ea000 - 0000000000100000
> Allocating PCI resources starting at 8000000 (gap: 8000000:f7fe9800)
> Booting paravirtualized kernel on bare hardware
> NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
> PERCPU: Embedded 13 pages/cpu @c1800000 s29656 r0 d23592 u4194304
> pcpu-alloc: s29656 r0 d23592 u4194304 alloc=1*4194304
> pcpu-alloc: [0] 0 
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32383
> Kernel command line: root=/dev/hda2 ro init=/bin/sh
> PID hash table entries: 512 (order: -1, 2048 bytes)
> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Initializing HighMem for node 0 (00000000:00000000)
> Memory: 124200k/131008k available (2871k kernel code, 6208k reserved, 992k data, 340k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff1e000 - 0xfffff000   ( 900 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xc87f0000 - 0xff7fe000   ( 880 MB)
>     lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
>       .init : 0xc13c7000 - 0xc141c000   ( 340 kB)
>       .data : 0xc12cdd54 - 0xc13c6038   ( 992 kB)
>       .text : 0xc1000000 - 0xc12cdd54   (2871 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Hierarchical RCU implementation.
> NR_IRQS:512
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Fast TSC calibration using PIT
> Detected 501.124 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 1002.00 BogoMIPS (lpj=1670413)
> Mount-cache hash table entries: 512
> CPU: L1 I cache: 16K, L1 D cache: 16K
> CPU: L2 cache: 256K
> mce: CPU supports 5 MCE banks
> Performance Events: 
> no APIC, boot with the "lapic" boot parameter to force-enable it.
> no hardware sampling interrupt available.
> p6 PMU driver.
> ... version:                0
> ... bit width:              32
> ... generic registers:      2
> ... value mask:             00000000ffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   0
> ... event mask:             0000000000000003
> Checking 'hlt' instruction... OK.
> SMP alternatives: switching to UP code
> Freeing SMP alternatives: 11k freed
> ACPI: Core revision 20090521
> ACPI: setting ELCR to 0200 (from 0820)
> weird, boot CPU (#0) not listed by the BIOS.
> SMP motherboard not detected.
> Local APIC not detected. Using dummy APIC emulation.
> SMP disabled
> Brought up 1 CPUs
> Total of 1 processors activated (1002.00 BogoMIPS).
> CPU0 attaching NULL sched-domain.
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfd9a6, last bus=1
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Enabling special treatment for EC from MSI.
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using PIC for interrupt routing
> ACPI: EC: non-query interrupt received, switching to interrupt mode
> ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: driver started in interrupt mode
> ACPI: Power Resource [PFAN] (off)
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci 0000:00:00.0: reg 10 32bit mmio pref: [0xf8000000-0xfbffffff]
> pci 0000:00:06.0: reg 10 32bit mmio: [0xfedc0000-0xfedfffff]
> pci 0000:00:06.0: reg 14 io port: [0xfcc0-0xfcc7]
> pci 0000:00:06.0: reg 18 io port: [0xfcc8-0xfccf]
> pci 0000:00:06.0: supports D2
> pci 0000:00:06.0: PME# supported from D2 D3hot D3cold
> pci 0000:00:06.0: PME# disabled
> pci 0000:00:07.1: reg 20 io port: [0xfcd0-0xfcdf]
> pci 0000:00:07.2: reg 20 io port: [0xfce0-0xfcff]
> pci 0000:00:07.3: quirk: region 8000-803f claimed by PIIX4 ACPI
> pci 0000:00:07.3: quirk: region 2180-218f claimed by PIIX4 SMB
> pci 0000:00:0a.0: reg 10 32bit mmio: [0x000000-0x000fff]
> pci 0000:00:0a.0: supports D1 D2
> pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.0: PME# disabled
> pci 0000:00:0a.1: reg 10 32bit mmio: [0x000000-0x000fff]
> pci 0000:00:0a.1: supports D1 D2
> pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.1: PME# disabled
> pci 0000:01:00.0: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
> pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x00ffff]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:00:01.0: bridge 32bit mmio: [0xf0000000-0xf7ffffff]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 11) *0, disabled.
> ACPI: PCI Interrupt Link [LNKC] (IRQs *5 6 7 10)
> ACPI: PCI Interrupt Link [LNKD] (IRQs *11)
> vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> PCI: Using ACPI for IRQ routing
> Switching to clocksource tsc
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:00: iomem range 0x0-0x9ffff could not be reserved
> system 00:00: iomem range 0xe0000-0xfffff could not be reserved
> system 00:00: iomem range 0x100000-0x7ffffff could not be reserved
> system 00:02: ioport range 0x4d0-0x4d1 has been reserved
> system 00:02: ioport range 0x398-0x399 has been reserved
> system 00:02: ioport range 0x2180-0x218f has been reserved
> system 00:02: ioport range 0x8000-0x803f has been reserved
> system 00:02: ioport range 0x3800-0x383f has been reserved
> system 00:02: iomem range 0xfff80000-0xffffffff could not be reserved
> pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
> pci 0000:00:01.0:   IO window: disabled
> pci 0000:00:01.0:   MEM window: 0xf0000000-0xf7ffffff
> pci 0000:00:01.0:   PREFETCH window: 0x18000000-0x180fffff
> pci 0000:00:0a.0: CardBus bridge, secondary bus 0000:02
> pci 0000:00:0a.0:   IO window: 0x001000-0x0010ff
> pci 0000:00:0a.0:   IO window: 0x001400-0x0014ff
> pci 0000:00:0a.0:   PREFETCH window: 0x8000000-0xbffffff
> pci 0000:00:0a.0:   MEM window: 0xc000000-0xfffffff
> pci 0000:00:0a.1: CardBus bridge, secondary bus 0000:06
> pci 0000:00:0a.1:   IO window: 0x001800-0x0018ff
> pci 0000:00:0a.1:   IO window: 0x001c00-0x001cff
> pci 0000:00:0a.1:   PREFETCH window: 0x10000000-0x13ffffff
> pci 0000:00:0a.1:   MEM window: 0x14000000-0x17ffffff
> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> pci 0000:00:0a.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> pci 0000:00:0a.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
> pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
> pci_bus 0000:01: resource 1 mem: [0xf0000000-0xf7ffffff]
> pci_bus 0000:01: resource 2 pref mem [0x18000000-0x180fffff]
> pci_bus 0000:02: resource 0 io:  [0x1000-0x10ff]
> pci_bus 0000:02: resource 1 io:  [0x1400-0x14ff]
> pci_bus 0000:02: resource 2 pref mem [0x8000000-0xbffffff]
> pci_bus 0000:02: resource 3 mem: [0xc000000-0xfffffff]
> pci_bus 0000:06: resource 0 io:  [0x1800-0x18ff]
> pci_bus 0000:06: resource 1 io:  [0x1c00-0x1cff]
> pci_bus 0000:06: resource 2 pref mem [0x10000000-0x13ffffff]
> pci_bus 0000:06: resource 3 mem: [0x14000000-0x17ffffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> TCP bind hash table entries: 4096 (order: 3, 32768 bytes)
> TCP: Hash tables configured (established 4096 bind 4096)
> TCP reno registered
> NET: Registered protocol family 1
> Simple Boot Flag at 0x37 set to 0x1
> Scanning for low memory corruption every 60 seconds
> msgmni has been set to 242
> alg: No test for stdrng (krng)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
> io scheduler noop registered (default)
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> pci 0000:01:00.0: Boot video device
> ACPI: AC Adapter [AC] (on-line)
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> ACPI: Power Button [PWRF]
> input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
> ACPI: Lid Switch [LID]
> fan PNP0C0B:00: registered as cooling_device0
> ACPI: Fan [FAN] (off)
> Marking TSC unstable due to TSC halts in idle
> ACPI: CPU0 (power states: C1[C1] C2[C2])
> processor LNXCPU:00: registered as cooling_device1
> ACPI: Processor [CPU0] (supports 4 throttling states)
> Switching to clocksource acpi_pm
> Switched to high resolution mode on CPU 0
> thermal LNXTHERM:01: registered as thermal_zone0
> ACPI: Thermal Zone [THRM] (54 C)
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 440BX Chipset
> agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
> Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
> Hangcheck: Using get_cycles().
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
> 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> loop: module loaded
> Uniform Multi-Platform E-IDE driver
> piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
> piix 0000:00:07.1: IDE port disabled
> piix 0000:00:07.1: not 100% native mode: will probe irqs later
>     ide0: BM-DMA at 0xfcd0-0xfcd7
> Probing IDE interface ide0...
> ACPI: Battery Slot [BAT0] (battery absent)
> hda: IBM-DARA-212000, ATA DISK drive
> hdb: TOSHIBA DVD-ROM SD-C2302, ATAPI CD/DVD-ROM drive
> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hda: UDMA/33 mode selected
> hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
> hdb: UDMA/33 mode selected
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> ide-gd driver 1.18
> hda: max request size: 128KiB
> hda: 23579136 sectors (12072 MB) w/418KiB Cache, CHS=23392/16/63
> hda: cache flushes not supported
>  hda: hda1 hda2
> ide-cd driver 5.00
> ide-cd: hdb: ATAPI 24X DVD-ROM drive, 128kB Cache
> Uniform CD-ROM driver Revision: 3.20
> PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> cpuidle: using governor ladder
> cpuidle: using governor menu
> TCP cubic registered
> NET: Registered protocol family 17
> Using IPI No-Shortcut mode
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
> Synaptics Touchpad, model: 1, fw: 4.6, id: 0x135ea1, caps: 0x804713/0x0
> input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input3
> EXT3-fs: hda2: couldn't mount because of unsupported optional features (240).
> EXT2-fs: hda2: couldn't mount because of unsupported optional features (240).
> EXT4-fs (hda2): barriers enabled
> EXT4-fs (hda2): delayed allocation enabled
> EXT4-fs: file extents enabled
> EXT4-fs: mballoc enabled
> EXT4-fs (hda2): mounted filesystem with ordered data mode
> VFS: Mounted root (ext4 filesystem) readonly on device 3:2.
> Freeing unused kernel memory: 340k freed
> kjournald2 starting: pid 26, dev hda2:8, commit interval 5 seconds
> Write protecting the kernel text: 2872k
> Write protecting the kernel read-only data: 740k
> EXT4-fs (hda2): internal journal on hda2:8
> JBD: barrier-based sync failed on hda2:8 - disabling barriers

Content-Description: bisection output
> 69d25870f20c4b2563304f2b79c5300dd60a067e is the first bad commit
> commit 69d25870f20c4b2563304f2b79c5300dd60a067e
> Author: Arjan van de Ven <arjan@infradead.org>
> Date:   Mon Sep 21 17:04:08 2009 -0700
> 
>     cpuidle: fix the menu governor to boost IO performance
>     
>     Fix the menu idle governor which balances power savings, energy efficiency
>     and performance impact.
>     
>     The reason for a reworked governor is that there have been serious
>     performance issues reported with the existing code on Nehalem server
>     systems.
>     
>     To show this I'm sure Andrew wants to see benchmark results:
>     (benchmark is "fio", "no cstates" is using "idle=poll")
>     
>                 no cstates      current linux   new algorithm
>     1 disk              107 Mb/s        85 Mb/s         105 Mb/s
>     2 disks             215 Mb/s        123 Mb/s        209 Mb/s
>     12 disks    590 Mb/s  320 Mb/s      585 Mb/s
>     
>     In various power benchmark measurements, no degredation was found by our
>     measurement&diagnostics team.  Obviously a small percentage more power was
>     used in the "fio" benchmark, due to the much higher performance.
>     
>     While it would be a novel idea to describe the new algorithm in this
>     commit message, I cheaped out and described it in comments in the code
>     instead.
>     
>     [changes since first post: spelling fixes from akpm, review feedback,
>     folded menu-tng into menu.c]
>     
>     Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>     Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>     Cc: Len Brown <lenb@kernel.org>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
>     Acked-by: Ingo Molnar <mingo@elte.hu>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> :040000 040000 6950249ee85fe869ebbb71aaf33984699224cd1d 1e4ab42d8d229d0151bb39a548ed95eb93f75f95 M      drivers
> :040000 040000 4bb15927952a3781752f462c9005860f1878265c 8a460cc55da7faac14523c79f6457b1cd9353276 M      include
> :040000 040000 71c103ec210293b8b6bcad896bec28b5abea635e cd730d0a1db46960a5f0e0590334c8ce5f413a13 M      kernel

