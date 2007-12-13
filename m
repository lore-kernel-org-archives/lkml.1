Return-Path: <linux-kernel-owner+w=401wt.eu-S1763039AbXLMQTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763039AbXLMQTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762769AbXLMQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:18:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762757AbXLMQS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:18:57 -0500
Message-ID: <47615B2E.1040608@redhat.com>
Date: Thu, 13 Dec 2007 17:17:50 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, mike.miller@hp.com
Subject: [Patch 4/8] Enhanced partition statistics: cciss fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates the enhanced partition statistics in cciss driver.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 cciss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/drivers/block/cciss.c linux-2.6/drivers/block/cciss.c
--- linux-2.6.orig/drivers/block/cciss.c	2007-12-04 17:37:13.000000000 +0100
+++ linux-2.6/drivers/block/cciss.c	2007-12-05 13:46:29.000000000 +0100
@@ -1268,7 +1268,8 @@ static void cciss_softirq_done(struct re
 	if (blk_fs_request(rq)) {
 		const int rw = rq_data_dir(rq);
 
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
+		all_stat_add(rq->rq_disk, sectors[rw],
+			     rq->nr_sectors, rq->sector);
 	}
 
 #ifdef CCISS_DEBUG

