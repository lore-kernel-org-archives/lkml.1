Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZGCWCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZGCWCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 18:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755812AbZGCWBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 18:01:53 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:33594 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbZGCWBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 18:01:50 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug Fix]: Do 32-bit table calculations in pre-processor
Date: Fri, 3 Jul 2009 17:01:47 -0500
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <ak@linux.intel.com>
References: <200907031314.36243.lkml@morethan.org> <200907031538.11603.lkml@morethan.org> <4A4E6CB4.90600@zytor.com>
In-Reply-To: <4A4E6CB4.90600@zytor.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_O/nTK/vl83iIHK8"
Message-Id: <200907031701.50442.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_O/nTK/vl83iIHK8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Fri July 3 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > That takes a running machine - which is a bit of a challenge at the moment.
> > Well, for the past four months, if truth be told.
> > 
> > Anything in particular you are looking for?
> > I may have it in my notes and data captures.
> > 
> 
> The CPUID flags, in particular the pse flag.
> 
> 	-hpa
> 

OK - got the requested information - also can see that
this whole thing was a false alarm. . .

The before and after of the original post was the difference
between the PAE and non-PAE code path **NOT** the calculation!
My bad, wasn't careful enough in my testing.

I have in-lined the difference between with/without the patch;
and attached the "patched" dmesg output.

> --- dmesg-patched.txt	2009-07-03 16:08:44.000000000 -0500
> +++ dmesg-unpatched.txt	2009-07-03 16:46:38.000000000 -0500
> @@ -1,4 +1,4 @@
> -Linux version 2.6.30-ce1200v-09183 (root@gen2-32) (gcc version 4.1.2
> (Gentoo 4.1.2 p1.1)) #3 PREEMPT Fri Jul 3 12:27:32 CDT 2009 +Linux version
> 2.6.30-ce1200v-09183 (root@gen2-32) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1))
> #4 PREEMPT Fri Jul 3 16:29:35 CDT 2009 KERNEL supported cpus:
>    Intel GenuineIntel
>    AMD AuthenticAMD
> @@ -59,7 +59,7 @@
>  init_memory_mapping: 0000000000000000-000000001bee0000
>   0000000000 - 001bee0000 page 4k
>  kernel direct mapping tables up to 1bee0000 @ 10000-83000
> -RAMDISK: 1b8d9000 - 1becf0cc
> +RAMDISK: 1b8d9000 - 1becf1bb
>  ACPI: RSDP 000f8470 00014 (v00 PTLTD )
>  ACPI: RSDT 1bee5663 00034 (v01 PTLTD    RSDT   06040000  LTP 00000000)
>  ACPI: FACP 1bee9a46 00074 (v01 CX700  PTLTW    06040000 PTL_ 000F4240)
> @@ -78,7 +78,7 @@
>  (7 early reservations) ==> bootmem [0000000000 - 001bee0000]
>    #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
> 0000001000] #1 [0000100000 - 0000733430]    TEXT DATA BSS ==> [0000100000 -
> 0000733430] -  #2 [001b8d9000 - 001becf0cc]          RAMDISK ==>
> [001b8d9000 - 001becf0cc] +  #2 [001b8d9000 - 001becf1bb]          RAMDISK
> ==> [001b8d9000 - 001becf1bb] #3 [000009dc00 - 0000100000]    BIOS reserved
> ==> [000009dc00 - 0000100000] #4 [0000734000 - 00007370f1]              BRK
> ==> [0000734000 - 00007370f1] #5 [0000010000 - 000007d000]          PGTABLE
> ==> [0000010000 - 000007d000] @@ -127,7 +127,7 @@
>  NR_IRQS:288
>  PID hash table entries: 2048 (order: 11, 8192 bytes)
>  Fast TSC calibration using PIT
> -Detected 600.021 MHz processor.
> +Detected 599.982 MHz processor.
>  Console: colour VGA+ 80x25
>  console [tty0] enabled
>  Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> @@ -144,7 +144,7 @@
>        .text : 0xc0100000 - 0xc050f40a   (4157 kB)
>  Checking if this processor honours the WP bit even in supervisor
> mode...Ok. SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1,
> Nodes=1 -Calibrating delay loop (skipped), value calculated using timer
> frequency.. 1200.04 BogoMIPS (lpj=2000070) +Calibrating delay loop
> (skipped), value calculated using timer frequency.. 1200.96 BogoMIPS
> (lpj=1999940) Security Framework initialized
>  Smack:  Initializing.
>  Mount-cache hash table entries: 512
> @@ -163,7 +163,7 @@
>  ....... works.
>  net_namespace: 996 bytes
>  regulator: core version 0.5
> -Time: 21:04:35  Date: 07/03/09
> +Time: 21:44:23  Date: 07/03/09
>  NET: Registered protocol family 16
>  ACPI: bus type pci registered
>  PCI: MCFG configuration 0: base e0000000 segment 0 buses 3 - 3
> @@ -386,9 +386,6 @@
>  serio: i8042 AUX2 port at 0x60,0x64 irq 12
>  serio: i8042 AUX3 port at 0x60,0x64 irq 12
>  mice: PS/2 mouse device common for all mice
> -ata2.00: ATA-7: ST730212DE, 3.01, max UDMA/66
> -ata2.00: 58605120 sectors, multi 16: LBA48
> -ata2.00: limited to UDMA/33 due to 40-wire cable
>  rtc_cmos 00:03: RTC can wake from S4
>  rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
>  rtc0: alarms up to one year, y3k, 242 bytes nvram
> @@ -406,10 +403,12 @@
>  usbcore: registered new interface driver usbhid
>  usbhid: v2.6:USB HID core driver
>  Advanced Linux Sound Architecture Driver Version 1.0.20.
> +ata2.00: ATA-7: ST730212DE, 3.01, max UDMA/66
> +ata2.00: 58605120 sectors, multi 16: LBA48
> +ata2.00: limited to UDMA/33 due to 40-wire cable
>  HDA Intel 0000:02:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>  HDA Intel 0000:02:01.0: setting latency timer to 64
>  HDA Intel 0000:02:01.0: PCI: Disallowing DAC for device
> -input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input4 ata2.00: configured for UDMA/33
>  scsi 1:0:0:0: Direct-Access     ATA      ST730212DE       3.01 PQ: 0 ANSI:
> 5 sd 1:0:0:0: Attached scsi generic sg0 type 0
> @@ -417,7 +416,8 @@
>  sd 1:0:0:0: [sda] Write Protect is off
>  sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
>  sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA - sda: sda1 sda2 sda3 sda4
> + sda:<6>input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input4 + sda1 sda2 sda3 sda4
>  sd 1:0:0:0: [sda] Attached SCSI disk
>  ALSA device list:
>    #0: HDA VIA VT82xx at 0xd1000000 irq 17
> @@ -442,8 +442,9 @@
>  PM: Checking hibernation image.
>  PM: Resume from disk failed.
>  registered taskstats version 1
> -  Magic number: 1:970:94
> -rtc_cmos 00:03: setting system clock to 2009-07-03 21:04:38 UTC
> (1246655078) +  Magic number: 1:144:752
> +tty ttyS3: hash matches
> +rtc_cmos 00:03: setting system clock to 2009-07-03 21:44:26 UTC
> (1246657466) BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
>  EDD information not available.
>  debug: unmapping init memory c0692000..c06f1000

Sorry about the fuss - really sorry.
Mike


--Boundary-00=_O/nTK/vl83iIHK8
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg-patched.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-patched.txt"

Linux version 2.6.30-ce1200v-09183 (root@gen2-32) (gcc version 4.1.2 (Gentoo 4.1.2 p1.1)) #3 PREEMPT Fri Jul 3 12:27:32 CDT 2009
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
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001bee0000 (usable)
 BIOS-e820: 000000001bee0000 - 000000001beea000 (ACPI data)
 BIOS-e820: 000000001beea000 - 000000001bf00000 (ACPI NVS)
 BIOS-e820: 000000001bf00000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
DMI present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
last_pfn = 0x1bee0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-DFFFF uncachable
  E0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask FE0000000 write-back
  1 base 01BF00000 mask FFFF00000 uncachable
  2 base 01C000000 mask FFC000000 uncachable
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
Scanning 0 areas for low memory corruption
modified physical RAM map:
 modified: 0000000000000000 - 0000000000010000 (reserved)
 modified: 0000000000010000 - 000000000009dc00 (usable)
 modified: 000000000009dc00 - 00000000000a0000 (reserved)
 modified: 00000000000dc000 - 00000000000e0000 (reserved)
 modified: 00000000000e8000 - 0000000000100000 (reserved)
 modified: 0000000000100000 - 000000001bee0000 (usable)
 modified: 000000001bee0000 - 000000001beea000 (ACPI data)
 modified: 000000001beea000 - 000000001bf00000 (ACPI NVS)
 modified: 000000001bf00000 - 0000000020000000 (reserved)
 modified: 00000000e0000000 - 00000000f0000000 (reserved)
 modified: 00000000fec00000 - 00000000fec10000 (reserved)
 modified: 00000000fee00000 - 00000000fee01000 (reserved)
 modified: 00000000fff80000 - 0000000100000000 (reserved)
init_memory_mapping: 0000000000000000-000000001bee0000
 0000000000 - 001bee0000 page 4k
kernel direct mapping tables up to 1bee0000 @ 10000-83000
RAMDISK: 1b8d9000 - 1becf0cc
ACPI: RSDP 000f8470 00014 (v00 PTLTD )
ACPI: RSDT 1bee5663 00034 (v01 PTLTD    RSDT   06040000  LTP 00000000)
ACPI: FACP 1bee9a46 00074 (v01 CX700  PTLTW    06040000 PTL_ 000F4240)
ACPI: DSDT 1bee5697 043AF (v01  VIA   PTL_ACPI 06040000 MSFT 0100000E)
ACPI: FACS 1beeafc0 00040
ACPI: SSDT 1bee9aba 004BA (v01 PPmmRe      PPm 06040000 INTL 20030224)
ACPI: APIC 1bee9f74 00050 (v01 PTLTD  	 APIC   06040000  LTP 00000000)
ACPI: MCFG 1bee9fc4 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
ACPI: Local APIC address 0xfee00000
0MB HIGHMEM available.
446MB LOWMEM available.
  mapped low ram: 0 - 1bee0000
  low ram: 0 - 1bee0000
  node 0 low ram: 00000000 - 1bee0000
  node 0 bootmap 0007d000 - 000807dc
(7 early reservations) ==> bootmem [0000000000 - 001bee0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000100000 - 0000733430]    TEXT DATA BSS ==> [0000100000 - 0000733430]
  #2 [001b8d9000 - 001becf0cc]          RAMDISK ==> [001b8d9000 - 001becf0cc]
  #3 [000009dc00 - 0000100000]    BIOS reserved ==> [000009dc00 - 0000100000]
  #4 [0000734000 - 00007370f1]              BRK ==> [0000734000 - 00007370f1]
  #5 [0000010000 - 000007d000]          PGTABLE ==> [0000010000 - 000007d000]
  #6 [000007d000 - 0000081000]          BOOTMAP ==> [000007d000 - 0000081000]
found SMP MP-table at [c00f84b0] f84b0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x0001bee0
  HighMem  0x0001bee0 -> 0x0001bee0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009d
    0: 0x00000100 -> 0x0001bee0
On node 0 totalpages: 114285
free_area_init_node: node 0, pgdat c06865a0, node_mem_map c1001200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3949 pages, LIFO batch:0
  Normal zone: 862 pages used for memmap
  Normal zone: 109442 pages, LIFO batch:31
Using APIC driver default
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009d000 - 000000000009e000
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 00000000000e8000
PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 113391
Kernel command line: root=/dev/sda1 resume=/dev/sda2 ro quiet splash
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
NR_IRQS:288
PID hash table entries: 2048 (order: 11, 8192 bytes)
Fast TSC calibration using PIT
Detected 600.021 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Initializing HighMem for node 0 (00000000:00000000)
Memory: 439952k/457600k available (4157k kernel code, 16920k reserved, 1538k data, 380k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdc6e0000 - 0xff7fe000   ( 561 MB)
    lowmem  : 0xc0000000 - 0xdbee0000   ( 446 MB)
      .init : 0xc0692000 - 0xc06f1000   ( 380 kB)
      .data : 0xc050f40a - 0xc068fd58   (1538 kB)
      .text : 0xc0100000 - 0xc050f40a   (4157 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 1200.04 BogoMIPS (lpj=2000070)
Security Framework initialized
Smack:  Initializing.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys freezer
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 128K (64 bytes/line)
CPU: Centaur VIA C7-M Processor 1200MHz stepping 00
Checking 'hlt' instruction... OK.
ACPI: Core revision 20090320
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
net_namespace: 996 bytes
regulator: core version 0.5
Time: 21:04:35  Date: 07/03/09
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 3 - 3
PCI: MCFG area at e0300000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI Warning (dsobject-0502): Package List length (8) larger than NumElements count (5), truncated
 [20090320]
ACPI Warning (dsobject-0502): Package List length (8) larger than NumElements count (5), truncated
 [20090320]
ACPI Warning (dsobject-0502): Package List length (8) larger than NumElements count (5), truncated
 [20090320]
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [PFN0] (off)
ACPI: Power Resource [PFN1] (off)
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:00.0: reg 10 32bit mmio: [0xc0000000-0xcfffffff]
pci 0000:00:01.0: supports D1
pci 0000:00:0f.0: reg 20 io port: [0x4460-0x446f]
pci 0000:00:10.0: reg 20 io port: [0x4400-0x441f]
pci 0000:00:10.0: supports D1 D2
pci 0000:00:10.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.0: PME# disabled
pci 0000:00:10.1: reg 20 io port: [0x4420-0x443f]
pci 0000:00:10.1: supports D1 D2
pci 0000:00:10.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.1: PME# disabled
pci 0000:00:10.2: reg 20 io port: [0x4440-0x445f]
pci 0000:00:10.2: supports D1 D2
pci 0000:00:10.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.2: PME# disabled
pci 0000:00:10.4: reg 10 32bit mmio: [0xd1400000-0xd14000ff]
pci 0000:00:10.4: supports D1 D2
pci 0000:00:10.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:10.4: PME# disabled
pci 0000:00:11.7: Disabling VIA CX700 PCI parking
pci 0000:00:11.7: Disabling VIA CX700 PCI caching
pci 0000:01:00.0: reg 10 32bit mmio: [0xa0000000-0xbfffffff]
pci 0000:01:00.0: reg 14 32bit mmio: [0xd0000000-0xd0ffffff]
pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:01:00.0: supports D1 D2
pci 0000:00:01.0: bridge 32bit mmio: [0xd0000000-0xd0ffffff]
pci 0000:00:01.0: bridge 32bit mmio pref: [0xa0000000-0xbfffffff]
pci 0000:02:01.0: reg 10 64bit mmio: [0xd1000000-0xd1003fff]
pci 0000:02:01.0: PME# supported from D0 D3hot D3cold
pci 0000:02:01.0: PME# disabled
pci 0000:00:13.0: bridge 32bit mmio: [0xd1000000-0xd10fffff]
pci 0000:03:09.0: reg 10 io port: [0x5000-0x50ff]
pci 0000:03:09.0: reg 14 32bit mmio: [0xd1100000-0xd11000ff]
pci 0000:03:09.0: supports D1 D2
pci 0000:03:09.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:03:09.0: PME# disabled
pci 0000:00:13.1: bridge io port: [0x5000-0x5fff]
pci 0000:00:13.1: bridge 32bit mmio: [0xd1100000-0xd11fffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.SP2P._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2PE._PRT]
ACPI: PCI Interrupt Link [ALKA] (IRQs 16 17 18 19 20 21 22 23) *10, disabled.
ACPI: PCI Interrupt Link [ALKB] (IRQs 16 17 18 19 20 21 22 23) *11, disabled.
ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *10, disabled.
ACPI: PCI Interrupt Link [ALKD] (IRQs 21) *0, disabled.
ACPI: PCI Interrupt Link [LNKA] (IRQs 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 9 10 11 12) *0, disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set for 64 byte cache
Bluetooth: Core ver 2.15
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
NET: Registered protocol family 8
NET: Registered protocol family 20
cfg80211: Calling CRDA to update world regulatory domain
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
system 00:05: iomem range 0x0-0x9ffff could not be reserved
system 00:05: iomem range 0xe0000-0xfffff could not be reserved
system 00:05: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:05: iomem range 0xffee0000-0xffefffff has been reserved
system 00:05: iomem range 0xfec00000-0xfec0ffff has been reserved
system 00:05: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:05: iomem range 0xe0208000-0xe0208fff has been reserved
system 00:06: ioport range 0x4d0-0x4d1 has been reserved
system 00:06: ioport range 0xfe10-0xfe11 has been reserved
system 00:06: ioport range 0xfe00-0xfe00 has been reserved
system 00:06: ioport range 0x4000-0x407f has been reserved
system 00:06: ioport range 0x4100-0x411f has been reserved
pci 0000:01:00.0: BAR 6: can't allocate mem resource [0xc0000000-0xbfffffff]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xd0000000-0xd0ffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000a0000000-0x000000bfffffff
pci 0000:00:13.0: PCI bridge, secondary bus 0000:02
pci 0000:00:13.0:   IO window: disabled
pci 0000:00:13.0:   MEM window: 0xd1000000-0xd10fffff
pci 0000:00:13.0:   PREFETCH window: disabled
pci 0000:00:13.1: PCI bridge, secondary bus 0000:03
pci 0000:00:13.1:   IO window: 0x5000-0x5fff
pci 0000:00:13.1:   MEM window: 0xd1100000-0xd11fffff
pci 0000:00:13.1:   PREFETCH window: disabled
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:13.0: setting latency timer to 64
pci 0000:00:13.1: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 1 mem: [0xd0000000-0xd0ffffff]
pci_bus 0000:01: resource 2 pref mem [0xa0000000-0xbfffffff]
pci_bus 0000:02: resource 1 mem: [0xd1000000-0xd10fffff]
pci_bus 0000:03: resource 0 io:  [0x5000-0x5fff]
pci_bus 0000:03: resource 1 mem: [0xd1100000-0xd11fffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Switched to high resolution mode on CPU 0
debug: unmapping init memory db8d9000..dbed0000
cpu0(1) debug files 73
Scanning for low memory corruption every 60 seconds
HugeTLB registered 4 MB page size, pre-allocated 0 pages
squashfs: version 4.0 (2009/01/31) Phillip Lougher
fuse init (API version 7.11)
msgmni has been set to 859
alg: No test for stdrng (krng)
alg: No test for stdrng (ansi_cprng)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:01:00.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
ACPI: Lid Switch [LID]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN0] (on)
fan PNP0C0B:01: registered as cooling_device1
ACPI: Fan [FAN1] (on)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:14/device:15/input/input3
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
Marking TSC unstable due to TSC halts in idle
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI_CPU:00: registered as cooling_device2
ACPI: Processor [CPU0] (supports 16 throttling states)
ACPI: Device [FAN0] failed to transition to D3
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (52 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
VIA RNG detected
Linux agpgart interface v0.103
agpgart: Detected VIA CX700 chipset
agpgart-via 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized via 2.11.1 20070202 for 0000:01:00.0 on minor 0
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
pata_via 0000:00:0f.0: version 0.3.4
pata_via 0000:00:0f.0: power state changed by ACPI to D0
pata_via 0000:00:0f.0: setting latency timer to 64
ACPI: Battery Slot [BAT0] (battery present)
scsi0 : pata_via
scsi1 : pata_via
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x4460 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0x4468 irq 15
Fixed MDIO Bus: probed
PPP generic driver version 2.4.2
8139too Fast Ethernet driver 0.9.28
8139too 0000:03:09.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
8139too 0000:03:09.0: setting latency timer to 64
eth0: RealTek RTL8139 at 0xdc71e000, 00:14:0b:3d:bc:5f, IRQ 16
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
ata1: port disabled. ignoring.
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver usbserial
USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
usbserial: USB Serial Driver core
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
ata2.00: ATA-7: ST730212DE, 3.01, max UDMA/66
ata2.00: 58605120 sectors, multi 16: LBA48 
ata2.00: limited to UDMA/33 due to 40-wire cable
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k, 242 bytes nvram
Linux video capture interface: v2.00
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
md: raid1 personality registered for level 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
device-mapper: multipath round-robin: version 1.0.0 loaded
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.20.
HDA Intel 0000:02:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:02:01.0: setting latency timer to 64
HDA Intel 0000:02:01.0: PCI: Disallowing DAC for device
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
ata2.00: configured for UDMA/33
scsi 1:0:0:0: Direct-Access     ATA      ST730212DE       3.01 PQ: 0 ANSI: 5
sd 1:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: [sda] 58605120 512-byte hardware sectors: (30.0 GB/27.9 GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 1:0:0:0: [sda] Attached SCSI disk
ALSA device list:
  #0: HDA VIA VT82xx at 0xd1000000 irq 17
TCP cubic registered
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
NET: Registered protocol family 17
Bridge firewalling registered
Bluetooth: L2CAP ver 2.13
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO (Voice Link) ver 0.6
Bluetooth: SCO socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Using IPI Shortcut mode
PM: Checking image partition /dev/sda2
PM: Resume from partition 8:2
PM: Checking hibernation image.
PM: Resume from disk failed.
registered taskstats version 1
  Magic number: 1:970:94
rtc_cmos 00:03: setting system clock to 2009-07-03 21:04:38 UTC (1246655078)
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
debug: unmapping init memory c0692000..c06f1000
Write protecting the kernel text: 4160k
Write protecting the kernel read-only data: 1248k
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1c0b1, caps: 0xa04750/0x200000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input5
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:10.4: PCI INT D -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:10.4: setting latency timer to 64
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: irq 23, io mem 0xd1400000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-ce1200v-09183 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.0: setting latency timer to 64
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 20, io base 0x00004400
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-ce1200v-09183 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
uhci_hcd 0000:00:10.1: setting latency timer to 64
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 22, io base 0x00004420
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-ce1200v-09183 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:10.2: PCI INT C -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: setting latency timer to 64
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x00004440
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30-ce1200v-09183 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usbcore: registered new interface driver rtl8187
usb 1-5: new high speed USB device using ehci_hcd and address 3
usb 1-5: New USB device found, idVendor=5986, idProduct=0101
usb 1-5: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 1-5: Product: USB2.0 Camera
usb 1-5: configuration #1 chosen from 1 choice
uvcvideo: Found UVC 1.00 device USB2.0 Camera (5986:0101)
input: USB2.0 Camera as /devices/pci0000:00/0000:00:10.4/usb1/1-5/1-5:1.0/input/input6
usb 1-6: new high speed USB device using ehci_hcd and address 4
usb 1-6: New USB device found, idVendor=0bda, idProduct=0158
usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-6: Product: USB2.0-CRW
usb 1-6: Manufacturer: Generic
usb 1-6: SerialNumber: 20060413092100000
usb 1-6: configuration #1 chosen from 1 choice
scsi2 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usb 2-2: new low speed USB device using uhci_hcd and address 2
usb 2-2: New USB device found, idVendor=04d9, idProduct=048e
usb 2-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 2-2: configuration #1 chosen from 1 choice
input: HID 04d9:048e as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2:1.0/input/input7
generic-usb 0003:04D9:048E.0001: input,hidraw0: USB HID v1.10 Mouse [HID 04d9:048e] on usb-0000:00:10.0-2/input0
PM: Starting manual resume from disk
PM: Resume from partition 8:2
PM: Checking hibernation image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
usb-storage: device scan complete
scsi 2:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] Attached SCSI removable disk
udev: starting version 141
udev: renamed network interface eth0 to eth1
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
Adding 1004052k swap on /dev/sda2.  Priority:4 extents:1 across:1004052k 
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
eth1: no IPv6 routers present
agpgart-via 0000:00:00.0: AGP 3.5 bridge
agpgart-via 0000:00:00.0: putting AGP V3 device into 8x mode
pci 0000:01:00.0: putting AGP V3 device into 8x mode
hda-intel: IRQ timing workaround is activated for card #0. Suggest a bigger bdl_pos_adj.

--Boundary-00=_O/nTK/vl83iIHK8--
