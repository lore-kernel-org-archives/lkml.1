Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYGCT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYGCT3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYGCT3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 15:29:04 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:34911 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYGCT3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 15:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZuHlZgLBO+CpTZF/iyn1pX27yf0CDWrgYd2qLV1aB5OsJTH7m5peCh6Pfmtuo+Y7YS
         gsJjz2tcXtpc5DCAX3DKVmC8BZL7lPKWeN+Xs/GASSSEODFcZ0rWc4NzxIHUlKwS3e78
         DE9nZJHBhtL6mkReMGgLxUM/pmZTIuDXpU0MY=
Message-ID: <6278d2220807031228q3be3ed47l158fb70d4357b498@mail.gmail.com>
Date: Thu, 3 Jul 2008 20:28:55 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 Jul, 18:10, Justin Piszcz <jpis...@lucidpixels.com> wrote:
> On Thu, 3 Jul 2008, Roger Heflin wrote:
> > Justin Piszcz wrote:
>
> >> On Thu, 3 Jul 2008, Jeff Garzik wrote:
>
> >>> Justin Piszcz wrote:
>
> > Well, given that pcie x1 is max 250MB/second, and a number of pcie cards are
> > not native (they have a pcie to pci converter between them), "dmidecode -vvv"
> > will give you more details on the actual layout of things, and given that I
> > have seen several devices actually run slower by having the ability to
> > oversubscribe the bandwidth that is available and seemingly actually run
> > slower because of this ability, that may have some bearing,    Ie 2 slower
> > disks may be faster than 2 fast disks on the pcie just because they don't
> > oversubscribe the interfere. And given that if there is a pci converter that
> > may lower the overall bandwidth even more, and cause the issue.   If this was
> > old style ethernet I would have though collisions, but it must just come down
> > to the arbitration setups not being carefully designed for high utilization,
> > and high interference between devices.
>
> >                               Roger
>
> I have ordered a couple 4 port boards (that are PCI-e x4), my next plan
> of action to acquire > 600MiB/s is as follows:
>
> Current:
> Mobo: 6 drives (full speed)
> Silicon Image (3 cards, 2 drives each)
>
> Future:
> Mobo: 6 drives (full speed)
> Silicon Image (3 cards, 1 drive each)
> Four Port Card in x16 slot (the 3 remaining drives)
>
> This should in theory allow 1000 MiB/s..
>
> --
>
> # dmidecode -vvv
> dmidecode: invalid option -- v
>
> Assume you mean lspci:
>
> 05:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)
>          Subsystem: Silicon Image, Inc. Device 7132
>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>          Latency: 0, Cache Line Size: 64 bytes
>          Interrupt: pin A routed to IRQ 16
>          Region 0: Memory at e0104000 (64-bit, non-prefetchable) [size=128]
>          Region 2: Memory at e0100000 (64-bit, non-prefetchable) [size=16K]
>          Region 4: I/O ports at 2000 [size=128]
>          Expansion ROM at e0900000 [disabled] [size=512K]
>          Capabilities: [54] Power Management version 2
>                  Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                  Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>          Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>                  Address: 0000000000000000  Data: 0000
>          Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
>                  DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>                          ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>                  DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                          RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                          MaxPayload 128 bytes, MaxReadReq 512 bytes
>                  DevSta: CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr- TransPend-
>                  LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimited, L1 unlimited
>                          ClockPM- Suprise- LLActRep- BwNot-
>                  LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
>                          ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>                  LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
>          Capabilities: [100] Advanced Error Reporting <?>
>          Kernel driver in use: sata_sil24

PCIe (gen 1) x1 tops out around 186MB/s with 128 bytes Max Payload,
after 8b/10b encoding,  DLLP and TLP protocols, so this would mostly
account for the limits.

Part of it may depend on implementation, you'll know what I mean if
you've used hp's older (C)CISS controllers.

Daniel
-- 
Daniel J Blueman
