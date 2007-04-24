Return-Path: <linux-kernel-owner+w=401wt.eu-S1031058AbXDXIX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031058AbXDXIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXDXIU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24153 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbXDXIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:41 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 13/15] cfq-iosched: never allow an async queue idling
Date: Tue, 24 Apr 2007 10:15:41 +0200
Message-Id: <1177402543846-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't enable it by default, don't let it get enabled during
runtime.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8f76aed..f920527 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1597,7 +1597,12 @@ static void
 cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		       struct cfq_io_context *cic)
 {
-	int enable_idle = cfq_cfqq_idle_window(cfqq);
+	int enable_idle;
+
+	if (!cfq_cfqq_sync(cfqq))
+		return;
+
+	enable_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!cic->ioc->task || !cfqd->cfq_slice_idle ||
 	    (cfqd->hw_tag && CIC_SEEKY(cic)))
-- 
1.5.1.1.190.g74474

