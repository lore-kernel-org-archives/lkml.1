Return-Path: <linux-kernel-owner+w=401wt.eu-S1759345AbYGPUK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345AbYGPUK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 16:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbYGPUKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 16:10:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27257 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbYGPUKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 16:10:13 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] block: Trivial fix for blk_integrity_rq()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Date: Wed, 16 Jul 2008 16:09:06 -0400
Message-ID: <yq1fxq9wpzx.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fail integrity check gracefully when request does not have a bio
attached (BLOCK_PC).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

PS. Jens is out for a couple of weeks.  Hence the direct submission.


diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -985,6 +985,9 @@ static inline int bdev_integrity_enabled
 
 static inline int blk_integrity_rq(struct request *rq)
 {
+	if (rq->bio == NULL)
+		return 0;
+
 	return bio_integrity(rq->bio);
 }
 
