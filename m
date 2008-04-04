Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYDDAQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYDDAQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbYDDANO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:13:14 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:62911 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761032AbYDDANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qTauBzbBfRx7XCf9uPF2ts/vlAaeAQcbW9Vj7mQfxjBhU2RqEXpQmR4XRTPoe74gEKMMgvVGc5DmciSIjUiPsaAYGMt0MrdvbVX/Z0MMmKTaq+1Dhe/KU75sg9+RePmg/BP2ldp54mUO/GQFkZa+0FIcI8qv5waxCSyHIlsGRsE=
Message-ID: <55a4f86e0804031713p5bc98992p866f2fff5433dd0f@mail.gmail.com>
Date: Fri, 4 Apr 2008 01:13:10 +0100
From: "=?UTF-8?Q?Maciej_=C5=BBenczykowski?=" <maze@tcs.uj.edu.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: Suspending and resuming a single PCI device (and bridge)
In-Reply-To: <55a4f86e0804031707j118d2f3atcb621b28dee29df0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <55a4f86e0804031707j118d2f3atcb621b28dee29df0@mail.gmail.com>
X-Google-Sender-Auth: 6af2a918475993bb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a wireless card (atheros 5418 on a MacBookPro3,1) which is
(kind-of) supported by the madwifi driver (from head), however
occasionally it gets stuck (long outstanding bug with lots of
comments, but no fixes) - I've noticed that a suspend to ram and
resume (almost?) always fixes the problem.

Thus, I'm wondering if there is a way to cause a pci device (and
possibly the pci bridge/port it's connected to) to suspend/resume
manually (or naturally, any other solution to the problem)...

The hardware in question:

# lspci -t | egrep 0b; lspci -vvnn -s 00:1c.4; lspci -vvnn -s 0b:00.0

           +-1c.4-[0000:0b]----00.0

00:1c.4 PCI bridge [0604]: Intel Corporation 82801H (ICH8 Family) PCI
Express Port 5 [8086:2847] (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 256 bytes
        Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
        Memory behind bridge: d7300000-d73fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
        Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
unlimited, L1 unlimited
                        ExtTag- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr+ TransPend-
                LnkCap: Port #5, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <256ns, L1 <4us
                        ClockPM- Suprise- LLActRep+ BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive+ BWMgmt- ABWMgmt-
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd-
HotPlug+ Surpise+
                        Slot #  4, PowerLimit 6.500000; Interlock- NoCompl-
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet-
CmdCplt- HPIrq- LinkChg-
                        Control: AttnInd Unknown, PwrInd Unknown,
Power- Interlock-
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt-
PresDet+ Interlock-
                        Changed: MRL- PresDet+ LinkState+
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal-
PMEIntEna- CRSVisible-
                RootCap: CRSVisible-
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: fee0300c  Data: 4179
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
[0000:0000]
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: pcieport-driver
        Kernel modules: shpchp

0b:00.0 Network controller [0280]: Atheros Communications, Inc. AR5418
802.11abgn Wireless PCI Express Adapter [168c:0024] (rev 01)
        Subsystem: Apple Computer Inc. Unknown device [106b:0087]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 256 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at d7300000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1,
Latency L0 <512ns, L1 <64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM L1 Enabled; RCB 128 bytes Disabled-
Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
                Vector table: BAR=0 offset=00000000
                PBA: BAR=0 offset=00000000
        Kernel driver in use: ath_pci
        Kernel modules: ath5k, ath_pci

When the problem happens, the kernel driver reports:
kernel: wifi0: ath_rxorn_tasklet: Receive FIFO overrun; resetting.
kernel:last message repeated 92 times

I've noticed this seems to be correlated to <MAbort+ being asserted on
the pci port (00:1c.4) and on the device itself (0b:00.0) - thus I
think the above message is more of a symptom, than an actual
problem...

Does anyone have any ideas (for example how [else] to clear MAbort)?

This is on kernel 2.6.24.4-74.fc8 from koji for fedora core 8 (also
present on 2.6.24.3-*.fc8), but people have reported issues on pretty
much everything (ubuntu, etc), any desired futher information
available by request...

Not currently subscribed so please keep me CC'ed.

Thanks,
Maciej
