Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbZJZUgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbZJZUgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZJZUgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:36:05 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:51248 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZJZUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=SREDjMkVb3eqWQKXF5lApveY4rkAtaNtQ8wQ3UfmPYLbDKe6h0D4e7lZJCnbrrEznJ
         y2Zgpcima9mWcna56DMtAScThwAxrGV6wnD8y6pY2i7pV6Wlx9+dTQNXu++tQrqMpQvr
         BwQqDDW4b/yWwRJ+6CgKJmtfiPDjuicylJ/2M=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] cfq-iosched: simplify prio-unboost code
Date: Mon, 26 Oct 2009 21:36:03 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262136.03233.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate redundant checks.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6e9b395..244bc8a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2611,12 +2611,10 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 			cfqq->ioprio = IOPRIO_NORM;
 	} else {
 		/*
-		 * check if we need to unboost the queue
+		 * unboost the queue (if needed)
 		 */
-		if (cfqq->ioprio_class != cfqq->org_ioprio_class)
-			cfqq->ioprio_class = cfqq->org_ioprio_class;
-		if (cfqq->ioprio != cfqq->org_ioprio)
-			cfqq->ioprio = cfqq->org_ioprio;
+		cfqq->ioprio_class = cfqq->org_ioprio_class;
+		cfqq->ioprio = cfqq->org_ioprio;
 	}
 }
 
-- 
1.6.2.5


