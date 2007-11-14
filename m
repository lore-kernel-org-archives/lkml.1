Return-Path: <linux-kernel-owner+w=401wt.eu-S1763418AbXKNUN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763418AbXKNUN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 15:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762087AbXKNUNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 15:13:08 -0500
Received: from [12.38.203.54] ([12.38.203.54]:9099 "EHLO empbedex1.empirix.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762195AbXKNUNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 15:13:01 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23.1 - sata_mv (7042) hang with large file operations
Date: Wed, 14 Nov 2007 15:12:59 -0500
Message-ID: <BD261180E6D35F4D9D32F3E44FD3D9010AAE886B@EMPBEDEX.empirix.com>
In-Reply-To: <473B3ED9.40707@rtr.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23.1 - sata_mv (7042) hang with large file operations
Thread-Index: Acgm7IWLiHygiMAxSUGYHmVy6dZ13QADRmgw
References: <BD261180E6D35F4D9D32F3E44FD3D901053E84BD@EMPBEDEX.empirix.com> <45ED682A.9040408@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010A7E1B45@EMPBEDEX.empirix.com> <4728A816.8020608@garzik.org> <BD261180E6D35F4D9D32F3E44FD3D9010AAE852F@EMPBEDEX.empirix.com> <473B36D7.8000205@rtr.ca> <BD261180E6D35F4D9D32F3E44FD3D9010AAE8585@EMPBEDEX.empirix.com> <473B3ED9.40707@rtr.ca>
From: "Morrison, Tom" <tmorrison@empirix.com>
To: "Mark Lord" <liml@rtr.ca>
Cc: "Jeff Garzik" <jeff@garzik.org>, <linux-ide@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 Nov 2007 20:13:00.0263 (UTC) FILETIME=[C10D8F70:01C826FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK:

	32-bit linux - Large Physical Memory / Large PTE
	(CONFIG_PTE_64BIT & CONFIG_PHYS_64BIT)
	4 Gig of DDR RAM

Here is the lspci -vv


-bash-2.05b# lspci -vv
00:00.0 Power PC: Unknown device 1957:0012 (rev 20)
        !!! Invalid class 0b20 for header type 01
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=11, sec-latency=0
        I/O behind bridge: 00000000-00000fff
        Memory behind bridge: ea900000-eeffffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [4c] #10 [0041]

01:00.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at eefe0000 (32-bit, non-prefetchable)
[size=128K]
        Bus: primary=01, secondary=02, subordinate=11, sec-latency=0
        I/O behind bridge: 07ffe000-07ffffff
        Memory behind bridge: ea900000-eeefffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0051]

02:01.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=02, secondary=03, subordinate=08, sec-latency=0
        Memory behind bridge: ec000000-eeefffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

02:02.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Bus: primary=02, secondary=09, subordinate=09, sec-latency=0
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

02:03.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=02, secondary=0a, subordinate=0b, sec-latency=0
        Memory behind bridge: eac00000-ebffffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

02:08.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=02, secondary=0c, subordinate=0c, sec-latency=0
        I/O behind bridge: 07fff000-07ffffff
        Memory behind bridge: eab00000-eabfffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

02:09.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=02, secondary=0d, subordinate=0f, sec-latency=0
        I/O behind bridge: 07ffe000-07ffefff
        Memory behind bridge: ea900000-eaafffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

02:0a.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Bus: primary=02, secondary=10, subordinate=10, sec-latency=0
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

02:0b.0 PCI bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Bus: primary=02, secondary=11, subordinate=11, sec-latency=0
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

03:00.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at eeee0000 (32-bit, non-prefetchable)
[size=128K]
        Bus: primary=03, secondary=04, subordinate=08, sec-latency=0
        Memory behind bridge: ec000000-eedfffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0051]

04:01.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Bus: primary=04, secondary=05, subordinate=05, sec-latency=0
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

04:02.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=04, secondary=06, subordinate=06, sec-latency=0
        Memory behind bridge: ec000000-eedfffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

04:03.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Bus: primary=04, secondary=07, subordinate=07, sec-latency=0
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

04:04.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Bus: primary=04, secondary=08, subordinate=08, sec-latency=0
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

06:00.0 Bridge: PLX Technology, Inc.: Unknown device 8532 (rev ba)
        Subsystem: PLX Technology, Inc.: Unknown device 8532
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 51
        Region 0: Memory at eede0000 (32-bit, non-prefetchable)
[size=128K]
        Region 2: Memory at ec000000 (32-bit, non-prefetchable)
[size=32M]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0001]

0a:00.0 PCI bridge: PLX Technology, Inc.: Unknown device 8111 (rev 21)
(prog-if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at ebff0000 (64-bit, prefetchable) [size=64K]
        Bus: primary=0a, secondary=0b, subordinate=0b, sec-latency=0
        Memory behind bridge: eac00000-ebefffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] #10 [0071]

0b:00.0 Class ff00: C-PORT Corp: Unknown device 0002 (rev 20)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 128
        Interrupt: pin A routed to IRQ 51
        Region 0: Memory at ebe00000 (32-bit, prefetchable) [size=1M]
        Region 1: Memory at ebd00000 (32-bit, prefetchable) [size=1M]
        Region 2: Memory at eb800000 (32-bit, prefetchable) [size=4M]
        Region 3: Memory at eb400000 (32-bit, prefetchable) [size=4M]
        Region 4: Memory at eb000000 (32-bit, prefetchable) [size=4M]
        Region 5: Memory at eac00000 (32-bit, prefetchable) [size=4M]

0c:00.0 SCSI storage controller: Galileo Technology Ltd.: Unknown device
7042 (rev 02)
        Subsystem: Galileo Technology Ltd.: Unknown device 11ab
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, cache line size 08
        Interrupt: pin A routed to IRQ 48
        Region 0: Memory at eab00000 (64-bit, non-prefetchable)
[size=1M]
        Region 2: I/O ports at 7ffff00 [size=256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [60] #10 [0011]

0d:00.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at eaae0000 (32-bit, non-prefetchable)
[size=128K]
        Bus: primary=0d, secondary=0e, subordinate=0f, sec-latency=0
        I/O behind bridge: 07ffe000-07ffefff
        Memory behind bridge: ea900000-ea9fffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0051]

0e:01.0 PCI bridge: PLX Technology, Inc.: Unknown device 8508 (rev aa)
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=0e, secondary=0f, subordinate=0f, sec-latency=0
        I/O behind bridge: 07ffe000-07ffefff
        Memory behind bridge: ea900000-ea9fffff
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [48] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] #10 [0161]

0f:00.0 Fibre Channel: QLogic Corp.: Unknown device 2432 (rev 02)
        Subsystem: QLogic Corp.: Unknown device 0137
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 50
        Region 0: I/O ports at 7ffef00 [size=256]
        Region 1: Memory at ea9fc000 (64-bit, non-prefetchable)
[size=16K]
        Expansion ROM at <unassigned> [disabled] [size=256K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [4c] #10 [0001]
        Capabilities: [64] Message Signalled Interrupts: 64bit+
Queue=0/4 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [74] Vital Product Data
        Capabilities: [7c] #11 [000f]

-bash-2.05b#


-----Original Message-----
From: Mark Lord [mailto:liml@rtr.ca] 
Sent: Wednesday, November 14, 2007 1:31 PM
To: Morrison, Tom
Cc: Jeff Garzik; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.1 - sata_mv (7042) hang with large file operations

Morrison, Tom wrote:
..
> ::: Can you give me exact details of how to set up and reproduce this?
> :::  -- Kernel version
> 
> 	Linux-2.6.23.1
> 
> 	NOTE: I am using ppc (arch/ppc instead of arch/powerpc)
..

Okay.  Is that 32-bit or 64-bit?  How much RAM ?

My PPC machine is not currently set up for Linux,
and has only PCIX (not PCIe) slots, so I'll try this
first on an x86-32 box with PCIe.

If it works for me there, then I may be able to try
a PCIX card in my PPC-32 box later.  The PCIX card
won't have a 7042 of course, so I'll use a 6081 instead.
Those earlier Marvell chips are supposed to be extremely similar.

> 
> :::  -- number/config/model of drives
> 
> 	2x250GIG Western Digital - 3 partitions (largest (/dev/sda3
> 	~200Gig - formatted to ext2).
> 
> 	7042 PEX on a MPC8548 Board
> 
> :::  -- exact command line sequence to cause the failure
> 
> 	NFS mount root file system (I am currently rebuild to take away
> 	the NFS file system dependency) - /dev/sda3 is drive in
> question...
> 
> 		a) mount /dev/sda3 /mnt/src 
> 		b) cp large_500Meg_file /mnt/src/.
> 
> ==========================================================
> ==========================================================
> NOTE: this does NOT fail on a 2.6.11 kernel version!!!!
> 	So I do NOT think it's a hardware problem!
> 
> 	It could be a PEX related problem with arch/ppc - I would
> 	expect under heavy pounding with smaller files it would
> 	fail as well - but it does NOT)
> ==========================================================
> ==========================================================
> 
> Anything else you need to know?
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

