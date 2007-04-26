Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbXDZVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbXDZVxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbXDZVxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:53:53 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:57191 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbXDZVxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:53:52 -0400
Message-ID: <46311882.2040005@free.fr>
Date: Thu, 26 Apr 2007 23:24:18 +0200
From: Francois SIMOND <curio@free.fr>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: sky2 regression in 2.6.21: Asus P5B-E Plus ethernet adapter no more
 supported
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Lastest sky2 update between 2.6.21-rc7 and 2.6.21 final disables the support of the integrated ethernet adapter build on the Asus P5B-E Plus motherboard.

Code used is :

#ifdef broken
	/* This device causes data corruption problems that are not resolved */
	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4364) }, /* 88E8056 */
#endif

I use this hardware successfully daily for one month and without any sign of problem (no corruption, no timeout, no warning) with kernel 2.6.20, x86_64.
Defining "broken" in sky2.h make it work again in 2.6.21 (but i did not run extended tests).


lspci -vv output :

02:00.0 Ethernet controller: Marvell Technology Group Ltd. Unknown device 4364 (rev 12)
        Subsystem: ASUSTeK Computer Inc. Unknown device 81f8
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 314
        Region 0: Memory at fe7fc000 (64-bit, non-prefetchable) [size=16K]
        Region 2: I/O ports at a800 [size=256]
        Expansion ROM at fe7c0000 [disabled] [size=128K]
        Capabilities: [48] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
                Address: 00000000fee0300c  Data: 4199
        Capabilities: [e0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <256ns, L1 unlimited
                Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1

Thank you !
