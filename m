Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYAXAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYAXAmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYAXAmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:42:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbYAXAmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:42:24 -0500
From: airlied@linux.ie
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       =?utf-8?q?Carlos=20Mart=C3=ADn?= <inean@users.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>
Subject: [PATCH] agp/intel: add support for E7221 chipset
Date: Thu, 24 Jan 2008 10:34:09 +1000
Message-Id: <1201134850-4543-1-git-send-email-airlied@linux.ie>
X-Mailer: git-send-email 1.5.3.7
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Martín <inean@users.sf.net>

The E7221 chipset is a 915 rebadged for the Intel server line.

Signed-off-by: Dave Airlie <airlied@linux.ie>
---
 drivers/char/agp/intel-agp.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index d879619..03eac1e 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -10,6 +10,8 @@
 #include <linux/agp_backend.h>
 #include "agp.h"
 
+#define PCI_DEVICE_ID_INTEL_E7221_HB	0x2588
+#define PCI_DEVICE_ID_INTEL_E7221_IG	0x258a
 #define PCI_DEVICE_ID_INTEL_82946GZ_HB      0x2970
 #define PCI_DEVICE_ID_INTEL_82946GZ_IG      0x2972
 #define PCI_DEVICE_ID_INTEL_82965G_1_HB     0x2980
@@ -526,7 +528,8 @@ static void intel_i830_init_gtt_entries(void)
 			break;
 		case I915_GMCH_GMS_STOLEN_48M:
 			/* Check it's really I915G */
-			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
+			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB ||
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
@@ -538,7 +541,8 @@ static void intel_i830_init_gtt_entries(void)
 			break;
 		case I915_GMCH_GMS_STOLEN_64M:
 			/* Check it's really I915G */
-			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
+			if (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_E7221_HB ||
+			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82915GM_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945G_HB ||
 			    agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82945GM_HB ||
@@ -1854,6 +1858,8 @@ static const struct intel_driver_description {
 	{ PCI_DEVICE_ID_INTEL_82865_HB, PCI_DEVICE_ID_INTEL_82865_IG, 0, "865",
 		&intel_845_driver, &intel_830_driver },
 	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, 0, "i875", &intel_845_driver, NULL },
+	{ PCI_DEVICE_ID_INTEL_E7221_HB, PCI_DEVICE_ID_INTEL_E7221_IG, 0, "E7221 (i915)",
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, 0, "915G",
 		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, 0, "915GM",
@@ -2059,6 +2065,7 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_82875_HB),
 	ID(PCI_DEVICE_ID_INTEL_7505_0),
 	ID(PCI_DEVICE_ID_INTEL_7205_0),
+	ID(PCI_DEVICE_ID_INTEL_E7221_HB),
 	ID(PCI_DEVICE_ID_INTEL_82915G_HB),
 	ID(PCI_DEVICE_ID_INTEL_82915GM_HB),
 	ID(PCI_DEVICE_ID_INTEL_82945G_HB),
-- 
1.5.3.6

