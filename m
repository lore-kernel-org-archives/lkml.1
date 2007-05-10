Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbXEJLlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbXEJLlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757872AbXEJLlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:41:09 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4873 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754558AbXEJLlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:41:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/12] crypto: don't pollute the global namespace with sg_next()
Date: Thu, 10 May 2007 13:40:26 +0200
Message-Id: <11787972372499-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11787972373654-git-send-email-jens.axboe@oracle.com>
References: <11787972373654-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's a subsystem function, prefix it as such.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 crypto/digest.c      |    2 +-
 crypto/scatterwalk.c |    2 +-
 crypto/scatterwalk.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/digest.c b/crypto/digest.c
index 1bf7414..e56de67 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -77,7 +77,7 @@ static int update2(struct hash_desc *desc,
 
 		if (!nbytes)
 			break;
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	return 0;
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 81afd17..2e51f82 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -70,7 +70,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		walk->offset += PAGE_SIZE - 1;
 		walk->offset &= PAGE_MASK;
 		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, sg_next(walk->sg));
+			scatterwalk_start(walk, scatterwalk_sg_next(walk->sg));
 	}
 }
 
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index f1592cc..e049c62 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -20,7 +20,7 @@
 
 #include "internal.h"
 
-static inline struct scatterlist *sg_next(struct scatterlist *sg)
+static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
 	return (++sg)->length ? sg : (void *)sg->page;
 }
-- 
1.5.2.rc1

