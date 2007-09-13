Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbXIMMok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbXIMMok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXIMMod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:44:33 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:2337 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752932AbXIMMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:44:32 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0709131354220.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709121405130.1817@scrub.home>
	 <1189683320.21778.213.camel@twins>
	 <Pine.LNX.4.64.0709131354220.1817@scrub.home>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RVezZaHXAG5mJbhl5hFT"
Date: Thu, 13 Sep 2007 14:44:28 +0200
Message-Id: <1189687469.21778.229.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RVezZaHXAG5mJbhl5hFT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 14:14 +0200, Roman Zippel wrote:
> Hi,
>=20
> On Thu, 13 Sep 2007, Peter Zijlstra wrote:
>=20
> > >  There's a good reason=20
> > > I put that much effort into maintaining a good, but still cheap avera=
ge,=20
> > > it's needed for a good task placement.
> >=20
> > While I agree that having this average is nice, your particular
> > implementation has the problem that it quickly overflows u64 at which
> > point it becomes a huge problem (a CPU hog could basically lock up your
> > box when that happens).
>=20
> If you look at the math, you'll see that I took the overflow into account=
,=20
> I even expected it. If you see this effect in my implementation, it would=
=20
> be a bug.

Ah, ok, I shall look to your patches in more detail, it was not obvious
from the formulae you posted.

> > >  There is of course more than one=20
> > > way to implement this, so you'll have good chances to simply reimplem=
ent=20
> > > it somewhat differently, but I'd be surprised if it would be somethin=
g=20
> > > completely different.
> >=20
> > Currently we have 2 approximations in place:
> >=20
> >   (leftmost + rightmost) / 2
> >=20
> > and
> >=20
> >   leftmost + period/2   (where period should match the span of the tree=
)
> >=20
> > neither are perfect but they seem to work quite well.
>=20
> You need more than two busy loops.=20

I'm missing context here, are you referring to the nice level error or
the avg approximation?

> There's a reason I implemented a simple simulator first, so I could=20
> actually study the scheduling behaviour of different load situations. Tha=
t=20
> doesn't protect from all surprises of course, but it gives me the=20
> necessary confidence the scheduler will work reasonably even in weird=20
> situations.

Right, I've build user-space simulators too, handy little things to play
with :-)

> From these tests I already know that your approximations only work with=20
> rather simple loads.

I've not yet seen it go spectacularly wrong, although admittedly a
highly concurrent kbuild is the most complex task I let loose on it.

Could you perhaps be more specific on the circumstances it breaks down
and what the negative impact is?

--=-RVezZaHXAG5mJbhl5hFT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG6TCsXA2jU0ANEf4RAmY6AJ9N7O2MseMeLROe56gdsO3zxJJiQwCfUe1h
Ws1X3HqVOW0Q+hlL41M0e9E=
=1ipS
-----END PGP SIGNATURE-----

--=-RVezZaHXAG5mJbhl5hFT--

