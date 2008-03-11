Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYCKCKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYCKCKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYCKCKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:10:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:11405 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbYCKCJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=DFb1+GFmZijXIFO+ZcrvIq/36HnlEsqrbzfa+te4oDGOW6WOv8hHoX+yXSQ/9tngOxb1louksNxrTgjldleFgry3AZCypWRhza18USbabxTyzII8wuGhccXWBxD+5tJlZh/Fe7nnf0GVjaK/NbsJUmuY3ckp65riIrq4ZV8PY8s=
Date: Tue, 11 Mar 2008 10:13:15 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Subject: 2.6.25-rc3 sometimes reboot with usb init(probe?) slowly
Message-ID: <20080311021314.GA3350@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sometimes (not every time) rebooting will be slow while initilize usb
device

This is not limited to 2.6.25-rc3.

Please see the timing issue in following dmesg output:

---

[    0.000000] Linux version 2.6.25-rc3 (dave@darkstar) (gcc version 3.4.6) #1 SMP PREEMPT Mon Feb 25 10:43:06 CST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fe88c00 (usable)
[    0.000000]  BIOS-e820: 000000003fe88c00 - 000000003fe8ac00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fe8ac00 - 000000003fe8cc00 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fe8cc00 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] 126MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00fe710] 000fe710
[    0.000000] Entering add_active_range(0, 0, 261768) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   261768
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   261768
[    0.000000] On node 0 totalpages: 261768
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4040 pages, LIFO batch:0
[    0.000000]   Normal zone: 3080 pages used for memmap
[    0.000000]   Normal zone: 222200 pages, LIFO batch:31
[    0.000000]   HighMem zone: 442 pages used for memmap
[    0.000000]   HighMem zone: 31950 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000FEB00, 0024 (r2 DELL  )
[    0.000000] ACPI: XSDT 000FD267, 005C (r1 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: FACP 000FD35F, 00F4 (r3 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: DSDT FFFC755F, 2D0E (r1   DELL    dt_ex     1000 INTL 20050309)
[    0.000000] ACPI: FACS 3FE88C00, 0040
[    0.000000] ACPI: SSDT FFFCA38E, 00AC (r1   DELL    st_ex     1000 INTL 20050309)
[    0.000000] ACPI: APIC 000FD453, 0072 (r1 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: BOOT 000FD4C5, 0028 (r1 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: ASF! 000FD4ED, 0067 (r16 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: MCFG 000FD554, 003E (r1 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: HPET 000FD592, 0038 (r1 DELL    DM051          7 ASL        61)
[    0.000000] ACPI: DMI detected: Dell Dimension 5150
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:4 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:4 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258190
[    0.000000] Kernel command line: BOOT_IMAGE=25rc3 ro root=805
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2793.109 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          30
[    0.003333] ... MAX_LOCKDEP_KEYS:        2048
[    0.003333] ... CLASSHASH_SIZE:           1024
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 1024 kB
[    0.003333]  per task-struct memory footprint: 1680 bytes
[    0.003333] ------------------------
[    0.003333] | Locking API testsuite:
[    0.003333] ----------------------------------------------------------------------------
[    0.003333]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]               recursive read-lock:             |  ok  |             |  ok  |
[    0.003333]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.003333]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.003333]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.003333]   --------------------------------------------------------------------------
[    0.003333]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.003333]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.003333]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.003333]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.003333]       hard-irq read-recursion/123:  ok  |
[    0.003333]       soft-irq read-recursion/123:  ok  |
[    0.003333]       hard-irq read-recursion/132:  ok  |
[    0.003333]       soft-irq read-recursion/132:  ok  |
[    0.003333]       hard-irq read-recursion/213:  ok  |
[    0.003333]       soft-irq read-recursion/213:  ok  |
[    0.003333]       hard-irq read-recursion/231:  ok  |
[    0.003333]       soft-irq read-recursion/231:  ok  |
[    0.003333]       hard-irq read-recursion/312:  ok  |
[    0.003333]       soft-irq read-recursion/312:  ok  |
[    0.003333]       hard-irq read-recursion/321:  ok  |
[    0.003333]       soft-irq read-recursion/321:  ok  |
[    0.003333] -------------------------------------------------------
[    0.003333] Good, all 218 testcases passed! |
[    0.003333] ---------------------------------
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 1023240k/1047072k available (2908k kernel code, 23188k reserved, 1255k data, 552k init, 129568k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc0518000 - 0xc05a2000   ( 552 kB)
[    0.003333]       .data : 0xc03d734b - 0xc0511038   (1255 kB)
[    0.003333]       .text : 0xc0100000 - 0xc03d734b   (2908 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 16 of 16 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=128, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] hpet clockevent registered
[    0.083335] Calibrating delay using timer specific routine.. 5597.94 BogoMIPS (lpj=9324705)
[    0.083611] Mount-cache hash table entries: 512
[    0.084908] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.085012] CPU: L2 cache: 1024K
[    0.085079] CPU: Physical Processor ID: 0
[    0.085148] CPU: Processor Core ID: 0
[    0.085218] Intel machine check architecture supported.
[    0.085294] Intel machine check reporting enabled on CPU#0.
[    0.085369] CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.085453] Compat vDSO mapped to ffffe000.
[    0.085530] Checking 'hlt' instruction... OK.
[    0.097092] ACPI: Core revision 20070126
[    0.216083] CPU0: Intel(R) Pentium(R) D CPU 2.80GHz stepping 07
[    0.216330] lockdep: fixing up alternatives.
[    0.216403] Booting processor 1/1 ip 4000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 5588.89 BogoMIPS (lpj=9310227)
[    0.003333] CPU: Trace cache: 12K uops, L1 D cache: 16K
[    0.003333] CPU: L2 cache: 1024K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.003333] CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
[    0.310393] CPU1: Intel(R) Pentium(R) D CPU 2.80GHz stepping 07
[    0.311208] Total of 2 processors activated (11185.83 BogoMIPS).
[    0.311475] ENABLING IO-APIC IRQs
[    0.311803] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.346644] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.346694] Brought up 2 CPUs
[    0.346816] CPU0 attaching sched-domain:
[    0.346820]  domain 0: span 03
[    0.346823]   groups: 01 02
[    0.346830] CPU1 attaching sched-domain:
[    0.346833]  domain 0: span 03
[    0.346836]   groups: 02 01
[    0.347904] net_namespace: 528 bytes
[    0.350228] NET: Registered protocol family 16
[    0.351557] ACPI: bus type pci registered
[    0.352177] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub without MMCONFIG support.
[    0.377391] PCI: PCI BIOS revision 2.10 entry at 0xfb93e, last bus=3
[    0.377467] PCI: Using configuration type 1
[    0.377536] Setting up standard PCI resources
[    0.400739] ACPI: EC: Look up EC in DSDT
[    0.442033] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.455269] ACPI: Interpreter enabled
[    0.455341] ACPI: (supports S0 S1 S3 S4 S5)
[    0.455715] ACPI: Using IOAPIC for interrupt routing
[    0.536727] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.538548] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.538662] pci 0000:00:1f.0: quirk: region 0880-08bf claimed by ICH6 GPIO
[    0.540325] PCI: Transparent bridge - 0000:00:1e.0
[    0.540473] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.546409] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.550218] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.551748] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    1.256590] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    1.256590] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    1.256590] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.257264] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    1.258510] ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    1.259606] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.260807] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    1.261955] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 5 6 7 9 10 11 12 15)
[    1.263297] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.263492] pnp: PnP ACPI init
[    1.263670] ACPI: bus type pnp registered
[    1.299045] pnpacpi: exceeded the max number of IO resources: 40 
[    1.299320] pnp: PnP ACPI: found 8 devices
[    1.299392] ACPI: ACPI bus type pnp unregistered
[    1.303254] SCSI subsystem initialized
[    1.303254] libata version 3.00 loaded.
[    1.303254] usbcore: registered new interface driver usbfs
[    1.303254] usbcore: registered new interface driver hub
[    1.303260] usbcore: registered new device driver usb
[    1.304267] PCI: Using ACPI for IRQ routing
[    1.304341] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    1.329919] ACPI: RTC can wake from S4
[    1.329919] Time: tsc clocksource has been installed.
[    1.329975] Switched to high resolution mode on CPU 0
[    1.001505] Switched to high resolution mode on CPU 1
[    1.350120] system 00:01: ioport range 0x800-0x85f has been reserved
[    1.350120] system 00:01: ioport range 0xc00-0xc7f has been reserved
[    1.350120] system 00:01: ioport range 0x860-0x8ff could not be reserved
[    1.350120] system 00:06: iomem range 0x0-0x9ffff could not be reserved
[    1.350120] system 00:06: iomem range 0x100000-0xffffff could not be reserved
[    1.350120] system 00:06: iomem range 0x1000000-0x3fe88bff could not be reserved
[    1.350120] system 00:06: iomem range 0xf0000-0xfffff could not be reserved
[    1.350120] system 00:06: iomem range 0xc0000-0xcffff could not be reserved
[    1.350120] system 00:06: iomem range 0xfec00000-0xfecfffff could not be reserved
[    1.350120] system 00:06: iomem range 0xfee00000-0xfeefffff could not be reserved
[    1.350120] system 00:06: iomem range 0xfed20000-0xfed9ffff could not be reserved
[    1.350120] system 00:06: iomem range 0xffb00000-0xffbfffff could not be reserved
[    1.350120] system 00:06: iomem range 0xffc00000-0xffffffff could not be reserved
[    1.350120] system 00:07: ioport range 0x100-0x1fe could not be reserved
[    1.350120] system 00:07: ioport range 0x200-0x277 has been reserved
[    1.350120] system 00:07: ioport range 0x280-0x2e7 has been reserved
[    1.350120] system 00:07: ioport range 0x2e8-0x2ef has been reserved
[    1.350120] system 00:07: ioport range 0x2f0-0x2f7 has been reserved
[    1.350120] system 00:07: ioport range 0x2f8-0x2ff has been reserved
[    1.350120] system 00:07: ioport range 0x300-0x377 could not be reserved
[    1.350120] system 00:07: ioport range 0x380-0x3bb has been reserved
[    1.350120] system 00:07: ioport range 0x3c0-0x3e7 could not be reserved
[    1.350120] system 00:07: ioport range 0x3f6-0x3f7 could not be reserved
[    1.350120] system 00:07: ioport range 0x400-0x4cf has been reserved
[    1.350120] system 00:07: ioport range 0x4d2-0x57f has been reserved
[    1.350120] system 00:07: ioport range 0x580-0x677 has been reserved
[    1.350120] system 00:07: ioport range 0x680-0x777 has been reserved
[    1.350120] system 00:07: ioport range 0x780-0x7bb has been reserved
[    1.350120] system 00:07: ioport range 0x7c0-0x7ff has been reserved
[    1.350120] system 00:07: ioport range 0x8e0-0x8ff has been reserved
[    1.350120] system 00:07: ioport range 0x900-0x9fe has been reserved
[    1.350120] system 00:07: ioport range 0xa00-0xafe has been reserved
[    1.350120] system 00:07: ioport range 0xb00-0xbfe has been reserved
[    1.350120] system 00:07: ioport range 0xc80-0xcaf has been reserved
[    1.350120] system 00:07: ioport range 0xcb0-0xcbf has been reserved
[    1.350120] system 00:07: ioport range 0xcc0-0xcf7 has been reserved
[    1.350120] system 00:07: ioport range 0xd00-0xdfe has been reserved
[    1.350130] system 00:07: ioport range 0xe00-0xefe has been reserved
[    1.350209] system 00:07: ioport range 0xf00-0xffe has been reserved
[    1.350286] system 00:07: ioport range 0x2000-0x20fe has been reserved
[    1.350364] system 00:07: ioport range 0x2100-0x21fe has been reserved
[    1.350441] system 00:07: ioport range 0x2200-0x22fe has been reserved
[    1.350519] system 00:07: ioport range 0x2300-0x23fe has been reserved
[    1.350597] system 00:07: ioport range 0x2400-0x24fe has been reserved
[    1.350675] system 00:07: ioport range 0x2500-0x25fe has been reserved
[    1.350752] system 00:07: ioport range 0x2600-0x26fe has been reserved
[    1.350830] system 00:07: ioport range 0x2700-0x27fe has been reserved
[    1.350908] system 00:07: ioport range 0x2800-0x28fe has been reserved
[    1.350986] system 00:07: ioport range 0x2900-0x29fe has been reserved
[    1.351064] system 00:07: ioport range 0x2a00-0x2afe has been reserved
[    1.351142] system 00:07: ioport range 0x2b00-0x2bfe has been reserved
[    1.351220] system 00:07: ioport range 0x2c00-0x2cfe has been reserved
[    1.351298] system 00:07: ioport range 0x2d00-0x2dfe has been reserved
[    1.351379] system 00:07: iomem range 0xf0000000-0xf3ffffff could not be reserved
[    1.351488] system 00:07: iomem range 0xfeda0000-0xfedacfff has been reserved
[    1.382831] PCI: Bridge: 0000:00:01.0
[    1.382904]   IO window: d000-dfff
[    1.382981]   MEM window: 0xefd00000-0xefefffff
[    1.383056]   PREFETCH window: 0x00000000e0000000-0x00000000e7ffffff
[    1.383141] PCI: Bridge: 0000:00:1c.0
[    1.383209]   IO window: disabled.
[    1.383285]   MEM window: 0xefc00000-0xefcfffff
[    1.383360]   PREFETCH window: disabled.
[    1.383445] PCI: Bridge: 0000:00:1e.0
[    1.383517]   IO window: c000-cfff
[    1.383593]   MEM window: 0xefa00000-0xefbfffff
[    1.383668]   PREFETCH window: disabled.
[    1.383791] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.383881] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.383933] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
[    1.384078] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.384105] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    1.384140] NET: Registered protocol family 2
[    1.440532] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.440532] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    1.440532] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    1.452362] TCP: Hash tables configured (established 131072 bind 65536)
[    1.452488] TCP reno registered
[    1.473933] Simple Boot Flag at 0x7a set to 0x80
[    1.158607] highmem bounce pool size: 64 pages
[    1.185774] VFS: Disk quotas dquot_6.5.1
[    1.186284] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.189728] NTFS driver 2.1.29 [Flags: R/W].
[    1.193062] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.193190] io scheduler noop registered
[    1.193261] io scheduler anticipatory registered (default)
[    1.193334] io scheduler deadline registered
[    1.194023] io scheduler cfq registered
[    1.194277] pci 0000:01:00.0: Boot video device
[    1.194306] pci 0000:03:08.0: Firmware left e100 interrupts enabled; disabling
[    1.194862] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.194993] assign_interrupt_mode Found MSI capability
[    1.195070] Allocate Port Service[0000:00:01.0:pcie00]
[    1.195467] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.195651] assign_interrupt_mode Found MSI capability
[    1.195729] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.195966] Allocate Port Service[0000:00:1c.0:pcie02]
[    1.352189] Real Time Clock Driver v1.12ac
[    1.352341] intel_rng: Firmware space is locked read-only. If you can't or
[    1.352343] intel_rng: don't want to disable this in firmware setup, and if
[    1.352345] intel_rng: you are certain that your system has a functional
[    1.352346] intel_rng: RNG, try using the 'no_fwh_detect' option.
[    1.352684] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.356062] Floppy drive(s): fd0 is 1.44M
[    4.371511] floppy0: no floppy controllers found
[    4.376401] brd: module loaded
[    4.377003] console [netcon0] enabled
[    4.378193] netconsole: network logging started
[    4.378264] Uniform Multi-Platform E-IDE driver
[    4.378337] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    4.378701] ICH7: IDE controller (0x8086:0x27df rev 0x01) at  PCI slot 0000:00:1f.1
[    4.378825] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
[    4.378975] ICH7: not 100% native mode: will probe irqs later
[    4.379063] ICH7: IDE port disabled
[    4.379138]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:PIO
[    4.379291] Probing IDE interface ide0...
[    5.403641] hda: TSSTcorp CD-RW/DVD-ROM TS-H492C, ATAPI CD/DVD-ROM drive
[    5.403641] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.403642] hda: UDMA/33 mode selected
[    5.404027] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.405089] Probing IDE interface ide1...
[    6.315687] hda: ATAPI 48X DVD-ROM CD-R/RW drive, 1536kB Cache
[    6.315687] Uniform CD-ROM driver Revision: 3.20
[    6.320734] Driver 'sd' needs updating - please use bus_type methods
[    6.321030] Driver 'sr' needs updating - please use bus_type methods
[    6.321379] ata_piix 0000:00:1f.2: version 2.12
[    6.321424] ACPI: PCI Interrupt 0000:00:1f.2[C] -> GSI 20 (level, low) -> IRQ 20
[    6.321569] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    6.476253] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    6.476376] scsi0 : ata_piix
[    6.476428] scsi1 : ata_piix
[    6.476457] ata1: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 20
[    6.476457] ata2: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 20
[    6.636511] ata1.00: ATA-7: SAMSUNG HD160JJ/P, ZM100-34, max UDMA7
[    6.636511] ata1.00: 312500000 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    6.643226] ata1.00: configured for UDMA/133
[    6.813218] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD160JJ/ ZM10 PQ: 0 ANSI: 5
[    6.813261] sd 0:0:0:0: [sda] 312500000 512-byte hardware sectors (160000 MB)
[    6.813261] sd 0:0:0:0: [sda] Write Protect is off
[    6.813261] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.813261] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.813760] sd 0:0:0:0: [sda] 312500000 512-byte hardware sectors (160000 MB)
[    6.813909] sd 0:0:0:0: [sda] Write Protect is off
[    6.813981] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.814132] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.814283]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    6.920968] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.922593] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 21 (level, low) -> IRQ 21
[    6.922757] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    6.922764] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.924012] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    6.928147] ehci_hcd 0000:00:1d.7: debug port 1
[    6.928229] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
[    6.928259] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[    6.944109] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.944294] usb usb1: configuration #1 chosen from 1 choice
[    6.944309] hub 1-0:1.0: USB hub found
[    6.944309] hub 1-0:1.0: 8 ports detected
[    7.047795] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    7.047825] USB Universal Host Controller Interface driver v3.0
[    7.047849] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 21 (level, low) -> IRQ 21
[    7.047849] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    7.047849] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    7.047864] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    7.047864] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    7.048858] usb usb2: configuration #1 chosen from 1 choice
[    7.049210] hub 2-0:1.0: USB hub found
[    7.049407] hub 2-0:1.0: 2 ports detected
[    7.154522] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
[    7.154522] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    7.154522] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    7.154560] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    7.154560] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    7.154628] usb usb3: configuration #1 chosen from 1 choice
[    7.154659] hub 3-0:1.0: USB hub found
[    7.154659] hub 3-0:1.0: 2 ports detected
[    7.258062] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    7.258062] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    7.258062] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    7.258105] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    7.258105] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    7.258175] usb usb4: configuration #1 chosen from 1 choice
[    7.258206] hub 4-0:1.0: USB hub found
[    7.258206] hub 4-0:1.0: 2 ports detected
[    7.274929] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    7.361517] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 23 (level, low) -> IRQ 23
[    7.361517] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    7.361517] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    7.361550] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    7.361550] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    7.361622] usb usb5: configuration #1 chosen from 1 choice
[    7.361653] hub 5-0:1.0: USB hub found
[    7.361653] hub 5-0:1.0: 2 ports detected
[    7.398937] usb 1-1: configuration #1 chosen from 1 choice
[    7.399104] hub 1-1:1.0: USB hub found
[    7.399163] hub 1-1:1.0: 4 ports detected
[    8.203048] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    8.383987] usb 3-2: configuration #1 chosen from 1 choice
[    8.617212] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    8.789330] usb 4-1: configuration #1 chosen from 1 choice
[    8.995873] usb 1-1.3: new full speed USB device using ehci_hcd and address 5
[    9.156054] usb 1-1.3: configuration #1 chosen from 1 choice
[    9.160635] usbcore: registered new interface driver libusual
[    9.161687] PNP: No PS/2 controller found. Probing ports directly.
[    9.164763] serio: i8042 KBD port at 0x60,0x64 irq 1
[    9.164897] serio: i8042 AUX port at 0x60,0x64 irq 12
[    9.165844] mice: PS/2 mouse device common for all mice
[    9.166672] cpuidle: using governor ladder
[    9.166746] cpuidle: using governor menu
[    9.167129] usbcore: registered new interface driver hiddev
[    9.182630] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:00:1d.1/usb3/3-2/3-2:1.0/input/input0
[   64.677054] usb 1-1: USB disconnect, address 2
[   64.677054] usb 1-1.3: USB disconnect, address 5
[   64.678008] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-2
[   64.693697] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.2/usb4/4-1/4-1:1.0/input/input1
[   64.713662] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.2-1
[   64.713676] usbcore: registered new interface driver usbhid
[   64.713676] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   64.714281] TCP cubic registered
[   64.714720] NET: Registered protocol family 1
[   64.714859] NET: Registered protocol family 17
[   64.714987] Starting balanced_irq
[   64.715127] Using IPI No-Shortcut mode
[   64.759402] EXT3-fs: mounted filesystem with ordered data mode.
[   64.759623] VFS: Mounted root (ext3 filesystem) readonly.
[   64.760377] Freeing unused kernel memory: 552k freed
[   64.760822] kjournald starting.  Commit interval 5 seconds
[   66.519566] Adding 1116476k swap on /dev/sda8.  Priority:-1 extents:1 across:1116476k
[   66.688595] EXT3 FS on sda5, internal journal
[   68.958597] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 17 (level, low) -> IRQ 17
[   68.967863] input: Power Button (FF) as /devices/virtual/input/input2
[   68.978916] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   68.981406] ACPI: Power Button (FF) [PWRF]
[   68.981935] input: Power Button (CM) as /devices/virtual/input/input3
[   69.007321] Linux agpgart interface v0.103
[   69.009548] ACPI: Power Button (CM) [VBTN]
[   69.017935] ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 18 (level, low) -> IRQ 18
[   69.018088] 3c59x: Donald Becker and others.
[   69.018167] 0000:03:02.0: 3Com PCI 3c905C Tornado at f88a8f80.
[   69.031988] input: PC Speaker as /devices/platform/pcspkr/input/input4
[   69.112920] ACPI: ACPI0007:00 is registered as cooling_device0
[   69.113238] ACPI: ACPI0007:01 is registered as cooling_device1
[   69.200673] rtc_cmos: probe of 00:05 failed with error -16
[   69.474946] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[   69.475145] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   70.072295] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   72.518491] eth0:  setting full-duplex.
[   77.184515] Bluetooth: Core ver 2.11
[   77.187752] NET: Registered protocol family 31
[   77.187758] Bluetooth: HCI device and connection manager initialized
[   77.187895] Bluetooth: HCI socket layer initialized
[   77.300348] Bluetooth: L2CAP ver 2.9
[   77.300355] Bluetooth: L2CAP socket layer initialized
[   77.357011] Bluetooth: RFCOMM socket layer initialized
[   77.357051] Bluetooth: RFCOMM TTY layer initialized
[   77.357054] Bluetooth: RFCOMM ver 1.8
[  134.461244] usb 1-1: new high speed USB device using ehci_hcd and address 6
[  134.584124] usb 1-1: configuration #1 chosen from 1 choice
[  134.584124] hub 1-1:1.0: USB hub found
[  134.584124] hub 1-1:1.0: 4 ports detected
[  134.890079] usb 1-1.3: new full speed USB device using ehci_hcd and address 7
[  134.969439] usb 1-1.3: device descriptor read/64, error -32
[  150.326752] usb 1-1.3: device descriptor read/64, error -110
[  150.511313] usb 1-1.3: new full speed USB device using ehci_hcd and address 8
[  150.667003] usb 1-1.3: configuration #1 chosen from 1 choice
[  150.719433] Bluetooth: HCI USB driver ver 2.9
[  150.721444] usbcore: registered new interface driver hci_usb
