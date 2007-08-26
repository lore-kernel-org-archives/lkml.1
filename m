Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXHZQBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXHZQBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 12:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbXHZQB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 12:01:28 -0400
Received: from lug-owl.de ([195.71.106.12]:42523 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726AbXHZQB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 12:01:27 -0400
Date: Sun, 26 Aug 2007 18:01:25 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Peter Firefly Lund <firefly@vax64.dk>
Cc: Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, Momchil Velikov <velco@fadata.bg>
Subject: Re: [LV] [PATCH] avoid negative shifts in radix-tree.c
Message-ID: <20070826160125.GQ11718@lug-owl.de>
Mail-Followup-To: Peter Firefly Lund <firefly@vax64.dk>,
	Christoph Lameter <clameter@sgi.com>,
	Christoph Hellwig <hch@infradead.org>, trivial@kernel.org,
	linux-kernel@vger.kernel.org, Momchil Velikov <velco@fadata.bg>
References: <1188051967.18306.45.camel@ls-search>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ickEXl+ukcSQ/3E"
Content-Disposition: inline
In-Reply-To: <1188051967.18306.45.camel@ls-search>
X-Operating-System: Linux mail 2.6.18-4-686
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--4ickEXl+ukcSQ/3E
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-08-25 16:26:07 +0200, Peter Firefly Lund <firefly@vax64.dk> wr=
ote:
> --- lib/radix-tree-old.c	2007-08-25 15:36:40.000000000 +0200
> +++ lib/radix-tree.c	2007-08-25 15:36:51.000000000 +0200
> @@ -980,12 +980,14 @@ radix_tree_node_ctor(void *node, struct=20
> =20
>  static __init unsigned long __maxindex(unsigned int height)
>  {
> -	unsigned int tmp =3D height * RADIX_TREE_MAP_SHIFT;
> -	unsigned long index =3D (~0UL >> (RADIX_TREE_INDEX_BITS - tmp - 1)) >> =
1;
> -
> -	if (tmp >=3D RADIX_TREE_INDEX_BITS)
> -		index =3D ~0UL;
> -	return index;
> +	unsigned int	tmp   =3D=20
> +	int shift =3D RADIX_TREE_INDEX_BITS - height * RADIX_TREE_MAP_SHIFT;
> +	unsigned long	index;
> +
> +	if (shift < 0)
> +		return ~0UL;
> +	else
> +		return ~0UL >> shift;
>  }
> =20
>  static __init void radix_tree_init_maxindex(void)

`index' seems to be unused now?  And indention does neither follow
kernel coding style, nor this file's style. You'd also hammer out
`tmp' and put its initializer right there where it's used.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:               Tr=C3=A4ume nicht von Dein Leben: Lebe Deinen T=
raum!
the second  :

--4ickEXl+ukcSQ/3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG0aPVHb1edYOZ4bsRAnV5AJ4h6Uoe0wFCMTVNdTyK0pkPYhcfNwCgg+T3
moaP5XHNokBiq9Eo3Yw8sFA=
=xUwg
-----END PGP SIGNATURE-----

--4ickEXl+ukcSQ/3E--
