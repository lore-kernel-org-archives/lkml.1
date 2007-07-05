Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbXGEJHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbXGEJHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbXGEJHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:07:31 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:33014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbXGEJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:07:31 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183626070.7054.54.camel@twins>
References: <1183583529.9662.34.camel@johannes.berg>
	 <20070705085304.GC3476@elte.hu>  <1183625889.3818.14.camel@johannes.berg>
	 <1183626070.7054.54.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9Rqx0eq0vzWqqDWhK5bW"
Date: Thu, 05 Jul 2007 11:08:27 +0200
Message-Id: <1183626507.3818.19.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9Rqx0eq0vzWqqDWhK5bW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 11:01 +0200, Peter Zijlstra wrote:

> You could of course make this STATIC_LOCKDEP_MAP_INIT() and place it
> near lockdep_init_map() :-)
>=20
> That way it would be clear that changes to either ought to be reflected
> in the other.

Sure. I have to repost anyway :)

How about

+/* both _name and _key must not be NULL */
+#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
+	{ .name =3D (_name), .key =3D (_key), }

That'll still require some #ifdef foo inside workqueue.h but I think
it's cleaner to put just this into lockdep.h

johannes

--=-9Rqx0eq0vzWqqDWhK5bW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjLUL/ETPhpq3jKURAqhPAKCESkJRcc/UDvPXmxR8+wJLVJbtNQCdEaJO
5uUSZYqxruSmt36xLGUwyDo=
=BFGu
-----END PGP SIGNATURE-----

--=-9Rqx0eq0vzWqqDWhK5bW--

