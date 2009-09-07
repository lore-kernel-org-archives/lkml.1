Return-Path: <linux-kernel-owner+w=401wt.eu-S1758735AbZIGCPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735AbZIGCPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 22:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbZIGCPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 22:15:51 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:56872 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbZIGCPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:15:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=CvTpT3+OFqhlRV84hJFkvTS5uR71JFQbKXk2X4Pht84TS5rszZDLV92/rzaBbLeKHJ
         Uylmhu/DcKfbf/goF4qWQoRAH5c8NTNi0acqm3Jqsa45Jg1Dwx4gjmJ/Z43oKFwjhvJG
         9RgNzWWprlUN/AC1ggyyvXLBUV2g8TMfTGTJo=
Date: Mon, 7 Sep 2009 11:15:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace bio queueing trial only when it occurs
Message-Id: <20090907111543.477595f5.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If BIO is discarded or cross over end of device,
BIO queueing trial doesn't occur.

Let's trace it only when it happens.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 block/blk-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5b59592..1a0cfd5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1463,8 +1463,6 @@ static inline void __generic_make_request(struct bio *bio)
 		if (old_sector != -1)
 			trace_block_remap(q, bio, old_dev, old_sector);

-		trace_block_bio_queue(q, bio);
-
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;

@@ -1477,6 +1475,8 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 		}

+		trace_block_bio_queue(q, bio);
+
 		ret = q->make_request_fn(q, bio);
 	} while (ret);

--
1.6.4



-- 
Kind regards,
Minchan Kim
