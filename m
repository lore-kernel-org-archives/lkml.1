Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbZE2TrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbZE2TrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZE2TrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:47:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42740 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbZE2TrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:47:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: Stable regression 2.6.29.3 vs 2.6.29.2
Date: Fri, 29 May 2009 21:47:04 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, stable <stable@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1243625720.4426.0.camel@plop>
In-Reply-To: <1243625720.4426.0.camel@plop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905292147.05395.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 May 2009, Pascal Terjan wrote:
> (Resending because of wrong To:, sorry for the duplicate)
> 
> We have a machine here where hard disk is no longer detected at boot
> time with 2.6.29.3 (it happens only on kernels with HIGHMEM4G + PAE and
> not on the same one with HIGHMEM64G). 
>
> Motherboard is ECS PF22 Extreme
> 
> bisect blames this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=3b442bfc78d351343fa539c63afde75d7b134316

Would it be possible to check if the current mainline works correctly?

Rafael
 

> lspci -vvv:
> 
> 00:00.0 Host bridge: Intel Corporation 82955X Memory Controller Hub (rev
> 81)
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
> 
> 00:01.0 PCI bridge: Intel Corporation 82955X PCI Express Root Port (rev
> 81) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> 	I/O behind bridge: 00009000-00009fff
> 	Memory behind bridge: f7e00000-fdefffff
> 	Prefetchable memory behind bridge: 00000000aff00000-00000000efefffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport-driver
> 	Kernel modules: shpchp
> 
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
> Definition Audio Controller (rev 01)
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at febf8000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: HDA Intel
> 	Kernel modules: snd-hda-intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 1 (rev 01) (prog-if 00 [Normal decode])
> 	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: fff00000-000fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport-driver
> 	Kernel modules: shpchp
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
> Express Port 5 (rev 01) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> 	I/O behind bridge: 0000a000-0000afff
> 	Memory behind bridge: fdf00000-fe7fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport-driver
> 	Kernel modules: shpchp
> 
> 00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
> Express Port 6 (rev 01) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
> 	I/O behind bridge: 0000b000-0000bfff
> 	Memory behind bridge: fe800000-fe9fffff
> 	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 	Kernel driver in use: pcieport-driver
> 	Kernel modules: shpchp
> 
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #1 (rev 01) (prog-if 00 [UHCI])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 23
> 	Region 4: I/O ports at e080 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #2 (rev 01) (prog-if 00 [UHCI])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 19
> 	Region 4: I/O ports at e000 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #3 (rev 01) (prog-if 00 [UHCI])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at dc00 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
> Controller #4 (rev 01) (prog-if 00 [UHCI])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 16
> 	Region 4: I/O ports at d880 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
> Controller (rev 01) (prog-if 20 [EHCI])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 23
> 	Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ehci_hcd
> 	Kernel modules: ehci-hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if
> 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
> 	I/O behind bridge: 0000c000-0000cfff
> 	Memory behind bridge: fea00000-feafffff
> 	Prefetchable memory behind bridge: 0000000030000000-00000000300fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
> Interface Bridge (rev 01)
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Capabilities: <access denied>
> 	Kernel modules: iTCO_wdt, intel-rng
> 
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
> Controller (rev 01) (prog-if 8a [Master SecP PriP])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: I/O ports at 01f0 [size=8]
> 	Region 1: I/O ports at 03f4 [size=1]
> 	Region 2: I/O ports at 0170 [size=8]
> 	Region 3: I/O ports at 0374 [size=1]
> 	Region 4: I/O ports at ffa0 [size=16]
> 	Kernel driver in use: ata_piix
> 	Kernel modules: ata_piix, piix
> 
> 00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family) SATA
> AHCI Controller (rev 01) (prog-if 01 [AHCI 1.0])
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 28
> 	Region 0: I/O ports at ec00 [size=8]
> 	Region 1: I/O ports at e880 [size=4]
> 	Region 2: I/O ports at e800 [size=8]
> 	Region 3: I/O ports at e480 [size=4]
> 	Region 4: I/O ports at e400 [size=32]
> 	Region 5: Memory at febffc00 (32-bit, non-prefetchable) [size=1K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ahci
> 	Kernel modules: ahci
> 
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
> (rev 01)
> 	Subsystem: Elitegroup Computer Systems Device 1b75
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin B routed to IRQ 19
> 	Region 4: I/O ports at 0400 [size=32]
> 	Kernel driver in use: i801_smbus
> 	Kernel modules: i2c-i801
> 
> 01:00.0 VGA compatible controller: nVidia Corporation GeForce 9500 GT
> (rev a1) (prog-if 00 [VGA controller])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 10
> 	Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=16M]
> 	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=512M]
> 	Region 3: Memory at fa000000 (64-bit, non-prefetchable) [size=32M]
> 	Region 5: I/O ports at 9c00 [size=128]
> 	Expansion ROM at fde80000 [disabled] [size=512K]
> 	Capabilities: <access denied>
> 	Kernel modules: nvidiafb
> 
> 03:00.0 Ethernet controller: Intel Corporation 82573V Gigabit Ethernet
> Controller (Copper) (rev 03)
> 	Subsystem: Intel Corporation Device 0000
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 29
> 	Region 0: Memory at fe7e0000 (32-bit, non-prefetchable) [size=128K]
> 	Region 1: Memory at fe000000 (32-bit, non-prefetchable) [size=4M]
> 	Region 2: I/O ports at ac00 [size=32]
> 	Capabilities: <access denied>
> 	Kernel driver in use: e1000e
> 	Kernel modules: e1000e
> 
> 04:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA
> Raid II Controller (rev 01)
> 	Subsystem: Elitegroup Computer Systems Device 5308
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at fe9ffc00 (64-bit, non-prefetchable) [size=128]
> 	Region 2: Memory at fe9f8000 (64-bit, non-prefetchable) [size=16K]
> 	Region 4: I/O ports at bc00 [size=128]
> 	Expansion ROM at fe900000 [disabled] [size=512K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: sata_sil24
> 	Kernel modules: sata_sil24
> 
> 05:04.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE
> 1394 OHCI Link Layer Controller (rev 80) (prog-if 10 [OHCI])
> 	Subsystem: VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link
> Layer Controller
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (8000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 22
> 	Region 0: Memory at feaff800 (32-bit, non-prefetchable) [size=2K]
> 	Region 1: I/O ports at cc00 [size=128]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ohci1394
> 	Kernel modules: ohci1394
> 
> 05:05.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
> Gigabit Ethernet (rev 10)
> 	Subsystem: Elitegroup Computer Systems Device 1853
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 21
> 	Region 0: I/O ports at c800 [size=256]
> 	Region 1: Memory at feaff400 (32-bit, non-prefetchable) [size=256]
> 	Expansion ROM at 30000000 [disabled] [size=128K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: r8169
> 	Kernel modules: r8169
