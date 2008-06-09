Return-Path: <linux-kernel-owner+w=401wt.eu-S1760714AbYFINIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714AbYFINIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYFINH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:07:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51372 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757029AbYFINH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:07:59 -0400
Date: Mon, 9 Jun 2008 23:07:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Julia Lawall <julia@diku.dk>
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/4] drivers/macintosh/smu.c: add missing of_node_put
Message-Id: <20080609230752.f3bba16d.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0806091420080.16009@ask.diku.dk>
References: <Pine.LNX.4.64.0806091420080.16009@ask.diku.dk>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Jun_2008_23_07_52_+1000_0BjiwbtP=/FvICFL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jun_2008_23_07_52_+1000_0BjiwbtP=/FvICFL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Jun 2008 14:20:42 +0200 (CEST) Julia Lawall <julia@diku.dk> wrote:
>
> From: Julia Lawall <julia@diku.dk>
>=20
> of_node_put is needed before discarding a value received from
> of_find_node_by_type, eg in error handling code.
>=20
> The semantic patch that makes the change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
>=20
> // <smpl>
> @@
> struct device_node *n;
> struct device_node *n1;
> struct device_node *n2;
> statement S;
> identifier f1,f2;
> expression E1,E2;
> constant C;
> @@
>=20
> n =3D of_find_node_by_type(...)
> ...
> if (!n) S
> ... when !=3D of_node_put(n)
>     when !=3D n1 =3D f1(n,...)
>     when !=3D E1 =3D n
>     when any
>     when strict
> (
> + of_node_put(n);
>   return -C;
> |
>   of_node_put(n);
> |
>   n2 =3D f2(n,...)
> |
>   E2 =3D n
> |
>   return ...;
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

However, the error handling in that routine (smu_init) needs much more
work.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jun_2008_23_07_52_+1000_0BjiwbtP=/FvICFL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhNKygACgkQTgG2atn1QN/lkQCgkl0CJwmYb6tvLd2Aud371RIC
krEAn2DljxkHbnta4ey6eG4yORJaRxHH
=EEnX
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jun_2008_23_07_52_+1000_0BjiwbtP=/FvICFL--
