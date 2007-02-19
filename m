Return-Path: <linux-kernel-owner+w=401wt.eu-S1750696AbXBSHL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750696AbXBSHL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 02:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXBSHL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 02:11:57 -0500
Received: from dsl.static81213182239.ttnet.net.tr ([81.213.182.239]:18518 "EHLO
	bonsai.taydin.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750696AbXBSHL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 02:11:56 -0500
From: Timur Aydin <ta@taydin.org>
To: linux-kernel@vger.kernel.org
Subject: Re: PCMCIA WLAN card initialization error
References: <87bqjr401n.fsf@bonsai.taydin.org>
Date: Mon, 19 Feb 2007 09:11:53 +0200
In-Reply-To: <87bqjr401n.fsf@bonsai.taydin.org> (Timur Aydin's message of
	"Sun\, 18 Feb 2007 23\:40\:20 +0200")
Message-ID: <87mz3abozq.fsf@bonsai.taydin.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am resending this to the orinoco devel mailing list.

Today I have tried using a Linksys WPC11 WLAN card and another Senao
NL2511 Plus and I am seeing the same errors in the kernel log and
again, the network interface does not show up with iwconfig.

These two cards are known to be working under windows xp.

==== Linksys WPC11 ====
Feb 19 08:59:30 bonsai pccard: card ejected from slot 0
Feb 19 08:59:39 bonsai pccard: PCMCIA card inserted into slot 0
Feb 19 08:59:39 bonsai pcmcia: registering new device pcmcia0.0
Feb 19 08:59:39 bonsai pcmcia: request for exclusive IRQ could not be fulfilled.
Feb 19 08:59:39 bonsai pcmcia: the driver needs updating to supported shared IRQ lines.
Feb 19 08:59:39 bonsai eth2: failed to initialize firmware (err = -19)
Feb 19 08:59:39 bonsai orinoco_cs: register_netdev() failed
Feb 19 08:59:39 bonsai pcmcia: request for exclusive IRQ could not be fulfilled.
Feb 19 08:59:39 bonsai pcmcia: the driver needs updating to supported shared IRQ lines.
Feb 19 08:59:39 bonsai eth2: failed to initialize firmware (err = -19)
Feb 19 08:59:39 bonsai orinoco_cs: register_netdev() failed

==== SENAO NL2511 Plus ====
Feb 19 09:01:21 bonsai pccard: card ejected from slot 0
Feb 19 09:01:40 bonsai pccard: PCMCIA card inserted into slot 0
Feb 19 09:01:40 bonsai pcmcia: registering new device pcmcia0.0
Feb 19 09:01:40 bonsai pcmcia: request for exclusive IRQ could not be fulfilled.
Feb 19 09:01:40 bonsai pcmcia: the driver needs updating to supported shared IRQ lines.
Feb 19 09:01:40 bonsai eth2: failed to initialize firmware (err = -19)
Feb 19 09:01:40 bonsai orinoco_cs: register_netdev() failed
Feb 19 09:01:40 bonsai pcmcia: request for exclusive IRQ could not be fulfilled.
Feb 19 09:01:40 bonsai pcmcia: the driver needs updating to supported shared IRQ lines.
Feb 19 09:01:40 bonsai eth2: failed to initialize firmware (err = -19)
Feb 19 09:01:40 bonsai orinoco_cs: register_netdev() failed
Feb 19 09:01:56 bonsai pccard: card ejected from slot 0

Timur


Timur Aydin <ta@taydin.org> writes:

> Hi,
>
> I have a Prism based PCMCIA WLAN card, which I want to use in my
> workstation PC. I am using a Ricoh RL5c475 based PCMCIA/PCI bridge to
> attach the card to one of the empty PCI slots. I want to use this PC
> as a wireless access point (with hostap), but first I want to make
> sure the card works, so I first want to use the card as a client to an
> existing wireless access point. So I compiled support into the linux
> kernel for only the hermes chipset and the yenta driver (no hostap
> right now).
>
> The problem is that when iwconfig is issued, the wireless interface
> does not show up.
>
> I am seeing some error or warning messages in the kernel logs, but I
> am not sure if they are relevant to this. For example:
>
> ...
> orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
> orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
> pcmcia: request for exclusive IRQ could not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines.
> eth2: failed to initialize firmware (err = -19)
> orinoco_cs: register_netdev() failed
> pcmcia: request for exclusive IRQ could not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines.
> eth2: failed to initialize firmware (err = -19)
> orinoco_cs: register_netdev() failed
> ...
>
>
> I am also seeing resource allocation errors:
>
> PCI: Failed to allocate mem resource #10:2000000@f8000000 for 0000:02:08.0
> PCI: Bus 3, cardbus bridge: 0000:02:08.0
>   IO window: 00009000-000090ff
>   IO window: 00009400-000094ff
>   PREFETCH window: 50000000-51ffffff
> PCI: Bridge: 0000:00:0e.0
>   IO window: 9000-afff
>   MEM window: f5000000-f6ffffff
>   PREFETCH window: 50000000-52ffffff
>
> I am not sure, but I think the actual error is the (err = -19). I have
> added some extra printk's into hermes.c. This error originates from
> the hermes_init function in hermes.c:
>
> 	/* Normally it's a "can't happen" for the command register to
>            be busy when we go to issue a command because we are
>            serializing all commands.  However we want to have some
>            chance of resetting the card even if it gets into a stupid
>            state, so we actually wait to see if the command register
>            will unbusy itself here. */
> 	k = CMD_BUSY_TIMEOUT;
> 	reg = hermes_read_regn(hw, CMD);
> 	while (k && (reg & HERMES_CMD_BUSY)) {
> 		if (reg == 0xffff) /* Special case - the card has probably been removed,
> 				      so don't wait for the timeout */
> 			return -ENODEV;
>
> 		k--;
> 		udelay(1);
> 		reg = hermes_read_regn(hw, CMD);
> 	}
>
> reg is indeed 0xffff and the function returns -ENODEV.
>
> I need help to further troubleshoot the problem, any directions or
> hints welcome...
>
> Here is the system information:
>
> uname -a:
> Linux bonsai 2.6.19-gentoo-r5 #1 PREEMPT Sun Feb 18 22:04:07 EET 2007
> i686 AMD Athlon(tm) 64 Processor 3500+ AuthenticAMD GNU/Linux
>
> The grub.conf, /etc/pcmcia/config.opts, lspci, lspcmcia and dmesg
> output is attached.
> Socket 0 Bridge:   	[yenta_cardbus] 	(bus ID: 0000:02:08.0)
> 	Configuration:	state: on	ready: yes
> 			Voltage: 3.3V Vcc: 3.3V Vpp: 0.0V
> 			Available IRQs: none
> 			Available ioports:	0x00000100 - 0x0000028f
> 						0x00000298 - 0x000003af
> 						0x000003e0 - 0x000004cf
> 						0x000004d8 - 0x000004ff
> 						0x00000820 - 0x000008ff
> 						0x00000a00 - 0x00000aff
> 						0x00000c00 - 0x00000cf7
> 						0x00009000 - 0x0000afff
> 			Available iomem:	0x000c0000 - 0x000fffff
> 						0x60000000 - 0x60ffffff
> 						0xa0000000 - 0xa0ffffff
> 						0xf5000000 - 0xf5ffffff
> 						0xf6200000 - 0xf6ffffff
> Socket 0 Device 0:	[-- no driver --]	(bus ID: 0.0)
> 	Configuration:	state: on
> 	Product Name:   INTERSIL HFA384x/IEEE Version 01.02 
> 	Identification:	manf_id: 0x0156	card_id: 0x0002
> 			function: 6 (network)
> 			prod_id(1): "INTERSIL" (0x74c5e40d)
> 			prod_id(2): "HFA384x/IEEE" (0xdb472a18)
> 			prod_id(3): "Version 01.02" (0x4b74baa0)
> 			prod_id(4): --- (---)
> 00:00.0 Host bridge: nVidia Corporation nForce3 250Gb Host Bridge (rev a1)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
> 	Capabilities: [44] HyperTransport: Slave or Primary Interface
> 		Command: BaseUnitID=0 UnitCnt=14 MastHost- DefDir- DUL-
> 		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
> 		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
> 		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
> 		Revision ID: 1.03
> 		Link Frequency 0: 1.0GHz
> 		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
> 		Link Frequency 1: 200MHz
> 		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
> 		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> 		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
> 		Prefetchable memory behind bridge Upper: 00-00
> 		Bus Number: 00
> 	Capabilities: [c0] AGP version 2.0
> 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
> 		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x1
>
> 00:01.0 ISA bridge: nVidia Corporation nForce3 250Gb LPC Bridge (rev a2)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
>
> 00:01.1 SMBus: nVidia Corporation nForce 250Gb PCI System Management (rev a1)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin A routed to IRQ 10
> 	Region 0: I/O ports at cc00 [size=32]
> 	Region 4: I/O ports at 4c00 [size=64]
> 	Region 5: I/O ports at 4c40 [size=64]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:02.0 USB Controller: nVidia Corporation CK8S USB Controller (rev a1) (prog-if 10 [OHCI])
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: Memory at f7003000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:02.1 USB Controller: nVidia Corporation CK8S USB Controller (rev a1) (prog-if 10 [OHCI])
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin B routed to IRQ 21
> 	Region 0: Memory at f7004000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:02.2 USB Controller: nVidia Corporation nForce3 EHCI USB 2.0 Controller (rev a2) (prog-if 20 [EHCI])
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Interrupt: pin C routed to IRQ 19
> 	Region 0: Memory at f7005000 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [44] Debug port
> 	Capabilities: [80] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:05.0 Bridge: nVidia Corporation CK8S Ethernet Controller (rev a2)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (250ns min, 5000ns max)
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: Memory at f7000000 (32-bit, non-prefetchable) [size=4K]
> 	Region 1: I/O ports at b800 [size=8]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
>
> 00:06.0 Multimedia audio controller: nVidia Corporation nForce3 250Gb AC'97 Audio Controller (rev a1)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 7585
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (500ns min, 1250ns max)
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: I/O ports at bc00 [size=256]
> 	Region 1: I/O ports at c000 [size=128]
> 	Region 2: Memory at f7001000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:08.0 IDE interface: nVidia Corporation CK8S Parallel ATA Controller (v2.5) (rev a2) (prog-if 8a [Master SecP PriP])
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 0250
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0 (750ns min, 250ns max)
> 	Region 4: I/O ports at f000 [size=16]
> 	Capabilities: [44] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 00:0b.0 PCI bridge: nVidia Corporation nForce3 250Gb AGP Host to PCI Bridge (rev a2) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 16
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=10
> 	I/O behind bridge: 0000f000-00000fff
> 	Memory behind bridge: f0000000-f2ffffff
> 	Prefetchable memory behind bridge: f3000000-f4ffffff
> 	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
>
> 00:0e.0 PCI bridge: nVidia Corporation nForce3 250Gb PCI-to-PCI Bridge (rev a2) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 0
> 	Bus: primary=00, secondary=02, subordinate=06, sec-latency=128
> 	I/O behind bridge: 00009000-0000afff
> 	Memory behind bridge: f5000000-f6ffffff
> 	Prefetchable memory behind bridge: 50000000-52ffffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
>
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Capabilities: [80] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
>
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>
> 01:00.0 VGA compatible controller: Matrox Graphics, Inc. MGA G550 AGP (rev 01) (prog-if 00 [VGA])
> 	Subsystem: Matrox Graphics, Inc. Millennium G550 Dual Head DDR 32Mb
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (4000ns min, 8000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at <ignored> (32-bit, prefetchable)
> 	Region 1: Memory at f0000000 (32-bit, non-prefetchable) [size=16K]
> 	Region 2: Memory at f1000000 (32-bit, non-prefetchable) [size=8M]
> 	[virtual] Expansion ROM at f3000000 [disabled] [size=128K]
> 	Capabilities: [dc] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [f0] AGP version 2.0
> 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
> 		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x1
>
> 02:08.0 CardBus bridge: Ricoh Co Ltd RL5c475 (rev 81)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 168
> 	Interrupt: pin A routed to IRQ 16
> 	Region 0: Memory at f6005000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
> 	Memory window 0: 50000000-51fff000 (prefetchable)
> 	Memory window 1: f6002000-f6003000
> 	I/O window 0: 00009000-000090ff
> 	I/O window 1: 00009400-000094ff
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
> 	16-bit legacy interface ports at 0001
>
> 02:0d.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)
> 	Subsystem: Micro-Star International Co., Ltd. Unknown device 025c
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 32 (8000ns min, 16000ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: I/O ports at a000 [size=256]
> 	Region 1: Memory at f6004000 (32-bit, non-prefetchable) [size=256]
> 	[virtual] Expansion ROM at 52000000 [disabled] [size=128K]
> 	Capabilities: [dc] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> us_irq 14 global_irq 14 high edge)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> ACPI: IRQ9 used by override.
> ACPI: IRQ14 used by override.
> ACPI: IRQ15 used by override.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
> Detected 2210.778 MHz processor.
> Built 1 zonelists.  Total pages: 260081
> Kernel command line: root=/dev/hda3 pci=assign-busses
> mapped APIC to ffffd000 (fee00000)
> mapped IOAPIC to ffffc000 (fec00000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 1034304k/1048512k available (2876k kernel code, 13568k reserved, 1189k data, 184k init, 131008k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc04fc000 - 0xc052a000   ( 184 kB)
>       .data : 0xc03cf034 - 0xc04f846c   (1189 kB)
>       .text : 0xc0100000 - 0xc03cf034   (2876 kB)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Calibrating delay using timer specific routine.. 4423.52 BogoMIPS (lpj=22117605)
> Mount-cache hash table entries: 512
> CPU: After generic identify, caps: 078bfbff e3d3fbff 00000000 00000000 00000000 00000000 00000000
> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
> CPU: L2 Cache: 512K (64 bytes/line)
> CPU: After all inits, caps: 078bfbff e3d3fbff 00000000 00000410 00000000 00000000 00000000
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> Compat vDSO mapped to ffffe000.
> CPU: AMD Athlon(tm) 64 Processor 3500+ stepping 00
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20060707
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfbe50, last bus=3
> PCI: Using configuration type 1
> Setting up standard PCI resources
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> Boot video device is 0000:01:00.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
> ACPI: Power Resource [ISAV] (on)
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
> ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNK3] (IRQs *3 4 5 6 7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 6 *7 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
> ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
> ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
> ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
> ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
> ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
> ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 10 devices
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> PCI: Cannot allocate resource region 0 of device 0000:01:00.0
> pnp: 00:00: ioport range 0x4000-0x407f could not be reserved
> pnp: 00:00: ioport range 0x4080-0x40ff has been reserved
> pnp: 00:00: ioport range 0x4400-0x447f has been reserved
> pnp: 00:00: ioport range 0x4480-0x44ff could not be reserved
> pnp: 00:00: ioport range 0x4800-0x487f has been reserved
> pnp: 00:00: ioport range 0x4880-0x48ff has been reserved
> PCI: Failed to allocate mem resource #0:2000000@f4000000 for 0000:01:00.0
> PCI: Bridge: 0000:00:0b.0
>   IO window: disabled.
>   MEM window: f0000000-f2ffffff
>   PREFETCH window: f3000000-f4ffffff
> PCI: Failed to allocate mem resource #10:2000000@f8000000 for 0000:02:08.0
> PCI: Bus 3, cardbus bridge: 0000:02:08.0
>   IO window: 00009000-000090ff
>   IO window: 00009400-000094ff
>   PREFETCH window: 50000000-51ffffff
> PCI: Bridge: 0000:00:0e.0
>   IO window: 9000-afff
>   MEM window: f5000000-f6ffffff
>   PREFETCH window: 50000000-52ffffff
> PCI: Setting latency timer of device 0000:00:0e.0 to 64
> ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
> ACPI: PCI Interrupt 0000:02:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 16
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 7, 524288 bytes)
> TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> Machine check exception polling timer started.
> highmem bounce pool size: 64 pages
> io scheduler noop registered
> io scheduler cfq registered (default)
> lp: driver loaded but no devices found
> Real Time Clock Driver v1.12ac
> Non-volatile memory driver v1.2
> Linux agpgart interface v0.101 (c) Dave Jones
> agpgart: Detected AGP bridge 0
> agpgart: Setting up Nforce3 AGP.
> agpgart: AGP aperture is 128M @ 0xe8000000
> [drm] Initialized drm 1.0.1 20051102
> ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
> ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC1] -> GSI 16 (level, low) -> IRQ 17
> matroxfb: Matrox G550 detected
> matroxfb: video RAM is not available in PCI address space, matroxfb disabled
> matroxfb: probe of 0000:01:00.0 failed with error -1
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
> loop: loaded (max 8 devices)
> e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.57.
> ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [APCH] -> GSI 23 (level, high) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:05.0 to 64
> eth0: forcedeth.c: subsystem: 01462:0250 bound to 0000:00:05.0
> r8169 Gigabit Ethernet driver 2.2LK loaded
> ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
> ACPI: PCI Interrupt 0000:02:0d.0[A] -> Link [APC5] -> GSI 16 (level, low) -> IRQ 17
> eth1: RTL8169s/8110s at 0xf881c000, 00:11:09:cb:83:6b, IRQ 17
> Linux video capture interface: v2.00
> saa7130/34: v4l2 driver version 0.2.14 loaded
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
> NFORCE3-250: chipset revision 162
> NFORCE3-250: not 100% native mode: will probe irqs later
> NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
> NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
>     ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
>     ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
> Probing IDE interface ide0...
> hda: SAMSUNG SP0802N, ATA DISK drive
> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> Probing IDE interface ide1...
> hdc: PHILIPS DVDR824DP, ATAPI CD/DVD-ROM drive
> ide1 at 0x170-0x177,0x376 on irq 15
> hda: max request size: 512KiB
> hda: 156368016 sectors (80060 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
> hda: cache flushes supported
>  hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
> hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 8192kB Cache, UDMA(33)
> Uniform CD-ROM driver Revision: 3.20
> Yenta: CardBus bridge found at 0000:02:08.0 [0000:0000]
> Yenta: ISA IRQ mask 0x0000, PCI irq 16
> Socket status: 30000810
> pcmcia: parent PCI bridge I/O window: 0x9000 - 0xafff
> cs: IO port probe 0x9000-0xafff: clean.
> pcmcia: parent PCI bridge Memory window: 0xf5000000 - 0xf6ffffff
> pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x52ffffff
> ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [APCL] -> GSI 22 (level, high) -> IRQ 19
> PCI: Setting latency timer of device 0000:00:02.2 to 64
> ehci_hcd 0000:00:02.2: EHCI Host Controller
> ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
> ehci_hcd 0000:00:02.2: debug port 1
> PCI: cache line size of 64 is not supported by device 0000:00:02.2
> ehci_hcd 0000:00:02.2: irq 19, io mem 0xf7005000
> ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 8 ports detected
> ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
> ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
> ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, high) -> IRQ 20
> PCI: Setting latency timer of device 0000:00:02.0 to 64
> ohci_hcd 0000:00:02.0: OHCI Host Controller
> ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
> ohci_hcd 0000:00:02.0: irq 20, io mem 0xf7003000
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 4 ports detected
> ACPI: PCI Interrupt Link [APCG] enabled at IRQ 20
> ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCG] -> GSI 20 (level, high) -> IRQ 21
> PCI: Setting latency timer of device 0000:00:02.1 to 64
> ohci_hcd 0000:00:02.1: OHCI Host Controller
> ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
> ohci_hcd 0000:00:02.1: irq 21, io mem 0xf7004000
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 4 ports detected
> USB Universal Host Controller Interface driver v3.0
> Initializing USB Mass Storage driver...
> pccard: PCMCIA card inserted into slot 0
> cs: memory probe 0xf5000000-0xf6ffffff: excluding 0xf6000000-0xf61fffff
> pcmcia: registering new device pcmcia0.0
> usb 2-1: new low speed USB device using ohci_hcd and address 2
> usb 2-1: configuration #1 chosen from 1 choice
> usb 2-2: new low speed USB device using ohci_hcd and address 3
> usb 2-2: configuration #1 chosen from 1 choice
> usbcore: registered new interface driver usb-storage
> USB Mass Storage support registered.
> input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input0
> input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.0-1
> input: DELL DELL USB Keyboard as /class/input/input1
> input: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.0-2
> usbcore: registered new interface driver usbhid
> drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> i2c /dev entries driver
> Advanced Linux Sound Architecture Driver Version 1.0.13 (Tue Nov 28 14:07:24 2006 UTC).
> ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 23
> ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [APCJ] -> GSI 23 (level, high) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:06.0 to 64
> intel8x0_measure_ac97_clock: measured 60001 usecs
> intel8x0: clocking to 55385
> ALSA device list:
>   #0: NVidia CK8S with ALC850 at 0xf7001000, irq 18
> ip_conntrack version 2.4 (8191 buckets, 65528 max) - 176 bytes per conntrack
> ip_tables: (C) 2000-2006 Netfilter Core Team
> TCP cubic registered
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> ieee80211: 802.11 data/management/control stack, git-1.1.13
> ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
> ieee80211_crypt: registered algorithm 'NULL'
> ieee80211_crypt: registered algorithm 'WEP'
> Using IPI Shortcut mode
> Time: tsc clocksource has been installed.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> Freeing unused kernel memory: 184k freed
> cs: IO port probe 0x100-0x3af: excluding 0x290-0x297
> cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
> cs: IO port probe 0x820-0x8ff: clean.
> cs: IO port probe 0xc00-0xcf7: clean.
> cs: IO port probe 0xa00-0xaff: clean.
> orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
> orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
> pcmcia: request for exclusive IRQ could not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines.
> eth2: failed to initialize firmware (err = -19)
> orinoco_cs: register_netdev() failed
> pcmcia: request for exclusive IRQ could not be fulfilled.
> pcmcia: the driver needs updating to supported shared IRQ lines.
> eth2: failed to initialize firmware (err = -19)
> orinoco_cs: register_netdev() failed
> EXT3 FS on hda3, internal journal
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
> EXT3 FS on hda2, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
> EXT3 FS on hda6, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> Adding 1052216k swap on /dev/hda5.  Priority:-1 extents:1 across:1052216k
> r8169: eth1: link down
> process `named' is using obsolete setsockopt SO_BSDCOMPAT
