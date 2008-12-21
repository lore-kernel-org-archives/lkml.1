Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbYLUSQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbYLUSQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 13:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLUSQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 13:16:42 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:59143 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbYLUSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 13:16:41 -0500
Subject: Re: [PATCH 2/13] drivers/gpu/drm/i915: Remove redundant test
From: Eric Anholt <eric@anholt.net>
To: Julia Lawall <julia@diku.dk>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812211628230.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211628230.9555@pc-004.diku.dk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VdGcmwoWDP5sAH1cnBtS"
Date: Sun, 21 Dec 2008 10:16:36 -0800
Message-Id: <1229883396.4798.1.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VdGcmwoWDP5sAH1cnBtS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-21 at 16:28 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
>=20
> object_list is checked to be not NULL near the beginning of the function =
and
> is not updated subsequently.
>=20
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
>=20
> // <smpl>

Committed.  Thanks!

> ---
>  drivers/gpu/drm/i915/i915_gem.c     |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_=
gem.c
> index fccf199..78319ec 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -2611,13 +2611,12 @@ i915_gem_execbuffer(struct drm_device *dev, void =
*data,
>  			  "back to user (%d)\n",
>  			   args->buffer_count, ret);
>  err:
> -	if (object_list !=3D NULL) {
> -		for (i =3D 0; i < pinned; i++)
> -			i915_gem_object_unpin(object_list[i]);
> +	for (i =3D 0; i < pinned; i++)
> +		i915_gem_object_unpin(object_list[i]);
> +
> +	for (i =3D 0; i < args->buffer_count; i++)
> +		drm_gem_object_unreference(object_list[i]);
> =20
> -		for (i =3D 0; i < args->buffer_count; i++)
> -			drm_gem_object_unreference(object_list[i]);
> -	}
>  	mutex_unlock(&dev->struct_mutex);
> =20
>  pre_mutex_err:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-VdGcmwoWDP5sAH1cnBtS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklOiAIACgkQHUdvYGzw6vdrqwCghSfgo0EC6SpwgOClXl9APCRy
SXAAnjPIgiwJpebuFJOFlgyH3SIDrBzD
=T7IP
-----END PGP SIGNATURE-----

--=-VdGcmwoWDP5sAH1cnBtS--

