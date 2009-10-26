Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZJZH2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZJZH2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZJZH2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:28:03 -0400
Received: from www84.your-server.de ([213.133.104.84]:48476 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbZJZH2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:28:01 -0400
Subject: Re: PCI Express-to-PCI Bridge: yenta_cardbus  no bus associated!
From: Stefani Seibold <stefani@seibold.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Matthew Wilcox <matthew@wil.cx>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091025083841.GA12526@isilmar.linta.de>
References: <1254248605.8881.1.camel@wall-e>
	 <200909300115.54263.rjw@sisk.pl> <1256393003.9013.4.camel@wall-e>
	 <20091024203452.GA10555@parisc-linux.org> <1256458229.4026.1.camel@wall-e>
	 <20091025083841.GA12526@isilmar.linta.de>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 08:27:53 +0100
Message-Id: <1256542073.4187.14.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > 
> > Okay, i tried it again with 'pci=assign-bussed'. All i get is a
> > 
> > decode_hpp: Could not get hotplug parameters. Use defaults
> > 
> > thats all. The express-card will not be detected.
> 
> I assume the "d" at the end was just a typo -- and "lspci -vvv" looks the
> same?
> 

Yes, this was a typo. Here are the diff's of dmesg and lspci -vvv with
and without "pci=assign-busses" after inserting the express card.

dmesg without 'pci=assign-busses':
----------------------------------

pci 0000:0e:00.0: supports D1 D2
pci 0000:0f:00.0: reg 10 32bit mmio: [0x000000-0x000fff]
pci 0000:0f:00.0: supports D1 D2
pci 0000:0f:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0f:00.0: PME# disabled
pci 0000:0e:00.0: bridge io port: [0x00-0xfff]
pci 0000:0e:00.0: bridge 32bit mmio: [0x000000-0x0fffff]
pci 0000:0e:00.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
ACPI: Delete PCI Interrupt Routing Table for 0000:0f
pci 0000:0e:00.0: PCI bridge, secondary bus 0000:0f
pci 0000:0e:00.0:   IO window: disabled
pci 0000:0e:00.0:   MEM window: 0xf1c00000-0xf1cfffff
pci 0000:0e:00.0:   PREFETCH window: disabled
decode_hpp: Could not get hotplug parameters. Use defaults
pci 0000:0e:00.0: enabling device (0000 -> 0002)
pci 0000:0e:00.0: setting latency timer to 64
yenta_cardbus 0000:0f:00.0: no bus associated! (try 'pci=assign-busses')
CE: hpet increasing min_delta_ns to 50624 nsec

lspci -vvv without 'pci=assign-busses':
---------------------------------------

0e:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 1
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=0e, secondary=0f, subordinate=0f, sec-latency=64
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f1c00000-f1cfffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [60] MSI: Enable- Count=1/16 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Subsystem: Device 5678:1234
	Capabilities: [90] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ BrConfRtry-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr+ FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-

0f:00.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
	Subsystem: Texas Instruments Device ac48
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at f1c00000 (32-bit, non-prefetchable) [disabled] [size=4K]
	Bus: primary=00, secondary=00, subordinate=00, sec-latency=0
	Memory window 0: 00000000-00000000 [disabled] (prefetchable)
	Memory window 1: 00000000-00000000 [disabled] (prefetchable)
	I/O window 0: 00000000-00000003 [disabled]
	I/O window 1: 00000000-00000003 [disabled]
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt- PostWrite-
	16-bit legacy interface ports at 0001

dmesg with 'pci=assign-busses':
-------------------------------

pci 0000:05:00.0: supports D1 D2
decode_hpp: Could not get hotplug parameters. Use defaults

lspci -vvv with 'pci=assign-busses':
------------------------------------

05:00.0 PCI bridge: Texas Instruments XIO2000(A)/XIO2200(A) PCI Express-to-PCI Bridge (rev 03) (prog-if 00 [Normal decode])
	Physical Slot: 1
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Bus: primary=00, secondary=00, subordinate=00, sec-latency=64
	I/O behind bridge: 00000000-00000fff
	Memory behind bridge: 00000000-000fffff
	Prefetchable memory behind bridge: 0000000000000000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [60] MSI: Enable- Count=1/16 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [80] Subsystem: Device 5678:1234
	Capabilities: [90] Express (v1) PCI/PCI-X Bridge, MSI 00
		DevCap:	MaxPayload 512 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+ BrConfRtry-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-

Greetings,
Stefani


