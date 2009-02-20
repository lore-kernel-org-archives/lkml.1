Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZBTPnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZBTPnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbZBTPnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:43:14 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.123]:48559 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbZBTPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:43:08 -0500
Message-ID: <499ECF87.2070204@cfl.rr.com>
Date: Fri, 20 Feb 2009 10:43:03 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Mark Hounschell <markh@compro.net>, john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD Phenom-II
 processor
References: <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com> <499D364C.3010704@cfl.rr.com> <20090219141131.GM4301@alberich.amd.com> <499D77D8.509@cfl.rr <20090220115357.GE4834@alberich.amd.com>
In-Reply-To: <20090220115357.GE4834@alberich.amd.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------020207030106080801090908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020207030106080801090908
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andreas Herrmann wrote:
> On Thu, Feb 19, 2009 at 10:54:19AM -0500, Mark Hounschell wrote:
>> Borislav Petkov wrote:
>>> On Thu, Feb 19, 2009 at 10:16:40AM -0500, Mark Hounschell wrote:
>>>> Andreas Herrmann wrote:
>>>>> Hi Mark,
>>>>>
>>>>> Can you please provide us output of lspci -vvxxx.
>>>>> (Please run this as root.)
>>>>>
>> Attached...
>>
>>
>>>>> Furthermore you can try booting your 1000HZ kernel
>>>>> with following kernel command lines:
>>>>>
> 
> Thanks for trying this out.
> But nothing suspicious found. I.e. timer/hpet interrupt is enabled
> and its routing seems to be ok.
> 
> Here's one more check that's worth trying: In one of your logs I've
> seen that HPET id reports 3 timers but later on 4 timers were detected
> for HPET.
> 
> To check what's going on I'd like to see the HPET configuration in the
> course of booting your system.  Please apply attached patch and boot
> with hpet=debug -- both with 250HZ and with 1000HZ -- and provide dmesg
> output.
> 
> 

Here is the short 1000Hz bootlog. I'm afraid non of your debug output made it
out however. I thought it was because it just wasn't getting that far but
looking at the 250Hz log I don't see any there either???

The patch applied (with fuz) to both kernel sources and I built/installed them
from clean. I don't find any messages starting with "hpet:" in either trace???


BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #7 SMP PREEMPT Fri Feb
20 09:01:29 EST 2009
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
RAMDISK: 374d0000 - 37feff4c
Allocated new RAMDISK: 004a7000 - 00fc6f4c
Move RAMDISK from 00000000374d0000 - 0000000037feff4b to 004a7000 - 00fc6f4b
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 004C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: SSDT BFFE8E40, 088C (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET BFFE9700, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE9740, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
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
  #7 [00004a7000 - 0000fc6f4c]      NEW RAMDISK ==> [00004a7000 - 0000fc6f4c]
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
ACPI: PM-Timer IO Port: 0x4008
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
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 36864 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780143
Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5 apm=off
selinux=0 noresume splash=silent apic=debug hpet=debug console=ttyS0,19200n
8 vga=normal
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3000.099 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3103456k/3145600k available (1836k kernel code, 40784k reserved, 1098k
data, 276k init, 2236296k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02cb187 - 0xc03ddc4c   (1098 kB)
      .text : 0xc0100000 - 0xc02cb187   (1836 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
HPE

A complete 250Hz version is attached.

Regards
Mark



--------------020207030106080801090908
Content-Type: text/plain;
 name="d.bootlog-250Hz.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="d.bootlog-250Hz.txt"

BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #7 SMP PREEMPT Fri Feb 2
0 09:01:54 EST 2009
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
RAMDISK: 374cf000 - 37fef1ba
Allocated new RAMDISK: 004a7000 - 00fc71ba
Move RAMDISK from 00000000374cf000 - 0000000037fef1b9 to 004a7000 - 00fc71b9
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 004C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: SSDT BFFE8E40, 088C (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET BFFE9700, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE9740, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: APIC BFFE8D80, 0084 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
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
  #7 [00004a7000 - 0000fc71ba]      NEW RAMDISK ==> [00004a7000 - 0000fc71ba]
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
ACPI: PM-Timer IO Port: 0x4008
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
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
PERCPU: Allocating 36864 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 780143
Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5 apm=off selinux=0 noresume splash=silent apic=debug hpet=debug console=ttyS0,19200n
8 vga=normal
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3000.190 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3103452k/3145600k available (1836k kernel code, 40788k reserved, 1098k data, 276k init, 2236296k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02cb157 - 0xc03ddc4c   (1098 kB)
      .text : 0xc0100000 - 0xc02cb157   (1836 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 6000.38 BogoMIPS (lpj=12000760)
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
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 940 Processor stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1250071
... PM timer delta = 357950
... PM timer result ok
..... delta 1250071
..... mult: 53686785
..... calibration result: 800045
..... CPU clock speed is 3000.0679 MHz.
..... host bus clock speed is 200.0045 MHz.
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 6000.41 BogoMIPS (lpj=12000822)
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
Calibrating delay using timer specific routine.. 6000.40 BogoMIPS (lpj=12000818)
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
Calibrating delay using timer specific routine.. 6000.41 BogoMIPS (lpj=12000824)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: AMD Phenom(tm) II X4 940 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (24001.61 BogoMIPS).
net_namespace: 776 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
pci 0000:00:04.0: PME# disabled
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:12.0: set SATA to AHCI mode
pci 0000:00:13.5: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.5: PME# disabled
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:03:00.0: PME# supported from D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:14.4: transparent bridge
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

... APIC ID:      00000000 (0)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000


... APIC ID:      01000000 (1)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000000000


... APIC ID:      02000000 (2)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000001000


... APIC ID:      03000000 (3)
... APIC VERSION: 80050010
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000000000000000000000
00000000000000010000000000001000

testing the IO APIC.......................

.................................... done.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #3
pnp: PnP ACPI init
ACPI: bus type pnp registered
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
pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
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
Freeing initrd memory: 11392k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1235121981.180:1): initialized
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
pcieport-driver 0000:00:02.0: found MSI capability
pcieport-driver 0000:00:04.0: found MSI capability
pcieport-driver 0000:00:06.0: found MSI capability
pcieport-driver 0000:00:07.0: found MSI capability
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
doing fast boot
Boot logging started on /dev/ttSCSI subsystem initialized
yS0(/dev/console) at Fri Feb 20 pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
09:26:22 2009
pata_jmicron 0000:03:00.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
scsi0 : pata_jmicron
FATAL: Module prscsi1 : pata_jmicron
ocessor not founata1: PATA max UDMA/100 cmd 0xbf00 ctl 0xbe00 bmdma 0xbb00 irq 19
ata2: PATA max UDMA/100 cmd 0xbd00 ctl 0xbc00 bmdma 0xbb08 irq 19
d.
FATAL: Module thermal not found.
logips2pp: Detected unknown logitech mouse model 11
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
hda: ST3120023A, ATA DISK drive
hdb: TSSTcorpCD/DVDW TS-H552B, ATAPI CD/DVD-ROM drive
hda: UDMA/100 mode selected
hdb: UDMA/33 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
aic7xxx 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
scsi8 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
        <Adaptec 2930CU SCSI adapter>
        aic7860: Ultra Single Channel A, SCSI Id=7, 3/253 SCBs

scsi 8:0:0:0: Direct-Access     SEAGATE  ST15150N         5052 PQ: 0 ANSI: 2
scsi8:A:0:0: Tagged Queuing enabled.  Depth 32
 target8:0:0: Beginning Domain Validation
 target8:0:0: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
 target8:0:0: Domain Validation skipping write tests
 target8:0:0: Ending Domain Validation
scsi 8:0:2:0: Sequential-Access ARCHIVE  Python 01931-XXX 5.63 PQ: 0 ANSI: 2
 target8:0:2: Beginning Domain Validation
 target8:0:2: FAST-10 SCSI 7.8 MB/s ST (128 ns, offset 15)
 target8:0:2: Domain Validation skipping write tests
 target8:0:2: Ending Domain Validation
FATAL: Module fan not found.
BIOS EDD facility v0.16 2004-Jun-25, 4 devices found
sky2 driver version 1.22
sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 5
sky2 0000:04:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
sky2 eth0: addr 00:e0:4d:7a:8c:ee
Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
Copyright (c) 1999-2006 Intel Corporation.
Creating device nodes with udev
Driver 'sd' needs updating - please use bus_type methods
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
ohci_hcd 0000:00:13.0: OHCI Host Controller
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
sd 2:0:0:0: [sda] Attached SCSI disk
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 >
ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe02e000
sd 3:0:0:0: [sdb] Attached SCSI disk
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdc] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
sd 8:0:0:0: [sdd] READ CAPACITY failed
sd 8:0:0:0: [sdd] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 8:0:0:0: [sdd] Sense Key : Medium Error [current]
sd 8:0:0:0: [sdd] Add. Sense: Medium format corrupted
sd 8:0:0:0: [sdd] Write Protect is off
sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 8:0:0:0: [sdd] Attached SCSI disk
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb1: SerialNumber: 0000:00:13.0
ehci_hcd 0000:00:13.5: PCI INT D -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.5: EHCI Host Controller
ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.5: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.5: debug port 1
usb 1-1: new full speed USB device using ohci_hcd and address 2
ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28.3-250Hz ehci_hcd
usb usb2: SerialNumber: 0000:00:13.5
ohci_hcd 0000:00:13.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe02d000
usb usb3: configuration #1 chosen from 1 choice
usb 1-1: device not accepting address 2, error -62
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 1-0:1.0: unable to enumerate USB device on port 1
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb3: SerialNumber: 0000:00:13.1
ohci_hcd 0000:00:13.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.2: OHCI Host Controller
ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe02c000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
usb 2-1: new high speed USB device using ehci_hcd and address 2
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb4: SerialNumber: 0000:00:13.2
usb 2-1: configuration #1 chosen from 1 choice
usb 2-1: New USB device found, idVendor=03f0, idProduct=5111
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: Photosmart 3200 series
usb 2-1: Manufacturer: HP
usb 2-1: SerialNumber: MY5B98310Z045K
ohci_hcd 0000:00:13.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ohci_hcd 0000:00:13.3: OHCI Host Controller
ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe02b000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb usb5: SerialNumber: 0000:00:13.3
usb 1-2: new full speed USB device using ohci_hcd and address 4
ohci_hcd 0000:00:13.4: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.4: OHCI Host Controller
ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe02a000
usb 1-2: device descriptor read/64, error -62
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28.3-250Hz ohci_hcd
usb 1-2: device descriptor read/64, error -62
usb usb6: SerialNumber: 0000:00:13.4
Waiting for device /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5 to appear:  ok
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
fsck 1.40.8 (13-Mar-2008)
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/dusb 1-2: new full speed USB device using ohci_hcd and address 5
isk/by-id/ata-ST3320620AS_6QF4HDV5-part5
usb 1-2: device descriptor read/64, error -62
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5: Superblock last kjournald starting.  Commit interval 5 seconds
write time is inEXT3 FS on sda5,  the future.  FIinternal journal
XED.
/dev/diskEXT3-fs: mounted filesystem with ordered data mode.
/by-id/ata-ST3320620AS_6QF4HDV5-part5: clean, 346619/3280320 files, 4787045/6554512 blocks
fsck succeeded. Mounting root device read-write.
Mounting root /dev/disk/by-id/ata-ST3320620AS_6Qusb 1-2: device descriptor read/64, error -62
F4HDV5-part5
usb 1-2: new full speed USB device using ohci_hcd and address 6
INIT: version 2.86 booting
usb 1-2: device not accepting address 6, error -62
usb 1-2: new full speed USB device using ohci_hcd and address 7
System Boot Control: Running /etc/init.d/boot
Mounting procfs at /proc                                              sb 1-2: device not accepting address 7, error -62
mdone                   ub 1-0:1.0: unable to enumerate USB device on port 2
h
Mounting sysfs at /sys                                                done
Mounting debugfs at /sys/kernel/debug                                 done
Initializing /dev                                                     done
Mounting devpts at /dev/pts                                           done
                                                                      done
Starting udevd: sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 3:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:0:0: Attached scsi generic sg2 type 0
sd 8:0:0:0: Attached scsi generic sg3 type 0
scsi 8:0:2:0: Attached scsi generic sg4 type 1
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
0000:02:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:0f:09:1b
st: Version 20080504, fixed bufsize 32768, s/g segs 256
0000:02:00.0: eth1: Intel(R) PRO/1000 Network Connection
0000:02:00.0: eth1: MAC: 1, PHY: 4, PBA No: d50854-003
Driver 'st' needs updating - please use bus_type methods
st 8:0:2:0: Attached scsi tape st0
st 8:0:2:0: st0: try direct i/o: yes (alignment 4 B)
Linux agpgart interface v0.103
Initializing USB Mass Storage driver...
scsi9 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
ide-gd driver 1.18
hda: max request size: 128KiB
hda: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=65535/16/63
hda: cache flushes supported
 hda: hda1
USB Mass Storage support registered.
usblp0: USB Bidirectional printer dev 2 if 1 alt 0 proto 2 vid 0x03F0 pid 0x5111
rtc_cmos 00:04: RTC can wake from S4
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
usbcore: registered new interface driver usblp
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
Driver 'osst' needs updating - please use bus_type methods
ide-cd driver 5.00
ide-cd: hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
IT8718 SuperIO detected.
parport_pc 00:0a: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ppdev: user-space parallel port driver
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
                                                                      done
Loading required kernel modules                                       done
Activating swap-devices in /etc/fstab...
Adding 8393952k swap on /dev/sda2.  Priority:-1 extents:1 across:8393952k
Adding 8393952k swap on /dev/sdb2.  Priority:-2 extents:1 across:83939done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
mount: according to mtab, /dev/sda5 is already mounted on /

Setting up the hardware clock                                         done
Activating device mapper...
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
                                                                      done
Checking file systems...
fsck 1.40.8 (13-Mar-2008)
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /11.1] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part5
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part5: clean, 244963/1640160 files, 1886024/6554512 blocks
[/sbin/fsck.ext3 (1) -- /boot] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part1
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part1: clean, 141/131616 files, 97801/263056 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part6
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part6: clean, 84104/5903072 files, 1455969/11797726 blocks
[/sbin/fsck.ext3 (1) -- /misc] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part7
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part7: clean, 10/8536064 files, 313923/17040940 blocks
[/sbin/fsck.ext3 (1) -- /usr/local] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part8
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part8: clean, 10111/656000 files, 562964/1311297 blocks
[/sbin/fsck.ext3 (1) -- /usr/src] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part9
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part9: clean, 988853/6557152 files, 10060855/13109032 blocks
[/sbin/fsck.ext3 (1) -- /misc1] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part10
/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part10: clean, 13/12992512 files, 455787/25967056 blocks
[/sbin/fsck.ext3 (1) -- /11.1/boot] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part1
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part1: clean, 50/65808 files, 23165/263056 blocks
[/sbin/fsck.ext3 (1) -- /11.1/home] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part6
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part6: clean, 85254/2951536 files, 1459985/11797726 blocks
[/sbin/fsck.ext3 (1) -- /11.1/misc] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part7
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part7: clean, 10/4268032 files, 313922/17040940 blocks
[/sbin/fsck.ext3 (1) -- /11.1/usr/local] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part8
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part8: clean, 10114/328000 files, 562986/1311297 blocks
[/sbin/fsck.ext3 (1) -- /11.1/usr/src] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part9
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part9: clean, 224708/3278576 files, 2125826/13109032 blocks
[/sbin/fsck.ext3 (1) -- /11.1/misc1] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part10
scsi 9:0:0:0: Direct-Access     HP       Photosmart 3210  1.00 PQ: 0 ANSI: 2
sd 9:0:0:0: [sde] Attached SCSI removable disk
sd 9:0:0:0: Attached scsi generic sg5 type 0
/dev/disk/by-id/ata-ST3320620AS_6QF4HZYT-part10: clean, 11/6496256 files, 455784/25967056 blocks
[/sbin/fsck.ext3 (1) -- /local] fsck.ext3 -a /dev/disk/by-id/ata-ST3320620AS_6QF4HDWN-part1
/dev/disk/by-id/ata-ST3320620AS_6QF4HDWN-part1: clean, 1673848/39075840 files, 21295338/78142160 blocks
[/sbin/fsck.ext3 (1) -- /lcrs] fsck.ext3 -a /dev/disk/by-id/ata-ST3120023A_3KA0P431-part1
/dev/disk/by-id/ata-ST3120023A_3KA0P431-part1: clean, 32325/14663680 files, 24187969/29302552 blloop: module loaded
ocks                                                                  done
journald starting.  Commit interval 5 seconds
XT3 FS odointernal journal
ne
EXT3-fs: mounted filesystem with ordered data mode.
Mounting local file systems...
kjournald starting.  Commit interval 5 seconds
proc on /proc tyEXT3 FS on sda6, internal journal
pe proc (rw)
syEXT3-fs: mounted filesystem with ordered data mode.
sfs on /sys type sysfs (rw)
debkjournald starting.  Commit interval 5 seconds
ugfs on /sys/kerEXT3 FS on sda7, internal journal
nel/debug type dEXT3-fs: mounted filesystem with ordered data mode.
ebugfs (rw)
udev on /dev type tmpfs (rw)
devptkjournald starting.  Commit interval 5 seconds
s on /dev/pts tyEXT3 FS on sda8, pe devpts (rw,mointernal journal
de=0620,gid=5)
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sda1 on /boot type ext3 (rw,acl,user_xattr)kjournald starting.  Commit interval 5 seconds

/dev/sda6 on /EXT3 FS on sda9, internal journal
home type ext3 (EXT3-fs: mounted filesystem with ordered data mode.
rw,acl,user_xattr)
/dev/sda7 on /misc type ext3 (rw,acl,user_xakjournald starting.  Commit interval 5 seconds
ttr)
/dev/sda8 EXT3 FS on sda10, internal journal
on /usr/local tyEXT3-fs: mounted filesystem with ordered data mode.
pe ext3 (rw,acl,user_xattr)
/dev/sda9 on /usr/src type ext3 (rw,acl,user_xattr)kjournald starting.  Commit interval 5 seconds

/dev/sda10 on EXT3 FS on sdb5, internal journal
/misc1 type ext3EXT3-fs: mounted filesystem with ordered data mode.
 (rw,acl,user_xattr)
/dev/sdb5 on /11.1 type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb1 on /11.1/boot type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb6 on /11.1/home type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb7 on /11.1/misc type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb8 on /11.1/usr/local type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb9 on /11.1/usr/src type ext3 (rw,acl,user_xattr)
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb10, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb10 on /11.1/misc1 type ext3 (rw,acl,userkjournald starting.  Commit interval 5 seconds
_xattr)
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdc1 on /local type ext3 (rkjournald starting.  Commit interval 5 seconds
w,acl,user_xattrEXT3 FS on hda1, )
internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/hda1 on /lcrs type ext3 (rw,acl,user_xattr)                      done
Retry device configuration:                                           done
Configuring serial ports...
/dev/ttyS0 at 0x03f8 (irq = 4) is a 16550A
Configured serial ports                                               done
fuse init (API version 7.10)
Loading fuse module                                                   done
Mounting fuse control filesystem                                      done
Setting current sysctl status from /etc/sysctl.conf
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.conf.all.rp_filter = 1
fs.inotify.max_user_watches = 65536
net.ipv4.conf.default.promote_secondaries = 1
net.ipv4.conf.all.promote_secondaries = 1
                                                                      done
Mounting securityfs on /sys/kernel/security                           done
ls: cannot access /sys/module/apparmor: No such file or directory
ls: cannot access /sys/module/apparmor: No such file or directory
Loading AppArmor module                                               failed
Enabling syn flood protection                                         done
Disabling IP forwarding                                               done
                                                                      done
Creating /var/log/boot.msg                                            done
showconsole: Warning: the ioctl TIOCGDEV is not known by the kernel
Activating remaining swap-devices in /etc/fstab...                    done
Setting up hostname 'harley'                                          done
Setting up loopback interface     lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8
                                                                      done
System Boot Control: The system has been                              set up
Failed features:                                                             boot.apparmor
Skipped features:                                                                boot.cycle
System Boot Control: Running /etc/init.d/boot.local
Linking /usr/src/linix to /usr/src/linux-2.6.28.3-250Hz
No rtom kernel driver found in /lib/modules/2.6.28.3-250Hz/misc
kernel.shmmax = 81943040                                              done
INIT: Entering runlevel: 5
Boot logging started on /dev/ttyS0(/dev/console) at Fri Feb 20 09:27:00 2009
Master Resource Control: previous runlevel: N, switching to runlevel: 5
mkdir: cannot create directory `/dev/cpuset': File exists
mount: cpuset already mounted or /dev/cpuset busy
mount: according to mtab, cpuset is already mounted on /dev/cpuset
acpid: starting up

Starting resource manager                                             done
Starting acpid                                                        done
Initializing random number generator                                  done
acpid: 1 rule loaded

Starting D-Bus daemonStarting syslog services                         done
                                                                      done
Starting ConsoleKit                                                   done
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
Loading CPUFreq modules (CPUFreq not supported)
Starting HAL daemonip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
Starting Firewall Initialization (phase 1 of 2)                       done
                                                                      done
Setting up network interfaces:
    lo
    lo        IP address: 127.0.0.1/8
              IP address: 127.0.0.2/8                                 done
    eth0      device: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 13)
    eth0      IP address: 10.10.10.100/24                             done
    eth1      device: Intel Corporation 82572EI Gigabit Ethernet Controller (Copper) (rev 06)
    eth1      IP address: 192.168.10.100/24                           done
Waiting for mandatory devices:  eth2 eth3 __NSC__
19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0
    eth2                                No interface found            failed
    eth3                                No interface found            failed
Setting up service network  .  .  .  .  .  .  .  .  .  .  .  .  .  .  failed
Starting service kdm                                                  done
Mount CIFS File Systems                                               unused
VMware Server is installed, but it has not been (correctly) configured
for the running kernel. To (re-)configure it, invoke the
following command: /usr/bin/vmware-config.pl.

Starting RPC portmap daemon                                           done
Loading Module rfm2g.
=========================================================
COPYRIGHT NOTICE
Copyright (C) 2002, 2004 GE Fanuc Embedded Systems, Inc.
International Copyright Secured.  All Rights Reserved.
=========================================================

cat: /proc/rfm2g: No such file or directory
/etc/init.d/rfm2g_init: line 84: [: 0: unary operator expected
chmod: cannot access `/dev/rfm2g[0-4]': No such file or directory
                                                                      failed
Starting auditd                                                       done
Starting SSH daemon                                                   done
Starting cupsd                                                        done
Starting Avahi daemon.                                                done
Starting Avahi DNS Configuration daemon                               done
Initializing gpib boards
FATAL: Module tnt4882 not found.
failed to open device file '/dev/gpib0'
main: No such file or directory
failed to open device file '/dev/gpib1'
main: No such file or directory
                                                                      failed
Loading keymap i386/qwerty/us.map.gz                                  done
Clearing PCIRMS Sram Memory
prm_clear_sram: prm_mmap_open failed: No such device
PCIRMS Board 0 SRAM Cleared with option local
                                                                      done
Loading compose table latin1.add                                      done
Start Unicode mode                                                    done
Loading console font lat9w-16.psfu  -m trivial G0:loadable            done
ntpd: time slew +0.025589s
Starting network time protocol daemon (NTPD)                          done
Starting Name Service Cache Daemon                                    done
Starting mail service (Postfix)                                       done
Starting CRON daemon                                                  done
Starting Firewall Initialization (phase 2 of 2) SuSEfirewall2: Warning: no default firewall zone defined, assuming 'ext'
                                                                      done
                                                                      done
Master Resource Control: runlevel 5 has been                          reached
Failed services in runlevel 5:                                            network vmware gpib rfm2g_init
Skipped services in runlevel 5: smbfs prm prm_dmatest prm_healthy splash

                                                                     Offline


--------------020207030106080801090908--
