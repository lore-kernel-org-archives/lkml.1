Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbZLDCsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbZLDCsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbZLDCrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:47:20 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:20159 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbZLDCrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:47:16 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com
Subject: [RFC][PATCH 04/10] arm: mxc: Fix Drive Strength Field in the IOMUX controller
Date: Fri,  4 Dec 2009 04:47:04 +0200
Message-Id: <a079a0627e77f2df590840e4798fc067f4436160.1259893118.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
 <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
 <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
 <58eb7d14c6cf56cbc874657dff5789c47116b49e.1259893118.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i.MX51 defines 4 values:

00: Low Drive Strength
01: Medium Drive Strength
10: High Drive Strength
11: Max Drive Strength

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/include/mach/iomux-v3.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/iomux-v3.h b/arch/arm/plat-mxc/include/mach/iomux-v3.h
index a0fa402..8c351d6 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -81,11 +81,13 @@ struct pad_desc {
 
 #define PAD_CTL_ODE			(1 << 3)
 
-#define PAD_CTL_DSE_STANDARD		(0 << 1)
-#define PAD_CTL_DSE_HIGH		(1 << 1)
-#define PAD_CTL_DSE_MAX			(2 << 1)
+#define PAD_CTL_DSE_LOW			(0 << 1)
+#define PAD_CTL_DSE_MED			(1 << 1)
+#define PAD_CTL_DSE_HIGH		(2 << 1)
+#define PAD_CTL_DSE_MAX			(3 << 1)
 
 #define PAD_CTL_SRE_FAST		(1 << 0)
+#define PAD_CTL_SRE_SLOW		(0 << 0)
 
 /*
  * setups a single pad:
-- 
1.6.3.3

