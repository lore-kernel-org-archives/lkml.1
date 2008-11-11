Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYKKW22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYKKW22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYKKW2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:28:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:49668 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750886AbYKKW2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:28:18 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18RcgxnKl4RXmKZF84i31WPss/01gK09/Lfexb78n
	zFHGYWS3W11xrv
From: Stefan Lippers-Hollmann <s.L-H@gmx.de>
To: gregkh@suse.de
Subject: Re: patch md-linear-fix-a-division-by-zero-bug-for-very-small-arrays.patch added to 2.6.27-stable tree
Date: Tue, 11 Nov 2008 23:28:14 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, maan@systemlinux.org, neilb@suse.de,
       stable@kernel.org
References: <20081111180958.4480949037@coco.kroah.org>
In-Reply-To: <20081111180958.4480949037@coco.kroah.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3558550.keiyoaXv55";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811112328.15522.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3558550.keiyoaXv55
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi

On Dienstag, 11. November 2008, gregkh@suse.de wrote:
>=20
> This is a note to let you know that we have just queued up the patch titl=
ed
>=20
>     Subject: md: linear: Fix a division by zero bug for very small arrays.
> Subject: md: linear: Fix a division by zero bug for very small arrays.
>=20
> to the 2.6.27-stable tree.  Its filename is
>=20
>     md-linear-fix-a-division-by-zero-bug-for-very-small-arrays.patch
>=20
> A git repo of this tree can be found at=20
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue.g=
it;a=3Dsummary
>=20
>=20
> From jejb@kernel.org  Tue Nov 11 09:47:32 2008
> From: Andre Noll <maan@systemlinux.org>
> Date: Fri, 7 Nov 2008 00:07:46 GMT
> Subject: md: linear: Fix a division by zero bug for very small arrays.
> To: stable@kernel.org
> Message-ID: <200811070007.mA707k6d006270@hera.kernel.org>
>=20
> From: Andre Noll <maan@systemlinux.org>
>=20
> commit f1cd14ae52985634d0389e934eba25b5ecf24565 upstream
>=20
> Date: Thu, 6 Nov 2008 19:41:24 +1100
> Subject: md: linear: Fix a division by zero bug for very small arrays.
>=20
> We currently oops with a divide error on starting a linear software
> raid array consisting of at least two very small (< 500K) devices.
>=20
> The bug is caused by the calculation of the hash table size which
> tries to compute sector_div(sz, base) with "base" being zero due to
> the small size of the component devices of the array.
>=20
> Fix this by requiring the hash spacing to be at least one which
> implies that also "base" is non-zero.
>=20
> This bug has existed since about 2.6.14.
>=20
> Signed-off-by: Andre Noll <maan@systemlinux.org>
> Signed-off-by: NeilBrown <neilb@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  drivers/md/linear.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -157,6 +157,8 @@ static linear_conf_t *linear_conf(mddev_
> =20
>  	min_spacing =3D conf->array_sectors / 2;
>  	sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
> +	if (min_sectors =3D=3D 0)
> +		min_sectors =3D 1;
> =20
>  	/* min_spacing is the minimum spacing that will fit the hash
>  	 * table in one PAGE.  This may be much smaller than needed.

drivers/md/linear.c: In function 'linear_conf':
drivers/md/linear.c:160: error: 'min_sectors' undeclared (first use in this=
 function)
drivers/md/linear.c:160: error: (Each undeclared identifier is reported onl=
y once
drivers/md/linear.c:160: error: for each function it appears in.)
make[5]: *** [drivers/md/linear.o] Error 1
make[4]: *** [drivers/md] Error 2
make[4]: *** Waiting for unfinished jobs....

This one obviously depends on:

commit 23242fbb470ff4c8c4d41f178832cf1929273d7d
Author: Andre Noll <maan@systemlinux.org>
Date:   Mon Oct 13 11:55:12 2008 +1100

    md: linear.c: Make two local variables sector-based.

which in turn depends on previous changes.

Regards
	Stefan Lippers-Hollmann

--nextPart3558550.keiyoaXv55
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkaBv8ACgkQORbEMfgJlPYOpQCaA7n8J9zmk5hgRuYK9PJaPAKw
hHMAn34BAUozxSHoWH7PyrTcDlnxzjvo
=g2LO
-----END PGP SIGNATURE-----

--nextPart3558550.keiyoaXv55--
