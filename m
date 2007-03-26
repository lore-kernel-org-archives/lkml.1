Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXCZRch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXCZRch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbXCZRcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:32:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:35625 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306AbXCZRcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=pAqR/c1rDeDSKhQdrZU/2oU1agbgXmpxHj+vc8tBpQWtoHG9oV6mtqrmpru/TdQKT9yQ2nFtIDmNX9bw/FkrN5/QyohXSHcUVtfYMPJRXhJ4KhaMclM+yuilfYj3JG6XoYbBxeY5aTL5U7KWx5ItSFIooTkApOywcmBkUh9aDco=
Message-ID: <460803A2.2080504@gmail.com>
Date: Mon, 26 Mar 2007 14:32:18 -0300
From: =?ISO-8859-1?Q?Mat=ED=ADas_Alejandro_Torres?= <torresmat@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SB600 and SATA disk in 2.6.21-rc5
Content-Type: multipart/mixed;
 boundary="------------060400070902090004010801"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060400070902090004010801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ubuntu 6.10  with kernel version 2.6.21-rc5 compiled with ahci support

I have a MSI K9AGM motherboard that ships with four SB600 SATA ports but 
when the kernel is booting it shows some errors and the SATA disk is not 
detected.

Here is what dmesg throws:

dmesg:


[    1.332000] ide: Assuming 33MHz system bus speed for PIO modes; 
override with idebus=xx
[    1.332000] ahci 0000:00:12.0: version 2.1
[    1.332000] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, 
low) -> IRQ 16
[    2.336000] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 
0xf impl SATA mode
[    2.336000] ahci 0000:00:12.0: flags: 64bit ncq ilck pm led clo pmp 
pio slum part
[    2.336000] ata1: SATA max UDMA/133 cmd 0xf8824d00 ctl 0x00000000 
bmdma 0x00000000 irq 222
[    2.336000] ata2: SATA max UDMA/133 cmd 0xf8824d80 ctl 0x00000000 
bmdma 0x00000000 irq 222
[    2.336000] ata3: SATA max UDMA/133 cmd 0xf8824e00 ctl 0x00000000 
bmdma 0x00000000 irq 222
[    2.336000] ata4: SATA max UDMA/133 cmd 0xf8824e80 ctl 0x00000000 
bmdma 0x00000000 irq 222
[    2.336000] scsi0 : ahci
[    2.648000] ata1: SATA link down (SStatus 0 SControl 300)
[    2.648000] scsi1 : ahci
[    3.132000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   33.132000] ata2.00: qc timeout (cmd 0xec)
[   33.132000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   34.112000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   64.112000] ata2.00: qc timeout (cmd 0xec)
[   64.112000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   64.112000] ata2.00: limiting speed to UDMA7:PIO5
[   65.092000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   95.092000] ata2.00: qc timeout (cmd 0xec)
[   95.092000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   96.072000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   96.072000] scsi2 : ahci
[   96.384000] ata3: SATA link down (SStatus 0 SControl 300)
[   96.384000] scsi3 : ahci
[   96.696000] ata4: SATA link down (SStatus 0 SControl 300)



##############################
lspci -vvv:

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA 
(prog-if 01 [AHCI 1.0])
   Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 64, Cache Line Size: 64 bytes
   Interrupt: pin A routed to IRQ 222
   Region 0: I/O ports at e800 [size=8]
   Region 1: I/O ports at e400 [size=4]
   Region 2: I/O ports at e000 [size=8]
   Region 3: I/O ports at dc00 [size=4]
   Region 4: I/O ports at d800 [size=16]
   Region 5: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
   Capabilities: [60] Power Management version 2
       Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
       Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/2 
Enable+
       Address: 00000000fee0300c  Data: 41b9
   Capabilities: [70] #12 [0010]


##############################
lshw

*-pci:0
         description: Host bridge
         product: RS480 Host Bridge
         vendor: ATI Technologies Inc
         physical id: 100
         bus info: pci@00:00.0
         version: 10
         width: 32 bits
         clock: 66MHz
       *-pci:0
            description: PCI bridge
            product: RS480 PCI-X Root Port
            vendor: ATI Technologies Inc
            physical id: 2
            bus info: pci@00:02.0
            version: 00
            width: 32 bits
            clock: 33MHz
            capabilities: pci normal_decode bus_master cap_list
            configuration: driver=pcieport-driver
       [...]
       *-storage
            description: SATA controller
            product: SB600 Non-Raid-5 SATA
            vendor: ATI Technologies Inc
            physical id: 12
            bus info: pci@00:12.0
            version: 00
            width: 32 bits
            clock: 66MHz
            capabilities: storage ahci_1.0 bus_master cap_list
            configuration: driver=ahci
            resources: ioport:e800-e807 ioport:e400-e403 
ioport:e000-e007 ioport:dc00-dc03 ioport:d800-d80f 
iomemory:febffc00-febfffff irq:222
       *-usb:0
            [...]



I attach the output of the lshw lspci -vvv and dmesg commands (all three 
of them executed as root).

Matias

--------------060400070902090004010801
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

[    0.000000] Linux version 2.6.21-rc5 (root@matias) (gcc version 4.1.2 20060928 (prerelease) (Ubuntu 4.1.1-13ubuntu5)) #1 SMP Sun Mar 25 23:25:22 ART 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000e4000 size: 000000000001c000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000003fec0000 end: 000000003ffc0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003ffc0000 size: 000000000000e000 end: 000000003ffce000 type: 3
[    0.000000] copy_e820_map() start: 000000003ffce000 size: 0000000000032000 end: 0000000040000000 type: 4
[    0.000000] copy_e820_map() start: 00000000ff780000 size: 0000000000880000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
[    0.000000]  BIOS-e820: 000000003ffc0000 - 000000003ffce000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ffce000 - 0000000040000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000ff780
[    0.000000] Entering add_active_range(0, 0, 262080) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   262080
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   262080
[    0.000000] On node 0 totalpages: 262080
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 255 pages used for memmap
[    0.000000]   HighMem zone: 32449 pages, LIFO batch:7
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F84E0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3FFC0000, 0040 (r1 A M I  OEMRSDT   7000604 MSFT       97)
[    0.000000] ACPI: FACP 3FFC0200, 0084 (r2 A M I  OEMFACP   7000604 MSFT       97)
[    0.000000] ACPI: DSDT 3FFC0480, 3DC9 (r1  AMMR_ AMMR_B36      B36 INTL 20051117)
[    0.000000] ACPI: FACS 3FFCE000, 0040
[    0.000000] ACPI: APIC 3FFC0390, 005C (r1 A M I  OEMAPIC   7000604 MSFT       97)
[    0.000000] ACPI: MCFG 3FFC03F0, 003C (r1 A M I  OEMMCFG   7000604 MSFT       97)
[    0.000000] ACPI: WDRT 3FFC0430, 0047 (r1 A M I  OEMWDRT   7000604 MSFT       97)
[    0.000000] ACPI: OEMB 3FFCE040, 0060 (r1 A M I  AMI_OEM   7000604 MSFT       97)
[    0.000000] ACPI: HPET 3FFC4250, 0038 (r1 A M I  OEMHPET   7000604 MSFT       97)
[    0.000000] ACPI: SSDT 3FFC4290, 01C4 (r1 A M I  ACPI2PPC        1 AMI         1)
[    0.000000] ATI board detected. Disabling timer routing over 8254.
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8000 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:bf780000)
[    0.000000] Built 1 zonelists.  Total pages: 260033
[    0.000000] Kernel command line: root=/dev/hda5 ro
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2000.218 MHz processor.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Memory: 1029748k/1048320k available (2099k kernel code, 17928k reserved, 970k data, 332k init, 130816k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.000000]       .init : 0xc0406000 - 0xc0459000   ( 332 kB)
[    0.000000]       .data : 0xc030cc9c - 0xc03ff754   ( 970 kB)
[    0.000000]       .text : 0xc0100000 - 0xc030cc9c   (2099 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[    0.000000] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.000000] hpet0: 4 32-bit timers, 14318180 Hz
[    0.084000] Calibrating delay using timer specific routine.. 4003.20 BogoMIPS (lpj=8006411)
[    0.084000] Security Framework v1.0.0 initialized
[    0.084000] SELinux:  Disabled at boot.
[    0.084000] Mount-cache hash table entries: 512
[    0.084000] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f
[    0.084000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.084000] CPU: L2 Cache: 256K (64 bytes/line)
[    0.084000] CPU 0(2) -> Core 0
[    0.084000] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000001f
[    0.084000] Compat vDSO mapped to ffffe000.
[    0.084000] Checking 'hlt' instruction... OK.
[    0.100000] SMP alternatives: switching to UP code
[    0.100000] ACPI: Core revision 20070126
[    0.100000] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3600+ stepping 02
[    0.100000] SMP alternatives: switching to SMP code
[    0.100000] Booting processor 1/1 eip 3000
[    0.112000] Initializing CPU#1
[    0.192000] Calibrating delay using timer specific routine.. 4000.15 BogoMIPS (lpj=8000303)
[    0.192000] CPU: After generic identify, caps: 178bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000001f
[    0.192000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.192000] CPU: L2 Cache: 256K (64 bytes/line)
[    0.192000] CPU 1(2) -> Core 1
[    0.192000] CPU: After all inits, caps: 178bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000001f
[    0.192000] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3600+ stepping 02
[    0.192000] Total of 2 processors activated (8003.35 BogoMIPS).
[    0.192000] ENABLING IO-APIC IRQs
[    0.192000] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.232000] Brought up 2 CPUs
[    0.272000] migration_cost=4000
[    0.272000] NET: Registered protocol family 16
[    0.272000] EISA bus registered
[    0.272000] ACPI: bus type pci registered
[    0.272000] PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
[    0.272000] PCI: Not using MMCONFIG.
[    0.272000] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=2
[    0.272000] PCI: Using configuration type 1
[    0.272000] Setting up standard PCI resources
[    0.316000] ACPI: Interpreter enabled
[    0.316000] ACPI: (supports S0 S1 S3 S4 S5)
[    0.316000] ACPI: Using IOAPIC for interrupt routing
[    0.316000] Error attaching device data
[    0.316000] Error attaching device data
[    0.324000] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.324000] PCI: Probing PCI hardware (bus 00)
[    0.324000] 0000:00:14.1: trying to change BAR0 from 0000 to 01F0
[    0.324000] 0000:00:14.1: trying to change BAR1 from 0000 to 03F4
[    0.324000] 0000:00:14.1: trying to change BAR2 from 0000 to 0170
[    0.324000] 0000:00:14.1: trying to change BAR3 from 0000 to 0374
[    0.324000] Boot video device is 0000:01:00.0
[    0.324000] PCI: Transparent bridge - 0000:00:14.4
[    0.324000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.324000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.324000] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.340000] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.340000] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.340000] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.340000] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.340000] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.340000] ACPI: PCI Interrupt Link [LNKF] (IRQs 9) *0, disabled.
[    0.344000] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.344000] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[    0.344000] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.344000] pnp: PnP ACPI init
[    0.348000] pnp: PnP ACPI: found 17 devices
[    0.348000] PnPBIOS: Disabled by ACPI PNP
[    0.348000] SCSI subsystem initialized
[    0.348000] libata version 2.20 loaded.
[    0.348000] PCI: Using ACPI for IRQ routing
[    0.348000] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.356000] NET: Registered protocol family 8
[    0.356000] NET: Registered protocol family 20
[    0.356000] pnp: 00:01: iomem range 0x0-0x0 could not be reserved
[    0.356000] pnp: 00:09: iomem range 0xffb80000-0xffbfffff could not be reserved
[    0.356000] pnp: 00:09: iomem range 0xfed00000-0xfed003ff could not be reserved
[    0.356000] pnp: 00:09: iomem range 0xff6ff000-0xff6ff7ff has been reserved
[    0.356000] pnp: 00:09: iomem range 0xfff80000-0xffffffff could not be reserved
[    0.356000] pnp: 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.356000] pnp: 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.356000] pnp: 00:0e: ioport range 0xa00-0xa0f has been reserved
[    0.356000] pnp: 00:0e: ioport range 0x600-0x60f has been reserved
[    0.356000] pnp: 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
[    0.356000] pnp: 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.356000] pnp: 00:10: iomem range 0xc0000-0xcffff could not be reserved
[    0.356000] pnp: 00:10: iomem range 0xe0000-0xfffff could not be reserved
[    0.356000] pnp: 00:10: iomem range 0x100000-0x3fffffff could not be reserved
[    0.360000] Time: hpet clocksource has been installed.
[    0.388000] PCI: Bridge: 0000:00:02.0
[    0.388000]   IO window: disabled.
[    0.388000]   MEM window: fa900000-fe9fffff
[    0.388000]   PREFETCH window: bff00000-dfefffff
[    0.388000] PCI: Bridge: 0000:00:14.4
[    0.388000]   IO window: b000-bfff
[    0.388000]   MEM window: fea00000-feafffff
[    0.388000]   PREFETCH window: 50000000-500fffff
[    0.388000] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.388000] NET: Registered protocol family 2
[    0.428000] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.428000] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[    0.428000] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.428000] TCP: Hash tables configured (established 131072 bind 65536)
[    0.428000] TCP reno registered
[    0.440000] checking if image is initramfs... it is
[    0.852000] Freeing initrd memory: 5020k freed
[    0.852000] audit: initializing netlink socket (disabled)
[    0.852000] audit(1174910725.848:1): initialized
[    0.852000] highmem bounce pool size: 64 pages
[    0.852000] VFS: Disk quotas dquot_6.5.1
[    0.852000] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.852000] io scheduler noop registered
[    0.852000] io scheduler anticipatory registered
[    0.852000] io scheduler deadline registered
[    0.852000] io scheduler cfq registered (default)
[    0.952000] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.952000] assign_interrupt_mode Found MSI capability
[    0.952000] Allocate Port Service[0000:00:02.0:pcie00]
[    0.952000] isapnp: Scanning for PnP cards...
[    1.304000] isapnp: No Plug & Play device found
[    1.332000] Real Time Clock Driver v1.12ac
[    1.332000] hpet_resources: 0xfed00000 is busy
[    1.332000] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.332000] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.332000] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.332000] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    1.332000] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[    1.332000] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    1.332000] ahci 0000:00:12.0: version 2.1
[    1.332000] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 16
[    2.336000] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    2.336000] ahci 0000:00:12.0: flags: 64bit ncq ilck pm led clo pmp pio slum part 
[    2.336000] ata1: SATA max UDMA/133 cmd 0xf8824d00 ctl 0x00000000 bmdma 0x00000000 irq 222
[    2.336000] ata2: SATA max UDMA/133 cmd 0xf8824d80 ctl 0x00000000 bmdma 0x00000000 irq 222
[    2.336000] ata3: SATA max UDMA/133 cmd 0xf8824e00 ctl 0x00000000 bmdma 0x00000000 irq 222
[    2.336000] ata4: SATA max UDMA/133 cmd 0xf8824e80 ctl 0x00000000 bmdma 0x00000000 irq 222
[    2.336000] scsi0 : ahci
[    2.648000] ata1: SATA link down (SStatus 0 SControl 300)
[    2.648000] scsi1 : ahci
[    3.132000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   33.132000] ata2.00: qc timeout (cmd 0xec)
[   33.132000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   34.112000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   64.112000] ata2.00: qc timeout (cmd 0xec)
[   64.112000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   64.112000] ata2.00: limiting speed to UDMA7:PIO5
[   65.092000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   95.092000] ata2.00: qc timeout (cmd 0xec)
[   95.092000] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
[   96.072000] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   96.072000] scsi2 : ahci
[   96.384000] ata3: SATA link down (SStatus 0 SControl 300)
[   96.384000] scsi3 : ahci
[   96.696000] ata4: SATA link down (SStatus 0 SControl 300)
[   96.696000] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   96.696000] serio: i8042 KBD port at 0x60,0x64 irq 1
[   96.696000] serio: i8042 AUX port at 0x60,0x64 irq 12
[   96.696000] mice: PS/2 mouse device common for all mice
[   96.696000] EISA: Probing bus 0 at eisa.0
[   96.696000] EISA: Detected 0 cards.
[   96.696000] TCP cubic registered
[   96.696000] NET: Registered protocol family 1
[   96.696000] Starting balanced_irq
[   96.696000] Using IPI No-Shortcut mode
[   96.696000] Freeing unused kernel memory: 332k freed
[   96.716000] input: AT Translated Set 2 keyboard as /class/input/input0
[   96.772000] ACPI: duty_cycle spans bit 4
[   97.176000] SB600_PATA: IDE controller at PCI slot 0000:00:14.1
[   97.176000] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 17
[   97.176000] SB600_PATA: chipset revision 0
[   97.176000] SB600_PATA: not 100% native mode: will probe irqs later
[   97.176000]     ide0: BM-DMA at 0xff00-0xff07, BIOS settings: hda:DMA, hdb:DMA
[   97.176000] Probing IDE interface ide0...
[   97.464000] hda: HDS728080PLAT20, ATA DISK drive
[   97.912000] hdb: ASUS DRW-1608P3S, ATAPI CD/DVD-ROM drive
[   97.968000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   97.988000] hda: max request size: 512KiB
[   97.988000] hda: 160836480 sectors (82348 MB) w/1719KiB Cache, CHS=16383/255/63, UDMA(100)
[   97.988000] hda: cache flushes supported
[   97.988000]  hda: hda1 hda2 < hda5 hda6 >
[   98.048000] hdb: ATAPI 63X DVD-ROM DVD-R-RAM CD-R/RW drive, 2000kB Cache, UDMA(66)
[   98.048000] Uniform CD-ROM driver Revision: 3.20
[   98.292000] Probing IDE interface ide1...
[   98.344000] usbcore: registered new interface driver usbfs
[   98.344000] usbcore: registered new interface driver hub
[   98.344000] usbcore: registered new device driver usb
[   98.344000] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[   98.344000] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 17
[   98.344000] ohci_hcd 0000:00:13.0: OHCI Host Controller
[   98.344000] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 1
[   98.344000] ohci_hcd 0000:00:13.0: irq 17, io mem 0xfebfe000
[   98.404000] usb usb1: configuration #1 chosen from 1 choice
[   98.404000] hub 1-0:1.0: USB hub found
[   98.404000] hub 1-0:1.0: 2 ports detected
[   98.508000] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 18
[   98.508000] ohci_hcd 0000:00:13.1: OHCI Host Controller
[   98.508000] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 2
[   98.508000] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfebfd000
[   98.568000] usb usb2: configuration #1 chosen from 1 choice
[   98.568000] hub 2-0:1.0: USB hub found
[   98.568000] hub 2-0:1.0: 2 ports detected
[   98.672000] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 19
[   98.672000] ohci_hcd 0000:00:13.2: OHCI Host Controller
[   98.672000] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 3
[   98.672000] ohci_hcd 0000:00:13.2: irq 19, io mem 0xfebfc000
[   98.732000] usb usb3: configuration #1 chosen from 1 choice
[   98.732000] hub 3-0:1.0: USB hub found
[   98.732000] hub 3-0:1.0: 2 ports detected
[   98.836000] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 18
[   98.836000] ohci_hcd 0000:00:13.3: OHCI Host Controller
[   98.836000] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 4
[   98.836000] ohci_hcd 0000:00:13.3: irq 18, io mem 0xfebfb000
[   98.896000] usb usb4: configuration #1 chosen from 1 choice
[   98.896000] hub 4-0:1.0: USB hub found
[   98.896000] hub 4-0:1.0: 2 ports detected
[   99.000000] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 19
[   99.000000] ohci_hcd 0000:00:13.4: OHCI Host Controller
[   99.000000] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 5
[   99.000000] ohci_hcd 0000:00:13.4: irq 19, io mem 0xfebfa000
[   99.060000] usb usb5: configuration #1 chosen from 1 choice
[   99.060000] hub 5-0:1.0: USB hub found
[   99.060000] hub 5-0:1.0: 2 ports detected
[   99.164000] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 20
[   99.164000] ehci_hcd 0000:00:13.5: EHCI Host Controller
[   99.164000] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 6
[   99.164000] ehci_hcd 0000:00:13.5: debug port 1
[   99.164000] ehci_hcd 0000:00:13.5: irq 20, io mem 0xfebff800
[   99.164000] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   99.164000] usb usb6: configuration #1 chosen from 1 choice
[   99.164000] hub 6-0:1.0: USB hub found
[   99.164000] hub 6-0:1.0: 10 ports detected
[   99.340000] Attempting manual resume
[   99.360000] kjournald starting.  Commit interval 5 seconds
[   99.360000] EXT3-fs: mounted filesystem with ordered data mode.
[  107.832000] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[  107.856000] input: PC Speaker as /class/input/input1
[  108.116000] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[  108.128000] Linux agpgart interface v0.102 (c) Dave Jones
[  108.148000] Floppy drive(s): fd0 is 1.44M
[  108.160000] r8169 Gigabit Ethernet driver 2.2LK loaded
[  108.160000] ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 21 (level, low) -> IRQ 21
[  108.160000] eth0: RTL8169sc/8110sc at 0xf888c800, 00:16:17:c3:b8:f9, IRQ 21
[  108.168000] FDC 0 is a post-1991 82077
[  108.176000] parport: PnPBIOS parport detected.
[  108.176000] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[  108.196000] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[  108.312000] r8169: eth0: link down
[  108.408000] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 17
[  108.608000] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[  108.872000] lp0: using parport0 (interrupt-driven).
[  108.980000] input: ImPS/2 Generic Wheel Mouse as /class/input/input2
[  108.996000] w83627ehf: unsupported chip ID: 0xffff
[  109.044000] Adding 1052216k swap on /dev/disk/by-uuid/ba363ce4-0f51-4ff4-abdb-c02e7467cc43.  Priority:-1 extents:1 across:1052216k
[  109.156000] EXT3 FS on hda5, internal journal
[  109.404000] NET: Registered protocol family 17
[  109.468000] NTFS driver 2.1.28 [Flags: R/O MODULE].
[  109.540000] NTFS volume version 3.1.
[  109.780000] r8169: eth0: link up
[  111.800000] input: Power Button (FF) as /class/input/input3
[  111.804000] ACPI: Power Button (FF) [PWRF]
[  111.804000] input: Power Button (CM) as /class/input/input4
[  111.804000] ACPI: Power Button (CM) [PWRB]
[  111.868000] No dock devices found.
[  111.888000] ibm_acpi: ec object not found
[  111.944000] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[  112.200000] powernow-k8: Found 2 AMD Athlon(tm) 64 X2 Dual Core Processor 3600+ processors (version 2.00.00)
[  112.200000] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0xe
[  112.200000] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x10
[  112.200000] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[  114.652000] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[  114.652000] apm: disabled - APM is not SMP safe.
[  116.640000] tsdev (compaq touchscreen emulation) is scheduled for removal.
[  116.640000] See Documentation/feature-removal-schedule.txt for details.
[  117.588000] NET: Registered protocol family 10
[  117.588000] lo: Disabled Privacy Extensions
[  119.524000] hda-intel: Invalid position buffer, using LPIB read method instead.
[  120.100000] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[  120.216000] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  120.216000] NFSD: starting 90-second grace period
[  123.500000] Clocksource tsc unstable (delta = -103221121 ns)
[  128.344000] eth0: no IPv6 routers present
[  136.772000] ISO 9660 Extensions: RRIP_1991A

--------------060400070902090004010801
Content-Type: text/plain;
 name="lshw"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lshw"

matias
    description: Desktop Computer
    product: MS-7242
    vendor: MSI
    version: 0A
    serial: To Be Filled By O.E.M.
    width: 32 bits
    capabilities: smbios-2.4 dmi-2.4
    configuration: chassis=desktop uuid=00020003-0004-0005-0006-000700080009
  *-core
       description: Motherboard
       product: MS-7242
       vendor: MSI
       physical id: 0
       version: 0A
       serial: To be filled by O.E.M.
       slot: To Be Filled By O.E.M.
     *-firmware
          description: BIOS
          vendor: American Megatrends Inc.
          physical id: 0
          version: 080013 (07/04/2006)
          size: 64KB
          capacity: 448KB
          capabilities: isa pci pnp apm upgrade shadowing escd cdboot bootselect socketedrom edd int13floppy1200 int13floppy720 int13floppy2880 int5printscreen int9keyboard int14serial int17printer int10video acpi usb ls120boot zipboot biosbootspecification
     *-cpu
          description: CPU
          product: AMD Athlon(tm) 64 X2 Dual Core Processor 3600+
          vendor: Advanced Micro Devices [AMD]
          physical id: 4
          bus info: cpu@0
          version: 15.11.2
          serial: To Be Filled By O.E.M.
          slot: CPU 1
          size: 1GHz
          capacity: 2GHz
          width: 64 bits
          clock: 200MHz
          capabilities: fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp x86-64 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8legacy ts fid vid ttp tm stc cpufreq
        *-cache:0
             description: L1 cache
             physical id: 5
             slot: L1-Cache
             size: 128KB
             capacity: 128KB
             capabilities: pipeline-burst internal varies data
        *-cache:1
             description: L2 cache
             physical id: 6
             slot: L2-Cache
             size: 256KB
             capacity: 512KB
             capabilities: pipeline-burst internal varies unified
        *-cache:2 DISABLED
             description: L3 cache
             physical id: 7
             slot: L3-Cache
             capabilities: internal
     *-memory
          description: System Memory
          physical id: 28
          slot: System board or motherboard
          size: 1GB
        *-bank:0
             description: DIMM Synchronous 266 MHz (3.8 ns)
             product: PartNum0
             vendor: Manufacturer0
             physical id: 0
             serial: SerNum0
             slot: DIMM0
             size: 512MB
             width: 64 bits
             clock: 266MHz (3.7594ns)
        *-bank:1
             description: DIMM SDRAM [empty]
             product: PartNum1
             vendor: Manufacturer1
             physical id: 1
             serial: SerNum1
             slot: DIMM1
        *-bank:2
             description: DIMM Synchronous 266 MHz (3.8 ns)
             product: PartNum2
             vendor: Manufacturer2
             physical id: 2
             serial: SerNum2
             slot: DIMM2
             size: 512MB
             width: 64 bits
             clock: 266MHz (3.7594ns)
        *-bank:3
             description: DIMM SDRAM [empty]
             product: PartNum3
             vendor: Manufacturer3
             physical id: 3
             serial: SerNum3
             slot: DIMM3
     *-pci:0
          description: Host bridge
          product: RS480 Host Bridge
          vendor: ATI Technologies Inc
          physical id: 100
          bus info: pci@00:00.0
          version: 10
          width: 32 bits
          clock: 66MHz
        *-pci:0
             description: PCI bridge
             product: RS480 PCI-X Root Port
             vendor: ATI Technologies Inc
             physical id: 2
             bus info: pci@00:02.0
             version: 00
             width: 32 bits
             clock: 33MHz
             capabilities: pci normal_decode bus_master cap_list
             configuration: driver=pcieport-driver
           *-display
                description: VGA compatible controller
                product: G71 [GeForce 7300 GS]
                vendor: nVidia Corporation
                physical id: 0
                bus info: pci@01:00.0
                version: a1
                size: 256MB
                width: 64 bits
                clock: 33MHz
                capabilities: vga bus_master cap_list
                resources: iomemory:fd000000-fdffffff iomemory:c0000000-cfffffff iomemory:fc000000-fcffffff irq:10
        *-storage
             description: SATA controller
             product: SB600 Non-Raid-5 SATA
             vendor: ATI Technologies Inc
             physical id: 12
             bus info: pci@00:12.0
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: storage ahci_1.0 bus_master cap_list
             configuration: driver=ahci
             resources: ioport:e800-e807 ioport:e400-e403 ioport:e000-e007 ioport:dc00-dc03 ioport:d800-d80f iomemory:febffc00-febfffff irq:222
        *-usb:0
             description: USB Controller
             product: SB600 USB (OHCI0)
             vendor: ATI Technologies Inc
             physical id: 13
             bus info: pci@00:13.0
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ohci bus_master cap_list
             configuration: driver=ohci_hcd
             resources: iomemory:febfe000-febfefff irq:17
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.21-rc5 ohci_hcd
                physical id: 1
                bus info: usb@1
                logical name: usb1
                version: 2.06
                capabilities: usb-1.10
                configuration: maxpower=0mA slots=2 speed=12.0MB/s
        *-usb:1
             description: USB Controller
             product: SB600 USB (OHCI1)
             vendor: ATI Technologies Inc
             physical id: 13.1
             bus info: pci@00:13.1
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ohci bus_master cap_list
             configuration: driver=ohci_hcd
             resources: iomemory:febfd000-febfdfff irq:18
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.21-rc5 ohci_hcd
                physical id: 1
                bus info: usb@2
                logical name: usb2
                version: 2.06
                capabilities: usb-1.10
                configuration: maxpower=0mA slots=2 speed=12.0MB/s
        *-usb:2
             description: USB Controller
             product: SB600 USB (OHCI2)
             vendor: ATI Technologies Inc
             physical id: 13.2
             bus info: pci@00:13.2
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ohci bus_master cap_list
             configuration: driver=ohci_hcd
             resources: iomemory:febfc000-febfcfff irq:19
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.21-rc5 ohci_hcd
                physical id: 1
                bus info: usb@3
                logical name: usb3
                version: 2.06
                capabilities: usb-1.10
                configuration: maxpower=0mA slots=2 speed=12.0MB/s
        *-usb:3
             description: USB Controller
             product: SB600 USB (OHCI3)
             vendor: ATI Technologies Inc
             physical id: 13.3
             bus info: pci@00:13.3
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ohci bus_master cap_list
             configuration: driver=ohci_hcd
             resources: iomemory:febfb000-febfbfff irq:18
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.21-rc5 ohci_hcd
                physical id: 1
                bus info: usb@4
                logical name: usb4
                version: 2.06
                capabilities: usb-1.10
                configuration: maxpower=0mA slots=2 speed=12.0MB/s
        *-usb:4
             description: USB Controller
             product: SB600 USB (OHCI4)
             vendor: ATI Technologies Inc
             physical id: 13.4
             bus info: pci@00:13.4
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ohci bus_master cap_list
             configuration: driver=ohci_hcd
             resources: iomemory:febfa000-febfafff irq:19
           *-usbhost
                product: OHCI Host Controller
                vendor: Linux 2.6.21-rc5 ohci_hcd
                physical id: 1
                bus info: usb@5
                logical name: usb5
                version: 2.06
                capabilities: usb-1.10
                configuration: maxpower=0mA slots=2 speed=12.0MB/s
        *-usb:5
             description: USB Controller
             product: SB600 USB Controller (EHCI)
             vendor: ATI Technologies Inc
             physical id: 13.5
             bus info: pci@00:13.5
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ehci bus_master cap_list
             configuration: driver=ehci_hcd
             resources: iomemory:febff800-febff8ff irq:20
           *-usbhost
                product: EHCI Host Controller
                vendor: Linux 2.6.21-rc5 ehci_hcd
                physical id: 1
                bus info: usb@6
                logical name: usb6
                version: 2.06
                capabilities: usb-2.00
                configuration: maxpower=0mA slots=10 speed=480.0MB/s
        *-serial
             description: SMBus
             product: SB600 SMBus
             vendor: ATI Technologies Inc
             physical id: 14
             bus info: pci@00:14.0
             version: 13
             width: 32 bits
             clock: 66MHz
             capabilities: cap_list
             configuration: driver=piix4_smbus
             resources: ioport:b00-b0f
        *-ide
             description: IDE interface
             product: SB600 IDE
             vendor: ATI Technologies Inc
             physical id: 14.1
             bus info: pci@00:14.1
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: ide bus_master cap_list
             configuration: driver=ATIIXP_IDE
             resources: ioport:1f0-1f7 ioport:3f4-3f3 ioport:170-177 ioport:374-373 ioport:ff00-ff0f irq:17
           *-ide
                description: IDE Channel 0
                physical id: 0
                bus info: ide@0
                logical name: ide0
                clock: 66MHz
              *-disk
                   description: ATA Disk
                   product: HDS728080PLAT20
                   physical id: 0
                   bus info: ide@0.0
                   logical name: /dev/hda
                   version: PF2OA21B
                   serial: PFD200E1DN2E7B
                   size: 76GB
                   capacity: 76GB
                   capabilities: ata dma lba iordy smart security pm apm partitioned partitioned:dos
                   configuration: apm=off mode=udma5 smart=on
                 *-volume:0
                      description: HPFS/NTFS partition
                      physical id: 1
                      bus info: ide@0.0,1
                      logical name: /dev/hda1
                      capacity: 18GB
                      capabilities: primary bootable
                 *-volume:1
                      description: W95 Ext'd (LBA) partition
                      physical id: 2
                      bus info: ide@0.0,2
                      logical name: /dev/hda2
                      capacity: 58GB
                      capabilities: primary
              *-cdrom
                   description: DVD-RAM writer
                   product: ASUS DRW-1608P3S
                   physical id: 1
                   bus info: ide@0.1
                   logical name: /dev/hdb
                   version: 1.24
                   capabilities: packet atapi cdrom removable nonmagnetic dma lba iordy pm audio cd-r cd-rw dvd dvd-r dvd-ram
                   configuration: mode=udma4
                 *-disc
                      physical id: 0
                      logical name: /dev/hdb
        *-multimedia
             description: Audio device
             product: SB600 Azalia
             vendor: ATI Technologies Inc
             physical id: 14.2
             bus info: pci@00:14.2
             version: 00
             width: 64 bits
             clock: 33MHz
             capabilities: bus_master cap_list
             configuration: driver=HDA Intel
             resources: iomemory:febf4000-febf7fff irq:17
        *-isa UNCLAIMED
             description: ISA bridge
             product: SB600 PCI to LPC Bridge
             vendor: ATI Technologies Inc
             physical id: 14.3
             bus info: pci@00:14.3
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: isa bus_master
        *-pci:1
             description: PCI bridge
             product: SB600 PCI to PCI Bridge
             vendor: ATI Technologies Inc
             physical id: 14.4
             bus info: pci@00:14.4
             version: 00
             width: 32 bits
             clock: 66MHz
             capabilities: pci subtractive_decode bus_master
           *-network
                description: Ethernet interface
                product: RTL-8110SC/8169SC Gigabit Ethernet
                vendor: Realtek Semiconductor Co., Ltd.
                physical id: 6
                bus info: pci@02:06.0
                logical name: eth0
                version: 10
                serial: 00:16:17:c3:b8:f9
                size: 100MB/s
                capacity: 1GB/s
                width: 32 bits
                clock: 66MHz
                capabilities: bus_master cap_list ethernet physical tp 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegociation
                configuration: autonegociation=on broadcast=yes driver=r8169 driverversion=2.2LK duplex=full ip=192.168.0.2 link=yes multicast=yes port=twisted pair speed=100MB/s
                resources: ioport:b800-b8ff iomemory:feaff800-feaff8ff irq:21
     *-pci:1
          description: Host bridge
          product: K8 [Athlon64/Opteron] HyperTransport Technology Configuration
          vendor: Advanced Micro Devices [AMD]
          physical id: 101
          bus info: pci@00:18.0
          version: 00
          width: 32 bits
          clock: 33MHz
     *-pci:2
          description: Host bridge
          product: K8 [Athlon64/Opteron] Address Map
          vendor: Advanced Micro Devices [AMD]
          physical id: 102
          bus info: pci@00:18.1
          version: 00
          width: 32 bits
          clock: 33MHz
     *-pci:3
          description: Host bridge
          product: K8 [Athlon64/Opteron] DRAM Controller
          vendor: Advanced Micro Devices [AMD]
          physical id: 103
          bus info: pci@00:18.2
          version: 00
          width: 32 bits
          clock: 33MHz
     *-pci:4
          description: Host bridge
          product: K8 [Athlon64/Opteron] Miscellaneous Control
          vendor: Advanced Micro Devices [AMD]
          physical id: 104
          bus info: pci@00:18.3
          version: 00
          width: 32 bits
          clock: 33MHz

--------------060400070902090004010801
Content-Type: text/plain;
 name="lspci"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci"

00:00.0 Host bridge: ATI Technologies Inc RS480 Host Bridge (rev 10)
	Subsystem: ATI Technologies Inc RS480 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0

00:02.0 PCI bridge: ATI Technologies Inc RS480 PCI-X Root Port (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fa900000-fe9fffff
	Prefetchable memory behind bridge: 00000000bff00000-00000000dfe00000
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express Root Port (Slot-) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <64ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 41a9
	Capabilities: [b0] #0d [0000]
	Capabilities: [b8] HyperTransport: MSI Mapping

00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA (prog-if 01 [AHCI 1.0])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 222
	Region 0: I/O ports at e800 [size=8]
	Region 1: I/O ports at e400 [size=4]
	Region 2: I/O ports at e000 [size=8]
	Region 3: I/O ports at dc00 [size=4]
	Region 4: I/O ports at d800 [size=16]
	Region 5: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: 64bit+ Queue=0/2 Enable+
		Address: 00000000fee0300c  Data: 41b9
	Capabilities: [70] #12 [0010]

00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at febfe000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000

00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 18
	Region 0: Memory at febfd000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000

00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 19
	Region 0: Memory at febfc000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000

00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 18
	Region 0: Memory at febfb000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000

00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4) (prog-if 10 [OHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 19
	Region 0: Memory at febfa000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000

00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI) (prog-if 20 [EHCI])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin D routed to IRQ 20
	Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [d0] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [e4] Debug port

00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: I/O ports at 0b00 [size=16]
	Capabilities: [b0] HyperTransport: MSI Mapping

00:14.1 IDE interface: ATI Technologies Inc SB600 IDE (prog-if 8a [Master SecP PriP])
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ff00 [size=16]
	Capabilities: [70] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000

00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin ? routed to IRQ 17
	Region 0: Memory at febf4000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000

00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
	Subsystem: Micro-Star International Co., Ltd. Unknown device 7242
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fea00000-feafffff
	Prefetchable memory behind bridge: 50000000-500fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]

01:00.0 VGA compatible controller: nVidia Corporation G71 [GeForce 7300 GS] (rev a1) (prog-if 00 [VGA])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at fc000000 (64-bit, non-prefetchable) [size=16M]
	Expansion ROM at fe9e0000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <256ns, L1 <4us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16

02:06.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)
	Subsystem: Micro-Star International Co., Ltd. Unknown device 242c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at b800 [size=256]
	Region 1: Memory at feaff800 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at 50000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-


--------------060400070902090004010801--
