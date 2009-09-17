Return-Path: <linux-kernel-owner+w=401wt.eu-S1760120AbZIQSuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbZIQSuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbZIQSrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:47:00 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1166 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759436AbZIQSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:46:55 -0400
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/20] cciss: Handle failure of blk_init_queue gracefully in
	cciss_add_disk.
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       andrew.patterson@hp.com, mikem@beardog.cce.hp.com,
       scameron@beardog.cce.hp.com
Date: Thu, 17 Sep 2009 13:47:24 -0500
Message-ID: <20090917184724.15105.3664.stgit@beardog.cce.hp.com>
In-Reply-To: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
References: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle failure of blk_init_queue gracefully in cciss_add_disk.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 557b958..60fe3c6 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1689,6 +1689,8 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
 	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	if (!disk->queue)
+		goto init_queue_failure;
 	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
 	disk->major = h->major;
 	disk->first_minor = drv_index << NWD_SHIFT;
@@ -1729,6 +1731,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 cleanup_queue:
 	blk_cleanup_queue(disk->queue);
 	disk->queue = NULL;
+init_queue_failure:
 	return -1;
 }
 

