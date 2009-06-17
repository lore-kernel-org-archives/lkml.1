Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbZFQVp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbZFQVp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 17:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZFQVpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 17:45:51 -0400
Received: from smtp3.ono.com ([62.42.230.176]:13324 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641AbZFQVpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 17:45:50 -0400
Date: Wed, 17 Jun 2009 23:45:50 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Speed of SDHCI subsystem
Message-ID: <20090617234550.116d7b7e@werewolf.home>
In-Reply-To: <20090603083341.7a2c84c8@mjolnir.ossman.eu>
References: <20090519003750.461abe7d@werewolf.home>
	<20090603083341.7a2c84c8@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1cvs71 (GTK+ 2.17.2; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009 08:33:41 +0200, Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> On Tue, 19 May 2009 00:37:50 +0200
> "J.A. Magallón" <jamagallon@ono.com> wrote:
> 
> > Hi all...
> > 
> > I have notice something strange with SD cards.
> > I have an Aspire One and had an 8Gb SDHC card that used for my home,
> > and have recently upgraded to a 16Gb one.
> > This new one came with an USB reader.
> > 
> > The thing is that cards look much faster when accessed through the USB
> > key that directly on the readers of the One.
> > 
> > Some numbers with hdparm:
> > 
> > TakeMS 8Gb Class 6:
> > 	Gives 10MB/s on the slot, 17MB/s via the USB key
> > SanDisk UltraII 16Gb, Class 4, advertised as 15Mb/s:
> > 	Gives 10MB/s on the slot, 14MB/s on USB
> > 
> > I know that hdparm is not a benchmark, but I supposed it should be
> > limited by the media, not the connection.
> > 
> > But somehow the SDHCI/MMC subsystem seems to be stuck at 10MB/s, independent
> > of the quality of the media.
> > 
> > Any ideas ?
> > 
> 
> Given your numbers I'd guess that your USB reader supports high-speed
> and your built-in one does not. The theoretical throughput without
> high-speed is 12.5 MB/s (SI-prefix). With some overhead, and the fact
> that many controllers have a lower maximum frequency than 25 MHz, makes
> your 10 MB/s pretty reasonable.
> 
> For reference, I've managed to achieve ~23 MB/s using a Sandisk Extreme
> III card and a JMicron controller, so there doesn't seem to be any
> major inherent bottle necks in the MMC stack.
> 

Thanks, now its clear it is related to hardware limits.
I suppose this controler is a cheap one...
Things in the Aspire One are these:

one:~# lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
04:00.0 System peripheral: JMicron Technologies, Inc. SD/MMC Host Controller
04:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host Controller
04:00.3 System peripheral: JMicron Technologies, Inc. MS Host Controller
04:00.4 System peripheral: JMicron Technologies, Inc. xD Host Controller

one:~# lspci -vvv -s 04:00.2
04:00.2 SD Host controller: JMicron Technologies, Inc. Standard SD Host Controller (prog-if 01)
    Subsystem: Acer Incorporated [ALI] Device 015b
    Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at 34100200 (32-bit, non-prefetchable) [size=256]
    Capabilities: [a4] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [80] Express (v1) Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
            ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
            MaxPayload 128 bytes, MaxReadReq 128 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
        LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 unlimited, L1 unlimited
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
    Capabilities: [94] MSI: Mask- 64bit- Count=1/1 Enable-
        Address: fffffffc  Data: 0000
    Kernel modules: sdhci-pci

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
