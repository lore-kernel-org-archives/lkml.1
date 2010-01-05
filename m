Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380Ab0AEVR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0AEVR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:17:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299Ab0AEVRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:17:55 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60962 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755243Ab0AEVRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:17:53 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: Yinghai Lu <yinghai@kernel.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: Memory probing fails after 2.6.30 (bisected)
In-reply-to: <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> <86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com>
Comments: In-reply-to Yinghai Lu <yinghai@kernel.org>
   message dated "Tue, 05 Jan 2010 11:02:14 -0800."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 05 Jan 2010 22:15:22 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.238.172
X-Scan-Result: No virus found in message 1NSGmS-0008Cm-Ct.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1NSGmS-0008Cm-Ct f50a3ec1b056fd8097b052ba830eb21b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


yinghai@kernel.org said:
> whole boot log with debug with boot command line?
>
> > I can produce a pic of the dmesg for the fingered commit of needed.
> boot that with earlyprintk=vga please. 

I managed to pull this one from the failing boot.
Does it help?

Linux version 2.6.30-rc2-00450-g8ecee46 (root@korven) (gcc version 4.3.2 (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #21 SMP Tue Jan 5 10:45:52 CET 2010
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
 BIOS-88: 0000000000000000 - 000000000009f000 (usable)
 BIOS-88: 0000000000100000 - 0000000001000000 (usable)
console [earlyvga0] enabled
DMI 2.4 present.
last_pfn = 0x1000 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base F7F800000 mask FFF800000 uncachable
  2 base 0FEDA0000 mask FFFFE0000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-0000000001000000
 0000000000 - 0000400000 page 4k
 0000400000 - 0001000000 page 2M
kernel direct mapping tables up to 1000000 @ 7000-b000
ACPI: RSDP 000f78b0 00024 (v02 HP    )
ACPI: XSDT 7f7e57c8 0007C (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 7f7e5684 000F4 (v04 HP     30AD     00000003 HP   00000001)
ACPI: DSDT 7f7e5acc 0FE7B (v01 HP       nc6400 00010000 MSFT 0100000E)
ACPI: FACS 7f7f7e80 00040
ACPI: SLIC 7f7e5844 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: HPET 7f7e59bc 00038 (v01 HP     30AD     00000001 HP   00000001)
ACPI: APIC 7f7e59f4 00068 (v01 HP     30AD     00000001 HP   00000001)
ACPI: MCFG 7f7e5a5c 0003C (v01 HP     30AD     00000001 HP   00000001)
ACPI: TCPA 7f7e5a98 00032 (v02 HP     30AD     00000001 HP   00000001)
ACPI: SSDT 7f7f5947 00059 (v01 HP       HPQNLP 00000001 MSFT 0100000E)
ACPI: SSDT 7f7f59a0 0032D (v01 HP       HPQSAT 00000001 MSFT 0100000E)
ACPI: SSDT 7f7f64e0 0025F (v01 HP      Cpu0Tst 00003000 INTL 20060317)
ACPI: SSDT 7f7f673f 000A6 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
ACPI: SSDT 7f7f67e5 004D7 (v01 HP        CpuPm 00003000 INTL 20060317)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
16MB LOWMEM available.
  mapped low ram: 0 - 01000000
  low ram: 0 - 01000000
  node 0 low ram: 00000000 - 01000000
  node 0 bootmap 00002000 - 00002200
(7 early reservations) ==> bootmem [0000000000 - 0001000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 000079a2f8]    TEXT DATA BSS ==> [0000100000 - 000079a2f8]
  #4 [000009ac00 - 0000100000]    BIOS reserved ==> [000009ac00 - 0000100000]
  #5 [000079b000 - 000079e164]              BRK ==> [000079b000 - 000079e164]
  #6 [0000002000 - 0000003000]          BOOTMAP ==> [0000002000 - 0000003000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00001000
  HighMem  0x00001000 -> 0x00001000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00001000
On node 0 totalpages: 3999
free_area_init_node: node 0, pgdat c069a480, node_mem_map c000c000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 0000000000100000
Allocating PCI resources starting at 10000000 (gap: 1000000:ff000000)
NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 11 pages at c002d000, static data 22940 bytes
Built 1 zonelists in Zone order, mobility grouping off.  Total pages: 3967
Kernel command line: earlyprintk=vga debug root=/dev/sda5 lpj=5546966 boot_delay=10 init=/bin/bash
boot_delay: 10, preset_lpj: 5546966, lpj: 5546966, HZ: 300, printk_delay_msec: 1663800
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:320
PID hash table entries: 64 (order: 6, 256 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1662.321 MHz processor.
Console: colour VGA+ 80x25
console handover: boot [earlyvga0] -> real [tty0]
Dentry cache hash table entries: 2048 (order: 1, 8192 bytes)
Inode-cache hash table entries: 1024 (order: 0, 4096 bytes)
Initializing HighMem for node 0 (00000000:00000000)
Memory: 8792k/16384k available (3710k kernel code, 7200k reserved, 2105k data, 324k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc1800000 - 0xff7fe000   ( 991 MB)
    lowmem  : 0xc0000000 - 0xc1000000   (  16 MB)
      .init : 0xc06b8000 - 0xc0709000   ( 324 kB)
      .data : 0xc049f93b - 0xc06ae084   (2105 kB)
      .text : 0xc0100000 - 0xc049f93b   (3710 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped) preset value.. 3329.85 BogoMIPS (lpj=5546966)
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090320
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay loop (skipped) preset value.. 3329.85 BogoMIPS (lpj=5546966)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T5500  @ 1.66GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (6659.70 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 712 bytes
HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  6165.600 MB/sec
xor: using function: pIII_sse (6165.600 MB/sec)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xf0322, last bus=32
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG for extended config space
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: Power Resource [C1EF] (on)
ACPI: Power Resource [C1F6] (on)
ACPI: Power Resource [C220] (on)
ACPI: Power Resource [C228] (on)
ACPI: Power Resource [C32D] (off)
ACPI: Power Resource [C32E] (off)
ACPI: Power Resource [C32F] (off)
ACPI: Power Resource [C330] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [C002] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xf4600000-0xf467ffff]
pci 0000:00:02.0: reg 14 io port: [0x4000-0x4007]
pci 0000:00:02.0: reg 18 32bit mmio: [0xe0000000-0xefffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xf4680000-0xf46bffff]
pci 0000:00:02.1: reg 10 32bit mmio: [0xf4700000-0xf477ffff]
pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4780000-0xf4783fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x4020-0x403f]
pci 0000:00:1d.1: reg 20 io port: [0x4040-0x405f]
pci 0000:00:1d.2: reg 20 io port: [0x4060-0x407f]
pci 0000:00:1d.3: reg 20 io port: [0x4080-0x409f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4784000-0xf47843ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0100 (mask 000f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0238 (mask 0007)
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x40a0-0x40af]
pci 0000:00:1f.2: reg 10 io port: [0x13f0-0x13f7]
pci 0000:00:1f.2: reg 14 io port: [0x15f4-0x15f7]
pci 0000:00:1f.2: reg 18 io port: [0x1370-0x1377]
pci 0000:00:1f.2: reg 1c io port: [0x1574-0x1577]
pci 0000:00:1f.2: reg 20 io port: [0x40d0-0x40df]
pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4785000-0xf47853ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:08:00.0: reg 10 64bit mmio: [0xf4100000-0xf410ffff]
pci 0000:08:00.0: PME# supported from D3hot D3cold
pci 0000:08:00.0: PME# disabled
pci 0000:00:1c.0: bridge 32bit mmio: [0xf4100000-0xf41fffff]
pci 0000:10:00.0: reg 10 32bit mmio: [0xf4000000-0xf4000fff]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xf4000000-0xf40fffff]
pci 0000:00:1c.3: bridge io port: [0x2000-0x3fff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xf0000000-0xf3ffffff]
pci 0000:02:06.0: reg 10 32bit mmio: [0xf4200000-0xf4200fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.2: reg 10 32bit mmio: [0xf4201000-0xf4201fff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: reg 10 32bit mmio: [0xf4202000-0xf42020ff]
pci 0000:02:06.3: supports D1 D2
pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot
pci 0000:02:06.3: PME# disabled
pci 0000:02:06.4: reg 10 32bit mmio: [0xf4203000-0xf4203fff]
pci 0000:02:06.4: reg 14 32bit mmio: [0xf4204000-0xf4204fff]
pci 0000:02:06.4: supports D1 D2
pci 0000:02:06.4: PME# supported from D0 D1 D2 D3hot
pci 0000:02:06.4: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xf4200000-0xf45fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C002._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C098._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C101._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C111._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C002.C117._PRT]
ACPI: PCI Interrupt Link [C10D] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10E] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10F] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C110] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C123] (IRQs *10 11)
ACPI: PCI Interrupt Link [C124] (IRQs *10 11)
ACPI: PCI Interrupt Link [C125] (IRQs 10 *11)
ACPI Exception (pci_link-0182): AE_NOT_FOUND, Evaluating _PRS [20090320]
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
raid6: int32x1    682 MB/s
raid6: int32x2    683 MB/s
raid6: int32x4    506 MB/s
raid6: int32x8    444 MB/s
raid6: mmxx1     2185 MB/s
raid6: mmxx2     2396 MB/s
raid6: sse1x1    1321 MB/s
raid6: sse1x2    1792 MB/s
raid6: sse2x1    2540 MB/s
raid6: sse2x2    2769 MB/s
raid6: using algorithm sse2x2 (2769 MB/s)
ACPI: WMI: Mapper loaded
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 23
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
cfg80211: Calling CRDA to update world regulatory domain
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
system 00:0c: ioport range 0x500-0x55f has been reserved
system 00:0c: ioport range 0x800-0x80f has been reserved
system 00:0c: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0e: ioport range 0x4d0-0x4d1 has been reserved
system 00:0e: ioport range 0x1000-0x107f has been reserved
system 00:0e: ioport range 0x1100-0x113f has been reserved
system 00:0e: ioport range 0x1200-0x121f has been reserved
system 00:0e: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0e: iomem range 0xfec00000-0xfec000ff has been reserved
system 00:0e: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:0e: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:0e: iomem range 0xfed90000-0xfed9afff has been reserved
system 00:0f: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:0f: iomem range 0xfee00000-0xfee00fff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xf4100000-0xf41fffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xf4000000-0xf40fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:20
pci 0000:00:1c.3:   IO window: 0x2000-0x3fff
pci 0000:00:1c.3:   MEM window: 0xf0000000-0xf3ffffff
pci 0000:00:1c.3:   PREFETCH window: disabled
pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:06.0:   IO window: 0x005000-0x0050ff
pci 0000:02:06.0:   IO window: 0x005400-0x0054ff
pci 0000:02:06.0:   PREFETCH window: 0x10000000-0x13ffffff
pci 0000:02:06.0:   MEM window: 0x14000000-0x17ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x5000-0x5fff
pci 0000:00:1e.0:   MEM window: 0xf4200000-0xf45fffff
pci 0000:00:1e.0:   PREFETCH window: 0x00000010000000-0x00000013ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:08: resource 0 mem: [0x0-0x0]
pci_bus 0000:08: resource 1 mem: [0xf4100000-0xf41fffff]
pci_bus 0000:08: resource 2 mem: [0x0-0x0]
pci_bus 0000:08: resource 3 mem: [0x0-0x0]
pci_bus 0000:10: resource 0 mem: [0x0-0x0]
pci_bus 0000:10: resource 1 mem: [0xf4000000-0xf40fffff]
pci_bus 0000:10: resource 2 mem: [0x0-0x0]
pci_bus 0000:10: resource 3 mem: [0x0-0x0]
pci_bus 0000:20: resource 0 io:  [0x2000-0x3fff]
pci_bus 0000:20: resource 1 mem: [0xf0000000-0xf3ffffff]
pci_bus 0000:20: resource 2 mem: [0x0-0x0]
pci_bus 0000:20: resource 3 mem: [0x0-0x0]
pci_bus 0000:02: resource 0 io:  [0x5000-0x5fff]
pci_bus 0000:02: resource 1 mem: [0xf4200000-0xf45fffff]
pci_bus 0000:02: resource 2 mem: [0x10000000-0x13ffffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:03: resource 0 io:  [0x5000-0x50ff]
pci_bus 0000:03: resource 1 io:  [0x5400-0x54ff]
pci_bus 0000:03: resource 2 mem: [0x10000000-0x13ffffff]
pci_bus 0000:03: resource 3 mem: [0x14000000-0x17ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 512 (order: 0, 4096 bytes)
TCP bind hash table entries: 512 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 512 bind 512)
TCP reno registered
NET: Registered protocol family 1
Machine check exception polling timer started.
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
HugeTLB registered 4 MB page size, pre-allocated 0 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
ROMFS MTD (C) 2007 Red Hat, Inc.
msgmni has been set to 17
alg: No test for stdrng (krng)
async_tx: api initialized (sync-only)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
ACPI: AC Adapter [C1B2] (on-line)
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [C249]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [C241]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [C331] (off)
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [C332] (off)
fan PNP0C0B:02: registered as cooling_device2
ACPI: Fan [C333] (off)
fan PNP0C0B:03: registered as cooling_device3
ACPI: Fan [C334] (off)
ACPI: SSDT 7f7f5d95 001FB (v01 HP      Cpu0Ist 00003000 INTL 20060317)
ACPI: SSDT 7f7f6015 004CB (v01 HP      Cpu0Cst 00003001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI_CPU:00: registered as cooling_device4
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7f7f5ccd 000C8 (v01 HP      Cpu1Ist 00003000 INTL 20060317)
ACPI: SSDT 7f7f5f90 00085 (v01 HP      Cpu1Cst 00003000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI_CPU:01: registered as cooling_device5
ACPI: Processor [CPU1] (supports 8 throttling states)
intel_rng: FWH not detected
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
SyncLink PC Card driver $Revision: 4.34 $
ACPI: Battery Slot [C1B4] (battery present)
SyncLink PC Card driver $Revision: 4.34 $, tty major#253
ACPI: Battery Slot [C1B3] (battery absent)
cm4000_cs.c v2.4.0gm6 - All bugs added by Harald Welte
OMNIKEY CardMan 4040 v1.1.0gm5 - All bugs added by Harald Welte
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x01)
pci 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
piix 0000:00:1f.1: IDE port disabled
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x40a0-0x40a7
Probing IDE interface ide0...
hda: HL-DT-ST DVDRAM GSA-U10N, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
ide-cd driver 5.00
ide-cd: hda: ATAPI 24X DVD-ROM DVD-R/RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
ahci 0000:00:1f.2: irq 24 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xf4785000 port 0xf4785100 irq 24
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
tg3.c:v3.98 (February 25, 2009)
tg3 0000:08:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
tg3 0000:08:00.0: setting latency timer to 64
tg3 0000:08:00.0: wake-up capability disabled by ACPI
tg3 0000:08:00.0: PME# disabled
eth0: Tigon3 [partno(BCM95751M) rev 4201] (PCI Express) MAC address 00:1e:ec:a3:fa:9f
eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
PPP generic driver version 2.4.2
console [netcon0] enabled
netconsole: network logging started
yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:30ad]
yenta_cardbus 0000:02:06.0: Enabling burst memory read transactions
yenta_cardbus 0000:02:06.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:02:06.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:06.0: TI: mfunc 0x01aa1b22, devctl 0x64
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: ATA-8: WDC WD3200BEVT-00ZCT0, 11.01A11, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd c6/00:10:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
ata1.00: configured for UDMA/133
ata1.00: configured for UDMA/133
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-0 11.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x0cf8, PCI irq 18
yenta_cardbus 0000:02:06.0: Socket status: 30000006
pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #03 to #06
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x5000 - 0x5fff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xf4200000 - 0xf45fffff
yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x10000000 - 0x13ffffff
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xf4784000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
116x: driver isp116x-hcd, 03 Nov 2005
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00004020
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00004040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00004080
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
sl811: driver sl811-hcd, 19 May 2005
driver u132_hcd built at 10:45:40 on Jan  5 2010
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver ums-alauda
usbcore: registered new interface driver ums-datafab
usbcore: registered new interface driver ums-freecom
usbcore: registered new interface driver ums-isd200
usbcore: registered new interface driver ums-jumpshot
usbcore: registered new interface driver ums-karma
usb 2-1: new full speed USB device using uhci_hcd and address 2
usbcore: registered new interface driver ums-sddr09
usbcore: registered new interface driver ums-sddr55
usbcore: registered new interface driver ums-usbat
usbcore: registered new interface driver usbserial
usbserial: USB Serial Driver core
driver ftdi-elan built at 10:45:37 on Jan  5 2010
usbcore: registered new interface driver ftdi-elan
PNP: PS/2 Controller [PNP0303:C21D,PNP0f13:C21E] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
md: linear personality registered for level -1
input: AT Translated Set 2 keyboard as /class/input/input3
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
md: raid10 personality registered for level 10
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: multipath personality registered for level -4
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
Bluetooth: Broadcom Blutonium firmware driver ver 1.2
usbcore: registered new interface driver bcm203x
EDAC MC: Ver: 2.1.0 Jan  5 2010
cpuidle: using governor ladder
Marking TSC unstable due to TSC halts in idle
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
usb 2-1: configuration #1 chosen from 1 choice
Advanced Linux Sound Architecture Driver Version 1.0.19.
HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA device list:
  #0: HDA Intel at 0xf4780000 irq 16
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
oprofile: using NMI interrupt.
serio: Synaptics pass-through port at isa0060/serio4/input0
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
input: SynPS/2 Synaptics TouchPad as /class/input/input4
Bluetooth: L2CAP ver 2.13
usb 3-1: new full speed USB device using uhci_hcd and address 2
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI No-Shortcut mode
usb 3-1: configuration #1 chosen from 1 choice
input: PS/2 Generic Mouse as /class/input/input5
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
Freeing unused kernel memory: 324k freed
EXT3 FS on sda5, internal journal


