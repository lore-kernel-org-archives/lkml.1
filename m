Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbXIJT2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbXIJT2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXIJT2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:28:25 -0400
Received: from khc.piap.pl ([195.187.100.11]:56733 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXIJT2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:28:24 -0400
To: sylvain.meyer@worldonline.fr
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Intel FB: support for interlaced video modes
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 10 Sep 2007 21:28:23 +0200
Message-ID: <m3hcm2l3qg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel framebuffer now supports interlaced video modes.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -323,11 +323,7 @@ intelfbhw_validate_mode(struct intelfb_info *dinfo,
 		return 1;
 	}
 
-	/* Check for interlaced/doublescan modes. */
-	if (var->vmode & FB_VMODE_INTERLACED) {
-		WRN_MSG("Mode is interlaced.\n");
-		return 1;
-	}
+	/* Check for doublescan modes. */
 	if (var->vmode & FB_VMODE_DOUBLE) {
 		WRN_MSG("Mode is double-scan.\n");
 		return 1;
@@ -1220,6 +1216,12 @@ intelfbhw_mode_to_hw(struct intelfb_info *dinfo, struct intelfb_hwstate *hw,
 
 	/* Set the palette to 8-bit mode. */
 	*pipe_conf &= ~PIPECONF_GAMMA;
+
+	if (var->vmode & FB_VMODE_INTERLACED)
+		*pipe_conf |= PIPECONF_INTERLACE_W_FIELD_INDICATION;
+	else
+		*pipe_conf &= ~PIPECONF_INTERLACE_MASK;
+
 	return 0;
 }
 
--- a/drivers/video/intelfb/intelfbhw.h
+++ b/drivers/video/intelfb/intelfbhw.h
@@ -286,6 +286,10 @@
 #define PIPECONF_UNLOCKED		0
 #define PIPECONF_GAMMA			(1 << 24)
 #define PIPECONF_PALETTE		0
+#define PIPECONF_PROGRESSIVE			(0 << 21)
+#define PIPECONF_INTERLACE_W_FIELD_INDICATION	(6 << 21)
+#define PIPECONF_INTERLACE_FIELD_0_ONLY		(7 << 21)
+#define PIPECONF_INTERLACE_MASK			(7 << 21)
 
 #define DISPARB			0x70030
 #define DISPARB_AEND_MASK		0x1ff
