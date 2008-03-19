Return-Path: <linux-kernel-owner+w=401wt.eu-S935848AbYCTAgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935848AbYCTAgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966010AbYCTAI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:08:58 -0400
Received: from host-71.mics.msu.su ([158.250.28.71]:53581 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965893AbYCTAIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:08:55 -0400
X-Greylist: delayed 1283 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 20:08:54 EDT
Date: Thu, 20 Mar 2008 02:47:39 +0300 (MSK)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: David Brownell <david-b@pacbell.net>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <200803171855.44552.david-b@pacbell.net>
Message-ID: <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl> <200803171855.44552.david-b@pacbell.net>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, again

Just in case - I do have an A7V8X-based PC in the office and have 
performed a simple experiment.

#1. Idle USB controller has no effect on PCI performance (I again
measured hda throughput).

#2. Default value for register 4Bh is 09h.

#3. I have detected no effect of changing [4Bh]=29h. Particularly, USB 
FLASH read speed is ~8MB/s and hda read speed is ~40MB/s regardless of 
[4Bh] content. During hda timing, "dd if=/dev/sda of=/dev/null bs=1024" 
was running in another window (/dev/sda being the USB stick).

My interpretation, is that bit5 at offset 4B may _not_ be an "EHCI sleep 
time select" like it is for VT6212. Am I missing something?

Here's lspci output for the reference:

# lspci -vv
00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host Bridge
        Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [80] AGP version 3.5
                Status: RQ=32 Iso- ArqSz=0 Cal=2 SBA+ ITACoh- GART64- HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
                Command: RQ=32 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8235 PCI Bridge (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Memory behind bridge: e6000000-e7dfffff
        Prefetchable memory behind bridge: e7f00000-efffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
...

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 4: I/O ports at d800 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at d400 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
        Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 17
        Region 4: I/O ports at d000 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32, Cache Line Size: 64 bytes
        Interrupt: pin D routed to IRQ 17
        Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+


DB> > I'm looking at a VIA datasheet which says the revision ID for the "VT6212 / 
DB> > VT6212L PCI USB2.0 Controller" is simply 0x60. The VT61212L I myself owned 
The same file here.

DB> > advertised a revision ID of 0x63 and Lev's VT6212L advertises 0x65.
Yes, it does. And UHCI part has rev.ID=0x62.

HTH
-L
