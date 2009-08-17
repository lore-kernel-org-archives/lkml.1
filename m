Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbZHQTyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbZHQTyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756829AbZHQTyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:54:14 -0400
Received: from mail.vyatta.com ([76.74.103.46]:46458 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756503AbZHQTyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:54:12 -0400
Date: Mon, 17 Aug 2009 12:54:06 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
Message-ID: <20090817125406.03e26060@nehalam>
In-Reply-To: <alpine.LFD.2.00.0908172032500.2782@localhost.localdomain>
References: <20090817090319.20979986@nehalam>
	<1250531337.26171.12.camel@work-vm>
	<20090817110127.40ee5c29@nehalam>
	<1250532954.26171.35.camel@work-vm>
	<20090817112704.2b4b2987@nehalam>
	<alpine.LFD.2.00.0908172032500.2782@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 20:34:02 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 17 Aug 2009, Stephen Hemminger wrote:
> > On Mon, 17 Aug 2009 11:15:54 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > > > > The behavior you describe where you can't switch to the TSC, may be due
> > > > > to the TSC disqualification code marking it as non HRT compatible
> > > > > (again, I need to double check). While I'm not sure that's really
> > > > > correct, as the TSC is fine for HRT, in this case on your box, the TSC
> > > > > has been marked as unstable (likely due to being unsynced on old AMD SMP
> > > > > systems). There is a real chance that the timekeeping code on your
> > > > > system could see the TSC go backwards, calculate a negative time
> > > > > interval, and then end up hanging. 
> > > > > 
> > > > 
> > > > TSC was alway stable on this box, and worked fine.  There was no
> > > > message in log about TSC instability. The change was bisected
> > > > down to that one commit.
> > > 
> > > But just to clarify, the TSC was never selected as the default
> > > clocksource on the box either, right?
> > 
> > correct.
> > 
> > I am okay with turning it off on boot command line for my tests,
> > but it might be an issue for other users.
> 
> Can you please provide a full dmesg of pre 31 and the output of
> /sys/.../available_clocksources before you switch to TSC ?

Linux version 2.6.30-1-amd64-vyatta (root@vyatta) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Fri Jul 31 10:10:16 PDT 2009
Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30-1-amd64-vyatta quiet root=UUID=56949d77-24b4-41ec-83d4-0a6c2da784bd ro console=ttyS0,9600 console=tty0
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
 BIOS-e820: 00000000cff60000 - 00000000cff72000 (ACPI data)
 BIOS-e820: 00000000cff72000 - 00000000cff80000 (ACPI NVS)
 BIOS-e820: 00000000cff80000 - 00000000d0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec00400 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
DMI present.
last_pfn = 0xcff60 max_arch_pfn = 0x100000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D4FFF write-protect
  D5000-E7FFF uncachable
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 disabled
  1 disabled
  2 base 0000000000 mask FF80000000 write-back
  3 base 0080000000 mask FFC0000000 write-back
  4 base 00C0000000 mask FFF0000000 write-back
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-00000000cff60000
 0000000000 - 00cfe00000 page 2M
 00cfe00000 - 00cff60000 page 4k
kernel direct mapping tables up to cff60000 @ 8000-e000
RAMDISK: 377f8000 - 37fef8ca
ACPI: RSDP 00000000000f7170 00024 (v02 PTLTD )
ACPI: XSDT 00000000cff6d116 00044 (v01 PTLTD  	 XSDT   06040000  LTP 00000000)
ACPI: FACP 00000000cff71d0f 000F4 (v03 AMD    HAMMER   06040000 PTEC 000F4240)
ACPI: DSDT 00000000cff6d15a 04B41 (v01 AMD-K8  AMDACPI 06040000 MSFT 0100000E)
ACPI: FACS 00000000cff72fc0 00040
ACPI: SRAT 00000000cff71e03 000C8 (v01 AMD    HAMMER   06040000 AMD  00000001)
ACPI: APIC 00000000cff71ecb 0008E (v01 PTLTD  	 APIC   06040000  LTP 00000000)
ACPI: ASF! 00000000cff71f59 000A7 (v16    MBI     CETP 06040000 PTL  00000001)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 00cff60000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 000077c98c]    TEXT DATA BSS ==> [0000200000 - 000077c98c]
  #3 [00377f8000 - 0037fef8ca]          RAMDISK ==> [00377f8000 - 0037fef8ca]
  #4 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
  #5 [000077d000 - 000077d140]              BRK ==> [000077d000 - 000077d140]
  #6 [0000008000 - 000000c000]          PGTABLE ==> [0000008000 - 000000c000]
found SMP MP-table at [ffff8800000f7140] f7140
 [ffffe20000000000-ffffe20002dfffff] PMD -> [ffff880001200000-ffff880003ffffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009d
    0: 0x00000100 -> 0x000cff60
On node 0 totalpages: 851709
  DMA zone: 56 pages used for memmap
  DMA zone: 1509 pages reserved
  DMA zone: 2432 pages, LIFO batch:0
  DMA32 zone: 11590 pages used for memmap
  DMA32 zone: 836122 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x8008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xf0500000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 0, address 0xf0500000, GSI 24-27
ACPI: IOAPIC (id[0x04] address[0xf0510000] gsi_base[28])
IOAPIC[2]: apic_id 4, version 0, address 0xf0510000, GSI 28-31
ACPI: IOAPIC (id[0x05] address[0xf0520000] gsi_base[32])
IOAPIC[3]: apic_id 5, version 0, address 0xf0520000, GSI 32-35
ACPI: IOAPIC (id[0x06] address[0xf0530000] gsi_base[36])
IOAPIC[4]: apic_id 6, version 0, address 0xf0530000, GSI 36-39
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at d4000000 (gap: d0000000:2ec00000)
NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 24 pages at ffff88000101c000, static data 68320 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 838554
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30-1-amd64-vyatta quiet root=UUID=56949d77-24b4-41ec-83d4-0a6c2da784bd ro console=ttyS0,9600 console=tty0
Initializing CPU#0
NR_IRQS:1280
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 1994.295 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Checking aperture...
AGP bridge at 08:00:00
Aperture from AGP @ d0000000 old size 32 MB
Aperture from AGP @ d0000000 size 256 MB (APSIZE f00)
Node 0: aperture @ d0000000 size 256 MB
Node 1: aperture @ d0000000 size 256 MB
Memory: 3338700k/3407232k available (2544k kernel code, 396k absent, 67432k reserved, 1723k data, 384k init)
Calibrating delay loop (skipped), value calculated using timer frequency.. 3988.59 BogoMIPS (lpj=7977180)
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
tseg: 00cff80000
ACPI: Core revision 20090320
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: AMD Opteron(tm) Processor 246 stepping 08
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3988.88 BogoMIPS (lpj=7977769)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Opteron(tm) Processor 246 stepping 08
Brought up 2 CPUs
Total of 2 processors activated (7977.47 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
net_namespace: 1888 bytes
NET: Registered protocol family 16
node 0 link 2: io port [0, 2fff]
node 0 link 0: io port [3000, 4fff]
TOM: 00000000d0000000 aka 3328M
node 0 link 2: mmio [f0000000, f051ffff]
node 0 link 0: mmio [f0520000, f09fffff]
node 0 link 0: mmio [d0000000, efffffff]
node 0 link 2: mmio [fec00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
bus: [00,07] on node 0 link 2
bus: 00 index 0 io port: [0, 2fff]
bus: 00 index 1 io port: [5000, ffff]
bus: 00 index 2 mmio: [f0000000, f051ffff]
bus: 00 index 3 mmio: [f0a00000, fcffffffff]
bus: [08,ff] on node 0 link 0
bus: 08 index 0 io port: [3000, 4fff]
bus: 08 index 1 mmio: [f0520000, f09fffff]
bus: 08 index 2 mmio: [d0000000, efffffff]
bus: 08 index 3 mmio: [a0000, bffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.1: reg 20 io port: [0x1460-0x146f]
pci 0000:00:07.2: reg 10 io port: [0x1440-0x145f]
pci 0000:00:07.5: reg 10 io port: [0x1000-0x10ff]
pci 0000:00:07.5: reg 14 io port: [0x1400-0x143f]
pci 0000:00:0a.1: reg 10 64bit mmio: [0xf0500000-0xf0500fff]
pci 0000:00:0b.1: reg 10 64bit mmio: [0xf0510000-0xf0510fff]
pci 0000:01:02.0: reg 10 io port: [0x00-0x07]
pci 0000:01:02.0: reg 14 io port: [0x00-0x03]
pci 0000:01:02.0: reg 18 io port: [0x00-0x07]
pci 0000:01:02.0: reg 1c io port: [0x00-0x03]
pci 0000:01:02.0: reg 20 io port: [0x00-0x0f]
pci 0000:01:02.0: reg 24 32bit mmio: [0x000000-0x0001ff]
pci 0000:01:02.0: reg 30 32bit mmio: [0x000000-0x07ffff]
pci 0000:01:02.0: supports D1 D2
pci 0000:01:03.0: reg 10 32bit mmio: [0xf0020000-0xf0020fff]
pci 0000:01:03.0: supports D1 D2
pci 0000:01:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:01:03.0: PME# disabled
pci 0000:01:03.1: reg 10 32bit mmio: [0xf0030000-0xf0030fff]
pci 0000:01:03.1: supports D1 D2
pci 0000:01:03.1: PME# supported from D0 D1 D2 D3hot
pci 0000:01:03.1: PME# disabled
pci 0000:01:03.2: reg 10 32bit mmio: [0xf0040000-0xf00400ff]
pci 0000:01:03.2: supports D1 D2
pci 0000:01:03.2: PME# supported from D0 D1 D2 D3hot
pci 0000:01:03.2: PME# disabled
pci 0000:00:06.0: bridge 32bit mmio: [0xf0000000-0xf00fffff]
pci 0000:02:01.0: reg 10 64bit mmio: [0xf0100000-0xf0103fff]
pci 0000:02:01.0: reg 18 io port: [0x2000-0x20ff]
pci 0000:02:01.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:02:01.0: supports D1
pci 0000:02:01.0: PME# supported from D0 D1 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:00:0a.0: bridge io port: [0x2000-0x2fff]
pci 0000:00:0a.0: bridge 32bit mmio: [0xf0100000-0xf01fffff]
pci 0000:03:02.0: reg 10 64bit mmio: [0xf0200000-0xf020ffff]
pci 0000:03:02.0: PME# supported from D3hot D3cold
pci 0000:03:02.0: PME# disabled
pci 0000:00:0b.0: bridge 32bit mmio: [0xf0200000-0xf02fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.TP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.G0PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.G0PB._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:08)
pci 0000:08:00.0: reg 10 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:08:03.1: reg 10 64bit mmio: [0xf0520000-0xf0520fff]
pci 0000:08:04.1: reg 10 64bit mmio: [0xf0530000-0xf0530fff]
pci 0000:09:00.0: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
pci 0000:09:00.0: reg 14 io port: [0x3000-0x30ff]
pci 0000:09:00.0: reg 18 32bit mmio: [0xf0800000-0xf080ffff]
pci 0000:09:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:09:00.0: supports D1 D2
pci 0000:09:00.1: reg 10 32bit mmio: [0xe8000000-0xefffffff]
pci 0000:09:00.1: reg 14 32bit mmio: [0xf0810000-0xf081ffff]
pci 0000:09:00.1: supports D1 D2
pci 0000:08:01.0: bridge io port: [0x3000-0x3fff]
pci 0000:08:01.0: bridge 32bit mmio: [0xf0800000-0xf08fffff]
pci 0000:08:01.0: bridge 32bit mmio pref: [0xe0000000-0xefffffff]
pci 0000:13:04.0: reg 10 io port: [0x4400-0x44ff]
pci 0000:13:04.0: reg 14 64bit mmio: [0xf0900000-0xf0901fff]
pci 0000:13:04.0: reg 1c io port: [0x4000-0x40ff]
pci 0000:13:04.0: reg 30 32bit mmio: [0x000000-0x07ffff]
pci 0000:13:04.1: reg 10 io port: [0x4c00-0x4cff]
pci 0000:13:04.1: reg 14 64bit mmio: [0xf0910000-0xf0911fff]
pci 0000:13:04.1: reg 1c io port: [0x4800-0x48ff]
pci 0000:13:04.1: reg 30 32bit mmio: [0x000000-0x07ffff]
pci 0000:08:04.0: bridge io port: [0x4000-0x4fff]
pci 0000:08:04.0: bridge 32bit mmio: [0xf0900000-0xf09fffff]
pci_bus 0000:08: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.Z00J._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.G1PA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1.G1PB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 *5 10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 5 10 11) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 5 *10 11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 5 10 *11)
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
pci 0000:08:00.0: BAR 0: can't allocate resource
agpgart-amd64 0000:08:00.0: AMD 8151 AGP Bridge rev B2
agpgart-amd64 0000:08:00.0: AGP aperture is 256M @ 0xd0000000
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:05: ioport range 0x4d0-0x4d1 has been reserved
system 00:05: ioport range 0x1100-0x117f has been reserved
system 00:05: ioport range 0x1180-0x11ff has been reserved
system 00:05: ioport range 0x100-0x11f has been reserved
system 00:05: iomem range 0xfff80000-0xffffffff has been reserved
system 00:05: iomem range 0xff780000-0xff7fffff has been reserved
system 00:05: iomem range 0xfee00000-0xfeefffff could not be reserved
pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
pci 0000:00:06.0:   IO window: 0x5000-0x5fff
pci 0000:00:06.0:   MEM window: 0xf0000000-0xf00fffff
pci 0000:00:06.0:   PREFETCH window: 0x000000f0300000-0x000000f03fffff
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0a.0:   IO window: 0x2000-0x2fff
pci 0000:00:0a.0:   MEM window: 0xf0100000-0xf01fffff
pci 0000:00:0a.0:   PREFETCH window: 0x000000f0400000-0x000000f04fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: 0xf0200000-0xf02fffff
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:08:01.0: PCI bridge, secondary bus 0000:09
pci 0000:08:01.0:   IO window: 0x3000-0x3fff
pci 0000:08:01.0:   MEM window: 0xf0800000-0xf08fffff
pci 0000:08:01.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
pci 0000:08:03.0: PCI bridge, secondary bus 0000:0e
pci 0000:08:03.0:   IO window: disabled
pci 0000:08:03.0:   MEM window: disabled
pci 0000:08:03.0:   PREFETCH window: disabled
pci 0000:08:04.0: PCI bridge, secondary bus 0000:13
pci 0000:08:04.0:   IO window: 0x4000-0x4fff
pci 0000:08:04.0:   MEM window: 0xf0900000-0xf09fffff
pci 0000:08:04.0:   PREFETCH window: 0x000000f0600000-0x000000f06fffff
pci_bus 0000:00: resource 0 io:  [0x00-0x2fff]
pci_bus 0000:00: resource 1 io:  [0x5000-0xffff]
pci_bus 0000:00: resource 2 mem: [0xf0000000-0xf051ffff]
pci_bus 0000:00: resource 3 mem: [0xf0a00000-0xfcffffffff]
pci_bus 0000:01: resource 0 io:  [0x5000-0x5fff]
pci_bus 0000:01: resource 1 mem: [0xf0000000-0xf00fffff]
pci_bus 0000:01: resource 2 pref mem [0xf0300000-0xf03fffff]
pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
pci_bus 0000:02: resource 1 mem: [0xf0100000-0xf01fffff]
pci_bus 0000:02: resource 2 pref mem [0xf0400000-0xf04fffff]
pci_bus 0000:03: resource 1 mem: [0xf0200000-0xf02fffff]
pci_bus 0000:08: resource 0 io:  [0x3000-0x4fff]
pci_bus 0000:08: resource 1 mem: [0xf0520000-0xf09fffff]
pci_bus 0000:08: resource 2 mem: [0xd0000000-0xefffffff]
pci_bus 0000:08: resource 3 mem: [0x0a0000-0x0bffff]
pci_bus 0000:09: resource 0 io:  [0x3000-0x3fff]
pci_bus 0000:09: resource 1 mem: [0xf0800000-0xf08fffff]
pci_bus 0000:09: resource 2 pref mem [0xe0000000-0xefffffff]
pci_bus 0000:13: resource 0 io:  [0x4000-0x4fff]
pci_bus 0000:13: resource 1 mem: [0xf0900000-0xf09fffff]
pci_bus 0000:13: resource 2 pref mem [0xf0600000-0xf06fffff]
NET: Registered protocol family 2
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 8158k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1250534164.624:1): initialized
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
squashfs: version 4.0 (2009/01/31) Phillip Lougher
msgmni has been set to 6538
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
boot interrupts on PCI device 0x1022:0x746b already disabled
pci 0000:00:0a.0: MSI quirk detected; subordinate MSI disabled
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:00:0a.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:00:0b.0: MSI quirk detected; subordinate MSI disabled
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:00:0b.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
agpgart-amd64 0000:08:00.0: Chipset erratum: Disabling direct PCI/AGP transfers
pci 0000:08:03.0: MSI quirk detected; subordinate MSI disabled
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:08:03.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:08:04.0: MSI quirk detected; subordinate MSI disabled
disabled boot interrupts on PCI device 0x1022:0x7450
pci 0000:08:04.0: AMD8131 rev 12 detected; disabling PCI-X MMRBC
pci 0000:09:00.0: Boot video device
AMD768 RNG detected
Linux agpgart interface v0.103
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
EDAC MC: Ver: 2.1.0 Jul 31 2009
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
Freeing unused kernel memory: 384k freed
input: AT Translated Set 2 keyboard as /class/input/input0
pata_acpi 0000:01:02.0: enabling device (0004 -> 0007)
pata_acpi 0000:01:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pata_acpi 0000:01:02.0: PCI INT A disabled
sata_sil 0000:01:02.0: version 2.4
sata_sil 0000:01:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sata_sil 0000:01:02.0: Applying R_ERR on DMA activate FIS errata fix
FDC 0 is a National Semiconductor PC87306
scsi0 : sata_sil
scsi1 : sata_sil
ata1: SATA max UDMA/100 mmio m512@0xf0000000 tf 0xf0000080 irq 17
ata2: SATA max UDMA/100 mmio m512@0xf0000000 tf 0xf00000c0 irq 17
pata_amd 0000:00:07.1: version 0.4.1
scsi2 : pata_amd
scsi3 : pata_amd
ata3: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1460 irq 14
ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x1468 irq 15
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
sky2 driver version 1.22
sky2 0000:02:01.0: PCI INT A -> GSI 26 (level, low) -> IRQ 26
sky2 0000:02:01.0: Yukon-2 XL chip revision 1
sky2 eth0: addr 00:00:5a:72:6b:87
sky2 eth1: addr 00:00:5a:72:6b:88
tg3.c:v3.98 (February 25, 2009)
tg3 0000:03:02.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28
tg3 0000:03:02.0: PME# disabled
eth2: Tigon3 [partno(BCM95703A30) rev 1002] (PCIX:100MHz:64-bit) MAC address 00:0d:60:53:08:18
eth2: attached PHY is 5703 (10/100/1000Base-T Ethernet) (WireSpeed[1])
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[1] TSOcap[0]
eth2: dma_rwctrl[769c4000] dma_mask[64-bit]
ata1: SATA link down (SStatus 0 SControl 310)
ata2: SATA link down (SStatus 0 SControl 310)
ata4.01: ATAPI: ATAPI   CD  N  DH52N2P, CP51, max UDMA/33
ata4.01: configured for UDMA/33
scsi 3:0:1:0: CD-ROM            ATAPI    CD  N  DH52N2P   CP51 PQ: 0 ANSI: 5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:01:03.2: PCI INT C -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:01:03.2: EHCI Host Controller
ehci_hcd 0000:01:03.2: new USB bus registered, assigned bus number 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
aic79xx 0000:13:04.0: PCI INT A -> GSI 39 (level, low) -> IRQ 39
ehci_hcd 0000:01:03.2: irq 16, io mem 0xf0040000
Driver 'sr' needs updating - please use bus_type methods
ehci_hcd 0000:01:03.2: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
ohci_hcd 0000:01:03.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:01:03.0: OHCI Host Controller
ohci_hcd 0000:01:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:01:03.0: irq 18, io mem 0xf0020000
sr0: scsi3-mmc drive: 0x/52x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:1:0: Attached scsi CD-ROM sr0
sr 3:0:1:0: Attached scsi generic sg0 type 5
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd 0000:01:03.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ohci_hcd 0000:01:03.1: OHCI Host Controller
ohci_hcd 0000:01:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:01:03.1: irq 19, io mem 0xf0030000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
scsi4 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
scsi 4:0:0:0: Direct-Access     MAXTOR   ATLAS15K2_36SCA  JNZM PQ: 0 ANSI: 3
 target4:0:0: asynchronous
scsi4:A:0:0: Tagged Queuing enabled.  Depth 32
 target4:0:0: Beginning Domain Validation
 target4:0:0: wide asynchronous
 target4:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI (6.25 ns, offset 127)
 target4:0:0: Ending Domain Validation
sd 4:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: [sda] 71132959 512-byte hardware sectors: (36.4 GB/33.9 GiB)
scsi 4:0:1:0: Direct-Access     MAXTOR   ATLAS15K2_36SCA  JNZM PQ: 0 ANSI: 3
 target4:0:1: asynchronous
scsi4:A:1:0: Tagged Queuing enabled.  Depth 32
 target4:0:1: Beginning Domain Validation
sd 4:0:0:0: [sda] Write Protect is off
sd 4:0:0:0: [sda] Mode Sense: bf 00 10 08
sd 4:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
 target4:0:1: wide asynchronous
 target4:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI (6.25 ns, offset 127)
scsi4: Invalid Sequencer interrupt occurred, resetting channel.
 sda: sda1
sd 4:0:0:0: [sda] Attached SCSI disk
 target4:0:1: Ending Domain Validation
sd 4:0:1:0: Attached scsi generic sg2 type 0
scsi4: Invalid Sequencer interrupt occurred, resetting channel.
sd 4:0:1:0: [sdb] 71132959 512-byte hardware sectors: (36.4 GB/33.9 GiB)
scsi4: Invalid Sequencer interrupt occurred, resetting channel.
sd 4:0:1:0: [sdb] Write Protect is off
sd 4:0:1:0: [sdb] Mode Sense: bf 00 10 08
scsi4: Invalid Sequencer interrupt occurred, resetting channel.
aic79xx 0000:13:04.1: PCI INT B -> GSI 38 (level, low) -> IRQ 38
sd 4:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 4:0:1:0: [sdb] Attached SCSI disk
scsi5 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec AIC7902 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100MHz, 512 SCBs
 target5:0:0: asynchronous
 target5:0:1: asynchronous
 target5:0:2: asynchronous
 target5:0:3: asynchronous
 target5:0:4: asynchronous
 target5:0:5: asynchronous
 target5:0:6: asynchronous
 target5:0:8: asynchronous
 target5:0:9: asynchronous
 target5:0:10: asynchronous
 target5:0:11: asynchronous
 target5:0:12: asynchronous
 target5:0:13: asynchronous
 target5:0:14: asynchronous
 target5:0:15: asynchronous
md: linear personality registered for level -1
md: multipath personality registered for level -4
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
xor: automatically using best checksumming function: generic_sse
   generic_sse:  5957.000 MB/sec
xor: using function: generic_sse (5957.000 MB/sec)
async_tx: api initialized (async)
raid6: int64x1   1619 MB/s
raid6: int64x2   2361 MB/s
raid6: int64x4   1911 MB/s
raid6: int64x8   1545 MB/s
raid6: sse2x1     867 MB/s
raid6: sse2x2    1975 MB/s
raid6: sse2x4    2807 MB/s
raid6: using algorithm sse2x4 (2807 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: raid10 personality registered for level 10
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with writeback data mode.
udevd version 125 started
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp 0000:00:06.0: HPC vendor_id 1022 device_id 7460 ss_vid 0 ss_did 0
shpchp 0000:00:06.0: Cannot reserve MMIO region
shpchp 0000:00:0a.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp 0000:00:0a.0: Cannot reserve MMIO region
shpchp 0000:00:0b.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp 0000:00:0b.0: Cannot reserve MMIO region
input: Power Button as /class/input/input1
ACPI: Power Button [PWRF]
input: Sleep Button as /class/input/input2
ACPI: Sleep Button [SLPF]
input: Power Button as /class/input/input3
ACPI: Power Button [PWRB]
shpchp 0000:08:01.0: HPC vendor_id 1022 device_id 7455 ss_vid 0 ss_did 0
shpchp 0000:08:01.0: Cannot reserve MMIO region
shpchp 0000:08:03.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp 0000:08:03.0: Cannot reserve MMIO region
shpchp 0000:08:04.0: HPC vendor_id 1022 device_id 7450 ss_vid 0 ss_did 0
shpchp 0000:08:04.0: Cannot reserve MMIO region
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: processor limited to max C-state 1
processor ACPI_CPU:00: registered as cooling_device0
processor ACPI_CPU:01: registered as cooling_device1
rtc_cmos 00:02: RTC can wake from S4
rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 242 bytes nvram
input: PC Speaker as /class/input/input4
input: ImPS/2 Generic Wheel Mouse as /class/input/input5
EXT3 FS on sda1, internal journal
IPv4 FIB: Using LC-trie version 0.408
warning: `vyatta-zebra' uses 32-bit capabilities (legacy support in use)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
ip6_tables: (C) 2000-2006 Netfilter Core Team
Registering unionfs 2.5.2 (for 2.6.30)
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
sky2 eth1: enabling interface
ADDRCONF(NETDEV_UP): eth1: link is not ready
tg3 0000:03:02.0: PME# disabled
ADDRCONF(NETDEV_UP): eth2: link is not ready
NET: Registered protocol family 17
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
tg3: eth2: Link is up at 1000 Mbps, full duplex.
tg3: eth2: Flow control is on for TX and on for RX.
ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
md: linear personality unregistered
md: multipath personality unregistered
md: raid0 personality unregistered
md: raid1 personality unregistered
md: raid6 personality unregistered
md: raid5 personality unregistered
md: raid4 personality unregistered
md: raid10 personality unregistered

