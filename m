Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbXD2ABk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbXD2ABk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 20:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbXD2ABk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 20:01:40 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54016 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXD2ABi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 20:01:38 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <200704281950.30405.rjw@sisk.pl>
	 <alpine.LFD.0.98.0704281421140.9964@woody.linux-foundation.org>
	 <200704290103.38409.rjw@sisk.pl>
	 <alpine.LFD.0.98.0704281640480.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-61YiVj4Jf42UQAnEKBq+"
Date: Sun, 29 Apr 2007 10:01:38 +1000
Message-Id: <1177804898.7652.10.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-61YiVj4Jf42UQAnEKBq+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-04-28 at 16:45 -0700, Linus Torvalds wrote:
>=20
> On Sun, 29 Apr 2007, Rafael J. Wysocki wrote:
> >=20
> > OK, more precisely: fs-related threads should not try to process their =
queues,
> > etc., after the snapshot is done, because that may cause some fs data t=
o be
> > written at that time and then the fs in question may be corrupted after=
 the
> > restore.  Not all of the I/O in general, fs data.
>=20
> But that's not true _either_. That's only true because right now I think=20
> we cannot even suspend to a swapfile (I might be wrong).=20
>=20
> If you have a swapfile on a filesystem, you'd need those fs queues=20
> running!

For Suspend2, and I think for swsusp too, we bmap the locations when
allocating the storage, and then submit our own bios. Even if swsusp
isn't using this method, I'm pretty sure the swap code does bmapping at
swapon time to avoid raciness later.

> > Well, I'm not sure whether or not that still would have been the case i=
f we had
> > stopped to freeze kernel threads for the hibernation/suspend.
>=20
> Did you miss the email where Paul pointed out that Mac/PowerPC didn't use=
=20
> to do any of this? And apparently never had any issues with it? And=20
> probably worked more reliably several years ago than suspend/hibernation=20
> does _today_?
>=20
> Ie we do have history of _not_ freezing things.  The freezing came later,=
=20
> and came with the subsystem that had more problems..

It also came because of problems. Not working perfectly isn't
necessarily a sign of a faulty reason for being added in the first
place.

I should also add, not freezing things is fine if you're happy with
getting half an image at most. If you want a full
just-as-if-I'd-never-turned-the-power-off image, you need freezing so
that you can have some pages which can be saved before others are
atomically copied, to ensure the whole image is consistent.

Nigel

--=-61YiVj4Jf42UQAnEKBq+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGM+BiN0y+n1M3mo0RAof2AKDR5Pni6HrTY12EPPJJ0h4ZAAq3kQCePeeK
atymrmU2w2Tmp9/wnmz/mWE=
=VqOw
-----END PGP SIGNATURE-----

--=-61YiVj4Jf42UQAnEKBq+--

