Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbXE2NOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbXE2NOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 09:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXE2NOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:14:00 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40339 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbXE2NN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:13:59 -0400
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <20070529124052.GH23046@elf.ucw.cz>
References: <4658B7DD.3060309@tmr.com>
	 <1180392482.4149.15.camel@nigel.suspend2.net>
	 <20070529112952.GA23046@elf.ucw.cz> <200705291403.09773.rjw@sisk.pl>
	 <20070529124052.GH23046@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5K7qlT8+zy1POt6C6Q49"
Date: Tue, 29 May 2007 23:13:45 +1000
Message-Id: <1180444425.20718.33.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5K7qlT8+zy1POt6C6Q49
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-29 at 14:40 +0200, Pavel Machek wrote:
> On Tue 2007-05-29 14:03:07, Rafael J. Wysocki wrote:
> > On Tuesday, 29 May 2007 13:29, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > > Yup.  Don't we do something like this for the (ACPI-based) suspen=
d to RAM
> > > > > already?
> > > >=20
> > > > Yeah, I was thinking about this overnight too. It should be doable.=
 In
> > > > addition to what we already do, I think you'd want:
> > > >=20
> > > > - to copy the assembly to do the copying to a safe page;
> > > > - to put the location of the cpu state that was saved in the image
> > > > header so that it can be used after the data is copied back;
> > >=20
> > > ...alternatively, we can just rely on copy routine (and its data) not
> > > changing frequently.
> > >=20
> > > > - to copy the nosave data to a 'safe' page.
> > > >=20
> > > > What else?
> > >=20
> > > page directories need to be on a safe place, too.
> >=20
> > They are already.
>=20
> ...but will that place still be safe when we use other version of
> kernel?

They'll be in the image too, won't they? Failing that, the information
could be stored in the image header.

> Anyway, pagedirs are on the safe place, right? That means that we
> swsusp should no longer clash with page allocation debugging...=20

You mean DEBUG_PAGEALLOC? That can be overcome easily - I have code in
current Suspend2 that works with DEBUG_PAGEALLOC. I handle the page
fault, mapping the page and setting a flag in the fault handler to tell
the atomic copy code to unmap the page again once it has been copied.

Regards,

Nigel

--=-5K7qlT8+zy1POt6C6Q49
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXCcJN0y+n1M3mo0RAsxgAJsFrEoiRgagMSmA4g1iXGUgM6z+HwCgysFX
6SK7XO1C1ZezvIzGfRYu39Q=
=xZDU
-----END PGP SIGNATURE-----

--=-5K7qlT8+zy1POt6C6Q49--

