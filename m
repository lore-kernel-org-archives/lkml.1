Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbYBHVbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbYBHVbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYBHVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:31:37 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:35706 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbYBHVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:31:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=bd+Q0JMZrUzKcVZOJX8aDOYWJVrZkaRoUgCDg+4CpjUeoWm5ExGghXeyYCDEwIRha/WIQ2bvk00RAjhGJmEnnSeQTnfOX9bNPONiaXX6Wp31As93ItIhbyvoyEcRfyrxHO9WlOs8eFdQMHQiX+WTuV17+TwtNigBh+UViwPh4HM=
Date: Sat, 9 Feb 2008 00:31:21 +0300
To: mingo@elte.hu, tglx@linutronix.de, arjan@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: CPA spam in dmesg (no pte level 0)
Message-ID: <20080208213121.GC15571@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I enabled pretty much all debugging on
2.6.24-0cf975e16927fd70f34cee20d3856246c13bb4c8 and CPA code
continuosly spams dmesg like this:

[   24.100000] CPA ffff810080000000 no pte level 0
[   24.520000] PGD 8063 PUD 0
[   24.520000] CPA ffff810080000000 no pte level 0
[   24.540000] PGD 8063 PUD 0

This is E6400 box with 4G of RAM, x86_64 is used.
dmesg and .config below:

of 256 used
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
[    0.000000] early res: 2 [200000-8ea667] TEXT DATA BSS
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
[    0.000000]   DMA zone: 1782 pages reserved
[    0.000000]   DMA zone: 2161 pages, LIFO batch:0
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
[    0.000000] PERCPU: Allocating 24368 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1025081
[    0.000000] Kernel command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC calibrated against PIT
[    0.000000] time.c: Detected 2135.074 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.000000] ... MAX_LOCK_DEPTH:          30
[    0.000000] ... MAX_LOCKDEP_KEYS:        2048
[    0.000000] ... CLASSHASH_SIZE:           1024
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.000000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.000000] ... CHAINHASH_SIZE:          8192
[    0.000000]  memory used by lock dependency info: 1648 kB
[    0.000000]  per task-struct memory footprint: 1680 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] Checking aperture...
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing software IO TLB between 0xbe63000 - 0xfe63000
[    0.000000] Memory: 4026940k/6291456k available (2044k kernel code, 165904k reserved, 804k data, 212k init)
[    0.000000] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.000000] hpet clockevent registered
[    0.150000] Calibrating delay using timer specific routine.. 4273.49 BogoMIPS (lpj=21367459)
[    0.150000] Mount-cache hash table entries: 256
[    0.150000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.150000] CPU: L2 cache: 2048K
[    0.150000] CPU: Physical Processor ID: 0
[    0.150000] CPU: Processor Core ID: 0
[    0.150000] CPU0: Thermal monitoring enabled (TM2)
[    0.150000] using mwait in idle threads.
[    0.150000] Freeing SMP alternatives: 16k freed
[    0.150000] ACPI: Core revision 20070126
[    0.270000] Using local APIC timer interrupts.
[    0.280000] APIC timer calibration result 16680269
[    0.280000] Detected 16.680 MHz APIC timer.
[    0.280000] lockdep: fixing up alternatives.
[    0.280000] Booting processor 1/2 APIC 0x1
[    0.000000] Initializing CPU#1
[    0.000000] Calibrating delay using timer specific routine.. 4270.17 BogoMIPS (lpj=21350894)
[    0.000000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000000] CPU: L2 cache: 2048K
[    0.000000] CPU: Physical Processor ID: 0
[    0.000000] CPU: Processor Core ID: 1
[    0.000000] CPU1: Thermal monitoring enabled (TM2)
[    0.000000] Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
[    0.440000] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.450000] Brought up 2 CPUs
[    0.450000] net_namespace: 408 bytes
[    0.450000] NET: Registered protocol family 16
[    0.450000] ACPI: bus type pci registered
[    0.450000] PCI: Using configuration type 1
[    0.450000] ACPI: EC: Look up EC in DSDT
[    0.460000] ACPI: Interpreter enabled
[    0.460000] ACPI: (supports S0 S5)
[    0.460000] ACPI: Using IOAPIC for interrupt routing
[    0.470000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.470000] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.470000] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.470000] PCI: Transparent bridge - 0000:00:1e.0
[    0.470000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.470000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.470000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.470000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.480000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.490000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.490000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.490000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.490000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.500000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.500000] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.500000] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.500000] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.500000] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  08, should be FB [20070126]
[    0.500000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.500000] pnp: PnP ACPI init
[    0.500000] ACPI: bus type pnp registered
[    0.500000] pnp: PnP ACPI: found 16 devices
[    0.500000] ACPI: ACPI bus type pnp unregistered
[    0.500000] SCSI subsystem initialized
[    0.500000] libata version 3.00 loaded.
[    0.500000] PCI: Using ACPI for IRQ routing
[    0.510000] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.550000] PCI-GART: No AMD northbridge found.
[    0.550000] Time: tsc clocksource has been installed.
[    0.560000] Switched to high resolution mode on CPU 0
[    0.110000] Switched to high resolution mode on CPU 1
[    0.590000] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.590000] system 00:08: ioport range 0x290-0x297 has been reserved
[    0.590000] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
[    0.590000] system 00:09: ioport range 0x800-0x87f has been reserved
[    0.590000] system 00:09: ioport range 0x480-0x4bf has been reserved
[    0.590000] system 00:09: iomem range 0xffafe000-0xffb0cbff could not be reserved
[    0.590000] system 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
[    0.590000] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.590000] system 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.590000] system 00:09: iomem range 0xfff00000-0xfffffffe could not be reserved
[    0.590000] system 00:09: iomem range 0xfebfe000-0xfebfec00 has been reserved
[    0.590000] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.590000] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.590000] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[    0.590000] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.590000] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[    0.590000] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[    0.590000] system 00:0f: iomem range 0x100000-0x7fffffff could not be reserved
[    0.590000] system 00:0f: iomem range 0x0-0x0 could not be reserved
[    0.590000] PCI: Bridge: 0000:00:01.0
[    0.590000]   IO window: a000-afff
[    0.590000]   MEM window: 0xf8800000-0xfe8fffff
[    0.590000]   PREFETCH window: 0x00000000bfe00000-0x00000000dfdfffff
[    0.590000] PCI: Bridge: 0000:00:1c.0
[    0.590000]   IO window: disabled.
[    0.590000]   MEM window: disabled.
[    0.590000]   PREFETCH window: 0x00000000dfe00000-0x00000000dfefffff
[    0.590000] PCI: Bridge: 0000:00:1c.3
[    0.590000]   IO window: disabled.
[    0.590000]   MEM window: 0xfea00000-0xfeafffff
[    0.590000]   PREFETCH window: disabled.
[    0.590000] PCI: Bridge: 0000:00:1c.4
[    0.590000]   IO window: b000-bfff
[    0.590000]   MEM window: 0xfe900000-0xfe9fffff
[    0.590000]   PREFETCH window: disabled.
[    0.590000] PCI: Bridge: 0000:00:1e.0
[    0.590000]   IO window: disabled.
[    0.590000]   MEM window: disabled.
[    0.590000]   PREFETCH window: disabled.
[    0.590000] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.590000] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.590000] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.590000] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.590000] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.590000] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.590000] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
[    0.590000] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.590000] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.590000] NET: Registered protocol family 2
[    0.690000] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.690000] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.690000] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.690000] TCP: Hash tables configured (established 262144 bind 65536)
[    0.690000] TCP reno registered
[    0.270000] io scheduler noop registered
[    0.270000] io scheduler cfq registered (default)
[    0.270000] pci 0000:01:00.0: Boot video device
[    0.280000] Real Time Clock Driver v1.12ac
[    0.280000] Linux agpgart interface v0.103
[    0.280000] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[    0.280000] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    0.280000] atl1 0000:03:00.0: version 2.0.7
[    0.430000] netconsole: local port 6665
[    0.430000] netconsole: local IP 10.10.0.42
[    0.430000] netconsole: interface eth0
[    0.430000] netconsole: remote port 9353
[    0.430000] netconsole: remote IP 10.10.0.1
[    0.430000] netconsole: remote ethernet address 00:80:48:45:ec:73
[    0.430000] netconsole: device eth0 not up yet, forcing it
[    2.270000] atl1 0000:03:00.0: eth0 link is up 100 Mbps full duplex
[    4.450000] netconsole: timeout waiting for carrier
[    4.480000] console [netcon0] enabled
[    4.490000] netconsole: network logging started
[    4.490000] Driver 'sd' needs updating - please use bus_type methods
[    4.490000] Driver 'sr' needs updating - please use bus_type methods
[    4.490000] ahci 0000:02:00.0: version 3.0
[    4.490000] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    4.520000] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[    4.520000] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[    4.520000] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    4.520000] scsi0 : ahci
[    4.520000] scsi1 : ahci
[    4.520000] ata1: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe100 irq 16
[    4.520000] ata2: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe180 irq 16
[    4.630000] ata1: SATA link down (SStatus 0 SControl 300)
[    4.720000] ata2: SATA link down (SStatus 0 SControl 300)
[    4.730000] ata_piix 0000:00:1f.2: version 2.12
[    4.730000] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    4.730000] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    4.730000] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    4.730000] scsi2 : ata_piix
[    4.730000] scsi3 : ata_piix
[    4.740000] ata3: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
[    4.740000] ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
[    5.040000] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.050000] ata3.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
[    5.050000] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.080000] ata3.00: configured for UDMA/133
[    4.860000] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    5.090000] ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    5.090000] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    5.120000] ata4.00: configured for UDMA/133
[    4.870000] scsi 2:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
[    4.870000] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[    4.870000] sd 2:0:0:0: [sda] Write Protect is off
[    4.870000] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.870000] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.870000] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[    4.870000] sd 2:0:0:0: [sda] Write Protect is off
[    4.870000] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.870000] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.870000]  sda: sda1 sda2 sda3 sda4
[    5.140000] sd 2:0:0:0: [sda] Attached SCSI disk
[    5.140000] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    5.140000] sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[    5.140000] sd 3:0:0:0: [sdb] Write Protect is off
[    5.140000] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.140000] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.140000] sd 3:0:0:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
[    5.140000] sd 3:0:0:0: [sdb] Write Protect is off
[    5.140000] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.140000] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.140000]  sdb: sdb1
[    5.160000] sd 3:0:0:0: [sdb] Attached SCSI disk
[    5.160000] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
[    5.160000] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    5.160000] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[    5.160000] scsi4 : ata_piix
[    5.160000] scsi5 : ata_piix
[    5.160000] ata5: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
[    5.160000] ata6: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
[    5.050000] ata5: SATA link down (SStatus 0 SControl 300)
[    5.130000] ata6: SATA link down (SStatus 0 SControl 300)
[    5.260000] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
[    5.260000] PCI: Setting latency timer of device 0000:02:00.1 to 64
[    5.260000] scsi6 : pata_jmicron
[    5.260000] scsi7 : pata_jmicron
[    5.260000] ata7: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 17
[    5.260000] ata8: PATA max UDMA/100 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 17
[    5.350000] ata7.01: ATAPI: _NEC DV-5800C, D9S2, max UDMA/33
[    5.360000] ata7.01: configured for UDMA/33
[    5.390000] scsi 6:0:1:0: CD-ROM            _NEC     DV-5800C         D9S2 PQ: 0 ANSI: 5
[    5.390000] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[    5.390000] Uniform CD-ROM driver Revision: 3.20
[    5.390000] sr 6:0:1:0: Attached scsi CD-ROM sr0
[    5.390000] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    5.390000] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    5.390000] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.390000] TCP cubic registered
[    5.390000] NET: Registered protocol family 1
[    5.410000] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    5.310000] kjournald starting.  Commit interval 5 seconds
[    5.510000] EXT3-fs: mounted filesystem with ordered data mode.
[    5.510000] VFS: Mounted root (ext3 filesystem) readonly.
[    5.510000] Freeing unused kernel memory: 212k freed
[    5.510000] Write protecting the kernel read-only data: 2664k
[    5.510000] Testing CPA: undo ffffffff80408000-ffffffff804a3000
[    5.510000] Testing CPA: again
[    7.570000] EXT3 FS on sda2, internal journal
[    7.740000] Adding 7823644k swap on /dev/sda3.  Priority:-1 extents:1 across:7823644k
[   14.010000] CPA self-test:
[   14.010000] PGD 8063 PUD 0 
[   14.010000] CPA ffff810080000000 no pte level 0
[   14.020000]  4k 1024 large 2558 gb 0 x 0[0-0] miss 262144
[   14.020000] PGD 8063 PUD 0 
[   14.020000] CPA ffff810080000000 no pte level 0
[   14.020000]  4k 172544 large 2223 gb 0 x 0[0-0] miss 262144
[   14.030000] PGD 8063 PUD 0 
[   14.030000] CPA ffff810080000000 no pte level 0
[   14.030000]  4k 172544 large 2223 gb 0 x 0[0-0] miss 262144
[   14.030000] ok.
[   14.310000] PGD 8063 PUD 0 
[   14.310000] CPA ffff810080000000 no pte level 0
[   14.320000] PGD 8063 PUD 0 
[   14.320000] CPA ffff810080000000 no pte level 0
[   14.330000] PGD 8063 PUD 0 
[   14.330000] CPA ffff810080000000 no pte level 0
[   15.070000] PGD 8063 PUD 0 
[   15.070000] CPA ffff810080000000 no pte level 0
[   15.090000] PGD 8063 PUD 0 
[   15.090000] CPA ffff810080000000 no pte level 0
[   15.100000] PGD 8063 PUD 0 
[   15.100000] CPA ffff810080000000 no pte level 0
[   15.270000] PGD 8063 PUD 0 
[   15.270000] CPA ffff810080000000 no pte level 0
[   15.280000] PGD 8063 PUD 0 
	...



#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24
# Sat Feb  9 00:06:38 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
# CONFIG_QUICKLIST is not set
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
# CONFIG_POSIX_MQUEUE is not set
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=15
# CONFIG_CGROUPS is not set
# CONFIG_FAIR_GROUP_SCHED is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_NAMESPACES is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_EMBEDDED=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_TIMERFD is not set
# CONFIG_EVENTFD is not set
CONFIG_SHMEM=y
# CONFIG_VM_EVENT_COUNTERS is not set
# CONFIG_SLUB_DEBUG is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_KPROBES=y
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_AS is not set
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
# CONFIG_PREEMPT_RCU is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_IOMMU_HELPER=y
CONFIG_SWIOTLB=y
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
# CONFIG_SCHED_MC is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_RCU_TRACE is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set
# CONFIG_X86_CPUID is not set
# CONFIG_NUMA is not set
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
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
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_SYSFS_POWER is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
# CONFIG_ACPI_PROCESSOR is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
# CONFIG_X86_PM_TIMER is not set
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
# CONFIG_CFG80211 is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_MAC80211 is not set
# CONFIG_IEEE80211 is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
# CONFIG_BLK_DEV is not set
# CONFIG_MISC_DEVICES is not set
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
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
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=y
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
# CONFIG_PATA_PLATFORM is not set
# CONFIG_MD is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_IEEE1394 is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_MII=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
CONFIG_ATL1=y
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
# CONFIG_WLAN_80211 is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
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
# CONFIG_INPUT_MOUSEDEV is not set
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
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
# CONFIG_INPUT_MOUSE is not set
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
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_I2C is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
# CONFIG_HWMON is not set
# CONFIG_THERMAL is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
# CONFIG_AGP_INTEL is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
# CONFIG_SOUND is not set
# CONFIG_HID_SUPPORT is not set
# CONFIG_USB_SUPPORT is not set
# CONFIG_MMC is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
# CONFIG_UIO is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
# CONFIG_FS_POSIX_ACL is not set
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_DNOTIFY is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_SCHED_DEBUG is not set
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_PREEMPT=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
CONFIG_DEBUG_VM=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
# CONFIG_FRAME_POINTER is not set
# CONFIG_FORCED_INLINING is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_X86_MPPARSE=y
CONFIG_IOMMU_DEBUG=y
# CONFIG_IOMMU_LEAK is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_CPA_DEBUG=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_CRYPTO is not set
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
