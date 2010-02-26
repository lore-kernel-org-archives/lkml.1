Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781Ab0BZAl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 19:41:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934756Ab0BZAl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 19:41:26 -0500
Date: Fri, 26 Feb 2010 11:41:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH -next] staging/pohmelfs: fix write_inode parameter
 warning
Message-Id: <20100226114118.097a2470.sfr@canb.auug.org.au>
In-Reply-To: <20100225144122.d9ba8810.randy.dunlap@oracle.com>
References: <20100225183523.80361261.sfr@canb.auug.org.au>
	<20100225144122.d9ba8810.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Feb_2010_11_41_18_+1100_U/_k1ovFM5Z=G9xz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Feb_2010_11_41_18_+1100_U/_k1ovFM5Z=G9xz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Thu, 25 Feb 2010 14:41:22 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> sparse warns that:
> drivers/staging/pohmelfs/inode.c:1797: warning: initialization from incom=
patible pointer type
>=20
> so fix pohmelfs_write_inode() to have the expected parameters.
>=20
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/staging/pohmelfs/inode.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> --- linux-next-20100225.orig/drivers/staging/pohmelfs/inode.c
> +++ linux-next-20100225/drivers/staging/pohmelfs/inode.c
> @@ -396,7 +396,8 @@ int pohmelfs_remove_child(struct pohmelf
>  /*
>   * Writeback for given inode.
>   */
> -static int pohmelfs_write_inode(struct inode *inode, int sync)
> +static int pohmelfs_write_inode(struct inode *inode,
> +				struct writeback_control *wbc)
>  {
>  	struct pohmelfs_inode *pi =3D POHMELFS_I(inode);
> =20

This patch is OK, but depends on changes that are in the vfs tree that
are not in Linus' tree yet.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Feb_2010_11_41_18_+1100_U/_k1ovFM5Z=G9xz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuHGK4ACgkQjjKRsyhoI8wHEACcDXPc7aDTTvfZcniKpdGAzNYy
ohMAn2cNGWd1MH5sG0VVt+FZuAo42Hh/
=zpjA
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Feb_2010_11_41_18_+1100_U/_k1ovFM5Z=G9xz--
