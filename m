Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZICPMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZICPMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZICPMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:12:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59276 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbZICPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:12:23 -0400
Message-ID: <52761.192.168.10.89.1251990725.squirrel@dbdmail.itg.ti.com>
Date: Thu, 3 Sep 2009 20:42:05 +0530 (IST)
Subject: [PATCH 1/2]: twl4030: register twl4030-pwrbuttonas a child of 
     twl4030-core.c
From: "vimal singh" <vimalsingh@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: felipe.balbi@nokia.com, sameo@openedhand.com,
       dbrownell@users.sourceforge.net
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'twl4030-pwrbutton' was already made as a platform_driver so it can
be registered as a child of twl4030-core.c.

But adding twl4030-pwrbutton as our child in twl4030-core is missing
currently. This patch adds it.

Signed-off-by: Vimal Singh <vimalsingh@ti.com>
CC: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
This patch is compile tested only.
This patch is based on Felipe Balbi's patch posted earlier:
http://lkml.org/lkml/2009/2/28/88

 drivers/mfd/twl4030-core.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+)

Index: linux-omap-2.6/drivers/mfd/twl4030-core.c
===================================================================
--- linux-omap-2.6.orig/drivers/mfd/twl4030-core.c
+++ linux-omap-2.6/drivers/mfd/twl4030-core.c
@@ -108,6 +108,13 @@
 #define twl_has_watchdog()        false
 #endif

+#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
+	|| defined(CONFIG_INPUT_TWL4030_PWRBUTTON_MODULE)
+#define twl_has_pwrbutton()	true
+#else
+#define twl_has_pwrbutton()	false
+#endif
+
 /* Triton Core internal information (BEGIN) */

 /* Last - for index max*/
@@ -538,6 +545,13 @@ add_children(struct twl4030_platform_dat
 			return PTR_ERR(child);
 	}

+	if (twl_has_pwrbutton()) {
+		child = add_child(1, "twl4030_pwrbutton",
+				NULL, 0, true, pdata->irq_base + 8 + 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (twl_has_regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);


