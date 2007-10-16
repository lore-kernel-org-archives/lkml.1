Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbXJPOJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbXJPOJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbXJPOJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:09:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:29264 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554AbXJPOJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=SKxwqudbquIizGcSlt4T9xkbYx6MH6Hbm0xwUbVH0T8s1fTVj/jelhsStUsJMbjKyONmn7wL/PzGBVz4ZNHbnL+QnNrrvJUapiffvzY9+FxR2bxrGlbtglr2KdrlbXRwjsI9tnB6rU7hh9K9cF4Uxj40xmNiUuv8p6BqZLh6v6o=
Message-ID: <4714C66D.4010607@gmail.com>
Date: Tue, 16 Oct 2007 18:10:53 +0400
From: Konstantin Kalin <konstantin.kalin@gmail.com>
User-Agent: Thunderbird 1.5.0.5 (Windows/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NVIDIA Ethernet & invalid MAC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Recently we've got some computers with new motherboard having NVidia 
chipset. The motherboard has nforce12 & nforce13 Ethernet cards. I've 
noticed that MAC address is setup random each boot. I debugged the 
driver and found that these cards have right-byte order of MAC address 
but the driver is expecting incorrect byte-order for these models. I 
made hardcode the driver and MAC address became valid. Also I tried  to 
understand that difference in this revision of the chipset. But I 
couldn't find anything interesting. I'm ready continue the investigation 
to do correct changes in the driver but I need an advice.

P.S. It's simple to add DEV_HAS_CORRECT_MACADDR to pci_device_tlb for 
these types of Ethernet. But I think it's not right decision because it 
would break older revisions of these models.

[root@tfm ~]# lspci -vvv
.....
00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a1)
        Subsystem: ASUSTeK Computer Inc. Unknown device 816a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 201
        Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at c800 [size=8]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
........
