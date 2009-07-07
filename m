Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZGGHFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZGGHFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbZGGHFC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:05:02 -0400
Received: from mail.gmx.net ([213.165.64.20]:58485 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753153AbZGGHE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:04:59 -0400
X-Authenticated: #1512929
X-Provags-ID: V01U2FsdGVkX18/DdIGdjg/kc39MZ0X5PRY41xz9iwDlD3rJjvkLM
	LgjSx3Nz6eqM89
Message-ID: <4A52F39A.1030704@warlich.name>
Date: Tue, 07 Jul 2009 09:04:58 +0200
From: Christof Warlich <christof@warlich.name>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: "EXT3-fs error" after resume from s2ram
References: <4A4771FD.1020207@warlich.name> <4A480859.5010206@gmail.com> <4A48C799.2010102@warlich.name> <4A495C2D.1040706@gmail.com> <4A49A49C.10104@warlich.name> <4A4C42E2.6030305@gmail.com> <4A51C929.5010909@warlich.name> <4A52931D.5070109@gmail.com>
In-Reply-To: <4A52931D.5070109@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock schrieb:
> On 07/06/2009 03:51 AM, Christof Warlich wrote:
>> Jul 6 09:15:41 fossie kernel: [ 316.648468] ata1.00: ACPI cmd
>> ef/03:0c:00:00:00:a0 filtered out
>> Jul 6 09:15:41 fossie kernel: [ 316.648468] ata1.00: ACPI cmd
>> ef/03:0c:00:00:00:a0 filtered out
>> Jul 6 09:15:41 fossie kernel: [ 316.648480] ata1.00: ACPI cmd
>> ef/03:45:00:00:00:a0 filtered out
>> Jul 6 09:15:41 fossie kernel: [ 316.648480] ata1.00: ACPI cmd
>> ef/03:45:00:00:00:a0 filtered out
>> Jul 6 09:15:41 fossie kernel: [ 316.659047] ata1.00: n_sectors mismatch
>> 268435456 != 312581808
>> Jul 6 09:15:41 fossie kernel: [ 316.659047] ata1.00: n_sectors mismatch
>> 268435456 != 312581808
>> Jul 6 09:15:41 fossie kernel: [ 316.659054] ata1.00: revalidation failed
>> (errno=-19)
>
> This is why the hard disk failed to resume, somehow the drive shows a 
> capacity of 149GB after resume but only 128GB before. What's the 
> actual capacity of the drive? I suspect the drive has a host protected 
> area on it, and somehow the HPA isn't showing up after we resume.
>
> Can you post the dmesg log from normal bootup?

Ah - thanks a lot for this very valuable insight! My harddrive is a WDC 
WD 1600BEVE-00WZ0-(PM) with 149GiB, (or 160GB), but the TC1100's BIOS is 
known to only support 128GiB. And fdisk also only shows just this amount 
(i.e. 137.4GB), so I'm not using any disk space beyond  the 128GiB boundary.

Below you'll find the complete output from dmesg, but the interesting 
lines are probably:

[    1.470162] ata1.00: HPA detected: current 268435456, native 312581808
[    1.470237] ata1.00: ATA-8: WDC WD1600BEVE-00WZT0, 01.01A01, max UDMA/100
[    1.470308] ata1.00: 268435456 sectors, multi 16: LBA48
[    1.484948] ata1.00: configured for UDMA/100
[    1.485216] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVE-0 
01.0 PQ: 0 ANSI: 5
[    1.485487] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.485651] sd 0:0:0:0: [sda] 268435456 512-byte hardware sectors: 
(137 GB/128 GiB)

Do you think I can fix the issue and circumvent the BIOS by passing the 
real geomerty of the drive as kernel boot parameters? This may also have 
the nice side effect that I could utilize the full capacity of the 
drive. I'll definitly do some experiments in this direction and let you 
know immediately if I succeed. Please let me know if this may be a waste 
of time or if you know an appropriate fix.

Regards,

Christof

christof@fossie:~$ dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30-020630-generic (root@zinc) (gcc 
version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #020630 SMP Wed Jun 10 09:45:40 
UTC 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005ff70000 (usable)
[    0.000000]  BIOS-e820: 000000005ff70000 - 000000005ff7c000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005ff7c000 - 000000005ff80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000005ff80000 - 0000000060000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffff000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x5ff70 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E3FFF uncachable
[    0.000000]   E4000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 05FF80000 mask FFFF80000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 
(usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000005ff70000 (usable)
[    0.000000]  modified: 000000005ff70000 - 000000005ff7c000 (ACPI data)
[    0.000000]  modified: 000000005ff7c000 - 000000005ff80000 (ACPI NVS)
[    0.000000]  modified: 000000005ff80000 - 0000000060000000 (reserved)
[    0.000000]  modified: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  modified: 00000000fffff000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] RAMDISK: 37873000 - 37fef743
[    0.000000] Allocated new RAMDISK: 00838000 - 00fb4743
[    0.000000] Move RAMDISK from 0000000037873000 - 0000000037fef742 to 
00838000 - 00fb4742
[    0.000000] ACPI: RSDP 000f6500 00014 (v00 PTLTD )
[    0.000000] ACPI: RSDT 5ff77a1d 00030 (v01 PTLTD    RSDT   06040000  
LTP 00000000)
[    0.000000] ACPI: FACP 5ff7bed2 00074 (v01 HP     08B0     06040000 
PTL  00000050)
[    0.000000] ACPI: DSDT 5ff77e73 0405F (v01 HP     08B0     06040000 
MSFT 0100000E)
[    0.000000] ACPI: FACS 5ff7cfc0 00040
[    0.000000] ACPI: BOOT 5ff7bfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  
LTP 00000001)
[    0.000000] ACPI: SSDT 5ff77a4d 0020E (v01  INTEL  EISTRef 00002000 
INTL 20021002)
[    0.000000] 647MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000833454]    TEXT DATA BSS ==> 
[0000100000 - 0000833454]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> 
[000009f800 - 0000100000]
[    0.000000]   #5 [0000834000 - 00008370f3]              BRK ==> 
[0000834000 - 00008370f3]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> 
[0000007000 - 0000008000]
[    0.000000]   #7 [0000838000 - 0000fb4743]      NEW RAMDISK ==> 
[0000838000 - 0000fb4743]
[    0.000000]   #8 [0000008000 - 000000f000]          BOOTMAP ==> 
[0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0005ff70
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005ff70
[    0.000000] On node 0 totalpages: 392971
[    0.000000] free_area_init_node: node 0, pgdat c06ee2c0, node_mem_map 
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1295 pages used for memmap
[    0.000000]   HighMem zone: 164451 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 70000000 (gap: 
60000000:9f800000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages at c1c09000, static data 25884 
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  
Total pages: 389900
[    0.000000] Kernel command line: 
root=UUID=0cd94059-4d36-4b42-9c42-9ccf70206ce6 ro vga=ext
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:512
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 996.664 MHz processor.
[    0.004000] Console: colour VGA+ 80x50
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.004000] allocated 7861440 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Initializing HighMem for node 0 (000377fe:0005ff70)
[    0.004000] Memory: 1535104k/1572288k available (4179k kernel code, 
35940k reserved, 2004k data, 528k init, 662984k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.004000]       .init : 0xc0714000 - 0xc0798000   ( 528 kB)
[    0.004000]       .data : 0xc0514e40 - 0xc0709ee8   (2004 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0514e40   (4179 kB)
[    0.004000] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=1
[    0.004022] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 1993.32 BogoMIPS (lpj=3986656)
[    0.004207] Security Framework initialized
[    0.004285] SELinux:  Disabled at boot.
[    0.004360] Mount-cache hash table entries: 512
[    0.004722] Initializing cgroup subsys ns
[    0.004796] Initializing cgroup subsys cpuacct
[    0.004865] Initializing cgroup subsys memory
[    0.004939] Initializing cgroup subsys freezer
[    0.005033] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.005138] CPU: L2 cache: 1024K
[    0.005224] Checking 'hlt' instruction... OK.
[    0.021271] SMP alternatives: switching to UP code
[    0.033279] Freeing SMP alternatives: 28k freed
[    0.033362] ACPI: Core revision 20090320
[    0.043104] ACPI: setting ELCR to 0200 (from 0c00)
[    0.044112] weird, boot CPU (#0) not listed by the BIOS.
[    0.044180] SMP motherboard not detected.
[    0.044244] Local APIC not detected. Using dummy APIC emulation.
[    0.044310] SMP disabled
[    0.044628] Brought up 1 CPUs
[    0.044693] Total of 1 processors activated (1993.32 BogoMIPS).
[    0.044780] CPU0 attaching NULL sched-domain.
[    0.045179] net_namespace: 1056 bytes
[    0.045267] Booting paravirtualized kernel on bare hardware
[    0.045801] regulator: core version 0.5
[    0.045894] Time:  8:29:46  Date: 07/07/09
[    0.046051] NET: Registered protocol family 16
[    0.046350] EISA bus registered
[    0.046435] ACPI: bus type pci registered
[    0.047217] PCI: PCI BIOS revision 2.10 entry at 0xfd9c3, last bus=2
[    0.047285] PCI: Using configuration type 1 for base access
[    0.049667] bio: create slab <bio-0> at 0
[    0.050800] ACPI: EC: Look up EC in DSDT
[    0.055722] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.064109] ACPI: Interpreter enabled
[    0.064181] ACPI: (supports S0 S3 S4 S5)
[    0.064428] ACPI: Using PIC for interrupt routing
[    0.072786] ACPI: EC: GPE = 0x1d, I/O: command/status = 0x66, data = 0x62
[    0.072857] ACPI: EC: driver started in interrupt mode
[    0.073036] ACPI: Power Resource [LRP0] (off)
[    0.073174] ACPI: Power Resource [LRP1] (off)
[    0.073312] ACPI: Power Resource [LRP2] (off)
[    0.073664] ACPI: No dock devices found.
[    0.073748] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.073890] pci 0000:00:00.0: reg 10 32bit mmio: [0xe2000000-0xe3ffffff]
[    0.074027] pci 0000:00:1d.0: reg 20 io port: [0x1800-0x181f]
[    0.074089] pci 0000:00:1d.1: reg 20 io port: [0x1820-0x183f]
[    0.074153] pci 0000:00:1d.2: reg 20 io port: [0x1840-0x185f]
[    0.074223] pci 0000:00:1d.7: reg 10 32bit mmio: [0xd0000000-0xd00003ff]
[    0.074288] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.074360] pci 0000:00:1d.7: PME# disabled
[    0.074520] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 
ACPI/GPIO/TCO
[    0.074608] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH4 
GPIO
[    0.074702] pci 0000:00:1f.1: reg 10 io port: [0x00-0x07]
[    0.074712] pci 0000:00:1f.1: reg 14 io port: [0x00-0x03]
[    0.074722] pci 0000:00:1f.1: reg 18 io port: [0x00-0x07]
[    0.074731] pci 0000:00:1f.1: reg 1c io port: [0x00-0x03]
[    0.074741] pci 0000:00:1f.1: reg 20 io port: [0x1860-0x186f]
[    0.074751] pci 0000:00:1f.1: reg 24 32bit mmio: [0x000000-0x0003ff]
[    0.074811] pci 0000:00:1f.3: reg 20 io port: [0x1880-0x189f]
[    0.074863] pci 0000:00:1f.5: reg 10 io port: [0x1c00-0x1cff]
[    0.074873] pci 0000:00:1f.5: reg 14 io port: [0x18c0-0x18ff]
[    0.074883] pci 0000:00:1f.5: reg 18 32bit mmio: [0xd0000c00-0xd0000dff]
[    0.074892] pci 0000:00:1f.5: reg 1c 32bit mmio: [0xd0000800-0xd00008ff]
[    0.074928] pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
[    0.074997] pci 0000:00:1f.5: PME# disabled
[    0.075094] pci 0000:00:1f.6: reg 10 io port: [0x2400-0x24ff]
[    0.075104] pci 0000:00:1f.6: reg 14 io port: [0x2000-0x207f]
[    0.075147] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.075217] pci 0000:00:1f.6: PME# disabled
[    0.075324] pci 0000:01:00.0: reg 10 32bit mmio: [0xd8000000-0xd8ffffff]
[    0.075333] pci 0000:01:00.0: reg 14 32bit mmio: [0xf0000000-0xf3ffffff]
[    0.075342] pci 0000:01:00.0: reg 18 32bit mmio: [0xe8000000-0xe807ffff]
[    0.075361] pci 0000:01:00.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.075423] pci 0000:00:01.0: bridge 32bit mmio: [0xd8000000-0xdfffffff]
[    0.075430] pci 0000:00:01.0: bridge 32bit mmio pref: 
[0xe8000000-0xf7ffffff]
[    0.075478] pci 0000:02:05.0: reg 10 32bit mmio: [0xe0002000-0xe0002fff]
[    0.075565] pci 0000:02:06.0: reg 10 32bit mmio: [0xe0003000-0xe0003fff]
[    0.075588] pci 0000:02:06.0: supports D1 D2
[    0.075593] pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.075663] pci 0000:02:06.0: PME# disabled
[    0.075762] pci 0000:02:06.1: reg 10 32bit mmio: [0xe0004000-0xe0004fff]
[    0.075786] pci 0000:02:06.1: supports D1 D2
[    0.075790] pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.075861] pci 0000:02:06.1: PME# disabled
[    0.075957] pci 0000:02:06.2: reg 10 io port: [0x4000-0x403f]
[    0.076056] pci 0000:02:07.0: reg 10 32bit mmio: [0xe0000000-0xe0001fff]
[    0.076087] pci 0000:02:07.0: reg 30 32bit mmio: [0x000000-0x003fff]
[    0.076108] pci 0000:02:07.0: supports D1 D2
[    0.076113] pci 0000:02:07.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.076183] pci 0000:02:07.0: PME# disabled
[    0.076282] pci 0000:00:1e.0: transparent bridge
[    0.076349] pci 0000:00:1e.0: bridge io port: [0x3000-0x4fff]
[    0.076357] pci 0000:00:1e.0: bridge 32bit mmio: [0xe0000000-0xe05fffff]
[    0.076407] pci_bus 0000:00: on NUMA node 0
[    0.076418] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.076697] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
[    0.076793] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.083826] ACPI: PCI Interrupt Link [LNKA] (IRQs *11)
[    0.084187] ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
[    0.084546] ACPI: PCI Interrupt Link [LNKC] (IRQs 12) *11
[    0.084946] ACPI: PCI Interrupt Link [LNKD] (IRQs 15) *10
[    0.085343] ACPI: PCI Interrupt Link [LNKE] (IRQs 9 10 11 12 15) *0, 
disabled.
[    0.085951] ACPI: PCI Interrupt Link [LNKF] (IRQs 9 10 11 12 15) *0, 
disabled.
[    0.086562] ACPI: PCI Interrupt Link [LNKG] (IRQs 9 10 11 12 15) *0, 
disabled.
[    0.088237] ACPI: PCI Interrupt Link [LNKH] (IRQs 9 *10 11 12 15)
[    0.088879] SCSI subsystem initialized
[    0.089037] libata version 3.00 loaded.
[    0.089175] usbcore: registered new interface driver usbfs
[    0.089278] usbcore: registered new interface driver hub
[    0.089392] usbcore: registered new device driver usb
[    0.089719] ACPI: WMI: Mapper loaded
[    0.089783] PCI: Using ACPI for IRQ routing
[    0.090091] Bluetooth: Core ver 2.15
[    0.090208] NET: Registered protocol family 31
[    0.090272] Bluetooth: HCI device and connection manager initialized
[    0.090342] Bluetooth: HCI socket layer initialized
[    0.090407] NET: Registered protocol family 8
[    0.090472] NET: Registered protocol family 20
[    0.090581] NetLabel: Initializing
[    0.090643] NetLabel:  domain hash size = 128
[    0.090707] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.090793] NetLabel:  unlabeled traffic allowed by default
[    0.091021] pnp: PnP ACPI init
[    0.092010] ACPI: bus type pnp registered
[    0.096394] pnp: PnP ACPI: found 8 devices
[    0.096460] ACPI: ACPI bus type pnp unregistered
[    0.096527] PnPBIOS: Disabled by ACPI PNP
[    0.096608] system 00:04: ioport range 0x600-0x60f has been reserved
[    0.096677] system 00:04: ioport range 0x700-0x70f has been reserved
[    0.096747] system 00:04: ioport range 0x800-0x807 has been reserved
[    0.096816] system 00:04: ioport range 0x1000-0x107f has been reserved
[    0.096886] system 00:04: ioport range 0x1180-0x11bf has been reserved
[    0.096956] system 00:04: ioport range 0xfe00-0xfe7f has been reserved
[    0.097026] system 00:04: ioport range 0xfe80-0xfeff has been reserved
[    0.097097] system 00:04: iomem range 0xfebfe000-0xfebfefff has been 
reserved
[    0.097168] system 00:04: iomem range 0xfebff000-0xfebfffff has been 
reserved
[    0.097239] system 00:04: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.132097] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.132166] pci 0000:00:01.0:   IO window: disabled
[    0.132235] pci 0000:00:01.0:   MEM window: 0xd8000000-0xdfffffff
[    0.132305] pci 0000:00:01.0:   PREFETCH window: 
0x000000e8000000-0x000000f7ffffff
[    0.132403] pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
[    0.132471] pci 0000:02:06.0:   IO window: 0x003000-0x0030ff
[    0.132540] pci 0000:02:06.0:   IO window: 0x003400-0x0034ff
[    0.132610] pci 0000:02:06.0:   PREFETCH window: 0x70000000-0x73ffffff
[    0.132681] pci 0000:02:06.0:   MEM window: 0x7c000000-0x7fffffff
[    0.132751] pci 0000:02:06.1: CardBus bridge, secondary bus 0000:07
[    0.132821] pci 0000:02:06.1:   IO window: 0x003800-0x0038ff
[    0.132890] pci 0000:02:06.1:   IO window: 0x003c00-0x003cff
[    0.132959] pci 0000:02:06.1:   PREFETCH window: 0x74000000-0x77ffffff
[    0.133030] pci 0000:02:06.1:   MEM window: 0x80000000-0x83ffffff
[    0.133101] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
[    0.133170] pci 0000:00:1e.0:   IO window: 0x3000-0x4fff
[    0.133240] pci 0000:00:1e.0:   MEM window: 0xe0000000-0xe05fffff
[    0.133310] pci 0000:00:1e.0:   PREFETCH window: 
0x00000070000000-0x00000079ffffff
[    0.133414] pci 0000:00:1e.0: setting latency timer to 64
[    0.133425] pci 0000:02:06.0: enabling device (0006 -> 0007)
[    0.133774] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.133842] PCI: setting IRQ 11 as level-triggered
[    0.133851] pci 0000:02:06.0: PCI INT A -> Link[LNKA] -> GSI 11 
(level, low) -> IRQ 11
[    0.133946] pci 0000:02:06.1: enabling device (0006 -> 0007)
[    0.134280] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    0.134347] PCI: setting IRQ 10 as level-triggered
[    0.134355] pci 0000:02:06.1: PCI INT B -> Link[LNKB] -> GSI 10 
(level, low) -> IRQ 10
[    0.134447] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.134453] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.134459] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xdfffffff]
[    0.134464] pci_bus 0000:01: resource 2 pref mem [0xe8000000-0xf7ffffff]
[    0.134470] pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
[    0.134475] pci_bus 0000:02: resource 1 mem: [0xe0000000-0xe05fffff]
[    0.134481] pci_bus 0000:02: resource 2 pref mem [0x70000000-0x79ffffff]
[    0.134486] pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
[    0.134491] pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffff]
[    0.134497] pci_bus 0000:03: resource 0 io:  [0x3000-0x30ff]
[    0.134503] pci_bus 0000:03: resource 1 io:  [0x3400-0x34ff]
[    0.134509] pci_bus 0000:03: resource 2 pref mem [0x70000000-0x73ffffff]
[    0.134516] pci_bus 0000:03: resource 3 mem: [0x7c000000-0x7fffffff]
[    0.134522] pci_bus 0000:07: resource 0 io:  [0x3800-0x38ff]
[    0.134528] pci_bus 0000:07: resource 1 io:  [0x3c00-0x3cff]
[    0.134535] pci_bus 0000:07: resource 2 pref mem [0x74000000-0x77ffffff]
[    0.134541] pci_bus 0000:07: resource 3 mem: [0x80000000-0x83ffffff]
[    0.134611] NET: Registered protocol family 2
[    0.134878] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.135651] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.137552] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.138755] TCP: Hash tables configured (established 131072 bind 65536)
[    0.138827] TCP reno registered
[    0.139113] NET: Registered protocol family 1
[    0.139326] Trying to unpack rootfs image as initramfs...
[    0.836575] Freeing initrd memory: 7665k freed
[    0.850717] Simple Boot Flag at 0x36 set to 0x1
[    0.850839] cpufreq-nforce2: No nForce2 chipset.
[    0.850958] Scanning for low memory corruption every 60 seconds
[    0.851282] audit: initializing netlink socket (disabled)
[    0.851388] type=2000 audit(1246955386.848:1): initialized
[    0.872151] Switched to high resolution mode on CPU 0
[    0.873847] highmem bounce pool size: 64 pages
[    0.873922] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.876974] VFS: Disk quotas dquot_6.5.2
[    0.877162] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.878530] fuse init (API version 7.11)
[    0.878773] msgmni has been set to 1720
[    0.879206] alg: No test for stdrng (krng)
[    0.879293] io scheduler noop registered
[    0.879358] io scheduler anticipatory registered
[    0.879422] io scheduler deadline registered
[    0.879578] io scheduler cfq registered (default)
[    0.879751] pci 0000:01:00.0: Boot video device
[    0.879929] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.880071] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.880861] ACPI: AC Adapter [AC] (on-line)
[    0.881061] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.881148] ACPI: Power Button [PWRF]
[    0.881303] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.881393] ACPI: Power Button [PWRB]
[    0.881686] fan PNP0C0B:00: registered as cooling_device0
[    0.881760] ACPI: Fan [FAN0] (off)
[    0.881979] fan PNP0C0B:01: registered as cooling_device1
[    0.882052] ACPI: Fan [FAN1] (off)
[    0.882271] fan PNP0C0B:02: registered as cooling_device2
[    0.882344] ACPI: Fan [FAN2] (off)
[    0.882898] Marking TSC unstable due to TSC halts in idle
[    0.882990] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.883239] processor ACPI_CPU:00: registered as cooling_device3
[    0.883309] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.888685] thermal LNXTHERM:01: registered as thermal_zone0
[    0.888765] ACPI: Thermal Zone [THRM] (54 C)
[    0.888919] isapnp: Scanning for PnP cards...
[    1.242800] isapnp: No Plug & Play device found
[    1.245037] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.245262] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.247494] serial 00:06: activated
[    1.247703] 00:06: ttyS0 at I/O 0x300 (irq = 4) is a 16550A
[    1.247920] serial 0000:00:1f.6: PCI INT B -> Link[LNKB] -> GSI 10 
(level, low) -> IRQ 10
[    1.248037] serial 0000:00:1f.6: PCI INT B disabled
[    1.249475] brd: module loaded
[    1.250194] loop: module loaded
[    1.250421] input: Macintosh mouse button emulation as 
/devices/virtual/input/input2
[    1.250562] Driver 'sd' needs updating - please use bus_type methods
[    1.250644] Driver 'sr' needs updating - please use bus_type methods
[    1.250837] ata_piix 0000:00:1f.1: version 2.13
[    1.250852] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    1.251220] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 12
[    1.251288] PCI: setting IRQ 12 as level-triggered
[    1.251296] ata_piix 0000:00:1f.1: PCI INT A -> Link[LNKC] -> GSI 12 
(level, low) -> IRQ 12
[    1.251443] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.251677] scsi0 : ata_piix
[    1.251933] scsi1 : ata_piix
[    1.253060] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1860 
irq 14
[    1.253132] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1868 
irq 15
[    1.254431] Fixed MDIO Bus: probed
[    1.254504] PPP generic driver version 2.4.2
[    1.254743] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.255118] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
[    1.255189] ehci_hcd 0000:00:1d.7: PCI INT D -> Link[LNKH] -> GSI 10 
(level, low) -> IRQ 10
[    1.255294] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.255301] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.255471] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    1.259484] ehci_hcd 0000:00:1d.7: debug port 1
[    1.259554] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.259568] ehci_hcd 0000:00:1d.7: irq 10, io mem 0xd0000000
[    1.272034] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.272273] usb usb1: configuration #1 chosen from 1 choice
[    1.272395] hub 1-0:1.0: USB hub found
[    1.272469] hub 1-0:1.0: 6 ports detected
[    1.272751] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.272848] uhci_hcd: USB Universal Host Controller Interface driver
[    1.272967] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKA] -> GSI 11 
(level, low) -> IRQ 11
[    1.273061] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.273085] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.273231] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    1.273341] uhci_hcd 0000:00:1d.0: irq 11, io base 0x00001800
[    1.273560] usb usb2: configuration #1 chosen from 1 choice
[    1.275617] hub 2-0:1.0: USB hub found
[    1.275689] hub 2-0:1.0: 2 ports detected
[    1.276201] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 15
[    1.276269] PCI: setting IRQ 15 as level-triggered
[    1.276278] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 15 
(level, low) -> IRQ 15
[    1.276370] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.276376] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.276516] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    1.276624] uhci_hcd 0000:00:1d.1: irq 15, io base 0x00001820
[    1.276843] usb usb3: configuration #1 chosen from 1 choice
[    1.276958] hub 3-0:1.0: USB hub found
[    1.277029] hub 3-0:1.0: 2 ports detected
[    1.277230] uhci_hcd 0000:00:1d.2: PCI INT C -> Link[LNKC] -> GSI 12 
(level, low) -> IRQ 12
[    1.277322] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.277328] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.277475] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    1.277584] uhci_hcd 0000:00:1d.2: irq 12, io base 0x00001840
[    1.277804] usb usb4: configuration #1 chosen from 1 choice
[    1.277918] hub 4-0:1.0: USB hub found
[    1.277991] hub 4-0:1.0: 2 ports detected
[    1.278290] PNP: No PS/2 controller found. Probing ports directly.
[    1.280978] ACPI: Battery Slot [CMB0] (battery present)
[    1.470162] ata1.00: HPA detected: current 268435456, native 312581808
[    1.470237] ata1.00: ATA-8: WDC WD1600BEVE-00WZT0, 01.01A01, max UDMA/100
[    1.470308] ata1.00: 268435456 sectors, multi 16: LBA48
[    1.484948] ata1.00: configured for UDMA/100
[    1.485216] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BEVE-0 
01.0 PQ: 0 ANSI: 5
[    1.485487] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.485651] sd 0:0:0:0: [sda] 268435456 512-byte hardware sectors: 
(137 GB/128 GiB)
[    1.485764] sd 0:0:0:0: [sda] Write Protect is off
[    1.485831] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.485878] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.486137]  sda:<7>ata2: port disabled. ignoring.
[    1.489939]  sda1 sda2 sda3
[    1.509462] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.528355] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.528526] mice: PS/2 mouse device common for all mice
[    1.528768] rtc_cmos 00:01: RTC can wake from S4
[    1.528895] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    1.528981] rtc0: alarms up to one month, y3k, 242 bytes nvram
[    1.529291] device-mapper: uevent: version 1.0.3
[    1.529593] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) 
initialised: dm-devel@redhat.com
[    1.529853] device-mapper: multipath: version 1.0.5 loaded
[    1.529921] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.530176] EISA: Probing bus 0 at eisa.0
[    1.530247] Cannot allocate resource for EISA slot 1
[    1.530313] Cannot allocate resource for EISA slot 2
[    1.530379] Cannot allocate resource for EISA slot 3
[    1.530444] Cannot allocate resource for EISA slot 4
[    1.530529] EISA: Detected 0 cards.
[    1.530744] cpuidle: using governor ladder
[    1.530920] cpuidle: using governor menu
[    1.532098] TCP cubic registered
[    1.532519] NET: Registered protocol family 10
[    1.533553] lo: Disabled Privacy Extensions
[    1.534368] NET: Registered protocol family 17
[    1.534459] Bluetooth: L2CAP ver 2.13
[    1.534522] Bluetooth: L2CAP socket layer initialized
[    1.534590] Bluetooth: SCO (Voice Link) ver 0.6
[    1.534654] Bluetooth: SCO socket layer initialized
[    1.534762] Bluetooth: RFCOMM socket layer initialized
[    1.534833] Bluetooth: RFCOMM TTY layer initialized
[    1.534900] Bluetooth: RFCOMM ver 1.11
[    1.535339] Using IPI No-Shortcut mode
[    1.535510] PM: Resume from disk failed.
[    1.535531] registered taskstats version 1
[    1.535814]   Magic number: 1:304:472
[    1.535977] acpi LNXSYSTM:00: hash matches
[    1.536097] rtc_cmos 00:01: setting system clock to 2009-07-07 
08:29:47 UTC (1246955387)
[    1.536188] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.536255] EDD information not available.
[    1.536402] Freeing unused kernel memory: 528k freed
[    1.536987] Write protecting the kernel text: 4180k
[    1.537111] Write protecting the kernel read-only data: 1664k
[    1.538165] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input3
[    1.880221] usb 2-2: new low speed USB device using uhci_hcd and 
address 2
[    2.038436] b44 0000:02:07.0: PCI INT A -> Link[LNKC] -> GSI 12 
(level, low) -> IRQ 12
[    2.058517] usb 2-2: configuration #1 chosen from 1 choice
[    2.100850] ssb: Sonics Silicon Backplane found on PCI device 
0000:02:07.0
[    2.100966] b44.c:v2.0
[    2.121534] eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 
00:11:85:5d:db:ae
[    2.300080] usb 4-2: new full speed USB device using uhci_hcd and 
address 2
[    2.430787] usbcore: registered new interface driver hiddev
[    2.448707] input: Jing-Mold USB K/B+Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input4
[    2.448942] generic-usb 0003:05AF:080A.0001: input,hidraw0: USB HID 
v1.10 Keyboard [Jing-Mold USB K/B+Mouse] on usb-0000:00:1d.0-2/input0
[    2.480489] input: Jing-Mold USB K/B+Mouse as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input5
[    2.480738] generic-usb 0003:05AF:080A.0002: input,hidraw1: USB HID 
v1.10 Mouse [Jing-Mold USB K/B+Mouse] on usb-0000:00:1d.0-2/input1
[    2.480862] usbcore: registered new interface driver usbhid
[    2.480931] usbhid: v2.6:USB HID core driver
[    2.530218] usb 4-2: configuration #1 chosen from 1 choice
[    2.686454] PM: Starting manual resume from disk
[    2.686523] PM: Resume from partition 8:2
[    2.686527] PM: Checking hibernation image.
[    2.686761] PM: Resume from disk failed.
[    2.691647] PM: Marking nosave pages: 0000000000002000 - 0000000000006000
[    2.691655] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.691664] PM: Basic memory bitmaps created
[    2.714773] PM: Basic memory bitmaps freed
[    2.752945] kjournald starting.  Commit interval 5 seconds
[    2.753031] EXT3-fs: mounted filesystem with writeback data mode.
[    8.029787] udev: starting version 141
[    8.239238] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    8.239491] usbcore: registered new interface driver btusb
[    8.290509] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    8.308205] Linux agpgart interface v0.103
[    8.326460] agpgart-intel 0000:00:00.0: Intel 855PM Chipset
[    8.328964] agpgart-intel 0000:00:00.0: AGP aperture is 32M @ 0xe2000000
[    8.362746] intel_rng: FWH not detected
[    8.447260] iTCO_vendor_support: vendor-support=0
[    8.497927] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.498109] iTCO_wdt: Found a ICH4-M TCO device (Version=1, 
TCOBASE=0x1060)
[    8.498269] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    8.533558] input: Video Bus as 
/devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/input/input6
[    8.533734] ACPI: Video Device [AGPB] (multi-head: yes  rom: no  
post: no)
[    8.597392] irda_init()
[    8.597414] NET: Registered protocol family 23
[    8.788189] yenta_cardbus 0000:02:06.0: CardBus bridge found [103c:08b0]
[    8.788284] yenta_cardbus 0000:02:06.0: Using CSCINT to route CSC 
interrupts to PCI
[    8.788370] yenta_cardbus 0000:02:06.0: Routing CardBus interrupts to PCI
[    8.788442] yenta_cardbus 0000:02:06.0: TI: mfunc 0x00001022, devctl 0x64
[    8.837946] lib80211: common routines for IEEE802.11 drivers
[    8.838022] lib80211_crypt: registered algorithm 'NULL'
[    8.888844] input: PC Speaker as /devices/platform/pcspkr/input/input7
[    9.036557] yenta_cardbus 0000:02:06.0: ISA IRQ mask 0x00f8, PCI irq 11
[    9.036636] yenta_cardbus 0000:02:06.0: Socket status: 30000086
[    9.036708] pci_bus 0000:02: Raising subordinate bus# of parent bus 
(#02) from #02 to #06
[    9.036817] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge I/O 
window: 0x3000 - 0x4fff
[    9.036907] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x3000-0x4fff: clean.
[    9.037896] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge 
Memory window: 0xe0000000 - 0xe05fffff
[    9.037987] yenta_cardbus 0000:02:06.0: pcmcia: parent PCI bridge 
Memory window: 0x70000000 - 0x79ffffff
[    9.054279] yenta_cardbus 0000:02:06.1: CardBus bridge found [103c:08b0]
[    9.054373] yenta_cardbus 0000:02:06.1: Using CSCINT to route CSC 
interrupts to PCI
[    9.054459] yenta_cardbus 0000:02:06.1: Routing CardBus interrupts to PCI
[    9.054532] yenta_cardbus 0000:02:06.1: TI: mfunc 0x00001022, devctl 0x64
[    9.080470] ieee80211: 802.11 data/management/control stack, git-1.1.13
[    9.080603] ieee80211: Copyright (C) 2004-2005 Intel Corporation 
<jketreno@linux.intel.com>
[    9.190728] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[    9.190806] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[    9.262206] nsc_ircc_pnp_probe() : From PnP, found firbase 0x2F8 ; 
irq 3 ; dma 3.
[    9.262246] nsc-ircc, chip->init
[    9.262322] nsc-ircc, Found chip at base=0x04e
[    9.262410] nsc-ircc, driver loaded (Dag Brattli)
[    9.262479] nsc_ircc_open(), can't get iobase of 0x2f8
[    9.262572] nsc-ircc, Found chip at base=0x04e
[    9.262659] nsc-ircc, driver loaded (Dag Brattli)
[    9.262725] nsc_ircc_open(), can't get iobase of 0x2f8
[    9.263059] nsc-ircc 00:07: disabled
[    9.288666] yenta_cardbus 0000:02:06.1: ISA IRQ mask 0x00f0, PCI irq 10
[    9.288745] yenta_cardbus 0000:02:06.1: Socket status: 30000084
[    9.288817] pci_bus 0000:02: Raising subordinate bus# of parent bus 
(#02) from #06 to #0a
[    9.288914] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge I/O 
window: 0x3000 - 0x4fff
[    9.289005] pcmcia_socket pcmcia_socket1: cs: IO port probe 
0x3000-0x4fff: clean.
[    9.289992] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge 
Memory window: 0xe0000000 - 0xe05fffff
[    9.290083] yenta_cardbus 0000:02:06.1: pcmcia: parent PCI bridge 
Memory window: 0x70000000 - 0x79ffffff
[    9.292837] ipw2100 0000:02:05.0: PCI INT A -> Link[LNKD] -> GSI 15 
(level, low) -> IRQ 15
[    9.293845] ipw2100: Detected Intel PRO/Wireless 2100 Network Connection
[    9.293940] ipw2100 0000:02:05.0: firmware: requesting ipw2100-1.3.fw
[    9.673856] Intel ICH 0000:00:1f.5: PCI INT B -> Link[LNKB] -> GSI 10 
(level, low) -> IRQ 10
[    9.674000] Intel ICH 0000:00:1f.5: setting latency timer to 64
[    9.879838] pcmcia_socket pcmcia_socket1: cs: IO port probe 
0x100-0x3af: clean.
[    9.881866] pcmcia_socket pcmcia_socket1: cs: IO port probe 
0x3e0-0x4ff: excluding 0x4d0-0x4d7
[    9.882888] pcmcia_socket pcmcia_socket1: cs: IO port probe 
0x820-0x8ff: clean.
[    9.883695] pcmcia_socket pcmcia_socket1: cs: IO port probe 
0xc00-0xcf7: clean.
[    9.884949] pcmcia_socket pcmcia_socket1: cs: IO port probe 
0xa00-0xaff: clean.
[    9.885962] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x100-0x3af: clean.
[    9.887936] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x3e0-0x4ff: excluding 0x4d0-0x4d7
[    9.888987] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0x820-0x8ff: clean.
[    9.889794] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xc00-0xcf7: clean.
[    9.890855] pcmcia_socket pcmcia_socket0: cs: IO port probe 
0xa00-0xaff: clean.
[   10.600041] intel8x0_measure_ac97_clock: measured 55343 usecs (2666 
samples)
[   10.600116] intel8x0: clocking to 48000
[   10.816652] lp: driver loaded but no devices found
[   10.913812] Adding 2104504k swap on /dev/sda2.  Priority:-1 extents:1 
across:2104504k
[   11.287054] EXT3 FS on sda3, internal journal
[   14.764229] ttyS1: LSR safety check engaged!
[   15.079475] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   15.079483] Bluetooth: BNEP filters: protocol multicast
[   15.126565] Bridge firewalling registered
[   15.994849] ppdev: user-space parallel port driver
[   20.039573] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   20.046240] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   21.136462] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   22.090587] lib80211_crypt: registered algorithm 'CCMP'
[   22.319478] padlock: VIA PadLock not detected.
[   22.480414] lib80211_crypt: registered algorithm 'TKIP'
[   31.880035] eth1: no IPv6 routers present
[   78.632049] Clocksource tsc unstable (delta = -200115148 ns)
[  987.061108] keyboard.c: can't emulate rawmode for keycode 240
[  987.077103] keyboard.c: can't emulate rawmode for keycode 240
christof@fossie:~$



