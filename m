Return-Path: <linux-kernel-owner+w=401wt.eu-S1760458AbXGEI5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbXGEI5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 04:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759718AbXGEI5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 04:57:12 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406AbXGEI5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 04:57:11 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070705085304.GC3476@elte.hu>
References: <1183583529.9662.34.camel@johannes.berg>
	 <20070705085304.GC3476@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mGwr9adZo4cZ4xhUyQIW"
Date: Thu, 05 Jul 2007 10:58:08 +0200
Message-Id: <1183625889.3818.14.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mGwr9adZo4cZ4xhUyQIW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 10:53 +0200, Ingo Molnar wrote:

> > +#ifdef CONFIG_LOCKDEP
> > +/*
> > + * HACK! This really should call lockdep_init_map() but can't
> > + * because there's no requirement to initialise work structs
> > + * at runtime. This works because subclass =3D=3D 0.
> > + *
> > + * NB: because we have to copy the lockdep_map, setting .key
> > + * here is required!
> > + */
>=20
> why do you consider this a hack? A static object is a static object, and=20
> its own address is its key. That's what we have for like 80% of all the=20
> spinlocks in the kernel. Static initialization is not as flexible as=20
> dynamic initialization, but the lockdep engine handles it. Am i missing=20
> something?

Well, there's nothing in lockdep that guarantees that. I'd be much more
comfortable doing that when lockdep had a STATIC_LOCKDEP_MAP_INIT()
macro that looks like my __WORK_INIT_LOCKDEP_MAP() macro because then
people changing lockdep would see that they cannot rely on
lockdep_init_map() having been called (unless subclass !=3D 0)

johannes

--=-mGwr9adZo4cZ4xhUyQIW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjLKg/ETPhpq3jKURAj/SAJ0XnELneJaIijt3/SWKQBwz+EzRSwCgqm74
M+aHjKhNiArjQMIBWR9ZDjs=
=8Mm8
-----END PGP SIGNATURE-----

--=-mGwr9adZo4cZ4xhUyQIW--

