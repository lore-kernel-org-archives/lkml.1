Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZKLX4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZKLX4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZKLX4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:56:42 -0500
Received: from lucidpixels.com ([75.144.35.66]:40531 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618AbZKLX4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:56:37 -0500
Date: Thu, 12 Nov 2009 18:56:41 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Thomas Gleixner <tglx@linutronix.de>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Venkatesch Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan> <1258069232.14894.9.camel@localhost.localdomain> <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Nov 2009, Thomas Gleixner wrote:

> On Thu, 12 Nov 2009, john stultz wrote:
>
>> Forgot to CC lkml, re-adding.
>
> Added more CCs
>
>> On Thu, 2009-11-12 at 18:25 -0500, Justin Piszcz wrote:
>>> On Thu, 12 Nov 2009, john stultz wrote:
>>>> On Thu, Nov 12, 2009 at 8:33 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>>>> On Thu, 12 Nov 2009, Justin Piszcz wrote:
>>>>>> On Wed, 11 Nov 2009, Justin Piszcz wrote:
>>>>>> Again, the problem:
>>>>>> [    3.318770] cpuidle: using governor ladder
>>>>>> [    3.321556] ------------[ cut here ]------------
>>>>>> [    3.321560] WARNING: at arch/x86/kernel/hpet.c:390
>>>>>> hpet_next_event+0x70/0x80()
>>>>>> [    3.321561] Hardware name:
>>>>>> [    3.321562] Modules linked in:
>>>>>> [    3.321564] Pid: 0, comm: swapper Not tainted 2.6.31.5 #17
>>>>>> [    3.321565] Call Trace:
>>>>>> [    3.321567]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>>>>>> [    3.321568]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>>>>>> [    3.321571]  [<ffffffff81056724>] ? warn_slowpath_common+0x74/0xd0
>>>>>> [    3.321573]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>>>>>> [    3.321576]  [<ffffffff81077696>] ? tick_dev_program_event+0x36/0xb0
>>>>>> [    3.321578]  [<ffffffff81077079>] ?
>>>>>> tick_broadcast_oneshot_control+0x119/0x120
>>>>>> [    3.321579]  [<ffffffff8107683d>] ? tick_notify+0x22d/0x420
>>>>>> [    3.321581]  [<ffffffff8106fe37>] ? notifier_call_chain+0x37/0x70
>>>>>> [    3.321583]  [<ffffffff8107612b>] ? clockevents_notify+0x2b/0x90
>>>>>> [    3.321586]  [<ffffffff81244848>] ? acpi_idle_enter_bm+0x15f/0x2d3
>>>>>> [    3.321587]  [<ffffffff812446de>] ? acpi_idle_enter_c1+0xf1/0xfc
>>>>>> [    3.321590]  [<ffffffff812e6d7a>] ? cpuidle_idle_call+0xba/0x120
>>>>>> [    3.321593]  [<ffffffff8102b832>] ? cpu_idle+0x62/0xc0
>>>>>> [    3.321596] ---[ end trace cac202f11005305c ]---
>>>>>> [    3.553852] cpuidle: using governor menu
>>>>>
>>>>> Other user with this problem:
>>>>> http://lkml.org/lkml/2009/10/2/330 - Nobody responded to his report.
>>>>>
>>>>> This has been also been reported on other forums with no fix / conclusion on
>>>>> any type of fix or work-around.
>>>>
>>>> Looks like your hpet is busted, or maybe something is resetting the
>>>> hpet at exactly the wrong time.
>>>>
>>>> What does booting with the attached patch do?
>>>
>>> Unfortunately I cannot login fast enough to get a full dmesg:
>>
>> So if you comment out the printk I added, does it boot?
>>
>>> It continually scrolls with this:
>>>
>>> [   11.463500] hpet_next_event: hpet_writel failed: 0x9c90955 != 0xa0e8b7b
>>> [   11.463972] hpet_next_event: hpet_writel failed: 0xa0e8b7b != 0x9cb9398
>>> [   11.475121] hpet_next_event: hpet_writel failed: 0x9cb9398 != 0xa0e8b71
>>> [   11.475144] hpet_next_event: hpet_writel failed: 0xa0e8b71 != 0x9ce0459
>>> [   11.486274] hpet_next_event: hpet_writel failed: 0x9ce0459 != 0xa0e8b61
>>> [   11.486343] hpet_next_event: hpet_writel failed: 0xa0e8b61 != 0x9d076c0
>>> [   11.497492] hpet_next_event: hpet_writel failed: 0x9d076c0 != 0xa0e8b4c
>>> [   11.497962] hpet_next_event: hpet_writel failed: 0xa0e8b4c != 0x9d30119
>>> [   11.509111] hpet_next_event: hpet_writel failed: 0x9d30119 != 0xa0e8b3c
>>> [   11.509134] hpet_next_event: hpet_writel failed: 0xa0e8b3c != 0x9d571a9
>>> [   11.520275] hpet_next_event: hpet_writel failed: 0x9d571a9 != 0xa0e8b2f
>>> [   11.520293] hpet_next_event: hpet_writel failed: 0xa0e8b2f != 0x9d7e24d
>>> [   11.531443] hpet_next_event: hpet_writel failed: 0x9d7e24d != 0xa0e8b1d
>>> [   11.531947] hpet_next_event: hpet_writel failed: 0xa0e8b1d != 0x9da6e46
>>> [   11.543095] hpet_next_event: hpet_writel failed: 0x9da6e46 != 0xa0e8b0c
>>
>> Huh. That's sort of crazy. It almost seems as though you have two offset
>> HPET timers at one timer location that are switching back and forth.
>> Looks like either very busted hardware, or something new the kernel
>> doesn't expect.
>>
>>> When I do not load processor.ko though, the error does not occur?
>
> Please boot w/o loading that module and post your full bootlog.
>
> Thanks,
>
> 	tglx
>

Hi,

Booting without loading the module or having it compiled in (the result is 
the same either way), the full boot log is below:

Link:
http://home.comcast.net/~jpiszcz/2009112/dmesg-full-boot-log-without-processor-module.txt

The log itself:
[    0.000000] Linux version 2.6.31.5 (root@p34) (gcc version 4.3.4 (Debian 4.3.4-5) ) #24 SMP Thu Nov 12 18:35:10 EST 2009
[    0.000000] Command line: BOOT_IMAGE=2.6.31.5-24 ro root=812 3w-9xxx.use_msi=1 reboot=a snd_hda_intel.enable_msi=1
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf671000 (usable)
[    0.000000]  BIOS-e820: 00000000cf671000 - 00000000cf6bf000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf6bf000 - 00000000cf6ee000 (usable)
[    0.000000]  BIOS-e820: 00000000cf6ee000 - 00000000cf7bf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf7bf000 - 00000000cf7e4000 (usable)
[    0.000000]  BIOS-e820: 00000000cf7e4000 - 00000000cf7f1000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf7f1000 - 00000000cf7f2000 (usable)
[    0.000000]  BIOS-e820: 00000000cf7f2000 - 00000000cf7ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf7ff000 - 00000000cf800000 (usable)
[    0.000000]  BIOS-e820: 00000000cf800000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] DMI 2.5 present.
[    0.000000] last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask F00000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcf800 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cf800000
[    0.000000]  0000000000 - 00cf800000 page 2M
[    0.000000] kernel direct mapping tables up to cf800000 @ 8000-d000
[    0.000000] init_memory_mapping: 0000000100000000-0000000230000000
[    0.000000]  0100000000 - 0230000000 page 2M
[    0.000000] kernel direct mapping tables up to 230000000 @ b000-15000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000cf7fd120 0006C (v01 INTEL  KBIBX10J 00000F26      01000013)
[    0.000000] ACPI: FACP 00000000cf7fc000 000F4 (v03 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: DSDT 00000000cf7f8000 03D03 (v02 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: FACS 00000000cf76c000 00040
[    0.000000] ACPI: APIC 00000000cf7f7000 000BC (v02 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: WDDT 00000000cf7f6000 00040 (v01 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: MCFG 00000000cf7f5000 0003C (v01 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: ASF! 00000000cf7f4000 000A5 (v32 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: HPET 00000000cf7f3000 00038 (v01 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: WDTx 00000000cf7f0000 00224 (v02 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: SSDT 00000000cf7e5000 0A0FC (v01 INTEL  SSDT  PM 00000F26 MSFT 0100000D)
[    0.000000] ACPI: ASPT 00000000cf7f2000 00034 (v05 INTEL  PerfTune 00000F26 MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0230000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 00016040ac]    TEXT DATA BSS ==> [0001000000 - 00016040ac]
[    0.000000]   #3 [000009e400 - 0000100000]    BIOS reserved ==> [000009e400 - 0000100000]
[    0.000000]   #4 [0001605000 - 000160515e]              BRK ==> [0001605000 - 000160515e]
[    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
[    0.000000]   #6 [000000b000 - 0000010000]          PGTABLE ==> [000000b000 - 0000010000]
[    0.000000]  [ffffea0000000000-ffffea0007bfffff] PMD -> [ffff880028600000-ffff88002f7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00230000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[7] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000008f
[    0.000000]     0: 0x00000100 -> 0x000cf671
[    0.000000]     0: 0x000cf6bf -> 0x000cf6ee
[    0.000000]     0: 0x000cf7bf -> 0x000cf7e4
[    0.000000]     0: 0x000cf7f1 -> 0x000cf7f2
[    0.000000]     0: 0x000cf7ff -> 0x000cf800
[    0.000000]     0: 0x00100000 -> 0x00230000
[    0.000000] On node 0 totalpages: 2094678
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 108 pages reserved
[    0.000000]   DMA zone: 3819 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 831231 pages, LIFO batch:31
[    0.000000]   Normal zone: 17024 pages used for memmap
[    0.000000]   Normal zone: 1228160 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:28000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 24 pages at ffff880028034000, static data 67744 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063210
[    0.000000] Kernel command line: BOOT_IMAGE=2.6.31.5-24 ro root=812 3w-9xxx.use_msi=1 reboot=a snd_hda_intel.enable_msi=1
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 8175616k/9175040k available (3874k kernel code, 796328k absent, 202212k reserved, 1524k data, 372k init)
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2933.315 MHz processor.
[    0.000028] Console: colour dummy device 80x25
[    0.000029] console [tty0] enabled
[    0.000232] hpet clockevent registered
[    0.000246] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    0.000254] Calibrating delay loop (skipped), value calculated using timer frequency.. 5866.63 BogoMIPS (lpj=2933315)
[    0.000285] Mount-cache hash table entries: 256
[    0.000344] CPU: Physical Processor ID: 0
[    0.000346] CPU: Processor Core ID: 0
[    0.000349] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000351] CPU: L2 cache: 256K
[    0.000352] CPU: L3 cache: 8192K
[    0.000355] mce: CPU supports 9 MCE banks
[    0.000362] CPU0: Thermal monitoring enabled (TM1)
[    0.000365] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 SHD:8
[    0.000371] using mwait in idle threads.
[    0.000378] Freeing SMP alternatives: 30k freed
[    0.000386] ACPI: Core revision 20090521
[    0.012830] Setting APIC routing to flat
[    0.013204] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.023204] CPU0: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.124270] Booting processor 1 APIC 0x1 ip 0x6000
[    0.134856] Initializing CPU#1
[    0.195187] Calibrating delay using timer specific routine.. 5865.74 BogoMIPS (lpj=2932872)
[    0.195192] CPU: Physical Processor ID: 0
[    0.195193] CPU: Processor Core ID: 0
[    0.195195] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.195196] CPU: L2 cache: 256K
[    0.195197] CPU: L3 cache: 8192K
[    0.195199] mce: CPU supports 9 MCE banks
[    0.195206] CPU1: Thermal monitoring enabled (TM1)
[    0.195208] CPU 1 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.195804] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.196391] CPU1: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.196414] Skipping synchronization checks as TSC is reliable.
[    0.196470] Booting processor 2 APIC 0x2 ip 0x6000
[    0.206700] Initializing CPU#2
[    0.267156] Calibrating delay using timer specific routine.. 5865.76 BogoMIPS (lpj=2932882)
[    0.267161] CPU: Physical Processor ID: 0
[    0.267162] CPU: Processor Core ID: 1
[    0.267163] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.267164] CPU: L2 cache: 256K
[    0.267165] CPU: L3 cache: 8192K
[    0.267166] mce: CPU supports 9 MCE banks
[    0.267173] CPU2: Thermal monitoring enabled (TM1)
[    0.267175] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.267673] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.268181] CPU2: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.268202] Skipping synchronization checks as TSC is reliable.
[    0.268254] Booting processor 3 APIC 0x3 ip 0x6000
[    0.278588] Initializing CPU#3
[    0.339126] Calibrating delay using timer specific routine.. 5865.76 BogoMIPS (lpj=2932884)
[    0.339130] CPU: Physical Processor ID: 0
[    0.339131] CPU: Processor Core ID: 1
[    0.339133] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.339133] CPU: L2 cache: 256K
[    0.339134] CPU: L3 cache: 8192K
[    0.339136] mce: CPU supports 9 MCE banks
[    0.339143] CPU3: Thermal monitoring enabled (TM1)
[    0.339144] CPU 3 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.339778] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.340469] CPU3: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.340490] Skipping synchronization checks as TSC is reliable.
[    0.340541] Booting processor 4 APIC 0x4 ip 0x6000
[    0.350875] Initializing CPU#4
[    0.411096] Calibrating delay using timer specific routine.. 5865.76 BogoMIPS (lpj=2932884)
[    0.411100] CPU: Physical Processor ID: 0
[    0.411101] CPU: Processor Core ID: 2
[    0.411103] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.411104] CPU: L2 cache: 256K
[    0.411104] CPU: L3 cache: 8192K
[    0.411106] mce: CPU supports 9 MCE banks
[    0.411113] CPU4: Thermal monitoring enabled (TM1)
[    0.411115] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.411614] x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
[    0.412056] CPU4: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.412076] Skipping synchronization checks as TSC is reliable.
[    0.412131] Booting processor 5 APIC 0x5 ip 0x6000
[    0.422464] Initializing CPU#5
[    0.483066] Calibrating delay using timer specific routine.. 5865.76 BogoMIPS (lpj=2932882)
[    0.483070] CPU: Physical Processor ID: 0
[    0.483071] CPU: Processor Core ID: 2
[    0.483072] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.483073] CPU: L2 cache: 256K
[    0.483073] CPU: L3 cache: 8192K
[    0.483075] mce: CPU supports 9 MCE banks
[    0.483082] CPU5: Thermal monitoring enabled (TM1)
[    0.483084] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.483721] x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
[    0.484445] CPU5: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.484466] Skipping synchronization checks as TSC is reliable.
[    0.484518] Booting processor 6 APIC 0x6 ip 0x6000
[    0.494852] Initializing CPU#6
[    0.555035] Calibrating delay using timer specific routine.. 5865.77 BogoMIPS (lpj=2932885)
[    0.555040] CPU: Physical Processor ID: 0
[    0.555041] CPU: Processor Core ID: 3
[    0.555042] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.555043] CPU: L2 cache: 256K
[    0.555044] CPU: L3 cache: 8192K
[    0.555045] mce: CPU supports 9 MCE banks
[    0.555052] CPU6: Thermal monitoring enabled (TM1)
[    0.555054] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
[    0.555553] x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
[    0.556032] CPU6: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.556055] Skipping synchronization checks as TSC is reliable.
[    0.556107] Booting processor 7 APIC 0x7 ip 0x6000
[    0.566440] Initializing CPU#7
[    0.627005] Calibrating delay using timer specific routine.. 5865.76 BogoMIPS (lpj=2932884)
[    0.627009] CPU: Physical Processor ID: 0
[    0.627010] CPU: Processor Core ID: 3
[    0.627011] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.627012] CPU: L2 cache: 256K
[    0.627013] CPU: L3 cache: 8192K
[    0.627015] mce: CPU supports 9 MCE banks
[    0.627022] CPU7: Thermal monitoring enabled (TM1)
[    0.627023] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
[    0.627659] x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
[    0.628322] CPU7: Intel(R) Core(TM) i7 CPU         870  @ 2.93GHz stepping 05
[    0.628342] Skipping synchronization checks as TSC is reliable.
[    0.628352] Brought up 8 CPUs
[    0.628354] Total of 8 processors activated (46926.97 BogoMIPS).
[    0.628695] NET: Registered protocol family 16
[    0.628829] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.628832] ACPI: bus type pci registered
[    0.628901] PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
[    0.628904] PCI: MCFG area at f8000000 reserved in E820
[    0.630093] PCI: Using MMCONFIG at f8000000 - fbffffff
[    0.630095] PCI: Using configuration type 1 for base access
[    0.631717] bio: create slab <bio-0> at 0
[    0.632214] ACPI: EC: Look up EC in DSDT
[    0.638739] ACPI: Interpreter enabled
[    0.638741] ACPI: (supports S0 S5)
[    0.638748] ACPI: Using IOAPIC for interrupt routing
[    0.641651] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.641752] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.641756] pci 0000:00:03.0: PME# disabled
[    0.641796] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.641799] pci 0000:00:05.0: PME# disabled
[    0.642042] pci 0000:00:19.0: reg 10 32bit mmio: [0xe6600000-0xe661ffff]
[    0.642051] pci 0000:00:19.0: reg 14 32bit mmio: [0xe6624000-0xe6624fff]
[    0.642059] pci 0000:00:19.0: reg 18 io port: [0x7040-0x705f]
[    0.642096] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.642104] pci 0000:00:19.0: PME# disabled
[    0.642158] pci 0000:00:1a.0: reg 10 32bit mmio: [0xe6625c00-0xe6625fff]
[    0.642208] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.642216] pci 0000:00:1a.0: PME# disabled
[    0.642258] pci 0000:00:1b.0: reg 10 64bit mmio: [0xe6620000-0xe6623fff]
[    0.642296] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.642304] pci 0000:00:1b.0: PME# disabled
[    0.642359] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.642367] pci 0000:00:1c.0: PME# disabled
[    0.642425] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.642433] pci 0000:00:1c.4: PME# disabled
[    0.642490] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.642498] pci 0000:00:1c.6: PME# disabled
[    0.642554] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.642562] pci 0000:00:1c.7: PME# disabled
[    0.642617] pci 0000:00:1d.0: reg 10 32bit mmio: [0xe6625800-0xe6625bff]
[    0.642667] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.642675] pci 0000:00:1d.0: PME# disabled
[    0.642844] pci 0000:00:1f.2: reg 10 io port: [0x7068-0x706f]
[    0.642853] pci 0000:00:1f.2: reg 14 io port: [0x7074-0x7077]
[    0.642861] pci 0000:00:1f.2: reg 18 io port: [0x7060-0x7067]
[    0.642870] pci 0000:00:1f.2: reg 1c io port: [0x7070-0x7073]
[    0.642878] pci 0000:00:1f.2: reg 20 io port: [0x7020-0x703f]
[    0.642886] pci 0000:00:1f.2: reg 24 32bit mmio: [0xe6625000-0xe66257ff]
[    0.642916] pci 0000:00:1f.2: PME# supported from D3hot
[    0.642924] pci 0000:00:1f.2: PME# disabled
[    0.642958] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe6626000-0xe66260ff]
[    0.642972] pci 0000:00:1f.3: reg 20 io port: [0x7000-0x701f]
[    0.643014] pci 0000:01:00.0: reg 10 32bit mmio: [0xe5000000-0xe5ffffff]
[    0.643020] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.643027] pci 0000:01:00.0: reg 1c 64bit mmio: [0xe4000000-0xe4ffffff]
[    0.643033] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.643069] pci 0000:00:03.0: bridge 32bit mmio: [0xe4000000-0xe5ffffff]
[    0.643073] pci 0000:00:03.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.643098] pci 0000:02:00.0: reg 10 64bit mmio: [0xe0000000-0xe1ffffff]
[    0.643105] pci 0000:02:00.0: reg 18 64bit mmio: [0xe6500000-0xe6500fff]
[    0.643109] pci 0000:02:00.0: reg 20 io port: [0x6000-0x60ff]
[    0.643116] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.643132] pci 0000:02:00.0: supports D1 D2
[    0.643152] pci 0000:00:05.0: bridge io port: [0x6000-0x6fff]
[    0.643154] pci 0000:00:05.0: bridge 32bit mmio: [0xe6500000-0xe65fffff]
[    0.643158] pci 0000:00:05.0: bridge 64bit mmio pref: [0xe0000000-0xe1ffffff]
[    0.643206] pci 0000:03:00.0: reg 10 64bit mmio: [0xe2000000-0xe3ffffff]
[    0.643220] pci 0000:03:00.0: reg 18 64bit mmio: [0xe6400000-0xe6400fff]
[    0.643230] pci 0000:03:00.0: reg 20 io port: [0x5000-0x50ff]
[    0.643244] pci 0000:03:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.643272] pci 0000:03:00.0: supports D1 D2
[    0.643312] pci 0000:00:1c.0: bridge io port: [0x5000-0x5fff]
[    0.643319] pci 0000:00:1c.0: bridge 32bit mmio: [0xe6400000-0xe64fffff]
[    0.643323] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xe2000000-0xe3ffffff]
[    0.643488] pci 0000:04:00.0: reg 10 32bit mmio: [0xe6380000-0xe639ffff]
[    0.643513] pci 0000:04:00.0: reg 14 32bit mmio: [0xe6300000-0xe637ffff]
[    0.643539] pci 0000:04:00.0: reg 18 io port: [0x4000-0x401f]
[    0.643564] pci 0000:04:00.0: reg 1c 32bit mmio: [0xe63a0000-0xe63a3fff]
[    0.643636] pci 0000:04:00.0: reg 30 32bit mmio: [0xfffc0000-0xffffffff]
[    0.643779] pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
[    0.643793] pci 0000:04:00.0: PME# disabled
[    0.643886] pci 0000:00:1c.4: bridge io port: [0x4000-0x4fff]
[    0.643893] pci 0000:00:1c.4: bridge 32bit mmio: [0xe6300000-0xe63fffff]
[    0.644055] pci 0000:05:00.0: reg 10 32bit mmio: [0xe6280000-0xe629ffff]
[    0.644076] pci 0000:05:00.0: reg 14 32bit mmio: [0xe6200000-0xe627ffff]
[    0.644101] pci 0000:05:00.0: reg 18 io port: [0x3000-0x301f]
[    0.644127] pci 0000:05:00.0: reg 1c 32bit mmio: [0xe62a0000-0xe62a3fff]
[    0.644199] pci 0000:05:00.0: reg 30 32bit mmio: [0xfffc0000-0xffffffff]
[    0.644342] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    0.644355] pci 0000:05:00.0: PME# disabled
[    0.644453] pci 0000:00:1c.6: bridge io port: [0x3000-0x3fff]
[    0.644460] pci 0000:00:1c.6: bridge 32bit mmio: [0xe6200000-0xe62fffff]
[    0.644518] pci 0000:06:00.0: reg 10 io port: [0x2018-0x201f]
[    0.644528] pci 0000:06:00.0: reg 14 io port: [0x2024-0x2027]
[    0.644535] pci 0000:06:00.0: reg 18 io port: [0x2010-0x2017]
[    0.644545] pci 0000:06:00.0: reg 1c io port: [0x2020-0x2023]
[    0.644551] pci 0000:06:00.0: reg 20 io port: [0x2000-0x200f]
[    0.644562] pci 0000:06:00.0: reg 24 32bit mmio: [0xe6100000-0xe61003ff]
[    0.644572] pci 0000:06:00.0: reg 30 32bit mmio: [0xfffc0000-0xffffffff]
[    0.644606] pci 0000:06:00.0: supports D1
[    0.644607] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.644616] pci 0000:06:00.0: PME# disabled
[    0.644659] pci 0000:00:1c.7: bridge io port: [0x2000-0x2fff]
[    0.644666] pci 0000:00:1c.7: bridge 32bit mmio: [0xe6100000-0xe61fffff]
[    0.644721] pci 0000:07:01.0: reg 20 io port: [0x1020-0x103f]
[    0.644749] pci 0000:07:01.0: supports D1 D2
[    0.644750] pci 0000:07:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.644758] pci 0000:07:01.0: PME# disabled
[    0.644810] pci 0000:07:01.1: reg 20 io port: [0x1000-0x101f]
[    0.644837] pci 0000:07:01.1: supports D1 D2
[    0.644838] pci 0000:07:01.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.644847] pci 0000:07:01.1: PME# disabled
[    0.644879] pci 0000:07:01.2: reg 10 32bit mmio: [0xe6004800-0xe60048ff]
[    0.644923] pci 0000:07:01.2: supports D1 D2
[    0.644924] pci 0000:07:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.644932] pci 0000:07:01.2: PME# disabled
[    0.644976] pci 0000:07:03.0: reg 10 32bit mmio: [0xe6004000-0xe60047ff]
[    0.644985] pci 0000:07:03.0: reg 14 32bit mmio: [0xe6000000-0xe6003fff]
[    0.645032] pci 0000:07:03.0: supports D1 D2
[    0.645033] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.645041] pci 0000:07:03.0: PME# disabled
[    0.645081] pci 0000:00:1e.0: transparent bridge
[    0.645089] pci 0000:00:1e.0: bridge io port: [0x1000-0x1fff]
[    0.645096] pci 0000:00:1e.0: bridge 32bit mmio: [0xe6000000-0xe60fffff]
[    0.645129] pci_bus 0000:00: on NUMA node 0
[    0.645132] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.645367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.645453] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.645497] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.645537] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.645577] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7._PRT]
[    0.645625] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    0.645663] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG5._PRT]
[    0.649154] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.649242] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.649328] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *9 10 11 12)
[    0.649411] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *9 10 11 12)
[    0.649495] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
[    0.649576] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
[    0.649661] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 *11 12)
[    0.649745] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
[    0.649918] SCSI subsystem initialized
[    0.649958] usbcore: registered new interface driver usbfs
[    0.649981] usbcore: registered new interface driver hub
[    0.650003] usbcore: registered new device driver usb
[    0.650088] PCI: Using ACPI for IRQ routing
[    0.655058] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    0.655064] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.658023] hpet: hpet2 irq 24 for MSI
[    0.658247] hpet: hpet3 irq 25 for MSI
[    0.658994] hpet: hpet4 irq 26 for MSI
[    0.659328] hpet: hpet5 irq 27 for MSI
[    0.660007] hpet: hpet6 irq 28 for MSI
[    0.662072] Switched to high resolution mode on CPU 0
[    0.662295] Switched to high resolution mode on CPU 1
[    0.662337] Switched to high resolution mode on CPU 7
[    0.662342] Switched to high resolution mode on CPU 5
[    0.662373] Switched to high resolution mode on CPU 3
[    0.663005] Switched to high resolution mode on CPU 6
[    0.663039] Switched to high resolution mode on CPU 2
[    0.663042] Switched to high resolution mode on CPU 4
[    0.664074] pnp: PnP ACPI init
[    0.664086] ACPI: bus type pnp registered
[    0.665258] pnp: PnP ACPI: found 10 devices
[    0.665260] ACPI: ACPI bus type pnp unregistered
[    0.665267] system 00:01: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.665270] system 00:01: iomem range 0xfeb00000-0xfeb03fff has been reserved
[    0.665272] system 00:01: iomem range 0xfed10000-0xfed13fff has been reserved
[    0.665275] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.665277] system 00:01: iomem range 0xfed1b000-0xfed1bfff has been reserved
[    0.665280] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.665282] system 00:01: iomem range 0xfed1a000-0xfed1afff has been reserved
[    0.665285] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.665287] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.665290] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    0.665292] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    0.665295] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    0.665297] system 00:01: iomem range 0xff000000-0xffffffff could not be reserved
[    0.665302] system 00:06: ioport range 0x500-0x57f has been reserved
[    0.665304] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.665307] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.670051] pci 0000:01:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.670055] pci 0000:02:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.670059] pci 0000:03:00.0: BAR 6: no parent found for of device [0xfffe0000-0xffffffff]
[    0.670067] pci 0000:04:00.0: BAR 6: no parent found for of device [0xfffc0000-0xffffffff]
[    0.670070] pci 0000:05:00.0: BAR 6: no parent found for of device [0xfffc0000-0xffffffff]
[    0.670073] pci 0000:06:00.0: BAR 6: no parent found for of device [0xfffc0000-0xffffffff]
[    0.670117] pci 0000:01:00.0: BAR 6: can't allocate mem resource [0xe0000000-0xdfffffff]
[    0.670120] pci 0000:00:03.0: PCI bridge, secondary bus 0000:01
[    0.670122] pci 0000:00:03.0:   IO window: disabled
[    0.670126] pci 0000:00:03.0:   MEM window: 0xe4000000-0xe5ffffff
[    0.670129] pci 0000:00:03.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.670134] pci 0000:00:05.0: PCI bridge, secondary bus 0000:02
[    0.670136] pci 0000:00:05.0:   IO window: 0x6000-0x6fff
[    0.670140] pci 0000:00:05.0:   MEM window: 0xe6500000-0xe65fffff
[    0.670143] pci 0000:00:05.0:   PREFETCH window: 0x000000e0000000-0x000000e1ffffff
[    0.670148] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
[    0.670154] pci 0000:00:1c.0:   IO window: 0x5000-0x5fff
[    0.670163] pci 0000:00:1c.0:   MEM window: 0xe6400000-0xe64fffff
[    0.670170] pci 0000:00:1c.0:   PREFETCH window: 0x000000e2000000-0x000000e3ffffff
[    0.670181] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:04
[    0.670183] pci 0000:00:1c.4:   IO window: 0x4000-0x4fff
[    0.670191] pci 0000:00:1c.4:   MEM window: 0xe6300000-0xe63fffff
[    0.670199] pci 0000:00:1c.4:   PREFETCH window: 0xe6700000-0xe67fffff
[    0.670208] pci 0000:00:1c.6: PCI bridge, secondary bus 0000:05
[    0.670215] pci 0000:00:1c.6:   IO window: 0x3000-0x3fff
[    0.670223] pci 0000:00:1c.6:   MEM window: 0xe6200000-0xe62fffff
[    0.670231] pci 0000:00:1c.6:   PREFETCH window: 0xe6800000-0xe68fffff
[    0.670239] pci 0000:00:1c.7: PCI bridge, secondary bus 0000:06
[    0.670246] pci 0000:00:1c.7:   IO window: 0x2000-0x2fff
[    0.670255] pci 0000:00:1c.7:   MEM window: 0xe6100000-0xe61fffff
[    0.670263] pci 0000:00:1c.7:   PREFETCH window: 0xe6900000-0xe69fffff
[    0.670271] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:07
[    0.670279] pci 0000:00:1e.0:   IO window: 0x1000-0x1fff
[    0.670287] pci 0000:00:1e.0:   MEM window: 0xe6000000-0xe60fffff
[    0.670294] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.670307] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.670311] pci 0000:00:03.0: setting latency timer to 64
[    0.670315] pci 0000:00:05.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.670318] pci 0000:00:05.0: setting latency timer to 64
[    0.670328] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.670333] pci 0000:00:1c.0: setting latency timer to 64
[    0.670342] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.670350] pci 0000:00:1c.4: setting latency timer to 64
[    0.670359] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.670364] pci 0000:00:1c.6: setting latency timer to 64
[    0.670374] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.670379] pci 0000:00:1c.7: setting latency timer to 64
[    0.670388] pci 0000:00:1e.0: setting latency timer to 64
[    0.670394] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.670395] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.670397] pci_bus 0000:01: resource 1 mem: [0xe4000000-0xe5ffffff]
[    0.670398] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xdfffffff]
[    0.670400] pci_bus 0000:02: resource 0 io:  [0x6000-0x6fff]
[    0.670401] pci_bus 0000:02: resource 1 mem: [0xe6500000-0xe65fffff]
[    0.670402] pci_bus 0000:02: resource 2 pref mem [0xe0000000-0xe1ffffff]
[    0.670403] pci_bus 0000:03: resource 0 io:  [0x5000-0x5fff]
[    0.670405] pci_bus 0000:03: resource 1 mem: [0xe6400000-0xe64fffff]
[    0.670406] pci_bus 0000:03: resource 2 pref mem [0xe2000000-0xe3ffffff]
[    0.670407] pci_bus 0000:04: resource 0 io:  [0x4000-0x4fff]
[    0.670408] pci_bus 0000:04: resource 1 mem: [0xe6300000-0xe63fffff]
[    0.670410] pci_bus 0000:04: resource 2 pref mem [0xe6700000-0xe67fffff]
[    0.670411] pci_bus 0000:05: resource 0 io:  [0x3000-0x3fff]
[    0.670412] pci_bus 0000:05: resource 1 mem: [0xe6200000-0xe62fffff]
[    0.670413] pci_bus 0000:05: resource 2 pref mem [0xe6800000-0xe68fffff]
[    0.670415] pci_bus 0000:06: resource 0 io:  [0x2000-0x2fff]
[    0.670416] pci_bus 0000:06: resource 1 mem: [0xe6100000-0xe61fffff]
[    0.670417] pci_bus 0000:06: resource 2 pref mem [0xe6900000-0xe69fffff]
[    0.670418] pci_bus 0000:07: resource 0 io:  [0x1000-0x1fff]
[    0.670420] pci_bus 0000:07: resource 1 mem: [0xe6000000-0xe60fffff]
[    0.670421] pci_bus 0000:07: resource 3 io:  [0x00-0xffff]
[    0.670422] pci_bus 0000:07: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.670463] NET: Registered protocol family 2
[    0.670516] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.670795] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.671388] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.671542] TCP: Hash tables configured (established 262144 bind 65536)
[    0.671545] TCP reno registered
[    0.671609] NET: Registered protocol family 1
[    0.673374] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.673492] NTFS driver 2.1.29 [Flags: R/O].
[    0.673543] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    0.674083] msgmni has been set to 15969
[    0.674136] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.674139] io scheduler noop registered
[    0.674141] io scheduler deadline registered
[    0.674156] io scheduler cfq registered (default)
[    0.696101] pci 0000:01:00.0: Boot video device
[    0.696298] pcieport-driver 0000:00:03.0: irq 29 for MSI/MSI-X
[    0.696303] pcieport-driver 0000:00:03.0: setting latency timer to 64
[    0.696397] pcieport-driver 0000:00:05.0: irq 30 for MSI/MSI-X
[    0.696401] pcieport-driver 0000:00:05.0: setting latency timer to 64
[    0.696500] pcieport-driver 0000:00:1c.0: irq 31 for MSI/MSI-X
[    0.696510] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.696616] pcieport-driver 0000:00:1c.4: irq 32 for MSI/MSI-X
[    0.696625] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.696735] pcieport-driver 0000:00:1c.6: irq 33 for MSI/MSI-X
[    0.696745] pcieport-driver 0000:00:1c.6: setting latency timer to 64
[    0.696859] pcieport-driver 0000:00:1c.7: irq 34 for MSI/MSI-X
[    0.696869] pcieport-driver 0000:00:1c.7: setting latency timer to 64
[    0.697093] aer 0000:00:03.0:pcie02: service driver aer loaded
[    0.697121] aer 0000:00:05.0:pcie02: service driver aer loaded
[    0.697243] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90004100000, using 2560k, total 262144k
[    0.697246] vesafb: mode is 1280x1024x8, linelength=1280, pages=1
[    0.697248] vesafb: scrolling: redraw
[    0.697250] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    0.740267] Console: switching to colour frame buffer device 160x64
[    0.783515] fb0: VESA VGA frame buffer device
[    0.783784] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.784147] ACPI: Power Button [PWRF]
[    0.784361] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.784752] ACPI: Sleep Button [SLPB]
[    0.786233] Linux agpgart interface v0.103
[    0.786790] loop: module loaded
[    0.786974] 3ware 9000 Storage Controller device driver for Linux v2.26.02.012.
[    0.787345] 3w-9xxx 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.787678] 3w-9xxx 0000:02:00.0: setting latency timer to 64
[    1.041983] scsi0 : 3ware 9000 Storage Controller
[    1.042325] 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xe6500000, IRQ: 16.
[    1.347899] 3w-9xxx: scsi0: Firmware FE9X 4.06.00.004, BIOS BE9X 4.05.00.015, Ports: 16.
[    1.348313] 3w-9xxx 0000:02:00.0: irq 35 for MSI/MSI-X
[    1.348622] scsi 0:0:0:0: Direct-Access     AMCC     9650SE-16M DISK  4.06 PQ: 0 ANSI: 5
[    1.356060] 3w-9xxx 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.356419] 3w-9xxx 0000:03:00.0: setting latency timer to 64
[    1.559842] scsi1 : 3ware 9000 Storage Controller
[    1.560175] 3w-9xxx: scsi1: Found a 3ware 9000 Storage Controller at 0xe6400000, IRQ: 16.
[    1.865761] 3w-9xxx: scsi1: Firmware FE9X 4.06.00.004, BIOS BE9X 4.05.00.015, Ports: 4.
[    1.866194] 3w-9xxx 0000:03:00.0: irq 36 for MSI/MSI-X
[    1.866521] scsi 1:0:0:0: Direct-Access     AMCC     9650SE-4LP DISK  4.06 PQ: 0 ANSI: 5
[    1.874897] sd 0:0:0:0: [sda] 25390350336 512-byte logical blocks: (12.9 TB/11.8 TiB)
[    1.874909] firewire_ohci 0000:07:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    1.874958] sd 1:0:0:0: [sdb] 292947968 512-byte logical blocks: (149 GB/139 GiB)
[    1.875390] sd 1:0:0:0: [sdb] Write Protect is off
[    1.875391] sd 1:0:0:0: [sdb] Mode Sense: 23 00 00 00
[    1.875678] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.876501]  sdb: sdb1 sdb2
[    1.877370] sd 0:0:0:0: [sda] Write Protect is off
[    1.877621] sd 0:0:0:0: [sda] Mode Sense: 23 00 00 00
[    1.877924] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.878476] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.880550]  sda: sda1
[    1.910624] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.931741] firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI version 1.10
[    1.932155] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.932475] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.932821] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.932827] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    1.933088] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.937341] ehci_hcd 0000:00:1a.0: debug port 2
[    1.937558] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
[    1.937570] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xe6625c00
[    1.943743] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.944046] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.944365] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.954633] usb usb1: Product: EHCI Host Controller
[    1.965025] usb usb1: Manufacturer: Linux 2.6.31.5 ehci_hcd
[    1.975616] usb usb1: SerialNumber: 0000:00:1a.0
[    1.986360] usb usb1: configuration #1 chosen from 1 choice
[    1.997298] hub 1-0:1.0: USB hub found
[    2.008298] hub 1-0:1.0: 3 ports detected
[    2.019422] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.030910] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.030916] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.042477] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.058232] ehci_hcd 0000:00:1d.0: debug port 2
[    2.070122] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
[    2.070135] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xe6625800
[    2.088947] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.101138] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.113616] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.126297] usb usb2: Product: EHCI Host Controller
[    2.139106] usb usb2: Manufacturer: Linux 2.6.31.5 ehci_hcd
[    2.152117] usb usb2: SerialNumber: 0000:00:1d.0
[    2.165267] usb usb2: configuration #1 chosen from 1 choice
[    2.178608] hub 2-0:1.0: USB hub found
[    2.192024] hub 2-0:1.0: 3 ports detected
[    2.205560] ehci_hcd 0000:07:01.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    2.219474] ehci_hcd 0000:07:01.2: EHCI Host Controller
[    2.233459] ehci_hcd 0000:07:01.2: new USB bus registered, assigned bus number 3
[    2.247749] ehci_hcd 0000:07:01.2: irq 20, io mem 0xe6004800
[    2.267900] ehci_hcd 0000:07:01.2: USB 2.0 started, EHCI 1.00
[    2.281928] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    2.295953] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.309891] usb usb3: Product: EHCI Host Controller
[    2.323646] usb usb3: Manufacturer: Linux 2.6.31.5 ehci_hcd
[    2.337283] usb usb3: SerialNumber: 0000:07:01.2
[    2.350945] usb usb3: configuration #1 chosen from 1 choice
[    2.364663] hub 3-0:1.0: USB hub found
[    2.369625] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.391846] hub 3-0:1.0: 4 ports detected
[    2.405376] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.418908] uhci_hcd: USB Universal Host Controller Interface driver
[    2.432382] uhci_hcd 0000:07:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.432422] firewire_core: created device fw0: GUID 0090270002523482, S400
[    2.459159] uhci_hcd 0000:07:01.0: UHCI Host Controller
[    2.472469] uhci_hcd 0000:07:01.0: new USB bus registered, assigned bus number 4
[    2.483894] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.483895] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.483939] usb 1-1: configuration #1 chosen from 1 choice
[    2.484053] hub 1-1:1.0: USB hub found
[    2.484146] hub 1-1:1.0: 6 ports detected
[    2.550507] uhci_hcd 0000:07:01.0: irq 22, io base 0x00001020
[    2.563201] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    2.575950] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.588581] usb usb4: Product: UHCI Host Controller
[    2.601192] usb usb4: Manufacturer: Linux 2.6.31.5 uhci_hcd
[    2.613909] usb usb4: SerialNumber: 0000:07:01.0
[    2.626503] usb usb4: configuration #1 chosen from 1 choice
[    2.638958] hub 4-0:1.0: USB hub found
[    2.651348] hub 4-0:1.0: 2 ports detected
[    2.663580] uhci_hcd 0000:07:01.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.675906] uhci_hcd 0000:07:01.1: UHCI Host Controller
[    2.688076] uhci_hcd 0000:07:01.1: new USB bus registered, assigned bus number 5
[    2.700390] uhci_hcd 0000:07:01.1: irq 21, io base 0x00001000
[    2.712629] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    2.724980] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.727519] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    2.750027] usb usb5: Product: UHCI Host Controller
[    2.762501] usb usb5: Manufacturer: Linux 2.6.31.5 uhci_hcd
[    2.774993] usb usb5: SerialNumber: 0000:07:01.1
[    2.787511] usb usb5: configuration #1 chosen from 1 choice
[    2.799938] hub 5-0:1.0: USB hub found
[    2.812298] hub 5-0:1.0: 2 ports detected
[    2.824641] Initializing USB Mass Storage driver...
[    2.836999] usbcore: registered new interface driver usb-storage
[    2.841841] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    2.841842] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.841903] usb 2-1: configuration #1 chosen from 1 choice
[    2.842118] hub 2-1:1.0: USB hub found
[    2.842209] hub 2-1:1.0: 8 ports detected
[    2.911937] USB Mass Storage support registered.
[    2.924524] PNP: No PS/2 controller found. Probing ports directly.
[    2.939635] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.952116] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.964420] mice: PS/2 mouse device common for all mice
[    2.976823] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    2.989364] rtc_cmos 00:03: RTC can wake from S4
[    3.001988] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    3.014543] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    3.027291] i2c /dev entries driver
[    3.039885] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.052924] coretemp coretemp.0: Using relative temperature scale!
[    3.065820] coretemp coretemp.1: Using relative temperature scale!
[    3.078579] coretemp coretemp.2: Using relative temperature scale!
[    3.091237] coretemp coretemp.3: Using relative temperature scale!
[    3.103694] coretemp coretemp.4: Using relative temperature scale!
[    3.115974] coretemp coretemp.5: Using relative temperature scale!
[    3.128061] coretemp coretemp.6: Using relative temperature scale!
[    3.139979] coretemp coretemp.7: Using relative temperature scale!
[    3.142402] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    3.163689] cpuidle: using governor ladder
[    3.175482] cpuidle: using governor menu
[    3.187506] usbcore: registered new interface driver hiddev
[    3.199173] usbcore: registered new interface driver usbhid
[    3.210632] usbhid: v2.6:USB HID core driver
[    3.222068] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    3.233714] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    3.245296] HDA Intel 0000:00:1b.0: irq 37 for MSI/MSI-X
[    3.245326] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    3.289123] ALSA device list:
[    3.300467]   #0: HDA Intel at 0xe6620000 irq 37
[    3.311875] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.323651] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.335092] TCP cubic registered
[    3.346383] NET: Registered protocol family 17
[    3.357889] RPC: Registered udp transport module.
[    3.369284] RPC: Registered tcp transport module.
[    3.371033] usb 4-1: New USB device found, idVendor=051d, idProduct=0002
[    3.371035] usb 4-1: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    3.371036] usb 4-1: Product: Back-UPS RS 1500 LCD FW:839.H7 .D USB FW:H7 
[    3.371037] usb 4-1: Manufacturer: American Power Conversion
[    3.371038] usb 4-1: SerialNumber: 8B0822R34475 
[    3.371088] usb 4-1: configuration #1 chosen from 1 choice
[    3.448282] rtc_cmos 00:03: setting system clock to 2009-11-12 18:36:34 UTC (1258050994)
[    4.540890] generic-usb 0003:051D:0002.0001: hiddev96: USB HID v1.10 Device [American Power Conversion Back-UPS RS 1500 LCD FW:839.H7 .D USB FW:H7 ] on usb-0000:07:01.0-1/input0
[    4.584674] UDF-fs: No partition found (1)
[    4.607866] XFS mounting filesystem sdb2
[    4.638182] usb 2-1.6: new full speed USB device using ehci_hcd and address 3
[    4.698658] Ending clean XFS mount for filesystem: sdb2
[    4.698698] VFS: Mounted root (xfs filesystem) readonly on device 8:18.
[    4.710879] Freeing unused kernel memory: 372k freed
[    4.723057] Write protecting the kernel read-only data: 4996k
[    4.788403] usb 2-1.6: New USB device found, idVendor=0a12, idProduct=0001
[    4.800654] usb 2-1.6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    4.813036] usb 2-1.6: configuration #1 chosen from 1 choice
[    4.899130] usb 2-1.7: new full speed USB device using ehci_hcd and address 4
[    4.996968] usb 2-1.7: New USB device found, idVendor=413c, idProduct=1002
[    5.009756] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.022547] usb 2-1.7: Product: Dell USB Keyboard Hub
[    5.035256] usb 2-1.7: Manufacturer: Dell
[    5.047852] usb 2-1.7: configuration #1 chosen from 1 choice
[    5.061119] hub 2-1.7:1.0: USB hub found
[    5.073705] hub 2-1.7:1.0: 3 ports detected
[    5.348030] usb 2-1.7.1: new full speed USB device using ehci_hcd and address 5
[    5.436245] usb 2-1.7.1: New USB device found, idVendor=413c, idProduct=2002
[    5.449031] usb 2-1.7.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.461762] usb 2-1.7.1: Product: Dell USB Keyboard Hub
[    5.474428] usb 2-1.7.1: Manufacturer: Dell
[    5.487209] usb 2-1.7.1: configuration #1 chosen from 1 choice
[    5.501365] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.1/2-1.7.1:1.0/input/input3
[    5.514671] generic-usb 0003:413C:2002.0002: input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.0-1.7.1/input0
[    5.529899] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.1/2-1.7.1:1.1/input/input4
[    5.543823] generic-usb 0003:413C:2002.0003: input: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.0-1.7.1/input1
[    5.605974] usb 2-1.7.2: new low speed USB device using ehci_hcd and address 6
[    5.709558] usb 2-1.7.2: New USB device found, idVendor=0461, idProduct=4d15
[    5.723953] usb 2-1.7.2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    5.738472] usb 2-1.7.2: Product: USB Optical Mouse
[    5.753081] usb 2-1.7.2: configuration #1 chosen from 1 choice
[    5.769901] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.7/2-1.7.2/2-1.7.2:1.0/input/input5
[    5.785431] generic-usb 0003:0461:4D15.0004: input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.7.2/input0
[    6.171395] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.15-NAPI
[    6.187743] e1000e: Copyright(c) 1999 - 2009 Intel Corporation.
[    6.204271] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    6.221022] e1000e 0000:00:19.0: setting latency timer to 64
[    6.221268] e1000e 0000:00:19.0: irq 38 for MSI/MSI-X
[    6.651705] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1c:c0:f6:b6:50
[    6.668568] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    6.685624] 0000:00:19.0: eth0: MAC: 10, PHY: 9, PBA No: ffffff-0ff
[    6.702633] e1000e 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.719623] e1000e 0000:04:00.0: setting latency timer to 64
[    6.720272] e1000e 0000:04:00.0: irq 39 for MSI/MSI-X
[    6.720274] e1000e 0000:04:00.0: irq 40 for MSI/MSI-X
[    6.799793] 0000:04:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:43:79:b1
[    6.804111] udev: renamed network interface eth1 to eth2
[    6.833739] 0000:04:00.0: eth2: Intel(R) PRO/1000 Network Connection
[    6.850831] 0000:04:00.0: eth2: MAC: 4, PHY: 8, PBA No: e46981-003
[    6.867900] e1000e 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.884978] e1000e 0000:05:00.0: setting latency timer to 64
[    6.885598] e1000e 0000:05:00.0: irq 41 for MSI/MSI-X
[    6.885600] e1000e 0000:05:00.0: irq 42 for MSI/MSI-X
[    6.966753] 0000:05:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:1b:21:43:7b:9e
[    6.983929] 0000:05:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    7.001129] 0000:05:00.0: eth1: MAC: 4, PHY: 8, PBA No: e46981-003
[    7.487735] Adding 16787884k swap on /dev/sdb1.  Priority:-1 extents:1 across:16787884k 
[    7.976077] XFS mounting filesystem sda1
[    8.139344] Ending clean XFS mount for filesystem: sda1
[    8.946085] e1000e 0000:00:19.0: irq 38 for MSI/MSI-X
[    8.997101] e1000e 0000:00:19.0: irq 38 for MSI/MSI-X
[   11.395553] e1000e: eth2 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   11.411855] 0000:04:00.0: eth2: 10/100 speed: disabling TSO
[   11.476544] e1000e: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   11.492988] 0000:05:00.0: eth1: 10/100 speed: disabling TSO
[   12.539968] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX

