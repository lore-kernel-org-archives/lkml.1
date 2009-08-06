Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZHFJLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZHFJLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbZHFJLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:11:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45546 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502AbZHFJLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:11:04 -0400
Date: Thu, 6 Aug 2009 19:10:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: linux-next: agp tree build failure
Message-Id: <20090806191054.74c475e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Aug_2009_19_10_54_+1000_2YRhpA1pP0vl_79g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Aug_2009_19_10_54_+1000_2YRhpA1pP0vl_79g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/char/agp/uninorth-agp.c: In function 'uninorth_configure':
drivers/char/agp/uninorth-agp.c:138: error: 'struct agp_bridge_data' has no=
 member named 'scratch_page_real'

Caused by commit c2980d8c2961113f24863f70d8ad016f55224c81 ("agp: Switch
agp_{un,}map_page() to take struct page * argument").

I have reverted that commit for today (and
6a12235c7d2d75c7d94b9afcaaecd422ff845ce0 ("agp: kill phys_to_gart() and
gart_to_phys()") which depends on it).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Aug_2009_19_10_54_+1000_2YRhpA1pP0vl_79g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp6nh4ACgkQjjKRsyhoI8yG+ACgiDuqTHx9Xdoo9ROc1sLLu56X
lIkAn38k4pPv7vFIirwtLJbcstHRAr9r
=Yb4M
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Aug_2009_19_10_54_+1000_2YRhpA1pP0vl_79g--
