Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbXD0WL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbXD0WL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbXD0WL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:11:57 -0400
Received: from smtp161.iad.emailsrvr.com ([207.97.245.161]:48682 "EHLO
	smtp161.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbXD0WLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:11:54 -0400
Message-ID: <46327503.9040902@gentoo.org>
Date: Fri, 27 Apr 2007 18:11:15 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, curio@free.fr
Subject: Re: sky2 regression in 2.6.21: Asus P5B-E Plus ethernet adapter no
 more supported
References: <46311882.2040005@free.fr> <20070426155050.7850bc16@freekitty>
In-Reply-To: <20070426155050.7850bc16@freekitty>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Hemminger wrote:
> But the same hardware dies horribly on Gigabyte GA-965P motherboards.
> Could you send me full lspci -vvx output. I'll re-enable it for Asus and add a block
> for the Gigabyte boards. (sigh)

This was also reported by another user at 
https://bugs.gentoo.org/show_bug.cgi?id=176219

The following hardware on an Asus P5B Deluxe board worked fine with 2.6.20:

sky2 v1.10 addr 0xfeafc000 irq 17 Yukon-EC Ultra (0xb4) rev 2

02:00.0 0200: 11ab:4364 (rev 12)
         Subsystem: 1148:4340
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort-
<MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 17
         Region 0: Memory at feafc000 (64-bit, non-prefetchable) [size=16K]
         Region 2: I/O ports at d800 [size=256]
         Expansion ROM at feac0000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [50] Vital Product Data
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0
Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [e0] Express Legacy Endpoint IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                 Device: Latency L0s unlimited, L1 unlimited
                 Device: AtnBtn- AtnInd- PwrInd-
                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, 
Port 0
                 Link: Latency L0s <256ns, L1 unlimited
                 Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
                 Link: Speed 2.5Gb/s, Width x1
00: ab 11 64 43 07 00 10 00 12 00 00 02 08 00 00 00
10: 04 c0 af fe 00 00 00 00 01 d8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 48 11 40 43
30: 00 00 ac fe 48 00 00 00 00 00 00 00 0a 01 00 00

I guess it may come as a side effect of your upcoming patch, but it 
would be nice if sky2 could printk() some basic info when it detects one 
of the controllers that it is going to ignore. Right now it is kind of 
mysterious why eth0 has disappeared in 2.6.21 for some users.

Thanks,
Daniel
