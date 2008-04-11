Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYDKMVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYDKMVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 08:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbYDKMU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 08:20:59 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:57976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYDKMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 08:20:58 -0400
Subject: Re: [RFC 1/3] add macros for new sparse features
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <47FE425C.7060405@s5r6.in-berlin.de>
References: <20080410134810.629048000@sipsolutions.net>
	 <20080410134827.771251000@sipsolutions.net>
	 <47FE425C.7060405@s5r6.in-berlin.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8pjRjQXmdm/TnsTbuq52"
Date: Fri, 11 Apr 2008 14:20:39 +0200
Message-Id: <1207916439.13354.68.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8pjRjQXmdm/TnsTbuq52
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> So, instead of
>=20
>   /* always call with host_lock held */
>   int foo(struct bar *b)
>   {
>=20
> we could write
>=20
>   int foo(struct bar *b) __requires(host_lock)
>   {
>=20
> and let sparse check the call chains... or how is it used?

Yes.

> And what about dynamically allocated locks?
> E.g. b->lock
> Or struct host h* =3D container_of(b, struct host, m); with the necessity
> to hold h->lock...

I was looking at making sparse check that certain variable references
are under rcu, but it's not as easy. Also, the lock context is just an
arbitrary name, there's no way to actually link it to a certain variable
or so to differentiate between them. I think that's not really solvable
in sparse, look at the things lockdep has to do.

johannes

--=-8pjRjQXmdm/TnsTbuq52
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/9XlqVg1VMiehFYAQKk0w//fRspT04ACbb1HUS5P21pbENuirTgrIFv
jYz/UomtBkbuJrqZwL1OFO70jrBK3jt1UwzZENub162DHI6pzFgiKFlU5c5uYs7c
d9zzpqF6SnPG2Ox2f9BUgGdqBdulXBXAlrT9W8MBW8fwuKngS0iQE3zkGjYB+nY5
x7br69bWMK01h+tqMcfHaI76E+BGqlLhaomCAJe4VDhIXZJkKS95oevnHm9fHh2a
NrxV+f+DvFyR4MezX3mVRpOBd0obtdcbquws/etOCcLofAWJWNFMccY4UKpU5CWO
QoemmQIsAYYNfu96y8nwZaBaYwN8RP0pChneK+hpqHs2eQuynT8bIBpQPhASCKvC
mKvqx9ANT+UYsfHj3gj8XZms/m7XGuf5n8KR2HwiLsqCmle3Jwoy/2y3P7JA2Xwi
Asa7UBJmHcOpkGFAZb4ilA3cgp5CmFwijeWIHIEKLjM67VYnpyoSMg77tY89A7dU
z8v1+vDQJfaEjBMXQL0x0W6rsazR41orXhFilgOXEhvL7hBHbZC4S618eRur4mxY
Y1oRoH2ABKRPCMgmH5ZRjaADzRDdLQ0oSy49yvDKu1yWp6oxvH5MquaJ1owOaKNg
d89eWSG0BrdX/b/hbvfqTUxEiC1eXVHP4RjGUgm7143/4Cjn5ewspAzZVHBHJjmN
DAUgK98qcAc=
=4MWs
-----END PGP SIGNATURE-----

--=-8pjRjQXmdm/TnsTbuq52--

