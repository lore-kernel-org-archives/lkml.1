Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0BEAuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 19:50:21 -0500
Received: from smtp13.ono.com ([62.42.230.16]:3681 "EHLO resmaa13.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757503Ab0BEAuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 19:50:20 -0500
Date: Fri, 5 Feb 2010 01:50:17 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: PCIe performance on nForcePro 2200/CK804
Message-ID: <20100205015017.40b7cc3e@werewolf.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.19.4; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a mobo with this chipset, the board in question is a SuperMicro H8DCE:

http://www.supermicro.com/Aplus/motherboard/Opteron/nForce/H8DCE.cfm

It has a GeForce GTX 260. The PCIe slot is supposed to be x16.
I use CUDA to do some calculations, and the transfer speed from host
memory to device is something like 1.3 GB/s (measured just timing a
host->device copy).

The same card on an Intel ICH10 chipset (Asus P5Q-PRO board) gives
about 4Gb/s.
One oldy 8800GTX on ICH8 (P965) gives 2.5 Gb/s (Intel DP965LT).

Is the nForce chipset so bad, or is it a kernel misconfiguration/bug ?
Or hardware/BIOS is not setup correctly ?

I am using 2.6.33-rc6 for x86-64. The kernel, gcc, CUDA, and even the test
binary is the same on all boxes (shared $HOME)...

Any ideas ?

cicely:~# lspci -vv -s 01:00.0
01:00.0 VGA compatible controller: nVidia Corporation GT200 [GeForce GTX 260] (rev a1) (prog-if 00 [VGA controller])
    Subsystem: ASUSTeK Computer Inc. Device 82e3
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    Latency: 0
    Interrupt: pin A routed to IRQ 19
    Region 0: Memory at be000000 (32-bit, non-prefetchable) [size=16M]
    Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
    Region 3: Memory at bc000000 (64-bit, non-prefetchable) [size=32M]
    Region 5: I/O ports at 8c00 [size=128]
    [virtual] Expansion ROM at bfb80000 [disabled] [size=512K]
    Capabilities: [60] Power Management version 3
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
        Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
        Address: 0000000000000000  Data: 0000
    Capabilities: [78] Express (v1) Endpoint, MSI 00
        DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
            ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
        DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
            RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
            MaxPayload 128 bytes, MaxReadReq 512 bytes
        DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
        LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <1us
            ClockPM- Surprise- LLActRep- BwNot-
        LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
            ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
        LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
    Kernel driver in use: nvidia
    Kernel modules: nvidia-current, nvidiafb, nouveau

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.1 (Cooker) for x86_64
Linux 2.6.32.3-desktop-0.rc2.1mnb (gcc 4.4.2 ) SMP
