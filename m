Return-Path: <linux-kernel-owner+w=401wt.eu-S1756040AbYFCAcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbYFCAcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYFCAcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:32:31 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:54263 "EHLO
	vonnegut.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYFCAca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:32:30 -0400
X-Greylist: delayed 3371 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2008 20:32:30 EDT
Subject: Re: in-kernel DRM tree move around....
From: Eric Anholt <eric@anholt.net>
To: Dave Airlie <airlied@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
In-Reply-To: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-B5nFKiiSI3Gfw410BW6E"
Date: Thu, 29 May 2008 12:41:25 -0700
Message-Id: <1212090086.2563.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 FreeBSD GNOME Team Port 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B5nFKiiSI3Gfw410BW6E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-29 at 10:46 +1000, Dave Airlie wrote:
> Hi,
>=20
> So I've been growing more annoyed with the current layout of the drm
> tree in the kernel,
>=20
> a) it lives under char.
> b) everything in one directory.
> c) header files in one directory.
> d) no header files exposed to userspace.
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/airlied/drm-2.6.git;a=3Dcommi=
tdiff;h=3D7df9a948d0f849466e3de259cccb49bc54cbad68
>=20
> is a proposal to create drivers/gpu/drm, (I may move AGP in there as
> well later). It also creates per-driver subdirs.
>=20
> This to me solves the a-d problems.
>=20
> There is also an out-of-tree kernel drm which I'll probably give some
> more thought later.

I like it.

For upstream DRM, my first thought was something like:

=EF=BB=BF=EF=BB=BFdrm/src/i915/i915_*.[ch]
drm/src/r128/r128_*.[ch]
drm/src/drm.h
drm/src/bsd/drm_*.[ch]
drm/src/bsd/Makefile
drm/src/bsd/i915/Makefile
drm/src/bsd/r128/Makefile
drm/src/linux/drm_*.=EF=BB=BF[ch]
drm/src/linux/Makefile

Get rid of the -core absurdity, and move the shared code to top-level of
the kernel instead of alongside other kernel code.

But maybe nicer for merging on both of our parts would be:

drm/linux/Makefile
drm/linux/drm*.[ch]
=EF=BB=BF=EF=BB=BFdrm/linux/i915/Makefile
drm/linux/i915/i915_*.[ch]
=EF=BB=BFdrm/linux/=EF=BB=BFi915/Makefile
=EF=BB=BFdrm/linux/r128/r128_*.[ch]
drm/bsd/drm.h -> ../linux/drm.h
drm/bsd/drm*.[ch]
drm/bsd/Makefile
=EF=BB=BFdrm/bsd/i915/Makefile
drm/bsd/i915/i915_drv.c
=EF=BB=BFdrm/bsd/i915/i915_*.[ch] -> ../../linux/i915/i915_*.[ch]
=EF=BB=BF=EF=BB=BFdrm/bsd/r128/Makefile
drm/bsd/r128/r128_drv.c
=EF=BB=BFdrm/bsd/r128/r128_*.[ch] -> ../../linux/r128/r128_*.[ch]

--=20
Eric Anholt                             anholt@FreeBSD.org
eric@anholt.net                         eric.anholt@intel.com


--=-B5nFKiiSI3Gfw410BW6E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (FreeBSD)

iEYEABECAAYFAkg/BuUACgkQHUdvYGzw6veqawCfYlqB77AtXKdFcLSVLLmf7tEF
SwQAoIlM1AWylsrk6KJSqqIp8Zc6lI9U
=poZy
-----END PGP SIGNATURE-----

--=-B5nFKiiSI3Gfw410BW6E--
