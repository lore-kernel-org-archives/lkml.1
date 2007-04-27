Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbXD0Oj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbXD0Oj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbXD0Oj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:39:28 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:52380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233AbXD0Oj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:39:26 -0400
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       suspend2-devel@lists.suspend2.net,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kTx9DZtB5Nmr/BrUDOKk"
Date: Fri, 27 Apr 2007 16:39:24 +0200
Message-Id: <1177684764.3565.20.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kTx9DZtB5Nmr/BrUDOKk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 10:34 -0400, Alan Stern wrote:

> For the sake of argument, let's call the stages of STD and STR by these=20
> names (also noted are the current PSMG values):
>=20
> 	Suspend to disk:
> 	"prepare to create snapshot" (=3D FREEZE)
> 	"continue after snapshot" (=3D RESUME)
>=20
> 	Resume from disk:
> 	"prepare to restore snapshot" (=3D PRETHAW)
> 	"continue after restore" (=3D RESUME)
>=20
> 	Suspend to RAM:
> 	"suspend" (=3D SUSPEND)
> 	"resume" (=3D RESUME)
>=20
> The real reason for adding PRETHAW was that drivers couldn't distinguish
> between "continue after restore" and "resume", other than by examining th=
e
> device's state -- since the PM core doesn't pass any information to the
> resume() method.

That's pretty much what I said about prethaw though, no? Anyway,

> Anyway, based on this analysis it seems reasonable to have Six (6) method=
=20
> pointers.  Suggested names (in the same order as above):
>=20
> 	pre_snaphot()
> 	post_snapshot()
> 	pre_restore()
> 	post_restore()
> 	suspend()
> 	resume()
>=20
> People apparently assume that pre_snapshot() and pre_restore() would=20
> always do the same thing and hence be redundant.  I'm not so sure; time=20
> will tell.  Doing it this way certainly is more clear.

Right. I did assume that pre_snapshot and pre_restore would be
effectively the same since they both have to quiesce the device and
assume not much more. I'm not averse to making it explicit, many drivers
that don't care can just assign the same function.

> Then there's the question of having early_ and late_ versions of some of=20
> these things (i.e., one called with interrupts enabled, the other with=20
> interrupts disabled).  I don't know to what extent that would be=20
> necessary; perhaps the each method call should occur in two phases with=20
> the interrupt-enable status changed in between.  Then the interrupt-enabl=
e=20
> setting could be passed as an argument.

Good point. Though if we go for passing the interrupt-enable setting as
an argument then many drivers will have the same
"if (irqs_disabled()) return" code. Hm. I guess passing it isn't even
strictly necessary.

johannes

--=-kTx9DZtB5Nmr/BrUDOKk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMgsb/ETPhpq3jKURAv1qAJ9a4tqCyMpTI+Yke4BzhI5QmNqfVACdFm3o
RQc5od63ibRWyk5tmGMwou0=
=/F2n
-----END PGP SIGNATURE-----

--=-kTx9DZtB5Nmr/BrUDOKk--

