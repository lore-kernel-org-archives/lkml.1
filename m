Return-Path: <linux-kernel-owner+w=401wt.eu-S1761020AbXEJLle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761020AbXEJLle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbXEJLlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4876 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757229AbXEJLlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/12] Add sg helpers for iterating over a scatterlist table
Date: Thu, 10 May 2007 13:40:27 +0200
Message-Id: <11787972373916-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787972373654-git-send-email-jens.axboe@oracle.com>
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
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

