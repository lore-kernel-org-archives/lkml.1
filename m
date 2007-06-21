Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbXFUFof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbXFUFof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 01:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXFUFo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 01:44:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:4470 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXFUFo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 01:44:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,445,1175497200"; 
   d="scan'208";a="259388615"
Date: Thu, 21 Jun 2007 13:43:18 +0800
From: Wang Zhenyu <zhenyu.z.wang@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net
Subject: [PATCH][AGPGART] intel_agp: don't load if no IGD and AGP port
Message-ID: <20070621054318.GA31381@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Carlo Wood <carlo@alinoe.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net
References: <alpine.LFD.0.98.0706181127380.14121@woody.linux-foundation.org> <20070618195415.GA7481@alinoe.com> <alpine.LFD.0.98.0706181332400.3593@woody.linux-foundation.org> <20070618225009.GE13538@alinoe.com> <alpine.LFD.0.98.0706181553450.3593@woody.linux-foundation.org> <20070619233716.GA5779@alinoe.com> <20070620011521.GB2856@zhen-devel.sh.intel.com> <20070620014227.GA4090@zhen-devel.sh.intel.com> <20070620140237.GB5524@alinoe.com> <20070620154610.GA2802@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620154610.GA2802@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
X-Mailer: mutt
X-Operating-System: Linux 2.6.15-1.2054_FC5smp i686
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks Carlo to report this problem. The following patch should fix
his and potential issue.

[AGPGART] intel_agp: don't load if no IGD detected and no AGP port

After i915 chip, GMCH has no AGP port. Origin bridge driver in device
table will try to access illegal regs like APBASE, APSIZE, etc. This
may cause problem.

So mark them as NULL in the table, we won't load if no IGD got detect
and bridge has no AGP port.

Signed-off-by: Wang Zhenyu <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |   35 +++++++++++++++++++----------------
 1 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 0439ee9..a124060 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -1843,35 +1843,35 @@ static const struct intel_driver_description {
 		&intel_845_driver, &intel_830_driver },
 	{ PCI_DEVICE_ID_INTEL_82875_HB, 0, 0, "i875", &intel_845_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_82915G_HB, PCI_DEVICE_ID_INTEL_82915G_IG, 0, "915G",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82915GM_HB, PCI_DEVICE_ID_INTEL_82915GM_IG, 0, "915GM",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945G_HB, PCI_DEVICE_ID_INTEL_82945G_IG, 0, "945G",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GM_IG, 1, "945GM",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82945GM_HB, PCI_DEVICE_ID_INTEL_82945GME_IG, 0, "945GME",
-		&intel_845_driver, &intel_915_driver },
+		NULL, &intel_915_driver },
 	{ PCI_DEVICE_ID_INTEL_82946GZ_HB, PCI_DEVICE_ID_INTEL_82946GZ_IG, 0, "946GZ",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_1_HB, PCI_DEVICE_ID_INTEL_82965G_1_IG, 0, "965G",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965Q_HB, PCI_DEVICE_ID_INTEL_82965Q_IG, 0, "965Q",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965G_HB, PCI_DEVICE_ID_INTEL_82965G_IG, 0, "965G",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GM_IG, 1, "965GM",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_82965GM_HB, PCI_DEVICE_ID_INTEL_82965GME_IG, 0, "965GME/GLE",
-		&intel_845_driver, &intel_i965_driver },
+		NULL, &intel_i965_driver },
 	{ PCI_DEVICE_ID_INTEL_7505_0, 0, 0, "E7505", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_7205_0, 0, 0, "E7205", &intel_7505_driver, NULL },
 	{ PCI_DEVICE_ID_INTEL_G33_HB, PCI_DEVICE_ID_INTEL_G33_IG, 0, "G33",
-		&intel_845_driver, &intel_g33_driver },
+		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q35_HB, PCI_DEVICE_ID_INTEL_Q35_IG, 0, "Q35",
-		&intel_845_driver, &intel_g33_driver },
+		NULL, &intel_g33_driver },
 	{ PCI_DEVICE_ID_INTEL_Q33_HB, PCI_DEVICE_ID_INTEL_Q33_IG, 0, "Q33",
-		&intel_845_driver, &intel_g33_driver },
+		NULL, &intel_g33_driver },
 	{ 0, 0, 0, NULL, NULL, NULL }
 };
 
@@ -1917,8 +1917,11 @@ static int __devinit agp_intel_probe(struct pci_dev *pdev,
 	}
 
 	if (bridge->driver == NULL) {
-		printk(KERN_WARNING PFX "Failed to find bridge device "
-			"(chip_id: %04x)\n", intel_agp_chipsets[i].gmch_chip_id);
+		/* bridge has no AGP and no IGD detected */
+		if (cap_ptr)
+			printk(KERN_WARNING PFX "Failed to find bridge device "
+				"(chip_id: %04x)\n",
+				intel_agp_chipsets[i].gmch_chip_id);
 		agp_put_bridge(bridge);
 		return -ENODEV;
         }
-- 
1.4.4.4
