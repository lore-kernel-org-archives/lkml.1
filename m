Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYKDBlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYKDBlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 20:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYKDBle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 20:41:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:17302 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYKDBld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 20:41:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,540,1220252400"; 
   d="asc'?scan'208";a="355818940"
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <490F468B.4040602@redhat.com>
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
	 <49087871.3010303@redhat.com>
	 <1225332179.24095.61.camel@yhuang-dev.sh.intel.com>
	 <490B3574.1060501@redhat.com>
	 <1225677161.24095.169.camel@yhuang-dev.sh.intel.com>
	 <490F468B.4040602@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bAVSkyEKaoVPqo/SdBYg"
Date: Tue, 04 Nov 2008 09:41:17 +0800
Message-Id: <1225762877.27266.22.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bAVSkyEKaoVPqo/SdBYg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-04 at 02:44 +0800, Chris Snook wrote:
> Huang Ying wrote:
> > On Sat, 2008-11-01 at 00:42 +0800, Chris Snook wrote:
> >> Huang Ying wrote:
> >>> Hi, Chris,
> >>>
> >>> On Wed, 2008-10-29 at 08:51 -0600, Chris Snook wrote:
> >>>> Huang Ying wrote:
> >>>>> Fix a race condition accessing oops_in_progress.  Which may be chan=
ged on
> >>>>> multiple CPU simultaneously, but it is changed via non-atomic opera=
tion
> >>>>> ++/--.  This patch changes the definition of oops_in_process from i=
nt to
> >>>>> atomic_t, and accessing method to atomic operations.
> >>>> You also need barriers.  I believe rmb() before atomic_read() and wm=
b() after=20
> >>>> atomic_set() should suffice.
> >>> I don't think that is necessary. I haven't found there is particular
> >>> consistent requirement about oops_in_progress.
> >> atomic_read() and atomic_set() don't inherently cause changes to be vi=
sible on=20
> >> other CPUs any faster than ++ and -- operators.  Sometimes it happens =
to work=20
> >> out that way as a result of how the compiler and the CPU order operati=
ons, but=20
> >> there's no semantic guarantee, and it could even take arbitrarily long=
 under=20
> >> some circumstances.  If you want to use atomic ops to close the race, =
you need=20
> >> to use barriers.
> >=20
> > As far as I know, barriers don't cause changes to be visible on other
> > CPUs faster too. It just guarantees corresponding operations after will
> > not get executed until that before have finished. And, I don't think we
> > need make changes to be visible on other CPUs faster.
>=20
> You're correct that barrier() has no impact on other CPUs.  wmb() and rmb=
() do.=20
>   If we don't need to make changes visible any faster, what's the point i=
n using=20
> atomic_set()?  It's not any less racy.  atomic_inc() and atomic_dec() wou=
ld be=20
> less racy, but you're not using those.

In default bust_spinlocks() implementation in lib/bust_spinlocks.c,
atomic_inc() and atomic_dec_and_test() is used. Which is used by x86
too. In some other architecture, atomic_set() is used to replace
"oops_in_progress =3D <xxx>". So this patch fixes architectures which use
default bust_spinlocks(), other architectures can be fixed by
corresponding architecture developers.

Best Regards,
Huang Ying


--=-bAVSkyEKaoVPqo/SdBYg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkPqDgACgkQKhFGF+eHlpgQ/wCfQTzIk6+D/mLYXcsolP8Rx36J
jbMAn16Sojnk456yPGp0P+xf2qpUOL+G
=t+5i
-----END PGP SIGNATURE-----

--=-bAVSkyEKaoVPqo/SdBYg--

