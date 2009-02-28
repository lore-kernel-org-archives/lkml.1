Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZB1T5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZB1T5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 14:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZB1T5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 14:57:36 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:36418 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZB1T5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 14:57:35 -0500
Subject: Re: i915 X lockup
From: Eric Anholt <eric@anholt.net>
To: Bruno =?ISO-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       airlied@linux.ie, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090228192406.496257b2@neptune.home>
References: <49A7B253.906@gmail.com>
	 <20090227023231.76e7c65f.akpm@linux-foundation.org>
	 <20090227130440.GA24633@silver.sucs.org> <49A7EF52.8080105@gmail.com>
	 <20090227231207.GA4687@silver.sucs.org> <1235780431.6992.14.camel@gaiman>
	 <49A8F660.10604@gmail.com>
	 <20090228004751.96d1ea8d.akpm@linux-foundation.org>
	 <1235811657.6992.77.camel@gaiman>  <20090228192406.496257b2@neptune.home>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VzRtztm9bD9T1dEbjP8+"
Date: Sat, 28 Feb 2009 11:57:32 -0800
Message-Id: <1235851052.6992.98.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VzRtztm9bD9T1dEbjP8+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-28 at 19:24 +0100, Bruno Pr=C3=A9mont wrote:
> On Sat, 28 February 2009 Eric Anholt <eric@anholt.net> wrote:
> > On Sat, 2009-02-28 at 00:47 -0800, Andrew Morton wrote:
> > > The kernel deadlocked on struct_mutex, did it not?  That's a kernel
> > > bug regardless of what userspace you're running.
> > >=20
> > > Do we know why this happened?
> >=20
> > Userland went stomping all over the device state that the kernel
> > thinks it controls since you went and turned on the KMS option
> > asserting "I'm not going to run old userland", so the GPU got hung,
> > and further software using the GPU hung, and then somebody waiting
> > for someone else finishing using the GPU (struct_mutex) got hung.
> >=20
> > The only proposal to prevent it is to use the "don't let userland map
> > my PCI device any more" support we now have available to us, which
> > would make X fail early on.  The unfortunate side-effect of that is
> > that we lose the ability to run incredibly useful userland debug
> > tools that do read-only access to registers.  We're moving bits of
> > those into debugfs for 2.6.30, but it's work that's not done even for
> > the tools we have today.
>=20
> I also saw/see Xorg lockup...
>=20
> I'm running xf86-video-intel-2.6.1 (2.6.2 released only very recently)
> and kernel with KMS disabled (KMS not capable of getting framebuffer
> properly configured it seems, at least display remains black)
>=20
> For me it's a deadlock between intel driver dispatching GEM requests
> and events (see log below).
> For me each time it happends was while interacting with a webbrowser,
> though it does not happend very often.
>=20
> Connecting to the notebook via ssh I can kill -KILL Xorg (kill -TERM
> does not work).
> When doing this GPU gets at least confused though in order to get
> vesafb back working it's sufficient to start Xorg with vesa driver
> (running with intel driver before rebooting leads to locked X and
> need to retry the killing)

You have a completely different problem.

Your GPU is hung in doing something that should work.  8xx support is
notoriously bad right now, and we haven't managed to get the developer
time on fixing it that we need, though I keep pushing for it.  My only
855 has a dead disk, or I probably would have poked at it by now.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-VzRtztm9bD9T1dEbjP8+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmplywACgkQHUdvYGzw6ve82wCghANpCNEkNQBiQ0hQBFsx7yWJ
Y3MAnjriq6LwpxFTUyH2gbDAjDgP2Hxw
=+OrD
-----END PGP SIGNATURE-----

--=-VzRtztm9bD9T1dEbjP8+--
