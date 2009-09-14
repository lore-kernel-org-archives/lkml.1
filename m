Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZINMPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZINMPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZINMPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:15:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34012 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZINMPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:15:12 -0400
Date: Mon, 14 Sep 2009 14:15:13 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: regulator: adding constraints to regulator_desc?
Message-ID: <20090914121513.GC3164@pengutronix.de>
References: <20090914104101.GB3164@pengutronix.de> <20090914105714.GA16736@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20090914105714.GA16736@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> The checks at the regulator level should be checking more than can be
> specified in the constraints - they should also be checking that the
> regulator can actually deliver the requested voltage.  It is possible
> that a request could be within the constraints but in between two steps
> that the regulator can deliver and therefore not supportable.  Drivers
> that don't do the additional checks should really be doing them.

I thought about the core just doing the basic checks (inbetween min and max=
),
so the regulator-drivers could still add more checks if needed. Though...

> These checks could be factored out if we change the API for setting
> voltage to work in terms of voltage selectors and force the
> implementation of list_voltage() but it's never seemed worth the hassle

=2E..if that works out and more checks could be done by the core, this woul=
d be
great, I think.

> > One thing which also raised my attention was the beginning of
> > regulator_check_voltage(). It starts with
>=20
> > 	BUG_ON(*min_uV > *max_uV);
>=20
> > Is it really necessary to halt the kernel? Wouldn't a big warning and -=
EINVAL
> > do like at the end of the function?
>=20
> That should also be OK, yes.  The risk is that once you start loosing
> the plot on regulator stuff the system will often die anyway due to
> power problems but WARN_ON and an error would cover the diagnostics just
> as well.

Okay. Will try to prepare a patch this evening.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkquM9EACgkQD27XaX1/VRu45wCgw/CDDJwz+KzU2G4QNZW4NR2O
fScAoLVAnL/Ja3tDgNW+dPXIodIRvtYf
=ol4C
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
