Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXDDRxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXDDRxf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 13:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXDDRxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 13:53:34 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:34933 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbXDDRxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 13:53:33 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Apr 2007 13:53:33 EDT
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 8/90] ARM: OMAP: FB: add controller platform data
Date: Wed,  4 Apr 2007 13:46:35 -0400
Message-Id: <11757088953851-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757088932135-git-send-email-tony@atomide.com>
References: omap-2007-04-04-133556 <11757088774110-git-send-email-tony@atomide.com> <11757088791107-git-send-email-tony@atomide.com> <11757088822930-git-send-email-tony@atomide.com> <11757088844012-git-send-email-tony@atomide.com> <1175708886798-git-send-email-tony@atomide.com> <11757088883638-git-send-email-tony@atomide.com> <11757088904153-git-send-email-tony@atomide.com> <11757088932135-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

Add controller platform data

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/fb.c            |    5 +++++
 include/asm-arm/arch-omap/omapfb.h |    8 +++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/fb.c b/arch/arm/plat-omap/fb.c
index 56acb87..91ebdaf 100644
--- a/arch/arm/plat-omap/fb.c
+++ b/arch/arm/plat-omap/fb.c
@@ -55,6 +55,11 @@ void omapfb_reserve_mem(void)
 	}
 }
 
+void omapfb_set_ctrl_platform_data(void *data)
+{
+	omapfb_config.ctrl_platform_data = data;
+}
+
 static inline int omap_init_fb(void)
 {
 	const struct omap_lcd_config *conf;
diff --git a/include/asm-arm/arch-omap/omapfb.h b/include/asm-arm/arch-omap/omapfb.h
index fccdb3d..ce80a71 100644
--- a/include/asm-arm/arch-omap/omapfb.h
+++ b/include/asm-arm/arch-omap/omapfb.h
@@ -292,8 +292,9 @@ struct omapfb_device {
 };
 
 struct omapfb_platform_data {
-	struct omap_lcd_config   lcd;
-	struct omap_fbmem_config fbmem;
+	struct omap_lcd_config	lcd;
+	struct omapfb_mem_desc	mem_desc;
+	void			*ctrl_platform_data;
 };
 
 #define OMAPFB_EVENT_READY	1
@@ -317,8 +318,9 @@ extern int  omapfb_update_window_async(struct omapfb_update_window *win,
 					void (*callback)(void *),
 					void *callback_data);
 
-/* in arch/arm/plat-omap/devices.c */
+/* in arch/arm/plat-omap/fb.c */
 extern void omapfb_reserve_mem(void);
+extern void omapfb_set_ctrl_platform_data(void *pdata);
 
 #endif /* __KERNEL__ */
 
-- 
1.4.4.2

