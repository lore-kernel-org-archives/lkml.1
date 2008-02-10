Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYBJPRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYBJPRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 10:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYBJPRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 10:17:38 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:32955 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYBJPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 10:17:37 -0500
Date: Sun, 10 Feb 2008 16:17:35 +0100
From: Bastian Blank <bastian@waldi.eu.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
       ndenev@gmail.com, oliver.pntr@gmail.com
Subject: Re: [PATCH] splice: fix user pointer access in get_iovec_page_array()
Message-ID: <20080210151735.GA2810@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
	ndenev@gmail.com, oliver.pntr@gmail.com
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 10, 2008 at 04:47:57PM +0200, Pekka J Enberg wrote:
> From: Bastian Blank <bastian@waldi.eu.org>
>=20
> The commit 8811930dc74a503415b35c4a79d14fb0b408a361 ("splice: missing user
> pointer access verification") added access_ok() to copy_from_user_mmap_se=
m()
> which only ensures we can copy the struct iovecs from userspace to the ke=
rnel
> but we also must check whether we can access the actual memory region poi=
nted
> to by the struct iovec to close the local root exploit.
>=20
> Cc: <stable@kernel.org>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Bastian Blank <waldi@debian.org>

> Index: linux-2.6/fs/splice.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/splice.c
> +++ linux-2.6/fs/splice.c
> @@ -1237,6 +1237,9 @@ static int get_iovec_page_array(const st
>  		if (unlikely(!base))
>  			break;
> =20
> +		if (unlikely(!access_ok(VERIFY_READ, base, len)))
> +			break;
> +
>  		/*
>  		 * Get this base offset and number of pages, then map
>  		 * in the user pages.

--=20
Those who hate and fight must stop themselves -- otherwise it is not stoppe=
d.
		-- Spock, "Day of the Dove", stardate unknown

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkevFY8ACgkQnw66O/MvCNH0wQCfTqiiDfIUaGMGqXeF/ItmZ2Oh
8MQAnjTs1ZgeBskuquocx8QqarKk19+H
=7yeo
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
