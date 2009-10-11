Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbZJKKiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbZJKKiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756534AbZJKKiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:38:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbZJKKiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:38:21 -0400
Subject: Re: NOHZ: local_softirq_pending 08
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <200910111217.31883.mb@bu3sch.de>
References: <20091011095217.GA2200@darkstar>
	 <1255255735.4095.53.camel@johannes.local> <200910111217.31883.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CGfYXcgFHCLBiKqwWH+O"
Date: Sun, 11 Oct 2009 12:37:42 +0200
Message-Id: <1255257462.4095.79.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CGfYXcgFHCLBiKqwWH+O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 12:17 +0200, Michael Buesch wrote:

> Ehm, no. That's not exactly true.
> We call the non-_irqsafe functions, which by definition are designed to
> run in non-irq (soft or hard) context. At least that's how I understand t=
he
> documentation, last time I read it.

So maybe the documentation is not entirely accurate. Such happens. From
this and previous threads tt's pretty obvious that these functions
cannot be called with softirqs enabled. And I've also stated before that
I do not believe that we should call them with softirqs enabled without
auditing the code for locking, which historically has been a weak point
of mac80211.

> Why don't you simply do local_bh_disable() in those functions, if they
> require bh disabled, instead of depending on the driver doing it?
>=20
> > FWIW, I believe the bug to be in b43 and wl12x1, and not as Michael
> > thinks in the stack.
>=20
> If mac80211 requires BHs disabled, it should do this.

I don't believe adding that into mac80211, even though it nests, is a
good idea for the case of many drivers where mac80211 and/or the driver
knows. It's pretty damn trivial to add two lines of code to the driver,
instead of penalising every other driver. The typical kernel style is
making things provide the required context, not a function take any
possible context.

johannes

--=-CGfYXcgFHCLBiKqwWH+O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0bVzAAoJEODzc/N7+QmaBwkP/0JMM9TAI2NMmSgalTvIbXS1
t45wqJTNuzvyGuC6YeFwGkgV9jFMbjdCOLT2aQSwqa0Mk1sj/qvv3mLQldndAl3e
ekYrMEDAARuxZfx2RJ5OVgd2MgjkZzPwjzFela7HlA/PXyGFcOF/wogDsAdOcOwY
gECGri56/4Trn81AKeXkIT+QsekODB4oM6UnBtIrHl/sKjpi0Bot+6HEdjcaW6l2
vTPp0uRMw59qzno6cYOtXdXRvbe1xdDK1KjIHP+vHuqLn2KKzPaFJNOeFhVS/uZC
WA3inwvarnXAzufZi3mX9kJbgd1XWLU6rEuZnwYAjwB61z0Qr2TacYtheRh1soWS
gygJ60/+fgOwjSuCGxeBC7GBXHbWvPWa7ArcHOzN+4wgCDljjkEAF8UWPi3tNGsF
lwxbaUbMt1bu+w9b+TizAPfoDGCHGBmxHScfeDHVNBoFZxhrgtHFxjr7S3h+H2Iu
sXt9yyaOwas3IG0urli/W962D62FdcnkauI98TcZx6hzWMtRwHD02rtkh5Mc8eeV
6a6/oRO6n6pRfKG0nJkoe+mH/8QyvDpYiO0Kj5/JxFJDhFOrKHzvnfVbZH83cyfB
15tCLqLkai428vd/ubBEYoqczMRwh8/798Y4x+GP+/MtenJpx5V3B000UDE0qvBd
mYCHAqNIy24CfzGWApmt
=1qH7
-----END PGP SIGNATURE-----

--=-CGfYXcgFHCLBiKqwWH+O--

