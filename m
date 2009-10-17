Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZJQGma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZJQGma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZJQGm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:42:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39210 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZJQGm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:42:27 -0400
Date: Sat, 17 Oct 2009 08:42:30 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: tony@atomide.com, Russell King <linux@arm.linux.org.uk>,
       linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 12/14] arch/arm/plat-omap: Drop an unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0910170842120.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

map_iovm_area is only called from a context where its second argument is
known not to be NULL, so drop the unnecessary test.  If new could be NULL,
the initialization of da should be moved below the test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/plat-omap/iovmm.c          |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index dc3fac3..21c73d4 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -449,7 +449,7 @@ static int map_iovm_area(struct iommu *obj, struct iovm_struct *new,
 	struct scatterlist *sg;
 	u32 da = new->da_start;
 
-	if (!obj || !new || !sgt)
+	if (!obj || !sgt)
 		return -EINVAL;
 
 	BUG_ON(!sgtable_ok(sgt));
