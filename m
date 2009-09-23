Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbZIWPPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbZIWPPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbZIWPPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:15:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60305 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZIWPPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:15:35 -0400
Date: Wed, 23 Sep 2009 17:15:38 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [RFC] regulator: add driver for MAX8660/8661
Message-ID: <20090923151538.GD3131@pengutronix.de>
References: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de> <20090922191529.GB4690@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zS7rBR6csb6tI2e1"
Content-Disposition: inline
In-Reply-To: <20090922191529.GB4690@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zS7rBR6csb6tI2e1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

> >  Documentation/power/regulator/max8660.txt |   32 ++
>=20
> Hrm, if we're going to do this we should do it consistently for all the
> drivers.  I think I prefer documentation embedded in the source TBH but
> only a little bit.

Fine with me; I think the chance of being read is bigger if such comments a=
re
embedded in the source.

> > +This chip is a bit nasty because it is a write-only device. Thus, the =
driver
> > +uses shadow registers to keep track of its values. The main problem ap=
pears to
> > +be the initialization: When Linux boots up, we cannot know if the chip=
 is in
> > +the default state or not, so we would have to pass such information in
> > +platform_data. As this adds a bit of complexity to the driver, this is=
 left
> > +out for now until it is really needed.
>=20
> The AB3100 regulator has a somewhat similar problem in that it appears
> to pretty much need some very device specific setup to be done since it
> expects software to do a lot of the bootstrapping.  Your plan of passing
> in platform data and just blatting the device configuration does seem
> reasonable if there's stuff like that.

See mail to Liam.

> > +Note that disabling V3 or V4 has no effect if pin EN34 is driven high =
(pin and
> > +register are ORed, see datasheet).
>=20
> Might be worth exposing this for control via GPIO in a future version of
> the driver.

Hmm, I have the impression that EN34 is usually either driven high or low
constantly. I'd also vote for just adding the GPIO-possibility when it is
needed.

> > +- Make use of the forced PWM modes?
>=20
> regulator_set_mode() - should be fairly straightforward.

I just checked the details again; you can't save power with switching to PW=
M. It
is mainly intended for low-noise systems.

> > +- ARD?
>=20
> I'm not sure what you mean by this?

Me neither :) That's a function of this chip we don't use.

> > +	struct regulator_dev *rdev[0];
>=20
> I'm not a big fan of the 0 length array - just [] ought to do?

OK.

>=20
> > +static int max8660_dcdc_enable(struct regulator_dev *rdev)
> > +{
> > +	int ret;
> > +	struct max8660 *max8660 =3D rdev_get_drvdata(rdev);
> > +	u8 val =3D (rdev_get_id(rdev) =3D=3D MAX8660_V3) ? 1 : 4;
> > +	ret =3D max8660_write(max8660, MAX8660_OVER1, 0xff, val);
> > +	val =3D (rdev_get_id(rdev) =3D=3D MAX8660_V3) ? 0x03 : 0x30;
> > +	return (ret !=3D 0) ? :
> > +		max8660_write(max8660, MAX8660_VCC1, ~val, val & 0x11);
>=20
> Some comments here as to why you're also updating VCC1 would be helpful
> here, it's a bit obscure at the minute.

ACK. Will describe.

> > +		switch (pdata->subdevs[i].id) {
> > +		case MAX8660_V3:
> > +			if (boot_on)
> > +				max8660->shadow_regs[MAX8660_OVER1] |=3D 1;
> > +			break;
>=20
> Might be worth a comment explaining why you're doing this - I believe
> you need this to be done first so that set_voltage() doesn't power
> things off but it's not immediately obvious from the code.

There is a comment:

	/* First loop sets up shadow registers to prevent glitches */

I agree it is suboptimally placed and could be more informative.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--zS7rBR6csb6tI2e1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq6O5oACgkQD27XaX1/VRv0bwCeOIkGFvRlXCBhtPy9VUrQ8V/k
980An0G2lazrHnMriycDADyENLv+HBWs
=ssF/
-----END PGP SIGNATURE-----

--zS7rBR6csb6tI2e1--
