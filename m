Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbXIMRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbXIMRGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXIMRGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 13:06:10 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:28840 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751760AbXIMRGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 13:06:09 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0709131706100.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709120242040.1817@scrub.home>
	 <20070913075258.GA9173@elte.hu>
	 <Pine.LNX.4.64.0709131419170.1817@scrub.home>
	 <20070913142842.GA26016@elte.hu>
	 <Pine.LNX.4.64.0709131706100.1817@scrub.home>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ljIxIjWczria6IeI+dO9"
Date: Thu, 13 Sep 2007 19:06:05 +0200
Message-Id: <1189703165.21778.258.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ljIxIjWczria6IeI+dO9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 18:50 +0200, Roman Zippel wrote:

> I never claimed to understand every detail of CFS, I can _guess_ what=20
> _might_ have been intended, but from that it's impossible to know for=20
> certain how important they are. Let's take this patch fragment:
>=20

	delta_fair =3D se->delta_fair_sleep;

we slept that much

> -       /*
> -        * Fix up delta_fair with the effect of us running
> -        * during the whole sleep period:
> -        */
> -       if (sched_feat(SLEEPER_AVG))
> -               delta_fair =3D div64_likely32((u64)delta_fair * load,
> -                                               load + se->load.weight);

if we would have ran we would not have been removed from the rq and the
weight would have been: rq_weight + weight

so compensate for us having been removed from the rq by scaling the
delta with: rq_weight/(rq_weight + weight)

> -       delta_fair =3D calc_weighted(delta_fair, se);

scale for nice levels



--=-ljIxIjWczria6IeI+dO9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG6W39XA2jU0ANEf4RAr3+AJ9AVgnJheVN29qwEXZQkEiYFsM3egCbBHqB
olfg48R1Q4dzeG4CtrXv6Yw=
=HBFK
-----END PGP SIGNATURE-----

--=-ljIxIjWczria6IeI+dO9--

