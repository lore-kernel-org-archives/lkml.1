Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZCPCbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZCPCbr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZCPC3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:44301 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZCPC3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:19 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/17] block: cleanup REQ_SOFTBARRIER usages
Date: Mon, 16 Mar 2009 11:28:50 +0900
Message-Id: <1237170540-19130-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

blk_insert_request() doesn't need to worry about REQ_SOFTBARRIER.
Don't set it.  Combined with recent ide updates, REQ_SOFTBARRIER is
now only used in elevator proper and for discard requests.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d7b2cc9..9e5f154 100644
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

