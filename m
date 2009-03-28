Return-Path: <linux-kernel-owner+w=401wt.eu-S1755332AbZC1JYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbZC1JYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbZC1JYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:24:22 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:33581 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZC1JYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=aHo/FhlEBYRltIw8R1Y0brnACJao5gl6+jUn1WZ6Nny/gm3RICnsDgNrjVco2aDpny
         7HYE0ytL1I6dzwLOBX+RoHSDqRZ8kHdV3bOiIa5LKQKhUQv15tEoZut5z6yhpg/BTd+l
         5tL8ue30vLqVjkgmUcc6la/gAjDP3V1uBXmEo=
Date: Sat, 28 Mar 2009 10:25:20 +0100
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Kristoffer Ericson <Kristoffer.Ericson@gmail.com>,
       Andriy Skulysh <askulysh@gmail.com>, Antonino Daplas <adaplas@pol.net>
Subject: Re: [PATCH 20/58] move hp680-bl's probe function to .devinit.text
Message-Id: <20090328102520.ef5e5faa.kristoffer.ericson@gmail.com>
In-Reply-To: <1238196439-16535-20-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	<1238196439-16535-20-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__28_Mar_2009_10_25_20_+0100_+CwvVWlHMNF1Vhpn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__28_Mar_2009_10_25_20_+0100_+CwvVWlHMNF1Vhpn
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

On Sat, 28 Mar 2009 00:26:41 +0100
Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> wrote:

> A pointer to hp680bl_probe is passed to the core via
> platform_driver_register and so the function must not disappear when the
> .init sections are discarded.  Otherwise (if also having HOTPLUG=3Dy)
> unbinding and binding a device to the driver via sysfs will result in an
> oops as does a device being registered late.
>=20
> An alternative to this patch is using platform_driver_probe instead of
> platform_driver_register plus removing the pointer to the probe function
> from the struct platform_driver.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Cc: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Richard Purdie <rpurdie@linux.intel.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andriy Skulysh <askulysh@gmail.com>
> Cc: Antonino Daplas <adaplas@pol.net>
> ---
>  drivers/video/backlight/hp680_bl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight=
/hp680_bl.c
> index 5be55a2..7fb4eef 100644
> --- a/drivers/video/backlight/hp680_bl.c
> +++ b/drivers/video/backlight/hp680_bl.c
> @@ -103,7 +103,7 @@ static struct backlight_ops hp680bl_ops =3D {
>  	.update_status  =3D hp680bl_set_intensity,
>  };
> =20
> -static int __init hp680bl_probe(struct platform_device *pdev)
> +static int __devinit hp680bl_probe(struct platform_device *pdev)
>  {
>  	struct backlight_device *bd;
> =20
> --=20
> 1.6.2
>=20


--=20
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Signature=_Sat__28_Mar_2009_10_25_20_+0100_+CwvVWlHMNF1Vhpn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknN7QAACgkQPQls10ERAGdmjQCg3DjjDMuvDoAMedE62D+X2Mwz
MUcAoNITjzFKpyb5rkk8daz1+utqGq5k
=VhpW
-----END PGP SIGNATURE-----

--Signature=_Sat__28_Mar_2009_10_25_20_+0100_+CwvVWlHMNF1Vhpn--
