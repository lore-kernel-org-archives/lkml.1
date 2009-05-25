Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZEYVmC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZEYVmC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 17:42:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZEYVly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 17:41:54 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:52131 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZEYVlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 17:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=b3ElL3a9As0WX43kkJxfjwLR5m3yX5DbsaDWPhBuraqBFveCwSWQ3iGBj+aX/t3vGl
         1VtqLEdylFKs+BnNO7ICtUjfe/d++b9rupljBe1nco6LzhuPxuXvkoWkBdZowV5ljdkV
         NPU1CFrwGKBp+obLZLdUEmL1SbpNowq+/xQ30=
MIME-Version: 1.0
In-Reply-To: <1243147091.27293.3.camel@concordia>
References: <c384c5ea0905231358t4803fbc6gf54618b2839a448a@mail.gmail.com>
	 <c384c5ea0905231512u72894e34g17746548e640d4fe@mail.gmail.com>
	 <1243147091.27293.3.camel@concordia>
Date: Mon, 25 May 2009 23:41:47 +0200
Message-ID: <c384c5ea0905251441p26af3b8ak6b3009990a43e8b6@mail.gmail.com>
Subject: Re: mpc8315e-rdb: pci_enable_msi() fails (using today's 
	galak/powerpc.git tree)
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: michael@ellerman.id.au
Cc: Linux PPC <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 24, 2009 at 8:38 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On Sun, 2009-05-24 at 00:12 +0200, Leon Woestenberg wrote:
>> Hello,
>>
>> On Sat, May 23, 2009 at 10:58 PM, Leon Woestenberg
>> <leon.woestenberg@gmail.com> wrote:
>> > using this tree: git://git.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git
>> >
>> > pci_enable_msi() fails on my MPC8315E-RDB board with PCIe device in
>
> <snip good bug report>
>
> 'lspci -vvv' of the device in question is often useful too.
>
Good point. Here's the full list, the last device is my target:

0000:00:00.0 0b20: 1957:00b4 (rev 10)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 128, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 2: Memory at <unassigned> (64-bit, prefetchable)
	Region 4: Memory at <unassigned> (64-bit, non-prefetchable)
	Capabilities: [48] CompactPCI hot-swap <?>
	Capabilities: [80] Power Management version 3
		Flags: PMEClk+ DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0002:02:00.0 0000: 1957:00b4 (rev 10)
	!!! Invalid class 0000 for header type 01
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00000000-00000fff
	Memory behind bridge: c0000000-cfffffff
	Prefetchable memory behind bridge: 0000000000100000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [4c] Express (v1) Root Port (Slot-), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <2us,
L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [138] Virtual Channel <?>
	Capabilities: [3f8] Vendor Specific Information <?>

0002:03:00.0 ff00: 1172:0004 (rev 01)
	Subsystem: 1172:0004
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 25
	Region 0: Memory at c0000000 (32-bit, non-prefetchable) [size=32K]
	Capabilities: [50] MSI: Mask- 64bit+ Count=1/4 Enable+
		Address: 00000000e00007f8  Data: 0000
	Capabilities: [78] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Kernel driver in use: altpciesgdma



-- 
Leon
