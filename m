Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZLBUbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZLBUbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbZLBUbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:31:42 -0500
Received: from smtp-out26.alice.it ([85.33.2.26]:4900 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZLBUbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:31:42 -0500
Date: Wed, 2 Dec 2009 21:31:31 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Daniel Ribeiro <drwyrm@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, openezx-devel@lists.openezx.org
Subject: Re: [PATCH] leds: Add LED class driver for regulator driven LEDs.
Message-Id: <20091202213131.1393a956.ospite@studenti.unina.it>
In-Reply-To: <1259778235.3588.141.camel@odin>
References: <1259775625-25973-1-git-send-email-ospite@studenti.unina.it>
	<1259778235.3588.141.camel@odin>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Dec_2009_21_31_31_+0100_Z/3DhWz1W8X_RjeO"
X-OriginalArrivalTime: 02 Dec 2009 20:31:45.0997 (UTC) FILETIME=[7771AFD0:01CA738E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Dec_2009_21_31_31_+0100_Z/3DhWz1W8X_RjeO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Dec 2009 18:23:55 +0000
Liam Girdwood <lrg@slimlogic.co.uk> wrote:

> On Wed, 2009-12-02 at 18:40 +0100, Antonio Ospite wrote:
> > This driver provides an interface for controlling LEDs (or vibrators)
> > connected to PMICs for which there is a regulator framework driver.
> >=20
> > This driver can be used, for instance, to control vibrator on all Motor=
ola EZX
> > phones using the pcap-regulator driver services.
> >=20
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
>=20
> Some very minor points below.
>=20

Thanks for reviewing the code.

[...]
> > +
> > +static void led_work(struct work_struct *work)
> > +{
> > +	struct regulator_led *led;
> > +	int voltage;
> > +	int ret;
> > +
> > +	led =3D container_of(work, struct regulator_led, work);
> > +
> > +	mutex_lock(&led->mutex);
> > +
> > +	if (led->value =3D=3D 0) {
>=20
> LED_OFF instead of 0 here ?
>

Ok.

> > +		regulator_led_disable(led);
> > +		goto out;
> > +	}
> > +
> > +	voltage =3D led_regulator_get_vdd(led->vcc, led->value);
> > +	dev_dbg(led->cdev.dev, "brightness: %d voltage: %d",
> > +			led->value, voltage);
> > +
> > +	ret =3D regulator_set_voltage(led->vcc, voltage, voltage);
> > +	if (ret !=3D 0)
> > +		dev_err(led->cdev.dev, "Failed to set voltage %d: %d\n",
> > +			voltage, ret);
>=20
> Some regulators may not support voltage change (via hw design or
> constraints) so set_voltage() will fail. We probably want to handle this
> regulator type so we don't call set_voltage().
>

Ok, I'll read more about the regulator framework to find out how to
check regulator capabilities.

> > +
> > +	regulator_led_enable(led);
> > +
> > +out:
> > +	mutex_unlock(&led->mutex);
> > +}
> > +
[...]
> > +static int regulator_led_probe(struct platform_device *pdev)
> > +{
> > +	struct led_regulator_platform_data *pdata =3D pdev->dev.platform_data;
> > +	struct regulator_led *led;
> > +	struct regulator *vcc;
> > +	int ret;
> > +
> > +	if (pdata =3D=3D NULL) {
> > +		dev_err(&pdev->dev, "no platform data\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	vcc =3D regulator_get(&pdev->dev, pdata->supply);
> > +	if (IS_ERR(vcc)) {
> > +		dev_err(&pdev->dev, "Cannot get vcc for %s\n", pdata->name);
> > +		return PTR_ERR(vcc);;
>=20
> double ;; here
>

Thanks.

[...]

Regards,
   Antonio=20

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Wed__2_Dec_2009_21_31_31_+0100_Z/3DhWz1W8X_RjeO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksWzqMACgkQ5xr2akVTsAFkygCcCNXdtanf9dkZCIIJQ/P5RTr0
2/QAoJ1Yfca7WtSBPde3Z9Ea49Had5my
=WT27
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Dec_2009_21_31_31_+0100_Z/3DhWz1W8X_RjeO--
