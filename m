Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbXD0GeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbXD0GeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbXD0GeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:34:23 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:57210 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399AbXD0GeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:34:22 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <1177617379.4737.29.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
	 <1177654110.4737.91.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ssluRBLI/xBs+YsIkSXc"
Date: Fri, 27 Apr 2007 16:34:21 +1000
Message-Id: <1177655661.4737.106.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ssluRBLI/xBs+YsIkSXc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-27 at 09:18 +0300, Pekka J Enberg wrote:
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > COW is a possibility, but I understood (perhaps wrongly) that Linus was
> > thinking of a single syscall or such like to prepare the snapshot. If
> > you're going to start doing things like this, won't that mean you'd the=
n
> > have to update/redo the snapshot or somehow nullify the effect of
> > anything the programs does so that doing it again after the snapshot is
> > restored doesn't cause problems?
>=20
> No. The snapshot is just that. A snapshot in time. From kernel point of=20
> view, it doesn't matter one bit what when you did it or if the state has=20
> changed before you resume. It's up to userspace to make sure the user=20
> doesn't do real work while the snapshot is being written to disk and=20
> machine is shut down.

Sorry Pekka, but that's just broken.

It implies firstly that we tell all userspace programs "I'm sorry, but
I'm suspending at the moment. Can you tip toe quietly around while I do
it?" You can't seriously expect every userspace program to be modified
to adjust it's behaviour according to whether we're writing a snapshot
to disk at the moment or not.

It also implies that we can prepare a snapshot and then happily have the
contents of the disk change so that they don't match the superblock and
other filesystem details we just saved in the snapshot. We can't. At
least not without modifying all the filesystems so that (at a minimum)
they know how to throw away all the metadata they have at resume time
and reread it from disk.

> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > I was going to leave it at that and press send, but perhaps that
> > wouldn't be wise. I feel I should also ask what you're thinking of as a
> > means of making sure userspace doesn't do much activity.
>=20
> When the snapshot pages are COW, we will run out of memory if userspace=20
> writes to those pages too much. If userspace is blocked, say like=20
> displaying a "we are suspending" in X which blocks the user from using=20
> other programs that could generate new writes and mounting filesystems=20
> read-only, we don't need to worry about running out of memory.

This sounds feasible, but it's only really acceptable if your willing to
have hibernation fail or restart multiple times. If your battery is
running out or you need to rush to put a lappy in your bag because they
train just came early, that's not an option. It's for that very reason
that I've put a lot of effort into trying to make it work first time,
every time. Not there yet, but it's a priority.

By the way, sorry. This email feels like it is pouring a lot of cold
water on your ideas. I don't want to be negative!

Regards,

Nigel

--=-ssluRBLI/xBs+YsIkSXc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMZltN0y+n1M3mo0RAs92AJ9g8nvflWwlk9BznGFt4IXygYVLjQCgoHke
UcDt5u/PxqZAphHKX13mt5w=
=Ix2G
-----END PGP SIGNATURE-----

--=-ssluRBLI/xBs+YsIkSXc--

