Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYJNHXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYJNHXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYJNHX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:23:29 -0400
Received: from home.keithp.com ([63.227.221.253]:51687 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYJNHX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:23:28 -0400
Subject: [PATCH] Reduce extraneous PCI posting reads during Intel AGP
	initialization
From: Keith Packard <keithp@keithp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Intel graphics drivers <Intel-gfx@lists.freedesktop.org>,
       Dave Airlie <airlied@linux.ie>
Cc: keithp@keithp.com
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-73mlJ0ZA63yl5dRrPgU/"
Date: Mon, 13 Oct 2008 23:40:11 -0700
Message-Id: <1223966411.5608.20.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-73mlJ0ZA63yl5dRrPgU/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=46rom b4ca8f9596e3d5d2a4c090eaf5e4f373c131a476 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Mon, 13 Oct 2008 23:33:21 -0700
Subject: [PATCH] Reduce extraneous PCI posting reads during Intel AGP initi=
alization

Instead of doing a posting read after each GTT entry update, do a single on=
e
at the end of the writes. This should reduce boot time a tiny amount by
avoiding a lot of extra uncached reads.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/char/agp/intel-agp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 016fdf0..a6a0c34 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -214,8 +214,8 @@ static int intel_i810_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i =3D 0; i < current_size->num_entries; i++) {
 			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+=
(i*4));
-			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI posting. */
 		}
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI posting. =
*/
 	}
 	global_cache_flush();
 	return 0;
@@ -773,8 +773,8 @@ static int intel_i830_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i =3D intel_private.gtt_entries; i < current_size->num_entries; i++=
) {
 			writel(agp_bridge->scratch_page, intel_private.registers+I810_PTE_BASE+=
(i*4));
-			readl(intel_private.registers+I810_PTE_BASE+(i*4));	/* PCI Posting. */
 		}
+		readl(intel_private.registers+I810_PTE_BASE+((i-1)*4));	/* PCI Posting. =
*/
 	}
=20
 	global_cache_flush();
@@ -989,8 +989,8 @@ static int intel_i915_configure(void)
 	if (agp_bridge->driver->needs_scratch_page) {
 		for (i =3D intel_private.gtt_entries; i < current_size->num_entries; i++=
) {
 			writel(agp_bridge->scratch_page, intel_private.gtt+i);
-			readl(intel_private.gtt+i);	/* PCI Posting. */
 		}
+		readl(intel_private.gtt+i-1);	/* PCI Posting. */
 	}
=20
 	global_cache_flush();
--=20
1.5.6.5


--=20
keith.packard@intel.com

--=-73mlJ0ZA63yl5dRrPgU/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBI9D7LQp8BWwlsTdMRAoaBAJ0VtzPHRMdW48Zecj1k3oVrV3tF4QCg6QQ8
ORtejk5rG2zZ5Xvzdr3SbfA=
=rJPw
-----END PGP SIGNATURE-----

--=-73mlJ0ZA63yl5dRrPgU/--

