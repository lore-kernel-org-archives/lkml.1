Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYLSHJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYLSHJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 02:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYLSHJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 02:09:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:41363 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLSHJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 02:09:32 -0500
Message-ID: <494B48A5.70207@gawab.com>
Date: Thu, 18 Dec 2008 23:09:25 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
References: <494318F5.4060007@gawab.com>	<20081216210251.138d3e98.akpm@linux-foundation.org> <20081217101307.4614145d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081217101307.4614145d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Tue, 16 Dec 2008 21:02:51 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> (cc linux-ide).
>>
>> This is a post-2.6.27 regression.  Panic!
>>
>> On Fri, 12 Dec 2008 18:07:49 -0800 Justin Madru <bevicm@dslextreme.com> wrote:
>>
>>     
>>> I've been testing .28 (currently -rc8) and I've noticed in the logs a 
>>> massive amount of the following.
>>> I can confirm that the messages doesn't appear when booting into a .27 
>>> kernel.
>>>
>>> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>> ata2.00: ST_FIRST: !(DRQ|ERR|DF)
>>>       
>
> Which is the first 2.6.28-rc that this appears ?
>
>   
I did some basic testing to find out what -rc it first appears in, and 
it _could_ be before -rc3.
I first noticed it after -rc6 because of another issue that made me look 
into the logs.
So, currently I don't know exactly when it started (haven't bisected).

The problem is that the sata-reset messages don't appear immediately 
after boot.
They happen about say 10 after boot, then appear sporadically, but 
sometimes very frequently.
I've tried to trigger the error, but have been unable to determine any 
relation.
Henceforth, a bisect would be hard.

To reply to Jeff:
Yes, the ata_piix module is loaded.
I do have a DVD/CD drive that should be on the same controller as the 
hard drive (TSSTcorpCD-RW/DVD-ROM TSL462D)
(is there a command to run to show drives connected to a controller?)

below is the dmesg, and more info about my computer (ie. config / hardware)
can be found at: http://jdserver.homelinux.org/bugreports/

BIOS EBDA/lowmem at: 0009f000/0009f000
Linux version 2.6.28-rc8-git (root@dell-laptop) (gcc version 4.3.2 
(Ubuntu 4.3.2-1ubuntu11) ) #1 SMP PREEMPT Wed Dec 10 21:59:30 PST 2008
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
PAT WC disabled due to known CPU erratum.
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f6d3400 (usable)
 BIOS-e820: 000000003f6d3400 - 0000000040000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4007000 (reserved)
 BIOS-e820: 00000000f4008000 - 00000000f400c000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x3f6d3 max_arch_pfn = 0x100000
kernel direct mapping tables up to 377fe000 @ 7000-d000
RAMDISK: 37bbc000 - 37fefac2
Allocated new RAMDISK: 0055e000 - 00991ac2
Move RAMDISK from 0000000037bbc000 - 0000000037fefac1 to 0055e000 - 00991ac1
ACPI: RSDP 000FC1D0, 0014 (r0 DELL  )
ACPI: RSDT 3F6D39CD, 0040 (r1 DELL    M07     27D7060D ASL        61)
ACPI: FACP 3F6D4800, 0074 (r1 DELL    M07     27D7060D ASL        61)
ACPI: DSDT 3F6D5400, 4766 (r1 INT430 SYSFexxx     1001 INTL 20050624)
ACPI: FACS 3F6E3C00, 0040
ACPI: HPET 3F6D4F00, 0038 (r1 DELL    M07            1 ASL        61)
ACPI: APIC 3F6D5000, 0068 (r1 DELL    M07     27D7060D ASL        47)
ACPI: MCFG 3F6D4FC0, 003E (r16 DELL    M07     27D7060D ASL        61)
ACPI: SLIC 3F6D509C, 0024 (r1 DELL    M07     27D7060D ASL        61)
ACPI: BOOT 3F6D4BC0, 0028 (r1 DELL    M07     27D7060D ASL        61)
ACPI: SSDT 3F6D3A0D, 04DC (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: Local APIC address 0xfee00000
126MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00009000 - 0000ff00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 
0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 
0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 
0000007000]
  #3 [0000100000 - 000055ae30]    TEXT DATA BSS ==> [0000100000 - 
000055ae30]
  #4 [000055b000 - 000055e000]    INIT_PG_TABLE ==> [000055b000 - 
000055e000]
  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 
0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 
0000009000]
  #7 [000055e000 - 0000991ac2]      NEW RAMDISK ==> [000055e000 - 
0000991ac2]
  #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 
0000010000]
Reserving 64MB of memory at 16MB for crashkernel (System RAM: 1014MB)
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003f6d3
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0003f6d3
On node 0 totalpages: 259698
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32215 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
PERCPU: Allocating 36864 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 257668
Kernel command line: root=UUID=5e751884-8e64-408f-ba3c-621be1d61cc6 ro 
splash rootflags=data=writeback  crashkernel=384M-2G:64M@16M,2G-:128M@16M
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
CPU 0 irqstacks, hard=c04f6000 soft=c04f2000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 1729.308 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 954952k/1039180k available (2649k kernel code, 83552k reserved, 
1063k data, 296k init, 129876k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff85000 - 0xfffff000   ( 488 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc04a5000 - 0xc04ef000   ( 296 kB)
      .data : 0xc0396637 - 0xc04a028c   (1063 kB)
      .text : 0xc0100000 - 0xc0396637   (2649 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer 
frequency.. 3460.72 BogoMIPS (lpj=5764360)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080926
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Genuine Intel(R) CPU           T2080  @ 1.73GHz stepping 0c
CPU 1 irqstacks, hard=c04f7000 soft=c04f3000
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3459.13 BogoMIPS 
(lpj=5763409)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Genuine Intel(R) CPU           T2080  @ 1.73GHz stepping 0c
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 3498706146 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to check_tsc_sync_source failed
Brought up 2 CPUs
Total of 2 processors activated (6919.85 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
net_namespace: 540 bytes
regulator: core version 0.5
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: MCFG area at f0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: reg 10 32bit mmio: [0xeff00000-0xeff7ffff]
pci 0000:00:02.0: reg 14 io port: [0xeff8-0xefff]
pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
pci 0000:00:02.0: reg 1c 32bit mmio: [0xefec0000-0xefefffff]
pci 0000:00:02.1: reg 10 32bit mmio: [0xeff80000-0xefffffff]
pci 0000:00:1b.0: reg 10 64bit mmio: [0xefebc000-0xefebffff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
pci 0000:00:1d.0: reg 20 io port: [0xbf80-0xbf9f]
pci 0000:00:1d.1: reg 20 io port: [0xbf60-0xbf7f]
pci 0000:00:1d.2: reg 20 io port: [0xbf40-0xbf5f]
pci 0000:00:1d.3: reg 20 io port: [0xbf20-0xbf3f]
pci 0000:00:1d.7: reg 10 32bit mmio: [0xffa80000-0xffa803ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1080-10bf claimed by ICH6 GPIO
pci 0000:00:1f.2: reg 10 io port: [0x1f0-0x1f7]
pci 0000:00:1f.2: reg 14 io port: [0x3f4-0x3f7]
pci 0000:00:1f.2: reg 18 io port: [0x170-0x177]
pci 0000:00:1f.2: reg 1c io port: [0x374-0x377]
pci 0000:00:1f.2: reg 20 io port: [0xbfa0-0xbfaf]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: reg 20 io port: [0x10c0-0x10df]
pci 0000:0b:00.0: reg 10 32bit mmio: [0xefdff000-0xefdfffff]
pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
pci 0000:0b:00.0: PME# disabled
pci 0000:0b:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable 
it with 'pcie_aspm=force'
pci 0000:00:1c.0: bridge 32bit mmio: [0xefd00000-0xefdfffff]
pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
pci 0000:00:1c.3: bridge 32bit mmio: [0xefa00000-0xefcfffff]
pci 0000:00:1c.3: bridge 64bit mmio pref: [0xe0000000-0xe01fffff]
pci 0000:03:00.0: reg 10 32bit mmio: [0xef9fe000-0xef9fffff]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:03:01.0: reg 10 32bit mmio: [0xef9fd800-0xef9fdfff]
pci 0000:03:01.0: supports D1 D2
pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.0: PME# disabled
pci 0000:03:01.1: reg 10 32bit mmio: [0xef9fd500-0xef9fd5ff]
pci 0000:03:01.1: supports D1 D2
pci 0000:03:01.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.1: PME# disabled
pci 0000:03:01.2: reg 10 32bit mmio: [0xef9fd600-0xef9fd6ff]
pci 0000:03:01.2: supports D1 D2
pci 0000:03:01.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.2: PME# disabled
pci 0000:03:01.3: reg 10 32bit mmio: [0xef9fd700-0xef9fd7ff]
pci 0000:03:01.3: supports D1 D2
pci 0000:03:01.3: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:01.3: PME# disabled
pci 0000:00:1e.0: transparent bridge
pci 0000:00:1e.0: bridge 32bit mmio: [0xef900000-0xef9fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *4
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 11) *3
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
cfg80211: Calling CRDA to update world regulatory domain
cfg80211: Failed calling CRDA
cfg80211: calling CRDA failed - unable to update world regulatory 
domain, using static definition
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:02: io resource (0x1000-0x1005) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling
pnp 00:02: io resource (0x1008-0x100f) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling
pnp 00:03: io resource (0x1006-0x1007) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling
pnp 00:03: io resource (0x100a-0x1059) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling
pnp 00:03: io resource (0x1060-0x107f) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling
pnp 00:03: io resource (0x1010-0x102f) overlaps 0000:00:1f.0 BAR 7 
(0x1000-0x107f), disabling
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
system 00:00: iomem range 0x0-0x9fbff could not be reserved
system 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xcffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x3f6d33ff could not be reserved
system 00:00: iomem range 0x3f6d3400-0x3f6fffff has been reserved
system 00:00: iomem range 0x3f700000-0x3f7fffff has been reserved
system 00:00: iomem range 0x3f700000-0x3fefffff could not be reserved
system 00:00: iomem range 0xffb00000-0xffffffff has been reserved
system 00:00: iomem range 0xfec00000-0xfec0ffff has been reserved
system 00:00: iomem range 0xfee00000-0xfee0ffff has been reserved
system 00:00: iomem range 0xfed20000-0xfed9ffff has been reserved
system 00:00: iomem range 0xffa80000-0xffa83fff could not be reserved
system 00:00: iomem range 0xf4000000-0xf4003fff has been reserved
system 00:00: iomem range 0xf4004000-0xf4004fff has been reserved
system 00:00: iomem range 0xf4005000-0xf4005fff has been reserved
system 00:00: iomem range 0xf4006000-0xf4006fff has been reserved
system 00:00: iomem range 0xf4008000-0xf400bfff has been reserved
system 00:00: iomem range 0xf0000000-0xf3ffffff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:03: ioport range 0xf400-0xf4fe has been reserved
system 00:03: ioport range 0x1080-0x10bf has been reserved
system 00:03: ioport range 0x10c0-0x10df has been reserved
system 00:03: ioport range 0x809-0x809 has been reserved
system 00:08: ioport range 0xc80-0xcff could not be reserved
system 00:08: ioport range 0x910-0x91f has been reserved
system 00:08: ioport range 0x920-0x92f has been reserved
system 00:08: ioport range 0xcb0-0xcbf has been reserved
system 00:08: ioport range 0x930-0x97f has been reserved
system 00:0b: iomem range 0xfed00000-0xfed003ff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: 0xefd00000-0xefdfffff
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:0c
pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
pci 0000:00:1c.3:   MEM window: 0xefa00000-0xefcfffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000e0000000-0x000000e01fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xef900000-0xef9fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 0b index 0 mmio: [0x0-0x0]
bus: 0b index 1 mmio: [0xefd00000-0xefdfffff]
bus: 0b index 2 mmio: [0x0-0x0]
bus: 0b index 3 mmio: [0x0-0x0]
bus: 0c index 0 io port: [0xd000-0xdfff]
bus: 0c index 1 mmio: [0xefa00000-0xefcfffff]
bus: 0c index 2 mmio: [0xe0000000-0xe01fffff]
bus: 0c index 3 mmio: [0x0-0x0]
bus: 03 index 0 mmio: [0x0-0x0]
bus: 03 index 1 mmio: [0xef900000-0xef9fffff]
bus: 03 index 2 mmio: [0x0-0x0]
bus: 03 index 3 io port: [0x00-0xffff]
bus: 03 index 4 mmio: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 4302k freed
Simple Boot Flag at 0x79 set to 0x1
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
msgmni has been set to 1620
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pcieport-driver 0000:00:1c.0: irq 383 for MSI/MSI-X
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pcieport-driver 0000:00:1c.3: irq 382 for MSI/MSI-X
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
b44 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ssb: Sonics Silicon Backplane found on PCI device 0000:03:00.0
b44.c:v2.0
eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:19:b9:72:d4:1f
console [netcon0] enabled
netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 296k freed
Write protecting the kernel text: 2652k
Write protecting the kernel read-only data: 868k
input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input0
ACPI: SSDT 3F6D4134, 0244 (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3F6D3EE9, 01C6 (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3F6D4378, 00C4 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3F6D40AF, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THM] (53 C)
Clocksource tsc unstable (delta = 2023093691 ns)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
firewire_ohci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
usbcore: registered new device driver usb
scsi0 : ata_piix
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xbfa0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xbfa8 irq 15
firewire_ohci: Added fw-ohci device 0000:03:01.0, OHCI version 1.10
ata1.00: ATA-7: ST980811AS, 3.CDD, max UDMA/133
ata1.00: 156301488 sectors, multi 8: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2.00: ATAPI: TSSTcorpCD-RW/DVD-ROM TSL462D, DE04, max UDMA/33
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      ST980811AS       3.CD PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: CD-ROM            TSSTcorp CDRW/DVD TSL462D DE04 PQ: 0 ANSI: 5
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xffa80000
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000bf80
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x0000bf60
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
Driver 'sr' needs updating - please use bus_type methods
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 22, io base 0x0000bf40
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000bf20
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
firewire_core: created device fw0: GUID 344fc00010d7ad81, S400
PM: Starting manual resume from disk
ReiserFS: sda6: found reiserfs format "3.6" with standard journal
ReiserFS: sda6: using writeback data mode
ReiserFS: sda6: journal params: device sda6, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: sda6: checking transaction log (sda6)
ReiserFS: sda6: Using r5 hash to sort names
udevd version 124 started
agpgart-intel 0000:00:00.0: Intel 945GM Chipset
agpgart-intel 0000:00:00.0: detected 7932K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
ACPI: AC Adapter [AC] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID]
input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PBTN]
input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: setting latency timer to 64
ACPI: Sleep Button (CM) [SBTN]
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for 
Linux, 1.2.26ks
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iwl3945 0000:0b:00.0: setting latency timer to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
iwl3945 0000:0b:00.0: PCI INT A disabled
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x180b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as 
/devices/platform/i8042/serio1/input/input4
Adding 1293192k swap on /dev/sda5.  Priority:-1 extents:1 across:1293192k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:02.0: setting latency timer to 64
[drm] Initialized i915 1.6.0 20080730 on minor 0
iwl3945 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
iwl3945 0000:0b:00.0: restoring config space at offset 0x1 (was 
0x100102, writing 0x100106)
iwl3945 0000:0b:00.0: irq 381 for MSI/MSI-X
iwl3945 0000:0b:00.0: firmware: requesting iwlwifi-3945-1.ucode
wlan0: direct probe to AP 00:1c:df:67:1f:ac try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1c:df:67:1f:ac
wlan0: authenticated
wlan0: associate with AP 00:1c:df:67:1f:ac
wlan0: RX AssocResp from 00:1c:df:67:1f:ac (capab=0x401 status=0 aid=2)
wlan0: associated
wlan0: disassociating by local choice (reason=3)
CE: hpet increasing min_delta_ns to 15000 nsec
CE: hpet increasing min_delta_ns to 22500 nsec
CE: hpet increasing min_delta_ns to 33750 nsec
wlan0: direct probe to AP 00:1c:df:67:1f:ac try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1c:df:67:1f:ac
wlan0: authenticated
wlan0: associate with AP 00:1c:df:67:1f:ac
wlan0: RX ReassocResp from 00:1c:df:67:1f:ac (capab=0x401 status=0 aid=2)
wlan0: associated
NET: Registered protocol family 10
ADDRCONF(NETDEV_UP): eth0: link is not ready
wlan0: no IPv6 routers present
CE: hpet increasing min_delta_ns to 50624 nsec
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: ST_FIRST: !(DRQ|ERR|DF)
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: ST_FIRST: !(DRQ|ERR|DF)
ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
         cdb 4a 01 00 00 10 00 00 00  08 00 00 00 00 00 00 00
         res 50/00:01:00:08:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: ST_FIRST: !(DRQ|ERR|DF)
ata2.00: cmd a0/00:00:00:08:00/00:00:00:00:00/a0 tag 0 pio 16392 in
         cdb 4a 01 00 00 10 00 00 00  08 00 00 00 00 00 00 00
         res 50/00:01:00:08:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete
