Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbZAHRJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbZAHRJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZAHRJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:09:33 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:43074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZAHRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:09:33 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090108162429.GA24884@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes>
	 <20090108162429.GA24884@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rJg1rg2riHZIgjZlWNjZ"
Date: Thu, 08 Jan 2009 18:10:01 +0100
Message-Id: <1231434601.8398.9.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rJg1rg2riHZIgjZlWNjZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 17:24 +0100, J=C3=B6rn Engel wrote:

> If you want to open-code it, you can use btree_lookup_less().  I added
> that function sometime last month.  Basically something like this:
> 	key =3D btree_last(head, geo);
> 	while (key) {
> 		/* do something with key */
> 		key =3D btree_lookup_less(head, geo, key);
> 	}

Ok, so looking deeper into this, how about adding

#define btree_for_each_key(head, geo, key, tmp)	\
	for (key =3D btree_last(head, geo), tmp =3D btree_lookup_less(head, geo, k=
ey);
	     key; key =3D tmp, tmp =3D btree_lookup_less(head, geo, key))

(and possibly some type-checking variants that hardcode the geo)

Does that seem correct? And would it be possible to provide btree_last()
that takes an void ** and fills it with the last entry, and the same for
lookup_less(), so we can write btree_for_each_entry() too?

johannes

--=-rJg1rg2riHZIgjZlWNjZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZjNnAAoJEKVg1VMiehFYVs0P+wYzdwGw+c3SRquRWQc9EWfi
2YzCwz8lmiru9njcpFtg7ihSWnCcrPSTMue7TqfY1I8yTbxyZ0T9uR8VxPlVllfj
EuQrB0jLDfaI5m5K6zFqbg2HEUVSzEgWMaq/UfaZ6RtKpBYJyY2S33xu7zrZdiyw
75BDD+aMENxdWMqG8+Y+4SlAyt4TE2TR9P8XRD/Z8p01Sr2AsnxEEkwFOuzIKd71
QxPP0BrGjm0zbwg13hxCsCmIXktgZdKJl9lmbLkz0zFLp5Zh79SgWPDekuYZLJg5
syrU50CjZi8FCcS7rPLUempzAMv2Bz9NW/zxo5E9d5XwL2yGlonk+4XTeQ9T418n
lTjINi/boXm6RF729odwOhAzlZQD2UxuOTF6wLbA6LfhPXpk4cGRLvDRbQZ/3lPP
OjIM132tfsQZzOwthOT4o988W+AfsjvHn5gB1aLCpzajRqGQaq6m8X/J3oJLPYFm
GOE7yDUckOcxseMx78Oj/EC8IE792CB6vSGnl4NpsYvv9kn15hrWs3c/yWNBG3Xb
hDlxXrpjqrb+WJpPbmQQU/lb/NG/aJZl4khDMQLh6XmhLqWh2RoHfcu8lPa7kQaw
sCJkTHhEuuB9EOVxjEWYus7pUkCTEbiL7jgd7pWpbMaQwQ+QgRrfa2HhZGcH1Cnd
2MXm6VIEvc2ZVAZ0zo4o
=EfYa
-----END PGP SIGNATURE-----

--=-rJg1rg2riHZIgjZlWNjZ--

