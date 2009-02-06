Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbZBFWUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbZBFWUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZBFWUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:20:19 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:50338 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZBFWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:20:12 -0500
Message-ID: <498CB798.7050308@cfl.rr.com>
Date: Fri, 06 Feb 2009 17:20:08 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: markh@compro.net
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
 processor
References: <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com> <497A48D5.9040904@cfl.rr.com> <497E0072.7000500@compro.net> <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <20090203151137.GB12017@aftab> <498897C1.2090802@compro.net> <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net> <498C7980.2060309@compro.net>
In-Reply-To: <498C7980.2060309@compro.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------080009020600040800080309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080009020600040800080309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mark Hounschell wrote:
>> Borislav Petkov wrote:
>>> Ok, here are two things you could try:
>>>
>>> Disable CONFIG_HIGH_RES_TIMERS (high resolution timers support in
>>> "Processor type and features"), boot with "apic=debug" and send me the
>>> output. I'd like to see how the lapic timer gets programmed. It would
>>> be better for that exercise to get the latest stable kernel, 2.6.28.3,
>>> imho.
>>>
>>> The other thing you could do is get x86info tools from here:
>>> http://www.codemonkey.org.uk/projects/x86info/. However, get either a
>>> daily snapshot or a checkout from the git repository and build it on
>>> your system. Then do
>>>
>>> x86info -a > x86info.txt
>>>
>>> lsmsr -V3 -a > lsmsr.txt
>>>
>>> and send me those text files - we might be able to get a clue what's going on
>>> from them.
> 
> Ok, attached is the bootlog.txt, x86info.txt, and lsmsr.txt
> 
> Thanks
> Mark
> 

That bootlog was captured from the serial console, but comparing it to the dmesg
I see more info in the dmesg. The extra stuff for "apic=debug" must not be going
to the serial console?? Either way here is the demsg output too.

Regards
Mark


--------------080009020600040800080309
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Fri Feb 6 11:48:54 EST 2009
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
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffe0000 (usable)
 BIOS-e820: 00000000bffe0000 - 00000000bffe3000 (ACPI NVS)
 BIOS-e820: 00000000bffe3000 - 00000000bfff0000 (ACPI data)
 BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
DMI 2.5 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0xbffe0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 377fe000 @ 10000-16000
RAMDISK: 375a8000 - 37fef479
Allocated new RAMDISK: 004a7000 - 00eee479
Move RAMDISK from 00000000375a8000 - 0000000037fef478 to 004a7000 - 00eee478
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 0044 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: HPET BFFE8E40, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE8E80, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: Local APIC address 0xfee00000
2183MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 00000000 - 377fe000
  bootmap 00012000 - 00018f00
(9 early reservations) ==> bootmem [0000000000 - 00377fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 00004a3c54]    TEXT DATA BSS ==> [0000100000 - 00004a3c54]
  #4 [00004a4000 - 00004a7000]    INIT_PG_TABLE ==> [00004a4000 - 00004a7000]
  #5 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
  #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
  #7 [00004a7000 - 0000eee479]      NEW RAMDISK ==> [00004a7000 - 0000eee479]
  #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f3f00] 000f3f00
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x000bffe0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bffe0
On node 0 totalpages: 786287
free_area_init_node: node 0, pgdat c03a4900, node_mem_map c1000200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 4368 pages used for memmap
  HighMem zone: 554706 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 36864 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780143
Kernel command line: root=/dev/sda5 hwprobe=-modules.pata apm=off selinux=0 noresume splash=silent apic=debug console=ttyS0,19200n8 vga=normal
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3360.372 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3104320k/3145600k available (1835k kernel code, 39920k reserved, 1095k data, 276k init, 2236296k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02caf27 - 0xc03dcc4c   (1095 kB)
      .text : 0xc0100000 - 0xc02caf27   (1835 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 6720.74 BogoMIPS (lpj=13441488)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080926
Getting VERSION: 80050010
Getting VERSION: 80050010
Getting ID: 0
Getting ID: f000000
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 4-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-9 -> 0x39 -> IRQ 9 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (4-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 4-16 4-17 4-18 4-19 4-20 4-21 4-22 4-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1312574
... PM timer delta = 357950
... PM timer result ok
..... delta 1312574
..... mult: 56371100
..... calibration result: 840047
..... CPU clock speed is 3360.0779 MHz.
..... host bus clock speed is 210.0047 MHz.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 6720.40 BogoMIPS (lpj=13440808)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
masked ExtINT on CPU#2
Calibrating delay using timer specific routine.. 6720.39 BogoMIPS (lpj=13440799)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
masked ExtINT on CPU#3
Calibrating delay using timer specific routine.. 6720.41 BogoMIPS (lpj=13440821)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (26881.95 BogoMIPS).
net_namespace: 776 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:12.0: reg 10 io port: [0xff00-0xff07]
pci 0000:00:12.0: reg 14 io port: [0xfe00-0xfe03]
pci 0000:00:12.0: reg 18 io port: [0xfd00-0xfd07]
pci 0000:00:12.0: reg 1c io port: [0xfc00-0xfc03]
pci 0000:00:12.0: reg 20 io port: [0xfb00-0xfb0f]
pci 0000:00:12.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xfe02c000-0xfe02cfff]
pci 0000:00:13.3: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
pci 0000:00:13.4: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
pci 0000:00:13.5: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
pci 0000:00:13.5: supports D1 D2
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.0: reg 10 io port: [0xb00-0xb0f]
pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
pci 0000:00:14.1: reg 20 io port: [0xf900-0xf90f]
pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:01:00.0: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
pci 0000:01:00.0: reg 14 64bit mmio: [0xc0000000-0xdfffffff]
pci 0000:01:00.0: reg 1c 64bit mmio: [0xf8000000-0xf9ffffff]
pci 0000:01:00.0: reg 24 io port: [0xdf00-0xdf7f]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:00:02.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:02.0: bridge 32bit mmio: [0xf8000000-0xfbffffff]
pci 0000:00:02.0: bridge 64bit mmio pref: [0xc0000000-0xdfffffff]
pci 0000:02:00.0: reg 10 32bit mmio: [0xfdbe0000-0xfdbfffff]
pci 0000:02:00.0: reg 14 32bit mmio: [0xfdbc0000-0xfdbdffff]
pci 0000:02:00.0: reg 18 io port: [0xcf00-0xcf1f]
pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:04.0: bridge io port: [0xc000-0xcfff]
pci 0000:00:04.0: bridge 32bit mmio: [0xfdb00000-0xfdbfffff]
pci 0000:00:04.0: bridge 64bit mmio pref: [0xfda00000-0xfdafffff]
pci 0000:03:00.0: reg 24 32bit mmio: [0xfdffe000-0xfdffffff]
pci 0000:03:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:03:00.1: reg 10 io port: [0xbf00-0xbf07]
pci 0000:03:00.1: reg 14 io port: [0xbe00-0xbe03]
pci 0000:03:00.1: reg 18 io port: [0xbd00-0xbd07]
pci 0000:03:00.1: reg 1c io port: [0xbc00-0xbc03]
pci 0000:03:00.1: reg 20 io port: [0xbb00-0xbb0f]
pci 0000:00:06.0: bridge io port: [0xb000-0xbfff]
pci 0000:00:06.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]
pci 0000:00:06.0: bridge 64bit mmio pref: [0xfde00000-0xfdefffff]
pci 0000:04:00.0: reg 10 64bit mmio: [0xfddfc000-0xfddfffff]
pci 0000:04:00.0: reg 18 io port: [0xee00-0xeeff]
pci 0000:04:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:07.0: bridge io port: [0xe000-0xefff]
pci 0000:00:07.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
pci 0000:00:07.0: bridge 64bit mmio pref: [0xfdc00000-0xfdcfffff]
pci 0000:05:05.0: reg 10 io port: [0xaf00-0xaf3f]
pci 0000:05:05.0: reg 14 32bit mmio: [0xfd9ff000-0xfd9fffff]
pci 0000:05:06.0: reg 10 io port: [0xac00-0xacff]
pci 0000:05:06.0: reg 14 32bit mmio: [0xfd9fe000-0xfd9fefff]
pci 0000:05:06.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:05:07.0: reg 10 io port: [0xae00-0xae3f]
pci 0000:05:07.0: reg 14 32bit mmio: [0xfd9fd000-0xfd9fdfff]
pci 0000:00:14.4: transparent bridge
pci 0000:00:14.4: bridge io port: [0xa000-0xafff]
pci 0000:00:14.4: bridge 32bit mmio: [0xfd900000-0xfd9fffff]
pci 0000:00:14.4: bridge 32bit mmio pref: [0xfd800000-0xfd8fffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: BAR 3: can't allocate resource

printing PIC contents
... PIC  IMR: ffff
... PIC  IRR: 0001
... PIC  ISR: 0000
... PIC ELCR: 0c28

printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000208fc
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000cd16
... APIC TMCCT: 0000094a
... APIC TDCR: 00000003


printing local APIC contents on CPU#1/1:
... APIC ID:      01000000 (1)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 02000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000
... APIC ESR: 00000000
... APIC ICR: 000008fc
... APIC ICR2: 01000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000cd16
... APIC TMCCT: 00006b13
... APIC TDCR: 00000003


printing local APIC contents on CPU#2/2:
... APIC ID:      02000000 (2)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000f0 (f0)
... APIC PROCPRI: 00000000
... APIC LDR: 04000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000001000
... APIC ESR: 00000000
... APIC ICR: 000008fc
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000cd16
... APIC TMCCT: 00003d0f
... APIC TDCR: 00000003


printing local APIC contents on CPU#3/3:
... APIC ID:      03000000 (3)
... APIC VERSION: 80050010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000f0 (f0)
... APIC PROCPRI: 00000000
... APIC LDR: 08000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC TMR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
... APIC IRR field:
0123456789abcdef0123456789abcdef
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000001000
... APIC ESR: 00000000
... APIC ICR: 000008fc
... APIC ICR2: 01000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00010000
... APIC LVT0: 00010700
... APIC LVT1: 00010400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000cd16
... APIC TMCCT: 00000f0b
... APIC TDCR: 00000003

number of MP IRQ sources: 15.
number of IO-APIC #4 registers: 24.
testing the IO APIC.......................

IO APIC #4......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00178021
.......     : max redirection entries: 0017
.......     : PRQ implemented: 1
.......     : IO APIC version: 0021
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
 00 000 1    0    0   0   0    0    0    00
 01 00F 0    0    0   0   0    1    1    31
 02 0FF 0    0    0   0   0    1    1    30
 03 00F 0    0    0   0   0    1    1    33
 04 00F 0    0    0   0   0    1    1    34
 05 00F 0    0    0   0   0    1    1    35
 06 00F 0    0    0   0   0    1    1    36
 07 00F 1    0    0   0   0    1    1    37
 08 00F 0    0    0   0   0    1    1    38
 09 00F 0    1    0   1   0    1    1    39
 0a 00F 0    0    0   0   0    1    1    3A
 0b 00F 0    0    0   0   0    1    1    3B
 0c 00F 0    0    0   0   0    1    1    3C
 0d 00F 0    0    0   0   0    1    1    3D
 0e 00F 0    0    0   0   0    1    1    3E
 0f 00F 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:2
IRQ1 -> 0:1
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
pnp: PnP ACPI init
ACPI: bus type pnp registered
IOAPIC[0]: Set routing entry (4-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (4-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
pnp 00:0d: mem resource (0xf0000-0xfffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x0-0x1fffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp 00:0d: mem resource (0x100000-0xbffdffff) overlaps 0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:01: ioport range 0x4100-0x411f has been reserved
system 00:01: ioport range 0x228-0x22f has been reserved
system 00:01: ioport range 0x40b-0x40b has been reserved
system 00:01: ioport range 0x4d6-0x4d6 has been reserved
system 00:01: ioport range 0xc00-0xc01 has been reserved
system 00:01: ioport range 0xc14-0xc14 has been reserved
system 00:01: ioport range 0xc50-0xc52 has been reserved
system 00:01: ioport range 0xc6c-0xc6d has been reserved
system 00:01: ioport range 0xc6f-0xc6f has been reserved
system 00:01: ioport range 0xcd0-0xcd1 has been reserved
system 00:01: ioport range 0xcd2-0xcd3 has been reserved
system 00:01: ioport range 0xcd4-0xcdf has been reserved
system 00:01: ioport range 0x4000-0x40fe has been reserved
system 00:01: ioport range 0x4210-0x4217 has been reserved
system 00:01: ioport range 0xb10-0xb1f has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x220-0x225 has been reserved
system 00:0d: iomem range 0xfed00000-0xfed000ff has been reserved
system 00:0d: iomem range 0xbffe0000-0xbfffffff could not be reserved
system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0d: iomem range 0xfff80000-0xfffeffff has been reserved
pci 0000:00:02.0: PCI bridge, secondary bus 0000:01
pci 0000:00:02.0:   IO window: 0xd000-0xdfff
pci 0000:00:02.0:   MEM window: 0xf8000000-0xfbffffff
pci 0000:00:02.0:   PREFETCH window: 0x000000c0000000-0x000000dfffffff
pci 0000:00:04.0: PCI bridge, secondary bus 0000:02
pci 0000:00:04.0:   IO window: 0xc000-0xcfff
pci 0000:00:04.0:   MEM window: 0xfdb00000-0xfdbfffff
pci 0000:00:04.0:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:03
pci 0000:00:06.0:   IO window: 0xb000-0xbfff
pci 0000:00:06.0:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:00:06.0:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
pci 0000:00:07.0: PCI bridge, secondary bus 0000:04
pci 0000:00:07.0:   IO window: 0xe000-0xefff
pci 0000:00:07.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:07.0:   PREFETCH window: 0x000000fdc00000-0x000000fdcfffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:05
pci 0000:00:14.4:   IO window: 0xa000-0xafff
pci 0000:00:14.4:   MEM window: 0xfd900000-0xfd9fffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fd800000-0x000000fd8fffff
IOAPIC[0]: Set routing entry (4-18 -> 0x49 -> IRQ 18 Mode:1 Active:1)
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:02.0: setting latency timer to 64
IOAPIC[0]: Set routing entry (4-16 -> 0x51 -> IRQ 16 Mode:1 Active:1)
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:04.0: setting latency timer to 64
pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:06.0: setting latency timer to 64
IOAPIC[0]: Set routing entry (4-19 -> 0x59 -> IRQ 19 Mode:1 Active:1)
pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:07.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffff]
bus: 01 index 0 io port: [0xd000-0xdfff]
bus: 01 index 1 mmio: [0xf8000000-0xfbffffff]
bus: 01 index 2 mmio: [0xc0000000-0xdfffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xc000-0xcfff]
bus: 02 index 1 mmio: [0xfdb00000-0xfdbfffff]
bus: 02 index 2 mmio: [0xfda00000-0xfdafffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xb000-0xbfff]
bus: 03 index 1 mmio: [0xfdf00000-0xfdffffff]
bus: 03 index 2 mmio: [0xfde00000-0xfdefffff]
bus: 03 index 3 mmio: [0x0-0x0]
bus: 04 index 0 io port: [0xe000-0xefff]
bus: 04 index 1 mmio: [0xfdd00000-0xfddfffff]
bus: 04 index 2 mmio: [0xfdc00000-0xfdcfffff]
bus: 04 index 3 mmio: [0x0-0x0]
bus: 05 index 0 io port: [0xa000-0xafff]
bus: 05 index 1 mmio: [0xfd900000-0xfd9fffff]
bus: 05 index 2 mmio: [0xfd800000-0xfd8fffff]
bus: 05 index 3 io port: [0x00-0xffff]
bus: 05 index 4 mmio: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done
Freeing initrd memory: 10525k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1233922326.136:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1717
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:02.0: setting latency timer to 64
pcieport-driver 0000:00:02.0: found MSI capability
pcieport-driver 0000:00:02.0: irq 1279 for MSI/MSI-X
pci_express 0000:00:02.0:pcie00: allocate port service
pci_express 0000:00:02.0:pcie03: allocate port service
pcieport-driver 0000:00:04.0: setting latency timer to 64
pcieport-driver 0000:00:04.0: found MSI capability
pcieport-driver 0000:00:04.0: irq 1278 for MSI/MSI-X
pci_express 0000:00:04.0:pcie00: allocate port service
pci_express 0000:00:04.0:pcie03: allocate port service
pcieport-driver 0000:00:06.0: setting latency timer to 64
pcieport-driver 0000:00:06.0: found MSI capability
pcieport-driver 0000:00:06.0: irq 1277 for MSI/MSI-X
pci_express 0000:00:06.0:pcie00: allocate port service
pci_express 0000:00:06.0:pcie03: allocate port service
pcieport-driver 0000:00:07.0: setting latency timer to 64
pcieport-driver 0000:00:07.0: found MSI capability
pcieport-driver 0000:00:07.0: irq 1276 for MSI/MSI-X
pci_express 0000:00:07.0:pcie00: allocate port service
pci_express 0000:00:07.0:pcie03: allocate port service
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: PC Speaker as /class/input/input0
input: AT Translated Set 2 keyboard as /class/input/input1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 276k freed
SCSI subsystem initialized
libata version 3.00 loaded.
pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
pata_jmicron 0000:03:00.1: setting latency timer to 64
scsi0 : pata_jmicron
scsi1 : pata_jmicron
ata1: PATA max UDMA/100 cmd 0xbf00 ctl 0xbe00 bmdma 0xbb00 irq 19
ata2: PATA max UDMA/100 cmd 0xbd00 ctl 0xbc00 bmdma 0xbb08 irq 19
logips2pp: Detected unknown logitech mouse model 11
ahci 0000:00:12.0: version 3.0
IOAPIC[0]: Set routing entry (4-22 -> 0x81 -> IRQ 22 Mode:1 Active:1)
ahci 0000:00:12.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:12.0: flags: ncq sntf ilck led clo pmp pio 
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
input: ImPS/2 Logitech Wheel Mouse as /class/input/input2
ata3: softreset failed (device not ready)
ata3: failed due to HW bug, retry pmp=0
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
ata3.00: configured for UDMA/133
ata4: softreset failed (device not ready)
ata4: failed due to HW bug, retry pmp=0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
ata4.00: configured for UDMA/133
ata5: softreset failed (device not ready)
ata5: failed due to HW bug, retry pmp=0
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata5.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
ata5.00: configured for UDMA/133
ata6: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
ahci 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ahci 0000:03:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:03:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
ahci 0000:03:00.0: setting latency timer to 64
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe100 irq 18
ata8: SATA max UDMA/133 abar m8192@0xfdffe000 port 0xfdffe180 irq 18
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
Uniform Multi-Platform E-IDE driver
atiixp 0000:00:14.1: IDE controller (0x1002:0x438c rev 0x00)
ATIIXP_IDE 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
atiixp 0000:00:14.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xf900-0xf907
Probing IDE interface ide0...
hda: ST3120023A, ATA DISK drive
hdb: TSSTcorpCD/DVDW TS-H552B, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
IOAPIC[0]: Set routing entry (4-21 -> 0x89 -> IRQ 21 Mode:1 Active:1)
aic7xxx 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
scsi8 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2930CU SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

BIOS EDD facility v0.16 2004-Jun-25, 4 devices found
sky2 driver version 1.22
sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 5
sky2 0000:04:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
 Part Number: Yukon 88E8056
 Engineering Level: Rev. 1.3
 Manufacturer: Marvell
sky2 0000:04:00.0: irq 1275 for MSI/MSI-X
sky2 eth0: addr 00:e0:4d:7a:8c:ee
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Driver 'sd' needs updating - please use bus_type methods
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ohci_hcd 0000:00:13.0: OHCI Host Controller
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
usb 1-1: new full speed USB device using ohci_hcd and address 2
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28.3-250Hz ehci_hcd
usb usb2: SerialNumber: 0000:00:13.5
IOAPIC[0]: Set routing entry (4-17 -> 0x99 -> IRQ 17 Mode:1 Active:1)
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
hub 1-0:1.0: unable to enumerate USB device on port 1
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=03f0, idProduct=5111
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Photosmart 3200 series
usb 2-1: Manufacturer: HP
usb 2-1: SerialNumber: MY5B98310Z045K
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb 2-2: new high speed USB device using ehci_hcd and address 3
usb usb4: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
usb 2-2: configuration #1 chosen from 1 choice
hub 2-2:1.0: USB hub found
hub 2-2:1.0: 4 ports detected
usb 2-2: New USB device found, idVendor=0424, idProduct=2504
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb5: SerialNumber: 0000:00:13.3
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb6: SerialNumber: 0000:00:13.4
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
e1000e 0000:02:00.0: setting latency timer to 64
e1000e 0000:02:00.0: irq 1274 for MSI/MSI-X
ide-cd driver 5.00
ide-cd: hdb: ATAPI 32X DVD-ROM DVD-R CD-R/RW<6>Linux agpgart interface v0.103
 drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:0f:09:1b
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Illegal request -- (Sense key=0x05)
  Logical block address out of range -- (asc=0x21, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
hdb: command error: status=0x51 { DriveReady SeekComplete Error }
hdb: command error: error=0x54 { AbortedCommand LastFailedSense=0x05 }
ide: failed opcode was: unknown
ATAPI device hdb:
  Error: Illegal request -- (Sense key=0x05)
  Logical block address out of range -- (asc=0x21, ascq=0x00)
  The failed "Read 10" packet command was: 
  "28 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00 "
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
IT8718 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x03F0 pid 0x5111
usbcore: registered new interface driver usblp
0000:02:00.0: eth1: MAC: 1, PHY: 4, PBA No: d50854-003
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Initializing USB Mass Storage driver...
scsi9 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
ppdev: user-space parallel port driver
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:3055: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:3059:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3063:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3064:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3072:    inputs: mic=0x18, fmic=0x19, line=0x1a, fline=0x0, cd=0x0, aux=0x0
Adding 8393952k swap on /dev/sda2.  Priority:-1 extents:1 across:8393952k
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.10)
scsi 9:0:0:0: Direct-Access     HP       Photosmart 3210  1.00 PQ: 0 ANSI: 2
sd 9:0:0:0: [sdd] Attached SCSI removable disk
sd 9:0:0:0: Attached scsi generic sg3 type 0
usb-storage: device scan complete
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
cdrom: This disc doesn't have any tracks I recognize!
sky2 eth0: enabling interface
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000e 0000:02:00.0: irq 1274 for MSI/MSI-X
e1000e 0000:02:00.0: irq 1274 for MSI/MSI-X
ADDRCONF(NETDEV_UP): eth1: link is not ready
sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present
warning: `ntpd' uses deprecated v2 capabilities in a way that may be insecure.
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9305 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9307 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=254 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=234 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=363 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=343 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=363 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=343 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=363 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=343 
SFW2-INext-ACC-TCP IN=eth0 OUT= MAC=00:e0:4d:7a:8c:ee:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=10.10.10.100 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=63488 DF PROTO=TCP SPT=38941 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A006FD8920000000001030304) 
SFW2-INext-ACC-TCP IN=eth0 OUT= MAC=00:e0:4d:7a:8c:ee:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=10.10.10.100 LEN=60 TOS=0x00 PREC=0x00 TTL=64 ID=46020 DF PROTO=TCP SPT=38942 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A006FDE950000000001030304) 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x04 PREC=0x40 TTL=1 ID=9310 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9314 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9328 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9347 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x20 TTL=1 ID=9351 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9370 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9372 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9387 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9391 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9393 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-ACC-TCP IN=eth0 OUT= MAC=00:e0:4d:7a:8c:ee:00:18:f8:ff:72:d3:08:00 SRC=216.54.166.2 DST=10.10.10.100 LEN=60 TOS=0x00 PREC=0x00 TTL=53 ID=22236 DF PROTO=TCP SPT=12276 DPT=22 WINDOW=5840 RES=0x00 SYN URGP=0 OPT (020405B40402080A09767D0E0000000001030306) 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9409 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x20 TTL=1 ID=9435 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x20 TTL=1 ID=9449 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9453 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9469 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9474 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9487 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9489 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9494 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9497 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9498 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9511 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9515 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9531 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9538 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9550 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9556 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9557 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9573 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9591 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9594 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9598 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9610 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9617 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9619 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9632 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9635 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9656 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9672 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9674 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9677 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9690 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9692 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9696 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9708 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9710 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9726 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9748 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9766 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth1 OUT= MAC= SRC=192.168.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC= SRC=10.10.10.100 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9801 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=64 TOS=0x00 PREC=0x00 TTL=255 ID=0 DF PROTO=UDP SPT=5353 DPT=5353 LEN=44 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9806 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9807 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9809 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9823 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9826 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9831 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9845 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9849 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x20 TTL=1 ID=9864 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9867 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x14 PREC=0xC0 TTL=1 ID=9870 OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:04:5a:83:54:1a:08:00 SRC=10.10.10.102 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF OPT (94040000) PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:01:00:18:f8:ff:72:d3:08:00 SRC=10.10.10.1 DST=224.0.0.1 LEN=28 TOS=0x00 PREC=0x00 TTL=1 ID=0 DF PROTO=2 
SFW2-INext-DROP-DEFLT IN=eth0 OUT= MAC=01:00:5e:00:00:fb:00:15:60:8c:4b:fb:08:00 SRC=10.10.10.105 DST=224.0.0.251 LEN=32 TOS=0x00 PREC=0x00 TTL=1 ID=9884 OPT (94040000) PROTO=2 

--------------080009020600040800080309--
