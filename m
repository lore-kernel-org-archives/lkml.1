Return-Path: <linux-kernel-owner+w=401wt.eu-S1762557AbZFNROS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762557AbZFNROS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 13:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZFNROH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 13:14:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51754 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZFNROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 13:14:06 -0400
Date: Sun, 14 Jun 2009 19:14:06 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       devicetree-discuss@ozlabs.org, Magnus Damm <magnus.damm@gmail.com>,
       Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090614171406.GA1010@pengutronix.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <20090614122136.GD3639@local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20090614122136.GD3639@local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Hans,

> > +	uioinfo->irq =3D irq_of_parse_and_map(op->node, 0);
> > +	if (!uioinfo->irq)
> > +		uioinfo->irq =3D UIO_IRQ_NONE;
>=20
> Please don't do this. It's inconsistent if all other UIO drivers require
> people to use UIO_IRQ_NONE and you also allow zero. UIO_IRQ_NONE was
> introduced because 0 may be a legal interrupt number on some platforms.

Yes, well, the '0' vs. 'NO_IRQ' thing is still not fully sorted out AFAIK. =
But
you are possibly right here, as long as irq_of_parse_and_map does return
NO_IRQ, I should explicitly check for it, like this:

	if (uioinfo->irq =3D=3D NO_IRQ)
		uioinfo->irq =3D UIO_IRQ_NONE;

> > +/* Match table for of_platform binding */
> > +static const struct of_device_id __devinitconst uio_of_genirq_match[] =
=3D {
>=20
> checkpatch.pl complains about that. Please check.

Did that, it is a false positive. See here:

http://lkml.indiana.edu/hypermail/linux/kernel/0906.1/02780.html

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko1L94ACgkQD27XaX1/VRsKRwCgkV+etCy/P9oVMZy21qFkhDpW
rlYAoLiY/tAj0womxa/gTg4pkEdXWp/t
=/oK2
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
