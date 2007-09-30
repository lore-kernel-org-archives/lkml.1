Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbXI3Pab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbXI3Pab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757340AbXI3PaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:30:20 -0400
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:47987 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbXI3PaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:30:15 -0400
Date: Sun, 30 Sep 2007 17:28:59 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
Message-ID: <20070930172859.7fd44eab@localhost>
In-Reply-To: <46FFBB2D.6060004@garzik.org>
References: <20070930160548.235be972@localhost>
	<20070930152908.1f58d39d@the-village.bc.nu>
	<20070930164610.20818867@localhost>
	<46FFBB2D.6060004@garzik.org>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007 11:05:17 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> > I have this problem only with XFS, and even with XFS it goes away
> > mounting with "nobarrier"...  
> 
> This last is an interesting datapoint.
> 
> I wonder if libata has a generic problem with NCQ + FLUSH CACHE.
> 
> What happens if you enable the 'fua' module parameter?  (libata.fua on 
> kernel command line, if built in)

it isn't supported here:
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Some more info:

	-------	lspci -----------
00:00.0 Host bridge: Intel Corporation Memory Controller Hub (rev 02)
00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics Controller (rev 02)
00:03.0 Communication controller: Intel Corporation HECI Controller (rev 02)
00:19.0 Ethernet controller: Intel Corporation Ethernet Controller (rev 02)
00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation PCI Express Port 4 (rev 02)
00:1c.4 PCI bridge: Intel Corporation PCI Express Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation SATA Controller AHCI (rev 02)
00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device 6101 (rev b1)
06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)


	---- smartctl  -i -d ata /dev/sda ------

smartctl version 5.37 [x86_64-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.7 and 7200.7 Plus family
Device Model:     ST380817AS
Serial Number:    4MR08EK8
Firmware Version: 3.42
User Capacity:    80,026,361,856 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  ATA/ATAPI-6 T13 1410D revision 2
Local Time is:    Sun Sep 30 17:27:39 2007 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled	


	--- dmesg, with timeout ----
[    0.000000] Linux version 2.6.23-rc8-ga64314e6 (paolo@tux) (gcc version 4.1.2 (Gentoo 4.1.2)) #85 SMP Sun Sep 30 10:22:14 CEST 2007
[    0.000000] Command line: root=/dev/sda6 ro vga=0x305
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003e599000 (usable)
[    0.000000]  BIOS-e820: 000000003e599000 - 000000003e5a6000 (reserved)
[    0.000000]  BIOS-e820: 000000003e5a6000 - 000000003e64d000 (usable)
[    0.000000]  BIOS-e820: 000000003e64d000 - 000000003e6a5000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003e6a5000 - 000000003e6aa000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003e6aa000 - 000000003e6ab000 (usable)
[    0.000000]  BIOS-e820: 000000003e6ab000 - 000000003e6f2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003e6f2000 - 000000003e6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003e6ff000 - 000000003e700000 (usable)
[    0.000000]  BIOS-e820: 000000003e700000 - 000000003f000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 255385) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 255398, 255565) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 255658, 255659) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 255743, 255744) 4 entries of 256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT 3E6FD038, 0050 (r1 INTEL  DG965SS       697       1000013)
[    0.000000] ACPI: FACP 3E6FC000, 0074 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: DSDT 3E6F7000, 40ED (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: FACS 3E6AB000, 0040
[    0.000000] ACPI: APIC 3E6F6000, 0078 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: WDDT 3E6F5000, 0040 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: MCFG 3E6F4000, 003C (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: ASF! 3E6F3000, 00A6 (r32 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: HPET 3E6F2000, 0038 (r1 INTEL  DG965SS       697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6A9000, 01BC (r1 INTEL     CpuPm      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6A8000, 0175 (r1 INTEL   Cpu0Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6A7000, 0175 (r1 INTEL   Cpu1Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6A6000, 0175 (r1 INTEL   Cpu2Ist      697 MSFT  1000013)
[    0.000000] ACPI: SSDT 3E6A5000, 0175 (r1 INTEL   Cpu3Ist      697 MSFT  1000013)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 255385) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 255398, 255565) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 255658, 255659) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 255743, 255744) 4 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0:        0 ->      143
[    0.000000]     0:      256 ->   255385
[    0.000000]     0:   255398 ->   255565
[    0.000000]     0:   255658 ->   255659
[    0.000000]     0:   255743 ->   255744
[    0.000000] On node 0 totalpages: 255441
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1336 pages reserved
[    0.000000]   DMA zone: 2591 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3440 pages used for memmap
[    0.000000]   DMA32 zone: 248018 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 3f000000:c0f00000)
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PERCPU: Allocating 30696 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order.  Total pages: 250609
[    0.000000] Kernel command line: root=/dev/sda6 ro vga=0x305
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[   29.987175] time.c: Detected 1864.803 MHz processor.
[   29.987216] Console: colour dummy device 80x25
[   29.987220] console [tty0] enabled
[   29.987913] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[   29.988366] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[   29.988449] Checking aperture...
[   29.998150] Memory: 997980k/1022976k available (3187k kernel code, 23076k reserved, 1398k data, 252k init)
[   30.057537] Calibrating delay using timer specific routine.. 3731.76 BogoMIPS (lpj=1865880)
[   30.057585] Mount-cache hash table entries: 256
[   30.057694] CPU: L1 I cache: 32K, L1 D cache: 32K
[   30.057698] CPU: L2 cache: 2048K
[   30.057702] using mwait in idle threads.
[   30.057704] CPU: Physical Processor ID: 0
[   30.057707] CPU: Processor Core ID: 0
[   30.057715] CPU0: Thermal monitoring enabled (TM2)
[   30.057728] SMP alternatives: switching to UP code
[   30.058511] ACPI: Core revision 20070126
[   30.072090] Using local APIC timer interrupts.
[   30.125708] result 16650017
[   30.125710] Detected 16.650 MHz APIC timer.
[   30.126592] SMP alternatives: switching to SMP code
[   30.127127] Booting processor 1/2 APIC 0x1
[   30.137504] Initializing CPU#1
[   30.197501] Calibrating delay using timer specific routine.. 3729.46 BogoMIPS (lpj=1864731)
[   30.197508] CPU: L1 I cache: 32K, L1 D cache: 32K
[   30.197509] CPU: L2 cache: 2048K
[   30.197512] CPU: Physical Processor ID: 0
[   30.197513] CPU: Processor Core ID: 1
[   30.197519] CPU1: Thermal monitoring enabled (TM2)
[   30.197832] Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
[   30.197915] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[   30.218512] Brought up 2 CPUs
[   30.218762] NET: Registered protocol family 16
[   30.218889] ACPI: bus type pci registered
[   30.218962] PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
[   30.218965] PCI: Not using MMCONFIG.
[   30.218968] PCI: Using configuration type 1
[   30.220995] ACPI: EC: Look up EC in DSDT
[   30.222925] ACPI: Interpreter enabled
[   30.222930] ACPI: (supports S0 S3 S5)
[   30.222941] ACPI: Using IOAPIC for interrupt routing
[   30.227099] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   30.227784] PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[   30.227789] PCI quirk: region 0500-053f claimed by ICH6 GPIO
[   30.228360] PCI: Transparent bridge - 0000:00:1e.0
[   30.228424] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   30.228792] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[   30.229054] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[   30.229158] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[   30.229262] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[   30.229365] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[   30.229468] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[   30.233539] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[   30.233632] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[   30.233720] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[   30.233808] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[   30.233896] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[   30.233983] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[   30.234070] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[   30.234157] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[   30.234280] Linux Plug and Play Support v0.97 (c) Adam Belay
[   30.234306] pnp: PnP ACPI init
[   30.234314] ACPI: bus type pnp registered
[   30.236504] pnp: PnP ACPI: found 12 devices
[   30.236508] ACPI: ACPI bus type pnp unregistered
[   30.236659] SCSI subsystem initialized
[   30.236693] libata version 2.21 loaded.
[   30.236773] usbcore: registered new interface driver usbfs
[   30.236804] usbcore: registered new interface driver hub
[   30.236838] usbcore: registered new device driver usb
[   30.236914] PCI: Using ACPI for IRQ routing
[   30.236917] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   30.239571] PCI-GART: No AMD northbridge found.
[   30.239577] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[   30.239583] hpet0: 3 64-bit timers, 14318180 Hz
[   30.241491] Time: tsc clocksource has been installed.
[   30.243637] pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
[   30.243642] pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[   30.243647] pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[   30.243651] pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[   30.243660] pnp: 00:06: ioport range 0x500-0x53f has been reserved
[   30.243664] pnp: 00:06: ioport range 0x400-0x47f has been reserved
[   30.243668] pnp: 00:06: ioport range 0x680-0x6ff has been reserved
[   30.243976] PCI: Bridge: 0000:00:1c.0
[   30.243979]   IO window: disabled.
[   30.243984]   MEM window: disabled.
[   30.243987]   PREFETCH window: disabled.
[   30.243992] PCI: Bridge: 0000:00:1c.1
[   30.243995]   IO window: 2000-2fff
[   30.244000]   MEM window: 50100000-501fffff
[   30.244004]   PREFETCH window: disabled.
[   30.244009] PCI: Bridge: 0000:00:1c.2
[   30.244011]   IO window: disabled.
[   30.244015]   MEM window: disabled.
[   30.244019]   PREFETCH window: disabled.
[   30.244024] PCI: Bridge: 0000:00:1c.3
[   30.244026]   IO window: disabled.
[   30.244030]   MEM window: disabled.
[   30.244034]   PREFETCH window: disabled.
[   30.244038] PCI: Bridge: 0000:00:1c.4
[   30.244040]   IO window: disabled.
[   30.244045]   MEM window: disabled.
[   30.244048]   PREFETCH window: disabled.
[   30.244053] PCI: Bridge: 0000:00:1e.0
[   30.244056]   IO window: 1000-1fff
[   30.244061]   MEM window: 50000000-500fffff
[   30.244065]   PREFETCH window: disabled.
[   30.244086] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[   30.244093] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   30.244108] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[   30.244115] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   30.244130] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[   30.244136] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   30.244151] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[   30.244157] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   30.244172] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
[   30.244178] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[   30.244187] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   30.244208] NET: Registered protocol family 2
[   30.252829] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[   30.252993] TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
[   30.254438] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   30.254953] TCP: Hash tables configured (established 131072 bind 65536)
[   30.254957] TCP reno registered
[   30.258041] checking if image is initramfs...it isn't (bad gzip magic numbers); looks like an initrd
[   30.259844] Freeing initrd memory: 2000k freed
[   30.260662] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   30.261386] fuse init (API version 7.8)
[   30.261497] io scheduler noop registered
[   30.261508] io scheduler cfq registered (default)
[   30.261519] Boot video device is 0000:00:02.0
[   30.263864] vesafb: framebuffer at 0x40000000, mapped to 0xffffc20000080000, using 1536k, total 7616k
[   30.263872] vesafb: mode is 1024x768x8, linelength=1024, pages=8
[   30.263875] vesafb: scrolling: redraw
[   30.263878] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[   30.271168] Console: switching to colour frame buffer device 128x48
[   30.278567] fb0: VESA VGA frame buffer device
[   30.278722] input: Power Button (FF) as /devices/virtual/input/input0
[   30.278811] ACPI: Power Button (FF) [PWRF]
[   30.278925] input: Sleep Button (CM) as /devices/virtual/input/input1
[   30.279016] ACPI: Sleep Button (CM) [SLPB]
[   30.279287] ACPI: Processor [CPU0] (supports 8 throttling states)
[   30.279428] ACPI: Processor [CPU1] (supports 8 throttling states)
[   30.279527] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[   30.279671] ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
[   30.282749] Real Time Clock Driver v1.12ac
[   30.282880] hpet_resources: 0xfed00000 is busy
[   30.282957] ppdev: user-space parallel port driver
[   30.283024] Linux agpgart interface v0.102
[   30.283111] agpgart: Detected an Intel 965G Chipset.
[   30.284096] agpgart: Detected 7676K stolen memory.
[   30.296061] agpgart: AGP aperture is 256M @ 0x40000000
[   30.296192] [drm] Initialized drm 1.1.0 20060810
[   30.296277] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[   30.296431] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   30.297686] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   30.299672] Floppy drive(s): fd0 is 1.44M
[   30.315172] FDC 0 is a National Semiconductor PC87306
[   30.317999] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
[   30.319791] loop: module loaded
[   30.321370] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[   30.323047] Copyright (c) 1999-2006 Intel Corporation.
[   30.324816] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[   30.326660] PCI: Setting latency timer of device 0000:00:19.0 to 64
[   30.344191] e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:19:d1:00:44:f5
[   30.420457] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   30.422651] 8139too Fast Ethernet driver 0.9.28
[   30.424709] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21
[   30.427712] eth1: RealTek RTL8139 at 0xffffc20000034000, 00:e0:4c:f0:a9:84, IRQ 21
[   30.429961] eth1:  Identified 8139 chip type 'RTL-8139C'
[   30.429978] tun: Universal TUN/TAP device driver, 1.6
[   30.432265] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   30.434787] ahci 0000:00:1f.2: version 2.3
[   30.434806] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[   31.438589] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[   31.441168] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
[   31.443776] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   31.443923] scsi0 : ahci
[   31.446617] scsi1 : ahci
[   31.449284] scsi2 : ahci
[   31.451957] scsi3 : ahci
[   31.454633] scsi4 : ahci
[   31.457319] scsi5 : ahci
[   31.459934] ata1: SATA max UDMA/133 cmd 0xffffc20000036100 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
[   31.462661] ata2: SATA max UDMA/133 cmd 0xffffc20000036180 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
[   31.465326] ata3: DUMMY
[   31.467925] ata4: DUMMY
[   31.470463] ata5: SATA max UDMA/133 cmd 0xffffc20000036300 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
[   31.473144] ata6: SATA max UDMA/133 cmd 0xffffc20000036380 ctl 0x0000000000000000 bmdma 0x0000000000000000 irq 19
[   31.931727] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   31.935692] ata1.00: ATA-6: ST380817AS, 3.42, max UDMA/133
[   31.938335] ata1.00: 156301488 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   31.942529] ata1.00: configured for UDMA/133
[   32.248917] ata2: SATA link down (SStatus 0 SControl 300)
[   32.553989] ata5: SATA link down (SStatus 0 SControl 300)
[   32.859062] ata6: SATA link down (SStatus 0 SControl 300)
[   32.861716] scsi 0:0:0:0: Direct-Access     ATA      ST380817AS       3.42 PQ: 0 ANSI: 5
[   32.864451] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   32.867134] sd 0:0:0:0: [sda] Write Protect is off
[   32.869785] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.869801] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.872544] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[   32.875232] sd 0:0:0:0: [sda] Write Protect is off
[   32.877853] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   32.877872] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   32.880538]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
[   32.940411] sd 0:0:0:0: [sda] Attached SCSI disk
[   32.943087] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   32.945761] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   32.948430] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   32.948459] scsi6 : pata_marvell
[   32.951099] scsi7 : pata_marvell
[   32.953658] ata7: PATA max UDMA/100 cmd 0x0000000000012018 ctl 0x0000000000012026 bmdma 0x0000000000012000 irq 17
[   32.956291] ata8: DUMMY
[   32.959319] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   33.439165] ata7.00: ATAPI: HL-DT-ST GCE-8400B, 1.03, max MWDMA2
[   33.441829] ata7.01: ATAPI: HL-DT-ST DVDRAM GSA-4167B, DL11, max UDMA/33
[   33.601285] ata7.00: configured for MWDMA2
[   33.777794] ata7.01: configured for UDMA/33
[   33.780634] scsi 6:0:0:0: CD-ROM            HL-DT-ST CD-RW GCE-8400B  1.03 PQ: 0 ANSI: 5
[   33.785942] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[   33.788528] Uniform CD-ROM driver Revision: 3.20
[   33.791133] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   33.791190] sr 6:0:0:0: Attached scsi generic sg1 type 5
[   33.797414] scsi 6:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL11 PQ: 0 ANSI: 5
[   33.818516] sr1: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   33.821290] sr 6:0:1:0: Attached scsi CD-ROM sr1
[   33.821341] sr 6:0:1:0: Attached scsi generic sg2 type 5
[   33.824265] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[   33.827575] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   33.827580] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   33.830574] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   33.833465] ehci_hcd 0000:00:1a.7: debug port 1
[   33.836345] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   33.836356] ehci_hcd 0000:00:1a.7: irq 18, io mem 0x50325c00
[   33.843042] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   33.846061] usb usb1: configuration #1 chosen from 1 choice
[   33.848924] hub 1-0:1.0: USB hub found
[   33.851774] hub 1-0:1.0: 4 ports detected
[   33.955254] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[   33.958552] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   33.958558] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   33.961480] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   33.964343] ehci_hcd 0000:00:1d.7: debug port 1
[   33.967147] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   33.967156] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50325800
[   33.973871] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   33.976880] usb usb2: configuration #1 chosen from 1 choice
[   33.979796] hub 2-0:1.0: USB hub found
[   33.982626] hub 2-0:1.0: 6 ports detected
[   34.086254] USB Universal Host Controller Interface driver v3.0
[   34.089142] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[   34.091991] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   34.091994] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   34.094850] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   34.097712] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000030c0
[   34.100604] usb usb3: configuration #1 chosen from 1 choice
[   34.103423] hub 3-0:1.0: USB hub found
[   34.106204] hub 3-0:1.0: 2 ports detected
[   34.210294] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[   34.213089] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   34.213092] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   34.215946] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   34.218748] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000030a0
[   34.221564] usb usb4: configuration #1 chosen from 1 choice
[   34.224257] hub 4-0:1.0: USB hub found
[   34.226838] hub 4-0:1.0: 2 ports detected
[   34.330315] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[   34.332952] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   34.332955] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   34.335639] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   34.338301] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00003080
[   34.341003] usb usb5: configuration #1 chosen from 1 choice
[   34.343622] hub 5-0:1.0: USB hub found
[   34.346183] hub 5-0:1.0: 2 ports detected
[   34.450352] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   34.452911] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   34.452914] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   34.455460] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   34.457992] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00003060
[   34.460577] usb usb6: configuration #1 chosen from 1 choice
[   34.463082] hub 6-0:1.0: USB hub found
[   34.465533] hub 6-0:1.0: 2 ports detected
[   34.569391] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   34.571922] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   34.571925] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   34.574436] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   34.576961] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00003040
[   34.579588] usb usb7: configuration #1 chosen from 1 choice
[   34.582118] hub 7-0:1.0: USB hub found
[   34.584570] hub 7-0:1.0: 2 ports detected
[   34.688474] usbcore: registered new interface driver cdc_acm
[   34.690937] drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
[   34.693552] usbcore: registered new interface driver usblp
[   34.696139] Initializing USB Mass Storage driver...
[   34.698720] usbcore: registered new interface driver usb-storage
[   34.701299] USB Mass Storage support registered.
[   34.703967] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   34.709467] serio: i8042 KBD port at 0x60,0x64 irq 1
[   34.712089] serio: i8042 AUX port at 0x60,0x64 irq 12
[   34.714738] mice: PS/2 mouse device common for all mice
[   34.738152] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[   34.744878] Advanced Linux Sound Architecture Driver Version 1.0.14 (Fri Jul 20 09:12:58 2007 UTC).
[   34.747801] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   34.751007] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   34.777368] ALSA device list:
[   34.780095]   #0: HDA Intel at 0x50320000 irq 22
[   34.782991] nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
[   34.785898] ip_tables: (C) 2000-2006 Netfilter Core Team
[   34.788628] TCP cubic registered
[   34.791318] NET: Registered protocol family 1
[   34.794002] NET: Registered protocol family 17
[   34.796636] NET: Registered protocol family 15
[   35.466678] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[   35.508376] RAMDISK: ext2 filesystem found at block 0
[   35.511061] RAMDISK: Loading 2000KiB [1 disk] into ram disk... |/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|/-\|done.
[   35.518488] VFS: Mounted root (ext2 filesystem).
[   35.550161] kjournald starting.  Commit interval 5 seconds
[   35.550167] EXT3-fs: mounted filesystem with ordered data mode.
[   35.550174] VFS: Mounted root (ext3 filesystem) readonly.
[   35.550175] Trying to move old root to /initrd ... /initrd does not exist. Ignored.
[   35.550358] Unmounting old root
[   35.550467] Trying to free ramdisk memory ... okay
[   35.550767] Freeing unused kernel memory: 252k freed
[   38.913357] udev: renamed network interface eth1 to eth0
[   38.949147] udev: renamed network interface eth0_rename to eth1
[   39.919457] EXT3 FS on sda6, internal journal
[   40.444195] kjournald starting.  Commit interval 5 seconds
[   40.444403] EXT3 FS on sda8, internal journal
[   40.444408] EXT3-fs: mounted filesystem with ordered data mode.
[   40.504435] Adding 1004020k swap on /dev/sda7.  Priority:-1 extents:1 across:1004020k
[   53.680358] eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
[  150.036560] SGI XFS with large block/inode numbers, no debug enabled
[  150.076345] XFS mounting filesystem sda1
[  150.138250] Ending clean XFS mount for filesystem: sda1
[  372.948796] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
[  372.948805] ata1.00: cmd 61/40:00:29:a3:98/00:00:00:00:00/40 tag 0 cdb 0x0 data 32768 out
[  372.948806]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[  373.252286] ata1: soft resetting port
[  373.458239] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  373.461012] ata1.00: configured for UDMA/133
[  373.461022] ata1: EH complete
[  373.461061] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
[  373.461075] sd 0:0:0:0: [sda] Write Protect is off
[  373.461077] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  373.461095] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA


-- 
	Paolo Ornati
	Linux 2.6.23-rc8-ga64314e6 on x86_64
