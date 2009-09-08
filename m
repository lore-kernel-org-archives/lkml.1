Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZIHG6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZIHG6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 02:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZIHG6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 02:58:09 -0400
Received: from mga07.intel.com ([143.182.124.22]:14932 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753602AbZIHG6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 02:58:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="asc'?scan'208";a="185104725"
Date: Tue, 8 Sep 2009 14:58:08 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected] Output to external monitor is broken (Re: Linux
 2.6.31-rc9)
Message-ID: <20090908065808.GA30390@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: "Carlos R. Mafra" <crmafra2@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ma Ling <ling.ma@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.01.0909051645430.3329@localhost.localdomain>
 <20090906142206.GA4449@Pilar.aei.mpg.de>
 <alpine.LFD.2.01.0909071125430.25628@localhost.localdomain>
 <20090907191219.GA5015@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20090907191219.GA5015@Pilar.aei.mpg.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.09.07 21:12:19 +0200, Carlos R. Mafra wrote:
>=20
> I am no longer at the institute with the monitor to test, but I've already
> uploaded similar debug info to the bugzilla upon ykzhao's request this
> morning (but I think you were not Cc:-ed on that request, though).
>=20
> http://bugzilla.kernel.org/show_bug.cgi?id=3D14139
>=20
> PS: The external monitor is unreadable, but the laptop's screen is still =
good.

Carlos, I've just taken a look at that one, there're some drawbacks in
it, but can't understand why it caused break for you. It'll be great if
you can test with this one.=20

=46rom f3932299964b2616d42d7fcf734bd880009ab206 Mon Sep 17 00:00:00 2001
=46rom: Zhenyu Wang <zhenyuw@linux.intel.com>
Date: Tue, 8 Sep 2009 14:52:25 +0800
Subject: [PATCH] drm/i915: fix mask bits setting

eDP is exclusive connector too, and add missing crtc_mask
setting for TV.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_dp.c  |    2 +-
 drivers/gpu/drm/i915/intel_drv.h |    1 +
 drivers/gpu/drm/i915/intel_tv.c  |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_d=
p.c
index f2afc4a..2b914d7 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1263,7 +1263,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
=20
 	if (IS_eDP(intel_output)) {
 		intel_output->crtc_mask =3D (1 << 1);
-		intel_output->clone_mask =3D (1 << INTEL_OUTPUT_EDP);
+		intel_output->clone_mask =3D (1 << INTEL_EDP_CLONE_BIT);
 	} else
 		intel_output->crtc_mask =3D (1 << 0) | (1 << 1);
 	connector->interlace_allowed =3D true;
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_=
drv.h
index 25aa6fa..26a6227 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -74,6 +74,7 @@
 #define INTEL_LVDS_CLONE_BIT 14
 #define INTEL_DVO_TMDS_CLONE_BIT 15
 #define INTEL_DVO_LVDS_CLONE_BIT 16
+#define INTEL_EDP_CLONE_BIT 17
=20
 #define INTEL_DVO_CHIP_NONE 0
 #define INTEL_DVO_CHIP_LVDS 1
diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index 2fbe13a..5b1c9e9 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1730,6 +1730,7 @@ intel_tv_init(struct drm_device *dev)
 	drm_mode_connector_attach_encoder(&intel_output->base, &intel_output->enc=
);
 	tv_priv =3D (struct intel_tv_priv *)(intel_output + 1);
 	intel_output->type =3D INTEL_OUTPUT_TVOUT;
+	intel_output->crtc_mask =3D (1 << 0) | (1 << 1);
 	intel_output->clone_mask =3D (1 << INTEL_TV_CLONE_BIT);
 	intel_output->enc.possible_crtcs =3D ((1 << 0) | (1 << 1));
 	intel_output->enc.possible_clones =3D (1 << INTEL_OUTPUT_TVOUT);
--=20
1.6.3.3

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqmAH8ACgkQsQQaM014GCcL2QCdHaR08dJEiJRc69o0V+iD0bM9
qwwAoIJpsW+MOr+Erl8sFUUxiz//bXg7
=9/3G
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
