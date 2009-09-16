Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZIPF1C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZIPF1C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 01:27:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZIPF1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 01:27:00 -0400
Received: from smtp-out-153.synserver.de ([212.40.180.153]:1055 "HELO
	smtp-out-153.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751333AbZIPF05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 01:26:57 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 1927
Date: Wed, 16 Sep 2009 07:26:57 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: x86-PAT tree merge causes keyboard problems
Message-ID: <20090916052657.GA1897@phenom2.trippelsdorf.de>
References: <20090915205259.GA1910@phenom2.trippelsdorf.de>
 <4AB018C0.30203@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AB018C0.30203@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Sep 15, 2009 at 03:44:16PM -0700, H. Peter Anvin wrote:
> On 09/15/2009 01:52 PM, Markus Trippelsdorf wrote:
> > The merge of the PAT tree today breaks certain key combinations of my
> > keyboard.  For example I switch my virtual desktops with
> > ctrl-alt-left/right and this combination stops working. Basically all
> > keyboard combinations involving the left alt key are broken on my
> > machine as a result of this merge.
> 
> > I bisected this down to:
> > 
> > »
> > 335ef896d4c6639849d79367f0fef9abc06d121b is the first bad commit
> > commit 335ef896d4c6639849d79367f0fef9abc06d121b
> > Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Date:   Fri Jul 10 09:57:36 2009 -0700
> > 
> >     x86, pat: Add rbtree to do quick lookup in memtype tracking
> 
> I think we have a winner for the second bizarrest bug report I've ever
> seen[1].  Not doubting you in any way, just that it is clearly a very
> strange combination of things at play here.

Haha, I knew that it would sound ridiculous... 

> We need more information about your system, the lspci -vv and dmidecode
> output, as well as your entire dmesg, and a dump of
> /debug/x86/pat_memtype_list.

OK. I've attached most of those.
The Xorg.log is also interesting:

(EE) XKB: Could not invoke xkbcomp
(EE) XKB: Couldn't compile keymap
(WW) Couldn't load XKB keymap, falling back to pre-XKB keymap

-- 
Markus

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=lspci

00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
	Subsystem: Advanced Micro Devices [AMD] RS780 Host Bridge
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [c4] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=12 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn+ LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [b]
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [54] HyperTransport: UnitID Clumping
	Capabilities: [40] HyperTransport: Retry Mode
	Capabilities: [9c] HyperTransport: #1a
	Capabilities: [f8] HyperTransport: #1c

00:01.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fbd00000-fbefffff
	Prefetchable memory behind bridge: 00000000f0000000-00000000f7ffffff
	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] HyperTransport: MSI Mapping Enable+ Fixed+
	Capabilities: [b0] Subsystem: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge (int gfx)

00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode] (prog-if 01 [AHCI 1.0])
	Subsystem: ATI Technologies Inc SB700/SB800 SATA Controller [IDE mode]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: I/O ports at c000 [size=8]
	Region 1: I/O ports at b000 [size=4]
	Region 2: I/O ports at a000 [size=8]
	Region 3: I/O ports at 9000 [size=4]
	Region 4: I/O ports at 8000 [size=16]
	Region 5: Memory at fbcffc00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [70] SATA HBA <?>
	Kernel driver in use: ahci

00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbcfd000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc SB700 USB OHCI1 Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at fbcfe000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ATI Technologies Inc Device 4397
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 17
	Region 0: Memory at fbcff800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0 Controller (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Device 4398
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbcfb000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Device 4399
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at fbcfc000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller (prog-if 20 [EHCI])
	Subsystem: ATI Technologies Inc SB700/SB800 USB EHCI Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at fbcff400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
		Bridge: PM- B3+
	Capabilities: [e4] Debug port: BAR=1 offset=00e0
	Kernel driver in use: ehci_hcd

00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
	Subsystem: ATI Technologies Inc SBx00 SMBus Controller
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [b0] HyperTransport: MSI Mapping Enable- Fixed+

00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: ATI Technologies Inc SB700/SB800 IDE Controller
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ff00 [size=16]
	Capabilities: [70] MSI: Enable- Count=1/2 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Kernel driver in use: pata_atiixp

00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
	Subsystem: ATI Technologies Inc Device 4383
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fbf00000-fbffffff
	Prefetchable memory behind bridge: f8000000-f80fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2 Controller (prog-if 10 [OHCI])
	Subsystem: ATI Technologies Inc Device 4396
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at fbcfa000 (32-bit, non-prefetchable) [size=4K]
	Kernel driver in use: ohci_hcd

00:18.0 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn+ LSEn+ ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] K10 [Opteron, Athlon64, Sempron] Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3300 Graphics (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 834d
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at d000 [size=256]
	Region 2: Memory at fbee0000 (32-bit, non-prefetchable) [size=64K]
	Region 5: Memory at fbd00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

01:05.1 Audio device: ATI Technologies Inc RS780 Azalia controller
	Subsystem: ATI Technologies Inc RS780 Azalia controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin B routed to IRQ 11
	Region 0: Memory at fbefc000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000

02:05.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (8000ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: I/O ports at e800 [size=256]
	Region 1: Memory at fbfffc00 (32-bit, non-prefetchable) [size=256]
	Expansion ROM at f8000000 [disabled] [size=128K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: r8169


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmidecode

# dmidecode 2.10
SMBIOS 2.5 present.
65 structures occupying 2385 bytes.
Table at 0x000F06E0.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 2001   
	Release Date: 08/25/2009
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 kB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 8.15

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: System manufacturer
	Product Name: System Product Name
	Version: System Version
	Serial Number: System Serial Number
	UUID: 8008001E-8C00-01DA-782C-00248C85CBA6
	Wake-up Type: Power Switch
	SKU Number: To Be Filled By O.E.M.
	Family: To Be Filled By O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: ASUSTeK Computer INC.
	Product Name: M4A78T-E
	Version: Rev 1.xx
	Serial Number: MS1C94B20501111
	Asset Tag: To Be Filled By O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To Be Filled By O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: Chassis Manufacture
	Type: Desktop
	Lock: Not Present
	Version: Chassis Version
	Serial Number: Chassis Serial Number
	Asset Tag: Asset-1234567890
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000001
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 40 bytes
Processor Information
	Socket Designation: AM3
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: AMD              
	ID: 42 0F 10 00 FF FB 8B 17
	Version: AMD Phenom(tm) II X4 955 Processor                  
	Voltage: 1.5 V
	External Clock: 200 MHz
	Max Speed: 3200 MHz
	Current Speed: 3210 MHz
	Status: Populated, Enabled
	Upgrade: Other
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 4
	Core Enabled: 4
	Thread Count: 4
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 512 kB
	Maximum Size: 512 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Data
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 2048 kB
	Maximum Size: 2048 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Varies With Memory Address
	Location: Internal
	Installed Size: 6144 kB
	Maximum Size: 6144 kB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS/2
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB12
	Internal Connector Type: None
	External Reference Designator: USB12
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB34
	Internal Connector Type: None
	External Reference Designator: USB34
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: On Board VGA
	Internal Connector Type: None
	External Reference Designator: On Board VGA
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LAN1
	Internal Connector Type: None
	External Reference Designator: LAN1
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIF_O1
	Internal Connector Type: None
	External Reference Designator: SPDIF_O1
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: HDMI
	Internal Connector Type: None
	External Reference Designator: HDMI
	External Connector Type: Other
	Port Type: Audio Port

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Line In
	Internal Connector Type: None
	External Reference Designator: Line In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Line Out
	Internal Connector Type: None
	External Reference Designator: Line Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Mic In
	Internal Connector Type: None
	External Reference Designator: Mic In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Center Out
	Internal Connector Type: None
	External Reference Designator: Center Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Surround Out
	Internal Connector Type: None
	External Reference Designator: Surround Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: Side Surround
	Internal Connector Type: None
	External Reference Designator: Side Surround Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: MAIN POWER
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CPU_FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CHA_FAN2
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB56
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB78
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB910
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1112
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA1
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA2
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA3
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA4
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA5
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: ESATA
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CDIN
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0024, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: AAFP
	Internal Connector Type: Mini Jack (headphones)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0025, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SPDIF_OUT
	Internal Connector Type: Mini Jack (headphones)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0026, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: 9 Pin Dual Inline (pin 10 cut)
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0027, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PRI_IDE
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0028, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FLOPPY
	Internal Connector Type: On Board Floppy
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0029, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PANEL
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x002A, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX16_1
	Type: x16 PCI Express
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002B, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX16_2
	Type: x16 PCI Express
	Current Usage: Available
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002C, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX1_1
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002D, DMI type 9, 13 bytes
System Slot Information
	Designation: PCIEX1_2
	Type: x1 PCI Express
	Current Usage: Available
	Length: Short
	ID: 5
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002E, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 13
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002F, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: Available
	Length: Short
	ID: 14
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0030, DMI type 10, 6 bytes
On Board Device Information
	Type: Video
	Status: Enabled
	Description:   To Be Filled By O.E.M.

Handle 0x0031, DMI type 11, 5 bytes
OEM Strings
	String 1: 00248C85CBA6
	String 2: To Be Filled By O.E.M.
	String 3: To Be Filled By O.E.M.
	String 4: To Be Filled By O.E.M.

Handle 0x0032, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x0033, DMI type 15, 35 bytes
System Event Log
	Area Length: 4 bytes
	Header Start Offset: 0x0000
	Header Length: 2 bytes
	Data Start Offset: 0x0002
	Access Method: Indexed I/O, one 16-bit index port, one 8-bit data port
	Access Address: Index 0x046A, Data 0x046C
	Status: Invalid, Not Full
	Change Token: 0x00000000
	Header Format: No Header
	Supported Log Type Descriptors: 6
	Descriptor 1: End of log
	Data Format 1: OEM-specific
	Descriptor 2: End of log
	Data Format 2: OEM-specific
	Descriptor 3: End of log
	Data Format 3: OEM-specific
	Descriptor 4: End of log
	Data Format 4: OEM-specific
	Descriptor 5: End of log
	Data Format 5: OEM-specific
	Descriptor 6: End of log
	Data Format 6: OEM-specific

Handle 0x0034, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x0035, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0019FFFFFFF
	Range Size: 6656 MB
	Physical Array Handle: 0x0034
	Partition Width: 0

Handle 0x0036, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0034
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM0
	Bank Locator: BANK0
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: Manufacturer00
	Serial Number: SerNum00
	Asset Tag: AssetTagNum0
	Part Number: ModulePartNumber00

Handle 0x0037, DMI type 126, 19 bytes
Inactive

Handle 0x0038, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0034
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK1
	Type: DDR
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Manufacturer01
	Serial Number: SerNum01
	Asset Tag: AssetTagNum1
	Part Number: ModulePartNumber01

Handle 0x0039, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0007FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x0038
	Memory Array Mapped Address Handle: 0x0035
	Partition Row Position: 1

Handle 0x003A, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0034
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM2
	Bank Locator: BANK2
	Type: DDR
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Manufacturer02
	Serial Number: SerNum02
	Asset Tag: AssetTagNum2
	Part Number: ModulePartNumber02

Handle 0x003B, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00080000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x003A
	Memory Array Mapped Address Handle: 0x0035
	Partition Row Position: 1

Handle 0x003C, DMI type 17, 27 bytes
Memory Device
	Array Handle: 0x0034
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 2048 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK3
	Type: DDR
	Type Detail: Synchronous
	Speed: 1333 MHz
	Manufacturer: Manufacturer03
	Serial Number: SerNum03
	Asset Tag: AssetTagNum3
	Part Number: ModulePartNumber03

Handle 0x003D, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x0017FFFFFFF
	Range Size: 2 GB
	Physical Device Handle: 0x003C
	Memory Array Mapped Address Handle: 0x0035
	Partition Row Position: 1

Handle 0x003E, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x003F, DMI type 139, 94 bytes
OEM-specific Type
	Header and Data:
		8B 5E 3F 00 00 1E 8C 00 01 DA 78 2C 04 04 32 55
		F8 00 A2 02 A1 00 40 63 43 10 84 83 03 DF 40 80
		00 20 00 73 3C 10 08 00 60 0F 43 10 15 04 20 00
		3C 10 00 00 00 43 10 00 00 00 00 00 00 00 00 00
		00 00 00 00 2C 78 DA FF FF 8C 1E 00 04 00 00 23
		33 00 00 00 00 00 00 00 00 00 00 00 00 01
	Strings:
		V1394GUID

Handle 0x0040, DMI type 127, 4 bytes
End Of Table


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=Xorg_diff

--- /var/log/Xorg.0.log.old	2009-09-16 07:05:14.000000000 +0200
+++ /var/log/Xorg.0.log	2009-09-16 07:05:50.000000000 +0200
@@ -11,7 +11,7 @@
 Release Date: 2009-8-25
 X Protocol Version 11, Revision 0
 Build Operating System: Linux 2.6.31-04082-g1824090 x86_64 
-Current Operating System: Linux phenom2.trippelsdorf.de 2.6.31-04548-gc789ee1 #14 SMP Tue Sep 15 22:26:19 CEST 2009 x86_64
+Current Operating System: Linux phenom2.trippelsdorf.de 2.6.31-04547-g0cb583f #15 SMP Wed Sep 16 07:04:49 CEST 2009 x86_64
 Build Date: 15 September 2009  01:42:19PM
  
 	Before reporting problems, check http://wiki.x.org
@@ -19,7 +19,7 @@
 Markers: (--) probed, (**) from config file, (==) default setting,
 	(++) from command line, (!!) notice, (II) informational,
 	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
-(==) Log file: "/var/log/Xorg.0.log", Time: Tue Sep 15 22:27:01 2009
+(==) Log file: "/var/log/Xorg.0.log", Time: Wed Sep 16 07:05:48 2009
 (==) Using config file: "/etc/X11/xorg.conf"
 (==) ServerLayout "Simple Layout"
 (**) |-->Screen "Screen 1" (0)
@@ -723,16 +723,16 @@
 (II) RADEON(0): [drm] installed DRM signal handler
 (II) RADEON(0): [pci] 32768 kB allocated with handle 0x006ea900
 (II) RADEON(0): [pci] ring handle = 0x2b800000
-(II) RADEON(0): [pci] Ring mapped at 0x7f93a7711000
+(II) RADEON(0): [pci] Ring mapped at 0x7fab1c81b000
 (II) RADEON(0): [pci] Ring contents 0x00000000
 (II) RADEON(0): [pci] ring read ptr handle = 0x1b7ff000
-(II) RADEON(0): [pci] Ring read ptr mapped at 0x7f93b3d47000
+(II) RADEON(0): [pci] Ring read ptr mapped at 0x7fab28e51000
 (II) RADEON(0): [pci] Ring read ptr contents 0x00000000
 (II) RADEON(0): [pci] vertex/indirect buffers handle = 0x2b801000
-(II) RADEON(0): [pci] Vertex/indirect buffers mapped at 0x7f93a7511000
+(II) RADEON(0): [pci] Vertex/indirect buffers mapped at 0x7fab1c61b000
 (II) RADEON(0): [pci] Vertex/indirect buffers contents 0x00000000
 (II) RADEON(0): [pci] GART texture map handle = 0x2b802000
-(II) RADEON(0): [pci] GART Texture map mapped at 0x7f93a5891000
+(II) RADEON(0): [pci] GART Texture map mapped at 0x7fab1a99b000
 (II) RADEON(0): [drm] register handle = 0x2fff8000
 (II) RADEON(0): [dri] Visual configs initialized
 (II) RADEON(0): RADEONRestoreMemMapRegisters() : 
@@ -870,6 +870,9 @@
 (II) AIGLX: Loaded and initialized /usr/lib64/dri/swrast_dri.so
 (II) GLX: Initialized DRISWRAST GL provider for screen 0
 (II) RADEON(0): Setting screen physical size to 434 x 270
+(EE) XKB: Could not invoke xkbcomp
+(EE) XKB: Couldn't compile keymap
+(WW) Couldn't load XKB keymap, falling back to pre-XKB keymap
 (**) Option "CorePointer"
 (**) Mouse1: always reports core events
 (**) Mouse1: Device: "/dev/input/by-id/usb-Logitech_USB_Receiver-event-mouse"
@@ -899,7 +902,12 @@
 (**) Option "CustomKeycodes" "off"
 (**) Keyboard1: CustomKeycodes disabled
 (II) XINPUT: Adding extended input device "Keyboard1" (type: KEYBOARD)
+(EE) XKB: Could not invoke xkbcomp
+(EE) XKB: Couldn't compile keymap
+(WW) Couldn't load XKB keymap, falling back to pre-XKB keymap
 (II) RADEON(0): Power Mode Switch
+(EE) XKB: Could not invoke xkbcomp
+(EE) XKB: Couldn't compile keymap
 (II) RADEON(0): Output: VGA-0, Detected Monitor Type: 0
 Dac detection success
 (II) RADEON(0): EDID vendor "GSM", prod id 20040

--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Linux version 2.6.31-04547-g0cb583f (markus@phenom2.trippelsdorf.de) (gcc version 4.4.1 (Gentoo 4.4.1) ) #15 SMP Wed Sep 16 07:04:49 CEST 2009
Command line: BOOT_IMAGE=/boot/kernel___ root=/dev/sdb vga=0x323 fbcon=rotate:3 quiet
KERNEL supported cpus:
  AMD AuthenticAMD
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000dff90000 (usable)
 BIOS-e820: 00000000dff90000 - 00000000dffa8000 (ACPI data)
 BIOS-e820: 00000000dffa8000 - 00000000dffd0000 (ACPI NVS)
 BIOS-e820: 00000000dffd0000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 00000001a0000000 (usable)
DMI present.
last_pfn = 0x1a0000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-EFFFF uncachable
  F0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000000 mask FFFF80000000 write-back
  1 base 000080000000 mask FFFFC0000000 write-back
  2 base 0000C0000000 mask FFFFE0000000 write-back
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
TOM2: 00000001a0000000 aka 6656M
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xdff90 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000dff90000
 0000000000 - 00c0000000 page 1G
 00c0000000 - 00dfe00000 page 2M
 00dfe00000 - 00dff90000 page 4k
kernel direct mapping tables up to dff90000 @ 8000-b000
init_memory_mapping: 0000000100000000-00000001a0000000
 0100000000 - 0180000000 page 1G
 0180000000 - 01a0000000 page 2M
kernel direct mapping tables up to 1a0000000 @ a000-c000
ACPI: RSDP 00000000000fb8b0 00024 (v02 ACPIAM)
ACPI: XSDT 00000000dff90100 00054 (v01 082509 XSDT1841 20090825 MSFT 00000097)
ACPI: FACP 00000000dff90290 000F4 (v03 082509 FACP1841 20090825 MSFT 00000097)
ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 20090521 tbfadt-558
ACPI: DSDT 00000000dff90440 0E73F (v01  A1152 A1152000 00000000 INTL 20060113)
ACPI: FACS 00000000dffa8000 00040
ACPI: APIC 00000000dff90390 0006C (v01 082509 APIC1841 20090825 MSFT 00000097)
ACPI: MCFG 00000000dff90400 0003C (v01 082509 OEMMCFG  20090825 MSFT 00000097)
ACPI: OEMB 00000000dffa8040 00072 (v01 082509 OEMB1841 20090825 MSFT 00000097)
ACPI: HPET 00000000dff9f440 00038 (v01 082509 OEMHPET  20090825 MSFT 00000097)
ACPI: SSDT 00000000dff9f480 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
ACPI: Local APIC address 0xfee00000
(7 early reservations) ==> bootmem [0000000000 - 01a0000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0001000000 - 00015522dc]    TEXT DATA BSS ==> [0001000000 - 00015522dc]
  #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #4 [0001553000 - 0001553290]              BRK ==> [0001553000 - 0001553290]
  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
  #6 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
 [ffffea0000000000-ffffea0005bfffff] PMD -> [ffff880028600000-ffff88002dbfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x001a0000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000dff90
    0: 0x00100000 -> 0x001a0000
On node 0 totalpages: 1572655
  DMA zone: 56 pages used for memmap
  DMA zone: 102 pages reserved
  DMA zone: 3841 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 899016 pages, LIFO batch:31
  Normal zone: 8960 pages used for memmap
  Normal zone: 646400 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8300 base: 0xfed00000
SMP: Allowing 4 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 24
Allocating PCI resources starting at e0000000 (gap: e0000000:1ff00000)
NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
PERCPU: Embedded 24 pages/cpu @ffff880028200000 s75936 r0 d22368 u524288
pcpu-alloc: s75936 r0 d22368 u524288 alloc=1*2097152
pcpu-alloc: [0] 0 1 2 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1549257
Kernel command line: BOOT_IMAGE=/boot/kernel___ root=/dev/sdb vga=0x323 fbcon=rotate:3 quiet
PID hash table entries: 4096 (order: 12, 32768 bytes)
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Initializing CPU#0
Checking aperture...
No AGP bridge found
Node 0: aperture @ 20000000 size 32 MB
Aperture pointing to e820 RAM. Ignoring.
Your BIOS doesn't leave a aperture memory hole
Please enable the IOMMU option in the BIOS setup
This costs you 64 MB of RAM
Mapping aperture over 65536 KB of RAM @ 20000000
Memory: 6117716k/6815744k available (3336k kernel code, 525124k absent, 172016k reserved, 1443k data, 396k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:384
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 3210.664 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
hpet clockevent registered
HPET: 4 timers in total, 1 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 6421.32 BogoMIPS (lpj=3210660)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
tseg: 0000000000
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 6 MCE banks
using C1E aware idle routine
Performance Counters: AMD PMU driver.
... version:                 0
... bit width:               48
... generic counters:        4
... value mask:              0000ffffffffffff
... max period:              00007fffffffffff
... fixed-purpose counters:  0
... counter mask:            000000000000000f
Freeing SMP alternatives: 28k freed
ACPI: Core revision 20090521
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6421.91 BogoMIPS (lpj=3210958)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
mce: CPU supports 6 MCE banks
CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
System has AMD C1E enabled
Switch to broadcast mode on CPU1
Booting processor 2 APIC 0x2 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 6421.91 BogoMIPS (lpj=3210955)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
mce: CPU supports 6 MCE banks
CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Switch to broadcast mode on CPU2
Booting processor 3 APIC 0x3 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 6421.89 BogoMIPS (lpj=3210948)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
mce: CPU supports 6 MCE banks
CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (25687.04 BogoMIPS).
Switch to broadcast mode on CPU3
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
Switch to broadcast mode on CPU0
NET: Registered protocol family 16
node 0 link 0: io port [1000, ffffff]
TOM: 00000000e0000000 aka 3584M
Fam 10h mmconf [e0000000, efffffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, efffffff] ==> none
node 0 link 0: mmio [f0000000, fbcfffff]
node 0 link 0: mmio [fbd00000, fbefffff]
node 0 link 0: mmio [fbf00000, ffefffff]
TOM2: 00000001a0000000 aka 6656M
bus: [00,07] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [f0000000, ffffffff]
bus: 00 index 3 mmio: [1a0000000, fcffffffff]
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
mtrr: your CPUs had inconsistent fixed MTRR settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI Warning: Incorrect checksum in table [OEMB] - AA, should be A2 20090521 tbutils-246
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
pci 0000:00:11.0: reg 24 32bit mmio: [0xfbcffc00-0xfbcfffff]
pci 0000:00:11.0: set SATA to AHCI mode
pci 0000:00:12.0: reg 10 32bit mmio: [0xfbcfd000-0xfbcfdfff]
pci 0000:00:12.1: reg 10 32bit mmio: [0xfbcfe000-0xfbcfefff]
pci 0000:00:12.2: reg 10 32bit mmio: [0xfbcff800-0xfbcff8ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10 32bit mmio: [0xfbcfb000-0xfbcfbfff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xfbcfc000-0xfbcfcfff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xfbcff400-0xfbcff4ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
pci 0000:00:14.5: reg 10 32bit mmio: [0xfbcfa000-0xfbcfafff]
pci 0000:01:05.0: reg 10 32bit mmio: [0xf0000000-0xf7ffffff]
pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
pci 0000:01:05.0: reg 18 32bit mmio: [0xfbee0000-0xfbeeffff]
pci 0000:01:05.0: reg 24 32bit mmio: [0xfbd00000-0xfbdfffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.1: reg 10 32bit mmio: [0xfbefc000-0xfbefffff]
pci 0000:01:05.1: supports D1 D2
pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfbd00000-0xfbefffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
pci 0000:02:05.0: reg 10 io port: [0xe800-0xe8ff]
pci 0000:02:05.0: reg 14 32bit mmio: [0xfbfffc00-0xfbfffcff]
pci 0000:02:05.0: reg 30 32bit mmio: [0xfbfc0000-0xfbfdffff]
pci 0000:02:05.0: supports D1 D2
pci 0000:02:05.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:02:05.0: PME# disabled
pci 0000:00:14.4: transparent bridge
pci 0000:00:14.4: bridge io port: [0xe000-0xefff]
pci 0000:00:14.4: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *4 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI-DMA: Disabling AGP.
PCI-DMA: aperture base @ 20000000 size 65536 KB
PCI-DMA: using GART IOMMU.
PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
hpet: hpet2 irq 24 for MSI
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:07: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x40b-0x40b has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0xc00-0xc01 has been reserved
system 00:08: ioport range 0xc14-0xc14 has been reserved
system 00:08: ioport range 0xc50-0xc51 has been reserved
system 00:08: ioport range 0xc52-0xc52 has been reserved
system 00:08: ioport range 0xc6c-0xc6c has been reserved
system 00:08: ioport range 0xc6f-0xc6f has been reserved
system 00:08: ioport range 0xcd0-0xcd1 has been reserved
system 00:08: ioport range 0xcd2-0xcd3 has been reserved
system 00:08: ioport range 0xcd4-0xcd5 has been reserved
system 00:08: ioport range 0xcd6-0xcd7 has been reserved
system 00:08: ioport range 0xcd8-0xcdf has been reserved
system 00:08: ioport range 0xb00-0xb3f has been reserved
system 00:08: ioport range 0x800-0x89f has been reserved
system 00:08: ioport range 0xb00-0xb0f has been reserved
system 00:08: ioport range 0xb20-0xb3f has been reserved
system 00:08: ioport range 0x900-0x90f has been reserved
system 00:08: ioport range 0x910-0x91f has been reserved
system 00:08: ioport range 0xfe00-0xfefe has been reserved
system 00:08: iomem range 0xffb80000-0xffbfffff has been reserved
system 00:08: iomem range 0xfec10000-0xfec1001f has been reserved
system 00:0a: ioport range 0x230-0x23f has been reserved
system 00:0a: ioport range 0x290-0x29f has been reserved
system 00:0a: ioport range 0xf40-0xf4f has been reserved
system 00:0a: ioport range 0xa30-0xa3f has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xcffff has been reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0xdfffffff could not be reserved
system 00:0c: iomem range 0xfec00000-0xffffffff could not be reserved
pci 0000:02:05.0: BAR 6: address space collision on of device [0xfbfc0000-0xfbfdffff]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0xfbd00000-0xfbefffff
pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:02
pci 0000:00:14.4:   IO window: 0xe000-0xefff
pci 0000:00:14.4:   MEM window: 0xfbf00000-0xfbffffff
pci 0000:00:14.4:   PREFETCH window: 0xf8000000-0xf80fffff
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
pci_bus 0000:01: resource 1 mem: [0xfbd00000-0xfbefffff]
pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf7ffffff]
pci_bus 0000:02: resource 0 io:  [0xe000-0xefff]
pci_bus 0000:02: resource 1 mem: [0xfbf00000-0xfbffffff]
pci_bus 0000:02: resource 2 pref mem [0xf8000000-0xf80fffff]
pci_bus 0000:02: resource 3 io:  [0x00-0xffff]
pci_bus 0000:02: resource 4 mem: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
kvm: Nested Virtualization enabled
kvm: Nested Paging enabled
Btrfs loaded
msgmni has been set to 11950
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:05.0: Boot video device
vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90000080000, using 6144k, total 16384k
vesafb: mode is 1024x768x32, linelength=4096, pages=4
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
Console: switching to colour frame buffer device 96x64
fb0: VESA VGA frame buffer device
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button [PWRB]
processor LNXCPU:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
processor LNXCPU:01: registered as cooling_device1
processor LNXCPU:02: registered as cooling_device2
processor LNXCPU:03: registered as cooling_device3
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
pci 0000:01:05.0: setting latency timer to 64
[drm] Initialized radeon 1.31.0 20080528 for 0000:01:05.0 on minor 0
loop: module loaded
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 irq 22
ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_atiixp 0000:00:14.1: setting latency timer to 64
scsi4 : pata_atiixp
scsi5 : pata_atiixp
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
r8169 0000:02:05.0: no PCI Express capability
eth0: RTL8110s at 0xffffc9000004ac00, 00:08:54:36:f2:2f, XID 04000000 IRQ 20
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 0
ata5.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
ata5.00: configured for UDMA/66
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
ata2: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: OCZ-VERTEX, Beta, max UDMA/133
ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usbcore: registered new interface driver usblp
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.21.
usbcore: registered new interface driver snd-usb-audio
ALSA device list:
  No soundcards found.
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ctnetlink v0.93: registering with nfnetlink.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor processors (4 cpu cores) (version 2.20.00)
powernow-k8:    0 : pstate 0 (3200 MHz)
powernow-k8:    1 : pstate 1 (2500 MHz)
powernow-k8:    2 : pstate 2 (2100 MHz)
powernow-k8:    3 : pstate 3 (800 MHz)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: SAMSUNG HD103UJ, 1AA01118, max UDMA7
ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       Beta PQ: 0 ANSI: 5
 sda:
sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 2:0:0:0: [sdb] Attached SCSI disk
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
usb 3-1: new low speed USB device using ohci_hcd and address 2
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg2 type 5
 sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
usb 3-1: configuration #1 chosen from 1 choice
input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.0/input/input2
generic-usb 0003:046A:0021.0001: input: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.0-1/input0
input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.0/usb3/3-1/3-1:1.1/input/input3
generic-usb 0003:046A:0021.0002: input: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.0-1/input1
UDF-fs: No partition found (1)
device fsid 8d449d7307e104f3-e9a05c394b7bab5 devid 1 transid 37067 /dev/root
Btrfs detected SSD devices, enabling SSD mode
VFS: Mounted root (btrfs filesystem) readonly on device 0:11.
Freeing unused kernel memory: 396k freed
usb 3-2: new full speed USB device using ohci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/input/input4
generic-usb 0003:046D:C526.0003: input: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.0-2/input0
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.1/input/input5
generic-usb 0003:046D:C526.0004: input: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.0-2/input1
udev: starting version 145
udev: renamed network interface eth0 to eth1
usb 4-1: new full speed USB device using ohci_hcd and address 2
usb 4-1: configuration #1 chosen from 1 choice
input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input6
generic-usb 0003:0D8C:000C.0005: input: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
kjournald starting.  Commit interval 60 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
Adding 200804k swap on /dev/sda3.  Priority:-1 extents:1 across:200804k 
r8169: eth1: link up
[drm] Setting GART location based on new memory map
[drm] Loading RS780/RS880 CP Microcode
[drm] Loading RS780/RS880 PFP Microcode
[drm] Resetting GPU
[drm] writeback test succeeded in 1 usecs
X:1861 conflicting memory types f0000000-f8000000 uncached-minus<->write-combining
reserve_memtype failed 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus
X:1861 conflicting memory types f0000000-f8000000 uncached-minus<->write-combining
reserve_memtype failed 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus
X:1861 freeing invalid memtype f0000000-f8000000
X:1861 conflicting memory types f0000000-f8000000 uncached-minus<->write-combining
reserve_memtype failed 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus
X:1861 freeing invalid memtype f0000000-f8000000

--C7zPtVaVf+AK4Oqc--
