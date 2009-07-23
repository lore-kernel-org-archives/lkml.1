Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZGWOO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZGWOO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbZGWOO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:14:27 -0400
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:52503 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbZGWOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:14:25 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
Date: Thu, 23 Jul 2009 16:14:22 +0200
User-Agent: KMail/1.9.9
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/AHaKlPEOdO7nD8"
Message-Id: <200907231614.23570.elendil@planet.nl>
X-OriginalArrivalTime: 23 Jul 2009 14:14:24.0567 (UTC) FILETIME=[E192A470:01CA0B9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/AHaKlPEOdO7nD8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm seeing the following change in dmesg between -rc3 and -rc4:
-system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
+system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved

There is nothing in the earlier part of dmesg that would explain this 
change.

The change is also visible in /proc/iomem:
 fec00000-fec00fff : IOAPIC 0
   fec00000-fec00fff : reserved
-    fec00000-fec000ff : pnp 00:0c

I somewhat suspect 857fdc53a0a90c3ba7fcf5b1fb4c7a62ae03cf82:
    x86/pci: insert ioapic resource before assigning unassigned resources

System is HP 2510p notebook (x86_64).

Cheers,
FJP


--Boundary-00=_/AHaKlPEOdO7nD8
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg_31-rc4"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="dmesg_31-rc4"

Linux version 2.6.31-rc4-pat (root@aragorn) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #19 SMP Thu Jul 23 15:32:44 CEST 2009
Command line: root=/dev/mapper/main-root ro vga=791 quiet
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007e7b0000 (usable)
 BIOS-e820: 000000007e7b0000 - 000000007e7c5400 (reserved)
 BIOS-e820: 000000007e7c5400 - 000000007e7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007e7e7fb8 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7e7b0 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask F80000000 write-back
  1 base 07F000000 mask FFF000000 uncachable
  2 base 07E800000 mask FFF800000 uncachable
  3 base 0FEDA0000 mask FFFFE0000 uncachable
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000007e7b0000
 0000000000 - 007e600000 page 2M
 007e600000 - 007e7b0000 page 4k
kernel direct mapping tables up to 7e7b0000 @ 8000-c000
RAMDISK: 37a92000 - 37fef7d8
ACPI: RSDP 00000000000f7960 00024 (v02 HP    )
ACPI: XSDT 000000007e7c81c8 0007C (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: FACP 000000007e7c8084 000F4 (v04 HP     30C9     00000003 HP   00000001)
ACPI: DSDT 000000007e7c8538 13484 (v01 HP       nc2500 00010000 MSFT 03000001)
ACPI: FACS 000000007e7e7d80 00040
ACPI: SLIC 000000007e7c8244 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
ACPI: HPET 000000007e7c83bc 00038 (v01 HP     30C9     00000001 HP   00000001)
ACPI: APIC 000000007e7c83f4 00068 (v01 HP     30C9     00000001 HP   00000001)
ACPI: MCFG 000000007e7c845c 0003C (v01 HP     30C9     00000001 HP   00000001)
ACPI: TCPA 000000007e7c8498 00032 (v02 HP     30C9     00000001 HP   00000001)
ACPI: ASF! 000000007e7c84cc 00069 (v16 HP     CHIMAYU  00000001 HP   00000000)
ACPI: SSDT 000000007e7db9bc 002BE (v01 HP       HPQPAT 00000001 MSFT 03000001)
ACPI: SSDT 000000007e7dc640 0025F (v01 HP      Cpu0Tst 00003000 INTL 20060317)
ACPI: SSDT 000000007e7dc89f 000A6 (v01 HP      Cpu1Tst 00003000 INTL 20060317)
ACPI: SSDT 000000007e7dc945 004D7 (v01 HP        CpuPm 00003000 INTL 20060317)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 007e7b0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00014eabb0]    TEXT DATA BSS ==> [0001000000 - 00014eabb0]
  #3 [0037a92000 - 0037fef7d8]          RAMDISK ==> [0037a92000 - 0037fef7d8]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [00014eb000 - 00014eb18c]              BRK ==> [00014eb000 - 00014eb18c]
  #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
 [ffffea0000000000-ffffea0001ffffff] PMD -> [ffff880001a00000-ffff8800039fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0007e7b0
On node 0 totalpages: 517967
  DMA zone: 64 pages used for memmap
  DMA zone: 101 pages reserved
  DMA zone: 3834 pages, LIFO batch:0
  DMA32 zone: 8031 pages used for memmap
  DMA32 zone: 505937 pages, LIFO batch:31
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
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 7f000000 (gap: 7f000000:7fc00000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages at ffff880001504000, static data 71392 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 509771
Kernel command line: root=/dev/mapper/main-root ro vga=791 quiet
PID hash table entries: 4096 (order: 12, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Memory: 2024536k/2072256k available (2404k kernel code, 388k absent, 46756k reserved, 1574k data, 360k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
NR_IRQS:512
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1330.026 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 2660.05 BogoMIPS (lpj=5320104)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20090521
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 2659.98 BogoMIPS (lpj=5319961)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     U7700  @ 1.33GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (5320.03 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
NET: Registered protocol family 16
ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Enabling special treatment for EC from MSI.
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at f8000000 - fbffffff
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [C003] (0000:00)
pci 0000:00:02.0: reg 10 64bit mmio: [0xe0400000-0xe04fffff]
pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 20 io port: [0x2000-0x2007]
pci 0000:00:02.1: reg 10 64bit mmio: [0xe0500000-0xe05fffff]
pci 0000:00:03.0: reg 10 64bit mmio: [0xe0600000-0xe060000f]
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:03.2: reg 10 io port: [0x2008-0x200f]
pci 0000:00:03.2: reg 14 io port: [0x2010-0x2013]
pci 0000:00:03.2: reg 18 io port: [0x2018-0x201f]
pci 0000:00:03.2: reg 1c io port: [0x2020-0x2023]
pci 0000:00:03.2: reg 20 io port: [0x2030-0x203f]
pci 0000:00:03.3: reg 10 io port: [0x2040-0x2047]
pci 0000:00:03.3: reg 14 32bit mmio: [0xe0601000-0xe0601fff]
pci 0000:00:19.0: reg 10 32bit mmio: [0xe0620000-0xe063ffff]
pci 0000:00:19.0: reg 14 32bit mmio: [0xe0640000-0xe0640fff]
pci 0000:00:19.0: reg 18 io port: [0x2060-0x207f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
pci 0000:00:1a.0: reg 20 io port: [0x2080-0x209f]
pci 0000:00:1a.1: reg 20 io port: [0x20a0-0x20bf]
pci 0000:00:1a.7: reg 10 32bit mmio: [0xe0641000-0xe06413ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10 64bit mmio: [0xe0644000-0xe0647fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0x20c0-0x20df]
pci 0000:00:1d.1: reg 20 io port: [0x20e0-0x20ff]
pci 0000:00:1d.2: reg 20 io port: [0x2100-0x211f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xe0648000-0xe06483ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)
pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
pci 0000:00:1f.1: reg 20 io port: [0x2120-0x212f]
pci 0000:10:00.0: reg 10 64bit mmio: [0xe0000000-0xe0001fff]
pci 0000:10:00.0: PME# supported from D0 D3hot D3cold
pci 0000:10:00.0: PME# disabled
pci 0000:00:1c.1: bridge 32bit mmio: [0xe0000000-0xe00fffff]
pci 0000:02:06.0: reg 10 32bit mmio: [0xe0100000-0xe0100fff]
pci 0000:02:06.0: supports D1 D2
pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.0: PME# disabled
pci 0000:02:06.1: reg 10 32bit mmio: [0xe0101000-0xe01017ff]
pci 0000:02:06.1: supports D1 D2
pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.1: PME# disabled
pci 0000:02:06.2: reg 10 32bit mmio: [0xe0102000-0xe01020ff]
pci 0000:02:06.2: supports D1 D2
pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.2: PME# disabled
pci 0000:02:06.3: reg 10 32bit mmio: [0xe0103000-0xe01030ff]
pci 0000:02:06.3: supports D1 D2
pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:06.3: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xe0100000-0xe03fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception: AE_NOT_FOUND, Evaluating _PRS 20090521 pci_link-182
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved
system 00:0a: ioport range 0x500-0x55f has been reserved
system 00:0a: ioport range 0x800-0x80f has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff has been reserved
system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x2f8-0x2ff has been reserved
system 00:0c: ioport range 0x3f8-0x3ff has been reserved
system 00:0c: ioport range 0x1000-0x107f has been reserved
system 00:0c: ioport range 0x1100-0x113f has been reserved
system 00:0c: ioport range 0x1200-0x121f has been reserved
system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:0c: iomem range 0xfed90000-0xfed99fff has been reserved
system 00:0d: iomem range 0xcee00-0xcffff has been reserved
system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
system 00:0d: iomem range 0xfeda0000-0xfedbffff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:10
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xe0000000-0xe00fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
pci 0000:02:06.0:   PREFETCH window: 0x80000000-0x83ffffff
pci 0000:02:06.0:   MEM window: 0x84000000-0x87ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xe0100000-0xe03fffff
pci 0000:00:1e.0:   PREFETCH window: 0x80000000-0x83ffffff
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:02:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:10: resource 1 mem: [0xe0000000-0xe00fffff]
pci_bus 0000:02: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:02: resource 1 mem: [0xe0100000-0xe03fffff]
pci_bus 0000:02: resource 2 pref mem [0x80000000-0x83ffffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:03: resource 0 io:  [0x3000-0x30ff]
pci_bus 0000:03: resource 1 io:  [0x3400-0x34ff]
pci_bus 0000:03: resource 2 pref mem [0x80000000-0x83ffffff]
pci_bus 0000:03: resource 3 mem: [0x84000000-0x87ffffff]
[...]

--Boundary-00=_/AHaKlPEOdO7nD8--
