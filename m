Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbXGGJNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbXGGJNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 05:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbXGGJNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 05:13:44 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34559 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbXGGJNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 05:13:43 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] Freezer: Handle uninterruptible tasks
Date: Sat, 7 Jul 2007 19:13:42 +1000
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <200707061012.48998.rjw@sisk.pl> <20070707075018.GB2638@elf.ucw.cz>
In-Reply-To: <20070707075018.GB2638@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1224078.IenSHiJm17";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707071913.43482.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1224078.IenSHiJm17
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Saturday 07 July 2007 17:50:18 Pavel Machek wrote:
> Hi!
>=20
> > The main limitation of the freezer is that it cannot handle=20
uninterruptible
> > tasks.  Namely, if there are uninterruptible tasks in the system, the=20
freezer
> > returns an error, which makes it impossible to suspend the system.
> ...
> > Unfortunately, this mechanism also leads to severe limitations, such as=
=20
that it
> > makes the freezer unable to handle systems using FUSE in a reliable way.
> >=20
> > This patch makes the freezer skip uninterruptible user space tasks (ie.=
=20
such
> > that have an mm of their own) when counting the tasks to be frozen.  As=
 a
> > result, these tasks have the TIF_FREEZE and TIF_SIGPENDING flags set, b=
ut=20
the
> > freezer doesn't wait for them to enter the refrigerator.  Nevertheless,=
=20
they
> > will enter the refrigerator as soon as they change their state.
>=20
> I don't think we can do that. I suspect rename looks like:
>=20
> 	write directory entry in source
> A)	(uninterruptible wait for write)
> 	write directory entry in destination
> 	(uninterruptible wait for write)
> 	write something else
>=20
> If we freeze some task in place "A)", we'll write to the disk when the
> directory write is finished :-(.

Renaming is a single syscall, so won't the process get frozen when the sysc=
all=20
finishes? The sys_sync will also help here - it will ensure the rename gets=
=20
flushed before we start on freezing kernel threads.

Perhaps you've just found more logic for keeping the sys_sync there?

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1224078.IenSHiJm17
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGj1lHN0y+n1M3mo0RAgKlAJ9YI4zJzlL9bwAknrVnrkOiZU5O+gCgnXmS
Cm4oeo7+qQhhj4HjJpPzG4U=
=jLOo
-----END PGP SIGNATURE-----

--nextPart1224078.IenSHiJm17--
