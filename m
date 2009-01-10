Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZAJP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZAJP3Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZAJP3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:29:11 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:36819 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913AbZAJP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:29:10 -0500
Date: Sat, 10 Jan 2009 16:30:14 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: "Jesse F. Hughes" <jesse@phiwumbda.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Various problems with new AMD 64 HP Pavilion Desktop machine.
	(1/2)
Message-ID: <20090110153014.GA19704@electric-eye.fr.zoreil.com>
References: <87r63ci7nb.fsf@phiwumbda.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r63ci7nb.fsf@phiwumbda.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse F. Hughes <jesse@phiwumbda.org> :
[...]
> I seem to be having a whole slew of problems with my new (refurbished)
> computer and I'm bumfuzzled about how to solve them.  A poster on
> comp.os.linux.hardware suggested I post a message here.

Your message appears with an unusual Content-Type which make it a bit
unpleasant to read/answer. Please check it.

[...]
> * My r8168 driver (latest available from realtek site) acts flaky.

Which version ? 8.0.10 ?

> The ethernet card works for a while, but then just craps out,
> receiving and sending no packets at all.  This usually happens during
> a sizeable download.  Removing and reloading the driver fixes the
> problem for a short while.

Can you give the in-kernel r8169 driver a try ? The 2.6.28 r8169 driver
should build with your kernel.

[...]
> * My Hauppauge 1800 (?) tv card seems to be acting up.  Sometimes when
> I lspci -vvv, I see
> 
>   !!! Unknown header type 7f

Add a -x option and you will probably see that the PCI configuration
space contains nothing but "ff" (it's not good).

Can you experience with the -H option of lspci and see what it reports
when this happens ?

(dumb question: is this a linux-only box ?)

[...]
> I'm more than a wee bit clueless about all this.  I hope that someone
> can help me out here.  Is it a hardware issue?  Does it have something
> to do with ACPI, as the colh poster suggested?

It could be purely software r8169 and PCI problems.

[...]
> Here's the output of lspci -vvv:
[...]
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> 	Subsystem: Hewlett-Packard Company Device 2a6f
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 2298
> 	Region 0: I/O ports at e800 [size=256]
> 	Region 2: Memory at febff000 (64-bit, non-prefetchable) [size=4K]
> 	Region 4: Memory at f8ff0000 (64-bit, prefetchable) [size=64K]
> 	Expansion ROM at febc0000 [disabled] [size=128K]
> 	Capabilities: [40] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
> 		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
> 		Address: 00000000fee0f00c  Data: 41a1
> 	Capabilities: [70] Express (v1) Endpoint, MSI 01
> 		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
> 			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 512 bytes
> 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <64us
> 			ClockPM+ Suprise- LLActRep- BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
> 	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
> 		Vector table: BAR=4 offset=00000000
> 		PBA: BAR=4 offset=00000800
> 	Capabilities: [d0] Vital Product Data <?>
> 	Capabilities: [100] Advanced Error Reporting <?>
> 	Capabilities: [140] Virtual Channel <?>
> 	Capabilities: [160] Device Serial Number 81-68-10-ec-00-00-00-00
> 	Kernel driver in use: r8169
                              ^^^^^
> 	Kernel modules: r8169, r8168

You told you were using Realtek's r8168 module. Did you explicitely force
modprobe to blacklist the module that you did not mean to use ?

I am rather confused by the fact that the dmesg and the lspci look more
like Intel than "AMD 64" ones (see the Subject of your message).

Can you clarify ?

-- 
Ueimor
