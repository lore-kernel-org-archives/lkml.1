Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYDWTPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYDWTPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYDWTPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:15:10 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:44630 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYDWTPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:15:08 -0400
Message-ID: <480F8AB9.2050805@hp.com>
Date: Wed, 23 Apr 2008 15:15:05 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [RFC][PATCH 3/3] Do not use rqhash when merges disabled
References: <480F8936.5030406@hp.com>
In-Reply-To: <480F8936.5030406@hp.com>
Content-Type: multipart/mixed;
 boundary="------------070506070209020700040001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070506070209020700040001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------070506070209020700040001
Content-Type: text/x-patch;
 name="0003-Do-not-use-rqhash-when-merges-disabled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-Do-not-use-rqhash-when-merges-disabled.patch"

>From b5da8dfdf106ceddc35634f43a02488616a55e7d Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Wed, 23 Apr 2008 08:50:22 -0400
Subject: [PATCH] Do not use rqhash when merges disabled


Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/elevator.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 88318c3..2ea5fb4 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -313,7 +313,7 @@ static inline void __elv_rqhash_del(struct request *rq)
 
 static void elv_rqhash_del(struct request_queue *q, struct request *rq)
 {
-	if (ELV_ON_HASH(rq))
+	if (!blk_queue_nomerges(q) && ELV_ON_HASH(rq))
 		__elv_rqhash_del(rq);
 }
 
@@ -601,7 +601,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		BUG_ON(!blk_fs_request(rq));
 		rq->cmd_flags |= REQ_SORTED;
 		q->nr_sorted++;
-		if (rq_mergeable(rq)) {
+		if (!blk_queue_nomerges(q) && rq_mergeable(rq)) {
 			elv_rqhash_add(q, rq);
 			if (!q->last_merge)
 				q->last_merge = rq;
-- 
1.5.2.5


--------------070506070209020700040001--
