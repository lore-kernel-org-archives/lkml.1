Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbXDZWUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbXDZWUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXDZWUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:20:35 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54055 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbXDZWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:20:33 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200704270008.19017.rjw@sisk.pl>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704261021160.9964@woody.linux-foundation.org>
	 <1177618081.4737.42.camel@nigel.suspend2.net>
	 <200704270008.19017.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a/Duw3AbzagQg5EnXmCD"
Date: Fri, 27 Apr 2007 08:20:31 +1000
Message-Id: <1177626031.4737.81.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a/Duw3AbzagQg5EnXmCD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Rafael.

On Fri, 2007-04-27 at 00:08 +0200, Rafael J. Wysocki wrote:
> On Thursday, 26 April 2007 22:08, Nigel Cunningham wrote:
> [--snip--]
> > > And no, I'm not saying that my suggestion is the only way to do it. G=
o=20
> > > wild. But the *current* situation is just broken. Three different thi=
ngs,=20
> > > none of which people can agree on. I'd *much* rather see a conceptual=
ly=20
> > > simpler approach that then required, but even more important is that =
right=20
> > > now people aren't even discussing alternatives, they're just pushing =
one=20
> > > of the three existing things, and that's simply not viable. Because I=
'm=20
> > > not merging another one.
> > >=20
> > > In fact, I personally feel that I shouldn't even have merged=20
> > > userspace-swsusp, but if Andrew thinks it needs to be merged, my pers=
onal=20
> > > feelings simply don't matter that much. I have to trust people. But y=
es,=20
> > > as far as *I* am personally concerned, I think it was a mistake to me=
rge=20
> > > it.
> >=20
> > Perhaps you should try to make an alternative yourself instead of
> > pushing us into making something we don't believe will work (my case) o=
r
> > have already done but in a way you don't like (Rafael). Don't talk abou=
t
> > Pavel cutting code. He's just acking/nacking what Rafael sends him.
>=20
> Well, I think that much of what Linus is saying indicates that he hasn't =
tried
> to write any such thing himself. ;-)
>=20
> Anyway, I'm tired of all this thing.  Really.  I've just been trying to m=
ake
> things _work_ more-or-less reliably in a way that Pavel liked and I reall=
y
> didn't know that much about the kernel when I started.  In fact, I starte=
d as a
> user who needed certain functionality from the kernel and that was not th=
ere
> at the time.  I've made some mistakes because of that (like the definitio=
ns of
> the ioctl numbers in suspend.h - this was just a rookie mistake, and I'm
> ashamed of it, but _nobody_ catched it, although I believe many people we=
re
> looking at the patch).
>=20
> Now that I know much more than before, I can say I agree with Linus on hi=
s
> opinion about the separation of s2ram form the snapshot/restore functiona=
lity
> (I'll call it 'hibernation' for simplicity from now on).  It should be do=
ne,
> because it would make things simpler and cleaner.  Still, it will be diff=
icult
> to do without screwing users en masse and that's my main concern here.
>=20
> I don't agree that we don't need the tasks freezer for suspending and
> hibernation.  We need it, because we need to be sure that the (other) tas=
ks
> will not get us in the way, and that also applies to kernel threads (and =
I
> don't think the tasks freezer is 'screwing' them, BTW).
>=20
> I agree that the userland interface for swsusp is not very nice and I'm g=
oing
> to do my best to clean that up.  I hope that someone will help me, but if=
 not,
> then that's fine.  OTOH, it's difficult, if not impossible, to do a
> userland-driven hibernation in a completely clean way.  I've tried that a=
nd I'm
> not exactly satisfied with the result, although it works and some distros=
 use
> it.  I wouldn't have done it again, but then I'm going to support the exi=
sting
> users, as I promised.
>=20
> Now, I think that the hibernation should better be done completely in the
> kernel, because that's just conceptually simpler, although some data exch=
ange
> with the user land may be acceptable for some optional fancy stuff.  I'm =
also
> tierd of the endless "to merge or not to merge suspend2" discussions that=
 just
> lead to nowhere.  For these reasons I declare that I'm ready to cooperate=
 with
> Nigel on integrating as much of suspend2 as reasonably possible into the
> existing infrastructure, under the following conditions:
> - we don't remove the existing user-visible interfaces

I don't want to remove user visible interfaces either (I understand that
you mean the ioctls by that?). Perhaps we can find a way to make them
still usable with a more in-kernel solution (ie some things become
noops?).

> - we work on one piece of code at a time

Sure. We should spend some time discussing and planning beforehand so we
don't waste time and effort writing and rewriting.

> - we avoid code duplication, as much as possible

No problem there.

> - we avoid using open-coded things, if possible

Regarding open-coded things, I assume you're referring to the extents. I
would argue that they're not open-coded because list.h implements doubly
linked lists, and extents use a singly linked list. That said, I suppose
we could make the extents doubly linked and use list.h, even though that
would be a waste of 4/8 bytes per extent.

> - if we don't agree on something, we ask someone wiser (volunteers welcom=
e ;-))

Absolutely!

> If that's acceptable, we can start tomorrow.  In the process, we can try =
to
> separate the hibernation code paths from the s2ram ones, but that will re=
quire
> a lot of knowledge about things that neither me nor Nigel, AFAICT, are ve=
ry
> familiar with, like writing device drivers.

Yes.

Thanks for this email. It's really encouraging, and I'm more than glad
to work with you. Unfortunately, as you've seen me keep saying already,
I have very limited time to work on this. Thankfully you seem to have
more, and Pekka has also stepped up to help, so maybe we can make good
forward progress despite my limitations.

Regards,

Nigel

--=-a/Duw3AbzagQg5EnXmCD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMSWvN0y+n1M3mo0RAvKNAJ43QuKI458FzT//euBltmtSajcy9wCfRVej
hZL8mewILU4pRJ0GkLORwcs=
=KOSg
-----END PGP SIGNATURE-----

--=-a/Duw3AbzagQg5EnXmCD--

