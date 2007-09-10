Return-Path: <linux-kernel-owner+w=401wt.eu-S965602AbXIJTY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965602AbXIJTY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbXIJTYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:24:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:45697 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333AbXIJTYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:24:47 -0400
To: sylvain.meyer@worldonline.fr
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Intel FB pixel clock calculation fix
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 10 Sep 2007 21:24:42 +0200
Message-ID: <m3ir6il3wl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel framebuffer mis-calculated pixel clocks.

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -924,10 +920,10 @@ calc_pll_params(int index, int clock, u32 *retm1, u32 *retm2, u32 *retn, u32 *re
 			if (m > pll->max_m)
 				m = pll->max_m - 1;
 			for (testm = m - 1; testm <= m; testm++) {
-				f_out = calc_vclock3(index, m, n, p);
+				f_out = calc_vclock3(index, testm, n, p);
 				if (splitm(index, testm, &m1, &m2)) {
-					WRN_MSG("cannot split m = %d\n", m);
-					n++;
+					WRN_MSG("cannot split m = %d\n",
+						testm);
 					continue;
 				}
 				if (clock > f_out)
