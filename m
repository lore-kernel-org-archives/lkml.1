Return-Path: <linux-kernel-owner+w=401wt.eu-S934013AbZIDUje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbZIDUje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933972AbZIDUjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:39:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933976AbZIDUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:39:29 -0400
From: Christian =?utf-8?q?Kr=C3=A4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: linux-pcmcia@lists.infradead.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Fri, 4 Sep 2009 22:39:16 +0200
User-Agent: KMail/1.9.9
Cc: Peter Stuge <peter@stuge.se>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090904043025.2774.qmail@stuge.se>
In-Reply-To: <20090904043025.2774.qmail@stuge.se>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 63862
Message-Id: <200909042239.17180.christian@kraemer-eu.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18vl2GjVE/WtqLDCwwSbEF0zmF5d/AvU5/MbW0
 Sho3bzcII+9lH9u/IdJEBZyApC9wkt0QNDn6WhcxGMTH20Kv91
 oEC/ItV5Mpc1h6YAu/FLySFPnS0ER79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 September 2009 06:30:25 Peter Stuge wrote:
> Parts of the kernel believe it is ok, which is why lspci says irq 11
> for 00:02.0 and 00:02.1, but the value actually configured in the
> CardBus controller hardware is 255 = unconfigured.
>
> lspci -H1 -s 2.0 -xxx might be interesting.

00:02.0 CardBus bridge: Texas Instruments PCI1250 (rev 02)
00: 4c 10 16 ac 07 00 10 02 02 00 07 06 20 a8 82 00
10: 00 10 30 20 a0 00 00 22 00 01 04 b0 00 00 00 24
20: 00 f0 ff 27 00 00 00 28 00 f0 ff 2b 00 10 00 00
30: fc 10 00 00 00 14 00 00 fc 14 00 00 ff 01 00 05
40: 14 10 92 00 01 00 00 00 00 00 00 00 00 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 61 f0 44 00 80 00 00 00 49 81 81 01 43 75 a9 fb
90: c0 02 62 60 00 00 00 00 00 00 00 00 00 00 00 00
a0: 01 00 21 7e 00 80 80 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00


> I hope it'll be resolved, but at this point more information is
> needed. Try the latest vanilla kernel. Try combinations of some
> kernel parameters:
>
> lapic
> pci=biosirq
>
> They will change how the kernel reads and thinks about interrupts.
> It's important to have interrupts working right, but at this point it
> seems there's a more fundamental PCI problem with the CardBus
> bridges. :\

Even I installed gentoo with the 2.6.30.5 downloaded from kernel.org.

When I boot with the "lapic" parameter dmesg says:
[    0.000000] Local APIC disabled by BIOS -- reenabling.
[    0.000000] Could not enable APIC!
I don't know exacly why the lapic couldn't be enabled.

The pci=biosirq seems to brings no changes in the behavior of the card(bus) 
and I couln'd see something very different in dmesg, but i also included the 
output with this parameter.

Maybe this help locating the problem.



dmesg output of a "default" boot (without special parameters):
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.5 (root@livecd) (gcc version 4.1.2 (Gentoo 
4.1.2 p1.0.2)) #1 SMP Fri Sep 4 14:54:02 Local time zone must be set--see zic 
m
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000011fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000011fe0000 - 0000000012000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.0 present.
[    0.000000] last_pfn = 0x11fd0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C9FFF write-protect
[    0.000000]   CA000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FF0000000 write-back
[    0.000000]   1 base 010000000 mask FFE000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) 
==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 0000000011fd0000 (usable)
[    0.000000]  modified: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
[    0.000000]  modified: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
[    0.000000]  modified: 0000000011fe0000 - 0000000012000000 (reserved)
[    0.000000]  modified: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-0000000011fd0000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0011c00000 page 2M
[    0.000000]  0011c00000 - 0011fd0000 page 4k
[    0.000000] kernel direct mapping tables up to 11fd0000 @ 7000-c000
[    0.000000] IBM Thinkpad 600 Series 2645 detected: force use of acpi=noirq
[    0.000000] ACPI: RSDP 000fd6e0 00014 (v00 IBM   )
[    0.000000] ACPI: RSDT 11fd0000 00028 (v01 IBM    TP600    00000001      
00000000)
[    0.000000] ACPI: FACP 11fd0100 00074 (v01 IBM    TP600    00000001      
00000000)
[    0.000000] ACPI: DSDT 11fd0200 0B2E4 (v01 IBM    TP600    00000013 MSFT 
0100000B)
[    0.000000] ACPI: FACS 11fdf000 00040
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 287MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 11fd0000
[    0.000000]   low ram: 0 - 11fd0000
[    0.000000]   node 0 low ram: 00000000 - 11fd0000
[    0.000000]   node 0 bootmap 00008000 - 0000a3fc
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0011fd0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001696d34]    TEXT DATA BSS ==> 
[0001000000 - 0001696d34]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> 
[000009f800 - 0000100000]
[    0.000000]   #5 [0001697000 - 000169e15b]              BRK ==> 
[0001697000 - 000169e15b]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> 
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000b000]          BOOTMAP ==> 
[0000008000 - 000000b000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00011fd0
[    0.000000]   HighMem  0x00011fd0 -> 0x00011fd0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00011fd0
[    0.000000] On node 0 totalpages: 73579
[    0.000000] free_area_init_node: node 0, pgdat c15661a0, node_mem_map 
c169f000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 544 pages used for memmap
[    0.000000]   Normal zone: 69040 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xef08
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 
12000000:edfe0000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages at c18e3000, static data 24380 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 73003
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel root=/dev/hda3
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:2304 nr_irqs:256
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 232.078 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000999] Initializing HighMem for node 0 (00000000:00000000)
[    0.000999] Memory: 284488k/294720k available (3622k kernel code, 9640k 
reserved, 1966k data, 432k init, 0k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xd27d0000 - 0xff7fe000   ( 720 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xd1fd0000   ( 287 MB)
[    0.000999]       .init : 0xc157c000 - 0xc15e8000   ( 432 kB)
[    0.000999]       .data : 0xc13898c3 - 0xc15751b8   (1966 kB)
[    0.000999]       .text : 0xc1000000 - 0xc13898c3   (3622 kB)
[    0.000999] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, 
Nodes=1
[    0.001057] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 464.15 BogoMIPS (lpj=232078)
[    0.001566] Security Framework initialized
[    0.001750] SELinux:  Initializing.
[    0.002092] SELinux:  Starting in permissive mode
[    0.002175] Mount-cache hash table entries: 512
[    0.003587] Initializing cgroup subsys ns
[    0.003753] Initializing cgroup subsys cpuacct
[    0.003917] Initializing cgroup subsys freezer
[    0.004169] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.004369] CPU: L2 cache: 512K
[    0.004511] Intel machine check architecture supported.
[    0.004666] Intel machine check reporting enabled on CPU#0.
[    0.004882] Checking 'hlt' instruction... OK.
[    0.009335] SMP alternatives: switching to UP code
[    0.027890] Freeing SMP alternatives: 15k freed
[    0.028097] ACPI: Core revision 20090320
[    0.103098] ACPI: setting ELCR to 0a00 (from 0800)
[    0.105397] weird, boot CPU (#0) not listed by the BIOS.
[    0.105553] SMP motherboard not detected.
[    0.105691] Local APIC not detected. Using dummy APIC emulation.
[    0.105837] SMP disabled
[    0.107705] Brought up 1 CPUs
[    0.107855] Total of 1 processors activated (464.15 BogoMIPS).
[    0.109909] khelper used greatest stack depth: 7324 bytes left
[    0.111454] net_namespace: 1028 bytes
[    0.114201] Time: 15:10:29  Date: 09/04/09
[    0.114867] NET: Registered protocol family 16
[    0.120177] khelper used greatest stack depth: 7268 bytes left
[    0.122882] EISA bus registered
[    0.123221] ACPI: bus type pci registered
[    0.130598] PCI: PCI BIOS revision 2.10 entry at 0xfd880, last bus=6
[    0.130780] PCI: Using configuration type 1 for base access
[    0.132143] khelper used greatest stack depth: 7180 bytes left
[    0.188162] khelper used greatest stack depth: 7168 bytes left
[    0.220172] khelper used greatest stack depth: 7148 bytes left
[    0.221292] bio: create slab <bio-0> at 0
[    0.232289] ACPI: EC: Look up EC in DSDT
[    0.999446] ACPI: Interpreter enabled
[    0.999616] ACPI: (supports S0 S1 S2 S3 S4 S5)
[    1.001581] ACPI: Using PIC for interrupt routing
[    1.019699] ACPI: EC: non-query interrupt received, switching to interrupt 
mode
[    1.160713] ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
[    1.160887] ACPI: EC: driver started in interrupt mode
[    1.162493] ACPI: Power Resource [PSIO] (on)
[    1.163392] ACPI: Power Resource [PFN0] (off)
[    1.164267] ACPI: Power Resource [PFN1] (off)
[    1.165068] ACPI: Power Resource [PVID] (on)
[    1.165887] ACPI: Power Resource [PRSD] (off)
[    1.166617] ACPI: Power Resource [PDCK] (on)
[    1.179419] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.179703] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.180800] pci 0000:00:00.0: reg 10 32bit mmio: [0x000000-0xfffffff]
[    1.181135] pci 0000:00:02.0: reg 10 32bit mmio: [0x20301000-0x20301fff]
[    1.181218] pci 0000:00:02.0: supports D1 D2
[    1.181247] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
[    1.181433] pci 0000:00:02.0: PME# disabled
[    1.181702] pci 0000:00:02.1: reg 10 32bit mmio: [0x20300000-0x20300fff]
[    1.181779] pci 0000:00:02.1: supports D1 D2
[    1.181808] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot
[    1.182041] pci 0000:00:02.1: PME# disabled
[    1.182323] pci 0000:00:03.0: reg 10 32bit mmio: [0xe0000000-0xe0ffffff]
[    1.182372] pci 0000:00:03.0: reg 14 32bit mmio: [0x20000000-0x201fffff]
[    1.182419] pci 0000:00:03.0: reg 18 32bit mmio: [0x20200000-0x202fffff]
[    1.182780] pci 0000:00:07.1: reg 20 io port: [0xfcf0-0xfcff]
[    1.183044] pci 0000:00:07.2: reg 20 io port: [0x8400-0x841f]
[    1.183173] * Found PM-Timer Bug on the chipset. Due to workarounds for a 
bug,
[    1.183191] * this clock source is slow. Consider trying other clock 
sources
[    1.183722] pci 0000:00:07.3: quirk: region ef00-ef3f claimed by PIIX4 ACPI
[    1.183913] pci 0000:00:07.3: quirk: region efa0-efaf claimed by PIIX4 SMB
[    1.184048] pci 0000:00:07.3: PIIX4 devres B PIO at 02f8-02ff
[    1.184235] pci 0000:00:07.3: PIIX4 devres E PIO at 0538-053f
[    1.184415] pci 0000:00:07.3: PIIX4 devres G PIO at 0130-013f
[    1.184599] pci 0000:00:07.3: PIIX4 devres I PIO at 002e-002f
[    1.184782] pci 0000:00:07.3: PIIX4 devres J PIO at 15e8-15ef
[    1.185277] pci_bus 0000:00: on NUMA node 0
[    1.185369] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.235927] SCSI subsystem initialized
[    1.236667] libata version 3.00 loaded.
[    1.239314] usbcore: registered new interface driver usbfs
[    1.240198] usbcore: registered new interface driver hub
[    1.241316] usbcore: registered new device driver usb
[    1.246290] PCI: Probing PCI hardware
[    1.247390] pci 0000:00:07.0: PIIX/ICH IRQ router [8086:7110]
[    1.247640] PCI: setting IRQ 11 as level-triggered
[    1.247673] pci 0000:00:02.0: found PCI INT A -> IRQ 11
[    1.247884] pci 0000:00:02.0: sharing IRQ 11 with 0000:00:03.0
[    1.248098] pci 0000:00:02.1: found PCI INT B -> IRQ 11
[    1.252147] cfg80211: Using static regulatory domain info
[    1.252336] cfg80211: Regulatory domain: US
[    1.252499]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[    1.252760]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    1.253082]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.253279]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.254038]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.254205]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.254367]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    1.254581] cfg80211: Calling CRDA for country: US
[    1.255462] NetLabel: Initializing
[    1.255606] NetLabel:  domain hash size = 128
[    1.255740] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.256085] NetLabel:  unlabeled traffic allowed by default
[    1.257905] pnp: PnP ACPI init
[    1.258180] ACPI: bus type pnp registered
[    1.264419] pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 
0 (0x0-0xfffffff), disabling
[    1.264716] pnp 00:00: mem resource (0xc0000-0xcbfff) overlaps 0000:00:00.0 
BAR 0 (0x0-0xfffffff), disabling
[    1.265060] pnp 00:00: mem resource (0xf0000-0xfffff) overlaps 0000:00:00.0 
BAR 0 (0x0-0xfffffff), disabling
[    1.265358] pnp 00:00: mem resource (0x100000-0x11ffffff) overlaps 
0000:00:00.0 BAR 0 (0x0-0xfffffff), disabling
[    1.359270] pnp: PnP ACPI: found 18 devices
[    1.359424] ACPI: ACPI bus type pnp unregistered
[    1.359660] system 00:00: iomem range 0xfffe0000-0xffffffff has been 
reserved
[    1.359911] system 00:0d: ioport range 0x15e0-0x15ef has been reserved
[    1.360137] system 00:0d: ioport range 0xef00-0xef3f has been reserved
[    1.360311] system 00:0d: ioport range 0xefa0-0xefaf has been reserved
[    1.403949] pci 0000:00:02.0: CardBus bridge, secondary bus 0000:01
[    1.404184] pci 0000:00:02.0:   IO window: 0x001000-0x0010ff
[    1.404370] pci 0000:00:02.0:   IO window: 0x001400-0x0014ff
[    1.404555] pci 0000:00:02.0:   PREFETCH window: 0x24000000-0x27ffffff
[    1.404742] pci 0000:00:02.0:   MEM window: 0x28000000-0x2bffffff
[    1.404903] pci 0000:00:02.1: CardBus bridge, secondary bus 0000:05
[    1.405101] pci 0000:00:02.1:   IO window: 0x001800-0x0018ff
[    1.405263] pci 0000:00:02.1:   IO window: 0x001c00-0x001cff
[    1.405421] pci 0000:00:02.1:   PREFETCH window: 0x2c000000-0x2fffffff
[    1.405584] pci 0000:00:02.1:   MEM window: 0x30000000-0x33ffffff
[    1.405795] pci 0000:00:02.0: found PCI INT A -> IRQ 11
[    1.406037] pci 0000:00:02.0: sharing IRQ 11 with 0000:00:03.0
[    1.406282] pci 0000:00:02.1: found PCI INT B -> IRQ 11
[    1.406525] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.406560] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    1.406595] pci_bus 0000:01: resource 0 io:  [0x1000-0x10ff]
[    1.406627] pci_bus 0000:01: resource 1 io:  [0x1400-0x14ff]
[    1.406659] pci_bus 0000:01: resource 2 pref mem [0x24000000-0x27ffffff]
[    1.406693] pci_bus 0000:01: resource 3 mem: [0x28000000-0x2bffffff]
[    1.406726] pci_bus 0000:05: resource 0 io:  [0x1800-0x18ff]
[    1.406757] pci_bus 0000:05: resource 1 io:  [0x1c00-0x1cff]
[    1.406790] pci_bus 0000:05: resource 2 pref mem [0x2c000000-0x2fffffff]
[    1.406823] pci_bus 0000:05: resource 3 mem: [0x30000000-0x33ffffff]
[    1.407227] NET: Registered protocol family 2
[    1.408432] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    1.412085] TCP established hash table entries: 16384 (order: 5, 131072 
bytes)
[    1.413292] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    1.414430] TCP: Hash tables configured (established 16384 bind 16384)
[    1.414618] TCP reno registered
[    1.415591] NET: Registered protocol family 1
[    1.419159] Machine check exception polling timer started.
[    1.425252] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, 
Peter Oruba
[    1.425479] Scanning for low memory corruption every 60 seconds
[    1.430278] audit: initializing netlink socket (disabled)
[    1.430537] type=2000 audit(1252077030.429:1): initialized
[    1.511521] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.560269] VFS: Disk quotas dquot_6.5.2
[    1.561656] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.575793] msgmni has been set to 556
[    1.577678] SELinux:  Registering netfilter hooks
[    1.579484] cryptomgr_test used greatest stack depth: 6944 bytes left
[    1.583472] alg: No test for stdrng (krng)
[    1.584646] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    1.584917] io scheduler noop registered
[    1.585165] io scheduler anticipatory registered
[    1.585342] io scheduler deadline registered
[    1.586635] io scheduler cfq registered (default)
[    1.586879] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.587186] pci 0000:00:03.0: Boot video device
[    1.587265] pci 0000:00:07.2: uhci_check_and_reset_hc: legsup = 0x2000
[    1.587292] pci 0000:00:07.2: Performing full reset
[    1.589503] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.593884] ACPI: AC Adapter [AC] (on-line)
[    1.596571] input: Power Button 
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.596798] ACPI: Power Button [PWRF]
[    1.598229] input: Lid Switch 
as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.599834] ACPI: Lid Switch [LID0]
[    1.601231] input: Sleep Button 
as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.601516] ACPI: Sleep Button [SLPB]
[    1.604606] fan PNP0C0B:00: registered as cooling_device0
[    1.604833] ACPI: Fan [FN00] (off)
[    1.606968] fan PNP0C0B:01: registered as cooling_device1
[    1.607263] ACPI: Fan [FN01] (off)
[    1.609371] fan PNP0C0B:02: registered as cooling_device2
[    1.609575] ACPI: Fan [FN20] (off)
[    1.611656] fan PNP0C0B:03: registered as cooling_device3
[    1.611860] ACPI: Fan [FN21] (off)
[    1.613964] fan PNP0C0B:04: registered as cooling_device4
[    1.614258] ACPI: Fan [FN60] (off)
[    1.616413] fan PNP0C0B:05: registered as cooling_device5
[    1.616637] ACPI: Fan [FN61] (off)
[    1.622827] input: Video Bus 
as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/input/input3
[    1.623160] ACPI: Video Device [VID0] (multi-head: yes  rom: no  post: no)
[    1.624395] Marking TSC unstable due to TSC halts in idle
[    1.625075] Switched to high resolution mode on CPU 0
[    1.625313] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.626377] processor ACPI_CPU:00: registered as cooling_device6
[    1.709170] thermal LNXTHERM:01: registered as thermal_zone0
[    1.709389] ACPI: Thermal Zone [THM0] (57 C)
[    1.725787] thermal LNXTHERM:02: registered as thermal_zone1
[    1.726004] ACPI: Thermal Zone [THM2] (42 C)
[    1.741416] thermal LNXTHERM:03: registered as thermal_zone2
[    1.741631] ACPI: Thermal Zone [THM6] (27 C)
[    1.748555] ACPI: Battery Slot [BAT0] (battery absent)
[    1.751949] khelper used greatest stack depth: 6832 bytes left
[    1.829932] Non-volatile memory driver v1.3
[    1.830565] Linux agpgart interface v0.103
[    1.832898] [drm] Initialized drm 1.1.0 20060810
[    1.833443] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.078276] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    2.083317] serial 00:03: unable to assign resources
[    2.083525] serial: probe of 00:03 failed with error -16
[    2.114950] brd: module loaded
[    2.129203] loop: module loaded
[    2.129350] Uniform Multi-Platform E-IDE driver
[    2.130920] piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
[    2.131336] piix 0000:00:07.1: not 100% native mode: will probe irqs later
[    2.131522]     ide0: BM-DMA at 0xfcf0-0xfcf7
[    2.131714]     ide1: BM-DMA at 0xfcf8-0xfcff
[    2.131891] Probing IDE interface ide0...
[    2.395317] hda: IBM-DADA-26480, ATA DISK drive
[    2.750260] async/0 used greatest stack depth: 6752 bytes left
[    3.007896] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    3.008238] hda: UDMA/33 mode selected
[    3.008707] Probing IDE interface ide1...
[    3.680317] hdc: SANYO CRD-S372B, ATAPI CD/DVD-ROM drive
[    3.986857] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    3.987133] hdc: MWDMA2 mode selected
[    3.987695] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    3.988218] ide1 at 0x170-0x177,0x376 on irq 15
[    3.991777] ide-gd driver 1.18
[    3.992274] hda: max request size: 128KiB
[    4.044352] hda: 12594960 sectors (6448 MB) w/460KiB Cache, CHS=13328/15/63
[    4.044647] hda: cache flushes not supported
[    4.045224]  hda: hda1 hda2 hda3
[    4.094282] ide-cd driver 5.00
[    4.095487] ide-cd: hdc: ATAPI 24X CD-ROM drive, 256kB Cache
[    4.095866] Uniform CD-ROM driver Revision: 3.20
[    4.106483] Driver 'sd' needs updating - please use bus_type methods
[    4.107358] Driver 'sr' needs updating - please use bus_type methods
[    4.114255] console [netcon0] enabled
[    4.114422] netconsole: network logging started
[    4.116235] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.116429] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    4.117308] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.117475] ohci_hcd: block sizes: ed 64 td 64
[    4.118288] uhci_hcd: USB Universal Host Controller Interface driver
[    4.118844] uhci_hcd 0000:00:07.2: found PCI INT D -> IRQ 11
[    4.119243] uhci_hcd 0000:00:07.2: UHCI Host Controller
[    4.120331] drivers/usb/core/inode.c: creating file 'devices'
[    4.120411] drivers/usb/core/inode.c: creating file '001'
[    4.121388] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus 
number 1
[    4.121643] uhci_hcd 0000:00:07.2: detected 2 ports
[    4.121803] uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.121830] uhci_hcd 0000:00:07.2: Performing full reset
[    4.121872] uhci_hcd 0000:00:07.2: supports USB remote wakeup
[    4.121947] uhci_hcd 0000:00:07.2: irq 11, io base 0x00008400
[    4.122652] usb usb1: default language 0x0409
[    4.122734] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.122907] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.123203] usb usb1: Product: UHCI Host Controller
[    4.123358] usb usb1: Manufacturer: Linux 2.6.30.5 uhci_hcd
[    4.123508] usb usb1: SerialNumber: 0000:00:07.2
[    4.124232] usb usb1: uevent
[    4.124869] usb usb1: usb_probe_device
[    4.124905] usb usb1: configuration #1 chosen from 1 choice
[    4.125248] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.125438] usb 1-0:1.0: uevent
[    4.126160] hub 1-0:1.0: usb_probe_interface
[    4.126192] hub 1-0:1.0: usb_probe_interface - got id
[    4.126220] hub 1-0:1.0: USB hub found
[    4.126466] hub 1-0:1.0: 2 ports detected
[    4.126639] hub 1-0:1.0: standalone hub
[    4.126662] hub 1-0:1.0: no power switching (usb 1.0)
[    4.126685] hub 1-0:1.0: individual port over-current protection
[    4.126713] hub 1-0:1.0: power on to power good time: 2ms
[    4.126766] hub 1-0:1.0: local power source is good
[    4.126796] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.128450] drivers/usb/core/inode.c: creating file '001'
[    4.130888] usbcore: registered new interface driver usblp
[    4.131219] Initializing USB Mass Storage driver...
[    4.132222] usbcore: registered new interface driver usb-storage
[    4.132425] USB Mass Storage support registered.
[    4.133367] usbcore: registered new interface driver libusual
[    4.135235] PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:MOU0] at 0x60,0x64 
irq 1,12
[    4.151097] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.151298] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.152657] mice: PS/2 mouse device common for all mice
[    4.159300] rtc_cmos 00:11: RTC can wake from S4
[    4.160576] rtc_cmos 00:11: rtc core: registered rtc_cmos as rtc0
[    4.160838] rtc0: alarms up to one month, y3k, 242 bytes nvram
[    4.166530] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
[    4.167769] input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input4
[    4.171323] EISA: Probing bus 0 at eisa.0
[    4.174551] cpuidle: using governor ladder
[    4.178649] cpuidle: using governor menu
[    4.198699] usbcore: registered new interface driver hiddev
[    4.199633] usbcore: registered new interface driver usbhid
[    4.199834] usbhid: v2.6:USB HID core driver
[    4.204784] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    4.204945] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.205225] thinkpad_acpi: ThinkPad BIOS IBET41WW, EC unknown
[    4.208311] Registered led device: tpacpi::power
[    4.209269] Registered led device: tpacpi:orange:batt
[    4.210235] Registered led device: tpacpi:green:batt
[    4.211218] Registered led device: tpacpi::dock_active
[    4.212166] Registered led device: tpacpi::bay_active
[    4.212981] Registered led device: tpacpi::dock_batt
[    4.213921] Registered led device: tpacpi::unknown_led
[    4.215382] Registered led device: tpacpi::standby
[    4.215559] thinkpad_acpi: warning: userspace override of important 
firmware LEDs is enabled
[    4.226472] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.235465] input: ThinkPad Extra Buttons as /devices/virtual/input/input5
[    4.236702] Netfilter messages via NETLINK v0.30.
[    4.236994] nf_conntrack version 0.5.0 (4605 buckets, 18420 max)
[    4.240883] ctnetlink v0.93: registering with nfnetlink.
[    4.250809] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.251293] TCP cubic registered
[    4.251434] Initializing XFRM netlink socket
[    4.257148] NET: Registered protocol family 10
[    4.269179] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.270256] IPv6 over IPv4 tunneling driver
[    4.281268] NET: Registered protocol family 17
[    4.284273] RPC: Registered udp transport module.
[    4.284453] RPC: Registered tcp transport module.
[    4.284858] Using IPI No-Shortcut mode
[    4.287616] PM: Resume from disk failed.
[    4.287759] registered taskstats version 1
[    4.288861]   Magic number: 9:524:183
[    4.392111] Clocksource tsc unstable (delta = -93920418 ns)
[    4.964973] IBM TrackPoint firmware: 0x0b, buttons: 3/3
[    4.996623] input: TPPS/2 IBM TrackPoint 
as /devices/platform/i8042/serio1/input/input6
[    5.006147] md: Waiting for all devices to be available before autodetect
[    5.006315] md: If you don't use raid, use raid=noautodetect
[    5.008587] md: Autodetecting RAID arrays.
[    5.008741] md: Scanned 0 and added 0 devices.
[    5.008874] md: autorun ...
[    5.008998] md: ... autorun DONE.
[    5.073323] kjournald starting.  Commit interval 5 seconds
[    5.073561] EXT3-fs: mounted filesystem with writeback data mode.
[    5.073804] VFS: Mounted root (ext3 filesystem) readonly on device 3:3.
[    5.074571] Freeing unused kernel memory: 432k freed
[    5.078862] Write protecting the kernel text: 3624k
[    5.079481] Write protecting the kernel read-only data: 1676k
[    5.204152] usb usb1: suspend_rh (auto-stop)
[    6.704215] hub 1-0:1.0: hub_suspend
[    6.704279] usb usb1: bus auto-suspend
[    6.704309] usb usb1: suspend_rh
[    6.938214] consoletype used greatest stack depth: 6700 bytes left
[    7.123701] stty used greatest stack depth: 6432 bytes left
[    7.259958] grep used greatest stack depth: 6248 bytes left
[    9.803524] usb usb1: uevent
[    9.803825] usb 1-0:1.0: uevent
[   10.314259] udevtrigger used greatest stack depth: 6180 bytes left
[   16.314813] yenta_cardbus 0000:00:02.0: CardBus bridge found [1014:0092]
[   16.314896] yenta_cardbus 0000:00:02.0: Enabling burst memory read 
transactions
[   16.314933] yenta_cardbus 0000:00:02.0: Using CSCINT to route CSC 
interrupts to PCI
[   16.314963] yenta_cardbus 0000:00:02.0: Routing CardBus interrupts to PCI
[   16.315000] yenta_cardbus 0000:00:02.0: TI: mfunc 0xfba97543, devctl 0x62
[   16.542728] yenta_cardbus 0000:00:02.0: ISA IRQ mask 0x0498, PCI irq 11
[   16.542765] yenta_cardbus 0000:00:02.0: Socket status: 30000006
[   16.544025] yenta_cardbus 0000:00:02.1: CardBus bridge found [1014:0092]
[   16.544204] yenta_cardbus 0000:00:02.1: Using CSCINT to route CSC 
interrupts to PCI
[   16.544238] yenta_cardbus 0000:00:02.1: Routing CardBus interrupts to PCI
[   16.544276] yenta_cardbus 0000:00:02.1: TI: mfunc 0xfba97543, devctl 0x62
[   16.767887] yenta_cardbus 0000:00:02.1: ISA IRQ mask 0x0498, PCI irq 11
[   16.767923] yenta_cardbus 0000:00:02.1: Socket status: 30000006
[   31.021280] EXT3 FS on hda3, internal journal
[   32.241860] cp used greatest stack depth: 6088 bytes left
[   38.934727] Adding 506512k swap on /dev/hda2.  Priority:-1 extents:1 
across:506512k














dmesg output of a boot with pci=biosirq:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.30.5 (root@livecd) (gcc version 4.1.2 (Gentoo 
4.1.2 p1.0.2)) #1 SMP Fri Sep 4 14:54:02 Local time zone must be set--see zic 
m
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000011fd0000 (usable)
[    0.000000]  BIOS-e820: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000011fe0000 - 0000000012000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.0 present.
[    0.000000] last_pfn = 0x11fd0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C9FFF write-protect
[    0.000000]   CA000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FF0000000 write-back
[    0.000000]   1 base 010000000 mask FFE000000 write-back
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] e820 update range: 0000000000002000 - 0000000000006000 (usable) 
==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000002000 (usable)
[    0.000000]  modified: 0000000000002000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009fc00 (usable)
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 0000000011fd0000 (usable)
[    0.000000]  modified: 0000000011fd0000 - 0000000011fdf000 (ACPI data)
[    0.000000]  modified: 0000000011fdf000 - 0000000011fe0000 (ACPI NVS)
[    0.000000]  modified: 0000000011fe0000 - 0000000012000000 (reserved)
[    0.000000]  modified: 00000000fffe0000 - 0000000100000000 (reserved)
[    0.000000] init_memory_mapping: 0000000000000000-0000000011fd0000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0011c00000 page 2M
[    0.000000]  0011c00000 - 0011fd0000 page 4k
[    0.000000] kernel direct mapping tables up to 11fd0000 @ 7000-c000
[    0.000000] IBM Thinkpad 600 Series 2645 detected: force use of acpi=noirq
[    0.000000] ACPI: RSDP 000fd6e0 00014 (v00 IBM   )
[    0.000000] ACPI: RSDT 11fd0000 00028 (v01 IBM    TP600    00000001      
00000000)
[    0.000000] ACPI: FACP 11fd0100 00074 (v01 IBM    TP600    00000001      
00000000)
[    0.000000] ACPI: DSDT 11fd0200 0B2E4 (v01 IBM    TP600    00000013 MSFT 
0100000B)
[    0.000000] ACPI: FACS 11fdf000 00040
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 287MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 11fd0000
[    0.000000]   low ram: 0 - 11fd0000
[    0.000000]   node 0 low ram: 00000000 - 11fd0000
[    0.000000]   node 0 bootmap 00008000 - 0000a3fc
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0011fd0000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> 
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> 
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001696d34]    TEXT DATA BSS ==> 
[0001000000 - 0001696d34]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved ==> 
[000009f800 - 0000100000]
[    0.000000]   #5 [0001697000 - 000169e15b]              BRK ==> 
[0001697000 - 000169e15b]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==> 
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000b000]          BOOTMAP ==> 
[0000008000 - 000000b000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00011fd0
[    0.000000]   HighMem  0x00011fd0 -> 0x00011fd0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000002
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00011fd0
[    0.000000] On node 0 totalpages: 73579
[    0.000000] free_area_init_node: node 0, pgdat c15661a0, node_mem_map 
c169f000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3963 pages, LIFO batch:0
[    0.000000]   Normal zone: 544 pages used for memmap
[    0.000000]   Normal zone: 69040 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xef08
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] Local APIC disabled by BIOS -- you can enable it with "lapic"
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 0000000000002000 - 
0000000000006000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 
12000000:edfe0000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages at c18e3000, static data 24380 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 73003
[    0.000000] Kernel command line: BOOT_IMAGE=/kernel root=/dev/hda3 
pci=biosirq
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Initializing CPU#0
[    0.000000] Experimental hierarchical RCU implementation.
[    0.000000] Experimental hierarchical RCU init done.
[    0.000000] NR_IRQS:2304 nr_irqs:256
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 232.107 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000999] Initializing HighMem for node 0 (00000000:00000000)
[    0.000999] Memory: 284488k/294720k available (3622k kernel code, 9640k 
reserved, 1966k data, 432k init, 0k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xd27d0000 - 0xff7fe000   ( 720 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xd1fd0000   ( 287 MB)
[    0.000999]       .init : 0xc157c000 - 0xc15e8000   ( 432 kB)
[    0.000999]       .data : 0xc13898c3 - 0xc15751b8   (1966 kB)
[    0.000999]       .text : 0xc1000000 - 0xc13898c3   (3622 kB)
[    0.000999] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, 
Nodes=1
[    0.001057] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 464.21 BogoMIPS (lpj=232107)
[    0.001570] Security Framework initialized
[    0.001760] SELinux:  Initializing.
[    0.002092] SELinux:  Starting in permissive mode
[    0.002175] Mount-cache hash table entries: 512
[    0.003589] Initializing cgroup subsys ns
[    0.003778] Initializing cgroup subsys cpuacct
[    0.003966] Initializing cgroup subsys freezer
[    0.004169] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.004392] CPU: L2 cache: 512K
[    0.004554] Intel machine check architecture supported.
[    0.004735] Intel machine check reporting enabled on CPU#0.
[    0.005101] Checking 'hlt' instruction... OK.
[    0.009333] SMP alternatives: switching to UP code
[    0.027914] Freeing SMP alternatives: 15k freed
[    0.028097] ACPI: Core revision 20090320
[    0.103079] ACPI: setting ELCR to 0a00 (from 0800)
[    0.105023] weird, boot CPU (#0) not listed by the BIOS.
[    0.105180] SMP motherboard not detected.
[    0.105320] Local APIC not detected. Using dummy APIC emulation.
[    0.105465] SMP disabled
[    0.107333] Brought up 1 CPUs
[    0.107483] Total of 1 processors activated (464.21 BogoMIPS).
[    0.109542] khelper used greatest stack depth: 7324 bytes left
[    0.111085] net_namespace: 1028 bytes
[    0.113724] Time: 15:25:18  Date: 09/04/09
[    0.114464] NET: Registered protocol family 16
[    0.122374] EISA bus registered
[    0.122678] ACPI: bus type pci registered
[    0.130079] PCI: PCI BIOS revision 2.10 entry at 0xfd880, last bus=6
[    0.130269] PCI: Using configuration type 1 for base access
[    0.143163] khelper used greatest stack depth: 7240 bytes left
[    0.167165] khelper used greatest stack depth: 7196 bytes left
[    0.197156] khelper used greatest stack depth: 7156 bytes left
[    0.220811] bio: create slab <bio-0> at 0
[    0.231862] ACPI: EC: Look up EC in DSDT
[    0.998790] ACPI: Interpreter enabled
[    0.999038] ACPI: (supports S0 S1 S2 S3 S4 S5)
[    1.000958] ACPI: Using PIC for interrupt routing
[    1.019219] ACPI: EC: non-query interrupt received, switching to interrupt 
mode
[    1.158229] khelper used greatest stack depth: 7072 bytes left
[    1.162325] ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
[    1.162491] ACPI: EC: driver started in interrupt mode
[    1.164101] ACPI: Power Resource [PSIO] (on)
[    1.164944] ACPI: Power Resource [PFN0] (off)
[    1.165686] ACPI: Power Resource [PFN1] (off)
[    1.166586] ACPI: Power Resource [PVID] (on)
[    1.167432] ACPI: Power Resource [PRSD] (off)
[    1.168220] ACPI: Power Resource [PDCK] (on)
[    1.180897] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.181161] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.182348] pci 0000:00:00.0: reg 10 32bit mmio: [0x000000-0xfffffff]
[    1.182574] pci 0000:00:02.0: reg 10 32bit mmio: [0x20301000-0x20301fff]
[    1.182653] pci 0000:00:02.0: supports D1 D2
[    1.182682] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot
[    1.182849] pci 0000:00:02.0: PME# disabled
[    1.183166] pci 0000:00:02.1: reg 10 32bit mmio: [0x20300000-0x20300fff]
[    1.183245] pci 0000:00:02.1: supports D1 D2
[    1.183273] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot
[    1.183437] pci 0000:00:02.1: PME# disabled
[    1.183679] pci 0000:00:03.0: reg 10 32bit mmio: [0xe0000000-0xe0ffffff]
[    1.183728] pci 0000:00:03.0: reg 14 32bit mmio: [0x20000000-0x201fffff]
[    1.183775] pci 0000:00:03.0: reg 18 32bit mmio: [0x20200000-0x202fffff]
[    1.184209] pci 0000:00:07.1: reg 20 io port: [0xfcf0-0xfcff]
[    1.184421] pci 0000:00:07.2: reg 20 io port: [0x8400-0x841f]
[    1.184544] * Found PM-Timer Bug on the chipset. Due to workarounds for a 
bug,
[    1.184562] * this clock source is slow. Consider trying other clock 
sources
[    1.185065] pci 0000:00:07.3: quirk: region ef00-ef3f claimed by PIIX4 ACPI
[    1.185240] pci 0000:00:07.3: quirk: region efa0-efaf claimed by PIIX4 SMB
[    1.185409] pci 0000:00:07.3: PIIX4 devres B PIO at 02f8-02ff
[    1.185569] pci 0000:00:07.3: PIIX4 devres E PIO at 0538-053f
[    1.185729] pci 0000:00:07.3: PIIX4 devres G PIO at 0130-013f
[    1.185890] pci 0000:00:07.3: PIIX4 devres I PIO at 002e-002f
[    1.186042] pci 0000:00:07.3: PIIX4 devres J PIO at 15e8-15ef
[    1.186466] pci_bus 0000:00: on NUMA node 0
[    1.186557] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.236866] SCSI subsystem initialized
[    1.237676] libata version 3.00 loaded.
[    1.240232] usbcore: registered new interface driver usbfs
[    1.241151] usbcore: registered new interface driver hub
[    1.242291] usbcore: registered new device driver usb
[    1.247293] PCI: Probing PCI hardware
[    1.248387] pci 0000:00:07.0: PIIX/ICH IRQ router [8086:7110]
[    1.248620] PCI: setting IRQ 11 as level-triggered
[    1.248653] pci 0000:00:02.0: found PCI INT A -> IRQ 11
[    1.248839] pci 0000:00:02.0: sharing IRQ 11 with 0000:00:03.0
[    1.249097] pci 0000:00:02.1: found PCI INT B -> IRQ 11
[    1.252948] cfg80211: Using static regulatory domain info
[    1.253087] cfg80211: Regulatory domain: US
[    1.254028]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[    1.254294]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    1.254479]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.254660]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.254843]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.255037]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    1.255227]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    1.255467] cfg80211: Calling CRDA for country: US
[    1.256425] NetLabel: Initializing
[    1.256595] NetLabel:  domain hash size = 128
[    1.256757] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.257129] NetLabel:  unlabeled traffic allowed by default
[    1.258981] pnp: PnP ACPI init
[    1.259275] ACPI: bus type pnp registered
[    1.265545] pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 
0 (0x0-0xfffffff), disabling
[    1.265796] pnp 00:00: mem resource (0xc0000-0xcbfff) overlaps 0000:00:00.0 
BAR 0 (0x0-0xfffffff), disabling
[    1.266089] pnp 00:00: mem resource (0xf0000-0xfffff) overlaps 0000:00:00.0 
BAR 0 (0x0-0xfffffff), disabling
[    1.266334] pnp 00:00: mem resource (0x100000-0x11ffffff) overlaps 
0000:00:00.0 BAR 0 (0x0-0xfffffff), disabling
[    1.359490] pnp: PnP ACPI: found 18 devices
[    1.359666] ACPI: ACPI bus type pnp unregistered
[    1.359926] system 00:00: iomem range 0xfffe0000-0xffffffff has been 
reserved
[    1.360260] system 00:0d: ioport range 0x15e0-0x15ef has been reserved
[    1.360463] system 00:0d: ioport range 0xef00-0xef3f has been reserved
[    1.360652] system 00:0d: ioport range 0xefa0-0xefaf has been reserved
[    1.404227] pci 0000:00:02.0: CardBus bridge, secondary bus 0000:01
[    1.404419] pci 0000:00:02.0:   IO window: 0x001000-0x0010ff
[    1.404604] pci 0000:00:02.0:   IO window: 0x001400-0x0014ff
[    1.404789] pci 0000:00:02.0:   PREFETCH window: 0x24000000-0x27ffffff
[    1.405029] pci 0000:00:02.0:   MEM window: 0x28000000-0x2bffffff
[    1.405218] pci 0000:00:02.1: CardBus bridge, secondary bus 0000:05
[    1.405393] pci 0000:00:02.1:   IO window: 0x001800-0x0018ff
[    1.405575] pci 0000:00:02.1:   IO window: 0x001c00-0x001cff
[    1.405755] pci 0000:00:02.1:   PREFETCH window: 0x2c000000-0x2fffffff
[    1.405937] pci 0000:00:02.1:   MEM window: 0x30000000-0x33ffffff
[    1.406213] pci 0000:00:02.0: found PCI INT A -> IRQ 11
[    1.406429] pci 0000:00:02.0: sharing IRQ 11 with 0000:00:03.0
[    1.406693] pci 0000:00:02.1: found PCI INT B -> IRQ 11
[    1.406950] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.407033] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    1.407069] pci_bus 0000:01: resource 0 io:  [0x1000-0x10ff]
[    1.407101] pci_bus 0000:01: resource 1 io:  [0x1400-0x14ff]
[    1.407134] pci_bus 0000:01: resource 2 pref mem [0x24000000-0x27ffffff]
[    1.407168] pci_bus 0000:01: resource 3 mem: [0x28000000-0x2bffffff]
[    1.407201] pci_bus 0000:05: resource 0 io:  [0x1800-0x18ff]
[    1.407232] pci_bus 0000:05: resource 1 io:  [0x1c00-0x1cff]
[    1.407264] pci_bus 0000:05: resource 2 pref mem [0x2c000000-0x2fffffff]
[    1.407298] pci_bus 0000:05: resource 3 mem: [0x30000000-0x33ffffff]
[    1.407648] NET: Registered protocol family 2
[    1.408865] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    1.412554] TCP established hash table entries: 16384 (order: 5, 131072 
bytes)
[    1.413761] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    1.414876] TCP: Hash tables configured (established 16384 bind 16384)
[    1.415089] TCP reno registered
[    1.416043] NET: Registered protocol family 1
[    1.419531] Machine check exception polling timer started.
[    1.425576] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, 
Peter Oruba
[    1.425851] Scanning for low memory corruption every 60 seconds
[    1.430653] audit: initializing netlink socket (disabled)
[    1.430890] type=2000 audit(1252077919.429:1): initialized
[    1.511883] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.560541] VFS: Disk quotas dquot_6.5.2
[    1.562047] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.576219] msgmni has been set to 556
[    1.578127] SELinux:  Registering netfilter hooks
[    1.579818] cryptomgr_test used greatest stack depth: 6944 bytes left
[    1.583803] alg: No test for stdrng (krng)
[    1.585027] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    1.585251] io scheduler noop registered
[    1.585387] io scheduler anticipatory registered
[    1.585527] io scheduler deadline registered
[    1.586789] io scheduler cfq registered (default)
[    1.587131] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.587376] pci 0000:00:03.0: Boot video device
[    1.587451] pci 0000:00:07.2: uhci_check_and_reset_hc: legsup = 0x2000
[    1.587478] pci 0000:00:07.2: Performing full reset
[    1.589663] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.594072] ACPI: AC Adapter [AC] (on-line)
[    1.596711] input: Power Button 
as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.597019] ACPI: Power Button [PWRF]
[    1.598390] input: Lid Switch 
as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    1.600430] ACPI: Lid Switch [LID0]
[    1.601716] input: Sleep Button 
as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    1.602009] ACPI: Sleep Button [SLPB]
[    1.605118] fan PNP0C0B:00: registered as cooling_device0
[    1.605352] ACPI: Fan [FN00] (off)
[    1.607494] fan PNP0C0B:01: registered as cooling_device1
[    1.607723] ACPI: Fan [FN01] (off)
[    1.609826] fan PNP0C0B:02: registered as cooling_device2
[    1.610150] ACPI: Fan [FN20] (off)
[    1.612281] fan PNP0C0B:03: registered as cooling_device3
[    1.612486] ACPI: Fan [FN21] (off)
[    1.614584] fan PNP0C0B:04: registered as cooling_device4
[    1.614786] ACPI: Fan [FN60] (off)
[    1.616894] fan PNP0C0B:05: registered as cooling_device5
[    1.617191] ACPI: Fan [FN61] (off)
[    1.623370] input: Video Bus 
as /devices/LNXSYSTM:00/device:00/PNP0A03:00/device:01/input/input3
[    1.623665] ACPI: Video Device [VID0] (multi-head: yes  rom: no  post: no)
[    1.624903] Marking TSC unstable due to TSC halts in idle
[    1.625748] ACPI: CPU0 (power states: C1[C1] C2[C2]<7>Switched to high 
resolution mode on CPU 0
[    1.626327] )
[    1.627259] processor ACPI_CPU:00: registered as cooling_device6
[    1.709517] thermal LNXTHERM:01: registered as thermal_zone0
[    1.709758] ACPI: Thermal Zone [THM0] (49 C)
[    1.726022] thermal LNXTHERM:02: registered as thermal_zone1
[    1.726349] ACPI: Thermal Zone [THM2] (42 C)
[    1.742005] thermal LNXTHERM:03: registered as thermal_zone2
[    1.742326] ACPI: Thermal Zone [THM6] (27 C)
[    1.749428] ACPI: Battery Slot [BAT0] (battery absent)
[    1.830217] Non-volatile memory driver v1.3
[    1.830720] Linux agpgart interface v0.103
[    1.833193] [drm] Initialized drm 1.1.0 20060810
[    1.833583] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.078277] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a NS16550A
[    2.083359] serial 00:03: unable to assign resources
[    2.083546] serial: probe of 00:03 failed with error -16
[    2.114935] brd: module loaded
[    2.129159] loop: module loaded
[    2.129326] Uniform Multi-Platform E-IDE driver
[    2.130914] piix 0000:00:07.1: IDE controller (0x8086:0x7111 rev 0x01)
[    2.131326] piix 0000:00:07.1: not 100% native mode: will probe irqs later
[    2.131512]     ide0: BM-DMA at 0xfcf0-0xfcf7
[    2.131704]     ide1: BM-DMA at 0xfcf8-0xfcff
[    2.131880] Probing IDE interface ide0...
[    2.395334] hda: IBM-DADA-26480, ATA DISK drive
[    2.751262] async/0 used greatest stack depth: 6752 bytes left
[    3.007890] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    3.008228] hda: UDMA/33 mode selected
[    3.008674] Probing IDE interface ide1...
[    3.731351] hdc: SANYO CRD-S372B, ATAPI CD/DVD-ROM drive
[    4.037848] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.106566] hdc: MWDMA2 mode selected
[    4.107191] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    4.107621] ide1 at 0x170-0x177,0x376 on irq 15
[    4.111247] ide-gd driver 1.18
[    4.111599] hda: max request size: 128KiB
[    4.159231] hda: 12594960 sectors (6448 MB) w/460KiB Cache, CHS=13328/15/63
[    4.159504] hda: cache flushes not supported
[    4.159969]  hda: hda1 hda2 hda3
[    4.209176] ide-cd driver 5.00
[    4.210301] ide-cd: hdc: ATAPI 24X CD-ROM drive, 256kB Cache
[    4.210654] Uniform CD-ROM driver Revision: 3.20
[    4.221373] Driver 'sd' needs updating - please use bus_type methods
[    4.222259] Driver 'sr' needs updating - please use bus_type methods
[    4.229158] console [netcon0] enabled
[    4.229304] netconsole: network logging started
[    4.230981] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.231283] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[    4.232005] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.232302] ohci_hcd: block sizes: ed 64 td 64
[    4.232988] uhci_hcd: USB Universal Host Controller Interface driver
[    4.233685] uhci_hcd 0000:00:07.2: found PCI INT D -> IRQ 11
[    4.233976] uhci_hcd 0000:00:07.2: UHCI Host Controller
[    4.235193] drivers/usb/core/inode.c: creating file 'devices'
[    4.235252] drivers/usb/core/inode.c: creating file '001'
[    4.236244] uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus 
number 1
[    4.236549] uhci_hcd 0000:00:07.2: detected 2 ports
[    4.236736] uhci_hcd 0000:00:07.2: uhci_check_and_reset_hc: cmd = 0x0000
[    4.236763] uhci_hcd 0000:00:07.2: Performing full reset
[    4.236805] uhci_hcd 0000:00:07.2: supports USB remote wakeup
[    4.236881] uhci_hcd 0000:00:07.2: irq 11, io base 0x00008400
[    4.237596] usb usb1: default language 0x0409
[    4.237678] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    4.237873] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    4.238213] usb usb1: Product: UHCI Host Controller
[    4.238387] usb usb1: Manufacturer: Linux 2.6.30.5 uhci_hcd
[    4.238559] usb usb1: SerialNumber: 0000:00:07.2
[    4.239305] usb usb1: uevent
[    4.239940] usb usb1: usb_probe_device
[    4.239976] usb usb1: configuration #1 chosen from 1 choice
[    4.240330] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[    4.240518] usb 1-0:1.0: uevent
[    4.241238] hub 1-0:1.0: usb_probe_interface
[    4.241268] hub 1-0:1.0: usb_probe_interface - got id
[    4.241296] hub 1-0:1.0: USB hub found
[    4.241518] hub 1-0:1.0: 2 ports detected
[    4.241663] hub 1-0:1.0: standalone hub
[    4.241685] hub 1-0:1.0: no power switching (usb 1.0)
[    4.241708] hub 1-0:1.0: individual port over-current protection
[    4.241736] hub 1-0:1.0: power on to power good time: 2ms
[    4.241789] hub 1-0:1.0: local power source is good
[    4.241819] hub 1-0:1.0: trying to enable port power on non-switchable hub
[    4.243515] drivers/usb/core/inode.c: creating file '001'
[    4.245926] usbcore: registered new interface driver usblp
[    4.246233] Initializing USB Mass Storage driver...
[    4.247211] usbcore: registered new interface driver usb-storage
[    4.247389] USB Mass Storage support registered.
[    4.248308] usbcore: registered new interface driver libusual
[    4.250154] PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:MOU0] at 0x60,0x64 
irq 1,12
[    4.266464] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.266683] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.268155] mice: PS/2 mouse device common for all mice
[    4.274775] rtc_cmos 00:11: RTC can wake from S4
[    4.275969] rtc_cmos 00:11: rtc core: registered rtc_cmos as rtc0
[    4.276372] rtc0: alarms up to one month, y3k, 242 bytes nvram
[    4.281932] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
[    4.283257] input: AT Translated Set 2 keyboard 
as /devices/platform/i8042/serio0/input/input4
[    4.286627] EISA: Probing bus 0 at eisa.0
[    4.289864] cpuidle: using governor ladder
[    4.294143] cpuidle: using governor menu
[    4.313763] usbcore: registered new interface driver hiddev
[    4.314686] usbcore: registered new interface driver usbhid
[    4.316000] usbhid: v2.6:USB HID core driver
[    4.320631] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    4.320814] thinkpad_acpi: http://ibm-acpi.sf.net/
[    4.320979] thinkpad_acpi: ThinkPad BIOS IBET41WW, EC unknown
[    4.322551] Registered led device: tpacpi::power
[    4.323858] Registered led device: tpacpi:orange:batt
[    4.324800] Registered led device: tpacpi:green:batt
[    4.325759] Registered led device: tpacpi::dock_active
[    4.326681] Registered led device: tpacpi::bay_active
[    4.327585] Registered led device: tpacpi::dock_batt
[    4.328532] Registered led device: tpacpi::unknown_led
[    4.329569] Registered led device: tpacpi::standby
[    4.329722] thinkpad_acpi: warning: userspace override of important 
firmware LEDs is enabled
[    4.341290] hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0000
[    4.348659] input: ThinkPad Extra Buttons as /devices/virtual/input/input5
[    4.350544] Netfilter messages via NETLINK v0.30.
[    4.350865] nf_conntrack version 0.5.0 (4605 buckets, 18420 max)
[    4.354733] ctnetlink v0.93: registering with nfnetlink.
[    4.364771] ip_tables: (C) 2000-2006 Netfilter Core Team
[    4.365239] TCP cubic registered
[    4.365380] Initializing XFRM netlink socket
[    4.370974] NET: Registered protocol family 10
[    4.383256] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    4.384364] IPv6 over IPv4 tunneling driver
[    4.395270] NET: Registered protocol family 17
[    4.398261] RPC: Registered udp transport module.
[    4.398415] RPC: Registered tcp transport module.
[    4.398793] Using IPI No-Shortcut mode
[    4.401582] PM: Resume from disk failed.
[    4.401725] registered taskstats version 1
[    4.402844]   Magic number: 9:283:436
[    4.895107] Clocksource tsc unstable (delta = -448627999 ns)
[    5.140923] IBM TrackPoint firmware: 0x0b, buttons: 3/3
[    5.173391] input: TPPS/2 IBM TrackPoint 
as /devices/platform/i8042/serio1/input/input6
[    5.182829] md: Waiting for all devices to be available before autodetect
[    5.182999] md: If you don't use raid, use raid=noautodetect
[    5.185359] md: Autodetecting RAID arrays.
[    5.185513] md: Scanned 0 and added 0 devices.
[    5.185647] md: autorun ...
[    5.185771] md: ... autorun DONE.
[    5.245190] kjournald starting.  Commit interval 5 seconds
[    5.245433] EXT3-fs: mounted filesystem with writeback data mode.
[    5.245677] VFS: Mounted root (ext3 filesystem) readonly on device 3:3.
[    5.246444] Freeing unused kernel memory: 432k freed
[    5.250766] Write protecting the kernel text: 3624k
[    5.251379] Write protecting the kernel read-only data: 1676k
[    5.454143] usb usb1: suspend_rh (auto-stop)
[    6.704217] hub 1-0:1.0: hub_suspend
[    6.704283] usb usb1: bus auto-suspend
[    6.704312] usb usb1: suspend_rh
[    7.038875] consoletype used greatest stack depth: 6700 bytes left
[    7.210192] stty used greatest stack depth: 6432 bytes left
[    7.260905] tty used greatest stack depth: 6288 bytes left
[    7.346334] grep used greatest stack depth: 5896 bytes left
[    9.872794] usb usb1: uevent
[    9.873214] usb 1-0:1.0: uevent
[   16.310826] yenta_cardbus 0000:00:02.0: CardBus bridge found [1014:0092]
[   16.310908] yenta_cardbus 0000:00:02.0: Enabling burst memory read 
transactions
[   16.310944] yenta_cardbus 0000:00:02.0: Using CSCINT to route CSC 
interrupts to PCI
[   16.310974] yenta_cardbus 0000:00:02.0: Routing CardBus interrupts to PCI
[   16.311011] yenta_cardbus 0000:00:02.0: TI: mfunc 0xfba97543, devctl 0x62
[   16.534884] yenta_cardbus 0000:00:02.0: ISA IRQ mask 0x0498, PCI irq 11
[   16.534921] yenta_cardbus 0000:00:02.0: Socket status: 30000006
[   16.536243] yenta_cardbus 0000:00:02.1: CardBus bridge found [1014:0092]
[   16.536316] yenta_cardbus 0000:00:02.1: Using CSCINT to route CSC 
interrupts to PCI
[   16.536348] yenta_cardbus 0000:00:02.1: Routing CardBus interrupts to PCI
[   16.536384] yenta_cardbus 0000:00:02.1: TI: mfunc 0xfba97543, devctl 0x62
[   16.759892] yenta_cardbus 0000:00:02.1: ISA IRQ mask 0x0498, PCI irq 11
[   16.759930] yenta_cardbus 0000:00:02.1: Socket status: 30000006
[   30.966695] EXT3 FS on hda3, internal journal
[   32.496813] Adding 506512k swap on /dev/hda2.  Priority:-1 extents:1 
across:506512k



