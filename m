Return-Path: <linux-kernel-owner+w=401wt.eu-S2993012AbXCIGvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993012AbXCIGvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993015AbXCIGvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:51:04 -0500
Received: from vesl.donpac.ru ([80.254.111.33]:46572 "EHLO vesl.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993012AbXCIGvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:51:02 -0500
Date: Fri, 9 Mar 2007 09:50:56 +0300
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309065055.GA18056@pazke.donpac.ru>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1173419792.32234.131.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <1173419792.32234.131.camel@localhost.localdomain>
X-Uname: Linux 2.6.18-1-amd64 x86_64
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Andrey Panin <pazke@donpac.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 068, 03 09, 2007 at 04:56:32PM +1100, Rusty Russell wrote:
> __builtin_types_compatible_p() has been around since gcc 2.95,

but it's not available in Intel C compiler IIRC :(

> and we don't use it anywhere.  This patch quietly fixes that.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>=20
> diff -r f0ff8138f993 include/linux/kernel.h
> --- a/include/linux/kernel.h	Fri Mar 09 16:40:25 2007 +1100
> +++ b/include/linux/kernel.h	Fri Mar 09 16:44:04 2007 +1100
> @@ -35,7 +35,9 @@ extern const char linux_proc_banner[];
>  #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
>  #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
> =20
> -#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
> +	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
> +		 typeof(&arr[0]))]))*0)
>  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
>  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
>  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFF8QPPIWZCBzwS8mkRAj0HAKCjgMBZmQNIG9ypRL5QjQDGUO0FOgCdEj2r
GYUyko2KRSpiYB3yM+/Fagc=
=3cOy
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
