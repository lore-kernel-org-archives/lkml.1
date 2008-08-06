Return-Path: <linux-kernel-owner+w=401wt.eu-S1764353AbYHFVag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764353AbYHFVag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764140AbYHFVV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:21:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:33560 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763184AbYHFVVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=vm+hn77clZXW9N3S0TzsNMcdGRHDU9aBRCaRgSXLvviy3hf65HE5fj6a8X5UHSKcVB
         Ff7AI2k41NdpX7Bdb4bjLe4yz0bIU0gxI/d+idBY21KwRVjjJdO3B2x0DI3MinmnaEqA
         1U0YaFuiJfd0kDMztYeNGtAgSa5ZfWPz1e4vg=
Message-ID: <dd18b0c30808061421q20becfd3lad86158f05cea36f@mail.gmail.com>
Date: Wed, 6 Aug 2008 14:21:08 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: BUG kmalloc-64: Object already free
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I must be honest, 2.6.27-rc1-00156-g94ad374
has made me entirely lazy with wanting to add any patches
or taking anything out... but I guess I'll have to pull
and add a patch that was sent to me yesterday.
upon booting I saw this for the first time with isight: <dmesg below>


[    0.000000] Linux version 2.6.27-rc1-00156-g94ad374 (root@unix)
(gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #5 SMP Mon Aug 4 08:40:33
PDT 2008
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
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5
     1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5
Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002
INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000
INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] 112MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00008000 - 0000f000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0038000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00005e9520]    TEXT DATA BSS ==>
[0000100000 - 00005e9520]
[    0.000000]   #4 [00005ea000 - 00005ed000]    INIT_PG_TABLE ==>
[00005ea000 - 00005ed000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x0003f0ea
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258185
[    0.000000] free_area_init_node: node 0, pgdat c04d4300,
node_mem_map c1000000
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 28680 pages, LIFO batch:7
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
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:b0000000)
[    0.000000] PERCPU: Allocating 47220 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 256167
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.27-rc1-00156-g94ad374 root=/dev/sda1 ro
vga=790 debug pnpacpi=off acpi_osi=Darwin pci=routeirq selinux=1
audit=1 enforce=1
[    0.000000] ACPI: Added _OSI(Darwin)
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] Detected 2161.253 MHz processor.
[    0.006666] Console: colour dummy device 80x25
[    0.006666] console [tty0] enabled
[    0.006666] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.006666] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.006666] Memory: 1018292k/1033128k available (2685k kernel code,
14088k reserved, 1406k data, 352k init, 115624k highmem)
[    0.006666] virtual kernel memory layout:
[    0.006666]     fixmap  : 0xfff82000 - 0xfffff000   ( 500 kB)
[    0.006666]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.006666]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.006666]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.006666]       .init : 0xc0506000 - 0xc055e000   ( 352 kB)
[    0.006666]       .data : 0xc039f595 - 0xc04feeb0   (1406 kB)
[    0.006666]       .text : 0xc0100000 - 0xc039f595   (2685 kB)
[    0.006666] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.006666] CPA: page pool initialized 1 of 1 pages preallocated
[    0.006666] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.006666] hpet clockevent registered
[    0.006666] Calibrating delay loop (skipped), value calculated
using timer frequency.. <6>4324.61 BogoMIPS (lpj=7204176)
[    0.006666] Security Framework initialized
[    0.006666] SELinux:  Initializing.
[    0.006666] SELinux:  Starting in permissive mode
[    0.006666] Mount-cache hash table entries: 512
[    0.006666] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.006666] CPU: L2 cache: 4096K
[    0.006666] CPU: Physical Processor ID: 0
[    0.006666] CPU: Processor Core ID: 0
[    0.006666] Intel machine check architecture supported.
[    0.006666] Intel machine check reporting enabled on CPU#0.
[    0.006666] using mwait in idle threads.
[    0.006666] Checking 'hlt' instruction... OK.
[    0.019998] ACPI: Core revision 20080609
[    0.033331] Parsing all Control Methods:
[    0.033556] Table [DSDT](id 0001) - 691 Objects with 79 Devices 157
Methods 29 Regions
[    0.034026] Parsing all Control Methods:
[    0.034213] Table [SSDT](id 0002) - 13 Objects with 0 Devices 4
Methods 0 Regions
[    0.034603] Parsing all Control Methods:
[    0.034793] Table [SSDT](id 0003) - 10 Objects with 3 Devices 4
Methods 0 Regions
[    0.035209] Parsing all Control Methods:
[    0.035402] Table [SSDT](id 0004) - 11 Objects with 3 Devices 5
Methods 0 Regions
[    0.035409]  tbxface-0596 [02] tb_load_namespace     : ACPI Tables
successfully acquired
[    0.035668] evxfevnt-0091 [02] enable                : Transition
to ACPI mode successful
[    0.035944] ENABLING IO-APIC IRQs
[    0.036135] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069148] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.069995] Booting processor 1/1 ip 6000
[    0.079994] Initializing CPU#1
[    0.162412] Calibrating delay using timer specific routine..
<6>4324.61 BogoMIPS (lpj=7204190)
[    0.162420] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.162422] CPU: L2 cache: 4096K
[    0.162424] CPU: Physical Processor ID: 0
[    0.162425] CPU: Processor Core ID: 1
[    0.162427] Intel machine check architecture supported.
[    0.162430] Intel machine check reporting enabled on CPU#1.
[    0.162191] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.162229] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.166655] Brought up 2 CPUs
[    0.166655] Total of 2 processors activated (8648.22 BogoMIPS).
[    0.166655] CPU0 attaching sched-domain:
[    0.166655]  domain 0: span 0-1 level MC
[    0.166655]   groups: 0 1
[    0.166655] CPU1 attaching sched-domain:
[    0.166655]  domain 0: span 0-1 level MC
[    0.166655]   groups: 1 0
[    0.166655] net_namespace: 648 bytes
[    0.166655] Booting paravirtualized kernel on bare hardware
[    0.166655] NET: Registered protocol family 16
[    0.166655] No dock devices found.
[    0.166656] EISA bus registered
[    0.166656] ACPI: bus type pci registered
[    0.166656] PCI: Using configuration type 1 for base access
[    0.171979] evgpeblk-0957 [04] ev_create_gpe_block   : GPE 00 to 1F
[_GPE] 4 regs on int 0x9
[    0.172127] ACPI: EC: EC description table is found, configuring boot EC
[    0.171647] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.179890] Completing Region/Field/Buffer/Package
initialization:...................................................................
[    0.183580] Initialized 27/29 Regions 0/0 Fields 21/21 Buffers
19/19 Packages (734 nodes)
[    0.183588] Initializing Device/Processor/Thermal objects by
executing _INI methods:..
[    0.184574] Executed 2 _INI methods requiring 0 _STA executions
(examined 89 objects)
[    0.185003] evgpeblk-1054 [03] ev_initialize_gpe_bloc: Found 7
Wake, Enabled 6 Runtime GPEs in this block
[    0.185080] ACPI: Interpreter enabled
[    0.185085] ACPI: (supports S0 S3 S4 S5)
[    0.185148] ACPI: Using IOAPIC for interrupt routing
[    0.202628] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.202634] ACPI: EC: driver started in interrupt mode
[    0.202752] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.202959] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.202966] pci 0000:00:01.0: PME# disabled
[    0.203139] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.203147] pci 0000:00:1b.0: PME# disabled
[    0.203219] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.203227] pci 0000:00:1c.0: PME# disabled
[    0.203299] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.203306] pci 0000:00:1c.1: PME# disabled
[    0.203378] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.203386] pci 0000:00:1c.2: PME# disabled
[    0.203751] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.203759] pci 0000:00:1d.7: PME# disabled
[    0.203923] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
ICH6 ACPI/GPIO/TCO
[    0.203931] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.204114] pci 0000:00:1f.2: PME# supported from D3hot
[    0.204121] pci 0000:00:1f.2: PME# disabled
[    0.204279] pci 0000:01:00.0: supports D1
[    0.204282] pci 0000:01:00.0: supports D2
[    0.204482] pci 0000:02:00.0: supports D1
[    0.204485] pci 0000:02:00.0: supports D2
[    0.204489] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.204498] pci 0000:02:00.0: PME# disabled
[    0.204707] pci 0000:03:00.0: supports D1
[    0.204711] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.204720] pci 0000:03:00.0: PME# disabled
[    0.204966] pci 0000:0c:03.0: supports D1
[    0.204970] pci 0000:0c:03.0: supports D2
[    0.204973] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.204981] pci 0000:0c:03.0: PME# disabled
[    0.205037] pci 0000:00:1e.0: transparent bridge
[    0.205080] bus 00 -> node 0
[    0.205094] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.206838] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.207398] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.207959] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.208505] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.209077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.230617] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.230894] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.231165] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.231434] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.231702] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.231981] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.232252] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.232521] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.233105] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.233195] pnp: PnP ACPI: disabled
[    0.233781] SCSI subsystem initialized
[    0.233873] libata version 3.00 loaded.
[    0.234202] usbcore: registered new interface driver usbfs
[    0.234383] usbcore: registered new interface driver hub
[    0.234506] usbcore: registered new device driver usb
[    0.235244] PCI: Using ACPI for IRQ routing
[    0.235249] PCI: Routing PCI interrupts for all devices because
"pci=routeirq" specified
[    0.235263] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.235271] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.235279] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.235286] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.235294] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.235301] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.235309] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.235317] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.235324] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.235332] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.235339] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.235349] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.235356] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.235363] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.235370] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.235377] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.235384] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.235392] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.240756] NetLabel: Initializing
[    0.240760] NetLabel:  domain hash size = 128
[    0.240764] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.240833] NetLabel:  unlabeled traffic allowed by default
[    0.240844] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.240851] hpet0: 3 64-bit timers, 14318180 Hz
[    0.276072] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.276079] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.276085] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.276092] pci 0000:00:01.0:   PREFETCH window:
0x00000040000000-0x00000047ffffff
[    0.276101] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.276107] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.276116] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.276124] pci 0000:00:1c.0:   PREFETCH window:
0x00000050500000-0x000000505fffff
[    0.276136] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.276140] pci 0000:00:1c.1:   IO window: disabled
[    0.276148] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.276156] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.276166] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.276172] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.276180] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.276188] pci 0000:00:1c.2:   PREFETCH window:
0x00000048000000-0x0000004bffffff
[    0.276200] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.276204] pci 0000:00:1e.0:   IO window: disabled
[    0.276213] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.276220] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.276235] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.276241] pci 0000:00:01.0: setting latency timer to 64
[    0.276252] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.276259] pci 0000:00:1c.0: setting latency timer to 64
[    0.276271] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.276278] pci 0000:00:1c.1: setting latency timer to 64
[    0.276290] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.276297] pci 0000:00:1c.2: setting latency timer to 64
[    0.280761] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.280772] pci 0000:00:1e.0: setting latency timer to 64
[    0.280793] NET: Registered protocol family 2
[    0.291541] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.291849] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.292288] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    0.292850] TCP: Hash tables configured (established 131072 bind 65536)
[    0.292856] TCP reno registered
[    0.294940] NET: Registered protocol family 1
[    0.296992] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[    0.298178] Initializing RT-Tester: OK
[    0.298291] audit: initializing netlink socket (enabled)
[    0.298312] type=2000 audit(1218056841.293:1): initialized
[    0.303389] highmem bounce pool size: 64 pages
[    0.303397] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.318956] fuse init (API version 7.9)
[    0.319500] msgmni has been set to 1763
[    0.319725] SELinux:  Registering netfilter hooks
[    0.319952] io scheduler noop registered
[    0.320269] io scheduler cfq registered (default)
[    0.320409] pci 0000:01:00.0: Boot video device
[    0.320889] vesafb: framebuffer at 0x40000000, mapped to
0xf8880000, using 3072k, total 16384k
[    0.320896] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    0.320901] vesafb: protected mode interface info at c000:ad0c
[    0.320906] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    0.320911] vesafb: scrolling: redraw
[    0.320915] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    0.345377] Console: switching to colour frame buffer device 128x48
[    0.367708] fb0: VESA VGA frame buffer device
[    0.377956] hpet_resources: 0xfed00000 is busy
[    0.380253] loop: module loaded
[    0.380410] Linux video capture interface: v2.00
[    0.380844] input: Macintosh mouse button emulation as /class/input/input0
[    0.381437] Driver 'sd' needs updating - please use bus_type methods
[    0.381824] Driver 'sr' needs updating - please use bus_type methods
[    0.382432] ata_piix 0000:00:1f.1: version 2.12
[    0.382740] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.383040] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.383414] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.383772] scsi0 : ata_piix
[    0.383629] scsi1 : ata_piix
[    0.385731] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    0.386054] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    0.504799] Switched to high resolution mode on CPU 1
[    0.506633] Switched to high resolution mode on CPU 0
[    0.540564] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.560527] ata1.00: configured for UDMA/66
[    0.732849] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R
UJ-857D  KCV9 PQ: 0 ANSI: 5
[    0.745653] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.754167] Uniform CD-ROM driver Revision: 3.20
[    0.762821] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.771310] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.779557] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.787933] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.946671] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.954959] scsi2 : ata_piix
[    0.963219] scsi3 : ata_piix
[    0.974504] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    0.982713] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    1.160484] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    1.168643] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.190492] ata3.01: configured for UDMA/100
[    1.361208] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU
MHW2120B 0081 PQ: 0 ANSI: 5
[    1.369925] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    1.378315] sd 2:0:1:0: [sda] Write Protect is off
[    1.386520] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.394695] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.403179] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    1.411550] sd 2:0:1:0: [sda] Write Protect is off
[    1.419840] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.428059] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.436474]  sda: sda1 sda2
[    1.445493] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.454089] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.462694] usbcore: registered new interface driver usblcd
[    1.471242] usbcore: registered new interface driver usbled
[    1.479713] PNP: No PS/2 controller found. Probing ports directly.
[    1.488935] i8042.c: No controller found.
[    1.501103] mice: PS/2 mouse device common for all mice
[    1.510165] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    1.518831] EDAC MC: Ver: 2.1.0 Jul 30 2008
[    1.524164] cpuidle: using governor ladder
[    1.532735] cpuidle: using governor menu
[    1.541451] usbcore: registered new interface driver hiddev
[    1.550153] usbcore: registered new interface driver usbhid
[    1.558767] usbhid: v2.6:USB HID core driver
[    1.567460] Advanced Linux Sound Architecture Driver Version 1.0.17.
[    1.576205] ALSA device list:
[    1.584873]   No soundcards found.
[    1.593636] oprofile: using NMI interrupt.
[    1.602674] IPVS: Registered protocols (TCP, AH, ESP)
[    1.611206] IPVS: Connection hash table configured (size=4096,
memory=32Kbytes)
[    1.619746] IPVS: ipvs loaded.
[    1.628242] Initializing XFRM netlink socket
[    1.636729] NET: Registered protocol family 17
[    1.645157] NET: Registered protocol family 15
[    1.653561] Starting balanced_irq
[    1.661903] Using IPI No-Shortcut mode
[    1.710295] kjournald starting.  Commit interval 5 seconds
[    1.718744] EXT3-fs: mounted filesystem with ordered data mode.
[    1.727164] VFS: Mounted root (ext3 filesystem) readonly.
[    1.735947] Freeing unused kernel memory: 352k freed
[    2.201917] type=1404 audit(1218056843.198:2): enforcing=1
old_enforcing=0 auid=4294967295 ses=4294967295
[    2.523821] SELinux: 8192 avtab hash slots, 240195 rules.
[    2.678625] SELinux: 8192 avtab hash slots, 240195 rules.
[    2.853824] SELinux:  7 users, 9 roles, 3113 types, 96 bools
[    2.862398] SELinux:  73 classes, 240195 rules
[    2.877073] SELinux:  Completing initialization.
[    2.885458] SELinux:  Setting up existing superblocks.
[    2.929408] SELinux: initialized (dev sda1, type ext3), uses xattr
[    2.992225] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    3.000734] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    3.009154] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses genfs_contexts
[    3.017445] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    3.025767] SELinux: initialized (dev inotifyfs, type inotifyfs),
uses genfs_contexts
[    3.034173] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    3.042583] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    3.051230] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.059820] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    3.068401] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.076964] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.085354] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.093476] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    3.101680] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.128383] type=1403 audit(1218056844.123:3): policy loaded
auid=4294967295 ses=4294967295
[    4.102935] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.116555] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    8.378798] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    9.827881] ACPI: SBS HC: EC = 0xf78933c0, offset = 0x20, query_bit = 0x10
[    9.860897] power_supply ADP1: uevent
[    9.870246] power_supply ADP1: No power supply yet
[    9.898259] power_supply ADP1: power_supply_changed
[    9.907477] ACPI: AC Adapter [ADP1] (on-line)
[    9.916695] power_supply ADP1: power_supply_changed_work
[    9.925841] power_supply ADP1: power_supply_update_gen_leds 1
[    9.931056] power_supply ADP1: uevent
[    9.940114] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    9.949234] power_supply ADP1: Static prop TYPE=Mains
[    9.958266] power_supply ADP1: 1 dynamic props
[    9.967232] power_supply ADP1: prop ONLINE=1
[   10.178334] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000
INTL 20050309)
[   10.187056] Parsing all Control Methods:
[   10.187840] Table [SSDT](id 0020) - 5 Objects with 0 Devices 3
Methods 0 Regions
[   10.215833] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001
INTL 20050309)
[   10.220833] Parsing all Control Methods:
[   10.220862] Table [SSDT](id 0021) - 1 Objects with 0 Devices 1
Methods 0 Regions
[   10.238210] Monitor-Mwait will be used to enter C-1 state
[   10.247237] Monitor-Mwait will be used to enter C-2 state
[   10.255999] Monitor-Mwait will be used to enter C-3 state
[   10.263702] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   10.279883] processor ACPI0007:00: registered as cooling_device0
[   10.290834] ACPI: Processor [CPU0] (supports 8 throttling states)
[   10.297675] Marking TSC unstable due to TSC halts in idle
[   10.301169] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
INTL 20050309)
[   10.301278] Parsing all Control Methods:
[   10.301477] Table [SSDT](id 0025) - 3 Objects with 0 Devices 3
Methods 0 Regions
[   10.302060] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
INTL 20050309)
[   10.302126] Parsing all Control Methods:
[   10.302320] Table [SSDT](id 0026) - 1 Objects with 0 Devices 1
Methods 0 Regions
[   10.303162] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   10.303209] processor ACPI0007:01: registered as cooling_device1
[   10.303214] ACPI: Processor [CPU1] (supports 8 throttling states)
[   10.389809] input: Power Button (FF) as /class/input/input1
[   10.405672] ACPI: Power Button (FF) [PWRF]
[   10.415106] input: Lid Switch as /class/input/input2
[   10.424296] ACPI: Lid Switch [LID0]
[   10.433418] input: Power Button (CM) as /class/input/input3
[   10.443794] ACPI: Power Button (CM) [PWRB]
[   10.452913] USB Universal Host Controller Interface driver v3.0
[   10.534654] input: Sleep Button (CM) as /class/input/input4
[   10.472255] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.550286] ACPI: Sleep Button (CM) [SLPB]
[   10.490279] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.499376] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.508639] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   10.518123] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   10.527470] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   10.538004] usb usb1: configuration #1 chosen from 1 choice
[   10.547543] hub 1-0:1.0: USB hub found
[   10.557071] hub 1-0:1.0: 2 ports detected
[   10.570487] input: Video Bus as /class/input/input5
[   10.644677] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   10.614205] ath_hal: module license 'Proprietary' taints kernel.
[   10.625357] ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416,
RF5111, RF5112, RF2413, RF5413, RF2133)
[   10.775538] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.785819] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.795599] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.814169] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   10.824050] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   10.835972] usb usb2: configuration #1 chosen from 1 choice
[   10.861259] hub 2-0:1.0: USB hub found
[   10.871335] hub 2-0:1.0: 2 ports detected
[   10.885030] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   10.959438] wlan: svn r3359
[   11.073151] usb 1-2: configuration #1 chosen from 1 choice
[   11.089229] Linux agpgart interface v0.103
[   11.107995] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input6
[   11.112454] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.122327] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.132565] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.145869] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   11.155529] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   11.165576] usb usb3: configuration #1 chosen from 1 choice
[   11.179049] hub 3-0:1.0: USB hub found
[   11.188032] hub 3-0:1.0: 2 ports detected
[   11.197243] input: USB HID v1.11 Keyboard [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   11.212803] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input7
[   11.227918] input: USB HID v1.11 Device [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   11.319854] ath_pci: svn r3359
[   11.348530] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   11.400689] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   11.411050] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   11.421312] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   11.431470] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   11.441651] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   11.451868] usb usb4: configuration #1 chosen from 1 choice
[   11.461992] hub 4-0:1.0: USB hub found
[   11.471951] hub 4-0:1.0: 2 ports detected
[   11.512266] usb 2-2: configuration #1 chosen from 1 choice
[   11.528407] appletouch: Geyser mode initialized.
[   11.538508] input: appletouch as /class/input/input8
[   11.630013] usb 3-2: new full speed USB device using uhci_hcd and address 2
[   11.670049] Symbol init_mm is marked as UNUSED, however this module
is using it.
[   11.679853] This symbol will go away in the future.
[   11.689557] Please evalute if this is the right api to use and if
it really is, submit a report the linux kernel mailinglist together
with submitting your code for inclusion.
[   11.691573] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   11.691617] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   11.748294] [fglrx] Maximum main memory to use for locked dma
buffers: 913 MBytes.
[   11.758513] [fglrx] ASYNCIO init succeed!
[   11.770463] [fglrx] PAT is enabled successfully!
[   11.781315] [fglrx] module loaded - fglrx 8.47.3 [Mar 29 2008] on minor 0
[   11.795835] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   11.844179] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   11.854895] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   11.865355] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   11.868382] usb 3-2: configuration #1 chosen from 1 choice
[   11.886174] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   11.900729] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR
Receiver] on usb-0000:00:1d.2-2
[   11.900729] firmware: requesting isight.fw
[   11.946099] ehci_hcd 0000:00:1d.7: debug port 1
[   11.956524] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   11.966913] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[   11.996180] usb 4-1: new full speed USB device using uhci_hcd and address 2
[   12.014319] Failed to load isight firmware
[   12.017566] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   12.017792] usb usb5: configuration #1 chosen from 1 choice
[   12.017878] hub 5-0:1.0: USB hub found
[   12.017890] hub 5-0:1.0: 8 ports detected
[   12.067187] =============================================================================
[   12.067875] BUG kmalloc-64: Object already free
[   12.067875] -----------------------------------------------------------------------------
[   12.067875]
[   12.067875] INFO: Allocated in isight_firmware_load+0x23/0x1ef
[isight_firmware] age=54 cpu=0 pid=1548
[   12.067875] INFO: Freed in isight_firmware_load+0x1c2/0x1ef
[isight_firmware] age=0 cpu=0 pid=1548
[   12.067875] INFO: Slab 0xc169b1e0 objects=36 used=35 fp=0xf4d8f540
flags=0x400000c3
[   12.067875] INFO: Object 0xf4d8f540 @offset=1344 fp=0x00000000
[   12.067875]
[   12.067875] Bytes b4 0xf4d8f530:  00 00 00 00 00 00 00 00 5a 5a 5a
5a 5a 5a 5a 5a ........ZZZZZZZZ
[   12.067875]   Object 0xf4d8f540:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   12.067875]   Object 0xf4d8f550:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   12.067875]   Object 0xf4d8f560:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   12.067875]   Object 0xf4d8f570:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[   12.067875]  Redzone 0xf4d8f580:  bb bb bb bb
              »»»»
[   12.067875]  Padding 0xf4d8f5a8:  5a 5a 5a 5a 5a 5a 5a 5a
              ZZZZZZZZ
[   12.067875] Pid: 1548, comm: modprobe Tainted: P
2.6.27-rc1-00156-g94ad374 #5
[   12.067875]  [<c0170a6f>] print_trailer+0xd4/0xdc
[   12.067875]  [<c0170b2f>] object_err+0x25/0x30
[   12.067875]  [<c0171388>] __slab_free+0x1b9/0x279
[   12.067875]  [<c0171ad9>] kfree+0xa3/0xb9
[   12.067875]  [<f8be01e1>] ? isight_firmware_load+0x1dc/0x1ef
[isight_firmware]
[   12.067875]  [<f8be01e1>] ? isight_firmware_load+0x1dc/0x1ef
[isight_firmware]
[   12.067875]  [<f8be01e1>] isight_firmware_load+0x1dc/0x1ef [isight_firmware]
[   12.067875]  [<c02ced3b>] usb_probe_interface+0xbd/0xf2
[   12.067875]  [<c0284638>] driver_probe_device+0xb8/0x133
[   12.067875]  [<c02846f0>] __driver_attach+0x3d/0x5f
[   12.067875]  [<c0283e5c>] bus_for_each_dev+0x37/0x5c
[   12.067875]  [<c02844b7>] driver_attach+0x14/0x16
[   12.067875]  [<c02846b3>] ? __driver_attach+0x0/0x5f
[   12.067875]  [<c02841f7>] bus_add_driver+0x93/0x1bc
[   12.067875]  [<c028486b>] driver_register+0x71/0xcc
[   12.067875]  [<c02ce6cf>] usb_register_driver+0x71/0xcb
[   12.067875]  [<f8be2017>] isight_firmware_init+0x17/0x19 [isight_firmware]
[   12.067875]  [<c0142f25>] sys_init_module+0x163f/0x17ae
[   12.067875]  [<c01171e6>] ? kmap_atomic_prot+0x1a8/0x1d5
[   12.067875]  [<c0153d77>] ? unlock_page+0x25/0x28
[   12.067875]  [<c0102f9a>] syscall_call+0x7/0xb
[   12.067875]  =======================
[   12.067875] FIX kmalloc-64: Object at 0xf4d8f540 not freed
[   12.887982] hub 4-0:1.0: unable to enumerate USB device on port 1
[   12.887982] usbcore: registered new interface driver appletouch
[   12.514850] usbcore: registered new interface driver isight_firmware
[   12.555312] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   12.914559] ath_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.914559] ath_pci 0000:03:00.0: setting latency timer to 64
[   12.614169] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[   12.914559] MadWifi: ath_attach: Switching rfkill capability off
[   12.716732] usb 2-2: USB disconnect, address 2
[   12.916678] ath_rate_sample: 1.2 (svn r3359)
[   12.916678] MadWifi: ath_attach: Switching per-packet transmit
power control off
[   12.916678] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   12.916678] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   12.916678] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps
9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   12.916678] wifi0: turboA rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   12.916678] wifi0: turboG rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   12.916678] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   12.916678] wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
[   12.916678] wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
[   12.875986] usb 3-2: USB disconnect, address 2
[   12.916678] wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
[   12.916678] wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
[   12.916678] wifi0: ath_announce: Use hw queue 8 for CAB traffic
[   12.916686] wifi0: ath_announce: Use hw queue 9 for beacons
[   12.955479] ath_pci: wifi0: Atheros 5418: mem=0x50100000, irq=17
[   13.013023] usb 1-2: USB disconnect, address 2
[   13.033928] input: appletouch disconnected
[   13.259886] usb 5-4: new high speed USB device using ehci_hcd and address 3
[   13.391804] usb 5-4: configuration #1 chosen from 1 choice
[   13.400415] firmware: requesting isight.fw
[   13.891757] usb 1-2: new full speed USB device using uhci_hcd and address 3
[   13.909910] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[   13.999206] Clocksource tsc unstable (delta = -448923007 ns)
[   14.083556] usb 1-2: configuration #1 chosen from 1 choice
[   14.099986] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input9
[   14.114771] input: USB HID v1.11 Keyboard [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   14.133421] appletouch: Geyser mode initialized.
[   14.140010] input: appletouch as /class/input/input10
[   14.158783] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input11
[   14.176314] input: USB HID v1.11 Device [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   14.413677] usb 3-2: new full speed USB device using uhci_hcd and address 3
[   14.598247] usb 3-2: configuration #1 chosen from 1 choice
[   14.616507] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR
Receiver] on usb-0000:00:1d.2-2
[   14.853135] usb 4-1: new full speed USB device using uhci_hcd and address 3
[   15.043790] usb 4-1: configuration #1 chosen from 1 choice
[   15.077082] input: HID 05ac:1000 as /class/input/input12
[   15.091490] input: USB HID v1.11 Keyboard [HID 05ac:1000] on
usb-0000:00:1d.3-1
[   15.118213] input: HID 05ac:1000 as /class/input/input13
[   15.131079] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[   15.567787] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   15.676821] applesmc: Apple MacBook Pro detected:
[   15.697174] applesmc:  - Model with accelerometer
[   15.708244] applesmc:  - Model with light sensors and backlight
[   15.718306] applesmc:  - Model with 12 temperature sensors
[   15.728477] usb 5-4: USB disconnect, address 3
[   15.791803] applesmc: device successfully initialized (0xe0, 0x00).
[   15.806769] applesmc: device successfully initialized.
[   15.817306] applesmc: 2 fans found.
[   15.827814] input: applesmc as /class/input/input14
[   15.849484] Registered led device: smc::kbd_backlight
[   15.859846] applesmc: driver successfully loaded.
[   16.128951] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.261268] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   16.272869] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Plase use
[   16.283676] nf_conntrack.acct=1 kernel paramater, acct=1
nf_conntrack module option or
[   16.294966] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   16.360891] arp_tables: (C) 2002 David S. Miller
[   16.442153] ieee80211_crypt: registered algorithm 'NULL'
[   16.498204] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   16.508964] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   16.534591] ieee80211_crypt: registered algorithm 'TKIP'
[   16.682458] usbcore: registered new interface driver uvcvideo
[   16.690038] USB Video Class driver (v0.1.0)
[   16.750064] ipmi message handler version 39.2
[   16.785375] IPMI Watchdog: driver initialized
[   16.869681] Adding 2980048k swap on
/dev/disk/by-uuid/4ac7c3b0-cb17-473c-8686-474b07ddf732.  Priority:-1
extents:1 across:2980048k
[   17.062587] EXT3 FS on sda1, internal journal
[   17.267716] SELinux: initialized (dev fusectl, type fusectl), uses
genfs_contexts
[   17.317592] usb 5-4: new high speed USB device using ehci_hcd and address 6
[   17.442317] usb 5-4: configuration #1 chosen from 1 choice
[   17.442775] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   17.445066] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
: -32 (exp. 26).
[   17.457246] input: Built-in iSight as /class/input/input15
[   23.154192] Bluetooth: Core ver 2.12
[   23.155244] NET: Registered protocol family 31
[   23.155249] Bluetooth: HCI device and connection manager initialized
[   23.155252] Bluetooth: HCI socket layer initialized
[   23.201293] Bluetooth: L2CAP ver 2.10
[   23.201299] Bluetooth: L2CAP socket layer initialized
[   23.233121] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   23.253387] usb 4-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[   23.307048] Bluetooth: RFCOMM socket layer initialized
[   23.307964] Bluetooth: RFCOMM TTY layer initialized
[   23.307972] Bluetooth: RFCOMM ver 1.10
[   23.742568] usb 4-1: reset full speed USB device using uhci_hcd and address 3
[   23.898310] usb 4-1: device firmware changed
[   23.911413] usb 4-1: USB disconnect, address 3
[   24.025931] usb 4-1: new full speed USB device using uhci_hcd and address 4
[   24.223796] usb 4-1: configuration #1 chosen from 1 choice
[   24.388837] Bluetooth: HCI USB driver ver 2.9
[   24.394979] usbcore: registered new interface driver hci_usb
[   30.288500] CPA self-test:
[   30.289242]  4k 1024 large 223 gb 0 x 1247[c0000000-f7c00000] miss 0
[   30.313583]  4k 195584 large 33 gb 0 x 195617[c0000000-f7fff000] miss 0
[   30.326432]  4k 195584 large 33 gb 0 x 195617[c0000000-f7fff000] miss 0
[   30.326443] ok.
[   35.104087] fglrx_pci 0000:01:00.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   37.272756] [fglrx] Reserve Block - 0 offset =  0X7ffb000 length = 0X5000
[   37.272764] [fglrx] Reserve Block - 1 offset =  0X0 length = 0X1000000
[   37.272767] [fglrx] Reserve Block - 2 offset =  0X7fbb000 length = 0X40000
[   37.557032] [fglrx] interrupt source 20008000 successfully enabled
[   37.557038] [fglrx] enable ID = 0x00000008
[   37.557046] [fglrx] Receive enable interrupt message with
irqEnableMask: 20008000
[   37.557138] [fglrx] interrupt source 10000000 successfully enabled
[   37.557141] [fglrx] enable ID = 0x00000009
[   37.557146] [fglrx] Receive enable interrupt message with
irqEnableMask: 10000000
[   41.458282] input: Apple Computer, Inc. Mighty Mouse as /class/input/input16

regards;

-- 
Justin P. Mattock
