Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYKKBF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYKKBF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 20:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752836AbYKKBFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 20:05:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:17754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbYKKBFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 20:05:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,580,1220252400"; 
   d="asc'?scan'208";a="358493512"
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Chris Snook <csnook@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081110163135.616E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <490F468B.4040602@redhat.com>
	 <1225762877.27266.22.camel@yhuang-dev.sh.intel.com>
	 <20081110163135.616E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-llG1ePzcy0fT3AIjX+lm"
Date: Tue, 11 Nov 2008 09:05:18 +0800
Message-Id: <1226365518.6081.90.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-llG1ePzcy0fT3AIjX+lm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-10 at 15:35 +0800, KOSAKI Motohiro wrote:
> > > > As far as I know, barriers don't cause changes to be visible on oth=
er
> > > > CPUs faster too. It just guarantees corresponding operations after =
will
> > > > not get executed until that before have finished. And, I don't thin=
k we
> > > > need make changes to be visible on other CPUs faster.
> > >=20
> > > You're correct that barrier() has no impact on other CPUs.  wmb() and=
 rmb() do.=20
> > >   If we don't need to make changes visible any faster, what's the poi=
nt in using=20
> > > atomic_set()?  It's not any less racy.  atomic_inc() and atomic_dec()=
 would be=20
> > > less racy, but you're not using those.
> >=20
> > In default bust_spinlocks() implementation in lib/bust_spinlocks.c,
> > atomic_inc() and atomic_dec_and_test() is used. Which is used by x86
> > too. In some other architecture, atomic_set() is used to replace
> > "oops_in_progress =3D <xxx>". So this patch fixes architectures which u=
se
> > default bust_spinlocks(), other architectures can be fixed by
> > corresponding architecture developers.
>=20
> I think Chris is right.
> So, I reccomend to read Documentation/memory-barriers.txt
>=20
> Almost architecture gurantee atomic_inc cause barrier implicitly.
> but not _all_ architecture.

Yes. atomic_inc() doesn't imply barrier on all architecture. But we
should not add barriers before all atomic_inc(), just ones needed. Can
you figure out which ones in the patch should has barrier added?

Best Regards,
Huang Ying


--=-llG1ePzcy0fT3AIjX+lm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkY2koACgkQKhFGF+eHlpiRRwCeJey77weSlc6LFtsalgKwe1U2
W3IAn3nsOiF3fZIRZB/Va6Vbs1jOfly7
=5z2W
-----END PGP SIGNATURE-----

--=-llG1ePzcy0fT3AIjX+lm--

