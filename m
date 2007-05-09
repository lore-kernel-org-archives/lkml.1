Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbXEIIAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbXEIIAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbXEIH7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 03:59:46 -0400
Received: from brick.kernel.dk ([80.160.20.94]:20889 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXEIH7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 03:59:44 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/10] Add sg helpers for iterating over a scatterlist table
Date: Wed,  9 May 2007 09:59:16 +0200
Message-Id: <11786975641306-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11786975641643-git-send-email-jens.axboe@oracle.com>
References: <11786975641643-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

First step to being able to change the scatterlist setup without
having to modify drivers (a lot :-)

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/scatterlist.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4efbd9c..c5bffde 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -20,4 +20,13 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
 	sg_set_buf(sg, buf, buflen);
 }
 
+#define sg_next(sg)		((sg) + 1)
+#define sg_last(sg, nents)	(&(sg[nents - 1]))
+
+/*
+ * Loop over each sg element, following the pointer to a new list if necessary
+ */
+#define for_each_sg(sglist, sg, nr, __i)	\
+	for (__i = 0, sg = (sglist); __i < nr; __i++, sg = sg_next(sg))
+
 #endif /* _LINUX_SCATTERLIST_H */
-- 
1.5.2.rc1

