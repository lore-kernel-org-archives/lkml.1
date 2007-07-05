Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXGEIt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXGEIt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbXGEItv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:49:51 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:38224 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757545AbXGEItu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:49:50 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070705084538.GA3476@elte.hu>
References: <1183583529.9662.34.camel@johannes.berg>
	 <20070705084538.GA3476@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NRmcs4MJAAxjGWcAYOEw"
Date: Thu, 05 Jul 2007 10:50:48 +0200
Message-Id: <1183625448.3818.6.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NRmcs4MJAAxjGWcAYOEw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 10:45 +0200, Ingo Molnar wrote:

> > +#ifdef CONFIG_LOCKDEP
> > +		/*
> > +		 * It is permissible to free the struct work_struct
> > +		 * from inside the function that is called from it,
> > +		 * this we need to take into account for lockdep too.
> > +		 * To avoid bogus "held lock freed" warnings as well
> > +		 * as problems when looking into work->lockdep_map,
> > +		 * make a copy and use that here.
> > +		 */
> > +		struct lockdep_map lockdep_map =3D work->lockdep_map;
> > +#endif
>=20
> > +		lock_acquire(&lockdep_map, 0, 0, 0, 2, _THIS_IP_);
> >  		f(work);
> > +		lock_release(&lockdep_map, 1, _THIS_IP_);
>=20
> neat trick :)

Not like I had a choice ;) But since I assign .key it still works :)

Btw, do you have a tree you'll submit this through, or Oleg, or should I
send it to akpm after we sort out any further issues?

johannes

--=-NRmcs4MJAAxjGWcAYOEw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjLDo/ETPhpq3jKURAlrTAKCH4AwokJRPVyt1O1DY/BONOr2qSACeNb6N
NPGMbsqIjzqaeIWYZO20avs=
=R4k9
-----END PGP SIGNATURE-----

--=-NRmcs4MJAAxjGWcAYOEw--

