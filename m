Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYDJQWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYDJQWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYDJQWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:22:17 -0400
Received: from isis45.plusserver.de ([217.172.174.164]:58269 "EHLO
	isis45.plusserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbYDJQWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:22:16 -0400
X-Greylist: delayed 2810 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2008 12:22:16 EDT
Date: Thu, 10 Apr 2008 17:34:00 +0200
From: Maik Broemme <mbroemme@plusserver.de>
To: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Added support for the Intel Integrated Graphics Controller
	965G/965GM to intelfb
Message-ID: <20080410153400.GA3553@bart.intergenia.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
X-Message-Flag: Outlook : A program to spread viri, but it can do mail too.
X-Operating-System: Linux bart 2.6.25-rc8
Organization: PlusServer AG
X-PGP-Key-FingerPrint: 109D 0AC6 86CF 06BD 4890  17B0 8FB9 9971 4EEB 31F1
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Spam-Score: -104.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

i have added support for the 965G and 965GM graphic chipsets to the intelfb
driver. I have a notebook with an Intel Mobile GM965/GL960 Integrated
Graphics Controller and with the attached patch the framebuffer comes
up. I have tested it a bit with DirectFB to make sure it is working stable.

I also have an Intel Mobile GM945 and i compared the results, the
programming interface of the 9xx series from Intel is mostly the same,
so i think the attached patch should add all functionality the 945GM
have. Please keep me in CC because i am not subscribed.

Signed-off-by: Maik Broemme <mbroemme@plusserver.de>

--Maik

--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="linux-2.6.25-rc8-intelfb-i965.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nur linux-2.6.25-rc8/Documentation/fb/intelfb.txt linux-2.6.25-rc8-in=
telfb-i965/Documentation/fb/intelfb.txt
--- linux-2.6.25-rc8/Documentation/fb/intelfb.txt	2008-04-01 21:44:26.00000=
0000 +0200
+++ linux-2.6.25-rc8-intelfb-i965/Documentation/fb/intelfb.txt	2008-04-10 1=
7:11:23.000000000 +0200
@@ -14,6 +14,8 @@
 	Intel 915GM
 	Intel 945G
 	Intel 945GM
+	Intel 965G
+	Intel 965GM
=20
 B.  List of available options
=20
diff -Nur linux-2.6.25-rc8/drivers/video/Kconfig linux-2.6.25-rc8-intelfb-i=
965/drivers/video/Kconfig
--- linux-2.6.25-rc8/drivers/video/Kconfig	2008-04-01 21:44:26.000000000 +0=
200
+++ linux-2.6.25-rc8-intelfb-i965/drivers/video/Kconfig	2008-04-10 17:12:19=
=2E000000000 +0200
@@ -1087,7 +1087,7 @@
 	  This driver supports the LE80578 (Carillo Ranch) board
=20
 config FB_INTEL
-	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G support (EXPERIMENTA=
L)"
+	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM sup=
port (EXPERIMENTAL)"
 	depends on FB && EXPERIMENTAL && PCI && X86
 	select AGP
 	select AGP_INTEL
@@ -1097,7 +1097,7 @@
 	select FB_CFB_IMAGEBLIT
 	help
 	  This driver supports the on-board graphics built in to the Intel
-          830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets.
+          830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chip=
sets.
           Say Y if you have and plan to use such a board.
=20
 	  If you say Y here and want DDC/I2C support you must first say Y to
diff -Nur linux-2.6.25-rc8/drivers/video/intelfb/intelfb.h linux-2.6.25-rc8=
-intelfb-i965/drivers/video/intelfb/intelfb.h
--- linux-2.6.25-rc8/drivers/video/intelfb/intelfb.h	2008-04-01 21:44:26.00=
0000000 +0200
+++ linux-2.6.25-rc8-intelfb-i965/drivers/video/intelfb/intelfb.h	2008-04-1=
0 17:10:53.000000000 +0200
@@ -12,9 +12,9 @@
 #endif
=20
 /*** Version/name ***/
-#define INTELFB_VERSION			"0.9.4"
+#define INTELFB_VERSION			"0.9.5"
 #define INTELFB_MODULE_NAME		"intelfb"
-#define SUPPORTED_CHIPSETS		"830M/845G/852GM/855GM/865G/915G/915GM/945G/94=
5GM"
+#define SUPPORTED_CHIPSETS		"830M/845G/852GM/855GM/865G/915G/915GM/945G/94=
5GM/965G/965GM"
=20
=20
 /*** Debug/feature defines ***/
@@ -58,6 +58,8 @@
 #define PCI_DEVICE_ID_INTEL_915GM	0x2592
 #define PCI_DEVICE_ID_INTEL_945G	0x2772
 #define PCI_DEVICE_ID_INTEL_945GM	0x27A2
+#define PCI_DEVICE_ID_INTEL_965G	0x29A2
+#define PCI_DEVICE_ID_INTEL_965GM	0x2A02
=20
 /* Size of MMIO region */
 #define INTEL_REG_SIZE			0x80000
@@ -158,6 +160,8 @@
 	INTEL_915GM,
 	INTEL_945G,
 	INTEL_945GM,
+	INTEL_965G,
+	INTEL_965GM,
 };
=20
 struct intelfb_hwstate {
@@ -358,7 +362,9 @@
 #define IS_I9XX(dinfo) (((dinfo)->chipset =3D=3D INTEL_915G) ||	\
 			((dinfo)->chipset =3D=3D INTEL_915GM) ||	\
 			((dinfo)->chipset =3D=3D INTEL_945G) ||	\
-			((dinfo)->chipset=3D=3DINTEL_945GM))
+			((dinfo)->chipset =3D=3D INTEL_945GM) ||	\
+			((dinfo)->chipset =3D=3D INTEL_965G) ||	\
+			((dinfo)->chipset =3D=3D INTEL_965GM))
=20
 #ifndef FBIO_WAITFORVSYNC
 #define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
diff -Nur linux-2.6.25-rc8/drivers/video/intelfb/intelfb_i2c.c linux-2.6.25=
-rc8-intelfb-i965/drivers/video/intelfb/intelfb_i2c.c
--- linux-2.6.25-rc8/drivers/video/intelfb/intelfb_i2c.c	2008-04-01 21:44:2=
6.000000000 +0200
+++ linux-2.6.25-rc8-intelfb-i965/drivers/video/intelfb/intelfb_i2c.c	2008-=
04-10 17:10:53.000000000 +0200
@@ -169,6 +169,8 @@
 		/* has some LVDS + tv-out */
 	case INTEL_945G:
 	case INTEL_945GM:
+	case INTEL_965G:
+	case INTEL_965GM:
 		/* SDVO ports have a single control bus - 2 devices */
 		dinfo->output[i].type =3D INTELFB_OUTPUT_SDVO;
 		intelfb_setup_i2c_bus(dinfo, &dinfo->output[i].i2c_bus,
diff -Nur linux-2.6.25-rc8/drivers/video/intelfb/intelfbdrv.c linux-2.6.25-=
rc8-intelfb-i965/drivers/video/intelfb/intelfbdrv.c
--- linux-2.6.25-rc8/drivers/video/intelfb/intelfbdrv.c	2008-04-01 21:44:26=
=2E000000000 +0200
+++ linux-2.6.25-rc8-intelfb-i965/drivers/video/intelfb/intelfbdrv.c	2008-0=
4-10 17:10:53.000000000 +0200
@@ -2,7 +2,7 @@
  * intelfb
  *
  * Linux framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/9=
15GM/
- * 945G/945GM integrated graphics chips.
+ * 945G/945GM/965G/965GM integrated graphics chips.
  *
  * Copyright =C2=A9 2002, 2003 David Dawes <dawes@xfree86.org>
  *                   2004 Sylvain Meyer
@@ -99,6 +99,9 @@
  *              Add vram option to reserve more memory than stolen by BIOS
  *              Fix intelfbhw_pan_display typo
  *              Add __initdata annotations
+ *
+ *    04/2008 - Version 0.9.5
+ *              Add support for 965G/965GM. (Maik Broemme <mbroemme@plusse=
rver.de>)
  */
=20
 #include <linux/module.h>
@@ -180,6 +183,8 @@
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_915GM, PCI_ANY_ID, PCI_ANY_ID,=
 PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_915GM },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945G, PCI_ANY_ID, PCI_ANY_ID, =
PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945G },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_945GM, PCI_ANY_ID, PCI_ANY_ID,=
 PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_945GM },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_965G, PCI_ANY_ID, PCI_ANY_ID, =
PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_965G },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_965GM, PCI_ANY_ID, PCI_ANY_ID,=
 PCI_CLASS_DISPLAY_VGA << 8, INTELFB_CLASS_MASK, INTEL_965GM },
 	{ 0, }
 };
=20
@@ -549,7 +554,10 @@
 	if ((ent->device =3D=3D PCI_DEVICE_ID_INTEL_915G) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_915GM) ||
 	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945G)  ||
-	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945GM)) {
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_945GM) ||
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_965G) ||
+	    (ent->device =3D=3D PCI_DEVICE_ID_INTEL_965GM)) {
+
 		aperture_bar =3D 2;
 		mmio_bar =3D 0;
 	}
diff -Nur linux-2.6.25-rc8/drivers/video/intelfb/intelfbhw.c linux-2.6.25-r=
c8-intelfb-i965/drivers/video/intelfb/intelfbhw.c
--- linux-2.6.25-rc8/drivers/video/intelfb/intelfbhw.c	2008-04-01 21:44:26.=
000000000 +0200
+++ linux-2.6.25-rc8-intelfb-i965/drivers/video/intelfb/intelfbhw.c	2008-04=
-10 17:10:53.000000000 +0200
@@ -143,6 +143,18 @@
 		dinfo->mobile =3D 1;
 		dinfo->pll_index =3D PLLS_I9xx;
 		return 0;
+	case PCI_DEVICE_ID_INTEL_965G:
+		dinfo->name =3D "Intel(R) 965G";
+		dinfo->chipset =3D INTEL_965G;
+		dinfo->mobile =3D 0;
+		dinfo->pll_index =3D PLLS_I9xx;
+		return 0;
+	case PCI_DEVICE_ID_INTEL_965GM:
+		dinfo->name =3D "Intel(R) 965GM";
+		dinfo->chipset =3D INTEL_965GM;
+		dinfo->mobile =3D 1;
+		dinfo->pll_index =3D PLLS_I9xx;
+		return 0;
 	default:
 		return 1;
 	}
@@ -174,7 +186,9 @@
 	case PCI_DEVICE_ID_INTEL_915GM:
 	case PCI_DEVICE_ID_INTEL_945G:
 	case PCI_DEVICE_ID_INTEL_945GM:
-		/* 915 and 945 chipsets support a 256MB aperture.
+	case PCI_DEVICE_ID_INTEL_965G:
+	case PCI_DEVICE_ID_INTEL_965GM:
+		/* 915, 945 and 965 chipsets support a 256MB aperture.
 		   Aperture size is determined by inspected the
 		   base address of the aperture. */
 		if (pci_resource_start(pdev, 2) & 0x08000000)

--PEIAKu/WMn1b1Hv9--
