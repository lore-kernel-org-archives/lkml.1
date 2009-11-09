Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbZKILqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbZKILqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbZKILqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:46:08 -0500
Received: from smtp.nokia.com ([192.100.122.233]:64532 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZKILqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:46:05 -0500
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 01/19] OMAP2: Add funcs for writing SMS_ROT_* registers
Date: Mon,  9 Nov 2009 13:45:08 +0200
Message-Id: <1257767126-12059-2-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 09 Nov 2009 11:45:49.0776 (UTC) FILETIME=[2EF83D00:01CA6132]
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
 arch/arm/plat-omap/include/plat/sdrc.h |    9 ++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/sdrc.c b/arch/arm/mach-omap2/sdrc.c
index 07000de..061dc8b 100644
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
diff --git a/arch/arm/plat-omap/include/plat/sdrc.h b/arch/arm/plat-omap/include/plat/sdrc.h
index 7b58a5f..3e72d86 100644
--- a/arch/arm/plat-omap/include/plat/sdrc.h
+++ b/arch/arm/plat-omap/include/plat/sdrc.h
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
1.6.5.1

