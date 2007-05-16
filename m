Return-Path: <linux-kernel-owner+w=401wt.eu-S1762543AbXEPIgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762543AbXEPIgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758695AbXEPIeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:07 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6599 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762335AbXEPIeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:04 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/19] Add sg helpers for iterating over a scatterlist table
Date: Wed, 16 May 2007 10:32:16 +0200
Message-Id: <11793043533803-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First step to being able to change the scatterlist setup without
having to modify drivers (a lot :-)

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4efbd9c..bed5ab4 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,4 +20,13 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
+#define sg_next(sg)		((sg) + 1)
+#define sg_last(sg, nents)	(&(sg[(nents) - 1]))
+
+/*
+ * Loop over each sg element, following the pointer to a new list if necessary
+ */
+#define for_each_sg(sglist, sg, nr, __i)	\
+	for (__i = 0, sg = (sglist); __i < (nr); __i++, sg = sg_next(sg))
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.2.rc1

