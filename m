Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZF0E4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZF0E4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 00:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZF0E4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 00:56:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbZF0E4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 00:56:35 -0400
Message-ID: <4A45A5C1.5080701@zytor.com>
Date: Fri, 26 Jun 2009 21:53:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se>
In-Reply-To: <19013.29264.623540.275538@pilspetsen.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you send me /proc/cpuinfo and /proc/iomem from this box?

	-hpa

Mikael Pettersson wrote:
> Mikael Pettersson writes:
>  > The combination of HIGHMEM64G and PCI doesn't work in 2.6.31-rc1,
>  > causing a hang in PCI initialisation during boot:
>  > 
>  > Linux version 2.6.31-rc1 (mikpe@brewer) (gcc version 4.3.4 20090621 (prerelease) (GCC) ) #1 Fri Jun 26 16:01:50 CEST 2009
>  > KERNEL supported cpus:
>  >   Intel GenuineIntel
>  > BIOS-provided physical RAM map:
>  >  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
>  >  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
>  >  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  >  BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
>  >  BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
>  >  BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
>  >  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
>  >  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  >  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
>  >  BIOS-e820: 0000000100000000 - 0000000200000000 (usable)
>  > DMI 2.4 present.
>  > last_pfn = 0x200000 max_arch_pfn = 0x1000000
>  > init_memory_mapping: 0000000000000000-00000000379fe000
>  > NX (Execute Disable) protection: active
>  > RAMDISK: 37ebb000 - 37fef7c6
>  > Allocated new RAMDISK: 00221000 - 003557c6
>  > Move RAMDISK from 0000000037ebb000 - 0000000037fef7c5 to 00221000 - 003557c5
>  > 7302MB HIGHMEM available.
>  > 889MB LOWMEM available.
>  >   mapped low ram: 0 - 379fe000
>  >   low ram: 0 - 379fe000
>  >   node 0 low ram: 00000000 - 379fe000
>  >   node 0 bootmap 00009000 - 0000ff40
>  > (7 early reservations) ==> bootmem [0000000000 - 00379fe000]
>  >   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>  >   #1 [0000100000 - 000021cf18]    TEXT DATA BSS ==> [0000100000 - 000021cf18]
>  >   #2 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
>  >   #3 [000021d000 - 000022022c]              BRK ==> [000021d000 - 000022022c]
>  >   #4 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
>  >   #5 [0000221000 - 00003557c6]      NEW RAMDISK ==> [0000221000 - 00003557c6]
>  >   #6 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
>  > Zone PFN ranges:
>  >   DMA      0x00000000 -> 0x00001000
>  >   Normal   0x00001000 -> 0x000379fe
>  >   HighMem  0x000379fe -> 0x00200000
>  > Movable zone start PFN for each node
>  > early_node_map[3] active PFN ranges
>  >     0: 0x00000000 -> 0x0000009e
>  >     0: 0x00000100 -> 0x0007ff90
>  >     0: 0x00100000 -> 0x00200000
>  > Allocating PCI resources starting at 80000000 (gap: 80000000:7ee00000)
>  > Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1556269
>  > Kernel command line: ro root=LABEL=32/ console=ttyS0,115200
>  > PID hash table entries: 4096 (order: 12, 16384 bytes)
>  > Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>  > Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>  > Enabling fast FPU save and restore... done.
>  > Enabling unmasked SIMD FPU exception support... done.
>  > Initializing CPU#0
>  > Initializing HighMem for node 0 (000379fe:00200000)
>  > Memory: 6220996k/8388608k available (691k kernel code, 68768k reserved, 203k data, 144k init, 5379656k highmem)
>  > virtual kernel memory layout:
>  >     fixmap  : 0xfffe6000 - 0xfffff000   ( 100 kB)
>  >     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
>  >     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
>  >     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
>  >       .init : 0xc01e2000 - 0xc0206000   ( 144 kB)
>  >       .data : 0xc01acd86 - 0xc01dfbdc   ( 203 kB)
>  >       .text : 0xc0100000 - 0xc01acd86   ( 691 kB)
>  > Checking if this processor honours the WP bit even in supervisor mode...Ok.
>  > NR_IRQS:16
>  > Fast TSC calibration using PIT
>  > Detected 2400.277 MHz processor.
>  > Console: colour VGA+ 80x25
>  > console [ttyS0] enabled
>  > Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.55 BogoMIPS (lpj=24002770)
>  > Mount-cache hash table entries: 512
>  > CPU: L1 I cache: 32K, L1 D cache: 32K
>  > CPU: L2 cache: 4096K
>  > using mwait in idle threads.
>  > CPU: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
>  > Checking 'hlt' instruction... OK.
>  > PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=2
>  > PCI: Using configuration type 1 for base access
>  > PCI: Probing PCI hardware
>  > pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
>  > pci 0000:00:01.0: PME# disabled
>  > pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
>  > pci 0000:00:1a.7: PME# disabled
>  > pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>  > pci 0000:00:1b.0: PME# disabled
>  > pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
>  > pci 0000:00:1d.7: PME# disabled
>  > pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
>  > pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
>  > pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
>  > pci 0000:00:1f.2: PME# supported from D3hot
>  > pci 0000:00:1f.2: PME# disabled
>  > pci 0000:02:02.0: PME# supported from D1 D2 D3hot D3cold
>  > pci 0000:02:02.0: PME# disabled
>  > pci 0000:00:1e.0: transparent bridge
>  > pci 0000:00:1f.0: PIIX/ICH IRQ router [8086:2810]
>  > 
>  > At this point the kernel hangs hard until rebooted.
>  > 
>  > Rebooting with mem=2048M (to avoid issues with mappings >= 4GB)
>  > allows PCI init to proceed and print:
>  > 
>  > pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
>  > pci 0000:00:01.0:   IO window: 0x9000-0xbfff
>  > pci 0000:00:01.0:   MEM window: 0xff800000-0xff8fffff
>  > pci 0000:00:01.0:   PREFETCH window: 0x000000bff00000-0x000000dfefffff
>  > pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
>  > pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
>  > pci 0000:00:1e.0:   MEM window: 0xff900000-0xff9fffff
>  > pci 0000:00:1e.0:   PREFETCH window: disabled
>  > pci 0000:00:01.0: found PCI INT A -> IRQ 11
>  > pci 0000:00:01.0: sharing IRQ 11 with 0000:00:1a.0
>  > pci 0000:00:01.0: sharing IRQ 11 with 0000:01:00.0
>  > Unpacking initramfs...
>  > Freeing initrd memory: 1233k freed
>  > platform rtc_cmos: registered platform RTC device (no PNP device found)
>  > Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>  > serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>  > Platform driver 'serial8250' needs updating - please use dev_pm_ops
>  > Freeing unused kernel memory: 144k freed
>  > Red Hat nash version 5.1.19.0.3 starting
>  > ...
>  > 
>  > Booting with pci=off also allows the kernel to boot.
>  > Reconfiguring with NOHIGHMEM or HIGHMEM4G also allows the kernel to boot.
>  > 
>  > This is a regression from 2.6.30 and earlier kernels.
> 
> I've now identified commit 95ee14e4379c5e19c0897c872350570402014742
> "x86: cap iomem_resource to addressable physical memory" by hpa (cc:d)
> as the culprit. Reverting it fixes my boot hang.
> 
> That commit was:
> 
>> x86: cap iomem_resource to addressable physical memory
>>
>> iomem_resource is by default initialized to -1, which means 64 bits of
>> physical address space if 64-bit resources are enabled.  However, x86
>> CPUs cannot address 64 bits of physical address space.  Thus, we want
>> to cap the physical address space to what the union of all CPU can
>> actually address.
>>
>> Without this patch, we may end up assigning inaccessible values to
>> uninitialized 64-bit PCI memory resources.
>>
>> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> Cc: Matthew Wilcox <matthew@wil.cx>
>> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>> Cc: Martin Mares <mj@ucw.cz>
>> Cc: stable@kernel.org
>> ---
>>
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index 3ffdcfa..5b9cb88 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -853,6 +853,9 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
>>  #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
>>  	numa_add_cpu(smp_processor_id());
>>  #endif
>> +
>> +	/* Cap the iomem address space to what is addressable on all CPUs */
>> +	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
>>  }
>>  
>>  #ifdef CONFIG_X86_64
