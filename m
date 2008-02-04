Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYBDVzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYBDVzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYBDVzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:55:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:48270 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbYBDVzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:55:20 -0500
Subject: Re: tg3 broken after "PCI: Fix bus resource assignment on 32 bits
	with 64b resources"
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080204151222.GB25790@localhost.sw.ru>
References: <20080204151222.GB25790@localhost.sw.ru>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 08:54:33 +1100
Message-Id: <1202162073.7079.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 18:12 +0300, Alexey Dobriyan wrote:
> Commit c40a22e0ce5eb400f27449e59e43d021bee58b8d aka
> "PCI: Fix bus resource assignment on 32 bits with 64b resources"
> renders one tg3-equipped box networkless here.
> 
> 	tg3.c:v3.87 (December 20, 2007)
> 	tg3: (0000:02:05.0) phy probe failed, err -19
> 	tg3: Problem fetching invariants of chip, aborting.
> 	tg3: (0000:02:05.1) phy probe failed, err -19
> 	tg3: Problem fetching invariants of chip, aborting.
> 
> It's 32-bit CONFIG_RESOURCES_64BIT=y box.
> 
> Not sure what you need this, but below is some lspci -vvvxxx output:

Interesting. It looks like the BAR of the tg3 has a spurrious 0x100000000
bit set to it. Can you send me a full dmesg, if possible enabling DEBUG
in the pci code (there's some places to turn DEBUG on in drivers/pci/*)

Ben.

> 00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64
> 	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
> 	I/O behind bridge: 0000a000-0000bfff
> 	Memory behind bridge: 80000000-817fffff
> 	Prefetchable memory behind bridge: 81800000-818fffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
> 	Capabilities: [c0] HyperTransport: Slave or Primary Interface
> 		!!! Possibly incomplete decoding
> 		Command: BaseUnitID=6 UnitCnt=4 MastHost- DefDir-
> 		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config 0: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
> 		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> 		Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
> 		Revision ID: 1.02
> 	Capabilities: [f0] HyperTransport: Interrupt Discovery and Configuration
> 00: 22 10 60 74 17 01 30 02 07 00 04 06 00 40 01 00
> 10: 00 00 00 00 00 00 00 00 00 03 03 40 a0 b0 00 02
> 20: 00 80 70 81 80 81 80 81 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 ff 00 0b 00
> 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 04 06 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 08 f0 86 00 20 00 00 00 d0 00 00 00 22 00 01 00
> d0: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 0d 00 0f 00 0d 00 11 00 13 00 17 00 00 00 00 00
> f0: 08 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
> 	Subsystem: Super Micro Computer Inc Unknown device 0811
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 6b 74 00 00 80 02 05 00 80 06 00 40 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 11 08
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 80 b1 09 bc 00 00 00 00 20 04 50 00 00 00 00 03
> 50: 01 00 00 00 0f 00 00 00 01 50 00 00 00 00 00 00
> 60: 00 00 80 06 13 00 00 00 00 00 00 00 00 00 00 00
> 70: 06 29 4b 55 0c 00 00 00 00 00 00 00 d9 15 11 08
> 80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 31 57 46 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 13) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Latency: 64
> 	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
> 	I/O behind bridge: 00009000-00009fff
> 	Memory behind bridge: 81900000-819fffff
> 	Prefetchable memory behind bridge: 0000000181a00000-0000000181afffff
> 	Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity+ SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 	Capabilities: [a0] PCI-X bridge device
> 		Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD- Freq=100MHz
> 		Status: Dev=00:0a.0 64bit+ 133MHz+ SCD- USC- SCO- SRD-
> 		Upstream: Capacity=14 CommitmentLimit=65535
> 		Downstream: Capacity=2 CommitmentLimit=65535
> 	Capabilities: [b8] HyperTransport: Interrupt Discovery and Configuration
> 	Capabilities: [c0] HyperTransport: Slave or Primary Interface
> 		!!! Possibly incomplete decoding
> 		Command: BaseUnitID=10 UnitCnt=2 MastHost- DefDir-
> 		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config 0: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Link Control 1: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config 1: MLWI=8bit MLWO=8bit LWI=8bit LWO=8bit
> 		Revision ID: 1.02
> 00: 22 10 50 74 17 01 30 02 13 00 04 06 00 40 81 00
> 10: 00 00 00 00 00 00 00 00 00 02 02 40 91 91 20 22
> 20: 90 81 90 81 a1 81 a1 81 01 00 00 00 01 00 00 00
> 30: 00 00 00 00 a0 00 00 00 00 00 00 00 ff 00 05 00
> 40: 05 00 1f 00 00 00 00 00 02 0c 00 00 01 2c 00 00
> 50: 00 00 03 00 00 00 04 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 07 b8 83 00 50 00 03 00 0e 00 ff ff 02 00 ff ff
> b0: 00 00 00 00 00 00 00 00 08 c0 00 80 00 00 00 03
> c0: 08 00 4a 00 20 00 11 11 20 00 00 00 22 04 35 00
> d0: 02 00 35 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 08 08 0f 00 08 08 0d 00 0f 0f 14 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
> 	Capabilities: [a0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 	Capabilities: [c0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
> 40: 01 01 05 00 04 04 01 00 01 01 01 00 01 01 01 00
> 50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
> 60: 10 00 01 00 e4 02 00 00 00 c0 00 0f 1c 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 08 a0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
> 90: 13 56 13 04 00 00 00 00 03 00 00 00 00 00 00 00
> a0: 08 c0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
> b0: 13 56 13 04 00 00 00 00 03 00 00 00 00 00 00 00
> c0: 08 00 01 21 20 00 11 11 22 04 75 80 02 00 00 00
> d0: 56 04 51 02 00 00 ff 00 07 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 03 00 00 00 00 00 7f 00 03 00 00 01 01 00 7f 01
> 50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
> 60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
> 70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
> 80: 03 90 fc 00 80 ff ff 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 03 0a 00 00 20 0b 00 00 03 00 80 00 20 ff ff 00
> c0: 13 10 00 00 20 f0 ff 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 03 02 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 fe e0 07 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 50 00 00 00 00 00 00 00 42 35 82 13 21 0b 10 00
> 90: 00 8c 23 08 08 0a 7b 0a 00 00 00 00 06 08 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: e5 d0 84 36 2e 00 00 00 4e 97 30 03 73 f0 e8 41
> c0: 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 85 ad 43 02 58 42 21 e4 92 2d 20 55 64 34 61 20
> e0: f7 94 06 36 ca 46 b7 66 e5 46 c7 9c cb 87 95 e4
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 03 11 00 00 00 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: ff 3b 00 00 40 00 50 00 00 00 00 00 00 00 00 00
> 50: f8 ff ff 7f 00 00 00 00 00 00 00 00 40 ba 7d 00
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 11 01 02 51 11 80 00 50 00 38 00 08 1b 22 00 00
> 80: 00 00 07 23 13 21 13 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 60 01 00 00 00 8c 0d 01 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 3f 00 00 e0 a5 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 07 07 e2 04 10 27 00 20 25 25 00 00
> e0: 00 00 00 00 20 0f 58 00 1b 01 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Capabilities: [80] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 	Capabilities: [a0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
> 		Revision ID: 1.02
> 	Capabilities: [c0] HyperTransport: Host or Secondary Interface
> 		!!! Possibly incomplete decoding
> 		Command: WarmRst+ DblEnd-
> 		Link Control: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0
> 		Link Config: MLWI=16bit MLWO=16bit LWI=N/C LWO=N/C
> 		Revision ID: 1.02
> 00: 22 10 00 11 00 00 10 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
> 40: 04 04 01 00 01 01 05 00 01 01 01 00 01 01 01 00
> 50: 01 01 01 00 01 01 01 00 01 01 01 00 01 01 01 00
> 60: 11 00 01 00 e4 00 00 00 00 c0 00 0f 10 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 08 a0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
> 90: 13 56 13 04 00 00 00 00 03 00 00 00 00 00 00 00
> a0: 08 c0 01 21 20 00 11 11 22 06 75 80 02 00 00 00
> b0: 13 56 13 04 00 00 00 00 03 00 00 00 00 00 00 00
> c0: 08 00 01 21 d0 00 11 77 22 00 75 80 02 00 00 00
> d0: 0a 90 03 03 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 01 11 00 00 00 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 03 00 00 00 00 00 7f 00 03 00 00 01 01 00 7f 01
> 50: 00 00 00 00 02 00 00 00 00 00 00 00 03 00 00 00
> 60: 00 00 00 00 04 00 00 00 00 00 00 00 05 00 00 00
> 70: 00 00 00 00 06 00 00 00 00 00 00 00 07 00 00 00
> 80: 03 90 fc 00 80 ff ff 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 03 0a 00 00 20 0b 00 00 03 00 80 00 20 ff ff 00
> c0: 13 10 00 00 20 f0 ff 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 03 02 00 ff 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 02 11 00 00 00 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: 00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 60: 00 00 00 00 00 00 00 00 00 fe e0 07 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 50 00 00 00 00 00 00 00 42 35 82 13 21 0b 10 00
> 90: 00 8c 23 08 08 0a 7b 0a 00 00 00 00 06 08 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 58 cc 3c 35 2e 00 00 00 51 9e 01 19 00 08 c2 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: ae ab f8 1a 11 88 d4 b7 a4 2e 25 5c 07 07 0e ec
> e0: b1 fb 58 f9 08 6c c3 fd 57 ab 93 9d b2 c7 93 c0
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
> 	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 00: 22 10 03 11 00 00 00 00 00 00 00 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 40: ff 3b 00 00 40 00 50 00 00 00 00 00 00 00 00 00
> 50: 00 00 00 00 00 00 00 00 00 00 00 00 80 cb 67 00
> 60: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 11 01 02 51 11 80 00 50 00 38 00 08 1b 22 00 00
> 80: 00 00 07 23 13 21 13 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 9a 10 00 00 80 0d 94 3f 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 2b 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 07 07 e2 04 10 27 00 20 25 25 00 00
> e0: 00 00 00 00 20 0b 59 00 1b 01 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 02:05.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
> 	Subsystem: Super Micro Computer Inc Unknown device 1648
> 	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin A routed to IRQ 26
> 	Region 0: Memory at 181900000 (64-bit, non-prefetchable) [size=64K]
> 	Capabilities: [40] PCI-X non-bridge device
> 		Command: DPERE- ERO- RBC=512 OST=1
> 		Status: Dev=02:05.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
> 	Capabilities: [48] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
> 		Address: efa5fbedafbd4770  Data: 2971
> 00: e4 14 48 16 02 01 b0 02 10 00 00 02 10 40 80 00
> 10: 04 00 90 81 01 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 48 16
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 40 00
> 40: 07 48 00 00 28 02 43 04 01 50 02 c0 00 20 00 64
> 50: 03 58 fc 80 00 00 00 78 05 00 86 00 70 47 bd af
> 60: ed fb a5 ef 71 29 00 00 9a 02 00 21 00 00 00 00
> 70: 82 32 00 00 a6 00 00 00 20 70 00 00 00 00 00 00
> 80: 00 00 00 00 72 cd a8 0a 00 00 01 00 fe 90 20 00
> 90: 01 07 00 01 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> 02:05.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 10)
> 	Subsystem: Super Micro Computer Inc Unknown device 1648
> 	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
> 	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
> 	Interrupt: pin B routed to IRQ 27
> 	Region 0: Memory at 181910000 (64-bit, non-prefetchable) [size=64K]
> 	Capabilities: [40] PCI-X non-bridge device
> 		Command: DPERE- ERO- RBC=512 OST=1
> 		Status: Dev=02:05.1 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=2048 DMOST=1 DMCRS=16 RSCEM- 266MHz- 533MHz-
> 	Capabilities: [48] Power Management version 2
> 		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> 	Capabilities: [50] Vital Product Data
> 	Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable-
> 		Address: 934fff7fffff39fc  Data: 59ff
> 00: e4 14 48 16 02 01 b0 02 10 00 00 02 10 40 80 00
> 10: 04 00 91 81 01 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 d9 15 48 16
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 09 02 40 00
> 40: 07 48 00 00 29 02 43 04 01 50 02 c0 00 20 00 64
> 50: 03 58 fc 80 00 00 00 78 05 00 86 00 fc 39 ff ff
> 60: 7f ff 4f 93 ff 59 00 00 9a 02 00 21 00 00 00 00
> 70: 02 32 00 00 a6 00 00 00 50 00 00 00 00 00 00 00
> 80: 03 58 fc 80 2f 14 b3 78 00 00 00 00 fe 90 60 00
> 90: 01 07 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

