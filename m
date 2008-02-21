Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYBUTU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYBUTU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbYBUTUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:20:15 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:51450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbYBUTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:20:13 -0500
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080220195913.GE21139@uranus.ravnborg.org>
References: <1203503909.17534.14.camel@johannes.berg>
	 <20080220195913.GE21139@uranus.ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GTQatHHLnXsC1L7lGGVz"
Date: Thu, 21 Feb 2008 13:42:56 +0100
Message-Id: <1203597776.20331.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GTQatHHLnXsC1L7lGGVz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

>> [patch doing CHECKFLAGS +=3D -D__CHECK_ENDIAN__ in the
>> net/mac80211/Makefile]

> I would prefer it to be kernel wide enabled.
> Tried a defconfig build.

Hm. I tend to think there was a reason for this, since this is actually
explicitly disabled by include/linux/types.h:

#ifdef __CHECKER__
#define __bitwise__ __attribute__((bitwise))
#else=20
#define __bitwise__
#endif

#ifdef __CHECK_ENDIAN__
#define __bitwise __bitwise__
#else
#define __bitwise
#endif

The commit that introduced __CHECK_ENDIAN__ was
af4ca457eaf2d6682059c18463eb106e2ce58198 ("gfp_t: infrastructure") but
it doesn't say anything about the rationale for it.

> When I enabled __CHECK_ENDIAN I got:
> 8 files with > 100 warnings
> 14 files with 10 to 99 warnings.
>=20
> So nothing that should scare a kernel hacker...
>=20
> warnings without: 1686
> warnings with: 2788
>=20
> OK - thats a lot, but then fixing 8 files will significantly
> reduce this.

I recently ran sparse on my config and was surprised by the number of
warnings. Then again, something in mmzone.h or so generated billions of
them...

In any case, I would love to have __CHECK_ENDIAN__ enabled by default at
least on the wireless code (just caught another bug with it...)

johannes

--=-GTQatHHLnXsC1L7lGGVz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR71xz6Vg1VMiehFYAQKl+BAAvgqz5hT+aIU5/xJSoTEY7wVE/5mrv23S
TbJW+52SchPOyUjgX1Wpv2qbXUfqxk+/BgcJjK9a/0cWCqOnV3L2HNsYmIoIg7hD
Y6gEy/xzd+WQsa92hHhlzD7vvvYleDge/r0HC01i6567Gtzsa9cljdELMk4bYqdN
YxTZPev9ry46f83QE8b7I+H3KxtQuvBDU2YjvC82GWsKjiHbAklZslAfqxAg3aDa
Fo9P6qjcKFy46oXbLL5meoPPYEvO4qjvJq47esVObrDa4IfQtes5Q6FAUJ5vkoDp
9tcfUWNAWHMMVO3841CkkLqyImQiktcKr8pLCArzrBXqGub7qIVrZuCsCjz/clTT
BR/4gt+GCN/3LRihbPZjpfrc8UX0yfaCcp1OyjnAKGkcTMl68ClP8tIb55N+FZWa
Mv3DOOru1pju3+ACb4AXmK9auzKpgKR1kR0xxB4HWA1yHeklYxZ9QP6c4MPpJtf5
3uh3obTpNGaGr9ECTNXirE89ps8M8VCnBMnzLIBBf3H4Eu1IgrB5b0+85CB9jzhL
PzAd8kuBMUhS/tmaa/3kR6dD8qpOeLHykqtNq4zk96ORDJcdHOmNX0rz9ZXHnEzB
4ADpjdhGC7wjf4tEoNAK8F1dLye8gBXKy/H1F8FjX622zluTeb6DRQHkrA4ymePx
ZnZZNKPgqSs=
=a10Z
-----END PGP SIGNATURE-----

--=-GTQatHHLnXsC1L7lGGVz--

