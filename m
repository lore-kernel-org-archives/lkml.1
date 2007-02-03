Return-Path: <linux-kernel-owner+w=401wt.eu-S1946477AbXBCPNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946477AbXBCPNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946473AbXBCPNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:13:51 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:53669 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946323AbXBCPNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:13:44 -0500
Message-id: <2799427829293325280@wsc.cz>
In-reply-to: <2106930977152662464@wsc.cz>
Subject: [PATCH 2/2] Char: use more PCI_DEVICE macro
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Cyclades team <async@cyclades.com>
Cc: <jgarzik@redhat.com>
Cc: <wim@iguana.be>
Date: Sat,  3 Feb 2007 16:13:51 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use more PCI_DEVICE macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 047d70c2758f6c0bb91350bfd4aca1a8a588d35f
tree c978c1e8d3748bb7749fdac7c41215f64c2a70c9
parent 6518489059ea5f8eca8d1ae6de51a6452b46eb52
author Jiri Slaby <jirislaby@gmail.com> Sat, 03 Feb 2007 15:55:52 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 03 Feb 2007 15:55:52 +0100

 drivers/char/applicom.c              |   12 +++--
 drivers/char/hw_random/amd-rng.c     |    4 +-
 drivers/char/hw_random/geode-rng.c   |    3 -
 drivers/char/hw_random/intel-rng.c   |   76 +++++++++++++++++-----------------
 drivers/char/watchdog/alim7101_wdt.c |    6 +--
 5 files changed, 49 insertions(+), 52 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index b44bb02..251c603 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -66,12 +66,12 @@ static char *applicom_pci_devnames[] = {
 };
 
 static struct pci_device_id applicom_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_APPLICOM,
+			PCI_DEVICE_ID_APPLICOM_PCIGENERIC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_APPLICOM,
+			PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_APPLICOM,
+			PCI_DEVICE_ID_APPLICOM_PCI2000PFB) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index b2d8cee..083f30c 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -43,8 +43,8 @@
  * want to register another driver on the same PCI id.
  */
 static const struct pci_device_id pci_tbl[] __devinitdata = {
-	{ 0x1022, 0x7443, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
-	{ 0x1022, 0x746b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
+	{ PCI_DEVICE(0x1022, 0x7443) },
+	{ PCI_DEVICE(0x1022, 0x746b) },
 	{ 0, },	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index ce02982..66b3951 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -45,8 +45,7 @@
  * want to register another driver on the same PCI id.
  */
 static const struct pci_device_id pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES) },
 	{ 0, },	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 83046bf..5513c63 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -96,49 +96,49 @@
  */
 static const struct pci_device_id pci_tbl[] __devinitdata = {
 /* AA
-	{ 0x8086, 0x2418, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2410, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* AA */
+	{ PCI_DEVICE(0x8086, 0x2418) }, */
+	{ PCI_DEVICE(0x8086, 0x2410) }, /* AA */
 /* AB
-	{ 0x8086, 0x2428, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2420, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* AB */
+	{ PCI_DEVICE(0x8086, 0x2428) }, */
+	{ PCI_DEVICE(0x8086, 0x2420) }, /* AB */
 /* ??
-	{ 0x8086, 0x2430, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
+	{ PCI_DEVICE(0x8086, 0x2430) }, */
 /* BAM, CAM, DBM, FBM, GxM
-	{ 0x8086, 0x2448, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x244c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* BAM */
-	{ 0x8086, 0x248c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* CAM */
-	{ 0x8086, 0x24cc, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* DBM */
-	{ 0x8086, 0x2641, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* FBM */
-	{ 0x8086, 0x27b9, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* GxM */
-	{ 0x8086, 0x27bd, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* GxM DH */
+	{ PCI_DEVICE(0x8086, 0x2448) }, */
+	{ PCI_DEVICE(0x8086, 0x244c) }, /* BAM */
+	{ PCI_DEVICE(0x8086, 0x248c) }, /* CAM */
+	{ PCI_DEVICE(0x8086, 0x24cc) }, /* DBM */
+	{ PCI_DEVICE(0x8086, 0x2641) }, /* FBM */
+	{ PCI_DEVICE(0x8086, 0x27b9) }, /* GxM */
+	{ PCI_DEVICE(0x8086, 0x27bd) }, /* GxM DH */
 /* BA, CA, DB, Ex, 6300, Fx, 631x/632x, Gx
-	{ 0x8086, 0x244e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2440, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* BA */
-	{ 0x8086, 0x2480, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* CA */
-	{ 0x8086, 0x24c0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* DB */
-	{ 0x8086, 0x24d0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* Ex */
-	{ 0x8086, 0x25a1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 6300 */
-	{ 0x8086, 0x2640, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* Fx */
-	{ 0x8086, 0x2670, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2671, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2672, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2673, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2674, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2675, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2676, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2677, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2678, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x2679, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267a, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x267f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* 631x/632x */
-	{ 0x8086, 0x27b8, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* Gx */
+	{ PCI_DEVICE(0x8086, 0x244e) }, */
+	{ PCI_DEVICE(0x8086, 0x2440) }, /* BA */
+	{ PCI_DEVICE(0x8086, 0x2480) }, /* CA */
+	{ PCI_DEVICE(0x8086, 0x24c0) }, /* DB */
+	{ PCI_DEVICE(0x8086, 0x24d0) }, /* Ex */
+	{ PCI_DEVICE(0x8086, 0x25a1) }, /* 6300 */
+	{ PCI_DEVICE(0x8086, 0x2640) }, /* Fx */
+	{ PCI_DEVICE(0x8086, 0x2670) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2671) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2672) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2673) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2674) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2675) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2676) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2677) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2678) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x2679) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267a) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267b) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267c) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267d) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267e) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x267f) }, /* 631x/632x */
+	{ PCI_DEVICE(0x8086, 0x27b8) }, /* Gx */
 /* E
-	{ 0x8086, 0x245e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, */
-	{ 0x8086, 0x2450, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, }, /* E  */
+	{ PCI_DEVICE(0x8086, 0x245e) }, */
+	{ PCI_DEVICE(0x8086, 0x2450) }, /* E  */
 	{ 0, },	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
diff --git a/drivers/char/watchdog/alim7101_wdt.c b/drivers/char/watchdog/alim7101_wdt.c
index 1dacec5..e4644dc 100644
--- a/drivers/char/watchdog/alim7101_wdt.c
+++ b/drivers/char/watchdog/alim7101_wdt.c
@@ -417,10 +417,8 @@ module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
 static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
-	{ PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{ PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
 };
 
