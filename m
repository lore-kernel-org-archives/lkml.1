Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXDIAxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXDIAxd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 20:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXDIAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 20:53:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:3124 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXDIAxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 20:53:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,386,1170662400"; 
   d="scan'208"; a="226801466:sNHT28567147"
Date: Mon, 9 Apr 2007 08:51:36 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
       Keith Packard <keithp@keithp.com>
Subject: [PATCH] intel_agp: PCI id update for Intel 965GM
Message-ID: <20070409005136.GA22124@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>, Eric Anholt <eric@anholt.net>,
	Keith Packard <keithp@keithp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[AGPGART] intel: Add 965GM chipset support

Update PCI id info for Intel 965GM chipset.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>

---
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index e542a62..a9fdbf9 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -18,11 +18,14 @@
 #define PCI_DEVICE_ID_INTEL_82965Q_IG       0x2992
 #define PCI_DEVICE_ID_INTEL_82965G_HB       0x29A0
 #define PCI_DEVICE_ID_INTEL_82965G_IG       0x29A2
+#define PCI_DEVICE_ID_INTEL_82965GM_HB      0x2A00
+#define PCI_DEVICE_ID_INTEL_82965GM_IG      0x2A02
 
 #define IS_I965 (agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82946GZ_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_1_HB || \
                  agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965Q_HB || \
-                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB)
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965G_HB || \
+                 agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_82965GM_HB)
 
 
 extern int agp_memory_reserved;
@@ -1921,7 +1924,13 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 			bridge->driver = &intel_845_driver;
 		name = "965G";
 		break;
-
+	case PCI_DEVICE_ID_INTEL_82965GM_HB:
+		if (find_i830(PCI_DEVICE_ID_INTEL_82965GM_IG))
+			bridge->driver = &intel_i965_driver;
+		else
+			bridge->driver = &intel_845_driver;
+		name = "965GM";
+		break;
 	case PCI_DEVICE_ID_INTEL_7505_0:
 		bridge->driver = &intel_7505_driver;
 		name = "E7505";
@@ -2080,6 +2089,7 @@ static struct pci_device_id agp_intel_pci_table[] = {
 	ID(PCI_DEVICE_ID_INTEL_82965G_1_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965Q_HB),
 	ID(PCI_DEVICE_ID_INTEL_82965G_HB),
+	ID(PCI_DEVICE_ID_INTEL_82965GM_HB),
 	{ }
 };
 
