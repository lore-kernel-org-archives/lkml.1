Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbZIHAe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbZIHAe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZIHAe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:34:27 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:39177 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbZIHAe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=GBGDVIxmErrOHDTQ2ja2ocGu6J84DzemIKx4CGjLyAkoXUE/gx5zBoqj8c1gONhYQF
         37U1n5iXRm48yBTt6WCnZ7IonPrD2Qncl0S0ijO/GdDB8/WPh/Zbbxo6aT2OlthKL1wo
         0kCSn8qqU8P9uHwTesyG2Q1SKF+V4taTeCA4c=
Date: Tue, 8 Sep 2009 09:34:16 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] trace bio queueing trial only when it occurs
Message-Id: <20090908093416.5a2f98b6.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It got lost in LKML mail storm.
I resend this.
Wu, Could you review this patch, please?

== CUT_HERE ==

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
