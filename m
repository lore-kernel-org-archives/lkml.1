Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZEJPKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZEJPKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbZEJPKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:10:32 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:52044 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZEJPKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:10:31 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sun, 10 May 2009 10:10:27 -0500
User-Agent: KMail/1.9.9
Cc: Michael Riepe <michael.riepe@googlemail.com>
References: <200903041828.49972.m.bueker@berlin.de> <4A06D8D2.4010505@googlemail.com> <200905101001.40455.lkml@morethan.org>
In-Reply-To: <200905101001.40455.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101010.29746.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 10 2009, Michael S. Zick wrote:
> On Sun May 10 2009, Michael Riepe wrote:
> > 
> > Michael Buesch wrote:
> > 
> > > I'm currently testing 2.6.29.1 without any additional patches but
> > > with the pci=nomsi boot option.
> > > 
> > > I didn't notice any hickups, yet. I'm running a stresstest on a GBit link for quite
> > > some time now. Earlier tests with older kernels and MSI burped earlier.
> > > 
> 
> I can confirm greater through-put and reduced cpu usage with pci=nomsi
> on different hardware.
> 
> Machine: Everex Cloudbook (ce1200v)
> HICS: Via CX700
> PCI-to-PCIe bridge, Via 1106:324B
> (only) Downstream device: HD Audio Controller, Via 1106:3288
> 
> Kernel: 2.6.30-rc5 (git repo)
> 
> No extensive benchmarking required here - you can hear the difference!
> 
> 00:13.1 PCI bridge [0604]: VIA Technologies, Inc. CX700/VX700 PCI to PCI Bridge [1106:324a]
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>         Latency: 0
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         I/O behind bridge: 00005000-00005fff
>         Memory behind bridge: d1100000-d11fffff
>         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                 PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 

Ooops - cut&paste error

00:13.0 PCI bridge [0604]: VIA Technologies, Inc. CX700/VX700 Host Bridge [1106:324b]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
        Latency: 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: d1000000-d10fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-

Mike
> 02:01.0 Audio device [0403]: VIA Technologies, Inc. VT1708/A [Azalia HDAC] (VIA High Definition Audio Controller) [1106:3288] (rev 10)
>         Subsystem: FIRST INTERNATIONAL Computer Inc Device [1509:2f07]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 32 bytes
>         Interrupt: pin A routed to IRQ 17
>         Region 0: Memory at d1000000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>                 Address: 0000000000000000  Data: 0000
>         Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                         ExtTag- RBE- FLReset-
>                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                         RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                         MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend+
>                 LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
>                         ClockPM- Suprise- LLActRep- BwNot-
>                 LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                 LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
>         Kernel driver in use: HDA Intel
> 
> Mike
> > > I will do more testing. If it turns out this is stable I will test the same kernel
> > > with Message Signaled Interrupts to see if that causes some breakage.
> > 
> > I've had this problem up to and including 2.6.29.2. Currently, I'm
> > trying 2.6.29.2 with pci=nomsi, and it's stable so far. With MSI
> > enabled, a single high-speed TCP transfer will stop after a few seconds,
> > but without MSI, I can run four simultaneous transfers to two different
> > hosts without a single hickup.
> > 
> > It seems to me that this particular chip really doesn't like MSI.
> > 
> > Kernel: 2.6.29.2 (x86_64)
> > Board: Intel D945GCLF2
> > BIOS version: LF94510J.86A.0099.2008.0731.0303
> > 
> > lspci -vv:
> > 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> > RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
> >         Subsystem: Intel Corporation Device 0001
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr- Stepping- SERR- FastB2B- DisINTx-
> >         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0, Cache Line Size: 64 bytes
> >         Interrupt: pin A routed to IRQ 16
> >         Region 0: I/O ports at 1000 [size=256]
> >         Region 2: Memory at 90100000 (64-bit, non-prefetchable) [size=4K]
> >         Region 4: Memory at 90000000 (64-bit, prefetchable) [size=64K]
> >         Expansion ROM at 90020000 [disabled] [size=128K]
> >         Capabilities: [40] Power Management version 3
> >                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
> > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> >         Capabilities: [50] MSI: Mask- 64bit+ Count=1/1 Enable-
> >                 Address: 0000000000000000  Data: 0000
> >         Capabilities: [70] Express (v1) Endpoint, MSI 01
> >                 DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s
> > <512ns, L1 <64us
> >                         ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> >                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
> > Unsupported-
> >                         RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> >                         MaxPayload 128 bytes, MaxReadReq 4096 bytes
> >                 DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+
> > TransPend-
> >                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
> > Latency L0 <512ns, L1 <64us
> >                         ClockPM+ Suprise- LLActRep- BwNot-
> >                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> > CommClk+
> >                         ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> >                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > DLActive- BWMgmt- ABWMgmt-
> >         Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
> >                 Vector table: BAR=4 offset=00000000
> >                 PBA: BAR=4 offset=00000800
> >         Capabilities: [d0] Vital Product Data <?>
> >         Kernel driver in use: r8169
> >         Kernel modules: r8169
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


