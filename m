Return-Path: <linux-kernel-owner+w=401wt.eu-S1765596AbXGVWmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765596AbXGVWmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759837AbXGVWmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:42:13 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:33047 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbXGVWmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:42:12 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 08:42:17 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, miltonm@bga.com,
       ying.huang@intel.com, linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart49403152.UEObEegZSz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707230842.22121.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart49403152.UEObEegZSz
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Alan.

On Monday 23 July 2007 01:26:23 Alan Stern wrote:
> On Sun, 22 Jul 2007, Nigel Cunningham wrote:
>=20
> > Hi.
> >=20
> > On Sunday 22 July 2007 02:13:56 Jeremy Maitin-Shepard wrote:
> > > It seems that you could still potentially get a failure to freeze if =
one
> > > FUSE process depends on another, and the one that is frozen second ju=
st
> > > happens to be waiting on the one that is frozen first when it is froz=
en.
> > > I admit that this situation is unlikely, and perhaps acceptable.
> > >=20
> > > A larger concern is that it seems that freezing FUSE processes at all
> > > _will_ generate deadlocks if a non-synchronous or memory-map-supporti=
ng
> > > filesystem is loopback mounted from a FUSE filesystem.  In that case,=
 if
> > > you attempt to sync or free memory once FUSE is frozen, you are sure =
to
> > > get a deadlock.
> >=20
> > Ok. So then (in response to Alan too), how about keeping a tree of moun=
ts,=20
> > akin to the device tree, and working from the deepest nodes up? (In=20
> > conjunction with what I already suggested)?
>=20
> Face it, Nigel, this is a losing battle.  You can try to come up with
> ever-more complex schemes to try and force FUSE into the freezer's
> framework, but it just won't fit.  Or if it does, the next filesystem
> to come along will require an even more baroque type of special-case=20
> handling.

It does seem to be a losing battle, but I'm wondering whether that's really=
=20
because it's an intractable problem, or because people have given up on it=
=20
before its time. We are talking about a computer system, so things should b=
e=20
predictable.
=20
> The general problem is that task A may be in an unfreezable state,
> waiting for task B to do something, while task B is already frozen. =20
> Since there's no reasonable way to determine that A really is waiting
> for B, you're just stuck.  (To make matters worse, A may not even
> realize which task it is waiting for; it may know only that it's
> waiting for somebody to do something!)  A and B could be user tasks,=20
> kernel threads, or one of each.

I guess I want to persist because all of these issues aren't utterly=20
unsolvable. It's just that we don't have the infrastructure yet to figure o=
ut=20
the solutions to these issues trivially. Take, for example, the locking=20
issue. If we could call some function to say "What process holds this lock?=
",=20
then task A could know that it's waiting on task B and put that information=
=20
somewhere. We could then use the information to freeze task B before task A.

=20
> The only thing to do is what Rafael has been working on: unfreeze
> things, hope the tasks sort themselves out, and try again.

That's what I'm questioning. Is there a more reliable way and we've just gi=
ven=20
up too quickly?

Regards,

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart49403152.UEObEegZSz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGo91ON0y+n1M3mo0RAh03AKDRmdkrsY1b1GQSRR3mIPlpHtqZZACfS3cL
Z8GCPQak9O8SuPpS/WxGbRA=
=5hPA
-----END PGP SIGNATURE-----

--nextPart49403152.UEObEegZSz--
