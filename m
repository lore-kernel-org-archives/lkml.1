Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYKCUUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYKCUUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbYKCUUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:20:30 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:54416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYKCUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:20:29 -0500
Subject: Re: [RFC PATCH 2/5] iscsi: bugfix for displaying IPv6 address
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, davem@davemloft.net,
       joe@perches.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081103121600.b3a8eef2.akpm@linux-foundation.org>
References: <1225166717.5526.17.camel@brick>
	 <20081103121600.b3a8eef2.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jsoBnkRLysM0X0AZbwe2"
Date: Mon, 03 Nov 2008 21:20:22 +0100
Message-Id: <1225743622.3619.67.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jsoBnkRLysM0X0AZbwe2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-03 at 12:16 -0800, Andrew Morton wrote:
> On Mon, 27 Oct 2008 21:05:17 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
>=20
> > Notice that ip is a u8 *, so currently every other byte is
> > being truncated here.
> >=20
>=20
> I don't understand that bug description.  The code looks OK to me?

> > -		str +=3D sprintf(str, NIP6_FMT, ntohs(ip[0]), ntohs(ip[1]),
> > -			       ntohs(ip[2]), ntohs(ip[3]), ntohs(ip[4]),
> > -			       ntohs(ip[5]), ntohs(ip[6]), ntohs(ip[7]));
> > +		str +=3D sprintf(str, "%p6", ip);

If ip is a u8 * these ntohs are operating on bytes which is bogus, and
NIP6_FMT expects to get 8 u16s, not 8 u8s.

johannes

--=-jsoBnkRLysM0X0AZbwe2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJD1zwAAoJEKVg1VMiehFYI8UP/Ai+J6G1pUZVgPWUNMbgBUPs
cs2JvFLwJzew1mpXmFZCC0WJH+itQpXDtxVeD8T8jDPghCDfMLAwocxpgfxmBiu1
ZhbvOxhoBEhJadARoGyRVamh+r5+nU87LLiVjuqZJcPmGgcAJZbDc4cVyesnAbFJ
R//VG9dGgGFPZwIPDzlfDCyYYcCbh2+eeUkAXyqkvXXIwJ2hGMp0Uwe1nNw0zcuz
ZRR1SL3/NoT+9solYCB0zcBrQRy2SzenmA6BDrsLK7qhFcaQ1Y7yZsztKnF51wVy
5HLReoVwJx0eNeeWH7oO5Y4+D1FGt7anFEHOxc74pf6XdCtnH4P3S+SeyWpYZKZv
z6HtmVY358LKs0ZsqZZTPyGNPcmgDx2kC1USGmxO8hx+6abOF+fJS9HsLfIc8ysF
82vW60cieymoEqS/iYgPEHkMA/ckQky+Z/gO5BxNPhE7ZruN6oFiwyZGQhtnS5CV
NHPbek8D5cY7mqCFrpdzOMEyUN0DY4IJfJM0J0TVOQTWlVIb7rSER8i1zidE2NLI
YUnICjJX4dIZO7yNDC4ztz1S3jj9MbqY8i99nL7+/DHFTydY3cMvoNIcLddFebCO
Icppd4TmDtA1xnu8becViWWFNCATjWyPRDphBhvQcWdyNi42CmQQsV5+sjSjBeDB
+0YF1e/wsdDhRZtBRk6g
=Y5ON
-----END PGP SIGNATURE-----

--=-jsoBnkRLysM0X0AZbwe2--

