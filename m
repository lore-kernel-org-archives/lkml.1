Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbXCaLgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbXCaLgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 07:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXCaLgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 07:36:45 -0400
Received: from mx.laposte.net ([81.255.54.16]:52526 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbXCaLgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 07:36:44 -0400
Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Mikko Tiihonen <mikko.tiihonen@iki.fi>, linux-kernel@vger.kernel.org,
       ranma@tdiedrich.de, om.turyx@gmail.com
In-Reply-To: <m3bqi9u2an.fsf@maximus.localdomain>
References: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
	 <1175294288.32441.6.camel@rousalka.dyndns.org>
	 <m3bqi9u2an.fsf@maximus.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HGtWM+8CkR7eN9QAuh2o"
Organization: Adresse perso
Date: Sat, 31 Mar 2007 13:36:26 +0200
Message-Id: <1175340987.4174.9.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-5.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HGtWM+8CkR7eN9QAuh2o
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[adding some people in CC that expressed interest in the problem before]

Le samedi 31 mars 2007 =C3=A0 12:37 +0200, Krzysztof Halasa a =C3=A9crit :
> Nicolas Mailhot <nicolas.mailhot@laposte.net> writes:
>=20
> > Oh, is looks so close to my system
> >
> > 00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
> > 00: de 10 50 00 0f 00 a0 00 a3 00 01 06 00 00 80 00
> > 10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 11 0c
> > 30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 40: 58 14 11 0c 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
> >                 ^^^^^^^^^^^
> >                 Usual HPET base address
> > 50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff
> > 60: 01 10 00 00 01 14 00 00 01 18 00 00 00 00 f9 ff
> > 70: 10 00 ff ff c1 00 00 00 00 00 04 19 18 d2 80 0d
> >                 ^^
> >                 c1 =3D> HPET disabled (according to your reference)
> >
> > I don't have an HPET toggle in my bios
>=20
> For reference: HPET enabled in BIOS, MSI K9N platinum board:
>=20
> dmesg | grep HPET
> ACPI: HPET (v001 A M I  OEMHPET0 0x02000701 MSFT 0x00000097)
> 	@ 0x000000003ffd5480
> ACPI: HPET id: 0x10de8201 base: 0xfed00000
> time.c: Using 25.000000 MHz WALL HPET GTOD HPET timer.
>=20
> 00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
>         Subsystem: Micro-Star International Co., Ltd. Unknown device 7250
>         Flags: bus master, 66MHz, fast devsel, latency 0
>         I/O ports at 2f00 [size=3D128]
> 00: de 10 62 03 0f 00 a0 00 a2 00 01 06 00 00 80 00
> 10: 01 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 50 72
> 30: 00 00 00 00 00 00 00 00 00 00 00 00 ff 00 00 00
> 40: 62 14 50 72 00 00 d0 fe fa 3e ff 00 fa 3e ff 00
>                 ^^^^^^^^^^^
> Dword at 0x44 indeed seems to be the address
>=20
> 50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 fe 3f
> 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f9 ff
> 70: 10 00 ff ff c5 80 00 00 00 00 45 19 00 c6 40 00
>                 ^^
> Enabled =3D consistent with http://lkml.org/lkml/2006/12/17/69
>=20
> 80: 09 20 00 10 1d 08 00 00 f0 00 00 01 f0 00 00 00
> 90: 00 08 00 00 00 00 00 00 21 47 95 86 ef cd ab 00
> a0: 01 00 00 81 00 00 00 00 00 00 00 00 00 00 00 00
>              ^^
> Not sure about 0xa3, though.
>=20
> b0: 00 00 00 00 00 0a 7f 0a 00 00 00 00 00 00 00 00
> c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 00 00 00 00 00 00 00 00 44 00 00 fe fd d3 00 a0
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00

Here is the full reference on my system

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
        Subsystem: Giga-byte Technology GA-K8N Ultra-9 Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
00: de 10 50 00 0f 00 a0 00 a3 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 11 0c
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 58 14 11 0c 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff
60: 01 10 00 00 01 14 00 00 01 18 00 00 00 00 f9 ff
70: 10 00 ff ff c1 00 00 00 00 00 04 19 18 d2 80 0d
80: 09 20 00 d8 01 01 00 00 c0 00 00 01 00 00 00 00
90: 00 00 00 00 00 00 00 00 21 64 87 a9 de bc 00 00
a0: 03 00 30 c1 00 00 00 00 00 00 00 00 00 00 00 00
b0: 95 02 f4 02 00 08 5f 08 00 00 00 00 00 00 00 00
c0: 35 82 80 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 14 10 01 00 00 00 d0 00 80 30 00 20 61 44 44 11
f0: 5a ff 5f bf 00 00 00 c0 10 ff ff ff 00 00 30 07

I'm crazy enough to test a patch if someone cooks it, but I'm way out of
my depth there :)

--=20
Nicolas Mailhot

--=-HGtWM+8CkR7eN9QAuh2o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkYOR7oACgkQI2bVKDsp8g2+pQCgjAZe/pqTWxT9dIVpvfVMGCaf
a+kAoN/DV0DEvi/isA7hbLNSuVpfbYfF
=MqKe
-----END PGP SIGNATURE-----

--=-HGtWM+8CkR7eN9QAuh2o--
