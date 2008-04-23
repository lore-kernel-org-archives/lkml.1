Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbYDWTO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbYDWTO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 15:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYDWTOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 15:14:21 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:5121 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYDWTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 15:14:21 -0400
Message-ID: <480F8A88.9090208@hp.com>
Date: Wed, 23 Apr 2008 15:14:16 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [RFC][PATCH 2/3] Have __make_request skip merges when disabled
References: <480F8936.5030406@hp.com>
In-Reply-To: <480F8936.5030406@hp.com>
Content-Type: multipart/mixed;
 boundary="------------060602070200000204020803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060602070200000204020803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------060602070200000204020803
Content-Type: text/x-patch;
 name="0002-Have-__make_request-skip-merges-when-disabled.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-Have-__make_request-skip-merges-when-disabled.patch"



Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 block/blk-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2a438a9..54a2d8b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1115,7 +1115,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 	spin_lock_irq(q->queue_lock);
 
-	if (unlikely(barrier) || elv_queue_empty(q))
+	if (blk_queue_nomerges(q) || unlikely(barrier) || elv_queue_empty(q))
 		goto get_rq;
 
 	el_ret = elv_merge(q, &req, bio);
-- 
1.5.2.5


--------------060602070200000204020803--
