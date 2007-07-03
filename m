Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbXGCQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbXGCQvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760541AbXGCQtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:49:50 -0400
Received: from systemlinux.org ([83.151.29.59]:42124 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761448AbXGCQtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:49:49 -0400
Date: Tue, 3 Jul 2007 18:46:26 +0200
From: Andre Noll <maan@systemlinux.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.22-rc7
Message-ID: <20070703164626.GZ22589@skl-net.de>
References: <alpine.LFD.0.98.0707011427380.1172@woody.linux-foundation.org> <20070703155519.GY22589@skl-net.de> <alpine.LFD.0.98.0707030908390.9434@woody.linux-foundation.org> <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yKkvi6mMqAM+MlBZ"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707030921400.4810@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--yKkvi6mMqAM+MlBZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:31, Christoph Lameter wrote:

> > Andre, does that simple change fix it for you (move the=20
> > "local_irq_enable()" to the end of early_kmem_cache_node_alloc)?
>=20
> Yes that should make the lock checker happy since interrupts are disabled=
=20
> when calling add_partial(). local_irq_enable can be called later without =
a=20
> problem. Useless longer interrupt hold off though.

I can confirm that the message disappears if local_irq_enable() is moved
to the end of the function.

> SLUB: Make lockdep happy by not calling add_partial with interrupts=20
> enabled during bootstrap
>=20
> If we move the local_irq_enable() to the end of the function then
> add_partial() in early_kmem_cache_node_alloc() will be called
> with interrupts disabled like during regular operations.
>=20
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Tested-By: Andre Noll <maan@systemlinux.org>

Thanks for the quick response and the fix, Linus and Christoph.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--yKkvi6mMqAM+MlBZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGin1iWto1QDEAkw8RAs98AJ9lr3mvjD+7HEkwohkP84o27GmlUACdEQ+s
MkwIYMQ5sgiD/Of8W+7rh1I=
=UZAg
-----END PGP SIGNATURE-----

--yKkvi6mMqAM+MlBZ--
