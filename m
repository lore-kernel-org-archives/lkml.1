Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbZBIPaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbZBIPaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 10:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZBIP3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 10:29:53 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:60832 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbZBIP3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:29:52 -0500
Message-ID: <49904BED.7090208@cfl.rr.com>
Date: Mon, 09 Feb 2009 10:29:49 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: markh@compro.net, Andreas Herrmann <andreas.herrmann3@amd.com>,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD	Phenom-II
 processor
References: <20090127163843.GA1628@aftab> <497FA725.7020503@cfl.rr.com> <497FA7F2.3060709@cfl.rr.com> <20090203151137.GB12017@aftab> <498897C1.2090802@compro.net> <498B1FA9.2050203@cfl.rr.com> <20090206135248.GB23459@aftab> <498C44FA.1010106@compro.net> <498C7980.2060309@compro.net> <498CB798.7050308@cfl.rr.com> <20090209141841.GA31643@aftab>
In-Reply-To: <20090209141841.GA31643@aftab>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Hi,
> 
> On Fri, Feb 06, 2009 at 05:20:08PM -0500, Mark Hounschell wrote:
>> Mark Hounschell wrote:
>>>> Borislav Petkov wrote:
>>>>> Ok, here are two things you could try:
>>>>>
>>>>> Disable CONFIG_HIGH_RES_TIMERS (high resolution timers support in
>>>>> "Processor type and features"), boot with "apic=debug" and send me the
>>>>> output. I'd like to see how the lapic timer gets programmed. It would
>>>>> be better for that exercise to get the latest stable kernel, 2.6.28.3,
>>>>> imho.
>>>>>
>>>>> The other thing you could do is get x86info tools from here:
>>>>> http://www.codemonkey.org.uk/projects/x86info/. However, get either a
>>>>> daily snapshot or a checkout from the git repository and build it on
>>>>> your system. Then do
>>>>>
>>>>> x86info -a > x86info.txt
>>>>>
>>>>> lsmsr -V3 -a > lsmsr.txt
>>>>>
>>>>> and send me those text files - we might be able to get a clue what's going on
>>>>> from them.
>>> Ok, attached is the bootlog.txt, x86info.txt, and lsmsr.txt
>>>
>>> Thanks
>>> Mark
>>>
>> That bootlog was captured from the serial console, but comparing it to the dmesg
>> I see more info in the dmesg. The extra stuff for "apic=debug" must not be going
>> to the serial console?? Either way here is the demsg output too.
>>
>> Regards
>> Mark
>>
> 
>> BIOS EBDA/lowmem at: 0009f000/0009f000
>> Initializing cgroup subsys cpuset
>> Linux version 2.6.28.3-250Hz (root@harley) (gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #2 SMP PREEMPT Fri Feb 6 11:48:54 EST 2009
> 
> maybe I wasn't clear enough - I meant to boot a _1000HZ_ kernel not a
> 250HZ one with highres timers disabled, if the line above is correct.
> Can you try the same thing as above again, please, but this time use a
> 1000HZ 32bit kernel.
> 
> Thanks.
> 

Sorry, hows this?
BIOS EBDA/lowmem at: 0009f000/0009f000
Initializing cgroup subsys cpuset
Linux version 2.6.28.3-1000Hz (root@harley) (gcc version 4.3.1 20080507
(prerelease) [gcc-4_3-branch revision 135036] (SUSE Linux) ) #3 SMP PREEMPT Mon Feb9
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
RAMDISK: 375a8000 - 37fef376
Allocated new RAMDISK: 004a7000 - 00eee376
Move RAMDISK from 00000000375a8000 - 0000000037fef375 to 004a7000 - 00eee375
ACPI: RSDP 000F7FB0, 0024 (r2 RX780 )
ACPI: XSDT BFFE3080, 0044 (r1 RX780  AWRDACPI 42302E31 AWRD        0)
ACPI: FACP BFFE8C80, 00F4 (r3 RX780  AWRDACPI 42302E31 AWRD        0)
FADT: X_PM1a_EVT_BLK.bit_width (8) does not match PM1_EVT_LEN (4)
ACPI: DSDT BFFE3200, 5A71 (r1 RX780  AWRDACPI     1000 MSFT  100000E)
ACPI: FACS BFFE0000, 0040
ACPI: HPET BFFE8E40, 0038 (r1 RX780  AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG BFFE8E80, 003C (r1 RX780  AWRDACPI 42302E31 AWRD        0)
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
  #7 [00004a7000 - 0000eee376]      NEW RAMDISK ==> [00004a7000 - 0000eee376]
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
Kernel command line: root=/dev/sda5 hwprobe=-modules.pata apm=off selinux=0
noresume splash=silent apic=debug console=ttyS0,19200n8 vga=normal
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Fast TSC calibration using PIT
Detected 3359.811 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 3104320k/3145600k available (1835k kernel code, 39920k reserved, 1099k
data, 276k init, 2236296k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe19000 - 0xfffff000   (1944 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc03e3000 - 0xc0428000   ( 276 kB)
      .data : 0xc02caf57 - 0xc03ddc4c   (1099 kB)
      .text : 0xc0100000 - 0xc02caf57   (1835 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
HPE


Regards
Mark

