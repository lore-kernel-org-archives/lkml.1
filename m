Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbYKCBwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbYKCBwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 20:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYKCBwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 20:52:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:55872 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbYKCBwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 20:52:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,532,1220252400"; 
   d="asc'?scan'208";a="355340064"
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <490B3574.1060501@redhat.com>
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
	 <49087871.3010303@redhat.com>
	 <1225332179.24095.61.camel@yhuang-dev.sh.intel.com>
	 <490B3574.1060501@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VihxFDlt/lMrsKn5tF1l"
Date: Mon, 03 Nov 2008 09:52:41 +0800
Message-Id: <1225677161.24095.169.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VihxFDlt/lMrsKn5tF1l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 00:42 +0800, Chris Snook wrote:
> Huang Ying wrote:
> > Hi, Chris,
> >=20
> > On Wed, 2008-10-29 at 08:51 -0600, Chris Snook wrote:
> >> Huang Ying wrote:
> >>> Fix a race condition accessing oops_in_progress.  Which may be change=
d on
> >>> multiple CPU simultaneously, but it is changed via non-atomic operati=
on
> >>> ++/--.  This patch changes the definition of oops_in_process from int=
 to
> >>> atomic_t, and accessing method to atomic operations.
> >> You also need barriers.  I believe rmb() before atomic_read() and wmb(=
) after=20
> >> atomic_set() should suffice.
> >=20
> > I don't think that is necessary. I haven't found there is particular
> > consistent requirement about oops_in_progress.
>=20
> atomic_read() and atomic_set() don't inherently cause changes to be visib=
le on=20
> other CPUs any faster than ++ and -- operators.  Sometimes it happens to =
work=20
> out that way as a result of how the compiler and the CPU order operations=
, but=20
> there's no semantic guarantee, and it could even take arbitrarily long un=
der=20
> some circumstances.  If you want to use atomic ops to close the race, you=
 need=20
> to use barriers.

As far as I know, barriers don't cause changes to be visible on other
CPUs faster too. It just guarantees corresponding operations after will
not get executed until that before have finished. And, I don't think we
need make changes to be visible on other CPUs faster.

Best Regards,
Huang Ying


--=-VihxFDlt/lMrsKn5tF1l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkOWWEACgkQKhFGF+eHlpgDPgCdEE4uA1AwggMJ8vcPLvJTl0fQ
pG8AnRiYz2frQx5GcSLudRvnhupHjqX2
=jQ0v
-----END PGP SIGNATURE-----

--=-VihxFDlt/lMrsKn5tF1l--

