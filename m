Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbXBEClM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbXBEClM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 21:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXBEClM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 21:41:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:22954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXBEClL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 21:41:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=cp1m5PjSSo30M7dd1oKGMSRJje/Q/JANVwSzTFqxMnIla4Lw2zE/LDSnu19FoSYRPUdNhlM/AfrAKcP7Lim3LaJ+DlgYGx2RPDstrhKcxo9NWKrfv5pUhY+V6+VKG9VcfjCQe0DiuCKDBr4pyxfU+hf4O91E0ob1aMljeYqe6QE=
Date: Mon, 5 Feb 2007 04:40:57 +0200
To: starvik@axis.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20] arch CRIS: user ARRAY_SIZE macro when appropriate
Message-ID: <20070205024057.GH18118@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205023935.GG18118@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch isn't compile checked since I have no CRIS machine at hand.

diff --git a/arch/cris/arch-v10/drivers/axisflashmap.c b/arch/cris/arch-v10/drivers/axisflashmap.c
index ffade19..c5d90fc 100644
--- a/arch/cris/arch-v10/drivers/axisflashmap.c
+++ b/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -359,8 +359,7 @@ static struct mtd_info *flash_probe(void)
 		 * So we use the MTD concatenation layer instead of further
 		 * complicating the probing procedure.
 		 */
-		mtd_cse = mtd_concat_create(mtds,
-					    sizeof(mtds) / sizeof(mtds[0]),
+		mtd_cse = mtd_concat_create(mtds, ARRAY_SIZE(mtds), 
 					    "cse0+cse1");
 #else
 		printk(KERN_ERR "%s and %s: Cannot concatenate due to kernel "
diff --git a/arch/cris/mm/tlb.c b/arch/cris/mm/tlb.c
index 0df390a..c4a98e2 100644
--- a/arch/cris/mm/tlb.c
+++ b/arch/cris/mm/tlb.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <asm/tlb.h>
 
 #define D(x)
@@ -100,7 +101,7 @@ tlb_init(void)
 
 	/* clear the page_id map */
 
-	for (i = 1; i < sizeof (page_id_map) / sizeof (page_id_map[0]); i++)
+	for (i = 1; i < ARRAY_SIZE(page_id_map); i++)
 		page_id_map[i] = NULL;
 	
 	/* invalidate the entire TLB */

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
