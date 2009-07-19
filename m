Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZGSP0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZGSP0e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 11:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZGSP0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 11:26:18 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:47103 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbZGSP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 11:26:16 -0400
Date: Sun, 19 Jul 2009 17:25:28 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: tony@atomide.com, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/10] arch/arm/plat-omap: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907191725060.16542@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The function map_iovm_area is static and is only called from one place, at
which the "new" argument cannot be NULL.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E,E1;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E=E1
      when != i
  if (E == NULL||...) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/plat-omap/iovmm.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 2fce2c1..04e2286 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -447,7 +447,7 @@ static int map_iovm_area(struct iommu *obj, struct iovm_struct *new,
 	struct scatterlist *sg;
 	u32 da = new->da_start;
 
-	if (!obj || !new || !sgt)
+	if (!obj || !sgt)
 		return -EINVAL;
 
 	BUG_ON(!sgtable_ok(sgt));
