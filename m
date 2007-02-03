Return-Path: <linux-kernel-owner+w=401wt.eu-S1946234AbXBCCQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946234AbXBCCQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946233AbXBCCQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:16:41 -0500
Received: from h150-67.u.wavenet.pl ([217.79.150.67]:35346 "EHLO
	alpha.polcom.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1946230AbXBCCQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:16:39 -0500
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Feb 2007 21:16:38 EST
Date: Sat, 3 Feb 2007 02:49:12 +0100 (CET)
From: Grzegorz Kulewski <kangur@polcom.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: libata_uli puts second channel to PIO4 on 2.6.18
Message-ID: <Pine.LNX.4.63.0702030231150.6097@alpha.polcom.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this SATA PCI card:

00:04.0 Mass storage controller: ALi Corporation ALi M5281 Serial ATA / 
RAID Host Controller (rev a4) (prog-if 85)
         Subsystem: ALi Corporation ALi M5281 Serial ATA / RAID Host 
Controller
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 128, Cache Line Size: 512 bytes
         Interrupt: pin A routed to IRQ 185
         Region 0: I/O ports at d400 [size=8]
         Region 1: I/O ports at d000 [size=4]
         Region 2: I/O ports at b800 [size=8]
         Region 3: I/O ports at b400 [size=4]
         Region 4: I/O ports at b000 [size=16]
         [virtual] Expansion ROM at 88000000 [disabled] [size=64K]

00:04.1 Mass storage controller: ALi Corporation M5228 ALi ATA/RAID 
Controller (rev c6) (prog-if 85)
         Subsystem: ALi Corporation Unknown device 5281
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 128
         Interrupt: pin A routed to IRQ 9
         Region 0: I/O ports at a800 [size=8]
         Region 1: I/O ports at a400 [size=4]
         Region 2: I/O ports at a000 [size=8]
         Region 3: I/O ports at 9800 [size=4]
         Region 4: I/O ports at 9400 [size=16]


It worked very well for half a year but with one disk (IIRC it was even 
plugged into second channel but I wont bet on it). Now I have second disk 
(very similar) and it is always put into PIO4 mode:

[   17.404451] libata version 2.00 loaded.
[   17.404916] sata_uli 0000:00:04.0: version 1.0
[   17.405009] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 18 (level, low) 
-> IRQ 185
[   17.405223] ata1: SATA max UDMA/133 cmd 0xD400 ctl 0xD002 bmdma 0xB000 
irq 185
[   17.405385] ata2: SATA max UDMA/133 cmd 0xB800 ctl 0xB402 bmdma 0xB008 
irq 185
[   17.405519] scsi2 : sata_uli
[   17.858803] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   17.880541] ata1.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ 
(depth 0/32)
[   17.880660] ata1.00: ata1: dev 0 multi count 16
[   17.888858] ata1.00: configured for UDMA/133
[   17.888941] scsi3 : sata_uli
[   18.342469] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   18.343573] ata2.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ 
(depth 0/32)
[   18.343691] ata2.00: ata2: dev 0 multi count 16
[   18.344972] ata2.00: configured for PIO4
[   18.345466]   Vendor: ATA       Model: ST3250620NS       Rev: 3.AE
[   18.346391]   Type:   Direct-Access                      ANSI SCSI 
revision: 05
[   18.347464]   Vendor: ATA       Model: ST3250620NS       Rev: 3.AE
[   18.348390]   Type:   Direct-Access                      ANSI SCSI 
revision: 05
[   18.349457] SCSI device sda: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.350234] sda: Write Protect is off
[   18.350307] sda: Mode Sense: 00 3a 00 00
[   18.351234] SCSI device sda: drive cache: write back
[   18.352233] SCSI device sda: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.352444] sda: Write Protect is off
[   18.352517] sda: Mode Sense: 00 3a 00 00
[   18.353443] SCSI device sda: drive cache: write back
[   18.353522]  sda: sda1 sda2
[   18.371118] sd 2:0:0:0: Attached scsi disk sda
[   18.372221] SCSI device sdb: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.372431] sdb: Write Protect is off
[   18.372504] sdb: Mode Sense: 00 3a 00 00
[   18.373440] SCSI device sdb: drive cache: write back
[   18.374430] SCSI device sdb: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.375218] sdb: Write Protect is off
[   18.375291] sdb: Mode Sense: 00 3a 00 00
[   18.376216] SCSI device sdb: drive cache: write back
[   18.376295]  sdb: unknown partition table
[   18.381481] sd 3:0:0:0: Attached scsi disk sdb


As you probably know this gives very very poor performance. Is there any 
way to make it fast? I tried changing cables and reconnecting them but it 
looks like it does not help. I can't do too much with this hardware since 
it is used as production server. But testing some patches is of course 
possible. On the other hand full kernel upgrade to 2.6.19 or .20 is not 
possible because this kernel has openvz patches and I don't have them for 
.19 or .20 yet.


This is what I am getting from various utilities:

# dmesg
[    0.000000] Linux version 2.6.18-028test010 (root@gamma) (gcc version 
3.4.6 (Gentoo 3.4.6-r2, ssp-3.4.6-1.0, pie-8.7.10)) #3 SMP Thu Jan 18 
02:02:53 CET 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fffb000 (usable)
[    0.000000]  BIOS-e820: 000000007fffb000 - 000000007ffff000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f0410
[    0.000000] On node 0 totalpages: 524283
[    0.000000]   DMA zone: 4096 pages, LIFO batch:0
[    0.000000]   Normal zone: 225280 pages, LIFO batch:31
[    0.000000]   HighMem zone: 294907 pages, LIFO batch:31
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP (v000 ASUS                                  ) @ 
0x000f5640
[    0.000000] ACPI: RSDT (v001 ASUS   TR-DLS   0x42302e31 MSFT 
0x31313031) @ 0x7fffb000
[    0.000000] ACPI: FADT (v001 ASUS   TR-DLS   0x42302e31 MSFT 
0x31313031) @ 0x7fffb0d8
[    0.000000] ACPI: BOOT (v001 ASUS   TR-DLS   0x42302e31 MSFT 
0x31313031) @ 0x7fffb030
[    0.000000] ACPI: MADT (v001 ASUS   TR-DLS   0x42302e31 MSFT 
0x31313031) @ 0x7fffb058
[    0.000000] ACPI: DSDT (v001   ASUS TR-DLS   0x00001000 MSFT 
0x0100000b) @ 0x00000000
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x03] enabled)
[    0.000000] Processor #3 6:11 APIC version 17
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:11 APIC version 17
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 
0-15
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec01000] gsi_base[16])
[    0.000000] IOAPIC[1]: apic_id 3 already used, trying 1
[    0.000000] IOAPIC[1]: apic_id 1, version 17, address 0xfec01000, GSI 
16-31
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec02000] gsi_base[32])
[    0.000000] IOAPIC[2]: apic_id 4, version 17, address 0xfec02000, GSI 
32-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 3 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 
80000000:7ec00000)
[    0.000000] Detected 1266.797 MHz processor.
[   40.450209] Built 1 zonelists.  Total pages: 524283
[   40.450218] Kernel command line: BOOT_IMAGE=linux ro root=40 
real_root=/dev/evms/root udev doevms2 no-hlt
[   40.450629] mapped APIC to ffffd000 (fee00000)
[   40.450636] mapped IOAPIC to ffffc000 (fec00000)
[   40.450641] mapped IOAPIC to ffffb000 (fec01000)
[   40.450647] mapped IOAPIC to ffffa000 (fec02000)
[   40.450654] Enabling fast FPU save and restore... done.
[   40.450660] Enabling unmasked SIMD FPU exception support... done.
[   40.450667] Initializing CPU#0
[   40.450745] PID hash table entries: 4096 (order: 12, 16384 bytes)
[   40.452580] Console: colour VGA+ 80x25
[   40.457081] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[   40.459152] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[   40.602726] Memory: 2069264k/2097132k available (3215k kernel code, 
26736k reserved, 921k data, 216k init, 1179628k highmem)
[   40.602875] Checking if this processor honours the WP bit even in 
supervisor mode... Ok.
[   40.662614] Calibrating delay using timer specific routine.. 2533.95 
BogoMIPS (lpj=1266979)
[   40.664751] Mount-cache hash table entries: 512
[   40.665157] CPU: After generic identify, caps: 0383fbff 00000000 
00000000 00000000 00000000 00000000 00000000
[   40.665180] CPU: After vendor identify, caps: 0383fbff 00000000 
00000000 00000000 00000000 00000000 00000000
[   40.665200] CPU: L1 I cache: 16K, L1 D cache: 16K
[   40.665310] CPU: L2 cache: 512K
[   40.665382] CPU: After all inits, caps: 0383fbff 00000000 00000000 
00000040 00000000 00000000 00000000
[   40.665396] Intel machine check architecture supported.
[   40.665477] Intel machine check reporting enabled on CPU#0.
[   40.665592] Checking 'hlt' instruction... disabled
[   40.665871] Freeing SMP alternatives: 20k freed
[   40.665952] ACPI: Core revision 20060707
[   40.670197] Page beancounter hash is 131072 entries.
[   40.671587] CPU0: Intel(R) Pentium(R) III CPU family      1266MHz 
stepping 01
[   40.671861] Booting processor 1/0 eip 2000
[   40.682256] Initializing CPU#1
[   40.742560] Calibrating delay using timer specific routine.. 2533.13 
BogoMIPS (lpj=1266567)
[   40.742574] CPU: After generic identify, caps: 0383fbff 00000000 
00000000 00000000 00000000 00000000 00000000
[   40.742587] CPU: After vendor identify, caps: 0383fbff 00000000 
00000000 00000000 00000000 00000000 00000000
[   40.742604] CPU: L1 I cache: 16K, L1 D cache: 16K
[   40.742609] CPU: L2 cache: 512K
[   40.742614] CPU: After all inits, caps: 0383fbff 00000000 00000000 
00000040 00000000 00000000 00000000
[   40.742626] Intel machine check architecture supported.
[   40.742633] Intel machine check reporting enabled on CPU#1.
[   40.742978] CPU1: Intel(R) Pentium(R) III CPU - S         1266MHz 
stepping 04
[   40.743597] Total of 2 processors activated (5067.09 BogoMIPS).
[   40.744155] ENABLING IO-APIC IRQs
[   40.744438] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   40.754527] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   40.754608] ...trying to set up timer (IRQ0) through the 8259A ... 
failed.
[   40.754721] timer doesn't work through the IO-APIC - disabling NMI 
Watchdog!
[   40.754807] ...trying to set up timer as Virtual Wire IRQ... works.
[   40.866487] checking TSC synchronization across 2 CPUs: passed.
[    0.000955] Brought up 2 CPUs
[    0.338431] migration_cost=1855
[    0.338816] checking if image is initramfs... it is
[    0.646592] Freeing initrd memory: 2292k freed
[    0.647746] NET: Registered protocol family 16
[    0.648073] ACPI: bus type pci registered
[    0.648732] PCI: PCI BIOS revision 2.10 entry at 0xf1b10, last bus=1
[    0.648825] PCI: Using configuration type 1
[    0.648899] Setting up standard PCI resources
[    0.657179] ACPI: Interpreter enabled
[    0.657265] ACPI: Using IOAPIC for interrupt routing
[    0.658504] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0, disabled.
[    0.659394] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0, disabled.
[    0.660282] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 
14 15)
[    0.661108] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0, disabled.
[    0.661995] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 *12 
14 15)
[    0.662841] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0, disabled.
[    0.663721] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0, disabled.
[    0.664616] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0
[    0.665455] ACPI: PCI Interrupt Link [LNKI] (IRQs 3 4 *5 6 7 9 10 11 12 
14 15)
[    0.666277] ACPI: PCI Interrupt Link [LNKJ] (IRQs 3 4 5 6 7 9 *10 11 12 
14 15)
[    0.667104] ACPI: PCI Interrupt Link [LNKK] (IRQs 3 4 5 6 7 9 10 11 12 
14 15) *0, disabled.
[    0.667987] ACPI: PCI Interrupt Link [LNKL] (IRQs 3 4 5tries: 1024 
(order 0, 4096 bytes)
[    0.776046] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.776403] JFS: nTxBlock = 8192, nTxLock = 65536
[    0.789371] SGI XFS with ACLs, security attributes, realtime, no debug 
enabled
[    0.790022] SGI XFS Quota Management subsystem
[    0.790200] Initializing Cryptographic API
[    0.790281] io scheduler noop registered
[    0.790574] io scheduler cfq registered (default)
[    0.791078] isapnp: Scanning for PnP cards...
[    1.147170] isapnp: No Plug & Play device found
[    1.190889] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing disabled
[    1.191199] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.191472] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.192354] 00:03: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.192760] 00:04: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.194261] RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 
blocksize
[    1.194595] netconsole: not configured, aborting
[    1.194674] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[    1.194760] ide: Assuming 33MHz system bus speed for PIO modes; 
override with idebus=xx
[    1.194943] SvrWks CSB5: IDE controller at PCI slot 0000:00:0f.1
[    1.195044] SvrWks CSB5: chipset revision 147
[    1.195120] SvrWks CSB5: not 100% native mode: will probe irqs later
[    1.195321]     ide0: BM-DMA at 0x7400-0x7407, BIOS settings: hda:pio, 
hdb:pio
[    1.195505]     ide1: BM-DMA at 0x7408-0x740f, BIOS settings: hdc:pio, 
hdd:pio
[    1.195683] Probing IDE interface ide0...
[    1.708783] Probing IDE interface ide1...
[    2.221689] ACPI: PCI Interrupt 0000:01:04.0[A] -> GSI 23 (level, low) 
-> IRQ 169
[    2.367927] sym0: <1010-66> rev 0x1 at pci 0000:01:04.0 irq 169
[    2.370131] sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
[    2.370216] sym0: open drain IRQ line driver, using on-chip SRAM
[    2.370298] sym0: using LOAD/STORE-based firmware.
[    2.370377] sym0: handling phase mismatch from SCRIPTS.
[   10.001807] sym1: SCSI BUS has been reset.
[   10.001888] scsi1 : sym-2.2.3
[   17.404451] libata version 2.00 loaded.
[   17.404916] sata_uli 0000:00:04.0: version 1.0
[   17.405009] ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 18 (level, low) 
-> IRQ 185
[   17.405223] ata1: SATA max UDMA/133 cmd 0xD400 ctl 0xD002 bmdma 0xB000 
irq 185
[   17.405385] ata2: SATA max UDMA/133 cmd 0xB800 ctl 0xB402 bmdma 0xB008 
irq 185
[   17.405519] scsi2 : sata_uli
[   17.858803] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   17.880541] ata1.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ 
(depth 0/32)
[   17.880660] ata1.00: ata1: dev 0 multi count 16
[   17.888858] ata1.00: configured for UDMA/133
[   17.888941] scsi3 : sata_uli
[   18.342469] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   18.343573] ata2.00: ATA-7, max UDMA/133, 488397168 sectors: LBA48 NCQ 
(depth 0/32)
[   18.343691] ata2.00: ata2: dev 0 multi count 16
[   18.344972] ata2.00: configured for PIO4
[   18.345466]   Vendor: ATA       Model: ST3250620NS       Rev: 3.AE
[   18.346391]   Type:   Direct-Access                      ANSI SCSI 
revision: 05
[   18.347464]   Vendor: ATA       Model: ST3250620NS       Rev: 3.AE
[   18.348390]   Type:   Direct-Access                      ANSI SCSI 
revision: 05
[   18.349457] SCSI device sda: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.350234] sda: Write Protect is off
[   18.350307] sda: Mode Sense: 00 3a 00 00
[   18.351234] SCSI device sda: drive cache: write back
[   18.352233] SCSI device sda: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.352444] sda: Write Protect is off
[   18.352517] sda: Mode Sense: 00 3a 00 00
[   18.353443] SCSI device sda: drive cache: write back
[   18.353522]  sda: sda1 sda2
[   18.371118] sd 2:0:0:0: Attached scsi disk sda
[   18.372221] SCSI device sdb: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.372431] sdb: Write Protect is off
[   18.372504] sdb: Mode Sense: 00 3a 00 00
[   18.373440] SCSI device sdb: drive cache: write back
[   18.374430] SCSI device sdb: 488397168 512-byte hdwr sectors (250059 
MB)
[   18.375218] sdb: Write Protect is off
[   18.375291] sdb: Mode Sense: 00 3a 00 00
[   18.376216] SCSI device sdb: drive cache: write back
[   18.376295]  sdb: unknown partition table
[   18.381481] sd 3:0:0:0: Attached scsi disk sdb
[   18.381688] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[   18.381774] PNP: PS/2 controller doesn't have AUX irq; using default 12
[   18.383816] serio: i8042 AUX port at 0x60,0x64 irq 12
[   18.383956] serio: i8042 KBD port at 0x60,0x64 irq 1
[   18.384135] mice: PS/2 mouse device common for all mice
[   18.384237] md: linear personality registered for level -1
[   18.384317] md: raid0 personality registered for level 0
[   18.384396] md: raid1 personality registered for level 1
[   18.384479] md: raid10 personality registered for level 10
[   18.401283] raid6: int32x1    410 MB/s
[   18.418290] raid6: int32x2    515 MB/s
[   18.435336] raid6: int32x4    363 MB/s
[   18.452181] raid6: int32x8    339 MB/s
[   18.469201] raid6: mmxx1     1218 MB/s
[   18.486181] raid6: mmxx2     1468 MB/s
[   18.503165] raid6: sse1x1    1144 MB/s
[   18.520121] raid6: sse1x2    1472 MB/s
[   18.520194] raid6: using algorithm sse1x2 (1472 MB/s)
[   18.520275] md: raid6 personality registered for level 6
[   18.520356] md: raid5 personality registered for level 5
[   18.520436] md: raid4 personality registered for level 4
[   18.520516] raid5: automatically using best checksumming function: 
pIII_sse
[   18.525116]    pIII_sse  :  2936.000 MB/sec
[   18.525191] raid5: using function: pIII_sse (2936.000 MB/sec)
[   18.525273] md: multipath personality registered for level -4
[   18.525357] md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
[   18.525440] md: bitmap version 4.39
[   18.525761] device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: 
dm-devel@redhat.com
[   18.526030] device-mapper: multipath: version 1.0.4 loaded
[   18.526117] device-mapper: multipath round-robin: version 1.0.0 loaded
[   18.526304] TCP bic registered
[   18.526481] Starting balanced_irq
[   18.526563] Using IPI Shortcut mode
[   18.526865] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   18.527117] Time: tsc clocksource has been installed.
[   18.527306] Freeing unused kernel memory: 216k freed
[   18.575330] input: AT Translated Set 2 keyboard as /class/input/input0
[   20.746542] ReiserFS: dm-4: found reiserfs format "3.6" with standard 
journal
[   20.951697] ReiserFS: dm-4: using ordered data mode
[   20.962477] ReiserFS: dm-4: journal params: device dm-4, size 8192, 
journal first block 18, max trans len 1024, max batch 900, max commit age 
30, max trans age 30
[   20.964729] ReiserFS: dm-4: checking transaction log (dm-4)
[   20.998074] ReiserFS: dm-4: Using r5 hash to sort names
[   21.756494] NET: Registered protocol family 1
[   24.535738] piix4_smbus 0000:00:0f.0: Found 0000:00:0f.0 device
[   24.547532] e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
[   24.547546] e100: Copyright(c) 1999-2005 Intel Corporation
[   24.547642] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 20 (level, low) 
-> IRQ 193
[   24.571116] e100: eth0: e100_probe: addr 0xfe000000, irq 193, MAC addr 
00:E0:18:59:69:9D
[   27.230063] ReiserFS: dm-7: found reiserfs format "3.6" with standard 
journal
[   27.412980] ReiserFS: dm-7: using ordered data mode
[   27.421903] ReiserFS: dm-7: journal params: device dm-7, size 8192, 
journal first block 18, max trans len 1024, max batch 900, max commit age 
30, max trans age 30
[   27.424180] ReiserFS: dm-7: checking transaction log (dm-7)
[   27.452356] ReiserFS: dm-7: Using r5 hash to sort names
[   27.479944] ReiserFS: dm-9: found reiserfs format "3.6" with standard 
journal
[   32.988256] ReiserFS: dm-9: using ordered data mode
[   33.003544] ReiserFS: dm-9: journal params: device dm-9, size 8192, 
journal first block 18, max trans len 1024, max batch 900, max commit age 
30, max trans age 30
[   33.005611] ReiserFS: dm-9: checking transaction log (dm-9)
[   33.053562] ReiserFS: dm-9: Using r5 hash to sort names
[   33.127199] ReiserFS: dm-2: found reiserfs format "3.6" with standard 
journal
[   39.540725] ReiserFS: dm-2: using ordered data mode
[   39.558141] ReiserFS: dm-2: journal params: device dm-2, size 8192, 
journal first block 18, max trans len 1024, max batch 900, max commit age 
30, max trans age 30
[   39.560283] ReiserFS: dm-2: checking transaction log (dm-2)
[   39.611942] ReiserFS: dm-2: Using r5 hash to sort names
[   41.866945] Adding 1048568k swap on /var/swapfile.  Priority:-1 
extents:211 across:1058640k
[  178.626262] ip_tables: (C) 2000-2006 Netfilter Core Team
[  179.812674] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
[  180.962075] NET: Registered protocol family 17
[  185.132332] NET: Unregistered protocol family 17
[  185.141710] NET: Registered protocol family 17


# hdparm -vItT /dev/sda

/dev/sda:
  IO_support   =  0 (default 16-bit)
  readonly     =  0 (off)
  readahead    = 256 (on)
  geometry     = 30401/255/63, sectors = 488397168, start = 0

ATA device, with non-removable media
         Model Number:       ST3250620NS
         Serial Number:      5QE08MGB
         Firmware Revision:  3.AEE
Standards:
         Supported: 7 6 5 4
         Likely used: 7
Configuration:
         Logical         max     current
         cylinders       16383   16383
         heads           16      16
         sectors/track   63      63
         --
         CHS current addressable sectors:   16514064
         LBA    user addressable sectors:  268435455
         LBA48  user addressable sectors:  488397168
         device size with M = 1024*1024:      238475 MBytes
         device size with M = 1000*1000:      250059 MBytes (250 GB)
Capabilities:
         LBA, IORDY(can be disabled)
         Queue depth: 32
         Standby timer values: spec'd by Standard, no device specific 
minimum
         R/W multiple sector transfer: Max = 16  Current = 16
         Recommended acoustic management value: 254, current value: 0
         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
              Cycle time: min=120ns recommended=120ns
         PIO: pio0 pio1 pio2 pio3 pio4
              Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
         Enabled Supported:
            *    SMART feature set
                 Security Mode feature set
            *    Power Management feature set
            *    Write cache
            *    Look-ahead
            *    Host Protected Area feature set
            *    WRITE_BUFFER command
            *    READ_BUFFER command
            *    DOWNLOAD_MICROCODE
                 SET_MAX security extension
            *    48-bit Address feature set
            *    Device Configuration Overlay feature set
            *    Mandatory FLUSH_CACHE
            *    FLUSH_CACHE_EXT
            *    SMART error logging
            *    SMART self-test
            *    General Purpose Logging feature set
                 64-bit World wide name
                 unknown 84[11]
                 unknown 84[12]
            *    SATA-I signaling speed (1.5Gb/s)
            *    Native Command Queueing (NCQ)
            *    Phy event counters
                 Device-initiated interface power management
            *    Software settings preservation
Security:
         Master password revision code = 65534
                 supported
         not     enabled
         not     locked
         not     frozen
         not     expired: security count
         not     supported: enhanced erase
Checksum: correct
  Timing cached reads:   868 MB in  2.01 seconds = 432.39 MB/sec
  Timing buffered disk reads:  198 MB in  3.03 seconds =  65.44 MB/sec


# hdparm -vItT /dev/sdb

/dev/sdb:
  IO_support   =  0 (default 16-bit)
  readonly     =  0 (off)
  readahead    = 256 (on)
  geometry     = 30401/255/63, sectors = 488397168, start = 0

ATA device, with non-removable media
         Model Number:       ST3250620NS
         Serial Number:      9QF1Q5WE
         Firmware Revision:  3.AEG
Standards:
         Supported: 7 6 5 4
         Likely used: 7
Configuration:
         Logical         max     current
         cylinders       16383   16383
         heads           16      16
         sectors/track   63      63
         --
         CHS current addressable sectors:   16514064
         LBA    user addressable sectors:  268435455
         LBA48  user addressable sectors:  488397168
         device size with M = 1024*1024:      238475 MBytes
         device size with M = 1000*1000:      250059 MBytes (250 GB)
Capabilities:
         LBA, IORDY(can be disabled)
         Queue depth: 32
         Standby timer values: spec'd by Standard, no device specific 
minimum
         R/W multiple sector transfer: Max = 16  Current = 16
         Advanced power management level: unknown setting (0xfefe)
         Recommended acoustic management value: 254, current value: 0
         DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
              Cycle time: min=120ns recommended=120ns
         PIO: pio0 pio1 pio2 pio3 pio4
              Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
         Enabled Supported:
            *    SMART feature set
                 Security Mode feature set
            *    Power Management feature set
            *    Write cache
            *    Look-ahead
            *    Host Protected Area feature set
            *    WRITE_BUFFER command
            *    READ_BUFFER command
            *    DOWNLOAD_MICROCODE
            *    Advanced Power Management feature set
                 SET_MAX security extension
            *    48-bit Address feature set
            *    Device Configuration Overlay feature set
            *    Mandatory FLUSH_CACHE
            *    FLUSH_CACHE_EXT
            *    SMART error logging
            *    SMART self-test
            *    General Purpose Logging feature set
                 64-bit World wide name
                 unknown 84[11]
                 unknown 84[12]
            *    SATA-I signaling speed (1.5Gb/s)
            *    Native Command Queueing (NCQ)
            *    Phy event counters
                 Device-initiated interface power management
            *    Software settings preservation
Security:
         Master password revision code = 65534
                 supported
         not     enabled
         not     locked
         not     frozen
         not     expired: security count
         not     supported: enhanced erase
Checksum: correct
  Timing cached reads:   864 MB in  2.00 seconds = 431.88 MB/sec
  Timing buffered disk reads:   14 MB in  3.34 seconds =   4.19 MB/sec


# smartctl -d ata -a /dev/sda
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3250620NS
Serial Number:    5QE08MGB
Firmware Version: 3.AEE
User Capacity:    250,059,350,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat Feb  3 01:42:33 2007 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                         was completed without error.
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test has 
ever
                                         been run.
Total time to complete Offline
data collection:                 ( 430) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon 
new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         No Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (  92) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   106   089   006    Pre-fail  Always 
-       11053265
   3 Spin_Up_Time            0x0003   091   090   000    Pre-fail  Always 
-       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always 
-       16
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always 
-       0
   7 Seek_Error_Rate         0x000f   080   060   030    Pre-fail  Always 
-       110081628
   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always 
-       479
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always 
-       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always 
-       113
187 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
-       0
189 Unknown_Attribute       0x003a   100   100   000    Old_age   Always 
-       0
190 Unknown_Attribute       0x0022   056   051   045    Old_age   Always 
-       808189996
194 Temperature_Celsius     0x0022   044   049   000    Old_age   Always 
-       44 (Lifetime Min/Max 0/29)
195 Hardware_ECC_Recovered  0x001a   063   058   000    Old_age   Always 
-       6
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
-       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline 
-       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
-       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline 
-       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always 
-       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%       478 
-
# 2  Extended offline    Interrupted (host reset)      80%       473 
-
# 3  Short offline       Completed without error       00%       473 
-
# 4  Extended offline    Completed without error       00%       393 
-
# 5  Short offline       Completed without error       00%       391 
-
# 6  Extended offline    Completed without error       00%        15 
-
# 7  Short offline       Completed without error       00%        14 
-

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute 
delay.


# smartctl -d ata -a /dev/sdb
smartctl version 5.36 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3250620NS
Serial Number:    9QF1Q5WE
Firmware Version: 3.AEG
User Capacity:    250,059,350,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat Feb  3 01:43:04 2007 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                         was completed without error.
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test has 
ever
                                         been run.
Total time to complete Offline
data collection:                 ( 430) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon 
new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         No Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (  92) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED 
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   112   100   006    Pre-fail  Always 
-       49974568
   3 Spin_Up_Time            0x0003   096   095   000    Pre-fail  Always 
-       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always 
-       6
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always 
-       0
   7 Seek_Error_Rate         0x000f   063   060   030    Pre-fail  Always 
-       2188910
   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always 
-       24
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always 
-       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always 
-       22
187 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
-       0
189 Unknown_Attribute       0x003a   100   100   000    Old_age   Always 
-       0
190 Unknown_Attribute       0x0022   056   051   045    Old_age   Always 
-       757858348
194 Temperature_Celsius     0x0022   044   049   000    Old_age   Always 
-       44 (Lifetime Min/Max 0/33)
195 Hardware_ECC_Recovered  0x001a   073   071   000    Old_age   Always 
-       193550671
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
-       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline 
-       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
-       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline 
-       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always 
-       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%         4 
-
# 2  Extended offline    Interrupted (host reset)      60%         2 
-
# 3  Short offline       Completed without error       00%         1 
-

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute 
delay.

More info available on request.

Any ideas?


Thanks in advance,

Grzegorz Kulewski

