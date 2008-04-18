Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYDREjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYDREjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 00:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYDREi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 00:38:57 -0400
Received: from ozlabs.org ([203.10.76.45]:44932 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYDREi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 00:38:56 -0400
Subject: Re: [PATCH 1/2] Add thread_info_cache_init() to all archs
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>, linux-m32r@ml.linux-m32r.org,
       takata@linux-m32r.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080417211905.8ff769fa.akpm@linux-foundation.org>
References: <20080410032354.90CB1DDF0F@ozlabs.org>
	 <20080413171953.bde5e9ac.akpm@linux-foundation.org>
	 <1208133506.6958.82.camel@pasglop>
	 <20080413191338.9776ebd0.akpm@linux-foundation.org>
	 <1208491086.6958.381.camel@pasglop>
	 <20080417211905.8ff769fa.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FDPfa9rGsj0DdIbVrzKH"
Date: Fri, 18 Apr 2008 14:38:55 +1000
Message-Id: <1208493535.9319.3.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FDPfa9rGsj0DdIbVrzKH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-17 at 21:19 -0700, Andrew Morton wrote:
> On Fri, 18 Apr 2008 13:58:06 +1000 Benjamin Herrenschmidt <benh@ozlabs.or=
g> wrote:
>=20
> >=20
> > > > > otoh, if only one .c file will ever call this function then I thi=
nk that
> > > > > all problems are solved by
> > > > >=20
> > > > > a) moving the above ifdeffery into the .c file
> > > > > b) adding a comment explaining which arch file must provide the o=
verride
> > > > > c) directly including that file from within the .c file.
> > > >=20
> > > > I can definitely do that. I have no problem either way. I can add t=
o all
> > > > archs too, it's just that whatever way I choose, some people won't =
be
> > > > happy with it :-)
> > > >=20
> > > > Anyway, I'll move the ifdeferry to init/main.c then.
> > >=20
> > > Thanks ;)
> > >=20
> > > I'm still wounded by my recent encounter with set_softirq_pending()
> > > and or_softirq_pending().
> >=20
> > Well, looking there, I saw we already used weak symbols for that
>=20
> Yes, `weak' is a nice solution.  It does add a few bytes of text which we
> could avoid with compile-time trickery, but only a very few.
>=20
> Plus this is __init anyway, although I don't know how well the combinatio=
n
> of `weak' and __init works.
>=20
> > +void __init __attribute__((weak) thread_info_cache_init(void)
>=20
> s/weak)/weak))/

There's also a #define of this called "__weak" if you like, less typing
and less ugly.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-FDPfa9rGsj0DdIbVrzKH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBICCXfdSjSd0sB4dIRAhE1AJ9ZHfHcu3unHY6kSWfP0t+aNTPkKQCeI0zj
966HGDJEisppeO7PrUitiG8=
=RoAh
-----END PGP SIGNATURE-----

--=-FDPfa9rGsj0DdIbVrzKH--

