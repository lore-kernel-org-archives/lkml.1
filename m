Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbZKPWbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbZKPWbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZKPWbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:31:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46665 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753587AbZKPWbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:31:49 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       504391@bugs.debian.org, Wouter van Heyst <larstiq@larstiq.dyndns.org>,
       Pierre Ossman <pierre@ossman.eu>
In-Reply-To: <20091116122329.847916b6.akpm@linux-foundation.org>
References: <1257914676.2237.57.camel@localhost>
	 <20091116122329.847916b6.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W9vWkOllP0aZEQaTRHND"
Date: Mon, 16 Nov 2009 22:31:49 +0000
Message-ID: <1258410709.2792.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W9vWkOllP0aZEQaTRHND
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-16 at 12:23 -0800, Andrew Morton wrote:
> On Wed, 11 Nov 2009 04:44:36 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > Some people run general-purpose distribution kernels on netbooks with
> > a card that is physically non-removable or logically non-removable
> > (e.g. used for /home) and cannot be cleanly unmounted during suspend.
> > Add a module parameter to set whether cards are assumed removable or
> > non-removable, with the default set by CONFIG_MMC_UNSAFE_RESUME.
> >=20
>=20
> The description really doesn't give me enough info to work out what's
> happening here and why this is being proposed.  But it smells nasty.

In general, it is not possible to tell whether a card present in an MMC
slot after resume is the same that was there before suspend.  So there
are two possible behaviours, each of which will cause data loss in some
cases:

CONFIG_MMC_UNSAFE_RESUME=3Dn (default): Cards are assumed to be removed
during suspend.  Any filesystem on them must be unmounted before
suspend; otherwise, buffered writes will be lost.

CONFIG_MMC_UNSAFE_RESUME=3Dy: Cards are assumed to remain present during
suspend.  They must not be swapped during suspend; otherwise, buffered
writes will be flushed to the wrong card.

Currently the choice is made at compile time and this allows that to be
overridden at module load time.

[...]
> > diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> > index d98b0e2..010c964 100644
> > --- a/drivers/mmc/core/core.c
> > +++ b/drivers/mmc/core/core.c
> > @@ -48,6 +48,22 @@ int use_spi_crc =3D 1;
> >  module_param(use_spi_crc, bool, 0);
> > =20
> >  /*
> > + * We normally treat cards as removed during suspend if they are not
> > + * known to be on a non-removable bus, to avoid the risk of writing
> > + * back data to a different card after resume.  Allow this to be
> > + * overridden if necessary.
> > + */
>=20
> So we have a module parameter which nobody knows about.  If they don't
> set this parameter which they don't know about, the kernel will trash
> their filesystem??
[...]

No, because it's set to 1 by default.  There is no change in the default
behaviour.

Ben.

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-W9vWkOllP0aZEQaTRHND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASwHSyue/yOyVhhEJAQISAw//WPHwVO/H7yYuH3uH0mXxSsd2tXRD83KO
jUJ2km6J5ofDNS9MOYgigXOJibd75EajB5W40iJtCxixA7tK2aLJpcKcuRbJ35eZ
QcQRcMyhG/kVcY8q4kCTgZJdTCRcf+4GoGSyht2JOVxymxjA14tHQvXbu29d4peu
SPHKYoz6F3jMqErhJ4KsKvfp1AIhx3mrbVhd5kAzaWp1hjfc7lAwNawl88QqsGGY
J12waj9mTKhOpPUggUvXgF1JF91l58sxKYJJ/A3v4TWxloNm/R0J0LLpcuU7r9Qe
f8yKd12bizCmHvBKYOAgExPH2sT3tVfd2jb7yBN29Ya9X1kRZ9x91SOMZNvVM4+C
hA7UrgXoZE16P4u9dRATH4dNRENTEOtAtCUFjkM6krywM5kQiEBvWixuuguBSa2A
DwzsQLQto+GCmYzgN3HMtWRjOzp7CGDEwqo2YmfR/UkiKiMMTy4rGTV6c43ePerw
WWXyTOdEwH/W4kJtGiksv4p0geUaJHa4Ol0lzCumPyILs3WaWKH5W3MZlM0oOvm8
wfNl0U1j0ZYRZCwSxSvMwNaZ2wqeeviMHuTf84zIuggvwChaWpsVOGtaEzalWdeP
G26/Zf/5Nrwn8s3Of6DQmMgCb5amGH4h3ShQ1y0dP9GSKYSsubHgZN6Hzmxk2wWO
ROAb4pRQKRQ=
=tVra
-----END PGP SIGNATURE-----

--=-W9vWkOllP0aZEQaTRHND--
