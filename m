Return-Path: <linux-kernel-owner+w=401wt.eu-S932380Ab0AGD2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab0AGD2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932363Ab0AGD2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:28:23 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36094 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330Ab0AGD2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZmTQYFT2euMdcsohVESyXb3uhc6HXdbMLKTifwcR3KfQ5bgbstnZ0GvEY+6fM821HV
         qljZFvjL/pMOIsjlCAxqVf4lfsnXlUOg3dbbWjtBw59bW0yNT76N1O4VOVc4khXut6+D
         kyEBhMEauAPdG+ivDSY+TP3F1Zq75sSxZAkeY=
MIME-Version: 1.0
In-Reply-To: <4B454F8B.5040900@gmail.com>
References: <64bb37e1001060137h597322e8s4305b7cc1c91527e@mail.gmail.com>
	 <4B4531F9.3060108@gmail.com>
	 <64bb37e1001061827i64ead7f9m3dbe1b7b707c79eb@mail.gmail.com>
	 <4B454F8B.5040900@gmail.com>
Date: Thu, 7 Jan 2010 04:28:20 +0100
Message-ID: <64bb37e1001061928k746d090cpe48d2ea7bbd3f774@mail.gmail.com>
Subject: Re: New MSI support in sata_sil24 still broken in 2.6.33-rc3
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Mahajan <vivek.mahajan@freescale.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 4:05 AM, Robert Hancock <hancockrwd@gmail.com> wrote:
> Hmm, well presumably the problem isn't related to that then. I was looking
> at your lspci output though:
>
> 00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
> (prog-if 85 [Master SecO PriO])
>        Subsystem: ASUSTeK Computer Inc. Device 81f0
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0 (750ns min, 250ns max)
>        Interrupt: pin A routed to IRQ 30
>        Region 0: I/O ports at cc00 [size=8]
>        Region 1: I/O ports at c880 [size=4]
>        Region 2: I/O ports at c800 [size=8]
>        Region 3: I/O ports at c480 [size=4]
>        Region 4: I/O ports at c400 [size=16]
>        Region 5: Memory at efafb000 (32-bit, non-prefetchable) [size=4K]
>        Capabilities: [44] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [b0] MSI: Enable+ Count=1/4 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4189
>        Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
>
> The HT MSI Mapping capability is not enabled on the device. I'm thinking it
> should be, but I'm not sure. And it's also not enabled on the bus which has
> the Silicon Image controller:
>
> 04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA
> Raid II Controller (rev 01)
>
> on its subordinate bus:
>
> 00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
> (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 0, Cache Line Size: 64 bytes
>        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>        I/O behind bridge: 0000e000-0000efff
>        Memory behind bridge: efe00000-efefffff
>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>        Capabilities: [48] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
>                Address: 00000000fee0f00c  Data: 4149
>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>                Mapping Address Base: 00000000fee00000
>
> CCing some people that might have some idea about this..

part of the PCI tree:
           +-0b.0-[04]----00.0  Silicon Image, Inc. SiI 3132 Serial
ATA Raid II Controller
           +-0c.0-[03]----00.0  Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express
           +-0d.0-[02]----00.0  Broadcom Corporation NetXtreme BCM5754
Gigabit Ethernet PCI Express
           +-0f.0-[01]--+-00.0  ATI Technologies Inc RV370 5B60
[Radeon X300 (PCIE)]
           |            \-00.1  ATI Technologies Inc RV370 [Radeon X300SE]

The three devices attached to 0c.0, 0d.0 and 0f.0 work correctly with MSI.
But each of these PCI Express bridges also has this Mapping disabled:
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
                Mapping Address Base: 00000000fee00000

This capability seems only to be enabled at the root:
00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
        Subsystem: ASUSTeK Computer Inc. Device 81f0
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- S
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort
        Latency: 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
                Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
                Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC-
TXO- <CRCErr=0 Isoc
                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
LWI=16bit DwFcInE
                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+
TXO+ <CRCErr=0 Isoc
                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut-
LWI=8bit DwFcInEn-
                Revision ID: 1.03
                Link Frequency 0: 1.0GHz
                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+
500MHz+ 600MHz+ 80
                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
                Link Frequency 1: 200MHz
                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz-
500MHz- 600MHz- 80
                Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE-
CRCFE- SERRFE- CF- RE
                Prefetchable memory behind bridge Upper: 00-00
                Bus Number: 00
        Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
                Mapping Address Base: 00000000fee00000

>From my dmesg:
[    1.636318] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.641854] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.647420] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.652946] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.658505] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.664055] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.669597] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.675172] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    1.680715] pci 0000:00:00.0: Found enabled HT MSI Mapping

I found this output very strange, as it always referred to the same
pci device, but looking at the code, that might only be a visual nit.

The output is from msi_ht_cap_enabled() in drivers/pci/quirks.c. This
will be called via nv_ht_enable_msi_mapping(), but always to check the
'host_bridge', not the devices that __nv_msi_ht_cap_quirk() loops
over.

But I do not have the knowlegde to to decide, if this is just a
overeager debug output, or if this should be switched to test each
device.


Torsten
