Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbYDWShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbYDWShn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbYDWShW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:37:22 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35950 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYDWShU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:37:20 -0400
Message-ID: <480F81DC.5010505@tiscali.nl>
Date: Wed, 23 Apr 2008 20:37:16 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] aty128fb: test below 0 on unsigned pll->post_divider
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pll->post_divider is unsigned, so the test fails

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index cbd3308..5617259 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -1339,8 +1339,6 @@ static int aty128_var_to_pll(u32 period_in_ps, struct aty128_pll *pll,
 	if (vclk * 12 < c.ppll_min)
 		vclk = c.ppll_min/12;
 
-	pll->post_divider = -1;
-
 	/* now, find an acceptable divider */
 	for (i = 0; i < sizeof(post_dividers); i++) {
 		output_freq = post_dividers[i] * vclk;
@@ -1350,7 +1348,7 @@ static int aty128_var_to_pll(u32 period_in_ps, struct aty128_pll *pll,
 		}
 	}
 
-	if (pll->post_divider < 0)
+	if (i == sizeof(post_dividers))
 		return -EINVAL;
 
 	/* calculate feedback divider */
