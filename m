Return-Path: <linux-kernel-owner+w=401wt.eu-S1764233AbYBVS7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764233AbYBVS7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763727AbYBVS7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:59:33 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52123 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763608AbYBVS7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:59:23 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Jeff Garzik <jeff@garzik.org>
cc: Anders Eriksson <aeriksson@fastmail.fm>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.25-rc2 + smartd = hang 
In-reply-to: <47BF0DCD.4060400@garzik.org> 
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <47BF0DCD.4060400@garzik.org>
Comments: In-reply-to Jeff Garzik <jeff@garzik.org>
   message dated "Fri, 22 Feb 2008 13:00:45 -0500."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 22 Feb 2008 19:56:45 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080222185645.9DD9C93C12F@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-ACL-Warn: Too high rate of unknown addresses received from you
X-Scan-Result: No virus found in message 1JSd6k-0007tw-67.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JSd6k-0007tw-67 980780ad987fc1cf63f733de04abd172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



jeff@garzik.org said:
> The sysrq-e output is probably just standard ext3 journalling unrelated  to
> the problem...  what does dmesg say?  lspci?  What's your hardware setup? 


dmesg ; smartd ; dmesg yields no new entries in dmesg. It seems on disk 
accesses are dead. it still routes packets fine.

This is an old PII-300 with 2 IDS disks and a DVD R/W. 

tippex ~ # lspci -vv
00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 02)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 64
        Region 0: Memory at e8000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 1.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
        Kernel driver in use: agpgart-intel
        Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge (rev 02) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: eda00000-efafffff
        Prefetchable memory behind bridge: e1800000-e58fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B+
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at ffa0 [size=16]
        Kernel driver in use: PIIX_IDE

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at 6000 [size=32]
        Kernel driver in use: uhci_hcd
        Kernel modules: uhci-hcd

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin ? routed to IRQ 9
        Kernel driver in use: piix4_smbus
        Kernel modules: i2c-piix4

00:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
        Subsystem: RaLink Unknown device 2560
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at efffe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt2500pci
        Kernel modules: rt2500pci

00:0b.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 05)
        Subsystem: Intel Corporation 82558B PRO/100+ PCI (TP)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at ec9ff000 (32-bit, prefetchable) [size=4K]
        Region 1: I/O ports at de00 [size=32]
        Region 2: Memory at efe00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at efd00000 [disabled] [size=1M]
        Capabilities: [dc] Power Management version 1
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: e100

01:00.0 VGA compatible controller: nVidia Corporation NV5 [RIVA TNT2/TNT2 Pro] (rev 15) (prog-if 00 [VGA controller])
        Subsystem: nVidia Corporation Compaq NVIDIA TNT2 Pro
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (1250ns min, 250ns max)
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at ee000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at e2000000 (32-bit, prefetchable) [size=32M]
        Expansion ROM at efaf0000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 1
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>



2.6.24.2 dmesg:
Feb 22 00:09:18 tippex Linux version 2.6.24.2 (anders@tippex) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #9 PREEMPT Thu Feb 21 16:08:47 CET 2008
Feb 22 00:09:18 tippex BIOS-provided physical RAM map:
Feb 22 00:09:18 tippex BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Feb 22 00:09:18 tippex BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Feb 22 00:09:18 tippex BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb 22 00:09:18 tippex BIOS-e820: 0000000000100000 - 0000000014000000 (usable)
Feb 22 00:09:18 tippex BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb 22 00:09:18 tippex 320MB LOWMEM available.
Feb 22 00:09:18 tippex Entering add_active_range(0, 0, 81920) 0 entries of 256 used
Feb 22 00:09:18 tippex Zone PFN ranges:
Feb 22 00:09:18 tippex DMA             0 ->     4096
Feb 22 00:09:18 tippex Normal       4096 ->    81920
Feb 22 00:09:18 tippex Movable zone start PFN for each node
Feb 22 00:09:18 tippex early_node_map[1] active PFN ranges
Feb 22 00:09:18 tippex 0:        0 ->    81920
Feb 22 00:09:18 tippex On node 0 totalpages: 81920
Feb 22 00:09:18 tippex DMA zone: 32 pages used for memmap
Feb 22 00:09:18 tippex DMA zone: 0 pages reserved
Feb 22 00:09:18 tippex DMA zone: 4064 pages, LIFO batch:0
Feb 22 00:09:18 tippex Normal zone: 608 pages used for memmap
Feb 22 00:09:18 tippex Normal zone: 77216 pages, LIFO batch:15
Feb 22 00:09:18 tippex Movable zone: 0 pages used for memmap
Feb 22 00:09:18 tippex DMI 2.1 present.
Feb 22 00:09:18 tippex Allocating PCI resources starting at 20000000 (gap: 14000000:ebff0000)
Feb 22 00:09:18 tippex Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81280
Feb 22 00:09:18 tippex Kernel command line: ro  pci=usepirqmask root=/dev/hdb1
Feb 22 00:09:18 tippex Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb 22 00:09:18 tippex mapped APIC to ffffb000 (01286000)
Feb 22 00:09:18 tippex Initializing CPU#0
Feb 22 00:09:18 tippex PID hash table entries: 2048 (order: 11, 8192 bytes)
Feb 22 00:09:18 tippex Detected 300.694 MHz processor.
Feb 22 00:09:18 tippex Console: colour VGA+ 80x25
Feb 22 00:09:18 tippex console [tty0] enabled
Feb 22 00:09:18 tippex Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Feb 22 00:09:18 tippex ... MAX_LOCKDEP_SUBCLASSES:    8
Feb 22 00:09:18 tippex ... MAX_LOCK_DEPTH:          30
Feb 22 00:09:18 tippex ... MAX_LOCKDEP_KEYS:        2048
Feb 22 00:09:18 tippex ... CLASSHASH_SIZE:           1024
Feb 22 00:09:18 tippex ... MAX_LOCKDEP_ENTRIES:     8192
Feb 22 00:09:18 tippex ... MAX_LOCKDEP_CHAINS:      16384
Feb 22 00:09:18 tippex ... CHAINHASH_SIZE:          8192
Feb 22 00:09:18 tippex memory used by lock dependency info: 1024 kB
Feb 22 00:09:18 tippex per task-struct memory footprint: 1680 bytes
Feb 22 00:09:18 tippex Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb 22 00:09:18 tippex Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb 22 00:09:18 tippex Memory: 317364k/327680k available (3055k kernel code, 9844k reserved, 1265k data, 188k init, 0k highmem)
Feb 22 00:09:18 tippex virtual kernel memory layout:
Feb 22 00:09:18 tippex fixmap  : 0xfffba000 - 0xfffff000   ( 276 kB)
Feb 22 00:09:18 tippex vmalloc : 0xd4800000 - 0xfffb8000   ( 695 MB)
Feb 22 00:09:18 tippex lowmem  : 0xc0000000 - 0xd4000000   ( 320 MB)
Feb 22 00:09:18 tippex .init : 0xc053c000 - 0xc056b000   ( 188 kB)
Feb 22 00:09:18 tippex .data : 0xc03fbccc - 0xc053832c   (1265 kB)
Feb 22 00:09:18 tippex .text : 0xc0100000 - 0xc03fbccc   (3055 kB)
Feb 22 00:09:18 tippex Checking if this processor honours the WP bit even in supervisor mode... Ok.
Feb 22 00:09:18 tippex Calibrating delay using timer specific routine.. 603.58 BogoMIPS (lpj=1207166)
Feb 22 00:09:18 tippex Mount-cache hash table entries: 512
Feb 22 00:09:18 tippex CPU: After generic identify, caps: 0080f9ff 00000000 00000000 00000000 00000000 00000000 00000000 00000000
Feb 22 00:09:18 tippex CPU: L1 I cache: 16K, L1 D cache: 16K
Feb 22 00:09:18 tippex CPU: L2 cache: 512K
Feb 22 00:09:18 tippex CPU: After all inits, caps: 0080f9ff 00000000 00000000 00000040 00000000 00000000 00000000 00000000
Feb 22 00:09:18 tippex Compat vDSO mapped to ffffe000.
Feb 22 00:09:18 tippex CPU: Intel Pentium II (Klamath) stepping 04
Feb 22 00:09:18 tippex Checking 'hlt' instruction... OK.
Feb 22 00:09:18 tippex Freeing SMP alternatives: 0k freed
Feb 22 00:09:18 tippex net_namespace: 80 bytes
Feb 22 00:09:18 tippex NET: Registered protocol family 16
Feb 22 00:09:18 tippex PCI: PCI BIOS revision 2.10 entry at 0xfda18, last bus=1
Feb 22 00:09:18 tippex PCI: Using configuration type 1
Feb 22 00:09:18 tippex Setting up standard PCI resources
Feb 22 00:09:18 tippex Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 22 00:09:18 tippex SCSI subsystem initialized
Feb 22 00:09:18 tippex usbcore: registered new interface driver usbfs
Feb 22 00:09:18 tippex usbcore: registered new interface driver hub
Feb 22 00:09:18 tippex usbcore: registered new device driver usb
Feb 22 00:09:18 tippex PCI: Probing PCI hardware
Feb 22 00:09:18 tippex PCI: Probing PCI hardware (bus 00)
Feb 22 00:09:18 tippex PCI quirk: region 0400-043f claimed by PIIX4 ACPI
Feb 22 00:09:18 tippex PCI quirk: region 0440-044f claimed by PIIX4 SMB
Feb 22 00:09:18 tippex PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
Feb 22 00:09:18 tippex PCI: setting IRQ 11 as level-triggered
Feb 22 00:09:18 tippex PCI: Found IRQ 11 for device 0000:00:07.2
Feb 22 00:09:18 tippex PCI: Sharing IRQ 11 with 0000:00:0b.0
Feb 22 00:09:18 tippex Bluetooth: Core ver 2.11
Feb 22 00:09:18 tippex NET: Registered protocol family 31
Feb 22 00:09:18 tippex Bluetooth: HCI device and connection manager initialized
Feb 22 00:09:18 tippex Bluetooth: HCI socket layer initialized
Feb 22 00:09:18 tippex Time: tsc clocksource has been installed.
Feb 22 00:09:18 tippex PCI: Bridge: 0000:00:01.0
Feb 22 00:09:18 tippex IO window: c000-cfff
Feb 22 00:09:18 tippex PREFETCH window: e1800000-e58fffff
Feb 22 00:09:18 tippex NET: Registered protocol family 2
Feb 22 00:09:18 tippex IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Feb 22 00:09:18 tippex TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Feb 22 00:09:18 tippex TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
Feb 22 00:09:18 tippex TCP: Hash tables configured (established 16384 bind 16384)
Feb 22 00:09:18 tippex TCP reno registered
Feb 22 00:09:18 tippex apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
Feb 22 00:09:18 tippex Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Feb 22 00:09:18 tippex io scheduler noop registered
Feb 22 00:09:18 tippex io scheduler anticipatory registered
Feb 22 00:09:18 tippex io scheduler deadline registered
Feb 22 00:09:18 tippex io scheduler cfq registered (default)
Feb 22 00:09:18 tippex Limiting direct PCI/PCI transfers.
Feb 22 00:09:18 tippex PCI: Firmware left 0000:00:0b.0 e100 interrupts enabled, disabling
Feb 22 00:09:18 tippex Boot video device is 0000:01:00.0
Feb 22 00:09:18 tippex pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb 22 00:09:18 tippex isapnp: Scanning for PnP cards...
Feb 22 00:09:18 tippex isapnp: Card 'AZT1008 PnP SOUND DEVICE'
Feb 22 00:09:18 tippex isapnp: 1 Plug & Play card detected total
Feb 22 00:09:18 tippex Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
Feb 22 00:09:18 tippex serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 22 00:09:18 tippex serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 22 00:09:18 tippex loop: module loaded
Feb 22 00:09:18 tippex e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
Feb 22 00:09:18 tippex e100: Copyright(c) 1999-2006 Intel Corporation
Feb 22 00:09:18 tippex PCI: Found IRQ 11 for device 0000:00:0b.0
Feb 22 00:09:18 tippex PCI: Sharing IRQ 11 with 0000:00:07.2
Feb 22 00:09:18 tippex e100: eth0: e100_probe: addr 0xec9ff000, irq 11, MAC addr 00:90:27:12:10:91
Feb 22 00:09:18 tippex Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
Feb 22 00:09:18 tippex ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 22 00:09:18 tippex PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
Feb 22 00:09:18 tippex PIIX4: not 100% native mode: will probe irqs later
Feb 22 00:09:18 tippex ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
Feb 22 00:09:18 tippex ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:pio
Feb 22 00:09:18 tippex Probing IDE interface ide0...
Feb 22 00:09:18 tippex hdb: IC35L120AVV207-0, ATA DISK drive
Feb 22 00:09:18 tippex hda: IBM-DTTA-371010, ATA DISK drive
Feb 22 00:09:18 tippex hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 00:09:18 tippex hda: UDMA/33 mode selected
Feb 22 00:09:18 tippex hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 00:09:18 tippex hdb: UDMA/33 mode selected
Feb 22 00:09:18 tippex ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 22 00:09:18 tippex Probing IDE interface ide1...
Feb 22 00:09:18 tippex hdd: Maxtor 6L250R0, ATA DISK drive
Feb 22 00:09:18 tippex hdc: AOPEN DUW1608/ARR, ATAPI CD/DVD-ROM drive
Feb 22 00:09:18 tippex hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 00:09:18 tippex hdc: UDMA/33 mode selected
Feb 22 00:09:18 tippex hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 00:09:18 tippex hdd: UDMA/33 mode selected
Feb 22 00:09:18 tippex ide1 at 0x170-0x177,0x376 on irq 15
Feb 22 00:09:18 tippex hda: max request size: 128KiB
Feb 22 00:09:18 tippex hda: Host Protected Area detected.
Feb 22 00:09:18 tippex  current capacity is 17850000 sectors (9139 MB)
Feb 22 00:09:18 tippex  native  capacity is 19746720 sectors (10110 MB)
Feb 22 00:09:18 tippex hda: Host Protected Area disabled.
Feb 22 00:09:18 tippex hda: 19746720 sectors (10110 MB) w/465KiB Cache, CHS=20896/15/63
Feb 22 00:09:18 tippex hda: cache flushes not supported
Feb 22 00:09:18 tippex hda: hda1 hda2
Feb 22 00:09:18 tippex hdb: max request size: 512KiB
Feb 22 00:09:18 tippex hdb: 241254720 sectors (123522 MB) w/1821KiB Cache, CHS=16383/255/63
Feb 22 00:09:18 tippex hdb: cache flushes supported
Feb 22 00:09:18 tippex hdb: hdb1
Feb 22 00:09:18 tippex hdd: max request size: 512KiB
Feb 22 00:09:18 tippex hdd: 490234752 sectors (251000 MB) w/16384KiB Cache, CHS=30515/255/63
Feb 22 00:09:18 tippex hdd: cache flushes supported
Feb 22 00:09:18 tippex hdd: hdd1
Feb 22 00:09:18 tippex hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Feb 22 00:09:18 tippex Uniform CD-ROM driver Revision: 3.20
Feb 22 00:09:18 tippex ide-floppy driver 0.99.newide
Feb 22 00:09:18 tippex usbcore: registered new interface driver cdc_acm
Feb 22 00:09:18 tippex /net/tippex.local/usr/src/linux-2.6.24/drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
Feb 22 00:09:18 tippex usbcore: registered new interface driver usblp
Feb 22 00:09:18 tippex Initializing USB Mass Storage driver...
Feb 22 00:09:18 tippex usbcore: registered new interface driver usb-storage
Feb 22 00:09:18 tippex USB Mass Storage support registered.
Feb 22 00:09:18 tippex usbcore: registered new interface driver libusual
Feb 22 00:09:18 tippex PNP: No PS/2 controller found. Probing ports directly.
Feb 22 00:09:18 tippex serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 22 00:09:18 tippex serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 22 00:09:18 tippex mice: PS/2 mouse device common for all mice
Feb 22 00:09:18 tippex Bluetooth: HCI USB driver ver 2.9
Feb 22 00:09:18 tippex usbcore: registered new interface driver hci_usb
Feb 22 00:09:18 tippex Bluetooth: Virtual HCI driver ver 1.2
Feb 22 00:09:18 tippex Bluetooth: HCI UART driver ver 2.2
Feb 22 00:09:18 tippex Bluetooth: HCI H4 protocol initialized
Feb 22 00:09:18 tippex Bluetooth: HCI BCSP protocol initialized
Feb 22 00:09:18 tippex Bluetooth: Broadcom Blutonium firmware driver ver 1.1
Feb 22 00:09:18 tippex usbcore: registered new interface driver bcm203x
Feb 22 00:09:18 tippex Bluetooth: Digianswer Bluetooth USB driver ver 0.9
Feb 22 00:09:18 tippex usbcore: registered new interface driver bpa10x
Feb 22 00:09:18 tippex Bluetooth: BlueFRITZ! USB driver ver 1.1
Feb 22 00:09:18 tippex usbcore: registered new interface driver bfusb
Feb 22 00:09:18 tippex EDAC MC: Ver: 2.1.0 Feb 21 2008
Feb 22 00:09:18 tippex Advanced Linux Sound Architecture Driver Version 1.0.15 (Tue Nov 20 19:16:42 2007 UTC).
Feb 22 00:09:18 tippex azt2320 00:01.01: activated
Feb 22 00:09:18 tippex azt2320 00:01.02: activated
Feb 22 00:09:18 tippex ALSA device list:
Feb 22 00:09:18 tippex #0: Aztech AZT2320, WSS at 0x534, irq 5, dma 1&3
Feb 22 00:09:18 tippex Netfilter messages via NETLINK v0.30.
Feb 22 00:09:18 tippex ip_tables: (C) 2000-2006 Netfilter Core Team
Feb 22 00:09:18 tippex TCP cubic registered
Feb 22 00:09:18 tippex NET: Registered protocol family 1
Feb 22 00:09:18 tippex NET: Registered protocol family 10
Feb 22 00:09:18 tippex IPv6 over IPv4 tunneling driver
Feb 22 00:09:18 tippex NET: Registered protocol family 17
Feb 22 00:09:18 tippex NET: Registered protocol family 15
Feb 22 00:09:18 tippex Bluetooth: L2CAP ver 2.9
Feb 22 00:09:18 tippex Bluetooth: L2CAP socket layer initialized
Feb 22 00:09:18 tippex Bluetooth: SCO (Voice Link) ver 0.5
Feb 22 00:09:18 tippex Bluetooth: SCO socket layer initialized
Feb 22 00:09:18 tippex Bluetooth: RFCOMM socket layer initialized
Feb 22 00:09:18 tippex Bluetooth: RFCOMM TTY layer initialized
Feb 22 00:09:18 tippex Bluetooth: RFCOMM ver 1.8
Feb 22 00:09:18 tippex Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Feb 22 00:09:18 tippex Bluetooth: BNEP filters: protocol multicast
Feb 22 00:09:18 tippex Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Feb 22 00:09:18 tippex RPC: Registered udp transport module.
Feb 22 00:09:18 tippex RPC: Registered tcp transport module.
Feb 22 00:09:18 tippex Using IPI Shortcut mode
Feb 22 00:09:18 tippex input: ImPS/2 Generic Wheel Mouse as /class/input/input0
Feb 22 00:09:18 tippex input: AT Translated Set 2 keyboard as /class/input/input1
Feb 22 00:09:18 tippex EXT3-fs: INFO: recovery required on readonly filesystem.
Feb 22 00:09:18 tippex EXT3-fs: write access will be enabled during recovery.
Feb 22 00:09:18 tippex kjournald starting.  Commit interval 5 seconds
Feb 22 00:09:18 tippex EXT3-fs: recovery complete.
Feb 22 00:09:18 tippex EXT3-fs: mounted filesystem with ordered data mode.
Feb 22 00:09:18 tippex VFS: Mounted root (ext3 filesystem) readonly.
Feb 22 00:09:18 tippex Freeing unused kernel memory: 188k freed
Feb 22 00:09:18 tippex Linux agpgart interface v0.102
Feb 22 00:09:18 tippex agpgart: Detected an Intel 440BX Chipset.
Feb 22 00:09:18 tippex USB Universal Host Controller Interface driver v3.0
Feb 22 00:09:19 tippex agpgart: AGP aperture is 64M @ 0xe8000000
Feb 22 00:09:19 tippex PCI: Enabling device 0000:00:07.2 (0000 -> 0001)
Feb 22 00:09:19 tippex PCI: Found IRQ 11 for device 0000:00:07.2
Feb 22 00:09:19 tippex PCI: Sharing IRQ 11 with 0000:00:0b.0
Feb 22 00:09:19 tippex PCI: Setting latency timer of device 0000:00:07.2 to 64
Feb 22 00:09:19 tippex uhci_hcd 0000:00:07.2: UHCI Host Controller
Feb 22 00:09:19 tippex uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
Feb 22 00:09:19 tippex uhci_hcd 0000:00:07.2: irq 11, io base 0x00006000
Feb 22 00:09:19 tippex usb usb1: configuration #1 chosen from 1 choice
Feb 22 00:09:19 tippex hub 1-0:1.0: USB hub found
Feb 22 00:09:19 tippex hub 1-0:1.0: 2 ports detected
Feb 22 00:09:19 tippex input: PC Speaker as /class/input/input2
Feb 22 00:09:19 tippex piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
Feb 22 00:09:19 tippex PCI: setting IRQ 10 as level-triggered
Feb 22 00:09:19 tippex PCI: Found IRQ 10 for device 0000:00:0a.0
Feb 22 00:09:19 tippex usb 1-2: new full speed USB device using uhci_hcd and address 2
Feb 22 00:09:19 tippex phy0: Selected rate control algorithm 'simple'
Feb 22 00:09:19 tippex usb 1-2: configuration #1 chosen from 1 choice
Feb 22 00:09:19 tippex EXT3 FS on hdb1, internal journal
Feb 22 00:09:19 tippex EXT2-fs warning (device hda1): ext2_fill_super: mounting ext3 filesystem as ext2
Feb 22 00:09:19 tippex kjournald starting.  Commit interval 5 seconds
Feb 22 00:09:19 tippex EXT3 FS on hdd1, internal journal
Feb 22 00:09:19 tippex EXT3-fs: mounted filesystem with ordered data mode.
Feb 22 00:09:19 tippex Adding 195304k swap on /var/cache/swapfile.  Priority:-1 extents:2098 across:40112396k
Feb 22 00:09:19 tippex Adding 102392k swap on /var/cache/swapfile.2.  Priority:-2 extents:663 across:3794356k
Feb 22 00:09:19 tippex Real Time Clock Driver v1.12ac
Feb 22 00:09:19 tippex ADDRCONF(NETDEV_UP): wlan0: link is not ready
Feb 22 00:09:19 tippex wlan0: Initial auth_alg=0
Feb 22 00:09:19 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Feb 22 00:09:19 tippex wlan0: RX authentication from 00:18:39:c0:5f:50 (alg=0 transaction=2 status=0)
Feb 22 00:09:19 tippex wlan0: authenticated
Feb 22 00:09:19 tippex wlan0: associate with AP 00:18:39:c0:5f:50
Feb 22 00:09:19 tippex wlan0: RX AssocResp from 00:18:39:c0:5f:50 (capab=0x431 status=0 aid=1)
Feb 22 00:09:19 tippex wlan0: associated
Feb 22 00:09:19 tippex wlan0: switched to short barker preamble (BSSID=00:18:39:c0:5f:50)
Feb 22 00:09:19 tippex ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Feb 22 00:09:19 tippex hda: UDMA/33 mode selected
Feb 22 00:09:19 tippex hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
Feb 22 00:09:19 tippex hda: drive_cmd: error=0x04 { DriveStatusError }
Feb 22 00:09:19 tippex ide: failed opcode was: 0xef
Feb 22 00:09:19 tippex hdb: UDMA/33 mode selected
Feb 22 00:09:19 tippex hdd: UDMA/33 mode selected
Feb 22 00:11:07 tippex smartd[6349]: smartd version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Feb 22 00:11:07 tippex smartd[6349]: Home page is http://smartmontools.sourceforge.net/
Feb 22 00:11:07 tippex smartd[6349]: Opened configuration file /etc/smartd.conf
Feb 22 00:11:07 tippex smartd[6349]: Configuration file /etc/smartd.conf parsed.
Feb 22 00:11:07 tippex smartd[6349]: Device: /dev/hdb, opened
Feb 22 00:11:07 tippex smartd[6349]: Device: /dev/hdb, found in smartd database.
Feb 22 00:11:07 tippex smartd[6349]: Device: /dev/hdb, enabled SMART Attribute Autosave.
Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdb, enabled SMART Automatic Offline Testing.
Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdb, is SMART capable. Adding to "monitor" list.
Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, opened
Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, found in smartd database.
Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, enabled SMART Attribute Autosave.
Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, enabled SMART Automatic Offline Testing.
Feb 22 00:11:09 tippex smartd[6349]: Device: /dev/hdd, is SMART capable. Adding to "monitor" list.
Feb 22 00:11:09 tippex smartd[6349]: Monitoring 2 ATA and 0 SCSI devices
Feb 22 00:11:09 tippex smartd[6349]: Device: /dev/hdb, initial Temperature is 28 Celsius
Feb 22 00:11:09 tippex smartd[6349]: Device: /dev/hdd, initial Temperature is 43 Celsius
Feb 22 00:11:09 tippex smartd[6351]: smartd has fork()ed into background mode. New PID=6351.
Feb 22 00:11:09 tippex smartd[6351]: file /var/run/smartd.pid written containing PID 6351



2.6.25-rc2
Feb 22 17:38:49 tippex Linux version 2.6.25-rc2 (anders@tippex) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #4 PREEMPT Fri Feb 22 15:38:48 CET 2008
Feb 22 17:38:49 tippex BIOS-provided physical RAM map:
Feb 22 17:38:49 tippex BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
Feb 22 17:38:49 tippex BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
Feb 22 17:38:49 tippex BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
Feb 22 17:38:49 tippex BIOS-e820: 0000000000100000 - 0000000014000000 (usable)
Feb 22 17:38:49 tippex BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
Feb 22 17:38:49 tippex 320MB LOWMEM available.
Feb 22 17:38:49 tippex Scan SMP from c0000000 for 1024 bytes.
Feb 22 17:38:49 tippex Scan SMP from c009fc00 for 1024 bytes.
Feb 22 17:38:49 tippex Scan SMP from c00f0000 for 65536 bytes.
Feb 22 17:38:49 tippex Scan SMP from c009f800 for 1024 bytes.
Feb 22 17:38:49 tippex Entering add_active_range(0, 0, 81920) 0 entries of 256 used
Feb 22 17:38:49 tippex Zone PFN ranges:
Feb 22 17:38:49 tippex DMA             0 ->     4096
Feb 22 17:38:49 tippex Normal       4096 ->    81920
Feb 22 17:38:49 tippex Movable zone start PFN for each node
Feb 22 17:38:49 tippex early_node_map[1] active PFN ranges
Feb 22 17:38:49 tippex 0:        0 ->    81920
Feb 22 17:38:49 tippex On node 0 totalpages: 81920
Feb 22 17:38:49 tippex DMA zone: 32 pages used for memmap
Feb 22 17:38:49 tippex DMA zone: 0 pages reserved
Feb 22 17:38:49 tippex DMA zone: 4064 pages, LIFO batch:0
Feb 22 17:38:49 tippex Normal zone: 608 pages used for memmap
Feb 22 17:38:49 tippex Normal zone: 77216 pages, LIFO batch:15
Feb 22 17:38:49 tippex Movable zone: 0 pages used for memmap
Feb 22 17:38:49 tippex DMI 2.1 present.
Feb 22 17:38:49 tippex Allocating PCI resources starting at 20000000 (gap: 14000000:ebff0000)
Feb 22 17:38:49 tippex Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81280
Feb 22 17:38:49 tippex Kernel command line: ro pci=usepirqmask root=/dev/hdb1
Feb 22 17:38:49 tippex Local APIC disabled by BIOS -- you can enable it with "lapic"
Feb 22 17:38:49 tippex mapped APIC to ffffb000 (01286000)
Feb 22 17:38:49 tippex Initializing CPU#0
Feb 22 17:38:49 tippex PID hash table entries: 2048 (order: 11, 8192 bytes)
Feb 22 17:38:49 tippex Detected 300.700 MHz processor.
Feb 22 17:38:49 tippex Console: colour VGA+ 80x25
Feb 22 17:38:49 tippex console [tty0] enabled
Feb 22 17:38:49 tippex Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
Feb 22 17:38:49 tippex ... MAX_LOCKDEP_SUBCLASSES:    8
Feb 22 17:38:49 tippex ... MAX_LOCK_DEPTH:          30
Feb 22 17:38:49 tippex ... MAX_LOCKDEP_KEYS:        2048
Feb 22 17:38:49 tippex ... CLASSHASH_SIZE:           1024
Feb 22 17:38:49 tippex ... MAX_LOCKDEP_ENTRIES:     8192
Feb 22 17:38:49 tippex ... MAX_LOCKDEP_CHAINS:      16384
Feb 22 17:38:49 tippex ... CHAINHASH_SIZE:          8192
Feb 22 17:38:49 tippex memory used by lock dependency info: 1024 kB
Feb 22 17:38:49 tippex per task-struct memory footprint: 1680 bytes
Feb 22 17:38:49 tippex Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Feb 22 17:38:49 tippex Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Feb 22 17:38:49 tippex Memory: 317272k/327680k available (3089k kernel code, 9936k reserved, 1283k data, 216k init, 0k highmem)
Feb 22 17:38:49 tippex virtual kernel memory layout:
Feb 22 17:38:49 tippex fixmap  : 0xfffba000 - 0xfffff000   ( 276 kB)
Feb 22 17:38:49 tippex vmalloc : 0xd4800000 - 0xfffb8000   ( 695 MB)
Feb 22 17:38:49 tippex lowmem  : 0xc0000000 - 0xd4000000   ( 320 MB)
Feb 22 17:38:49 tippex .init : 0xc0548000 - 0xc057e000   ( 216 kB)
Feb 22 17:38:49 tippex .data : 0xc040478a - 0xc0545538   (1283 kB)
Feb 22 17:38:49 tippex .text : 0xc0100000 - 0xc040478a   (3089 kB)
Feb 22 17:38:49 tippex Checking if this processor honours the WP bit even in supervisor mode...Ok.
Feb 22 17:38:49 tippex CPA: page pool initialized 16 of 16 pages preallocated
Feb 22 17:38:49 tippex Calibrating delay using timer specific routine.. 604.51 BogoMIPS (lpj=1209023)
Feb 22 17:38:49 tippex Mount-cache hash table entries: 512
Feb 22 17:38:49 tippex CPU: L1 I cache: 16K, L1 D cache: 16K
Feb 22 17:38:49 tippex CPU: L2 cache: 512K
Feb 22 17:38:49 tippex Compat vDSO mapped to ffffe000.
Feb 22 17:38:49 tippex CPU: Intel Pentium II (Klamath) stepping 04
Feb 22 17:38:49 tippex Checking 'hlt' instruction... OK.
Feb 22 17:38:49 tippex Freeing SMP alternatives: 0k freed
Feb 22 17:38:49 tippex net_namespace: 616 bytes
Feb 22 17:38:49 tippex NET: Registered protocol family 16
Feb 22 17:38:49 tippex PCI: PCI BIOS revision 2.10 entry at 0xfda18, last bus=1
Feb 22 17:38:49 tippex PCI: Using configuration type 1
Feb 22 17:38:49 tippex Setting up standard PCI resources
Feb 22 17:38:49 tippex Linux Plug and Play Support v0.97 (c) Adam Belay
Feb 22 17:38:49 tippex SCSI subsystem initialized
Feb 22 17:38:49 tippex usbcore: registered new interface driver usbfs
Feb 22 17:38:49 tippex usbcore: registered new interface driver hub
Feb 22 17:38:49 tippex usbcore: registered new device driver usb
Feb 22 17:38:49 tippex PCI: Probing PCI hardware
Feb 22 17:38:49 tippex PCI: Probing PCI hardware (bus 00)
Feb 22 17:38:49 tippex pci 0000:00:07.3: quirk: region 0400-043f claimed by PIIX4 ACPI
Feb 22 17:38:49 tippex pci 0000:00:07.3: quirk: region 0440-044f claimed by PIIX4 SMB
Feb 22 17:38:49 tippex PCI: Using IRQ router PIIX/ICH [8086/7110] at 0000:00:07.0
Feb 22 17:38:49 tippex PCI: setting IRQ 11 as level-triggered
Feb 22 17:38:49 tippex PCI: Found IRQ 11 for device 0000:00:07.2
Feb 22 17:38:49 tippex PCI: Sharing IRQ 11 with 0000:00:0b.0
Feb 22 17:38:49 tippex Bluetooth: Core ver 2.11
Feb 22 17:38:49 tippex NET: Registered protocol family 31

Feb 22 17:38:49 tippex Bluetooth: HCI device and connection manager initialized
Feb 22 17:38:49 tippex Bluetooth: HCI socket layer initialized
Feb 22 17:38:49 tippex Time: tsc clocksource has been installed.
Feb 22 17:38:49 tippex PCI: Bridge: 0000:00:01.0
Feb 22 17:38:49 tippex IO window: c000-cfff
Feb 22 17:38:49 tippex MEM window: 0xeda00000-0xefafffff
Feb 22 17:38:49 tippex PREFETCH window: 0x00000000e1800000-0x00000000e58fffff
Feb 22 17:38:49 tippex NET: Registered protocol family 2
Feb 22 17:38:49 tippex IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Feb 22 17:38:49 tippex TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Feb 22 17:38:49 tippex TCP bind hash table entries: 16384 (order: 7, 589824 bytes)
Feb 22 17:38:49 tippex TCP: Hash tables configured (established 16384 bind 16384)
Feb 22 17:38:49 tippex TCP reno registered
Feb 22 17:38:49 tippex apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
Feb 22 17:38:49 tippex Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Feb 22 17:38:49 tippex io scheduler noop registered
Feb 22 17:38:49 tippex io scheduler anticipatory registered
Feb 22 17:38:49 tippex io scheduler deadline registered
Feb 22 17:38:49 tippex io scheduler cfq registered (default)
Feb 22 17:38:49 tippex pci 0000:00:00.0: Limiting direct PCI/PCI transfers
Feb 22 17:38:49 tippex pci 0000:00:0b.0: Firmware left e100 interrupts enabled; disabling
Feb 22 17:38:49 tippex pci 0000:01:00.0: Boot video device
Feb 22 17:38:49 tippex pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Feb 22 17:38:49 tippex isapnp: Scanning for PnP cards...
Feb 22 17:38:49 tippex isapnp: Card 'AZT1008 PnP SOUND DEVICE'
Feb 22 17:38:49 tippex isapnp: 1 Plug & Play card detected total
Feb 22 17:38:49 tippex Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
Feb 22 17:38:49 tippex serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Feb 22 17:38:49 tippex serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Feb 22 17:38:49 tippex loop: module loaded
Feb 22 17:38:49 tippex e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
Feb 22 17:38:49 tippex e100: Copyright(c) 1999-2006 Intel Corporation
Feb 22 17:38:49 tippex PCI: Found IRQ 11 for device 0000:00:0b.0
Feb 22 17:38:49 tippex PCI: Sharing IRQ 11 with 0000:00:07.2
Feb 22 17:38:49 tippex e100: eth0: e100_probe: addr 0xec9ff000, irq 11, MAC addr 00:90:27:12:10:91
Feb 22 17:38:49 tippex Uniform Multi-Platform E-IDE driver
Feb 22 17:38:49 tippex ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Feb 22 17:38:49 tippex PIIX4: IDE controller (0x8086:0x7111 rev 0x01) at  PCI slot 0000:00:07.1
Feb 22 17:38:49 tippex PIIX4: not 100% native mode: will probe irqs later
Feb 22 17:38:49 tippex ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:PIO
Feb 22 17:38:49 tippex ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:PIO, hdd:PIO
Feb 22 17:38:49 tippex Probing IDE interface ide0...
Feb 22 17:38:49 tippex hdb: IC35L120AVV207-0, ATA DISK drive
Feb 22 17:38:49 tippex hda: IBM-DTTA-371010, ATA DISK drive
Feb 22 17:38:49 tippex hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 17:38:49 tippex hda: UDMA/33 mode selected
Feb 22 17:38:49 tippex hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 17:38:49 tippex hdb: UDMA/33 mode selected
Feb 22 17:38:49 tippex Probing IDE interface ide1...
Feb 22 17:38:49 tippex hdd: Maxtor 6L250R0, ATA DISK drive
Feb 22 17:38:49 tippex hdc: AOPEN DUW1608/ARR, ATAPI CD/DVD-ROM drive
Feb 22 17:38:49 tippex hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 17:38:49 tippex hdc: UDMA/33 mode selected
Feb 22 17:38:49 tippex hdd: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Feb 22 17:38:49 tippex hdd: UDMA/33 mode selected
Feb 22 17:38:49 tippex ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Feb 22 17:38:49 tippex ide1 at 0x170-0x177,0x376 on irq 15
Feb 22 17:38:49 tippex hda: max request size: 128KiB
Feb 22 17:38:49 tippex hda: 19746720 sectors (10110 MB) w/465KiB Cache, CHS=20896/15/63
Feb 22 17:38:49 tippex hda: cache flushes not supported
Feb 22 17:38:49 tippex hda: hda1 hda2
Feb 22 17:38:49 tippex hdb: max request size: 512KiB
Feb 22 17:38:49 tippex hdb: 241254720 sectors (123522 MB) w/1821KiB Cache, CHS=16383/255/63
Feb 22 17:38:49 tippex hdb: cache flushes supported
Feb 22 17:38:49 tippex hdb: hdb1
Feb 22 17:38:49 tippex hdd: max request size: 512KiB
Feb 22 17:38:49 tippex hdd: 490234752 sectors (251000 MB) w/16384KiB Cache, CHS=30515/255/63
Feb 22 17:38:49 tippex hdd: cache flushes supported
Feb 22 17:38:49 tippex hdd: hdd1
Feb 22 17:38:49 tippex hdc: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Feb 22 17:38:49 tippex Uniform CD-ROM driver Revision: 3.20
Feb 22 17:38:49 tippex ide-floppy driver 1.00
Feb 22 17:38:49 tippex usbcore: registered new interface driver cdc_acm
Feb 22 17:38:49 tippex /net/tippex.local/usr/src/linux-2.6.25/drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver for USB modems and ISDN adapters
Feb 22 17:38:49 tippex usbcore: registered new interface driver usblp
Feb 22 17:38:49 tippex Initializing USB Mass Storage driver...
Feb 22 17:38:49 tippex usbcore: registered new interface driver usb-storage
Feb 22 17:38:49 tippex USB Mass Storage support registered.
Feb 22 17:38:49 tippex usbcore: registered new interface driver libusual
Feb 22 17:38:49 tippex PNP: No PS/2 controller found. Probing ports directly.
Feb 22 17:38:49 tippex serio: i8042 KBD port at 0x60,0x64 irq 1
Feb 22 17:38:49 tippex serio: i8042 AUX port at 0x60,0x64 irq 12
Feb 22 17:38:49 tippex mice: PS/2 mouse device common for all mice
Feb 22 17:38:49 tippex Bluetooth: HCI USB driver ver 2.9
Feb 22 17:38:49 tippex usbcore: registered new interface driver hci_usb
Feb 22 17:38:49 tippex Bluetooth: Virtual HCI driver ver 1.2
Feb 22 17:38:49 tippex Bluetooth: HCI UART driver ver 2.2
Feb 22 17:38:49 tippex Bluetooth: HCI H4 protocol initialized
Feb 22 17:38:49 tippex Bluetooth: HCI BCSP protocol initialized
Feb 22 17:38:49 tippex Bluetooth: Broadcom Blutonium firmware driver ver 1.1
Feb 22 17:38:49 tippex usbcore: registered new interface driver bcm203x
Feb 22 17:38:49 tippex Bluetooth: Digianswer Bluetooth USB driver ver 0.9
Feb 22 17:38:49 tippex usbcore: registered new interface driver bpa10x
Feb 22 17:38:49 tippex Bluetooth: BlueFRITZ! USB driver ver 1.1
Feb 22 17:38:49 tippex usbcore: registered new interface driver bfusb
Feb 22 17:38:49 tippex EDAC MC: Ver: 2.1.0 Feb 22 2008
Feb 22 17:38:49 tippex Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
Feb 22 17:38:49 tippex azt2320 00:01.01: activated
Feb 22 17:38:49 tippex azt2320 00:01.02: activated
Feb 22 17:38:49 tippex ALSA device list:
Feb 22 17:38:49 tippex #0: Aztech AZT2320, WSS at 0x534, irq 5, dma 1&3
Feb 22 17:38:49 tippex Netfilter messages via NETLINK v0.30.
Feb 22 17:38:49 tippex ip_tables: (C) 2000-2006 Netfilter Core Team
Feb 22 17:38:49 tippex TCP cubic registered
Feb 22 17:38:49 tippex NET: Registered protocol family 1
Feb 22 17:38:49 tippex NET: Registered protocol family 10
Feb 22 17:38:49 tippex IPv6 over IPv4 tunneling driver
Feb 22 17:38:49 tippex NET: Registered protocol family 17
Feb 22 17:38:49 tippex NET: Registered protocol family 15
Feb 22 17:38:49 tippex Bluetooth: L2CAP ver 2.9
Feb 22 17:38:49 tippex Bluetooth: L2CAP socket layer initialized
Feb 22 17:38:49 tippex Bluetooth: SCO (Voice Link) ver 0.5
Feb 22 17:38:49 tippex Bluetooth: SCO socket layer initialized
Feb 22 17:38:49 tippex Bluetooth: RFCOMM socket layer initialized
Feb 22 17:38:49 tippex Bluetooth: RFCOMM TTY layer initialized
Feb 22 17:38:49 tippex Bluetooth: RFCOMM ver 1.8
Feb 22 17:38:49 tippex Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Feb 22 17:38:49 tippex Bluetooth: BNEP filters: protocol multicast
Feb 22 17:38:49 tippex Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Feb 22 17:38:49 tippex RPC: Registered udp transport module.
Feb 22 17:38:49 tippex RPC: Registered tcp transport module.
Feb 22 17:38:49 tippex Using IPI Shortcut mode
Feb 22 17:38:49 tippex input: ImPS/2 Generic Wheel Mouse as /class/input/input0
Feb 22 17:38:49 tippex input: AT Translated Set 2 keyboard as /class/input/input1
Feb 22 17:38:49 tippex kjournald starting.  Commit interval 5 seconds
Feb 22 17:38:49 tippex EXT3-fs: mounted filesystem with ordered data mode.
Feb 22 17:38:49 tippex VFS: Mounted root (ext3 filesystem) readonly.
Feb 22 17:38:49 tippex Freeing unused kernel memory: 216k freed
Feb 22 17:38:49 tippex Linux agpgart interface v0.103
Feb 22 17:38:49 tippex USB Universal Host Controller Interface driver v3.0
Feb 22 17:38:49 tippex PCI: Enabling device 0000:00:07.2 (0000 -> 0001)
Feb 22 17:38:49 tippex PCI: Found IRQ 11 for device 0000:00:07.2
Feb 22 17:38:49 tippex PCI: Sharing IRQ 11 with 0000:00:0b.0
Feb 22 17:38:49 tippex PCI: Setting latency timer of device 0000:00:07.2 to 64
Feb 22 17:38:49 tippex uhci_hcd 0000:00:07.2: UHCI Host Controller
Feb 22 17:38:49 tippex uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
Feb 22 17:38:49 tippex uhci_hcd 0000:00:07.2: irq 11, io base 0x00006000
Feb 22 17:38:49 tippex usb usb1: configuration #1 chosen from 1 choice
Feb 22 17:38:49 tippex hub 1-0:1.0: USB hub found
Feb 22 17:38:49 tippex hub 1-0:1.0: 2 ports detected
Feb 22 17:38:49 tippex usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
Feb 22 17:38:49 tippex usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
Feb 22 17:38:49 tippex usb usb1: Product: UHCI Host Controller
Feb 22 17:38:49 tippex usb usb1: Manufacturer: Linux 2.6.25-rc2 uhci_hcd
Feb 22 17:38:49 tippex usb usb1: SerialNumber: 0000:00:07.2
Feb 22 17:38:49 tippex agpgart: Detected an Intel 440BX Chipset.
Feb 22 17:38:49 tippex agpgart: AGP aperture is 64M @ 0xe8000000
Feb 22 17:38:49 tippex input: PC Speaker as /class/input/input2
Feb 22 17:38:49 tippex piix4_smbus 0000:00:07.3: Found 0000:00:07.3 device
Feb 22 17:38:49 tippex usb 1-2: new full speed USB device using uhci_hcd and address 2
Feb 22 17:38:49 tippex PCI: setting IRQ 10 as level-triggered
Feb 22 17:38:49 tippex PCI: Found IRQ 10 for device 0000:00:0a.0
Feb 22 17:38:49 tippex phy0: Selected rate control algorithm 'pid'
Feb 22 17:38:49 tippex usb 1-2: configuration #1 chosen from 1 choice
Feb 22 17:38:49 tippex usb 1-2: New USB device found, idVendor=07b8, idProduct=b02a
Feb 22 17:38:49 tippex usb 1-2: New USB device strings: Mfr=0, Product=2, SerialNumber=0
Feb 22 17:38:49 tippex usb 1-2: Product: Bluetooth USB Adapter
Feb 22 17:38:49 tippex EXT3 FS on hdb1, internal journal
Feb 22 17:38:49 tippex EXT2-fs warning (device hda1): ext2_fill_super: mounting ext3 filesystem as ext2
Feb 22 17:38:49 tippex kjournald starting.  Commit interval 5 seconds
Feb 22 17:38:49 tippex EXT3 FS on hdd1, internal journal
Feb 22 17:38:49 tippex EXT3-fs: mounted filesystem with ordered data mode.
Feb 22 17:38:49 tippex Adding 195304k swap on /var/cache/swapfile.  Priority:-1 extents:2098 across:40112396k
Feb 22 17:38:49 tippex Adding 102392k swap on /var/cache/swapfile.2.  Priority:-2 extents:663 across:3794356k
Feb 22 17:38:49 tippex Real Time Clock Driver v1.12ac
Feb 22 17:38:49 tippex ADDRCONF(NETDEV_UP): wlan0: link is not ready
Feb 22 17:38:49 tippex wlan0: Initial auth_alg=0
Feb 22 17:38:49 tippex wlan0: authenticate with AP 00:18:39:c0:5f:50
Feb 22 17:38:49 tippex wlan0: RX authentication from 00:18:39:c0:5f:50 (alg=0 transaction=2 status=0)
Feb 22 17:38:49 tippex wlan0: authenticated
Feb 22 17:38:49 tippex wlan0: associate with AP 00:18:39:c0:5f:50
Feb 22 17:38:49 tippex wlan0: RX AssocResp from 00:18:39:c0:5f:50 (capab=0x431 status=0 aid=1)
Feb 22 17:38:49 tippex wlan0: associated
Feb 22 17:38:49 tippex ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Feb 22 17:38:49 tippex hda: UDMA/33 mode selected
Feb 22 17:38:49 tippex hda: task_no_data_intr: status=0x51 { DriveReady SeekComplete Error }
Feb 22 17:38:49 tippex hda: task_no_data_intr: error=0x04 { DriveStatusError }
Feb 22 17:38:49 tippex ide: failed opcode was: 0xef
Feb 22 17:38:49 tippex hdb: UDMA/33 mode selected
Feb 22 17:38:49 tippex hdd: UDMA/33 mode selected


