Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZAISrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZAISrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZAISrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:47:06 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:12959 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbZAISrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:47:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=fDeA3QuvRcEJYWobua6WThzpR3sj3XPLjDB+PFeSZNMePabskMN+gmyIqS4Pxmtsrs
         apjJQf9LiREoyXKNKLNu/5DutWOgc6GbB8DuEQ8ki/Wx7JuA/xpzhZwI/7zHrHSqpByt
         mLz8DR/qPaoM+XhE8n82/HoTczv+OxoM8l2Dg=
Message-ID: <496799C8.1060804@gmail.com>
Date: Fri, 09 Jan 2009 10:39:04 -0800
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
 boundary="------------040200010509060200090409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040200010509060200090409
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
I have applied the patch,
and am not being spammed with
loads of warnings. However there is
one in there:

[    1.902934] ------------[ cut here ]------------
[    1.910604] WARNING: at drivers/ata/libata-sff.c:1017 
ata_sff_hsm_move+0x4de/0x72f()
[    1.912902] Hardware name: MacBookPro2,2
[    1.912902] Modules linked in:
[    1.912902] Pid: 0, comm: swapper Not tainted 2.6.28-07814-gdefbbee #10
[    1.912902] Call Trace:
[    1.912902]  [<c01292ca>] warn_slowpath+0x76/0xad
[    1.912902]  [<c018a64d>] ? check_object+0x139/0x190
[    1.912902]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[    1.912902]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[    1.912902]  [<c03e22a8>] ? _spin_unlock_irqrestore+0x2d/0x3c
[    1.912902]  [<c02327f0>] ? blk_run_queue+0x2d/0x31
[    1.912902]  [<c02ceca9>] ? scsi_run_queue+0x29d/0x324
[    1.912902]  [<c023ba49>] ? kobject_put+0x37/0x3c
[    1.912902]  [<c02afb67>] ? put_device+0x14/0x16
[    1.912902]  [<c02ee75a>] ? ata_sff_data_xfer32+0x5d/0xa7
[    1.912902]  [<c02ee0ce>] ata_sff_hsm_move+0x4de/0x72f
[    1.912902]  [<c02ee448>] ? ata_sff_interrupt+0x18/0x1f7
[    1.912902]  [<c02ee58b>] ata_sff_interrupt+0x15b/0x1f7
[    1.912902]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    1.912902]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    1.912902]  [<c0104bc9>] do_IRQ+0x92/0xad
[    1.912902]  [<c010396c>] common_interrupt+0x2c/0x34
[    1.912902]  [<c010835b>] ? mwait_idle+0x55/0x85
[    1.912902]  [<c01023b1>] ? cpu_idle+0x7e/0xa5
[    1.912902]  [<c01023b7>] cpu_idle+0x84/0xa5
[    1.912902]  [<c03d39ef>] rest_init+0x53/0x55
[    1.912902]  [<c055a818>] start_kernel+0x2dc/0x2e1
[    1.912902]  [<c055a085>] __init_begin+0x85/0x8d
[    1.912902] ---[ end trace c6be6dae142eee34 ]---

I guess the best answer for this, is to just
be patient, until things get worked out.
attached is dmesg.

regards;

Justin P. Mattock

--------------040200010509060200090409
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] Linux version 2.6.28-07814-gdefbbee (root@unix) (gcc version 4.3.3 20081217 (prerelease) (Ubuntu 4.3.2-2ubuntu9) ) #10 SMP Fri Jan 9 10:17:23 PST 2009
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
[    0.000000]   #3 [0000100000 - 0000669250]    TEXT DATA BSS ==> [0000100000 - 0000669250]
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28-07814-gdefbbee root=/dev/sda1 vga=790 debug pnpacpi=off pci=routeirq acpi_osi=Darwin audit=1 selinux=1 ohci1394_dma=early enforcing=0
[    0.000000] ACPI: Added _OSI(Darwin)
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 2161.204 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Memory: 1017788k/1033128k available (2969k kernel code, 14592k reserved, 1457k data, 404k init, 123824k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfff9e000 - 0xfffff000   ( 388 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.010000]       .init : 0xc055a000 - 0xc05bf000   ( 404 kB)
[    0.010000]       .data : 0xc03e64be - 0xc05529c4   (1457 kB)
[    0.010000]       .text : 0xc0100000 - 0xc03e64be   (2969 kB)
[    0.010000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.010000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4322.40 BogoMIPS (lpj=21612040)
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
[    0.041364] ACPI: Core revision 20080926
[    0.061825] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.061832] ftrace: allocating 15027 entries in 59 pages
[    0.067892]   alloc irq_2_pin on cpu 0 node 0
[    0.067901]   alloc irq_2_pin on cpu 0 node 0
[    0.067907]   alloc irq_2_pin on cpu 0 node 0
[    0.067913]   alloc irq_2_pin on cpu 0 node 0
[    0.067919]   alloc irq_2_pin on cpu 0 node 0
[    0.067925]   alloc irq_2_pin on cpu 0 node 0
[    0.067930]   alloc irq_2_pin on cpu 0 node 0
[    0.067936]   alloc irq_2_pin on cpu 0 node 0
[    0.067942]   alloc irq_2_pin on cpu 0 node 0
[    0.067948]   alloc irq_2_pin on cpu 0 node 0
[    0.067954]   alloc irq_2_pin on cpu 0 node 0
[    0.067960]   alloc irq_2_pin on cpu 0 node 0
[    0.067966]   alloc irq_2_pin on cpu 0 node 0
[    0.067972]   alloc irq_2_pin on cpu 0 node 0
[    0.067978]   alloc irq_2_pin on cpu 0 node 0
[    0.068134] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.168154] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.170000] Testing tracer nop: PASSED
[    0.170000] Booting processor 1 APIC 0x1 ip 0x6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine.. 4322.51 BogoMIPS (lpj=21612583)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] [ds] using core 2 configuration
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#1.
[    0.010000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.321749] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.321785] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.330031] Brought up 2 CPUs
[    0.330036] Total of 2 processors activated (8644.92 BogoMIPS).
[    0.330103] CPU0 attaching sched-domain:
[    0.330108]  domain 0: span 0-1 level MC
[    0.330112]   groups: 0 1
[    0.330119] CPU1 attaching sched-domain:
[    0.330122]  domain 0: span 0-1 level MC
[    0.330126]   groups: 1 0
[    0.330214] net_namespace: 800 bytes
[    0.330214] Booting paravirtualized kernel on bare hardware
[    0.330327] NET: Registered protocol family 16
[    0.330327] EISA bus registered
[    0.330327] ACPI: bus type pci registered
[    0.330327] PCI: Using configuration type 1 for base access
[    0.340112] bio: create slab <bio-0> at 0
[    0.341250] ACPI: EC: EC description table is found, configuring boot EC
[    0.341517] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.355071] ACPI: Interpreter enabled
[    0.355078] ACPI: (supports S0 S3 S4 S5)
[    0.355153] ACPI: Using IOAPIC for interrupt routing
[    0.371523] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.371523] ACPI: EC: driver started in interrupt mode
[    0.371523] ACPI: No dock devices found.
[    0.371523] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.371523] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.371523] pci 0000:00:01.0: PME# disabled
[    0.371523] pci 0000:00:07.0: reg 10 32bit mmio: [0x50404000-0x50404fff]
[    0.371523] pci 0000:00:1b.0: reg 10 64bit mmio: [0x50400000-0x50403fff]
[    0.371523] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.371523] pci 0000:00:1b.0: PME# disabled
[    0.371523] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.371523] pci 0000:00:1c.0: PME# disabled
[    0.371523] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.371523] pci 0000:00:1c.1: PME# disabled
[    0.371523] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.371523] pci 0000:00:1c.2: PME# disabled
[    0.371523] pci 0000:00:1d.0: reg 20 io port: [0x4080-0x409f]
[    0.371523] pci 0000:00:1d.1: reg 20 io port: [0x4060-0x407f]
[    0.371523] pci 0000:00:1d.2: reg 20 io port: [0x4040-0x405f]
[    0.371523] pci 0000:00:1d.3: reg 20 io port: [0x4020-0x403f]
[    0.371523] pci 0000:00:1d.7: reg 10 32bit mmio: [0x50405400-0x504057ff]
[    0.371523] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.371523] pci 0000:00:1d.7: PME# disabled
[    0.371523] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.371523] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.371523] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
[    0.371523] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
[    0.371523] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
[    0.371523] pci 0000:00:1f.1: reg 10 io port: [0x40d8-0x40df]
[    0.371523] pci 0000:00:1f.1: reg 14 io port: [0x40ec-0x40ef]
[    0.371523] pci 0000:00:1f.1: reg 18 io port: [0x40d0-0x40d7]
[    0.371523] pci 0000:00:1f.1: reg 1c io port: [0x40e8-0x40eb]
[    0.371523] pci 0000:00:1f.1: reg 20 io port: [0x40b0-0x40bf]
[    0.371523] pci 0000:00:1f.2: reg 10 io port: [0x40c8-0x40cf]
[    0.371523] pci 0000:00:1f.2: reg 14 io port: [0x40e4-0x40e7]
[    0.371523] pci 0000:00:1f.2: reg 18 io port: [0x40c0-0x40c7]
[    0.371523] pci 0000:00:1f.2: reg 1c io port: [0x40e0-0x40e3]
[    0.371523] pci 0000:00:1f.2: reg 20 io port: [0x40a0-0x40af]
[    0.371523] pci 0000:00:1f.2: reg 24 32bit mmio: [0x50405000-0x504053ff]
[    0.371523] pci 0000:00:1f.2: PME# supported from D3hot
[    0.371526] pci 0000:00:1f.2: PME# disabled
[    0.371594] pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
[    0.371673] pci 0000:01:00.0: reg 10 32bit mmio: [0x40000000-0x47ffffff]
[    0.371683] pci 0000:01:00.0: reg 14 io port: [0x3000-0x30ff]
[    0.371694] pci 0000:01:00.0: reg 18 32bit mmio: [0x50300000-0x5030ffff]
[    0.371716] pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.371748] pci 0000:01:00.0: supports D1 D2
[    0.371811] pci 0000:00:01.0: bridge io port: [0x3000-0x3fff]
[    0.371816] pci 0000:00:01.0: bridge 32bit mmio: [0x50300000-0x503fffff]
[    0.371823] pci 0000:00:01.0: bridge 64bit mmio pref: [0x40000000-0x47ffffff]
[    0.371906] pci 0000:02:00.0: reg 10 64bit mmio: [0x50200000-0x50203fff]
[    0.371919] pci 0000:02:00.0: reg 18 io port: [0x2000-0x20ff]
[    0.371957] pci 0000:02:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
[    0.372016] pci 0000:02:00.0: supports D1 D2
[    0.372020] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.372028] pci 0000:02:00.0: PME# disabled
[    0.372095] pci 0000:00:1c.0: bridge io port: [0x2000-0x2fff]
[    0.372102] pci 0000:00:1c.0: bridge 32bit mmio: [0x50200000-0x502fffff]
[    0.372183] pci 0000:03:00.0: reg 10 64bit mmio: [0x50100000-0x5010ffff]
[    0.372281] pci 0000:03:00.0: supports D1
[    0.372284] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.372292] pci 0000:03:00.0: PME# disabled
[    0.372372] pci 0000:00:1c.1: bridge 32bit mmio: [0x50100000-0x501fffff]
[    0.372442] pci 0000:00:1c.2: bridge io port: [0x1000-0x1fff]
[    0.372449] pci 0000:00:1c.2: bridge 32bit mmio: [0x4c100000-0x500fffff]
[    0.372459] pci 0000:00:1c.2: bridge 64bit mmio pref: [0x48000000-0x4bffffff]
[    0.372519] pci 0000:0c:03.0: reg 10 32bit mmio: [0x4c004000-0x4c0047ff]
[    0.372531] pci 0000:0c:03.0: reg 14 32bit mmio: [0x4c000000-0x4c003fff]
[    0.372600] pci 0000:0c:03.0: supports D1 D2
[    0.372603] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.372611] pci 0000:0c:03.0: PME# disabled
[    0.372676] pci 0000:00:1e.0: transparent bridge
[    0.372685] pci 0000:00:1e.0: bridge 32bit mmio: [0x4c000000-0x4c0fffff]
[    0.372723] pci_bus 0000:00: on NUMA node 0
[    0.372738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.381199] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.381795] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.382378] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.382958] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.383566] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.401130] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401130] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401130] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.401130] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.401399] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.401687] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.401974] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.402258] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.410348] SCSI subsystem initialized
[    0.410348] libata version 3.00 loaded.
[    0.410348] usbcore: registered new interface driver usbfs
[    0.410348] usbcore: registered new interface driver hub
[    0.410348] usbcore: registered new device driver usb
[    0.410348] PCI: Using ACPI for IRQ routing
[    0.410348] PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
[    0.410348]   alloc irq_2_pin on cpu 0 node 0
[    0.410348] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410348] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410348]   alloc irq_2_pin on cpu 0 node 0
[    0.410348] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.410348]   alloc irq_2_pin on cpu 0 node 0
[    0.410348] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.410348] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.410348]   alloc irq_2_pin on cpu 0 node 0
[    0.410348] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.410348]   alloc irq_2_pin on cpu 0 node 0
[    0.410348] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.410348]   alloc irq_2_pin on cpu 0 node 0
[    0.410348] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410348] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.410348] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.410348] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.410348] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.410348] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410348] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.410348] vendor=8086 device=27a1
[    0.410348] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410348] vendor=8086 device=27d0
[    0.410348] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.410348] vendor=8086 device=27d2
[    0.410348] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.410348] vendor=8086 device=2448
[    0.410348] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.440090] cfg80211: Using static regulatory domain info
[    0.440090] cfg80211: Regulatory domain: US
[    0.440090] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.440090] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.440090] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440090] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440090] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440090] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.440090] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.440094] cfg80211: Calling CRDA for country: US
[    0.440123] NetLabel: Initializing
[    0.440123] NetLabel:  domain hash size = 128
[    0.440123] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.440142] NetLabel:  unlabeled traffic allowed by default
[    0.440156] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.440163] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.470029] pnp: PnP ACPI: disabled
[    0.501823] Switched to high resolution mode on CPU 1
[    0.505912] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.505919] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.505926] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.505931] pci 0000:00:01.0:   PREFETCH window: 0x00000040000000-0x00000047ffffff
[    0.505941] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.505946] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.505954] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.505962] pci 0000:00:1c.0:   PREFETCH window: 0x00000050500000-0x000000505fffff
[    0.505973] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.505976] pci 0000:00:1c.1:   IO window: disabled
[    0.505984] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.505991] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.506001] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.506006] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.506015] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.506022] pci 0000:00:1c.2:   PREFETCH window: 0x00000048000000-0x0000004bffffff
[    0.506033] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.506037] pci 0000:00:1e.0:   IO window: disabled
[    0.506045] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.506052] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.506065] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.506071] pci 0000:00:01.0: setting latency timer to 64
[    0.506078] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.506085] pci 0000:00:1c.0: setting latency timer to 64
[    0.506093] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.506100] pci 0000:00:1c.1: setting latency timer to 64
[    0.506108] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.506115] pci 0000:00:1c.2: setting latency timer to 64
[    0.510004] Switched to high resolution mode on CPU 0
[    0.510546] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.510556] pci 0000:00:1e.0: setting latency timer to 64
[    0.510562] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.510566] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.510570] pci_bus 0000:01: resource 0 io:  [0x3000-0x3fff]
[    0.510574] pci_bus 0000:01: resource 1 mem: [0x50300000-0x503fffff]
[    0.510579] pci_bus 0000:01: resource 2 mem: [0x40000000-0x47ffffff]
[    0.510583] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.510586] pci_bus 0000:02: resource 0 io:  [0x2000-0x2fff]
[    0.510591] pci_bus 0000:02: resource 1 mem: [0x50200000-0x502fffff]
[    0.510595] pci_bus 0000:02: resource 2 mem: [0x50500000-0x505fffff]
[    0.510599] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.510602] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.510606] pci_bus 0000:03: resource 1 mem: [0x50100000-0x501fffff]
[    0.510610] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.510614] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.510617] pci_bus 0000:04: resource 0 io:  [0x1000-0x1fff]
[    0.510621] pci_bus 0000:04: resource 1 mem: [0x4c100000-0x500fffff]
[    0.510626] pci_bus 0000:04: resource 2 mem: [0x48000000-0x4bffffff]
[    0.510629] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.510633] pci_bus 0000:0c: resource 0 mem: [0x0-0x0]
[    0.510637] pci_bus 0000:0c: resource 1 mem: [0x4c000000-0x4c0fffff]
[    0.510641] pci_bus 0000:0c: resource 2 mem: [0x0-0x0]
[    0.510645] pci_bus 0000:0c: resource 3 io:  [0x00-0xffff]
[    0.510649] pci_bus 0000:0c: resource 4 mem: [0x000000-0xffffffff]
[    0.510682] NET: Registered protocol family 2
[    0.540086] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.540445] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.540896] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    0.541448] TCP: Hash tables configured (established 131072 bind 65536)
[    0.541453] TCP reno registered
[    0.550160] NET: Registered protocol family 1
[    0.551231] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    0.553514] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.555132] Initializing RT-Tester: OK
[    0.555262] audit: initializing netlink socket (enabled)
[    0.555328] type=2000 audit(1231525384.550:1): initialized
[    0.558404] Testing tracer sched_switch: PASSED
[    0.660047] Testing tracer function: PASSED
[    0.790682] Testing dynamic ftrace: PASSED
[    1.030058] Testing tracer irqsoff: PASSED
[    1.040356] Testing tracer wakeup: PASSED
[    1.370269] highmem bounce pool size: 64 pages
[    1.370277] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.388618] fuse init (API version 7.11)
[    1.389288] msgmni has been set to 1746
[    1.389550] SELinux:  Registering netfilter hooks
[    1.390420] alg: No test for stdrng (krng)
[    1.390439] io scheduler noop registered
[    1.390832] io scheduler cfq registered (default)
[    1.390985] pci 0000:01:00.0: Boot video device
[    1.391671] vesafb: framebuffer at 0x40000000, mapped to 0xf8100000, using 3072k, total 16384k
[    1.391678] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    1.391682] vesafb: protected mode interface info at c000:ad0c
[    1.391686] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    1.391690] vesafb: scrolling: redraw
[    1.391694] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    1.416065] Console: switching to colour frame buffer device 128x48
[    1.438277] fb0: VESA VGA frame buffer device
[    1.453688] loop: module loaded
[    1.453841] Linux video capture interface: v2.00
[    1.454311] input: Macintosh mouse button emulation as /class/input/input0
[    1.454947] Driver 'sd' needs updating - please use bus_type methods
[    1.455342] Driver 'sr' needs updating - please use bus_type methods
[    1.456001] ata_piix 0000:00:1f.1: version 2.12
[    1.456332] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    1.456631] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.457004] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.457366] scsi0 : ata_piix
[    1.458056] scsi1 : ata_piix
[    1.460215] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    1.460536] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    1.460872] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.461202] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.620022] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.631721] scsi2 : ata_piix
[    1.639476] scsi3 : ata_piix
[    1.650596] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    1.658261] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    1.666287] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    1.670319] usbcore: registered new interface driver usblcd
[    1.670425] usbcore: registered new interface driver usbled
[    1.670833] PNP: No PS/2 controller found. Probing ports directly.
[    1.671713] i8042.c: No controller found.
[    1.710334] mice: PS/2 mouse device common for all mice
[    1.719243] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    1.727335] EDAC MC: Ver: 2.1.0 Jan  8 2009
[    1.735960] cpuidle: using governor ladder
[    1.744036] cpuidle: using governor menu
[    1.752475] ata1.00: configured for UDMA/66
[    1.754358] usbcore: registered new interface driver hiddev
[    1.754468] usbcore: registered new interface driver usbhid
[    1.754472] usbhid: v2.6:USB HID core driver
[    1.754605] Advanced Linux Sound Architecture Driver Version 1.0.18a.
[    1.754736] ALSA device list:
[    1.754737]   No soundcards found.
[    1.754936] oprofile: using NMI interrupt.
[    1.755209] IPVS: Registered protocols (TCP, AH, ESP)
[    1.755412] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
[    1.755436] IPVS: ipvs loaded.
[    1.755773] Initializing XFRM netlink socket
[    1.755787] NET: Registered protocol family 17
[    1.755794] NET: Registered protocol family 15
[    1.755818] Using IPI No-Shortcut mode
[    1.842978] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    1.842980] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.880540] ata3.01: configured for UDMA/100
[    1.894173] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
[    1.902934] ------------[ cut here ]------------
[    1.910604] WARNING: at drivers/ata/libata-sff.c:1017 ata_sff_hsm_move+0x4de/0x72f()
[    1.912902] Hardware name: MacBookPro2,2
[    1.912902] Modules linked in:
[    1.912902] Pid: 0, comm: swapper Not tainted 2.6.28-07814-gdefbbee #10
[    1.912902] Call Trace:
[    1.912902]  [<c01292ca>] warn_slowpath+0x76/0xad
[    1.912902]  [<c018a64d>] ? check_object+0x139/0x190
[    1.912902]  [<c018aed4>] ? __slab_free+0x280/0x2b8
[    1.912902]  [<c0243883>] ? _raw_spin_lock+0x53/0xf8
[    1.912902]  [<c03e22a8>] ? _spin_unlock_irqrestore+0x2d/0x3c
[    1.912902]  [<c02327f0>] ? blk_run_queue+0x2d/0x31
[    1.912902]  [<c02ceca9>] ? scsi_run_queue+0x29d/0x324
[    1.912902]  [<c023ba49>] ? kobject_put+0x37/0x3c
[    1.912902]  [<c02afb67>] ? put_device+0x14/0x16
[    1.912902]  [<c02ee75a>] ? ata_sff_data_xfer32+0x5d/0xa7
[    1.912902]  [<c02ee0ce>] ata_sff_hsm_move+0x4de/0x72f
[    1.912902]  [<c02ee448>] ? ata_sff_interrupt+0x18/0x1f7
[    1.912902]  [<c02ee58b>] ata_sff_interrupt+0x15b/0x1f7
[    1.912902]  [<c015a307>] handle_IRQ_event+0x34/0x69
[    1.912902]  [<c015b47e>] handle_edge_irq+0xc8/0x109
[    1.912902]  [<c0104bc9>] do_IRQ+0x92/0xad
[    1.912902]  [<c010396c>] common_interrupt+0x2c/0x34
[    1.912902]  [<c010835b>] ? mwait_idle+0x55/0x85
[    1.912902]  [<c01023b1>] ? cpu_idle+0x7e/0xa5
[    1.912902]  [<c01023b7>] cpu_idle+0x84/0xa5
[    1.912902]  [<c03d39ef>] rest_init+0x53/0x55
[    1.912902]  [<c055a818>] start_kernel+0x2dc/0x2e1
[    1.912902]  [<c055a085>] __init_begin+0x85/0x8d
[    1.912902] ---[ end trace c6be6dae142eee34 ]---
[    2.137001] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.144310] Uniform CD-ROM driver Revision: 3.20
[    2.151890] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.159336] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.166507] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
[    2.174297] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.181748] sd 2:0:1:0: [sda] Write Protect is off
[    2.189281] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.196840] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.196875] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    2.212210] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors: (120 GB/111 GiB)
[    2.219968] sd 2:0:1:0: [sda] Write Protect is off
[    2.227508] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.234964] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.242483]  sda: sda1 sda2
[    2.250557] sd 2:0:1:0: [sda] Attached SCSI disk
[    2.262220] kjournald starting.  Commit interval 5 seconds
[    2.262230] EXT3-fs: mounted filesystem with ordered data mode.
[    2.262262] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    2.284801] Freeing unused kernel memory: 404k freed
[    2.901753] SELinux: 8192 avtab hash slots, 145595 rules.
[    3.000823] SELinux: 8192 avtab hash slots, 145595 rules.
[    3.177947] SELinux:  7 users, 9 roles, 2684 types, 95 bools, 1 sens, 256 cats
[    3.185761] SELinux:  73 classes, 145595 rules
[    3.200048] SELinux:  class kernel_service not defined in policy
[    3.208046] SELinux: the above unknown classes and permissions will be denied
[    3.215993] SELinux:  Completing initialization.
[    3.223928] SELinux:  Setting up existing superblocks.
[    3.267051] SELinux: initialized (dev sda1, type ext3), uses xattr
[    3.422421] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[    3.430663] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[    3.438901] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[    3.447241] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[    3.455646] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[    3.464125] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    3.472665] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[    3.481362] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.490125] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[    3.499032] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.508001] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.517000] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.525941] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[    3.534953] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.586324] type=1403 audit(1231525387.580:2): policy loaded auid=4294967295 ses=4294967295
[    4.276658] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.732131] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    4.815277] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[    9.263202] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   10.020530] applesmc: Apple MacBook Pro detected:
[   10.038609] applesmc:  - Model with accelerometer
[   10.047574] applesmc:  - Model with light sensors and backlight
[   10.056523] applesmc:  - Model with 12 temperature sensors
[   10.066189] applesmc: device has already been initialized (0xe0, 0x00).
[   10.074911] applesmc: device successfully initialized.
[   10.084261] applesmc: 2 fans found.
[   10.094500] input: applesmc as /class/input/input1
[   10.128689] Registered led device: smc::kbd_backlight
[   10.137775] applesmc: driver successfully loaded.
[   10.305716] uhci_hcd: USB Universal Host Controller Interface driver
[   10.314633] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.323552] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.332311] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.341058] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   10.349977] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[   10.358926] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   10.367912] usb usb1: configuration #1 chosen from 1 choice
[   10.376759] hub 1-0:1.0: USB hub found
[   10.385436] hub 1-0:1.0: 2 ports detected
[   10.394329] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.403216] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.411929] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.420605] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[   10.429307] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   10.440129] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.448985] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[   10.458686] usb usb2: configuration #1 chosen from 1 choice
[   10.467649] hub 2-0:1.0: USB hub found
[   10.476427] hub 2-0:1.0: 2 ports detected
[   10.485270] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.494175] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   10.503177] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   10.512086] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 3
[   10.525053] ehci_hcd 0000:00:1d.7: debug port 1
[   10.533770] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   10.542553] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[   10.556625] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[   10.566492] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[   10.572510] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.572699] usb usb3: configuration #1 chosen from 1 choice
[   10.572781] hub 3-0:1.0: USB hub found
[   10.572793] hub 3-0:1.0: 8 ports detected
[   10.573627] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.573638] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.573641] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.573709] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   10.573760] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   10.573974] usb usb4: configuration #1 chosen from 1 choice
[   10.574043] hub 4-0:1.0: USB hub found
[   10.574055] hub 4-0:1.0: 2 ports detected
[   10.622526] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   10.622536] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   10.622539] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   10.622621] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   10.622670] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   10.622856] usb usb5: configuration #1 chosen from 1 choice
[   10.622932] hub 5-0:1.0: USB hub found
[   10.622954] hub 5-0:1.0: 2 ports detected
[   10.740099] Monitor-Mwait will be used to enter C-1 state
[   10.747973] Monitor-Mwait will be used to enter C-2 state
[   10.755740] Monitor-Mwait will be used to enter C-3 state
[   10.763575] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   10.771376] processor ACPI_CPU:00: registered as cooling_device0
[   10.779053] ACPI: Processor [CPU0] (supports 8 throttling states)
[   10.788391] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[   10.797299] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[   10.806325] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   10.814253] processor ACPI_CPU:01: registered as cooling_device1
[   10.820000] Marking TSC unstable due to TSC halts in idle
[   10.829590] ACPI: Processor [CPU1] (supports 8 throttling states)
[   10.837522] power_supply ADP1: uevent
[   10.837588] input: Power Button (FF) as /class/input/input2
[   10.853005] power_supply ADP1: No power supply yet
[   10.860686] power_supply ADP1: power_supply_changed
[   10.868324] ACPI: AC Adapter [ADP1] (on-line)
[   10.876178] power_supply ADP1: power_supply_changed_work
[   10.883922] power_supply ADP1: power_supply_update_gen_leds 1
[   10.891648] power_supply ADP1: uevent
[   10.899232] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   10.906753] power_supply ADP1: Static prop TYPE=Mains
[   10.914334] power_supply ADP1: 1 dynamic props
[   10.921734] power_supply ADP1: prop ONLINE=1
[   10.933588] ACPI: Power Button (FF) [PWRF]
[   10.941150] input: Lid Switch as /class/input/input3
[   10.956091] ACPI: Lid Switch [LID0]
[   10.963482] input: Power Button (CM) as /class/input/input4
[   10.974860] ACPI: Power Button (CM) [PWRB]
[   10.982686] input: Sleep Button (CM) as /class/input/input5
[   10.995085] ACPI: Sleep Button (CM) [SLPB]
[   11.027771] ath9k: 0.1
[   11.035208] vendor=8086 device=27d2
[   11.042476] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   11.050023] ath9k 0000:03:00.0: setting latency timer to 64
[   11.152543] usb 3-4: new high speed USB device using ehci_hcd and address 3
[   11.187512] wmaster0 (ath9k): not using net_device_ops yet
[   11.195676] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   11.211649] wlan0 (ath9k): not using net_device_ops yet
[   11.219924] Registered led device: ath9k-phy0:radio
[   11.227793] Registered led device: ath9k-phy0:assoc
[   11.235647] Registered led device: ath9k-phy0:tx
[   11.243307] Registered led device: ath9k-phy0:rx
[   11.250772] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81: mem=0xf80a0000, irq=17
[   11.313472] usb 3-4: configuration #1 chosen from 1 choice
[   11.326298] vendor=8086 device=2448
[   11.334713] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   11.411183] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[   11.462998] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   11.472078] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.539547] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   11.550724] uvcvideo: UVC non compliance - GET_DEF(PROBE) not supported. Enabling workaround.
[   11.560167] usbcore: registered new interface driver uvcvideo
[   11.569001] USB Video Class driver (v0.1.0)
[   11.603294] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   11.671305] input: HDA Intel at 0x50400000 irq 22 Line In at Ext Rear Jack as /class/input/input6
[   11.681726] input: HDA Intel at 0x50400000 irq 22 HP Out at Ext Rear Jack as /class/input/input7
[   11.852566] usb 4-2: new full speed USB device using uhci_hcd and address 2
[   11.871648] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   12.030317] ieee1394: raw1394: /dev/raw1394 device initialized
[   12.051951] usb 4-2: configuration #1 chosen from 1 choice
[   12.070961] generic-usb 0003:05AC:8240.0001: hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[   12.206503] usbcore: registered new interface driver appletouch
[   12.370068] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   12.451588] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.582841] nf_conntrack version 0.5.0 (16142 buckets, 64568 max)
[   12.593959] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[   12.604836] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[   12.605016] usb 5-1: configuration #1 chosen from 1 choice
[   12.626838] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   12.644064] input: HID 05ac:1000 as /class/input/input8
[   12.682860] generic-usb 0003:05AC:1000.0002: input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[   12.694579] arp_tables: (C) 2002 David S. Miller
[   12.709006] input: HID 05ac:1000 as /class/input/input9
[   12.750343] generic-usb 0003:05AC:1000.0003: input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[   12.866038] usbcore: registered new interface driver isight_firmware
[   12.924559] ipmi message handler version 39.2
[   12.950653] IPMI Watchdog: driver initialized
[   13.040240] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   13.235085] usb 1-2: configuration #1 chosen from 1 choice
[   13.244148] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input10
[   13.244811] Adding 2988360k swap on /dev/sda2.  Priority:-1 extents:1 across:2988360k 
[   13.283009] apple 0003:05AC:021A.0004: input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input0
[   13.287764] appletouch: Geyser mode initialized.
[   13.287863] input: appletouch as /class/input/input11
[   13.327862] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input12
[   13.352760] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[   13.370479] apple 0003:05AC:021A.0005: input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
[   13.666766] EXT3 FS on sda1, internal journal
[   16.916641] applesmc: light sensor data length set to 6
[   17.873780] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
[   17.892461] Bluetooth: Core ver 2.14
[   17.892616] NET: Registered protocol family 31
[   17.892618] Bluetooth: HCI device and connection manager initialized
[   17.892622] Bluetooth: HCI socket layer initialized
[   17.926884] Bluetooth: L2CAP ver 2.11
[   17.926888] Bluetooth: L2CAP socket layer initialized
[   17.947969] Bluetooth: SCO (Voice Link) ver 0.6
[   17.947972] Bluetooth: SCO socket layer initialized
[   17.980913] Bluetooth: RFCOMM socket layer initialized
[   17.980931] Bluetooth: RFCOMM TTY layer initialized
[   17.980933] Bluetooth: RFCOMM ver 1.10
[   18.079004] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   18.079007] Bluetooth: BNEP filters: protocol multicast
[   18.190178] usb 5-1: USB disconnect, address 2
[   18.490084] usb 5-1: new full speed USB device using uhci_hcd and address 3
[   18.701079] usb 5-1: configuration #1 chosen from 1 choice
[   18.916093] Bluetooth: Generic Bluetooth USB driver ver 0.4
[   18.916459] usbcore: registered new interface driver btusb
[   20.000179] Clocksource tsc unstable (delta = -448243008 ns)
[   22.487811] type=1400 audit(1231525406.482:3): avc:  denied  { sys_module } for  pid=2710 comm="wpa_supplicant" capability=16 scontext=system_u:system_r:system_dbusd_t:s0 tcontext=system_u:system_r:system_dbusd_t:s0 tclass=capability
[   22.501646] type=1300 audit(1231525406.482:3): arch=40000003 syscall=54 success=no exit=-19 a0=9 a1=8933 a2=bfbbcb1c a3=bfbbcb1c items=0 ppid=1 pid=2710 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="wpa_supplicant" exe="/sbin/wpa_supplicant" subj=system_u:system_r:system_dbusd_t:s0 key=(null)
[   29.509657] vendor=8086 device=27a1
[   29.509663] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   29.584845] Linux agpgart interface v0.103
[   29.721020] [drm] Initialized drm 1.1.0 20060810
[   29.771041] pci 0000:01:00.0: setting latency timer to 64
[   29.771318] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   30.064590] Xorg:2858 map pfn expected mapping type write-combining for 40000000-48000000, got uncached-minus
[   30.187933] [drm] Setting GART location based on new memory map
[   30.189408] [drm] Loading R500 Microcode
[   30.189466] [drm] Num pipes: 1
[   30.189481] [drm] writeback test succeeded in 1 usecs
[   31.967659] wlan0: authenticate with AP 00:1e:2a:00:67:f0
[   31.969627] wlan0: authenticated
[   31.969632] wlan0: associate with AP 00:1e:2a:00:67:f0
[   31.972241] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431 status=0 aid=2)
[   31.972247] wlan0: associated
[   36.486446] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   36.487812] input: justinmattock’s mouse #1 as /class/input/input13
[   36.524143] generic-bluetooth 0005:0000:0000.0006: input: BLUETOOTH HID v0.00 Mouse [justinmattock’s mouse #1] on 00:17:F2:B4:BC:F5
[   74.337168] type=1400 audit(1231525480.391:4): avc:  denied  { write } for  pid=3024 comm="sudo" name="/" dev=tmpfs ino=1430 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:var_run_t:s0 tclass=dir
[   74.337192] type=1400 audit(1231525480.391:4): avc:  denied  { add_name } for  pid=3024 comm="sudo" name="sudo" scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:var_run_t:s0 tclass=dir
[   74.337271] type=1400 audit(1231525480.391:4): avc:  denied  { create } for  pid=3024 comm="sudo" name="sudo" scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=a-12:object_r:var_run_t:s0 tclass=dir
[   74.337361] type=1300 audit(1231525480.391:4): arch=40000003 syscall=39 success=yes exit=0 a0=8069558 a1=1c0 a2=8069558 a3=8070ab8 items=0 ppid=3022 pid=3024 auid=4294967295 uid=0 gid=1000 euid=0 suid=0 fsuid=0 egid=1000 sgid=0 fsgid=1000 tty=pts1 ses=4294967295 comm="sudo" exe="/usr/bin/sudo" subj=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 key=(null)
[   74.337427] type=1400 audit(1231525480.391:5): avc:  denied  { write } for  pid=3024 comm="sudo" name="sudo" dev=tmpfs ino=10506 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=a-12:object_r:var_run_t:s0 tclass=dir
[   74.337449] type=1400 audit(1231525480.391:5): avc:  denied  { add_name } for  pid=3024 comm="sudo" name="a-12" scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=a-12:object_r:var_run_t:s0 tclass=dir
[   74.337500] type=1300 audit(1231525480.391:5): arch=40000003 syscall=39 success=yes exit=0 a0=8070aa0 a1=1c0 a2=2 a3=8070ab8 items=0 ppid=3022 pid=3024 auid=4294967295 uid=0 gid=1000 euid=0 suid=0 fsuid=0 egid=1000 sgid=0 fsgid=1000 tty=pts1 ses=4294967295 comm="sudo" exe="/usr/bin/sudo" subj=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 key=(null)
[   74.354264] type=1400 audit(1231525480.411:6): avc:  denied  { search } for  pid=3024 comm="sudo" name="/" dev=tmpfs ino=1725 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:tmpfs_t:s0 tclass=dir
[   74.354327] type=1300 audit(1231525480.411:6): arch=40000003 syscall=5 success=yes exit=4 a0=805a4aa a1=102 a2=168 a3=0 items=0 ppid=3022 pid=3024 auid=4294967295 uid=0 gid=1000 euid=0 suid=0 fsuid=0 egid=1000 sgid=0 fsgid=1000 tty=pts1 ses=4294967295 comm="sudo" exe="/usr/bin/sudo" subj=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 key=(null)
[   81.087371] type=1400 audit(1231525487.146:7): avc:  denied  { create } for  pid=3024 comm="sudo" name="1" scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=a-12:object_r:var_run_t:s0 tclass=file
[   81.087456] type=1400 audit(1231525487.146:7): avc:  denied  { write } for  pid=3024 comm="sudo" name="1" dev=tmpfs ino=10514 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=a-12:object_r:var_run_t:s0 tclass=file
[   81.087530] type=1300 audit(1231525487.146:7): arch=40000003 syscall=5 success=yes exit=4 a0=8070ab8 a1=241 a2=180 a3=8070aa0 items=0 ppid=3022 pid=3024 auid=4294967295 uid=0 gid=1000 euid=0 suid=0 fsuid=0 egid=1000 sgid=0 fsgid=1000 tty=pts1 ses=4294967295 comm="sudo" exe="/usr/bin/sudo" subj=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 key=(null)
[   81.088308] type=1400 audit(1231525487.146:8): avc:  denied  { write } for  pid=3024 comm="sudo" name="log" dev=tmpfs ino=8466 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:tmpfs_t:s0 tclass=sock_file
[   81.088412] type=1300 audit(1231525487.146:8): arch=40000003 syscall=102 success=yes exit=0 a0=3 a1=bfef1270 a2=b7fb3ff4 a3=0 items=0 ppid=3022 pid=3024 auid=4294967295 uid=0 gid=1000 euid=0 suid=0 fsuid=0 egid=1000 sgid=0 fsgid=1000 tty=pts1 ses=4294967295 comm="sudo" exe="/usr/bin/sudo" subj=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 key=(null)
[   81.089319] type=1400 audit(1231525487.146:9): avc:  denied  { execute } for  pid=3024 comm="sudo" name="su" dev=sda1 ino=3489809 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:su_exec_t:s0 tclass=file
[   81.089369] type=1400 audit(1231525487.146:9): avc:  denied  { read } for  pid=3024 comm="sudo" name="su" dev=sda1 ino=3489809 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:su_exec_t:s0 tclass=file
[   81.089563] type=1400 audit(1231525487.146:9): avc:  denied  { execute_no_trans } for  pid=3024 comm="sudo" path="/bin/su" dev=sda1 ino=3489809 scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:su_exec_t:s0 tclass=file
[   81.169023] type=1300 audit(1231525487.146:9): arch=40000003 syscall=11 success=yes exit=0 a0=8069ff8 a1=bfef19c8 a2=8070830 a3=1 items=0 ppid=3022 pid=3024 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts1 ses=4294967295 comm="su" exe="/bin/su" subj=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 key=(null)
[   81.240379] type=1400 audit(1231525487.301:10): avc:  denied  { compute_av } for  pid=3024 comm="su" scontext=a-12:sysadm_r:sysadm_sudo_t:s0-s0:c0.c255 tcontext=system_u:object_r:security_t:s0 tclass=security

--------------040200010509060200090409--
