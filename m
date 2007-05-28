Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbXE1WsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbXE1WsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXE1WsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:48:07 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43908 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322AbXE1WsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:48:06 -0400
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <200705281957.38954.rjw@sisk.pl>
References: <4658B7DD.3060309@tmr.com> <465AD746.7090008@tmr.com>
	 <20070528132625.GQ18807@elf.ucw.cz>  <200705281957.38954.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QDg7lGOc2xWnhGLzAYha"
Date: Tue, 29 May 2007 08:48:02 +1000
Message-Id: <1180392482.4149.15.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QDg7lGOc2xWnhGLzAYha
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Mon, 2007-05-28 at 19:57 +0200, Rafael J. Wysocki wrote:
> On Monday, 28 May 2007 15:26, Pavel Machek wrote:
> > Hi!
> >=20
> > > >That's clear, I'll have to use xen or kvm or similar which restores=20
> > > >the system as suspended. Thanks for the clarification of the limitat=
ions.
> > > >
> > > Sorry, I wrote that late at night and quickly. I should have said=20
> > > "design decision" rather than "limitation," For systems which don't d=
o=20
> > > multiple kernels it's not an issue.
> > >=20
> > > I certainly would not have made the same decision, but I didn't write=
=20
> > > the code. It seems more robust to save everything than to try to=20
> > > identify what has and hasn't changed in a modular kernel.
> >=20
> > We rely on atomic copy routine not moving inside the kernel. Yes, it
> > would be possible to copy it to "known good" address and gain ability
> > to resume different kernels. Actually it should not be _that_ hard.
>=20
> Yup.  Don't we do something like this for the (ACPI-based) suspend to RAM
> already?

Yeah, I was thinking about this overnight too. It should be doable. In
addition to what we already do, I think you'd want:

- to copy the assembly to do the copying to a safe page;
- to put the location of the cpu state that was saved in the image
header so that it can be used after the data is copied back;
- to copy the nosave data to a 'safe' page.

What else?

Regards,

Nigel

--=-QDg7lGOc2xWnhGLzAYha
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGW1wiN0y+n1M3mo0RAruKAJ0Sk9ZkzITfKLl3/iIBSqWeauRIFQCgzBCl
UDR4MKa7TKR789sXYlPfPkk=
=uM/a
-----END PGP SIGNATURE-----

--=-QDg7lGOc2xWnhGLzAYha--

