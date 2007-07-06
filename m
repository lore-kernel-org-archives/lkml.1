Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbXGFHHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbXGFHHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762181AbXGFHHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:07:33 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:44642 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758413AbXGFHHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:07:32 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Date: Fri, 6 Jul 2007 17:07:20 +1000
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       nigel@suspend2.net, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Paul Mackerras <paulus@samba.org>,
       Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>
References: <200707041658.59588.rjw@sisk.pl> <20070705220046.GC3881@elf.ucw.cz> <200707060902.55090.rjw@sisk.pl>
In-Reply-To: <200707060902.55090.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3909026.cUa00Odpy5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061707.23316.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3909026.cUa00Odpy5
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 17:02:53 Rafael J. Wysocki wrote:
> On Friday, 6 July 2007 00:00, Pavel Machek wrote:
> > Hi!
> >=20
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > The syncing of filesystems from within the freezer is generally not=20
needed.
> > > Change freeze_processes() so that it doesn't execute sys_sync() and m=
ake=20
the
> > > suspend and hibernation code path sync filesystems independently of t=
he=20
freezer.
> >=20
> > Yes, we can do that, but ... why?
>=20
> I think that sync and the freezer are different things and shouldn't be=20
mixed in
> such a way as they are now.
>=20
> > Does it actually fix FUSE?
>=20
> It should prevent the freezer from deadlocking.

That's not the same thing. It's like saying "My footbrake grabs so I'll use=
=20
the handbrake all the time. Take the stone out of the brake pad! :)

> > Miklos claims sync is nop on FUSE...?=20
>=20
> In that case there shouldn't be any deadlock, but a freezer failure. :-)

Isn't this scary? I'm agreeing with Pavel and the two of us seem to be=20
disagreeing with everyone else!

To get more serious and practical though, I think the solution is to fuzz t=
he=20
userspace/kernelspace distinction. What we really want to do is freeze thin=
gs=20
that submit I/O, then sync, then freeze anything that processes I/O and nee=
ds=20
to be frozen. In effect, redefine fuse processes as freezeable kernel=20
threads.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart3909026.cUa00Odpy5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjeorN0y+n1M3mo0RAiefAKDvj0tKkFt9pMB58ZsOGRtSBYanswCgx4TJ
Dppfj0MqT6eS0tZ/TKtRUGw=
=/bZU
-----END PGP SIGNATURE-----

--nextPart3909026.cUa00Odpy5--
