Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYDKGeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYDKGeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYDKGd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:33:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46941 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYDKGd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:33:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=s9vu35cizx+EMn5Dv1OfTmyNFVF5EiAkuSFAJN3n7GUfhj9YVua71u5jtCCFe+W7q7acrtfBgeYkbdDOCXqgI6/Ub5L22F5FPVWdm6oLI5zxGr8+4414BhSIG8X0w3U/O4matS8k40Yelxh4fQLOpKaCvYapO4E856xCwKX1EV8=
Date: Fri, 11 Apr 2008 10:29:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: 2.6.25-rc8-mm2: boot hang after "ACPI: using IOAPIC for interrupt
	routing"
Message-ID: <20080411062928.GB4748@martell.zuzino.mipt.ru>
References: <20080410203354.f0a6f464.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410203354.f0a6f464.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 08:33:54PM -0700, Andrew Morton wrote:
> - git-slub has been temporarily replaced by git-pekka.  Pekka is standing in
>   while Christoph is away.

I bisected boot hang after "ACPI: using IOAPIC for interrupt routing"
down to git-pekka.

normal dmesg from 2.6.25-rc8-something and .config snippets for -mm

# CONFIG_SLUB_DEBUG is not set		(hey, I thought this was on!)
CONFIG_SLUB=y
# CONFIG_SLUB_STATS is not set

# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_FS is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_RODATA=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set

P.S.: I now suspect that one bisection point was wrong, however,
      make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes
      was definitely good.


[    0.000000] Linux version 2.6.25-rc8 (ad@martell) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #2 SMP Fri Apr 11 00:54:03 MSD 2008
[    0.000000] Command line: root=/dev/sda2 netconsole=@192.168.0.1/eth0,9353@192.168.0.42/00:1b:38:af:22:49 ignore_loglevel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
[    0.000000]  BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 524176) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
[    0.000000] end_pfn_map = 1572864
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 7FF90100, 0054 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
[    0.000000] ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   2000707 MSFT       97)
[    0.000000] ACPI: DSDT 7FF905C0, 8FA9 (r1  A0637 A0637000        0 INTL 20060113)
[    0.000000] ACPI: FACS 7FF9E000, 0040
[    0.000000] ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   2000707 MSFT       97)
[    0.000000] ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   2000707 MSFT       97)
[    0.000000] ACPI: SLIC 7FF90440, 0176 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
[    0.000000] ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   2000707 MSFT       97)
[    0.000000] ACPI: HPET 7FF99570, 0038 (r1 MSTEST OEMHPET   2000707 MSFT       97)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 524176) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-5eead3] TEXT DATA BSS
[    0.000000] early res: 3 [9fc00-a0bff] EBDA
[    0.000000] early res: 4 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
[    0.000000]  [ffffe20004400000-ffffe200045fffff] PMD ->ffff810009a00000 on node 0
[    0.000000]  [ffffe20004600000-ffffe200047fffff] PMD ->ffff810009e00000 on node 0
[    0.000000]  [ffffe20004800000-ffffe200049fffff] PMD ->ffff81000a200000 on node 0
[    0.000000]  [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff81000a600000 on node 0
[    0.000000]  [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff81000aa00000 on node 0
[    0.000000]  [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff81000ae00000 on node 0
[    0.000000]  [ffffe20005000000-ffffe200051fffff] PMD ->ffff81000b200000 on node 0
[    0.000000]  [ffffe20005200000-ffffe200053fffff] PMD ->ffff81000b600000 on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1572864
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524176
[    0.000000]     0:  1048576 ->  1572864
[    0.000000] On node 0 totalpages: 1048367
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1018 pages reserved
[    0.000000]   DMA zone: 2925 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 505800 pages, LIFO batch:31
[    0.000000]   Normal zone: 7168 pages used for memmap
[    0.000000]   Normal zone: 517120 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a202 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
[    0.000000] PERCPU: Allocating 32200 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1025845
[    0.000000] Kernel command line: root=/dev/sda2 netconsole=@192.168.0.1/eth0,9353@192.168.0.42/00:1b:38:af:22:49 ignore_loglevel
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PIT
[    0.000000] time.c: Detected 2135.096 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing software IO TLB between 0xbe27000 - 0xfe27000
[    0.000000] Memory: 4030128k/6291456k available (2283k kernel code, 162620k reserved, 1113k data, 228k init)
[    0.000000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000000] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.000000] hpet clockevent registered
[    0.150000] Calibrating delay using timer specific routine.. 4272.54 BogoMIPS (lpj=21362745)
[    0.150000] Mount-cache hash table entries: 256
[    0.150000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.150000] CPU: L2 cache: 2048K
[    0.150000] CPU: Physical Processor ID: 0
[    0.150000] CPU: Processor Core ID: 0
[    0.150000] CPU0: Thermal monitoring enabled (TM2)
[    0.150000] using mwait in idle threads.
[    0.150000] Freeing SMP alternatives: 21k freed
[    0.150000] ACPI: Core revision 20070126
[    0.270000] Using local APIC timer interrupts.
[    0.290000] APIC timer calibration result 16680437
[    0.290000] Detected 16.680 MHz APIC timer.
[    0.290000] Booting processor 1/2 APIC 0x1
[    0.000000] Initializing CPU#1
[    0.000000] Calibrating delay using timer specific routine.. 4270.25 BogoMIPS (lpj=21351254)
[    0.000000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000000] CPU: L2 cache: 2048K
[    0.000000] CPU: Physical Processor ID: 0
[    0.000000] CPU: Processor Core ID: 1
[    0.000000] CPU1: Thermal monitoring enabled (TM2)
[    0.000000] Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
[    0.450000] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.460000] Brought up 2 CPUs
[    0.460000] net_namespace: 872 bytes
[    0.460000] NET: Registered protocol family 16
[    0.460000] No dock devices found.
[    0.460000] ACPI: bus type pci registered
[    0.460000] PCI: Using configuration type 1
[    0.460000] ACPI: EC: Look up EC in DSDT
[    0.470000] ACPI: Interpreter enabled
[    0.470000] ACPI: (supports S0 S5)
[    0.470000] ACPI: Using IOAPIC for interrupt routing
[    0.480000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.480000] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.480000] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.480000] PCI: Transparent bridge - 0000:00:1e.0
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.490000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.490000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.490000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.490000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.490000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.500000] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.500000] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.500000] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.500000] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  08, should be 03 [20070126]
[    0.500000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.500000] pnp: PnP ACPI init
[    0.500000] ACPI: bus type pnp registered
[    0.500000] pnp: PnP ACPI: found 15 devices
[    0.500000] ACPI: ACPI bus type pnp unregistered
[    0.500000] SCSI subsystem initialized
[    0.500000] libata version 3.00 loaded.
[    0.500000] PCI: Using ACPI for IRQ routing
[    0.500000] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.540000] PCI-GART: No AMD northbridge found.
[    0.550000] Switched to high resolution mode on CPU 0
[    0.090000] Switched to high resolution mode on CPU 1
[    0.580000] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.580000] system 00:07: ioport range 0x290-0x297 has been reserved
[    0.580000] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.580000] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.580000] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.580000] system 00:08: iomem range 0xffafe000-0xffb0cbff could not be reserved
[    0.580000] system 00:08: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.580000] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.580000] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.580000] system 00:08: iomem range 0xfff00000-0xfffffffe could not be reserved
[    0.580000] system 00:08: iomem range 0xfebfe000-0xfebfec00 has been reserved
[    0.580000] system 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.580000] system 00:0b: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.580000] system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
[    0.580000] system 00:0e: iomem range 0x0-0x9ffff could not be reserved
[    0.580000] system 00:0e: iomem range 0xc0000-0xcffff has been reserved
[    0.580000] system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
[    0.580000] system 00:0e: iomem range 0x100000-0x7fffffff could not be reserved
[    0.580000] system 00:0e: iomem range 0x0-0x0 could not be reserved
[    0.580000] PCI: Bridge: 0000:00:01.0
[    0.580000]   IO window: 9000-9fff
[    0.580000]   MEM window: 0xf8700000-0xfe7fffff
[    0.580000]   PREFETCH window: 0x00000000bfe00000-0x00000000dfdfffff
[    0.580000] PCI: Bridge: 0000:00:1c.0
[    0.580000]   IO window: disabled.
[    0.580000]   MEM window: disabled.
[    0.580000]   PREFETCH window: 0x00000000dfe00000-0x00000000dfefffff
[    0.580000] PCI: Bridge: 0000:00:1c.3
[    0.580000]   IO window: disabled.
[    0.580000]   MEM window: 0xfe900000-0xfe9fffff
[    0.580000]   PREFETCH window: disabled.
[    0.580000] PCI: Bridge: 0000:00:1c.4
[    0.580000]   IO window: a000-afff
[    0.580000]   MEM window: 0xfe800000-0xfe8fffff
[    0.580000]   PREFETCH window: disabled.
[    0.580000] PCI: Bridge: 0000:00:1e.0
[    0.580000]   IO window: b000-bfff
[    0.580000]   MEM window: 0xfea00000-0xfeafffff
[    0.580000]   PREFETCH window: 0x0000000088000000-0x00000000880fffff
[    0.580000] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.580000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.580000] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.580000] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.580000] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.580000] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.580000] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[    0.580000] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.580000] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.580000] NET: Registered protocol family 2
[    0.670000] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.670000] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.670000] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.670000] TCP: Hash tables configured (established 262144 bind 65536)
[    0.670000] TCP reno registered
[    0.240000] io scheduler noop registered
[    0.240000] io scheduler cfq registered (default)
[    0.240000] pci 0000:01:00.0: Boot video device
[    0.250000] Real Time Clock Driver v1.12ac
[    0.250000] Linux agpgart interface v0.103
[    0.250000] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[    0.250000] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    0.250000] atl1 0000:03:00.0: version 2.0.7
[    0.390000] 8139too Fast Ethernet driver 0.9.28
[    0.390000] ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 23 (level, low) -> IRQ 23
[    0.390000] eth1: RealTek RTL8139 at 0xb800, 00:80:48:2e:06:2e, IRQ 23
[    0.390000] eth1:  Identified 8139 chip type 'RTL-8100B/8139D'
[    0.390000] netconsole: local port 6665
[    0.390000] netconsole: local IP 192.168.0.1
[    0.390000] netconsole: interface eth0
[    0.390000] netconsole: remote port 9353
[    0.390000] netconsole: remote IP 192.168.0.42
[    0.390000] netconsole: remote ethernet address 00:1b:38:af:22:49
[    0.390000] netconsole: device eth0 not up yet, forcing it
[    3.050000] atl1 0000:03:00.0: eth0 link is up 1000 Mbps full duplex
[    2.760000] console [netcon0] enabled
[    2.770000] netconsole: network logging started
[    2.770000] Driver 'sd' needs updating - please use bus_type methods
[    2.770000] ahci 0000:02:00.0: version 3.0
[    2.770000] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    2.800000] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    2.800000] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    2.800000] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    2.800000] scsi0 : ahci
[    2.800000] scsi1 : ahci
[    2.800000] ata1: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe100 irq 16
[    2.800000] ata2: SATA max UDMA/133 abar m8192@0xfe8fe000 port 0xfe8fe180 irq 16
[    2.910000] ata1: SATA link down (SStatus 0 SControl 300)
[    3.010000] ata2: SATA link down (SStatus 0 SControl 300)
[    3.010000] ata_piix 0000:00:1f.2: version 2.12
[    3.010000] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    3.010000] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    3.010000] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    3.010000] scsi2 : ata_piix
[    3.010000] scsi3 : ata_piix
[    3.020000] ata3: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
[    3.020000] ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
[    3.130000] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.270000] ata3.00: ATA-8: ST3750330AS, SD15, max UDMA/133
[    3.270000] ata3.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.270000] ata3.01: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
[    3.270000] ata3.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.290000] ata3.00: configured for UDMA/133
[    3.310000] ata3.01: configured for UDMA/133
[    3.230000] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.330000] ata4.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
[    3.330000] ata4.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    3.360000] ata4.00: configured for UDMA/133
[    3.240000] scsi 2:0:0:0: Direct-Access     ATA      ST3750330AS      SD15 PQ: 0 ANSI: 5
[    3.240000] sd 2:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[    3.240000] sd 2:0:0:0: [sda] Write Protect is off
[    3.250000] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.250000] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.250000] sd 2:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
[    3.250000] sd 2:0:0:0: [sda] Write Protect is off
[    3.250000] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.250000] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.250000]  sda: sda1 sda2
[    3.370000] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.370000] scsi 2:0:1:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 ANSI: 5
[    3.370000] sd 2:0:1:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[    3.370000] sd 2:0:1:0: [sdb] Write Protect is off
[    3.370000] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.370000] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.370000] sd 2:0:1:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
[    3.370000] sd 2:0:1:0: [sdb] Write Protect is off
[    3.370000] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.370000] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.370000]  sdb: sdb4
[    3.390000]  sdb4: <openbsd: sdb5 sdb6 >
[    3.390000] sd 2:0:1:0: [sdb] Attached SCSI disk
[    3.390000] scsi 3:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
[    3.390000] sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[    3.390000] sd 3:0:0:0: [sdc] Write Protect is off
[    3.390000] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.390000] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.390000] sd 3:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[    3.390000] sd 3:0:0:0: [sdc] Write Protect is off
[    3.390000] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    3.390000] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.390000]  sdc: sdc1
[    3.410000] sd 3:0:0:0: [sdc] Attached SCSI disk
[    3.410000] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
[    3.410000] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    3.410000] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    3.410000] scsi4 : ata_piix
[    3.410000] scsi5 : ata_piix
[    3.420000] ata5: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
[    3.420000] ata6: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
[    3.420000] ata5: SATA link down (SStatus 0 SControl 300)
[    3.520000] ata6: SATA link down (SStatus 0 SControl 300)
[    3.500000] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[    3.500000] PCI: Setting latency timer of device 0000:02:00.1 to 64
[    3.500000] scsi6 : pata_jmicron
[    3.500000] scsi7 : pata_jmicron
[    3.500000] ata7: PATA max UDMA/100 cmd 0xac00 ctl 0xa880 bmdma 0xa400 irq 17
[    3.500000] ata8: PATA max UDMA/100 cmd 0xa800 ctl 0xa480 bmdma 0xa408 irq 17
[    3.560000] ata7.01: ATAPI: Optiarc DVD RW AD-7173A, 1-01, max UDMA/66
[    3.600000] ata7.01: configured for UDMA/66
[    3.620000] scsi 6:0:1:0: CD-ROM            Optiarc  DVD RW AD-7173A  1-01 PQ: 0 ANSI: 5
[    3.620000] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    3.620000] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    3.620000] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.620000] mice: PS/2 mouse device common for all mice
[    3.620000] Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
[    3.620000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    3.620000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    3.630000] input: AT Translated Set 2 keyboard as /class/input/input0
[    3.880000] ALSA device list:
[    3.880000]   #0: HDA Intel at 0xfebf8000 irq 22
[    3.880000] TCP cubic registered
[    3.880000] NET: Registered protocol family 1
[    3.650000] kjournald starting.  Commit interval 5 seconds
[    3.910000] EXT3-fs: mounted filesystem with ordered data mode.
[    3.910000] VFS: Mounted root (ext3 filesystem) readonly.
[    3.910000] Freeing unused kernel memory: 228k freed
[    4.930000] Driver 'sr' needs updating - please use bus_type methods
[    5.480000] usbcore: registered new interface driver usbfs
[    5.480000] usbcore: registered new interface driver hub
[    5.480000] usbcore: registered new device driver usb
[    5.480000] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.480000] Uniform CD-ROM driver Revision: 3.20
[    5.480000] sr 6:0:1:0: Attached scsi CD-ROM sr0
[    5.480000] USB Universal Host Controller Interface driver v3.0
[    5.480000] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[    5.480000] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    5.480000] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.480000] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    5.480000] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000dc00
[    5.480000] usb usb1: configuration #1 chosen from 1 choice
[    5.480000] hub 1-0:1.0: USB hub found
[    5.480000] hub 1-0:1.0: 2 ports detected
[    5.590000] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.590000] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.590000] usb usb1: Product: UHCI Host Controller
[    5.590000] usb usb1: Manufacturer: Linux 2.6.25-rc8 uhci_hcd
[    5.590000] usb usb1: SerialNumber: 0000:00:1a.0
[    5.590000] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
[    5.590000] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    5.590000] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.590000] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
[    5.590000] uhci_hcd 0000:00:1a.1: irq 17, io base 0x0000e000
[    5.590000] usb usb2: configuration #1 chosen from 1 choice
[    5.590000] hub 2-0:1.0: USB hub found
[    5.590000] hub 2-0:1.0: 2 ports detected
[    5.700000] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.700000] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.700000] usb usb2: Product: UHCI Host Controller
[    5.700000] usb usb2: Manufacturer: Linux 2.6.25-rc8 uhci_hcd
[    5.700000] usb usb2: SerialNumber: 0000:00:1a.1
[    5.700000] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    5.700000] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    5.700000] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.700000] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    5.700000] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000d480
[    5.700000] usb usb3: configuration #1 chosen from 1 choice
[    5.700000] hub 3-0:1.0: USB hub found
[    5.700000] hub 3-0:1.0: 2 ports detected
[    5.770000] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.770000] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.770000] usb usb3: Product: UHCI Host Controller
[    5.770000] usb usb3: Manufacturer: Linux 2.6.25-rc8 uhci_hcd
[    5.770000] usb usb3: SerialNumber: 0000:00:1d.0
[    5.770000] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    5.770000] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    5.770000] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.770000] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
[    5.770000] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000d800
[    5.770000] usb usb4: configuration #1 chosen from 1 choice
[    5.770000] hub 4-0:1.0: USB hub found
[    5.770000] hub 4-0:1.0: 2 ports detected
[    5.810000] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.810000] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.810000] usb usb4: Product: UHCI Host Controller
[    5.810000] usb usb4: Manufacturer: Linux 2.6.25-rc8 uhci_hcd
[    5.810000] usb usb4: SerialNumber: 0000:00:1d.1
[    5.810000] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    5.810000] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    5.810000] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.810000] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
[    5.810000] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d880
[    5.810000] usb usb5: configuration #1 chosen from 1 choice
[    5.810000] hub 5-0:1.0: USB hub found
[    5.810000] hub 5-0:1.0: 2 ports detected
[    5.860000] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.860000] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.860000] usb usb5: Product: UHCI Host Controller
[    5.860000] usb usb5: Manufacturer: Linux 2.6.25-rc8 uhci_hcd
[    5.860000] usb usb5: SerialNumber: 0000:00:1d.2
[    5.860000] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[    5.860000] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    5.860000] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.860000] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
[    5.860000] ehci_hcd 0000:00:1a.7: debug port 1
[    5.860000] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[    5.860000] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfebffc00
[    5.880000] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.880000] usb usb6: configuration #1 chosen from 1 choice
[    5.880000] hub 6-0:1.0: USB hub found
[    5.880000] hub 6-0:1.0: 4 ports detected
[    5.970000] usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
[    5.970000] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.970000] usb usb6: Product: EHCI Host Controller
[    5.970000] usb usb6: Manufacturer: Linux 2.6.25-rc8 ehci_hcd
[    5.970000] usb usb6: SerialNumber: 0000:00:1a.7
[    5.970000] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    5.970000] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    5.970000] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.970000] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
[    5.970000] ehci_hcd 0000:00:1d.7: debug port 1
[    5.970000] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    5.970000] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfebff800
[    5.990000] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    5.990000] usb usb7: configuration #1 chosen from 1 choice
[    5.990000] hub 7-0:1.0: USB hub found
[    5.990000] hub 7-0:1.0: 6 ports detected
[    6.040000] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    6.040000] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    6.040000] usb usb7: Product: EHCI Host Controller
[    6.040000] usb usb7: Manufacturer: Linux 2.6.25-rc8 ehci_hcd
[    6.040000] usb usb7: SerialNumber: 0000:00:1d.7
[    6.870000] EXT3 FS on sda2, internal journal
[    7.130000] Adding 9775512k swap on /dev/sda1.  Priority:-1 extents:1 across:9775512k
[   12.610000] ip_tables: (C) 2000-2006 Netfilter Core Team
[   12.620000] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   13.000000] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1

