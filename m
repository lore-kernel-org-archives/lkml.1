Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbYFINKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbYFINKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYFINKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:10:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51420 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYFINKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:10:45 -0400
Date: Mon, 9 Jun 2008 23:10:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Julia Lawall <julia@diku.dk>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/4] drivers/macintosh/therm_adt746x.c: add missing
 of_node_put
Message-Id: <20080609231037.b8aa7561.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0806091421200.16009@ask.diku.dk>
References: <Pine.LNX.4.64.0806091421200.16009@ask.diku.dk>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Jun_2008_23_10_37_+1000_HKYG/_Axzb=z6d7v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jun_2008_23_10_37_+1000_HKYG/_Axzb=z6d7v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jun 2008 14:21:51 +0200 (CEST) Julia Lawall <julia@diku.dk> wrote:
>
> From: Julia Lawall <julia@diku.dk>
>=20
> of_node_put is needed before discarding a value received from
> of_find_node_by_name, eg in error handling code.
>=20
> The semantic patch that makes the change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>=20
> // <smpl>
> @@
> struct device_node *n;
> struct device_node *n1;
> statement S;
> identifier f;
> expression E;
> constant C;
> @@
>=20
> n =3D of_find_node_by_name(...)
> ...
> if (!n) S
> ... when !=3D of_node_put(n)
>     when !=3D n1 =3D f(n,...)
>     when !=3D E =3D n
>     when any
>     when strict
> (
> + of_node_put(n);
>   return -C;
> |
>   of_node_put(n);
> |
>   n1 =3D f(n,...)
> |
>   E =3D n
> |
>   return ...;
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jun_2008_23_10_37_+1000_HKYG/_Axzb=z6d7v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhNK80ACgkQTgG2atn1QN9GFgCfQNgpZmLlg9arSLT+Y8mCW+Xt
9KYAn0p59n2uytbhr13aoaCRdP2w2nKa
=0s7l
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jun_2008_23_10_37_+1000_HKYG/_Axzb=z6d7v--
