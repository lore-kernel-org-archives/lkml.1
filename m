Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbZIXSH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbZIXSH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZIXSHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:07:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57888 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZIXSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:07:24 -0400
Date: Thu, 24 Sep 2009 20:07:27 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: add driver for MAX8660/8661
Message-ID: <20090924180727.GA6408@pengutronix.de>
References: <1253798645-9493-1-git-send-email-w.sang@pengutronix.de> <20090924173904.GA9082@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20090924173904.GA9082@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > +	if (MAX8660_DCDC_MIN_UV + selector * MAX8660_DCDC_STEP > max_uV)
> > +		return -EINVAL;
>=20
> Not important but using list_voltage() here would be a little nicer.

Well, uhm, yeah :)

> > +static struct regulator_ops max8660_dcdc_ops =3D {
> > +	.is_enabled =3D max8660_dcdc_is_enabled,
> > +	.list_voltage =3D max8660_dcdc_list,
> > +	.set_voltage =3D max8660_dcdc_set,
> > +	.get_voltage =3D max8660_dcdc_get,
> > +	/* no set_mode() & friends: forced PWM does not save any power */
>=20
> Forced PWM is normally a power loss - the benefit it gives is the
> ability to respond to sudden spikes in load without voltage droops.  The
> power benefit from not having it enabled is usually only apparent at
> lower loads.

Understood. Well, as this chip automatically switches PWM on/off depending =
on
the load (formula is in the datasheet), it seems to me that the forced-PWM =
mode
is mainly used for systems which prefer low-noise on the signal. So, the ab=
ove
comment could just be dropped. Liam, could you do this, or shall I resend?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq7tV8ACgkQD27XaX1/VRuiMgCgtrMkTgt1pjusl1eros85Z6cZ
k6IAn0/2dqbol7/ToE/cmQMjXFeCWLSC
=XJBS
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
