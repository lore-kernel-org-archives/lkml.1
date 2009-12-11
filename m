Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbZLKIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbZLKIp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbZLKIpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:45:21 -0500
Received: from smtp14.ono.com ([62.42.230.176]:18065 "EHLO resmaa14.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751131AbZLKIpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:45:18 -0500
Date: Fri, 11 Dec 2009 09:45:15 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Useless thermal acpi driver ?
Message-ID: <20091211094515.4b4872ef@werewolf.home>
In-Reply-To: <alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>
References: <20091209232608.25aed4ca@werewolf.home>
	<4B20483C.6090309@gmail.com>
	<alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>
X-Mailer: Claws Mail 3.7.3cvs35 (GTK+ 2.19.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/3CLjc+L=H7TrDLyXfMQRZDc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/3CLjc+L=H7TrDLyXfMQRZDc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 11 Dec 2009 01:25:49 -0500 (EST), Len Brown <lenb@kernel.org> wrote:

> On Wed, 9 Dec 2009, Robert Hancock wrote:
>=20
> > On 12/09/2009 04:26 PM, J.A. Magall=C3=B3n wrote:
> > > Hi all...
> > >=20
> > > I have a couple boxes where the thermal acpi driver gives this:
> > >=20
> > > bran:~>  sensors
> > > acpitz-virtual-0
> > > Adapter: Virtual device
> > > temp1:       +26.8=C2=B0C  (crit =3D +100.0=C2=B0C)
> > >=20
> > > bran:~>  acpi -t
> > > No support for device type: battery
> > >       Thermal 1: ok, 27.0 degrees C
> > >=20
> > > It stays _always_ the same, there is no difference if I run some numb=
er
> > > crunchin, or even if one of them is overclocked from 2.8 to 3.0 GHz.
> >=20
> > There are systems where an ACPI thermal zone exists but isn't really ho=
oked up
> > to anything and just reports some dummy temperature value. My old system
> > reported 40 degrees C no matter what. (I think it's something like the =
thermal
> > zone support is part of the standard ACPI DSDT template the mobo maker =
got
> > from the BIOS developer and they effectively disabled it by putting in =
the
> > dummy temperature.)
>=20
> send the output from acpidump, and a quick look will tell us
> if your ACPI suport is dummy, or accesses real registers.
>=20
> Also, show the output from
>=20
> grep . /proc/acpi/thermal_zone/*/*
>=20

Here they go:

bran:~# grep . /proc/acpi/thermal_zone/*/*
/proc/acpi/thermal_zone/THRM/cooling_mode:0 - Active; 1 - Passive
/proc/acpi/thermal_zone/THRM/polling_frequency:<polling disabled>
/proc/acpi/thermal_zone/THRM/state:state:                   ok
/proc/acpi/thermal_zone/THRM/temperature:temperature:             27 C
/proc/acpi/thermal_zone/THRM/trip_points:critical (S5):           100 C
/proc/acpi/thermal_zone/THRM/trip_points:passive:                 75 C: tc1=
=3D4 tc2=3D3 tsp=3D60 devices=3DCPU0
/proc/acpi/thermal_zone/THRM/trip_points:active[0]:               75 C: dev=
ices=3D FAN

Result from acpidump is attached.

--=20
J.A. Magallon <jamagallon()ono!com>     \               Software is like se=
x:
                                         \         It's better when it's fr=
ee
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May

--MP_/3CLjc+L=H7TrDLyXfMQRZDc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=acpidump.txt

DSDT @ 0xbfff30c0
  0000: 44 53 44 54 42 45 00 00 01 74 49 4e 54 45 4c 52  DSDTBE...tINTELR
  0010: 41 57 52 44 41 43 50 49 00 10 00 00 4d 53 46 54  AWRDACPI....MSFT
  0020: 0e 00 00 01 10 2c 5c 5f 50 52 5f 5b 83 11 5c 2e  .....,\_PR_[..\.
  0030: 5f 50 52 5f 43 50 55 30 00 00 00 00 00 00 5b 83  _PR_CPU0......[.
  0040: 11 5c 2e 5f 50 52 5f 43 50 55 31 01 00 00 00 00  .\._PR_CPU1.....
  0050: 00 08 5c 5f 53 30 5f 12 0a 04 0a 00 0a 00 0a 00  ..\_S0_.........
  0060: 0a 00 08 5c 5f 53 31 5f 12 0a 04 0a 01 0a 00 0a  ...\_S1_........
  0070: 00 0a 00 08 5c 53 53 33 5f 12 0a 04 0a 05 0a 00  ....\SS3_.......
  0080: 0a 00 0a 00 08 5c 5f 53 34 5f 12 0a 04 0a 06 0a  .....\_S4_......
  0090: 00 0a 00 0a 00 08 5c 5f 53 35 5f 12 0a 04 0a 07  ......\_S5_.....
  00a0: 0a 00 0a 00 0a 00 08 46 4c 41 47 0a 00 08 53 54  .......FLAG...ST
  00b0: 41 54 0a 00 5b 80 5c 44 45 42 47 01 0a 80 0a 01  AT..[.\DEBG.....
  00c0: 5b 81 0c 5c 44 45 42 47 01 44 42 47 31 08 5b 80  [..\DEBG.DBG1.[.
  00d0: 45 58 54 4d 00 0c 30 f8 0f 00 0a 10 5b 81 29 45  EXTM..0.....[.)E
  00e0: 58 54 4d 02 52 4f 4d 31 10 52 4d 53 31 10 52 4f  XTM.ROM1.RMS1.RO
  00f0: 4d 32 10 52 4d 53 32 10 52 4f 4d 33 10 52 4d 53  M2.RMS2.ROM3.RMS
  0100: 33 10 41 4d 45 4d 20 5b 80 5c 53 4d 49 43 01 0a  3.AMEM [.\SMIC..
  0110: b2 0a 01 5b 81 0c 5c 53 4d 49 43 01 53 43 50 5f  ...[..\SMIC.SCP_
  0120: 08 5b 80 5c 50 4d 31 53 01 0b 00 04 0a 04 5b 81  .[.\PM1S......[.
  0130: 1b 5c 50 4d 31 53 01 50 4d 30 30 08 50 4d 30 31  .\PM1S.PM00.PM01
  0140: 08 50 4d 30 32 08 50 4d 30 33 08 5b 80 5c 53 50  .PM02.PM03.[.\SP
  0150: 45 4e 01 0b 30 04 0a 01 5b 81 0e 5c 53 50 45 4e  EN..0...[..\SPEN
  0160: 01 00 04 54 52 41 50 01 5b 80 5c 47 42 4c 45 01  ...TRAP.[.\GBLE.
  0170: 0b 21 04 0a 01 5b 81 0c 5c 47 42 4c 45 01 45 53  .!...[..\GBLE.ES
  0180: 4d 49 08 5b 80 41 50 4d 50 01 0a b2 0a 02 5b 81  MI.[.APMP.....[.
  0190: 10 41 50 4d 50 01 41 50 4d 43 08 41 50 4d 44 08  .APMP.APMC.APMD.
  01a0: 5b 80 5c 47 50 4f 5f 01 0b 8e 04 0a 02 5b 81 3f  [.\GPO_......[.?
  01b0: 5c 47 50 4f 5f 01 47 4f 31 30 01 47 4f 31 31 01  \GPO_.GO10.GO11.
  01c0: 00 01 00 01 00 01 47 4f 31 35 01 47 4f 31 36 01  ......GO15.GO16.
  01d0: 47 4f 31 37 01 47 4f 31 38 01 47 4f 31 39 01 47  GO17.GO18.GO19.G
  01e0: 4f 31 41 01 47 4f 31 42 01 47 4f 31 43 01 5b 80  O1A.GO1B.GO1C.[.
  01f0: 5c 47 50 4f 32 01 0b b8 04 0a 02 5b 81 44 04 5c  \GPO2......[.D.\
  0200: 47 50 4f 32 01 47 4f 32 30 01 47 4f 32 31 01 47  GPO2.GO20.GO21.G
  0210: 4f 32 32 01 47 4f 32 33 01 47 4f 32 34 01 47 4f  O22.GO23.GO24.GO
  0220: 32 35 01 47 4f 32 36 01 47 4f 32 37 01 47 4f 32  25.GO26.GO27.GO2
  0230: 38 01 47 4f 32 39 01 47 4f 32 41 01 47 4f 32 42  8.GO29.GO2A.GO2B
  0240: 01 08 4f 53 46 4c 0a 01 14 41 05 53 54 52 43 02  ..OSFL...A.STRC.
  0250: a0 0a 92 93 87 68 87 69 a4 0a 00 72 87 68 0a 01  .....h.i...r.h..
  0260: 60 08 42 55 46 30 11 02 60 08 42 55 46 31 11 02  `.BUF0..`.BUF1..
  0270: 60 70 68 42 55 46 30 70 69 42 55 46 31 a2 1a 60  `phBUF0piBUF1..`
  0280: 76 60 a0 15 92 93 83 88 42 55 46 30 60 00 83 88  v`......BUF0`...
  0290: 42 55 46 31 60 00 a4 00 a4 01 5b 80 52 54 43 4d  BUF1`.....[.RTCM
  02a0: 01 0a 70 0a 02 5b 81 10 52 54 43 4d 01 43 4d 49  ..p..[..RTCM.CMI
  02b0: 4e 08 43 4d 44 41 08 5b 86 12 43 4d 49 4e 43 4d  N.CMDA.[..CMINCM
  02c0: 44 41 01 00 48 07 53 48 55 54 08 5b 80 49 4e 46  DA..H.SHUT.[.INF
  02d0: 4f 00 0c 40 f8 0f 00 0a 01 5b 81 24 49 4e 46 4f  O..@.....[.$INFO
  02e0: 01 4b 42 44 49 01 52 54 43 57 01 50 53 32 46 01  .KBDI.RTCW.PS2F.
  02f0: 49 52 46 4c 02 44 49 53 45 01 53 53 48 55 01 5b  IRFL.DISE.SSHU.[
  0300: 80 42 45 45 50 01 0a 61 0a 01 5b 81 0b 42 45 45  .BEEP..a..[..BEE
  0310: 50 01 53 31 42 5f 08 5b 80 43 4f 4e 54 01 0a 40  P.S1B_.[.CONT..@
  0320: 0a 04 5b 81 1a 43 4f 4e 54 01 43 4e 54 30 08 43  ..[..CONT.CNT0.C
  0330: 4e 54 31 08 43 4e 54 32 08 43 54 52 4c 08 14 43  NT1.CNT2.CTRL..C
  0340: 06 53 50 4b 52 01 70 53 31 42 5f 60 70 0a b6 43  .SPKR.pS1B_`p..C
  0350: 54 52 4c 70 0a 55 43 4e 54 32 70 0a 03 43 4e 54  TRLp.UCNT2p..CNT
  0360: 32 70 68 62 a2 37 94 62 0a 00 7d 53 31 42 5f 0a  2phb.7.b..}S1B_.
  0370: 03 53 31 42 5f 70 0b ff 5f 63 a2 07 94 63 0a 00  .S1B_p.._c...c..
  0380: 76 63 7b 53 31 42 5f 0a fc 53 31 42 5f 70 0b ff  vc{S1B_..S1B_p..
  0390: 0e 63 a2 07 94 63 0a 00 76 63 76 62 70 60 53 31  .c...c..vcvbp`S1
  03a0: 42 5f 10 17 5c 00 08 50 49 43 46 0a 00 14 0c 5f  B_..\..PICF...._
  03b0: 50 49 43 01 70 68 50 49 43 46 14 49 06 5c 5f 50  PIC.phPICF.I.\_P
  03c0: 54 53 01 7d 68 0a f0 60 70 60 44 42 47 31 4f 53  TS.}h..`p`DBG1OS
  03d0: 54 50 a0 0d 93 68 0a 01 70 68 60 53 41 4c 44 60  TP...h..ph`SALD`
  03e0: a0 05 93 68 0a 02 a0 0d 93 68 0a 03 70 68 60 53  ...h.....h..ph`S
  03f0: 41 4c 44 60 a0 1e 93 68 0a 05 70 45 53 4d 49 60  ALD`...h..pESMI`
  0400: 7b 60 0a fb 60 70 60 45 53 4d 49 70 68 60 53 41  {`..`p`ESMIph`SA
  0410: 4c 44 60 a0 10 93 68 0a 04 a0 0a 92 50 49 43 46  LD`...h.....PICF
  0420: 5b 22 0a 64 14 40 0b 5c 5f 57 41 4b 01 70 0a ff  [".d.@.\_WAK.p..
  0430: 44 42 47 31 53 41 4c 44 0a 00 86 5c 2f 04 5f 53  DBG1SALD...\/._S
  0440: 42 5f 50 43 49 30 50 58 34 30 55 41 52 31 0a 00  B_PCI0PX40UAR1..
  0450: a0 12 4f 53 46 4c 86 5c 2e 5f 53 42 5f 50 57 52  ..OSFL.\._SB_PWR
  0460: 42 0a 02 a1 17 a0 15 93 52 54 43 57 0a 00 86 5c  B.......RTCW...\
  0470: 2e 5f 53 42 5f 50 57 52 42 0a 02 86 5c 2f 03 5f  ._SB_PWRB...\/._
  0480: 53 42 5f 50 43 49 30 55 53 42 30 0a 00 86 5c 2f  SB_PCI0USB0...\/
  0490: 03 5f 53 42 5f 50 43 49 30 55 53 42 31 0a 00 86  ._SB_PCI0USB1...
  04a0: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 32 0a  \/._SB_PCI0USB2.
  04b0: 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42  ..\/._SB_PCI0USB
  04c0: 33 0a 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55  3...\/._SB_PCI0U
  04d0: 53 42 45 0a 00 10 1a 5c 5f 53 49 5f 14 09 5f 4d  SBE....\_SI_.._M
  04e0: 53 47 01 70 60 60 14 09 5f 53 53 54 01 70 60 60  SG.p``.._SST.p``
  04f0: 10 49 0e 5c 5f 47 50 45 14 18 5f 4c 30 35 00 86  .I.\_GPE.._L05..
  0500: 5c 2f 03 5f 53 42 5f 50 43 49 30 4d 4f 44 4d 0a  \/._SB_PCI0MODM.
  0510: 02 14 18 5f 4c 30 33 00 86 5c 2f 03 5f 53 42 5f  ..._L03..\/._SB_
  0520: 50 43 49 30 55 53 42 30 0a 02 14 18 5f 4c 30 34  PCI0USB0...._L04
  0530: 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42  ..\/._SB_PCI0USB
  0540: 31 0a 02 14 18 5f 4c 30 42 00 86 5c 2f 03 5f 53  1...._L0B..\/._S
  0550: 42 5f 50 43 49 30 48 55 42 30 0a 02 14 32 5f 4c  B_PCI0HUB0...2_L
  0560: 30 38 00 86 5c 2f 04 5f 53 42 5f 50 43 49 30 50  08..\/._SB_PCI0P
  0570: 58 34 30 55 41 52 31 0a 02 86 5c 2f 04 5f 53 42  X40UAR1...\/._SB
  0580: 5f 50 43 49 30 50 58 34 30 55 41 52 32 0a 02 14  _PCI0PX40UAR2...
  0590: 18 5f 4c 30 43 00 86 5c 2f 03 5f 53 42 5f 50 43  ._L0C..\/._SB_PC
  05a0: 49 30 55 53 42 32 0a 02 14 18 5f 4c 30 45 00 86  I0USB2...._L0E..
  05b0: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 33 0a  \/._SB_PCI0USB3.
  05c0: 02 14 18 5f 4c 30 44 00 86 5c 2f 03 5f 53 42 5f  ..._L0D..\/._SB_
  05d0: 50 43 49 30 55 53 42 45 0a 02 10 85 c9 03 5c 5f  PCI0USBE......\_
  05e0: 53 42 5f 5b 82 19 50 57 52 42 08 5f 48 49 44 0c  SB_[..PWRB._HID.
  05f0: 41 d0 0c 0c 14 09 5f 53 54 41 00 a4 0a 0b 5b 82  A....._STA....[.
  0600: 8c a3 03 50 43 49 30 08 5f 48 49 44 0c 41 d0 0a  ...PCI0._HID.A..
  0610: 03 08 5f 41 44 52 0a 00 08 5f 55 49 44 0a 01 08  .._ADR..._UID...
  0620: 5f 42 42 4e 0a 00 14 17 53 53 33 44 00 a0 0b 93  _BBN....SS3D....
  0630: 4f 53 46 4c 0a 02 a4 0a 02 a1 04 a4 0a 03 14 09  OSFL............
  0640: 5f 53 54 41 00 a4 0a 0f 14 40 0d 5f 43 52 53 00  _STA.....@._CRS.
  0650: 08 42 55 46 30 11 4c 08 0a 88 88 0d 00 02 01 00  .BUF0.L.........
  0660: 00 00 00 00 ff 00 00 00 00 01 47 01 f8 0c f8 0c  ..........G.....
  0670: 01 08 88 0d 00 01 0c 03 00 00 00 00 f7 0c 00 00  ................
  0680: f8 0c 88 0d 00 01 0c 03 00 00 00 0d ff ff 00 00  ................
  0690: 00 f3 87 17 00 00 0c 03 00 00 00 00 00 00 0a 00  ................
  06a0: ff ff 0b 00 00 00 00 00 00 00 02 00 87 17 00 00  ................
  06b0: 0c 03 00 00 00 00 00 00 0c 00 ff ff 0d 00 00 00  ................
  06c0: 00 00 00 00 02 00 87 17 00 00 0c 03 00 00 00 00  ................
  06d0: 00 00 10 00 ff ff bf fe 00 00 00 00 00 00 f0 ff  ................
  06e0: 79 00 8a 42 55 46 30 0a 76 54 43 4d 4d 8a 42 55  y..BUF0.vTCMM.BU
  06f0: 46 30 0a 82 54 4f 4d 4d 72 41 4d 45 4d 0c 00 00  F0..TOMMrAMEM...
  0700: 01 00 54 43 4d 4d 74 0c 00 00 c0 fe 54 43 4d 4d  ..TCMMt.....TCMM
  0710: 54 4f 4d 4d a4 42 55 46 30 08 50 49 43 4d 12 40  TOMM.BUF0.PICM.@
  0720: 0c 07 12 1a 04 0c ff ff 1f 00 0a 02 5c 2f 03 5f  ............\/._
  0730: 53 42 5f 50 43 49 30 4c 4e 4b 41 0a 00 12 1a 04  SB_PCI0LNKA.....
  0740: 0c ff ff 1f 00 0a 00 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  0750: 49 30 4c 4e 4b 43 0a 00 12 1a 04 0c ff ff 1f 00  I0LNKC..........
  0760: 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b  ..\/._SB_PCI0LNK
  0770: 42 0a 00 12 1a 04 0c ff ff 1d 00 0a 00 5c 2f 03  B............\/.
  0780: 5f 53 42 5f 50 43 49 30 4c 4e 4b 41 0a 00 12 1a  _SB_PCI0LNKA....
  0790: 04 0c ff ff 1d 00 0a 01 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  07a0: 43 49 30 4c 4e 4b 44 0a 00 12 1a 04 0c ff ff 1d  CI0LNKD.........
  07b0: 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e  ...\/._SB_PCI0LN
  07c0: 4b 43 0a 00 12 1a 04 0c ff ff 1d 00 0a 03 5c 2f  KC............\/
  07d0: 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 31 0a 00 08  ._SB_PCI0LNK1...
  07e0: 41 50 49 43 12 45 06 07 12 0d 04 0c ff ff 1f 00  APIC.E..........
  07f0: 0a 02 0a 00 0a 10 12 0d 04 0c ff ff 1f 00 0a 00  ................
  0800: 0a 00 0a 12 12 0d 04 0c ff ff 1f 00 0a 01 0a 00  ................
  0810: 0a 11 12 0d 04 0c ff ff 1d 00 0a 00 0a 00 0a 10  ................
  0820: 12 0d 04 0c ff ff 1d 00 0a 01 0a 00 0a 13 12 0d  ................
  0830: 04 0c ff ff 1d 00 0a 02 0a 00 0a 12 12 0d 04 0c  ................
  0840: ff ff 1d 00 0a 03 0a 00 0a 17 14 19 5f 50 52 54  ............_PRT
  0850: 00 a0 0b 92 50 49 43 46 a4 50 49 43 4d a1 06 a4  ....PICF.PICM...
  0860: 41 50 49 43 5b 82 45 57 48 55 42 30 08 5f 41 44  APIC[.EWHUB0._AD
  0870: 52 0c 00 00 1e 00 14 09 5f 53 54 41 00 a4 0a 0f  R......._STA....
  0880: 08 50 49 43 4d 12 43 36 20 12 1a 04 0c ff ff 08  .PICM.C6 .......
  0890: 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e  ...\/._SB_PCI0LN
  08a0: 4b 46 0a 00 12 1a 04 0c ff ff 08 00 0a 01 5c 2f  KF............\/
  08b0: 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 30 0a 00 12  ._SB_PCI0LNK0...
  08c0: 1a 04 0c ff ff 08 00 0a 02 5c 2f 03 5f 53 42 5f  .........\/._SB_
  08d0: 50 43 49 30 4c 4e 4b 31 0a 00 12 1a 04 0c ff ff  PCI0LNK1........
  08e0: 08 00 0a 03 5c 2f 03 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  08f0: 4e 4b 45 0a 00 12 1a 04 0c ff ff 03 00 0a 00 5c  NKE............\
  0900: 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 42 0a 00  /._SB_PCI0LNKB..
  0910: 12 1a 04 0c ff ff 03 00 0a 01 5c 2f 03 5f 53 42  ..........\/._SB
  0920: 5f 50 43 49 30 4c 4e 4b 43 0a 00 12 1a 04 0c ff  _PCI0LNKC.......
  0930: ff 03 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  0940: 4c 4e 4b 44 0a 00 12 1a 04 0c ff ff 03 00 0a 03  LNKD............
  0950: 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 41 0a  \/._SB_PCI0LNKA.
  0960: 00 12 1a 04 0c ff ff 02 00 0a 00 5c 2f 03 5f 53  ...........\/._S
  0970: 42 5f 50 43 49 30 4c 4e 4b 43 0a 00 12 1a 04 0c  B_PCI0LNKC......
  0980: ff ff 02 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  0990: 30 4c 4e 4b 44 0a 00 12 1a 04 0c ff ff 02 00 0a  0LNKD...........
  09a0: 02 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 41  .\/._SB_PCI0LNKA
  09b0: 0a 00 12 1a 04 0c ff ff 02 00 0a 03 5c 2f 03 5f  ............\/._
  09c0: 53 42 5f 50 43 49 30 4c 4e 4b 42 0a 00 12 1a 04  SB_PCI0LNKB.....
  09d0: 0c ff ff 05 00 0a 00 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  09e0: 49 30 4c 4e 4b 44 0a 00 12 1a 04 0c ff ff 05 00  I0LNKD..........
  09f0: 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b  ..\/._SB_PCI0LNK
  0a00: 41 0a 00 12 1a 04 0c ff ff 05 00 0a 02 5c 2f 03  A............\/.
  0a10: 5f 53 42 5f 50 43 49 30 4c 4e 4b 42 0a 00 12 1a  _SB_PCI0LNKB....
  0a20: 04 0c ff ff 05 00 0a 03 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  0a30: 43 49 30 4c 4e 4b 43 0a 00 12 1a 04 0c ff ff 07  CI0LNKC.........
  0a40: 00 0a 00 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e  ...\/._SB_PCI0LN
  0a50: 4b 45 0a 00 12 1a 04 0c ff ff 07 00 0a 01 5c 2f  KE............\/
  0a60: 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 46 0a 00 12  ._SB_PCI0LNKF...
  0a70: 1a 04 0c ff ff 07 00 0a 02 5c 2f 03 5f 53 42 5f  .........\/._SB_
  0a80: 50 43 49 30 4c 4e 4b 30 0a 00 12 1a 04 0c ff ff  PCI0LNK0........
  0a90: 07 00 0a 03 5c 2f 03 5f 53 42 5f 50 43 49 30 4c  ....\/._SB_PCI0L
  0aa0: 4e 4b 31 0a 00 12 1a 04 0c ff ff 09 00 0a 00 5c  NK1............\
  0ab0: 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 41 0a 00  /._SB_PCI0LNKA..
  0ac0: 12 1a 04 0c ff ff 09 00 0a 01 5c 2f 03 5f 53 42  ..........\/._SB
  0ad0: 5f 50 43 49 30 4c 4e 4b 42 0a 00 12 1a 04 0c ff  _PCI0LNKB.......
  0ae0: ff 09 00 0a 02 5c 2f 03 5f 53 42 5f 50 43 49 30  .....\/._SB_PCI0
  0af0: 4c 4e 4b 43 0a 00 12 1a 04 0c ff ff 09 00 0a 03  LNKC............
  0b00: 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 44 0a  \/._SB_PCI0LNKD.
  0b10: 00 12 1a 04 0c ff ff 0a 00 0a 00 5c 2f 03 5f 53  ...........\/._S
  0b20: 42 5f 50 43 49 30 4c 4e 4b 30 0a 00 12 1a 04 0c  B_PCI0LNK0......
  0b30: ff ff 0a 00 0a 01 5c 2f 03 5f 53 42 5f 50 43 49  ......\/._SB_PCI
  0b40: 30 4c 4e 4b 31 0a 00 12 1a 04 0c ff ff 0a 00 0a  0LNK1...........
  0b50: 02 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b 45  .\/._SB_PCI0LNKE
  0b60: 0a 00 12 1a 04 0c ff ff 0a 00 0a 03 5c 2f 03 5f  ............\/._
  0b70: 53 42 5f 50 43 49 30 4c 4e 4b 46 0a 00 12 1a 04  SB_PCI0LNKF.....
  0b80: 0c ff ff 0b 00 0a 00 5c 2f 03 5f 53 42 5f 50 43  .......\/._SB_PC
  0b90: 49 30 4c 4e 4b 31 0a 00 12 1a 04 0c ff ff 0b 00  I0LNK1..........
  0ba0: 0a 01 5c 2f 03 5f 53 42 5f 50 43 49 30 4c 4e 4b  ..\/._SB_PCI0LNK
  0bb0: 45 0a 00 12 1a 04 0c ff ff 0b 00 0a 02 5c 2f 03  E............\/.
  0bc0: 5f 53 42 5f 50 43 49 30 4c 4e 4b 46 0a 00 12 1a  _SB_PCI0LNKF....
  0bd0: 04 0c ff ff 0b 00 0a 03 5c 2f 03 5f 53 42 5f 50  ........\/._SB_P
  0be0: 43 49 30 4c 4e 4b 30 0a 00 08 41 50 49 43 12 43  CI0LNK0...APIC.C
  0bf0: 1c 20 12 0d 04 0c ff ff 08 00 0a 00 0a 00 0a 15  . ..............
  0c00: 12 0d 04 0c ff ff 08 00 0a 01 0a 00 0a 16 12 0d  ................
  0c10: 04 0c ff ff 08 00 0a 02 0a 00 0a 17 12 0d 04 0c  ................
  0c20: ff ff 08 00 0a 03 0a 00 0a 14 12 0d 04 0c ff ff  ................
  0c30: 03 00 0a 00 0a 00 0a 11 12 0d 04 0c ff ff 03 00  ................
  0c40: 0a 01 0a 00 0a 12 12 0d 04 0c ff ff 03 00 0a 02  ................
  0c50: 0a 00 0a 13 12 0d 04 0c ff ff 03 00 0a 03 0a 00  ................
  0c60: 0a 10 12 0d 04 0c ff ff 02 00 0a 00 0a 00 0a 12  ................
  0c70: 12 0d 04 0c ff ff 02 00 0a 01 0a 00 0a 13 12 0d  ................
  0c80: 04 0c ff ff 02 00 0a 02 0a 00 0a 10 12 0d 04 0c  ................
  0c90: ff ff 02 00 0a 03 0a 00 0a 11 12 0d 04 0c ff ff  ................
  0ca0: 05 00 0a 00 0a 00 0a 13 12 0d 04 0c ff ff 05 00  ................
  0cb0: 0a 01 0a 00 0a 10 12 0d 04 0c ff ff 05 00 0a 02  ................
  0cc0: 0a 00 0a 11 12 0d 04 0c ff ff 05 00 0a 03 0a 00  ................
  0cd0: 0a 12 12 0d 04 0c ff ff 07 00 0a 00 0a 00 0a 14  ................
  0ce0: 12 0d 04 0c ff ff 07 00 0a 01 0a 00 0a 15 12 0d  ................
  0cf0: 04 0c ff ff 07 00 0a 02 0a 00 0a 16 12 0d 04 0c  ................
  0d00: ff ff 07 00 0a 03 0a 00 0a 17 12 0d 04 0c ff ff  ................
  0d10: 09 00 0a 00 0a 00 0a 10 12 0d 04 0c ff ff 09 00  ................
  0d20: 0a 01 0a 00 0a 11 12 0d 04 0c ff ff 09 00 0a 02  ................
  0d30: 0a 00 0a 12 12 0d 04 0c ff ff 09 00 0a 03 0a 00  ................
  0d40: 0a 13 12 0d 04 0c ff ff 0a 00 0a 00 0a 00 0a 16  ................
  0d50: 12 0d 04 0c ff ff 0a 00 0a 01 0a 00 0a 17 12 0d  ................
  0d60: 04 0c ff ff 0a 00 0a 02 0a 00 0a 14 12 0d 04 0c  ................
  0d70: ff ff 0a 00 0a 03 0a 00 0a 15 12 0d 04 0c ff ff  ................
  0d80: 0b 00 0a 00 0a 00 0a 17 12 0d 04 0c ff ff 0b 00  ................
  0d90: 0a 01 0a 00 0a 14 12 0d 04 0c ff ff 0b 00 0a 02  ................
  0da0: 0a 00 0a 15 12 0d 04 0c ff ff 0b 00 0a 03 0a 00  ................
  0db0: 0a 16 14 19 5f 50 52 54 00 a0 0b 92 50 49 43 46  ...._PRT....PICF
  0dc0: a4 50 49 43 4d a1 06 a4 41 50 49 43 14 0e 5f 50  .PICM...APIC.._P
  0dd0: 52 57 00 a4 12 06 02 0a 0b 0a 05 5b 82 8d 73 01  RW.........[..s.
  0de0: 50 58 34 30 08 5f 41 44 52 0c 00 00 1f 00 5b 80  PX40._ADR.....[.
  0df0: 50 52 45 56 02 0a 08 0a 01 10 1f 5c 00 5b 81 1a  PREV.......\.[..
  0e00: 5c 2f 04 5f 53 42 5f 50 43 49 30 50 58 34 30 50  \/._SB_PCI0PX40P
  0e10: 52 45 56 01 52 45 56 30 08 5b 80 50 49 52 51 02  REV.REV0.[.PIRQ.
  0e20: 0a 60 0a 04 10 2e 5c 00 5b 81 29 5c 2f 04 5f 53  .`....\.[.)\/._S
  0e30: 42 5f 50 43 49 30 50 58 34 30 50 49 52 51 01 50  B_PCI0PX40PIRQ.P
  0e40: 49 52 41 08 50 49 52 42 08 50 49 52 43 08 50 49  IRA.PIRB.PIRC.PI
  0e50: 52 44 08 5b 80 50 49 52 32 02 0a 68 0a 04 10 2e  RD.[.PIR2..h....
  0e60: 5c 00 5b 81 29 5c 2f 04 5f 53 42 5f 50 43 49 30  \.[.)\/._SB_PCI0
  0e70: 50 58 34 30 50 49 52 32 01 50 49 52 45 08 50 49  PX40PIR2.PIRE.PI
  0e80: 52 46 08 50 49 52 47 08 50 49 52 48 08 5b 80 4c  RF.PIRG.PIRH.[.L
  0e90: 50 49 4f 02 0a e0 0a 0e 10 4b 26 5c 00 5b 81 4a  PIO......K&\.[.J
  0ea0: 04 5c 2f 04 5f 53 42 5f 50 43 49 30 50 58 34 30  .\/._SB_PCI0PX40
  0eb0: 4c 50 49 4f 01 55 41 49 4f 08 50 52 49 4f 08 53  LPIO.UAIO.PRIO.S
  0ec0: 4e 44 44 08 46 57 48 44 08 47 4e 31 4c 08 47 4e  NDD.FWHD.GN1L.GN
  0ed0: 31 48 08 4c 50 45 31 08 4c 50 45 32 08 00 20 47  1H.LPE1.LPE2.. G
  0ee0: 4e 32 4c 08 47 4e 32 48 08 14 4e 07 44 49 53 44  N2L.GN2H..N.DISD
  0ef0: 01 a0 10 93 68 0a 00 7b 4c 50 45 31 0a fe 4c 50  ....h..{LPE1..LP
  0f00: 45 31 a0 10 93 68 0a 01 7b 4c 50 45 31 0a fd 4c  E1...h..{LPE1..L
  0f10: 50 45 31 a0 10 93 68 0a 02 7b 4c 50 45 31 0a fb  PE1...h..{LPE1..
  0f20: 4c 50 45 31 a0 10 93 68 0a 03 7b 4c 50 45 31 0a  LPE1...h..{LPE1.
  0f30: f7 4c 50 45 31 a0 10 93 68 0a 04 7b 4c 50 45 32  .LPE1...h..{LPE2
  0f40: 0a fc 4c 50 45 32 a0 10 93 68 0a 05 7b 4c 50 45  ..LPE2...h..{LPE
  0f50: 31 0a df 4c 50 45 31 a0 10 93 68 0a 06 7b 47 4e  1..LPE1...h..{GN
  0f60: 32 4c 0a fe 47 4e 32 4c 14 4b 19 43 4b 49 4f 02  2L..GN2L.K.CKIO.
  0f70: a0 45 05 93 69 0a 00 7d 4c 50 45 31 0a 01 4c 50  .E..i..}LPE1..LP
  0f80: 45 31 7b 55 41 49 4f 0a f0 60 a0 0e 93 68 0b f8  E1{UAIO..`...h..
  0f90: 03 7d 60 0a 00 55 41 49 4f a0 0e 93 68 0b f8 02  .}`..UAIO...h...
  0fa0: 7d 60 0a 01 55 41 49 4f a0 0e 93 68 0b e8 02 7d  }`..UAIO...h...}
  0fb0: 60 0a 05 55 41 49 4f a0 0e 93 68 0b e8 03 7d 60  `..UAIO...h...}`
  0fc0: 0a 07 55 41 49 4f a0 45 05 93 69 0a 01 7d 4c 50  ..UAIO.E..i..}LP
  0fd0: 45 31 0a 02 4c 50 45 31 7b 55 41 49 4f 0a 0f 60  E1..LPE1{UAIO..`
  0fe0: a0 0e 93 68 0b f8 03 7d 60 0a 00 55 41 49 4f a0  ...h...}`..UAIO.
  0ff0: 0e 93 68 0b f8 02 7d 60 0a 10 55 41 49 4f a0 0e  ..h...}`..UAIO..
  1000: 93 68 0b e8 02 7d 60 0a 50 55 41 49 4f a0 0e 93  .h...}`.PUAIO...
  1010: 68 0b e8 03 7d 60 0a 70 55 41 49 4f a0 46 04 93  h...}`.pUAIO.F..
  1020: 69 0a 02 7d 4c 50 45 31 0a 04 4c 50 45 31 7b 50  i..}LPE1..LPE1{P
  1030: 52 49 4f 0a fc 60 a0 0e 93 68 0b 78 03 7d 60 0a  RIO..`...h.x.}`.
  1040: 00 50 52 49 4f a0 0e 93 68 0b 78 02 7d 60 0a 01  .PRIO...h.x.}`..
  1050: 50 52 49 4f a0 0e 93 68 0b bc 03 7d 60 0a 02 50  PRIO...h...}`..P
  1060: 52 49 4f a0 10 93 69 0a 03 7d 4c 50 45 31 0a 08  RIO...i..}LPE1..
  1070: 4c 50 45 31 a0 29 93 69 0a 04 a0 11 93 68 0b 01  LPE1.).i.....h..
  1080: 02 7d 4c 50 45 32 0a 01 4c 50 45 32 a0 11 93 68  .}LPE2..LPE2...h
  1090: 0b 09 02 7d 4c 50 45 32 0a 02 4c 50 45 32 a0 34  ...}LPE2..LPE2.4
  10a0: 93 69 0a 05 7d 4c 50 45 31 0a 20 4c 50 45 31 a0  .i..}LPE1. LPE1.
  10b0: 11 93 68 0b 00 03 7d 53 4e 44 44 0a 08 53 4e 44  ..h...}SNDD..SND
  10c0: 44 a0 11 93 68 0b 30 03 7b 53 4e 44 44 0a f7 53  D...h.0.{SNDD..S
  10d0: 4e 44 44 a0 30 93 69 0a 06 a0 1c 92 93 68 0b ff  NDD.0.i......h..
  10e0: ff 7b 68 0a ff 60 7d 60 0a 01 47 4e 32 4c 7a 68  .{h..`}`..GN2Lzh
  10f0: 0a 08 47 4e 32 48 a1 0d 70 00 47 4e 32 48 70 00  ..GN2H..p.GN2Hp.
  1100: 47 4e 32 4c 5b 80 4c 50 44 4d 02 0a 90 0a 02 10  GN2L[.LPDM......
  1110: 4d 0d 5c 00 5b 81 1f 5c 2f 04 5f 53 42 5f 50 43  M.\.[..\/._SB_PC
  1120: 49 30 50 58 34 30 4c 50 44 4d 01 4c 44 4d 30 08  I0PX40LPDM.LDM0.
  1130: 4c 44 4d 31 08 14 47 0b 53 4c 44 4d 02 a0 15 93  LDM1..G.SLDM....
  1140: 68 0a 00 7b 4c 44 4d 30 0a fc 60 7d 60 0a 01 4c  h..{LDM0..`}`..L
  1150: 44 4d 30 a0 15 93 68 0a 01 7b 4c 44 4d 30 0a f3  DM0...h..{LDM0..
  1160: 60 7d 60 0a 04 4c 44 4d 30 a0 15 93 68 0a 02 7b  `}`..LDM0...h..{
  1170: 4c 44 4d 30 0a cf 60 7d 60 0a 10 4c 44 4d 30 a0  LDM0..`}`..LDM0.
  1180: 15 93 68 0a 03 7b 4c 44 4d 30 0a 3f 60 7d 60 0a  ..h..{LDM0.?`}`.
  1190: 40 4c 44 4d 30 a0 15 93 69 0a 00 7b 4c 44 4d 30  @LDM0...i..{LDM0
  11a0: 0a fc 60 7d 60 0a 03 4c 44 4d 30 a0 15 93 69 0a  ..`}`..LDM0...i.
  11b0: 01 7b 4c 44 4d 30 0a f3 60 7d 60 0a 0c 4c 44 4d  .{LDM0..`}`..LDM
  11c0: 30 a0 15 93 69 0a 02 7b 4c 44 4d 30 0a cf 60 7d  0...i..{LDM0..`}
  11d0: 60 0a 30 4c 44 4d 30 a0 15 93 69 0a 03 7b 4c 44  `.0LDM0...i..{LD
  11e0: 4d 30 0a 3f 60 7d 60 0a c0 4c 44 4d 30 10 1d 5c  M0.?`}`..LDM0..\
  11f0: 00 5b 80 5c 53 43 50 50 01 0a b2 0a 01 5b 81 0c  .[.\SCPP.....[..
  1200: 5c 53 43 50 50 01 53 4d 49 50 08 14 49 07 5c 2f  \SCPP.SMIP..I.\/
  1210: 03 5f 53 42 5f 50 43 49 30 5f 49 4e 49 00 a0 24  ._SB_PCI0_INI..$
  1220: 53 54 52 43 5c 5f 4f 53 5f 0d 4d 69 63 72 6f 73  STRC\_OS_.Micros
  1230: 6f 66 74 20 57 69 6e 64 6f 77 73 00 70 0a 56 53  oft Windows.p.VS
  1240: 4d 49 50 a1 41 04 a0 2e 53 54 52 43 5c 5f 4f 53  MIP.A...STRC\_OS
  1250: 5f 0d 4d 69 63 72 6f 73 6f 66 74 20 57 69 6e 64  _.Microsoft Wind
  1260: 6f 77 73 20 4e 54 00 70 0a 58 53 4d 49 50 70 0a  ows NT.p.XSMIPp.
  1270: 00 4f 53 46 4c a1 0f 70 0a 57 53 4d 49 50 70 0a  .OSFL..p.WSMIPp.
  1280: 02 4f 53 46 4c 10 3a 5c 00 14 36 4f 53 54 50 00  .OSFL.:\..6OSTP.
  1290: a0 0f 93 4f 53 46 4c 0a 01 70 0a 56 53 4d 49 50  ...OSFL..p.VSMIP
  12a0: a0 0f 93 4f 53 46 4c 0a 02 70 0a 57 53 4d 49 50  ...OSFL..p.WSMIP
  12b0: a0 0f 93 4f 53 46 4c 0a 00 70 0a 58 53 4d 49 50  ...OSFL..p.XSMIP
  12c0: 5b 82 4b 0a 53 59 53 52 08 5f 48 49 44 0c 41 d0  [.K.SYSR._HID.A.
  12d0: 0c 02 08 5f 55 49 44 0a 01 08 5f 43 52 53 11 4e  ..._UID..._CRS.N
  12e0: 08 0a 8a 47 01 10 00 10 00 01 10 47 01 22 00 22  ...G.......G."."
  12f0: 00 01 1e 47 01 44 00 44 00 01 1c 47 01 62 00 62  ...G.D.D...G.b.b
  1300: 00 01 02 47 01 65 00 65 00 01 0b 47 01 74 00 74  ...G.e.e...G.t.t
  1310: 00 01 0c 47 01 91 00 91 00 01 03 47 01 a2 00 a2  ...G.......G....
  1320: 00 01 1e 47 01 e0 00 e0 00 01 10 47 01 78 0b 78  ...G.......G.x.x
  1330: 0b 04 04 47 01 78 0f 78 0f 04 04 47 01 78 0a 78  ...G.x.x...G.x.x
  1340: 0a 04 04 47 01 78 0e 78 0e 04 04 47 01 bc 0b bc  ...G.x.x...G....
  1350: 0b 04 04 47 01 bc 0f bc 0f 04 04 47 01 d0 04 d0  ...G.......G....
  1360: 04 01 02 47 01 94 02 94 02 01 04 79 00 5b 82 2b  ...G.......y.[.+
  1370: 50 49 43 5f 08 5f 48 49 44 0b 41 d0 08 5f 43 52  PIC_._HID.A.._CR
  1380: 53 11 18 0a 15 47 01 20 00 20 00 01 02 47 01 a0  S....G. . ...G..
  1390: 00 a0 00 01 02 22 04 00 79 00 5b 82 3d 44 4d 41  ....."..y.[.=3DDMA
  13a0: 31 08 5f 48 49 44 0c 41 d0 02 00 08 5f 43 52 53  1._HID.A...._CRS
  13b0: 11 28 0a 25 2a 10 04 47 01 00 00 00 00 01 10 47  .(.%*..G.......G
  13c0: 01 80 00 80 00 01 11 47 01 94 00 94 00 01 0c 47  .......G.......G
  13d0: 01 c0 00 c0 00 01 20 79 00 5b 82 25 54 4d 52 5f  ...... y.[.%TMR_
  13e0: 08 5f 48 49 44 0c 41 d0 01 00 08 5f 43 52 53 11  ._HID.A...._CRS.
  13f0: 10 0a 0d 47 01 40 00 40 00 01 04 22 01 00 79 00  ...G.@.@..."..y.
  1400: 5b 82 25 52 54 43 5f 08 5f 48 49 44 0c 41 d0 0b  [.%RTC_._HID.A..
  1410: 00 08 5f 43 52 53 11 10 0a 0d 47 01 70 00 70 00  .._CRS....G.p.p.
  1420: 04 04 22 00 01 79 00 5b 82 22 53 50 4b 52 08 5f  .."..y.[."SPKR._
  1430: 48 49 44 0c 41 d0 08 00 08 5f 43 52 53 11 0d 0a  HID.A...._CRS...
  1440: 0a 47 01 61 00 61 00 01 01 79 00 5b 82 25 43 4f  .G.a.a...y.[.%CO
  1450: 50 52 08 5f 48 49 44 0c 41 d0 0c 04 08 5f 43 52  PR._HID.A...._CR
  1460: 53 11 10 0a 0d 47 01 f0 00 f0 00 01 10 22 00 20  S....G.......".=20
  1470: 79 00 10 47 0f 5c 00 5b 80 57 49 4e 31 01 0a 2e  y..G.\.[.WIN1...
  1480: 0a 02 5b 81 10 57 49 4e 31 01 49 4e 44 50 08 44  ..[..WIN1.INDP.D
  1490: 41 54 41 08 5b 86 41 0b 49 4e 44 50 44 41 54 41  ATA.[.A.INDPDATA
  14a0: 01 00 10 43 46 47 5f 08 00 20 4c 44 4e 5f 08 00  ...CFG_.. LDN_..
  14b0: 40 0c 49 44 48 49 08 49 44 4c 4f 08 50 4f 57 43  @.IDHI.IDLO.POWC
  14c0: 08 00 48 06 41 43 54 52 08 00 48 17 49 4f 41 48  ..H.ACTR..H.IOAH
  14d0: 08 49 4f 41 4c 08 49 4f 32 48 08 49 4f 32 4c 08  .IOAL.IO2H.IO2L.
  14e0: 00 40 06 49 4e 54 52 08 00 08 49 4e 54 31 08 00  .@.INTR...INT1..
  14f0: 08 44 4d 43 48 08 00 48 35 43 52 45 30 08 43 52  .DMCH..H5CRE0.CR
  1500: 45 31 08 43 52 45 32 08 43 52 45 33 08 43 52 45  E1.CRE2.CRE3.CRE
  1510: 34 08 00 48 05 4f 50 54 31 08 4f 50 54 32 08 4f  4..H.OPT1.OPT2.O
  1520: 50 54 33 08 4f 50 54 34 08 4f 50 54 35 08 4f 50  PT3.OPT4.OPT5.OP
  1530: 54 36 08 4f 50 54 37 08 4f 50 54 38 08 4f 50 54  T6.OPT7.OPT8.OPT
  1540: 39 08 4f 50 54 41 08 14 14 45 4e 46 47 00 70 0a  9.OPTA...ENFG.p.
  1550: 87 49 4e 44 50 70 0a 87 49 4e 44 50 14 0d 45 58  .INDPp..INDP..EX
  1560: 46 47 00 70 0a aa 49 4e 44 50 5b 80 43 4f 4d 31  FG.p..INDP[.COM1
  1570: 01 0b f8 03 0a 08 5b 81 2e 43 4f 4d 31 01 50 33  ......[..COM1.P3
  1580: 46 38 08 50 33 46 39 08 50 33 46 41 08 50 33 46  F8.P3F9.P3FA.P3F
  1590: 42 08 50 33 46 43 08 50 33 46 44 08 50 33 46 45  B.P3FC.P3FD.P3FE
  15a0: 08 50 33 46 46 08 5b 80 43 4f 4d 32 01 0b f8 02  .P3FF.[.COM2....
  15b0: 0a 08 5b 81 2e 43 4f 4d 32 01 50 32 46 38 08 50  ..[..COM2.P2F8.P
  15c0: 32 46 39 08 50 32 46 41 08 50 32 46 42 08 50 32  2F9.P2FA.P2FB.P2
  15d0: 46 43 08 50 32 46 44 08 50 32 46 45 08 50 32 46  FC.P2FD.P2FE.P2F
  15e0: 46 08 5b 80 43 4f 4d 33 01 0b e8 03 0a 08 5b 81  F.[.COM3......[.
  15f0: 2e 43 4f 4d 33 01 50 33 45 38 08 50 33 45 39 08  .COM3.P3E8.P3E9.
  1600: 50 33 45 41 08 50 33 45 42 08 50 33 45 43 08 50  P3EA.P3EB.P3EC.P
  1610: 33 45 44 08 50 33 45 45 08 50 33 45 46 08 5b 80  3ED.P3EE.P3EF.[.
  1620: 43 4f 4d 34 01 0b e8 02 0a 08 5b 81 2e 43 4f 4d  COM4......[..COM
  1630: 34 01 50 32 45 38 08 50 32 45 39 08 50 32 45 41  4.P2E8.P2E9.P2EA
  1640: 08 50 32 45 42 08 50 32 45 43 08 50 32 45 44 08  .P2EB.P2EC.P2ED.
  1650: 50 32 45 45 08 50 32 45 46 08 14 4a 0b 49 43 4f  P2EE.P2EF..J.ICO
  1660: 4d 01 70 68 60 a0 29 93 60 0b f8 03 70 50 33 46  M.ph`.).`...pP3F
  1670: 44 60 70 50 33 46 44 60 70 0a c3 50 33 46 41 a2  D`pP3FD`p..P3FA.
  1680: 0f 92 93 50 33 46 41 0a c1 70 50 33 46 45 60 a1  ...P3FA..pP3FE`.
  1690: 45 08 a0 29 93 60 0b f8 02 70 50 32 46 44 60 70  E..).`...pP2FD`p
  16a0: 50 32 46 44 60 70 0a c3 50 32 46 41 a2 0f 92 93  P2FD`p..P2FA....
  16b0: 50 32 46 41 0a c1 70 50 32 46 45 60 a1 48 05 a0  P2FA..pP2FE`.H..
  16c0: 29 93 60 0b e8 03 70 50 33 45 44 60 70 50 33 45  ).`...pP3ED`pP3E
  16d0: 44 60 70 0a c3 50 33 45 41 a2 0f 92 93 50 33 45  D`p..P3EA....P3E
  16e0: 41 0a c1 70 50 33 45 45 60 a1 2b a0 29 93 60 0b  A..pP3EE`.+.).`.
  16f0: e8 02 70 50 32 45 44 60 70 50 32 45 44 60 70 0a  ..pP2ED`pP2ED`p.
  1700: c3 50 32 45 41 a2 0f 92 93 50 32 45 41 0a c1 70  .P2EA....P2EA..p
  1710: 50 32 45 45 60 5b 82 46 15 46 44 43 30 08 5f 48  P2EE`[.F.FDC0._H
  1720: 49 44 0c 41 d0 07 00 14 3a 5f 53 54 41 00 45 4e  ID.A....:_STA.EN
  1730: 46 47 70 00 4c 44 4e 5f a0 0c 41 43 54 52 45 58  FGp.LDN_..ACTREX
  1740: 46 47 a4 0a 0f a1 1c a0 11 91 49 4f 41 48 49 4f  FG........IOAHIO
  1750: 41 4c 45 58 46 47 a4 0a 0d a1 08 45 58 46 47 a4  ALEXFG.....EXFG.
  1760: 0a 00 14 2b 5f 44 49 53 00 45 4e 46 47 70 0a 00  ...+_DIS.ENFGp..
  1770: 4c 44 4e 5f 70 00 41 43 54 52 53 4c 44 4d 44 4d  LDN_p.ACTRSLDMDM
  1780: 43 48 0a 04 45 58 46 47 44 49 53 44 0a 03 14 41  CH..EXFGDISD...A
  1790: 06 5f 43 52 53 00 08 42 55 46 30 11 1b 0a 18 47  ._CRS..BUF0....G
  17a0: 01 f0 03 f0 03 01 06 47 01 f7 03 f7 03 01 01 22  .......G......."
  17b0: 40 00 2a 04 00 79 00 8c 42 55 46 30 0a 02 49 4f  @.*..y..BUF0..IO
  17c0: 4c 4f 8c 42 55 46 30 0a 03 49 4f 48 49 8c 42 55  LO.BUF0..IOHI.BU
  17d0: 46 30 0a 04 49 4f 52 4c 8c 42 55 46 30 0a 05 49  F0..IORL.BUF0..I
  17e0: 4f 52 48 45 4e 46 47 45 58 46 47 a4 42 55 46 30  ORHENFGEXFG.BUF0
  17f0: 08 5f 50 52 53 11 1d 0a 1a 30 47 01 f0 03 f0 03  ._PRS....0G.....
  1800: 01 06 47 01 f7 03 f7 03 01 01 22 40 00 2a 04 00  ..G......."@.*..
  1810: 38 79 00 14 49 05 5f 53 52 53 01 8c 68 0a 02 49  8y..I._SRS..h..I
  1820: 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a 02 49  OLO.h..IOHI.h..I
  1830: 4f 41 44 8b 68 0a 19 49 52 51 4c 8c 68 0a 1c 44  OAD.h..IRQL.h..D
  1840: 4d 41 56 45 4e 46 47 70 00 4c 44 4e 5f 70 01 41  MAVENFGp.LDN_p.A
  1850: 43 54 52 53 4c 44 4d 44 4d 43 48 44 4d 43 48 45  CTRSLDMDMCHDMCHE
  1860: 58 46 47 43 4b 49 4f 49 4f 41 44 0a 03 5b 82 46  XFGCKIOIOAD..[.F
  1870: 1b 55 41 52 31 08 5f 48 49 44 0c 41 d0 05 01 08  .UAR1._HID.A....
  1880: 5f 55 49 44 0a 01 14 3f 5f 53 54 41 00 45 4e 46  _UID...?_STA.ENF
  1890: 47 70 0a 02 4c 44 4e 5f a0 0c 41 43 54 52 45 58  Gp..LDN_..ACTREX
  18a0: 46 47 a4 0a 0f a1 1c a0 11 91 49 4f 41 48 49 4f  FG........IOAHIO
  18b0: 41 4c 45 58 46 47 a4 0a 0d a1 08 45 58 46 47 a4  ALEXFG.....EXFG.
  18c0: 0a 00 45 58 46 47 14 21 5f 44 49 53 00 45 4e 46  ..EXFG.!_DIS.ENF
  18d0: 47 70 0a 02 4c 44 4e 5f 70 00 41 43 54 52 45 58  Gp..LDN_p.ACTREX
  18e0: 46 47 44 49 53 44 0a 00 14 49 09 5f 43 52 53 00  FGDISD...I._CRS.
  18f0: 08 42 55 46 31 11 10 0a 0d 47 01 00 00 00 00 01  .BUF1....G......
  1900: 08 22 00 00 79 00 8c 42 55 46 31 0a 02 49 4f 4c  ."..y..BUF1..IOL
  1910: 4f 8c 42 55 46 31 0a 03 49 4f 48 49 8c 42 55 46  O.BUF1..IOHI.BUF
  1920: 31 0a 04 49 4f 52 4c 8c 42 55 46 31 0a 05 49 4f  1..IORL.BUF1..IO
  1930: 52 48 8b 42 55 46 31 0a 09 49 52 51 57 45 4e 46  RH.BUF1..IRQWENF
  1940: 47 70 0a 02 4c 44 4e 5f 70 49 4f 41 4c 49 4f 4c  Gp..LDN_pIOALIOL
  1950: 4f 70 49 4f 41 4c 49 4f 52 4c 70 49 4f 41 48 49  OpIOALIORLpIOAHI
  1960: 4f 48 49 70 49 4f 41 48 49 4f 52 48 70 01 60 79  OHIpIOAHIORHp.`y
  1970: 60 49 4e 54 52 49 52 51 57 45 58 46 47 a4 42 55  `INTRIRQWEXFG.BU
  1980: 46 31 08 5f 50 52 53 11 36 0a 33 30 47 01 f8 03  F1._PRS.6.30G...
  1990: f8 03 01 08 22 b8 1e 30 47 01 f8 02 f8 02 01 08  ...."..0G.......
  19a0: 22 b8 1e 30 47 01 e8 03 e8 03 01 08 22 b8 1e 30  "..0G......."..0
  19b0: 47 01 e8 02 e8 02 01 08 22 b8 1e 38 79 00 14 46  G......."..8y..F
  19c0: 06 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68  ._SRS..h..IOLO.h
  19d0: 0a 03 49 4f 48 49 8b 68 0a 02 49 4f 41 44 8b 68  ..IOHI.h..IOAD.h
  19e0: 0a 09 49 52 51 57 45 4e 46 47 70 0a 02 4c 44 4e  ..IRQWENFGp..LDN
  19f0: 5f 70 01 41 43 54 52 70 49 4f 4c 4f 49 4f 41 4c  _p.ACTRpIOLOIOAL
  1a00: 70 49 4f 48 49 49 4f 41 48 82 49 52 51 57 60 74  pIOHIIOAH.IRQW`t
  1a10: 60 0a 01 49 4e 54 52 45 58 46 47 43 4b 49 4f 49  `..INTREXFGCKIOI
  1a20: 4f 41 44 0a 00 5b 82 49 1d 55 41 52 32 08 5f 48  OAD..[.I.UAR2._H
  1a30: 49 44 0c 41 d0 05 01 08 5f 55 49 44 0a 02 14 44  ID.A...._UID...D
  1a40: 05 5f 53 54 41 00 45 4e 46 47 70 0a 03 4c 44 4e  ._STA.ENFGp..LDN
  1a50: 5f 7b 4f 50 54 32 0a 30 60 a0 30 92 93 60 0a 10  _{OPT2.0`.0..`..
  1a60: a0 0c 41 43 54 52 45 58 46 47 a4 0a 0f a1 1c a0  ..ACTREXFG......
  1a70: 11 91 49 4f 41 48 49 4f 41 4c 45 58 46 47 a4 0a  ..IOAHIOALEXFG..
  1a80: 0d a1 08 45 58 46 47 a4 0a 00 a1 08 45 58 46 47  ...EXFG.....EXFG
  1a90: a4 0a 00 14 2f 5f 44 49 53 00 45 4e 46 47 70 0a  ..../_DIS.ENFGp.
  1aa0: 03 4c 44 4e 5f 7b 4f 50 54 32 0a 38 60 a0 0b 93  .LDN_{OPT2.8`...
  1ab0: 60 0a 00 70 00 41 43 54 52 45 58 46 47 44 49 53  `..p.ACTREXFGDIS
  1ac0: 44 0a 01 14 49 09 5f 43 52 53 00 08 42 55 46 32  D...I._CRS..BUF2
  1ad0: 11 10 0a 0d 47 01 00 00 00 00 01 08 22 10 00 79  ....G......."..y
  1ae0: 00 8c 42 55 46 32 0a 02 49 4f 4c 4f 8c 42 55 46  ..BUF2..IOLO.BUF
  1af0: 32 0a 03 49 4f 48 49 8c 42 55 46 32 0a 04 49 4f  2..IOHI.BUF2..IO
  1b00: 52 4c 8c 42 55 46 32 0a 05 49 4f 52 48 8b 42 55  RL.BUF2..IORH.BU
  1b10: 46 32 0a 09 49 52 51 57 45 4e 46 47 70 0a 03 4c  F2..IRQWENFGp..L
  1b20: 44 4e 5f 70 49 4f 41 4c 49 4f 4c 4f 70 49 4f 41  DN_pIOALIOLOpIOA
  1b30: 4c 49 4f 52 4c 70 49 4f 41 48 49 4f 48 49 70 49  LIORLpIOAHIOHIpI
  1b40: 4f 41 48 49 4f 52 48 70 01 60 79 60 49 4e 54 52  OAHIORHp.`y`INTR
  1b50: 49 52 51 57 45 58 46 47 a4 42 55 46 32 08 5f 50  IRQWEXFG.BUF2._P
  1b60: 52 53 11 36 0a 33 30 47 01 f8 03 f8 03 01 08 22  RS.6.30G......."
  1b70: b8 1e 30 47 01 f8 02 f8 02 01 08 22 b8 1e 30 47  ..0G......."..0G
  1b80: 01 e8 03 e8 03 01 08 22 b8 1e 30 47 01 e8 02 e8  ......."..0G....
  1b90: 02 01 08 22 b8 1e 38 79 00 14 46 06 5f 53 52 53  ..."..8y..F._SRS
  1ba0: 01 8c 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48  ..h..IOLO.h..IOH
  1bb0: 49 8b 68 0a 02 49 4f 41 44 8b 68 0a 09 49 52 51  I.h..IOAD.h..IRQ
  1bc0: 57 45 4e 46 47 70 0a 03 4c 44 4e 5f 70 01 41 43  WENFGp..LDN_p.AC
  1bd0: 54 52 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49  TRpIOLOIOALpIOHI
  1be0: 49 4f 41 48 82 49 52 51 57 60 74 60 0a 01 49 4e  IOAH.IRQW`t`..IN
  1bf0: 54 52 45 58 46 47 43 4b 49 4f 49 4f 41 44 0a 01  TREXFGCKIOIOAD..
  1c00: 5b 82 4c 1d 49 52 44 41 08 5f 48 49 44 0c 41 d0  [.L.IRDA._HID.A.
  1c10: 05 10 14 43 05 5f 53 54 41 00 45 4e 46 47 70 0a  ...C._STA.ENFGp.
  1c20: 03 4c 44 4e 5f 7b 4f 50 54 32 0a 30 60 a0 2f 93  .LDN_{OPT2.0`./.
  1c30: 60 0a 10 a0 0c 41 43 54 52 45 58 46 47 a4 0a 0f  `....ACTREXFG...
  1c40: a1 1c a0 11 91 49 4f 41 48 49 4f 41 4c 45 58 46  .....IOAHIOALEXF
  1c50: 47 a4 0a 0d a1 08 45 58 46 47 a4 0a 00 a1 08 45  G.....EXFG.....E
  1c60: 58 46 47 a4 0a 00 14 3c 5f 44 49 53 00 a0 32 93  XFG....<_DIS..2.
  1c70: 44 49 53 45 0a 01 45 4e 46 47 70 0a 03 4c 44 4e  DISE..ENFGp..LDN
  1c80: 5f 7b 4f 50 54 32 0a 38 60 a0 0c 92 93 60 0a 00  _{OPT2.8`....`..
  1c90: 70 00 41 43 54 52 45 58 46 47 44 49 53 44 0a 01  p.ACTREXFGDISD..
  1ca0: 70 60 60 14 47 09 5f 43 52 53 00 08 42 55 46 34  p``.G._CRS..BUF4
  1cb0: 11 10 0a 0d 47 01 00 00 00 00 01 08 22 00 00 79  ....G......."..y
  1cc0: 00 8c 42 55 46 34 0a 02 49 4f 4c 4f 8c 42 55 46  ..BUF4..IOLO.BUF
  1cd0: 34 0a 03 49 4f 48 49 8c 42 55 46 34 0a 04 49 4f  4..IOHI.BUF4..IO
  1ce0: 52 4c 8c 42 55 46 34 0a 05 49 4f 52 48 8b 42 55  RL.BUF4..IORH.BU
  1cf0: 46 34 0a 09 49 52 51 57 45 4e 46 47 70 0a 03 4c  F4..IRQWENFGp..L
  1d00: 44 4e 5f 70 49 4f 41 4c 49 4f 4c 4f 70 49 4f 41  DN_pIOALIOLOpIOA
  1d10: 4c 49 4f 52 4c 70 49 4f 41 48 49 4f 48 49 70 49  LIORLpIOAHIOHIpI
  1d20: 4f 41 48 49 4f 52 48 79 0a 01 49 4e 54 52 49 52  OAHIORHy..INTRIR
  1d30: 51 57 45 58 46 47 a4 42 55 46 34 08 5f 50 52 53  QWEXFG.BUF4._PRS
  1d40: 11 36 0a 33 30 47 01 f8 03 f8 03 01 08 22 b8 1e  .6.30G......."..
  1d50: 30 47 01 f8 02 f8 02 01 08 22 b8 1e 30 47 01 e8  0G......."..0G..
  1d60: 03 e8 03 01 08 22 b8 1e 30 47 01 e8 02 e8 02 01  ....."..0G......
  1d70: 08 22 b8 1e 38 79 00 14 46 06 5f 53 52 53 01 8c  ."..8y..F._SRS..
  1d80: 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b  h..IOLO.h..IOHI.
  1d90: 68 0a 02 49 4f 41 44 8b 68 0a 09 49 52 51 57 45  h..IOAD.h..IRQWE
  1da0: 4e 46 47 70 0a 03 4c 44 4e 5f 70 01 41 43 54 52  NFGp..LDN_p.ACTR
  1db0: 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f 48 49 49 4f  pIOLOIOALpIOHIIO
  1dc0: 41 48 82 49 52 51 57 60 74 60 0a 01 49 4e 54 52  AH.IRQW`t`..INTR
  1dd0: 45 58 46 47 43 4b 49 4f 49 4f 41 44 0a 01 5b 82  EXFGCKIOIOAD..[.
  1de0: 4d 26 4c 50 54 31 08 5f 48 49 44 0c 41 d0 04 00  M&LPT1._HID.A...
  1df0: 14 44 05 5f 53 54 41 00 45 4e 46 47 70 0a 01 4c  .D._STA.ENFGp..L
  1e00: 44 4e 5f 7b 4f 50 54 31 0a 02 60 a0 30 92 93 60  DN_{OPT1..`.0..`
  1e10: 0a 02 a0 0c 41 43 54 52 45 58 46 47 a4 0a 0f a1  ....ACTREXFG....
  1e20: 1c a0 11 91 49 4f 41 48 49 4f 41 4c 45 58 46 47  ....IOAHIOALEXFG
  1e30: a4 0a 0d a1 08 45 58 46 47 a4 0a 00 a1 08 45 58  .....EXFG.....EX
  1e40: 46 47 a4 0a 00 14 21 5f 44 49 53 00 45 4e 46 47  FG....!_DIS.ENFG
  1e50: 70 0a 01 4c 44 4e 5f 70 00 41 43 54 52 45 58 46  p..LDN_p.ACTREXF
  1e60: 47 44 49 53 44 0a 02 14 42 12 5f 43 52 53 00 08  GDISD...B._CRS..
  1e70: 42 55 46 35 11 18 0a 15 47 01 00 00 00 00 01 08  BUF5....G.......
  1e80: 47 01 00 00 00 00 01 04 22 00 00 79 00 8c 42 55  G......."..y..BU
  1e90: 46 35 0a 02 49 4f 4c 4f 8c 42 55 46 35 0a 03 49  F5..IOLO.BUF5..I
  1ea0: 4f 48 49 8c 42 55 46 35 0a 04 49 4f 52 4c 8c 42  OHI.BUF5..IORL.B
  1eb0: 55 46 35 0a 05 49 4f 52 48 8c 42 55 46 35 0a 07  UF5..IORH.BUF5..
  1ec0: 49 4f 4c 45 8c 42 55 46 35 0a 0a 49 4f 32 31 8c  IOLE.BUF5..IO21.
  1ed0: 42 55 46 35 0a 0b 49 4f 32 32 8c 42 55 46 35 0a  BUF5..IO22.BUF5.
  1ee0: 0c 49 4f 32 33 8c 42 55 46 35 0a 0d 49 4f 32 34  .IO23.BUF5..IO24
  1ef0: 8b 42 55 46 35 0a 11 49 52 51 57 45 4e 46 47 70  .BUF5..IRQWENFGp
  1f00: 0a 01 4c 44 4e 5f 70 49 4f 41 4c 49 4f 4c 4f 70  ..LDN_pIOALIOLOp
  1f10: 49 4f 4c 4f 49 4f 52 4c 70 49 4f 41 48 49 4f 48  IOLOIORLpIOAHIOH
  1f20: 49 70 49 4f 48 49 49 4f 52 48 70 49 4f 41 4c 49  IpIOHIIORHpIOALI
  1f30: 4f 32 31 70 49 4f 41 4c 49 4f 32 33 72 49 4f 41  O21pIOALIO23rIOA
  1f40: 48 0a 04 49 4f 32 32 72 49 4f 41 48 0a 04 49 4f  H..IO22rIOAH..IO
  1f50: 32 34 a0 0f 93 49 4f 4c 4f 0a bc 70 0a 04 49 4f  24...IOLO..p..IO
  1f60: 4c 45 a1 08 70 0a 08 49 4f 4c 45 70 01 60 70 49  LE..p..IOLEp.`pI
  1f70: 4e 54 52 65 79 60 65 49 52 51 57 70 01 41 43 54  NTRey`eIRQWp.ACT
  1f80: 52 45 58 46 47 a4 42 55 46 35 08 5f 50 52 53 11  REXFG.BUF5._PRS.
  1f90: 43 04 0a 3f 30 47 01 78 03 78 03 01 08 47 01 78  C..?0G.x.x...G.x
  1fa0: 07 78 07 01 04 22 b8 1e 30 47 01 78 02 78 02 01  .x..."..0G.x.x..
  1fb0: 08 47 01 78 06 78 06 01 04 22 b8 1e 30 47 01 bc  .G.x.x..."..0G..
  1fc0: 03 bc 03 01 04 47 01 bc 07 bc 07 01 04 22 b8 1e  .....G......."..
  1fd0: 38 79 00 14 49 07 5f 53 52 53 01 8c 68 0a 02 49  8y..I._SRS..h..I
  1fe0: 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a 02 49  OLO.h..IOHI.h..I
  1ff0: 4f 41 44 8c 68 0a 04 49 4f 52 4c 8c 68 0a 05 49  OAD.h..IORL.h..I
  2000: 4f 52 48 8b 68 0a 11 49 52 51 57 45 4e 46 47 70  ORH.h..IRQWENFGp
  2010: 0a 01 4c 44 4e 5f 70 01 41 43 54 52 70 49 4f 4c  ..LDN_p.ACTRpIOL
  2020: 4f 49 4f 41 4c 70 49 4f 48 49 49 4f 41 48 81 49  OIOALpIOHIIOAH.I
  2030: 52 51 57 60 74 60 0a 01 60 70 60 49 4e 54 52 45  RQW`t`..`p`INTRE
  2040: 58 46 47 43 4b 49 4f 49 4f 41 44 0a 02 5b 82 43  XFGCKIOIOAD..[.C
  2050: 2b 45 43 50 31 08 5f 48 49 44 0c 41 d0 04 01 14  +ECP1._HID.A....
  2060: 43 05 5f 53 54 41 00 45 4e 46 47 70 0a 01 4c 44  C._STA.ENFGp..LD
  2070: 4e 5f 7b 4f 50 54 31 0a 02 60 a0 2f 93 60 0a 02  N_{OPT1..`./.`..
  2080: a0 0c 41 43 54 52 45 58 46 47 a4 0a 0f a1 1c a0  ..ACTREXFG......
  2090: 11 91 49 4f 41 48 49 4f 41 4c 45 58 46 47 a4 0a  ..IOAHIOALEXFG..
  20a0: 0d a1 08 45 58 46 47 a4 0a 00 a1 08 45 58 46 47  ...EXFG.....EXFG
  20b0: a4 0a 00 14 2b 5f 44 49 53 00 45 4e 46 47 70 0a  ....+_DIS.ENFGp.
  20c0: 01 4c 44 4e 5f 70 00 41 43 54 52 53 4c 44 4d 44  .LDN_p.ACTRSLDMD
  20d0: 4d 43 48 0a 04 45 58 46 47 44 49 53 44 0a 02 14  MCH..EXFGDISD...
  20e0: 41 14 5f 43 52 53 00 08 42 55 46 36 11 1b 0a 18  A._CRS..BUF6....
  20f0: 47 01 00 00 00 00 01 08 47 01 00 00 00 00 01 04  G.......G.......
  2100: 22 00 00 2a 00 00 79 00 8c 42 55 46 36 0a 02 49  "..*..y..BUF6..I
  2110: 4f 4c 4f 8c 42 55 46 36 0a 03 49 4f 48 49 8c 42  OLO.BUF6..IOHI.B
  2120: 55 46 36 0a 04 49 4f 52 4c 8c 42 55 46 36 0a 05  UF6..IORL.BUF6..
  2130: 49 4f 52 48 8c 42 55 46 36 0a 0a 49 4f 45 4c 8c  IORH.BUF6..IOEL.
  2140: 42 55 46 36 0a 0b 49 4f 45 48 8c 42 55 46 36 0a  BUF6..IOEH.BUF6.
  2150: 0c 49 4f 4d 4c 8c 42 55 46 36 0a 0d 49 4f 4d 48  .IOML.BUF6..IOMH
  2160: 8c 42 55 46 36 0a 07 49 4f 4c 45 8b 42 55 46 36  .BUF6..IOLE.BUF6
  2170: 0a 11 49 52 51 57 8c 42 55 46 36 0a 14 44 4d 41  ..IRQW.BUF6..DMA
  2180: 43 45 4e 46 47 70 0a 01 4c 44 4e 5f 70 01 41 43  CENFGp..LDN_p.AC
  2190: 54 52 70 49 4f 41 4c 62 70 62 49 4f 4c 4f 70 49  TRpIOALbpbIOLOpI
  21a0: 4f 41 48 63 70 63 49 4f 48 49 7d 63 0a 04 63 70  OAHcpcIOHI}c..cp
  21b0: 63 49 4f 45 48 70 63 49 4f 4d 48 70 49 4f 4c 4f  cIOEHpcIOMHpIOLO
  21c0: 49 4f 52 4c 70 49 4f 4c 4f 49 4f 45 4c 70 49 4f  IORLpIOLOIOELpIO
  21d0: 4c 4f 49 4f 4d 4c 70 49 4f 48 49 49 4f 52 48 a0  LOIOMLpIOHIIORH.
  21e0: 0f 93 49 4f 4c 4f 0a bc 70 0a 04 49 4f 4c 45 a1  ..IOLO..p..IOLE.
  21f0: 08 70 0a 08 49 4f 4c 45 70 01 60 70 49 4e 54 52  .p..IOLEp.`pINTR
  2200: 65 79 60 65 49 52 51 57 70 01 60 70 44 4d 43 48  ey`eIRQWp.`pDMCH
  2210: 65 79 60 65 44 4d 41 43 45 58 46 47 a4 42 55 46  ey`eDMACEXFG.BUF
  2220: 36 08 5f 50 52 53 11 4c 04 0a 48 30 47 01 78 03  6._PRS.L..H0G.x.
  2230: 78 03 01 08 47 01 78 07 78 07 01 04 22 b8 1e 2a  x...G.x.x..."..*
  2240: 0b 00 30 47 01 78 02 78 02 01 08 47 01 78 06 78  ..0G.x.x...G.x.x
  2250: 06 01 04 22 b8 1e 2a 0b 00 30 47 01 bc 03 bc 03  ..."..*..0G.....
  2260: 01 04 47 01 bc 07 bc 07 01 04 22 b8 1e 2a 0b 00  ..G......."..*..
  2270: 38 79 00 14 4e 08 5f 53 52 53 01 8c 68 0a 02 49  8y..N._SRS..h..I
  2280: 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a 02 49  OLO.h..IOHI.h..I
  2290: 4f 41 44 8b 68 0a 11 49 52 51 57 8c 68 0a 14 44  OAD.h..IRQW.h..D
  22a0: 4d 41 43 45 4e 46 47 70 0a 01 4c 44 4e 5f 70 01  MACENFGp..LDN_p.
  22b0: 41 43 54 52 70 49 4f 4c 4f 49 4f 41 4c 70 49 4f  ACTRpIOLOIOALpIO
  22c0: 48 49 49 4f 41 48 81 49 52 51 57 60 74 60 0a 01  HIIOAH.IRQW`t`..
  22d0: 60 70 60 49 4e 54 52 81 44 4d 41 43 61 70 44 4d  `p`INTR.DMACapDM
  22e0: 43 48 60 74 61 0a 01 44 4d 43 48 53 4c 44 4d 60  CH`ta..DMCHSLDM`
  22f0: 44 4d 43 48 45 58 46 47 43 4b 49 4f 49 4f 41 44  DMCHEXFGCKIOIOAD
  2300: 0a 02 5b 80 4b 42 43 54 01 0a 60 0a 05 5b 81 12  ..[.KBCT..`..[..
  2310: 4b 42 43 54 01 50 30 36 30 08 00 18 50 30 36 34  KBCT.P060...P064
  2320: 08 5b 82 4f 08 50 53 32 4d 08 5f 48 49 44 0c 41  .[.O.PS2M._HID.A
  2330: d0 0f 13 14 17 5f 53 54 41 00 a0 0b 93 50 53 32  ....._STA....PS2
  2340: 46 0a 00 a4 0a 0f a1 04 a4 0a 00 14 46 06 5f 43  F...........F._C
  2350: 52 53 00 08 42 55 46 31 11 08 0a 05 22 00 10 79  RS..BUF1...."..y
  2360: 00 08 42 55 46 32 11 18 0a 15 47 01 60 00 60 00  ..BUF2....G.`.`.
  2370: 01 01 47 01 64 00 64 00 01 01 22 00 10 79 00 a0  ..G.d.d..."..y..
  2380: 2b 93 4b 42 44 49 0a 01 a0 0d 93 4f 53 46 4c 0a  +.KBDI.....OSFL.
  2390: 02 a4 42 55 46 31 a0 0d 93 4f 53 46 4c 0a 01 a4  ..BUF1...OSFL...
  23a0: 42 55 46 31 a1 06 a4 42 55 46 32 a1 06 a4 42 55  BUF1...BUF2...BU
  23b0: 46 31 5b 82 40 05 50 53 32 4b 08 5f 48 49 44 0c  F1[.@.PS2K._HID.
  23c0: 41 d0 03 03 08 5f 43 49 44 0c 41 d0 03 0b 14 17  A...._CID.A.....
  23d0: 5f 53 54 41 00 a0 0b 93 4b 42 44 49 0a 01 a4 0a  _STA....KBDI....
  23e0: 00 a1 04 a4 0a 0f 08 5f 43 52 53 11 18 0a 15 47  ......._CRS....G
  23f0: 01 60 00 60 00 01 01 47 01 64 00 64 00 01 01 22  .`.`...G.d.d..."
  2400: 02 00 79 00 5b 82 4c 06 50 53 4d 52 08 5f 48 49  ..y.[.L.PSMR._HI
  2410: 44 0c 41 d0 0c 02 08 5f 55 49 44 0a 03 14 39 5f  D.A...._UID...9_
  2420: 53 54 41 00 a0 0b 93 4b 42 44 49 0a 00 a4 0a 00  STA....KBDI.....
  2430: a0 23 93 50 53 32 46 0a 00 a0 0b 93 4f 53 46 4c  .#.PS2F.....OSFL
  2440: 0a 02 a4 0a 0f a0 0b 93 4f 53 46 4c 0a 01 a4 0a  ........OSFL....
  2450: 0f a4 0a 00 a4 0a 0f 08 5f 43 52 53 11 15 0a 12  ........_CRS....
  2460: 47 01 60 00 60 00 01 01 47 01 64 00 64 00 01 01  G.`.`...G.d.d...
  2470: 79 00 10 47 04 5c 00 14 42 04 53 41 4c 44 01 a0  y..G.\..B.SALD..
  2480: 09 93 68 0a 00 70 0a 00 60 a0 09 93 68 0a 01 70  ..h..p..`...h..p
  2490: 0a 80 60 a0 09 93 68 0a 03 70 0a c0 60 a0 0b 93  ..`...h..p..`...
  24a0: 68 0a 04 7f 0a 00 0a 40 60 a0 0b 93 68 0a 05 7f  h......@`...h...
  24b0: 0a 00 0a 40 60 53 4c 45 44 60 10 28 5c 00 14 24  ...@`SLED`.(\..$
  24c0: 53 4c 45 44 01 45 4e 46 47 70 0a 09 4c 44 4e 5f  SLED.ENFGp..LDN_
  24d0: 7b 4f 50 54 34 0a 3f 60 7d 60 68 4f 50 54 34 45  {OPT4.?`}`hOPT4E
  24e0: 58 46 47 5b 82 35 50 4d 49 4f 08 5f 48 49 44 0c  XFG[.5PMIO._HID.
  24f0: 41 d0 0c 02 08 5f 55 49 44 0a 02 14 1e 5f 43 52  A...._UID...._CR
  2500: 53 00 08 42 55 46 30 11 0d 0a 0a 47 01 00 04 00  S..BUF0....G....
  2510: 04 01 c0 79 00 a4 42 55 46 30 5b 82 31 55 53 42  ...y..BUF0[.1USB
  2520: 30 08 5f 41 44 52 0c 00 00 1d 00 14 15 53 53 33  0._ADR.......SS3
  2530: 44 00 a0 0b 93 4f 53 46 4c 0a 02 a4 0a 02 a4 0a  D....OSFL.......
  2540: 03 08 5f 50 52 57 12 06 02 0a 03 0a 01 5b 82 31  .._PRW.......[.1
  2550: 55 53 42 31 08 5f 41 44 52 0c 01 00 1d 00 14 15  USB1._ADR.......
  2560: 53 53 33 44 00 a0 0b 93 4f 53 46 4c 0a 02 a4 0a  SS3D....OSFL....
  2570: 02 a4 0a 03 08 5f 50 52 57 12 06 02 0a 04 0a 01  ....._PRW.......
  2580: 5b 82 31 55 53 42 32 08 5f 41 44 52 0c 02 00 1d  [.1USB2._ADR....
  2590: 00 14 15 53 53 33 44 00 a0 0b 93 4f 53 46 4c 0a  ...SS3D....OSFL.
  25a0: 02 a4 0a 02 a4 0a 03 08 5f 50 52 57 12 06 02 0a  ........_PRW....
  25b0: 0c 0a 01 5b 82 31 55 53 42 33 08 5f 41 44 52 0c  ...[.1USB3._ADR.
  25c0: 03 00 1d 00 14 15 53 53 33 44 00 a0 0b 93 4f 53  ......SS3D....OS
  25d0: 46 4c 0a 02 a4 0a 02 a4 0a 03 08 5f 50 52 57 12  FL........._PRW.
  25e0: 06 02 0a 0e 0a 01 5b 82 31 55 53 42 45 08 5f 41  ......[.1USBE._A
  25f0: 44 52 0c 07 00 1d 00 14 15 53 53 33 44 00 a0 0b  DR.......SS3D...
  2600: 93 4f 53 46 4c 0a 02 a4 0a 02 a4 0a 03 08 5f 50  .OSFL........._P
  2610: 52 57 12 06 02 0a 0d 0a 01 5b 82 41 98 49 43 48  RW.......[.A.ICH
  2620: 58 08 5f 41 44 52 0c 01 00 1f 00 5b 80 50 43 49  X._ADR.....[.PCI
  2630: 5f 02 0a 40 0a 20 5b 81 43 05 50 43 49 5f 03 49  _..@. [.C.PCI_.I
  2640: 54 4d 30 10 49 54 4d 31 10 53 49 54 30 04 53 49  TM0.ITM1.SIT0.SI
  2650: 54 31 04 00 18 55 44 43 30 02 55 44 43 31 02 00  T1...UDC0.UDC1..
  2660: 0c 55 44 54 30 08 55 44 54 31 08 00 40 04 49 43  .UDT0.UDT1..@.IC
  2670: 46 30 02 49 43 46 31 02 00 06 57 50 50 45 01 00  F0.ICF1...WPPE..
  2680: 01 46 41 53 30 02 46 41 53 31 02 14 47 1c 47 54  .FAS0.FAS1..G.GT
  2690: 4d 5f 06 70 11 03 0a 14 60 8a 60 0a 00 50 49 4f  M_.p....`.`..PIO
  26a0: 30 8a 60 0a 04 44 4d 41 30 8a 60 0a 08 50 49 4f  0.`..DMA0.`..PIO
  26b0: 31 8a 60 0a 0c 44 4d 41 31 8a 60 0a 10 46 4c 41  1.`..DMA1.`..FLA
  26c0: 47 70 0a 10 46 4c 41 47 a0 15 91 7b 68 0a 08 00  Gp..FLAG...{h...
  26d0: 92 7b 68 0a 01 00 70 0b 84 03 50 49 4f 30 a1 23  .{h...p...PIO0.#
  26e0: 72 7a 7b 68 0b 00 03 00 0a 08 00 7a 7b 68 0b 00  rz{h.......z{h..
  26f0: 30 00 0a 0c 00 61 77 74 0a 09 61 00 0a 1e 50 49  0....awt..a...PI
  2700: 4f 30 a0 3f 91 90 68 0b 00 40 90 6a 0a 01 a0 15  O0.?..h..@.j....
  2710: 91 7b 68 0a 80 00 92 7b 68 0a 10 00 70 0b 84 03  .{h....{h...p...
  2720: 50 49 4f 31 a1 1d 72 7b 69 0a 03 00 7a 7b 69 0a  PIO1..r{i...z{i.
  2730: 0c 00 0a 02 00 61 77 74 0a 09 61 00 0a 1e 50 49  .....awt..a...PI
  2740: 4f 31 a1 0a 70 50 49 4f 30 50 49 4f 31 a0 38 7b  O1..pPIO0PIO1.8{
  2750: 6a 0a 01 00 74 0a 04 7b 6b 0a 03 00 61 a0 0d 7b  j...t..{k...a..{
  2760: 6d 0a 01 00 70 0a 14 44 4d 41 30 a1 1a a0 0e 7b  m...p..DMA0....{
  2770: 6c 0a 01 00 77 61 0a 0f 44 4d 41 30 a1 09 77 61  l...wa..DMA0..wa
  2780: 0a 1e 44 4d 41 30 a1 0a 70 50 49 4f 30 44 4d 41  ..DMA0..pPIO0DMA
  2790: 30 a0 44 05 91 90 68 0b 00 40 90 6a 0a 01 a0 3c  0.D...h..@.j...<
  27a0: 7b 6a 0a 02 00 74 0a 04 7a 7b 6b 0a 30 00 0a 04  {j...t..z{k.0...
  27b0: 00 61 a0 0d 7b 6d 0a 02 00 70 0a 14 44 4d 41 31  .a..{m...p..DMA1
  27c0: a1 1a a0 0e 7b 6c 0a 02 00 77 61 0a 0f 44 4d 41  ....{l...wa..DMA
  27d0: 31 a1 09 77 61 0a 1e 44 4d 41 31 a1 0a 70 50 49  1..wa..DMA1..pPI
  27e0: 4f 31 44 4d 41 31 a1 0a 70 44 4d 41 30 44 4d 41  O1DMA1..pDMA0DMA
  27f0: 31 70 00 46 4c 41 47 a0 11 7b 68 0a 01 00 7d 46  1p.FLAG..{h...}F
  2800: 4c 41 47 0a 10 46 4c 41 47 a0 11 7b 6a 0a 01 00  LAG..FLAG..{j...
  2810: 7d 46 4c 41 47 0a 01 46 4c 41 47 a0 11 7b 68 0a  }FLAG..FLAG..{h.
  2820: 02 00 7d 46 4c 41 47 0a 02 46 4c 41 47 a0 11 7b  ..}FLAG..FLAG..{
  2830: 6a 0a 02 00 7d 46 4c 41 47 0a 04 46 4c 41 47 a0  j...}FLAG..FLAG.
  2840: 11 7b 68 0a 20 00 7d 46 4c 41 47 0a 08 46 4c 41  .{h. .}FLAG..FLA
  2850: 47 a4 60 14 47 28 53 54 4d 5f 03 70 11 03 0a 18  G.`.G(STM_.p....
  2860: 67 8a 67 0a 00 49 54 4d 5f 8a 67 0a 04 53 49 54  g.g..ITM_.g..SIT
  2870: 5f 8a 67 0a 08 55 44 43 5f 8a 67 0a 0c 55 44 54  _.g..UDC_.g..UDT
  2880: 5f 8a 67 0a 10 49 43 46 5f 8a 67 0a 14 46 41 53  _.g..ICF_.g..FAS
  2890: 5f 8a 68 0a 00 50 49 4f 30 8a 68 0a 04 44 4d 41  _.h..PIO0.h..DMA
  28a0: 30 8a 68 0a 08 50 49 4f 31 8a 68 0a 0c 44 4d 41  0.h..PIO1.h..DMA
  28b0: 31 8a 68 0a 10 46 4c 41 47 70 46 4c 41 47 64 70  1.h..FLAGpFLAGdp
  28c0: 0b 00 80 60 a0 0b 7b 64 0a 02 00 7d 60 0a 07 60  ...`..{d...}`..`
  28d0: a0 11 7b 64 0a 08 00 7d 60 0b 00 40 60 7d 60 0a  ..{d...}`..@`}`.
  28e0: 70 60 a0 16 90 95 44 4d 41 30 50 49 4f 30 92 7b  p`....DMA0PIO0.{
  28f0: 64 0a 01 00 7d 60 0a 08 60 a0 16 90 95 44 4d 41  d...}`..`....DMA
  2900: 31 50 49 4f 31 92 7b 64 0a 04 00 7d 60 0a 80 60  1PIO1.{d...}`..`
  2910: a0 14 50 49 4f 30 a0 0e 95 50 49 4f 30 0b 84 03  ..PIO0...PIO0...
  2920: 7d 60 0a 01 60 a0 14 50 49 4f 31 a0 0e 95 50 49  }`..`..PIO1...PI
  2930: 4f 31 0b 84 03 7d 60 0a 10 60 a0 0c 7b 64 0a 01  O1...}`..`..{d..
  2940: 00 70 50 49 4f 30 61 a1 07 70 44 4d 41 30 61 a0  .pPIO0a..pDMA0a.
  2950: 2d 61 a0 0c 92 94 61 0a 78 7d 60 0b 00 23 60 a1  -a....a.x}`..#`.
  2960: 1d a0 0c 92 94 61 0a b4 7d 60 0b 00 21 60 a1 0e  .....a..}`..!`..
  2970: a0 0c 92 94 61 0a f0 7d 60 0b 00 10 60 70 60 49  ....a..}`...`p`I
  2980: 54 4d 5f 70 00 60 a0 0c 7b 64 0a 04 00 70 50 49  TM_p.`..{d...pPI
  2990: 4f 31 61 a1 07 70 44 4d 41 31 61 a0 27 61 a0 0a  O1a..pDMA1a.'a..
  29a0: 92 94 61 0a 78 70 0a 0b 60 a1 19 a0 0a 92 94 61  ..a.xp..`......a
  29b0: 0a b4 70 0a 09 60 a1 0c a0 0a 92 94 61 0a f0 70  ..p..`......a..p
  29c0: 0a 04 60 70 60 53 49 54 5f 70 0a 00 60 a0 0b 7b  ..`p`SIT_p..`..{
  29d0: 64 0a 01 00 7d 60 0a 01 60 a0 0b 7b 64 0a 04 00  d...}`..`..{d...
  29e0: 7d 60 0a 02 60 70 60 55 44 43 5f 70 0a 00 60 a0  }`..`p`UDC_p..`.
  29f0: 37 7b 64 0a 01 00 a0 0c 93 44 4d 41 30 0a 14 70  7{d......DMA0..p
  2a00: 0a 01 60 a1 23 a0 11 95 44 4d 41 30 0a 3c 78 44  ..`.#...DMA0.<xD
  2a10: 4d 41 30 0a 0f 00 61 a1 0a 78 44 4d 41 30 0a 1e  MA0...a..xDMA0..
  2a20: 00 61 74 0a 04 61 60 a0 41 04 7b 64 0a 04 00 a0  .at..a`.A.{d....
  2a30: 0c 93 44 4d 41 31 0a 14 70 0a 01 61 a1 23 a0 11  ..DMA1..p..a.#..
  2a40: 95 44 4d 41 31 0a 3c 78 44 4d 41 31 0a 0f 00 61  .DMA1.<xDMA1...a
  2a50: a1 0a 78 44 4d 41 31 0a 1e 00 61 74 0a 04 61 61  ..xDMA1...at..aa
  2a60: 79 61 0a 04 61 7d 60 61 60 70 60 55 44 54 5f 70  ya..a}`a`p`UDT_p
  2a70: 0a 00 60 a0 1c 44 4d 41 30 a0 16 94 44 4d 41 30  ..`..DMA0...DMA0
  2a80: 0a 14 a0 0d 95 44 4d 41 30 0a 3c 7d 60 0a 01 60  .....DMA0.<}`..`
  2a90: a0 1c 44 4d 41 31 a0 16 94 44 4d 41 31 0a 14 a0  ..DMA1...DMA1...
  2aa0: 0d 95 44 4d 41 31 0a 3c 7d 60 0a 02 60 70 60 49  ..DMA1.<}`..`p`I
  2ab0: 43 46 5f 70 0a 00 60 a0 0d 93 44 4d 41 30 0a 14  CF_p..`...DMA0..
  2ac0: 7d 60 0a 01 60 a0 0d 93 44 4d 41 31 0a 14 7d 60  }`..`...DMA1..}`
  2ad0: 0a 02 60 70 60 46 41 53 5f a4 67 14 4a 05 48 31  ..`p`FAS_.g.J.H1
  2ae0: 35 50 01 08 42 55 46 46 11 0b 0a 08 00 00 00 00  5P..BUFF........
  2af0: 00 00 00 00 70 68 60 70 42 55 46 46 61 73 60 61  ....ph`pBUFFas`a
  2b00: 67 8b 67 0a 02 43 59 4c 5f 8b 67 0a 06 48 45 41  g.g..CYL_.g..HEA
  2b10: 44 8b 67 0a 0c 53 50 54 5f a0 18 90 92 95 48 45  D.g..SPT_.....HE
  2b20: 41 44 0a 10 92 95 43 59 4c 5f 0b 00 20 a4 53 50  AD....CYL_.. .SP
  2b30: 54 5f a1 03 a4 00 14 4d 11 47 54 46 30 07 70 11  T_.....M.GTF0.p.
  2b40: 0a 0a 07 03 00 00 00 00 a0 ef 67 8c 67 0a 01 4d  ..........g.g..M
  2b50: 4f 44 45 a0 2d 7b 6a 0a 01 00 7b 6b 0a 03 60 a0  ODE.-{j...{k..`.
  2b60: 0b 7b 6e 0a 01 00 72 60 0a 04 60 a1 0d a0 0b 7b  .{n...r`..`....{
  2b70: 6c 0a 01 00 72 60 0a 02 60 7d 60 0a 40 4d 4f 44  l...r`..`}`.@MOD
  2b80: 45 a1 3e 72 7a 7b 68 0b 00 03 00 0a 08 00 7a 7b  E.>rz{h.......z{
  2b90: 68 0b 00 30 00 0a 0c 00 60 a0 0d 92 95 60 0a 05  h..0....`....`..
  2ba0: 70 0a 22 4d 4f 44 45 a1 18 a0 0d 92 95 60 0a 03  p."MODE......`..
  2bb0: 70 0a 21 4d 4f 44 45 a1 08 70 0a 20 4d 4f 44 45  p.!MODE..p. MODE
  2bc0: 73 67 67 66 a0 24 91 7b 68 0a 08 00 92 7b 68 0a  sggf.$.{h....{h.
  2bd0: 01 00 a0 0d 7b 68 0a 02 00 70 0a 00 4d 4f 44 45  ....{h...p..MODE
  2be0: a1 08 70 0a 01 4d 4f 44 45 a1 3e 72 7a 7b 68 0b  ..p..MODE.>rz{h.
  2bf0: 00 03 00 0a 08 00 7a 7b 68 0b 00 30 00 0a 0c 00  ......z{h..0....
  2c00: 60 a0 0d 92 95 60 0a 05 70 0a 0c 4d 4f 44 45 a1  `....`..p..MODE.
  2c10: 18 a0 0d 92 95 60 0a 03 70 0a 0b 4d 4f 44 45 a1  .....`..p..MODE.
  2c20: 08 70 0a 0a 4d 4f 44 45 73 66 67 65 a0 23 6d 70  .p..MODEsfge.#mp
  2c30: 11 0a 0a 07 00 00 00 00 00 ae 91 64 8c 64 0a 01  ...........d.d..
  2c40: 53 50 54 5f 70 6d 53 50 54 5f 73 65 64 66 a4 66  SPT_pmSPT_sedf.f
  2c50: a1 03 a4 65 14 45 11 47 54 46 31 07 70 11 0a 0a  ...e.E.GTF1.p...
  2c60: 07 03 00 00 00 00 b0 ef 67 8c 67 0a 01 4d 4f 44  ........g.g..MOD
  2c70: 45 a0 31 7b 6a 0a 02 00 7a 7b 6b 0a 30 00 0a 04  E.1{j...z{k.0...
  2c80: 60 a0 0b 7b 6e 0a 02 00 72 60 0a 04 60 a1 0d a0  `..{n...r`..`...
  2c90: 0b 7b 6c 0a 02 00 72 60 0a 02 60 7d 60 0a 40 4d  .{l...r`..`}`.@M
  2ca0: 4f 44 45 a1 38 72 7a 7b 69 0a 03 00 0a 02 00 7b  ODE.8rz{i......{
  2cb0: 69 0a 0c 00 60 a0 0d 92 95 60 0a 05 70 0a 22 4d  i...`....`..p."M
  2cc0: 4f 44 45 a1 18 a0 0d 92 95 60 0a 03 70 0a 21 4d  ODE......`..p.!M
  2cd0: 4f 44 45 a1 08 70 0a 20 4d 4f 44 45 73 67 67 66  ODE..p. MODEsggf
  2ce0: a0 24 91 7b 68 0a 80 00 92 7b 68 0a 10 00 a0 0d  .$.{h....{h.....
  2cf0: 7b 68 0a 20 00 70 0a 00 4d 4f 44 45 a1 08 70 0a  {h. .p..MODE..p.
  2d00: 01 4d 4f 44 45 a1 38 72 7a 7b 69 0a 03 00 0a 02  .MODE.8rz{i.....
  2d10: 00 7b 69 0a 0c 00 60 a0 0d 92 95 60 0a 05 70 0a  .{i...`....`..p.
  2d20: 0c 4d 4f 44 45 a1 18 a0 0d 92 95 60 0a 03 70 0a  .MODE......`..p.
  2d30: 0b 4d 4f 44 45 a1 08 70 0a 0a 4d 4f 44 45 73 66  .MODE..p..MODEsf
  2d40: 67 65 a0 23 6d 70 11 0a 0a 07 00 00 00 00 00 be  ge.#mp..........
  2d50: 91 64 8c 64 0a 01 53 50 54 5f 70 6d 53 50 54 5f  .d.d..SPT_pmSPT_
  2d60: 73 65 64 66 a4 66 a1 03 a4 65 5b 82 47 11 50 52  sedf.f...e[.G.PR
  2d70: 49 4d 08 5f 41 44 52 0a 00 14 26 5f 47 54 4d 00  IM._ADR...&_GTM.
  2d80: 70 47 54 4d 5f 49 54 4d 30 53 49 54 30 55 44 43  pGTM_ITM0SIT0UDC
  2d90: 30 55 44 54 30 49 43 46 30 46 41 53 30 60 a4 60  0UDT0ICF0FAS0`.`
  2da0: 14 44 06 5f 53 54 4d 03 70 53 54 4d 5f 68 69 6a  .D._STM.pSTM_hij
  2db0: 60 8a 60 0a 00 49 54 4d 5f 8a 60 0a 04 53 49 54  `.`..ITM_.`..SIT
  2dc0: 5f 8a 60 0a 08 55 44 43 5f 8a 60 0a 0c 55 44 54  _.`..UDC_.`..UDT
  2dd0: 5f 8a 60 0a 10 49 43 46 5f 8a 60 0a 14 46 41 53  _.`..ICF_.`..FAS
  2de0: 5f 70 55 44 43 5f 55 44 43 30 70 55 44 54 5f 55  _pUDC_UDC0pUDT_U
  2df0: 44 54 30 70 49 43 46 5f 49 43 46 30 70 46 41 53  DT0pICF_ICF0pFAS
  2e00: 5f 46 41 53 30 5b 82 3d 4d 41 53 54 08 5f 41 44  _FAS0[.=3DMAST._AD
  2e10: 52 0a 00 08 48 31 35 46 00 14 2a 5f 47 54 46 00  R...H15F..*_GTF.
  2e20: 70 47 54 46 30 49 54 4d 30 53 49 54 30 55 44 43  pGTF0ITM0SIT0UDC
  2e30: 30 55 44 54 30 49 43 46 30 48 31 35 46 46 41 53  0UDT0ICF0H15FFAS
  2e40: 30 60 a4 60 5b 82 3d 53 4c 41 56 08 5f 41 44 52  0`.`[.=3DSLAV._ADR
  2e50: 0a 01 08 48 31 35 46 00 14 2a 5f 47 54 46 00 70  ...H15F..*_GTF.p
  2e60: 47 54 46 31 49 54 4d 30 53 49 54 30 55 44 43 30  GTF1ITM0SIT0UDC0
  2e70: 55 44 54 30 49 43 46 30 48 31 35 46 46 41 53 30  UDT0ICF0H15FFAS0
  2e80: 60 a4 60 5b 82 47 11 53 45 43 4e 08 5f 41 44 52  `.`[.G.SECN._ADR
  2e90: 0a 01 14 26 5f 47 54 4d 00 70 47 54 4d 5f 49 54  ...&_GTM.pGTM_IT
  2ea0: 4d 31 53 49 54 31 55 44 43 31 55 44 54 31 49 43  M1SIT1UDC1UDT1IC
  2eb0: 46 31 46 41 53 31 60 a4 60 14 44 06 5f 53 54 4d  F1FAS1`.`.D._STM
  2ec0: 03 70 53 54 4d 5f 68 69 6a 60 8a 60 0a 00 49 54  .pSTM_hij`.`..IT
  2ed0: 4d 5f 8a 60 0a 04 53 49 54 5f 8a 60 0a 08 55 44  M_.`..SIT_.`..UD
  2ee0: 43 5f 8a 60 0a 0c 55 44 54 5f 8a 60 0a 10 49 43  C_.`..UDT_.`..IC
  2ef0: 46 5f 8a 60 0a 14 46 41 53 5f 70 55 44 43 5f 55  F_.`..FAS_pUDC_U
  2f00: 44 43 31 70 55 44 54 5f 55 44 54 31 70 49 43 46  DC1pUDT_UDT1pICF
  2f10: 5f 49 43 46 31 70 46 41 53 5f 46 41 53 31 5b 82  _ICF1pFAS_FAS1[.
  2f20: 3d 4d 41 53 54 08 5f 41 44 52 0a 00 08 48 31 35  =3DMAST._ADR...H15
  2f30: 46 00 14 2a 5f 47 54 46 00 70 47 54 46 30 49 54  F..*_GTF.pGTF0IT
  2f40: 4d 31 53 49 54 31 55 44 43 31 55 44 54 31 49 43  M1SIT1UDC1UDT1IC
  2f50: 46 31 48 31 35 46 46 41 53 31 60 a4 60 5b 82 3d  F1H15FFAS1`.`[.=3D
  2f60: 53 4c 41 56 08 5f 41 44 52 0a 01 08 48 31 35 46  SLAV._ADR...H15F
  2f70: 00 14 2a 5f 47 54 46 00 70 47 54 46 31 49 54 4d  ..*_GTF.pGTF1ITM
  2f80: 31 53 49 54 31 55 44 43 31 55 44 54 31 49 43 46  1SIT1UDC1UDT1ICF
  2f90: 31 48 31 35 46 46 41 53 31 60 a4 60 5b 82 4f b5  1H15FFAS1`.`[.O.
  2fa0: 49 44 45 31 08 5f 41 44 52 0c 02 00 1f 00 5b 80  IDE1._ADR.....[.
  2fb0: 49 44 45 43 02 0a 90 0a 03 5b 81 12 49 44 45 43  IDEC.....[..IDEC
  2fc0: 01 4d 41 50 5f 08 00 08 50 43 53 5f 08 5b 80 50  .MAP_...PCS_.[.P
  2fd0: 43 49 5f 02 0a 40 0a 20 5b 81 43 05 50 43 49 5f  CI_..@. [.C.PCI_
  2fe0: 03 49 54 4d 30 10 49 54 4d 31 10 53 49 54 30 04  .ITM0.ITM1.SIT0.
  2ff0: 53 49 54 31 04 00 18 55 44 43 30 02 55 44 43 31  SIT1...UDC0.UDC1
  3000: 02 00 0c 55 44 54 30 08 55 44 54 31 08 00 40 04  ...UDT0.UDT1..@.
  3010: 49 43 46 30 02 49 43 46 31 02 00 06 57 50 50 45  ICF0.ICF1...WPPE
  3020: 01 00 01 46 41 53 30 02 46 41 53 31 02 14 47 1c  ...FAS0.FAS1..G.
  3030: 47 54 4d 5f 06 70 11 03 0a 14 60 8a 60 0a 00 50  GTM_.p....`.`..P
  3040: 49 4f 30 8a 60 0a 04 44 4d 41 30 8a 60 0a 08 50  IO0.`..DMA0.`..P
  3050: 49 4f 31 8a 60 0a 0c 44 4d 41 31 8a 60 0a 10 46  IO1.`..DMA1.`..F
  3060: 4c 41 47 70 0a 10 46 4c 41 47 a0 15 91 7b 68 0a  LAGp..FLAG...{h.
  3070: 08 00 92 7b 68 0a 01 00 70 0b 84 03 50 49 4f 30  ...{h...p...PIO0
  3080: a1 23 72 7a 7b 68 0b 00 03 00 0a 08 00 7a 7b 68  .#rz{h.......z{h
  3090: 0b 00 30 00 0a 0c 00 61 77 74 0a 09 61 00 0a 1e  ..0....awt..a...
  30a0: 50 49 4f 30 a0 3f 91 90 68 0b 00 40 90 6a 0a 01  PIO0.?..h..@.j..
  30b0: a0 15 91 7b 68 0a 80 00 92 7b 68 0a 10 00 70 0b  ...{h....{h...p.
  30c0: 84 03 50 49 4f 31 a1 1d 72 7b 69 0a 03 00 7a 7b  ..PIO1..r{i...z{
  30d0: 69 0a 0c 00 0a 02 00 61 77 74 0a 09 61 00 0a 1e  i......awt..a...
  30e0: 50 49 4f 31 a1 0a 70 50 49 4f 30 50 49 4f 31 a0  PIO1..pPIO0PIO1.
  30f0: 38 7b 6a 0a 01 00 74 0a 04 7b 6b 0a 03 00 61 a0  8{j...t..{k...a.
  3100: 0d 7b 6d 0a 01 00 70 0a 14 44 4d 41 30 a1 1a a0  .{m...p..DMA0...
  3110: 0e 7b 6c 0a 01 00 77 61 0a 0f 44 4d 41 30 a1 09  .{l...wa..DMA0..
  3120: 77 61 0a 1e 44 4d 41 30 a1 0a 70 50 49 4f 30 44  wa..DMA0..pPIO0D
  3130: 4d 41 30 a0 44 05 91 90 68 0b 00 40 90 6a 0a 01  MA0.D...h..@.j..
  3140: a0 3c 7b 6a 0a 02 00 74 0a 04 7a 7b 6b 0a 30 00  .<{j...t..z{k.0.
  3150: 0a 04 00 61 a0 0d 7b 6d 0a 02 00 70 0a 14 44 4d  ...a..{m...p..DM
  3160: 41 31 a1 1a a0 0e 7b 6c 0a 02 00 77 61 0a 0f 44  A1....{l...wa..D
  3170: 4d 41 31 a1 09 77 61 0a 1e 44 4d 41 31 a1 0a 70  MA1..wa..DMA1..p
  3180: 50 49 4f 31 44 4d 41 31 a1 0a 70 44 4d 41 30 44  PIO1DMA1..pDMA0D
  3190: 4d 41 31 70 00 46 4c 41 47 a0 11 7b 68 0a 01 00  MA1p.FLAG..{h...
  31a0: 7d 46 4c 41 47 0a 10 46 4c 41 47 a0 11 7b 6a 0a  }FLAG..FLAG..{j.
  31b0: 01 00 7d 46 4c 41 47 0a 01 46 4c 41 47 a0 11 7b  ..}FLAG..FLAG..{
  31c0: 68 0a 02 00 7d 46 4c 41 47 0a 02 46 4c 41 47 a0  h...}FLAG..FLAG.
  31d0: 11 7b 6a 0a 02 00 7d 46 4c 41 47 0a 04 46 4c 41  .{j...}FLAG..FLA
  31e0: 47 a0 11 7b 68 0a 20 00 7d 46 4c 41 47 0a 08 46  G..{h. .}FLAG..F
  31f0: 4c 41 47 a4 60 14 47 28 53 54 4d 5f 03 70 11 03  LAG.`.G(STM_.p..
  3200: 0a 18 67 8a 67 0a 00 49 54 4d 5f 8a 67 0a 04 53  ..g.g..ITM_.g..S
  3210: 49 54 5f 8a 67 0a 08 55 44 43 5f 8a 67 0a 0c 55  IT_.g..UDC_.g..U
  3220: 44 54 5f 8a 67 0a 10 49 43 46 5f 8a 67 0a 14 46  DT_.g..ICF_.g..F
  3230: 41 53 5f 8a 68 0a 00 50 49 4f 30 8a 68 0a 04 44  AS_.h..PIO0.h..D
  3240: 4d 41 30 8a 68 0a 08 50 49 4f 31 8a 68 0a 0c 44  MA0.h..PIO1.h..D
  3250: 4d 41 31 8a 68 0a 10 46 4c 41 47 70 46 4c 41 47  MA1.h..FLAGpFLAG
  3260: 64 70 0b 00 80 60 a0 0b 7b 64 0a 02 00 7d 60 0a  dp...`..{d...}`.
  3270: 07 60 a0 11 7b 64 0a 08 00 7d 60 0b 00 40 60 7d  .`..{d...}`..@`}
  3280: 60 0a 70 60 a0 16 90 95 44 4d 41 30 50 49 4f 30  `.p`....DMA0PIO0
  3290: 92 7b 64 0a 01 00 7d 60 0a 08 60 a0 16 90 95 44  .{d...}`..`....D
  32a0: 4d 41 31 50 49 4f 31 92 7b 64 0a 04 00 7d 60 0a  MA1PIO1.{d...}`.
  32b0: 80 60 a0 14 50 49 4f 30 a0 0e 95 50 49 4f 30 0b  .`..PIO0...PIO0.
  32c0: 84 03 7d 60 0a 01 60 a0 14 50 49 4f 31 a0 0e 95  ..}`..`..PIO1...
  32d0: 50 49 4f 31 0b 84 03 7d 60 0a 10 60 a0 0c 7b 64  PIO1...}`..`..{d
  32e0: 0a 01 00 70 50 49 4f 30 61 a1 07 70 44 4d 41 30  ...pPIO0a..pDMA0
  32f0: 61 a0 2d 61 a0 0c 92 94 61 0a 78 7d 60 0b 00 23  a.-a....a.x}`..#
  3300: 60 a1 1d a0 0c 92 94 61 0a b4 7d 60 0b 00 21 60  `......a..}`..!`
  3310: a1 0e a0 0c 92 94 61 0a f0 7d 60 0b 00 10 60 70  ......a..}`...`p
  3320: 60 49 54 4d 5f 70 00 60 a0 0c 7b 64 0a 04 00 70  `ITM_p.`..{d...p
  3330: 50 49 4f 31 61 a1 07 70 44 4d 41 31 61 a0 27 61  PIO1a..pDMA1a.'a
  3340: a0 0a 92 94 61 0a 78 70 0a 0b 60 a1 19 a0 0a 92  ....a.xp..`.....
  3350: 94 61 0a b4 70 0a 09 60 a1 0c a0 0a 92 94 61 0a  .a..p..`......a.
  3360: f0 70 0a 04 60 70 60 53 49 54 5f 70 0a 00 60 a0  .p..`p`SIT_p..`.
  3370: 0b 7b 64 0a 01 00 7d 60 0a 01 60 a0 0b 7b 64 0a  .{d...}`..`..{d.
  3380: 04 00 7d 60 0a 02 60 70 60 55 44 43 5f 70 0a 00  ..}`..`p`UDC_p..
  3390: 60 a0 37 7b 64 0a 01 00 a0 0c 93 44 4d 41 30 0a  `.7{d......DMA0.
  33a0: 14 70 0a 01 60 a1 23 a0 11 95 44 4d 41 30 0a 3c  .p..`.#...DMA0.<
  33b0: 78 44 4d 41 30 0a 0f 00 61 a1 0a 78 44 4d 41 30  xDMA0...a..xDMA0
  33c0: 0a 1e 00 61 74 0a 04 61 60 a0 41 04 7b 64 0a 04  ...at..a`.A.{d..
  33d0: 00 a0 0c 93 44 4d 41 31 0a 14 70 0a 01 61 a1 23  ....DMA1..p..a.#
  33e0: a0 11 95 44 4d 41 31 0a 3c 78 44 4d 41 31 0a 0f  ...DMA1.<xDMA1..
  33f0: 00 61 a1 0a 78 44 4d 41 31 0a 1e 00 61 74 0a 04  .a..xDMA1...at..
  3400: 61 61 79 61 0a 04 61 7d 60 61 60 70 60 55 44 54  aaya..a}`a`p`UDT
  3410: 5f 70 0a 00 60 a0 1c 44 4d 41 30 a0 16 94 44 4d  _p..`..DMA0...DM
  3420: 41 30 0a 14 a0 0d 95 44 4d 41 30 0a 3c 7d 60 0a  A0.....DMA0.<}`.
  3430: 01 60 a0 1c 44 4d 41 31 a0 16 94 44 4d 41 31 0a  .`..DMA1...DMA1.
  3440: 14 a0 0d 95 44 4d 41 31 0a 3c 7d 60 0a 02 60 70  ....DMA1.<}`..`p
  3450: 60 49 43 46 5f 70 0a 00 60 a0 0d 93 44 4d 41 30  `ICF_p..`...DMA0
  3460: 0a 14 7d 60 0a 01 60 a0 0d 93 44 4d 41 31 0a 14  ..}`..`...DMA1..
  3470: 7d 60 0a 02 60 70 60 46 41 53 5f a4 67 14 4d 11  }`..`p`FAS_.g.M.
  3480: 47 54 46 30 07 70 11 0a 0a 07 03 00 00 00 00 a0  GTF0.p..........
  3490: ef 67 8c 67 0a 01 4d 4f 44 45 a0 2d 7b 6a 0a 01  .g.g..MODE.-{j..
  34a0: 00 7b 6b 0a 03 60 a0 0b 7b 6e 0a 01 00 72 60 0a  .{k..`..{n...r`.
  34b0: 04 60 a1 0d a0 0b 7b 6c 0a 01 00 72 60 0a 02 60  .`....{l...r`..`
  34c0: 7d 60 0a 40 4d 4f 44 45 a1 3e 72 7a 7b 68 0b 00  }`.@MODE.>rz{h..
  34d0: 03 00 0a 08 00 7a 7b 68 0b 00 30 00 0a 0c 00 60  .....z{h..0....`
  34e0: a0 0d 92 95 60 0a 05 70 0a 22 4d 4f 44 45 a1 18  ....`..p."MODE..
  34f0: a0 0d 92 95 60 0a 03 70 0a 21 4d 4f 44 45 a1 08  ....`..p.!MODE..
  3500: 70 0a 20 4d 4f 44 45 73 67 67 66 a0 24 91 7b 68  p. MODEsggf.$.{h
  3510: 0a 08 00 92 7b 68 0a 01 00 a0 0d 7b 68 0a 02 00  ....{h.....{h...
  3520: 70 0a 00 4d 4f 44 45 a1 08 70 0a 01 4d 4f 44 45  p..MODE..p..MODE
  3530: a1 3e 72 7a 7b 68 0b 00 03 00 0a 08 00 7a 7b 68  .>rz{h.......z{h
  3540: 0b 00 30 00 0a 0c 00 60 a0 0d 92 95 60 0a 05 70  ..0....`....`..p
  3550: 0a 0c 4d 4f 44 45 a1 18 a0 0d 92 95 60 0a 03 70  ..MODE......`..p
  3560: 0a 0b 4d 4f 44 45 a1 08 70 0a 0a 4d 4f 44 45 73  ..MODE..p..MODEs
  3570: 66 67 65 a0 23 6d 70 11 0a 0a 07 00 00 00 00 00  fge.#mp.........
  3580: ae 91 64 8c 64 0a 01 53 50 54 5f 70 6d 53 50 54  ..d.d..SPT_pmSPT
  3590: 5f 73 65 64 66 a4 66 a1 03 a4 65 14 45 11 47 54  _sedf.f...e.E.GT
  35a0: 46 31 07 70 11 0a 0a 07 03 00 00 00 00 b0 ef 67  F1.p...........g
  35b0: 8c 67 0a 01 4d 4f 44 45 a0 31 7b 6a 0a 02 00 7a  .g..MODE.1{j...z
  35c0: 7b 6b 0a 30 00 0a 04 60 a0 0b 7b 6e 0a 02 00 72  {k.0...`..{n...r
  35d0: 60 0a 04 60 a1 0d a0 0b 7b 6c 0a 02 00 72 60 0a  `..`....{l...r`.
  35e0: 02 60 7d 60 0a 40 4d 4f 44 45 a1 38 72 7a 7b 69  .`}`.@MODE.8rz{i
  35f0: 0a 03 00 0a 02 00 7b 69 0a 0c 00 60 a0 0d 92 95  ......{i...`....
  3600: 60 0a 05 70 0a 22 4d 4f 44 45 a1 18 a0 0d 92 95  `..p."MODE......
  3610: 60 0a 03 70 0a 21 4d 4f 44 45 a1 08 70 0a 20 4d  `..p.!MODE..p. M
  3620: 4f 44 45 73 67 67 66 a0 24 91 7b 68 0a 80 00 92  ODEsggf.$.{h....
  3630: 7b 68 0a 10 00 a0 0d 7b 68 0a 20 00 70 0a 00 4d  {h.....{h. .p..M
  3640: 4f 44 45 a1 08 70 0a 01 4d 4f 44 45 a1 38 72 7a  ODE..p..MODE.8rz
  3650: 7b 69 0a 03 00 0a 02 00 7b 69 0a 0c 00 60 a0 0d  {i......{i...`..
  3660: 92 95 60 0a 05 70 0a 0c 4d 4f 44 45 a1 18 a0 0d  ..`..p..MODE....
  3670: 92 95 60 0a 03 70 0a 0b 4d 4f 44 45 a1 08 70 0a  ..`..p..MODE..p.
  3680: 0a 4d 4f 44 45 73 66 67 65 a0 23 6d 70 11 0a 0a  .MODEsfge.#mp...
  3690: 07 00 00 00 00 00 be 91 64 8c 64 0a 01 53 50 54  ........d.d..SPT
  36a0: 5f 70 6d 53 50 54 5f 73 65 64 66 a4 66 a1 03 a4  _pmSPT_sedf.f...
  36b0: 65 5b 82 49 1b 50 52 49 44 08 5f 41 44 52 0a 00  e[.I.PRID._ADR..
  36c0: 14 26 5f 47 54 4d 00 70 47 54 4d 5f 49 54 4d 30  .&_GTM.pGTM_ITM0
  36d0: 53 49 54 30 55 44 43 30 55 44 54 30 49 43 46 30  SIT0UDC0UDT0ICF0
  36e0: 46 41 53 30 60 a4 60 14 44 06 5f 53 54 4d 03 70  FAS0`.`.D._STM.p
  36f0: 53 54 4d 5f 68 69 6a 60 8a 60 0a 00 49 54 4d 5f  STM_hij`.`..ITM_
  3700: 8a 60 0a 04 53 49 54 5f 8a 60 0a 08 55 44 43 5f  .`..SIT_.`..UDC_
  3710: 8a 60 0a 0c 55 44 54 5f 8a 60 0a 10 49 43 46 5f  .`..UDT_.`..ICF_
  3720: 8a 60 0a 14 46 41 53 5f 70 55 44 43 5f 55 44 43  .`..FAS_pUDC_UDC
  3730: 30 70 55 44 54 5f 55 44 54 30 70 49 43 46 5f 49  0pUDT_UDT0pICF_I
  3740: 43 46 30 70 46 41 53 5f 46 41 53 30 5b 82 48 04  CF0pFAS_FAS0[.H.
  3750: 44 52 56 30 08 5f 41 44 52 0a 00 08 48 31 35 46  DRV0._ADR...H15F
  3760: 00 14 34 5f 47 54 46 00 a0 2b 43 54 59 50 0a 00  ..4_GTF..+CTYP..
  3770: 70 47 54 46 30 49 54 4d 30 53 49 54 30 55 44 43  pGTF0ITM0SIT0UDC
  3780: 30 55 44 54 30 49 43 46 30 48 31 35 46 46 41 53  0UDT0ICF0H15FFAS
  3790: 30 60 a4 60 a1 01 5b 82 48 04 44 52 56 31 08 5f  0`.`..[.H.DRV1._
  37a0: 41 44 52 0a 01 08 48 31 35 46 00 14 34 5f 47 54  ADR...H15F..4_GT
  37b0: 46 00 a0 2b 43 54 59 50 0a 00 70 47 54 46 31 49  F..+CTYP..pGTF1I
  37c0: 54 4d 30 53 49 54 30 55 44 43 30 55 44 54 30 49  TM0SIT0UDC0UDT0I
  37d0: 43 46 30 48 31 35 46 46 41 53 30 60 a4 60 a1 01  CF0H15FFAS0`.`..
  37e0: 14 47 04 5f 50 53 30 00 70 43 54 59 50 0a 00 60  .G._PS0.pCTYP..`
  37f0: a0 35 60 a0 10 93 60 0a 01 7d 50 43 53 5f 0a 03  .5`...`..}PCS_..
  3800: 50 43 53 5f a0 10 93 60 0a 03 7d 50 43 53 5f 0a  PCS_...`..}PCS_.
  3810: 01 50 43 53 5f a0 10 93 60 0a 04 7d 50 43 53 5f  .PCS_...`..}PCS_
  3820: 0a 02 50 43 53 5f a1 01 14 43 04 5f 50 53 33 00  ..PCS_...C._PS3.
  3830: 70 43 54 59 50 0a 00 60 a0 31 60 a0 0c 93 60 0a  pCTYP..`.1`...`.
  3840: 01 70 0a 00 50 43 53 5f a0 10 93 60 0a 03 7c 50  .p..PCS_...`..|P
  3850: 43 53 5f 0a 01 50 43 53 5f a0 10 93 60 0a 04 7c  CS_..PCS_...`..|
  3860: 50 43 53 5f 0a 02 50 43 53 5f a1 01 5b 82 49 1b  PCS_..PCS_..[.I.
  3870: 53 45 43 44 08 5f 41 44 52 0a 01 14 26 5f 47 54  SECD._ADR...&_GT
  3880: 4d 00 70 47 54 4d 5f 49 54 4d 31 53 49 54 31 55  M.pGTM_ITM1SIT1U
  3890: 44 43 31 55 44 54 31 49 43 46 31 46 41 53 31 60  DC1UDT1ICF1FAS1`
  38a0: a4 60 14 44 06 5f 53 54 4d 03 70 53 54 4d 5f 68  .`.D._STM.pSTM_h
  38b0: 69 6a 60 8a 60 0a 00 49 54 4d 5f 8a 60 0a 04 53  ij`.`..ITM_.`..S
  38c0: 49 54 5f 8a 60 0a 08 55 44 43 5f 8a 60 0a 0c 55  IT_.`..UDC_.`..U
  38d0: 44 54 5f 8a 60 0a 10 49 43 46 5f 8a 60 0a 14 46  DT_.`..ICF_.`..F
  38e0: 41 53 5f 70 55 44 43 5f 55 44 43 31 70 55 44 54  AS_pUDC_UDC1pUDT
  38f0: 5f 55 44 54 31 70 49 43 46 5f 49 43 46 31 70 46  _UDT1pICF_ICF1pF
  3900: 41 53 5f 46 41 53 31 14 47 04 5f 50 53 30 00 70  AS_FAS1.G._PS0.p
  3910: 43 54 59 50 0a 01 60 a0 35 60 a0 10 93 60 0a 02  CTYP..`.5`...`..
  3920: 7d 50 43 53 5f 0a 03 50 43 53 5f a0 10 93 60 0a  }PCS_..PCS_...`.
  3930: 05 7d 50 43 53 5f 0a 01 50 43 53 5f a0 10 93 60  .}PCS_..PCS_...`
  3940: 0a 06 7d 50 43 53 5f 0a 02 50 43 53 5f a1 01 14  ..}PCS_..PCS_...
  3950: 43 04 5f 50 53 33 00 70 43 54 59 50 0a 01 60 a0  C._PS3.pCTYP..`.
  3960: 31 60 a0 0c 93 60 0a 02 70 0a 00 50 43 53 5f a0  1`...`..p..PCS_.
  3970: 10 93 60 0a 05 7c 50 43 53 5f 0a 01 50 43 53 5f  ..`..|PCS_..PCS_
  3980: a0 10 93 60 0a 06 7c 50 43 53 5f 0a 02 50 43 53  ...`..|PCS_..PCS
  3990: 5f a1 01 5b 82 48 04 44 52 56 30 08 5f 41 44 52  _..[.H.DRV0._ADR
  39a0: 0a 00 08 48 31 35 46 00 14 34 5f 47 54 46 00 a0  ...H15F..4_GTF..
  39b0: 2b 43 54 59 50 0a 01 70 47 54 46 30 49 54 4d 31  +CTYP..pGTF0ITM1
  39c0: 53 49 54 31 55 44 43 31 55 44 54 31 49 43 46 31  SIT1UDC1UDT1ICF1
  39d0: 48 31 35 46 46 41 53 31 60 a4 60 a1 01 5b 82 48  H15FFAS1`.`..[.H
  39e0: 04 44 52 56 31 08 5f 41 44 52 0a 01 08 48 31 35  .DRV1._ADR...H15
  39f0: 46 00 14 34 5f 47 54 46 00 a0 2b 43 54 59 50 0a  F..4_GTF..+CTYP.
  3a00: 01 70 47 54 46 31 49 54 4d 31 53 49 54 31 55 44  .pGTF1ITM1SIT1UD
  3a10: 43 31 55 44 54 31 49 43 46 31 48 31 35 46 46 41  C1UDT1ICF1H15FFA
  3a20: 53 31 60 a4 60 a1 01 14 4d 06 47 53 50 53 00 70  S1`.`...M.GSPS.p
  3a30: 00 60 70 4d 41 50 5f 61 70 50 43 53 5f 62 a0 4e  .`pMAP_apPCS_b.N
  3a40: 04 95 61 0a 06 70 00 63 70 00 64 70 00 65 a0 08  ..a..p.cp.dp.e..
  3a50: 90 62 0a 10 70 01 63 a0 08 90 62 0a 20 70 01 64  .b..p.c...b. p.d
  3a60: a0 17 92 90 61 0a 01 70 63 65 a0 0d 90 61 0a 04  ....a..pce...a..
  3a70: 7d 79 64 0a 01 64 65 00 a1 12 70 64 65 a0 0d 90  }yd..de...pde...
  3a80: 61 0a 04 7d 79 63 0a 01 63 65 00 a4 65 a1 07 a4  a..}yc..ce..e...
  3a90: 0c ff ff ff ff 14 47 06 43 54 59 50 01 70 00 60  ......G.CTYP.p.`
  3aa0: a0 31 68 a0 14 90 94 4d 41 50 5f 0a 01 95 4d 41  .1h....MAP_...MA
  3ab0: 50 5f 0a 06 70 0a 01 60 a1 19 a0 0b 93 4d 41 50  P_..p..`.....MAP
  3ac0: 5f 00 70 0a 03 60 a0 0b 93 4d 41 50 5f 01 70 0a  _.p..`...MAP_.p.
  3ad0: 04 60 a1 28 a0 0c 94 4d 41 50 5f 0a 05 70 0a 02  .`.(...MAP_..p..
  3ae0: 60 a1 19 a0 0b 93 4d 41 50 5f 00 70 0a 05 60 a0  `.....MAP_.p..`.
  3af0: 0b 93 4d 41 50 5f 01 70 0a 06 60 a4 60 5b 82 39  ..MAP_.p..`.`[.9
  3b00: 50 58 34 33 08 5f 41 44 52 0c 03 00 1f 00 5b 80  PX43._ADR.....[.
  3b10: 50 42 41 53 02 0a 20 0a 02 5b 81 0b 50 42 41 53  PBAS.. ..[..PBAS
  3b20: 01 42 41 53 30 10 14 11 53 4d 42 42 00 7b 42 41  .BAS0...SMBB.{BA
  3b30: 53 30 0b fe ff 60 a4 60 5b 82 1e 4d 4f 44 4d 08  S0...`.`[..MODM.
  3b40: 5f 41 44 52 0c 06 00 1f 00 14 0e 5f 50 52 57 00  _ADR......._PRW.
  3b50: a4 12 06 02 0a 05 0a 05 08 42 55 46 41 11 09 0a  .........BUFA...
  3b60: 06 23 b8 de 18 79 00 08 42 55 46 42 11 09 0a 06  .#...y..BUFB....
  3b70: 23 00 00 18 79 00 8b 42 55 46 42 0a 01 49 52 51  #...y..BUFB..IRQ
  3b80: 56 5b 82 4b 08 4c 4e 4b 41 08 5f 48 49 44 0c 41  V[.K.LNKA._HID.A
  3b90: d0 0c 0f 08 5f 55 49 44 0a 01 14 1c 5f 53 54 41  ...._UID...._STA
  3ba0: 00 7b 50 49 52 41 0a 80 60 a0 08 93 60 0a 80 a4  .{PIRA..`...`...
  3bb0: 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52 53 00 a4 42  ........._PRS..B
  3bc0: 55 46 41 14 11 5f 44 49 53 00 7d 50 49 52 41 0a  UFA.._DIS.}PIRA.
  3bd0: 80 50 49 52 41 14 1b 5f 43 52 53 00 7b 50 49 52  .PIRA.._CRS.{PIR
  3be0: 41 0a 0f 60 79 0a 01 60 49 52 51 56 a4 42 55 46  A..`y..`IRQV.BUF
  3bf0: 42 14 1c 5f 53 52 53 01 8b 68 0a 01 49 52 51 31  B.._SRS..h..IRQ1
  3c00: 82 49 52 51 31 60 76 60 70 60 50 49 52 41 5b 82  .IRQ1`v`p`PIRA[.
  3c10: 4b 08 4c 4e 4b 42 08 5f 48 49 44 0c 41 d0 0c 0f  K.LNKB._HID.A...
  3c20: 08 5f 55 49 44 0a 02 14 1c 5f 53 54 41 00 7b 50  ._UID...._STA.{P
  3c30: 49 52 42 0a 80 60 a0 08 93 60 0a 80 a4 0a 09 a1  IRB..`...`......
  3c40: 04 a4 0a 0b 14 0b 5f 50 52 53 00 a4 42 55 46 41  ......_PRS..BUFA
  3c50: 14 11 5f 44 49 53 00 7d 50 49 52 42 0a 80 50 49  .._DIS.}PIRB..PI
  3c60: 52 42 14 1b 5f 43 52 53 00 7b 50 49 52 42 0a 0f  RB.._CRS.{PIRB..
  3c70: 60 79 0a 01 60 49 52 51 56 a4 42 55 46 42 14 1c  `y..`IRQV.BUFB..
  3c80: 5f 53 52 53 01 8b 68 0a 01 49 52 51 31 82 49 52  _SRS..h..IRQ1.IR
  3c90: 51 31 60 76 60 70 60 50 49 52 42 5b 82 4b 08 4c  Q1`v`p`PIRB[.K.L
  3ca0: 4e 4b 43 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  NKC._HID.A...._U
  3cb0: 49 44 0a 03 14 1c 5f 53 54 41 00 7b 50 49 52 43  ID...._STA.{PIRC
  3cc0: 0a 80 60 a0 08 93 60 0a 80 a4 0a 09 a1 04 a4 0a  ..`...`.........
  3cd0: 0b 14 0b 5f 50 52 53 00 a4 42 55 46 41 14 11 5f  ..._PRS..BUFA.._
  3ce0: 44 49 53 00 7d 50 49 52 43 0a 80 50 49 52 43 14  DIS.}PIRC..PIRC.
  3cf0: 1b 5f 43 52 53 00 7b 50 49 52 43 0a 0f 60 79 0a  ._CRS.{PIRC..`y.
  3d00: 01 60 49 52 51 56 a4 42 55 46 42 14 1c 5f 53 52  .`IRQV.BUFB.._SR
  3d10: 53 01 8b 68 0a 01 49 52 51 31 82 49 52 51 31 60  S..h..IRQ1.IRQ1`
  3d20: 76 60 70 60 50 49 52 43 5b 82 4b 08 4c 4e 4b 44  v`p`PIRC[.K.LNKD
  3d30: 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a  ._HID.A...._UID.
  3d40: 04 14 1c 5f 53 54 41 00 7b 50 49 52 44 0a 80 60  ..._STA.{PIRD..`
  3d50: a0 08 93 60 0a 80 a4 0a 09 a1 04 a4 0a 0b 14 0b  ...`............
  3d60: 5f 50 52 53 00 a4 42 55 46 41 14 11 5f 44 49 53  _PRS..BUFA.._DIS
  3d70: 00 7d 50 49 52 44 0a 80 50 49 52 44 14 1b 5f 43  .}PIRD..PIRD.._C
  3d80: 52 53 00 7b 50 49 52 44 0a 0f 60 79 0a 01 60 49  RS.{PIRD..`y..`I
  3d90: 52 51 56 a4 42 55 46 42 14 1c 5f 53 52 53 01 8b  RQV.BUFB.._SRS..
  3da0: 68 0a 01 49 52 51 31 82 49 52 51 31 60 76 60 70  h..IRQ1.IRQ1`v`p
  3db0: 60 50 49 52 44 5b 82 4b 08 4c 4e 4b 45 08 5f 48  `PIRD[.K.LNKE._H
  3dc0: 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 05 14 1c  ID.A...._UID....
  3dd0: 5f 53 54 41 00 7b 50 49 52 45 0a 80 60 a0 08 93  _STA.{PIRE..`...
  3de0: 60 0a 80 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52  `............_PR
  3df0: 53 00 a4 42 55 46 41 14 11 5f 44 49 53 00 7d 50  S..BUFA.._DIS.}P
  3e00: 49 52 45 0a 80 50 49 52 45 14 1b 5f 43 52 53 00  IRE..PIRE.._CRS.
  3e10: 7b 50 49 52 45 0a 0f 60 79 0a 01 60 49 52 51 56  {PIRE..`y..`IRQV
  3e20: a4 42 55 46 42 14 1c 5f 53 52 53 01 8b 68 0a 01  .BUFB.._SRS..h..
  3e30: 49 52 51 31 82 49 52 51 31 60 76 60 70 60 50 49  IRQ1.IRQ1`v`p`PI
  3e40: 52 45 5b 82 4b 08 4c 4e 4b 46 08 5f 48 49 44 0c  RE[.K.LNKF._HID.
  3e50: 41 d0 0c 0f 08 5f 55 49 44 0a 06 14 1c 5f 53 54  A...._UID...._ST
  3e60: 41 00 7b 50 49 52 46 0a 80 60 a0 08 93 60 0a 80  A.{PIRF..`...`..
  3e70: a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52 53 00 a4  .........._PRS..
  3e80: 42 55 46 41 14 11 5f 44 49 53 00 7d 50 49 52 46  BUFA.._DIS.}PIRF
  3e90: 0a 80 50 49 52 46 14 1b 5f 43 52 53 00 7b 50 49  ..PIRF.._CRS.{PI
  3ea0: 52 46 0a 0f 60 79 0a 01 60 49 52 51 56 a4 42 55  RF..`y..`IRQV.BU
  3eb0: 46 42 14 1c 5f 53 52 53 01 8b 68 0a 01 49 52 51  FB.._SRS..h..IRQ
  3ec0: 31 82 49 52 51 31 60 76 60 70 60 50 49 52 46 5b  1.IRQ1`v`p`PIRF[
  3ed0: 82 4b 08 4c 4e 4b 30 08 5f 48 49 44 0c 41 d0 0c  .K.LNK0._HID.A..
  3ee0: 0f 08 5f 55 49 44 0a 07 14 1c 5f 53 54 41 00 7b  .._UID...._STA.{
  3ef0: 50 49 52 47 0a 80 60 a0 08 93 60 0a 80 a4 0a 09  PIRG..`...`.....
  3f00: a1 04 a4 0a 0b 14 0b 5f 50 52 53 00 a4 42 55 46  ......._PRS..BUF
  3f10: 41 14 11 5f 44 49 53 00 7d 50 49 52 47 0a 80 50  A.._DIS.}PIRG..P
  3f20: 49 52 47 14 1b 5f 43 52 53 00 7b 50 49 52 47 0a  IRG.._CRS.{PIRG.
  3f30: 0f 60 79 0a 01 60 49 52 51 56 a4 42 55 46 42 14  .`y..`IRQV.BUFB.
  3f40: 1c 5f 53 52 53 01 8b 68 0a 01 49 52 51 31 82 49  ._SRS..h..IRQ1.I
  3f50: 52 51 31 60 76 60 70 60 50 49 52 47 5b 82 4b 08  RQ1`v`p`PIRG[.K.
  3f60: 4c 4e 4b 31 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  LNK1._HID.A...._
  3f70: 55 49 44 0a 08 14 1c 5f 53 54 41 00 7b 50 49 52  UID...._STA.{PIR
  3f80: 48 0a 80 60 a0 08 93 60 0a 80 a4 0a 09 a1 04 a4  H..`...`........
  3f90: 0a 0b 14 0b 5f 50 52 53 00 a4 42 55 46 41 14 11  ...._PRS..BUFA..
  3fa0: 5f 44 49 53 00 7d 50 49 52 48 0a 80 50 49 52 48  _DIS.}PIRH..PIRH
  3fb0: 14 1b 5f 43 52 53 00 7b 50 49 52 48 0a 0f 60 79  .._CRS.{PIRH..`y
  3fc0: 0a 01 60 49 52 51 56 a4 42 55 46 42 14 1c 5f 53  ..`IRQV.BUFB.._S
  3fd0: 52 53 01 8b 68 0a 01 49 52 51 31 82 49 52 51 31  RS..h..IRQ1.IRQ1
  3fe0: 60 76 60 70 60 50 49 52 48 14 0e 5f 50 52 57 00  `v`p`PIRH.._PRW.
  3ff0: a4 12 06 02 0a 0b 0a 05 14 21 5c 2f 05 5f 53 42  .........!\/._SB
  4000: 5f 50 43 49 30 50 58 34 30 55 41 52 31 5f 50 52  _PCI0PX40UAR1_PR
  4010: 57 00 a4 12 06 02 0a 08 0a 05 14 21 5c 2f 05 5f  W..........!\/._
  4020: 53 42 5f 50 43 49 30 50 58 34 30 55 41 52 32 5f  SB_PCI0PX40UAR2_
  4030: 50 52 57 00 a4 12 06 02 0a 08 0a 05 5b 82 4e 1e  PRW.........[.N.
  4040: 4d 45 4d 5f 08 5f 48 49 44 0c 41 d0 0c 01 14 4d  MEM_._HID.A....M
  4050: 1d 5f 43 52 53 00 08 42 55 46 30 11 42 0a 0a 9e  ._CRS..BUF0.B...
  4060: 86 09 00 01 00 00 0f 00 00 40 00 00 86 09 00 01  .........@......
  4070: 00 40 0f 00 00 40 00 00 86 09 00 01 00 80 0f 00  .@...@..........
  4080: 00 40 00 00 86 09 00 01 00 c0 0f 00 00 40 00 00  .@...........@..
  4090: 86 09 00 01 00 00 00 00 00 00 01 00 86 09 00 01  ................
  40a0: 00 00 00 00 00 00 0a 00 86 09 00 01 00 00 10 00  ................
  40b0: 00 00 00 00 86 09 00 01 00 00 c0 fe 00 10 00 00  ................
  40c0: 86 09 00 01 00 10 c0 fe 00 f0 18 00 86 09 00 01  ................
  40d0: 00 00 e0 fe 00 10 00 00 86 09 00 01 00 00 b0 ff  ................
  40e0: 00 00 08 00 86 09 00 01 00 00 f0 ff 00 00 10 00  ................
  40f0: 86 09 00 01 00 00 0e 00 00 00 01 00 79 00 8a 42  ............y..B
  4100: 55 46 30 0a 34 41 43 4d 4d 8a 42 55 46 30 0a 04  UF0.4ACMM.BUF0..
  4110: 52 4d 41 31 8a 42 55 46 30 0a 08 52 53 53 31 8a  RMA1.BUF0..RSS1.
  4120: 42 55 46 30 0a 10 52 4d 41 32 8a 42 55 46 30 0a  BUF0..RMA2.BUF0.
  4130: 14 52 53 53 32 8a 42 55 46 30 0a 1c 52 4d 41 33  .RSS2.BUF0..RMA3
  4140: 8a 42 55 46 30 0a 20 52 53 53 33 8a 42 55 46 30  .BUF0. RSS3.BUF0
  4150: 0a 28 52 4d 41 34 8a 42 55 46 30 0a 2c 52 53 53  .(RMA4.BUF0.,RSS
  4160: 34 8a 42 55 46 30 0a 50 45 58 54 4d 74 41 4d 45  4.BUF0.PEXTMtAME
  4170: 4d 0c 00 00 10 00 45 58 54 4d a0 35 92 93 52 4f  M.....EXTM.5..RO
  4180: 4d 31 00 70 52 4d 41 31 52 4d 41 32 79 52 4f 4d  M1.pRMA1RMA2yROM
  4190: 31 0a 08 60 70 60 52 4d 41 31 79 52 4d 53 31 0a  1..`p`RMA1yRMS1.
  41a0: 08 60 70 60 52 53 53 31 70 0b 00 80 52 53 53 32  .`p`RSS1p...RSS2
  41b0: a0 35 92 93 52 4f 4d 32 00 70 52 4d 41 32 52 4d  .5..ROM2.pRMA2RM
  41c0: 41 33 79 52 4f 4d 32 0a 08 60 70 60 52 4d 41 32  A3yROM2..`p`RMA2
  41d0: 79 52 4d 53 32 0a 08 60 70 60 52 53 53 32 70 0b  yRMS2..`p`RSS2p.
  41e0: 00 c0 52 53 53 33 a0 37 92 93 52 4f 4d 33 00 70  ..RSS3.7..ROM3.p
  41f0: 52 4d 41 33 52 4d 41 34 79 52 4f 4d 33 0a 08 60  RMA3RMA4yROM3..`
  4200: 70 60 52 4d 41 33 79 52 4d 53 33 0a 08 60 70 60  p`RMA3yRMS3..`p`
  4210: 52 53 53 33 70 0c 00 00 01 00 52 53 53 34 70 41  RSS3p.....RSS4pA
  4220: 4d 45 4d 41 43 4d 4d a4 42 55 46 30 5b 82 42 04  MEMACMM.BUF0[.B.
  4230: 5c 2f 04 5f 53 42 5f 50 43 49 30 50 58 34 30 46  \/._SB_PCI0PX40F
  4240: 57 48 5f 08 5f 48 49 44 0c 25 d4 08 00 14 22 5f  WH_._HID.%...."_
  4250: 43 52 53 00 08 46 57 48 30 11 11 0a 0e 86 09 00  CRS..FWH0.......
  4260: 01 00 00 b8 ff 00 00 08 00 79 00 a4 46 57 48 30  .........y..FWH0
  4270: 5b 80 54 45 4d 4d 00 0c 10 f8 0f 00 0a 0c 5b 81  [.TEMM........[.
  4280: 24 54 45 4d 4d 02 54 50 31 48 10 54 50 31 4c 10  $TEMM.TP1H.TP1L.
  4290: 54 50 32 48 10 54 50 32 4c 10 54 52 50 43 10 53  TP2H.TP2L.TRPC.S
  42a0: 45 4e 46 10 08 54 56 41 52 11 08 0a 05 00 00 00  ENF..TVAR.......
  42b0: 00 00 8c 54 56 41 52 0a 00 50 4c 43 59 8b 54 56  ...TVAR..PLCY.TV
  42c0: 41 52 0a 01 43 54 4f 53 8b 54 56 41 52 0a 03 43  AR..CTOS.TVAR..C
  42d0: 54 48 59 08 54 42 55 46 11 07 0a 04 00 00 00 00  THY.TBUF........
  42e0: 8c 54 42 55 46 0a 00 44 42 30 30 8c 54 42 55 46  .TBUF..DB00.TBUF
  42f0: 0a 01 44 42 30 31 8b 54 42 55 46 0a 00 44 57 30  ..DB01.TBUF..DW0
  4300: 30 8b 54 42 55 46 0a 02 44 57 30 31 8a 54 42 55  0.TBUF..DW01.TBU
  4310: 46 0a 00 44 41 54 44 5b 80 49 50 5f 5f 01 0b 95  F..DATD[.IP__...
  4320: 02 0a 02 5b 81 10 49 50 5f 5f 01 49 4e 44 53 08  ...[..IP__.INDS.
  4330: 44 41 54 53 08 14 0d 53 43 46 47 01 53 42 59 54  DATS...SCFG.SBYT
  4340: 0a 40 68 14 2f 53 54 4f 53 03 70 47 42 59 54 0a  .@h./STOS.pGBYT.
  4350: 4e 60 7d 60 0a 01 61 53 42 59 54 0a 4e 61 53 42  N`}`..aSBYT.NaSB
  4360: 59 54 0a 55 69 53 42 59 54 0a 56 68 53 42 59 54  YT.UiSBYT.VhSBYT
  4370: 0a 4e 60 14 2f 53 54 48 59 03 70 47 42 59 54 0a  .N`./STHY.pGBYT.
  4380: 4e 60 7d 60 0a 01 61 53 42 59 54 0a 4e 61 53 42  N`}`..aSBYT.NaSB
  4390: 59 54 0a 53 69 53 42 59 54 0a 54 68 53 42 59 54  YT.SiSBYT.ThSBYT
  43a0: 0a 4e 60 14 4d 05 52 54 4d 50 00 70 47 42 59 54  .N`.M.RTMP.pGBYT
  43b0: 0a 4e 60 7d 60 0a 01 61 53 42 59 54 0a 4e 61 70  .N`}`..aSBYT.Nap
  43c0: 47 42 59 54 0a 50 61 70 47 42 59 54 0a 51 62 79  GBYT.PapGBYT.Qby
  43d0: 61 0a 08 61 7d 61 62 63 7a 63 0a 07 63 79 63 0a  a..a}abczc..cyc.
  43e0: 02 61 72 63 61 63 72 63 0b ac 0a 63 a0 0b 94 63  .arcacrc...c...c
  43f0: 0b 8a 0e 70 0b ac 0a 63 53 42 59 54 0a 4e 60 a4  ...p...cSBYT.N`.
  4400: 63 14 12 53 42 59 54 02 70 68 49 4e 44 53 70 69  c..SBYT.phINDSpi
  4410: 44 41 54 53 14 14 47 42 59 54 01 70 68 49 4e 44  DATS..GBYT.phIND
  4420: 53 70 44 41 54 53 67 a4 67 10 48 11 5c 5f 54 5a  SpDATSg.g.H.\_TZ
  4430: 5f 5b 82 28 46 41 4e 5f 08 5f 48 49 44 0c 41 d0  _[.(FAN_._HID.A.
  4440: 0c 0b 14 18 5f 49 4e 49 00 70 54 50 31 48 43 54  ...._INI.pTP1HCT
  4450: 4f 53 70 54 50 31 4c 43 54 48 59 5b 85 45 0e 54  OSpTP1LCTHY[.E.T
  4460: 48 52 4d 08 5f 41 4c 30 12 06 01 46 41 4e 5f 14  HRM._AL0...FAN_.
  4470: 1e 5f 41 43 30 00 a0 10 7d 50 4c 43 59 50 4c 43  ._AC0...}PLCYPLC
  4480: 59 67 a4 54 50 32 48 a1 06 a4 54 50 31 48 08 5f  Yg.TP2H...TP1H._
  4490: 50 53 4c 12 0c 01 5c 2e 5f 50 52 5f 43 50 55 30  PSL...\._PR_CPU0
  44a0: 08 5f 54 53 50 0a 3c 08 5f 54 43 31 0a 04 08 5f  ._TSP.<._TC1..._
  44b0: 54 43 32 0a 03 14 1e 5f 50 53 56 00 a0 10 7d 50  TC2...._PSV...}P
  44c0: 4c 43 59 50 4c 43 59 67 a4 54 50 31 48 a1 06 a4  LCYPLCYg.TP1H...
  44d0: 54 50 32 48 14 0b 5f 43 52 54 00 a4 54 52 50 43  TP2H.._CRT..TRPC
  44e0: 14 0a 5f 54 4d 50 00 a4 0b b8 0b 14 24 5f 53 43  .._TMP......$_SC
  44f0: 50 01 a0 08 68 70 01 50 4c 43 59 a1 07 70 00 50  P...hp.PLCY..p.P
  4500: 4c 43 59 86 5c 2e 5f 54 5a 5f 54 48 52 4d 0a 81  LCY.\._TZ_THRM..
  4510: 14 31 53 54 4d 50 02 70 69 44 57 30 30 a0 12 68  .1STMP.piDW00..h
  4520: 53 54 48 59 44 42 30 30 44 42 30 31 44 57 30 30  STHYDB00DB01DW00
  4530: a1 11 53 54 4f 53 44 42 30 30 44 42 30 31 44 57  ..STOSDB00DB01DW
  4540: 30 30                                            00

FACS @ 0xbfff0000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0xbfff3040
  0000: 46 41 43 50 74 00 00 00 01 11 49 6e 74 65 6c 52  FACPt.....IntelR
  0010: 41 57 52 44 41 43 50 49 31 2e 30 42 41 57 52 44  AWRDACPI1.0BAWRD
  0020: 00 00 00 00 00 00 ff bf c0 30 ff bf 01 00 09 00  .........0......
  0030: b2 00 00 00 a1 a0 00 00 00 04 00 00 00 00 00 00  ................
  0040: 04 04 00 00 00 00 00 00 00 00 00 00 08 04 00 00  ................
  0050: 28 04 00 00 00 00 00 00 04 02 00 04 08 00 00 00  (...............
  0060: 65 00 e9 03 00 00 00 00 01 01 0d 00 00 00 00 00  e...............
  0070: a5 04 00 00                                      ....

APIC @ 0xbfff7640
  0000: 41 50 49 43 7c 00 00 00 01 58 49 6e 74 65 6c 52  APIC|....XIntelR
  0010: 41 57 52 44 41 43 50 49 31 2e 30 42 41 57 52 44  AWRDACPI1.0BAWRD
  0020: 00 00 00 00 00 00 e0 fe 01 00 00 00 00 08 00 00  ................
  0030: 01 00 00 00 00 08 01 01 01 00 00 00 01 0c 02 00  ................
  0040: 00 00 c0 fe 00 00 00 00 02 0a 00 00 02 00 00 00  ................
  0050: 00 00 02 0a 00 09 09 00 00 00 0d 00 02 0a 00 0e  ................
  0060: 0e 00 00 00 05 00 02 0a 00 0f 0f 00 00 00 05 00  ................
  0070: 04 06 00 05 00 01 04 06 01 05 00 01              ............

RSDT @ 0xbfff3000
  0000: 52 53 44 54 2c 00 00 00 01 5c 49 6e 74 65 6c 52  RSDT,....\IntelR
  0010: 41 57 52 44 41 43 50 49 31 2e 30 42 41 57 52 44  AWRDACPI1.0BAWRD
  0020: 00 00 00 00 40 30 ff bf 40 76 ff bf              ....@0..@v..

RSD PTR @ 0xf7120
  0000: 52 53 44 20 50 54 52 20 a5 49 6e 74 65 6c 52 00  RSD PTR .IntelR.
  0010: 00 30 ff bf                                      .0..


--MP_/3CLjc+L=H7TrDLyXfMQRZDc--
