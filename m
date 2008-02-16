Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYBPROv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYBPROv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYBPROo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:14:44 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:45734 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYBPROn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:14:43 -0500
Message-ID: <47B719FB.4020107@tiscali.nl>
Date: Sat, 16 Feb 2008 18:14:35 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: kyungmin.park@samsung.com
CC: linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/mtd/onenand/onenand_base.c unlikely(x) || unlikely(y)
 => unlikely(x || y)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not yet tested.
---
Replace unlikely(x) || unlikely(y) by unlikely(x || y)

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index 8d7d21b..7334b4a 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -1336,7 +1336,7 @@ static int onenand_panic_write(struct mtd_info *mtd, loff_t to, size_t len,
 	}
 
 	/* Reject writes, which are not page aligned */
-        if (unlikely(NOTALIGNED(to)) || unlikely(NOTALIGNED(len))) {
+        if (unlikely(NOTALIGNED(to) || NOTALIGNED(len))) {
                 printk(KERN_ERR "onenand_panic_write: Attempt to write not page aligned data\n");
                 return -EINVAL;
         }
@@ -1466,7 +1466,7 @@ static int onenand_write_ops_nolock(struct mtd_info *mtd, loff_t to,
 	}
 
 	/* Reject writes, which are not page aligned */
-        if (unlikely(NOTALIGNED(to)) || unlikely(NOTALIGNED(len))) {
+        if (unlikely(NOTALIGNED(to) || NOTALIGNED(len))) {
                 printk(KERN_ERR "onenand_write_ops_nolock: Attempt to write not page aligned data\n");
                 return -EINVAL;
         }
