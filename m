Return-Path: <linux-kernel-owner+w=401wt.eu-S1762738AbXGEXf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762738AbXGEXf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759842AbXGEXfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:35:15 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46975 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbXGEXfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:35:13 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 09:35:11 +1000
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <200707060913.05644.nigel@nigel.suspend2.net> <1183677643.3388.105.camel@localhost.localdomain>
In-Reply-To: <1183677643.3388.105.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1549699.qhScn4nsNC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707060935.12706.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1549699.qhScn4nsNC
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 09:20:43 Benjamin Herrenschmidt wrote:
>=20
> > Will you be able to guarantee that every place where a task can/will bl=
ock=20
> > will be harmless place? If so, how will you guarantee that? How will yo=
u=20
> > debug issues where a task occasionally doesn't block in the right place=
,=20
> > particularly instances where it is some less than obvious interaction w=
ith=20
> > other tasks?
>=20
> Which places aren't harmless if you don't have a freezer ?

If I knew that, I wouldn't be asking the question.

> > This is the whole point to having the freezer. It makes things more=20
> > predictable and testable. It shows us, clearly, when process X is the o=
ne=20
> > that is causing problems.
>=20
> No, the freezer creates all those places what are harmful for a task to
> block because they will break the freezer :-)

Nice try :) Okay then, you remove the freezer, try hibernating, then get ba=
ck=20
to me after you've fixed your filesystem because some process that wasn't=20
frozen started writing things after the atomic copy (making the on disk=20
filesystem inconsistent with the snapshot).

As Pavel rightly said, you can get rid of the freezer, but you're only goin=
g=20
to have to implement another one that does the essentially the same thing,=
=20
even if it is at some other level.
=20
> > >  - Silently add GFP_NOIO to all allocations, to avoid having things
> > > blocking in kmalloc() with a mutex held that will deadlock with
> > > suspend() in a driver for example. Or set some way to have all GFP
> > > waiters wakeup and fail rather than wait for IOs. It's hard/bizarre b=
ut
> > > necessary, again, with or without a freezer.
> >=20
> > GFP_ATOMIC? (In driver suspend, they shouldn't be sleeping either, righ=
t?)
>=20
> NOIO should be enough I think but ATOMIC would do).
> =20
> That's one of the reason why I used to have the pre-suspend and
> post-resume hooks in my original powermac implementation, for those few
> drivers complicated enough to require some pre-allocations.
> =20
> > >  - Deal with the firmware problem. The best way is probably to have an
> > > async request_firmware interface(). Another thing is, drivers may want
> > > to cache their firmware in main memory, that sort of thing...
> > >
>=20
> Note that the above firmware problem could be dealt with also with the
> pre-suspend/post-resume. Allowing to pre-request firmware etc... and
> keep it around until after resume, because we know we will need it.
> Gives a chance to drivers to perform things while the system is still
> live, filesystems still working, etc... (big memory allocations for
> example).
>=20
> > > And that's just a small list off the top of my mind, of known problems
> > > that will cause deadlocks or misbehaviours today, with or without the
> > > freezer, and that need to be addressed.
> >=20
> > Userspace device drivers too?
>=20
> Maybe but they are less of an issue, most of the time, they don't do DMA
> or whatever harmful things. If they are USB drivers, for example, they
> are an non-issues at that level.

(Leaving the rest of the message intact so we don't have to fragment the=20
discussion into a million subthreads).

Regards,

Nigel

--nextPart1549699.qhScn4nsNC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjYAwN0y+n1M3mo0RAvecAJ9j+9ImU1r53WqkTs2L1fd5YPrvcwCaA8yC
o01ys2e3r11sPD3HG7w0qps=
=m6mU
-----END PGP SIGNATURE-----

--nextPart1549699.qhScn4nsNC--
