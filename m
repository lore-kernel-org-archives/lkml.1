Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZIRQrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZIRQrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZIRQrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:47:01 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62201 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbZIRQrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:47:00 -0400
Message-ID: <4AB3B4B8.10300@ce.jp.nec.com>
Date: Sat, 19 Sep 2009 01:26:32 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, Mike Snitzer <snitzer@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Alasdair G Kergon <agk@redhat.com>
CC: David Strand <dpstrand@gmail.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dm: Use blk_queue_copy_limits()
References: <4AB3B43D.9000802@ce.jp.nec.com>
In-Reply-To: <4AB3B43D.9000802@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new blk_queue_copy_limits() so that invalid limits
(max_sectors == 0) are fixed up appropriately when copied to the queue.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Reported-by: David Strand <dpstrand@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/md/dm-table.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31.work/drivers/md/dm-table.c
===================================================================
--- linux-2.6.31.work.orig/drivers/md/dm-table.c
+++ linux-2.6.31.work/drivers/md/dm-table.c
@@ -1090,7 +1090,7 @@ void dm_table_set_restrictions(struct dm
 	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
-	q->limits = *limits;
+	blk_queue_copy_limits(q, limits);

 	if (limits->no_cluster)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
