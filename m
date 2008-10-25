Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYJYOy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYJYOy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYJYOyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:54:19 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:34276 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYJYOyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:54:18 -0400
Date: Sat, 25 Oct 2008 16:53:29 +0200
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andres Freund <andres@anarazel.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Current suspend issues on Lenovo X200
Message-ID: <20081025145329.GB4273@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Andres Freund <andres@anarazel.de>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810241628.23002.andres@anarazel.de> <200810241123.17883.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <200810241123.17883.jbarnes@virtuousgeek.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.27-rc9-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jesse Barnes [Fri, Oct 24, 2008 at 11:23:17AM -0700]:
> On Friday, October 24, 2008 7:28 am Andres Freund wrote:
> > Hi Nico,
> >
> > On Thursday 23 October 2008 22:43:26 Nico -telmich- Schottelius wrote:
> > >  - 2.6.27-next-20081023:
> > >    -> no X running (because xorg does not work with that kernel)
> >
> > I think what you need is one rather short fix for the intel xorg driver:
> >
> > diff --git a/src/i830_driver.c b/src/i830_driver.c
> > index c1d61f4..eaf5d27 100644
> > --- a/src/i830_driver.c
> > +++ b/src/i830_driver.c
> > @@ -502,8 +502,8 @@ I830DetectMemory(ScrnInfoPtr pScrn)
> >     range =3D gtt_size + 4;
> >
> >     /* new 4 series hardware has seperate GTT stolen with GFX stolen */
> > - if (IS_G4X(pI830))
> > - range =3D 0;
> > + if (IS_G4X(pI830) || IS_GM45(pI830))
> > + range =3D 4;
> >
> >     if (IS_I85X(pI830) || IS_I865G(pI830) || IS_I9XX(pI830)) {
> >        switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> >
> > (Out of the "[git pull] agp patches for 2.6.28-rc1" thread)
>=20
> Something like this might also help.
>=20
> G4x chips do their own memory arbitration management, so we shouldn't try=
ing
> to save/restore the DSPARB reg.
>=20

I'm a bit confused. Which of both patches against 2.6.28-rc1 should I try?

Nico

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkDMukACgkQuL75KpiFGIxrBACg2JD1oHtb9Hlr9eFq8hWRBZpU
4eYAnA/YjocwX1Ioh3rhRSSJnsaMFqMR
=G3Xr
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
