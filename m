Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbYFSBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbYFSBC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 21:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756122AbYFSBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 21:02:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:17326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbYFSBCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 21:02:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,668,1204531200"; 
   d="asc'?scan'208";a="579472596"
Date: Thu, 19 Jun 2008 08:55:10 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGP] intel_agp: Add support for Intel 4 series
	chipsets
Message-ID: <20080619005510.GA22454@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080618052300.GA16715@zhen-devel.sh.intel.com> <4858B892.8080909@movial.fi> <20080618073407.GA18084@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20080618073407.GA18084@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2008.06.18 15:34:07 +0800, Zhenyu Wang wrote:
> Thanks, updated as below with typo and indent fix.
>=20
> [AGP] intel_agp: Add support for Intel 4 series chipsets
>=20

I believe now that this one might be better to be split,
as it does contain a fix on IGD_GM chipset for extra stolen
memory size available, and it's good to be included in 2.6.26.
New Intel 4 series chipset enabling patch could be queued for
next kernel.

---

[AGP] intel_agp: extra stolen mem size available for IGD_GM chipset

This adds missing stolen memory size detect for IGD_GM, be sure to
detect right size as current X intel driver (2.3.2) which has already
worked out.

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index eeea50a..ba9718f 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -565,13 +565,13 @@ static void intel_i830_init_gtt_entries(void)
 				gtt_entries =3D 0;
 			break;
 		case G33_GMCH_GMS_STOLEN_128M:
-			if (IS_G33)
+			if (IS_G33 || IS_I965)
 				gtt_entries =3D MB(128) - KB(size);
 			else
 				gtt_entries =3D 0;
 			break;
 		case G33_GMCH_GMS_STOLEN_256M:
-			if (IS_G33)
+			if (IS_G33 || IS_I965)
 				gtt_entries =3D MB(256) - KB(size);
 			else
 				gtt_entries =3D 0;
--=20
1.5.4

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhZrm4ACgkQsQQaM014GCcBZwCcDCr5Urpvm0E/OVdItbWEHYQ9
55sAnj0pGhgeMZGaq/j59EWFPPHV78+L
=SGO/
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
