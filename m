Return-Path: <linux-kernel-owner+w=401wt.eu-S1758249AbYGRMCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249AbYGRMCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYGRMCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:02:24 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:51383 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752155AbYGRMCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:02:22 -0400
Date: Fri, 18 Jul 2008 08:02:19 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080718120219.GA2695@bromo.msbb.uc.edu>
References: <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com> <20080718011532.GA30920@bromo.msbb.uc.edu> <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com> <20080718060935.GA32345@bromo.msbb.uc.edu> <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807172322s5dabbd1bx297742d782e373d6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:22:15PM -0700, Yinghai Lu wrote:
> On Thu, Jul 17, 2008 at 11:09 PM, Jack Howarth
> <howarth@bromo.msbb.uc.edu> wrote:
> > YH,
> >   I built a fedora kernel rpm using the diff of the vanilla
> > 2.6.26 release vs the current git of the linus kernel tree.
> > The option for pci_early_config_dump appears to have been
> > renamed as earlydump. Using 'debug pci=earlydump', I get the
> > following PCI information from the bios. This kernel uses your
> > mmconfig patch with the dmicode of MacBookPro2.
> 
> how about
> lspci -vvxxxx
> 
> YH

YH,
   I get the attached when booted under the current linus 2.6 git.
Let me know if between the earlydump results and these if anything
comes to mind as to why PCIEASPM is freezing up on the probe behind
the bridge.
                       Jack
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
00: 86 80 a0 27 06 00 90 20 03 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT Express PCI Express Root Port (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: d8300000-d83fffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp
00: 86 80 a1 27 07 00 10 00 03 00 04 06 40 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 00 30 30 00 00
20: 30 d8 30 d8 01 c0 f1 cf 00 00 00 00 00 00 00 00
30: 00 00 00 00 88 00 00 00 00 00 00 00 0b 01 08 00

00:07.0 Performance counters: Intel Corporation Unknown device 27a3 (rev 03)
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at d8404000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>
00: 86 80 a3 27 02 00 b0 00 03 00 01 11 00 00 00 00
10: 00 40 40 d8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 dc 00 00 00 00 00 00 00 0b 01 00 00

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
	Subsystem: Sigmatel Unknown device 7680
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at d8400000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel
00: 86 80 d8 27 06 00 10 00 02 00 03 04 40 00 00 00
10: 04 00 40 d8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 84 83 80 76
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: d8200000-d82fffff
	Prefetchable memory behind bridge: 00000000d8500000-00000000d85fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp
00: 86 80 d0 27 07 00 10 00 02 00 04 06 40 00 81 00
10: 00 00 00 00 00 00 00 00 00 02 02 00 20 20 00 00
20: 20 d8 20 d8 51 d8 51 d8 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 00 00

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Memory behind bridge: d8100000-d81fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp
00: 86 80 d2 27 07 00 10 00 02 00 04 06 40 00 81 00
10: 00 00 00 00 00 00 00 00 00 03 03 00 f0 00 00 20
20: 10 d8 10 d8 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 00 00

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Bus: primary=00, secondary=04, subordinate=0b, sec-latency=0
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: d4100000-d80fffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d3ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp
00: 86 80 d4 27 07 00 10 00 02 00 04 06 40 00 81 00
10: 00 00 00 00 00 00 00 00 00 04 0b 00 10 10 00 00
20: 10 d4 00 d8 01 d0 f1 d3 00 00 00 00 00 00 00 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 03 00 00

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at 4080 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd
00: 86 80 c8 27 05 00 80 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 40 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 4060 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd
00: 86 80 c9 27 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 61 40 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 4040 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd
00: 86 80 ca 27 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 41 40 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 03 00 00

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at 4020 [size=32]
	Kernel driver in use: uhci_hcd
	Kernel modules: uhci-hcd
00: 86 80 cb 27 05 00 80 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 21 40 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 04 00 00

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at d8405400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ehci_hcd
	Kernel modules: ehci-hcd
00: 86 80 cc 27 06 00 90 02 02 20 03 0c 00 00 00 00
10: 00 54 40 d8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=32
	Memory behind bridge: d4000000-d40fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: <access denied>
00: 86 80 48 24 07 00 10 00 e2 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 0c 0c 20 f0 00 80 22
20: 00 d4 00 d4 f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 00 00 00 00

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: <access denied>
	Kernel modules: iTCO_wdt, intel-rng
00: 86 80 b9 27 07 00 10 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 40b0 [size=16]
	Kernel driver in use: ata_piix
	Kernel modules: pata_acpi, ata_generic, ata_piix
00: 86 80 df 27 05 00 80 02 02 8a 01 01 00 00 00 00
10: d9 40 00 00 ed 40 00 00 d1 40 00 00 e9 40 00 00
20: b1 40 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 01 00 00

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 40c8 [size=8]
	Region 1: I/O ports at 40e4 [size=4]
	Region 2: I/O ports at 40c0 [size=8]
	Region 3: I/O ports at 40e0 [size=4]
	Region 4: I/O ports at 40a0 [size=16]
	Region 5: Memory at d8405000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: <access denied>
	Kernel driver in use: ata_piix
	Kernel modules: pata_acpi, ata_generic, ata_piix
00: 86 80 c4 27 07 00 b0 02 02 8f 01 01 00 00 00 00
10: c9 40 00 00 e5 40 00 00 c1 40 00 00 e1 40 00 00
20: a1 40 00 00 00 50 40 d8 00 00 00 00 86 80 70 72
30: 00 00 00 00 70 00 00 00 00 00 00 00 0b 02 00 00

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
	Subsystem: Intel Corporation Unknown device 7270
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at efa0 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801
00: 86 80 da 27 01 00 80 02 02 00 05 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 ef 00 00 00 00 00 00 00 00 00 00 86 80 70 72
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00

01:00.0 VGA compatible controller: ATI Technologies Inc M56P [Radeon Mobility X1600] (prog-if 00 [VGA controller])
	Subsystem: Apple Computer Inc. Unknown device 0080
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 3000 [size=256]
	Region 2: Memory at d8300000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at d8320000 [disabled] [size=128K]
	Capabilities: <access denied>
00: 02 10 c5 71 07 00 10 00 00 00 00 03 40 00 00 00
10: 08 00 00 c0 01 30 00 00 00 00 30 d8 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 6b 10 80 00
30: 00 00 fe ff 50 00 00 00 00 00 00 00 0b 01 00 00

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 22)
	Subsystem: Marvell Technology Group Ltd. Marvell RDK-8053
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d8200000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at 2000 [size=256]
	Expansion ROM at d8500000 [disabled] [size=128K]
	Capabilities: <access denied>
	Kernel driver in use: sky2
	Kernel modules: sky2
00: ab 11 62 43 07 00 10 00 22 00 00 02 40 00 00 00
10: 04 00 20 d8 00 00 00 00 01 20 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 ab 11 21 53
30: 00 00 fe ff 48 00 00 00 00 00 00 00 0b 01 00 00

03:00.0 Network controller: Atheros Communications Inc. AR5418 802.11abgn Wireless PCI Express Adapter (rev 01)
	Subsystem: Apple Computer Inc. Unknown device 0087
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 256 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at d8100000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: <access denied>
	Kernel driver in use: ath_pci
	Kernel modules: ath_pci, ath5k
00: 8c 16 24 00 07 00 10 00 01 00 80 02 40 00 00 00
10: 04 00 10 d8 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 6b 10 87 00
30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00

0c:03.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 IEEE-1394b Link Layer Controller (rev 01) (prog-if 10 [OHCI])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 248 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at d4004000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at d4000000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci
00: 4c 10 25 80 16 00 10 02 01 10 00 0c 10 f8 00 00
10: 00 40 00 d4 00 00 00 d4 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 01 02 04

