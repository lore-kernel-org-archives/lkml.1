Return-Path: <linux-kernel-owner+w=401wt.eu-S1757506AbXGDWwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbXGDWwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXGDWwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:52:10 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:59198 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbXGDWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:52:09 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync from within the freezer during suspend to RAM
Date: Thu, 5 Jul 2007 08:52:14 +1000
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
References: <200707041658.59588.rjw@sisk.pl> <200707050848.16163.nigel@nigel.suspend2.net> <20070704224942.GD2491@elf.ucw.cz>
In-Reply-To: <20070704224942.GD2491@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8401367.yHBPVo1QgU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707050852.15392.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8401367.yHBPVo1QgU
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 08:49:42 Pavel Machek wrote:
> On Thu 2007-07-05 08:48:15, Nigel Cunningham wrote:
> > Hi.
> >=20
> > On Thursday 05 July 2007 00:58:58 Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > The syncing of filesystems from within the freezer in not needed for=
=20
suspend=20
> > to
> > > RAM.  Change freeze_processes() so that it doesn't execute sys_sync()=
=20
and
> > > introduce the "syncing" version of it to be called from the hibernati=
on=20
code
> > > paths.
> > >=20
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > >  include/linux/freezer.h |   14 ++++++++++++--
> > >  kernel/power/disk.c     |    2 +-
> > >  kernel/power/main.c     |    6 ++++++
> > >  kernel/power/process.c  |    8 +++++---
> > >  kernel/power/user.c     |    2 +-
> > >  5 files changed, 25 insertions(+), 7 deletions(-)
> >=20
> > Looks ok, except that I wonder if you want the following fragment. It=20
looks to=20
> > me (looking at rc6) like with this code, you'll currently call sys_sync=
=20
twice=20
> > when suspending to ram. Maybe I'm misreading it. Also, shouldn't it be=
=20
done=20
> > after taking the mutex?
>=20
> sys_sync() should be okay to call, mutex or not.

Yeah. That wasn't my point, sorry. Calling sys_sync is pointless if you're=
=20
going to fail to take the mutex. It makes more sense to know you've got it=
=20
before you start doing things related to actually suspending.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart8401367.yHBPVo1QgU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjCSfN0y+n1M3mo0RAkL4AJsFfDtxPAaNVAFYfQ6WUQb7Sv8HVgCffKJC
yNP81MEmfN8F3licpy00nPo=
=M5Q2
-----END PGP SIGNATURE-----

--nextPart8401367.yHBPVo1QgU--
