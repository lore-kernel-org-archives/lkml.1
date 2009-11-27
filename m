Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZK0HoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZK0HoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 02:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZK0HoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 02:44:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51218 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZK0HoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 02:44:20 -0500
Date: Fri, 27 Nov 2009 08:44:17 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: rpurdie@rpsys.net, l.fu@pengutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: leds-pwm: Set led_classdev max_brightness
Message-ID: <20091127074417.GA4721@pengutronix.de>
Mail-Followup-To: Lars-Peter Clausen <lars@metafoo.de>, rpurdie@rpsys.net,
	l.fu@pengutronix.de, linux-kernel@vger.kernel.org
References: <1259299058-23443-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1259299058-23443-1-git-send-email-lars@metafoo.de>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
 Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8,
 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
 +49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 08:32:00 up 10 min,  1 user,  load average: 0.23, 0.46, 0.34
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lars-Peter,

On Fri, Nov 27, 2009 at 06:17:38AM +0100, Lars-Peter Clausen wrote:
> Currently the driver leds-pwm doesn't set max_brightness for the led devi=
ce
> although it's platform data proides a maximum brightness. Instead it stor=
es its
> own private driver struct. The max_brightness defaults to 255 for led dev=
ice if
> it has not been set.
> As a result any leds-pwm device with a different maximum brightness will =
show
> incorrect behavior, as it is posible to either set a longer then period d=
uty
> time or not be able to switch the led to full brightness.
>=20
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks for the patch, however Pls note that the pwm framework has seen
some major changes by Bill Gatliff, including this driver, see
http://lwn.net/Articles/357837/
The patches are pending, but it's quite possible that this driver will
become obsolete soon.
for the patch it self:

Acked-by: Luotao Fu <l.fu@pengutronix.de>

> ---
>  drivers/leds/leds-pwm.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> index cdfdc87..88b1dd0 100644
> --- a/drivers/leds/leds-pwm.c
> +++ b/drivers/leds/leds-pwm.c
> @@ -27,7 +27,6 @@ struct led_pwm_data {
>  	struct pwm_device	*pwm;
>  	unsigned int 		active_low;
>  	unsigned int		period;
> -	unsigned int		max_brightness;
>  };
> =20
>  static void led_pwm_set(struct led_classdev *led_cdev,
> @@ -35,7 +34,7 @@ static void led_pwm_set(struct led_classdev *led_cdev,
>  {
>  	struct led_pwm_data *led_dat =3D
>  		container_of(led_cdev, struct led_pwm_data, cdev);
> -	unsigned int max =3D led_dat->max_brightness;
> +	unsigned int max =3D led_dat->cdev.max_brightness;
>  	unsigned int period =3D  led_dat->period;
> =20
>  	if (brightness =3D=3D 0) {
> @@ -77,10 +76,10 @@ static int led_pwm_probe(struct platform_device *pdev)
>  		led_dat->cdev.name =3D cur_led->name;
>  		led_dat->cdev.default_trigger =3D cur_led->default_trigger;
>  		led_dat->active_low =3D cur_led->active_low;
> -		led_dat->max_brightness =3D cur_led->max_brightness;
>  		led_dat->period =3D cur_led->pwm_period_ns;
>  		led_dat->cdev.brightness_set =3D led_pwm_set;
>  		led_dat->cdev.brightness =3D LED_OFF;
> +		led_dat->cdev.max_brightness =3D cur_led->max_brightness;
>  		led_dat->cdev.flags |=3D LED_CORE_SUSPENDRESUME;
> =20
>  		ret =3D led_classdev_register(&pdev->dev, &led_dat->cdev);
> --=20
> 1.5.6.5
>=20

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksPg1EACgkQkLuxfMCkDTbMjwCfeAJkfltJBBH6Dq18PTst/UOR
/FkAnifVC1SjrmyvPzDCpbV2EW3q625j
=R5+v
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
