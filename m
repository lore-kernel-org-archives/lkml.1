Return-Path: <linux-kernel-owner+w=401wt.eu-S1763198AbXLMQUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763198AbXLMQUQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762790AbXLMQTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:19:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762780AbXLMQTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:19:00 -0500
Message-ID: <47615B32.1000001@redhat.com>
Date: Thu, 13 Dec 2007 17:17:54 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, chirag.kantharia@hp.com
Subject: [Patch 5/8] Enhanced partition statistics: cpqarray fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates the enhanced partition statistics in SMART2 driver (not tested).

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 cpqarray.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/drivers/block/cpqarray.c linux-2.6/drivers/block/cpqarray.c
--- linux-2.6.orig/drivers/block/cpqarray.c	2007-12-04 17:37:12.000000000 +0100
+++ linux-2.6/drivers/block/cpqarray.c	2007-12-05 13:48:28.000000000 +0100
@@ -1035,7 +1035,8 @@ static inline void complete_command(cmdl
 	if (blk_fs_request(rq)) {
 		const int rw = rq_data_dir(rq);
 
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
+		all_stat_add(rq->rq_disk, sectors[rw],
+			     rq->nr_sectors, rq->sector);
 	}
 
 	add_disk_randomness(rq->rq_disk);

