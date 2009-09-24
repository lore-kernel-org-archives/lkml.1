Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZIXL4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZIXL4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZIXL4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:56:30 -0400
Received: from smtp.nokia.com ([192.100.105.134]:26199 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZIXL43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:56:29 -0400
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 01/19] OMAP2: Add funcs for writing SMS_ROT_* registers
Date: Thu, 24 Sep 2009 14:56:06 +0300
Message-Id: <1253793384-31158-2-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
References: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 24 Sep 2009 11:56:30.0187 (UTC) FILETIME=[0DAEB3B0:01CA3D0E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMS_ROT_* registers are used by VRFB rotation engine.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/sdrc.c             |   16 ++++++++++++++++
 arch/arm/plat-omap/include/mach/sdrc.h |    9 ++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/sdrc.c b/arch/arm/mach-omap2/sdrc.c
index 9e3bd4f..6a5a2c5 100644
--- a/arch/arm/mach-omap2/sdrc.c
+++ b/arch/arm/mach-omap2/sdrc.c
@@ -133,3 +133,19 @@ void __init omap2_sdrc_init(struct omap_sdrc_params *sdrc_cs0,
 		(1 << SDRC_POWER_PAGEPOLICY_SHIFT);
 	sdrc_write_reg(l, SDRC_POWER);
 }
+
+void omap2_sms_write_rot_control(u32 val, unsigned ctx)
+{
+	sms_write_reg(val, SMS_ROT_CONTROL(ctx));
+}
+
+void omap2_sms_write_rot_size(u32 val, unsigned ctx)
+{
+	sms_write_reg(val, SMS_ROT_SIZE(ctx));
+}
+
+void omap2_sms_write_rot_physical_ba(u32 val, unsigned ctx)
+{
+	sms_write_reg(val, SMS_ROT_PHYSICAL_BA(ctx));
+}
+
diff --git a/arch/arm/plat-omap/include/mach/sdrc.h b/arch/arm/plat-omap/include/mach/sdrc.h
index 1c09c78..3b157ce 100644
--- a/arch/arm/plat-omap/include/mach/sdrc.h
+++ b/arch/arm/plat-omap/include/mach/sdrc.h
@@ -88,7 +88,10 @@
 
 /* SMS register offsets - read/write with sms_{read,write}_reg() */
 
-#define SMS_SYSCONFIG		0x010
+#define SMS_SYSCONFIG			0x010
+#define SMS_ROT_CONTROL(context)	(0x180 + 0x10 * context)
+#define SMS_ROT_SIZE(context)		(0x184 + 0x10 * context)
+#define SMS_ROT_PHYSICAL_BA(context)	(0x188 + 0x10 * context)
 /* REVISIT: fill in other SMS registers here */
 
 
@@ -121,6 +124,10 @@ int omap2_sdrc_get_params(unsigned long r,
 			  struct omap_sdrc_params **sdrc_cs0,
 			  struct omap_sdrc_params **sdrc_cs1);
 
+void omap2_sms_write_rot_control(u32 val, unsigned ctx);
+void omap2_sms_write_rot_size(u32 val, unsigned ctx);
+void omap2_sms_write_rot_physical_ba(u32 val, unsigned ctx);
+
 #ifdef CONFIG_ARCH_OMAP2
 
 struct memory_timings {
-- 
1.6.4

