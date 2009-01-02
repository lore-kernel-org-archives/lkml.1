Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbZABKoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbZABKoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:44:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757559AbZABKlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:49 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:45061 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbZABKli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:38 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] m68k: atafb - kill warn_unused_result warnings
Date: Fri,  2 Jan 2009 11:41:25 +0100
Message-Id: <1230892892-25751-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
References: <1230892892-25751-1-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-2-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-3-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-4-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-5-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-6-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-7-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-8-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-9-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-10-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-11-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-12-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

warning: ignoring return value of 'request_irq', declared with attribute
warn_unused_result

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/atafb.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index 477ce55..8058572 100644
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -3075,8 +3075,7 @@ int __init atafb_setup(char *options)
 
 int __init atafb_init(void)
 {
-	int pad;
-	int detected_mode;
+	int pad, detected_mode, error;
 	unsigned int defmode = 0;
 	unsigned long mem_req;
 
@@ -3116,8 +3115,12 @@ int __init atafb_init(void)
 			printk("atafb_init: initializing Falcon hw\n");
 			fbhw = &falcon_switch;
 			atafb_ops.fb_setcolreg = &falcon_setcolreg;
-			request_irq(IRQ_AUTO_4, falcon_vbl_switcher, IRQ_TYPE_PRIO,
-			            "framebuffer/modeswitch", falcon_vbl_switcher);
+			error = request_irq(IRQ_AUTO_4, falcon_vbl_switcher,
+					    IRQ_TYPE_PRIO,
+					    "framebuffer/modeswitch",
+					    falcon_vbl_switcher);
+			if (error)
+				return error;
 			defmode = DEFMODE_F30;
 			break;
 		}
-- 
1.5.6.5

