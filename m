Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZEJNil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZEJNil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 09:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbZEJNic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 09:38:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:41499 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbZEJNia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 09:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:x-accept-language:mime-version:to
         :cc:subject:references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=NJ/iORNhSrZE/Yrc+CJPAER4pAocr7LHJCBWF7sTFpqta/k47rGe8NdGDERYTttqep
         QgCjnUF+hVMZHFuuSOpoxZHOMAhDKPRt4FeJmFUbK6ys1Xug5jjxxkpXSS95J2dEsgAm
         GGRPOizjNlvvaJWTUBj6k/86ZJ1/vkL+Eu2Gw=
Message-ID: <4A06D8D2.4010505@googlemail.com>
Date: Sun, 10 May 2009 15:38:26 +0200
From: Michael Riepe <michael.riepe@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: de-de, de, en-us, en
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Francois Romieu <romieu@fr.zoreil.com>, Rui Santos <rsantos@grupopie.com>,
       =?ISO-8859-15?Q?Michael_B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
References: <200903041828.49972.m.bueker@berlin.de> <20090322211159.GA23042@electric-eye.fr.zoreil.com> <49CA1822.6050902@grupopie.com> <200904041950.04324.mb@bu3sch.de>
In-Reply-To: <200904041950.04324.mb@bu3sch.de>
X-Enigmail-Version: 0.91.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michael Buesch wrote:

> I'm currently testing 2.6.29.1 without any additional patches but
> with the pci=nomsi boot option.
> 
> I didn't notice any hickups, yet. I'm running a stresstest on a GBit link for quite
> some time now. Earlier tests with older kernels and MSI burped earlier.
> 
> I will do more testing. If it turns out this is stable I will test the same kernel
> with Message Signaled Interrupts to see if that causes some breakage.

I've had this problem up to and including 2.6.29.2. Currently, I'm
trying 2.6.29.2 with pci=nomsi, and it's stable so far. With MSI
enabled, a single high-speed TCP transfer will stop after a few seconds,
but without MSI, I can run four simultaneous transfers to two different
hosts without a single hickup.

It seems to me that this particular chip really doesn't like MSI.

Kernel: 2.6.29.2 (x86_64)
Board: Intel D945GCLF2
BIOS version: LF94510J.86A.0099.2008.0731.0303

lspci -vv:
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
        Subsystem: Intel Corporation Device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 1000 [size=256]
        Region 2: Memory at 90100000 (64-bit, non-prefetchable) [size=4K]
        Region 4: Memory at 90000000 (64-bit, prefetchable) [size=64K]
        Expansion ROM at 90020000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] MSI: Mask- 64bit+ Count=1/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express (v1) Endpoint, MSI 01
                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM+ Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data <?>
        Kernel driver in use: r8169
        Kernel modules: r8169

-- 
Michael "Tired" Riepe <michael.riepe@googlemail.com>
X-Tired: Each morning I get up I die a little
