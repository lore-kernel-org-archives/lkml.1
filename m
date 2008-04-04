Return-Path: <linux-kernel-owner+w=401wt.eu-S1758546AbYDDIW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbYDDIW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbYDDIWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:22:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33396 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758432AbYDDIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:21:52 -0400
Date: Fri, 4 Apr 2008 01:21:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
Message-Id: <20080404012147.abf8a598.akpm@linux-foundation.org>
In-Reply-To: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 05:07:45 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:

> When playing a DVD and then suspending the system while the DVD is
> still in play, upon wakeup I'm receiving a Buffer I/O error on device
> sr0, logical block 356490.
> the DVD will continue to play but then gmplayer complains: Warning!
> FPS changed 23.976 -> 29.970 (-5.994005) [4] then the video becomes
> very choppy. When looking at osx in the same test the DVD will be
> paused until the cd player aligns itself, then playback will start.
> With looking further at this I think this is an issue of a library or
> codec, So with this in mind is there a package that I might look at to
> see if this resolves the issue. Attached is dmesg of the Buffer I/O
> regards;

An ata thing, I assume.  Let's cc linux-ide.

Is this new behaviour in 2.6.25-rc8, or were earlier kernels OK?

> [    0.000000] Linux version 2.6.25-rc8 (root@unix) (gcc version 4.1.3 20080114 (prerelease) (Debian 4.1.2-19)) #1 SMP Tue Apr 1 23:57:23 UTC 2008
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
> [    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
> [    0.000000] 112MB HIGHMEM available.
> [    0.000000] 896MB LOWMEM available.
> [    0.000000] Scan SMP from c0000000 for 1024 bytes.
> [    0.000000] Scan SMP from c009fc00 for 1024 bytes.
> [    0.000000] Scan SMP from c00f0000 for 65536 bytes.
> [    0.000000] Scan SMP from c009fc00 for 1024 bytes.
> [    0.000000] Entering add_active_range(0, 0, 258282) 0 entries of 256 used
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   Normal       4096 ->   229376
> [    0.000000]   HighMem    229376 ->   258282
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[1] active PFN ranges
> [    0.000000]     0:        0 ->   258282
> [    0.000000] On node 0 totalpages: 258282
> [    0.000000]   DMA zone: 32 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 4064 pages, LIFO batch:0
> [    0.000000]   Normal zone: 1760 pages used for memmap
> [    0.000000]   Normal zone: 223520 pages, LIFO batch:31
> [    0.000000]   HighMem zone: 225 pages used for memmap
> [    0.000000]   HighMem zone: 28681 pages, LIFO batch:7
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] DMI 2.4 present.
> [    0.000000] Using APIC driver default
> [    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
> [    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
> [    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
> [    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 INTL 20050309)
> [    0.000000] ACPI: FACS 3FEC0000, 0040
> [    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
> [    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
> [    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
> [    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
> [    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
> [    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
> [    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
> [    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
> [    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
> [    0.000000] ACPI: DMI detected: Apple
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] Processor #0 6:15 APIC version 20
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
> [    0.000000] Processor #1 6:15 APIC version 20
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
> [    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 256265
> [    0.000000] Kernel command line: root=/dev/sda1 ro quiet splash vga=773 selinux=1 audit=1 enforcing=1 highres=off apic=verbose acpi_osi=Linux pnpacpi=off usbcore.autosuspend=1 pci=routeirq
> [    0.000000] audit: enabled (after initialization)
> [    0.000000] ACPI: Added _OSI(Linux)
> [    0.000000] mapped APIC to ffffb000 (fee00000)
> [    0.000000] mapped IOAPIC to ffffa000 (fec00000)
> [    0.000000] Enabling fast FPU save and restore... done.
> [    0.000000] Enabling unmasked SIMD FPU exception support... done.
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
> [    0.000000] Detected 2161.255 MHz processor.
> [    0.003333] Console: colour dummy device 80x25
> [    0.003333] console [tty0] enabled
> [    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> [    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> [    0.003333] Memory: 1019064k/1033128k available (2490k kernel code, 13416k reserved, 959k data, 332k init, 115624k highmem)
> [    0.003333] virtual kernel memory layout:
> [    0.003333]     fixmap  : 0xfff9a000 - 0xfffff000   ( 404 kB)
> [    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
> [    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
> [    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
> [    0.003333]       .init : 0xc0466000 - 0xc04b9000   ( 332 kB)
> [    0.003333]       .data : 0xc036e8c8 - 0xc045e740   ( 959 kB)
> [    0.003333]       .text : 0xc0100000 - 0xc036e8c8   (2490 kB)
> [    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
> [    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
> [    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> [    0.003333] hpet clockevent registered
> [    0.083331] Calibrating delay using timer specific routine.. 4328.69 BogoMIPS (lpj=7210719)
> [    0.083348] Security Framework initialized
> [    0.083351] SELinux:  Initializing.
> [    0.083358] SELinux:  Starting in enforcing mode
> [    0.083366] selinux_register_security:  Registering secondary module capability
> [    0.083368] Capability LSM initialized as secondary
> [    0.083377] Mount-cache hash table entries: 512
> [    0.083484] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.083486] CPU: L2 cache: 4096K
> [    0.083489] CPU: Physical Processor ID: 0
> [    0.083490] CPU: Processor Core ID: 0
> [    0.083492] Intel machine check architecture supported.
> [    0.083495] Intel machine check reporting enabled on CPU#0.
> [    0.083497] using mwait in idle threads.
> [    0.083500] Compat vDSO mapped to ffffe000.
> [    0.083505] Checking 'hlt' instruction... OK.
> [    0.097770] ACPI: Core revision 20070126
> [    0.105392] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
> [    0.105398] enabled ExtINT on CPU#0
> [    0.105407] Booting processor 1/1 ip 4000
> [    0.003333] Initializing CPU#1
> [    0.003333] masked ExtINT on CPU#1
> [    0.003333] Calibrating delay using timer specific routine.. 4324.65 BogoMIPS (lpj=7204251)
> [    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
> [    0.003333] CPU: L2 cache: 4096K
> [    0.003333] CPU: Physical Processor ID: 0
> [    0.003333] CPU: Processor Core ID: 1
> [    0.003333] Intel machine check architecture supported.
> [    0.003333] Intel machine check reporting enabled on CPU#1.
> [    0.197373] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
> [    0.197387] Total of 2 processors activated (8652.35 BogoMIPS).
> [    0.197578] ENABLING IO-APIC IRQs
> [    0.197579] init IO_APIC IRQs
> [    0.197581]  IO-APIC (apicid-pin) 1-0 not connected.
> [    0.197625]  IO-APIC (apicid-pin) 1-16, 1-17, 1-18, 1-19, 1-20, 1-21, 1-22, 1-23 not connected.
> [    0.197777] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.230814] Using local APIC timer interrupts.
> [    0.230815] calibrating APIC timer ...
> [    0.233318] ... lapic delta = 1039057
> [    0.233318] ... PM timer delta = 357953
> [    0.233318] ... PM timer result ok
> [    0.233318] ..... delta 1039057
> [    0.233318] ..... mult: 44630068
> [    0.233318] ..... calibration result: 554163
> [    0.233318] ..... CPU clock speed is 2161.1523 MHz.
> [    0.233318] ..... host bus clock speed is 166.0885 MHz.
> [    0.233318] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [    0.233334] Brought up 2 CPUs
> [    0.233358] CPU0 attaching sched-domain:
> [    0.233360]  domain 0: span 3
> [    0.233362]   groups: 1 2
> [    0.233365] CPU1 attaching sched-domain:
> [    0.233366]  domain 0: span 3
> [    0.233368]   groups: 2 1
> [    0.233604] net_namespace: 452 bytes
> [    0.233613] Booting paravirtualized kernel on bare hardware
> [    0.233781] NET: Registered protocol family 16
> [    0.233952] No dock devices found.
> [    0.234059] EISA bus registered
> [    0.234063] ACPI: bus type pci registered
> [    0.234139] PCI: Using configuration type 1
> [    0.234141] Setting up standard PCI resources
> [    0.236136] ACPI: EC: EC description table is found, configuring boot EC
> [    0.236316] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    0.239148] ACPI: BIOS _OSI(Linux) query honored via cmdline
> [    0.239488] ACPI: Interpreter enabled
> [    0.239491] ACPI: (supports S0 S3 S4 S5)
> [    0.239502] ACPI: Using IOAPIC for interrupt routing
> [    0.252698] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    0.252700] ACPI: EC: driver started in poll mode
> [    0.254869] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [    0.255644] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> [    0.255649] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
> [    0.256495] PCI: Transparent bridge - 0000:00:1e.0
> [    0.256539] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [    0.256853] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
> [    0.256970] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
> [    0.257083] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
> [    0.257195] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
> [    0.257315] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
> [    0.263253] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.263349] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    0.263435] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
> [    0.263528] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
> [    0.263615] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
> [    0.263700] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
> [    0.263785] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
> [    0.263870] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
> [    0.264244] Linux Plug and Play Support v0.97 (c) Adam Belay
> [    0.264276] pnp: PnP ACPI: disabled
> [    0.264463] SCSI subsystem initialized
> [    0.264521] libata version 3.00 loaded.
> [    0.264627] usbcore: registered new interface driver usbfs
> [    0.264685] usbcore: registered new interface driver hub
> [    0.264739] usbcore: registered new device driver usb
> [    0.264994] PCI: Using ACPI for IRQ routing
> [    0.264997] PCI: Routing PCI interrupts for all devices because "pci=routeirq" specified
> [    0.265001] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    0.265004] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    0.265007] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    0.265011] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
> [    0.265013] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
> [    0.265016] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    0.265019] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> [    0.265023] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> [    0.265025] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    0.265028] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
> [    0.265031] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> [    0.265033] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> [    0.265036] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> [    0.265039] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
> [    0.265041] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    0.265044] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    0.265047] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> [    0.265049] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
> [    0.265052] number of MP IRQ sources: 15.
> [    0.265053] number of IO-APIC #1 registers: 24.
> [    0.265055] testing the IO APIC.......................
> [    0.265063] IO APIC #1......
> [    0.265064] .... register #00: 00000000
> [    0.265066] .......    : physical APIC id: 00
> [    0.265067] .......    : Delivery Type: 0
> [    0.265068] .......    : LTS          : 0
> [    0.265069] .... register #01: 00170020
> [    0.265071] .......     : max redirection entries: 0017
> [    0.265072] .......     : PRQ implemented: 0
> [    0.265074] .......     : IO APIC version: 0020
> [    0.265075] .... IRQ redirection table:
> [    0.265076]  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
> [    0.265081]  00 000 00  1    0    0   0   0    0    0    00
> [    0.265087]  01 003 03  0    0    0   0   0    1    1    39
> [    0.265093]  02 003 03  0    0    0   0   0    1    1    31
> [    0.265099]  03 003 03  0    0    0   0   0    1    1    41
> [    0.265105]  04 003 03  0    0    0   0   0    1    1    49
> [    0.265110]  05 003 03  0    0    0   0   0    1    1    51
> [    0.265116]  06 003 03  0    0    0   0   0    1    1    59
> [    0.265122]  07 003 03  0    0    0   0   0    1    1    61
> [    0.265127]  08 003 03  0    0    0   0   0    1    1    69
> [    0.265133]  09 003 03  0    1    0   0   0    1    1    71
> [    0.265139]  0a 003 03  0    0    0   0   0    1    1    79
> [    0.265144]  0b 003 03  0    0    0   0   0    1    1    81
> [    0.265150]  0c 003 03  0    0    0   0   0    1    1    89
> [    0.265156]  0d 003 03  0    0    0   0   0    1    1    91
> [    0.265161]  0e 003 03  0    0    0   0   0    1    1    99
> [    0.265167]  0f 003 03  0    0    0   0   0    1    1    A1
> [    0.265173]  10 003 03  1    1    0   1   0    1    1    A9
> [    0.265179]  11 003 03  1    1    0   1   0    1    1    B9
> [    0.265184]  12 003 03  1    1    0   1   0    1    1    C1
> [    0.265190]  13 003 03  1    1    0   1   0    1    1    D1
> [    0.265196]  14 000 00  1    0    0   0   0    0    0    00
> [    0.265202]  15 000 00  1    0    0   0   0    0    0    00
> [    0.265207]  16 003 03  1    1    0   1   0    1    1    B1
> [    0.265213]  17 003 03  1    1    0   1   0    1    1    C9
> [    0.265215] IRQ to pin mappings:
> [    0.265217] IRQ0 -> 0:2
> [    0.265218] IRQ1 -> 0:1
> [    0.265220] IRQ3 -> 0:3
> [    0.265222] IRQ4 -> 0:4
> [    0.265223] IRQ5 -> 0:5
> [    0.265225] IRQ6 -> 0:6
> [    0.265226] IRQ7 -> 0:7
> [    0.265228] IRQ8 -> 0:8
> [    0.265230] IRQ9 -> 0:9
> [    0.265231] IRQ10 -> 0:10
> [    0.265233] IRQ11 -> 0:11
> [    0.265235] IRQ12 -> 0:12
> [    0.265236] IRQ13 -> 0:13
> [    0.265238] IRQ14 -> 0:14
> [    0.265239] IRQ15 -> 0:15
> [    0.265241] IRQ16 -> 0:16
> [    0.265243] IRQ17 -> 0:17
> [    0.265244] IRQ18 -> 0:18
> [    0.265246] IRQ19 -> 0:19
> [    0.265247] IRQ22 -> 0:22
> [    0.265249] IRQ23 -> 0:23
> [    0.265251] .................................... done.
> [    0.269996] NetLabel: Initializing
> [    0.269997] NetLabel:  domain hash size = 128
> [    0.269999] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.270011] NetLabel:  unlabeled traffic allowed by default
> [    0.270021] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
> [    0.270025] hpet0: 3 64-bit timers, 14318180 Hz
> [    0.307160] PCI: Bridge: 0000:00:01.0
> [    0.307162]   IO window: 3000-3fff
> [    0.307166]   MEM window: 0x50300000-0x503fffff
> [    0.307169]   PREFETCH window: 0x0000000040000000-0x0000000047ffffff
> [    0.307173] PCI: Bridge: 0000:00:1c.0
> [    0.307176]   IO window: 2000-2fff
> [    0.307181]   MEM window: 0x50200000-0x502fffff
> [    0.307186]   PREFETCH window: 0x0000000050500000-0x00000000505fffff
> [    0.307193] PCI: Bridge: 0000:00:1c.1
> [    0.307194]   IO window: disabled.
> [    0.307199]   MEM window: 0x50100000-0x501fffff
> [    0.307203]   PREFETCH window: disabled.
> [    0.307210] PCI: Bridge: 0000:00:1c.2
> [    0.307213]   IO window: 1000-1fff
> [    0.307218]   MEM window: 0x4c100000-0x500fffff
> [    0.307222]   PREFETCH window: 0x0000000048000000-0x000000004bffffff
> [    0.307230] PCI: Bridge: 0000:00:1e.0
> [    0.307231]   IO window: disabled.
> [    0.307236]   MEM window: 0x4c000000-0x4c0fffff
> [    0.307240]   PREFETCH window: disabled.
> [    0.307255] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
> [    0.307260] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [    0.307281] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
> [    0.307286] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [    0.307308] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
> [    0.307314] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> [    0.307336] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    0.307341] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> [    0.307354] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [    0.307363] NET: Registered protocol family 2
> [    0.320025] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> [    0.320209] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
> [    0.320565] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.320740] TCP: Hash tables configured (established 131072 bind 65536)
> [    0.320743] TCP reno registered
> [    0.094028] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
> [    0.094312] audit: initializing netlink socket (enabled)
> [    0.094323] type=2000 audit(1207283385.326:1): initialized
> [    0.094501] highmem bounce pool size: 64 pages
> [    0.094505] Total HugeTLB memory allocated, 0
> [    0.097174] fuse init (API version 7.9)
> [    0.097442] SELinux:  Registering netfilter hooks
> [    0.097510] io scheduler noop registered
> [    0.097563] io scheduler cfq registered (default)
> [    0.097660] pci 0000:01:00.0: Boot video device
> [    0.097777] vesafb: framebuffer at 0x40000000, mapped to 0xf8880000, using 1536k, total 16384k
> [    0.097779] vesafb: mode is 1024x768x8, linelength=1024, pages=18
> [    0.097781] vesafb: protected mode interface info at c000:ad0c
> [    0.097783] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
> [    0.097785] vesafb: scrolling: redraw
> [    0.097787] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
> [    0.097839] fb0: VESA VGA frame buffer device
> [    0.097913] power_supply ADP1: uevent
> [    0.097915] power_supply ADP1: No power supply yet
> [    0.097946] power_supply ADP1: power_supply_changed
> [    0.097951] ACPI: AC Adapter [ADP1] (on-line)
> [    0.097995] power_supply ADP1: power_supply_changed_work
> [    0.097997] power_supply ADP1: power_supply_update_gen_leds 1
> [    0.098003] power_supply ADP1: uevent
> [    0.098004] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
> [    0.098009] power_supply ADP1: Static prop TYPE=Mains
> [    0.098011] power_supply ADP1: 1 dynamic props
> [    0.098013] power_supply ADP1: prop ONLINE=1
> [    0.332231] ACPI: EC: non-query interrupt received, switching to interrupt mode
> [    0.432875] power_supply BAT0: uevent
> [    0.432877] power_supply BAT0: No power supply yet
> [    0.432955] power_supply BAT0: power_supply_changed
> [    0.433020] power_supply BAT0: power_supply_changed_work
> [    0.458794] ACPI: Battery Slot [BAT0] (battery present)
> [    0.463083] hpet_resources: 0xfed00000 is busy
> [    0.463620] loop: module loaded
> [    0.463645] Linux video capture interface: v2.00
> [    0.463871] input: Macintosh mouse button emulation as /class/input/input0
> [    0.464036] Driver 'sd' needs updating - please use bus_type methods
> [    0.464066] Driver 'sr' needs updating - please use bus_type methods
> [    0.464259] ata_piix 0000:00:1f.1: version 2.12
> [    0.464267] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> [    0.464300] PCI: Setting latency timer of device 0000:00:1f.1 to 64
> [    0.464373] scsi0 : ata_piix
> [    0.464457] scsi1 : ata_piix
> [    0.464974] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
> [    0.464977] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
> [    0.488663] power_supply BAT0: power_supply_update_bat_leds 4
> [    0.488669] power_supply BAT0: uevent
> [    0.488670] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
> [    0.488674] power_supply BAT0: Static prop TYPE=Battery
> [    0.488676] power_supply BAT0: 12 dynamic props
> [    0.488678] power_supply BAT0: prop STATUS=Full
> [    0.488681] power_supply BAT0: prop PRESENT=1
> [    0.488683] power_supply BAT0: prop TECHNOLOGY=Unknown
> [    0.488685] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
> [    0.488688] power_supply BAT0: prop VOLTAGE_NOW=12453000
> [    0.488690] power_supply BAT0: prop CURRENT_NOW=0
> [    0.488692] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
> [    0.488695] power_supply BAT0: prop ENERGY_FULL=53150000
> [    0.488697] power_supply BAT0: prop ENERGY_NOW=51380000
> [    0.488699] power_supply BAT0: prop MODEL_NAME=ASMB012
> [    0.488701] power_supply BAT0: prop MANUFACTURER=SMPN012
> [    0.488703] power_supply BAT0: prop SERIAL_NUMBER=
> [    0.266661] Switched to NOHz mode on CPU #1
> [    0.503310] Switched to NOHz mode on CPU #0
> [    0.280565] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
> [    0.290514] ata1.00: configured for UDMA/66
> [    0.509974] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D  KCV9 PQ: 0 ANSI: 5
> [    0.513308] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
> [    0.513308] Uniform CD-ROM driver Revision: 3.20
> [    0.513308] sr 0:0:0:0: Attached scsi CD-ROM sr0
> [    0.513308] sr 0:0:0:0: Attached scsi generic sg0 type 5
> [    0.513308] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> [    0.513308] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
> [    0.519983] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [    0.520029] scsi2 : ata_piix
> [    0.520107] scsi3 : ata_piix
> [    0.520984] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
> [    0.520987] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
> [    0.539973] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
> [    0.539973] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [    0.543810] ata3.01: configured for UDMA/100
> [    0.553305] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 0081 PQ: 0 ANSI: 5
> [    0.553305] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> [    0.553305] sd 2:0:1:0: [sda] Write Protect is off
> [    0.553305] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
> [    0.553305] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.553305] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> [    0.553305] sd 2:0:1:0: [sda] Write Protect is off
> [    0.553305] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
> [    0.553305] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.553305]  sda: sda1 sda2 < sda5 >
> [    0.553305] sd 2:0:1:0: [sda] Attached SCSI disk
> [    0.553305] sd 2:0:1:0: Attached scsi generic sg1 type 0
> [    0.553305] usbcore: registered new interface driver usblcd
> [    0.553305] usbcore: registered new interface driver usbled
> [    0.553305] PNP: No PS/2 controller found. Probing ports directly.
> [    0.553305] i8042.c: No controller found.
> [    0.560048] mice: PS/2 mouse device common for all mice
> [    0.560112] applesmc: Apple MacBook Pro detected:
> [    0.560114] applesmc:  - Model with accelerometer
> [    0.560115] applesmc:  - Model with light sensors and backlight
> [    0.560117] applesmc:  - Model with 12 temperature sensors
> [    0.560665] applesmc: device has already been initialized (0xe0, 0x00).
> [    0.560667] applesmc: device successfully initialized.
> [    0.560866] applesmc: 2 fans found.
> [    0.561508] input: applesmc as /class/input/input1
> [    0.561570] Registered led device: smc::kbd_backlight
> [    0.561607] applesmc: driver successfully loaded.
> [    0.561675] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
> [    0.561677] EDAC MC: Ver: 2.1.0 Apr  1 2008
> [    0.561874] cpuidle: using governor ladder
> [    0.561876] cpuidle: using governor menu
> [    0.561912] usbcore: registered new interface driver hiddev
> [    0.561945] usbcore: registered new interface driver usbhid
> [    0.561948] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [    0.561983] Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
> [    0.561985] ALSA device list:
> [    0.561986]   No soundcards found.
> [    0.562041] oprofile: using NMI interrupt.
> [    0.562439] IPVS: Registered protocols (TCP, AH, ESP)
> [    0.562452] IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
> [    0.562472] IPVS: ipvs loaded.
> [    0.562473] Initializing XFRM netlink socket
> [    0.562485] NET: Registered protocol family 1
> [    0.562493] NET: Registered protocol family 17
> [    0.562497] NET: Registered protocol family 15
> [    0.562504] Starting balanced_irq
> [    0.562530] Using IPI No-Shortcut mode
> [    0.343320] kjournald starting.  Commit interval 5 seconds
> [    0.563305] EXT3-fs: mounted filesystem with ordered data mode.
> [    0.563305] VFS: Mounted root (ext3 filesystem) readonly.
> [    0.563305] Freeing unused kernel memory: 332k freed
> [    0.717700] SELinux:8192 avtab hash slots allocated. Num of rules:203526
> [    0.748552] SELinux:8192 avtab hash slots allocated. Num of rules:203526
> [    0.780144] security:  7 users, 7 roles, 2631 types, 89 bools
> [    0.780147] security:  69 classes, 203526 rules
> [    0.781474] SELinux:  Completing initialization.
> [    0.781476] SELinux:  Setting up existing superblocks.
> [    0.783291] SELinux: initialized (dev sda1, type ext3), uses xattr
> [    0.783291] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> [    0.783291] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> [    0.783291] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    0.783291] SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> [    0.783291] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> [    0.783291] SELinux: initialized (dev proc, type proc), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> [    0.783291] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> [    0.783606] SELinux: policy loaded with handle_unknown=deny
> [    0.783613] type=1403 audit(1207283387.446:2): policy loaded auid=4294967295 ses=4294967295
> [    0.956623] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    0.707038] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    0.958218] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    1.048272] power_supply ADP1: uevent
> [    1.048275] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
> [    1.048279] power_supply ADP1: Static prop TYPE=Mains
> [    1.048281] power_supply ADP1: 1 dynamic props
> [    1.048283] power_supply ADP1: prop ONLINE=1
> [    1.048299] power_supply BAT0: uevent
> [    1.048300] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
> [    1.048303] power_supply BAT0: Static prop TYPE=Battery
> [    1.048305] power_supply BAT0: 12 dynamic props
> [    1.748730] power_supply BAT0: prop STATUS=Full
> [    1.748735] power_supply BAT0: prop PRESENT=1
> [    1.748738] power_supply BAT0: prop TECHNOLOGY=Unknown
> [    1.748741] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
> [    1.748743] power_supply BAT0: prop VOLTAGE_NOW=12452000
> [    1.748746] power_supply BAT0: prop CURRENT_NOW=0
> [    1.748748] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
> [    1.748750] power_supply BAT0: prop ENERGY_FULL=53150000
> [    1.748753] power_supply BAT0: prop ENERGY_NOW=51380000
> [    1.748755] power_supply BAT0: prop MODEL_NAME=ASMB012
> [    1.748758] power_supply BAT0: prop MANUFACTURER=SMPN012
> [    1.748760] power_supply BAT0: prop SERIAL_NUMBER=
> [    2.259246] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
> [    2.259524] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
> [    2.961917] Monitor-Mwait will be used to enter C-1 state
> [    2.961921] Monitor-Mwait will be used to enter C-2 state
> [    2.961923] Monitor-Mwait will be used to enter C-3 state
> [    2.961985] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> [    2.962013] ACPI: ACPI0007:00 is registered as cooling_device0
> [    2.962018] ACPI: Processor [CPU0] (supports 8 throttling states)
> [    2.962360] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
> [    2.962570] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
> [    2.283458] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
> [    2.283478] ACPI: ACPI0007:01 is registered as cooling_device1
> [    2.283482] ACPI: Processor [CPU1] (supports 8 throttling states)
> [    2.978015] input: Power Button (FF) as /class/input/input2
> [    3.003200] ACPI: Power Button (FF) [PWRF]
> [    3.003267] input: Lid Switch as /class/input/input3
> [    3.003326] ACPI: Lid Switch [LID0]
> [    3.003373] input: Power Button (CM) as /class/input/input4
> [    3.042126] ACPI: Power Button (CM) [PWRB]
> [    3.042198] input: Sleep Button (CM) as /class/input/input5
> [    3.056493] ACPI: Sleep Button (CM) [SLPB]
> [    3.230052] Linux agpgart interface v0.103
> [    3.307976] USB Universal Host Controller Interface driver v3.0
> [    3.308018] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> [    3.308029] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [    3.308032] uhci_hcd 0000:00:1d.0: UHCI Host Controller
> [    3.308220] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
> [    3.308316] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
> [    3.308351] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
> [    3.308473] usb usb1: configuration #1 chosen from 1 choice
> [    3.308495] hub 1-0:1.0: USB hub found
> [    3.308501] hub 1-0:1.0: 2 ports detected
> [    3.387181] input: Video Bus as /class/input/input6
> [    3.409815] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    3.409999] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> [    3.410009] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [    3.410013] uhci_hcd 0000:00:1d.1: UHCI Host Controller
> [    3.410038] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
> [    3.410067] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
> [    3.410170] usb usb2: configuration #1 chosen from 1 choice
> [    3.410192] hub 2-0:1.0: USB hub found
> [    3.410198] hub 2-0:1.0: 2 ports detected
> [    3.513241] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> [    3.513252] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [    3.513256] uhci_hcd 0000:00:1d.2: UHCI Host Controller
> [    3.513279] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
> [    3.513313] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
> [    3.513418] usb usb3: configuration #1 chosen from 1 choice
> [    3.513440] hub 3-0:1.0: USB hub found
> [    3.513446] hub 3-0:1.0: 2 ports detected
> [    3.619190] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
> [    3.619201] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [    3.619204] uhci_hcd 0000:00:1d.3: UHCI Host Controller
> [    3.619228] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
> [    3.619261] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
> [    3.619367] usb usb4: configuration #1 chosen from 1 choice
> [    3.619390] hub 4-0:1.0: USB hub found
> [    3.619395] hub 4-0:1.0: 2 ports detected
> [    3.636455] usb 1-2: new full speed USB device using uhci_hcd and address 2
> [    3.651461] ath_hal: module license 'Proprietary' taints kernel.
> [    3.663223] ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133)
> [    3.683283] wlan: svn r3221
> [    3.711071] ath_pci: svn r3221
> [    3.719918] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> [    3.719932] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [    3.719935] ehci_hcd 0000:00:1d.7: EHCI Host Controller
> [    3.719961] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
> [    3.723823] ehci_hcd 0000:00:1d.7: debug port 1
> [    3.723829] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
> [    3.723836] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
> [    3.759627] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> [    3.759731] usb usb5: configuration #1 chosen from 1 choice
> [    3.759756] hub 5-0:1.0: USB hub found
> [    3.759762] hub 5-0:1.0: 8 ports detected
> [    3.853097] Marking TSC unstable due to: TSC halts in idle.
> [    3.183313] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
> [    3.867148] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> [    3.867171] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [    3.893921] hda_codec: STAC922x, Apple subsys_id=106b1e00
> [    3.234477] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
> [    3.931749] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> [    3.931762] PCI: Setting latency timer of device 0000:03:00.0 to 64
> [    4.061648] HAL returned 41 channels.
> [    4.061653] Channel   1 (2412 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061657] Channel   1 (2412 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061660] Channel   2 (2417 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061663] Channel   2 (2417 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061667] Channel   3 (2422 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061670] Channel   3 (2422 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061673] Channel   4 (2427 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061677] Channel   4 (2427 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061680] Channel   5 (2432 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061683] Channel   5 (2432 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061687] Channel   6 (2437 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061690] Channel   6 (2437 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061693] Channel   6 (2437 MHz) Max Tx Power 18 dBm (reg limited) [31 hw 18 reg] Flags CF_TURBO CF_OFDM CF_2GHZ
> [    4.061697] Channel   7 (2442 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061700] Channel   7 (2442 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061703] Channel   8 (2447 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061706] Channel   8 (2447 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061709] Channel   9 (2452 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061713] Channel   9 (2452 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061716] Channel  10 (2457 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061719] Channel  10 (2457 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061722] Channel  11 (2462 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_CCK CF_2GHZ
> [    4.061726] Channel  11 (2462 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_OFDM CF_2GHZ
> [    4.061729] Channel  36 (5180 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061732] Channel  40 (5200 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061736] Channel  42 (5210 MHz) Max Tx Power 15 dBm (reg limited) [31 hw 15 reg] Flags CF_TURBO CF_OFDM CF_5GHZ CF_STATIC_TURBO
> [    4.061739] Channel  44 (5220 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061742] Channel  48 (5240 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061746] Channel  50 (5250 MHz) Max Tx Power 15 dBm (reg limited) [31 hw 15 reg] Flags CF_TURBO CF_OFDM CF_5GHZ CF_PASSIVE_SCAN_ONLY CF_STATIC_TURBO PF_DFS_REQUIRED
> [    4.061750] Channel  52 (5260 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ CF_PASSIVE_SCAN_ONLY PF_DFS_REQUIRED
> [    4.061754] Channel  56 (5280 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ CF_PASSIVE_SCAN_ONLY PF_DFS_REQUIRED
> [    4.061758] Channel  58 (5290 MHz) Max Tx Power 18 dBm (reg limited) [31 hw 18 reg] Flags CF_TURBO CF_OFDM CF_5GHZ CF_PASSIVE_SCAN_ONLY CF_STATIC_TURBO PF_DFS_REQUIRED
> [    4.061762] Channel  60 (5300 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ CF_PASSIVE_SCAN_ONLY PF_DFS_REQUIRED
> [    4.061766] Channel  64 (5320 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ CF_PASSIVE_SCAN_ONLY PF_DFS_REQUIRED
> [    4.061769] Channel 149 (5745 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061773] Channel 152 (5760 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_TURBO CF_OFDM CF_5GHZ CF_STATIC_TURBO
> [    4.061776] Channel 153 (5765 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061779] Channel 157 (5785 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061783] Channel 160 (5800 MHz) Max Tx Power 20 dBm (reg limited) [31 hw 20 reg] Flags CF_TURBO CF_OFDM CF_5GHZ CF_STATIC_TURBO
> [    4.061786] Channel 161 (5805 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061790] Channel 165 (5825 MHz) Max Tx Power 30 dBm (reg limited) [31 hw 30 reg] Flags CF_OFDM CF_5GHZ
> [    4.061792] ath_pci: switching rfkill capability off
> [    4.080224] ath_rate_sample: 1.2 (svn r3221)
> [    4.080224] ath_pci: switching per-packet transmit power control off
> [    4.080224] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> [    4.080224] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
> [    4.080224] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> [    4.080224] wifi0: turboA rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> [    4.080224] wifi0: turboG rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
> [    4.080224] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
> [    4.080224] wifi0: mac 12.10 phy 8.1 radio 12.0
> [    4.080224] wifi0: Use hw queue 1 for WME_AC_BE traffic
> [    4.080224] wifi0: Use hw queue 0 for WME_AC_BK traffic
> [    4.080224] wifi0: Use hw queue 2 for WME_AC_VI traffic
> [    4.080224] wifi0: Use hw queue 3 for WME_AC_VO traffic
> [    4.080224] wifi0: Use hw queue 8 for CAB traffic
> [    4.080224] wifi0: Use hw queue 9 for beacons
> [    4.113529] wifi0: Atheros 5418: mem=0x50100000, irq=17
> [    4.258239] usb 1-2: device not accepting address 2, error -71
> [    4.268120] Clocksource tsc unstable (delta = -146744094 ns)
> [    4.717932] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> [    4.446532] usb 5-4: new high speed USB device using ehci_hcd and address 3
> [    5.177113] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
> [    5.254452] usb 5-4: configuration #1 chosen from 1 choice
> [    5.019550] usbcore: registered new interface driver appletouch
> [    5.792179] Symbol init_mm is marked as UNUSED, however this module is using it.
> [    5.792183] This symbol will go away in the future.
> [    5.792185] Please evalute if this is the right api to use, and if it really is, submit a report the linux kernel mailinglist together with submitting your code for inclusion.
> [    5.808566] [fglrx] Maximum main memory to use for locked dma buffers: 913 MBytes.
> [    5.808594] [fglrx] ASYNCIO init succeed!
> [    5.810559] [fglrx] PAT is enabled successfully!
> [    5.810581] [fglrx] module loaded - fglrx 8.47.3 [Feb 25 2008] on minor 0
> [    5.925496] usb 1-2: new full speed USB device using uhci_hcd and address 4
> [    5.991088] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
> [    5.991091] intelfb: Version 0.9.4
> [    6.039295] Console: switching to colour frame buffer device 128x48
> [    6.087454] ip_tables: (C) 2000-2006 Netfilter Core Team
> [    5.413970] usb 1-2: configuration #1 chosen from 1 choice
> [    5.420713] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input7
> [    5.445334] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> [    5.450550] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> [    6.137835] appletouch: Geyser mode initialized.
> [    6.137893] input: appletouch as /class/input/input8
> [    6.155056] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input9
> [    6.155056] arp_tables: (C) 2002 David S. Miller
> [    6.155464] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> [    6.212641] ieee80211_crypt: registered algorithm 'NULL'
> [    6.215127] ieee80211_crypt: registered algorithm 'TKIP'
> [    6.343049] Adding 2988048k swap on /dev/disk/by-uuid/c58cdc7c-b94b-4116-9cca-bf154269e4d8.  Priority:-1 extents:1 across:2988048k
> [    6.391922] usb 3-2: new full speed USB device using uhci_hcd and address 2
> [    5.741741] EXT3 FS on sda1, internal journal
> [    6.565336] usb 3-2: configuration #1 chosen from 1 choice
> [    5.900025] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2
> [    6.132611] usb 4-1: new full speed USB device using uhci_hcd and address 2
> [    6.324999] usb 4-1: configuration #1 chosen from 1 choice
> [    7.019276] input: HID 05ac:1000 as /class/input/input10
> [    7.046429] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> [    7.065228] input: HID 05ac:1000 as /class/input/input11
> [    7.086132] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> [    6.416101] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
> [    6.418848] uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
> [    6.419743] input: Built-in iSight as /class/input/input12
> [    6.446317] usbcore: registered new interface driver uvcvideo
> [    6.446323] USB Video Class driver (SVN r198)
> [    7.809391] usb 5-4: USB disconnect, address 3
> [    9.060971] appletouch: incomplete data package (first byte: 2, length: 4).
> [    9.539766] usb 5-4: new high speed USB device using ehci_hcd and address 6
> [    9.641888] usb 5-4: configuration #1 chosen from 1 choice
> [    9.642174] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
> [    9.644653] uvcvideo: Failed to query (135) UVC control 1 (unit 0) : -32 (exp. 26).
> [    9.645339] input: Built-in iSight as /class/input/input13
> [   10.138778] input: Pommed beeper device as /class/input/input14
> [   10.241566] Bluetooth: Core ver 2.11
> [   10.243725] NET: Registered protocol family 31
> [   10.243728] Bluetooth: HCI device and connection manager initialized
> [   10.243731] Bluetooth: HCI socket layer initialized
> [   10.299125] Bluetooth: L2CAP ver 2.9
> [   10.299125] Bluetooth: L2CAP socket layer initialized
> [    9.675457] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> [    9.694644] usb 4-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 64 rq 0 len 0 ret -84
> [   10.354197] Bluetooth: RFCOMM socket layer initialized
> [   10.354776] Bluetooth: RFCOMM TTY layer initialized
> [   10.354779] Bluetooth: RFCOMM ver 1.8
> [   10.589269] usb 4-1: USB disconnect, address 2
> [   10.824926] usb 4-1: new full speed USB device using uhci_hcd and address 3
> [   11.015363] usb 4-1: configuration #1 chosen from 1 choice
> [   11.086051] Bluetooth: HCI USB driver ver 2.9
> [   11.089237] usbcore: registered new interface driver hci_usb
> [   10.603936] CPU0 attaching NULL sched-domain.
> [   10.603942] CPU1 attaching NULL sched-domain.
> [   10.613659] CPU0 attaching sched-domain:
> [   10.613663]  domain 0: span 3
> [   10.613665]   groups: 1 2
> [   10.613668]   domain 1: span 3
> [   10.613669]    groups: 3
> [   10.613672] CPU1 attaching sched-domain:
> [   10.613673]  domain 0: span 3
> [   10.613675]   groups: 2 1
> [   10.613677]   domain 1: span 3
> [   10.613678]    groups: 3
> [   16.099935] input: Apple Computer, Inc. Mighty Mouse as /class/input/input15
> [   20.975690] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [   23.378169] [fglrx] Reserve Block - 0 offset =  0X7ffb000 length = 0X5000
> [   23.378175] [fglrx] Reserve Block - 1 offset =  0X0 length = 0X1000000
> [   23.378177] [fglrx] Reserve Block - 2 offset =  0X7fbb000 length = 0X40000
> [   24.167068] [fglrx] interrupt source 20008000 successfully enabled
> [   24.167068] [fglrx] enable ID = 0x00000008
> [   24.167068] [fglrx] Receive enable interrupt message with irqEnableMask: 20008000
> [   24.167068] [fglrx] interrupt source 10000000 successfully enabled
> [   24.167068] [fglrx] enable ID = 0x00000009
> [   24.167068] [fglrx] Receive enable interrupt message with irqEnableMask: 10000000
> [  144.557848] applesmc: wait status failed: 5 != 4
> [  144.358566] applesmc: wait status failed: c != 8
> [  144.409864] PM: Syncing filesystems ... done.
> [  145.650031] Freezing user space processes ... (elapsed 0.11 seconds) done.
> [  145.764634] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
> [  145.764693] Suspending console(s)
> [  145.829398] sd 2:0:1:0: [sda] Synchronizing SCSI cache
> [  145.829602] sd 2:0:1:0: [sda] Stopping disk
> [  146.795569] ACPI: PCI interrupt for device 0000:03:00.0 disabled
> [  146.808867] [fglrx] firegl_gps_setpowerdown .
> [  146.840196] ACPI: PCI interrupt for device 0000:01:00.0 disabled
> [  146.840417] ACPI: PCI interrupt for device 0000:00:1f.2 disabled
> [  146.852207] ACPI: PCI interrupt for device 0000:00:1f.1 disabled
> [  146.852379] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
> [  146.865455] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
> [  146.865501] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
> [  146.865547] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
> [  146.865591] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
> [  146.865795] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
> [  146.880615] ACPI: Preparing to enter system sleep state S3
> [  146.881357] Disabling non-boot CPUs ...
> [  146.881373] CPU0 attaching NULL sched-domain.
> [  146.881377] CPU1 attaching NULL sched-domain.
> [  146.992026] CPU 1 is now offline
> [  146.992031] SMP alternatives: switching to UP code
> [  146.993980] CPU0 attaching sched-domain:
> [  146.993984]  domain 0: span 1
> [  146.993987]   groups: 1
> [  146.994265] CPU1 is down
> [  146.994265] Intel machine check architecture supported.
> [  146.994271] Intel machine check reporting enabled on CPU#0.
> [  146.994309] Back to C!
> [  146.995386] Enabling non-boot CPUs ...
> [  146.995451] CPU0 attaching NULL sched-domain.
> [  146.995560] SMP alternatives: switching to SMP code
> [  146.998683] Booting processor 1/1 ip 4000
> [  147.295547] Initializing CPU#1
> [  147.295547] masked ExtINT on CPU#1
> [  147.295547] Calibrating delay using timer specific routine.. 4324.69 BogoMIPS (lpj=7204309)
> [  147.295547] CPU: L1 I cache: 32K, L1 D cache: 32K
> [  147.295547] CPU: L2 cache: 4096K
> [  147.295547] CPU: Physical Processor ID: 0
> [  147.295547] CPU: Processor Core ID: 1
> [  147.295547] Intel machine check architecture supported.
> [  147.295547] Intel machine check reporting enabled on CPU#1.
> [  147.092674] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
> [  147.092726] CPU0 attaching sched-domain:
> [  147.092729]  domain 0: span 3
> [  147.092730]   groups: 1 2
> [  147.092732]   domain 1: span 3
> [  147.092734]    groups: 3
> [  147.092736] CPU1 attaching sched-domain:
> [  147.092737]  domain 0: span 3
> [  147.092738]   groups: 2 1
> [  147.092740]   domain 1: span 3
> [  147.092742]    groups: 3
> [  147.295547] CPU1 is up
> [  147.295552] Switched to NOHz mode on CPU #1
> [  147.792197] ACPI: EC: missing OBF confirmation, don't expect it any longer.
> [  148.292164] ACPI: EC: missing write data confirmation, don't expect it any longer.
> [  148.601213] PM: Writing back config space on device 0000:00:01.0 at offset f (was 80100, writing 8010b)
> [  148.601225] PM: Writing back config space on device 0000:00:01.0 at offset a (was f, writing 0)
> [  148.601232] PM: Writing back config space on device 0000:00:01.0 at offset 9 (was 1fff1, writing 47f14001)
> [  148.601239] PM: Writing back config space on device 0000:00:01.0 at offset 8 (was fff0, writing 50305030)
> [  148.601246] PM: Writing back config space on device 0000:00:01.0 at offset 7 (was f0, writing 3030)
> [  148.601253] PM: Writing back config space on device 0000:00:01.0 at offset 6 (was 0, writing 10100)
> [  148.601261] PM: Writing back config space on device 0000:00:01.0 at offset 3 (was 10000, writing 10040)
> [  148.601269] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100000, writing 100007)
> [  148.601300] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
> [  148.601309] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [  148.601320] PM: Writing back config space on device 0000:00:07.0 at offset f (was 100, writing 10b)
> [  148.601337] PM: Writing back config space on device 0000:00:07.0 at offset 4 (was 0, writing 50404000)
> [  148.601346] PM: Writing back config space on device 0000:00:07.0 at offset 1 (was b00000, writing b00002)
> [  148.612161] PM: Writing back config space on device 0000:00:1b.0 at offset f (was 100, writing 10a)
> [  148.612187] PM: Writing back config space on device 0000:00:1b.0 at offset 4 (was 4, writing 50400004)
> [  148.612196] PM: Writing back config space on device 0000:00:1b.0 at offset 3 (was 0, writing 40)
> [  148.612206] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100000, writing 100002)
> [  148.612236] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
> [  148.612247] PCI: Setting latency timer of device 0000:00:1b.0 to 64
> [  148.612295] PM: Writing back config space on device 0000:00:1c.0 at offset 9 (was 10001, writing 50515051)
> [  148.612304] PM: Writing back config space on device 0000:00:1c.0 at offset 8 (was 0, writing 50205020)
> [  148.612312] PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was 20000000, writing 2020)
> [  148.612326] PM: Writing back config space on device 0000:00:1c.0 at offset 3 (was 810000, writing 810040)
> [  148.612336] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100000, writing 100007)
> [  148.612388] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
> [  148.612397] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [  148.612429] PM: Writing back config space on device 0000:00:1c.1 at offset 9 (was 10001, writing 1fff1)
> [  148.612438] PM: Writing back config space on device 0000:00:1c.1 at offset 8 (was 0, writing 50105010)
> [  148.612447] PM: Writing back config space on device 0000:00:1c.1 at offset 7 (was 20000000, writing 200000f0)
> [  148.612460] PM: Writing back config space on device 0000:00:1c.1 at offset 3 (was 810000, writing 810040)
> [  148.612471] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100000, writing 100007)
> [  148.612522] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
> [  148.612531] PCI: Setting latency timer of device 0000:00:1c.1 to 64
> [  148.612563] PM: Writing back config space on device 0000:00:1c.2 at offset 9 (was 10001, writing 4bf14801)
> [  148.612572] PM: Writing back config space on device 0000:00:1c.2 at offset 8 (was 0, writing 50004c10)
> [  148.612580] PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was 20000000, writing 1010)
> [  148.612594] PM: Writing back config space on device 0000:00:1c.2 at offset 3 (was 810000, writing 810040)
> [  148.612604] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100000, writing 100007)
> [  148.612656] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
> [  148.612664] PCI: Setting latency timer of device 0000:00:1c.2 to 64
> [  148.612675] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
> [  148.612686] PCI: Setting latency timer of device 0000:00:1d.0 to 64
> [  148.612748] usb usb1: root hub lost power or was reset
> [  148.612777] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
> [  148.612787] PCI: Setting latency timer of device 0000:00:1d.1 to 64
> [  148.612848] usb usb2: root hub lost power or was reset
> [  148.612871] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
> [  148.612881] PCI: Setting latency timer of device 0000:00:1d.2 to 64
> [  148.612942] usb usb3: root hub lost power or was reset
> [  148.612969] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
> [  148.612979] PCI: Setting latency timer of device 0000:00:1d.3 to 64
> [  148.613041] usb usb4: root hub lost power or was reset
> [  148.625479] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
> [  148.625490] PCI: Setting latency timer of device 0000:00:1d.7 to 64
> [  148.625572] PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was 10001, writing 1fff1)
> [  148.625580] PM: Writing back config space on device 0000:00:1e.0 at offset 8 (was 0, writing 4c004c00)
> [  148.625589] PM: Writing back config space on device 0000:00:1e.0 at offset 7 (was 22800000, writing 228000f0)
> [  148.625606] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100000, writing 100007)
> [  148.625635] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [  148.625704] PM: Writing back config space on device 0000:00:1f.1 at offset f (was 100, writing 10b)
> [  148.625736] PM: Writing back config space on device 0000:00:1f.1 at offset 1 (was 2800001, writing 2800005)
> [  148.625750] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
> [  148.625759] PCI: Setting latency timer of device 0000:00:1f.1 to 64
> [  148.638818] PM: Writing back config space on device 0000:00:1f.2 at offset f (was 200, writing 20b)
> [  148.638851] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00003, writing 2b00007)
> [  148.638875] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> [  148.638885] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [  148.642171] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [  148.642181] PCI: Setting latency timer of device 0000:01:00.0 to 64
> [  148.651132] [fglrx] firegl_gps_setpowerup .
> [  148.656530] PM: Writing back config space on device 0000:02:00.0 at offset f (was 100, writing 10b)
> [  148.656545] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing fffe0000)
> [  148.656567] PM: Writing back config space on device 0000:02:00.0 at offset 6 (was 1, writing 2001)
> [  148.656579] PM: Writing back config space on device 0000:02:00.0 at offset 4 (was 4, writing 50200004)
> [  148.656588] PM: Writing back config space on device 0000:02:00.0 at offset 3 (was 0, writing 40)
> [  148.656600] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 40100000, writing 100007)
> [  148.668840] PM: Writing back config space on device 0000:03:00.0 at offset f (was 1ff, writing 10a)
> [  148.668874] PM: Writing back config space on device 0000:03:00.0 at offset 4 (was 4, writing 50100004)
> [  148.668884] PM: Writing back config space on device 0000:03:00.0 at offset 3 (was 0, writing 40)
> [  148.668896] PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 100000, writing 100007)
> [  148.668941] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> [  148.668952] PCI: Setting latency timer of device 0000:03:00.0 to 64
> [  148.685507] PM: Writing back config space on device 0000:0c:03.0 at offset 5 (was 0, writing 4c000000)
> [  148.685516] PM: Writing back config space on device 0000:0c:03.0 at offset 4 (was 0, writing 4c004000)
> [  148.685525] PM: Writing back config space on device 0000:0c:03.0 at offset 3 (was 0, writing f810)
> [  148.685537] PM: Writing back config space on device 0000:0c:03.0 at offset 1 (was 2100000, writing 2100016)
> [  148.736588] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
> [  148.740881] sd 2:0:1:0: [sda] Starting disk
> [  148.708902] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
> [  148.708908] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
> [  148.722524] ata3.01: configured for UDMA/100
> [  148.939395] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> [  148.939401] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
> [  148.731368] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> [  148.731393] sd 2:0:1:0: [sda] Write Protect is off
> [  148.731397] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
> [  148.731433] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [  148.731664] applesmc: device has already been initialized (0xe0, 0x00).
> [  149.105985] ata1.00: configured for UDMA/66
> [  148.962313] Restarting tasks ... <6>usb 1-2: USB disconnect, address 4
> [  149.003406] done.
> [  149.068591] Buffer I/O error on device sr0, logical block 356490
> [  149.068601] Buffer I/O error on device sr0, logical block 356491
> [  149.068606] Buffer I/O error on device sr0, logical block 356492
> [  149.068612] Buffer I/O error on device sr0, logical block 356493
> [  149.068617] Buffer I/O error on device sr0, logical block 356494
> [  149.068621] Buffer I/O error on device sr0, logical block 356495
> [  149.068627] Buffer I/O error on device sr0, logical block 356496
> [  149.068632] Buffer I/O error on device sr0, logical block 356497
> [  149.068637] Buffer I/O error on device sr0, logical block 356498
> [  149.068642] Buffer I/O error on device sr0, logical block 356499
> [  149.135499] input: appletouch disconnected
> [  149.325200] usb 1-2: new full speed USB device using uhci_hcd and address 5
> [  149.358524] usb 1-2: configuration #1 chosen from 1 choice
> [  149.365428] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input16
> [  149.371879] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> [  149.376222] appletouch: Geyser mode initialized.
> [  149.376267] input: appletouch as /class/input/input17
> [  149.379214] appletouch: incomplete data package (first byte: 2, length: 4).
> [  149.384253] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input18
> [  149.388556] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> [  149.391464] usb 3-2: USB disconnect, address 2
> [  149.591643] usb 3-2: new full speed USB device using uhci_hcd and address 3
> [  149.761008] usb 3-2: configuration #1 chosen from 1 choice
> [  149.767228] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2
> [  149.767228] usb 4-1: USB disconnect, address 3
> [  150.390816] usb 4-1: new full speed USB device using uhci_hcd and address 4
> [  150.874557] usb 4-1: new full speed USB device using uhci_hcd and address 5
> [  151.045882] usb 4-1: configuration #1 chosen from 1 choice
> [  151.072274] input: HID 05ac:1000 as /class/input/input19
> [  151.074648] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> [  151.089934] input: HID 05ac:1000 as /class/input/input20
> [  151.089934] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> [  153.773933] printk: 1322 messages suppressed.
> [  153.773943] Buffer I/O error on device sr0, logical block 357112
> 
> 
