Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbZIWOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbZIWOiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbZIWOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:38:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47840 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZIWOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:38:12 -0400
Date: Wed, 23 Sep 2009 16:38:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC] regulator: add driver for MAX8660/8661
Message-ID: <20090923143815.GC3131@pengutronix.de>
References: <1253625499-9314-1-git-send-email-w.sang@pengutronix.de> <1253629577.11624.278.camel@vega>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline
In-Reply-To: <1253629577.11624.278.camel@vega>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

> Fwiw, the WM8350 has several similar boot up modes. Luckily we can read
> back this device to determine mode and any boot loader config. It may
> also be required to add any shadow register changes to your
> platform_data. i.e. if boot loader does any writes.

While I thought about how to achieve that (Specify voltages and convert them
back to selector-values? Ask for the selector value? Enforce a complete
register set?), I concluded that there are lots of details in here, and I'd
spare that for the case when it is actually needed. In our case, it is not.

> Btw, have you tried register read back ? The data sheet mentions a
> "bidirectional" I2C SDA line implying the device registers can be read
> back, even though they are all marked W in the register map.

The line itself has the capability of being bidirectional, still the chips =
has
no logic for being read. Page 37 states:

"The MAX8660/MAX8661 are write-only devices and recognize the 'write byte'
protocol as defined in the SMBus specification and shown in section A of Fi=
gure
11..."

And to be very sure, I just tried a read -> '-EIO'


>=20
> > +The Target Voltage 2 Registers for V3, V4 and V5 are not used by this =
driver.
> > +
> > +Note that disabling V3 or V4 has no effect if pin EN34 is driven high =
(pin and
> > +register are ORed, see datasheet).
> > +
>=20
> Sounds like EN34 status should be in platform_data.

Good idea, will implement that.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkq6MtcACgkQD27XaX1/VRutcQCfQVf9C9MrN7GcAimvUHnvEzVA
chcAoJ/H5rjDzGK8Yj51+2NxaaiQat36
=nxMg
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
