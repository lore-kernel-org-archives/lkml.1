Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbZKHGBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbZKHGBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZKHGBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:01:15 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:58592 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZKHGBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:01:12 -0500
Date: Sun, 8 Nov 2009 01:01:08 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       cjb@laptop.org, deepak@laptop.org,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [PATCH 5/6] CS5535: define lxfb/gxfb MSRs in linux/cs5535.h
Message-ID: <20091108010108.1568ce2a@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


..and include them in the lxfb/gxfb drivers rather than asm/geode.h (where
possible).

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 arch/x86/include/asm/geode.h     |   13 -------------
 drivers/video/geode/display_gx.c |    2 +-
 drivers/video/geode/gxfb.h       |    2 +-
 drivers/video/geode/gxfb_core.c  |    2 +-
 drivers/video/geode/lxfb.h       |    2 +-
 drivers/video/geode/lxfb_ops.c   |    2 +-
 drivers/video/geode/suspend_gx.c |    2 +-
 drivers/video/geode/video_gx.c   |    2 +-
 include/linux/cs5535.h           |   13 +++++++++++++
 9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/geode.h b/arch/x86/include/asm/geode.h
index df1eaf8..ae104da 100644
--- a/arch/x86/include/asm/geode.h
+++ b/arch/x86/include/asm/geode.h
@@ -31,25 +31,12 @@ extern int geode_get_dev_base(unsigned int dev);
 
 /* MSRS */
 
-#define MSR_GLIU_P2D_RO0	0x10000029
-
-#define MSR_LX_GLD_MSR_CONFIG	0x48002001
-#define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
-						 * sheet has the wrong value */
-#define MSR_GLCP_SYS_RSTPLL	0x4C000014
-#define MSR_GLCP_DOTPLL		0x4C000015
-
 #define MSR_LBAR_SMB		0x5140000B
 #define MSR_LBAR_GPIO		0x5140000C
 #define MSR_LBAR_MFGPT		0x5140000D
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
-#define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
-
-#define MSR_GX_GLD_MSR_CONFIG	0xC0002001
-#define MSR_GX_MSR_PADSEL	0xC0002011
-
 /* Resource Sizes */
 
 #define LBAR_GPIO_SIZE		0xFF
diff --git a/drivers/video/geode/display_gx.c b/drivers/video/geode/display_gx.c
index 3ddf055..f0af911 100644
--- a/drivers/video/geode/display_gx.c
+++ b/drivers/video/geode/display_gx.c
@@ -17,7 +17,7 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 #include <asm/delay.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "gxfb.h"
 
diff --git a/drivers/video/geode/gxfb.h b/drivers/video/geode/gxfb.h
index 16a96f8..d19e937 100644
--- a/drivers/video/geode/gxfb.h
+++ b/drivers/video/geode/gxfb.h
@@ -340,7 +340,7 @@ static inline void write_fp(struct gxfb_par *par, int reg, uint32_t val)
 }
 
 
-/* MSRs are defined in asm/geode.h; their bitfields are here */
+/* MSRs are defined in linux/cs5535.h; their bitfields are here */
 
 #define MSR_GLCP_SYS_RSTPLL_DOTPOSTDIV3	(1 << 3)
 #define MSR_GLCP_SYS_RSTPLL_DOTPREMULT2	(1 << 2)
diff --git a/drivers/video/geode/gxfb_core.c b/drivers/video/geode/gxfb_core.c
index 2552cac..b3e639d 100644
--- a/drivers/video/geode/gxfb_core.c
+++ b/drivers/video/geode/gxfb_core.c
@@ -32,7 +32,7 @@
 #include <linux/suspend.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "gxfb.h"
 
diff --git a/drivers/video/geode/lxfb.h b/drivers/video/geode/lxfb.h
index 6a51448..fc68a8b 100644
--- a/drivers/video/geode/lxfb.h
+++ b/drivers/video/geode/lxfb.h
@@ -409,7 +409,7 @@ static inline void write_fp(struct lxfb_par *par, int reg, uint32_t val)
 }
 
 
-/* MSRs are defined in asm/geode.h; their bitfields are here */
+/* MSRs are defined in linux/cs5535.h; their bitfields are here */
 
 #define MSR_GLCP_DOTPLL_LOCK		(1 << 25)	/* r/o */
 #define MSR_GLCP_DOTPLL_HALFPIX		(1 << 24)
diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index fe1ee7c..0e5d8c7 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -13,7 +13,7 @@
 #include <linux/fb.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "lxfb.h"
 
diff --git a/drivers/video/geode/suspend_gx.c b/drivers/video/geode/suspend_gx.c
index 9aff32e..1bb043d 100644
--- a/drivers/video/geode/suspend_gx.c
+++ b/drivers/video/geode/suspend_gx.c
@@ -10,7 +10,7 @@
 #include <linux/fb.h>
 #include <asm/io.h>
 #include <asm/msr.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 #include <asm/delay.h>
 
 #include "gxfb.h"
diff --git a/drivers/video/geode/video_gx.c b/drivers/video/geode/video_gx.c
index b8d52a8..6082f65 100644
--- a/drivers/video/geode/video_gx.c
+++ b/drivers/video/geode/video_gx.c
@@ -16,7 +16,7 @@
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/msr.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 #include "gxfb.h"
 
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index eb34108..d5a1d48 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -12,6 +12,14 @@
 #define _CS5535_H
 
 /* MSRs */
+#define MSR_GLIU_P2D_RO0	0x10000029
+
+#define MSR_LX_GLD_MSR_CONFIG	0x48002001
+#define MSR_LX_MSR_PADSEL	0x48002011	/* NOT 0x48000011; the data
+						 * sheet has the wrong value */
+#define MSR_GLCP_SYS_RSTPLL	0x4C000014
+#define MSR_GLCP_DOTPLL		0x4C000015
+
 #define MSR_LBAR_SMB		0x5140000B
 #define MSR_LBAR_GPIO		0x5140000C
 #define MSR_LBAR_MFGPT		0x5140000D
@@ -30,6 +38,11 @@
 #define MSR_MFGPT_NR		0x51400029
 #define MSR_MFGPT_SETUP		0x5140002B
 
+#define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
+
+#define MSR_GX_GLD_MSR_CONFIG	0xC0002001
+#define MSR_GX_MSR_PADSEL	0xC0002011
+
 /* resource sizes */
 #define LBAR_GPIO_SIZE		0xFF
 #define LBAR_MFGPT_SIZE		0x40
-- 
1.5.6.5

