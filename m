Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZBKAv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZBKAv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbZBKAdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:33:15 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:38774 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758266AbZBKAdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:33:14 -0500
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
From: Eric Anholt <eric@anholt.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, samr <sam@ravnborg.org>
In-Reply-To: <20090205193619.GB31839@elte.hu>
References: <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain>
	 <20090204181109.GR21085@gamma.logic.tuwien.ac.at>
	 <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain>
	 <20090204185606.GA12991@elte.hu> <1233809147.13118.8.camel@gaiman>
	 <498B1F2A.70209@oracle.com> <20090205191234.GG20470@elte.hu>
	 <498B3A8F.3040801@oracle.com> <20090205192059.GB27422@elte.hu>
	 <498B3CB8.3020202@oracle.com>  <20090205193619.GB31839@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GPNiMkgA4jeCL+7++Hpz"
Date: Tue, 10 Feb 2009 16:33:04 -0800
Message-Id: <1234312384.32506.26.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GPNiMkgA4jeCL+7++Hpz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 20:36 +0100, Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
>=20
> > > kconfig was not broken at all in this case. It detected a circular=20
> > > dependency and did its work well.
> >=20
> > Maybe.  I haven't seen an explanation for the problems that Eric report=
ed=20
> > 2+ weeks ago.
>=20
> The thing he reported 2 weeks ago is a straightforward recursive dependen=
cy=20
> bug in the config entries:
>=20
>   drivers/gpu/drm/Kconfig:8:error: found recursive dependency:
>    DRM -> <choice> -> DRM_I915 -> FB -> FB_I810 -> AGP -> DRM
>=20
> this is the precise circular dependency problem that the I810_FB and=20
> INTEL_FB changes in my patch solve.

I think the problem is that when looking at
	select FB
or
	depends on FB
I see "this thing depends on FB.  If I said select, then instead of
asking the user to enable it before seeing the option, just enable the
option for them".  Even after seeing your patch, I still don't see why
the select means that AGP depends on DRM.

But big thanks for fixing it!

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-GPNiMkgA4jeCL+7++Hpz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmSHMAACgkQHUdvYGzw6vcFBQCgm6V81/TnhjORzYhxFKxAv2JA
BgIAn0oKT09bmVLkHTZJ/CGvWEN+c/Cf
=V2xh
-----END PGP SIGNATURE-----

--=-GPNiMkgA4jeCL+7++Hpz--
