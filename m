Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXGVXSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXGVXSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760682AbXGVXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:18:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:55889 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760288AbXGVXSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:18:08 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Mon, 23 Jul 2007 09:18:17 +1000
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>, nigel@suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Miklos Szeredi <miklos@szeredi.hu>, miltonm@bga.com,
       ying.huang@intel.com, linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org> <200707230842.22121.nigel@nigel.suspend2.net> <200707230109.23071.rjw@sisk.pl>
In-Reply-To: <200707230109.23071.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1606567.qAtlRnV7Q7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707230918.18213.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1606567.qAtlRnV7Q7
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 July 2007 09:09:21 Rafael J. Wysocki wrote:
> Hi,
>=20
> On Monday, 23 July 2007 00:42, Nigel Cunningham wrote:
> > Hi Alan.
> >=20
> > On Monday 23 July 2007 01:26:23 Alan Stern wrote:
> > > On Sun, 22 Jul 2007, Nigel Cunningham wrote:
> > >=20
> > > > Hi.
> > > >=20
> > > > On Sunday 22 July 2007 02:13:56 Jeremy Maitin-Shepard wrote:
> > > > > It seems that you could still potentially get a failure to freeze=
 if=20
one
> > > > > FUSE process depends on another, and the one that is frozen secon=
d=20
just
> > > > > happens to be waiting on the one that is frozen first when it is=
=20
frozen.
> > > > > I admit that this situation is unlikely, and perhaps acceptable.
> > > > >=20
> > > > > A larger concern is that it seems that freezing FUSE processes at=
=20
all
> > > > > _will_ generate deadlocks if a non-synchronous or=20
memory-map-supporting
> > > > > filesystem is loopback mounted from a FUSE filesystem.  In that=20
case, if
> > > > > you attempt to sync or free memory once FUSE is frozen, you are s=
ure=20
to
> > > > > get a deadlock.
> > > >=20
> > > > Ok. So then (in response to Alan too), how about keeping a tree of=
=20
mounts,=20
> > > > akin to the device tree, and working from the deepest nodes up? (In=
=20
> > > > conjunction with what I already suggested)?
> > >=20
> > > Face it, Nigel, this is a losing battle.  You can try to come up with
> > > ever-more complex schemes to try and force FUSE into the freezer's
> > > framework, but it just won't fit.  Or if it does, the next filesystem
> > > to come along will require an even more baroque type of special-case=
=20
> > > handling.
> >=20
> > It does seem to be a losing battle, but I'm wondering whether that's=20
really=20
> > because it's an intractable problem, or because people have given up on=
 it=20
> > before its time. We are talking about a computer system, so things shou=
ld=20
be=20
> > predictable.
> > =20
> > > The general problem is that task A may be in an unfreezable state,
> > > waiting for task B to do something, while task B is already frozen. =
=20
> > > Since there's no reasonable way to determine that A really is waiting
> > > for B, you're just stuck.  (To make matters worse, A may not even
> > > realize which task it is waiting for; it may know only that it's
> > > waiting for somebody to do something!)  A and B could be user tasks,=
=20
> > > kernel threads, or one of each.
> >=20
> > I guess I want to persist because all of these issues aren't utterly=20
> > unsolvable. It's just that we don't have the infrastructure yet to figu=
re=20
out=20
> > the solutions to these issues trivially. Take, for example, the locking=
=20
> > issue. If we could call some function to say "What process holds this=20
lock?",=20
> > then task A could know that it's waiting on task B and put that=20
information=20
> > somewhere. We could then use the information to freeze task B before ta=
sk=20
A.
> >=20
> > =20
> > > The only thing to do is what Rafael has been working on: unfreeze
> > > things, hope the tasks sort themselves out, and try again.
> >=20
> > That's what I'm questioning. Is there a more reliable way and we've jus=
t=20
given=20
> > up too quickly?
>=20
> Well, there probably is one, but it likely would require us to make chang=
es
> that wouldn't be accepted by some people and thus would never be merged.

Well, doesn't that imply that we should at least look into what changes wou=
ld=20
be needed? If they wouldn't be accepted by some people, then either the=20
objections would be reasonable or they wouldn't (and would hopefully be=20
overridden). But we can't know if we don't try.

Regards,

Nigel

=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1606567.qAtlRnV7Q7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGo+W6N0y+n1M3mo0RApXeAJ9DnNm2lrW8TbCEqWTSPHSL5uBgSwCfTenb
+vcxjvuIN/yv+ENUfJrCcVM=
=4O5h
-----END PGP SIGNATURE-----

--nextPart1606567.qAtlRnV7Q7--
