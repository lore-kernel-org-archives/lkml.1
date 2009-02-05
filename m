Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbZBEEqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbZBEEqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbZBEEpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 23:45:50 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:54305 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZBEEpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 23:45:49 -0500
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
From: Eric Anholt <eric@anholt.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
In-Reply-To: <20090204185606.GA12991@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera>
	 <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
	 <20090204181109.GR21085@gamma.logic.tuwien.ac.at>
	 <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain>
	 <20090204185606.GA12991@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2amFikqmhmOfz6IJgjRK"
Date: Wed, 04 Feb 2009 20:45:47 -0800
Message-Id: <1233809147.13118.8.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2amFikqmhmOfz6IJgjRK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-04 at 19:56 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>=20
> > On Wed, 4 Feb 2009, Norbert Preining wrote:
> > >=20
> > > The problem is that if you have a configuration under 2.6.28 without=20
> > > CONFIG_FB and just call make oldconfig, or even make config and don't=
=20
> > > know that you loose the DRM. And I was using make oldconfig (there is=
 a=20
> > > graphical config?? ;-))
> >=20
> > Sure. It's inconvenient, no question about that. I asked the i915 peopl=
e=20
> > to look into not requiring CONFIG_FB, and I hope they will, but my poin=
t=20
> > is that I don't think we can consider "small one-time inconvenience" to=
 be=20
> > a "regression".
>=20
> if you mean that as a general principle, there's four very real downsides=
 in=20
> my opinion.
>=20
> Firstly, we could have done better (and still can do better), via various=
=20
> easy and non-intrusive measures:
>=20
>    - We could add a runtime warning:
>=20
>       for example a WARN_ONCE("please enable CONFIG_DRM_I915 and CONFIG_F=
B")=20
>       that there's no DRM because CONFIG_FB is not selected and oldconfig=
=20
>       loses the I915 setting silently - placed in a key DRM ioctl, would=20
>       have gone a long way addressing the issue. Testers do notice kernel=
=20
>       warnings that pop up when their X gets slow. (This approach might a=
lso=20
>       have the added bonus of warning folks who enable the wrong driver f=
or=20
>       the hardware.)
>=20
>    - Or we could add a more thoughtful Kconfig migration:
>=20
>       Rename DRM_I915 to DRM_I915_FB [which it really is now], and keep
>       DRM_I915 as a non-interactive migration helper: if set, it=20
>       auto-selects both FB and DRM_I915_FB.
>=20
>       While CONFIG_FB is an interactive Kconfig option so a select can be=
=20
>       dangerous to a correct dependency tree, it seems safe to do in this=
=20
>       specific case because it seems to be a rather leaf entry with no=20
>       dependencies.

I tried select FB.  It's the right thing to do.  It doesn't work.  I
posted to the mailing list two weeks ago about the insane dependency
chain that kbuild comes up with and fails on when we do this, and got
silence.

Believe me, I hate this inconvenience to users even more than each of
you do, because I get to deal with the reports.  But I haven't had the
time to sit down and figure out what drugs kbuild is on, or even how to
work around it (despite IRC help from a few other kernel guys).

The alternative I can see is to ifdef the code for something that will
be on by default and which stable userland will require in 6 months.
That seems wrong.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-2amFikqmhmOfz6IJgjRK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmKbvkACgkQHUdvYGzw6vdghwCeMWKDqGkPoFWLjy0BsZXXU5r2
pz4Anjww3uKIYKjNRFgV5qISSTuDh+PC
=yIaF
-----END PGP SIGNATURE-----

--=-2amFikqmhmOfz6IJgjRK--

