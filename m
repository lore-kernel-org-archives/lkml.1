Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab0BTIpq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:45:46 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:43510 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0BTIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:45:45 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002192046u5105db8j4b8a63647d9220ce@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <2375c9f91002192046u5105db8j4b8a63647d9220ce@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ssA84b06/ZMquueKg7bd"
Date: Sat, 20 Feb 2010 09:45:30 +0100
Message-ID: <1266655530.3790.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ssA84b06/ZMquueKg7bd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 12:46 +0800, Am=C3=A9rico Wang wrote:

> This is a real deadlock case found by lockdep added to s_active.
>=20
> The problem is that we did kobject_put(&data->kobj) while holding
> policy_rwsem
> which is used to protect 'data'. It is not so easy to fix this,
> probably we need to do more work on cpufreq code.

But it doesn't make sense that it's just an existing real deadlock that
is now found -- it never occurred previously!

Anyway, I'll try your patch, thanks for that.

johannes

--=-ssA84b06/ZMquueKg7bd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf6EnAAoJEODzc/N7+QmaYbEQAKxmDV8/iS3S6PKMa8VECYcq
F3Z5JIxNKPfXdQvG30Tnoz1d6vHfVs5S7oiEvFJRlki2U0VS2QlGDfsIBcbFPG/P
OGaGvmjyAjrHIh4imfuRmt9s/aEqkeqymdI9CcHr6IuCsz6O/QPSqp3BRe1klYCP
YSv6vCDxzKVDF7YMF/GYXaz8aN0mBqCWlfM8pRZ982xUttIV1BYDPmXTwU2w1iqJ
fYebuP1QUZ+nzE4yob8pli6Ns6Z3haSrjlKVhNF1fvsRYbISfBEGDftGCVeFomTf
QxJYNWRLNvSN5T+T+lx7KMLFzfsAA3M51dFGWRzcUyEv/iPK9kucthQ+jf5qWDy3
Uei5uf+sLYE5UwmkTaEk+MkVAKhxCCESEsf5AJe3kSjh+fgkzIM/+BRMw7i6HbU3
eBhZy6+wWf2U+JwKf7ZZtayor5OqCP+hGya/gGL/JEAyTiRs4cd6naso9Ivw2gGV
GBQNScU8StMKc+P994Bej+mmUID7s4z6rsDVMvxsOsQYekbvtBeNo2jpmZa+tX4J
e/cJP2WJazLmZtFkhyNgPP8hrW4jZrw+tba8HujodvQHKuNoI8a0zovmh2ggesdE
edM6gCUQRg1w0SPQYSCC0EZjlN6xNKJK192dNuQl5QhGnFTXfKST4aAUgZNLNzIz
4s0tXJ9cu2jm8Jwtyj71
=Rr3u
-----END PGP SIGNATURE-----

--=-ssA84b06/ZMquueKg7bd--

