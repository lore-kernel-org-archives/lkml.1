Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbZABKrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbZABKrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZABKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:41:59 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:47562 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbZABKlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:41:40 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
Subject: [PATCH] m68k: atari_scc - kill fake config variables
Date: Fri,  2 Jan 2009 11:41:32 +0100
Message-Id: <1230892892-25751-20-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1230892892-25751-19-git-send-email-geert@linux-m68k.org>
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
 <1230892892-25751-13-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-14-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-15-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-16-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-17-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-18-git-send-email-geert@linux-m68k.org>
 <1230892892-25751-19-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename CONFIG_{TT,FALCON,ST}_SCC to SUPPORT_{TT,FALCON,ST}_SCC and reduce ifdef
clutter

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
---
 drivers/char/atari_scc.c |   39 ++++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/char/atari_scc.c b/drivers/char/atari_scc.c
index 5dc59ff..fefff96 100644
--- a/drivers/char/atari_scc.c
+++ b/drivers/char/atari_scc.c
@@ -49,9 +49,9 @@
 
 #include "scc.h"
 
-#define CONFIG_TT_SCC     1
-#define CONFIG_FALCON_SCC 1
-#define CONFIG_ST_SCC     1
+#define SUPPORT_TT_SCC     1
+#define SUPPORT_FALCON_SCC 1
+#define SUPPORT_ST_SCC     1
 
 #define CHANNEL_A	0
 #define CHANNEL_B	1
@@ -364,7 +364,7 @@ static void atari_scc_b_free_irqs(struct scc_port *port)
 	free_irq(IRQ_SCCB_SPCOND, port);
 }
 
-#ifdef CONFIG_TT_SCC
+#ifdef SUPPORT_TT_SCC
 static int atari_tt_scc_init(void)
 {
 	struct scc_port *port;
@@ -464,10 +464,15 @@ static int atari_tt_scc_init(void)
 
 	return 0;
 }
-#endif
+#else /* !SUPPORT_TT_SCC */
+static inline int atari_tt_scc_init(void)
+{
+	return -ENODEV;
+}
+#endif /* !SUPPORT_TT_SCC */
 
 
-#ifdef CONFIG_FALCON_SCC
+#ifdef SUPPORT_FALCON_SCC
 static int atari_falcon_scc_init(void)
 {
 	struct scc_port *port;
@@ -541,10 +546,15 @@ static int atari_falcon_scc_init(void)
 
 	return 0;
 }
-#endif
+#else /* !SUPPORT_FALCON_SCC */
+static inline int atari_falcon_scc_init(void)
+{
+	return -ENODEV;
+}
+#endif /* !SUPPORT_FALCON_SCC */
 
 
-#ifdef CONFIG_ST_SCC
+#ifdef SUPPORT_ST_SCC
 static int atari_st_scc_init(void)
 {
 	struct scc_port *port;
@@ -618,7 +628,12 @@ static int atari_st_scc_init(void)
 
 	return 0;
 }
-#endif
+#else /* !SUPPORT_ST_SCC */
+static inline int atari_st_scc_init(void)
+{
+	return -ENODEV;
+}
+#endif /* !SUPPORT_ST_SCC */
 
 
 int atari_scc_init(void)
@@ -635,18 +650,12 @@ int atari_scc_init(void)
 
 	scc_del = &mfp.par_dt_reg;
 
-#ifdef CONFIG_TT_SCC
 	if (MACH_IS_TT)
 		res = atari_tt_scc_init();
-#endif
-#ifdef CONFIG_FALCON_SCC
 	if (MACH_IS_FALCON)
 		res = atari_falcon_scc_init();
-#endif
-#ifdef CONFIG_ST_SCC
 	if (MACH_IS_ST)
 		res = atari_st_scc_init();
-#endif
 	return res;
 }
 
-- 
1.5.6.5

