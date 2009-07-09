Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZGISSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZGISSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZGISR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:17:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:41071 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754179AbZGISRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:17:54 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX1/4nR0zUK74ja4Mlc6Fzys8pZ+IR53ibFFMQ8mrrp
	/+EnChXLhSl/u2
Message-ID: <4A56344C.3010500@warlich.name>
Date: Thu, 09 Jul 2009 20:17:48 +0200
From: Christof Warlich <christof@warlich.name>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com> <4A52F39A.1030704@warlich.name> <4A5311C7.1020507@warlich.name> <4A535973.9090206@gmail.com> <4A5388EA.7030503@warlich.name> <4A53DA88.5080703@gmail.com> <4A543FA5.1090608@warlich.name> <4A54AD1A.1040009@kernel.org> <4A54B98B.50806@gmail.com>
In-Reply-To: <4A54B98B.50806@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000005070206050902090901"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000005070206050902090901
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Tejun Heo schrieb:
> Tejun Heo wrote:
>   
>> One thing we can do is to make libata remember the native size on
>> initial probing and let revalidation consider it.  Yeap, that would
>> work.  Can you please test the attached patch and post full log
>> including boot and suspend/resume?
>>     
>
> Patch slightly updated.  Please test this one.
>
>   

Hi Tejun, Robert,

hey, great: Suspend to ram seems to work like a charm now! Many thanks 
to Robert for taking the time to identify the root cause and to Tejun 
for providing the patch.

I've attached both boot and suspend / resume messages from 
/var/log/kern.log, just let me know if I can do anything else to
help getting the patch into an official kernel release. Furthermore, I 
would be happy to be kept posted on the progress being made regarding this.

Just one clarification: From what I understood so far, it will be 
impossible to ever utilize the full disk capacity as long as the BIOS 
applies the HPA on boot, right?

Cheers,

Christof

--------------000005070206050902090901
Content-Type: text/x-log;
 name="boot.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="boot.log"

Jul  9 19:33:39 fossie kernel: Inspecting /boot/System.map-2.6.30-custom
Jul  9 19:33:39 fossie kernel: Cannot find map file.
Jul  9 19:33:39 fossie kernel: Loaded 54314 symbols from 42 modules.
Jul  9 19:33:39 fossie kernel: [    0.000000] Initializing cgroup subsys cpuset
Jul  9 19:33:39 fossie kernel: [    0.000000] Initializing cgroup subsys cpu
Jul  9 19:33:39 fossie kernel: [    0.000000] Linux version 2.6.30-custom (root@fossie) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #1 SMP Thu Jul 9 07:27:25 CEST 2009
Jul  9 19:33:39 fossie kernel: [    0.000000] KERNEL supported cpus:
Jul  9 19:33:39 fossie kernel: [    0.000000]   Intel GenuineIntel
Jul  9 19:33:39 fossie kernel: [    0.000000]   AMD AuthenticAMD
Jul  9 19:33:39 fossie kernel: [    0.000000]   NSC Geode by NSC
Jul  9 19:33:39 fossie kernel: [    0.000000]   Cyrix CyrixInstead
Jul  9 19:33:39 fossie kernel: [    0.000000]   Centaur CentaurHauls
Jul  9 19:33:39 fossie kernel: [    0.000000]   Transmeta GenuineTMx86
Jul  9 19:33:39 fossie kernel: [    0.000000]   Transmeta TransmetaCPU
Jul  9 19:33:39 fossie kernel: [    0.000000]   UMC UMC UMC UMC
Jul  9 19:33:39 fossie kernel: [    0.000000] BIOS-provided physical RAM map:
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 0000000000100000 - 000000005ff70000 (usable)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 000000005ff70000 - 000000005ff7c000 (ACPI data)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 000000005ff7c000 - 000000005ff80000 (ACPI NVS)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 000000005ff80000 - 0000000060000000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  BIOS-e820: 00000000fffff000 - 0000000100000000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000] DMI present.
Jul  9 19:33:39 fossie kernel: [    0.000000] last_pfn = 0x5ff70 max_arch_pfn = 0x100000
Jul  9 19:33:39 fossie kernel: [    0.000000] MTRR default type: uncachable
Jul  9 19:33:39 fossie kernel: [    0.000000] MTRR fixed ranges enabled:
Jul  9 19:33:39 fossie kernel: [    0.000000]   00000-9FFFF write-back
Jul  9 19:33:39 fossie kernel: [    0.000000]   A0000-BFFFF uncachable
Jul  9 19:33:39 fossie kernel: [    0.000000]   C0000-CFFFF write-protect
Jul  9 19:33:39 fossie kernel: [    0.000000]   D0000-E3FFF uncachable
Jul  9 19:33:39 fossie kernel: [    0.000000]   E4000-FFFFF write-protect
Jul  9 19:33:39 fossie kernel: [    0.000000] MTRR variable ranges enabled:
Jul  9 19:33:39 fossie kernel: [    0.000000]   0 base 000000000 mask FC0000000 write-back
Jul  9 19:33:39 fossie kernel: [    0.000000]   1 base 040000000 mask FE0000000 write-back
Jul  9 19:33:39 fossie kernel: [    0.000000]   2 base 05FF80000 mask FFFF80000 uncachable
Jul  9 19:33:39 fossie kernel: [    0.000000]   3 disabled
Jul  9 19:33:39 fossie kernel: [    0.000000]   4 disabled
Jul  9 19:33:39 fossie kernel: [    0.000000]   5 disabled
Jul  9 19:33:39 fossie kernel: [    0.000000]   6 disabled
Jul  9 19:33:39 fossie kernel: [    0.000000]   7 disabled
Jul  9 19:33:39 fossie kernel: [    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) ==> (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000] Scanning 1 areas for low memory corruption
Jul  9 19:33:39 fossie kernel: [    0.000000] modified physical RAM map:
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 0000000000100000 - 000000005ff70000 (usable)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 000000005ff70000 - 000000005ff7c000 (ACPI data)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 000000005ff7c000 - 000000005ff80000 (ACPI NVS)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 000000005ff80000 - 0000000060000000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 00000000ff800000 - 00000000ffc00000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000]  modified: 00000000fffff000 - 0000000100000000 (reserved)
Jul  9 19:33:39 fossie kernel: [    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
Jul  9 19:33:39 fossie kernel: [    0.000000]  0000000000 - 0000400000 page 4k
Jul  9 19:33:39 fossie kernel: [    0.000000]  0000400000 - 0037400000 page 2M
Jul  9 19:33:39 fossie kernel: [    0.000000]  0037400000 - 00377fe000 page 4k
Jul  9 19:33:39 fossie kernel: [    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
Jul  9 19:33:39 fossie kernel: [    0.000000] RAMDISK: 3508c000 - 37fef77d
Jul  9 19:33:39 fossie kernel: [    0.000000] Allocated new RAMDISK: 0082c000 - 0378f77d
Jul  9 19:33:39 fossie kernel: [    0.000000] Move RAMDISK from 000000003508c000 - 0000000037fef77c to 0082c000 - 0378f77c
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: RSDP 000f6500 00014 (v00 PTLTD )
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: RSDT 5ff77a1d 00030 (v01 PTLTD    RSDT   06040000  LTP 00000000)
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: FACP 5ff7bed2 00074 (v01 HP     08B0     06040000 PTL  00000050)
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: DSDT 5ff77e73 0405F (v01 HP     08B0     06040000 MSFT 0100000E)
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: FACS 5ff7cfc0 00040
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: BOOT 5ff7bfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: SSDT 5ff77a4d 0020E (v01  INTEL  EISTRef 00002000 INTL 20021002)
Jul  9 19:33:39 fossie kernel: [    0.000000] 647MB HIGHMEM available.
Jul  9 19:33:39 fossie kernel: [    0.000000] 887MB LOWMEM available.
Jul  9 19:33:39 fossie kernel: [    0.000000]   mapped low ram: 0 - 377fe000
Jul  9 19:33:39 fossie kernel: [    0.000000]   low ram: 0 - 377fe000
Jul  9 19:33:39 fossie kernel: [    0.000000]   node 0 low ram: 00000000 - 377fe000
Jul  9 19:33:39 fossie kernel: [    0.000000]   node 0 bootmap 00008000 - 0000ef00
Jul  9 19:33:39 fossie kernel: [    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #3 [0000100000 - 0000827454]    TEXT DATA BSS ==> [0000100000 - 0000827454]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #5 [0000828000 - 000082b0f3]              BRK ==> [0000828000 - 000082b0f3]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #7 [000082c000 - 000378f77d]      NEW RAMDISK ==> [000082c000 - 000378f77d]
Jul  9 19:33:39 fossie kernel: [    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
Jul  9 19:33:39 fossie kernel: [    0.000000] Zone PFN ranges:
Jul  9 19:33:39 fossie kernel: [    0.000000]   DMA      0x00000000 -> 0x00001000
Jul  9 19:33:39 fossie kernel: [    0.000000]   Normal   0x00001000 -> 0x000377fe
Jul  9 19:33:39 fossie kernel: [    0.000000]   HighMem  0x000377fe -> 0x0005ff70
Jul  9 19:33:39 fossie kernel: [    0.000000] Movable zone start PFN for each node
Jul  9 19:33:39 fossie kernel: [    0.000000] early_node_map[3] active PFN ranges
Jul  9 19:33:39 fossie kernel: [    0.000000]     0: 0x00000000 -> 0x00000002
Jul  9 19:33:39 fossie kernel: [    0.000000]     0: 0x00000006 -> 0x0000009f
Jul  9 19:33:39 fossie kernel: [    0.000000]     0: 0x00000100 -> 0x0005ff70
Jul  9 19:33:39 fossie kernel: [    0.000000] On node 0 totalpages: 392971
Jul  9 19:33:39 fossie kernel: [    0.000000] free_area_init_node: node 0, pgdat c06e42a0, node_mem_map c3790000
Jul  9 19:33:39 fossie kernel: [    0.000000]   DMA zone: 32 pages used for memmap
Jul  9 19:33:39 fossie kernel: [    0.000000]   DMA zone: 0 pages reserved
Jul  9 19:33:39 fossie kernel: [    0.000000]   DMA zone: 3963 pages, LIFO batch:0
Jul  9 19:33:39 fossie kernel: [    0.000000]   Normal zone: 1744 pages used for memmap
Jul  9 19:33:39 fossie kernel: [    0.000000]   Normal zone: 221486 pages, LIFO batch:31
Jul  9 19:33:39 fossie kernel: [    0.000000]   HighMem zone: 1295 pages used for memmap
Jul  9 19:33:39 fossie kernel: [    0.000000]   HighMem zone: 164451 pages, LIFO batch:31
Jul  9 19:33:39 fossie kernel: [    0.000000] Using APIC driver default
Jul  9 19:33:39 fossie kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x1008
Jul  9 19:33:39 fossie kernel: [    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
Jul  9 19:33:39 fossie kernel: [    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
Jul  9 19:33:39 fossie kernel: [    0.000000] nr_irqs_gsi: 16
Jul  9 19:33:39 fossie kernel: [    0.000000] PM: Registered nosave memory: 0000000000002000 - 0000000000006000
Jul  9 19:33:39 fossie kernel: [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jul  9 19:33:39 fossie kernel: [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
Jul  9 19:33:39 fossie kernel: [    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Jul  9 19:33:39 fossie kernel: [    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:9f800000)
Jul  9 19:33:39 fossie kernel: [    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
Jul  9 19:33:39 fossie kernel: [    0.000000] PERCPU: Embedded 12 pages at c4399000, static data 25884 bytes
Jul  9 19:33:39 fossie kernel: [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 389900
Jul  9 19:33:39 fossie kernel: [    0.000000] Kernel command line: root=UUID=0cd94059-4d36-4b42-9c42-9ccf70206ce6 ro quiet splash 
Jul  9 19:33:39 fossie kernel: [    0.000000] Enabling fast FPU save and restore... done.
Jul  9 19:33:39 fossie kernel: [    0.000000] Enabling unmasked SIMD FPU exception support... done.
Jul  9 19:33:39 fossie kernel: [    0.000000] Initializing CPU#0
Jul  9 19:33:39 fossie kernel: [    0.000000] NR_IRQS:512
Jul  9 19:33:39 fossie kernel: [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
Jul  9 19:33:39 fossie kernel: [    0.000000] Fast TSC calibration using PIT
Jul  9 19:33:39 fossie kernel: [    0.000000] Detected 996.746 MHz processor.
Jul  9 19:33:39 fossie kernel: [    0.004000] Console: colour VGA+ 80x25
Jul  9 19:33:39 fossie kernel: [    0.004000] console [tty0] enabled
Jul  9 19:33:39 fossie kernel: [    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Jul  9 19:33:39 fossie kernel: [    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul  9 19:33:39 fossie kernel: [    0.004000] allocated 7861440 bytes of page_cgroup
Jul  9 19:33:39 fossie kernel: [    0.004000] please try cgroup_disable=memory option if you don't want
Jul  9 19:33:39 fossie kernel: [    0.004000] Initializing HighMem for node 0 (000377fe:0005ff70)
Jul  9 19:33:39 fossie kernel: [    0.004000] Memory: 1494228k/1572288k available (4236k kernel code, 76748k reserved, 1906k data, 520k init, 662984k highmem)
Jul  9 19:33:39 fossie kernel: [    0.004000] virtual kernel memory layout:
Jul  9 19:33:39 fossie kernel: [    0.004000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
Jul  9 19:33:39 fossie kernel: [    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
Jul  9 19:33:39 fossie kernel: [    0.004000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
Jul  9 19:33:39 fossie kernel: [    0.004000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
Jul  9 19:33:39 fossie kernel: [    0.004000]       .init : 0xc070a000 - 0xc078c000   ( 520 kB)
Jul  9 19:33:39 fossie kernel: [    0.004000]       .data : 0xc0523347 - 0xc06ffee8   (1906 kB)
Jul  9 19:33:39 fossie kernel: [    0.004000]       .text : 0xc0100000 - 0xc0523347   (4236 kB)
Jul  9 19:33:39 fossie kernel: [    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jul  9 19:33:39 fossie kernel: [    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Jul  9 19:33:39 fossie kernel: [    0.004022] Calibrating delay loop (skipped), value calculated using timer frequency.. 1993.49 BogoMIPS (lpj=3986984)
Jul  9 19:33:39 fossie kernel: [    0.004078] Security Framework initialized
Jul  9 19:33:39 fossie kernel: [    0.004097] SELinux:  Disabled at boot.
Jul  9 19:33:39 fossie kernel: [    0.004112] Mount-cache hash table entries: 512
Jul  9 19:33:39 fossie kernel: [    0.004408] Initializing cgroup subsys ns
Jul  9 19:33:39 fossie kernel: [    0.004418] Initializing cgroup subsys cpuacct
Jul  9 19:33:39 fossie kernel: [    0.004426] Initializing cgroup subsys memory
Jul  9 19:33:39 fossie kernel: [    0.004440] Initializing cgroup subsys freezer
Jul  9 19:33:39 fossie kernel: [    0.004471] CPU: L1 I cache: 32K, L1 D cache: 32K
Jul  9 19:33:39 fossie kernel: [    0.004476] CPU: L2 cache: 1024K
Jul  9 19:33:39 fossie kernel: [    0.004503] Checking 'hlt' instruction... OK.
Jul  9 19:33:39 fossie kernel: [    0.021269] SMP alternatives: switching to UP code
Jul  9 19:33:39 fossie kernel: [    0.033272] Freeing SMP alternatives: 28k freed
Jul  9 19:33:39 fossie kernel: [    0.033294] ACPI: Core revision 20090320
Jul  9 19:33:39 fossie kernel: [    0.042813] ACPI: setting ELCR to 0200 (from 0c00)
Jul  9 19:33:39 fossie kernel: [    0.044104] weird, boot CPU (#0) not listed by the BIOS.
Jul  9 19:33:39 fossie kernel: [    0.044109] SMP motherboard not detected.
Jul  9 19:33:39 fossie kernel: [    0.044114] Local APIC not detected. Using dummy APIC emulation.
Jul  9 19:33:39 fossie kernel: [    0.044117] SMP disabled
Jul  9 19:33:39 fossie kernel: [    0.044369] Brought up 1 CPUs
Jul  9 19:33:39 fossie kernel: [    0.044374] Total of 1 processors activated (1993.49 BogoMIPS).
Jul  9 19:33:39 fossie kernel: [    0.044395] CPU0 attaching NULL sched-domain.
Jul  9 19:33:39 fossie kernel: [    0.044782] net_namespace: 1056 bytes
Jul  9 19:33:39 fossie kernel: [    0.044809] Booting paravirtualized kernel on bare hardware
Jul  9 19:33:39 fossie kernel: [    0.045268] regulator: core version 0.5
Jul  9 19:33:39 fossie kernel: [    0.045299] Time: 19:33:22  Date: 07/09/09
Jul  9 19:33:39 fossie kernel: [    0.045391] NET: Registered protocol family 16
Jul  9 19:33:39 fossie kernel: [    0.045624] EISA bus registered
Jul  9 19:33:39 fossie kernel: [    0.045649] ACPI: bus type pci registered
Jul  9 19:33:39 fossie kernel: [    0.046369] PCI: PCI BIOS revision 2.10 entry at 0xfd9c3, last bus=2
Jul  9 19:33:39 fossie kernel: [    0.046374] PCI: Using configuration type 1 for base access
Jul  9 19:33:39 fossie kernel: [    0.048260] bio: create slab <bio-0> at 0
Jul  9 19:33:39 fossie kernel: [    0.049342] ACPI: EC: Look up EC in DSDT
Jul  9 19:33:39 fossie kernel: [    0.054173] ACPI: EC: non-query interrupt received, switching to interrupt mode
Jul  9 19:33:39 fossie kernel: [    0.064108] ACPI: Interpreter enabled
Jul  9 19:33:39 fossie kernel: [    0.064121] ACPI: (supports S0 S3 S4 S5)
Jul  9 19:33:39 fossie kernel: [    0.064159] ACPI: Using PIC for interrupt routing
Jul  9 19:33:39 fossie kernel: [    0.072306] ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
Jul  9 19:33:39 fossie kernel: [    0.072311] ACPI: EC: driver started in interrupt mode
Jul  9 19:33:39 fossie kernel: [    0.072421] ACPI: Power Resource [LRP0] (off)
Jul  9 19:33:39 fossie kernel: [    0.072495] ACPI: Power Resource [LRP1] (off)
Jul  9 19:33:39 fossie kernel: [    0.072569] ACPI: Power Resource [LRP2] (off)
Jul  9 19:33:39 fossie kernel: [    0.072856] ACPI: No dock devices found.
Jul  9 19:33:39 fossie kernel: [    0.072880] ACPI: PCI Root Bridge [PCI0] (0000:00)
Jul  9 19:33:39 fossie kernel: [    0.072956] pci 0000:00:00.0: reg 10 32bit mmio: [0xe2000000-0xe3ffffff]
Jul  9 19:33:39 fossie kernel: [    0.073094] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
Jul  9 19:33:39 fossie kernel: [    0.073155] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
Jul  9 19:33:39 fossie kernel: [    0.073218] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
Jul  9 19:33:39 fossie kernel: [    0.073288] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd0000000-0xd00003ff]
Jul  9 19:33:39 fossie kernel: [    0.073354] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Jul  9 19:33:39 fossie kernel: [    0.073361] pci 0000:00:1d.7: PME# disabled
Jul  9 19:33:39 fossie kernel: [    0.073461] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
Jul  9 19:33:39 fossie kernel: [    0.073468] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 GPIO
Jul  9 19:33:39 fossie kernel: [    0.073498] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
Jul  9 19:33:39 fossie kernel: [    0.073508] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
Jul  9 19:33:39 fossie kernel: [    0.073517] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
Jul  9 19:33:39 fossie kernel: [    0.073527] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
Jul  9 19:33:39 fossie kernel: [    0.073537] pci 0000:00:1f.1: reg 20 io port: [0x1860-0x186f]
Jul  9 19:33:39 fossie kernel: [    0.073547] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
Jul  9 19:33:39 fossie kernel: [    0.073607] pci 0000:00:1f.3: reg 20 io port: [0x1880-0x189f]
Jul  9 19:33:39 fossie kernel: [    0.073658] pci 0000:00:1f.5: reg 10 io port: [0x1c00-0x1cff]
Jul  9 19:33:39 fossie kernel: [    0.073668] pci 0000:00:1f.5: reg 14 io port: [0x18c0-0x18ff]
Jul  9 19:33:39 fossie kernel: [    0.073678] pci 0000:00:1f.5: reg 18 32bit mmio: [0xd0000c00-0xd0000dff]
Jul  9 19:33:39 fossie kernel: [    0.073688] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xd0000800-0xd00008ff]
Jul  9 19:33:39 fossie kernel: [    0.073723] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
Jul  9 19:33:39 fossie kernel: [    0.073730] pci 0000:00:1f.5: PME# disabled
Jul  9 19:33:39 fossie kernel: [    0.073766] pci 0000:00:1f.6: reg 10 io port: [0x2400-0x24ff]
Jul  9 19:33:39 fossie kernel: [    0.073776] pci 0000:00:1f.6: reg 14 io port: [0x2000-0x207f]
Jul  9 19:33:39 fossie kernel: [    0.073820] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
Jul  9 19:33:39 fossie kernel: [    0.073826] pci 0000:00:1f.6: PME# disabled
Jul  9 19:33:39 fossie kernel: [    0.073872] pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xd8ffffff]
Jul  9 19:33:39 fossie kernel: [    0.073882] pci 0000:01:00.0: reg 14 32bit mmio: [0xf0000000-0xf3ffffff]
Jul  9 19:33:39 fossie kernel: [    0.073891] pci 0000:01:00.0: reg 18 32bit mmio: [0xe8000000-0xe807ffff]
Jul  9 19:33:39 fossie kernel: [    0.073910] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
Jul  9 19:33:39 fossie kernel: [    0.073971] pci 0000:00:01.0: bridge 32bit mmio: [0xd8000000-0xdfffffff]
Jul  9 19:33:39 fossie kernel: [    0.073978] pci 0000:00:01.0: bridge 32bit mmio pref: [0xe8000000-0xf7ffffff]
Jul  9 19:33:39 fossie kernel: [    0.074027] pci 0000:02:05.0: reg 10 32bit mmio: [0xe0002000-0xe0002fff]
Jul  9 19:33:39 fossie kernel: [    0.074113] pci 0000:02:06.0: reg 10 32bit mmio: [0xe0003000-0xe0003fff]
Jul  9 19:33:39 fossie kernel: [    0.074136] pci 0000:02:06.0: supports D1 D2
Jul  9 19:33:39 fossie kernel: [    0.074141] pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
Jul  9 19:33:39 fossie kernel: [    0.074147] pci 0000:02:06.0: PME# disabled
Jul  9 19:33:39 fossie kernel: [    0.074187] pci 0000:02:06.1: reg 10 32bit mmio: [0xe0004000-0xe0004fff]
Jul  9 19:33:39 fossie kernel: [    0.074210] pci 0000:02:06.1: supports D1 D2
Jul  9 19:33:39 fossie kernel: [    0.074214] pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
Jul  9 19:33:39 fossie kernel: [    0.074221] pci 0000:02:06.1: PME# disabled
Jul  9 19:33:39 fossie kernel: [    0.074257] pci 0000:02:06.2: reg 10 io port: [0x4000-0x403f]
Jul  9 19:33:39 fossie kernel: [    0.076062] pci 0000:02:07.0: reg 10 32bit mmio: [0xe0000000-0xe0001fff]
Jul  9 19:33:39 fossie kernel: [    0.076093] pci 0000:02:07.0: reg 30 32bit mmio: [0x000000-0x003fff]
Jul  9 19:33:39 fossie kernel: [    0.076115] pci 0000:02:07.0: supports D1 D2
Jul  9 19:33:39 fossie kernel: [    0.076119] pci 0000:02:07.0: PME# supported from D0 D1 D2 D3hot D3cold
Jul  9 19:33:39 fossie kernel: [    0.076126] pci 0000:02:07.0: PME# disabled
Jul  9 19:33:39 fossie kernel: [    0.076165] pci 0000:00:1e.0: transparent bridge
Jul  9 19:33:39 fossie kernel: [    0.076172] pci 0000:00:1e.0: bridge io port: [0x3000-0x4fff]
Jul  9 19:33:39 fossie kernel: [    0.076179] pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xe05fffff]
Jul  9 19:33:39 fossie kernel: [    0.076230] pci_bus 0000:00: on NUMA node 0
Jul  9 19:33:39 fossie kernel: [    0.076241] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Jul  9 19:33:39 fossie kernel: [    0.076509] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
Jul  9 19:33:39 fossie kernel: [    0.076603] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
Jul  9 19:33:39 fossie kernel: [    0.083836] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
Jul  9 19:33:39 fossie kernel: [    0.084028] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
Jul  9 19:33:39 fossie kernel: [    0.084206] ACPI: PCI Interrupt Link [LNKC] (IRQs 12) *11
Jul  9 19:33:39 fossie kernel: [    0.084383] ACPI: PCI Interrupt Link [LNKD] (IRQs 15) *10
Jul  9 19:33:39 fossie kernel: [    0.084560] ACPI: PCI Interrupt Link [LNKE] (IRQs 9 10 11 12 15) *0, disabled.
Jul  9 19:33:39 fossie kernel: [    0.084742] ACPI: PCI Interrupt Link [LNKF] (IRQs 9 10 11 12 15) *0, disabled.
Jul  9 19:33:39 fossie kernel: [    0.084923] ACPI: PCI Interrupt Link [LNKG] (IRQs 9 10 11 12 15) *0, disabled.
Jul  9 19:33:39 fossie kernel: [    0.085105] ACPI: PCI Interrupt Link [LNKH] (IRQs 9 *10 11 12 15)
Jul  9 19:33:39 fossie kernel: [    0.085408] SCSI subsystem initialized
Jul  9 19:33:39 fossie kernel: [    0.085504] libata version 3.00 loaded.
Jul  9 19:33:39 fossie kernel: [    0.085639] usbcore: registered new interface driver usbfs
Jul  9 19:33:39 fossie kernel: [    0.085677] usbcore: registered new interface driver hub
Jul  9 19:33:39 fossie kernel: [    0.085725] usbcore: registered new device driver usb
Jul  9 19:33:39 fossie kernel: [    0.085979] ACPI: WMI: Mapper loaded
Jul  9 19:33:39 fossie kernel: [    0.085984] PCI: Using ACPI for IRQ routing
Jul  9 19:33:39 fossie kernel: [    0.086229] Bluetooth: Core ver 2.15
Jul  9 19:33:39 fossie kernel: [    0.086283] NET: Registered protocol family 31
Jul  9 19:33:39 fossie kernel: [    0.086287] Bluetooth: HCI device and connection manager initialized
Jul  9 19:33:39 fossie kernel: [    0.086293] Bluetooth: HCI socket layer initialized
Jul  9 19:33:39 fossie kernel: [    0.086297] NET: Registered protocol family 8
Jul  9 19:33:39 fossie kernel: [    0.086301] NET: Registered protocol family 20
Jul  9 19:33:39 fossie kernel: [    0.086346] NetLabel: Initializing
Jul  9 19:33:39 fossie kernel: [    0.086350] NetLabel:  domain hash size = 128
Jul  9 19:33:39 fossie kernel: [    0.086353] NetLabel:  protocols = UNLABELED CIPSOv4
Jul  9 19:33:39 fossie kernel: [    0.086378] NetLabel:  unlabeled traffic allowed by default
Jul  9 19:33:39 fossie kernel: [    0.086536] pnp: PnP ACPI init
Jul  9 19:33:39 fossie kernel: [    0.086551] ACPI: bus type pnp registered
Jul  9 19:33:39 fossie kernel: [    0.090683] pnp: PnP ACPI: found 8 devices
Jul  9 19:33:39 fossie kernel: [    0.090687] ACPI: ACPI bus type pnp unregistered
Jul  9 19:33:39 fossie kernel: [    0.090694] PnPBIOS: Disabled by ACPI PNP
Jul  9 19:33:39 fossie kernel: [    0.090715] system 00:04: ioport range 0x600-0x60f has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090721] system 00:04: ioport range 0x700-0x70f has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090727] system 00:04: ioport range 0x800-0x807 has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090734] system 00:04: ioport range 0x1000-0x107f has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090740] system 00:04: ioport range 0x1180-0x11bf has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090746] system 00:04: ioport range 0xfe00-0xfe7f has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090753] system 00:04: ioport range 0xfe80-0xfeff has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090760] system 00:04: iomem range 0xfebfe000-0xfebfefff has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090767] system 00:04: iomem range 0xfebff000-0xfebfffff has been reserved
Jul  9 19:33:39 fossie kernel: [    0.090774] system 00:04: iomem range 0xfec00000-0xfec00fff has been reserved
Jul  9 19:33:39 fossie kernel: [    0.125557] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Jul  9 19:33:39 fossie kernel: [    0.125562] pci 0000:00:01.0:   IO window: disabled
Jul  9 19:33:39 fossie kernel: [    0.125570] pci 0000:00:01.0:   MEM window: 0xd8000000-0xdfffffff
Jul  9 19:33:39 fossie kernel: [    0.125577] pci 0000:00:01.0:   PREFETCH window: 0x000000e8000000-0x000000f7ffffff
Jul  9 19:33:39 fossie kernel: [    0.125593] pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
Jul  9 19:33:39 fossie kernel: [    0.125599] pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
Jul  9 19:33:39 fossie kernel: [    0.125606] pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
Jul  9 19:33:39 fossie kernel: [    0.125613] pci 0000:02:06.0:   PREFETCH window: 0x70000000-0x73ffffff
Jul  9 19:33:39 fossie kernel: [    0.125620] pci 0000:02:06.0:   MEM window: 0x7c000000-0x7fffffff
Jul  9 19:33:39 fossie kernel: [    0.125628] pci 0000:02:06.1: CardBus bridge, secondary bus 0000:07
Jul  9 19:33:39 fossie kernel: [    0.125633] pci 0000:02:06.1:   IO window: 0x003800-0x0038ff
Jul  9 19:33:39 fossie kernel: [    0.125639] pci 0000:02:06.1:   IO window: 0x003c00-0x003cff
Jul  9 19:33:39 fossie kernel: [    0.125646] pci 0000:02:06.1:   PREFETCH window: 0x74000000-0x77ffffff
Jul  9 19:33:39 fossie kernel: [    0.125654] pci 0000:02:06.1:   MEM window: 0x80000000-0x83ffffff
Jul  9 19:33:39 fossie kernel: [    0.125661] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
Jul  9 19:33:39 fossie kernel: [    0.125667] pci 0000:00:1e.0:   IO window: 0x3000-0x4fff
Jul  9 19:33:39 fossie kernel: [    0.125675] pci 0000:00:1e.0:   MEM window: 0xe0000000-0xe05fffff
Jul  9 19:33:39 fossie kernel: [    0.125683] pci 0000:00:1e.0:   PREFETCH window: 0x00000070000000-0x00000079ffffff
Jul  9 19:33:39 fossie kernel: [    0.125705] pci 0000:00:1e.0: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [    0.125716] pci 0000:02:06.0: enabling device (0006 -> 0007)
Jul  9 19:33:39 fossie kernel: [    0.125994] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
Jul  9 19:33:39 fossie kernel: [    0.125999] PCI: setting IRQ 11 as level-triggered
Jul  9 19:33:39 fossie kernel: [    0.126007] pci 0000:02:06.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Jul  9 19:33:39 fossie kernel: [    0.126021] pci 0000:02:06.1: enabling device (0006 -> 0007)
Jul  9 19:33:39 fossie kernel: [    0.126283] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
Jul  9 19:33:39 fossie kernel: [    0.126287] PCI: setting IRQ 10 as level-triggered
Jul  9 19:33:39 fossie kernel: [    0.126295] pci 0000:02:06.1: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Jul  9 19:33:39 fossie kernel: [    0.126306] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
Jul  9 19:33:39 fossie kernel: [    0.126312] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
Jul  9 19:33:39 fossie kernel: [    0.126318] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xdfffffff]
Jul  9 19:33:39 fossie kernel: [    0.126325] pci_bus 0000:01: resource 2 pref mem [0xe8000000-0xf7ffffff]
Jul  9 19:33:39 fossie kernel: [    0.126332] pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
Jul  9 19:33:39 fossie kernel: [    0.126338] pci_bus 0000:02: resource 1 mem: [0xe0000000-0xe05fffff]
Jul  9 19:33:39 fossie kernel: [    0.126345] pci_bus 0000:02: resource 2 pref mem [0x70000000-0x79ffffff]
Jul  9 19:33:39 fossie kernel: [    0.126352] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
Jul  9 19:33:39 fossie kernel: [    0.126358] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
Jul  9 19:33:39 fossie kernel: [    0.126365] pci_bus 0000:03: resource 0 io:  [0x3000-0x30ff]
Jul  9 19:33:39 fossie kernel: [    0.126370] pci_bus 0000:03: resource 1 io:  [0x3400-0x34ff]
Jul  9 19:33:39 fossie kernel: [    0.126376] pci_bus 0000:03: resource 2 pref mem [0x70000000-0x73ffffff]
Jul  9 19:33:39 fossie kernel: [    0.126381] pci_bus 0000:03: resource 3 mem: [0x7c000000-0x7fffffff]
Jul  9 19:33:39 fossie kernel: [    0.126387] pci_bus 0000:07: resource 0 io:  [0x3800-0x38ff]
Jul  9 19:33:39 fossie kernel: [    0.126392] pci_bus 0000:07: resource 1 io:  [0x3c00-0x3cff]
Jul  9 19:33:39 fossie kernel: [    0.126398] pci_bus 0000:07: resource 2 pref mem [0x74000000-0x77ffffff]
Jul  9 19:33:39 fossie kernel: [    0.126403] pci_bus 0000:07: resource 3 mem: [0x80000000-0x83ffffff]
Jul  9 19:33:39 fossie kernel: [    0.126467] NET: Registered protocol family 2
Jul  9 19:33:39 fossie kernel: [    0.126657] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul  9 19:33:39 fossie kernel: [    0.127317] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
Jul  9 19:33:39 fossie kernel: [    0.129007] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
Jul  9 19:33:39 fossie kernel: [    0.130144] TCP: Hash tables configured (established 131072 bind 65536)
Jul  9 19:33:39 fossie kernel: [    0.130150] TCP reno registered
Jul  9 19:33:39 fossie kernel: [    0.130358] NET: Registered protocol family 1
Jul  9 19:33:39 fossie kernel: [    0.130505] Trying to unpack rootfs image as initramfs...
Jul  9 19:33:39 fossie kernel: [    0.628079] Switched to high resolution mode on CPU 0
Jul  9 19:33:39 fossie kernel: [    3.300417] Freeing initrd memory: 48525k freed
Jul  9 19:33:39 fossie kernel: [    3.395414] Simple Boot Flag at 0x36 set to 0x1
Jul  9 19:33:39 fossie kernel: [    3.395463] cpufreq-nforce2: No nForce2 chipset.
Jul  9 19:33:39 fossie kernel: [    3.395520] Scanning for low memory corruption every 60 seconds
Jul  9 19:33:39 fossie kernel: [    3.395760] audit: initializing netlink socket (disabled)
Jul  9 19:33:39 fossie kernel: [    3.395824] type=2000 audit(1247168005.392:1): initialized
Jul  9 19:33:39 fossie kernel: [    3.412547] highmem bounce pool size: 64 pages
Jul  9 19:33:39 fossie kernel: [    3.412559] HugeTLB registered 4 MB page size, pre-allocated 0 pages
Jul  9 19:33:39 fossie kernel: [    3.415543] VFS: Disk quotas dquot_6.5.2
Jul  9 19:33:39 fossie kernel: [    3.415666] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Jul  9 19:33:39 fossie kernel: [    3.417007] fuse init (API version 7.11)
Jul  9 19:33:39 fossie kernel: [    3.417188] msgmni has been set to 1720
Jul  9 19:33:39 fossie kernel: [    3.417567] alg: No test for stdrng (krng)
Jul  9 19:33:39 fossie kernel: [    3.417590] io scheduler noop registered
Jul  9 19:33:39 fossie kernel: [    3.417595] io scheduler anticipatory registered
Jul  9 19:33:39 fossie kernel: [    3.417599] io scheduler deadline registered
Jul  9 19:33:39 fossie kernel: [    3.417696] io scheduler cfq registered (default)
Jul  9 19:33:39 fossie kernel: [    3.417807] pci 0000:01:00.0: Boot video device
Jul  9 19:33:39 fossie kernel: [    3.417981] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Jul  9 19:33:39 fossie kernel: [    3.418032] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
Jul  9 19:33:39 fossie kernel: [    3.418733] ACPI: AC Adapter [AC] (on-line)
Jul  9 19:33:39 fossie kernel: [    3.418872] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
Jul  9 19:33:39 fossie kernel: [    3.418877] ACPI: Power Button [PWRF]
Jul  9 19:33:39 fossie kernel: [    3.418971] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
Jul  9 19:33:39 fossie kernel: [    3.418980] ACPI: Power Button [PWRB]
Jul  9 19:33:39 fossie kernel: [    3.419203] fan PNP0C0B:00: registered as cooling_device0
Jul  9 19:33:39 fossie kernel: [    3.419214] ACPI: Fan [FAN0] (off)
Jul  9 19:33:39 fossie kernel: [    3.419369] fan PNP0C0B:01: registered as cooling_device1
Jul  9 19:33:39 fossie kernel: [    3.419380] ACPI: Fan [FAN1] (off)
Jul  9 19:33:39 fossie kernel: [    3.419534] fan PNP0C0B:02: registered as cooling_device2
Jul  9 19:33:39 fossie kernel: [    3.419545] ACPI: Fan [FAN2] (off)
Jul  9 19:33:39 fossie kernel: [    3.420054] Marking TSC unstable due to TSC halts in idle
Jul  9 19:33:39 fossie kernel: [    3.420082] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Jul  9 19:33:39 fossie kernel: [    3.420119] processor ACPI_CPU:00: registered as cooling_device3
Jul  9 19:33:39 fossie kernel: [    3.420126] ACPI: Processor [CPU0] (supports 8 throttling states)
Jul  9 19:33:39 fossie kernel: [    3.424997] thermal LNXTHERM:01: registered as thermal_zone0
Jul  9 19:33:39 fossie kernel: [    3.425012] ACPI: Thermal Zone [THRM] (44 C)
Jul  9 19:33:39 fossie kernel: [    3.425098] isapnp: Scanning for PnP cards...
Jul  9 19:33:39 fossie kernel: [    3.779051] isapnp: No Plug & Play device found
Jul  9 19:33:39 fossie kernel: [    3.781193] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
Jul  9 19:33:39 fossie kernel: [    3.781354] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
Jul  9 19:33:39 fossie kernel: [    3.783420] serial 00:06: activated
Jul  9 19:33:39 fossie kernel: [    3.783562] 00:06: ttyS0 at I/O 0x300 (irq = 4) is a 16550A
Jul  9 19:33:39 fossie kernel: [    3.783710] serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Jul  9 19:33:39 fossie kernel: [    3.783720] serial 0000:00:1f.6: PCI INT B disabled
Jul  9 19:33:39 fossie kernel: [    3.785063] brd: module loaded
Jul  9 19:33:39 fossie kernel: [    3.785688] loop: module loaded
Jul  9 19:33:39 fossie kernel: [    3.785853] input: Macintosh mouse button emulation as /devices/virtual/input/input2
Jul  9 19:33:39 fossie kernel: [    3.785909] Driver 'sd' needs updating - please use bus_type methods
Jul  9 19:33:39 fossie kernel: [    3.785927] Driver 'sr' needs updating - please use bus_type methods
Jul  9 19:33:39 fossie kernel: [    3.786055] ata_piix 0000:00:1f.1: version 2.13
Jul  9 19:33:39 fossie kernel: [    3.786070] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
Jul  9 19:33:39 fossie kernel: [    3.786375] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
Jul  9 19:33:39 fossie kernel: [    3.786380] PCI: setting IRQ 12 as level-triggered
Jul  9 19:33:39 fossie kernel: [    3.786388] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  9 19:33:39 fossie kernel: [    3.786453] ata_piix 0000:00:1f.1: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [    3.786685] scsi0 : ata_piix
Jul  9 19:33:39 fossie kernel: [    3.786874] scsi1 : ata_piix
Jul  9 19:33:39 fossie kernel: [    3.787895] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 irq 14
Jul  9 19:33:39 fossie kernel: [    3.787901] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 irq 15
Jul  9 19:33:39 fossie kernel: [    3.789154] Fixed MDIO Bus: probed
Jul  9 19:33:39 fossie kernel: [    3.789167] PPP generic driver version 2.4.2
Jul  9 19:33:39 fossie kernel: [    3.789335] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Jul  9 19:33:39 fossie kernel: [    3.789636] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
Jul  9 19:33:39 fossie kernel: [    3.789644] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
Jul  9 19:33:39 fossie kernel: [    3.789666] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [    3.789672] ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jul  9 19:33:39 fossie kernel: [    3.789778] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
Jul  9 19:33:39 fossie kernel: [    3.793693] ehci_hcd 0000:00:1d.7: debug port 1
Jul  9 19:33:39 fossie kernel: [    3.793702] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Jul  9 19:33:39 fossie kernel: [    3.793715] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xd0000000
Jul  9 19:33:39 fossie kernel: [    3.807017] ACPI: Battery Slot [CMB0] (battery present)
Jul  9 19:33:39 fossie kernel: [    3.808053] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
Jul  9 19:33:39 fossie kernel: [    3.808244] usb usb1: configuration #1 chosen from 1 choice
Jul  9 19:33:39 fossie kernel: [    3.808302] hub 1-0:1.0: USB hub found
Jul  9 19:33:39 fossie kernel: [    3.808318] hub 1-0:1.0: 6 ports detected
Jul  9 19:33:39 fossie kernel: [    3.808534] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Jul  9 19:33:39 fossie kernel: [    3.808568] uhci_hcd: USB Universal Host Controller Interface driver
Jul  9 19:33:39 fossie kernel: [    3.808624] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Jul  9 19:33:39 fossie kernel: [    3.808635] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [    3.808641] uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jul  9 19:33:39 fossie kernel: [    3.808724] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
Jul  9 19:33:39 fossie kernel: [    3.808753] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
Jul  9 19:33:39 fossie kernel: [    3.808907] usb usb2: configuration #1 chosen from 1 choice
Jul  9 19:33:39 fossie kernel: [    3.808957] hub 2-0:1.0: USB hub found
Jul  9 19:33:39 fossie kernel: [    3.808971] hub 2-0:1.0: 2 ports detected
Jul  9 19:33:39 fossie kernel: [    3.809419] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 15
Jul  9 19:33:39 fossie kernel: [    3.809425] PCI: setting IRQ 15 as level-triggered
Jul  9 19:33:39 fossie kernel: [    3.809433] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  9 19:33:39 fossie kernel: [    3.809443] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [    3.809449] uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jul  9 19:33:39 fossie kernel: [    3.809527] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Jul  9 19:33:39 fossie kernel: [    3.809553] uhci_hcd 0000:00:1d.1: irq 15, io base 0x00001820
Jul  9 19:33:39 fossie kernel: [    3.809721] usb usb3: configuration #1 chosen from 1 choice
Jul  9 19:33:39 fossie kernel: [    3.809771] hub 3-0:1.0: USB hub found
Jul  9 19:33:39 fossie kernel: [    3.809784] hub 3-0:1.0: 2 ports detected
Jul  9 19:33:39 fossie kernel: [    3.809922] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  9 19:33:39 fossie kernel: [    3.809933] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [    3.809939] uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jul  9 19:33:39 fossie kernel: [    3.810024] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Jul  9 19:33:39 fossie kernel: [    3.810052] uhci_hcd 0000:00:1d.2: irq 12, io base 0x00001840
Jul  9 19:33:39 fossie kernel: [    3.810201] usb usb4: configuration #1 chosen from 1 choice
Jul  9 19:33:39 fossie kernel: [    3.810251] hub 4-0:1.0: USB hub found
Jul  9 19:33:39 fossie kernel: [    3.810265] hub 4-0:1.0: 2 ports detected
Jul  9 19:33:39 fossie kernel: [    3.810498] PNP: No PS/2 controller found. Probing ports directly.
Jul  9 19:33:39 fossie kernel: [    4.010145] ata1.00: HPA detected: current 268435456, native 312581808
Jul  9 19:33:39 fossie kernel: [    4.010156] ata1.00: ATA-8: WDC WD1600BEVE-00WZT0, 01.01A01, max UDMA/100
Jul  9 19:33:39 fossie kernel: [    4.010162] ata1.00: 268435456 sectors, multi 16: LBA48 
Jul  9 19:33:39 fossie kernel: [    4.024486] ata1.00: configured for UDMA/100
Jul  9 19:33:39 fossie kernel: [    4.024682] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVE-0 01.0 PQ: 0 ANSI: 5
Jul  9 19:33:39 fossie kernel: [    4.024861] sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul  9 19:33:39 fossie kernel: [    4.024960] sd 0:0:0:0: [sda] 268435456 512-byte hardware sectors: (137 GB/128 GiB)
Jul  9 19:33:39 fossie kernel: [    4.024989] sd 0:0:0:0: [sda] Write Protect is off
Jul  9 19:33:39 fossie kernel: [    4.024995] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul  9 19:33:39 fossie kernel: [    4.025038] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul  9 19:33:39 fossie kernel: [    4.025198]  sda:<7>ata2: port disabled. ignoring.
Jul  9 19:33:39 fossie kernel: [    4.029934]  sda1 sda2 sda3
Jul  9 19:33:39 fossie kernel: [    4.049456] sd 0:0:0:0: [sda] Attached SCSI disk
Jul  9 19:33:39 fossie kernel: [    4.060411] serio: i8042 KBD port at 0x60,0x64 irq 1
Jul  9 19:33:39 fossie kernel: [    4.060517] mice: PS/2 mouse device common for all mice
Jul  9 19:33:39 fossie kernel: [    4.060694] rtc_cmos 00:01: RTC can wake from S4
Jul  9 19:33:39 fossie kernel: [    4.060759] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
Jul  9 19:33:39 fossie kernel: [    4.060781] rtc0: alarms up to one month, y3k, 242 bytes nvram
Jul  9 19:33:39 fossie kernel: [    4.061024] device-mapper: uevent: version 1.0.3
Jul  9 19:33:39 fossie kernel: [    4.061253] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
Jul  9 19:33:39 fossie kernel: [    4.061409] device-mapper: multipath: version 1.0.5 loaded
Jul  9 19:33:39 fossie kernel: [    4.061415] device-mapper: multipath round-robin: version 1.0.0 loaded
Jul  9 19:33:39 fossie kernel: [    4.061596] EISA: Probing bus 0 at eisa.0
Jul  9 19:33:39 fossie kernel: [    4.061608] Cannot allocate resource for EISA slot 1
Jul  9 19:33:39 fossie kernel: [    4.061613] Cannot allocate resource for EISA slot 2
Jul  9 19:33:39 fossie kernel: [    4.061618] Cannot allocate resource for EISA slot 3
Jul  9 19:33:39 fossie kernel: [    4.061622] Cannot allocate resource for EISA slot 4
Jul  9 19:33:39 fossie kernel: [    4.061645] EISA: Detected 0 cards.
Jul  9 19:33:39 fossie kernel: [    4.061798] cpuidle: using governor ladder
Jul  9 19:33:39 fossie kernel: [    4.061914] cpuidle: using governor menu
Jul  9 19:33:39 fossie kernel: [    4.062913] TCP cubic registered
Jul  9 19:33:39 fossie kernel: [    4.063274] NET: Registered protocol family 10
Jul  9 19:33:39 fossie kernel: [    4.064190] lo: Disabled Privacy Extensions
Jul  9 19:33:39 fossie kernel: [    4.064867] NET: Registered protocol family 17
Jul  9 19:33:39 fossie kernel: [    4.064897] Bluetooth: L2CAP ver 2.13
Jul  9 19:33:39 fossie kernel: [    4.064900] Bluetooth: L2CAP socket layer initialized
Jul  9 19:33:39 fossie kernel: [    4.064905] Bluetooth: SCO (Voice Link) ver 0.6
Jul  9 19:33:39 fossie kernel: [    4.064909] Bluetooth: SCO socket layer initialized
Jul  9 19:33:39 fossie kernel: [    4.064996] Bluetooth: RFCOMM socket layer initialized
Jul  9 19:33:39 fossie kernel: [    4.065005] Bluetooth: RFCOMM TTY layer initialized
Jul  9 19:33:39 fossie kernel: [    4.065009] Bluetooth: RFCOMM ver 1.11
Jul  9 19:33:39 fossie kernel: [    4.065395] Using IPI No-Shortcut mode
Jul  9 19:33:39 fossie kernel: [    4.065509] PM: Resume from disk failed.
Jul  9 19:33:39 fossie kernel: [    4.065530] registered taskstats version 1
Jul  9 19:33:39 fossie kernel: [    4.065751]   Magic number: 1:726:596
Jul  9 19:33:39 fossie kernel: [    4.065887] rtc_cmos 00:01: setting system clock to 2009-07-09 19:33:26 UTC (1247168006)
Jul  9 19:33:39 fossie kernel: [    4.065893] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
Jul  9 19:33:39 fossie kernel: [    4.065897] EDD information not available.
Jul  9 19:33:39 fossie kernel: [    4.065984] Freeing unused kernel memory: 520k freed
Jul  9 19:33:39 fossie kernel: [    4.066511] Write protecting the kernel text: 4240k
Jul  9 19:33:39 fossie kernel: [    4.066570] Write protecting the kernel read-only data: 1564k
Jul  9 19:33:39 fossie kernel: [    4.071253] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Jul  9 19:33:39 fossie kernel: [    4.416048] usb 2-2: new low speed USB device using uhci_hcd and address 2
Jul  9 19:33:39 fossie kernel: [    4.593871] usb 2-2: configuration #1 chosen from 1 choice
Jul  9 19:33:39 fossie kernel: [    4.753680] b44 0000:02:07.0: PCI INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  9 19:33:39 fossie kernel: [    4.812213] ssb: Sonics Silicon Backplane found on PCI device 0000:02:07.0
Jul  9 19:33:39 fossie kernel: [    4.812257] b44.c:v2.0
Jul  9 19:33:39 fossie kernel: [    4.833758] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:11:85:5d:db:ae
Jul  9 19:33:39 fossie kernel: [    4.836524] usb 4-2: new full speed USB device using uhci_hcd and address 2
Jul  9 19:33:39 fossie kernel: [    5.066093] usb 4-2: configuration #1 chosen from 1 choice
Jul  9 19:33:39 fossie kernel: [    5.282156] usbcore: registered new interface driver hiddev
Jul  9 19:33:39 fossie kernel: [    5.298448] input: Jing-Mold USB K/B+Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
Jul  9 19:33:39 fossie kernel: [    5.298593] generic-usb 0003:05AF:080A.0001: input,hidraw0: USB HID v1.10 Keyboard [Jing-Mold USB K/B+Mouse] on usb-0000:00:1d.0-2/input0
Jul  9 19:33:39 fossie kernel: [    5.331789] input: Jing-Mold USB K/B+Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input5
Jul  9 19:33:39 fossie kernel: [    5.331961] generic-usb 0003:05AF:080A.0002: input,hidraw1: USB HID v1.10 Mouse [Jing-Mold USB K/B+Mouse] on usb-0000:00:1d.0-2/input1
Jul  9 19:33:39 fossie kernel: [    5.332005] usbcore: registered new interface driver usbhid
Jul  9 19:33:39 fossie kernel: [    5.332056] usbhid: v2.6:USB HID core driver
Jul  9 19:33:39 fossie kernel: [    5.436067] PM: Starting manual resume from disk
Jul  9 19:33:39 fossie kernel: [    5.436076] PM: Resume from partition 8:2
Jul  9 19:33:39 fossie kernel: [    5.436079] PM: Checking hibernation image.
Jul  9 19:33:39 fossie kernel: [    5.436329] PM: Resume from disk failed.
Jul  9 19:33:39 fossie kernel: [    5.441108] PM: Marking nosave pages: 0000000000002000 - 0000000000006000
Jul  9 19:33:39 fossie kernel: [    5.441117] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
Jul  9 19:33:39 fossie kernel: [    5.441124] PM: Basic memory bitmaps created
Jul  9 19:33:39 fossie kernel: [    5.464260] PM: Basic memory bitmaps freed
Jul  9 19:33:39 fossie kernel: [    5.492959] kjournald starting.  Commit interval 5 seconds
Jul  9 19:33:39 fossie kernel: [    5.492976] EXT3-fs: mounted filesystem with writeback data mode.
Jul  9 19:33:39 fossie kernel: [   10.725428] udev: starting version 141
Jul  9 19:33:39 fossie kernel: [   10.954946] Bluetooth: Generic Bluetooth USB driver ver 0.5
Jul  9 19:33:39 fossie kernel: [   10.955114] usbcore: registered new interface driver btusb
Jul  9 19:33:39 fossie kernel: [   11.038643] Linux agpgart interface v0.103
Jul  9 19:33:39 fossie kernel: [   11.073606] agpgart-intel 0000:00:00.0: Intel 855PM Chipset
Jul  9 19:33:39 fossie kernel: [   11.076218] agpgart-intel 0000:00:00.0: AGP aperture is 32M @ 0xe2000000
Jul  9 19:33:39 fossie kernel: [   11.107396] intel_rng: FWH not detected
Jul  9 19:33:39 fossie kernel: [   11.160069] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
Jul  9 19:33:39 fossie kernel: [   11.927680] irda_init()
Jul  9 19:33:39 fossie kernel: [   11.927708] NET: Registered protocol family 23
Jul  9 19:33:39 fossie kernel: [   11.953534] input: PC Speaker as /devices/platform/pcspkr/input/input6
Jul  9 19:33:39 fossie kernel: [   11.982187] iTCO_vendor_support: vendor-support=0
Jul  9 19:33:39 fossie kernel: [   12.009797] lib80211: common routines for IEEE802.11 drivers
Jul  9 19:33:39 fossie kernel: [   12.009803] lib80211_crypt: registered algorithm 'NULL'
Jul  9 19:33:39 fossie kernel: [   12.125736] yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:08b0]
Jul  9 19:33:39 fossie kernel: [   12.125758] yenta_cardbus 0000:02:06.0: Enabling burst memory read transactions
Jul  9 19:33:39 fossie kernel: [   12.125766] yenta_cardbus 0000:02:06.0: Using CSCINT to route CSC interrupts to PCI
Jul  9 19:33:39 fossie kernel: [   12.125771] yenta_cardbus 0000:02:06.0: Routing CardBus interrupts to PCI
Jul  9 19:33:39 fossie kernel: [   12.125779] yenta_cardbus 0000:02:06.0: TI: mfunc 0x00001022, devctl 0x64
Jul  9 19:33:39 fossie kernel: [   12.143065] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/input/input7
Jul  9 19:33:39 fossie kernel: [   12.143152] ACPI: Video Device [AGPB] (multi-head: yes  rom: no  post: no)
Jul  9 19:33:39 fossie kernel: [   12.193658] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Jul  9 19:33:39 fossie kernel: [   12.193772] iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
Jul  9 19:33:39 fossie kernel: [   12.193878] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Jul  9 19:33:39 fossie kernel: [   12.240487] ieee80211: 802.11 data/management/control stack, git-1.1.13
Jul  9 19:33:39 fossie kernel: [   12.240495] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
Jul  9 19:33:39 fossie kernel: [   12.336382] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; irq 3 ; dma 3.
Jul  9 19:33:39 fossie kernel: [   12.336466] nsc-ircc, chip->init
Jul  9 19:33:39 fossie kernel: [   12.336477] nsc-ircc, Found chip at base=0x04e
Jul  9 19:33:39 fossie kernel: [   12.336505] nsc-ircc, driver loaded (Dag Brattli)
Jul  9 19:33:39 fossie kernel: [   12.336514] nsc_ircc_open(), can't get iobase of 0x2f8
Jul  9 19:33:39 fossie kernel: [   12.336545] nsc-ircc, Found chip at base=0x04e
Jul  9 19:33:39 fossie kernel: [   12.336572] nsc-ircc, driver loaded (Dag Brattli)
Jul  9 19:33:39 fossie kernel: [   12.336578] nsc_ircc_open(), can't get iobase of 0x2f8
Jul  9 19:33:39 fossie kernel: [   12.336888] nsc-ircc 00:07: disabled
Jul  9 19:33:39 fossie kernel: [   12.369101] yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x00f0, PCI irq 11
Jul  9 19:33:39 fossie kernel: [   12.369110] yenta_cardbus 0000:02:06.0: Socket status: 30000086
Jul  9 19:33:39 fossie kernel: [   12.369118] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #02 to #06
Jul  9 19:33:39 fossie kernel: [   12.369133] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x4fff
Jul  9 19:33:39 fossie kernel: [   12.369141] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3000-0x4fff: clean.
Jul  9 19:33:39 fossie kernel: [   12.369986] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe05fffff
Jul  9 19:33:39 fossie kernel: [   12.369992] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge Memory window: 0x70000000 - 0x79ffffff
Jul  9 19:33:39 fossie kernel: [   12.373093] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
Jul  9 19:33:39 fossie kernel: [   12.373100] ipw2100: Copyright(c) 2003-2006 Intel Corporation
Jul  9 19:33:39 fossie kernel: [   12.379362] ipw2100 0000:02:05.0: PCI INT A -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  9 19:33:39 fossie kernel: [   12.380283] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
Jul  9 19:33:39 fossie kernel: [   12.380316] ipw2100 0000:02:05.0: firmware: requesting ipw2100-1.3.fw
Jul  9 19:33:39 fossie kernel: [   12.808205] yenta_cardbus 0000:02:06.1: CardBus bridge found [103c:08b0]
Jul  9 19:33:39 fossie kernel: [   12.808231] yenta_cardbus 0000:02:06.1: Using CSCINT to route CSC interrupts to PCI
Jul  9 19:33:39 fossie kernel: [   12.808236] yenta_cardbus 0000:02:06.1: Routing CardBus interrupts to PCI
Jul  9 19:33:39 fossie kernel: [   12.808244] yenta_cardbus 0000:02:06.1: TI: mfunc 0x00001022, devctl 0x64
Jul  9 19:33:39 fossie kernel: [   12.929397] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Jul  9 19:33:39 fossie kernel: [   12.929449] Intel ICH 0000:00:1f.5: setting latency timer to 64
Jul  9 19:33:39 fossie kernel: [   13.040637] yenta_cardbus 0000:02:06.1: ISA IRQ mask 0x00f8, PCI irq 10
Jul  9 19:33:39 fossie kernel: [   13.040645] yenta_cardbus 0000:02:06.1: Socket status: 30000084
Jul  9 19:33:39 fossie kernel: [   13.040653] pci_bus 0000:02: Raising subordinate bus# of parent bus (#02) from #06 to #0a
Jul  9 19:33:39 fossie kernel: [   13.040667] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x4fff
Jul  9 19:33:39 fossie kernel: [   13.040674] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3000-0x4fff: clean.
Jul  9 19:33:39 fossie kernel: [   13.041517] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe05fffff
Jul  9 19:33:39 fossie kernel: [   13.041524] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge Memory window: 0x70000000 - 0x79ffffff
Jul  9 19:33:39 fossie kernel: [   13.141342] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x100-0x3af: clean.
Jul  9 19:33:39 fossie kernel: [   13.143271] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
Jul  9 19:33:39 fossie kernel: [   13.144133] pcmcia_socket pcmcia_socket1: cs: IO port probe 0x820-0x8ff: clean.
Jul  9 19:33:39 fossie kernel: [   13.144822] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xc00-0xcf7: clean.
Jul  9 19:33:39 fossie kernel: [   13.145755] pcmcia_socket pcmcia_socket1: cs: IO port probe 0xa00-0xaff: clean.
Jul  9 19:33:39 fossie kernel: [   13.609505] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x100-0x3af: clean.
Jul  9 19:33:39 fossie kernel: [   13.611365] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
Jul  9 19:33:39 fossie kernel: [   13.612225] pcmcia_socket pcmcia_socket0: cs: IO port probe 0x820-0x8ff: clean.
Jul  9 19:33:39 fossie kernel: [   13.612913] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xc00-0xcf7: clean.
Jul  9 19:33:39 fossie kernel: [   13.613864] pcmcia_socket pcmcia_socket0: cs: IO port probe 0xa00-0xaff: clean.
Jul  9 19:33:39 fossie kernel: [   13.852049] intel8x0_measure_ac97_clock: measured 55340 usecs (2666 samples)
Jul  9 19:33:39 fossie kernel: [   13.852056] intel8x0: clocking to 48000
Jul  9 19:33:39 fossie kernel: [   14.083079] lp: driver loaded but no devices found
Jul  9 19:33:39 fossie kernel: [   14.189960] Adding 2104504k swap on /dev/sda2.  Priority:-1 extents:1 across:2104504k 
Jul  9 19:33:39 fossie kernel: [   14.798631] EXT3 FS on sda3, internal journal
Jul  9 19:33:41 fossie kernel: [   18.941891] ttyS1: LSR safety check engaged!
Jul  9 19:33:41 fossie kernel: [   19.254268] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Jul  9 19:33:41 fossie kernel: [   19.254275] Bluetooth: BNEP filters: protocol multicast
Jul  9 19:33:41 fossie kernel: [   19.397420] Bridge firewalling registered
Jul  9 19:33:43 fossie kernel: [   21.074751] ppdev: user-space parallel port driver
Jul  9 19:33:47 fossie kernel: [   24.571948] ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul  9 19:33:47 fossie kernel: [   24.578315] ADDRCONF(NETDEV_UP): eth1: link is not ready
Jul  9 19:33:48 fossie kernel: [   25.696655] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Jul  9 19:33:49 fossie kernel: [   26.836252] lib80211_crypt: registered algorithm 'CCMP'
Jul  9 19:33:49 fossie kernel: [   27.202932] padlock: VIA PadLock not detected.
Jul  9 19:33:49 fossie kernel: [   27.255759] lib80211_crypt: registered algorithm 'TKIP'
Jul  9 19:33:58 fossie kernel: [   35.964035] eth1: no IPv6 routers present
Jul  9 19:34:45 fossie kernel: [   83.124045] Clocksource tsc unstable (delta = -200139229 ns)

--------------000005070206050902090901
Content-Type: text/x-log;
 name="susp_resume.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="susp_resume.log"

Jul  9 19:48:18 fossie kernel: [  896.138419] b44: eth0: powering down PHY
Jul  9 19:48:18 fossie kernel: [  896.412076] ipw2100: exit - failed to send CARD_DISABLE command
Jul  9 19:48:36 fossie kernel: [  898.598103] PM: Syncing filesystems ... done.
Jul  9 19:48:36 fossie kernel: [  898.601100] PM: Preparing system for mem sleep
Jul  9 19:48:36 fossie kernel: [  898.601119] Freezing user space processes ... (elapsed 0.00 seconds) done.
Jul  9 19:48:36 fossie kernel: [  898.605015] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Jul  9 19:48:36 fossie kernel: [  898.605099] PM: Entering mem sleep
Jul  9 19:48:36 fossie kernel: [  898.605122] Suspending console(s) (use no_console_suspend to debug)
Jul  9 19:48:36 fossie kernel: [  898.606680] btusb_bulk_complete: hci0 urb c2d99900 failed to resubmit (1)
Jul  9 19:48:36 fossie kernel: [  898.607664] btusb_bulk_complete: hci0 urb c2d99c80 failed to resubmit (1)
Jul  9 19:48:36 fossie kernel: [  898.608667] btusb_intr_complete: hci0 urb c2d99d80 failed to resubmit (1)
Jul  9 19:48:36 fossie kernel: [  898.744076] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Jul  9 19:48:36 fossie kernel: [  898.925690] sd 0:0:0:0: [sda] Stopping disk
Jul  9 19:48:36 fossie kernel: [  899.340165] serial 00:06: disabled
Jul  9 19:48:36 fossie kernel: [  899.340229] b44 0000:02:07.0: PCI INT A disabled
Jul  9 19:48:36 fossie kernel: [  899.480179] ipw2100 0000:02:05.0: PCI INT A disabled
Jul  9 19:48:36 fossie kernel: [  899.496338] Intel ICH 0000:00:1f.5: PCI INT B disabled
Jul  9 19:48:36 fossie kernel: [  899.496424] ACPI: Cannot set device to a higher-powered state than parent
Jul  9 19:48:36 fossie kernel: [  899.496514] ata2: port disabled. ignoring.
Jul  9 19:48:36 fossie kernel: [  899.496576] ata_piix 0000:00:1f.1: PCI INT A disabled
Jul  9 19:48:36 fossie kernel: [  899.496590] ehci_hcd 0000:00:1d.7: PCI INT D disabled
Jul  9 19:48:36 fossie kernel: [  899.496637] ehci_hcd 0000:00:1d.7: PME# disabled
Jul  9 19:48:36 fossie kernel: [  899.512140] uhci_hcd 0000:00:1d.2: PCI INT C disabled
Jul  9 19:48:36 fossie kernel: [  899.512173] uhci_hcd 0000:00:1d.1: PCI INT B disabled
Jul  9 19:48:36 fossie kernel: [  899.512206] uhci_hcd 0000:00:1d.0: PCI INT A disabled
Jul  9 19:48:36 fossie kernel: [  899.512446] ACPI: Device [FAN2] failed to transition to D0
Jul  9 19:48:36 fossie kernel: [  899.512629] ACPI: Device [FAN1] failed to transition to D0
Jul  9 19:48:36 fossie kernel: [  899.512799] ACPI: Device [FAN0] failed to transition to D0
Jul  9 19:48:36 fossie kernel: [  899.512838] PM: suspend devices took 0.908 seconds
Jul  9 19:48:36 fossie kernel: [  899.513507] ACPI: Preparing to enter system sleep state S3
Jul  9 19:48:36 fossie kernel: [  899.640437] Disabling non-boot CPUs ...
Jul  9 19:48:36 fossie kernel: [  899.640526] ------------[ cut here ]------------
Jul  9 19:48:36 fossie kernel: [  899.640539] WARNING: at kernel/smp.c:289 smp_call_function_single+0xa0/0x120()
Jul  9 19:48:36 fossie kernel: [  899.640543] Hardware name: HP Tablet PC Tx1100
Jul  9 19:48:36 fossie kernel: [  899.640546] Modules linked in: michael_mic arc4 ecb lib80211_crypt_tkip aes_i586 aes_generic lib80211_crypt_ccmp binfmt_misc ppdev bridge stp bnep lp parport pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device ipw2100 snd libipw iTCO_wdt soundcore video yenta_socket rsrc_nonstatic pcmcia_core lib80211 iTCO_vendor_support pcspkr irda snd_page_alloc output crc_ccitt shpchp intel_agp agpgart btusb usbhid b44 ssb mii
Jul  9 19:48:36 fossie kernel: [  899.640610] Pid: 3478, comm: pm-suspend Not tainted 2.6.30-custom #1
Jul  9 19:48:36 fossie kernel: [  899.640614] Call Trace:
Jul  9 19:48:36 fossie kernel: [  899.640624]  [<c051bdc0>] ? printk+0x18/0x20
Jul  9 19:48:36 fossie kernel: [  899.640630]  [<c015f870>] ? smp_call_function_single+0xa0/0x120
Jul  9 19:48:36 fossie kernel: [  899.640639]  [<c0138ffc>] warn_slowpath_common+0x6c/0xc0
Jul  9 19:48:36 fossie kernel: [  899.640645]  [<c015f870>] ? smp_call_function_single+0xa0/0x120
Jul  9 19:48:36 fossie kernel: [  899.640651]  [<c0139065>] warn_slowpath_null+0x15/0x20
Jul  9 19:48:36 fossie kernel: [  899.640657]  [<c015f870>] smp_call_function_single+0xa0/0x120
Jul  9 19:48:36 fossie kernel: [  899.640665]  [<c0110d30>] ? do_drv_read+0x0/0x50
Jul  9 19:48:36 fossie kernel: [  899.640671]  [<c0110b47>] get_cur_val+0x97/0xc0
Jul  9 19:48:36 fossie kernel: [  899.640678]  [<c0110bb3>] get_cur_freq_on_cpu+0x43/0x70
Jul  9 19:48:36 fossie kernel: [  899.640688]  [<c041deb6>] cpufreq_suspend+0x86/0x100
Jul  9 19:48:36 fossie kernel: [  899.640694]  [<c015289a>] ? raw_notifier_call_chain+0x1a/0x20
Jul  9 19:48:36 fossie kernel: [  899.640702]  [<c0159f51>] ? clockevents_notify+0x21/0x70
Jul  9 19:48:36 fossie kernel: [  899.640712]  [<c035e64d>] sysdev_suspend+0x7d/0x1f0
Jul  9 19:48:36 fossie kernel: [  899.640719]  [<c017328c>] ? stop_machine_destroy+0x3c/0x40
Jul  9 19:48:36 fossie kernel: [  899.640727]  [<c0164d7f>] suspend_devices_and_enter+0x1af/0x210
Jul  9 19:48:36 fossie kernel: [  899.640734]  [<c051bdc0>] ? printk+0x18/0x20
Jul  9 19:48:36 fossie kernel: [  899.640739]  [<c0164f44>] enter_state+0x134/0x1a0
Jul  9 19:48:36 fossie kernel: [  899.640746]  [<c016502d>] state_store+0x7d/0xc0
Jul  9 19:48:36 fossie kernel: [  899.640751]  [<c0164fb0>] ? state_store+0x0/0xc0
Jul  9 19:48:36 fossie kernel: [  899.640758]  [<c02d1a14>] kobj_attr_store+0x24/0x30
Jul  9 19:48:36 fossie kernel: [  899.640766]  [<c02154b2>] sysfs_write_file+0x92/0xf0
Jul  9 19:48:36 fossie kernel: [  899.640776]  [<c01c6c8c>] vfs_write+0x9c/0x170
Jul  9 19:48:36 fossie kernel: [  899.640782]  [<c0215420>] ? sysfs_write_file+0x0/0xf0
Jul  9 19:48:36 fossie kernel: [  899.640788]  [<c01c6e1d>] sys_write+0x3d/0x70
Jul  9 19:48:36 fossie kernel: [  899.640794]  [<c010305c>] sysenter_do_call+0x12/0x28
Jul  9 19:48:36 fossie kernel: [  899.640799] ---[ end trace b4771eb00c1bebc0 ]---
Jul  9 19:48:36 fossie kernel: [  899.640799] Back to C!
Jul  9 19:48:36 fossie kernel: [  899.642653] ACPI: Waking up from system sleep state S3
Jul  9 19:48:36 fossie kernel: [  900.080214] agpgart-intel 0000:00:00.0: restoring config space at offset 0x4 (was 0xe0000008, writing 0xe2000008)
Jul  9 19:48:36 fossie kernel: [  900.080224] agpgart-intel 0000:00:00.0: restoring config space at offset 0x1 (was 0x20900106, writing 0x30900106)
Jul  9 19:48:36 fossie kernel: [  900.080245] pci 0000:00:01.0: restoring config space at offset 0x7 (was 0x2a000f0, writing 0x22a000f0)
Jul  9 19:48:36 fossie kernel: [  900.080278] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  9 19:48:36 fossie kernel: [  900.080308] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  9 19:48:36 fossie kernel: [  900.080339] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800001)
Jul  9 19:48:36 fossie kernel: [  900.080379] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900102)
Jul  9 19:48:36 fossie kernel: [  900.080407] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0xfff0, writing 0x79f07000)
Jul  9 19:48:36 fossie kernel: [  900.080415] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0xfff0, writing 0xe050e000)
Jul  9 19:48:36 fossie kernel: [  900.080423] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x228000f0, writing 0x2804030)
Jul  9 19:48:36 fossie kernel: [  900.080431] pci 0000:00:1e.0: restoring config space at offset 0x6 (was 0x40020200, writing 0x400a0200)
Jul  9 19:48:36 fossie kernel: [  900.080444] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x80800005, writing 0x88800107)
Jul  9 19:48:36 fossie kernel: [  900.080481] ata_piix 0000:00:1f.1: restoring config space at offset 0xf (was 0x100, writing 0x1ff)
Jul  9 19:48:36 fossie kernel: [  900.080495] ata_piix 0000:00:1f.1: restoring config space at offset 0x9 (was 0x0, writing 0x7a000000)
Jul  9 19:48:36 fossie kernel: [  900.080512] ata_piix 0000:00:1f.1: restoring config space at offset 0x1 (was 0x2800005, writing 0x2800007)
Jul  9 19:48:36 fossie kernel: [  900.080552] Intel ICH 0000:00:1f.5: restoring config space at offset 0xf (was 0x200, writing 0x20a)
Jul  9 19:48:36 fossie kernel: [  900.080568] Intel ICH 0000:00:1f.5: restoring config space at offset 0x7 (was 0x0, writing 0xd0000800)
Jul  9 19:48:36 fossie kernel: [  900.080575] Intel ICH 0000:00:1f.5: restoring config space at offset 0x6 (was 0x0, writing 0xd0000c00)
Jul  9 19:48:36 fossie kernel: [  900.080583] Intel ICH 0000:00:1f.5: restoring config space at offset 0x5 (was 0x1301, writing 0x18c1)
Jul  9 19:48:36 fossie kernel: [  900.080590] Intel ICH 0000:00:1f.5: restoring config space at offset 0x4 (was 0x1201, writing 0x1c01)
Jul  9 19:48:36 fossie kernel: [  900.080600] Intel ICH 0000:00:1f.5: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900003)
Jul  9 19:48:36 fossie kernel: [  900.080620] pci 0000:00:1f.6: restoring config space at offset 0xf (was 0x200, writing 0x20a)
Jul  9 19:48:36 fossie kernel: [  900.080637] pci 0000:00:1f.6: restoring config space at offset 0x5 (was 0x1501, writing 0x2001)
Jul  9 19:48:36 fossie kernel: [  900.080645] pci 0000:00:1f.6: restoring config space at offset 0x4 (was 0x1401, writing 0x2401)
Jul  9 19:48:36 fossie kernel: [  900.080655] pci 0000:00:1f.6: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
Jul  9 19:48:36 fossie kernel: [  900.080685] pci 0000:01:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x4000)
Jul  9 19:48:36 fossie kernel: [  900.080708] ipw2100 0000:02:05.0: restoring config space at offset 0xf (was 0x22020100, writing 0x2202010a)
Jul  9 19:48:36 fossie kernel: [  900.080728] ipw2100 0000:02:05.0: restoring config space at offset 0x4 (was 0x0, writing 0xe0002000)
Jul  9 19:48:36 fossie kernel: [  900.080735] ipw2100 0000:02:05.0: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
Jul  9 19:48:36 fossie kernel: [  900.080744] ipw2100 0000:02:05.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900116)
Jul  9 19:48:36 fossie kernel: [  900.080766] yenta_cardbus 0000:02:06.0: restoring config space at offset 0xf (was 0x34001ff, writing 0x5c001ff)
Jul  9 19:48:36 fossie kernel: [  900.080774] yenta_cardbus 0000:02:06.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
Jul  9 19:48:36 fossie kernel: [  900.080781] yenta_cardbus 0000:02:06.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
Jul  9 19:48:36 fossie kernel: [  900.080789] yenta_cardbus 0000:02:06.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
Jul  9 19:48:36 fossie kernel: [  900.080797] yenta_cardbus 0000:02:06.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
Jul  9 19:48:36 fossie kernel: [  900.080805] yenta_cardbus 0000:02:06.0: restoring config space at offset 0xa (was 0x0, writing 0x7ffff000)
Jul  9 19:48:36 fossie kernel: [  900.080813] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x9 (was 0x0, writing 0x7c000000)
Jul  9 19:48:36 fossie kernel: [  900.080820] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x8 (was 0x0, writing 0x73fff000)
Jul  9 19:48:36 fossie kernel: [  900.080828] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x7 (was 0x0, writing 0x70000000)
Jul  9 19:48:36 fossie kernel: [  900.080836] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x6 (was 0x0, writing 0xb0060302)
Jul  9 19:48:36 fossie kernel: [  900.080845] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x4 (was 0x0, writing 0xe0003000)
Jul  9 19:48:36 fossie kernel: [  900.080853] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x3 (was 0x820000, writing 0x82a808)
Jul  9 19:48:36 fossie kernel: [  900.080862] yenta_cardbus 0000:02:06.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Jul  9 19:48:36 fossie kernel: [  900.080885] yenta_cardbus 0000:02:06.1: restoring config space at offset 0xf (was 0x34002ff, writing 0x5c002ff)
Jul  9 19:48:36 fossie kernel: [  900.080893] yenta_cardbus 0000:02:06.1: restoring config space at offset 0xe (was 0x0, writing 0x3cfc)
Jul  9 19:48:36 fossie kernel: [  900.080901] yenta_cardbus 0000:02:06.1: restoring config space at offset 0xd (was 0x0, writing 0x3c00)
Jul  9 19:48:36 fossie kernel: [  900.080908] yenta_cardbus 0000:02:06.1: restoring config space at offset 0xc (was 0x0, writing 0x38fc)
Jul  9 19:48:36 fossie kernel: [  900.080916] yenta_cardbus 0000:02:06.1: restoring config space at offset 0xb (was 0x0, writing 0x3800)
Jul  9 19:48:36 fossie kernel: [  900.080924] yenta_cardbus 0000:02:06.1: restoring config space at offset 0xa (was 0x0, writing 0x83fff000)
Jul  9 19:48:36 fossie kernel: [  900.080932] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x9 (was 0x0, writing 0x80000000)
Jul  9 19:48:36 fossie kernel: [  900.080940] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x8 (was 0x0, writing 0x77fff000)
Jul  9 19:48:36 fossie kernel: [  900.080947] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x7 (was 0x0, writing 0x74000000)
Jul  9 19:48:36 fossie kernel: [  900.080955] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x6 (was 0x0, writing 0xb00a0702)
Jul  9 19:48:36 fossie kernel: [  900.080964] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 0xe0004000)
Jul  9 19:48:36 fossie kernel: [  900.080972] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x3 (was 0x820000, writing 0x82a808)
Jul  9 19:48:36 fossie kernel: [  900.080982] yenta_cardbus 0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Jul  9 19:48:36 fossie kernel: [  900.081015] pci 0000:02:06.2: restoring config space at offset 0x4 (was 0x1, writing 0x4001)
Jul  9 19:48:36 fossie kernel: [  900.081023] pci 0000:02:06.2: restoring config space at offset 0x3 (was 0x0, writing 0x4008)
Jul  9 19:48:36 fossie kernel: [  900.081032] pci 0000:02:06.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Jul  9 19:48:36 fossie kernel: [  900.081067] b44 0000:02:07.0: restoring config space at offset 0x1 (was 0x100106, writing 0x8100106)
Jul  9 19:48:36 fossie kernel: [  901.480940] PM: Device LNXPOWER:01 failed to resume: error -8
Jul  9 19:48:36 fossie kernel: [  901.481249] PM: Device LNXPOWER:02 failed to resume: error -8
Jul  9 19:48:36 fossie kernel: [  901.490611] agpgart-intel 0000:00:00.0: restoring config space at offset 0x4 (was 0xe0000008, writing 0xe2000008)
Jul  9 19:48:36 fossie kernel: [  901.490620] agpgart-intel 0000:00:00.0: restoring config space at offset 0x1 (was 0x900106, writing 0x30900106)
Jul  9 19:48:36 fossie kernel: [  901.490675] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
Jul  9 19:48:36 fossie kernel: [  901.490684] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  901.490706] usb usb2: root hub lost power or was reset
Jul  9 19:48:36 fossie kernel: [  901.490766] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  9 19:48:36 fossie kernel: [  901.490775] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  901.490795] usb usb3: root hub lost power or was reset
Jul  9 19:48:36 fossie kernel: [  901.490835] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  9 19:48:36 fossie kernel: [  901.490843] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  901.490863] usb usb4: root hub lost power or was reset
Jul  9 19:48:36 fossie kernel: [  901.490930] ehci_hcd 0000:00:1d.7: PME# disabled
Jul  9 19:48:36 fossie kernel: [  901.490938] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
Jul  9 19:48:36 fossie kernel: [  901.490947] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  901.490955] ehci_hcd 0000:00:1d.7: PME# disabled
Jul  9 19:48:36 fossie kernel: [  901.490986] pci 0000:00:1e.0: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  901.491021] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  9 19:48:36 fossie kernel: [  901.491028] ata_piix 0000:00:1f.1: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  901.491082] ata2: port disabled. ignoring.
Jul  9 19:48:36 fossie kernel: [  901.492572] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
Jul  9 19:48:36 fossie kernel: [  901.492581] Intel ICH 0000:00:1f.5: setting latency timer to 64
Jul  9 19:48:36 fossie kernel: [  902.384429] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
Jul  9 19:48:36 fossie kernel: [  902.384436] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
Jul  9 19:48:36 fossie kernel: [  902.400333] ata1.00: n_sectors mismatch 268435456 != 312581808
Jul  9 19:48:36 fossie kernel: [  902.400337] ata1.00: new n_sectors matches native, probably late HPA unlock, continuing
Jul  9 19:48:36 fossie kernel: [  902.409152] ata1.00: n_sectors mismatch 268435456 != 312581808
Jul  9 19:48:36 fossie kernel: [  902.409156] ata1.00: new n_sectors matches native, probably late HPA unlock, continuing
Jul  9 19:48:36 fossie kernel: [  902.409162] ata1.00: configured for UDMA/100
Jul  9 19:48:36 fossie kernel: [  902.505982] pci 0000:00:1f.6: PME# disabled
Jul  9 19:48:36 fossie kernel: [  902.505989] pci 0000:01:00.0: PME# disabled
Jul  9 19:48:36 fossie kernel: [  902.506001] ipw2100 0000:02:05.0: PCI INT A -> Link[LNKD] -> GSI 15 (level, low) -> IRQ 15
Jul  9 19:48:36 fossie kernel: [  903.068143] pci 0000:02:06.2: PME# disabled
Jul  9 19:48:36 fossie kernel: [  903.068154] b44 0000:02:07.0: PCI INT A -> Link[LNKC] -> GSI 12 (level, low) -> IRQ 12
Jul  9 19:48:36 fossie kernel: [  903.068181] b44 0000:02:07.0: restoring config space at offset 0x1 (was 0x100106, writing 0x8100106)
Jul  9 19:48:36 fossie kernel: [  903.089758] serial 00:06: activated
Jul  9 19:48:36 fossie kernel: [  903.836272] sd 0:0:0:0: [sda] Starting disk
Jul  9 19:48:36 fossie kernel: [  904.144050] usb 2-2: reset low speed USB device using uhci_hcd and address 2
Jul  9 19:48:36 fossie kernel: [  904.588050] usb 4-2: reset full speed USB device using uhci_hcd and address 2
Jul  9 19:48:36 fossie kernel: [  904.965867] btusb 4-2:1.0: no reset_resume for driver btusb?
Jul  9 19:48:36 fossie kernel: [  904.965872] btusb 4-2:1.1: no reset_resume for driver btusb?
Jul  9 19:48:36 fossie kernel: [  905.216349] PM: resume devices took 5.136 seconds
Jul  9 19:48:36 fossie kernel: [  905.216353] ------------[ cut here ]------------
Jul  9 19:48:36 fossie kernel: [  905.216366] WARNING: at kernel/power/main.c:176 suspend_test_finish+0x80/0x90()
Jul  9 19:48:36 fossie kernel: [  905.216370] Hardware name: HP Tablet PC Tx1100
Jul  9 19:48:36 fossie kernel: [  905.216373] Component: resume devices
Jul  9 19:48:36 fossie kernel: [  905.216376] Modules linked in: michael_mic arc4 ecb lib80211_crypt_tkip aes_i586 aes_generic lib80211_crypt_ccmp binfmt_misc ppdev bridge stp bnep lp parport pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device ipw2100 snd libipw iTCO_wdt soundcore video yenta_socket rsrc_nonstatic pcmcia_core lib80211 iTCO_vendor_support pcspkr irda snd_page_alloc output crc_ccitt shpchp intel_agp agpgart btusb usbhid b44 ssb mii
Jul  9 19:48:36 fossie kernel: [  905.216440] Pid: 3478, comm: pm-suspend Tainted: G        W  2.6.30-custom #1
Jul  9 19:48:36 fossie kernel: [  905.216444] Call Trace:
Jul  9 19:48:36 fossie kernel: [  905.216452]  [<c0164bc0>] ? suspend_test_finish+0x80/0x90
Jul  9 19:48:36 fossie kernel: [  905.216458]  [<c0164bc0>] ? suspend_test_finish+0x80/0x90
Jul  9 19:48:36 fossie kernel: [  905.216466]  [<c0138ffc>] warn_slowpath_common+0x6c/0xc0
Jul  9 19:48:36 fossie kernel: [  905.216473]  [<c0164bc0>] ? suspend_test_finish+0x80/0x90
Jul  9 19:48:36 fossie kernel: [  905.216479]  [<c0139096>] warn_slowpath_fmt+0x26/0x30
Jul  9 19:48:36 fossie kernel: [  905.216485]  [<c0164bc0>] suspend_test_finish+0x80/0x90
Jul  9 19:48:36 fossie kernel: [  905.216493]  [<c0164c77>] suspend_devices_and_enter+0xa7/0x210
Jul  9 19:48:36 fossie kernel: [  905.216501]  [<c051bdc0>] ? printk+0x18/0x20
Jul  9 19:48:36 fossie kernel: [  905.216507]  [<c0164f44>] enter_state+0x134/0x1a0
Jul  9 19:48:36 fossie kernel: [  905.216514]  [<c016502d>] state_store+0x7d/0xc0
Jul  9 19:48:36 fossie kernel: [  905.216520]  [<c0164fb0>] ? state_store+0x0/0xc0
Jul  9 19:48:36 fossie kernel: [  905.216527]  [<c02d1a14>] kobj_attr_store+0x24/0x30
Jul  9 19:48:36 fossie kernel: [  905.216534]  [<c02154b2>] sysfs_write_file+0x92/0xf0
Jul  9 19:48:36 fossie kernel: [  905.216544]  [<c01c6c8c>] vfs_write+0x9c/0x170
Jul  9 19:48:36 fossie kernel: [  905.216550]  [<c0215420>] ? sysfs_write_file+0x0/0xf0
Jul  9 19:48:36 fossie kernel: [  905.216556]  [<c01c6e1d>] sys_write+0x3d/0x70
Jul  9 19:48:36 fossie kernel: [  905.216563]  [<c010305c>] sysenter_do_call+0x12/0x28
Jul  9 19:48:36 fossie kernel: [  905.216568] ---[ end trace b4771eb00c1bebc1 ]---
Jul  9 19:48:36 fossie kernel: [  905.216879] PM: Finishing wakeup.
Jul  9 19:48:36 fossie kernel: [  905.216883] Restarting tasks ... done.
Jul  9 19:48:38 fossie kernel: [  906.903180] ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul  9 19:48:38 fossie kernel: [  906.909502] ADDRCONF(NETDEV_UP): eth1: link is not ready
Jul  9 19:48:39 fossie kernel: [  908.036593] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
Jul  9 19:48:49 fossie kernel: [  918.040050] eth1: no IPv6 routers present

--------------000005070206050902090901--
