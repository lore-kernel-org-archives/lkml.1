Return-Path: <linux-kernel-owner+w=401wt.eu-S1751413AbXE2WKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbXE2WKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXE2WKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:10:07 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54279 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbXE2WKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:10:05 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Lord <lkml@rtr.ca>, Pavel Machek <pavel@ucw.cz>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org>
References: <1179870110.16656.2.camel@localhost>
	 <1180008394.15600.26.camel@localhost>
	 <alpine.LFD.0.98.0705240854250.26602@woody.linux-foundation.org>
	 <20070524200435.GA9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241323361.26602@woody.linux-foundation.org>
	 <20070524220017.GC9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241507050.26602@woody.linux-foundation.org>
	 <20070524221743.GD9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241550030.26602@woody.linux-foundation.org>
	 <20070524231852.GG9604@elf.ucw.cz>
	 <alpine.LFD.0.98.0705241736120.26602@woody.linux-foundation.org>
	 <1180058123.3997.91.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
	 <1180059605.3997.100.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
	 <1180062040.3997.112.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
	 <1180067587.3997.136.camel@nigel.suspend2.net>  <465C366C.2070900@rtr.ca>
	 <1180473765.20718.47.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0/Yii8glH9GCOPVTFWuw"
Date: Wed, 30 May 2007 08:10:04 +1000
Message-Id: <1180476604.20718.50.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0/Yii8glH9GCOPVTFWuw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-29 at 14:33 -0700, Linus Torvalds wrote:
>=20
> On Wed, 30 May 2007, Nigel Cunningham wrote:
> >=20
> > On Tue, 2007-05-29 at 10:19 -0400, Mark Lord wrote:
> > >=20
> > > How about blocking brk() and mmap(MAP_ANONYMOUS) in addition to
> > > the filesystem VFS callers?   Or is that starting to get messy again?
> >=20
> > Yeah. Getting messy again :)
>=20
> Indeed. And also misses the point - the point being that we don't actuall=
y=20
> need to freeze anything at all most of the time. There's nothing wrong=20
> with making memory allocations etc.
>=20
> And yes, suspend is different from hibernate. I can see how hibernate=20
> people are worried about people writing to things after doing the=20
> snapshot, but those concerns don't exist with suspend. With suspend, the=20
> biggest concern is accessing a device after it has been suspended, but on=
=20
> the other hand, also the fact that we end up having driver writers used=20
> to the system being "runnable", so they do things that really do require =
a=20
> full-fledged system (and sometimes that means just some delayed action=20
> using a kernel thread, other times it seems to rely on more complex=20
> behaviour like firmware loading :^p )

Yeah, but they can't. Even after the freezing of processes has been
removed from the normal suspend to ram path, we're still going to have
this issue with the suspend to ram after writing a hibernation image
path.

Regards,

Nigel

--=-0/Yii8glH9GCOPVTFWuw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXKS8N0y+n1M3mo0RAsLsAKCQ1kLcVIuErxEjDJIaHGfTCeJZrQCcDKqv
USD/koDKjzHKUC1vrPVypX0=
=yScV
-----END PGP SIGNATURE-----

--=-0/Yii8glH9GCOPVTFWuw--

