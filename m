Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbZGOLcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbZGOLcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZGOLcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:32:20 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:36839 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbZGOLcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:32:15 -0400
Date: Wed, 15 Jul 2009 13:32:10 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-kernel@vger.kernel.org
Cc: linux-mtd@lists.infradead.org
Subject: Mounting more than one ubifs fails on 2.6.31-rc2
Message-ID: <20090715113210.GB16289@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following error when trying to mount a second ubifs:
"mount: File exists"
Apparently the problem is that ubifs is registered in /sys/class/bdi
with it's name 'ubifs' instead of the ubi device major/minor and
so can only be registered once.

navi:/home/ranma# mount -t ubifs ubi1:rootfs /mnt/ubi1
navi:/home/ranma# mount -t ubifs ubi0:rootfs /mnt/ubi0
mount: File exists
navi:/home/ranma# umount /mnt/ubi1
navi:/home/ranma# mount -t ubifs ubi0:rootfs /mnt/ubi0
navi:/home/ranma# mount -t ubifs ubi1:rootfs /mnt/ubi1
mount: File exists

The corresponding kernel error messages is:
sysfs: cannot create duplicate filename '/class/bdi/ubifs'

[    0.000000] Linux version 2.6.31-rc2 (ranma@navi) (gcc version 4.3.3 (Debian 4.3.3-13) ) #13 Tue Jul 14 23:45:46 CEST 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005f6d0000 (usable)
[    0.000000]  BIOS-e820: 000000005f6d0000 - 000000005f6e5000 (ACPI data)
[    0.000000]  BIOS-e820: 000000005f6e5000 - 000000005f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000005f700000 - 0000000060000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x5f6d0 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DBFFF uncachable
[    0.000000]   DC000-DFFFF write-back
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 040000000 mask FE0000000 write-back
[    0.000000]   2 base 05F700000 mask FFFF00000 uncachable
[    0.000000]   3 base 05F800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-c000
[    0.000000] ACPI: RSDP 000f6c80 00024 (v02 IBM   )
[    0.000000] ACPI: XSDT 5f6d5c43 0005C (v01 IBM    TP-75    00002060  LTP 00000000)
[    0.000000] ACPI: FACP 5f6d5d00 000F4 (v03 IBM    TP-75    00002060 IBM  00000001)
[    0.000000] ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 20090521 tbfadt-527
[    0.000000] ACPI Warning: Optional field Gpe1Block has zero address or length: 000000000000102C/0 20090521 tbfadt-558
[    0.000000] ACPI: DSDT 5f6d5ee7 0EEB9 (v01 IBM    TP-75    00002060 MSFT 0100000E)
[    0.000000] ACPI: FACS 5f6f6000 00040
[    0.000000] ACPI: SSDT 5f6d5eb4 00033 (v01 IBM    TP-75    00002060 MSFT 0100000E)
[    0.000000] ACPI: ECDT 5f6e4da0 00052 (v01 IBM    TP-75    00002060 IBM  00000001)
[    0.000000] ACPI: TCPA 5f6e4df2 00032 (v01 IBM    TP-75    00002060 PTL  00000001)
[    0.000000] ACPI: APIC 5f6e4e24 0005A (v01 IBM    TP-75    00002060 IBM  00000001)
[    0.000000] ACPI: MCFG 5f6e4e7e 0003C (v01 IBM    TP-75    00002060 IBM  00000001)
[    0.000000] ACPI: BOOT 5f6e4fd8 00028 (v01 IBM    TP-75    00002060  LTP 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 638MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000]   node 0 low ram: 00000000 - 377fe000
[    0.000000]   node 0 bootmap 00008000 - 0000ef00
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00016fdef4]    TEXT DATA BSS ==> [0001000000 - 00016fdef4]
[    0.000000]   #2 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #3 [00016fe000 - 0001705160]              BRK ==> [00016fe000 - 0001705160]
[    0.000000]   #4 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
[    0.000000]   #5 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0005f6d0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0005f6d0
[    0.000000] On node 0 totalpages: 390767
[    0.000000] free_area_init_node: node 0, pgdat c161844c, node_mem_map c1706000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 1278 pages used for memmap
[    0.000000]   HighMem zone: 162260 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
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
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 60000000 (gap: 60000000:80000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 387713
[    0.000000] Kernel command line: root=ubi0:rootfs rootfstype=ubifs rootdelay=10 block2mtd.block2mtd=/dev/sdb2,1048576 ubi.mtd=0 resume=/dev/sda6 vga=ext notsc usbcore.autosuspend=1 thinkpad_acpi.experimental=1 thinkpad_acpi.fan_control=1 i915.modeset=1 no_console_suspend ro
[    0.000000] notsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000377fe:0005f6d0)
[    0.000000] Memory: 1542024k/1563456k available (4410k kernel code, 20244k reserved, 1894k data, 316k init, 654152k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa4000 - 0xfffff000   ( 364 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc162a000 - 0xc1679000   ( 316 kB)
[    0.000000]       .data : 0xc144e913 - 0xc16283f4   (1894 kB)
[    0.000000]       .text : 0xc1000000 - 0xc144e913   (4410 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] NR_IRQS:288
[    0.000000] CPU 0 irqstacks, hard=c161e000 soft=c161f000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1496.394 MHz processor.
[    0.000000] Console: colour VGA+ 80x50
[    0.000000] console [tty0] enabled
[    0.010000] Calibrating delay loop... 2988.44 BogoMIPS (lpj=14942208)
[    0.270000] Mount-cache hash table entries: 512
[    0.270000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.270000] CPU: L2 cache: 2048K
[    0.270000] mce: CPU supports 5 MCE banks
[    0.270000] Disabling lock debugging due to kernel taint
[    0.270000] CPU0: Thermal monitoring enabled (TM1)
[    0.270000] CPU: Intel(R) Pentium(R) M processor 1.50GHz stepping 08
[    0.270000] Checking 'hlt' instruction... OK.
[    0.310000] ACPI: Core revision 20090521
[    0.340000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.440000] NET: Registered protocol family 16
[    0.440000] ACPI: bus type pci registered
[    0.440000] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.440000] PCI: MCFG area at e0000000 reserved in E820
[    0.440000] PCI: Using MMCONFIG for extended config space
[    0.440000] PCI: Using configuration type 1 for base access
[    0.440000] bio: create slab <bio-0> at 0
[    0.440000] ACPI: EC: EC description table is found, configuring boot EC
[    0.450000] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.590000] ACPI: Interpreter enabled
[    0.590000] ACPI: (supports S0 S3 S4 S5)
[    0.590000] ACPI: Using IOAPIC for interrupt routing
[    0.610000] ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
[    0.610000] ACPI: EC: driver started in interrupt mode
[    0.610000] ACPI: Power Resource [PUBS] (on)
[    0.610000] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.610000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.620000] pci 0000:00:02.0: reg 10 32bit mmio: [0xa0080000-0xa00fffff]
[    0.620000] pci 0000:00:02.0: reg 14 io port: [0x1800-0x1807]
[    0.620000] pci 0000:00:02.0: reg 18 32bit mmio: [0xc0000000-0xcfffffff]
[    0.620000] pci 0000:00:02.0: reg 1c 32bit mmio: [0xa0000000-0xa003ffff]
[    0.620000] pci 0000:00:02.1: reg 10 32bit mmio: [0x000000-0x07ffff]
[    0.620000] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.620000] pci 0000:00:1c.0: PME# disabled
[    0.620000] pci 0000:00:1d.0: reg 20 io port: [0x1820-0x183f]
[    0.620000] pci 0000:00:1d.1: reg 20 io port: [0x1840-0x185f]
[    0.620000] pci 0000:00:1d.2: reg 20 io port: [0x1860-0x187f]
[    0.620000] pci 0000:00:1d.3: reg 20 io port: [0x1880-0x189f]
[    0.620000] pci 0000:00:1d.7: reg 10 32bit mmio: [0xa0040000-0xa00403ff]
[    0.620000] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.620000] pci 0000:00:1d.7: PME# disabled
[    0.620000] pci 0000:00:1e.2: reg 10 io port: [0x1c00-0x1cff]
[    0.620000] pci 0000:00:1e.2: reg 14 io port: [0x18c0-0x18ff]
[    0.620000] pci 0000:00:1e.2: reg 18 32bit mmio: [0xa0040800-0xa00409ff]
[    0.620000] pci 0000:00:1e.2: reg 1c 32bit mmio: [0xa0040400-0xa00404ff]
[    0.620000] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    0.620000] pci 0000:00:1e.2: PME# disabled
[    0.620000] pci 0000:00:1e.3: reg 10 io port: [0x2400-0x24ff]
[    0.620000] pci 0000:00:1e.3: reg 14 io port: [0x2000-0x207f]
[    0.620000] pci 0000:00:1e.3: PME# supported from D0 D3hot D3cold
[    0.620000] pci 0000:00:1e.3: PME# disabled
[    0.620000] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.620000] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.620000] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.620000] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 1600-167f
[    0.620000] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 15c0-15cf
[    0.620000] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.620000] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.620000] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.620000] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.620000] pci 0000:00:1f.2: reg 20 io port: [0x1810-0x181f]
[    0.620000] pci 0000:00:1f.2: PME# supported from D3hot
[    0.620000] pci 0000:00:1f.2: PME# disabled
[    0.620000] pci 0000:00:1f.3: reg 20 io port: [0x18a0-0x18bf]
[    0.620000] pci 0000:02:00.0: reg 10 64bit mmio: [0xa0100000-0xa010ffff]
[    0.620000] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    0.620000] pci 0000:02:00.0: PME# disabled
[    0.620000] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.620000] pci 0000:00:1c.0: bridge 32bit mmio: [0xa0100000-0xa01fffff]
[    0.620000] pci 0000:04:00.0: reg 10 32bit mmio: [0xa0200000-0xa0200fff]
[    0.620000] pci 0000:04:00.0: supports D1 D2
[    0.620000] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.620000] pci 0000:04:00.0: PME# disabled
[    0.620000] pci 0000:04:00.1: reg 10 32bit mmio: [0xa0201000-0xa02010ff]
[    0.620000] pci 0000:04:00.1: supports D1 D2
[    0.620000] pci 0000:04:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.620000] pci 0000:04:00.1: PME# disabled
[    0.620000] pci 0000:04:02.0: reg 10 32bit mmio: [0xa0202000-0xa0202fff]
[    0.620000] pci 0000:04:02.0: PME# supported from D0 D3hot D3cold
[    0.620000] pci 0000:04:02.0: PME# disabled
[    0.620000] pci 0000:00:1e.0: transparent bridge
[    0.620000] pci 0000:00:1e.0: bridge io port: [0x3000-0x6fff]
[    0.620000] pci 0000:00:1e.0: bridge 32bit mmio: [0xa0200000-0xafffffff]
[    0.620000] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ffffff]
[    0.620000] pci_bus 0000:00: on NUMA node 0
[    0.620000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.620000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.620000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.620000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.620000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.620000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.620000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.630000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.630000] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.630000] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.630000] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.630000] SCSI subsystem initialized
[    0.630000] libata version 3.00 loaded.
[    0.630000] usbcore: registered new interface driver usbfs
[    0.630000] usbcore: registered new interface driver hub
[    0.630000] usbcore: registered new device driver usb
[    0.630000] PCI: Using ACPI for IRQ routing
[    0.630000] Bluetooth: Core ver 2.15
[    0.630000] NET: Registered protocol family 31
[    0.630000] Bluetooth: HCI device and connection manager initialized
[    0.630000] Bluetooth: HCI socket layer initialized
[    0.630000] cfg80211: Using static regulatory domain info
[    0.630000] cfg80211: Regulatory domain: US
[    0.630000] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.630000] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.630000] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.630000] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.630000] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.630000] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.630000] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.630000] cfg80211: Calling CRDA for country: US
[    0.630000] hpet clockevent registered
[    0.630000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.630000] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.630000] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.640000] pnp: PnP ACPI init
[    0.640000] ACPI: bus type pnp registered
[    0.640000] pnp: PnP ACPI: found 12 devices
[    0.640000] ACPI: ACPI bus type pnp unregistered
[    0.640000] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.640000] system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
[    0.640000] system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
[    0.640000] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.640000] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.640000] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.640000] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.640000] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.640000] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.640000] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.640000] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.640000] system 00:00: iomem range 0x100000-0x5fffffff could not be reserved
[    0.640000] system 00:00: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.650002] Switched to high resolution mode on CPU 0
[    0.650002] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.650002] system 00:02: ioport range 0x1180-0x11bf has been reserved
[    0.650002] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.650002] system 00:02: ioport range 0x1600-0x162f has been reserved
[    0.650002] system 00:02: ioport range 0x1632-0x167f has been reserved
[    0.650002] system 00:02: ioport range 0x15c0-0x15df has been reserved
[    0.650002] system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
[    0.650002] system 00:02: iomem range 0xf0008000-0xf000bfff has been reserved
[    0.650002] system 00:02: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.650002] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.650002] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.680005] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.680005] pci 0000:00:1c.0:   IO window: disabled
[    0.680005] pci 0000:00:1c.0:   MEM window: 0xa0100000-0xa01fffff
[    0.680005] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.680005] pci 0000:04:00.0: CardBus bridge, secondary bus 0000:05
[    0.680005] pci 0000:04:00.0:   IO window: 0x003000-0x0030ff
[    0.680005] pci 0000:04:00.0:   IO window: 0x003400-0x0034ff
[    0.680005] pci 0000:04:00.0:   PREFETCH window: 0xd0000000-0xd3ffffff
[    0.680005] pci 0000:04:00.0:   MEM window: 0xa4000000-0xa7ffffff
[    0.680005] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
[    0.680005] pci 0000:00:1e.0:   IO window: 0x3000-0x6fff
[    0.680005] pci 0000:00:1e.0:   MEM window: 0xa0200000-0xafffffff
[    0.680005] pci 0000:00:1e.0:   PREFETCH window: 0x000000d0000000-0x000000d7ffffff
[    0.680005] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.680005] pci 0000:00:1c.0: setting latency timer to 64
[    0.680005] pci 0000:00:1e.0: setting latency timer to 64
[    0.680005] pci 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.680005] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.680005] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.680005] pci_bus 0000:02: resource 1 mem: [0xa0100000-0xa01fffff]
[    0.680005] pci_bus 0000:04: resource 0 io:  [0x3000-0x6fff]
[    0.680005] pci_bus 0000:04: resource 1 mem: [0xa0200000-0xafffffff]
[    0.680005] pci_bus 0000:04: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    0.680005] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.680005] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffff]
[    0.680005] pci_bus 0000:05: resource 0 io:  [0x3000-0x30ff]
[    0.680005] pci_bus 0000:05: resource 1 io:  [0x3400-0x34ff]
[    0.680005] pci_bus 0000:05: resource 2 pref mem [0xd0000000-0xd3ffffff]
[    0.680005] pci_bus 0000:05: resource 3 mem: [0xa4000000-0xa7ffffff]
[    0.680005] NET: Registered protocol family 2
[    0.680005] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.680005] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.680005] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.680005] TCP: Hash tables configured (established 131072 bind 65536)
[    0.680005] TCP reno registered
[    0.680005] NET: Registered protocol family 1
[    0.680005] Simple Boot Flag at 0x35 set to 0x1
[    0.690015] highmem bounce pool size: 64 pages
[    0.690015] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.690015] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.690015] NTFS driver 2.1.29 [Flags: R/W].
[    0.690015] JFFS2 version 2.2. (NAND) (SUMMARY)  © 2001-2006 Red Hat, Inc.
[    0.690015] fuse init (API version 7.12)
[    0.690015] msgmni has been set to 1735
[    0.690015] alg: No test for stdrng (krng)
[    0.690015] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.690015] io scheduler noop registered
[    0.690015] io scheduler anticipatory registered
[    0.690015] io scheduler deadline registered
[    0.690015] io scheduler cfq registered (default)
[    0.690015] pci 0000:00:02.0: Boot video device
[    0.690015] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.690015] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.690015] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.690015] ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
[    0.690015] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.700012] acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[    0.700012] Platform driver 'platform-lcd' needs updating - please use dev_pm_ops
[    0.701184] ACPI: AC Adapter [AC] (on-line)
[    0.701184] input: Power Button as /class/input/input0
[    0.701184] ACPI: Power Button [PWRF]
[    0.701184] input: Lid Switch as /class/input/input1
[    0.702184] ACPI: Lid Switch [LID]
[    0.702184] input: Sleep Button as /class/input/input2
[    0.702184] ACPI: Sleep Button [SLPB]
[    0.702184] input: Video Bus as /class/input/input3
[    0.702184] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.706802] Marking TSC unstable due to TSC halts in idle
[    0.706802] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.706802] processor LNXCPU:00: registered as cooling_device0
[    0.706802] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.709707] thermal LNXTHERM:01: registered as thermal_zone0
[    0.709707] ACPI: Thermal Zone [THM0] (34 C)
[    0.710012] Non-volatile memory driver v1.3
[    0.710012] Linux agpgart interface v0.103
[    0.710012] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    0.710012] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.710012] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    0.710012] [drm] Initialized drm 1.1.0 20060810
[    0.710012] i915 0000:00:02.0: power state changed by ACPI to D0
[    0.710012] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.710012] i915 0000:00:02.0: setting latency timer to 64
[    0.750005] i2c-adapter i2c-1: unable to read EDID block.
[    0.750005] i915 0000:00:02.0: LVDS-1: no EDID data
[    1.050004] [drm] DAC-6: set mode 640x480 0
[    1.150005] i2c-adapter i2c-1: unable to read EDID block.
[    1.150005] i915 0000:00:02.0: LVDS-1: no EDID data
[    1.200004] [drm] TV-12: set mode NTSC 480i 0
[    1.320004] allocated 1024x768 fb: 0x007df000, bo f710fbc0
[    1.380004] [drm] LVDS-8: set mode 1024x768 16
[    1.410004] Console: switching to colour frame buffer device 170x69
[    1.420006] fb0: inteldrmfb frame buffer device
[    1.420006] registered panic notifier
[    1.420006] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.420006] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.420006] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a NS16550A
[    1.420006] Platform driver 'serial8250' needs updating - please use dev_pm_ops
[    1.420006] 00:0a: ttyS0 at I/O 0x200 (irq = 5) is a NS16550A
[    1.420006] serial 0000:00:1e.3: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[    1.420006] serial 0000:00:1e.3: PCI INT B disabled
[    1.420006] loop: module loaded
[    1.420006] ata_piix 0000:00:1f.2: version 2.13
[    1.420006] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.455313] ACPI: Battery Slot [BAT0] (battery present)
[    1.580009] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.580009] scsi0 : ata_piix
[    1.580009] scsi1 : ata_piix
[    1.580009] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
[    1.580009] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
[    1.580009] tg3.c:v3.99 (April 20, 2009)
[    1.580009] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.580009] tg3 0000:02:00.0: setting latency timer to 64
[    1.600006] tg3 0000:02:00.0: PME# disabled
[    1.640004] eth0: Tigon3 [partno(BCM95751M) rev 4101] (PCI Express) MAC address 00:16:d3:2f:fc:d1
[    1.640004] eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    1.640004] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    1.650949] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    1.650949] PPP generic driver version 2.4.2
[    1.650949] NET: Registered protocol family 24
[    1.650949] tun: Universal TUN/TAP device driver, 1.6
[    1.650949] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.650949] usbcore: registered new interface driver asix
[    1.650949] usbcore: registered new interface driver cdc_ether
[    1.660316] usbcore: registered new interface driver cdc_eem
[    1.660316] usbcore: registered new interface driver net1080
[    1.660316] usbcore: registered new interface driver rndis_host
[    1.660316] usbcore: registered new interface driver cdc_subset
[    1.660316] usbcore: registered new interface driver zaurus
[    1.660316] block2mtd: error: cannot open device /dev/sdb2
[    1.660316] block2mtd: spawned kernel thread for async waiting on '/dev/sdb2'
[    1.670591] yenta_cardbus 0000:04:00.0: CardBus bridge found [1014:0555]
[    1.670591] ubi_init_attach_mtd(0): waiting async for device to appear
[    1.760416] ata1.00: ATA-6: HTC426040G9AT00, 00P4A0B5, max UDMA/100
[    1.760416] ata1.00: 78140160 sectors, multi 16: LBA 
[    1.760416] ata1.00: applying bridge limits
[    1.800416] ata1.00: configured for UDMA/100
[    1.800416] scsi 0:0:0:0: Direct-Access     ATA      HTC426040G9AT00  00P4 PQ: 0 ANSI: 5
[    1.800416] sd 0:0:0:0: [sda] 78140160 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    1.800416] sd 0:0:0:0: [sda] Write Protect is off
[    1.800416] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.800416] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.800416]  sda:
[    1.810014] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.924200]  sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.972109] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.100009] yenta_cardbus 0000:04:00.0: ISA IRQ mask 0x0cb8, PCI irq 16
[    2.100009] yenta_cardbus 0000:04:00.0: Socket status: 30000006
[    2.100009] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge I/O window: 0x3000 - 0x6fff
[    2.100009] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge Memory window: 0xa0200000 - 0xafffffff
[    2.100009] yenta_cardbus 0000:04:00.0: pcmcia: parent PCI bridge Memory window: 0xd0000000 - 0xd7ffffff
[    2.370007] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.372736] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    2.372736] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.372736] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.372736] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.372736] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    2.382256] ehci_hcd 0000:00:1d.7: debug port 1
[    2.382256] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    2.382256] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xa0040000
[    2.410006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.410006] usb usb1: configuration #1 chosen from 1 choice
[    2.410006] hub 1-0:1.0: USB hub found
[    2.410006] hub 1-0:1.0: 8 ports detected
[    2.420254] uhci_hcd: USB Universal Host Controller Interface driver
[    2.423212] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    2.423212] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.423212] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.423212] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    2.430985] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.430985] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[    2.430985] usb usb2: configuration #1 chosen from 1 choice
[    2.430985] hub 2-0:1.0: USB hub found
[    2.441321] hub 2-0:1.0: 2 ports detected
[    2.444183] uhci_hcd 0000:00:1d.1: power state changed by ACPI to D0
[    2.444183] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.444183] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    2.444183] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    2.451775] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    2.451775] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001840
[    2.451775] usb usb3: configuration #1 chosen from 1 choice
[    2.451775] hub 3-0:1.0: USB hub found
[    2.462022] hub 3-0:1.0: 2 ports detected
[    2.462022] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.462022] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    2.462022] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.462022] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    2.472192] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[    2.472192] usb usb4: configuration #1 chosen from 1 choice
[    2.472192] hub 4-0:1.0: USB hub found
[    2.472192] hub 4-0:1.0: 2 ports detected
[    2.482298] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.482298] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    2.482298] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    2.482298] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    2.482298] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001880
[    2.492236] usb usb5: configuration #1 chosen from 1 choice
[    2.492236] hub 5-0:1.0: USB hub found
[    2.492236] hub 5-0:1.0: 2 ports detected
[    2.492236] usbcore: registered new interface driver cdc_acm
[    2.502409] cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
[    2.502409] usbcore: registered new interface driver usblp
[    2.502409] Initializing USB Mass Storage driver...
[    2.510265] usbcore: registered new interface driver usb-storage
[    2.510265] USB Mass Storage support registered.
[    2.510265] usbcore: registered new interface driver libusual
[    2.510265] usbcore: registered new interface driver usbserial
[    2.521092] USB Serial support registered for generic
[    2.521092] usbcore: registered new interface driver usbserial_generic
[    2.521092] usbserial: USB Serial Driver core
[    2.521092] USB Serial support registered for hp4X
[    2.531702] usbcore: registered new interface driver hp4X
[    2.531702] hp4x: v1.00:HP4x (48/49) Generic Serial driver
[    2.531702] USB Serial support registered for pl2303
[    2.531702] usbcore: registered new interface driver pl2303
[    2.542294] pl2303: Prolific PL2303 USB to serial adaptor driver
[    2.542294] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    2.542294] Platform driver 'i8042' needs updating - please use dev_pm_ops
[    2.560313] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.560313] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.560313] mice: PS/2 mouse device common for all mice
[    2.560313] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    2.571083] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[    2.571083] cpuidle: using governor ladder
[    2.571083] cpuidle: using governor menu
[    2.580006] wacom driver registered
[    2.580006] usbcore: registered new interface driver usbhid
[    2.580006] usbhid: v2.6:USB HID core driver
[    2.580006] Platform driver 'thinkpad_acpi' needs updating - please use dev_pm_ops
[    2.590977] thinkpad_acpi: ThinkPad ACPI Extras v0.23
[    2.590977] thinkpad_acpi: http://ibm-acpi.sf.net/
[    2.590977] thinkpad_acpi: ThinkPad BIOS 75ET60WW (2.06 ), EC 75HT20WW-1.02
[    2.590977] thinkpad_acpi: IBM ThinkPad X41 Tablet, model 1866CTO
[    2.601682] input: AT Translated Set 2 keyboard as /class/input/input4
[    2.601682] thinkpad_acpi: possible tablet mode switch found; ThinkPad in laptop mode
[    2.618155] Registered led device: tpacpi::thinklight
[    2.620886] thinkpad_acpi: acpi_bus_get_device(bay) failed: -19
[    2.620886] thinkpad_acpi: disabling subdriver bay
[    2.620886] Registered led device: tpacpi::power
[    2.620886] Registered led device: tpacpi::standby
[    2.635381] input: ThinkPad Extra Buttons as /class/input/input5
[    2.635381] Advanced Linux Sound Architecture Driver Version 1.0.20.
[    2.641049] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.641049] Intel ICH 0000:00:1e.2: setting latency timer to 64
[    2.680053] block2mtd: error: cannot open device /dev/sdb2
[    2.740052] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    2.891615] usb 1-5: configuration #1 chosen from 1 choice
[    2.894743] hub 1-5:1.0: USB hub found
[    2.897865] hub 1-5:1.0: 4 ports detected
[    3.081125] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[    3.099078] input: TPPS/2 IBM TrackPoint as /class/input/input6
[    3.190251] usb 1-5.1: new high speed USB device using ehci_hcd and address 3
[    3.301004] usb 1-5.1: configuration #1 chosen from 1 choice
[    3.304004] scsi2 : SCSI emulation for USB Mass Storage devices
[    3.304004] usb-storage: device found at 3
[    3.304004] usb-storage: waiting for device to settle before scanning
[    3.590018] intel8x0_measure_ac97_clock: measured 59933 usecs (11 samples)
[    3.590018] intel8x0: measured clock 183 rejected
[    3.690018] block2mtd: error: cannot open device /dev/sdb2
[    3.960018] intel8x0_measure_ac97_clock: measured 59959 usecs (2888 samples)
[    3.960018] intel8x0: clocking to 48000
[    3.960018] ALSA device list:
[    3.960018]   #0: Intel ICH6 with AD1981B at irq 22
[    3.971615] netem: version 1.2
[    3.971615] u32 classifier
[    3.971615] Netfilter messages via NETLINK v0.30.
[    3.971615] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    3.982722] IPv4 over IPv4 tunneling driver
[    3.982722] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.982722] TCP bic registered
[    3.991408] TCP cubic registered
[    3.991408] TCP westwood registered
[    3.991408] TCP highspeed registered
[    3.991408] TCP hybla registered
[    4.002213] TCP vegas registered
[    4.002213] TCP veno registered
[    4.002213] TCP illinois registered
[    4.010005] NET: Registered protocol family 10
[    4.010005] IPv6 over IPv4 tunneling driver
[    4.010005] NET: Registered protocol family 17
[    4.010005] Bridge firewalling registered
[    4.020790] Bluetooth: L2CAP ver 2.13
[    4.020790] Bluetooth: L2CAP socket layer initialized
[    4.020790] Bluetooth: SCO (Voice Link) ver 0.6
[    4.020790] Bluetooth: SCO socket layer initialized
[    4.030915] Bluetooth: RFCOMM socket layer initialized
[    4.030915] Bluetooth: RFCOMM TTY layer initialized
[    4.030915] Bluetooth: RFCOMM ver 1.11
[    4.030915] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    4.040820] Bluetooth: BNEP filters: protocol multicast
[    4.040820] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.040820] RPC: Registered udp transport module.
[    4.040820] RPC: Registered tcp transport module.
[    4.050732] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    4.050732] All bugs added by David S. Miller <davem@redhat.com>
[    4.050732] lib80211: common routines for IEEE802.11 drivers
[    4.050732] lib80211_crypt: registered algorithm 'NULL'
[    4.050732] P-state transition latency capped at 20 uS
[    4.060523] Using IPI Shortcut mode
[    4.063644] Waiting 10sec before mounting root device...
[    4.700022] block2mtd: error: cannot open device /dev/sdb2
[    5.710024] block2mtd: error: cannot open device /dev/sdb2
[    6.720024] block2mtd: error: cannot open device /dev/sdb2
[    7.730023] block2mtd: error: cannot open device /dev/sdb2
[    8.300169] usb-storage: device scan complete
[    8.300669] scsi 2:0:0:0: Direct-Access     SanDisk  U3 Cruzer Micro  8.02 PQ: 0 ANSI: 0 CCS
[    8.300669] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    8.312918] sd 2:0:0:0: [sdb] 31825919 512-byte logical blocks: (16.2 GB/15.1 GiB)
[    8.320663] sd 2:0:0:0: [sdb] Write Protect is off
[    8.320663] sd 2:0:0:0: [sdb] Mode Sense: 45 00 00 08
[    8.320663] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    8.334789] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    8.340030]  sdb: sdb1 sdb2 sdb3
[    8.349915] sd 2:0:0:0: [sdb] Assuming drive cache: write through
[    8.355266] sd 2:0:0:0: [sdb] Attached SCSI removable disk
[    8.740558] block2mtd: mtd0: [/dev/sdb2] erase_size = 1024KiB [1048576]
[    8.820022] UBI: attaching mtd0 to ubi0
[    8.820022] UBI: physical eraseblock size:   1048576 bytes (1024 KiB)
[    8.830555] UBI: logical eraseblock size:    1048448 bytes
[    8.830555] UBI: smallest flash I/O unit:    1
[    8.840938] UBI: VID header offset:          64 (aligned 64)
[    8.840938] UBI: data offset:                128
[   10.804125] UBI: attached mtd0 to ubi0
[   10.813762] UBI: MTD device name:            "block2mtd: /dev/sdb2"
[   10.813762] UBI: MTD device size:            3074 MiB
[   10.824018] UBI: number of good PEBs:        3074
[   10.824018] UBI: number of bad PEBs:         0
[   10.834011] UBI: max. allowed volumes:       128
[   10.834011] UBI: wear-leveling threshold:    4096
[   10.843760] UBI: number of internal volumes: 1
[   10.843760] UBI: number of user volumes:     1
[   10.853364] UBI: available PEBs:             0
[   10.853364] UBI: total number of reserved PEBs: 3074
[   10.862810] UBI: number of PEBs reserved for bad PEB handling: 0
[   10.862810] UBI: max/mean erase counter: 7/0
[   10.872322] UBI: background thread "ubi_bgt0d" started, PID 743
[   14.393116] UBIFS: recovery needed
[   14.680008] UBIFS: recovery deferred
[   14.680008] UBIFS: mounted UBI device 0, volume 0, name "rootfs"
[   14.691455] UBIFS: mounted read-only
[   14.691455] UBIFS: file system size:   3209299328 bytes (3134081 KiB, 3060 MiB, 3061 LEBs)
[   14.701063] UBIFS: journal size:       33550336 bytes (32764 KiB, 31 MiB, 32 LEBs)
[   14.701063] UBIFS: media format:       w4/r0 (latest is w4/r0)
[   14.710947] UBIFS: default compressor: lzo
[   14.710947] UBIFS: reserved for root:  4952683 bytes (4836 KiB)
[   14.723502] VFS: Mounted root (ubifs filesystem) readonly on device 0:12.
[   14.723502] Freeing unused kernel memory: 316k freed
[   14.733982] Write protecting the kernel text: 4412k
[   14.733982] Write protecting the kernel read-only data: 1560k
[   15.970014] udev: renamed network interface eth0 to lan0
[   16.470007] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   16.482546] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   16.510009] sdhci: Secure Digital Host Controller Interface driver
[   16.510009] sdhci: Copyright(c) Pierre Ossman
[   16.540008] sdhci-pci 0000:04:00.1: SDHCI controller found [1180:0822] (rev 13)
[   16.550623] sdhci-pci 0000:04:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.550623] mmc0: Controller vendor_ver=02 sdhci_ver=00.
[   16.564216] mmc0: Controller caps=018021a1.
[   16.570129] SDHCI_INT_ENABLE: Can toggle bits e1ff01ff
[   16.570129] SDHCI_HOST_CONTROL: Can toggle bits 06
[   16.581924] DMA forced on (host quirk)
[   16.581924] sdhci-pci 0000:04:00.1: Will use DMA mode even though HW doesn't fully claim to support it.
[   16.593925] HISPD forced on (host quirk)
[   16.593925] Verified that HOST_CONTROL bit SDHCI_CTRL_HISPD can be toggled
[   16.606903] Could not set SDHCI_CTRL_LED to 1!
[   16.611700] mmc0: SDHCI controller on PCI [0000:04:00.1] using DMA
[   16.700006] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
[   16.712745] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   16.712745] ipw2200 0000:04:02.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   16.726161] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
[   16.730284] ipw2200 0000:04:02.0: firmware: requesting ipw2200-bss.fw
[   16.905411] ipw2200: Detected geography ZZA (11 802.11bg channels, 13 802.11a channels)
[   16.910009] udev: renamed network interface eth0 to wlan0
[   16.910009] mmc0: new high speed SDHC card at address b368
[   16.950011] mmcblk0: mmc0:b368 SDC   14.9 GiB (ro)
[   16.950011]  mmcblk0: p1
[   18.510010] Adding 1052216k swap on /dev/sda6.  Priority:10 extents:1 across:1052216k 
[   18.641876] UBIFS: completing deferred recovery
[   18.641876] UBIFS: deferred recovery completed
[   20.724007] EXT4-fs (sda3): barriers enabled
[   20.735324] kjournald2 starting: pid 1663, dev sda3:8, commit interval 5 seconds
[   20.742505] EXT4-fs (sda3): delayed allocation enabled
[   20.742505] EXT4-fs: mballoc enabled
[   20.756748] EXT4-fs (sda3): mounted filesystem with ordered data mode
[   20.775165] EXT4-fs (sda7): barriers enabled
[   20.812025] kjournald2 starting: pid 1664, dev sda7:8, commit interval 5 seconds
[   20.812025] EXT4-fs (sda7): internal journal on sda7:8
[   20.816498] EXT4-fs (sda7): delayed allocation enabled
[   20.823512] EXT4-fs: file extents enabled
[   20.830405] EXT4-fs: mballoc enabled
[   20.830405] EXT4-fs (sda7): mounted filesystem with ordered data mode
[   21.570010] tg3 0000:02:00.0: PME# disabled
[   21.760005] ADDRCONF(NETDEV_UP): lan0: link is not ready
[   23.512909] lib80211_crypt: registered algorithm 'CCMP'
[   23.880004] [drm] DAC-6: set mode 640x480 0
[   23.980004] [drm] DAC-6: set mode 640x480 0
[   24.060005] i2c-adapter i2c-1: unable to read EDID block.
[   24.060005] i915 0000:00:02.0: LVDS-1: no EDID data
[   24.110004] [drm] TV-12: set mode NTSC 480i 0
[   24.250004] [drm] TV-12: set mode NTSC 480i 0
[   24.390004] [drm] DAC-6: set mode 640x480 0
[   24.500005] [drm] DAC-6: set mode 640x480 0
[   24.580004] i2c-adapter i2c-1: unable to read EDID block.
[   24.580004] i915 0000:00:02.0: LVDS-1: no EDID data
[   24.630005] [drm] TV-12: set mode NTSC 480i 0
[   24.770004] [drm] TV-12: set mode NTSC 480i 0
[   33.180025] wlan0: no IPv6 routers present
[   37.350006] [drm] DAC-6: set mode 640x480 0
[   37.470004] [drm] DAC-6: set mode 640x480 0
[   37.550005] i2c-adapter i2c-1: unable to read EDID block.
[   37.550005] i915 0000:00:02.0: LVDS-1: no EDID data
[   37.590004] [drm] TV-12: set mode NTSC 480i 0
[   37.740004] [drm] TV-12: set mode NTSC 480i 0
[  300.270026] Machine check events logged
[10459.243467] ipw2200: Firmware error detected.  Restarting.
[14907.040026] usb 1-3: new high speed USB device using ehci_hcd and address 4
[14907.192042] usb 1-3: configuration #1 chosen from 1 choice
[14907.202042] scsi3 : SCSI emulation for USB Mass Storage devices
[14907.202042] usb-storage: device found at 4
[14907.202042] usb-storage: waiting for device to settle before scanning
[14912.209657] usb-storage: device scan complete
[14912.209657] scsi 3:0:0:0: Direct-Access     Generic  CF Reader        1.01 PQ: 0 ANSI: 0
[14912.209657] scsi 3:0:0:1: Direct-Access     Generic  SM/SD/MS Reader  1.00 PQ: 0 ANSI: 0
[14912.209657] sd 3:0:0:0: Attached scsi generic sg2 type 0
[14912.209657] sd 3:0:0:1: Attached scsi generic sg3 type 0
[14913.188987] sd 3:0:0:0: [sdc] 31326208 512-byte logical blocks: (16.0 GB/14.9 GiB)
[14913.198987] sd 3:0:0:1: [sdd] Attached SCSI removable disk
[14913.198987] sd 3:0:0:0: [sdc] Write Protect is off
[14913.198987] sd 3:0:0:0: [sdc] Mode Sense: 03 00 00 00
[14913.198987] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[14913.198987] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[14913.198987]  sdc: sdc1 sdc2
[14913.200014] sd 3:0:0:0: [sdc] Assuming drive cache: write through
[14913.200014] sd 3:0:0:0: [sdc] Attached SCSI removable disk
[14951.915194] block2mtd: mtd1: [/dev/sdc2] erase_size = 512KiB [524288]
[14961.803738] UBI: attaching mtd1 to ubi1
[14961.803738] UBI: physical eraseblock size:   524288 bytes (512 KiB)
[14961.803738] UBI: logical eraseblock size:    524160 bytes
[14961.803738] UBI: smallest flash I/O unit:    1
[14961.803738] UBI: VID header offset:          64 (aligned 64)
[14961.803738] UBI: data offset:                128
[14966.530015] UBI: attached mtd1 to ubi1
[14966.530015] UBI: MTD device name:            "block2mtd: /dev/sdc2"
[14966.530015] UBI: MTD device size:            3074 MiB
[14966.530015] UBI: number of good PEBs:        6148
[14966.530015] UBI: number of bad PEBs:         0
[14966.530015] UBI: max. allowed volumes:       128
[14966.530015] UBI: wear-leveling threshold:    4096
[14966.530015] UBI: number of internal volumes: 1
[14966.530015] UBI: number of user volumes:     1
[14966.530015] UBI: available PEBs:             202
[14966.530015] UBI: total number of reserved PEBs: 5946
[14966.530015] UBI: number of PEBs reserved for bad PEB handling: 0
[14966.530015] UBI: max/mean erase counter: 2/0
[14966.530015] UBI: background thread "ubi_bgt1d" started, PID 2855
[14973.971753] ------------[ cut here ]------------
[14973.971753] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0x9f/0xb4()
[14973.971753] Hardware name: 1866CTO
[14973.971753] sysfs: cannot create duplicate filename '/class/bdi/ubifs'
[14973.971753] Modules linked in: lib80211_crypt_ccmp mmc_block ipw2200 sdhci_pci sdhci libipw
[14973.971753] Pid: 2857, comm: mount Tainted: G   M       2.6.31-rc2 #13
[14973.971753] Call Trace:
[14973.971753]  [<c1020550>] warn_slowpath_common+0x60/0x90
[14973.971753]  [<c10205b4>] warn_slowpath_fmt+0x24/0x27
[14973.971753]  [<c10ab6c5>] sysfs_add_one+0x9f/0xb4
[14973.971753]  [<c10abafe>] create_dir+0x43/0x71
[14973.971753]  [<c10abb59>] sysfs_create_dir+0x2d/0x41
[14973.971753]  [<c11cc4e5>] ? kobject_get+0x12/0x17
[14973.971753]  [<c11cc5ce>] kobject_add_internal+0xa1/0x163
[14973.971753]  [<c11d07f1>] ? vsnprintf+0x7e/0x31c
[14973.971753]  [<c11cc749>] kobject_add_varg+0x35/0x41
[14973.971753]  [<c11cc7ba>] kobject_add+0x43/0x49
[14973.971753]  [<c127a82c>] device_add+0x107/0x521
[14973.971753]  [<c11cc354>] ? kobject_init+0x36/0x6e
[14973.971753]  [<c127ac58>] device_register+0x12/0x15
[14973.971753]  [<c127ad10>] device_create_vargs+0xb5/0xd7
[14973.971753]  [<c106555b>] bdi_register+0x26/0x6b
[14973.971753]  [<c117dbf0>] ubifs_get_sb+0x412/0x10da
[14973.971753]  [<c11cba9e>] ? idr_get_empty_slot+0x14f/0x238
[14973.971753]  [<c11cbce4>] ? ida_get_new_above+0x15d/0x177
[14973.971753]  [<c1077562>] vfs_kern_mount+0x3c/0x77
[14973.971753]  [<c10775e1>] do_kern_mount+0x32/0xb9
[14973.971753]  [<c10881e3>] do_mount+0x588/0x5da
[14973.971753]  [<c105beb0>] ? __get_free_pages+0x1f/0x21
[14973.971753]  [<c1086b63>] ? copy_mount_options+0x2a/0xf9
[14973.971753]  [<c1088296>] sys_mount+0x61/0x9b
[14973.971753]  [<c10028b5>] syscall_call+0x7/0xb
[14973.971753] ---[ end trace 0bb72133202234c0 ]---
[14973.971753] kobject_add_internal failed for ubifs with -EEXIST, don't try to register things with the same name in the same directory.
[14973.971753] Pid: 2857, comm: mount Tainted: G   M    W  2.6.31-rc2 #13
[14973.971753] Call Trace:
[14973.971753]  [<c11cc67e>] kobject_add_internal+0x151/0x163
[14973.971753]  [<c11d07f1>] ? vsnprintf+0x7e/0x31c
[14973.971753]  [<c11cc749>] kobject_add_varg+0x35/0x41
[14973.971753]  [<c11cc7ba>] kobject_add+0x43/0x49
[14973.971753]  [<c127a82c>] device_add+0x107/0x521
[14973.971753]  [<c11cc354>] ? kobject_init+0x36/0x6e
[14973.971753]  [<c127ac58>] device_register+0x12/0x15
[14973.971753]  [<c127ad10>] device_create_vargs+0xb5/0xd7
[14973.971753]  [<c106555b>] bdi_register+0x26/0x6b
[14973.971753]  [<c117dbf0>] ubifs_get_sb+0x412/0x10da
[14973.971753]  [<c11cba9e>] ? idr_get_empty_slot+0x14f/0x238
[14973.971753]  [<c11cbce4>] ? ida_get_new_above+0x15d/0x177
[14973.971753]  [<c1077562>] vfs_kern_mount+0x3c/0x77
[14973.971753]  [<c10775e1>] do_kern_mount+0x32/0xb9
[14973.971753]  [<c10881e3>] do_mount+0x588/0x5da
[14973.971753]  [<c105beb0>] ? __get_free_pages+0x1f/0x21
[14973.971753]  [<c1086b63>] ? copy_mount_options+0x2a/0xf9
[14973.971753]  [<c1088296>] sys_mount+0x61/0x9b
[14973.971753]  [<c10028b5>] syscall_call+0x7/0xb

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31-rc2
# Fri Jul 10 19:54:17 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_DYNAMIC_PER_CPU_AREA=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
CONFIG_KERNEL_LZMA=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set

#
# RCU Subsystem
#
CONFIG_CLASSIC_RCU=y
# CONFIG_TREE_RCU is not set
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_PREEMPT_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
# CONFIG_GROUP_SCHED is not set
# CONFIG_CGROUPS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_NET_NS is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_COMPAT_BRK is not set
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_MARKERS=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
# CONFIG_SPARSE_IRQ is not set
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
CONFIG_MPENTIUMM=y
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_GENERIC_CPU is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_OLD_MCE is not set
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_X86_CPU_DEBUG is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
# CONFIG_X86_RESERVE_LOW_64K is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION_NVS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=y
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
# CONFIG_HOTPLUG_PCI_PCIE is not set
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
# CONFIG_HOTPLUG_PCI_COMPAQ is not set
CONFIG_HOTPLUG_PCI_IBM=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
# CONFIG_BINFMT_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=y
# CONFIG_TCP_CONG_HTCP is not set
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
# CONFIG_NF_CT_ACCT is not set
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_DCCP is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
# CONFIG_NETFILTER_XT_TARGET_HL is not set
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_MARK=y
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
# CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP is not set
# CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_HL is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=y
CONFIG_IP_NF_MATCH_ECN=y
# CONFIG_IP_NF_MATCH_TTL is not set
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
# CONFIG_IP_NF_TARGET_ULOG is not set
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
# CONFIG_NF_NAT_SNMP_BASIC is not set
# CONFIG_NF_NAT_FTP is not set
# CONFIG_NF_NAT_IRC is not set
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
# CONFIG_NF_NAT_SIP is not set
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=y
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
CONFIG_IP6_NF_QUEUE=y
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
# CONFIG_NET_SCH_HFSC is not set
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFQ=y
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
# CONFIG_NET_SCH_DRR is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_ROUTE=y
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
# CONFIG_NET_CLS_RSVP is not set
# CONFIG_NET_CLS_RSVP6 is not set
# CONFIG_NET_CLS_FLOW is not set
# CONFIG_NET_EMATCH is not set
# CONFIG_NET_CLS_ACT is not set
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=y
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTSDIO is not set
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIBCM203X is not set
# CONFIG_BT_HCIBPA10X is not set
# CONFIG_BT_HCIBFUSB is not set
# CONFIG_BT_HCIDTL1 is not set
# CONFIG_BT_HCIBT3C is not set
# CONFIG_BT_HCIBLUECARD is not set
# CONFIG_BT_HCIBTUART is not set
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_CFG80211=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_WIRELESS_OLD_REGULATORY=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
CONFIG_MAC80211_DEFAULT_PS=y
CONFIG_MAC80211_DEFAULT_PS_VALUE=1

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_MTD=y
# CONFIG_MTD_DEBUG is not set
# CONFIG_MTD_CONCAT is not set
# CONFIG_MTD_PARTITIONS is not set
# CONFIG_MTD_TESTS is not set

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=y
CONFIG_MTD_BLKDEVS=y
CONFIG_MTD_BLOCK=y
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_MTD_OOPS is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_TS5500 is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
CONFIG_MTD_BLOCK2MTD=y

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
# CONFIG_MTD_NAND is not set
# CONFIG_MTD_ONENAND is not set

#
# LPDDR flash memory drivers
#
# CONFIG_MTD_LPDDR is not set

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=y
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
# CONFIG_SATA_PMP is not set
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PCMCIA=y
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
# CONFIG_PATA_SCH is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set
# CONFIG_DM_DELAY is not set
# CONFIG_DM_UEVENT is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_BROADCOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=m
# CONFIG_PCI_ATMEL is not set
CONFIG_PCMCIA_ATMEL=m
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH9K is not set
# CONFIG_AR9170_USB is not set
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
# CONFIG_IWLWIFI is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
CONFIG_HOSTAP_CS=m
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set
# CONFIG_HERMES is not set
# CONFIG_IWM is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
CONFIG_USB_NET_NET1080=y
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
# CONFIG_USB_KC2190 is not set
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_NET_PCMCIA is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
CONFIG_PPPOE=y
# CONFIG_PPPOL2TP is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_LM8323 is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_HELPER_AUTO is not set

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Graphics adapter I2C/DDC channel drivers
#
# CONFIG_I2C_VOODOO3 is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_SCx200_ACB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATK0110 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_SENSORS_APPLESMC is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_AB3100_CORE is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_I810 is not set
# CONFIG_DRM_I830 is not set
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
# CONFIG_FONT_8x8 is not set
# CONFIG_FONT_8x16 is not set
CONFIG_FONT_6x11=y
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_SEQUENCER=y
# CONFIG_SND_SEQ_DUMMY is not set
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
# CONFIG_SND_DYNAMIC_MINORS is not set
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
# CONFIG_SND_RAWMIDI_SEQ is not set
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
# CONFIG_SND_PCSP is not set
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=1
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_CTXFI is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_INDIGOIOX is not set
# CONFIG_SND_INDIGODJX is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
# CONFIG_SND_HDA_INTEL is not set
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set
# CONFIG_SND_USB is not set
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EZKEY=y
CONFIG_HID_KYE=y
CONFIG_HID_GYRATION=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LOGITECH=y
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_NTRIG=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
CONFIG_USB_SERIAL_PL2303=y
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=y
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_VST is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_UNSAFE_RESUME=y

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
# CONFIG_MMC_SDHCI_PLTFM is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SDRICOH_CS is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_BD2802 is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_PANASONIC_LAPTOP is not set
# CONFIG_COMPAL_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
CONFIG_THINKPAD_ACPI_DEBUG=y
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_BAY=y
# CONFIG_THINKPAD_ACPI_VIDEO is not set
# CONFIG_THINKPAD_ACPI_HOTKEY_POLL is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
# CONFIG_ISCSI_IBFT_FIND is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
# CONFIG_DNOTIFY is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=932
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_JFFS2_FS=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
CONFIG_JFFS2_FS_WBUF_VERIFY=y
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
CONFIG_JFFS2_RUBIN=y
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_UBIFS_FS=y
CONFIG_UBIFS_FS_XATTR=y
CONFIG_UBIFS_FS_ADVANCED_COMPR=y
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
# CONFIG_NFSD_V4 is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
# CONFIG_RPCSEC_GSS_KRB5 is not set
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_FTRACE_SYSCALLS=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_POWER_TRACER=y
# CONFIG_STACK_TRACER is not set
# CONFIG_KMEMTRACE is not set
# CONFIG_WORKQUEUE_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_IMA is not set
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_GF128MUL is not set
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_TEST is not set

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_SEQIV is not set

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_PCBC is not set
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
# CONFIG_CRYPTO_HMAC is not set
# CONFIG_CRYPTO_XCBC is not set

#
# Digest
#
# CONFIG_CRYPTO_CRC32C is not set
# CONFIG_CRYPTO_CRC32C_INTEL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
# CONFIG_CRYPTO_RMD320 is not set
# CONFIG_CRYPTO_SHA1 is not set
# CONFIG_CRYPTO_SHA256 is not set
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_WP512 is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_CAMELLIA is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_DES is not set
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_TEA is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
# CONFIG_CRYPTO_ZLIB is not set
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
