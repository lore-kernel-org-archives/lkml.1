Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYGUR4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYGUR4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYGUR4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:56:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:21063 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYGUR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:56:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jzG6K9qgmXQbSNy3KVyseKIdLCI+aaJTh7sNPk8l2HS6c4J7gjFkwDX//EvlhU1nxS
         Frw8qvGVAB9wi1W+WCSIaHanzkyPD2FD1vqY+XoLm9zW5gn1ZIlh2HFiOOJBrTBzyMzc
         r2JjWPgMdFv0Xa4CU5kxTndkEbCjM6Pfd7m/U=
Date: Mon, 21 Jul 2008 21:49:52 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
Subject: 2.6.26 BUG: recent printk recursion!
Message-ID: <20080721174952.GA18891@orion>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi

It is a clear 2.6.26 kernel.
I get this few times a day. Strange, it did not happen with all -rcX.
I do not know how to reproduce it.


00:00.0 Host bridge [0600]: nVidia Corporation nForce2 AGP (different version?) [10de:01e0] (rev c1)
00:00.1 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 1 [10de:01eb] (rev c1)
00:00.2 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 4 [10de:01ee] (rev c1)
00:00.3 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 3 [10de:01ed] (rev c1)
00:00.4 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 2 [10de:01ec] (rev c1)
00:00.5 RAM memory [0500]: nVidia Corporation nForce2 Memory Controller 5 [10de:01ef] (rev c1)
00:01.0 ISA bridge [0601]: nVidia Corporation nForce2 ISA Bridge [10de:0060] (rev a4)
00:01.1 SMBus [0c05]: nVidia Corporation nForce2 SMBus (MCP) [10de:0064] (rev a2)
00:02.0 USB Controller [0c03]: nVidia Corporation nForce2 USB Controller [10de:0067] (rev a4)
00:02.1 USB Controller [0c03]: nVidia Corporation nForce2 USB Controller [10de:0067] (rev a4)
00:02.2 USB Controller [0c03]: nVidia Corporation nForce2 USB Controller [10de:0068] (rev a4)
00:04.0 Ethernet controller [0200]: nVidia Corporation nForce2 Ethernet Controller [10de:0066] (rev a1)
00:08.0 PCI bridge [0604]: nVidia Corporation nForce2 External PCI Bridge [10de:006c] (rev a3)
00:09.0 IDE interface [0101]: nVidia Corporation nForce2 IDE [10de:0065] (rev a2)
00:1e.0 PCI bridge [0604]: nVidia Corporation nForce2 AGP [10de:01e8] (rev c1)
01:06.0 Ethernet controller [0200]: Intel Corporation 82540EM Gigabit Ethernet Controller [8086:100e] (rev 02)
01:0a.0 RAID bus controller [0104]: Promise Technology, Inc. PDC20270 (FastTrak100 LP/TX2/TX4) [105a:6268] (rev 02)
02:00.0 VGA compatible controller [0300]: ATI Technologies Inc Radeon RV250 If [Radeon 9000] [1002:4966] (rev 01)
02:00.1 Display controller [0380]: ATI Technologies Inc Radeon RV250 [Radeon 9000] (Secondary) [1002:496e] (rev 01)


[    0.000000] Linux version 2.6.26 (fireball@tor) (gcc version 4.3.1 (Gentoo 4.3.1-r1 p1.1) ) #12 PREEMPT Sat Jul 19 04:03:50 MSD 2008
[    0.000000] PAT disabled. Not yet verified on this CPU type.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009d000 (usable)
[    0.000000]  BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000005fff0000 (usable)
[    0.000000]  BIOS-e820: 000000005fff0000 - 000000005fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000005fff3000 - 0000000060000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] 639MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   393200
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   393200
[    0.000000] DMI 2.2 present.
[    0.000000] ACPI: RSDP 000F6B00, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 5FFF3000, 002C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 5FFF3040, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 5FFF30C0, 48E8 (r1 NVIDIA AWRDACPI     1000 MSFT  100000D)
[    0.000000] ACPI: FACS 5FFF0000, 0040
[    0.000000] ACPI: APIC 5FFF79C0, 005A (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: BIOS IRQ0 pin2 override ignored.
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 70000000 (gap: 60000000:9ec00000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 390128
[    0.000000] Kernel command line: root=/dev/sda1 netconsole=@192.168.99.1/eth0,6666@192.168.99.2/00:1d:7d:d1:c3:69 console=tty1 console=ttyS0,9600 ro
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] CPU 0 irqstacks, hard=c04e3000 soft=c04e2000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1829.998 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty1] enabled
[    0.003333] console [ttyS0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        2048
[    0.003333] ... CLASSHASH_SIZE:           1024
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 1024 kB
[    0.003333]  per task-struct memory footprint: 2688 bytes
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
[    0.003333] Memory: 1551584k/1572800k available (2591k kernel code, 20100k reserved, 1199k data, 168k init, 655296k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9a000 - 0xfffff000   ( 404 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc04b5000 - 0xc04df000   ( 168 kB)
[    0.003333]       .data : 0xc0387f76 - 0xc04b3f20   (1199 kB)
[    0.003333]       .text : 0xc0100000 - 0xc0387f76   (2591 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=12, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.089859] Calibrating delay using timer specific routine.. 3665.79 BogoMIPS (lpj=6106877)
[    0.096660] Mount-cache hash table entries: 512
[    0.099993] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.103326] CPU: L2 Cache: 512K (64 bytes/line)
[    0.106659] Intel machine check architecture supported.
[    0.109992] Intel machine check reporting enabled on CPU#0.
[    0.113325] CPU: AMD Athlon(tm) XP 2500+ stepping 00
[    0.123325] Checking 'hlt' instruction... OK.
[    0.143323] debug: unmapping init memory c04b5000..c04b5000
[    0.146657] ACPI: Core revision 20080321
[    0.183567] ENABLING IO-APIC IRQs
[    0.189987] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.226651] khelper used greatest stack depth: 3156 bytes left
[    0.229985] net_namespace: 268 bytes
[    0.233318] NET: Registered protocol family 16
[    0.236651] No dock devices found.
[    0.239984] ACPI: bus type pci registered
[    0.243930] PCI: PCI BIOS revision 2.10 entry at 0xfb420, last bus=2
[    0.249983] PCI: Using configuration type 1 for base access
[    0.253316] Setting up standard PCI resources
[    0.267171] khelper used greatest stack depth: 3036 bytes left
[    0.273315] khelper used greatest stack depth: 2668 bytes left
[    0.327359] ACPI: Interpreter enabled
[    0.333311] ACPI: (supports S0 S5)
[    0.343296] ACPI: Using IOAPIC for interrupt routing
[    0.393638] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.399973] pci 0000:00:00.0: nForce2 C1 Halt Disconnect fixup
[    0.613175] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.656250] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.696633] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.730402] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 10 11 *12 14 15)
[    0.766633] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.809480] ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.843723] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.881918] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.916633] ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.956633] ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.999468] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.042813] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    1.077054] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    1.115236] ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.159466] ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    1.200371] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15<4>Clocksource tsc unstable (delta = 715964607 ns)
[    1.236633] ) *0, disabled.
[    1.249433] ACPI: PCI Interrupt Link [APC1] (IRQs *16), disabled.
[    1.262715] ACPI: PCI Interrupt Link [APC2] (IRQs *17), disabled.
[    1.273624] ACPI: PCI Interrupt Link [APC3] (IRQs *18)
[    1.286633] ACPI: PCI Interrupt Link [APC4] (IRQs *19)
[    1.296633] ACPI: PCI Interrupt Link [APCE] (IRQs *16), disabled.
[    1.307262] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0
[    1.329699] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0
[    1.350587] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0
[    1.373012] ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
[    1.399676] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0, disabled.
[    1.423010] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
[    1.446071] ACPI: PCI Interrupt Link [APCS] (IRQs *23)
[    1.456633] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0
[    1.477545] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
[    1.503010] ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
[    1.526344] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
[    1.549961] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.553300] pnp: PnP ACPI init
[    1.556633] ACPI: bus type pnp registered
[    1.578029] pnp: PnP ACPI: found 12 devices
[    1.583300] ACPI: ACPI bus type pnp unregistered
[    1.586633] SCSI subsystem initialized
[    1.592735] PCI: Using ACPI for IRQ routing
[    1.610615] ACPI: RTC can wake from S4
[    1.634519] system 00:00: ioport range 0x4000-0x407f has been reserved
[    1.639967] system 00:00: ioport range 0x4080-0x40ff has been reserved
[    1.643300] system 00:00: ioport range 0x4400-0x447f has been reserved
[    1.646633] system 00:00: ioport range 0x4480-0x44ff has been reserved
[    1.649967] system 00:00: ioport range 0x4200-0x427f has been reserved
[    1.653300] system 00:00: ioport range 0x4280-0x42ff has been reserved
[    1.656633] system 00:01: ioport range 0x5000-0x503f has been reserved
[    1.659967] system 00:01: ioport range 0x5100-0x513f has been reserved
[    1.663300] system 00:02: iomem range 0xdb800-0xdbfff has been reserved
[    1.666633] system 00:02: iomem range 0xf0000-0xf7fff could not be reserved
[    1.669967] system 00:02: iomem range 0xf8000-0xfbfff could not be reserved
[    1.673300] system 00:02: iomem range 0xfc000-0xfffff could not be reserved
[    1.676633] system 00:02: iomem range 0x5fff0000-0x5fffffff could not be reserved
[    1.679967] system 00:02: iomem range 0xffff0000-0xffffffff could not be reserved
[    1.683300] system 00:02: iomem range 0x0-0x9ffff could not be reserved
[    1.686633] system 00:02: iomem range 0x100000-0x5ffeffff could not be reserved
[    1.689967] system 00:02: iomem range 0xfec00000-0xfec00fff could not be reserved
[    1.693300] system 00:02: iomem range 0xfee00000-0xfee00fff could not be reserved
[    1.696633] system 00:04: ioport range 0xb78-0xb7b has been reserved
[    1.699967] system 00:04: ioport range 0xf78-0xf7b has been reserved
[    1.703300] system 00:04: ioport range 0xa78-0xa7b has been reserved
[    1.706633] system 00:04: ioport range 0xe78-0xe7b has been reserved
[    1.709967] system 00:04: ioport range 0xbbc-0xbbf has been reserved
[    1.713300] system 00:04: ioport range 0xfbc-0xfbf has been reserved
[    1.716633] system 00:04: ioport range 0x4d0-0x4d1 has been reserved
[    1.719967] system 00:04: ioport range 0x294-0x297 has been reserved
[    1.753553] PCI: Bridge: 0000:00:08.0
[    1.760011]   IO window: a000-cfff
[    1.800022]   MEM window: 0xec000000-0xedffffff
[    1.854258]   PREFETCH window: 0x0000000070000000-0x00000000700fffff
[    1.930330] PCI: Bridge: 0000:00:1e.0
[    1.974159]   IO window: d000-dfff
[    2.014890]   MEM window: 0xea000000-0xebffffff
[    2.069487]   PREFETCH window: 0x00000000e0000000-0x00000000e7ffffff
[    2.143838] NET: Registered protocol family 2
[    2.255570] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    2.340864] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.432210] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    2.518928] TCP: Hash tables configured (established 131072 bind 65536)
[    2.598813] TCP reno registered
[    2.655076] NET: Registered protocol family 1
[    2.710013] Machine check exception polling timer started.
[    2.780013] Initializing RT-Tester: OK
[    2.824888] ====[ backtrace testing ]===========
[    2.880147] Testing a backtrace from process context.
[    2.943281] The following trace is a kernel self test and not a bug!
[    3.017148] Pid: 1, comm: swapper Not tainted 2.6.26 #12
[    3.083287]  [<c04b5365>] ? kernel_init+0x0/0x1c9
[    3.140002]  [<c013e36b>] backtrace_regression_test+0x26/0x67
[    3.209521]  [<c04b53fe>] kernel_init+0x99/0x1c9
[    3.263773]  [<c013e345>] ? backtrace_regression_test+0x0/0x67
[    3.334013]  [<c0134dfa>] ? trace_hardirqs_on+0xe6/0x10d
[    3.398015]  [<c0102d7f>] ? restore_nocheck+0x12/0x15
[    3.460357]  [<c04b5365>] ? kernel_init+0x0/0x1c9
[    3.516924]  [<c04b5365>] ? kernel_init+0x0/0x1c9
[    3.573653]  [<c01038b7>] kernel_thread_helper+0x7/0x10
[    3.636414]  =======================
[    3.692372] ====[ end of backtrace testing ]====
[    3.746682] Testing a backtrace from irq context.
[    3.802997] The following trace is a kernel self test and not a bug!
[    3.879059] Pid: 1, comm: swapper Not tainted 2.6.26 #12
[    3.942645]  [<c013e341>] backtrace_test_timer+0x1c/0x20
[    4.006437]  [<c012177b>] run_timer_softirq+0x12c/0x185
[    4.069194]  [<c013e325>] ? backtrace_test_timer+0x0/0x20
[    4.134126]  [<c013e325>] ? backtrace_test_timer+0x0/0x20
[    4.200284]  [<c011eb9f>] __do_softirq+0x54/0xa1
[    4.255767]  [<c010494f>] do_softirq+0x57/0xa6
[    4.309172]  [<c011e795>] irq_exit+0x3b/0x7c
[    4.360500]  [<c010d388>] smp_apic_timer_interrupt+0x62/0x6d
[    4.429111]  [<c010374b>] apic_timer_interrupt+0x33/0x38
[    4.492906]  [<c011b08e>] ? vprintk+0x339/0x378
[    4.547558]  [<c0121900>] ? sys_sysinfo+0x2e/0x30
[    4.604289]  [<c04b5365>] ? kernel_init+0x0/0x1c9
[    4.661019]  [<c013e3a6>] ? backtrace_regression_test+0x61/0x67
[    4.732299]  [<c04b53fe>] ? kernel_init+0x99/0x1c9
[    4.790064]  [<c013e345>] ? backtrace_regression_test+0x0/0x67
[    4.860306]  [<c0134dfa>] ? trace_hardirqs_on+0xe6/0x10d
[    4.924309]  [<c0102d7f>] ? restore_nocheck+0x12/0x15
[    4.985194]  [<c04b5365>] ? kernel_init+0x0/0x1c9
[    5.041923]  [<c04b5365>] ? kernel_init+0x0/0x1c9
[    5.098654]  [<c01038b7>] ? kernel_thread_helper+0x7/0x10
[    5.163700]  =======================
[    5.209211] Kprobe smoke test started
[    5.254465] Kprobe smoke test passed successfully
[    5.311448] highmem bounce pool size: 64 pages
[    5.403155] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.483352] SGI XFS with security attributes, debug enabled
[    5.557838] msgmni has been set to 1751
[    5.603956] io scheduler noop registered
[    5.651855] io scheduler cfq registered (default)
[    5.712714] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    5.781483] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [APC4] -> GSI 19 (level, high) -> IRQ 19
[    5.887340] radeonfb: Found Intel x86 BIOS ROM Image
[    5.946814] radeonfb: Retrieved PLL infos from BIOS
[    6.006043] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=275.00 Mhz, System=275.00 MHz
[    6.105234] radeonfb: PLL min 20000 max 35000
[    6.499835] i2c-adapter i2c-1: unable to read EDID block.
[    6.706678] i2c-adapter i2c-1: unable to read EDID block.
[    6.913346] i2c-adapter i2c-1: unable to read EDID block.
[    7.288455] i2c-adapter i2c-3: unable to read EDID block.
[    7.496679] i2c-adapter i2c-3: unable to read EDID block.
[    7.703346] i2c-adapter i2c-3: unable to read EDID block.
[    7.910012] i2c-adapter i2c-1: unable to read EDID block.
[    8.116678] i2c-adapter i2c-1: unable to read EDID block.
[    8.323345] i2c-adapter i2c-1: unable to read EDID block.
[    8.530012] i2c-adapter i2c-3: unable to read EDID block.
[    8.736678] i2c-adapter i2c-3: unable to read EDID block.
[    8.943345] i2c-adapter i2c-3: unable to read EDID block.
[    9.227411] radeonfb: Monitor 1 type CRT found
[    9.280015] radeonfb: EDID probed
[    9.319956] radeonfb: Monitor 2 type no found
[    9.413340] Console: switching to colour frame buffer device 160x64
[    9.516862] radeonfb (0000:02:00.0): ATI Radeon 4966 "If"
[    9.584532] ACPI: ACPI0007:00 is registered as cooling_device0
[    9.660012] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    9.731900] ACPI: Thermal Zone [THRM] (49 C)
[    9.802687] Linux agpgart interface v0.103
[    9.851833] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
[    9.959188] Hangcheck: Using get_cycles().
[   10.009188] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   10.103915] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   10.176434] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.250472] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   10.320011] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.390012] lkdtm : Invalid command
[   10.430066] kgdb: Registered I/O driver kgdbts.
[   10.486286] kgdbts:RUN plant and detach test
[   10.536845] kgdbts:RUN sw breakpoint test
[   10.584854] kgdbts:RUN bad memory access test
[   10.637084] kgdbts:RUN singlestep test 1000 iterations
[   10.699071] kgdbts:RUN singlestep [0/1000]
[   10.756684] kgdbts:RUN singlestep [100/1000]
[   10.816687] kgdbts:RUN singlestep [200/1000]
[   10.876180] kgdbts:RUN singlestep [300/1000]
[   10.935148] kgdbts:RUN singlestep [400/1000]
[   10.993351] kgdbts:RUN singlestep [500/1000]
[   11.053128] kgdbts:RUN singlestep [600/1000]
[   11.112563] kgdbts:RUN singlestep [700/1000]
[   11.173360] kgdbts:RUN singlestep [800/1000]
[   11.233347] kgdbts:RUN singlestep [900/1000]
[   11.292342] kgdbts:RUN hw breakpoint test
[   11.340058] kgdbts:RUN hw write breakpoint test
[   11.394299] kgdbts:RUN access write breakpoint test
[   11.452755] kgdbts:RUN do_fork for 100 breakpoints
[   11.510236] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[   11.587380] Copyright (c) 1999-2006 Intel Corporation.
[   11.650023] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   11.718842] ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [APC3] -> GSI 18 (level, high) -> IRQ 18
[   12.075871] e1000: 0000:01:06.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:09:d4:79
[   12.197330] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   12.282893] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   12.373343] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[   12.443355] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCH] -> GSI 22 (level, high) -> IRQ 22
[   13.068568] forcedeth 0000:00:04.0: ifname eth1, PHY OUI 0x732 @ 1, addr 00:50:8d:f5:11:16
[   13.170022] forcedeth 0000:00:04.0: timirq lnktim desc-v1
[   13.240185] netconsole: local port 6665
[   13.287129] netconsole: local IP 192.168.99.1
[   13.342839] netconsole: interface eth0
[   13.390446] netconsole: remote port 6666
[   13.440129] netconsole: remote IP 192.168.99.2
[   13.496067] netconsole: remote ethernet address 00:1d:7d:d1:c3:69
[   13.571871] netconsole: device eth0 not up yet, forcing it
[   17.646679] netconsole: timeout waiting for carrier
[   17.728354] console [netcon0] enabled
[   22.390008] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   22.500020] netconsole: network logging started
[   22.563363] Driver 'sd' needs updating - please use bus_type methods
[   22.643983] scsi0 : pata_amd
[   22.683554] scsi1 : pata_amd
[   22.726676] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[   22.813363] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[   23.063175] ata1.00: ATA-7: ST3250823A, 3.02, max UDMA/100
[   23.132661] ata1.00: 488397168 sectors, multi 16: LBA48 
[   23.206262] ata1.00: configured for UDMA/100
[   23.463230] ata2.01: ATA-7: ST3250824A, 3.AAD, max UDMA/100
[   23.532503] ata2.01: 488397168 sectors, multi 16: LBA48 
[   23.646675] ata2.01: configured for UDMA/100
[   23.714162] scsi 0:0:0:0: Direct-Access     ATA      ST3250823A       3.02 PQ: 0 ANSI: 5
[   23.816130] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   23.905624] sd 0:0:0:0: [sda] Write Protect is off
[   23.969025] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.082811] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
[   24.170125] sd 0:0:0:0: [sda] Write Protect is off
[   24.233013] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.346621]  sda: sda1 sda2 sda3
[   24.410548] sd 0:0:0:0: [sda] Attached SCSI disk
[   24.470583] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   24.538903] scsi 1:0:1:0: Direct-Access     ATA      ST3250824A       3.AA PQ: 0 ANSI: 5
[   24.640703] sd 1:0:1:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[   24.730228] sd 1:0:1:0: [sdb] Write Protect is off
[   24.792299] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   24.904015] sd 1:0:1:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
[   24.993633] sd 1:0:1:0: [sdb] Write Protect is off
[   25.056383] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   25.168908]  sdb: sdb1
[   25.222522] sd 1:0:1:0: [sdb] Attached SCSI disk
[   25.282797] sd 1:0:1:0: Attached scsi generic sg1 type 0
[   25.352570] ACPI: PCI Interrupt 0000:01:0a.0[A] -> Link [APC3] -> GSI 18 (level, high) -> IRQ 18
[   25.562755] pata_pdc2027x 0000:01:0a.0: PLL input clock 16703 kHz
[   25.670005] scsi2 : pata_pdc2027x
[   25.714861] scsi3 : pata_pdc2027x
[   25.759611] ata3: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0417c0 irq 18
[   25.852887] ata4: PATA max UDMA/100 mmio m65536@0xed040000 cmd 0xed0415c0 irq 18
[   26.106252] ata3.00: ATA-7: ST3250823A, 3.03, max UDMA/100
[   26.176719] ata3.00: 488397168 sectors, multi 16: LBA48 
[   26.256675] ata3.00: configured for UDMA/100
[   26.506675] ata4.00: HPA detected: current 488395055, native 488397168
[   26.587237] ata4.00: ATA-7: ST3250824A, 3.AAD, max UDMA/100
[   26.658915] ata4.00: 488395055 sectors, multi 16: LBA48 
[   26.772107] ata4.00: configured for UDMA/100
[   26.843344] scsi 2:0:0:0: Direct-Access     ATA      ST3250823A       3.03 PQ: 0 ANSI: 5
[   26.944390] sd 2:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[   27.035508] sd 2:0:0:0: [sdc] Write Protect is off
[   27.096894] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.210371] sd 2:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
[   27.300753] sd 2:0:0:0: [sdc] Write Protect is off
[   27.363333] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   27.476488]  sdc: sdc1
[   27.521768] sd 2:0:0:0: [sdc] Attached SCSI disk
[   27.582698] sd 2:0:0:0: Attached scsi generic sg2 type 0
[   27.652220] scsi 3:0:0:0: Direct-Access     ATA      ST3250824A       3.AA PQ: 0 ANSI: 5
[   27.755624] sd 3:0:0:0: [sdd] 488395055 512-byte hardware sectors (250058 MB)
[   27.846197] sd 3:0:0:0: [sdd] Write Protect is off
[   27.908817] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.022582] sd 3:0:0:0: [sdd] 488395055 512-byte hardware sectors (250058 MB)
[   28.113224] sd 3:0:0:0: [sdd] Write Protect is off
[   28.175944] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   28.289449]  sdd: sdd1
[   28.342483] sd 3:0:0:0: [sdd] Attached SCSI disk
[   28.403854] sd 3:0:0:0: Attached scsi generic sg3 type 0
[   28.473679] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   28.552782] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[   28.674669] serio: i8042 KBD port at 0x60,0x64 irq 1
[   28.740592] mice: PS/2 mouse device common for all mice
[   28.810008] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[   28.886761] rtc0: alarms up to one year, y3k
[   28.956677] input: AT Translated Set 2 keyboard as /class/input/input0
[   29.059213] rtc-test rtc-test.0: rtc core: registered test as rtc1
[   29.139204] rtc-test rtc-test.1: rtc core: registered test as rtc2
[   29.218857] Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec (nowayout= 0)
[   29.334632] cpuidle: using governor ladder
[   29.389019] cpuidle: using governor menu
[   29.441934] oprofile: using NMI interrupt.
[   29.498914] TCP cubic registered
[   29.542715] NET: Registered protocol family 17
[   29.603343] RPC: Registered udp transport module.
[   29.663368] RPC: Registered tcp transport module.
[   29.726465] Using IPI Shortcut mode
[   29.774599] rtc_cmos 00:06: setting system clock to 2008-07-21 10:17:20 UTC (1216635440)
[   29.877905] ReiserFS: sda1: found reiserfs format "3.6" with standard journal
[   29.968639] ReiserFS: sda1: using ordered data mode
[   30.036678] ReiserFS: sda1: journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   30.221719] ReiserFS: sda1: checking transaction log (sda1)
[   32.773360] CPA self-test:
[   32.811244]  4k 4096 large 220 gb 0 x 4316[c0000000-f7fff000] miss 0
[   32.902836]  4k 197632 large 31 gb 0 x 197663[c0000000-f7fff000] miss 0
[   32.990007]  4k 197632 large 31 gb 0 x 197663[c0000000-f7fff000] miss 0
[   33.074482] ok.
[   96.133784] ReiserFS: sda1: replayed 376 transactions in 65 seconds
[   96.230717] ReiserFS: sda1: Using r5 hash to sort names
[   96.309203] VFS: Mounted root (reiserfs filesystem) readonly.
[   96.386655] debug: unmapping init memory c04b5000..c04df000
[   96.705580] khelper used greatest stack depth: 2488 bytes left
[   97.351270] init-early.sh used greatest stack depth: 1268 bytes left
[ 4769.633975]  [<c0104aaf>] <2>BUG: recent printk recursion!
[ 4769.633975]  [<c0103712>] common_interrupt+0x2e/0x34
[ 4769.633975]  [<c022cb06>] ? xfs_trans_buf_item_match+0x76/0x9b
[ 4769.633975]  [<c022d5ba>] xfs_trans_read_buf+0x10b/0x4b2
[ 4769.633975]  [<c01fdd44>] xfs_btree_read_bufl+0x7d/0xbd
[ 4769.633975]  [<c01fb213>] xfs_bmbt_rshift+0xaa/0x512
[ 4769.633975]  [<c02599e3>] ? random32+0x24/0x3d
[ 4769.633975]  [<c020c944>] ? xfs_error_test+0x14/0x7c
[ 4769.633975]  [<c01fe55a>] ? xfs_btree_check_lblock+0x13f/0x180
[ 4769.633975]  [<c01fe740>] ? xfs_btree_check_rec+0xa2/0x116
[ 4769.633975]  [<c01fb99e>] xfs_bmbt_insrec+0x323/0x6ed
[ 4769.633975]  [<c022d8d7>] ? xfs_trans_read_buf+0x428/0x4b2
[ 4769.633975]  [<c020c944>] ? xfs_error_test+0x14/0x7c
[ 4769.633975]  [<c01fbdd4>] xfs_bmbt_insert+0x6c/0x1d2
[ 4769.633975]  [<c01f4531>] xfs_bmap_add_extent_delay_real+0x6e5/0x1352
[ 4769.633975]  [<c012ce97>] ? up_read+0x16/0x2b
[ 4769.633975]  [<c01e4139>] ? xfs_alloc_vextent+0x3d3/0x686
[ 4769.633975]  [<c01f6504>] xfs_bmap_add_extent+0x25c/0x4cb
[ 4769.633975]  [<c01f71ab>] xfs_bmapi+0xa38/0x1765
[ 4769.633975]  [<c0135f32>] ? __lock_acquire+0xc26/0xc35
[ 4769.633975]  [<c021b74f>] xfs_iomap_write_allocate+0x20c/0x33c
[ 4769.633975]  [<c021c482>] xfs_iomap+0x29d/0x30b
[ 4769.633975]  [<c0235f8a>] xfs_map_blocks+0x2b/0x62
[ 4769.633975]  [<c0237058>] xfs_page_state_convert+0x2d7/0x569
[ 4769.633975]  [<c0237409>] xfs_vm_writepage+0x89/0xbd
[ 4769.633975]  [<c01485ba>] __writepage+0xb/0x26
[ 4769.633975]  [<c0148d5e>] write_cache_pages+0x153/0x25d
[ 4769.633975]  [<c01485af>] ? __writepage+0x0/0x26
[ 4769.633975]  [<c0148e85>] generic_writepages+0x1d/0x27
[ 4769.633975]  [<c0235f59>] xfs_vm_writepages+0x3d/0x43
[ 4769.633975]  [<c0235f1c>] ? xfs_vm_writepages+0x0/0x43
[ 4769.633975]  [<c0148eb2>] do_writepages+0x23/0x34
[ 4769.633975]  [<c0179b6a>] __writeback_single_inode+0x14c/0x26d
[ 4769.633975]  [<c0133c22>] ? put_lock_stats+0xd/0x21
[ 4769.633975]  [<c017a00f>] sync_sb_inodes+0x1c5/0x276
[ 4769.633975]  [<c017a296>] writeback_inodes+0x8d/0xe2
[ 4769.633975]  [<c0149552>] balance_dirty_pages_ratelimited_nr+0x11d/0x22a
[ 4769.633975]  [<c01496a3>] set_page_dirty_balance+0x44/0x48
[ 4769.633975]  [<c014e8a9>] __do_fault+0x2c7/0x2d9
[ 4769.633975]  [<c014fb7d>] handle_mm_fault+0x262/0x53c
[ 4769.633975]  [<c0385f13>] ? do_page_fault+0x22e/0x6a1
[ 4769.633975]  [<c012cd7c>] ? down_read_trylock+0x36/0x40
[ 4769.633975]  [<c0385fe6>] do_page_fault+0x301/0x6a1
[ 4769.633975]  [<c012ce97>] ? up_read+0x16/0x2b
[ 4769.633975]  [<c0386043>] ? do_page_fault+0x35e/0x6a1
[ 4769.633975]  [<c0135f32>] ? __lock_acquire+0xc26/0xc35
[ 4769.633975]  [<c0135f32>] ? __lock_acquire+0xc26/0xc35
[ 4769.633975]  [<c0385ce5>] ? do_page_fault+0x0/0x6a1
[ 4769.633975]  [<c0385ce5>] ? do_page_fault+0x0/0x6a1
[ 4769.633975]  [<c03847d2>] error_code+0x6a/0x70
[ 4769.633975]  [<c0258e90>] ? copy_to_user+0xfe/0x106
[ 4769.633975]  [<c031cda0>] memcpy_toiovec+0x2c/0x50
[ 4769.633975]  [<c031d279>] skb_copy_datagram_iovec+0x47/0x194
[ 4769.633975]  [<c0383fb2>] ? _spin_unlock_bh+0x2f/0x32
[ 4769.633975]  [<c0318407>] ? release_sock+0xac/0xb4
[ 4769.633975]  [<c033ca51>] tcp_recvmsg+0x46d/0x70b
[ 4769.633975]  [<c0317b3a>] sock_common_recvmsg+0x31/0x4a
[ 4769.633975]  [<c0316917>] sock_recvmsg+0xd0/0xe8
[ 4769.633975]  [<c0129cbf>] ? autoremove_wake_function+0x0/0x33
[ 4769.633975]  [<c0135f32>] ? __lock_acquire+0xc26/0xc35
[ 4769.633975]  [<c0135f32>] ? __lock_acquire+0xc26/0xc35
[ 4769.633975]  [<c03174b5>] sys_recvfrom+0x7b/0xba
[ 4769.633975]  [<c0106beb>] ? native_sched_clock+0x7f/0x91
[ 4769.633975]  [<c0133c22>] ? put_lock_stats+0xd/0x21
[ 4769.633975]  [<c0382ecf>] ? __mutex_unlock_slowpath+0xca/0xe3
[ 4769.633975]  [<c0134dfa>] ? trace_hardirqs_on+0xe6/0x10d
[ 4769.633975]  [<c0382ef0>] ? mutex_unlock+0x8/0xa
[ 4769.633975]  [<c031750c>] sys_recv+0x18/0x1a
[ 4769.633975]  [<c031785c>] sys_socketcall+0xed/0x169
[ 4769.633975]  [<c0102cd0>] ? sysenter_past_esp+0xa5/0xb1
[ 4769.633975]  [<c0102c95>] sysenter_past_esp+0x6a/0xb1
[ 4769.633975]  [<c011b098>] ? vprintk+0x343/0x378
[ 4769.633975]  [<c027410a>] ? fbcon_putcs+0x1cf/0x215
[ 4769.633975]  [<c0141d9c>] ? __rcu_read_unlock+0x54/0x62
[ 4769.633975]  [<c03864bf>] ? __atomic_notifier_call_chain+0x2c/0x36
[ 4769.633975]  [<c013e161>] ? __print_symbol+0x21/0x2a
[ 4769.633975]  [<c038639d>] ? sub_preempt_count+0x17/0x60
[ 4769.633975]  [<c038404b>] ? _spin_unlock_irqrestore+0x54/0x58
[ 4769.633975]  [<c011abb7>] ? release_console_sem+0x197/0x19f
[ 4769.633975]  [<c038639d>] ? sub_preempt_count+0x17/0x60
[ 4769.633975]  [<c011b0aa>] ? vprintk+0x355/0x378
[ 4769.633975]  [<c011abb7>] ? release_console_sem+0x197/0x19f
[ 4769.633975]  [<c011abb7>] ? release_console_sem+0x197/0x19f
[ 4769.633975]  [<c011abb7>] ? release_console_sem+0x197/0x19f
[ 4769.633975]  [<c010d4e1>] ? touch_nmi_watchdog+0x24/0x26
[ 4769.633975]  [<c01282a5>] ? __kernel_text_address+0x34/0x3e
[ 4769.633975]  [<c0103cbb>] ? dump_trace+0xae/0xe2
[ 4769.633975]  [<c0103bce>] ? print_trace_address+0x0/0x3f
[ 4769.633975]  [<c0104645>] ? show_trace+0x15/0x29
[ 4769.633975]  [<c0104aaf>] ? do_IRQ+0x61/0xe2
[ 4769.633975]  [<c0103712>] ? common_interrupt+0x2e/0x34
[ 4769.633975]  [<c022cb06>] ? xfs_trans_buf_item_match+0x76/0x9b
[ 4769.633975]  [<c022d5ba>] ? xfs_trans_read_buf+0x10b/0x4b2
[ 4769.633975]  [<c01fdd44>] ? xfs_btree_read_bufl+0x7d/0xbd
[ 4769.633975]  [<c01fb213>] ? xfs_bmbt_rshift+0xaa/0x512
[ 4769.633975]  [<c02599e3>] ? random32+0x24/0x3d
[ 4769.633975]  [<c020c944>] ? xfs_error_test+0x14/0x7c
[ 4769.633975]  [<c01fe55a>] ? xfs_btree_check_lblock+0x13f/0x180
[ 4769.633975]  [<c01fe740>] ? xfs_btree_check_rec+0xa2/0x116
[ 4769.633975]  [<c01fb99e>] ? xfs_bmbt_insrec+0x323/0x6ed
[ 4769.633975]  [<c022d8d7>] ? xfs_trans_read_buf+0x428/0x4b2
[ 4769.633975]  [<c020c944>] ? xfs_error_test+0x14/0x7c
[ 4769.633975]  [<c01fbdd4>] ? xfs_bmbt_insert+0x6c/0x1d2
[ 4769.633975]  [<c01f4531>] ? xfs_bmap_add_extent_delay_real+0x6e5/0x1352
[ 4769.633975]  [<c012ce97>] ? up_read+0x16/0x2b
[ 4769.633975]  [<c01e4139>] ? xfs_alloc_vextent+0x3d3/0x686
[ 4769.633975]  [<c01f6504>] ? xfs_bmap_add_extent+0x25c/0x4cb
[ 4769.633975]  [<c01f71ab>] ? xfs_bmapi+0xa38/0x1765
[ 4769.633975]  [<c0135f32>] ? __lock_acquire+0xc26/0xc35
[ 4769.633975]  [<c021b74f>] ? xfs_iomap_write_allocate+0x20c/0x33c

--AhhlLboLdkugWU4S
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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

--AhhlLboLdkugWU4S--
