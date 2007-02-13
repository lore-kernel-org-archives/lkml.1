Return-Path: <linux-kernel-owner+w=401wt.eu-S1751226AbXBMKDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbXBMKDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 05:03:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXBMKDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 05:03:07 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:3873 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbXBMKDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 05:03:05 -0500
Message-ID: <45D18CCB.3070906@imap.cc>
Date: Tue, 13 Feb 2007 11:02:51 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>, nigel@nigel.suspend2.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <Pine.LNX.4.62.0702120948230.10436@chinchilla.sonytel.be> <20070212150410.GA17400@elf.ucw.cz> <Pine.LNX.4.62.0702121653160.2928@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0702121653160.2928@pademelon.sonytel.be>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF6122A0B994C5158AC683C12"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF6122A0B994C5158AC683C12
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Geert Uytterhoeven schrieb:
> On Mon, 12 Feb 2007, Pavel Machek wrote:

>> > Can't the upper layer just assume -ENOSYS if .resume/.suspend is NUL=
L?
>> > It's nicer if you don't have to implement dummy functions at all.
>>=20
>> Unfortunately, drivers currently assume "NULL =3D=3D nothing is needed=
",

More often than not they assume nothing of the kind.

>> so we'd have t do big search & replace...=20
>=20
> Which means you also cannot easily keep track of which driver supports
> suspend/resume and which doesn't, as there will always be drivers where=
 a
> missing suspend/resume function is correct.

I think those are rare exceptions. They could and should be
asked to make this statement explicit, as you propose:

> Wouldn't it be more sensible to have
>=20
>     .suspend =3D suspend_nothing_to_do
>=20
> instead, and reserve NULL for `not yet implemented'?

NULL is already taken for 'don't know'. So *two* new values
are needed, one for "nothing to do" and one for "not supported".

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigF6122A0B994C5158AC683C12
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF0YzLMdB4Whm86/kRAiNrAJ0WZIiFEUSi0A6Mg+Ns6MlQiWHm9gCfXSGk
lvNMQBP+BTNnuRluEP0XdMY=
=lQF6
-----END PGP SIGNATURE-----

--------------enigF6122A0B994C5158AC683C12--
