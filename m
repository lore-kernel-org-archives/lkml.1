Return-Path: <linux-kernel-owner+w=401wt.eu-S1031429AbXDZSkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031429AbXDZSkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031433AbXDZSkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:40:19 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031429AbXDZSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:40:17 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200704262040.31760.rjw@sisk.pl>
References: <20070425072350.GA6866@ucw.cz>
	 <20070426113005.GU17387@elf.ucw.cz>
	 <1177605074.6814.93.camel@johannes.berg>  <200704262040.31760.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lZLPfwsUVRjZkhfGFaId"
Date: Thu, 26 Apr 2007 20:40:02 +0200
Message-Id: <1177612802.6814.121.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lZLPfwsUVRjZkhfGFaId
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 20:40 +0200, Rafael J. Wysocki wrote:

> >  * it surfaces kernel implementation details about pm_ops and thus make=
s
> >    the whole thing very fragile
>=20
> Can you elaborate?

Well it tells userspace about pm_ops->enter/prepare/finish etc.
Also, it seems that it needs a "release memory now" operation instead of
just releasing it when the fd is closed?

> >  * it has yet another interface (yuck) to determine whether to reboot,
> >    shut down etc, doesn't use /sys/power/disk
>=20
> Yes.  In fact it was meant as a replacement for /sys/power/disk at one po=
int.

Heh.

> >  * I generally had no idea wtf it is doing in some places
>=20
> I could have told you if you had asked. :-)

I was offline ;)

> Do we need hibernate_ops at all?  There's only one user anyway and I'm no=
t
> sure there will be more of them in the future.

I'm pretty sure there won't be, but there's no way to do it cleanly
without pm_ops since even acpi doesn't do this all the time but only
when some set of conditions is true. Hence, it needs to be able to
determine the availability of the platform mode at run time rather than
build time (build time =3D> we could use weak symbols, arch hooks, ...)

johannes

--=-lZLPfwsUVRjZkhfGFaId
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMPIC/ETPhpq3jKURAtaIAKCuVH219VocWWLOCTcozP04ixT7NQCgs9nf
IHsFZ7KIZkHZ9KRWkoAxMLI=
=fvL4
-----END PGP SIGNATURE-----

--=-lZLPfwsUVRjZkhfGFaId--

