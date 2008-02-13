Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYBMMMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYBMMMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYBMMMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:12:41 -0500
Received: from ozlabs.org ([203.10.76.45]:58538 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbYBMMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:12:40 -0500
Subject: Re: [GIT]: Make LMB code sharable with sparc64.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080213.004120.22092044.davem@davemloft.net>
References: <20080213.004120.22092044.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dkybxUrGkM3vIQDsyQxR"
Date: Wed, 13 Feb 2008 23:12:38 +1100
Message-Id: <1202904758.6974.9.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dkybxUrGkM3vIQDsyQxR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-02-13 at 00:41 -0800, David Miller wrote:
> As I mentioned to a few ppc folks at LCA08 I plan to use
> the LMB code from powerpc as a basis for NUMA support on
> sparc64.
>=20
> There are two changes.
>=20
> 1) Move arch/powerpc/mm/lmb.c to lib/lmb.c, put the main
>    interface bits in include/linux/lmb.h, put arch-specific
>    bits in asm/lmb.h and add Kconfig machinery to build this
>    stuff on sparc64.
>=20
> 2) Fix a bug in lmb_alloc() wherein the size was not aligned
>    so we could easily run out of reserve blocks because
>    every aligned allocation would create a tiny hole, and
>    secondly the lmb_reserve() call there did not have it's
>    return value checked.
>=20
> Powerpc folks, if there are no objections please pull, thanks!

Looks like there are a few places (in arch/powerpc) that were getting
asm/prom.h via asm/lmb.h, I'll send a patch in the morning.

cheers

arch/powerpc/mm/numa.c:124: error: implicit declaration of function 'of_fin=
d_node_by_type'

arch/powerpc/platforms/ps3/os-area.c:215: error: variable 'property_rtc_dif=
f' has initializer but incomplete type

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-dkybxUrGkM3vIQDsyQxR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHst62dSjSd0sB4dIRAnHCAJ0WXswnzsz4BVnMzg+bhO1iYQvDbACeMm+i
R9+GOvHdGVJkibSkG/wjhZ8=
=oB+G
-----END PGP SIGNATURE-----

--=-dkybxUrGkM3vIQDsyQxR--

