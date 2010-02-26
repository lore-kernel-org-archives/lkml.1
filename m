Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301Ab0BZQ0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 11:26:42 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:55617 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965244Ab0BZQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 11:26:41 -0500
Date: Fri, 26 Feb 2010 13:20:03 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>,
       Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
       mjg@redhat.com
Subject: Re: [PATCH] backlight, classmate-laptop: fix missing registration
 failure handling
Message-ID: <20100226162002.GE23453@holoscopio.com>
References: <20100221002831.689bace8@neptune.home>
 <20100226125939.7cda6d46@neptune.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9l24NVCWtSuIVIod"
Content-Disposition: inline
In-Reply-To: <20100226125939.7cda6d46@neptune.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9l24NVCWtSuIVIod
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Mathew,

Please apply the following patch.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

On Fri, Feb 26, 2010 at 12:59:39PM +0100, Bruno Pr=C3=A9mont wrote:
> Check newly registered backlight_device for error and properly
> return error to parent.
> Mark struct backlight_ops as const.
>=20
> Signed-off-by: Bruno Pr=C3=A9mont <bonbons@linux-vserver.org>
> ---
>  drivers/platform/x86/classmate-laptop.c |    2 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index bfae789..66f6aad 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -452,7 +452,7 @@ static int cmpc_bl_update_status(struct backlight_dev=
ice *bd)
>  		return -1;
>  }
> =20
> -static struct backlight_ops cmpc_bl_ops =3D {
> +static const struct backlight_ops cmpc_bl_ops =3D {
>  	.get_brightness =3D cmpc_bl_get_brightness,
>  	.update_status =3D cmpc_bl_update_status
>  };
> @@ -463,6 +463,8 @@ static int cmpc_bl_add(struct acpi_device *acpi)
> =20
>  	bd =3D backlight_device_register("cmpc_bl", &acpi->dev,
>  				       acpi->handle, &cmpc_bl_ops);
> +	if (IS_ERR(bd))
> +		return PTR_ERR(bd);
>  	bd->props.max_brightness =3D 7;
>  	dev_set_drvdata(&acpi->dev, bd);
>  	return 0;
> --=20
> 1.6.4.4
>=20

--9l24NVCWtSuIVIod
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuH9LIACgkQyTpryRcqtS0l4gCgmG3Pfqnpbz1VdWjgmJW1jNSS
eQQAn1ooXG2rGjoCRRkfDdMaorljgK0H
=84Ic
-----END PGP SIGNATURE-----

--9l24NVCWtSuIVIod--
