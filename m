Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbZC1XP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbZC1XP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 19:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbZC1XPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 19:15:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:11553 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZC1XPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 19:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OoqsE401fUYr9qTVmkshdEU6KUtl8EVhFKqmk95P3HmyUt/YVHon4zMyvig6+YGLfb
         REtQLQ4BqBxm1TZTMRX3UAbDZ2ZIJGxZsJf3n7kSNJJ6FryY+U6Ib6W9UwoO5dafqL2y
         eL2A5sfrTz3pKdUw37FhnbJmKv13X9/fHDyOU=
MIME-Version: 1.0
In-Reply-To: <200903282316.55142.prakash@punnoor.de>
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm>
	 <200903281431.36572.prakash@punnoor.de>
	 <86802c440903281352v1a12a5a2kbda5a039d72aa26f@mail.gmail.com>
	 <200903282316.55142.prakash@punnoor.de>
Date: Sat, 28 Mar 2009 16:15:45 -0700
X-Google-Sender-Auth: 89eb361c0cd7bd3f
Message-ID: <86802c440903281615v30fd2071o61b4d75d8a5b28f4@mail.gmail.com>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
From: Yinghai Lu <yinghai@kernel.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 3:16 PM, Prakash Punnoor <prakash@punnoor.de> wrote:
> On Samstag 28 März 2009 21:52:45 Yinghai Lu wrote:
>> On Sat, Mar 28, 2009 at 6:31 AM, Prakash Punnoor <prakash@punnoor.de> wrote:
>> > On Samstag 28 März 2009 13:34:44 Prakash Punnoor wrote:
>> >> On Freitag 27 März 2009 00:10:01 Jesse Barnes wrote:
>> >> > On Fri, 20 Mar 2009 19:29:41 -0700
>> >> >
>> >> > Yinghai Lu <yinghai@kernel.org> wrote:
>> >> > > Impact: fix bug
>> >> > >
>> >> > > Prakash reported that his c51-mcp51 system ondie sound card doesn't
>> >> > > work MSI but if he hack out the HT-MSI on mcp51, the MSI will work
>> >> > > well with sound card.
>> >> > >
>> >> > > this patch rework the nv_msi_ht_cap_quirk()
>> >> > > and will only try to avoid to enable ht_msi on device following that
>> >> > > root dev, and don't touch that root dev
>> >> > >
>> >> > > v3: will enable c51...
>> >> > > v4: will enable c51 kind of without leaf too.
>> >> > > v5: update to mainline
>> >> > >
>> >> > > Reported-by: Prakash Punnoor <prakash@punnoor.de>
>> >> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> >> >
>> >> > Applied, thanks.  Prakash if you get a chance can you try testing my
>> >> > linux-next branch (or just linux-next in general tomorrow) to make
>> >> > sure this is still ok for you?
>> >> >
>> >> > Thanks,
>> >>
>> >> Finally I am able to test the linux-next branch of pci tree after Jesse
>> >> gave some help with git.(Is it correct that the kernel calls itself
>> >> 2.6.28-rc8? I looked into quirks.c and it seems to be correctly
>> >> patched.) Unfortunately it doesn't seem to work for me (and I am
>> >> wondering why as the old v4 version seemed to work ontop of one of the
>> >> 2.6.29-rc versions):
>> >>
>> >> dmesg|grep HT
>> >> pci 0000:00:00.0: Found disabled HT MSI Mapping
>> >> pci 0000:00:03.0: Enabling HT MSI Mapping
>> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
>> >> pci 0000:00:0e.0: Enabling HT MSI Mapping
>> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
>> >> pci 0000:00:0f.0: Enabling HT MSI Mapping
>> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
>> >> pci 0000:00:10.0: Enabling HT MSI Mapping
>> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
>> >> pci 0000:00:10.1: Enabling HT MSI Mapping
>> >>
>> >> Device 09.0 doesn't get enabled (good) but 00.0 also not (bad). Then my
>> >> Intel HDA cannot use MSI.
>> >
>> > I sprinkeld a few debugging messages around in the code and looking at
>> > that I don't see how the code can enable NMSI for device 00.0, but not
>> > for 09.0:
>> >
>> > Both will exit here:
>> >
>> > if (host_bridge == dev && host_bridge_with_leaf(host_bridge))
>>
>> where is
>> 0000:00:03.0: Enabling HT MSI Mapping
>> from?
>
> As I said this time there is a PCIe device more in my system (a realtek NIC):
> I guess because of that this one appeared - or I have some different drivers
> loaded?
>
> 00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 32 bytes
>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>        I/O behind bridge: 0000a000-0000afff
>        Memory behind bridge: fdc00000-fdcfffff
>        Prefetchable memory behind bridge: 00000000fdd00000-00000000fddfffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>        Capabilities: [48] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>                Address: 00000000fee0300c  Data: 4149
>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>                Mapping Address Base: 00000000fee00000
>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
>                        ExtTag- RBE- FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
>                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
>                        ClockPM- Surprise- LLActRep+ BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
>                        Changed: MRL- PresDet+ LinkState+
>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
>                RootCap: CRSVisible-
>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>        Capabilities: [100] Virtual Channel <?>
>        Kernel driver in use: pcieport-driver
> 00: de 10 fd 02 07 04 10 00 a1 00 04 06 08 00 01 00
> 10: 00 00 00 00 00 00 00 00 00 01 01 00 a1 a1 00 20
> 20: c0 fd c0 fd d1 fd d1 fd 00 00 00 00 00 00 00 00
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00
> 40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00
> 50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00
> 60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 10 00 41 01 c0 04 00 00 10 28 00 00 11 3c 11 01
> 90: 40 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> The realtek nic:
> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 01)
>        Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Interrupt: pin A routed to IRQ 25
>        Region 0: I/O ports at ac00 [size=256]
>        Region 2: Memory at fdcff000 (64-bit, non-prefetchable) [size=4K]
>        Expansion ROM at fdcc0000 [disabled] [size=128K]
>        Capabilities: [40] Power Management version 2
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [48] Vital Product Data
>                Unknown small resource type 05
>                Unknown large resource type 6c
>                No end tag found
>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>                Address: 00000000fee0300c  Data: 4161
>        Capabilities: [60] Express (v1) Endpoint, MSI 00
>                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <1us, L1 unlimited
>                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-
>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
>                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency L0 unlimited, L1 unlimited
>                        ClockPM- Surprise- LLActRep- BwNot-
>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>        Capabilities: [84] Vendor Specific Information <?>
>        Capabilities: [100] Advanced Error Reporting
>                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
>                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
>                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
>                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
>                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- ChkEn-
>        Capabilities: [12c] Virtual Channel <?>
>        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-12-45
>        Capabilities: [154] Power Budgeting <?>
>        Kernel driver in use: r8169
> 00: ec 10 68 81 07 04 10 00 01 00 00 02 10 00 00 00
> 10: 01 ac 00 00 00 00 00 00 04 f0 cf fd 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 02 01 00 00 ec 10 68 81
> 30: 00 00 cc fd 40 00 00 00 00 00 00 00 05 01 00 00
> 40: 01 48 c2 f7 00 00 00 00 03 50 00 00 05 df c2 f7
> 50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 61 41 00 00
> 60: 10 84 01 00 23 7f 00 00 10 58 1a 00 41 f4 03 00
> 70: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 09 00 4c 01 01 1c 02 00 fb ff ff 11
> 90: 08 30 00 00 a2 10 0a 00 67 50 08 00 c3 01 00 00
> a0: 02 28 ff 01 00 00 00 00 00 08 00 00 03 00 03 00
> b0: 00 00 00 00 ff 3f ff 3f ff ff 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>

ok, when you plug in the card, BIOS will enable the pcie bridge...

need other way to figure out it is HT tunnel or HT end devices.

YH
