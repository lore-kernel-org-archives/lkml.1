Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbXGEMii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbXGEMii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757234AbXGEMia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:38:30 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:48942 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164AbXGEMia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:38:30 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 22:38:25 +1000
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, Oliver Neukum <oliver@neukum.org>,
       Miklos Szeredi <miklos@szeredi.hu>, benh@kernel.crashing.org,
       mjg59@srcf.ucam.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <20070704234523.GC2719@elf.ucw.cz> <200707051425.07904.rjw@sisk.pl>
In-Reply-To: <200707051425.07904.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1201636.iSAgefnjtu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707052238.27889.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1201636.iSAgefnjtu
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 22:25:06 Rafael J. Wysocki wrote:
> On Thursday, 5 July 2007 01:45, Pavel Machek wrote:
> > On Tue 2007-07-03 21:32:20, Oliver Neukum wrote:
> > > Am Dienstag, 3. Juli 2007 schrieb Miklos Szeredi:
> > > > > And a further question. The freezer is not atomic. What do you do
> > > > > if a task not yet frozen calls sys_sync(), but fuse is already=20
frozen?
> > > >=20
> > > > What do you do if a task not yet frozen writes to a pipe, on the ot=
her
> > > > end of which is a task already frozen?
> >=20
> > There's some difference between uninterruptible and interruptible
> > sleep I'd say.
> >=20
> > > > It doesn't matter.  The only thing that should matter during suspend
> > > > (not hibernate) is saving the state of devices to ram, and putting =
the
> > > > devices to sleep.
> > >=20
> > > Well, but you did remove sys_sync() from the freezer, which is
> > > and must be called in the hibernate path.
> >=20
> > Not "must". In fact, hibernation should be safe without sys_sync(). It
> > is just user un-friendly.
>=20
> In fact, I'd like to remove the sys_sync() from the freezer entirely,=20
because
> it just doesn't belong in there.
>=20
> The only advantege of having sys_sync() in freeze_processes() is that we
> have a chance to write out everything when applications cannot produce mo=
re
> data to write, but there are filesystems which don't do that anyway (eg.=
=20
XFS),
> so generally there's no reason to bother.

Shouldn't XFS - and fuse - be considered to be broken? Sync should sync dat=
a=20
and if XFS isn't doing that, it's wrong.

In the case of fuse, we should have a mechanism by which fuse processes can=
 be=20
made to sync if they do have any pending I/O, and by which they can be froz=
en=20
later than other userspace processes.

I'd like to see the sync stay, because it improves reliability and data=20
integrity in the fail-to-resume case. Calling scripts would probably invoke=
=20
sync themselves if they don't already, but that's racy. As it is at the=20
moment, we know userspace is stopped, so syncing isn't racy.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1201636.iSAgefnjtu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjOZDN0y+n1M3mo0RAk9mAKCSSal8CrEcxMwbaaxn4f4gftpzJgCg0gp9
ZszH0kVXyMj2Uy+XMSuy0Q8=
=Mksm
-----END PGP SIGNATURE-----

--nextPart1201636.iSAgefnjtu--
