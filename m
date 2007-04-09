Return-Path: <linux-kernel-owner+w=401wt.eu-S965747AbXDIVW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965747AbXDIVW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965880AbXDIVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:22:59 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:26352 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965747AbXDIVWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:22:49 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3/18] ARM: OMAP: FB: add controller platform data
Date: Mon,  9 Apr 2007 17:22:08 -0400
Message-Id: <11761537522665-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537491968-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com>
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

