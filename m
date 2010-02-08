Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0BHPRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:17:36 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:48341 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0BHPRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:17:33 -0500
Date: Mon, 8 Feb 2010 13:12:31 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-acpi@vger.kernel.org
Cc: don@syst.com.br, len.brown@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] classmate-laptop: use a single MODULE_DEVICE_TABLE to
 get correct aliases
Message-ID: <20100208151230.GB1085@holoscopio.com>
References: <1264201053-14161-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1264201053-14161-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello, Len Brown.

I'd really like this patch below to go into 2.6.33, since it's needed to
load the driver automatically.

Any chance you'd apply it to your tree and send a pull request to Linus?

Regards,
Cascardo.

On Fri, Jan 22, 2010 at 08:57:33PM -0200, Thadeu Lima de Souza Cascardo wro=
te:
> Instead of a MODULE_DEVICE_TABLE for every acpi_driver ids table, we
> create a table containing all ids to export to get a module alias for
> each one.
>=20
> This will fix automatic loading of the driver when one of the ACPI
> devices is not present (like the accelerometer, which is not present in
> some models).
>=20
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  drivers/platform/x86/classmate-laptop.c |   31 +++++++++++++++++++++----=
------
>  1 files changed, 21 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index ed90082..8cb20e4 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -34,6 +34,11 @@ struct cmpc_accel {
>  #define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
> =20
> =20
> +#define CMPC_ACCEL_HID		"ACCE0000"
> +#define CMPC_TABLET_HID		"TBLT0000"
> +#define CMPC_BL_HID		"IPML200"
> +#define CMPC_KEYS_HID		"FnBT0000"
> +
>  /*
>   * Generic input device code.
>   */
> @@ -282,10 +287,9 @@ static int cmpc_accel_remove(struct acpi_device *acp=
i, int type)
>  }
> =20
>  static const struct acpi_device_id cmpc_accel_device_ids[] =3D {
> -	{"ACCE0000", 0},
> +	{CMPC_ACCEL_HID, 0},
>  	{"", 0}
>  };
> -MODULE_DEVICE_TABLE(acpi, cmpc_accel_device_ids);
> =20
>  static struct acpi_driver cmpc_accel_acpi_driver =3D {
>  	.owner =3D THIS_MODULE,
> @@ -366,10 +370,9 @@ static int cmpc_tablet_resume(struct acpi_device *ac=
pi)
>  }
> =20
>  static const struct acpi_device_id cmpc_tablet_device_ids[] =3D {
> -	{"TBLT0000", 0},
> +	{CMPC_TABLET_HID, 0},
>  	{"", 0}
>  };
> -MODULE_DEVICE_TABLE(acpi, cmpc_tablet_device_ids);
> =20
>  static struct acpi_driver cmpc_tablet_acpi_driver =3D {
>  	.owner =3D THIS_MODULE,
> @@ -477,17 +480,16 @@ static int cmpc_bl_remove(struct acpi_device *acpi,=
 int type)
>  	return 0;
>  }
> =20
> -static const struct acpi_device_id cmpc_device_ids[] =3D {
> -	{"IPML200", 0},
> +static const struct acpi_device_id cmpc_bl_device_ids[] =3D {
> +	{CMPC_BL_HID, 0},
>  	{"", 0}
>  };
> -MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
> =20
>  static struct acpi_driver cmpc_bl_acpi_driver =3D {
>  	.owner =3D THIS_MODULE,
>  	.name =3D "cmpc",
>  	.class =3D "cmpc",
> -	.ids =3D cmpc_device_ids,
> +	.ids =3D cmpc_bl_device_ids,
>  	.ops =3D {
>  		.add =3D cmpc_bl_add,
>  		.remove =3D cmpc_bl_remove
> @@ -540,10 +542,9 @@ static int cmpc_keys_remove(struct acpi_device *acpi=
, int type)
>  }
> =20
>  static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
> -	{"FnBT0000", 0},
> +	{CMPC_KEYS_HID, 0},
>  	{"", 0}
>  };
> -MODULE_DEVICE_TABLE(acpi, cmpc_keys_device_ids);
> =20
>  static struct acpi_driver cmpc_keys_acpi_driver =3D {
>  	.owner =3D THIS_MODULE,
> @@ -607,3 +608,13 @@ static void cmpc_exit(void)
> =20
>  module_init(cmpc_init);
>  module_exit(cmpc_exit);
> +
> +static const struct acpi_device_id cmpc_device_ids[] =3D {
> +	{CMPC_ACCEL_HID, 0},
> +	{CMPC_TABLET_HID, 0},
> +	{CMPC_BL_HID, 0},
> +	{CMPC_KEYS_HID, 0},
> +	{"", 0}
> +};
> +
> +MODULE_DEVICE_TABLE(acpi, cmpc_device_ids);
> --=20
> 1.6.6
>=20

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwKd4ACgkQyTpryRcqtS1/3QCfZlcRe3DXvfg+jW4mtcWA6dfM
rjMAoJv8rhLOLNk5ZUpdvG9FO2MxCDUG
=p0xO
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
