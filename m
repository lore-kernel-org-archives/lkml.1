Return-Path: <linux-kernel-owner+w=401wt.eu-S965271AbXDMWnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965271AbXDMWnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965277AbXDMWnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:43:39 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:36209 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030873AbXDMWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:43:35 -0400
Subject: Re: [linux-pm] [RFD] swsusp problem: Drivers allocate much memory
	during	suspend (was: Re: 2.6.21-rc5: swsusp: Not enough free memory)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pavel Machek <pavel@suse.cz>
Cc: linux-pm@lists.osdl.org, Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20070413223841.GD28269@elf.ucw.cz>
References: <460B6E4B.3060004@gmail.com> <200704131400.12021.rjw@sisk.pl>
	 <1176466896.7112.159.camel@nigel.suspend2.net>
	 <200704132241.52725.rjw@sisk.pl> <20070413221016.GQ28264@elf.ucw.cz>
	 <1176503692.7112.189.camel@nigel.suspend2.net>
	 <20070413223841.GD28269@elf.ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sytiPjWJdglYn/ivsfE6"
Date: Sat, 14 Apr 2007 08:43:30 +1000
Message-Id: <1176504210.7112.204.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sytiPjWJdglYn/ivsfE6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-04-14 at 00:38 +0200, Pavel Machek wrote:
> Hi!
>=20
> > > > > > Well, it looks like someone allocated about 6000 pages after we=
 had freed
> > > > > > enough memory for suspending.
> > > > >=20
> > > > > We have a tunable allowance in Suspend2 for this, because fglrx
> > > > > allocates a lot of pages in its suspend routine if DRI is enabled=
. I
> > > > > think some other drivers do too, but fglrx is the main one I know=
.
> > > >=20
> > > > I wasn't aware of that, thanks for the information.
> > > >=20
> > > > I think this means we'll probably need to add a tunable, similar to=
 image_size,
> > > > that will allow the users to specify how much spare memory they wan=
t to reserve
> > > > for suspending (instead of the constant PAGES_FOR_IO).  IMO we can =
call it
> > > > 'spare_memory'.
> > >=20
> > > Just increase PAGES_FOR_IO. This should not be tunable.
> >=20
> > If we don't have a means for drivers to pre-allocate or say how much
> > memory they need, it should be tunable. Frankly, I'm startled that you
> > guys haven't heard of this issue before now. I can't believe everyone
> > who has ever wanted to hibernate with DRM enabled has been using
> > Suspend2. Maybe this is one of the sources of complaints that swsusp
> > isn't reliable?
>=20
> We do not support closed-source drivers, and open-source drivers are
> well behaved.

I didn't say fglrx was the only example. Any system using DRI (not DRM,
sorry), would, I think, be expected. I just mention fglrx because I have
a Radeon 200M that can only use fglrx for Beryl etc at the mo - it's the
one I'm familiar with.

> > > > IMO to really fix the problem, we should let the drivers that need =
much memory
> > > > for suspending allocate it _before_ the memory shrinker is called. =
 For this
> > > > purpose we can use notifiers that will be called before we start th=
e shrinking
> > > > of memory.  Namely, if a driver needs to allocate substantial amoun=
t
> > > > of memory
> > >=20
> > > Yes please. Using that notifier without leaking the memory will be
> > > "interesting" but if someone needs so much memory during suspend, let
> > > them eat their own complexity.
> >=20
> > It doesn't need to be that complex. Add another (optional) function to
> > the driver model to let drivers say how much they want and it becomes
> > trivial. Maybe this idea should be preferred over the notifier chain.
>=20
> Actually, it is trivial to prealocate during boot ;-). As the notifier
> chain can be useful for other stuff, too, I'd go that way.

Pavel! Talk sense! You're not seriously suggesting squirreling away 35
megabytes of a user's memory at boot just because they might want to
hibernate with DRI enabled later? Yes, 35 megabytes is a realistic
amount.

Regards,

Nigel

--=-sytiPjWJdglYn/ivsfE6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGIAeSN0y+n1M3mo0RAp1dAKDhopOaaMNcRBGYC0FTpeDtSIu4vwCgxkxN
cLeOLCFZSA64VEa67l6fBsc=
=nFM4
-----END PGP SIGNATURE-----

--=-sytiPjWJdglYn/ivsfE6--

