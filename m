Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbYBJQmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbYBJQmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYBJQmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 11:42:11 -0500
Received: from lakepoint.domeneshop.no ([194.63.248.54]:46784 "EHLO
	lakepoint.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbYBJQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 11:42:09 -0500
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2008 11:42:09 EST
Message-ID: <47AF27D5.4000308@auby.no>
Date: Sun, 10 Feb 2008 17:35:33 +0100
From: Christian Auby <christian@auby.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Marvel based pcie gbit controller on nForce 630i mainboard
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently acquired an XFX nForce 630i based motherboard, and have been 
experiencing hard freezes from time to time that I originally had no 
idea why happened. With hard freeze I mean exactly that; no log messages 
that I know of (though there might be some I don't know of), picture and 
input frozen.

After a bit I tried the following 64-bit kernels and found the culprit:

2.6.18-6 (debian stable)
2.6.22-14 (ubuntu server)
2.6.24-2 (debian unstable)

All of them crash when transferring files over samba, a hard freeze 
requiring shutdown.

I added a PCI network card, and without changing anything else things 
now work fine. The faulting network card is detected as:

---
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E 
Gigabit Ethernet Controller (rev 14)
---

Or more detailed:

---
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E 
Gigabit Ethernet Controller (rev 14)
Subsystem: Marvell Technology Group Ltd. Unknown device 00ba
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
Latency: 0, Cache Line Size: 32 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at efbfc000 (64-bit, non-prefetchable) [size=16K]
Region 2: I/O ports at bf00 [size=256]
[virtual] Expansion ROM at efa00000 [disabled] [size=128K]
Capabilities: [48] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 PME-Enable- DSel=0 DScale=1 PME-
Capabilities: [50] Vital Product Data
Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
Address: 0000000000000000 Data: 0000
Capabilities: [e0] Express Legacy Endpoint IRQ 0
Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
Device: Latency L0s unlimited, L1 unlimited
Device: AtnBtn- AtnInd- PwrInd-
Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
Link: Latency L0s <256ns, L1 unlimited
Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
Link: Speed 2.5Gb/s, Width x1
---

Is this a simple case of unsupported new hardware (atm all devices are 
listed as unknown with lspci, IDs pending according to the lspci page), 
or is there something more sinister afoot? If any more information is 
required (I'm sure there is), I will do my best to provide it with my 
limited Linux knowledge.

Regards,

Christian

PS: Please CC me on reply.
