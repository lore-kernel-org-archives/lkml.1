Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZFOX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZFOX1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZFOX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:27:13 -0400
Received: from bar.sig21.net ([80.81.252.164]:33037 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbZFOX1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:27:12 -0400
Date: Tue, 16 Jun 2009 01:27:09 +0200
From: Johannes Stezenbach <js@sig21.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.30: hibernation/swsusp lockup due to acpi-cpufreq
Message-ID: <20090615232709.GA6059@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Spam-21-Score: -3.5 (---)
X-Spam-21-Report: No, score=-3.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.881,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

on my aging Thinkpad T42p resume from hibernation
fails in 2.6.30. There is a backtrace on suspend prior
to writing out the disk image, but I cannot capture
it due to lack of a serial port on the T42p. On
resume the machine is dead after reading the image
from disk.

I've bisected this to:

 commit 01599fca6758d2cd133e78f87426fc851c9ea725
 Author: Andrew Morton <akpm@linux-foundation.org>
 Date:   Mon Apr 13 10:27:49 2009 -0700

    cpufreq: use smp_call_function_[single|many]() in acpi-cpufreq.c

I see in git log that this commit is known broken, but the
resume on my machine is still broken in 2.6.30.

If I disable CONFIG_X86_ACPI_CPUFREQ suspend/resume works in 2.6.30.

I include lspci and dmesg below.


Johannes



00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller (rev 01)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc M10 NT [FireGL Mobility T2] (rev 80)
02:00.0 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
02:00.1 CardBus bridge: Texas Instruments PCI4520 PC card Cardbus Controller (rev 01)
02:01.0 Ethernet controller: Intel Corporation 82540EP Gigabit Ethernet Controller (Mobile) (rev 03)
02:02.0 Ethernet controller: Atheros Communications Inc. AR5212 802.11abg NIC (rev 01)



Linux version 2.6.30 (root@void) (gcc version 4.3.3 (Debian 4.3.3-11) ) #3 PREEMPT Tue Jun 16 00:17:11 CEST 2009
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
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff60000 (usable)
 BIOS-e820: 000000003ff60000 - 000000003ff77000 (ACPI data)
 BIOS-e820: 000000003ff77000 - 000000003ff79000 (ACPI NVS)
 BIOS-e820: 000000003ff80000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0x3ff60 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-CFFFF write-protect
  D0000-DBFFF uncachable
  DC000-DFFFF write-back
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FC0000000 write-back
  1 base 03FF80000 mask FFFF80000 uncachable
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
Warning only 895MB will be used.
Use a HIGHMEM enabled kernel.
init_memory_mapping: 0000000000000000-0000000037fa8000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037c00000 page 2M
 0037c00000 - 0037fa8000 page 4k
kernel direct mapping tables up to 37fa8000 @ 7000-c000
RAMDISK: 37c44000 - 37fefe13
Allocated new RAMDISK: 00653000 - 009fee13
Move RAMDISK from 0000000037c44000 - 0000000037fefe12 to 00653000 - 009fee12
ACPI: RSDP 000f6d70 00024 (v02 IBM   )
ACPI: XSDT 3ff6a672 0004C (v01 IBM    TP-1R    00003230  LTP 00000000)
ACPI: FACP 3ff6a700 000F4 (v03 IBM    TP-1R    00003230 IBM  00000001)
ACPI Warning (tbfadt-0531): 32/64X length mismatch in Gpe1Block: 0/32 [20090320]
ACPI Warning (tbfadt-0562): Optional field Gpe1Block has zero address or length: 000000000000102C/0 [20090320]
ACPI: DSDT 3ff6a8e7 0C530 (v01 IBM    TP-1R    00003230 MSFT 0100000E)
ACPI: FACS 3ff78000 00040
ACPI: SSDT 3ff6a8b4 00033 (v01 IBM    TP-1R    00003230 MSFT 0100000E)
ACPI: ECDT 3ff76e17 00052 (v01 IBM    TP-1R    00003230 IBM  00000001)
ACPI: TCPA 3ff76e69 00032 (v01 IBM    TP-1R    00003230 PTL  00000001)
ACPI: BOOT 3ff76fd8 00028 (v01 IBM    TP-1R    00003230  LTP 00000001)
895MB LOWMEM available.
  mapped low ram: 0 - 37fa8000
  low ram: 0 - 37fa8000
  node 0 low ram: 00000000 - 37fa8000
  node 0 bootmap 00008000 - 0000eff8
(7 early reservations) ==> bootmem [0000000000 - 0037fa8000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 000064f098]    TEXT DATA BSS ==> [0000100000 - 000064f098]
  #2 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #3 [0000650000 - 0000652128]              BRK ==> [0000650000 - 0000652128]
  #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #5 [0000653000 - 00009fee13]      NEW RAMDISK ==> [0000653000 - 00009fee13]
  #6 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00037fa8
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00037fa8
On node 0 totalpages: 229191
free_area_init_node: node 0, pgdat c0590410, node_mem_map c1000000
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223432 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x1008
Local APIC disabled by BIOS -- you can enable it with "lapic"
nr_irqs_gsi: 16
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bf800000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227399
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:288
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1794.244 MHz processor.
Console: colour VGA+ 80x34
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 899432k/917152k available (3160k kernel code, 17272k reserved, 1552k data, 296k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
    vmalloc : 0xf87a8000 - 0xfffa8000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7fa8000   ( 895 MB)
      .init : 0xc059e000 - 0xc05e8000   ( 296 kB)
      .data : 0xc041619f - 0xc059a2bc   (1552 kB)
      .text : 0xc0100000 - 0xc041619f   (3160 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay loop (skipped), value calculated using timer frequency.. 3588.48 BogoMIPS (lpj=17942440)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: Intel(R) Pentium(R) M processor 1.80GHz stepping 06
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090320
ACPI: setting ELCR to 0200 (from 0800)
net_namespace: 720 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd8d6, last bus=8
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using PIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: Power Resource [PUBS] (on)
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xc0000000-0xc00003ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x1860-0x186f]
pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
pci 0000:00:1f.3: reg 20 io port: [0x1880-0x189f]
pci 0000:00:1f.5: reg 10 io port: [0x1c00-0x1cff]
pci 0000:00:1f.5: reg 14 io port: [0x18c0-0x18ff]
pci 0000:00:1f.5: reg 18 32bit mmio: [0xc0000c00-0xc0000dff]
pci 0000:00:1f.5: reg 1c 32bit mmio: [0xc0000800-0xc00008ff]
pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.5: PME# disabled
pci 0000:00:1f.6: reg 10 io port: [0x2400-0x24ff]
pci 0000:00:1f.6: reg 14 io port: [0x2000-0x207f]
pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
pci 0000:00:1f.6: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
pci 0000:01:00.0: reg 18 32bit mmio: [0xc0100000-0xc010ffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
pci 0000:00:01.0: bridge 32bit mmio: [0xc0100000-0xc01fffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xe0000000-0xe7ffffff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xb0000000-0xb0000fff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:02:00.1: reg 10 32bit mmio: [0xb1000000-0xb1000fff]
pci 0000:02:00.1: supports D1 D2
pci 0000:02:00.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.1: PME# disabled
pci 0000:02:01.0: reg 10 32bit mmio: [0xc0240000-0xc025ffff]
pci 0000:02:01.0: reg 14 32bit mmio: [0xc0200000-0xc020ffff]
pci 0000:02:01.0: reg 18 io port: [0x8000-0x803f]
pci 0000:02:01.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:02:02.0: reg 10 32bit mmio: [0xc0210000-0xc021ffff]
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge io port: [0x4000-0x8fff]
pci 0000:00:1e.0: bridge 32bit mmio: [0xc0200000-0xcfffffff]
pci 0000:00:1e.0: bridge 32bit mmio pref: [0xe8000000-0xefffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff could not be reserved
system 00:00: iomem range 0xcc000-0xcffff could not be reserved
system 00:00: iomem range 0xdc000-0xdffff could not be reserved
system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
system 00:00: iomem range 0xe8000-0xebfff could not be reserved
system 00:00: iomem range 0xec000-0xeffff could not be reserved
system 00:00: iomem range 0xf0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x3fffffff could not be reserved
system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved
system 00:02: ioport range 0x1000-0x107f has been reserved
system 00:02: ioport range 0x1180-0x11bf has been reserved
system 00:02: ioport range 0x15e0-0x15ef has been reserved
system 00:02: ioport range 0x1600-0x162f has been reserved
system 00:02: ioport range 0x1632-0x167f has been reserved
system 00:02: ioport range 0x1630-0x1631 has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x3000-0x3fff
pci 0000:00:01.0:   MEM window: 0xc0100000-0xc01fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000e0000000-0x000000e7ffffff
pci 0000:02:00.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:00.0:   IO window: 0x004000-0x0040ff
pci 0000:02:00.0:   IO window: 0x004400-0x0044ff
pci 0000:02:00.0:   PREFETCH window: 0xe8000000-0xebffffff
pci 0000:02:00.0:   MEM window: 0xc4000000-0xc7ffffff
pci 0000:02:00.1: CardBus bridge, secondary bus 0000:07
pci 0000:02:00.1:   IO window: 0x004800-0x0048ff
pci 0000:02:00.1:   IO window: 0x004c00-0x004cff
pci 0000:02:00.1:   PREFETCH window: 0xec000000-0xefffffff
pci 0000:02:00.1:   MEM window: 0xc8000000-0xcbffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x4000-0x8fff
pci 0000:00:1e.0:   MEM window: 0xc0200000-0xcfffffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000e8000000-0x000000efffffff
pci 0000:00:1e.0: setting latency timer to 64
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
pci 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
pci 0000:02:00.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:01: resource 1 mem: [0xc0100000-0xc01fffff]
pci_bus 0000:01: resource 2 pref mem [0xe0000000-0xe7ffffff]
pci_bus 0000:02: resource 0 io:  [0x4000-0x8fff]
pci_bus 0000:02: resource 1 mem: [0xc0200000-0xcfffffff]
pci_bus 0000:02: resource 2 pref mem [0xe8000000-0xefffffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
pci_bus 0000:03: resource 0 io:  [0x4000-0x40ff]
pci_bus 0000:03: resource 1 io:  [0x4400-0x44ff]
pci_bus 0000:03: resource 2 pref mem [0xe8000000-0xebffffff]
pci_bus 0000:03: resource 3 mem: [0xc4000000-0xc7ffffff]
pci_bus 0000:07: resource 0 io:  [0x4800-0x48ff]
pci_bus 0000:07: resource 1 io:  [0x4c00-0x4cff]
pci_bus 0000:07: resource 2 pref mem [0xec000000-0xefffffff]
pci_bus 0000:07: resource 3 mem: [0xc8000000-0xcbffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs...
Freeing initrd memory: 3759k freed
Simple Boot Flag at 0x35 set to 0x1
cpu0(1) debug files 55
squashfs: version 4.0 (2009/01/31) Phillip Lougher
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
fuse init (API version 7.11)
msgmni has been set to 1764
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
pci 0000:01:00.0: Boot video device
radeonfb 0000:01:00.0: power state changed by ACPI to D0
radeonfb 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=6) Memory=320.00 Mhz, System=202.00 MHz
radeonfb: PLL min 20000 max 35000
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
Switched to high resolution mode on CPU 0
i2c-adapter i2c-1: unable to read EDID block.
Non-DDC laptop panel detected
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
i2c-adapter i2c-2: unable to read EDID block.
radeonfb: Monitor 1 type LCD found
radeonfb: Monitor 2 type no found
radeonfb: panel ID string: 1600x1200               
radeonfb: detected LVDS panel size from BIOS: 1600x1200
radeondb: BIOS provided dividers will be used
radeonfb: Dynamic Clock Power Management enabled
Console: switching to colour frame buffer device 200x75
radeonfb (0000:01:00.0): ATI Radeon 4e54 "NT"
power_supply AC: uevent
power_supply AC: No power supply yet
power_supply AC: power_supply_changed
ACPI: AC Adapter [AC] (on-line)
power_supply AC: power_supply_changed_work
power_supply AC: power_supply_update_gen_leds 1
power_supply AC: uevent
power_supply AC: POWER_SUPPLY_NAME=AC
power_supply AC: Static prop TYPE=Mains
power_supply AC: 1 dynamic props
power_supply AC: prop ONLINE=1
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
ACPI: Sleep Button [SLPB]
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:02/device:03/input/input3
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM0] (50 C)
power_supply BAT0: uevent
power_supply BAT0: No power supply yet
power_supply BAT0: power_supply_changed
power_supply BAT0: power_supply_changed_work
ACPI: Battery Slot [BAT0] (battery present)
power_supply BAT0: power_supply_update_bat_leds 4
power_supply BAT0: uevent
power_supply BAT0: POWER_SUPPLY_NAME=BAT0
power_supply BAT0: Static prop TYPE=Battery
power_supply BAT0: 13 dynamic props
power_supply BAT0: prop STATUS=Full
power_supply BAT0: prop PRESENT=1
power_supply BAT0: prop TECHNOLOGY=Li-ion
power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
power_supply BAT0: prop VOLTAGE_NOW=12390000
power_supply BAT0: prop CURRENT_NOW=0
power_supply BAT0: prop POWER_NOW=0
power_supply BAT0: prop ENERGY_FULL_DESIGN=71280000
power_supply BAT0: prop ENERGY_FULL=48970000
power_supply BAT0: prop ENERGY_NOW=48970000
power_supply BAT0: prop MODEL_NAME=IBM-93P5003
power_supply BAT0: prop MANUFACTURER=SONY
power_supply BAT0: prop SERIAL_NUMBER= 1416
Real Time Clock Driver v1.12b
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel 855PM Chipset
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
[drm] Initialized radeon 1.30.0 20080528 for 0000:01:00.0 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial 00:09: activated
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
serial 0000:00:1f.6: PCI INT B disabled
loop: module loaded
Uniform Multi-Platform E-IDE driver
piix 0000:00:1f.1: IDE controller (0x8086:0x24ca rev 0x01)
pci 0000:00:1f.1: enabling device (0005 -> 0007)
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
pci 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
piix 0000:00:1f.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1860-0x1867
    ide1: BM-DMA at 0x1868-0x186f
Probing IDE interface ide0...
hda: HTS726060M9AT00, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: UJDA765 DVD/CDRW, ATAPI CD/DVD-ROM drive
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 117210240 sectors (60011 MB) w/7877KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1 hda2
ide-cd driver 5.00
ide-cd: hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:02:01.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
e1000: 0000:02:01.0: e1000_probe: (PCI:33MHz:32-bit)
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
PPP BSD Compression module registered
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
yenta_cardbus 0000:02:00.0: CardBus bridge found [1014:0552]
yenta_cardbus 0000:02:00.0: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:02:00.0: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:00.0: TI: mfunc 0x01d21b22, devctl 0x64
yenta_cardbus 0000:02:00.0: ISA IRQ mask 0x04f8, PCI irq 11
yenta_cardbus 0000:02:00.0: Socket status: 30000086
yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
yenta_cardbus 0000:02:00.0: pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
yenta_cardbus 0000:02:00.1: CardBus bridge found [1014:0552]
yenta_cardbus 0000:02:00.1: Using INTVAL to route CSC interrupts to PCI
yenta_cardbus 0000:02:00.1: Routing CardBus interrupts to PCI
yenta_cardbus 0000:02:00.1: TI: mfunc 0x01d21b22, devctl 0x64
yenta_cardbus 0000:02:00.1: ISA IRQ mask 0x04f8, PCI irq 11
yenta_cardbus 0000:02:00.1: Socket status: 30000086
yenta_cardbus 0000:02:00.1: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x8fff
yenta_cardbus 0000:02:00.1: pcmcia: parent PCI bridge Memory window: 0xc0200000 - 0xcfffffff
yenta_cardbus 0000:02:00.1: pcmcia: parent PCI bridge Memory window: 0xe8000000 - 0xefffffff
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver ums-cypress
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
Registered led device: tpacpi::thinklight
Registered led device: tpacpi::power
Registered led device: tpacpi::standby
input: ThinkPad Extra Buttons as /devices/virtual/input/input5
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (14330 buckets, 57320 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Using IPI Shortcut mode
Clocksource tsc unstable (delta = -116160907 ns)
Synaptics Touchpad, model: 1, fw: 5.9, id: 0x2c6ab1, caps: 0x884793/0x0
serio: Synaptics pass-through port at isa0060/serio1/input0
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input6
registered taskstats version 1
Freeing unused kernel memory: 296k freed
power_supply AC: uevent
power_supply AC: POWER_SUPPLY_NAME=AC
power_supply AC: Static prop TYPE=Mains
power_supply AC: 1 dynamic props
power_supply AC: prop ONLINE=1
power_supply BAT0: uevent
power_supply BAT0: POWER_SUPPLY_NAME=BAT0
power_supply BAT0: Static prop TYPE=Battery
power_supply BAT0: 13 dynamic props
power_supply BAT0: prop STATUS=Full
power_supply BAT0: prop PRESENT=1
power_supply BAT0: prop TECHNOLOGY=Li-ion
power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
power_supply BAT0: prop VOLTAGE_NOW=12390000
power_supply BAT0: prop CURRENT_NOW=0
power_supply BAT0: prop POWER_NOW=0
power_supply BAT0: prop ENERGY_FULL_DESIGN=71280000
power_supply BAT0: prop ENERGY_FULL=48970000
power_supply BAT0: prop ENERGY_NOW=48970000
power_supply BAT0: prop MODEL_NAME=IBM-93P5003
power_supply BAT0: prop MANUFACTURER=SONY
power_supply BAT0: prop SERIAL_NUMBER= 1416
uhci_hcd: USB Universal Host Controller Interface driver
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 11 (level, low) -> IRQ 11
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xc0000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 11, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 11, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/serio2/input/input7
PM: Starting manual resume from disk
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
udev: starting version 141
power_supply AC: uevent
power_supply AC: POWER_SUPPLY_NAME=AC
power_supply AC: Static prop TYPE=Mains
power_supply AC: 1 dynamic props
power_supply AC: prop ONLINE=1
power_supply BAT0: uevent
power_supply BAT0: POWER_SUPPLY_NAME=BAT0
power_supply BAT0: Static prop TYPE=Battery
power_supply BAT0: 13 dynamic props
power_supply BAT0: prop STATUS=Full
power_supply BAT0: prop PRESENT=1
power_supply BAT0: prop TECHNOLOGY=Li-ion
power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
power_supply BAT0: prop VOLTAGE_NOW=12390000
power_supply BAT0: prop CURRENT_NOW=0
power_supply BAT0: prop POWER_NOW=0
power_supply BAT0: prop ENERGY_FULL_DESIGN=71280000
power_supply BAT0: prop ENERGY_FULL=48970000
power_supply BAT0: prop ENERGY_NOW=48970000
power_supply BAT0: prop MODEL_NAME=IBM-93P5003
power_supply BAT0: prop MANUFACTURER=SONY
power_supply BAT0: prop SERIAL_NUMBER= 1416
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
ath5k 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
ath5k 0000:02:02.0: registered as 'phy0'
phy0: Selected rate control algorithm 'minstrel'
Registered led device: ath5k-phy0::rx
Registered led device: ath5k-phy0::tx
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF5112B multiband radio found (0x36)
Adding 1048568k swap on /dev/mapper/vg0-cswap.  Priority:-1 extents:1 across:1048568k 
EXT3 FS on dm-2, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
agpgart-intel 0000:00:00.0: AGP 2.0 bridge
agpgart-intel 0000:00:00.0: putting AGP V2 device into 2x mode
radeonfb 0000:01:00.0: putting AGP V2 device into 2x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 2 usecs
nfsd: last server has exited, flushing export cache
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
