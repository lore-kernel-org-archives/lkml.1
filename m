Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYKQGlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYKQGlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYKQGlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:41:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:40182 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYKQGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:41:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,617,1220252400"; 
   d="asc'?scan'208";a="639979017"
Date: Mon, 17 Nov 2008 14:39:00 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGP] intel_agp: add support for G41 chipset
Message-ID: <20081117063900.GB17066@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@redhat.com>,
	Eric Anholt <eric@anholt.net>, LKML <linux-kernel@vger.kernel.org>
References: <20080911075303.GA8239@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20080911075303.GA8239@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2008.09.11 15:53:03 +0800, Zhenyu Wang wrote:
>=20
> [PATCH] [AGP] intel_agp: add support for G41 chipset
>=20
> G41 is another one of Intel 4 series chipset, like G45/G43.
>=20

Dave, here's refreshed G41 pci ids patch for AGP.

=46rom 1ab01c662f2607f5aa77c104edc710286f3feef7 Mon Sep 17 00:00:00 2001
=46rom: Zhenyu Wang <zhenyu.z.wang@intel.com>
Date: Mon, 17 Nov 2008 14:33:45 +0800
Subject: [PATCH] [AGP] intel_agp: add support for G41 chipset

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 9cf6e9b..7d8db5a 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -40,6 +40,8 @@
 #define PCI_DEVICE_ID_INTEL_Q45_IG          0x2E12
 #define PCI_DEVICE_ID_INTEL_G45_HB          0x2E20
 #define PCI_DEVICE_ID_INTEL_G45_IG          0x2E22
+#define PCI_DEVICE_ID_INTEL_G41_HB          0x2E30
+#define PCI_DEVICE_ID_INTEL_G41_IG          0x2E32
=20
 /* cover 915 and 945 variants */
 #define IS_I915 (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_E7221_=
HB || \
@@ -63,7 +65,8 @@
 #define IS_G4X (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_IGD_E_H=
B || \
 		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_Q45_HB || \
 		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_G45_HB || \
-		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_GM45_HB)
+		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_GM45_HB || \
+		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_G41_HB)
=20
 extern int agp_memory_reserved;
=20
@@ -1196,6 +1199,7 @@ static void intel_i965_get_gtt_range(int *gtt_offset,=
 int *gtt_size)
 	case PCI_DEVICE_ID_INTEL_IGD_E_HB:
 	case PCI_DEVICE_ID_INTEL_Q45_HB:
 	case PCI_DEVICE_ID_INTEL_G45_HB:
+	case PCI_DEVICE_ID_INTEL_G41_HB:
 		*gtt_offset =3D *gtt_size =3D MB(2);
 		break;
 	default:
@@ -2163,6 +2167,8 @@ static const struct intel_driver_description {
 	    "Q45/Q43", NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_G45_HB, PCI_DEVICE_ID_INTEL_G45_IG, 0,
 	    "G45/G43", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_G41_HB, PCI_DEVICE_ID_INTEL_G41_IG, 0,
+	    "G41", NULL, &intel_i965_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
=20
@@ -2360,6 +2366,7 @@ static struct pci_device_id agp_intel_pci_table[] =3D=
 {
 	ID(PCI_DEVICE_ID_INTEL_IGD_E_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
 	ID(PCI_DEVICE_ID_INTEL_G45_HB),
+	ID(PCI_DEVICE_ID_INTEL_G41_HB),
 	{ }
 };
=20
--=20
1.5.6.5


--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkhEYQACgkQsQQaM014GCckIACgkRG6OTNbaGiP33sQmW0gQxrG
a3MAn2ev0R7d4xguCZTRPgLhrscDPyg0
=x0SJ
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
