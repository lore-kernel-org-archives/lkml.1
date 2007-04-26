Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbXDZWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbXDZWI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXDZWI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:08:28 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54723 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbXDZWI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:08:27 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       Dumitru Ciobarcianu <Dumitru.Ciobarcianu@ines.ro>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christian Hesse <mail@earthworm.de>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>,
       "suspend2-devel@lists.suspend2.net" 
	<suspend2-devel@lists.suspend2.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <200704262322.24048.rjw@sisk.pl>
References: <qlG9V8pP.1177603830.8836760.penberg@cs.helsinki.fi>
	 <200704262237.32665.rjw@sisk.pl>
	 <1177620949.4737.61.camel@nigel.suspend2.net>
	 <200704262322.24048.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bhFXgYG6fTgQR6+Xonuy"
Date: Fri, 27 Apr 2007 08:08:25 +1000
Message-Id: <1177625305.4737.70.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bhFXgYG6fTgQR6+Xonuy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 23:22 +0200, Rafael J. Wysocki wrote:
> On Thursday, 26 April 2007 22:55, Nigel Cunningham wrote:
> > Hi.
> >=20
> > On Thu, 2007-04-26 at 22:37 +0200, Rafael J. Wysocki wrote:
> > > On Thursday, 26 April 2007 22:16, Nigel Cunningham wrote:
> > > > Hi.
> > > >=20
> > > > On Thu, 2007-04-26 at 21:28 +0200, Rafael J. Wysocki wrote:
> > > > > On Thursday, 26 April 2007 18:10, Pekka Enberg wrote:
> > > > > >=20
> > > > > > On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > > In principle, we could add suspend2 as an alternative (in ana=
logy with the I/O
> > > > > > > schedulers, for example), but I think for this purpose it sho=
uld be reviewed
> > > > > > > properly.
> > > > > >=20
> > > > > > Yeah, this makes sense.
> > > > > >=20
> > > > > > On 4/26/2007, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > > > > There also is a real problem with how it uses the LRU pages. =
 It _seems_ to
> > > > > > > work, but at least to me it seems to be potentially dangerous=
.
> > > > > >=20
> > > > > > I am new to suspend2 so can you please explain what exactly is =
dangerous
> > > > > > about it?
> > > > >=20
> > > > > After freezing tasks, it first saves the contents of the LRU page=
s, freezes
> > > > > devices and then uses the LRU pages for storing the suspend image=
 (if more
> > > > > memory is needed, it's allocated, but that's irrelevant here).  N=
ow, we have no
> > > > > warranty that the LRU pages are not updated after we've saved the=
ir contents
> > > > > (first potential problem here).
> > > > >=20
> > > > > After the image has been created, we have to unfreeze devices and=
 save the
> > > > > image.  Now, we have no warranty that no one will be writing to t=
he LRU pages
> > > > > that we have used to store the image, for whatever reasons known =
to him, so the
> > > > > image can potentially get corrupted while it's being saved.
> > > > >=20
> > > > > In principle, device drivers can do this and there are some kerne=
l threads that
> > > > > also can do this (we don't freeze them, because they're needed fo=
r the image
> > > > > saving).
> > > > >=20
> > > > > The design is conceptually really really complicated and it makes=
 strong
> > > > > assumptions about the behavior of different subsystems.  While th=
ese
> > > > > assumptions _may_ be satisfied right now, we'd have to ensure the=
 satisfaction
> > > > > of them in the future if suspend2 were merged.
> > > >=20
> > > > That's a good description of the issue, although I think _may_ and
> > > > _seems_ are stating things a bit more pessimistically than is
> > > > necessary.=20
> > >=20
> > > I've used them to express my personal concerns.
> > >=20
> > > > You see, we need to remember that the pages which are saved separat=
ely
> > > > are LRU pages. Because userspace is frozen, their contents are goin=
g to
> > > > be static. The only possibilities for modifying them come from time=
r
> > > > routines, improperly frozen filesystems and device drivers.
> > >=20
> > > And kernel threads that we don't freeze deliberately.  Currently, the=
se are
> > > all worker threads, dm-related kernel threads and some others.
> > >=20
> > > > We have code to check that the LRU isn't changing, and I've only se=
en
> > > > one report of modifications to about 20 LRU pages. I haven't had th=
e
> > > > time yet to chase down the cause, but hope to do so soon.
> > >=20
> > > I didn't say that would be common.  If it had been, you'd have seen p=
roblems
> > > with it.  To me the problem is the lack of warranty that it won't hap=
pen.
> > >=20
> > > > The general scheme has been working for four or five years - if the=
re
> > > > was a fundamental issue, we would have found it by now.
> > > >=20
> > > > The scheme isn't complicated.
> > >=20
> > > Conceptually, it is complicated just because you're using the LRU.
> >=20
> > Well, I'm willing to look at other ideas. I actually selected LRU
> > because it was simple. Prior to this, we did have a try at just
> > iterating over the pages of frozen processes, but it didn't yield enoug=
h
> > pages to be viable. I wouldn't be surprised if hunting down the cause o=
f
> > these changing pages leads to doing the opposite - starting with LRU
> > pages and then removing all the ones owned by processes. (Am I right in
> > thinking the remainder would be anonymous pages? I must learn more mm
> > inards :>).
>=20
> I think we can discuss that, and the other things too.  I'm open to
> cooperation. :-)

Great!

Nigel

--=-bhFXgYG6fTgQR6+Xonuy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMSLYN0y+n1M3mo0RAhoyAKCvtCBZ3S+4xEjpDWloXhnmCXV56wCgz/Ki
IV7uIRAjsfX0M5x6eTgPNIc=
=mu7L
-----END PGP SIGNATURE-----

--=-bhFXgYG6fTgQR6+Xonuy--

