Return-Path: <linux-kernel-owner+w=401wt.eu-S1945978AbXBPQVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945978AbXBPQVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 11:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945979AbXBPQVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 11:21:24 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:4585 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945978AbXBPQVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 11:21:22 -0500
Date: Fri, 16 Feb 2007 17:21:14 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Alan <alan@lxorguk.ukuu.org.uk>
Subject: pata_amd dropping to PIO on resume
Message-ID: <20070216162114.GA7857@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Linux Kernel ML <linux-kernel@vger.kernel.org>,
	linux-ide@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Possibly a known issue:

After resume pata_amd drops from UDMA/33 to PIO on my system.
Reloading the module puts both attached optical drives (master and
slave) back to UDMA/33.

AFAICS "simplex DMA is claimed by other device, disabling DMA" seems
to be causing it to drop to PIO (but only after a suspend/resume
cycle, not on boot or module load).

Burning a DVD with 6x speed using PIO makes heavy use of burnproof
and makes the whole system quite sluggish. :)

[    0.000000] Linux version 2.6.20-amd64 (ranma@melchior) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #63 Sun Feb 11 10:58:36 CET 2007
[    0.000000] Command line: root=/dev/sda5 resume=/dev/sda6 vga=6 apic=verbose netconsole=@192.168.8.241/,514@255.255.255.255/ ro
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fee0000 (usable)
[    0.000000]  BIOS-e820: 000000003fee0000 - 000000003fee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fee3000 - 000000003fef0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003fef0000 - 000000003ff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 261856) 1 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP (v002 Nvidia                                ) @ 0x00000000000f7b70
[    0.000000] ACPI: XSDT (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003fee30c0
[    0.000000] ACPI: FADT (v003 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003feec5c0
[    0.000000] ACPI: SSDT (v001 PTLTD  POWERNOW 0x00000001  LTP 0x00000001) @ 0x000000003feec7c0
[    0.000000] ACPI: HPET (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000098) @ 0x000000003feec900
[    0.000000] ACPI: MCFG (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003feec980
[    0.000000] ACPI: MADT (v001 Nvidia ASUSACPI 0x42302e31 AWRD 0x00000000) @ 0x000000003feec700
[    0.000000] ACPI: DSDT (v001 NVIDIA AWRDACPI 0x00001000 MSFT 0x03000000) @ 0x0000000000000000
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 261856) 1 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   261856
[    0.000000] On node 0 totalpages: 261759
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1338 pages reserved
[    0.000000]   DMA zone: 2605 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3524 pages used for memmap
[    0.000000]   DMA32 zone: 254236 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] mapped APIC to ffffffffff5fd000 (        fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fc000 (00000000fec00000)
[    0.000000] Nosave address range: 000000000009f000 - 00000000000a0000
[    0.000000] Nosave address range: 00000000000a0000 - 00000000000f0000
[    0.000000] Nosave address range: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3ff00000:b0100000)
[    0.000000] Built 1 zonelists.  Total pages: 256841
[    0.000000] Kernel command line: root=/dev/sda5 resume=/dev/sda6 vga=6 apic=verbose netconsole=@192.168.8.241/,514@255.255.255.255/ ro
[    0.000000] netconsole: local port 6665
[    0.000000] netconsole: local IP 192.168.8.241
[    0.000000] netconsole: interface eth0
[    0.000000] netconsole: remote port 514
[    0.000000] netconsole: remote IP 255.255.255.255
[    0.000000] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   24.288641] time.c: Using 25.000000 MHz WALL HPET GTOD HPET/TSC timer.
[   24.288644] time.c: Detected 2009.259 MHz processor.
[   24.294154] Console: colour VGA+ 80x60
[   24.296776] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   24.297614] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   24.297857] Checking aperture...
[   24.297966] CPU 0: aperture @ b0ca000000 size 32 MB
[   24.298073] Aperture too small (32 MB)
[   24.302864] No AGP bridge found
[   24.310527] Memory: 1025428k/1047424k available (3185k kernel code, 21364k reserved, 1446k data, 200k init)
[   24.392078] Calibrating delay using timer specific routine.. 4023.48 BogoMIPS (lpj=6703172)
[   24.392325] Mount-cache hash table entries: 256
[   24.392502] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[   24.392611] CPU: L2 Cache: 512K (64 bytes/line)
[   24.392736] CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 02
[   24.392889] ACPI: Core revision 20060707
[   24.395352] ACPI (tbget-0289): Table [DSDT] replaced by host OS [20060707]
[   24.401100] enabled ExtINT on CPU#0
[   24.401207] ESR value after enabling vector: 00000000, after 00000004
[   24.401543] ENABLING IO-APIC IRQs
[   24.401650] init IO_APIC IRQs
[   24.401652]  IO-APIC (apicid-pin) 2-0, 2-16, 2-17, 2-18, 2-19, 2-20, 2-21, 2-22, 2-23 not connected.
[   24.401848] ..TIMER: vector=0x20 apic1=0 pin1=2 apic2=-1 pin2=-1
[   24.434946] Using local APIC timer interrupts.
[   24.484761] result 12557887
[   24.484867] Detected 12.557 MHz APIC timer.
[   24.485290] testing NMI watchdog ... OK.
[   24.518570] NET: Registered protocol family 16
[   24.518739] ACPI: bus type pci registered
[   24.521493] PCI: Using MMCONFIG at f0000000
[   24.521620] PCI: No mmconfig possible on device 00:18
[   24.531607] ACPI: Interpreter enabled
[   24.531717] ACPI: Using IOAPIC for interrupt routing
[   24.532449] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   24.532560] PCI: Probing PCI hardware (bus 00)
[   24.535027] PCI: Transparent bridge - 0000:00:06.0
[   24.535485] Boot video device is 0000:07:00.0
[   24.535558] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   24.657903] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[   24.660295] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 *10 11 14 15)
[   24.661027] ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
[   24.661766] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 *11 14 15)
[   24.662493] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.663346] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.664201] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 *7 9 10 11 14 15)
[   24.664933] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 *11 14 15)
[   24.665667] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.666520] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.667374] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 *10 11 14 15)
[   24.668106] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
[   24.668855] ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 *10 11 14 15)
[   24.669586] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[   24.670332] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.671185] ACPI: PCI Interrupt Link [LSMB] (IRQs *5 7 9 10 11 14 15)
[   24.671943] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 *11 14 15)
[   24.672676] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.673528] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.674381] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.675242] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[   24.676176] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[   24.676897] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[   24.677619] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[   24.678339] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[   24.679066] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[   24.679786] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[   24.680510] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[   24.681231] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[   24.681962] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[   24.682745] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
[   24.683528] ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0, disabled.
[   24.684310] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[   24.685098] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
[   24.685883] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[   24.686666] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[   24.687448] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[   24.688231] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[   24.689023] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
[   24.689805] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
[   24.690588] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0, disabled.
[   24.693822] Linux Plug and Play Support v0.97 (c) Adam Belay
[   24.693936] pnp: PnP ACPI init
[   24.699645] IOAPIC[0]: Set PCI routing entry (2-8 -> 0x28 -> IRQ 8 Mode:0 Active:0)
[   24.699820] IOAPIC[0]: Set PCI routing entry (2-13 -> 0x2d -> IRQ 13 Mode:0 Active:0)
[   24.700821] IOAPIC[0]: Set PCI routing entry (2-4 -> 0x24 -> IRQ 4 Mode:0 Active:0)
[   24.702557] pnp: PnP ACPI: found 11 devices
[   24.702755] SCSI subsystem initialized
[   24.702881] libata version 2.00 loaded.
[   24.702918] usbcore: registered new interface driver usbfs
[   24.703046] usbcore: registered new interface driver hub
[   24.703176] usbcore: registered new device driver usb
[   24.703323] PCI: Using ACPI for IRQ routing
[   24.703433] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   24.703627] number of MP IRQ sources: 15.
[   24.703629] number of IO-APIC #2 registers: 24.
[   24.703631] testing the IO APIC.......................
[   24.703743] 
[   24.703848] IO APIC #2......
[   24.703850] .... register #00: 02000000
[   24.703852] .......    : physical APIC id: 02
[   24.703854] .... register #01: 00170011
[   24.703856] .......     : max redirection entries: 0017
[   24.703857] .......     : PRQ implemented: 0
[   24.703859] .......     : IO APIC version: 0011
[   24.703861] .... register #02: 02000000
[   24.703863] .......     : arbitration: 02
[   24.703864] .... IRQ redirection table:
[   24.703866]  NR Log Phy Mask Trig IRR Pol Stat Dest Deli Vect:   
[   24.703871]  00 000 00  1    0    0   0   0    0    0    00
[   24.703878]  01 001 01  0    0    0   0   0    1    1    21
[   24.703884]  02 001 01  0    0    0   0   0    1    1    20
[   24.703891]  03 001 01  0    0    0   0   0    1    1    23
[   24.703897]  04 001 01  1    0    0   0   0    1    1    24
[   24.703903]  05 001 01  1    0    0   0   0    1    1    25
[   24.703910]  06 001 01  0    0    0   0   0    1    1    26
[   24.703916]  07 001 01  1    0    0   0   0    1    1    27
[   24.703922]  08 001 01  1    0    0   0   0    1    1    28
[   24.703929]  09 001 01  0    1    0   0   0    1    1    29
[   24.703935]  0a 001 01  1    0    0   0   0    1    1    2A
[   24.703942]  0b 001 01  1    0    0   0   0    1    1    2B
[   24.703948]  0c 001 01  0    0    0   0   0    1    1    2C
[   24.703954]  0d 001 01  1    0    0   0   0    1    1    2D
[   24.703961]  0e 001 01  0    0    0   0   0    1    1    2E
[   24.703967]  0f 001 01  0    0    0   0   0    1    1    2F
[   24.703973]  10 000 00  1    0    0   0   0    0    0    00
[   24.703980]  11 000 00  1    0    0   0   0    0    0    00
[   24.703986]  12 000 00  1    0    0   0   0    0    0    00
[   24.703992]  13 000 00  1    0    0   0   0    0    0    00
[   24.703998]  14 000 00  1    0    0   0   0    0    0    00
[   24.704004]  15 000 00  1    0    0   0   0    0    0    00
[   24.704011]  16 000 00  1    0    0   0   0    0    0    00
[   24.704017]  17 000 00  1    0    0   0   0    0    0    00
[   24.704020] IRQ to pin mappings:
[   24.704021] IRQ0 -> 0:2
[   24.704023] IRQ1 -> 0:1
[   24.704025] IRQ3 -> 0:3
[   24.704026] IRQ4 -> 0:4
[   24.704028] IRQ5 -> 0:5
[   24.704030] IRQ6 -> 0:6
[   24.704031] IRQ7 -> 0:7
[   24.704033] IRQ8 -> 0:8
[   24.704035] IRQ9 -> 0:9
[   24.704036] IRQ10 -> 0:10
[   24.704038] IRQ11 -> 0:11
[   24.704040] IRQ12 -> 0:12
[   24.704042] IRQ13 -> 0:13
[   24.704044] IRQ14 -> 0:14
[   24.704045] IRQ15 -> 0:15
[   24.704048] .................................... done.
[   24.801570] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[   24.801758] hpet0: 3 32-bit timers, 25000000 Hz
[   24.803395] pnp: 00:01: ioport range 0x1000-0x107f could not be reserved
[   24.803504] pnp: 00:01: ioport range 0x1080-0x10ff has been reserved
[   24.803613] pnp: 00:01: ioport range 0x1400-0x147f has been reserved
[   24.803721] pnp: 00:01: ioport range 0x1480-0x14ff could not be reserved
[   24.803830] pnp: 00:01: ioport range 0x1800-0x187f has been reserved
[   24.803938] pnp: 00:01: ioport range 0x1880-0x18ff has been reserved
[   24.804236] PCI: Bridge: 0000:00:06.0
[   24.804343]   IO window: d000-dfff
[   24.804451]   MEM window: fde00000-fdefffff
[   24.804559]   PREFETCH window: 40000000-400fffff
[   24.804666] PCI: Bridge: 0000:00:0a.0
[   24.804773]   IO window: disabled.
[   24.804879]   MEM window: disabled.
[   24.804992]   PREFETCH window: disabled.
[   24.805099] PCI: Bridge: 0000:00:0b.0
[   24.805205]   IO window: disabled.
[   24.805312]   MEM window: disabled.
[   24.805418]   PREFETCH window: disabled.
[   24.805525] PCI: Bridge: 0000:00:0c.0
[   24.805631]   IO window: disabled.
[   24.805738]   MEM window: disabled.
[   24.805845]   PREFETCH window: disabled.
[   24.805951] PCI: Bridge: 0000:00:0d.0
[   24.806058]   IO window: disabled.
[   24.806165]   MEM window: disabled.
[   24.806271]   PREFETCH window: disabled.
[   24.806379] PCI: Bridge: 0000:00:0e.0
[   24.806486]   IO window: b000-cfff
[   24.806593]   MEM window: fdd00000-fddfffff
[   24.806700]   PREFETCH window: disabled.
[   24.806807] PCI: Bridge: 0000:00:0f.0
[   24.806914]   IO window: a000-afff
[   24.807022]   MEM window: fdc00000-fdcfffff
[   24.807129]   PREFETCH window: e8000000-efffffff
[   24.807241] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   24.807247] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   24.807251] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   24.807256] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   24.807261] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   24.807265] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   24.807270] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   24.807288] NET: Registered protocol family 2
[   24.834882] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   24.835191] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   24.835856] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   24.842108] TCP: Hash tables configured (established 131072 bind 65536)
[   24.842216] TCP reno registered
[   24.852114] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   24.852354] JFFS2 version 2.2. (NAND) (C) 2001-2006 Red Hat, Inc.
[   24.852497] fuse init (API version 7.8)
[   24.852673] io scheduler noop registered
[   24.852800] io scheduler anticipatory registered
[   24.852927] io scheduler deadline registered
[   24.853061] io scheduler cfq registered (default)
[   24.865671] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   24.865684] assign_interrupt_mode Found MSI capability
[   24.865807] Allocate Port Service[0000:00:0a.0:pcie00]
[   24.865835] Allocate Port Service[0000:00:0a.0:pcie03]
[   24.865873] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   24.865886] assign_interrupt_mode Found MSI capability
[   24.866002] Allocate Port Service[0000:00:0b.0:pcie00]
[   24.866023] Allocate Port Service[0000:00:0b.0:pcie03]
[   24.866061] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   24.866073] assign_interrupt_mode Found MSI capability
[   24.866189] Allocate Port Service[0000:00:0c.0:pcie00]
[   24.866210] Allocate Port Service[0000:00:0c.0:pcie03]
[   24.866246] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   24.866259] assign_interrupt_mode Found MSI capability
[   24.866374] Allocate Port Service[0000:00:0d.0:pcie00]
[   24.866396] Allocate Port Service[0000:00:0d.0:pcie03]
[   24.866436] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   24.866448] assign_interrupt_mode Found MSI capability
[   24.866563] Allocate Port Service[0000:00:0e.0:pcie00]
[   24.866585] Allocate Port Service[0000:00:0e.0:pcie03]
[   24.866622] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   24.866634] assign_interrupt_mode Found MSI capability
[   24.866749] Allocate Port Service[0000:00:0f.0:pcie00]
[   24.866773] Allocate Port Service[0000:00:0f.0:pcie03]
[   24.866945] input: Power Button (FF) as /class/input/input0
[   24.867053] ACPI: Power Button (FF) [PWRF]
[   24.867211] input: Power Button (CM) as /class/input/input1
[   24.867319] ACPI: Power Button (CM) [PWRB]
[   24.867449] ACPI: Fan [FAN] (on)
[   24.867603] ACPI: Processor [CPU0] (supports 8 throttling states)
[   24.868761] ACPI: Thermal Zone [THRM] (23 C)
[   24.870244] Real Time Clock Driver v1.12ac
[   24.870509] hpet_resources: 0xfefff000 is busy
[   24.870515] Linux agpgart interface v0.101 (c) Dave Jones
[   24.870799] loop: loaded (max 8 devices)
[   24.870979] tun: Universal TUN/TAP device driver, 1.6
[   24.871086] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   24.871217] netconsole: eth0 doesn't exist, aborting.
[   24.871406] ahci 0000:06:00.0: version 2.0
[   24.871965] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[   24.872076] IOAPIC[0]: Set PCI routing entry (2-16 -> 0x69 -> IRQ 16 Mode:1 Active:1)
[   24.872082] ACPI: PCI Interrupt 0000:06:00.0[A] -> Link [APC7] -> GSI 16 (level, low) -> IRQ 16
[   25.873557] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   25.873564] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
[   25.873759] ahci 0000:06:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
[   25.873973] ata1: SATA max UDMA/133 cmd 0xFFFFC20000060100 ctl 0x0 bmdma 0x0 irq 16
[   25.874252] ata2: SATA max UDMA/133 cmd 0xFFFFC20000060180 ctl 0x0 bmdma 0x0 irq 16
[   25.874453] scsi0 : ahci
[   26.186481] ata1: SATA link down (SStatus 0 SControl 300)
[   26.186595] scsi1 : ahci
[   26.665886] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   26.668868] ata2.00: ATA-7, max UDMA7, 488397168 sectors: LBA48 NCQ (depth 31/32)
[   26.696451] ata2.00: configured for UDMA/133
[   26.696620] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG SP2504C  VT10 PQ: 0 ANSI: 5
[   26.696875] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   26.696989] sda: Write Protect is off
[   26.697096] sda: Mode Sense: 00 3a 00 00
[   26.697106] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.697329] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   26.697440] sda: Write Protect is off
[   26.697548] sda: Mode Sense: 00 3a 00 00
[   26.697557] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   26.697750]  sda: sda1 sda2 sda4 < sda5 sda6 >
[   26.733930] sd 1:0:0:0: Attached scsi disk sda
[   26.734080] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   26.734259] block2mtd: version $Revision: 1.30 $
[   26.734949] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
[   26.735059] IOAPIC[0]: Set PCI routing entry (2-23 -> 0x71 -> IRQ 23 Mode:1 Active:1)
[   26.735066] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   26.735308] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   26.735310] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   26.735452] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[   26.735669] ehci_hcd 0000:00:02.1: debug port 1
[   26.735785] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   26.735793] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfe02e000
[   26.735905] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   26.736180] usb usb1: configuration #1 chosen from 1 choice
[   26.736315] hub 1-0:1.0: USB hub found
[   26.736428] hub 1-0:1.0: 10 ports detected
[   26.839042] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
[   26.839571] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[   26.839681] IOAPIC[0]: Set PCI routing entry (2-22 -> 0x79 -> IRQ 22 Mode:1 Active:1)
[   26.839686] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   26.839924] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   26.839926] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   26.840062] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[   26.840264] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[   26.894316] usb usb2: configuration #1 chosen from 1 choice
[   26.894448] hub 2-0:1.0: USB hub found
[   26.894561] hub 2-0:1.0: 10 ports detected
[   26.995510] USB Universal Host Controller Interface driver v3.0
[   27.065367] usb 1-2: new high speed USB device using ehci_hcd and address 2
[   27.189770] usb 1-2: configuration #1 chosen from 1 choice
[   27.190113] hub 1-2:1.0: USB hub found
[   27.190465] hub 1-2:1.0: 4 ports detected
[   27.881000] usb 2-3: new full speed USB device using ohci_hcd and address 2
[   28.030879] usb 2-3: configuration #1 chosen from 1 choice
[   28.270507] usb 2-5: new full speed USB device using ohci_hcd and address 3
[   28.423381] usb 2-5: configuration #1 chosen from 1 choice
[   28.613671] usb 1-2.3: new low speed USB device using ehci_hcd and address 5
[   28.702232] usb 1-2.3: configuration #1 chosen from 1 choice
[   28.889946] usb 1-2.4: new low speed USB device using ehci_hcd and address 6
[   28.976762] usb 1-2.4: configuration #1 chosen from 1 choice
[   28.977405] usbcore: registered new interface driver usblp
[   28.977513] drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
[   28.980420] input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
[   28.980530] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-2.3
[   28.984787] input: HID 046a:0001 as /class/input/input3
[   28.984902] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-2.4
[   28.985136] usbcore: registered new interface driver usbhid
[   28.985244] drivers/usb/input/hid-core.c: v2.6:USB HID core driver
[   28.985422] PNP: No PS/2 controller found. Probing ports directly.
[   28.985727] serio: i8042 KBD port at 0x60,0x64 irq 1
[   28.985837] serio: i8042 AUX port at 0x60,0x64 irq 12
[   28.986046] mice: PS/2 mouse device common for all mice
[   29.100577] i2c /dev entries driver
[   29.100808] i2c_adapter i2c-0: nForce2 SMBus adapter at 0x1c00
[   29.100952] i2c_adapter i2c-1: nForce2 SMBus adapter at 0x1c40
[   29.101104] it87: Found IT8716F chip at 0x290, revision 0
[   29.101219] it87: in3 is VCC (+5V)
[   29.101325] it87: in7 is VCCH (+5V Stand-By)
[   29.101642] md: raid1 personality registered for level 1
[   29.101795] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
[   29.102049] GACT probability on
[   29.102156] Mirror/redirect action on
[   29.102308] u32 classifier
[   29.102414]     Performance counters on
[   29.102521]     input device check on 
[   29.102627]     Actions configured 
[   29.102740] IPv4 over IPv4 tunneling driver
[   29.102922] ip_tables: (C) 2000-2006 Netfilter Core Team
[   29.205996] TCP bic registered
[   29.206103] TCP cubic registered
[   29.206210] TCP westwood registered
[   29.206316] TCP htcp registered
[   29.206423] TCP vegas registered
[   29.206530] Initializing XFRM netlink socket
[   29.206642] NET: Registered protocol family 1
[   29.206772] NET: Registered protocol family 10
[   29.206982] IPv6 over IPv4 tunneling driver
[   29.207155] NET: Registered protocol family 17
[   29.207263] NET: Registered protocol family 15
[   29.285888] Bridge firewalling registered
[   29.286025] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[   29.286133] All bugs added by David S. Miller <davem@redhat.com>
[   29.286264] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ processors (version 2.00.00)
[   29.286484] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
[   29.286592] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0xa
[   29.286700] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   29.292979] ACPI: (supports S0 S1 S3 S4 S5)
[   29.293291] md: Autodetecting RAID arrays.
[   29.293398] md: autorun ...
[   29.293505] md: ... autorun DONE.
[   29.304470] EXT3-fs: INFO: recovery required on readonly filesystem.
[   29.304578] EXT3-fs: write access will be enabled during recovery.
[   30.121789] kjournald starting.  Commit interval 5 seconds
[   30.121905] EXT3-fs: recovery complete.
[   30.122246] EXT3-fs: mounted filesystem with ordered data mode.
[   30.122396] VFS: Mounted root (ext3 filesystem) readonly.
[   30.122539] Freeing unused kernel memory: 200k freed
[   31.907348] forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.59.
[   31.908131] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 21
[   31.908242] IOAPIC[0]: Set PCI routing entry (2-21 -> 0x81 -> IRQ 21 Mode:1 Active:1)
[   31.908249] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APCH] -> GSI 21 (level, low) -> IRQ 21
[   31.908484] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   31.908491] forcedeth: using HIGHDMA
[   31.992612] usbcore: registered new interface driver usbserial
[   31.992731] drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
[   31.992938] usbcore: registered new interface driver usbserial_generic
[   31.993046] drivers/usb/serial/usb-serial.c: USB Serial Driver core
[   32.063166] drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303
[   32.063378] pl2303 2-5:1.0: pl2303 converter detected
[   32.063530] usb 2-5: pl2303 converter now attached to ttyUSB0
[   32.063641] usbcore: registered new interface driver pl2303
[   32.063749] drivers/usb/serial/pl2303.c: Prolific PL2303 USB to serial adaptor driver
[   32.422156] eth0: forcedeth.c: subsystem: 01043:8239 bound to 0000:00:08.0
[   32.422836] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 20
[   32.422947] IOAPIC[0]: Set PCI routing entry (2-20 -> 0x89 -> IRQ 20 Mode:1 Active:1)
[   32.422953] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [AMC1] -> GSI 20 (level, low) -> IRQ 20
[   32.423189] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   32.423196] forcedeth: using HIGHDMA
[   32.938172] eth1: forcedeth.c: subsystem: 01043:8239 bound to 0000:00:09.0
[   32.938468] pata_amd 0000:00:04.0: version 0.2.7
[   32.938486] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   32.938936] ata3: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
[   32.939073] ata4: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
[   32.939198] scsi2 : pata_amd
[   33.251005] ata3.00: ATAPI, max UDMA/33
[   33.410820] ata3.01: ATAPI, max UDMA/66
[   33.570598] ata3.00: configured for UDMA/33
[   33.730440] ata3.01: configured for UDMA/66
[   33.730556] scsi3 : pata_amd
[   33.730713] ata4: port disabled. ignoring.
[   33.730716] ata4: reset failed, giving up
[   33.731743] scsi 2:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.1A PQ: 0 ANSI: 5
[   33.734667] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   33.734776] Uniform CD-ROM driver Revision: 3.20
[   33.734910] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   33.734936] sr 2:0:0:0: Attached scsi generic sg1 type 5
[   33.736169] scsi 2:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-106  1.22 PQ: 0 ANSI: 5
[   33.740333] sr1: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[   33.740463] sr 2:0:1:0: Attached scsi CD-ROM sr1
[   33.740483] sr 2:0:1:0: Attached scsi generic sg2 type 5
[   33.755207] gameport: EMU10K1 is pci0000:01:08.1/gameport0, io 0xd000, speed 1203kHz
[   33.756094] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[   33.756205] IOAPIC[0]: Set PCI routing entry (2-18 -> 0x91 -> IRQ 18 Mode:1 Active:1)
[   33.756212] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   33.756454] ALSA sound/pci/emu10k1/emu10k1_main.c:1176: vendor=0x1102, device=0x2, subsystem_vendor_id=0x80641102, subsystem_id=0x8064
[   33.756672] ALSA sound/pci/emu10k1/emu10k1_main.c:1201: Sound card name=SB Live 5.1
[   34.141679] Adding 1951856k swap on /dev/sda6.  Priority:-1 extents:1 across:1951856k
[   34.277758] EXT3 FS on sda5, internal journal
[   55.266834] kjournald starting.  Commit interval 5 seconds
[   55.266842] EXT3-fs: mounted filesystem with ordered data mode.
[   55.293021] kjournald starting.  Commit interval 5 seconds
[   55.293232] EXT3 FS on dm-2, internal journal
[   55.293235] EXT3-fs: mounted filesystem with ordered data mode.
[   55.316433] kjournald starting.  Commit interval 5 seconds
[   55.316673] EXT3 FS on dm-1, internal journal
[   55.316676] EXT3-fs: mounted filesystem with ordered data mode.
[   55.345149] kjournald starting.  Commit interval 5 seconds
[   55.345335] EXT3 FS on dm-3, internal journal
[   55.345338] EXT3-fs: mounted filesystem with ordered data mode.
[   55.362316] ReiserFS: dm-4: found reiserfs format "3.6" with standard journal
[   55.362324] ReiserFS: dm-4: using ordered data mode
[   55.366159] ReiserFS: dm-4: journal params: device dm-4, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   55.367288] ReiserFS: dm-4: checking transaction log (dm-4)
[   55.408316] ReiserFS: dm-4: Using r5 hash to sort names
[   63.931903] lp: driver loaded but no devices found
[   63.938146] ppdev: user-space parallel port driver
[   65.473324] eth0: no IPv6 routers present
[   73.986381] [drm] Initialized drm 1.1.0 20060810
[   74.019729] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[   74.019734] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   74.019789] [drm] Initialized radeon 1.25.0 20060524 on minor 0
[   81.453161] [drm] Setting GART location based on new memory map
[   81.453299] [drm] Loading R300 Microcode
[   81.453314] [drm] writeback test succeeded in 1 usecs
[ 4259.367578] Stopping tasks ... done.
[ 4259.373241] Shrinking memory...  -\|/-\|/-\|/-\done (132248 pages freed)
[ 4259.824607] Freed 528992 kbytes in 0.36 seconds (1469.42 MB/s)
[ 4259.824610] Suspending console(s)
[ 4259.824667] pl2303 2-5:1.0: no suspend for driver pl2303?
[ 4259.831337] ACPI: PCI interrupt for device 0000:01:08.0 disabled
[ 4259.857319] ata4: port disabled. ignoring.
[ 4259.857321] ata4: reset failed, giving up
[ 4259.857348] ACPI: PCI interrupt for device 0000:00:02.1 disabled
[ 4259.870614] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 4259.884150] Extended CMOS year: 20
[ 4259.884154] swsusp: critical section: 
[ 4259.901762] swsusp: Need to copy 126252 pages
[   46.617820] Extended CMOS year: 20
[   46.741688] ACPI: Unable to turn cooling device [ffff81003fe90890] 'on'
[   46.754331] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[   46.754336] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   46.754341] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   46.754346] PM: Writing back config space on device 0000:00:02.0 at offset f (was 1030100, writing 103010a)
[   46.754353] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0, writing fe02f000)
[   46.754357] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was b00006, writing b00007)
[   46.767646] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   46.767650] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   46.767663] usb usb1: root hub lost power or was reset
[   46.767670] ehci_hcd 0000:00:02.1: debug port 1
[   46.767672] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   46.767680] PM: Writing back config space on device 0000:00:04.0 at offset b (was 82391043, writing 8239f043)
[   46.767687] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   46.767699] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   46.767731] ata4: port disabled. ignoring.
[   46.767733] ata4: reset failed, giving up
[   46.781633] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   46.781646] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   46.781658] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   46.781670] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   46.781682] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   46.781695] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   46.794290] PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900005, writing 2900001)
[   46.794300] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   46.802032] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   46.802087] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   46.802101] PM: Writing back config space on device 0000:07:00.1 at offset 1 (was 100000, writing 100004)
[   46.834236] usb usb2: root hub lost power or was reset
[   46.900814]  usbdev1.2_ep00: PM: resume from 0, parent 1-2 still 1
[   46.900817] hub 1-2:1.0: PM: resume from 1, parent 1-2 still 1
[   46.900819]  usbdev1.2_ep81: PM: resume from 0, parent 1-2:1.0 still 1
[   46.900822]  usbdev2.2_ep00: PM: resume from 0, parent 2-3 still 1
[   46.900825] usb 2-3:1.0: PM: resume from 1, parent 2-3 still 1
[   46.900827]  usbdev2.2_ep81: PM: resume from 0, parent 2-3:1.0 still 1
[   46.900830]  usbdev2.2_ep02: PM: resume from 0, parent 2-3:1.0 still 1
[   46.900833]  usbdev2.3_ep00: PM: resume from 0, parent 2-5 still 1
[   46.900836] pl2303 2-5:1.0: PM: resume from 1, parent 2-5 still 1
[   46.900838]  usbdev2.3_ep81: PM: resume from 0, parent 2-5:1.0 still 1
[   46.900841]  usbdev2.3_ep02: PM: resume from 0, parent 2-5:1.0 still 1
[   46.900844]  usbdev2.3_ep83: PM: resume from 0, parent 2-5:1.0 still 1
[   46.900846] usb 1-2.3: PM: resume from 1, parent 1-2 still 1
[   46.900849]  usbdev1.5_ep00: PM: resume from 0, parent 1-2.3 still 1
[   46.900852] usbhid 1-2.3:1.0: PM: resume from 1, parent 1-2.3 still 1
[   46.900854]  usbdev1.5_ep81: PM: resume from 0, parent 1-2.3:1.0 still 1
[   46.900857] usb 1-2.4: PM: resume from 1, parent 1-2 still 1
[   46.900859]  usbdev1.6_ep00: PM: resume from 0, parent 1-2.4 still 1
[   46.900862] usbhid 1-2.4:1.0: PM: resume from 1, parent 1-2.4 still 1
[   46.900865]  usbdev1.6_ep81: PM: resume from 0, parent 1-2.4:1.0 still 1
[   46.900896] pl2303 ttyUSB0: PM: resume from 0, parent 2-5:1.0 still 1
[   46.901647] Restarting tasks ... done.
[   47.370227] ata1: SATA link down (SStatus 0 SControl 300)
[   47.500058] usb 2-3: USB disconnect, address 2
[   47.718451] usb 2-5: USB disconnect, address 3
[   47.718536] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[   47.718551] pl2303 2-5:1.0: device disconnected
[   48.180039] ata3.00: simplex DMA is claimed by other device, disabling DMA
[   48.180044] ata3.01: simplex DMA is claimed by other device, disabling DMA
[   48.233813] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   48.269054] ata2.00: configured for UDMA/133
[   48.279925] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   48.281181] sda: Write Protect is off
[   48.281183] sda: Mode Sense: 00 3a 00 00
[   48.307427] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   48.323838] ata3.00: configured for PIO4
[   48.365639] usb 1-2: USB disconnect, address 2
[   48.365642] usb 1-2.3: USB disconnect, address 5
[   48.365813] usb 1-2.4: USB disconnect, address 6
[   48.467677] ata3.01: configured for PIO4
[   48.569386] usb 1-2: new high speed USB device using ehci_hcd and address 7
[   48.663586] usb 1-2: configuration #1 chosen from 1 choice
[   48.663742] hub 1-2:1.0: USB hub found
[   48.663915] hub 1-2:1.0: 4 ports detected
[   49.009453] usb 2-3: new full speed USB device using ohci_hcd and address 4
[   49.084293] usb 2-3: configuration #1 chosen from 1 choice
[   49.205580] usb 2-5: new full speed USB device using ohci_hcd and address 5
[   49.282050] usb 2-5: configuration #1 chosen from 1 choice
[   49.283535] pl2303 2-5:1.0: pl2303 converter detected
[   49.283578] usb 2-5: pl2303 converter now attached to ttyUSB0
[   49.377140] usb 1-2.3: new low speed USB device using ehci_hcd and address 10
[   49.421334] usb 1-2.3: configuration #1 chosen from 1 choice
[   49.423607] input: Logitech USB-PS/2 Optical Mouse as /class/input/input4
[   49.423646] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-2.3
[   49.516965] usb 1-2.4: new low speed USB device using ehci_hcd and address 11
[   49.567151] usb 1-2.4: configuration #1 chosen from 1 choice
[   49.569434] input: HID 046a:0001 as /class/input/input5
[   49.569461] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-2.4
[   51.357955] [drm] Loading R300 Microcode
[ 1819.418095] Stopping tasks ... done.
[ 1819.424178] Shrinking memory...  -\<7>Losing some ticks... checking if CPU frequency changed.
[ 1819.573548] |/-done (52819 pages freed)
[ 1819.702523] Freed 211276 kbytes in 0.26 seconds (812.60 MB/s)
[ 1819.702526] Suspending console(s)
[ 1819.702542] pl2303 2-5:1.0: no suspend for driver pl2303?
[ 1819.708649] ACPI: PCI interrupt for device 0000:01:08.0 disabled
[ 1819.730573] ata4: port disabled. ignoring.
[ 1819.730575] ata4: reset failed, giving up
[ 1819.730600] ACPI: PCI interrupt for device 0000:00:02.1 disabled
[ 1819.742539] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 1819.754724] Extended CMOS year: 20
[ 1819.754728] swsusp: critical section: 
[ 1819.771398] swsusp: Need to copy 119646 pages
[   45.092996] Extended CMOS year: 20
[   45.227517] ACPI: Unable to turn cooling device [ffff81003fe90890] 'on'
[   45.239495] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[   45.239499] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   45.239505] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   45.239510] PM: Writing back config space on device 0000:00:02.0 at offset f (was 1030100, writing 103010a)
[   45.239517] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0, writing fe02f000)
[   45.239521] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was b00006, writing b00007)
[   45.252811] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   45.252815] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   45.252827] usb usb1: root hub lost power or was reset
[   45.252834] ehci_hcd 0000:00:02.1: debug port 1
[   45.252837] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   45.252848] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   45.252860] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   45.252892] ata4: port disabled. ignoring.
[   45.252894] ata4: reset failed, giving up
[   45.266802] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   45.266816] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   45.266829] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   45.266842] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   45.266854] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   45.266867] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   45.279453] PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900005, writing 2900001)
[   45.279463] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   45.287212] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   45.287267] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   45.287281] PM: Writing back config space on device 0000:07:00.1 at offset 1 (was 100000, writing 100004)
[   45.319399] usb usb2: root hub lost power or was reset
[   45.386014]  usbdev1.7_ep00: PM: resume from 0, parent 1-2 still 1
[   45.386017] hub 1-2:1.0: PM: resume from 1, parent 1-2 still 1
[   45.386020]  usbdev1.7_ep81: PM: resume from 0, parent 1-2:1.0 still 1
[   45.386023]  usbdev2.4_ep00: PM: resume from 0, parent 2-3 still 1
[   45.386025] usb 2-3:1.0: PM: resume from 1, parent 2-3 still 1
[   45.386028]  usbdev2.4_ep81: PM: resume from 0, parent 2-3:1.0 still 1
[   45.386030]  usbdev2.4_ep02: PM: resume from 0, parent 2-3:1.0 still 1
[   45.386033]  usbdev2.5_ep00: PM: resume from 0, parent 2-5 still 1
[   45.386036] pl2303 2-5:1.0: PM: resume from 1, parent 2-5 still 1
[   45.386039] pl2303 ttyUSB0: PM: resume from 0, parent 2-5:1.0 still 1
[   45.386042]  usbdev2.5_ep81: PM: resume from 0, parent 2-5:1.0 still 1
[   45.386045]  usbdev2.5_ep02: PM: resume from 0, parent 2-5:1.0 still 1
[   45.386047]  usbdev2.5_ep83: PM: resume from 0, parent 2-5:1.0 still 1
[   45.386050] usb 1-2.3: PM: resume from 1, parent 1-2 still 1
[   45.386053]  usbdev1.10_ep00: PM: resume from 0, parent 1-2.3 still 1
[   45.386055] usbhid 1-2.3:1.0: PM: resume from 1, parent 1-2.3 still 1
[   45.386058]  usbdev1.10_ep81: PM: resume from 0, parent 1-2.3:1.0 still 1
[   45.386061] usb 1-2.4: PM: resume from 1, parent 1-2 still 1
[   45.386064]  usbdev1.11_ep00: PM: resume from 0, parent 1-2.4 still 1
[   45.386066] usbhid 1-2.4:1.0: PM: resume from 1, parent 1-2.4 still 1
[   45.386069]  usbdev1.11_ep81: PM: resume from 0, parent 1-2.4:1.0 still 1
[   45.386808] Restarting tasks ... done.
[   45.908656] ata1: SATA link down (SStatus 0 SControl 300)
[   46.038488] usb 2-3: USB disconnect, address 4
[   46.278183] usb 2-5: USB disconnect, address 5
[   46.278290] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[   46.278302] pl2303 2-5:1.0: device disconnected
[   46.709405] ata3.00: simplex DMA is claimed by other device, disabling DMA
[   46.709410] ata3.01: simplex DMA is claimed by other device, disabling DMA
[   46.739271] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   46.760624] ata2.00: configured for UDMA/133
[   46.766708] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   46.770504] sda: Write Protect is off
[   46.770508] sda: Mode Sense: 00 3a 00 00
[   46.789290] ata3.00: configured for PIO4
[   46.830671] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   46.839142] usb 1-2: USB disconnect, address 7
[   46.839145] usb 1-2.3: USB disconnect, address 10
[   46.839351] usb 1-2.4: USB disconnect, address 11
[   46.869204] ata3.01: configured for PIO4
[   46.952330] usb 1-2: new high speed USB device using ehci_hcd and address 12
[   47.014599] usb 1-2: configuration #1 chosen from 1 choice
[   47.014751] hub 1-2:1.0: USB hub found
[   47.014919] hub 1-2:1.0: 4 ports detected
[   47.360147] usb 2-3: new full speed USB device using ohci_hcd and address 6
[   47.435407] usb 2-3: configuration #1 chosen from 1 choice
[   47.554902] usb 2-5: new full speed USB device using ohci_hcd and address 7
[   47.631378] usb 2-5: configuration #1 chosen from 1 choice
[   47.632858] pl2303 2-5:1.0: pl2303 converter detected
[   47.632900] usb 2-5: pl2303 converter now attached to ttyUSB0
[   47.726463] usb 1-2.3: new low speed USB device using ehci_hcd and address 15
[   47.770717] usb 1-2.3: configuration #1 chosen from 1 choice
[   47.772246] input: Logitech USB-PS/2 Optical Mouse as /class/input/input6
[   47.772275] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-2.3
[   47.866288] usb 1-2.4: new low speed USB device using ehci_hcd and address 16
[   47.916470] usb 1-2.4: configuration #1 chosen from 1 choice
[   47.918585] input: HID 046a:0001 as /class/input/input7
[   47.918613] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-2.4
[   49.715588] [drm] Loading R300 Microcode
[11140.947574] Stopping tasks ... done.
[11140.951996] Shrinking memory...  -\|/-\|/-\|/-done (126350 pages freed)
[11141.387165] Freed 505400 kbytes in 0.37 seconds (1365.94 MB/s)
[11141.387168] Suspending console(s)
[11141.387183] pl2303 2-5:1.0: no suspend for driver pl2303?
[11141.393260] ACPI: PCI interrupt for device 0000:01:08.0 disabled
[11141.416988] ata4: port disabled. ignoring.
[11141.416990] ata4: reset failed, giving up
[11141.417015] ACPI: PCI interrupt for device 0000:00:02.1 disabled
[11141.428954] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[11141.441138] Extended CMOS year: 20
[11141.441142] swsusp: critical section: 
[11141.458212] swsusp: Need to copy 125968 pages
[   46.405801] Extended CMOS year: 20
[   46.526479] ACPI: Unable to turn cooling device [ffff81003fe90890] 'on'
[   46.538984] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[   46.538988] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   46.538993] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   46.538998] PM: Writing back config space on device 0000:00:02.0 at offset f (was 1030100, writing 103010a)
[   46.539005] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0, writing fe02f000)
[   46.539009] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was b00006, writing b00007)
[   46.552299] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   46.552303] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   46.552315] usb usb1: root hub lost power or was reset
[   46.552322] ehci_hcd 0000:00:02.1: debug port 1
[   46.552325] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   46.552336] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   46.552348] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   46.552380] ata4: port disabled. ignoring.
[   46.552381] ata4: reset failed, giving up
[   46.566291] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   46.566304] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   46.566317] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   46.566329] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   46.566342] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   46.566354] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   46.578942] PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900005, writing 2900001)
[   46.578952] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   46.586654] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   46.586708] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   46.586722] PM: Writing back config space on device 0000:07:00.1 at offset 1 (was 100000, writing 100004)
[   46.618888] usb usb2: root hub lost power or was reset
[   46.685502]  usbdev1.12_ep00: PM: resume from 0, parent 1-2 still 1
[   46.685505] hub 1-2:1.0: PM: resume from 1, parent 1-2 still 1
[   46.685508]  usbdev1.12_ep81: PM: resume from 0, parent 1-2:1.0 still 1
[   46.685511]  usbdev2.6_ep00: PM: resume from 0, parent 2-3 still 1
[   46.685513] usb 2-3:1.0: PM: resume from 1, parent 2-3 still 1
[   46.685516]  usbdev2.6_ep81: PM: resume from 0, parent 2-3:1.0 still 1
[   46.685519]  usbdev2.6_ep02: PM: resume from 0, parent 2-3:1.0 still 1
[   46.685522]  usbdev2.7_ep00: PM: resume from 0, parent 2-5 still 1
[   46.685524] pl2303 2-5:1.0: PM: resume from 1, parent 2-5 still 1
[   46.685527] pl2303 ttyUSB0: PM: resume from 0, parent 2-5:1.0 still 1
[   46.685530]  usbdev2.7_ep81: PM: resume from 0, parent 2-5:1.0 still 1
[   46.685533]  usbdev2.7_ep02: PM: resume from 0, parent 2-5:1.0 still 1
[   46.685535]  usbdev2.7_ep83: PM: resume from 0, parent 2-5:1.0 still 1
[   46.685538] usb 1-2.3: PM: resume from 1, parent 1-2 still 1
[   46.685541]  usbdev1.15_ep00: PM: resume from 0, parent 1-2.3 still 1
[   46.685543] usbhid 1-2.3:1.0: PM: resume from 1, parent 1-2.3 still 1
[   46.685546]  usbdev1.15_ep81: PM: resume from 0, parent 1-2.3:1.0 still 1
[   46.685549] usb 1-2.4: PM: resume from 1, parent 1-2 still 1
[   46.685551]  usbdev1.16_ep00: PM: resume from 0, parent 1-2.4 still 1
[   46.685554] usbhid 1-2.4:1.0: PM: resume from 1, parent 1-2.4 still 1
[   46.685557]  usbdev1.16_ep81: PM: resume from 0, parent 1-2.4:1.0 still 1
[   46.687133] Restarting tasks ... done.
[   47.154878] ata1: SATA link down (SStatus 0 SControl 300)
[   47.284708] usb 2-3: USB disconnect, address 6
[   47.512421] usb 2-5: USB disconnect, address 7
[   47.512514] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[   47.512529] pl2303 2-5:1.0: device disconnected
[   47.974011] ata3.00: simplex DMA is claimed by other device, disabling DMA
[   47.974016] ata3.01: simplex DMA is claimed by other device, disabling DMA
[   48.027783] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   48.061190] ata2.00: configured for UDMA/133
[   48.069834] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   48.074885] sda: Write Protect is off
[   48.074887] sda: Mode Sense: 00 3a 00 00
[   48.092079] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   48.117809] ata3.00: configured for PIO4
[   48.159611] usb 1-2: USB disconnect, address 12
[   48.159613] usb 1-2.3: USB disconnect, address 15
[   48.159799] usb 1-2.4: USB disconnect, address 16
[   48.261649] ata3.01: configured for PIO4
[   48.363361] usb 1-2: new high speed USB device using ehci_hcd and address 17
[   48.475357] usb 1-2: configuration #1 chosen from 1 choice
[   48.475546] hub 1-2:1.0: USB hub found
[   48.475862] hub 1-2:1.0: 4 ports detected
[   48.840712] usb 2-3: new full speed USB device using ohci_hcd and address 8
[   48.915559] usb 2-3: configuration #1 chosen from 1 choice
[   49.036838] usb 2-5: new full speed USB device using ohci_hcd and address 9
[   49.113312] usb 2-5: configuration #1 chosen from 1 choice
[   49.114796] pl2303 2-5:1.0: pl2303 converter detected
[   49.114839] usb 2-5: pl2303 converter now attached to ttyUSB0
[   49.208399] usb 1-2.3: new low speed USB device using ehci_hcd and address 20
[   49.252655] usb 1-2.3: configuration #1 chosen from 1 choice
[   49.254306] input: Logitech USB-PS/2 Optical Mouse as /class/input/input8
[   49.254334] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-2.3
[   49.348225] usb 1-2.4: new low speed USB device using ehci_hcd and address 21
[   49.398410] usb 1-2.4: configuration #1 chosen from 1 choice
[   49.400547] input: HID 046a:0001 as /class/input/input9
[   49.400574] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-2.4
[   51.888316] [drm] Loading R300 Microcode
[ 1868.638886] Stopping tasks ... done.
[ 1868.648496] Shrinking memory...  -\|done (37345 pages freed)
[ 1868.916749] Freed 149380 kbytes in 0.24 seconds (622.41 MB/s)
[ 1868.916752] Suspending console(s)
[ 1868.916768] pl2303 2-5:1.0: no suspend for driver pl2303?
[ 1868.923494] ACPI: PCI interrupt for device 0000:01:08.0 disabled
[ 1868.949070] ata4: port disabled. ignoring.
[ 1868.949073] ata4: reset failed, giving up
[ 1868.949099] ACPI: PCI interrupt for device 0000:00:02.1 disabled
[ 1868.962366] ACPI: PCI interrupt for device 0000:00:02.0 disabled
[ 1868.975902] Extended CMOS year: 20
[ 1868.975905] swsusp: critical section: 
[ 1868.992230] swsusp: Need to copy 118066 pages
[   45.033129] Extended CMOS year: 20
[   45.102696] ACPI: Unable to turn cooling device [ffff81003fe90890] 'on'
[   45.113046] PCI: Enabling device 0000:00:02.0 (0000 -> 0002)
[   45.113050] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[   45.113056] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   45.113061] PM: Writing back config space on device 0000:00:02.0 at offset f (was 1030100, writing 103010a)
[   45.113067] PM: Writing back config space on device 0000:00:02.0 at offset 4 (was 0, writing fe02f000)
[   45.113072] PM: Writing back config space on device 0000:00:02.0 at offset 1 (was b00006, writing b00007)
[   45.121372] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 23 (level, low) -> IRQ 23
[   45.121376] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   45.121385] usb usb1: root hub lost power or was reset
[   45.121390] ehci_hcd 0000:00:02.1: debug port 1
[   45.121392] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[   45.121401] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   45.121411] PCI: Setting latency timer of device 0000:00:06.0 to 64
[   45.121434] ata4: port disabled. ignoring.
[   45.121435] ata4: reset failed, giving up
[   45.128447] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   45.128458] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   45.128468] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   45.128478] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   45.128488] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   45.128498] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[   45.134697] PM: Writing back config space on device 0000:01:08.0 at offset 1 (was 2900005, writing 2900001)
[   45.134705] ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
[   45.138897] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   45.138930] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [APC6] -> GSI 16 (level, low) -> IRQ 16
[   45.138940] PM: Writing back config space on device 0000:07:00.1 at offset 1 (was 100000, writing 100004)
[   45.154668] usb usb2: root hub lost power or was reset
[   45.187980]  usbdev1.17_ep00: PM: resume from 0, parent 1-2 still 1
[   45.187983] hub 1-2:1.0: PM: resume from 1, parent 1-2 still 1
[   45.187985]  usbdev1.17_ep81: PM: resume from 0, parent 1-2:1.0 still 1
[   45.187988]  usbdev2.8_ep00: PM: resume from 0, parent 2-3 still 1
[   45.187991] usb 2-3:1.0: PM: resume from 1, parent 2-3 still 1
[   45.187994]  usbdev2.8_ep81: PM: resume from 0, parent 2-3:1.0 still 1
[   45.187996]  usbdev2.8_ep02: PM: resume from 0, parent 2-3:1.0 still 1
[   45.187999]  usbdev2.9_ep00: PM: resume from 0, parent 2-5 still 1
[   45.188002] pl2303 2-5:1.0: PM: resume from 1, parent 2-5 still 1
[   45.188005] pl2303 ttyUSB0: PM: resume from 0, parent 2-5:1.0 still 1
[   45.188007]  usbdev2.9_ep81: PM: resume from 0, parent 2-5:1.0 still 1
[   45.188010]  usbdev2.9_ep02: PM: resume from 0, parent 2-5:1.0 still 1
[   45.188013]  usbdev2.9_ep83: PM: resume from 0, parent 2-5:1.0 still 1
[   45.188016] usb 1-2.3: PM: resume from 1, parent 1-2 still 1
[   45.188018]  usbdev1.20_ep00: PM: resume from 0, parent 1-2.3 still 1
[   45.188021] usbhid 1-2.3:1.0: PM: resume from 1, parent 1-2.3 still 1
[   45.188024]  usbdev1.20_ep81: PM: resume from 0, parent 1-2.3:1.0 still 1
[   45.188027] usb 1-2.4: PM: resume from 1, parent 1-2 still 1
[   45.188029]  usbdev1.21_ep00: PM: resume from 0, parent 1-2.4 still 1
[   45.188032] usbhid 1-2.4:1.0: PM: resume from 1, parent 1-2.4 still 1
[   45.188035]  usbdev1.21_ep81: PM: resume from 0, parent 1-2.4:1.0 still 1
[   45.189668] Restarting tasks ... done.
[   45.427658] ata1: SATA link down (SStatus 0 SControl 300)
[   45.492574] usb 2-3: USB disconnect, address 8
[   45.612423] usb 2-5: USB disconnect, address 9
[   45.612522] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[   45.612534] pl2303 2-5:1.0: device disconnected
[   45.862207] ata3.00: simplex DMA is claimed by other device, disabling DMA
[   45.862212] ata3.01: simplex DMA is claimed by other device, disabling DMA
[   45.892076] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   45.909792] ata2.00: configured for UDMA/133
[   45.917258] SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
[   45.919786] sda: Write Protect is off
[   45.919789] sda: Mode Sense: 00 3a 00 00
[   45.942097] ata3.00: configured for PIO4
[   45.963270] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   45.971972] usb 1-2: USB disconnect, address 17
[   45.971975] usb 1-2.3: USB disconnect, address 20
[   45.972182] usb 1-2.4: USB disconnect, address 21
[   46.022005] ata3.01: configured for PIO4
[   46.085160] usb 1-2: new high speed USB device using ehci_hcd and address 22
[   46.147417] usb 1-2: configuration #1 chosen from 1 choice
[   46.147568] hub 1-2:1.0: USB hub found
[   46.147737] hub 1-2:1.0: 4 ports detected
[   46.492976] usb 2-3: new full speed USB device using ohci_hcd and address 10
[   46.568121] usb 2-3: configuration #1 chosen from 1 choice
[   46.689693] usb 2-5: new full speed USB device using ohci_hcd and address 11
[   46.765875] usb 2-5: configuration #1 chosen from 1 choice
[   46.767359] pl2303 2-5:1.0: pl2303 converter detected
[   46.767401] usb 2-5: pl2303 converter now attached to ttyUSB0
[   46.860966] usb 1-2.3: new low speed USB device using ehci_hcd and address 25
[   46.905221] usb 1-2.3: configuration #1 chosen from 1 choice
[   46.906812] input: Logitech USB-PS/2 Optical Mouse as /class/input/input10
[   46.906840] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:02.1-2.3
[   47.000791] usb 1-2.4: new low speed USB device using ehci_hcd and address 26
[   47.050975] usb 1-2.4: configuration #1 chosen from 1 choice
[   47.053263] input: HID 046a:0001 as /class/input/input11
[   47.053291] input: USB HID v1.00 Keyboard [HID 046a:0001] on usb-0000:00:02.1-2.4
[   48.843424] [drm] Loading R300 Microcode
[ 5527.919787] ISO 9660 Extensions: Microsoft Joliet Level 3
[ 5527.921129] ISO 9660 Extensions: RRIP_1991A
[ 5543.460247] ata3.00: disabled
[ 5543.460251] ata3.01: disabled
[ 5543.463584] Trying to free nonexistent resource <00000000000001f0-00000000000001f7>
[ 5543.463588] Trying to free nonexistent resource <0000000000000170-0000000000000177>
[ 5544.447160] pata_amd 0000:00:04.0: version 0.2.7
[ 5544.447173] PCI: Setting latency timer of device 0000:00:04.0 to 64
[ 5544.450745] ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
[ 5544.451229] ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
[ 5544.451245] scsi4 : pata_amd
[ 5544.607725] ata5.00: ATAPI, max UDMA/33
[ 5544.687551] ata5.01: ATAPI, max UDMA/66
[ 5544.767439] ata5.00: configured for UDMA/33
[ 5544.847348] ata5.01: configured for UDMA/33
[ 5544.847819] scsi5 : pata_amd
[ 5544.847869] ata6: port disabled. ignoring.
[ 5544.847871] ata6: reset failed, giving up
[ 5544.853145] scsi 4:0:0:0: CD-ROM            _NEC     DVD_RW ND-3500AG 2.1A PQ: 0 ANSI: 5
[ 5544.855207] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[ 5544.855243] sr 4:0:0:0: Attached scsi CD-ROM sr0
[ 5544.855271] sr 4:0:0:0: Attached scsi generic sg1 type 5
[ 5544.857560] scsi 4:0:1:0: CD-ROM            PIONEER  DVD-ROM DVD-106  1.22 PQ: 0 ANSI: 5
[ 5544.862326] sr1: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[ 5544.862366] sr 4:0:1:0: Attached scsi CD-ROM sr1
[ 5544.862397] sr 4:0:1:0: Attached scsi generic sg2 type 5
[ 5547.650288] ISO 9660 Extensions: Microsoft Joliet Level 3
[ 5547.651829] ISO 9660 Extensions: RRIP_1991A
[ 5573.214514] ISO 9660 Extensions: Microsoft Joliet Level 3
[ 5573.215370] ISO 9660 Extensions: RRIP_1991A
[ 6413.972484] EXT3 FS on sda1, internal journal
[ 6481.731596] EXT3 FS on sda1, internal journal
[ 8025.835826] time.c: can't update CMOS clock from 59 to 0
[10031.009704] ISO 9660 Extensions: Microsoft Joliet Level 3
[10031.032879] ISO 9660 Extensions: RRIP_1991A

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
