Return-Path: <linux-kernel-owner+w=401wt.eu-S1751304AbXBZPzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751304AbXBZPzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 10:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965256AbXBZPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 10:55:22 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:15762 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXBZPzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 10:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Q3K1LLCRNQxVtk+o/uGZSyK69uxcMHjuOvtYUVOrjW3iJdSt6jsRA8Pxu12VI3WYCOMjuw8YCVGlEXBOYZAM0A2ILThzIPo5k1tlCdIIUTfJJLQe1rpZSyD1xv58mqnhrTukB/dqdeIOKXSZFdu8bWah00azUDKG+O4VgQ5H+hU=
Message-ID: <671c20540702260755heb107e9v55af2f80f7e49c4@mail.gmail.com>
Date: Mon, 26 Feb 2007 10:55:13 -0500
From: "Tom Burns" <tom.i.burns@gmail.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Subject: Re: [r8169] Any success with RTL8110SC?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <671c20540702230841w640e59d5uf928bac0bbfa8baa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <671c20540702221117p3f5c16b3h52173c94d17f7eda@mail.gmail.com>
	 <20070222223122.GA28191@electric-eye.fr.zoreil.com>
	 <671c20540702230841w640e59d5uf928bac0bbfa8baa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Francois, list,

I've realized now that in reality, the r8169 driver (2.6.20-1
backported to 2.6.15-1, with the patch from Francois' first email
applied) is receiving data!  Just not transmitting any.  tcpdump shows
valid packets on the LAN, but ifconfig reports 0 packets transferred.

Hope this helps.

Cheers,
Tom

On 2/23/07, Tom Burns <tom.i.burns@gmail.com> wrote:
> Hi Francois,
>
>   Thanks for your reply.
>
> On 2/22/07, Francois Romieu <romieu@fr.zoreil.com> wrote:
> [...]
> > I do not have the answar that you expect but some information could help:
> > - which motherboard is it ?
> > - can you send a dmesg for 2.6.20.1 as well as a lspci -vvx from your
> >   computer ?
>
> The motherboard is the latest revision of the MB720F mini ITX:
> http://www.ibase-i.com.tw/mb720.htm
>
> I have attached my dmesg and lspci -vvx output at the bottom of the message.
>
> > > The r1000 driver seems to be able to send data on the wire for about a
> > > minute, receive packets back about 5% of the time, and after a minute
> > > stop working altogether, complaining that the "send buffer is full."
> >
> > If I read you correctly, this version of the driver is less broken than
> > the others, right ?
>
> Correct.  On this board none of the versions of r8169 I backported to
> 2.6.15-1 were able to successfully put any data on the wire.  The eth
> interface gets created, and the device does properly report the link
> status up/down (as shown at the bottom of the dmesg output below), but
> that's it afaik.  The r1000 driver sends a bit of data as I had
> elaborated in the original email.
>
> > If you are brave, you can try the patch below against 2.6.20-rc1:
> > http://www.fr.zoreil.com/people/francois/misc/20070221-2.6.21-rc1-r8169-test.patch
>
> Thanks for providing that - however I just tried it, and I get the
> same results as with module I backported from 2.6.20 (that is, device
> is recognized but no data is sent on the wire).
>
> ===== output from lspci -vvx =====
>
> 00:00.0 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Subsystem: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR-
>         Latency: 8
>         Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
>         Capabilities: [80] AGP version 3.5
>                 Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
> FW+ AGP3+ Rate=x4,x8
>                 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 59 02 06 00 30 22 00 00 00 06 00 08 80 00
> 10: 08 00 00 e8 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 59 02
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00
>
> 00:00.1 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
> 00: 06 11 59 12 06 00 00 02 00 00 00 06 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> 00:00.2 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
> 00: 06 11 59 22 06 00 00 02 00 00 00 06 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> 00:00.3 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
> 00: 06 11 59 32 06 00 00 02 00 00 00 06 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> 00:00.4 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
> 00: 06 11 59 42 06 00 00 02 00 00 00 06 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> 00:00.7 Host bridge: VIA Technologies, Inc. CN400/PM880 Host Bridge
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
> 00: 06 11 59 72 06 00 00 02 00 00 00 06 00 00 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 a0 00 00 00 00 00 00 00 00 00 00 00
>
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge (prog-if
> 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         Memory behind bridge: f4000000-f5ffffff
>         Prefetchable memory behind bridge: f0000000-f3ffffff
>         Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR+ <PERR+
>         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>         Capabilities: [70] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 98 b1 07 01 30 02 00 00 04 06 00 00 01 00
> 10: 00 00 00 00 00 00 00 00 00 01 01 00 f0 00 20 e2
> 20: 00 f4 f0 f5 00 f0 f0 f3 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 70 00 00 00 00 00 00 00 00 00 0a 00
>
> 00:0a.0 Ethernet controller: Realtek Semiconductor Co., Ltd. Unknown
> device 8167 (rev 10)
>         Subsystem: Realtek Semiconductor Co., Ltd. Unknown device 8167
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (8000ns min, 16000ns max), Cache Line Size 08
>         Interrupt: pin A routed to IRQ 10
>         Region 0: I/O ports at d000 [size=256]
>         Region 1: Memory at f6023000 (32-bit, non-prefetchable) [size=256]
>         [virtual] Expansion ROM at 10000000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
> 00: ec 10 67 81 07 00 b0 02 10 00 00 02 08 20 00 00
> 10: 01 d0 00 00 00 30 02 f6 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 ec 10 67 81
> 30: 00 00 00 00 dc 00 00 00 00 00 00 00 0a 01 20 40
>
> 00:0c.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
> Controller (rev 80) (prog-if 10 [OHCI])
>         Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (8000ns max), Cache Line Size 08
>         Interrupt: pin A routed to IRQ 10
>         Region 0: Memory at f6020000 (32-bit, non-prefetchable) [size=2K]
>         Region 1: I/O ports at e600 [size=128]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 44 30 07 00 10 02 80 10 00 0c 08 20 00 00
> 10: 00 00 02 f6 01 e6 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 44 30
> 30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 20
>
> 00:0f.0 IDE interface: VIA Technologies, Inc. VIA VT6420 SATA RAID
> Controller (rev 80) (prog-if 8f [Master SecP SecO PriP PriO])
>         Subsystem: VIA Technologies, Inc. VIA VT6420 SATA RAID Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32
>         Interrupt: pin B routed to IRQ 10
>         Region 0: I/O ports at ec00 [size=8]
>         Region 1: I/O ports at ed00 [size=4]
>         Region 2: I/O ports at ee00 [size=8]
>         Region 3: I/O ports at e400 [size=4]
>         Region 4: I/O ports at e500 [size=16]
>         Region 5: I/O ports at d400 [size=256]
>         Capabilities: [c0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 49 31 07 00 90 02 80 8f 01 01 00 20 80 00
> 10: 01 ec 00 00 01 ed 00 00 01 ee 00 00 01 e4 00 00
> 20: 01 e5 00 00 01 d4 00 00 00 00 00 00 06 11 49 31
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 0a 02 00 00
>
> 00:0f.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> (prog-if 8a [Master SecP PriP])
>         Subsystem: VIA Technologies, Inc.
> VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32
>         Interrupt: pin A routed to IRQ 5
>         Region 4: I/O ports at e700 [size=16]
>         Capabilities: [c0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 71 05 07 00 90 02 06 8a 01 01 00 20 00 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 01 e7 00 00 00 00 00 00 00 00 00 00 06 11 71 05
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 05 01 00 00
>
> 00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32, Cache Line Size 08
>         Interrupt: pin A routed to IRQ 5
>         Region 4: I/O ports at e800 [size=32]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 38 30 07 00 10 02 81 00 03 0c 08 20 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 01 e8 00 00 00 00 00 00 00 00 00 00 06 11 38 30
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 05 01 00 00
>
> 00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32, Cache Line Size 08
>         Interrupt: pin A routed to IRQ 5
>         Region 4: I/O ports at e900 [size=32]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 38 30 07 00 10 02 81 00 03 0c 08 20 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 01 e9 00 00 00 00 00 00 00 00 00 00 06 11 38 30
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 05 01 00 00
>
> 00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32, Cache Line Size 08
>         Interrupt: pin B routed to IRQ 10
>         Region 4: I/O ports at ea00 [size=32]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 38 30 07 00 10 02 81 00 03 0c 08 20 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 01 ea 00 00 00 00 00 00 00 00 00 00 06 11 38 30
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 02 00 00
>
> 00:10.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 81) (prog-if 00 [UHCI])
>         Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32, Cache Line Size 08
>         Interrupt: pin B routed to IRQ 10
>         Region 4: I/O ports at eb00 [size=32]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 38 30 07 00 10 02 81 00 03 0c 08 20 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 01 eb 00 00 00 00 00 00 00 00 00 00 06 11 38 30
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 0a 02 00 00
>
> 00:10.4 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 86)
> (prog-if 20 [EHCI])
>         Subsystem: VIA Technologies, Inc. USB 2.0
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32, Cache Line Size 08
>         Interrupt: pin C routed to IRQ 6
>         Region 0: Memory at f6021000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 04 31 17 00 10 02 86 20 03 0c 08 20 80 00
> 10: 00 10 02 f6 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 04 31
> 30: 00 00 00 00 80 00 00 00 00 00 00 00 06 03 00 00
>
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge
> [KT600/K8T800/K8T890 South]
>         Subsystem: VIA Technologies, Inc. DFI KT600-AL Motherboard
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping+ SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Capabilities: [c0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 27 32 87 00 10 02 00 00 01 06 00 00 80 00
> 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 27 32
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
>
> 00:11.5 Multimedia audio controller: VIA Technologies, Inc.
> VT8233/A/8235/8237 AC97 Audio Controller (rev 60)
>         Subsystem: Avance Logic Inc. Unknown device 4760
>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin C routed to IRQ 6
>         Region 0: I/O ports at d800 [size=256]
>         Capabilities: [c0] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 59 30 01 00 10 02 60 00 01 04 00 00 00 00
> 10: 01 d8 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 05 40 60 47
> 30: 00 00 00 00 c0 00 00 00 00 00 00 00 06 03 00 00
>
> 00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 78)
>         Subsystem: VIA Technologies, Inc. VT6102 [Rhine II] Embeded Ethernet
> Controller on VT8235
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (750ns min, 2000ns max), Cache Line Size 08
>         Interrupt: pin A routed to IRQ 5
>         Region 0: I/O ports at e000 [size=256]
>         Region 1: Memory at f6022000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 00: 06 11 65 30 07 00 10 02 78 00 00 02 08 20 00 00
> 10: 01 e0 00 00 00 20 02 f6 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 02 01
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 05 01 03 08
>
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. S3 Unichrome
> Pro VGA Adapter (rev 02) (prog-if 00 [VGA])
>         Subsystem: VIA Technologies, Inc. S3 Unichrome Pro VGA Adapter
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (500ns min)
>         Interrupt: pin A routed to IRQ 5
>         Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
>         Region 1: Memory at f4000000 (32-bit, non-prefetchable) [size=16M]
>         [virtual] Expansion ROM at f5000000 [disabled] [size=64K]
>         Capabilities: [60] Power Management version 2
>                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [70] AGP version 3.0
>                 Status: RQ=256 Iso- ArqSz=0 Cal=7 SBA+ ITACoh- GART64- HTrans-
> 64bit- FW- AGP3+ Rate=x4,x8
>                 Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP- GART64- 64bit- FW- Rate=<none>
> 00: 06 11 18 31 07 00 30 02 02 00 00 03 00 20 00 00
> 10: 08 00 00 f0 00 00 00 f4 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 18 31
> 30: 00 00 00 00 60 00 00 00 00 00 00 00 05 01 02 00
>
> ===== end lspci -vvx =====
>
> ===== output of dmesg with r8169.c module from 2.6.20 =====
>
> Linux version 2.6.15-1.2054_FC5
> (bhcompile@hs20-bc1-3.build.redhat.com) (gcc version 4.1.0 20060304
> (Red Hat 4.1.0-3)) #1 Tue Mar 14 15:48:33 EST 2006
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000000bdf0000 (usable)
>  BIOS-e820: 000000000bdf0000 - 000000000bdf3000 (ACPI NVS)
>  BIOS-e820: 000000000bdf3000 - 000000000be00000 (ACPI data)
>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> 0MB HIGHMEM available.
> 189MB LOWMEM available.
> Using x86 segment limits to approximate NX protection
> On node 0 totalpages: 48624
>   DMA zone: 4096 pages, LIFO batch:0
>   DMA32 zone: 0 pages, LIFO batch:0
>   Normal zone: 44528 pages, LIFO batch:7
>   HighMem zone: 0 pages, LIFO batch:0
> DMI 2.3 present.
> Allocating PCI resources starting at 10000000 (gap: 0be00000:f2e00000)
> Built 1 zonelists
> Kernel command line: ro root=/dev/sda1 vga=785 noapic acpi=off
> No local APIC present or hardware disabled
> mapped APIC to ffffd000 (0117e000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> CPU 0 irqstacks, hard=c03d4000 soft=c03d3000
> PID hash table entries: 1024 (order: 10, 16384 bytes)
> Detected 1399.535 MHz processor.
> Using tsc for high-res timesource
> Console: colour dummy device 80x25
> Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
> Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
> Memory: 187932k/194496k available (1914k kernel code, 6048k reserved,
> 774k data, 176k init, 0k highmem)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Calibrating delay using timer specific routine.. 2805.00 BogoMIPS (lpj=5610006)
> Security Framework v1.0.0 initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> selinux_register_security:  Registering secondary module capability
> Capability LSM initialized as secondary
> Mount-cache hash table entries: 512
> CPU: After generic identify, caps: 0381b83f 00000000 00000000 00000000
> 00000000 00000000 00000000
> CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
> CPU: L2 Cache: 64K (32 bytes/line)
> CPU: After all inits, caps: 0381b13f 00000000 00000000 00000000
> 00000000 000000dc 00000000
> CPU: Centaur VIA Nehemiah stepping 0a
> Checking 'hlt' instruction... OK.
> checking if image is initramfs... it is
> Freeing initrd memory: 997k freed
> NET: Registered protocol family 16
> PCI: PCI BIOS revision 2.10 entry at 0xf9f20, last bus=1
> PCI: Using configuration type 1
> ACPI: Subsystem revision 20060127
> ACPI: Interpreter disabled.
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI: disabled
> usbcore: registered new driver usbfs
> usbcore: registered new driver hub
> PCI: Probing PCI hardware
> PCI: Probing PCI hardware (bus 00)
> Boot video device is 0000:01:00.0
> PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
> PCI: Found IRQ 5 for device 0000:00:0f.1
> PCI: Sharing IRQ 5 with 0000:00:10.0
> PCI: Sharing IRQ 5 with 0000:00:10.1
> PCI: Sharing IRQ 5 with 0000:00:12.0
> PCI: Bridge: 0000:00:01.0
>   IO window: disabled.
>   MEM window: f4000000-f5ffffff
>   PREFETCH window: f0000000-f3ffffff
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
> audit: initializing netlink socket (disabled)
> audit(1172277235.532:1): initialized
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> SELinux:  Registering netfilter hooks
> Initializing Cryptographic API
> ksign: Installing public key data
> Loading keyring
> - Added public key EE596B44DDA71123
> - User ID: Red Hat, Inc. (Kernel Module GPG key)
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> PCI: Bypassing VIA 8237 APIC De-Assert Message
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> vesafb: framebuffer at 0xf0000000, mapped to 0xcc880000, using 1200k,
> total 65536k
> vesafb: mode is 640x480x16, linelength=1280, pages=101
> vesafb: protected mode interface info at c000:a585
> vesafb: scrolling: redraw
> vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
> Console: switching to colour frame buffer device 80x30
> fb0: VESA VGA frame buffer device
> isapnp: Scanning for PnP cards...
> isapnp: No Plug & Play device found
> Real Time Clock Driver v1.12ac
> Linux agpgart interface v0.101 (c) Dave Jones
> agpgart: Detected VIA PM800/PN800/PM880/PN880 chipset
> agpgart: AGP aperture is 128M @ 0xe8000000
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 AUX port at 0x60,0x64 irq 12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> serial8250: ttyS2 at I/O 0x3e8 (irq = 11) is a 16550A
> RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
> Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
> VP_IDE: IDE controller at PCI slot 0000:00:0f.1
> PCI: Found IRQ 5 for device 0000:00:0f.1
> PCI: Sharing IRQ 5 with 0000:00:10.0
> PCI: Sharing IRQ 5 with 0000:00:10.1
> PCI: Sharing IRQ 5 with 0000:00:12.0
> PCI: Via IRQ fixup for 0000:00:0f.1, from 255 to 5
> VP_IDE: chipset revision 6
> VP_IDE: not 100% native mode: will probe irqs later
> VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
>     ide0: BM-DMA at 0xe700-0xe707, BIOS settings: hda:pio, hdb:pio
>     ide1: BM-DMA at 0xe708-0xe70f, BIOS settings: hdc:pio, hdd:pio
> Probing IDE interface ide0...
> Probing IDE interface ide1...
> Probing IDE interface ide0...
> Probing IDE interface ide1...
> ide-floppy driver 0.99.newide
> usbcore: registered new driver libusual
> usbcore: registered new driver hiddev
> usbcore: registered new driver usbhid
> drivers/usb/input/hid-core.c: v2.6:USB HID core driver
> mice: PS/2 mouse device common for all mice
> md: md driver 0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
> md: bitmap version 4.39
> NET: Registered protocol family 2
> input: AT Translated Set 2 keyboard as /class/input/input0
> IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
> TCP established hash table entries: 8192 (order: 5, 131072 bytes)
> TCP bind hash table entries: 8192 (order: 5, 163840 bytes)
> TCP: Hash tables configured (established 8192 bind 8192)
> TCP reno registered
> TCP bic registered
> Initializing IPsec netlink socket
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> Using IPI Shortcut mode
> Freeing unused kernel memory: 176k freed
> Write protecting the kernel read-only data: 359k
> SCSI subsystem initialized
> input: PS2++ Logitech Wheel Mouse as /class/input/input1
> libata version 1.20 loaded.
> sata_via 0000:00:0f.0: version 1.1
> PCI: Found IRQ 10 for device 0000:00:0f.0
> PCI: Sharing IRQ 10 with 0000:00:0a.0
> PCI: Sharing IRQ 10 with 0000:00:10.2
> PCI: Sharing IRQ 10 with 0000:00:10.3
> sata_via 0000:00:0f.0: routed to hard irq line 10
> ata1: SATA max UDMA/133 cmd 0xEC00 ctl 0xED02 bmdma 0xE500 irq 10
> ata2: SATA max UDMA/133 cmd 0xEE00 ctl 0xE402 bmdma 0xE508 irq 10
> ata1: SATA link up 1.5 Gbps (SStatus 113)
> ata1: dev 0 cfg 49:2f00 82:7469 83:7f01 84:4023 85:7469 86:3c01 87:4023 88:407f
> ata1: dev 0 ATA-7, max UDMA/133, 156301488 sectors: LBA48
> ata1: dev 0 configured for UDMA/133
> scsi0 : sata_via
> ata2: SATA link down (SStatus 0)
> scsi1 : sata_via
>   Vendor: ATA       Model: WDC WD800JD-22LS  Rev: 06.0
>   Type:   Direct-Access                      ANSI SCSI revision: 05
> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: drive cache: write back
> SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: drive cache: write back
>  sda: sda1 sda2
> sd 0:0:0:0: Attached scsi disk sda
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> SELinux:  Disabled at runtime.
> SELinux:  Unregistering netfilter hooks
> via-rhine.c:v1.10-LK1.2.0-2.6 June-10-2004 Written by Donald Becker
> PCI: Found IRQ 5 for device 0000:00:12.0
> PCI: Sharing IRQ 5 with 0000:00:0f.1
> PCI: Sharing IRQ 5 with 0000:00:10.0
> PCI: Sharing IRQ 5 with 0000:00:10.1
> eth0: VIA Rhine II at 0xf6022000, 00:03:2d:0a:c9:21, IRQ 5.
> eth0: MII PHY found at address 1, status 0x786d advertising 05e1 Link c5e1.
> PCI: Found IRQ 6 for device 0000:00:11.5
> PCI: Sharing IRQ 6 with 0000:00:10.4
> PCI: Setting latency timer of device 0000:00:11.5 to 64
> USB Universal Host Controller Interface driver v2.3
> PCI: Found IRQ 5 for device 0000:00:10.0
> PCI: Sharing IRQ 5 with 0000:00:0f.1
> PCI: Sharing IRQ 5 with 0000:00:10.1
> PCI: Sharing IRQ 5 with 0000:00:12.0
> uhci_hcd 0000:00:10.0: UHCI Host Controller
> uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:10.0: irq 5, io base 0x0000e800
> usb usb1: configuration #1 chosen from 1 choice
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> PCI: Found IRQ 5 for device 0000:00:10.1
> PCI: Sharing IRQ 5 with 0000:00:0f.1
> PCI: Sharing IRQ 5 with 0000:00:10.0
> PCI: Sharing IRQ 5 with 0000:00:12.0
> uhci_hcd 0000:00:10.1: UHCI Host Controller
> uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
> uhci_hcd 0000:00:10.1: irq 5, io base 0x0000e900
> usb usb2: configuration #1 chosen from 1 choice
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> PCI: Found IRQ 10 for device 0000:00:10.2
> PCI: Sharing IRQ 10 with 0000:00:0a.0
> PCI: Sharing IRQ 10 with 0000:00:0f.0
> PCI: Sharing IRQ 10 with 0000:00:10.3
> uhci_hcd 0000:00:10.2: UHCI Host Controller
> uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
> uhci_hcd 0000:00:10.2: irq 10, io base 0x0000ea00
> usb usb3: configuration #1 chosen from 1 choice
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 2 ports detected
> PCI: Found IRQ 10 for device 0000:00:10.3
> PCI: Sharing IRQ 10 with 0000:00:0a.0
> PCI: Sharing IRQ 10 with 0000:00:0f.0
> PCI: Sharing IRQ 10 with 0000:00:10.2
> uhci_hcd 0000:00:10.3: UHCI Host Controller
> uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
> uhci_hcd 0000:00:10.3: irq 10, io base 0x0000eb00
> usb usb4: configuration #1 chosen from 1 choice
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 2 ports detected
> ieee1394: Initialized config rom entry `ip1394'
> PCI: Found IRQ 10 for device 0000:00:0c.0
> ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[10]
> MMIO=[f6020000-f60207ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> PCI: Found IRQ 6 for device 0000:00:10.4
> PCI: Sharing IRQ 6 with 0000:00:11.5
> ehci_hcd 0000:00:10.4: EHCI Host Controller
> ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
> ehci_hcd 0000:00:10.4: irq 6, io mem 0xf6021000
> ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
> usb usb5: configuration #1 chosen from 1 choice
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: 8 ports detected
> Non-volatile memory driver v1.2
> floppy0: Unable to grab IRQ6 for the floppy driver
> parport0: PC-style at 0x378 [PCSPP,TRISTATE]
> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[000000032d1122ad]
> lp0: using parport0 (polling).
> lp0: console ready
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> device-mapper: 4.5.0-ioctl (2005-10-04) initialised: dm-devel@redhat.com
> EXT3 FS on sda1, internal journal
> Adding 522104k swap on /dev/sda2.  Priority:-1 extents:1 across:522104k
> eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
> r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
> PCI: Found IRQ 10 for device 0000:00:0a.0
> PCI: Sharing IRQ 10 with 0000:00:0f.0
> PCI: Sharing IRQ 10 with 0000:00:10.2
> PCI: Sharing IRQ 10 with 0000:00:10.3
> eth1: RTL8169sc/8110sc at 0xccbca000, 00:03:2d:0a:c9:20, IRQ 10
> r8169: eth1: link down
> eth0: link down
> r8169: eth1: link up
>
> Cheers,
> Tom
>
