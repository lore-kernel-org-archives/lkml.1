Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYKNPPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYKNPPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 10:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYKNPPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 10:15:24 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:56138 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYKNPPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 10:15:23 -0500
Date: Fri, 14 Nov 2008 16:15:22 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andres Freund <andres@anarazel.de>
Subject: Re: Current suspend issues on Lenovo X200
Message-ID: <20081114151522.GD4877@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
References: <20081023204326.GB4175@denkbrett.schottelius.org> <200810241123.17883.jbarnes@virtuousgeek.org> <20081025145329.GB4273@denkbrett.schottelius.org> <200811121024.44502.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <200811121024.44502.jbarnes@virtuousgeek.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc4-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jesse Barnes [Wed, Nov 12, 2008 at 10:24:44AM -0800]:
> On Saturday, October 25, 2008 7:53 am Nico -telmich- Schottelius wrote:
> > Jesse Barnes [Fri, Oct 24, 2008 at 11:23:17AM -0700]:
> > > On Friday, October 24, 2008 7:28 am Andres Freund wrote:
> > > > Hi Nico,
> > > >
> > > > On Thursday 23 October 2008 22:43:26 Nico -telmich- Schottelius wro=
te:
> > > > >  - 2.6.27-next-20081023:
> > > > >    -> no X running (because xorg does not work with that kernel)
> > > >
> > > > I think what you need is one rather short fix for the intel xorg
> > > > driver:
> > > >
> > > > diff --git a/src/i830_driver.c b/src/i830_driver.c
> > > > index c1d61f4..eaf5d27 100644
> > > > --- a/src/i830_driver.c
> > > > +++ b/src/i830_driver.c
> > > > @@ -502,8 +502,8 @@ I830DetectMemory(ScrnInfoPtr pScrn)
> > > >     range =3D gtt_size + 4;
> > > >
> > > >     /* new 4 series hardware has seperate GTT stolen with GFX stole=
n */
> > > > - if (IS_G4X(pI830))
> > > > - range =3D 0;
> > > > + if (IS_G4X(pI830) || IS_GM45(pI830))
> > > > + range =3D 4;
> > > >
> > > >     if (IS_I85X(pI830) || IS_I865G(pI830) || IS_I9XX(pI830)) {
> > > >        switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
> > > >
> > > > (Out of the "[git pull] agp patches for 2.6.28-rc1" thread)
> > >
> > > Something like this might also help.
> > >
> > > G4x chips do their own memory arbitration management, so we shouldn't
> > > trying to save/restore the DSPARB reg.
> >
> > I'm a bit confused. Which of both patches against 2.6.28-rc1 should I t=
ry?
>=20
> Have you tried recent (last few days) git bits of the kernel and xf86-vid=
eo-
> intel?

Yep, sorry, opened a new thread. Issue got better (console works without s3=
_bios),
but xorg still reboots the system. I'll try the referenced workaround at
http://ubuntuforums.org/showpost.php?p=3D6105510&postcount=3D12

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdlgoACgkQuL75KpiFGIyaRACfcL6IAOpQet4XGniJ48sQ1EiU
AhMAn1iKLbUA1FnY9KQqKHNqE59041vZ
=RcTs
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
