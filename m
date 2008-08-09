Return-Path: <linux-kernel-owner+w=401wt.eu-S1758001AbYHIGmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001AbYHIGmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 02:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYHIGmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 02:42:14 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:40513 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYHIGmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 02:42:13 -0400
Date: Sat, 9 Aug 2008 08:42:10 +0200
From: Bastian Blank <bastian@waldi.eu.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] DocBook: don't compress mandocs
Message-ID: <20080809064210.GA22380@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <bastian@waldi.eu.org>,
	Sam Ravnborg <sam@ravnborg.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080808074724.GA28249@wavehammer.waldi.eu.org> <20080808214504.GA8001@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <20080808214504.GA8001@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2008 at 11:45:04PM +0200, Sam Ravnborg wrote:
> On Fri, Aug 08, 2008 at 09:47:24AM +0200, Bastian Blank wrote:
> > The mandocs target uses gzip to compress the resulting manpages. If this
> > target runs more than once (using make -jX) at the same time, gzip may
> > run more then once with the same set of files. It just bails out if it
> > is not able to find a file because a concurrent run already removed it.
> >=20
> > Fix this by removing the gzip call and only work with uncompressed
> > manpages.
>=20
> If it failded with gzip being run more than once before this
> patch does not solve the bug - it simply makes it harder to trigger.

No, the problem does not longer exists then. Or do you see a "*" to be
expanded on runtime?

> Anything that does not work with a make -j100 build is broken.
> And please understand that we have people that uses "make -j100" when bui=
lding
> the kernel.

I only use -j64 ...

> These people most likely does not do "make mandocs" but we should still f=
ix
> the bug and not try to paper it over in this way.
>=20
> So try to analyse why we in the first place will run gzip in parallele an=
d solve that.

make mandocs
-> make a.9 b.9 c.9 d.9 ... z.9
   -> xmlto a.xml; gzip *
   -> xmlto b.xml; gzip *
   -> xmlto c.xml; gzip *
   -> xmlto d.xml; gzip *
   ...
   -> xmlto z.xml; gzip *

Bastian

--=20
Captain's Log, star date 21:34.5...

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEARECAAYFAkidPEIACgkQnw66O/MvCNFCoACfQTL1tGsU5/4yirmziLsME6vE
8c4AnR1xAga9PDPKmJtl0N9ZU9sa0jcH
=iywS
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
