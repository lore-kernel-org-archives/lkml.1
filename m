Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZDUQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZDUQju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbZDUQiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:38:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40099 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbZDUQiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:38:12 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/14] block: cleanup REQ_SOFTBARRIER usages
Date: Wed, 22 Apr 2009 01:37:51 +0900
Message-Id: <1240331881-28218-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240331881-28218-1-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:38:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_insert_request() doesn't need to worry about REQ_SOFTBARRIER.
Don't set it.  Combined with recent ide updates, REQ_SOFTBARRIER is
now only used in elevator proper and for discard requests.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bcc85ec..c632e6d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -944,7 +944,6 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 	 * barrier
 	 */
 	rq->cmd_type = REQ_TYPE_SPECIAL;
-	rq->cmd_flags |= REQ_SOFTBARRIER;
 
 	rq->special = data;
 
-- 
1.6.0.2

