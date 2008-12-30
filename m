Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbYL3M2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbYL3M2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYL3M2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:28:16 -0500
Received: from lucidpixels.com ([75.144.35.66]:43006 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYL3M2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:28:15 -0500
Date: Tue, 30 Dec 2008 07:28:14 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: alsa-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       alsa-user@lists.sourceforge.net
Subject: Re: 2.6.28: hda_codec: Unknown model for ALC883, trying auto-probe
 from BIOS...
In-Reply-To: <alpine.DEB.1.10.0812300616570.11356@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0812300727380.11356@p34.internal.lan>
References: <alpine.DEB.1.10.0812300616570.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-507234908-1230640094=:11356"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-507234908-1230640094=:11356
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 30 Dec 2008, Justin Piszcz wrote:

> The audio for this board works fine, there are no issues, but there are s=
ome=20
> cosmetic issues when the driver loads:
>
> 1. Unknown model.
> 2. Wrong model number.
>
> On my ABIT AW9D-MAX motherboard:
> [   10.667963] Advanced Linux Sound Architecture Driver Version 1.0.18rc3=
=2E
> [   10.668156] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -=
>=20
> IRQ 1
> 6
> [   10.668228] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [   10.677932] hda_codec: Unknown model for ALC883, trying auto-probe fro=
m=20
> BIOS.
> ..
> [   10.705082] ALSA device list:
> [   10.705128]   #0: HDA Intel at 0xfdff8000 irq 16
>
> On an Intel motherboard, correctly detected, no warnings about an Unknown
> model.
>
> [    5.466951] Advanced Linux Sound Architecture Driver Version 1.0.18rc3=
=2E
> [    5.470149] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -=
>=20
> IRQ 22
> [    5.473135] HDA Intel 0000:00:1b.0: setting latency timer to 64
> [    5.512645] ALSA device list:
> [    5.515568]   #0: HDA Intel at 0xe2420000 irq 22
>
> Specs:
> # abit AudioMAX# HD 7.1 CH
> # Supports Jack Sensing and S/PDIF In/Out
> # Dolby=AE Master Studio Certificated=20
> http://www.abit.com.tw/page/en/motherboard/motherboard_detail.php?pMODEL_=
NAME=3DAW9D-MAX&fMTYPE=3DLGA775&pPRODINFO=3DSpecifications&fSEARCHTEXT=3DAW=
9D-MAX
>
> Not too specific, however:
> http://www.anandtech.com/mb/showdoc.aspx?i=3D2829
>
> Reveals the correct model:
> -> Realtek ALC882M HD-Audio 8-channel CODEC - Dolby Master Studio Where t=
he=20
> kernel believes it is an ALC883.
>
> Would it be possible to probe properly/and get the correct model number i=
n=20
> there for this audio chipset?
>
> lspci:
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definit=
ion=20
> Audio Controller (rev 01)
>
> lspci -vvvx:
> 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definit=
ion=20
> Audio Controller (rev 01)
>  Subsystem: ABIT Computer Corp. Device 107a
>  Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=20
> Stepping- SERR- FastB2B- DisINTx-
>  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
-=20
> <MAbort- >SERR- <PERR- INTx-
>  Latency: 0, Cache Line Size: 4 bytes
>  Interrupt: pin A routed to IRQ 16
>  Region 0: Memory at fdff8000 (64-bit, non-prefetchable) [size=3D16K]
>  Capabilities: [50] Power Management version 2
>    Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA=20
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>    Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>  Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/=
0=20
> Enable-
>    Address: 0000000000000000  Data: 0000
>  Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
>    DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
>      ExtTag- RBE- FLReset-
>    DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
>      RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
>      MaxPayload 128 bytes, MaxReadReq 128 bytes
>    DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
>    LnkCap: Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64=
ns,=20
> L1 <1us
>      ClockPM- Suprise- LLActRep- BwNot-
>    LnkCtl: ASPM Disabled; Disabled- Retrain- CommClk-
>      ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>    LnkSta: Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMg=
mt-=20
> ABWMgmt-
>  Capabilities: [100] Virtual Channel <?>
>  Capabilities: [130] Root Complex Link <?>
>  Kernel driver in use: HDA Intel
> 00: 86 80 d8 27 06 00 10 00 01 00 03 04 01 00 00 00
> 10: 04 80 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 7b 14 7a 10
> 30: 00 00 00 00 50 00 00 00 00 00 00 00 05 01 00 00

Fixed alsa e-mail in cc list.

Justin.
---1463747160-507234908-1230640094=:11356--
