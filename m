Return-Path: <linux-kernel-owner+w=401wt.eu-S1031068AbXDXIZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031068AbXDXIZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbXDXIUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:22 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24156 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030942AbXDXIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:42 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 15/15] cfq-iosched: tighten queue request overlap condition
Date: Tue, 24 Apr 2007 10:15:43 +0200
Message-Id: <11774025433027-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For tagged devices, allow overlap of requests if the idle window
isn't enabled on the current active queue.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 772df89..8093733 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -983,7 +983,8 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 	 * flight or is idling for a new request, allow either of these
 	 * conditions to happen (or time out) before selecting a new queue.
 	 */
-	if (cfqq->dispatched || timer_pending(&cfqd->idle_slice_timer)) {
+	if (timer_pending(&cfqd->idle_slice_timer) ||
+	    (cfqq->dispatched && cfq_cfqq_idle_window(cfqq))) {
 		cfqq = NULL;
 		goto keep_queue;
 	}
-- 
1.5.1.1.190.g74474

