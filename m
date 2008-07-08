Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYGHQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYGHQQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYGHQQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 12:16:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYGHQQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 12:16:04 -0400
Subject: Re: [PATCH] CONFIG_KMOD needs to be default y
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1215533175.9610.51.camel@johannes.berg> (sfid-20080708_180716_966611_589BAABD)
References: <1215517771.9610.28.camel@johannes.berg>
	 <20080708124208.GA6704@infradead.org>
	 <200807082303.26194.rusty@rustcorp.com.au>
	 <1215533175.9610.51.camel@johannes.berg>
	 (sfid-20080708_180716_966611_589BAABD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SF2LsJFEizsG6pWfs1Em"
Date: Tue, 08 Jul 2008 18:15:14 +0200
Message-Id: <1215533714.9610.55.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SF2LsJFEizsG6pWfs1Em
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 18:06 +0200, Johannes Berg wrote:
> On Tue, 2008-07-08 at 23:03 +1000, Rusty Russell wrote:
>=20
> > > What about just killing the config option entirely?  It' basically
> > > guarding a ~50 lines function + a sysctl variable.  I think having
> > > modules but not CONFIG_KMOD is entirely unreasonable.
> >=20
> > I agree with Christoph here.
>=20
> Yeah, like I said, I wasn't sure why it's there anyway.
>=20
> > But as a patch series please: it's spread pretty wide.  eg. first make =
it a=20
> > non-prompting CONFIG option, then remove the users, then finally kill i=
t.
>=20
> Sure.
>=20
> > Some existing request_module users might be able to use=20
> > try_then_request_module, too...
>=20
> try_then_request_module seems buggy though. Or at least, doing something
> unexpected. Here's the macro, for reference:
>=20
> #define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), =
(x)))
>=20
> I think it should be
> #define try_then_request_module(x, mod...) \
> 	((x) ?: ({request_module(mod); (x)}))
>=20
> the difference being that it returns the result of the second "x" when
> the first "x" fails.

Never mind, it's not actually different, I just didn't understand that
syntax correctly.

The rest still stands though, do we really want to evaluate x twice when
CONFIG_MODULES is not set? Then, theoretically, the result shouldn't
change.

johannes

--=-SF2LsJFEizsG6pWfs1Em
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc5KOAAoJEKVg1VMiehFY24cP/iSWsZhJiK9kvRA2BiC3TvOK
BBp4DlVuuIXwWCGP0QG2F7ANnqbhszmSzQ8bJ8NTGBOcCXdfgY4DG6O58UGZn5Hz
edhygGouCUOUCCDz/u/oDn1oFDGiIbsxBEIu+QeT5/CE0IToO4XqXY3ggKWcir26
OokhUKiy0kGcjHjNuHIQg6KMVlQC5SIJvQ5WOJ3xVtv0rbWPvmFxBf7sU9XUeR6R
4j17oMFAdHm0B/VEsXy2g6sCBp/86nkK8E6FmR8z4iTz722wHEkNVFfF58kuU3Kn
GCOBCGebkXAa79rFGb2seg55y3JYFDG+Ch+bp+i0zlaZlhagfgc/dsvgGR1DLJF9
m8F9rDgDnTyzpmahx7Pm2GT8s3mEgRt6sBxqLgv/ukFqSAYmq+rr6PuROD01Ekg9
7X2Ipu7LU4yvE4QXZsYto1D6WAucoHkgm802Y1DTeZzQRtK963Lgq3Cc+tGfJlW/
rpii4YLsNKlvegST46TH/ktolovPojfQwxb4kbjDFjlYnwJA2p1LSGJmKa1tMEBZ
/VyZOwzlORbksOovVnKKctoAJDk/7RVg/XO5TN+ALu5kGXBG68LTEW6FyadSvE/K
VBN5ksPN536ZrYjsejr39f9NrzYQNe15zwdZwIr+aITthnoDFLzq1OL2JQxq5QRC
48n1H0FriDoMgUxsrayI
=LjAs
-----END PGP SIGNATURE-----

--=-SF2LsJFEizsG6pWfs1Em--

