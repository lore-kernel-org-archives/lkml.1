Return-Path: <linux-kernel-owner+w=401wt.eu-S1757883AbYFSBE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883AbYFSBE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 21:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbYFSBEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 21:04:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:1640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122AbYFSBET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 21:04:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,668,1204531200"; 
   d="asc'?scan'208";a="399183813"
Date: Thu, 19 Jun 2008 08:56:48 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGP] intel_agp: Add support for Intel 4 series
	chipsets
Message-ID: <20080619005648.GB22454@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080618052300.GA16715@zhen-devel.sh.intel.com> <4858B892.8080909@movial.fi> <20080618073407.GA18084@zhen-devel.sh.intel.com> <20080619005510.GA22454@zhen-devel.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20080619005510.GA22454@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2008.06.19 08:55:10 +0800, Zhenyu Wang wrote:
> I believe now that this one might be better to be split,
> as it does contain a fix on IGD_GM chipset for extra stolen
> memory size available, and it's good to be included in 2.6.26.
> New Intel 4 series chipset enabling patch could be queued for
> next kernel.
>=20

[AGP] intel_agp: Add support for Intel 4 series chipsets

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   84 ++++++++++++++++++++++++++++++++++++--=
----
 1 files changed, 72 insertions(+), 12 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index ba9718f..189b325 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -34,6 +34,12 @@
 #define PCI_DEVICE_ID_INTEL_Q33_IG          0x29D2
 #define PCI_DEVICE_ID_INTEL_IGD_HB          0x2A40
 #define PCI_DEVICE_ID_INTEL_IGD_IG          0x2A42
+#define PCI_DEVICE_ID_INTEL_IGD_E_HB        0x2E00
+#define PCI_DEVICE_ID_INTEL_IGD_E_IG        0x2E02
+#define PCI_DEVICE_ID_INTEL_Q45_HB          0x2E10
+#define PCI_DEVICE_ID_INTEL_Q45_IG          0x2E12
+#define PCI_DEVICE_ID_INTEL_G45_HB          0x2E20
+#define PCI_DEVICE_ID_INTEL_G45_IG          0x2E22
=20
 /* cover 915 and 945 variants */
 #define IS_I915 (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_E7221_=
HB || \
@@ -55,6 +61,10 @@
 		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_Q35_HB || \
 		agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_Q33_HB)
=20
+#define IS_G4X	(agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_IGD_E_H=
B || \
+		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_Q45_HB || \
+		 agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_G45_HB)
+
 extern int agp_memory_reserved;
=20
=20
@@ -80,8 +90,12 @@ extern int agp_memory_reserved;
 #define I915_PTEADDR	0x1C
 #define I915_GMCH_GMS_STOLEN_48M	(0x6 << 4)
 #define I915_GMCH_GMS_STOLEN_64M	(0x7 << 4)
-#define G33_GMCH_GMS_STOLEN_128M       (0x8 << 4)
-#define G33_GMCH_GMS_STOLEN_256M       (0x9 << 4)
+#define G33_GMCH_GMS_STOLEN_128M	(0x8 << 4)
+#define G33_GMCH_GMS_STOLEN_256M	(0x9 << 4)
+#define INTEL_GMCH_GMS_STOLEN_96M	(0xa << 4)
+#define INTEL_GMCH_GMS_STOLEN_160M	(0xb << 4)
+#define INTEL_GMCH_GMS_STOLEN_224M	(0xc << 4)
+#define INTEL_GMCH_GMS_STOLEN_352M	(0xd << 4)
 #define I915_IFPADDR    0x60
=20
 /* Intel 965G registers */
@@ -504,6 +518,10 @@ static void intel_i830_init_gtt_entries(void)
 			size =3D 512;
 		}
 		size +=3D 4;
+	} else if (IS_G4X) {
+		/* On 4 Series hardware, GTT stolen is separate from graphics
+		 * stolen, ignore it in stolen gtt entries counting */
+		size =3D 0;
 	} else {
 		/* On previous hardware, the GTT size was just what was
 		 * required to map the aperture.
@@ -551,31 +569,53 @@ static void intel_i830_init_gtt_entries(void)
 			gtt_entries =3D MB(32) - KB(size);
 			break;
 		case I915_GMCH_GMS_STOLEN_48M:
-			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33)
+			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries =3D MB(48) - KB(size);
 			else
 				gtt_entries =3D 0;
 			break;
 		case I915_GMCH_GMS_STOLEN_64M:
-			/* Check it's really I915G */
-			if (IS_I915 || IS_I965 || IS_G33)
+			if (IS_I915 || IS_I965 || IS_G33 || IS_G4X)
 				gtt_entries =3D MB(64) - KB(size);
 			else
 				gtt_entries =3D 0;
 			break;
 		case G33_GMCH_GMS_STOLEN_128M:
-			if (IS_G33 || IS_I965)
+			if (IS_G33 || IS_I965 || IS_G4X)
 				gtt_entries =3D MB(128) - KB(size);
 			else
 				gtt_entries =3D 0;
 			break;
 		case G33_GMCH_GMS_STOLEN_256M:
-			if (IS_G33 || IS_I965)
+			if (IS_G33 || IS_I965 || IS_G4X)
 				gtt_entries =3D MB(256) - KB(size);
 			else
 				gtt_entries =3D 0;
 			break;
+		case INTEL_GMCH_GMS_STOLEN_96M:
+			if (IS_I965 || IS_G4X)
+				gtt_entries =3D MB(96) - KB(size);
+			else
+				gtt_entries =3D 0;
+			break;
+		case INTEL_GMCH_GMS_STOLEN_160M:
+			if (IS_I965 || IS_G4X)
+				gtt_entries =3D MB(160) - KB(size);
+			else
+				gtt_entries =3D 0;
+			break;
+		case INTEL_GMCH_GMS_STOLEN_224M:
+			if (IS_I965 || IS_G4X)
+				gtt_entries =3D MB(224) - KB(size);
+			else
+				gtt_entries =3D 0;
+			break;
+		case INTEL_GMCH_GMS_STOLEN_352M:
+			if (IS_I965 || IS_G4X)
+				gtt_entries =3D MB(352) - KB(size);
+			else
+				gtt_entries =3D 0;
+			break;
 		default:
 			gtt_entries =3D 0;
 			break;
@@ -1134,6 +1174,20 @@ static unsigned long intel_i965_mask_memory(struct a=
gp_bridge_data *bridge,
 	return addr | bridge->driver->masks[type].mask;
 }
=20
+static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
+{
+	switch (agp_bridge->dev->device) {
+	case PCI_DEVICE_ID_INTEL_IGD_HB:
+	case PCI_DEVICE_ID_INTEL_IGD_E_HB:
+	case PCI_DEVICE_ID_INTEL_Q45_HB:
+	case PCI_DEVICE_ID_INTEL_G45_HB:
+	    *gtt_offset =3D *gtt_size =3D MB(2);
+	    break;
+	default:
+	    *gtt_offset =3D *gtt_size =3D KB(512);
+	}
+}
+
 /* The intel i965 automatically initializes the agp aperture during POST.
  * Use the memory already set aside for in the GTT.
  */
@@ -1154,10 +1208,7 @@ static int intel_i965_create_gatt_table(struct agp_b=
ridge_data *bridge)
=20
        temp &=3D 0xfff00000;
=20
-       if (agp_bridge->dev->device =3D=3D PCI_DEVICE_ID_INTEL_IGD_HB)
-	       gtt_offset =3D gtt_size =3D MB(2);
-       else
-	       gtt_offset =3D gtt_size =3D KB(512);
+       intel_i965_get_gtt_range(&gtt_offset, &gtt_size);
=20
        intel_private.gtt =3D ioremap((temp + gtt_offset) , gtt_size);
=20
@@ -2063,6 +2114,12 @@ static const struct intel_driver_description {
 		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_IGD_HB, PCI_DEVICE_ID_INTEL_IGD_IG, 0,
 	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_IGD_E_HB, PCI_DEVICE_ID_INTEL_IGD_E_IG, 0,
+	    "Intel Integrated Graphics Device", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_Q45_HB, PCI_DEVICE_ID_INTEL_Q45_IG, 0,
+	    "Q45/Q43", NULL, &intel_i965_driver },
+	{ PCI_DEVICE_ID_INTEL_G45_HB, PCI_DEVICE_ID_INTEL_G45_IG, 0,
+	    "G45/G43", NULL, &intel_i965_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
=20
@@ -2254,6 +2311,9 @@ static struct pci_device_id agp_intel_pci_table[] =3D=
 {
 	ID(PCI_DEVICE_ID_INTEL_Q35_HB),
 	ID(PCI_DEVICE_ID_INTEL_Q33_HB),
 	ID(PCI_DEVICE_ID_INTEL_IGD_HB),
+	ID(PCI_DEVICE_ID_INTEL_IGD_E_HB),
+	ID(PCI_DEVICE_ID_INTEL_Q45_HB),
+	ID(PCI_DEVICE_ID_INTEL_G45_HB),
 	{ }
 };
=20
--=20
1.5.4



--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhZrtAACgkQsQQaM014GCcEBQCfVIJ8E9y6Zm4pLmbqCd/Q0Xdw
DvQAoIddgoW17nEpuKyd5uItXJjNX4J3
=jaDG
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
