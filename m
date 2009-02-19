Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZBSKhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZBSKhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 05:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZBSKhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 05:37:08 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:62415 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbZBSKhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 05:37:03 -0500
Message-ID: <499D364C.3010704@cfl.rr.com>
Date: Thu, 19 Feb 2009 05:37:00 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Mark Hounschell <markh@compro.net>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net> <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com> <20090209141841.GA31643@aftab> <49904BED.7090208@cfl.rr.com> <499C0913.9050905@compro.net> <20090218141843.GB13304@aftab> <499C3DED.1090807@cfl.rr.com> <20090218174243.GD13304@aftab> <499C7AC8.4080609@cfl.rr.com>
In-Reply-To: <499C7AC8.4080609@cfl.rr.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> Borislav Petkov wrote:

snip.


>>> Checking if this processor honours the WP bit even in supervisor mode...Ok.
>>> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
>>> HPET0 prog. values: now 20642, delta 14318, cfg: 0x15c,
>>> HPET: 4 timers in total, 0 timers will be used for per-cpu timer
>>> Calibrating delay loop (skipped), value calculated using timer frequency..
>>> 6000.59 BogoMIPS (lpj=3000297)
>>> Security Framework initialized
>>> Mount-cache hash table entries: 512
>>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>>> CPU: L2 Cache: 512K (64 bytes/line)
>>> CPU: Physical Processor ID: 0
>>> CPU: Processor Core ID: 0
>>> using C1E aware idle routine
>>> Checking 'hlt' instruction...
>> now if you retry the same thing, does the machine hang with the exact
>> same output/at the exact same place in the boot process or it differs
>> each time?
>>
> 
> Yes, now it does. I've done it about 5 times. Same...
> 
> Mark

If I make the check_hlt routine just return I get what _appears_ to be what you
need to see.


BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #5 SMP PREEMPT Thu Feb9
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
RAMDISK: 374cf000 - 37fef40f
Allocated new RAMDISK: 004a7000 - 00fc740f
Move RAMDISK from 00000000374cf000 - 0000000037fef40e to 004a7000 - 00fc740e
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
  #7 [00004a7000 - 0000fc740f]      NEW RAMDISK ==> [00004a7000 - 0000fc740f]
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
Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5
hwprobe=-modules.pata apm=off selinux=0 noresume splash=silent apic=debug console=g
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 3000.183 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3103452k/3145600k available (1835k kernel code, 40788k reserved, 1099k
data, 276k init, 2236296k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02caf97 - 0xc03ddc4c   (1099 kB)
      .text : 0xc0100000 - 0xc02caf97   (1835 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
HPET0 prog. values: now 1131, delta 14318, cfg: 0x15c,
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency..
6000.36 BogoMIPS (lpj=3000183)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using C1E aware idle routine
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
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 2) ...
....... failed.
...trying to set up timer as Virtual Wire IRQ...
..... failed.
...trying to set up timer as ExtINT IRQ...
..... failed :(.
Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug
and send a report.  Then try booting with the 'noapic' option.

------------[ cut here ]------------
WARNING: at kernel/smp.c:333 smp_call_function_mask+0x2c/0x17d()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.28.3-1000Hz #5
Call Trace:
 [<c011e9cd>] warn_on_slowpath+0x40/0x61
 [<c01d6ddd>] delay_tsc+0x6c/0x87
 [<c01d6d00>] __const_udelay+0x19/0x2d
 [<c0233a77>] wait_for_xmitr+0x33/0x74
 [<c01d6ddd>] delay_tsc+0x6c/0x87
 [<c01d6d13>] __const_udelay+0x2c/0x2d
 [<c0233a77>] wait_for_xmitr+0x33/0x74
 [<c02c7304>] _spin_unlock+0xc/0x1f
 [<c02c7122>] _spin_lock_irqsave+0x11/0x2a
 [<c0131116>] up+0x9/0x2a
 [<c010d48e>] stop_this_cpu+0x0/0x30
 [<c0139985>] smp_call_function_mask+0x2c/0x17d
 [<c010d48e>] stop_this_cpu+0x0/0x30
 [<c011f3e2>] vprintk+0x27e/0x2b4
 [<c013ead4>] crash_kexec+0xa9/0xb0
 [<c011f3e2>] vprintk+0x27e/0x2b4
 [<c02c7122>] _spin_lock_irqsave+0x11/0x2a
 [<c010d48e>] stop_this_cpu+0x0/0x30
 [<c0139af8>] smp_call_function+0x22/0x47
 [<c010d482>] native_smp_send_stop+0x18/0x24
 [<c02c526d>] panic+0x51/0xdf
 [<c03f155d>] setup_IO_APIC+0xac4/0xaf8
 [<c01d6ddd>] delay_tsc+0x6c/0x87
 [<c0233a00>] serial8250_verify_port+0xb/0x35
 [<c02c7304>] _spin_unlock+0xc/0x1f
 [<c02c7122>] _spin_lock_irqsave+0x11/0x2a
 [<c0131116>] up+0x9/0x2a
 [<c02c72a1>] _spin_unlock_irqrestore+0xe/0x21
 [<c011ef7c>] release_console_sem+0x16d/0x19a
 [<c011f3e2>] vprintk+0x27e/0x2b4
 [<c02c6fe4>] _spin_lock+0xd/0x23
 [<c02c5309>] printk+0xe/0x15
 [<c02c3c65>] setup_local_APIC+0x16e/0x207
 [<c010e789>] setup_apic_nmi_watchdog+0x1e/0x81
 [<c03ed93a>] native_smp_prepare_cpus+0x3ab/0x441
 [<c03e31f0>] kernel_init+0x43/0x144
 [<c03e31ad>] kernel_init+0x0/0x144
 [<c010464b>] kernel_thread_helper+0x7/0x10
---[ end trace 4eaa2a86a8e2da22 ]---




Here is the same part of the log with a 250Hz kernel that does boot. (without
your little printk patch though)


BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Fri
Feb 9
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
RAMDISK: 375a8000 - 37fef479
Allocated new RAMDISK: 004a7000 - 00eee479
Move RAMDISK from 00000000375a8000 - 0000000037fef478 to 004a7000 - 00eee478
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
Kernel command line: root=/dev/disk/by-id/ata-ST3320620AS_6QF4HDV5-part5
hwprobe=-modules.pata apm=off selinux=0 noresume splash=silent apic=debug console=g
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration matches PMTIMER. 1 loops
Detected 3000.243 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3104320k/3145600k available (1835k kernel code, 39920k reserved, 1095k
data, 276k init, 2236296k highmem)
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
HPET: 4 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency..
6000.48 BogoMIPS (lpj=12000972)
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
..... CPU clock speed is 3000.0687 MHz.
..... host bus clock speed is 200.0045 MHz.
Booting processor 1 APIC 0x1 ip 0x6000




Regards
Mark
