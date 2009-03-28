Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbZC1WOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbZC1WOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761965AbZC1WOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:14:14 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:50229 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbZC1WOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:14:10 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 0D9AE3CA205
From: Prakash Punnoor <prakash@punnoor.de>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] pci: don't enable too much HT MSI mapping -v5 -resend
Date: Sat, 28 Mar 2009 23:16:54 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8; KDE/4.2.1; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Robert Hancock <hancockrwd@gmail.com>, david@lang.hm,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <alpine.DEB.1.10.0902171419000.26625@asgard.lang.hm> <200903281431.36572.prakash@punnoor.de> <86802c440903281352v1a12a5a2kbda5a039d72aa26f@mail.gmail.com>
In-Reply-To: <86802c440903281352v1a12a5a2kbda5a039d72aa26f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1310326.ERysuNpbog";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903282316.55142.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1310326.ERysuNpbog
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 28 M=E4rz 2009 21:52:45 Yinghai Lu wrote:
> On Sat, Mar 28, 2009 at 6:31 AM, Prakash Punnoor <prakash@punnoor.de> wro=
te:
> > On Samstag 28 M=E4rz 2009 13:34:44 Prakash Punnoor wrote:
> >> On Freitag 27 M=E4rz 2009 00:10:01 Jesse Barnes wrote:
> >> > On Fri, 20 Mar 2009 19:29:41 -0700
> >> >
> >> > Yinghai Lu <yinghai@kernel.org> wrote:
> >> > > Impact: fix bug
> >> > >
> >> > > Prakash reported that his c51-mcp51 system ondie sound card doesn't
> >> > > work MSI but if he hack out the HT-MSI on mcp51, the MSI will work
> >> > > well with sound card.
> >> > >
> >> > > this patch rework the nv_msi_ht_cap_quirk()
> >> > > and will only try to avoid to enable ht_msi on device following th=
at
> >> > > root dev, and don't touch that root dev
> >> > >
> >> > > v3: will enable c51...
> >> > > v4: will enable c51 kind of without leaf too.
> >> > > v5: update to mainline
> >> > >
> >> > > Reported-by: Prakash Punnoor <prakash@punnoor.de>
> >> > > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >> >
> >> > Applied, thanks.  Prakash if you get a chance can you try testing my
> >> > linux-next branch (or just linux-next in general tomorrow) to make
> >> > sure this is still ok for you?
> >> >
> >> > Thanks,
> >>
> >> Finally I am able to test the linux-next branch of pci tree after Jesse
> >> gave some help with git.(Is it correct that the kernel calls itself
> >> 2.6.28-rc8? I looked into quirks.c and it seems to be correctly
> >> patched.) Unfortunately it doesn't seem to work for me (and I am
> >> wondering why as the old v4 version seemed to work ontop of one of the
> >> 2.6.29-rc versions):
> >>
> >> dmesg|grep HT
> >> pci 0000:00:00.0: Found disabled HT MSI Mapping
> >> pci 0000:00:03.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:0e.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:0f.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:10.0: Enabling HT MSI Mapping
> >> pci 0000:00:09.0: Found disabled HT MSI Mapping
> >> pci 0000:00:10.1: Enabling HT MSI Mapping
> >>
> >> Device 09.0 doesn't get enabled (good) but 00.0 also not (bad). Then my
> >> Intel HDA cannot use MSI.
> >
> > I sprinkeld a few debugging messages around in the code and looking at
> > that I don't see how the code can enable NMSI for device 00.0, but not
> > for 09.0:
> >
> > Both will exit here:
> >
> > if (host_bridge =3D=3D dev && host_bridge_with_leaf(host_bridge))
>
> where is
> 0000:00:03.0: Enabling HT MSI Mapping
> from?

As I said this time there is a PCIe device more in my system (a realtek NIC=
):
I guess because of that this one appeared - or I have some different drivers
loaded?

00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1) (pro=
g-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-=20
        Latency: 0, Cache Line Size: 32 bytes                              =
                                 =20
        Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0                                        =20
        I/O behind bridge: 0000a000-0000afff                               =
                                 =20
        Memory behind bridge: fdc00000-fdcfffff                            =
                                 =20
        Prefetchable memory behind bridge: 00000000fdd00000-00000000fddffff=
f                                =20
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort+ <SERR- <PERR-      =20
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-      =
                                 =20
                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-        =
                                 =20
        Capabilities: [40] Subsystem: nVidia Corporation Device 0000       =
                                 =20
        Capabilities: [48] Power Management version 2                      =
                                 =20
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1+,D2=
+,D3hot+,D3cold+)                  =20
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-            =
                                     =20
        Capabilities: [50] MSI: Mask- 64bit+ Count=3D1/2 Enable+           =
                                   =20
                Address: 00000000fee0300c  Data: 4149                      =
                                 =20
        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-      =
                                 =20
                Mapping Address Base: 00000000fee00000                     =
                                 =20
        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00          =
                                 =20
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512=
ns, L1 <4us                      =20
                        ExtTag- RBE- FLReset-                              =
                                 =20
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-                          =20
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+       =
                                 =20
                        MaxPayload 128 bytes, MaxReadReq 512 bytes         =
                                 =20
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- Tr=
ansPend-                         =20
                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Late=
ncy L0 <512ns, L1 <4us           =20
                        ClockPM- Surprise- LLActRep+ BwNot-                =
                                 =20
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+                             =20
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-     =
                                 =20
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive+ BWMgmt- ABWMgmt-          =20
                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Su=
rpise-                           =20
                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-=
                                 =20
                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPI=
rq- LinkChg-                     =20
                        Control: AttnInd Off, PwrInd On, Power- Interlock- =
                                 =20
                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ I=
nterlock-                        =20
                        Changed: MRL- PresDet+ LinkState+                  =
                                 =20
                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-=
 CRSVisible-                     =20
                RootCap: CRSVisible-                                       =
                                 =20
                RootSta: PME ReqID 0000, PMEStatus- PMEPending-            =
                                 =20
        Capabilities: [100] Virtual Channel <?>                            =
                                 =20
        Kernel driver in use: pcieport-driver                              =
                                 =20
00: de 10 fd 02 07 04 10 00 a1 00 04 06 08 00 01 00                        =
                                 =20
10: 00 00 00 00 00 00 00 00 00 01 01 00 a1 a1 00 20                        =
                                 =20
20: c0 fd c0 fd d1 fd d1 fd 00 00 00 00 00 00 00 00                        =
                                 =20
30: 00 00 00 00 40 00 00 00 00 00 00 00 ff 00 04 00                        =
                                 =20
40: 0d 48 00 00 de 10 00 00 01 50 02 f8 00 00 00 00                        =
                                 =20
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 49 41 00 00                        =
                                 =20
60: 08 80 00 a8 00 00 e0 fe 00 00 00 00 00 00 00 00                        =
                                 =20
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
80: 10 00 41 01 c0 04 00 00 10 28 00 00 11 3c 11 01                        =
                                 =20
90: 40 00 11 30 00 00 00 00 c0 01 48 01 00 00 00 00                        =
                                 =20
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                 =20

The realtek nic:
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B =
PCI Express Gigabit Ethernet controller (rev 01)
        Subsystem: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Expres=
s Gigabit Ethernet controller                  =20
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-=
 Stepping- SERR- FastB2B- DisINTx+             =20
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <T=
Abort- <MAbort- >SERR- <PERR- INTx-              =20
        Latency: 0, Cache Line Size: 64 bytes                              =
                                               =20
        Interrupt: pin A routed to IRQ 25                                  =
                                               =20
        Region 0: I/O ports at ac00 [size=3D256]                           =
                                                 =20
        Region 2: Memory at fdcff000 (64-bit, non-prefetchable) [size=3D4K]=
                                                 =20
        Expansion ROM at fdcc0000 [disabled] [size=3D128K]                 =
                                                 =20
        Capabilities: [40] Power Management version 2                      =
                                               =20
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0-,D1+,=
D2+,D3hot+,D3cold+)                              =20
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-            =
                                                   =20
        Capabilities: [48] Vital Product Data                              =
                                               =20
                Unknown small resource type 05                             =
                                               =20
                Unknown large resource type 6c                             =
                                               =20
                No end tag found                                           =
                                               =20
        Capabilities: [50] MSI: Mask- 64bit+ Count=3D1/2 Enable+           =
                                                 =20
                Address: 00000000fee0300c  Data: 4161                      =
                                               =20
        Capabilities: [60] Express (v1) Endpoint, MSI 00                   =
                                               =20
                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency L0s <1u=
s, L1 unlimited                                =20
                        ExtTag+ AttnBtn+ AttnInd+ PwrInd+ RBE- FLReset-    =
                                               =20
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsup=
ported-                                        =20
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+       =
                                               =20
                        MaxPayload 128 bytes, MaxReadReq 4096 bytes        =
                                               =20
                DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ Tr=
ansPend-                                       =20
                LnkCap: Port #0, Speed 2.5GT/s, Width x4, ASPM L0s, Latency=
 L0 unlimited, L1 unlimited                    =20
                        ClockPM- Surprise- LLActRep- BwNot-                =
                                               =20
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- Comm=
Clk+                                           =20
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-     =
                                               =20
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLA=
ctive- BWMgmt- ABWMgmt-                        =20
        Capabilities: [84] Vendor Specific Information <?>                 =
                                               =20
        Capabilities: [100] Advanced Error Reporting                       =
                                               =20
                UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-        =20
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-        =20
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- =
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-        =20
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-                                           =20
                CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatal=
Err-                                           =20
                AERCap: First Error Pointer: 14, GenCap- CGenEn- ChkCap- Ch=
kEn-                                           =20
        Capabilities: [12c] Virtual Channel <?>                            =
                                               =20
        Capabilities: [148] Device Serial Number 68-81-ec-10-00-00-12-45   =
                                               =20
        Capabilities: [154] Power Budgeting <?>                            =
                                               =20
        Kernel driver in use: r8169                                        =
                                               =20
00: ec 10 68 81 07 04 10 00 01 00 00 02 10 00 00 00                        =
                                               =20
10: 01 ac 00 00 00 00 00 00 04 f0 cf fd 00 00 00 00                        =
                                               =20
20: 00 00 00 00 00 00 00 00 02 01 00 00 ec 10 68 81                        =
                                               =20
30: 00 00 cc fd 40 00 00 00 00 00 00 00 05 01 00 00                        =
                                               =20
40: 01 48 c2 f7 00 00 00 00 03 50 00 00 05 df c2 f7                        =
                                               =20
50: 05 60 83 00 0c 30 e0 fe 00 00 00 00 61 41 00 00                        =
                                               =20
60: 10 84 01 00 23 7f 00 00 10 58 1a 00 41 f4 03 00                        =
                                               =20
70: 40 00 11 10 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                               =20
80: 00 00 00 00 09 00 4c 01 01 1c 02 00 fb ff ff 11                        =
                                               =20
90: 08 30 00 00 a2 10 0a 00 67 50 08 00 c3 01 00 00                        =
                                               =20
a0: 02 28 ff 01 00 00 00 00 00 08 00 00 03 00 03 00                        =
                                               =20
b0: 00 00 00 00 ff 3f ff 3f ff ff 00 00 00 00 00 00                        =
                                               =20
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                               =20
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                               =20
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                        =
                                               =20
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

--nextPart1310326.ERysuNpbog
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAknOodcACgkQxU2n/+9+t5jctACfczj4vzd9jKD+Ex7IENoa+jrv
/3cAn1Z1T3Cdex/Me06AjDjT7pWRSvIS
=5LQf
-----END PGP SIGNATURE-----

--nextPart1310326.ERysuNpbog--
