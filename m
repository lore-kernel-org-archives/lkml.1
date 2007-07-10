Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbXGJBc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbXGJBc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbXGJBcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:32:50 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53281 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXGJBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:32:49 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: hibernation/snapshot design [was Re: [PATCH] Remove process freezer from suspend to RAM pathway]
Date: Tue, 10 Jul 2007 11:33:00 +1000
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Miklos Szeredi <miklos@szeredi.hu>
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <20070708221315.GF5401@elf.ucw.cz> <200707090101.28832.rjw@sisk.pl>
In-Reply-To: <200707090101.28832.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11962317.xRHHmGy5PO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707101133.01566.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart11962317.xRHHmGy5PO
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Monday 09 July 2007 09:01:27 Rafael J. Wysocki wrote:
> Hi,
>=20
> On Monday, 9 July 2007 00:13, Pavel Machek wrote:
> > Hi!
> >=20
> > > > Actaully, I'm perfectly fine with that, as long as each task blocke=
d=20
by the
> > > > driver due to suspend has PF_FROZEN (or something similar) set.  Th=
en,=20
at
> > > > least theoretically, we'll be able to drop the freezer from the=20
suspend code
> > > > path and move it after device_suspend() (or the hibernation-specific
> > > > equivalent) for hibernation (in that case there shouldn't be a prob=
lem=20
with
> > > > any task waiting on I/O while the freezer is running ;-)).
> > >=20
> > > I don't see the need for a freezer for snapshot but that's a different
> > > issue. (stop_machine looks good enough to me).
> >=20
> > Freezer is not needed for snapshot -- it is needed so that we can
> > write out the snapshot to disk without the need for special
> > drivers/block/simple-ide-for-suspend.c. (We are doing snapshot, then
> > write to disk from userland code in uswsusp).
>=20
> Yes.
>=20
> BTW, this patch:
>=20
>=20
http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc7/patches/15-fre=
ezer-make-kernel-threads-nonfreezable-by-default.patch
>=20
> that's queued up in -mm contains a freezer documentation update, in which=
=20
the
> reasons of using it, as well as its limitations, are described.
>=20
> To summarize what was previously said in this thread:
>=20
> * Apparently, we agree that the freezer is _generally_ not needed for=20
suspend
>   (ie. any transition to a system sleep state other than hibernation), bu=
t=20
some
>   of us (eg. me) think that it wouldn't be reasonable to drop the freezer=
=20
from
>   the suspend code path _right_ _now_ .
>=20
> * Some of us, including you, Nigel and me, think that the freezer is need=
ed
>   for hibernation (please see the document in the patch above for details=
).
>   In the (very) long run this might be avoided too, but (IMO) certainly n=
ot=20
at
>   this point.
>=20
> * We seem to agree that in order to remove the freezer from the suspend c=
ode
>   path some work needs to be done on device drivers, driver midlayers and=
=20
the
>   PM core.  We also need to do some work on the PM core in order to=20
introduce
>   a separate hibernation framework and IMO it would be reasonable to
>   synchronize these efforts.
>=20
> * We are now to decide what to do so that the freezer can be safely remov=
ed
>   from the suspend code path and how to integrate that change with the
>   hibernation code path (if possible and reasonable).
>=20
> * The freezer vs FUSE issue that started this thread remains unresolved, =
so
>   it would be desirable to provide a short-term fix (need not be very nic=
e).

(Finally catching up on emails since Saturday!)

The freezer is also essential for doing a full image of memory - you have t=
o=20
be able to guarantee that some of the image won't change in order to be abl=
e=20
to write it out before the atomic copy. Of course the freezer alone isn't=20
enough, but it solves 95% of the issue.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart11962317.xRHHmGy5PO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGkuHNN0y+n1M3mo0RApa8AKCA0YY73RCHwgPShYFMQuPmPgHlSACfYjgB
/FOMmYkPcvt+xNq2vPLiiGE=
=8IP+
-----END PGP SIGNATURE-----

--nextPart11962317.xRHHmGy5PO--
