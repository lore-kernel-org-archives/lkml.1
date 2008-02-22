Return-Path: <linux-kernel-owner+w=401wt.eu-S934511AbYBVCGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934511AbYBVCGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 21:06:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbYBVCGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 21:06:20 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44809 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423AbYBVCGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 21:06:19 -0500
Date: Fri, 22 Feb 2008 02:06:15 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Gabriel C <nix.or.die@googlemail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Gabriel C <crazy@frugalware.org>
Subject: Re: modular intel-agp does not work on my box
In-Reply-To: <47BE222B.2080500@googlemail.com>
Message-ID: <alpine.DEB.0.82.0802220205410.3412@skynet.skynet.ie>
References: <47BE222B.2080500@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi,
> 
> When building agp* modular ( CONFIG_AGP=y/m and CONFIG_AGP_INTEL=m ) intel-agp does nothing on my box 
> ( Dell Precision WorkStation 530 MT ) chipset is not being detected.
> 
> Building both Y fixes that and agpgart works and also detects my chipset.

Have you got EDAC modules built as well? they might be taking ownership 
when they shouldn't..

Dave.

> 
> ..
> 
> Linux agpgart interface v0.102
> agpgart: Detected an Intel i860 Chipset.
> agpgart: AGP aperture is 256M @ 0xe0000000
> 
> ..
> 
> Also I've tested kernel 2.6.24.2 and 2.6.25-rc2 both with same result.
> 
> lspci -vvvxxx output :
> 
> 00:00.0 Host bridge: Intel Corporation 82860 860 (Wombat) Chipset Host Bridge (MCH) (rev 04)
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR+ INTx-
> 	Latency: 0
> 	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
> 	Capabilities: [a0] AGP version 2.0
> 		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
> 		Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW+ Rate=x4
> 	Kernel driver in use: agpgart-intel
> 	Kernel modules: i82860_edac
> 00: 86 80 31 25 06 01 90 a0 04 00 00 06 00 00 00 00
> 10: 08 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00
> 40: d4 d4 92 80 80 80 80 80 80 80 80 80 80 80 80 80
> 50: 05 6b 02 00 00 00 00 00 00 10 11 11 01 00 11 11
> 60: 10 00 20 08 28 10 28 10 28 10 28 10 28 10 28 10
> 70: 28 10 28 10 28 10 28 10 28 10 28 10 28 10 28 10
> 80: 00 00 00 00 00 00 00 00 0f 00 00 00 00 00 00 00
> 90: 0b 00 0b 00 61 01 01 08 55 19 00 00 81 0a 38 00
> a0: 02 00 20 00 17 02 00 1f 14 03 00 00 00 00 00 00
> b0: 80 00 00 00 00 00 00 00 00 00 04 27 20 10 8b 00
> c0: 44 c0 50 11 00 28 00 00 00 00 00 00 03 00 00 00
> d0: 02 28 00 0e 03 00 00 33 af 09 31 b5 01 00 0b 00
> e0: 00 00 6a 00 00 00 00 01 2a 25 2b 33 07 00 00 00
> f0: 00 00 01 00 74 f8 30 80 38 0f 00 00 00 00 00 00
> 
> 00:01.0 PCI bridge: Intel Corporation 82850 850 (Tehama) Chipset AGP Bridge (rev 04) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
> 	I/O behind bridge: 0000e000-0000efff
> 	Memory behind bridge: ff800000-ff9fffff
> 	Prefetchable memory behind bridge: d0000000-dfffffff
> 	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Kernel modules: shpchp
> 00: 86 80 32 25 07 01 a0 00 04 00 04 06 00 40 01 00
> 10: 00 00 00 00 00 00 00 00 00 01 01 40 e0 e0 a0 22
> 20: 80 ff 90 ff 00 d0 f0 df 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0e 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:02.0 PCI bridge: Intel Corporation 82860 860 (Wombat) Chipset AGP Bridge (rev 04) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64
> 	Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
> 	I/O behind bridge: 0000d000-0000dfff
> 	Memory behind bridge: ff500000-ff7fffff
> 	Prefetchable memory behind bridge: fff00000-000fffff
> 	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Kernel modules: shpchp
> 00: 86 80 33 25 07 01 a0 00 04 00 04 06 00 40 01 00
> 10: 00 00 00 00 00 00 00 00 00 02 03 00 d0 d0 a0 02
> 20: 50 ff 70 ff f0 ff 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 02 28 00 0e 23 14 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 04) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=00, secondary=04, subordinate=04, sec-latency=64
> 	I/O behind bridge: 0000c000-0000cfff
> 	Memory behind bridge: ff300000-ff4fffff
> 	Prefetchable memory behind bridge: fff00000-000fffff
> 	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Kernel modules: shpchp
> 00: 86 80 4e 24 07 01 80 00 04 00 04 06 00 00 01 00
> 10: 00 00 00 00 00 00 00 00 00 04 04 40 c0 c0 80 22
> 20: 30 ff 40 ff f0 ff 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 00
> 40: 00 28 20 20 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 06 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 92 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 10 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 01 00 02 00 03 00 c0 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801BA ISA Bridge (LPC) (rev 04)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Kernel modules: intel-rng, iTCO_wdt
> 00: 86 80 40 24 0f 00 80 02 04 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 01 08 00 00 10 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 81 08 00 00 10 00 00 00
> 60: 8b 89 80 8b 90 00 00 00 80 80 8b 84 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: df fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00
> c0: 00 00 00 00 04 08 00 00 00 00 00 00 01 00 00 00
> d0: 86 21 00 00 02 1f 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 c0 01 0c 04 14 33 22 11 00 00 00 67 45
> f0: 00 00 40 00 00 00 00 00 47 0f 00 00 00 00 00 02
> 
> 00:1f.1 IDE interface: Intel Corporation 82801BA IDE U100 Controller (rev 04) (prog-if 80 [Master])
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
> 	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
> 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
> 	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
> 	Region 4: I/O ports at ffa0 [size=16]
> 	Kernel driver in use: ata_piix
> 00: 86 80 4b 24 05 00 80 02 04 80 01 01 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: a1 ff 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 07 e3 03 e3 00 00 00 00 05 00 01 02 00 00 00 00
> 50: 00 00 00 00 50 10 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.2 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 04) (prog-if 00 [UHCI])
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin D routed to IRQ 17
> 	Region 4: I/O ports at ff80 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 00: 86 80 42 24 05 00 80 02 04 00 03 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 81 ff 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 04 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 27 00 00 03 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.3 SMBus: Intel Corporation 82801BA/BAM SMBus Controller (rev 04)
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin B routed to IRQ 19
> 	Region 4: I/O ports at bcd0 [size=16]
> 	Kernel driver in use: i801_smbus
> 	Kernel modules: i2c-i801
> 00: 86 80 43 24 01 00 80 02 04 00 05 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: d1 bc 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00
> 40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.4 USB Controller: Intel Corporation 82801BA/BAM USB Controller #1 (rev 04) (prog-if 00 [UHCI])
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin C routed to IRQ 18
> 	Region 4: I/O ports at ff60 [size=32]
> 	Kernel driver in use: uhci_hcd
> 	Kernel modules: uhci-hcd
> 00: 86 80 44 24 05 00 80 02 04 00 03 0c 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 61 ff 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 04 03 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 27 00 00 03 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 00:1f.5 Multimedia audio controller: Intel Corporation 82801BA/BAM AC'97 Audio Controller (rev 04)
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Interrupt: pin B routed to IRQ 19
> 	Region 0: I/O ports at b800 [size=256]
> 	Region 1: I/O ports at bc40 [size=64]
> 	Kernel driver in use: Intel ICH
> 	Kernel modules: snd-intel8x0
> 00: 86 80 45 24 05 00 80 02 04 00 01 04 00 00 00 00
> 10: 01 b8 00 00 41 bc 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 09 02 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 47 0f 00 00 00 00 00 00
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon R350 [Radeon 9800 Pro] (prog-if 00 [VGA controller])
> 	Subsystem: Hightech Information System Ltd. Unknown device 8500
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- Stepping+ SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 255 (2000ns min), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 20
> 	Region 0: Memory at d8000000 (32-bit, prefetchable) [size=128M]
> 	Region 1: I/O ports at ec00 [size=256]
> 	Region 2: Memory at ff8f0000 (32-bit, non-prefetchable) [size=64K]
> 	Expansion ROM at ff800000 [disabled] [size=128K]
> 	Capabilities: [58] AGP version 2.0
> 		Status: RQ=80 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
> 		Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW+ Rate=x4
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel modules: fglrx, radeonfb
> 00: 02 10 48 4e a7 01 b0 02 00 00 00 03 10 ff 80 00
> 10: 08 00 00 d8 01 ec 00 00 00 00 8f ff 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 87 17 00 85
> 30: 00 00 00 c1 58 00 00 00 00 00 00 00 0b 01 08 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 87 17 00 85
> 50: 01 00 02 06 00 00 00 00 02 50 20 00 17 02 00 4f
> 60: 14 03 00 1f 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 01:00.1 Display controller: ATI Technologies Inc Radeon R350 [Radeon 9800 Pro] (Secondary)
> 	Subsystem: Hightech Information System Ltd. Unknown device 8501
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (2000ns min), Cache Line Size: 64 bytes
> 	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
> 	Region 1: Memory at ff8e0000 (32-bit, non-prefetchable) [size=64K]
> 	Capabilities: [50] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 02 10 68 4e 87 00 b0 02 00 00 80 03 10 40 00 00
> 10: 08 00 00 d0 00 00 8e ff 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 87 17 01 85
> 30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 08 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 01 00 02 06 00 00 00 00 02 50 20 00 17 02 00 4f
> 60: 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 02:1f.0 PCI bridge: Intel Corporation 82806AA PCI64 Hub PCI Bridge (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Bus: primary=02, secondary=03, subordinate=03, sec-latency=64
> 	I/O behind bridge: 0000d000-0000dfff
> 	Memory behind bridge: ff600000-ff7fffff
	Prefetchable memory behind bridge: fff00000-000fffff
> 	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Kernel modules: shpchp
> 00: 86 80 60 13 07 01 20 00 03 00 04 06 00 00 01 00
> 10: 00 00 00 00 00 00 00 00 02 03 03 40 d0 d0 a0 02
> 20: 60 ff 70 ff f0 ff 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 80
40: 00 68 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 30 0f 00 00 00 00 00 00
> 
> 03:00.0 PIC: Intel Corporation 82806AA PCI64 Hub Advanced Programmable Interrupt Controller (rev 01) (prog-if 20 [IO(X)-APIC])
> 	Subsystem: Intel Corporation 82806AA PCI64 Hub APIC
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Region 0: Memory at ff6ff000 (32-bit, non-prefetchable) [disabled] [size=4K]
> 00: 86 80 61 11 00 00 00 00 01 20 00 08 00 00 80 00
> 10: 00 f0 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 61 11
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 03:0e.0 SCSI storage controller: Adaptec AIC-7892P U160/m (rev 02)
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 16
> 	BIST result: 00
> 	Region 0: I/O ports at dc00 [disabled] [size=256]
> 	Region 1: Memory at ff6fe000 (64-bit, non-prefetchable) [size=4K]
> 	Expansion ROM at ff700000 [disabled] [size=128K]
> 	Capabilities: [dc] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: aic7xxx
> 00: 05 90 8f 00 16 01 b0 02 02 00 00 01 10 40 00 80
> 10: 01 dc 00 00 04 e0 6f ff 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 70 ff dc 00 00 00 00 00 00 00 0b 01 28 19
> 40: 80 04 00 80 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 04:0b.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 78)
> 	Subsystem: Dell Unknown device 00d8
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (2500ns min, 2500ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 18
> 	Region 0: I/O ports at cc80 [size=128]
> 	Region 1: Memory at ff3ffc00 (32-bit, non-prefetchable) [size=128]
> 	Expansion ROM at ff300000 [disabled] [size=128K]
> 	Capabilities: [dc] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> 	Kernel driver in use: 3c59x
> 	Kernel modules: 3c59x
> 00: b7 10 00 92 17 01 10 02 78 00 00 02 10 40 00 00
> 10: 81 cc 00 00 00 fc 3f ff 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 28 10 d8 00
> 30: 00 00 40 ff dc 00 00 00 00 00 00 00 04 01 0a 0a
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 01 00 02 fe
> e0: 00 40 00 68 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 04:0f.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
> 	Subsystem: NEC Corporation Hama USB 2.0 CardBus
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (250ns min, 10500ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 17
> 	Region 0: Memory at ff3fe000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: ohci_hcd
> 	Kernel modules: ohci-hcd
> 00: 33 10 35 00 16 01 10 02 41 10 03 0c 10 40 80 00
> 10: 00 e0 3f ff 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 33 10 35 00
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 01 01 2a
> 40: 01 00 02 7e 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 05 33 30 c4 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 04:0f.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
> 	Subsystem: NEC Corporation Hama USB 2.0 CardBus
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (250ns min, 10500ns max), Cache Line Size: 64 bytes
> 	Interrupt: pin B routed to IRQ 20
> 	Region 0: Memory at ff3fd000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: ohci_hcd
> 	Kernel modules: ohci-hcd
> 00: 33 10 35 00 16 01 10 02 41 10 03 0c 10 40 00 00
> 10: 00 d0 3f ff 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 33 10 35 00
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0b 02 01 2a
> 40: 01 00 02 7e 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 04:0f.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])
> 	Subsystem: Unknown device 1838:1074
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
> 	Interrupt: pin C routed to IRQ 19
> 	Region 0: Memory at ff3ff800 (32-bit, non-prefetchable) [size=256]
> 	Capabilities: [40] Power Management version 2
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Kernel driver in use: ehci_hcd
> 	Kernel modules: ehci-hcd
> 00: 33 10 e0 00 16 01 10 02 02 20 03 0c 20 40 00 00
> 10: 00 f8 3f ff 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 38 18 74 10
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 09 03 10 22
> 40: 01 00 02 7e 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 20 20 3f 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 05 33 30 c4 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 
> Regards,
> 
> Gabriel
> 
> 
