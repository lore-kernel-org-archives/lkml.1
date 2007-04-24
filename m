Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbXDXIWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbXDXIWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXDXIUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24152 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbXDXIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:41 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 9/15] cfq-iosched: slice offset should take ioprio into account
Date: Tue, 24 Apr 2007 10:15:37 +0200
Message-Id: <11774025432255-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the max_slice-cur_slice as the multipler for the insertion offset.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f86ff4d..251131a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -442,7 +442,8 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 	/*
 	 * just an approximation, should be ok.
 	 */
-	return ((cfqd->busy_queues - 1) * cfq_prio_slice(cfqd, 1, 0));
+	return (cfqd->busy_queues - 1) * (cfq_prio_slice(cfqd, 1, 0) -
+		       cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio));
 }
 
 /*
-- 
1.5.1.1.190.g74474

