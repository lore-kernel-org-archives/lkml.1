Return-Path: <linux-kernel-owner+w=401wt.eu-S1759889AbXKBSrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889AbXKBSrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755797AbXKBSri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:47:38 -0400
Received: from poseidon.rz.tu-clausthal.de ([139.174.2.21]:64996 "EHLO
	poseidon.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbXKBSrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:47:36 -0400
X-Greylist: delayed 790 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2007 14:47:35 EDT
From: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
To: linux-kernel@vger.kernel.org
Subject: question about sata-error on boot.
Date: Fri, 2 Nov 2007 19:34:20 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_t22KHjMNsBZAL+n"
Message-Id: <200711021934.21123.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_t22KHjMNsBZAL+n
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

for some time (and I can't say for how long, but the board is less than a=20
month old) I get this error on boot:

[   42.116273] ahci 0000:00:0a.0: version 2.2
[   42.116482] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   42.116653] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   43.119478] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   43.119778] ahci 0000:00:0a.0: flags: 64bit led clo pmp pio
[   43.119943] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   43.120149] scsi0 : ahci
[   43.120365] scsi1 : ahci
[   43.120556] scsi2 : ahci
[   43.120741] scsi3 : ahci
[   43.120927] ata1: SATA max UDMA/133 cmd 0xffffc20000014100 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.121227] ata2: SATA max UDMA/133 cmd 0xffffc20000014180 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.121526] ata3: SATA max UDMA/133 cmd 0xffffc20000014200 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.121826] ata4: SATA max UDMA/133 cmd 0xffffc20000014280 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.934296] ata1: softreset failed (1st FIS failed)
[   43.934461] ata1: reset failed (errno=3D-5), retrying in 10 secs
[   53.885194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   53.885890] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   53.886056] ata1.00: 312581808 sectors, multi 16: LBA48
[   53.886804] ata1.00: configured for UDMA/133
[   54.201147] ata2: SATA link down (SStatus 0 SControl 300)
[   54.517101] ata3: SATA link down (SStatus 0 SControl 300)
[   54.833055] ata4: SATA link down (SStatus 0 SControl 300)

The board has four ports and I use the first one. After that, the computer=
=20
boots and works fine. Harddisk-speed is normal. Kernel is 2.6.22.9 with=20
cfs&reiser4 patches.

Is this something to worry about?

=46ollowing is lspci -v and dmesg, config is attached.=20
lspci -v
00:00.0 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
        Subsystem: ASRock Incorporation Unknown device 0444
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-

00:01.0 ISA bridge: nVidia Corporation MCP65 LPC Bridge (rev a2)
        Subsystem: ASRock Incorporation Unknown device 0441
        Flags: bus master, 66MHz, fast devsel, latency 0
        I/O ports at 2f00 [size=3D256]

00:01.1 SMBus: nVidia Corporation MCP65 SMBus (rev a1)
        Subsystem: ASRock Incorporation Unknown device 0446
        Flags: 66MHz, fast devsel, IRQ 11
        I/O ports at ac00 [size=3D64]
        I/O ports at 2d00 [size=3D64]
        I/O ports at 2e00 [size=3D64]
        Capabilities: [44] Power Management version 2

00:01.2 RAM memory: nVidia Corporation MCP65 Memory Controller (rev a1)
        Subsystem: ASRock Incorporation Unknown device 0446
        Flags: 66MHz, fast devsel

00:02.0 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1)=20
(prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation Unknown device 0454
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
        Memory at f9dff000 (32-bit, non-prefetchable) [size=3D4K]
        Capabilities: [44] Power Management version 2

00:02.1 USB Controller: nVidia Corporation MCP65 USB Controller (rev a1)=20
(prog-if 20 [EHCI])
        Subsystem: ASRock Incorporation Unknown device 0455
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
        Memory at f9dfec00 (32-bit, non-prefetchable) [size=3D256]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2

00:08.0 PCI bridge: nVidia Corporation MCP65 PCI bridge (rev a1) (prog-if 0=
1=20
[Subtractive decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
128
        I/O behind bridge: 0000c000-0000dfff
        Memory behind bridge: f9f00000-f9ffffff
        Prefetchable memory behind bridge: 88000000-880fffff
        Capabilities: [b8] Subsystem: ASRock Incorporation Unknown device 0=
449
        Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-

00:09.0 IDE interface: nVidia Corporation MCP65 IDE (rev a1) (prog-if 8a=20
[Master SecP PriP])
        Subsystem: ASRock Incorporation Unknown device 0448
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled]=
=20
[size=3D8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled]=
=20
[size=3D1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled]=
=20
[size=3D8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled]=
=20
[size=3D1]
        I/O ports at ffa0 [size=3D16]
        Capabilities: [44] Power Management version 2

00:0a.0 IDE interface: nVidia Corporation MCP65 SATA Controller (rev a1)=20
(prog-if 85 [Master SecO PriO])
        Subsystem: ASRock Incorporation Unknown device 045d
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 315
        I/O ports at 0e00 [size=3D8]
        I/O ports at 0e20 [size=3D4]
        I/O ports at 0e40 [size=3D8]
        I/O ports at 0e60 [size=3D4]
        I/O ports at 9800 [size=3D16]
        Memory at f9dfc000 (32-bit, non-prefetchable) [size=3D8K]
        Capabilities: [44] Power Management version 2
        Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/3 Enable+
        Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+

00:0b.0 PCI bridge: nVidia Corporation Unknown device 045b (rev a1) (prog-i=
f=20
00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
        I/O behind bridge: 0000b000-0000bfff
        Memory behind bridge: f9e00000-f9efffff
        Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 0=
45b
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00

00:0c.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)=20
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
        Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 0=
45a
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00

00:0d.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)=20
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fa000000-febfffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 0=
458
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00

00:0e.0 PCI bridge: nVidia Corporation MCP65 PCI Express bridge (rev a1)=20
(prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D0
        Capabilities: [40] Subsystem: ASRock Incorporation Unknown device 0=
459
        Capabilities: [48] Power Management version 2
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/1 Enable+
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
        Capabilities: [80] Express Root Port (Slot+), MSI 00

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
HyperTransport Technology Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Address Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRA=
M=20
Controller
        Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]=20
Miscellaneous Control
        Flags: fast devsel
        Capabilities: [f0] #0f [0010]

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI=20
Express Gigabit Ethernet controller (rev 01)
        Subsystem: ASRock Incorporation Unknown device 8168
        Flags: bus master, fast devsel, latency 0, IRQ 19
        I/O ports at b800 [size=3D256]
        Memory at f9eff000 (64-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at f9ec0000 [disabled] [size=3D128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Vital Product Data
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/1 Enable-
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [84] Vendor Specific Information

02:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000=
=20
Controller (PHY/Link) (prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation Unknown device 8023
        Flags: bus master, medium devsel, latency 128, IRQ 11
        Memory at f9fff800 (32-bit, non-prefetchable) [size=3D2K]
        Memory at f9ff8000 (32-bit, non-prefetchable) [size=3D16K]
        Capabilities: [44] Power Management version 2

02:08.0 SCSI storage controller: Adaptec AHA-2944UW / AIC-7884U (rev 01)
        Subsystem: Adaptec Unknown device 7884
        Flags: bus master, medium devsel, latency 128, IRQ 5
        I/O ports at d800 [size=3D256]
        Memory at f9ffe000 (32-bit, non-prefetchable) [size=3D4K]
        Expansion ROM at 88020000 [disabled] [size=3D64K]
        Capabilities: [dc] Power Management version 1

02:09.0 Multimedia audio controller: Creative Labs SB0400 Audigy2 Value
        Subsystem: Creative Labs Unknown device 1001
        Flags: bus master, medium devsel, latency 128, IRQ 17
        I/O ports at dc00 [size=3D64]
        Capabilities: [dc] Power Management version 2

02:0a.0 Mass storage controller: HighPoint Technologies, Inc.=20
HPT366/368/370/370A/372/372N (rev 01)
        Flags: bus master, medium devsel, latency 120, IRQ 18
        I/O ports at d480 [size=3D8]
        I/O ports at d400 [size=3D4]
        I/O ports at d000 [size=3D256]
        Expansion ROM at 88000000 [disabled by cmd] [size=3D128K]

02:0a.1 Mass storage controller: HighPoint Technologies, Inc.=20
HPT366/368/370/370A/372/372N (rev 01)
        Flags: bus master, medium devsel, latency 120, IRQ 18
        I/O ports at cc00 [size=3D8]
        I/O ports at c880 [size=3D4]
        I/O ports at c400 [size=3D256]

04:00.0 VGA compatible controller: nVidia Corporation GeForce 8600 GT (rev =
a1)=20
(prog-if 00 [VGA])
        Subsystem: nVidia Corporation Unknown device 0439
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fd000000 (32-bit, non-prefetchable) [size=3D16M]
        Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
        Memory at fa000000 (64-bit, non-prefetchable) [size=3D32M]
        I/O ports at ec00 [size=3D128]
        [virtual] Expansion ROM at febe0000 [disabled] [size=3D128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+=20
Queue=3D0/0 Enable-
        Capabilities: [78] Express Endpoint, MSI 0

dmesg:
[    0.000000] Linux version 2.6.22.9-cfs-v22reiser4 (root@energy) (gcc=20
version 4.2.2 (Gentoo 4.2.2 p1.0)) #5 SMP Thu Oct 25 14:39:54 CEST 2007
[    0.000000] Command line: root=3D/dev/sda3 nmi_watchdog=3D0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffb0000 - 000000007ffc0000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffc0000 - 000000007fff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fff0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff380000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 524208) 1 entries of 256 u=
sed
[    0.000000] end_pfn_map =3D 1048576
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000FA530, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 7FFB0000, 003C (r1 A M I  OEMRSDT   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: FACP 7FFB0200, 0084 (r2 A_M_I  OEMFACP  12000601 MSFT =
     =20
97)
[    0.000000] ACPI: DSDT 7FFB0450, 4FFA (r1  ASR19 ASR1915A      15A INTL=
=20
20051117)
[    0.000000] ACPI: FACS 7FFC0000, 0040
[    0.000000] ACPI: APIC 7FFB0390, 0080 (r1 A M I  OEMAPIC   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: MCFG 7FFB0410, 003C (r1 A M I  OEMMCFG   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: OEMB 7FFC0040, 0060 (r1 A M I  AMI_OEM   9000720 MSFT =
     =20
97)
[    0.000000] ACPI: HPET 7FFB5450, 0038 (r1 A M I  OEMHPET0  9000720 MSFT =
     =20
97)
[    0.000000] ACPI: SSDT 7FFB5490, 030E (r1 A M I  POWERNOW        1 AMD  =
      =20
1)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 524208) 1 entries of 256 u=
sed
[    0.000000] No mptable found.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524208
[    0.000000] On node 0 totalpages: 524111
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 905 pages reserved
[    0.000000]   DMA zone: 3038 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7110 pages used for memmap
[    0.000000]   DMA32 zone: 513002 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
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
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap:=20
80000000:7ec00000)
[    0.000000] PERCPU: Allocating 29336 bytes of per cpu data
[    0.000000] Built 1 zonelists.  Total pages: 516040
[    0.000000] Kernel command line: root=3D/dev/sda3 nmi_watchdog=3D0
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Marking TSC unstable due to TSCs unsynchronized
[   40.731282] time.c: Detected 3013.892 MHz processor.
[   40.735511] Console: colour VGA+ 80x25
[   40.745472] Dentry cache hash table entries: 262144 (order: 9, 2097152=20
bytes)
[   40.746781] Inode-cache hash table entries: 131072 (order: 8, 1048576=20
bytes)
[   40.747137] Checking aperture...
[   40.747300] CPU 0: aperture @ ecc8000000 size 32 MB
[   40.747464] Aperture too small (32 MB)
[   40.753296] No AGP bridge found
[   40.765569] Memory: 2060372k/2096832k available (2200k kernel code, 3579=
2k=20
reserved, 669k data, 184k init)
[   40.847841] Calibrating delay using timer specific routine.. 6034.57=20
BogoMIPS (lpj=3D10053716)
[   40.848202] Mount-cache hash table entries: 256
[   40.848437] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[   40.848602] CPU: L2 Cache: 1024K (64 bytes/line)
[   40.848766] CPU: Physical Processor ID: 0
[   40.848928] CPU: Processor Core ID: 0
[   40.849103] Freeing SMP alternatives: 26k freed
[   40.849613] ACPI: Core revision 20070126
[   40.884963] Using local APIC timer interrupts.
[   40.918232] result 12557891
[   40.918393] Detected 12.557 MHz APIC timer.
[   40.921062] Booting processor 1/2 APIC 0x1
[   40.931358] Initializing CPU#1
[   41.014213] Calibrating delay using timer specific routine.. 6030.95=20
BogoMIPS (lpj=3D10046323)
[   41.014218] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64=20
bytes/line)
[   41.014219] CPU: L2 Cache: 1024K (64 bytes/line)
[   41.014221] CPU: Physical Processor ID: 0
[   41.014222] CPU: Processor Core ID: 1
[   41.014303] AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ stepping 03
[   41.017460] Brought up 2 CPUs
[   41.019044] NET: Registered protocol family 16
[   41.019258] ACPI: bus type pci registered
[   41.019428] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[   41.019592] PCI: Not using MMCONFIG.
[   41.019755] PCI: Using configuration type 1
[   41.024096] ACPI: Interpreter enabled
[   41.024259] ACPI: Using IOAPIC for interrupt routing
[   41.024586] Error attaching device data
[   41.024751] Error attaching device data
[   41.024916] Error attaching device data
[   41.025082] Error attaching device data
[   41.031242] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   41.031413] PCI: Probing PCI hardware (bus 00)
[   41.031942] PCI: Transparent bridge - 0000:00:08.0
[   41.032367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   41.032524] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[   41.032638] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[   41.032705] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[   41.032771] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[   41.032836] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[   41.037361] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *5
[   41.037882] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *10
[   41.038385] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *10
[   41.038888] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
[   41.039391] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0,=20
disabled.
[   41.039923] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[   41.040426] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0,=20
disabled.
[   41.040972] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *10
[   41.041475] ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
[   41.041978] ACPI: PCI Interrupt Link [LMAD] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.042510] ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *7
[   41.043012] ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.043544] ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.044088] ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *11
[   41.044593] ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.045126] ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *15
[   41.045630] ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.046189] ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.046722] ACPI: PCI Interrupt Link [UB11] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.047255] ACPI: PCI Interrupt Link [UB12] (IRQs 20 21 22 23) *0,=20
disabled.
[   41.047708] Linux Plug and Play Support v0.97 (c) Adam Belay
[   41.047879] pnp: PnP ACPI init
[   41.048045] ACPI: bus type pnp registered
[   41.051043] pnp: PnP ACPI: found 13 devices
[   41.051205] ACPI: ACPI bus type pnp unregistered
[   41.051432] SCSI subsystem initialized
[   41.051618] libata version 2.21 loaded.
[   41.051654] usbcore: registered new interface driver usbfs
[   41.051834] usbcore: registered new interface driver hub
[   41.052016] usbcore: registered new device driver usb
[   41.052197] PCI: Using ACPI for IRQ routing
[   41.052360] PCI: If a device doesn't work, try "pci=3Drouteirq".  If it=
=20
helps, post a report
[   41.052747] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[   41.053027] hpet0: 3 32-bit timers, 25000000 Hz
[   41.054255] pnp: 00:05: iomem range 0x0-0x0 could not be reserved
[   41.054421] pnp: 00:05: iomem range 0xfee01000-0xfeefffff has been reser=
ved
[   41.054589] pnp: 00:07: iomem range 0xfec00000-0xfec00fff could not be=20
reserved
[   41.054886] pnp: 00:07: iomem range 0xfee00000-0xfee00fff could not be=20
reserved
[   41.055185] pnp: 00:0a: ioport range 0x290-0x29f has been reserved
[   41.055351] pnp: 00:0b: iomem range 0xe0000000-0xefffffff has been reser=
ved
[   41.055519] pnp: 00:0c: iomem range 0x0-0x9ffff could not be reserved
[   41.055685] pnp: 00:0c: iomem range 0xc0000-0xcffff has been reserved
[   41.055850] pnp: 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[   41.056017] pnp: 00:0c: iomem range 0x100000-0x7fffffff could not be=20
reserved
[   41.056338] PCI: Bridge: 0000:00:08.0
[   41.056501]   IO window: c000-dfff
[   41.056664]   MEM window: f9f00000-f9ffffff
[   41.056829]   PREFETCH window: 88000000-880fffff
[   41.056993] PCI: Bridge: 0000:00:0b.0
[   41.057156]   IO window: b000-bfff
[   41.057319]   MEM window: f9e00000-f9efffff
[   41.057451] Time: hpet clocksource has been installed.
[   41.057645]   PREFETCH window: disabled.
[   41.057808] PCI: Bridge: 0000:00:0c.0
[   41.057970]   IO window: disabled.
[   41.058132]   MEM window: disabled.
[   41.058294]   PREFETCH window: disabled.
[   41.058457] PCI: Bridge: 0000:00:0d.0
[   41.058619]   IO window: e000-efff
[   41.058783]   MEM window: fa000000-febfffff
[   41.058946]   PREFETCH window: d0000000-dfffffff
[   41.059110] PCI: Bridge: 0000:00:0e.0
[   41.059272]   IO window: disabled.
[   41.059434]   MEM window: disabled.
[   41.059596]   PREFETCH window: disabled.
[   41.059765] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   41.059770] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   41.059774] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   41.059778] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   41.059783] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   41.059801] NET: Registered protocol family 2
[   41.100619] IP route cache hash table entries: 65536 (order: 7, 524288=20
bytes)
[   41.101145] TCP established hash table entries: 131072 (order: 9, 314572=
8=20
bytes)
[   41.102591] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[   41.103136] TCP: Hash tables configured (established 131072 bind 65536)
[   41.103302] TCP reno registered
[   41.114592] Total HugeTLB memory allocated, 0
[   41.114825] Loading Reiser4. See www.namesys.com for a description of=20
Reiser4.
[   41.115182] io scheduler noop registered
[   41.115352] io scheduler cfq registered (default)
[   41.116320] Boot video device is 0000:04:00.0
[   41.116435] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[   41.116450] assign_interrupt_mode Found MSI capability
[   41.116629] Allocate Port Service[0000:00:0b.0:pcie00]
[   41.116670] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[   41.116685] assign_interrupt_mode Found MSI capability
[   41.116857] Allocate Port Service[0000:00:0c.0:pcie00]
[   41.116893] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[   41.116908] assign_interrupt_mode Found MSI capability
[   41.117080] Allocate Port Service[0000:00:0d.0:pcie00]
[   41.117117] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[   41.117135] assign_interrupt_mode Found MSI capability
[   41.120561] Allocate Port Service[0000:00:0e.0:pcie00]
[   41.120731] input: Power Button (FF) as /class/input/input0
[   41.120895] ACPI: Power Button (FF) [PWRF]
[   41.121116] input: Power Button (CM) as /class/input/input1
[   41.121279] ACPI: Power Button (CM) [PWRB]
[   41.140593] Real Time Clock Driver v1.12ac
[   41.140939] hpet_resources: 0xfed00000 is busy
[   41.140970] Linux agpgart interface v0.102 (c) Dave Jones
[   41.141204] tun: Universal TUN/TAP device driver, 1.6
[   41.141367] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   41.141551] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   41.141716] ide: Assuming 33MHz system bus speed for PIO modes; override=
=20
with idebus=3Dxx
[   41.142031] NFORCE-MCP65: IDE controller at PCI slot 0000:00:09.0
[   41.142207] NFORCE-MCP65: chipset revision 161
[   41.142371] NFORCE-MCP65: not 100% native mode: will probe irqs later
[   41.142539] NFORCE-MCP65: 0000:00:09.0 (rev a1) UDMA133 controller
[   41.142706]     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA,=20
hdb:pio
[   41.143065] Probing IDE interface ide0...
[   41.430036] hda: SAMSUNG SP1213N, ATA DISK drive
[   42.071954] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   42.074576] hda: max request size: 512KiB
[   42.074789] hda: 234493056 sectors (120060 MB) w/8192KiB Cache,=20
CHS=3D16383/255/63, UDMA(100)
[   42.075551] hda: cache flushes supported
[   42.075734]  hda: hda1 hda2 hda3 < hda5 hda6 hda7 >
[   42.116273] ahci 0000:00:0a.0: version 2.2
[   42.116482] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 23
[   42.116653] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LSA0] -> GSI 23=
=20
(level, low) -> IRQ 23
[   43.119478] ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0x=
f=20
impl IDE mode
[   43.119778] ahci 0000:00:0a.0: flags: 64bit led clo pmp pio
[   43.119943] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[   43.120149] scsi0 : ahci
[   43.120365] scsi1 : ahci
[   43.120556] scsi2 : ahci
[   43.120741] scsi3 : ahci
[   43.120927] ata1: SATA max UDMA/133 cmd 0xffffc20000014100 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.121227] ata2: SATA max UDMA/133 cmd 0xffffc20000014180 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.121526] ata3: SATA max UDMA/133 cmd 0xffffc20000014200 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.121826] ata4: SATA max UDMA/133 cmd 0xffffc20000014280 ctl=20
0x0000000000000000 bmdma 0x0000000000000000 irq 315
[   43.934296] ata1: softreset failed (1st FIS failed)
[   43.934461] ata1: reset failed (errno=3D-5), retrying in 10 secs
[   53.885194] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   53.885890] ata1.00: ATA-7: WDC WD1600JS-00MHB1, 10.02E01, max UDMA/133
[   53.886056] ata1.00: 312581808 sectors, multi 16: LBA48
[   53.886804] ata1.00: configured for UDMA/133
[   54.201147] ata2: SATA link down (SStatus 0 SControl 300)
[   54.517101] ata3: SATA link down (SStatus 0 SControl 300)
[   54.833055] ata4: SATA link down (SStatus 0 SControl 300)
[   54.833271] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-00M 10=
=2E0=20
PQ: 0 ANSI: 5
[   54.833623] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   54.833793] sd 0:0:0:0: [sda] Write Protect is off
[   54.833957] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   54.833965] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   54.834287] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (16004=
2=20
MB)
[   54.834455] sd 0:0:0:0: [sda] Write Protect is off
[   54.834619] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   54.834626] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
=20
doesn't support DPO or FUA
[   54.834924]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   54.869055] sd 0:0:0:0: [sda] Attached SCSI disk
[   54.869495] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 22
[   54.869667] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 22=
=20
(level, low) -> IRQ 22
[   54.870288] PCI: Setting latency timer of device 0000:00:02.1 to 64
[   54.870293] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   54.870532] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus=
=20
number 1
[   54.870848] ehci_hcd 0000:00:02.1: debug port 1
[   54.871013] PCI: cache line size of 64 is not supported by device=20
0000:00:02.1
[   54.871022] ehci_hcd 0000:00:02.1: irq 22, io mem 0xf9dfec00
[   54.871191] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10=
=20
Dec 2004
[   54.871572] usb usb1: configuration #1 chosen from 1 choice
[   54.871761] hub 1-0:1.0: USB hub found
[   54.871927] hub 1-0:1.0: 10 ports detected
[   54.976112] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHC=
I)=20
Driver
[   54.976353] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 21
[   54.976523] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 21=
=20
(level, low) -> IRQ 21
[   54.977020] PCI: Setting latency timer of device 0000:00:02.0 to 64
[   54.977025] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   54.977260] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus=
=20
number 2
[   54.977569] ohci_hcd 0000:00:02.0: irq 21, io mem 0xf9dff000
[   55.034680] usb usb2: configuration #1 chosen from 1 choice
[   55.034869] hub 2-0:1.0: USB hub found
[   55.035037] hub 2-0:1.0: 10 ports detected
[   55.139122] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x6=
4=20
irq 1,12
[   55.142186] serio: i8042 KBD port at 0x60,0x64 irq 1
[   55.142352] serio: i8042 AUX port at 0x60,0x64 irq 12
[   55.142569] mice: PS/2 mouse device common for all mice
[   55.169330] input: AT Translated Set 2 keyboard as /class/input/input2
[   55.431622] usb 1-5: new high speed USB device using ehci_hcd and addres=
s 3
[   55.566822] usb 1-5: configuration #1 chosen from 1 choice
[   55.807525] usb 2-4: new full speed USB device using ohci_hcd and addres=
s 2
[   55.963577] usb 2-4: configuration #1 chosen from 1 choice
[   55.969539] hub 2-4:1.0: USB hub found
[   55.972507] hub 2-4:1.0: 4 ports detected
[   56.314740] usb 2-4.1: new full speed USB device using ohci_hcd and addr=
ess=20
3
[   56.449493] usb 2-4.1: configuration #1 chosen from 1 choice
[   56.669944] usb 2-4.3: new low speed USB device using ohci_hcd and addre=
ss=20
4
[   56.783741] usb 2-4.3: configuration #1 chosen from 1 choice
[   56.802767] input: Logitech USB-PS/2 Optical Mouse as /class/input/input3
[   56.802968] input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse]=
 on=20
usb-0000:00:02.0-4.3
[   56.803327] usbcore: registered new interface driver usbhid
[   56.803492] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   56.803690] TCP cubic registered
[   56.803861] NET: Registered protocol family 1
[   56.804026] NET: Registered protocol family 17
[   56.804201] powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processo=
r=20
6000+ processors (version 2.00.00)
[   56.804448] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x6
[   56.804613] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0x8
[   56.804778] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xa
[   56.804943] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xc
[   56.805107] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0xe
[   56.805272] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[   56.805437] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[   56.805602] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[   56.826551] ReiserFS: sda3: found reiserfs format "3.6" with standard=20
journal
[   56.826720] ReiserFS: sda3: using ordered data mode
[   56.836124] ReiserFS: sda3: journal params: device sda3, size 8192, jour=
nal=20
first block 18, max trans len 1024, max batch 900, max commit age 30, max=20
trans age 30
[   56.837467] ReiserFS: sda3: checking transaction log (sda3)
[   56.888740] ReiserFS: sda3: Using r5 hash to sort names
[   56.888915] VFS: Mounted root (reiserfs filesystem) readonly.
[   56.889092] Freeing unused kernel memory: 184k freed
[   61.840593] ReiserFS: sda3: switching to journaled data mode
[   62.230945] r8169 Gigabit Ethernet driver 2.2LK loaded
[   62.231224] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   62.231232] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNEB] -> GSI 19=
=20
(level, low) -> IRQ 19
[   62.231250] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   62.231430] eth0: RTL8168b/8111b at 0xffffc2000016c000, 00:19:66:47:f3:c=
b,=20
IRQ 19
[   62.284221] HPT366: IDE controller at PCI slot 0000:02:0a.0
[   62.284491] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 18
[   62.284499] ACPI: PCI Interrupt 0000:02:0a.0[A] -> Link [LNKC] -> GSI 18=
=20
(level, low) -> IRQ 18
[   62.284508] HPT366: chipset revision 1
[   62.284514] HPT366: using 33 MHz PCI clock
[   62.284516] HPT366: 100% native mode on irq 18
[   62.284524]     ide1: BM-DMA at 0xd000-0xd007, BIOS settings: hdc:pio,=20
hdd:pio
[   62.284536] ACPI: PCI Interrupt 0000:02:0a.1[A] -> Link [LNKC] -> GSI 18=
=20
(level, low) -> IRQ 18
[   62.284544] HPT366: using 33 MHz PCI clock
[   62.284546] HPT366: too many IDE interfaces, no room in table
[   62.284548] HPT366: neither IDE port enabled (BIOS)
[   62.284551] Probing IDE interface ide1...
[   62.988343] hdc: _NEC DVD_RW ND-3500AG, ATAPI CD/DVD-ROM drive
[   63.630192] ide1 at 0xd480-0xd487,0xd402 on irq 18
[   63.632589] hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
[   63.632594] Uniform CD-ROM driver Revision: 3.20
[   64.048482] reiser4: sda5: found disk format 4.0.0.
[   69.431516] reiser4: sda6: found disk format 4.0.0.
[   70.722395] reiser4: hda7: found disk format 4.0.0.
[   71.428725] Adding 1951888k swap on /dev/sda2.  Priority:-1 extents:1=20
across:1951888k
[   74.227887] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 17
[   74.227897] ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKB] -> GSI 17=
=20
(level, low) -> IRQ 17
[   74.230613] Audigy2 value: Special config.
[   78.048887] r8169: eth0: link up
[   78.049039] r8169: eth0: link up
[   82.597555] nvidia: module license 'NVIDIA' taints kernel.
[   82.767839] ACPI: PCI Interrupt Link [LNED] enabled at IRQ 16
[   82.767847] ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNED] -> GSI 16=
=20
(level, low) -> IRQ 16
[   82.767853] PCI: Setting latency timer of device 0000:04:00.0 to 64
[   82.767943] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.23  T=
hu=20
Oct  4 10:27:34 PDT 2007

Gl=FCck Auf,
Volker

--Boundary-00=_t22KHjMNsBZAL+n
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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
YZwAAA==

--Boundary-00=_t22KHjMNsBZAL+n--
