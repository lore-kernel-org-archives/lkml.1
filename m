Return-Path: <linux-kernel-owner+w=401wt.eu-S1755614AbZAHUSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614AbZAHUSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759952AbZAHUS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:18:26 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:44492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633AbZAHUSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:18:25 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090108200243.GD24884@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes>
	 <20090108162429.GA24884@logfs.org> <1231434601.8398.9.camel@johannes>
	 <20090108200243.GD24884@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wQg4ACe/OyQVDzA25y5P"
Date: Thu, 08 Jan 2009 21:18:55 +0100
Message-Id: <1231445935.8398.18.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wQg4ACe/OyQVDzA25y5P
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 21:02 +0100, J=C3=B6rn Engel wrote:

> > #define btree_for_each_key(head, geo, key, tmp)	\
> > 	for (key =3D btree_last(head, geo), tmp =3D btree_get_prev_key(head, g=
eo, key);
> > 	     key; key =3D tmp, tmp =3D btree_get_prev_key(head, geo, key))
>=20
> [ Changed the function name above.  It really isn't a lookup, it returns
> a key, not a value.  My fault. ]

Right.

> Looks correct otherwise.  Probably needs a comment that without "tmp" we
> would skip a 0 key.  Or am I the only one who wants to simplify the code
> before spotting this little subtlety?

I, uh, I didn't even realise that. I think the code for
btree_last/btree_get_prev_key isn't correct as is since the 0 key is
valid, but you can't tell whether it returned 0 because it didn't find
anything, or because there was no more entry. Or am I missing something?

> > (and possibly some type-checking variants that hardcode the geo)
> >=20
> > Does that seem correct? And would it be possible to provide btree_last(=
)
> > that takes an void ** and fills it with the last entry, and the same fo=
r
> > lookup_less(), so we can write btree_for_each_entry() too?
>=20
> Not sure what you mean.  Something with the same effect as this?
>=20
> #define btree_for_each_val(head, geo, key, val)				\
> 	 for (key =3D btree_last(head, geo),				\
> 	 		val =3D btree_lookup(head, geo, key);		\
> 	 		val;						\
> 			key =3D btree_get_prev_key(head, geo, key),	\
> 			val =3D btree_lookup(head, geo, key))

Well, that does lots of lookups that don't seem necessary, since a
function like btree_last should be able to return the value right away.
Also, if it was

#define btree_for_each_val(head, geo, key, val)
	for (val =3D btree_last(head, geo, &key);
	     val;
	     val =3D btree_get_prev(head, geo, &key))

it would be more correct, I think?

johannes

--=-wQg4ACe/OyQVDzA25y5P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZl+sAAoJEKVg1VMiehFYjcYQAKM4jn+8Urwa4bauiWis7Qh5
BzCttmfw66PekpOqcAb8OznrDjWu8neC5Q/hD5V5osJYbro6oCXh2gzv7hNPMcA/
TZal+/I4gsWqhP6qq/6Vd/9adURLDPKbH6nZMoEcMJubVDPIVn3kMPrKlaVjRi3r
YJZIjGSg6eyKClUeNfjNL+316HQNL5Ix9E5O4jdoDZx1qOY5viKVgco46+xSaap2
7GoBxrxPeISLrCl8whiq8yrGH8Xmmx8gXC+hIRznMXtAL5J4xyWcI37jKFn88o4W
1pQMwphYbbEA1dyKHhzFRR9PFS3ydLEtMgiKmDVeD2jgCWu0c476lk3GlfLDiH/O
/+TbD4KnftYacNqtgmE0FTVBGGQ8ExSEFIdwVF/bfAIrnHjwrE7a3j5PvoFCjAea
O5XGehsVUclrb5T/2S5Q3AuFraJK3Llqxwa+Eal8Lg4Dm3wMwqU+CSLIlIEEHoss
Uvu5UnZ1fZgTUv8+KQMsHh4mFLMX2mThtOsXuXGF5f5YKwx9p1pDJq3c2FW9W4EU
ploBQT7+/0xBwUXF8YboG8Utm4xCLsO2xXIDrtBmbFqhYIuPS2RNk7YOLYRPPwQ6
DQxjFbgTX8RNP1YgxCEqfy7l5EMgBs8VRWYtcU1X/b3gwVLsaX5tNp3tmoCkbBuv
fyb4OpVRjmm2tKu2Sdn5
=ll8a
-----END PGP SIGNATURE-----

--=-wQg4ACe/OyQVDzA25y5P--

