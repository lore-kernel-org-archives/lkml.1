Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbXG0LdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbXG0LdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 07:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935690AbXG0Lcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 07:32:41 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:40638 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637AbXG0Lck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 07:32:40 -0400
Message-Id: <20070727113540.638204787@de.ibm.com>
References: <20070727113348.413110503@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Jul 2007 13:33:49 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Frank Munzert <munzert@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 1/6] vmur: fix diag14_read.
Content-Disposition: inline; filename=010-vmur-read.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Munzert <munzert@de.ibm.com>

Record length of spool file must be only stored in 1st SPLINK record

Signed-off-by: Frank Munzert <munzert@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/char/vmur.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/char/vmur.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/vmur.c
+++ quilt-2.6/drivers/s390/char/vmur.c
@@ -486,7 +486,7 @@ static ssize_t diag14_read(struct file *
 		}
 		if (rc)
 			goto fail;
-		if (reclen)
+		if (reclen && (copied == 0) && (*offs < PAGE_SIZE))
 			*((u16 *) &buf[FILE_RECLEN_OFFSET]) = reclen;
 		len = min(count - copied, PAGE_SIZE - res);
 		if (copy_to_user(ubuf + copied, buf + res, len)) {

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

