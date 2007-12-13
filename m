Return-Path: <linux-kernel-owner+w=401wt.eu-S1762918AbXLMQTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762918AbXLMQTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 11:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762689AbXLMQSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 11:18:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762682AbXLMQSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 11:18:47 -0500
Message-ID: <47615B29.1030108@redhat.com>
Date: Thu, 13 Dec 2007 17:17:45 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, ecashin@coraid.com
Subject: [Patch 3/8] Enhanced partition statistics: aoe fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates the enhanced partition statistics in ATA over Ethernet driver (not tested).

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 aoecmd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
diff -urNp -X linux-2.6/Documentation/dontdiff linux-2.6.orig/drivers/block/aoe/aoecmd.c linux-2.6/drivers/block/aoe/aoecmd.c
--- linux-2.6.orig/drivers/block/aoe/aoecmd.c	2007-12-04 17:37:13.000000000 +0100
+++ linux-2.6/drivers/block/aoe/aoecmd.c	2007-12-05 13:45:10.000000000 +0100
@@ -648,10 +648,10 @@ aoecmd_ata_rsp(struct sk_buff *skb)
 			struct gendisk *disk = d->gd;
 			const int rw = bio_data_dir(buf->bio);
 
-			disk_stat_inc(disk, ios[rw]);
-			disk_stat_add(disk, ticks[rw], duration);
-			disk_stat_add(disk, sectors[rw], n_sect);
-			disk_stat_add(disk, io_ticks, duration);
+			all_stat_inc(disk, ios[rw], buf->sector);
+			all_stat_add(disk, ticks[rw], duration, buf->sector);
+			all_stat_add(disk, sectors[rw], n_sect, buf->sector);
+			all_stat_add(disk, io_ticks, duration, buf->sector);
 			n = (buf->flags & BUFFL_FAIL) ? -EIO : 0;
 			bio_endio(buf->bio, n);
 			mempool_free(buf, d->bufpool);

