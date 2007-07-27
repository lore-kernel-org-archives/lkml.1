Return-Path: <linux-kernel-owner+w=401wt.eu-S936117AbXG0Jpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936117AbXG0Jpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935647AbXG0Jpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:45:33 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35673 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935471AbXG0Jpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:45:31 -0400
Date: Fri, 27 Jul 2007 11:44:07 +0200 (MEST)
Message-Id: <200707270944.LAA17082@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 02/68] 0 -> NULL, for arch/arm
Cc: rmk@arm.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: rmk@arm.linux.org.uk
Cc: akpm@linux-foundation.org
---

 common/dmabounce.c |    2 +-
 mach-omap1/clock.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index b36b1e8..74ff750 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -238,7 +238,7 @@ map_single(struct device *dev, void *ptr
 		struct safe_buffer *buf;
 
 		buf = alloc_safe_buffer(device_info, ptr, size, dir);
-		if (buf == 0) {
+		if (buf == NULL) {
 			dev_err(dev, "%s: unable to map unsafe buffer %p!\n",
 			       __func__, ptr);
 			return 0;
diff --git a/arch/arm/mach-omap1/clock.c b/arch/arm/mach-omap1/clock.c
index f625f6d..b7e1b22 100644
--- a/arch/arm/mach-omap1/clock.c
+++ b/arch/arm/mach-omap1/clock.c
@@ -193,7 +193,7 @@ static int calc_dsor_exp(struct clk *clk
 		return -EINVAL;
 
 	parent = clk->parent;
-	if (unlikely(parent == 0))
+	if (unlikely(parent == NULL))
 		return -EIO;
 
 	realrate = parent->rate;

