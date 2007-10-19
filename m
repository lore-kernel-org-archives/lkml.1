Return-Path: <linux-kernel-owner+w=401wt.eu-S936195AbXJSRvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936195AbXJSRvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765838AbXJSRvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:51:36 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:54944 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765850AbXJSRve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:51:34 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2007 13:51:33 EDT
From: Samuel Tardieu <sam@rfc1149.net>
Date: Fri, 19 Oct 2007 19:26:35 +0200
Subject: [PATCH] eccbuf is statically defined and always evaluate to true
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Message-Id: <20071019174155.80782C408E@mail2.rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/mtd/devices/doc2000.c     |    4 ++--
 drivers/mtd/devices/doc2001plus.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
index c73e96b..e9ce241 100644
--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -632,7 +632,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 			len = ((from | 0x1ff) + 1) - from;
 
 		/* The ECC will not be calculated correctly if less than 512 is read */
-		if (len != 0x200 && eccbuf)
+		if (len != 0x200)
 			printk(KERN_WARNING
 			       "ECC needs a full sector read (adr: %lx size %lx)\n",
 			       (long) from, (long) len);
@@ -896,7 +896,7 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* Let the caller know we completed it */
 		*retlen += len;
 
-		if (eccbuf) {
+		{
 			unsigned char x[8];
 			size_t dummy;
 			int ret;
diff --git a/drivers/mtd/devices/doc2001plus.c b/drivers/mtd/devices/doc2001plus.c
index 2b30b58..83be346 100644
--- a/drivers/mtd/devices/doc2001plus.c
+++ b/drivers/mtd/devices/doc2001plus.c
@@ -748,7 +748,7 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
 	WriteDOC(DoC_GetDataOffset(mtd, &fto), docptr, Mplus_FlashCmd);
 
 	/* On interleaved devices the flags for 2nd half 512 are before data */
-	if (eccbuf && before)
+	if (before)
 		fto -= 2;
 
 	/* issue the Serial Data In command to initial the Page Program process */
-- 
1.5.3.4

