Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbXD0WIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbXD0WIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbXD0WIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:08:00 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:37994 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbXD0WHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:07:45 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <1177654110.4737.91.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
	 <200704272324.43359.rjw@sisk.pl>
	 <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RPVS8gfRxsdh1gniqpXl"
Date: Sat, 28 Apr 2007 08:07:46 +1000
Message-Id: <1177711666.4737.176.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RPVS8gfRxsdh1gniqpXl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-27 at 14:44 -0700, Linus Torvalds wrote:
>=20
> On Fri, 27 Apr 2007, Rafael J. Wysocki wrote:
> >=20
> > Why do you think that keeping the user space frozen after 'snapshot' is=
 a bad
> > idea?  I think that solves many of the problems you're discussing.
>=20
> It makes it harder to debug (wouldn't it be *nice* to just ssh in, and do
>=20
> 	gdb -p <snapshotter>

Make the machine being suspended a VM and you can already do that.

> when something goes wrong?) but we also *depend* on user space for variou=
s=20
> things (the same way we depend on kernel threads, and why it has been suc=
h=20
> a total disaster to try to freeze the kernel threads too!). For example,=20
> if you want to do graphical stuff, just using X would be quite nice,=20
> wouldn't it?

It would be nice, yes.

But in doing so you make the contents of the disk inconsistent with the
state you've just snapshotted, leading to filesystem corruption. Even if
you modify filesystems to do checkpointing (which is what we're really
talking about), you still also have the problem that your snapshot has
to be stored somewhere before you write it to disk, so you also have to
either

1) write some known static memory to disk before the snapshot and reuse
it for the snapshot,
2) ensure up to half the RAM is free for your snapshot or=20
3) compress the snapshot as you take it, guessing beforehand how much
memory the compressed snapshot might take and freeing that might
4) reserve memory at boot time for the atomic copy so that 2) or 3) is
still done, but without having to free the memory. (Yuk!).

> But I do agree that doing everythign in the kernel is likely to just be a=
=20
> hell of a lot simpler for everybody.

Indeed.

Nigel

--=-RPVS8gfRxsdh1gniqpXl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMnQyN0y+n1M3mo0RArCgAKC4Pdvo+LR12iLW3P4mewwIQ9Fu8wCbBklS
WdCvc4S4PLdRwHZK8Qr6ii0=
=+XEI
-----END PGP SIGNATURE-----

--=-RPVS8gfRxsdh1gniqpXl--

