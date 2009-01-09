Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbZAIRKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbZAIRKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 12:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbZAIRKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 12:10:35 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:51651 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZAIRK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 12:10:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=lcaLDto7Fo181ntVpgSON8ydSX+sJyJsp/4b8mWp/3YJX6ixsbsglaZgFkitQhTH7w
         zXrgOuXEUlspv9BNnijJZiiV+DjGxM/XK8DaldMzVywciz2Ve6f03Id0bd0sc64IzkEQ
         ZvVg+8DUzleWWYfjTK1TZfgLi58auejhIbouc=
Message-ID: <496784FA.6030607@gmail.com>
Date: Fri, 09 Jan 2009 09:10:18 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081126)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] libata: use WARN_ON_ONCE on hot paths
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>	<20090108221753.78648cd6@daedalus.pq.iki.fi>	<20090108125317.648397d2@infradead.org>	<49667C36.4080300@gmail.com>	<20090108143127.437c15de@infradead.org>	<4966974B.3090700@gmail.com>	<49672166.4050606@gmail.com>	<496724A2.5030400@kernel.org>	<c4e36d110901090331r7c1cf06cy25c4a3a3579e47de@mail.gmail.com>	<49673D02.6000002@garzik.org> <20090109120730.5c80fc68@lxorguk.ukuu.org.uk>
In-Reply-To: <20090109120730.5c80fc68@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed;
 boundary="------------090104030903060602000905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090104030903060602000905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
>> If I had to guess, I would say that Arjan's patches assume it is OK to 
>> treat two ports on a single IDE controller as completely independent, 
>> when that is not really the reality of the hardware.
>>     
>
> The PCI probe paths and the setup paths of several of the PATA
> controller drivers know they are single threaded in a few spots so it
> wouldn't suprise me in the slightest. Really this async stuff needs to
> spend 2 or 3 months in -next getting the kinks worked out so that driver
> assumptions can be pinned down and fixed, and someone can give it an API
> with names that anyone but Arjan understands ;)
>
> Alan
>
>   
Tejun;
attached is lspci -nnn,
and dmesg.
I'll go ahead and plug that patch in
to see,

regards;

Justin P. Mattock

--------------090104030903060602000905
Content-Type: text/plain;
 name="libatawarning"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="libatawarning"

[    0.000000] Linux version 2.6.28-07812-g5fbbf5f (root@unix) (gcc version 4.3.3 20081217 (prerelease) (Ubuntu 4.3.2-2ubuntu9) ) #9 SMP Thu Jan 8 15:57:17 PST 2009
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
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-d000
[    0.000000] init_ohci1394_dma: initializing OHCI-1394 at 0c:03.0
[    0.000000] init_ohci1394_dma: finished initializing OHCI DMA
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 120MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00009000 - 0000ff00
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 0000669210]    TEXT DATA BSS ==> [0000100000 - 0000669210]
[    0.000000]   #4 [000066a000 - 000066d000]    INIT_PG_TABLE ==> [000066a000 - 000066d000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f0ea
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258185
[    0.000000] free_area_init_node: node 0, pgdat c053bb40, node_mem_map c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 242 pages used for memmap
[    0.000000]   HighMem zone: 30714 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Allocating 40960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256167
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28-07812-g5fbbf5f root=/dev/sda1 vga=790 debug pnpacpi=off pci=routeirq acpi_osi=Darwin audit=1 selinux=1 ohci1394_dma=early enforcing=0
[    0.000000] ACPI: Added _OSI(Darwin)
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 2161.244 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Memory: 1017788k/1033128k available (2968k kernel code, 14592k reserved, 1457k data, 404k init, 123824k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfff9e000 - 0xfffff000   ( 388 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.010000]       .init : 0xc055a000 - 0xc05bf000   ( 404 kB)
[    0.010000]       .data : 0xc03e635e - 0xc05529c4   (1457 kB)
[    0.010000]       .text : 0xc0100000 - 0xc03e635e   (2968 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4322.48 BogoMIPS (lpj=21612440)
[    0.010000] Security Framework initialized
[    0.010000] SELinux:  Initializing.
[    0.010000] SELinux:  Starting in permissive mode
[    0.010000] Failure registering Root Plug module with the kernel
[    0.010000] Mount-cache hash table entries: 512
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] [ds] using core 2 configuration
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#0.
[    0.010000] using mwait in idle threads.
[    0.010000] Checking 'hlt' instruction... OK.
[    0.041110] ACPI: Core revision 20080926
[    0.061512] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.061520] ftrace: allocating 15027 entries in 59 pages
[    0.067579]   alloc irq_2_pin on cpu 0 node 0
[    0.067588]   alloc irq_2_pin on cpu 0 node 0
[    0.067594]   alloc irq_2_pin on cpu 0 node 0
[    0.067600]   alloc irq_2_pin on cpu 0 node 0
[    0.067606]   alloc irq_2_pin on cpu 0 node 0
[    0.067612]   alloc irq_2_pin on cpu 0 node 0
[    0.067618]   alloc irq_2_pin on cpu 0 node 0
[    0.067624]   alloc irq_2_pin on cpu 0 node 0
[    0.067630]   alloc irq_2_pin on cpu 0 node 0
[    0.067636]   alloc irq_2_pin on cpu 0 node 0
[    0.067641]   alloc irq_2_pin on cpu 0 node 0
[    0.067647]   alloc irq_2_pin on cpu 0 node 0
[    0.067653]   alloc irq_2_pin on cpu 0 node 0
[    0.067659]   alloc irq_2_pin on cpu 0 node 0
[    0.067665]   alloc irq_2_pin on cpu 0 node 0
[    0.067821] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.167841] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.170000] Testing tracer nop: PASSED
[    0.170000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4322.52 BogoMIPS (lpj=21612609)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] [ds] using core 2 configuration
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#1.
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.321764] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.321800] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.330031] Brought up 2 CPUs
[    0.330037] Total of 2 processors activated (8645.00 BogoMIPS).
[    0.330104] CPU0 attaching sched-domain:
[    0.330109]  domain 0: span 0-1 level MC
[    0.330113]   groups: 0 1
[    0.330120] CPU1 attaching sched-domain:
[    0.330123]  domain 0: span 0-1 level MC
[    0.330127]   groups: 1 0
[    0.330214] net_namespace: 800 bytes
[    0.330214] Booting paravirtualized kernel on bare hardware
[    0.330328] NET: Registered protocol family 16
[    0.330328] EISA bus registered
[    0.330328] ACPI: bus type pci registered
[    0.330328] PCI: Using configuration type 1 for base access
[    0.340113] bio: create slab <bio-0> at 0
[    0.341190] ACPI: EC: EC description table is found, configuring boot EC
[    0.341441] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.355712] ACPI: Interpreter enabled
[    0.355719] ACPI: (supports S0 S3 S4 S5)
[    0.355794] ACPI: Using IOAPIC for interrupt routing
[    0.371581] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.371581] ACPI: EC: driver started in interrupt mode
[    0.371581] ACPI: No dock devices found.
[    0.371581] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.371581] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.371581] pci 0000:00:01.0: PME# disabled
[    0.371581] pci 0000:00:07.0: reg 10 32bit mmio: [0x50404000-0x50404fff]
[    0.371581] pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
[    0.371581] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.371581] pci 0000:00:1b.0: PME# disabled
[    0.371581] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.371581] pci 0000:00:1c.0: PME# disabled
[    0.371581] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.371581] pci 0000:00:1c.1: PME# disabled
[    0.371581] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.371581] pci 0000:00:1c.2: PME# disabled
[    0.371581] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    0.371581] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    0.371581] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    0.371581] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    0.371581] pci 0000:00:1d.7: reg 10 32bit mmio: [0x50405400-0x504057ff]
[    0.371581] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.371581] pci 0000:00:1d.7: PME# disabled
[    0.371581] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.371581] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.371581] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.371581] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
[    0.371581] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
[    0.371581] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
[    0.371581] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
[    0.371581] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
[    0.371581] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
[    0.371581] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    0.371581] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    0.371581] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    0.371581] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    0.371581] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    0.371581] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    0.371581] pci 0000:00:1f.2: reg 24 32bit mmio: [0x50405000-0x504053ff]
[    0.371581] pci 0000:00:1f.2: PME# supported from D3hot
[    0.371581] pci 0000:00:1f.2: PME# disabled
[    0.371591] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.371670] pci 0000:01:00.0: reg 10 32bit mmio: [0x40000000-0x47ffffff]
[    0.371680] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.371691] pci 0000:01:00.0: reg 18 32bit mmio: [0x50300000-0x5030ffff]
[    0.371712] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.371745] pci 0000:01:00.0: supports D1 D2
[    0.371807] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.371812] pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
[    0.371820] pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x47ffffff]
[    0.371903] pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x50203fff]
[    0.371915] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.371953] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.372012] pci 0000:02:00.0: supports D1 D2
[    0.372016] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.372024] pci 0000:02:00.0: PME# disabled
[    0.372090] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.372097] pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
[    0.380052] pci 0000:03:00.0: reg 10 64bit mmio: [0x50100000-0x5010ffff]
[    0.380150] pci 0000:03:00.0: supports D1
[    0.380154] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.380162] pci 0000:03:00.0: PME# disabled
[    0.380241] pci 0000:00:1c.1: bridge 32bit mmio: [0x50100000-0x501fffff]
[    0.380309] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.380316] pci 0000:00:1c.2: bridge 32bit mmio: [0x4c100000-0x500fffff]
[    0.380327] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x48000000-0x4bffffff]
[    0.380386] pci 0000:0c:03.0: reg 10 32bit mmio: [0x4c004000-0x4c0047ff]
[    0.380398] pci 0000:0c:03.0: reg 14 32bit mmio: [0x4c000000-0x4c003fff]
[    0.380466] pci 0000:0c:03.0: supports D1 D2
[    0.380469] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.380477] pci 0000:0c:03.0: PME# disabled
[    0.380539] pci 0000:00:1e.0: transparent bridge
[    0.380548] pci 0000:00:1e.0: bridge 32bit mmio: [0x4c000000-0x4c0fffff]
[    0.380586] pci_bus 0000:00: on NUMA node 0
[    0.380601] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.382455] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.383052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.383635] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.384215] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.384823] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.401124] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401124] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401124] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401124] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.410113] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.410403] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.410691] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.410975] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.411093] SCSI subsystem initialized
[    0.411093] libata version 3.00 loaded.
[    0.411093] usbcore: registered new interface driver usbfs
[    0.411093] usbcore: registered new interface driver hub
[    0.411093] usbcore: registered new device driver usb
[    0.411093] PCI: Using ACPI for IRQ routing
[    0.411093] PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
[    0.411093]   alloc irq_2_pin on cpu 0 node 0
[    0.411093] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.411093] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.411093]   alloc irq_2_pin on cpu 0 node 0
[    0.411093] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.411093]   alloc irq_2_pin on cpu 0 node 0
[    0.411093] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.411093] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.411093]   alloc irq_2_pin on cpu 0 node 0
[    0.411093] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.411093]   alloc irq_2_pin on cpu 0 node 0
[    0.411093] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.411093]   alloc irq_2_pin on cpu 0 node 0
[    0.411093] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.411093] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.411093] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.411093] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.411093] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.411093] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.411093] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.411093] vendor=8086 device=27a1
[    0.411093] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.411093] vendor=8086 device=27d0
[    0.411093] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.411093] vendor=8086 device=27d2
[    0.411093] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.411093] vendor=8086 device=2448
[    0.411093] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.440091] cfg80211: Using static regulatory domain info
[    0.440091] cfg80211: Regulatory domain: US
[    0.440091] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.440091] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.440091] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440091] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.440094] cfg80211: Calling CRDA for country: US
[    0.440129] NetLabel: Initializing
[    0.440129] NetLabel:  domain hash size = 128
[    0.440129] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.440141] NetLabel:  unlabeled traffic allowed by default
[    0.440155] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.440162] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.470029] pnp: PnP ACPI: disabled
[    0.501837] Switched to high resolution mode on CPU 1
[    0.505913] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.505921] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.505927] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.505933] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x00000047ffffff
[    0.505943] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.505948] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.505956] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.505963] pci 0000:00:1c.0:   PREFETCH window: 0x00000050500000-0x000000505fffff
[    0.505974] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.505977] pci 0000:00:1c.1:   IO window: disabled
[    0.505986] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.505992] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.506002] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.506007] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.506016] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.506023] pci 0000:00:1c.2:   PREFETCH window: 0x00000048000000-0x0000004bffffff
[    0.506033] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.506037] pci 0000:00:1e.0:   IO window: disabled
[    0.506045] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.506052] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.506065] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.506071] pci 0000:00:01.0: setting latency timer to 64
[    0.506078] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.506086] pci 0000:00:1c.0: setting latency timer to 64
[    0.506093] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.506100] pci 0000:00:1c.1: setting latency timer to 64
[    0.506108] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.506115] pci 0000:00:1c.2: setting latency timer to 64
[    0.510003] Switched to high resolution mode on CPU 0
[    0.510546] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.510556] pci 0000:00:1e.0: setting latency timer to 64
[    0.510562] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.510566] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.510570] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    0.510574] pci_bus 0000:01: resource 1 mem: [0x50300000-0x503fffff]
[    0.510578] pci_bus 0000:01: resource 2 mem: [0x40000000-0x47ffffff]
[    0.510582] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.510586] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.510590] pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
[    0.510595] pci_bus 0000:02: resource 2 mem: [0x50500000-0x505fffff]
[    0.510599] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.510602] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.510606] pci_bus 0000:03: resource 1 mem: [0x50100000-0x501fffff]
[    0.510610] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.510614] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.510618] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
[    0.510622] pci_bus 0000:04: resource 1 mem: [0x4c100000-0x500fffff]
[    0.510626] pci_bus 0000:04: resource 2 mem: [0x48000000-0x4bffffff]
[    0.510630] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.510634] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.510637] pci_bus 0000:0c: resource 1 mem: [0x4c000000-0x4c0fffff]
[    0.510641] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.510645] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.510649] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffff]
[    0.510683] NET: Registered protocol family 2
[    0.540086] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.540447] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.540896] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    0.541448] TCP: Hash tables configured (established 131072 bind 65536)
[    0.541453] TCP reno registered
[    0.550162] NET: Registered protocol family 1
[    0.551228] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.553493] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.555111] Initializing RT-Tester: OK
[    0.555241] audit: initializing netlink socket (enabled)
[    0.555306] type=2000 audit(1231520393.550:1): initialized
[    0.558380] Testing tracer sched_switch: PASSED
[    0.660045] Testing tracer function: PASSED
[    0.790804] Testing dynamic ftrace: PASSED
[    1.030057] Testing tracer irqsoff: PASSED
[    1.040349] Testing tracer wakeup: PASSED
[    1.370268] highmem bounce pool size: 64 pages
[    1.370277] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.388694] fuse init (API version 7.11)
[    1.389377] msgmni has been set to 1746
[    1.389643] SELinux:  Registering netfilter hooks
[    1.390516] alg: No test for stdrng (krng)
[    1.390534] io scheduler noop registered
[    1.390912] io scheduler cfq registered (default)
[    1.391065] pci 0000:01:00.0: Boot video device
[    1.391753] vesafb: framebuffer at 0x40000000, mapped to 0xf8100000, using 3072k, total 16384k
[    1.391760] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    1.391764] vesafb: protected mode interface info at c000:ad0c
[    1.391769] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    1.391773] vesafb: scrolling: redraw
[    1.391777] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    1.416141] Console: switching to colour frame buffer device 128x48
[    1.438354] fb0: VESA VGA frame buffer device
[    1.453875] loop: module loaded
[    1.454027] Linux video capture interface: v2.00
[    1.454511] input: Macintosh mouse button emulation as /class/input/input0
[    1.455166] Driver 'sd' needs updating - please use bus_type methods
[    1.455568] Driver 'sr' needs updating - please use bus_type methods
[    1.456248] ata_piix 0000:00:1f.1: version 2.12
[    1.456553] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    1.456851] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.457226] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.457592] scsi0 : ata_piix
[    1.458282] scsi1 : ata_piix
[    1.460449] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    1.460770] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    1.461108] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.461556] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.610020] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.621400] scsi2 : ata_piix
[    1.629185] scsi3 : ata_piix
[    1.633011] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    1.648255] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    1.655983] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    1.663999] usbcore: registered new interface driver usblcd
[    1.671847] usbcore: registered new interface driver usbled
[    1.672913] ata1.00: configured for UDMA/66
[    1.688158] PNP: No PS/2 controller found. Probing ports directly.
[    1.696963] i8042.c: No controller found.
[    1.704826] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
[    1.713751] mice: PS/2 mouse device common for all mice
[    1.721836] ------------[ cut here ]------------
[    1.729872] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[    1.731803] Hardware name: MacBookPro2,2
[    1.731803] Modules linked in:
[    1.731803] Pid: 1, comm: swapper Not tainted 2.6.28-07812-g5fbbf5f #9
[    1.731803] Call Trace:
[    1.731803]  [<c01292ca>] warn_slowpath+0x76/0xad
[    1.731803]  [<c0263865>] ? cfb_fillrect+0x182/0x275
[    1.731803]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    1.731803]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    1.731803]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    1.731803]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    1.731803]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    1.731803]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    1.731803]  [<c0104bc9>] do_IRQ+0x92/0xad
[    1.731803]  [<c010396c>] common_interrupt+0x2c/0x34
[    1.731803]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
[    1.731803]  [<c012da4f>] ? __do_softirq+0x6b/0x154
[    1.731803]  [<c012db6c>] ? do_softirq+0x34/0x7e
[    1.731803]  [<c012db8a>] do_softirq+0x52/0x7e
[    1.731803]  [<c012dcd6>] irq_exit+0x49/0x77
[    1.731803]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[    1.731803]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[    1.731803]  [<c0129e84>] ? vprintk+0x2aa/0x2d5
[    1.731803]  [<c03df731>] printk+0x14/0x1b
[    1.731803]  [<c05780e8>] mousedev_init+0x70/0x78
[    1.731803]  [<c0101137>] _stext+0x4f/0x127
[    1.731803]  [<c0578078>] ? mousedev_init+0x0/0x78
[    1.731803]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
[    1.731803]  [<c015be90>] ? init_irq_proc+0x58/0x65
[    1.731803]  [<c055a309>] kernel_init+0x105/0x156
[    1.731803]  [<c055a204>] ? kernel_init+0x0/0x156
[    1.731803]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    1.731803] ---[ end trace fe574a344d5c3215 ]---
[    1.981838] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.989856] EDAC MC: Ver: 2.1.0 Jan  8 2009
[    2.003655] cpuidle: using governor ladder
[    2.010983] cpuidle: using governor menu
[    2.020575] usbcore: registered new interface driver hiddev
[    2.028263] usbcore: registered new interface driver usbhid
[    2.035357] ------------[ cut here ]------------
[    2.042280] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[    2.045305] Hardware name: MacBookPro2,2
[    2.045305] Modules linked in:
[    2.045305] Pid: 1, comm: swapper Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[    2.045305] Call Trace:
[    2.045305]  [<c01292ca>] warn_slowpath+0x76/0xad
[    2.045305]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[    2.045305]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[    2.045305]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[    2.045305]  [<c011e4d1>] ? complete+0x39/0x43
[    2.045305]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[    2.045305]  [<c011e4d1>] ? complete+0x39/0x43
[    2.045305]  [<c02e2f72>] ? ata_qc_complete_internal+0x13/0x15
[    2.045305]  [<c02e085b>] ? __ata_qc_complete+0x98/0xa0
[    2.045305]  [<c02e1ecb>] ? ata_qc_complete+0x1a1/0x1a9
[    2.045305]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    2.045305]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    2.045305]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    2.045305]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    2.172504]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    2.172504]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    2.182503]  [<c0104bc9>] do_IRQ+0x92/0xad
[    2.192513] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    2.192515] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.192503]  [<c010396c>] common_interrupt+0x2c/0x34
[    2.192503]  [<c012007b>] ? sched_debug_show+0x803/0xbbd
[    2.192503]  [<c012da4f>] ? __do_softirq+0x6b/0x154
[    2.192503]  [<c012db6c>] ? do_softirq+0x34/0x7e
[    2.192503]  [<c012db8a>] do_softirq+0x52/0x7e
[    2.192503]  [<c012dcd6>] irq_exit+0x49/0x77
[    2.192503]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[    2.192503]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[    2.192503]  [<c0129e84>] ? vprintk+0x2aa/0x2d5
[    2.192503]  [<c023c4fc>] ? kobject_uevent+0xa/0xc
[    2.192503]  [<c02b1a1c>] ? bus_add_driver+0x1a0/0x1c2
[    2.192503]  [<c03df731>] printk+0x14/0x1b
[    2.192503]  [<c02ffffe>] usb_register_driver+0x8e/0xd0
[    2.192503]  [<c0579e5a>] hid_init+0x47/0x75
[    2.192503]  [<c0101137>] _stext+0x4f/0x127
[    2.192503]  [<c0579e13>] ? hid_init+0x0/0x75
[    2.192503]  [<c015be1c>] ? register_irq_proc+0x84/0xa0
[    2.192503]  [<c015be90>] ? init_irq_proc+0x58/0x65
[    2.192503]  [<c055a309>] kernel_init+0x105/0x156
[    2.192503]  [<c055a204>] ? kernel_init+0x0/0x156
[    2.192503]  [<c0103bcb>] kernel_thread_helper+0x7/0x10
[    2.192503] ---[ end trace fe574a344d5c3216 ]---
[    2.364422] ata3.01: configured for UDMA/100
[    2.364425] usbhid: v2.6:USB HID core driver
[    2.364576] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    2.364703] ALSA device list:
[    2.364704]   No soundcards found.
[    2.364898] oprofile: using NMI interrupt.
[    2.365176] IPVS: Registered protocols (TCP, AH, ESP)
[    2.365367] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    2.365399] IPVS: ipvs loaded.
[    2.365737] Initializing XFRM netlink socket
[    2.365764] NET: Registered protocol family 17
[    2.365771] NET: Registered protocol family 15
[    2.365797] Using IPI No-Shortcut mode
[    2.449894] ------------[ cut here ]------------
[    2.456463] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[    2.459864] Hardware name: MacBookPro2,2
[    2.459864] Modules linked in:
[    2.459864] Pid: 0, comm: swapper Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[    2.459864] Call Trace:
[    2.459864]  [<c01292ca>] warn_slowpath+0x76/0xad
[    2.459864]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[    2.459864]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[    2.459864]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[    2.459864]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
[    2.459864]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[    2.459864]  [<c02ce674>] ? scsi_eh_scmd_add+0x83/0x8c
[    2.459864]  [<c02ce6cf>] ? scsi_times_out+0x52/0x6c
[    2.459864]  [<c0235c66>] ? blk_rq_timed_out+0x11/0x4b
[    2.459864]  [<c0235ce3>] ? blk_abort_request+0x43/0x46
[    2.459864]  [<c02ebb5c>] ? ata_qc_schedule_eh+0x49/0x50
[    2.459864]  [<c02e1d9f>] ? ata_qc_complete+0x75/0x1a9
[    2.459864]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[    2.459864]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[    2.459864]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[    2.459864]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[    2.459864]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    2.459864]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    2.459864]  [<c0104bc9>] do_IRQ+0x92/0xad
[    2.459864]  [<c010396c>] common_interrupt+0x2c/0x34
[    2.459864]  [<c010835b>] ? mwait_idle+0x55/0x85
[    2.459864]  [<c01023b1>] ? cpu_idle+0x7e/0xa5
[    2.459864]  [<c01023b7>] cpu_idle+0x84/0xa5
[    2.459864]  [<c03d388f>] rest_init+0x53/0x55
[    2.459864]  [<c055a818>] start_kernel+0x2dc/0x2e1
[    2.459864]  [<c055a085>] __init_begin+0x85/0x8d
[    2.459864] ---[ end trace fe574a344d5c3218 ]---
[    2.678868] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.685724] Uniform CD-ROM driver Revision: 3.20
[    2.692871] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.699965] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.706769] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
[    2.714112] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.721144] sd 2:0:1:0: [sda] Write Protect is off
[    2.728059] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.735168] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.735204] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    2.749856] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.757197] sd 2:0:1:0: [sda] Write Protect is off
[    2.764320] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.771472] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.778816]  sda: sda1 sda2
[    2.786829] sd 2:0:1:0: [sda] Attached SCSI disk
[    2.796471] kjournald starting.  Commit interval 5 seconds
[    2.796482] EXT3-fs: mounted filesystem with ordered data mode.
[    2.796514] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    2.818894] Freeing unused kernel memory: 404k freed
[    3.550039] SELinux: 8192 avtab hash slots, 145595 rules.
[    3.649463] SELinux: 8192 avtab hash slots, 145595 rules.
[    3.827322] SELinux:  7 users, 9 roles, 2684 types, 95 bools, 1 sens, 256 cats
[    3.835067] SELinux:  73 classes, 145595 rules
[    3.849279] SELinux:  class kernel_service not defined in policy
[    3.857290] SELinux: the above unknown classes and permissions will be denied
[    3.865206] SELinux:  Completing initialization.
[    3.873133] SELinux:  Setting up existing superblocks.
[    3.915306] SELinux: initialized (dev sda1, type ext3), uses xattr
[    4.070668] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    4.078905] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    4.087189] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[    4.095531] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    4.103962] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[    4.112471] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.121051] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    4.129761] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.138562] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    4.147512] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.156482] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.165500] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.174469] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    4.183494] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.236649] type=1403 audit(1231520397.230:2): policy loaded auid=4294967295 ses=4294967295
[    4.924895] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.380343] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    5.463722] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    9.933766] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   10.204205] ------------[ cut here ]------------
[   10.211237] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   10.211237] Hardware name: MacBookPro2,2
[   10.211237] Modules linked in:
[   10.211237] Pid: 906, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   10.211237] Call Trace:
[   10.211237]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.211237]  [<c016d1b4>] ? __rmqueue_smallest+0xc2/0x13d
[   10.211237]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.211237]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.211237]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.211237]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.211237]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.211237]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.211237]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.346361]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.346361]  [<c02400d8>] ? memset+0xc/0x18
[   10.346361]  [<c0243817>] ? _raw_spin_unlock+0x5f/0x78
[   10.346361]  [<c03e2164>] _spin_unlock+0xd/0xf
[   10.346361]  [<c01799c4>] __do_fault+0x2e1/0x345
[   10.346361]  [<c017b345>] handle_mm_fault+0x29e/0x606
[   10.346361]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   10.346361]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[   10.346361]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   10.346361]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   10.346361]  [<c011e70c>] ? set_next_entity+0xa7/0x113
[   10.346361]  [<c011eeb9>] ? pick_next_task_fair+0x73/0x7a
[   10.346361]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   10.346361]  [<c018a64d>] ? check_object+0x139/0x190
[   10.346361]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.346361]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   10.346361]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.346361]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   10.346361]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   10.346361]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   10.346361]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.346361]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.346361]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.346361]  [<c03e2427>] error_code+0x77/0x7c
[   10.346361] ---[ end trace fe574a344d5c3219 ]---
[   10.548704] ------------[ cut here ]------------
[   10.554212] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   10.558893] Hardware name: MacBookPro2,2
[   10.565780] Modules linked in:
[   10.571514] Pid: 906, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   10.579079] Call Trace:
[   10.586908]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.594592]  [<c01206cd>] ? enqueue_task_fair+0x24/0x5e
[   10.598988]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   10.606576]  [<c01238ef>] ? try_to_wake_up+0x245/0x250
[   10.611611]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
[   10.617897]  [<c0169974>] ? find_get_page+0x22/0x86
[   10.617897]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.632999]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.632999]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.647677]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.647677]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.657529]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.657529]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.657529]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.682885]  [<c03e007b>] ? schedule+0x695/0x8f1
[   10.687982]  [<c03e3ee5>] ? do_page_fault+0x272/0x6f9
[   10.692986]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   10.692986]  [<c018beb3>] ? kmem_cache_free+0xae/0xc2
[   10.692986]  [<c0196c85>] ? putname+0x29/0x34
[   10.692986]  [<c0196c85>] ? putname+0x29/0x34
[   10.692986]  [<c0198701>] ? user_path_at+0x4a/0x67
[   10.692986]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   10.692986]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   10.692986]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   10.752958]  [<c0192230>] ? vfs_stat_fd+0x1e/0x45
[   10.752958]  [<c019231a>] ? vfs_stat+0x16/0x18
[   10.752958]  [<c0192335>] ? sys_stat64+0x19/0x30
[   10.752958]  [<c0343a2e>] ? sys_socket+0x48/0x5f
[   10.752958]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   10.752958]  [<c03e2423>] ? error_code+0x73/0x7c
[   10.752958]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.752958]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   10.752958]  [<c03e2427>] error_code+0x77/0x7c
[   10.752958] ---[ end trace fe574a344d5c321a ]---
[   10.868838] ------------[ cut here ]------------
[   10.874946] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   10.880108] Hardware name: MacBookPro2,2
[   10.880108] Modules linked in:
[   10.880108] Pid: 1110, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   10.902791] Call Trace:
[   10.906429]  [<c01292ca>] warn_slowpath+0x76/0xad
[   10.912518]  [<c016d1b4>] ? __rmqueue_smallest+0xc2/0x13d
[   10.922518]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   10.928763]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   10.936009]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   10.942520]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   10.946674]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   10.946674]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   10.960790]  [<c0104bc9>] do_IRQ+0x92/0xad
[   10.967560]  [<c010396c>] common_interrupt+0x2c/0x34
[   10.976456]  [<c0179ff1>] ? do_wp_page+0x3c3/0x5eb
[   10.981733]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   10.981733]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   10.992521]  [<c017b634>] handle_mm_fault+0x58d/0x606
[   11.002516]  [<c03e405c>] ? do_page_fault+0x3e9/0x6f9
[   11.002516]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   11.011817]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   11.017702]  [<c03e2423>] ? error_code+0x73/0x7c
[   11.017702]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.017702]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
[   11.017702]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   11.017702]  [<c03e2423>] ? error_code+0x73/0x7c
[   11.017702]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.017702]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.017702]  [<c03e2427>] error_code+0x77/0x7c
[   11.017702] ---[ end trace fe574a344d5c321b ]---
[   11.087571] ------------[ cut here ]------------
[   11.090002] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.090002] Hardware name: MacBookPro2,2
[   11.090002] Modules linked in:
[   11.090002] Pid: 1102, comm: modprobe Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.090002] Call Trace:
[   11.090002]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.090002]  [<c016e6cf>] ? get_page_from_freelist+0x2a6/0x3ed
[   11.090002]  [<c011b408>] ? kmap_atomic_prot+0xb6/0xe0
[   11.090002]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   11.090002]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.090002]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.090002]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.090002]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.090002]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.090002]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.090002]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.090002]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.090002]  [<c0116615>] ? native_make_pte+0x0/0xa
[   11.090002]  [<c011b3ec>] ? kmap_atomic_prot+0x9a/0xe0
[   11.090002]  [<c011b445>] kmap_atomic+0x13/0x15
[   11.090002]  [<c016e74c>] get_page_from_freelist+0x323/0x3ed
[   11.090002]  [<c016ea87>] __alloc_pages_internal+0x9b/0x36a
[   11.090002]  [<c01818ae>] ? anon_vma_prepare+0x8d/0xb1
[   11.090002]  [<c017b1f7>] handle_mm_fault+0x150/0x606
[   11.090002]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   11.090002]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   11.090002]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   11.090002]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   11.090002]  [<c018a64d>] ? check_object+0x139/0x190
[   11.090002]  [<c018bb89>] ? __slab_alloc+0x409/0x4a8
[   11.090002]  [<c017e2d1>] ? __vma_link+0x5d/0x61
[   11.090002]  [<c017e330>] ? vma_link+0x5b/0x80
[   11.090002]  [<c017f5e0>] ? mmap_region+0x33d/0x435
[   11.090002]  [<c017f943>] ? do_mmap_pgoff+0x26b/0x2cb
[   11.090002]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   11.090002]  [<c03e2423>] ? error_code+0x73/0x7c
[   11.090002]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.090002]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.090002]  [<c03e2427>] error_code+0x77/0x7c
[   11.090002] ---[ end trace fe574a344d5c321c ]---
[   11.355771] ------------[ cut here ]------------
[   11.362246] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.364634] Hardware name: MacBookPro2,2
[   11.364634] Modules linked in:
[   11.364634] Pid: 1089, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.364634] Call Trace:
[   11.364634]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.364634]  [<c0170030>] ? balance_dirty_pages_ratelimited_nr+0x100/0x2e8
[   11.364634]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.364634]  [<c017b634>] ? handle_mm_fault+0x58d/0x606
[   11.364634]  [<c02146dc>] ? inode_has_perm+0x5d/0x67
[   11.364634]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.364634]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.364634]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.364634]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.364634]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.364634]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.364634]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.364634]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.364634]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.364634]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.364634]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   11.364634]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   11.364634]  [<c0196cb5>] ? getname+0x25/0xbc
[   11.364634]  [<c0196cb5>] getname+0x25/0xbc
[   11.364634]  [<c01582a2>] ? audit_syscall_entry+0x137/0x159
[   11.364634]  [<c0101b53>] sys_execve+0x12/0x55
[   11.364634]  [<c010329f>] sysenter_do_call+0x12/0x34
[   11.364634] ---[ end trace fe574a344d5c321d ]---
[   11.542706] ------------[ cut here ]------------
[   11.549177] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.551628] Hardware name: MacBookPro2,2
[   11.551628] Modules linked in:
[   11.551628] Pid: 982, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.551628] Call Trace:
[   11.551628]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.551628]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[   11.551628]  [<c018a64d>] ? check_object+0x139/0x190
[   11.551628]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   11.551628]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.551628]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.551628]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.551628]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.551628]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.551628]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.551628]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.551628]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.551628]  [<c0179ff1>] ? do_wp_page+0x3c3/0x5eb
[   11.551628]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   11.551628]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.551628]  [<c017b634>] handle_mm_fault+0x58d/0x606
[   11.551628]  [<c013a27a>] ? autoremove_wake_function+0x0/0x38
[   11.551628]  [<c018a64d>] ? check_object+0x139/0x190
[   11.551628]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   11.551628]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   11.551628]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.551628]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   11.551628]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   11.551628]  [<c018a054>] ? add_partial+0x49/0x4e
[   11.551628]  [<c018acd8>] ? __slab_free+0x84/0x2b8
[   11.551628]  [<c018beb3>] ? kmem_cache_free+0xae/0xc2
[   11.551628]  [<c019bf01>] ? __d_free+0x41/0x46
[   11.551628]  [<c019bf01>] ? __d_free+0x41/0x46
[   11.551628]  [<c019bf30>] ? d_free+0x2a/0x3c
[   11.551628]  [<c01a1900>] ? mntput_no_expire+0x21/0xff
[   11.551628]  [<c019c584>] ? dput+0x22/0x10a
[   11.551628]  [<c018feec>] ? __fput+0x154/0x15c
[   11.551628]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   11.551628]  [<c03e2423>] ? error_code+0x73/0x7c
[   11.551628]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.551628]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.551628]  [<c03e2427>] error_code+0x77/0x7c
[   11.551628] ---[ end trace fe574a344d5c321e ]---
[   11.832112] ------------[ cut here ]------------
[   11.837800] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   11.840002] Hardware name: MacBookPro2,2
[   11.840002] Modules linked in:
[   11.840002] Pid: 964, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   11.840002] Call Trace:
[   11.840002]  [<c01292ca>] warn_slowpath+0x76/0xad
[   11.840002]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[   11.840002]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[   11.840002]  [<c012044f>] ? enqueue_entity+0x1a/0x274
[   11.840002]  [<c011bbac>] ? update_curr+0xae/0x189
[   11.840002]  [<c023de36>] ? rb_insert_color+0x56/0xc0
[   11.840002]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   11.840002]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   11.840002]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   11.840002]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   11.840002]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   11.840002]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   11.840002]  [<c0104bc9>] do_IRQ+0x92/0xad
[   11.840002]  [<c010396c>] common_interrupt+0x2c/0x34
[   11.840002]  [<c0179ff1>] ? do_wp_page+0x3c3/0x5eb
[   11.840002]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   11.840002]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.840002]  [<c017b634>] handle_mm_fault+0x58d/0x606
[   11.840002]  [<c013a27a>] ? autoremove_wake_function+0x0/0x38
[   11.840002]  [<c018a64d>] ? check_object+0x139/0x190
[   11.840002]  [<c03e3ee3>] ? do_page_fault+0x270/0x6f9
[   11.840002]  [<c03e3fed>] do_page_fault+0x37a/0x6f9
[   11.840002]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   11.840002]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   11.840002]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   11.840002]  [<c018a054>] ? add_partial+0x49/0x4e
[   11.840002]  [<c018acd8>] ? __slab_free+0x84/0x2b8
[   11.840002]  [<c018beb3>] ? kmem_cache_free+0xae/0xc2
[   11.840002]  [<c019bf01>] ? __d_free+0x41/0x46
[   11.840002]  [<c019bf01>] ? __d_free+0x41/0x46
[   11.840002]  [<c019bf30>] ? d_free+0x2a/0x3c
[   11.840002]  [<c01a1900>] ? mntput_no_expire+0x21/0xff
[   11.840002]  [<c019c584>] ? dput+0x22/0x10a
[   11.840002]  [<c018feec>] ? __fput+0x154/0x15c
[   11.840002]  [<c0240330>] ? trace_hardirqs_off_thunk+0xc/0x10
[   11.840002]  [<c03e2423>] ? error_code+0x73/0x7c
[   11.840002]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.840002]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   11.840002]  [<c03e2427>] error_code+0x77/0x7c
[   11.840002] ---[ end trace fe574a344d5c321f ]---
[   12.109647] ------------[ cut here ]------------
[   12.115376] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   12.118418] Hardware name: MacBookPro2,2
[   12.118418] Modules linked in:
[   12.118418] Pid: 1033, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   12.118418] Call Trace:
[   12.118418]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.118418]  [<c0240030>] ? __get_user_1+0xc/0x14
[   12.118418]  [<c02cf6d7>] ? scsi_request_fn+0x3e8/0x492
[   12.118418]  [<c03e2231>] ? _spin_lock_irq+0x21/0x24
[   12.118418]  [<c02cf6d7>] ? scsi_request_fn+0x3e8/0x492
[   12.118418]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
[   12.118418]  [<c02327f0>] ? blk_run_queue+0x2d/0x31
[   12.118418]  [<c02ceca9>] ? scsi_run_queue+0x29d/0x324
[   12.118418]  [<c023ba49>] ? kobject_put+0x37/0x3c
[   12.118418]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.118418]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.118418]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.118418]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.118418]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.118418]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.118418]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.118418]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.118418]  [<c016007b>] ? ftrace_regex_write+0x166/0x173
[   12.118418]  [<c016e117>] ? free_hot_cold_page+0x2a/0x262
[   12.118418]  [<c016e371>] __pagevec_free+0x22/0x2a
[   12.118418]  [<c0170d44>] release_pages+0x143/0x17e
[   12.118418]  [<c0183a4d>] free_pages_and_swap_cache+0x6b/0x84
[   12.118418]  [<c017e006>] exit_mmap+0xd4/0xff
[   12.118418]  [<c0127565>] mmput+0x26/0x8a
[   12.118418]  [<c012a92f>] exit_mm+0xe3/0xeb
[   12.118418]  [<c012beb5>] do_exit+0x155/0x68f
[   12.118418]  [<c018feec>] ? __fput+0x154/0x15c
[   12.118418]  [<c012c452>] do_group_exit+0x63/0x8a
[   12.118418]  [<c012c491>] sys_exit_group+0x18/0x1a
[   12.118418]  [<c010329f>] sysenter_do_call+0x12/0x34
[   12.118418] ---[ end trace fe574a344d5c3220 ]---
[   12.335408] ------------[ cut here ]------------
[   12.341753] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   12.344253] Hardware name: MacBookPro2,2
[   12.344253] Modules linked in:
[   12.344253] Pid: 1015, comm: udevd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   12.344253] Call Trace:
[   12.344253]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.344253]  [<c0160030>] ? ftrace_regex_write+0x11b/0x173
[   12.344253]  [<c011b332>] ? kunmap_atomic+0x72/0x92
[   12.344253]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   12.344253]  [<c017a1b4>] ? do_wp_page+0x586/0x5eb
[   12.344253]  [<c01799f0>] ? __do_fault+0x30d/0x345
[   12.344253]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   12.344253]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.344253]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.344253]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.344253]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.344253]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.344253]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.344253]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.344253]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.344253]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   12.344253]  [<c018bd01>] ? kfree+0xd9/0xe9
[   12.344253]  [<c0158140>] ? audit_free+0x166/0x191
[   12.344253]  [<c0158140>] audit_free+0x166/0x191
[   12.344253]  [<c012bea8>] do_exit+0x148/0x68f
[   12.344253]  [<c018feec>] ? __fput+0x154/0x15c
[   12.344253]  [<c012c452>] do_group_exit+0x63/0x8a
[   12.344253]  [<c012c491>] sys_exit_group+0x18/0x1a
[   12.344253]  [<c010329f>] sysenter_do_call+0x12/0x34
[   12.344253] ---[ end trace fe574a344d5c3221 ]---
[   12.536113] ------------[ cut here ]------------
[   12.542329] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   12.544234] Hardware name: MacBookPro2,2
[   12.544234] Modules linked in:
[   12.544234] Pid: 1088, comm: modprobe Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   12.544234] Call Trace:
[   12.544234]  [<c01292ca>] warn_slowpath+0x76/0xad
[   12.544234]  [<c0243800>] ? _raw_spin_unlock+0x48/0x78
[   12.544234]  [<c03e2423>] ? error_code+0x73/0x7c
[   12.544234]  [<c03e3c73>] ? do_page_fault+0x0/0x6f9
[   12.544234]  [<c0240320>] ? trace_hardirqs_on_thunk+0xc/0x10
[   12.544234]  [<c01033eb>] ? restore_nocheck_notrace+0x0/0xe
[   12.544234]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   12.544234]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   12.544234]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   12.544234]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   12.544234]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   12.544234]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   12.544234]  [<c0104bc9>] do_IRQ+0x92/0xad
[   12.544234]  [<c0196cb5>] ? getname+0x25/0xbc
[   12.544234]  [<c010396c>] common_interrupt+0x2c/0x34
[   12.544234]  [<c0196cb5>] ? getname+0x25/0xbc
[   12.544234]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   12.544234]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   12.544234]  [<c0196cb5>] ? getname+0x25/0xbc
[   12.544234]  [<c0196cb5>] getname+0x25/0xbc
[   12.544234]  [<c018d74b>] do_sys_open+0x19/0xbc
[   12.544234]  [<c018d83a>] sys_open+0x23/0x2b
[   12.544234]  [<c010329f>] sysenter_do_call+0x12/0x34
[   12.544234] ---[ end trace fe574a344d5c3222 ]---
[   13.211963] uhci_hcd: USB Universal Host Controller Interface driver
[   13.218605] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   13.225218] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.231775] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.238378] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   13.245299] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   13.252286] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   13.259403] usb usb1: configuration #1 chosen from 1 choice
[   13.266518] hub 1-0:1.0: USB hub found
[   13.273544] hub 1-0:1.0: 2 ports detected
[   13.280836] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.288135] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   13.295392] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   13.302620] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   13.309782] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   13.316962] usb usb2: configuration #1 chosen from 1 choice
[   13.324108] hub 2-0:1.0: USB hub found
[   13.331068] hub 2-0:1.0: 2 ports detected
[   13.338144] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   13.345207] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   13.352241] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   13.359321] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[   13.366480] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   13.373730] usb usb3: configuration #1 chosen from 1 choice
[   13.380916] hub 3-0:1.0: USB hub found
[   13.387987] hub 3-0:1.0: 2 ports detected
[   13.395276] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   13.402559] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   13.409797] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   13.417089] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[   13.424514] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   13.432050] usb usb4: configuration #1 chosen from 1 choice
[   13.439566] hub 4-0:1.0: USB hub found
[   13.447014] hub 4-0:1.0: 2 ports detected
[   13.454732] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   13.462355] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[   13.470362] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   13.478581] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   13.486682] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   13.494829] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[   13.507028] ehci_hcd 0000:00:1d.7: debug port 1
[   13.515240] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   13.523532] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[   13.552519] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   13.560788] usb usb5: configuration #1 chosen from 1 choice
[   13.569092] hub 5-0:1.0: USB hub found
[   13.577182] hub 5-0:1.0: 8 ports detected
[   13.609811] applesmc: Apple MacBook Pro detected:
[   13.617819] applesmc:  - Model with accelerometer
[   13.625593] applesmc:  - Model with light sensors and backlight
[   13.633345] applesmc:  - Model with 12 temperature sensors
[   13.690620] applesmc: device successfully initialized (0xe0, 0x00).
[   13.698814] applesmc: device successfully initialized.
[   13.707280] applesmc: 2 fans found.
[   13.716427] input: applesmc as /class/input/input1
[   13.737081] Registered led device: smc::kbd_backlight
[   13.745019] applesmc: driver successfully loaded.
[   13.791528] input: Power Button (FF) as /class/input/input2
[   13.799626] ACPI: Power Button (FF) [PWRF]
[   13.807434] input: Lid Switch as /class/input/input3
[   13.830209] ACPI: Lid Switch [LID0]
[   13.837922] input: Power Button (CM) as /class/input/input4
[   13.860104] ACPI: Power Button (CM) [PWRB]
[   13.867985] input: Sleep Button (CM) as /class/input/input5
[   13.890191] ACPI: Sleep Button (CM) [SLPB]
[   13.922470] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[   13.931616] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[   13.940442] Monitor-Mwait will be used to enter C-1 state
[   13.948424] Monitor-Mwait will be used to enter C-2 state
[   13.956168] Monitor-Mwait will be used to enter C-3 state
[   13.963954] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   13.971831] processor ACPI_CPU:00: registered as cooling_device0
[   13.979568] ACPI: Processor [CPU0] (supports 8 throttling states)
[   13.988959] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[   13.997922] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[   14.007181] Marking TSC unstable due to TSC halts in idle
[   14.007611] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   14.007665] processor ACPI_CPU:01: registered as cooling_device1
[   14.007670] ACPI: Processor [CPU1] (supports 8 throttling states)
[   14.082484] ath9k: 0.1
[   14.090234] vendor=8086 device=27d2
[   14.097782] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.105601] ath9k 0000:03:00.0: setting latency timer to 64
[   14.243331] wmaster0 (ath9k): not using net_device_ops yet
[   14.251474] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   14.264997] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   14.273210] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   14.283918] wlan0 (ath9k): not using net_device_ops yet
[   14.292724] Registered led device: ath9k-phy0:radio
[   14.300984] Registered led device: ath9k-phy0:assoc
[   14.309285] Registered led device: ath9k-phy0:tx
[   14.317303] Registered led device: ath9k-phy0:rx
[   14.325169] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81: mem=0xf80e0000, irq=17
[   14.358812] power_supply ADP1: uevent
[   14.366914] power_supply ADP1: No power supply yet
[   14.374902] power_supply ADP1: power_supply_changed
[   14.383031] ACPI: AC Adapter [ADP1] (on-line)
[   14.392173] power_supply ADP1: power_supply_changed_work
[   14.400175] power_supply ADP1: power_supply_update_gen_leds 1
[   14.408059] power_supply ADP1: uevent
[   14.415912] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   14.423618] power_supply ADP1: Static prop TYPE=Mains
[   14.431246] power_supply ADP1: 1 dynamic props
[   14.432523] usb 5-4: new high speed USB device using ehci_hcd and address 3
[   14.446817] power_supply ADP1: prop ONLINE=1
[   14.473391] vendor=8086 device=2448
[   14.481128] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   14.541120] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[   14.566192] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   14.593178] usb 5-4: configuration #1 chosen from 1 choice
[   14.633663] input: HDA Intel at 0x50400000 irq 22 Line In at Ext Rear Jack as /class/input/input6
[   14.643136] usb 5-4: firmware: requesting isight.fw
[   14.654614] input: HDA Intel at 0x50400000 irq 22 HP Out at Ext Rear Jack as /class/input/input7
[   14.708374] usbcore: registered new interface driver isight_firmware
[   14.878115] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   15.030941] ieee1394: raw1394: /dev/raw1394 device initialized
[   15.120076] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   15.205350] usbcore: registered new interface driver appletouch
[   15.326414] usb 1-2: configuration #1 chosen from 1 choice
[   15.346590] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input8
[   15.380965] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
[   15.405258] appletouch: Geyser mode initialized.
[   15.415534] input: appletouch as /class/input/input9
[   15.449378] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input10
[   15.478419] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.505555] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
[   15.616807] nf_conntrack version 0.5.0 (16142 buckets, 64568 max)
[   15.628224] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   15.639516] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   15.650970] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   15.715273] arp_tables: (C) 2002 David S. Miller
[   15.812649] usb 3-2: new full speed USB device using uhci_hcd and address 2
[   15.867106] usbcore: registered new interface driver uvcvideo
[   15.878915] USB Video Class driver (v0.1.0)
[   15.926269] ipmi message handler version 39.2
[   15.954663] IPMI Watchdog: driver initialized
[   16.019762] usb 3-2: configuration #1 chosen from 1 choice
[   16.028695] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[   16.293244] Adding 2988360k swap on /dev/sda2.  Priority:-1 extents:1 across:2988360k 
[   16.306802] usb 4-1: new full speed USB device using uhci_hcd and address 2
[   16.352951] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[   16.503231] usb 4-1: configuration #1 chosen from 1 choice
[   16.529419] input: HID 05ac:1000 as /class/input/input11
[   16.537263] generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[   16.560516] input: HID 05ac:1000 as /class/input/input12
[   16.574038] generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[   16.725603] EXT3 FS on sda1, internal journal
[   19.796628] applesmc: light sensor data length set to 6
[   20.557262] ------------[ cut here ]------------
[   20.557265] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.557268] Hardware name: MacBookPro2,2
[   20.557269] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.557331] Pid: 2543, comm: hald-addon-inpu Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.557333] Call Trace:
[   20.557339]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.557344]  [<c0213328>] ? selinux_socket_recvmsg+0x1a/0x1c
[   20.557349]  [<c0342ccb>] ? sock_aio_read+0x109/0x117
[   20.557352]  [<c02146dc>] ? inode_has_perm+0x5d/0x67
[   20.557356]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.557359]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.557363]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.557366]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.557371]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.557374]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.557378]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.557381]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.557383] ---[ end trace fe574a344d5c3223 ]---
[   20.563971] ------------[ cut here ]------------
[   20.563975] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.563977] Hardware name: MacBookPro2,2
[   20.563979] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.564039] Pid: 2461, comm: dd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.564041] Call Trace:
[   20.564046]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.564050]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.564055]  [<c03e2148>] ? _spin_unlock_irqrestore+0x2d/0x3c
[   20.564058]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.564061]  [<c03e2164>] ? _spin_unlock+0xd/0xf
[   20.564066]  [<c0218d0c>] ? selinux_capable+0xb5/0xc3
[   20.564070]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
[   20.564074]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.564077]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.564081]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.564084]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.564088]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.564092]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.564095]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.564098]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.564101] ---[ end trace fe574a344d5c3224 ]---
[   20.567917] ------------[ cut here ]------------
[   20.567920] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.567922] Hardware name: MacBookPro2,2
[   20.567924] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.567979] Pid: 2461, comm: dd Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.567981] Call Trace:
[   20.567984]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.567988]  [<c011e7c1>] ? dequeue_entity+0x1b/0x20d
[   20.567992]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.567996]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.567999]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.568003]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.568006]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.568009]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.568013]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.568016]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.568019]  [<c03e007b>] ? schedule+0x695/0x8f1
[   20.568023]  [<c03e2111>] ? _spin_unlock_irq+0x14/0x1e
[   20.568026]  [<c012a25d>] do_syslog+0x169/0x2fc
[   20.568030]  [<c013a27a>] ? autoremove_wake_function+0x0/0x38
[   20.568034]  [<c01c4962>] ? kmsg_read+0x0/0x42
[   20.568038]  [<c01c499b>] kmsg_read+0x39/0x42
[   20.568042]  [<c01bdab6>] proc_reg_read+0x65/0x79
[   20.568045]  [<c01bda51>] ? proc_reg_read+0x0/0x79
[   20.568049]  [<c018f825>] vfs_read+0x8c/0x106
[   20.568052]  [<c018f942>] sys_read+0x40/0x65
[   20.568055]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.568057] ---[ end trace fe574a344d5c3225 ]---
[   20.589015] ------------[ cut here ]------------
[   20.589018] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.589021] Hardware name: MacBookPro2,2
[   20.589022] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.589079] Pid: 2563, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.589081] Call Trace:
[   20.589087]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.589092]  [<c016ea87>] ? __alloc_pages_internal+0x9b/0x36a
[   20.589097]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
[   20.589101]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.589104]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.589108]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.589111]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.589115]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.589119]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.589122]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.589125]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.589129]  [<c01c6c90>] ? sysfs_open_file+0x2a/0x1e0
[   20.589133]  [<c018d979>] __dentry_open+0x11d/0x211
[   20.589136]  [<c018db11>] nameidata_to_filp+0x31/0x48
[   20.589139]  [<c01c6c66>] ? sysfs_open_file+0x0/0x1e0
[   20.589143]  [<c0198bd3>] do_filp_open+0x3a5/0x6e8
[   20.589146]  [<c018bb89>] ? __slab_alloc+0x409/0x4a8
[   20.589150]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.589152]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[   20.589156]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.589158]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.589162]  [<c018d779>] do_sys_open+0x47/0xbc
[   20.589165]  [<c018d83a>] sys_open+0x23/0x2b
[   20.589168]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.589170] ---[ end trace fe574a344d5c3226 ]---
[   20.590097] ------------[ cut here ]------------
[   20.590100] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.590102] Hardware name: MacBookPro2,2
[   20.590104] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.590158] Pid: 2563, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.590160] Call Trace:
[   20.590163]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.590167]  [<c016ea87>] ? __alloc_pages_internal+0x9b/0x36a
[   20.590171]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
[   20.590175]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.590178]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.590182]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.590185]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.590189]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.590192]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.590196]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.590199]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.590202]  [<c018fd49>] ? file_free_rcu+0x35/0x38
[   20.590206]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   20.590209]  [<c018beb7>] ? kmem_cache_free+0xb2/0xc2
[   20.590212]  [<c018fd49>] ? file_free_rcu+0x35/0x38
[   20.590215]  [<c018fd49>] file_free_rcu+0x35/0x38
[   20.590218]  [<c015c55e>] __rcu_process_callbacks+0x1b5/0x249
[   20.590221]  [<c015c616>] rcu_process_callbacks+0x24/0x42
[   20.590225]  [<c012da81>] __do_softirq+0x9d/0x154
[   20.590228]  [<c012db8a>] do_softirq+0x52/0x7e
[   20.590230]  [<c012dcd6>] irq_exit+0x49/0x77
[   20.590234]  [<c03e56e9>] __irqentry_text_start+0x79/0x87
[   20.590237]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.590241]  [<c0103aa1>] apic_timer_interrupt+0x2d/0x34
[   20.590244]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.590246]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   20.590250]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   20.590252]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.590255]  [<c0196cb5>] getname+0x25/0xbc
[   20.590258]  [<c018d74b>] do_sys_open+0x19/0xbc
[   20.590261]  [<c018d83a>] sys_open+0x23/0x2b
[   20.590264]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.590266] ---[ end trace fe574a344d5c3227 ]---
[   20.640709] ------------[ cut here ]------------
[   20.640712] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.640715] Hardware name: MacBookPro2,2
[   20.640717] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.640777] Pid: 2563, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.640779] Call Trace:
[   20.640784]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.640789]  [<c0212f70>] ? avc_has_perm+0x3e/0x48
[   20.640793]  [<c0243800>] ? _raw_spin_unlock+0x48/0x78
[   20.640797]  [<c023fac6>] ? vsnprintf+0x866/0x8c5
[   20.640801]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.640804]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.640808]  [<c018bf56>] ? kmem_cache_alloc+0x8f/0xcc
[   20.640812]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.640815]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.640819]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.640823]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.640826]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.640830]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.640833]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.640836]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.640840]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   20.640843]  [<c018bf5a>] ? kmem_cache_alloc+0x93/0xcc
[   20.640846]  [<c0196cb5>] ? getname+0x25/0xbc
[   20.640849]  [<c0196cb5>] getname+0x25/0xbc
[   20.640852]  [<c018d74b>] do_sys_open+0x19/0xbc
[   20.640855]  [<c018d83a>] sys_open+0x23/0x2b
[   20.640858]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.640860] ---[ end trace fe574a344d5c3228 ]---
[   20.641797] ------------[ cut here ]------------
[   20.641799] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.641801] Hardware name: MacBookPro2,2
[   20.641803] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.641857] Pid: 2563, comm: hald-addon-macb Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.641859] Call Trace:
[   20.641863]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.641866]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.641870]  [<c018a64d>] ? check_object+0x139/0x190
[   20.641873]  [<c018bb89>] ? __slab_alloc+0x409/0x4a8
[   20.641876]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.641880]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.641883]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.641886]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.641890]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.641893]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.641896]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.641899]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.641902]  [<c0196c85>] ? putname+0x29/0x34
[   20.641905]  [<c018007b>] ? move_page_tables+0xd3/0x28b
[   20.641908]  [<c018beb7>] ? kmem_cache_free+0xb2/0xc2
[   20.641911]  [<c0196c85>] ? putname+0x29/0x34
[   20.641914]  [<c0196c85>] putname+0x29/0x34
[   20.641917]  [<c018d7e4>] do_sys_open+0xb2/0xbc
[   20.641920]  [<c018d83a>] sys_open+0x23/0x2b
[   20.641923]  [<c010329f>] sysenter_do_call+0x12/0x34
[   20.641925] ---[ end trace fe574a344d5c3229 ]---
[   20.643038] ------------[ cut here ]------------
[   20.643041] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.643043] Hardware name: MacBookPro2,2
[   20.643045] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.643100] Pid: 0, comm: swapper Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.643102] Call Trace:
[   20.643105]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.643111]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.643114]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.643118]  [<c01869de>] ? dma_pool_free+0x18d/0x195
[   20.643122]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.643125]  [<c01869de>] ? dma_pool_free+0x18d/0x195
[   20.643133]  [<f88ed812>] ? qh_completions+0x2b9/0x320 [ehci_hcd]
[   20.643137]  [<c03e2141>] ? _spin_unlock_irqrestore+0x26/0x3c
[   20.643141]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.643144]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.643148]  [<c024382c>] ? _raw_spin_unlock+0x74/0x78
[   20.643151]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.643154]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.643158]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.643162]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.643165]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.643168]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.643180]  [<f85d9965>] ? acpi_idle_enter_simple+0x1b2/0x229 [processor]
[   20.643185]  [<c031f15d>] ? menu_select+0x3d/0x8c
[   20.643188]  [<c031e695>] cpuidle_idle_call+0x65/0x98
[   20.643191]  [<c01023b7>] cpu_idle+0x84/0xa5
[   20.643195]  [<c03d388f>] rest_init+0x53/0x55
[   20.643198] ---[ end trace fe574a344d5c322a ]---
[   20.644103] ------------[ cut here ]------------
[   20.644106] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x49c/0x6d0()
[   20.644108] Hardware name: MacBookPro2,2
[   20.644110] Modules linked in: fan battery container ipt_LOG xt_limit xt_tcpudp xt_state ipt_addrtype nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ftp ipmi_watchdog ipmi_msghandler uvcvideo uinput arpt_mangle arptable_filter arp_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle iptable_filter ip_tables x_tables coretemp eeprom acpi_cpufreq appletouch cpufreq_powersave cpufreq_performance cpufreq_ondemand cpufreq_conservative firewire_sbp2 firewire_core raw1394 isight_firmware snd_hda_codec_idt ohci1394 ac joydev thermal snd_hda_intel snd_hda_codec ath9k video processor button ieee1394 applesmc evdev ehci_hcd uhci_hcd snd_hwdep snd_pcm snd_page_alloc pata_acpi
[   20.644164] Pid: 2543, comm: hald-addon-inpu Tainted: G        W  2.6.28-07812-g5fbbf5f #9
[   20.644166] Call Trace:
[   20.644169]  [<c01292ca>] warn_slowpath+0x76/0xad
[   20.644173]  [<c0213328>] ? selinux_socket_recvmsg+0x1a/0x1c
[   20.644177]  [<c0342ccb>] ? sock_aio_read+0x109/0x117
[   20.644181]  [<c02146dc>] ? inode_has_perm+0x5d/0x67
[   20.644184]  [<c02ee5f9>] ? ata_sff_data_xfer32+0x5d/0xa7
[   20.644188]  [<c02edf9d>] ata_sff_hsm_move+0x49c/0x6d0
[   20.644191]  [<c03e210f>] ? _spin_unlock_irq+0x12/0x1e
[   20.644195]  [<c02ee2fa>] ? ata_sff_interrupt+0x18/0x1f7
[   20.644198]  [<c02ee43d>] ata_sff_interrupt+0x15b/0x1f7
[   20.644202]  [<c015a307>] handle_IRQ_event+0x34/0x69
[   20.644205]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[   20.644208]  [<c0104bc9>] do_IRQ+0x92/0xad
[   20.644211]  [<c010396c>] common_interrupt+0x2c/0x34
[   20.644213] ---[ end trace fe574a344d5c322b ]---
[   20.719784] usb 5-4: USB disconnect, address 3
[   20.864088] Bluetooth: Core ver 2.14
[   20.864296] NET: Registered protocol family 31
[   20.864298] Bluetooth: HCI device and connection manager initialized
[   20.864301] Bluetooth: HCI socket layer initialized
[   20.896097] usb 4-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
[   20.897394] Bluetooth: L2CAP ver 2.11
[   20.897396] Bluetooth: L2CAP socket layer initialized
[   20.919152] Bluetooth: SCO (Voice Link) ver 0.6
[   20.919155] Bluetooth: SCO socket layer initialized
[   20.942952] Bluetooth: RFCOMM socket layer initialized
[   20.942970] Bluetooth: RFCOMM TTY layer initialized
[   20.942972] Bluetooth: RFCOMM ver 1.10
[   21.117977] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   21.117980] Bluetooth: BNEP filters: protocol multicast
[   21.210155] usb 4-1: USB disconnect, address 2
[   21.510051] usb 4-1: new full speed USB device using uhci_hcd and address 3
[   21.723267] usb 4-1: configuration #1 chosen from 1 choice
[   21.932542] Bluetooth: Generic Bluetooth USB driver ver 0.4
[   21.932738] usbcore: registered new interface driver btusb
[   22.520137] usb 5-4: new high speed USB device using ehci_hcd and address 7
[   22.671843] usb 5-4: configuration #1 chosen from 1 choice
[   22.673609] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   22.676040] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   23.002526] Clocksource tsc unstable (delta = -277026392 ns)
[   25.466740] type=1400 audit(1231520418.460:3): avc:  denied  { sys_module } for  pid=2690 comm="wpa_supplicant" capability=16 scontext=system_u:system_r:system_dbusd_t:s0 tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
[   25.488418] type=1300 audit(1231520418.460:3): arch=40000003 syscall=54 success=no exit=-19 a0=9 a1=8933 a2=bf84427c a3=bf84427c items=0 ppid=1 pid=2690 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="wpa_supplicant" exe="/sbin/wpa_supplicant" subj=system_u:system_r:system_dbusd_t:s0 key=(null)
[   28.430086] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[   28.432028] wlan0: authenticated
[   28.432033] wlan0: associate with AP 00:1e:2a:00:67:f0
[   28.434650] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431 status=0 aid=2)
[   28.434657] wlan0: associated
[   33.589775] vendor=8086 device=27a1
[   33.589781] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   33.661461] Linux agpgart interface v0.103
[   33.780288] [drm] Initialized drm 1.1.0 20060810
[   33.837966] pci 0000:01:00.0: setting latency timer to 64
[   33.838243] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   34.212834] Xorg:2852 map pfn expected mapping type write-combining for 40000000-48000000, got uncached-minus
[   34.326059] [drm] Setting GART location based on new memory map
[   34.327563] [drm] Loading R500 Microcode
[   34.327621] [drm] Num pipes: 1
[   34.327636] [drm] writeback test succeeded in 1 usecs
[   40.751986] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   40.753380] input: justinmattock’s mouse #1 as /class/input/input13
[   40.791582] generic-bluetooth 0005:0000:0000.0006: input: BLUETOOTH HID v0.00 Mouse [justinmattock’s mouse #1] on 00:17:F2:B4:BC:F5

--------------090104030903060602000905
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub [8086:27a0] (rev 03)
00:01.0 PCI bridge [0604]: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port [8086:27a1] (rev 03)
00:07.0 Performance counters [1101]: Intel Corporation Device [8086:27a3] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 02)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 [8086:27d2] (rev 02)
00:1c.2 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 [8086:27d4] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 [8086:27c8] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 [8086:27c9] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 [8086:27ca] (rev 02)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 [8086:27cb] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev e2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge [8086:27b9] (rev 02)
00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE Controller [8086:27df] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller [8086:27c4] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 02)
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc M56P [Radeon Mobility X1600] [1002:71c5]
02:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller [11ab:4362] (rev 22)
03:00.0 Network controller [0280]: Atheros Communications Inc. AR5008 Wireless Network Adapter [168c:0024] (rev 01)
0c:03.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB82AA2 IEEE-1394b Link Layer Controller [104c:8025] (rev 01)

--------------090104030903060602000905--
